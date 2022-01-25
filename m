Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2CD49AA34
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1324958AbiAYDfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:35:17 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.222]:37616 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S3415269AbiAYBAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 20:00:04 -0500
HMM_SOURCE_IP: 172.18.0.48:50016.1962489051
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id DA46C280029;
        Tue, 25 Jan 2022 08:30:13 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id ff90be4f69a445f5b32540480a51d8bc for j.vosburgh@gmail.com;
        Tue, 25 Jan 2022 08:30:16 CST
X-Transaction-ID: ff90be4f69a445f5b32540480a51d8bc
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jay.vosburgh@canonical.com, nikolay@nvidia.com,
        huyd12@chinatelecom.cn
Subject: [PATCH v8] net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode
Date:   Mon, 24 Jan 2022 19:29:54 -0500
Message-Id: <20220125002954.94405-1-sunshouxin@chinatelecom.cn>
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
 drivers/net/bonding/bond_alb.c | 37 +++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 533e476988f2..d4d8670643e9 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1269,6 +1269,34 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
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
+	ip6hdr = ipv6_hdr(skb);
+	if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
+		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr)))
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
@@ -1348,8 +1376,10 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 	/* Do not TX balance any multicast or broadcast */
 	if (!is_multicast_ether_addr(eth_data->h_dest)) {
 		switch (skb->protocol) {
-		case htons(ETH_P_IP):
 		case htons(ETH_P_IPV6):
+			if (alb_determine_nd(skb, bond))
+				break;
+		case htons(ETH_P_IP):
 			hash_index = bond_xmit_hash(bond, skb);
 			if (bond->params.tlb_dynamic_lb) {
 				tx_slave = tlb_choose_channel(bond,
@@ -1446,6 +1476,11 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 			break;
 		}
 
+		if (alb_determine_nd(skb, bond)) {
+			do_tx_balance = false;
+			break;
+		}
+
 		hash_start = (char *)&ip6hdr->daddr;
 		hash_size = sizeof(ip6hdr->daddr);
 		break;

base-commit: dd81e1c7d5fb126e5fbc5c9e334d7b3ec29a16a0
-- 
2.27.0

