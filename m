Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA2149F122
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345482AbiA1Cjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:39:55 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.228]:43064 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S241710AbiA1Cjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:39:54 -0500
HMM_SOURCE_IP: 172.18.0.188:52266.46694565
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 4F92E280177;
        Fri, 28 Jan 2022 10:39:42 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id a9e64b333e9c4f4eb3b632d49f176d02 for j.vosburgh@gmail.com;
        Fri, 28 Jan 2022 10:39:49 CST
X-Transaction-ID: a9e64b333e9c4f4eb3b632d49f176d02
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jay.vosburgh@canonical.com, nikolay@nvidia.com,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH v10] net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode
Date:   Thu, 27 Jan 2022 21:39:16 -0500
Message-Id: <20220128023916.100071-1-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since ipv6 neighbor solicitation and advertisement messages
isn't handled gracefully in bond6 driver, we can see packet
drop due to inconsistency between mac address in the option
message and source MAC .

Another examples is ipv6 neighbor solicitation and advertisement
messages from VM via tap attached to host bridge, the src mac
might be changed through balance-alb mode, but it is not synced
with Link-layer address in the option message.

The patch implements bond6's tx handle for ipv6 neighbor
solicitation and advertisement messages.

Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
v9->v10:
- add IPv6 header pull in alb_determine_nd.
- combine bond_xmit_alb_slave_get's IPv6 header
pull with alb_determine_nd's
---
 drivers/net/bonding/bond_alb.c | 40 ++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 533e476988f2..d9da6eb7f5c2 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1269,6 +1269,37 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
 	return res;
 }
 
+/* determine if the packet is NA or NS */
+static bool __alb_determine_nd(struct icmp6hdr *hdr)
+{
+	if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
+	    hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
+		return true;
+	}
+
+	return false;
+}
+
+static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
+{
+	struct ipv6hdr *ip6hdr;
+	struct icmp6hdr *hdr;
+
+	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr)))
+		return true;
+
+	ip6hdr = ipv6_hdr(skb);
+	if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
+		if (!pskb_may_pull(skb, sizeof(*ip6hdr) + sizeof(*hdr)))
+			return true;
+
+		hdr = icmp6_hdr(skb);
+		return __alb_determine_nd(hdr);
+	}
+
+	return false;
+}
+
 /************************ exported alb functions ************************/
 
 int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
@@ -1348,8 +1379,11 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 	/* Do not TX balance any multicast or broadcast */
 	if (!is_multicast_ether_addr(eth_data->h_dest)) {
 		switch (skb->protocol) {
-		case htons(ETH_P_IP):
 		case htons(ETH_P_IPV6):
+			if (alb_determine_nd(skb, bond))
+				break;
+			fallthrough;
+		case htons(ETH_P_IP):
 			hash_index = bond_xmit_hash(bond, skb);
 			if (bond->params.tlb_dynamic_lb) {
 				tx_slave = tlb_choose_channel(bond,
@@ -1432,10 +1466,12 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 			break;
 		}
 
-		if (!pskb_network_may_pull(skb, sizeof(*ip6hdr))) {
+		if (alb_determine_nd(skb, bond)) {
 			do_tx_balance = false;
 			break;
 		}
+
+		/* The IPv6 header is pulled by alb_determine_nd */
 		/* Additionally, DAD probes should not be tx-balanced as that
 		 * will lead to false positives for duplicate addresses and
 		 * prevent address configuration from working.

base-commit: dd81e1c7d5fb126e5fbc5c9e334d7b3ec29a16a0
-- 
2.27.0

