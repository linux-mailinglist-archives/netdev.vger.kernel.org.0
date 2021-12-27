Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C08647FBBF
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 11:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhL0KG4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Dec 2021 05:06:56 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.222]:59074 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233302AbhL0KGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 05:06:55 -0500
HMM_SOURCE_IP: 172.18.0.218:50990.267937466
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.243 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id AB2732800B8;
        Mon, 27 Dec 2021 18:06:50 +0800 (CST)
X-189-SAVE-TO-SEND: huyd12@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 845c147ac1e64b3eb3972c3b96c0ac46 for andy@greyhouse.net;
        Mon, 27 Dec 2021 18:06:53 CST
X-Transaction-ID: 845c147ac1e64b3eb3972c3b96c0ac46
X-Real-From: huyd12@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: huyd12@chinatelecom.cn
From:   <huyd12@chinatelecom.cn>
To:     <sunshouxin@chinatelecom.cn>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20211224142512.44182-1-sunshouxin@chinatelecom.cn>
In-Reply-To: <20211224142512.44182-1-sunshouxin@chinatelecom.cn>
Subject: =?gb2312?B?u9i4tDogW1BBVENIIHY1XSBuZXQ6IGJvbmRpbmc6IEFkZCBzdXBwbw==?=
        =?gb2312?B?cnQgZm9yIElQVjYgbnMvbmEgdG8gYmFsYW5jZS1hbGIvYmFsYW5jZS10bGI=?=
        =?gb2312?B?IG1vZGU=?=
Date:   Mon, 27 Dec 2021 18:06:50 +0800
Message-ID: <002201d7fb09$796ea210$6c4be630$@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQGnB4B8szRZdyiFEwb+aw1WgpK/iqyoAwNQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

I noticed one warning info on spinics, it said the patch "Still breaks
allmodconfig build".
I wonder why I didn't get it ,but I still rebuild it with allmodconfig, no
any warning jump out.
Anyone can light shouxin a bit?

Thanks.


------
胡亚弟
 
中国电信股份有限公司云计算分公司 研发一部
Mobile: 15810133835
北京市海淀中街15号远中悦莱
Email: huyd12@chinatelecom.cn
------------------------------------------------------------------------

-----邮件原件-----
发件人: sunshouxin@chinatelecom.cn <sunshouxin@chinatelecom.cn> 
发送时间: 2021年12月24日 22:25
收件人: j.vosburgh@gmail.com; vfalico@gmail.com; andy@greyhouse.net;
davem@davemloft.net; kuba@kernel.org
抄送: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
huyd12@chinatelecom.cn
主题: [PATCH v5] net: bonding: Add support for IPV6 ns/na to
balance-alb/balance-tlb mode

Since ipv6 neighbor solicitation and advertisement messages isn't handled
gracefully in bonding6 driver, we can see packet drop due to inconsistency
bewteen mac address in the option message and source MAC .

Another examples is ipv6 neighbor solicitation and advertisement messages
from VM via tap attached to host brighe, the src mac mighe be changed
through balance-alb mode, but it is not synced with Link-layer address in
the option message.

The patch implements bond6's tx handle for ipv6 neighbor solicitation and
advertisement messages.

Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
 drivers/net/bonding/bond_alb.c | 149 +++++++++++++++++++++++++++++++++
 1 file changed, 149 insertions(+)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 533e476988f2..485e4863a365 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -22,6 +22,8 @@
 #include <asm/byteorder.h>
 #include <net/bonding.h>
 #include <net/bond_alb.h>
+#include <net/ndisc.h>
+#include <net/ip6_checksum.h>
 
 static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned = {
 	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
@@ -1269,6 +1271,137 @@ static int alb_set_mac_address(struct bonding *bond,
void *addr)
 	return res;
 }
 
+/*determine if the packet is NA or NS*/ static bool 
+__alb_determine_nd(struct icmp6hdr *hdr) {
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
+			lladdr = ndisc_opt_addr_data(nd_opt, dev);
+			break;
+
+		default:
+			lladdr = NULL;
+			break;
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
+			return;
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
+			return NULL;
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
+	struct icmp6hdr *hdr;
+
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		if (tx_slave && tx_slave !=
+		    rcu_access_pointer(bond->curr_active_slave)) {
+			ip6hdr = ipv6_hdr(skb);
+			if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
+				hdr = icmp6_hdr(skb);
+				if (__alb_determine_nd(hdr))
+					alb_change_nd_option(skb,
tx_slave->dev->dev_addr);
+			}
+		}
+	}
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
 
 int bond_alb_initialize(struct bonding *bond, int rlb_enabled) @@ -1350,6
+1483,9 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 		switch (skb->protocol) {
 		case htons(ETH_P_IP):
 		case htons(ETH_P_IPV6):
+			if (alb_determine_nd(skb, bond))
+				break;
+
 			hash_index = bond_xmit_hash(bond, skb);
 			if (bond->params.tlb_dynamic_lb) {
 				tx_slave = tlb_choose_channel(bond, @@
-1446,6 +1582,18 @@ struct slave *bond_xmit_alb_slave_get(struct bonding
*bond,
 			break;
 		}
 
+		if (alb_determine_nd(skb, bond)) {
+			u8 *lladdr;
+
+			lladdr = alb_get_lladdr(skb);
+			if (lladdr) {
+				if (!bond_slave_has_mac_rx(bond, lladdr)) {
+					do_tx_balance = false;
+					break;
+				}
+			}
+		}
+
 		hash_start = (char *)&ip6hdr->daddr;
 		hash_size = sizeof(ip6hdr->daddr);
 		break;
@@ -1489,6 +1637,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct
net_device *bond_dev)
 	struct slave *tx_slave = NULL;
 
 	tx_slave = bond_xmit_alb_slave_get(bond, skb);
+	alb_set_nd_option(skb, bond, tx_slave);
 	return bond_do_alb_xmit(skb, bond, tx_slave);  }
 

base-commit: 7a29b11da9651ef6a970e2f6bfd276f053aeb06a
--
2.27.0


