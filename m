Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8E249FBFF
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349401AbiA1OpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:45:13 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.222]:53241 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1349397AbiA1OpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:45:13 -0500
HMM_SOURCE_IP: 172.18.0.48:39842.1715433666
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 6B76A280029;
        Fri, 28 Jan 2022 22:45:04 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 0df3d2047b33487fa1e6ddceffca084c for j.vosburgh@gmail.com;
        Fri, 28 Jan 2022 22:45:07 CST
X-Transaction-ID: 0df3d2047b33487fa1e6ddceffca084c
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jay.vosburgh@canonical.com, nikolay@nvidia.com,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH v11] net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode
Date:   Fri, 28 Jan 2022 09:44:42 -0500
Message-Id: <20220128144442.101289-1-sunshouxin@chinatelecom.cn>
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

v10->v11:
- use pskb_network_may_pull insteading of pskb_may_pull in
alb_determine_nd
- remove __alb_determine_nd
---
 drivers/net/bonding/bond_alb.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 533e476988f2..c98a4b0a8453 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1269,6 +1269,27 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
 	return res;
 }
 
+/* determine if the packet is NA or NS */
+static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
+{
+	struct ipv6hdr *ip6hdr;
+	struct icmp6hdr *hdr;
+
+	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr)))
+		return true;
+
+	ip6hdr = ipv6_hdr(skb);
+	if (ip6hdr->nexthdr != IPPROTO_ICMPV6)
+		return false;
+
+	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr) + sizeof(*hdr)))
+		return true;
+
+	hdr = icmp6_hdr(skb);
+	return hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
+		hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION;
+}
+
 /************************ exported alb functions ************************/
 
 int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
@@ -1348,8 +1369,11 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
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
@@ -1432,10 +1456,12 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
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

base-commit: 145d9b498fc827b79c1260b4caa29a8e59d4c2b9
-- 
2.27.0

