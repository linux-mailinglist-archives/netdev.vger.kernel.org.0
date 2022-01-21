Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F87E495BD4
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 09:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379541AbiAUIXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 03:23:21 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.223]:38782 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231208AbiAUIXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 03:23:20 -0500
HMM_SOURCE_IP: 172.18.0.188:48432.1615665580
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 6D91F280114;
        Fri, 21 Jan 2022 16:23:07 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id d7c3bb7e8efa438aa87da2bffbb667ed for j.vosburgh@gmail.com;
        Fri, 21 Jan 2022 16:23:11 CST
X-Transaction-ID: d7c3bb7e8efa438aa87da2bffbb667ed
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jay.vosburgh@canonical.com, huyd12@chinatelecom.cn
Subject: [PATCH v7] net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode
Date:   Fri, 21 Jan 2022 03:22:43 -0500
Message-Id: <20220121082243.88155-1-sunshouxin@chinatelecom.cn>
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
 drivers/net/bonding/bond_alb.c | 36 ++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 533e476988f2..82b7071840b1 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1269,6 +1269,34 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
 	return res;
 }
 
+/*determine if the packet is NA or NS*/
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
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		ip6hdr = ipv6_hdr(skb);
+		if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
+			hdr = icmp6_hdr(skb);
+			if (__alb_determine_nd(hdr))
+				return true;
+		}
+	}
+
+	return false;
+}
+
 /************************ exported alb functions ************************/
 
 int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
@@ -1350,6 +1378,9 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 		switch (skb->protocol) {
 		case htons(ETH_P_IP):
 		case htons(ETH_P_IPV6):
+			if (alb_determine_nd(skb, bond))
+				break;
+
 			hash_index = bond_xmit_hash(bond, skb);
 			if (bond->params.tlb_dynamic_lb) {
 				tx_slave = tlb_choose_channel(bond,
@@ -1446,6 +1477,11 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
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

base-commit: 79e06c4c4950be2abd8ca5d2428a8c915aa62c24
-- 
2.27.0

