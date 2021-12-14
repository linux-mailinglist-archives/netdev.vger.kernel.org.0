Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1E5473A10
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241897AbhLNBMG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Dec 2021 20:12:06 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.228]:51820 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232173AbhLNBMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 20:12:06 -0500
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2021 20:12:05 EST
HMM_SOURCE_IP: 172.18.0.218:52692.1369407998
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.243 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 5D0152801F6;
        Tue, 14 Dec 2021 09:02:01 +0800 (CST)
X-189-SAVE-TO-SEND: huyd12@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id ac4134ae3a50440fb17d76801f4299c3 for andy@greyhouse.net;
        Tue, 14 Dec 2021 09:02:07 CST
X-Transaction-ID: ac4134ae3a50440fb17d76801f4299c3
X-Real-From: huyd12@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: huyd12@chinatelecom.cn
From:   <huyd12@chinatelecom.cn>
To:     <sunshouxin@chinatelecom.cn>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1639141691-3741-1-git-send-email-sunshouxin@chinatelecom.cn>
In-Reply-To: <1639141691-3741-1-git-send-email-sunshouxin@chinatelecom.cn>
Subject: =?gb2312?B?u9i4tDogW1BBVENIIFYyXSBuZXQ6IGJvbmRpbmc6IEFkZCBzdXBwbw==?=
        =?gb2312?B?cnQgZm9yIElQVjYgbnMvbmE=?=
Date:   Tue, 14 Dec 2021 09:02:05 +0800
Message-ID: <009101d7f086$3a3e14f0$aeba3ed0$@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGXPJv4Ko2ilKi7zNVqkCkMP8Cvk6yykukQ
Content-Language: zh-cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi£¬all

Any comments will be appreciated.
thanks a lot.

Yadi


Ö÷Ìâ: [PATCH V2] net: bonding: Add support for IPV6 ns/na

Since ipv6 neighbor solicitation and advertisement messages isn't handled
gracefully in bonding6 driver, we can see packet drop due to inconsistency
bewteen mac address in the option message and source MAC .

Another examples is ipv6 neighbor solicitation and advertisement messages
from VM via tap attached to host brighe, the src mac mighe be changed
through balance-alb mode, but it is not synced with Link-layer address in
the option message.

The patch implements bond6's tx handle for ipv6 neighbor solicitation and
advertisement messages.

			Border-Leaf
			/        \
		       /          \
		    Tunnel1    Tunnel2
		     /              \
	            /                \
		  Leaf-1--Tunnel3--Leaf-2
		    \                /
		     \              /
		      \            /
		       \          /
		       NIC1    NIC2
			\      /
			server

We can see in our lab the Border-Leaf receives occasionally a NA packet
which is assigned to NIC1 mac in ND/NS option message, but actaully send out
via NIC2 mac due to tx-alb, as a result, it will cause inconsistency between
MAC table and ND Table in Border-Leaf, i.e, NIC1 = Tunnel2 in ND table and
NIC1 = Tunnel1 in mac table.

And then, Border-Leaf starts to forward packet destinated to the Server, it
will only check the ND table entry in some switch to encapsulate the
destination MAC of the message as
NIC1 MAC, and then send it out from Tunnel2 by ND table.
Then, Leaf-2 receives the packet, it notices the destination MAC of message
is NIC1 MAC and should forword it to Tunne1 by Tunnel3.

However, this traffic forward will be failure due to split horizon of VxLAN
tunnels.

Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
 drivers/net/bonding/bond_alb.c | 131
+++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 533e476..afa386b 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -22,6 +22,7 @@
 #include <asm/byteorder.h>
 #include <net/bonding.h>
 #include <net/bond_alb.h>
+#include <net/ndisc.h>
 
 static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned = {
 	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
@@ -1269,6 +1270,119 @@ static int alb_set_mac_address(struct bonding *bond,
void *addr)
 	return res;
 }
 
+/*determine if the packet is NA or NS*/ static bool 
+alb_determine_nd(struct icmp6hdr *hdr) {
+	if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
+	    hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
+		return true;
+	}
+
+	return false;
+}
+
+static void alb_change_nd_option(struct sk_buff *skb, void *data) {
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
+		lladdr = NULL;
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
+			icmp6h->icmp6_cksum = 0;
+
+			icmp6h->icmp6_cksum =
csum_ipv6_magic(&ip6hdr->saddr,
+							
&ip6hdr->daddr,
+						ntohs(ip6hdr->payload_len),
+						IPPROTO_ICMPV6,
+						csum_partial(icmp6h,
+							
ntohs(ip6hdr->payload_len), 0));
+		}
+		ndoptlen -= l;
+		nd_opt = ((void *)nd_opt) + l;
+	}
+}
+
+static u8 *alb_get_lladdr(struct sk_buff *skb) {
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
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		if (tx_slave && tx_slave !=
+		    rcu_access_pointer(bond->curr_active_slave)) {
+			ip6hdr = ipv6_hdr(skb);
+			if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
+				hdr = icmp6_hdr(skb);
+				if (alb_determine_nd(hdr))
+					alb_change_nd_option(skb,
tx_slave->dev->dev_addr);
+			}
+		}
+	}
+}
+
 /************************ exported alb functions ************************/
 
 int bond_alb_initialize(struct bonding *bond, int rlb_enabled) @@ -1415,6
+1529,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 	}
 	case ETH_P_IPV6: {
 		const struct ipv6hdr *ip6hdr;
+		struct icmp6hdr *hdr = NULL;
 
 		/* IPv6 doesn't really use broadcast mac address, but leave
 		 * that here just in case.
@@ -1446,6 +1561,21 @@ struct slave *bond_xmit_alb_slave_get(struct bonding
*bond,
 			break;
 		}
 
+		if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
+			hdr = icmp6_hdr(skb);
+			if (alb_determine_nd(hdr)) {
+				u8 *lladdr = NULL;
+
+				lladdr = alb_get_lladdr(skb);
+				if (lladdr) {
+					if (!bond_slave_has_mac_rx(bond,
lladdr)) {
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
@@ -1489,6 +1619,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct
net_device *bond_dev)
 	struct slave *tx_slave = NULL;
 
 	tx_slave = bond_xmit_alb_slave_get(bond, skb);
+	alb_set_nd_option(skb, bond, tx_slave);
 	return bond_do_alb_xmit(skb, bond, tx_slave);  }
 
--
1.8.3.1


