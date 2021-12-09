Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA5846E2CF
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 07:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbhLIHCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 02:02:24 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.223]:54354 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231487AbhLIHCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 02:02:20 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2021 02:02:19 EST
HMM_SOURCE_IP: 172.18.0.218:60082.1930715747
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 40B2A280129;
        Thu,  9 Dec 2021 14:50:44 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id a02ab3115fe448229f26be0106e0d00c for j.vosburgh@gmail.com;
        Thu, 09 Dec 2021 14:50:53 CST
X-Transaction-ID: a02ab3115fe448229f26be0106e0d00c
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
Subject: [PATCH] net: bonding: Add support for IPV6 ns/na
Date:   Thu,  9 Dec 2021 14:50:22 +0800
Message-Id: <1639032622-28098-1-git-send-email-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since ipv6 neighbor solicitation and advertisement messages
isn't handled gracefully in bonding6 driver, we can see packet
drop due to inconsistency bewteen mac address in the option
message and source MAC .

Another examples is ipv6 neighbor solicitation and advertisement
messages from VM via tap attached to host brighe, the src mac
mighe be changed through balance-alb mode, but it is not synced
with Link-layer address in the option message.

The patch implements bond6's tx handle for ipv6 neighbor
solicitation and advertisement messages.

Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
 drivers/net/bonding/bond_alb.c | 127 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 2ec8e01..01566ba 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -22,6 +22,7 @@
 #include <asm/byteorder.h>
 #include <net/bonding.h>
 #include <net/bond_alb.h>
+#include <net/ndisc.h>
 
 static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned = {
 	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
@@ -1269,6 +1270,112 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
 	return res;
 }
 
+static void alb_change_nd_option(struct sk_buff *skb, void *data)
+{
+	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
+	struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
+	struct net_device *dev = skb->dev;
+	struct icmp6hdr *icmp6h = icmp6_hdr(skb);
+	struct ipv6hdr *ip6hdr = ipv6_hdr(skb);
+	u8 *lladdr = NULL;
+	u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
+				offsetof(struct nd_msg, opt));
+
+	while (ndoptlen) {
+		int l;
+
+		switch (nd_opt->nd_opt_type) {
+		case ND_OPT_SOURCE_LL_ADDR:
+		case ND_OPT_TARGET_LL_ADDR:
+		lladdr = ndisc_opt_addr_data(nd_opt, dev);
+		break;
+
+		default:
+		break;
+		}
+
+		l = nd_opt->nd_opt_len << 3;
+
+		if (ndoptlen < l || l == 0)
+			return;
+
+		if (lladdr) {
+			memcpy(lladdr, data, dev->addr_len);
+			lladdr = NULL;
+			icmp6h->icmp6_cksum = 0;
+
+			icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
+							      &ip6hdr->daddr,
+						ntohs(ip6hdr->payload_len),
+						IPPROTO_ICMPV6,
+						csum_partial(icmp6h,
+							     ntohs(ip6hdr->payload_len), 0));
+			lladdr = NULL;
+		}
+		ndoptlen -= l;
+		nd_opt = ((void *)nd_opt) + l;
+	}
+}
+
+static u8 *alb_get_lladdr(struct sk_buff *skb)
+{
+	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
+	struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
+	struct net_device *dev = skb->dev;
+	u8 *lladdr = NULL;
+	u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
+				offsetof(struct nd_msg, opt));
+
+	while (ndoptlen) {
+		int l;
+
+		switch (nd_opt->nd_opt_type) {
+		case ND_OPT_SOURCE_LL_ADDR:
+		case ND_OPT_TARGET_LL_ADDR:
+			lladdr = ndisc_opt_addr_data(nd_opt, dev);
+			break;
+
+		default:
+			break;
+		}
+
+		l = nd_opt->nd_opt_len << 3;
+
+		if (ndoptlen < l || l == 0)
+			return lladdr;
+
+		if (lladdr)
+			return lladdr;
+
+		ndoptlen -= l;
+		nd_opt = ((void *)nd_opt) + l;
+	}
+
+	return lladdr;
+}
+
+static void alb_set_nd_option(struct sk_buff *skb, struct bonding *bond,
+			      struct slave *tx_slave)
+{
+	struct ipv6hdr *ip6hdr;
+	struct icmp6hdr *hdr = NULL;
+
+	if (tx_slave && tx_slave != rcu_access_pointer(bond->curr_active_slave)) {
+		if (ntohs(skb->protocol) == ETH_P_IPV6) {
+			ip6hdr = ipv6_hdr(skb);
+			if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
+				hdr = icmp6_hdr(skb);
+				if (hdr->icmp6_type ==
+				    NDISC_NEIGHBOUR_ADVERTISEMENT ||
+				     hdr->icmp6_type ==
+				     NDISC_NEIGHBOUR_SOLICITATION) {
+					alb_change_nd_option(skb, tx_slave->dev->dev_addr);
+				}
+			}
+		}
+	}
+}
+
 /************************ exported alb functions ************************/
 
 int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
@@ -1415,6 +1522,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 	}
 	case ETH_P_IPV6: {
 		const struct ipv6hdr *ip6hdr;
+		struct icmp6hdr *hdr = NULL;
 
 		/* IPv6 doesn't really use broadcast mac address, but leave
 		 * that here just in case.
@@ -1446,6 +1554,24 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 			break;
 		}
 
+		if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
+			hdr = icmp6_hdr(skb);
+			if (hdr->icmp6_type ==
+			    NDISC_NEIGHBOUR_ADVERTISEMENT ||
+			    hdr->icmp6_type ==
+			    NDISC_NEIGHBOUR_SOLICITATION) {
+				u8 *lladdr = NULL;
+
+				lladdr = alb_get_lladdr(skb);
+				if (lladdr) {
+					if (!bond_slave_has_mac_rx(bond, lladdr)) {
+						do_tx_balance = false;
+						break;
+					}
+				}
+			}
+		}
+
 		hash_start = (char *)&ip6hdr->daddr;
 		hash_size = sizeof(ip6hdr->daddr);
 		break;
@@ -1489,6 +1615,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 	struct slave *tx_slave = NULL;
 
 	tx_slave = bond_xmit_alb_slave_get(bond, skb);
+	alb_set_nd_option(skb, bond, tx_slave);
 	return bond_do_alb_xmit(skb, bond, tx_slave);
 }
 
-- 
1.8.3.1

