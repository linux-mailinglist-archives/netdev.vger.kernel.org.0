Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C694D588B
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345836AbiCKDBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243959AbiCKDA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:00:59 -0500
X-Greylist: delayed 550 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Mar 2022 18:59:56 PST
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C47B9398F;
        Thu, 10 Mar 2022 18:59:56 -0800 (PST)
HMM_SOURCE_IP: 172.18.0.218:37692.1206753115
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 0687D280128;
        Fri, 11 Mar 2022 10:50:52 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id e12254a66a0d46dabb1c2f778c4d84bf for j.vosburgh@gmail.com;
        Fri, 11 Mar 2022 10:50:57 CST
X-Transaction-ID: e12254a66a0d46dabb1c2f778c4d84bf
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH 1/3] net:ipv6:Add ndisc_bond_send_na to support sending na by slave directly
Date:   Thu, 10 Mar 2022 21:49:56 -0500
Message-Id: <20220311024958.7458-2-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220311024958.7458-1-sunshouxin@chinatelecom.cn>
References: <20220311024958.7458-1-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ndisc_bond_send_na to support sending na by slave directly and
export it for bonding usage.

Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
 include/net/ndisc.h |  6 +++++
 net/ipv6/ndisc.c    | 61 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index da7eec8669ec..317bcb29c795 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -471,6 +471,12 @@ void ndisc_update(const struct net_device *dev, struct neighbour *neigh,
 		  const u8 *lladdr, u8 new, u32 flags, u8 icmp6_type,
 		  struct ndisc_options *ndopts);
 
+void ndisc_bond_send_na(struct net_device *dev, const struct in6_addr *daddr,
+			const struct in6_addr *solicited_addr, bool router,
+			bool solicited, bool override, bool inc_opt,
+			unsigned short vlan_id, const void *mac_dst,
+			const void *mac_src);
+
 /*
  *	IGMP
  */
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index fcb288b0ae13..c59a110e9b10 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -572,6 +572,67 @@ void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 	ndisc_send_skb(skb, daddr, src_addr);
 }
 
+void ndisc_bond_send_na(struct net_device *dev, const struct in6_addr *daddr,
+			const struct in6_addr *solicited_addr,
+			bool router, bool solicited, bool override,
+			bool inc_opt, unsigned short vlan_id,
+			const void *mac_dst, const void *mac_src)
+{
+	struct sk_buff *skb;
+	const struct in6_addr *src_addr;
+	struct nd_msg *msg;
+	struct net *net = dev_net(dev);
+	struct sock *sk = net->ipv6.ndisc_sk;
+	int optlen = 0;
+	int ret;
+
+	src_addr = solicited_addr;
+	if (!dev->addr_len)
+		inc_opt = false;
+	if (inc_opt)
+		optlen += ndisc_opt_addr_space(dev,
+					       NDISC_NEIGHBOUR_ADVERTISEMENT);
+
+	skb = ndisc_alloc_skb(dev, sizeof(*msg) + optlen);
+	if (!skb)
+		return;
+
+	msg = skb_put(skb, sizeof(*msg));
+	*msg = (struct nd_msg) {
+		.icmph = {
+			.icmp6_type = NDISC_NEIGHBOUR_ADVERTISEMENT,
+			.icmp6_router = router,
+			.icmp6_solicited = solicited,
+			.icmp6_override = override,
+		},
+		.target = *solicited_addr,
+	};
+
+	if (inc_opt)
+		ndisc_fill_addr_option(skb, ND_OPT_TARGET_LL_ADDR,
+				       dev->dev_addr,
+				       NDISC_NEIGHBOUR_ADVERTISEMENT);
+
+	if (vlan_id)
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+				       vlan_id);
+
+	msg->icmph.icmp6_cksum = csum_ipv6_magic(src_addr, daddr, skb->len,
+						 IPPROTO_ICMPV6,
+						 csum_partial(&msg->icmph,
+							      skb->len, 0));
+
+	ip6_nd_hdr(skb, src_addr, daddr, inet6_sk(sk)->hop_limit, skb->len);
+
+	skb->protocol = htons(ETH_P_IPV6);
+	skb->dev = dev;
+	if (dev_hard_header(skb, dev, ETH_P_IPV6, mac_dst, mac_src, skb->len) < 0)
+		return;
+
+	ret = dev_queue_xmit(skb);
+}
+EXPORT_SYMBOL(ndisc_bond_send_na);
+
 static void ndisc_send_unsol_na(struct net_device *dev)
 {
 	struct inet6_dev *idev;
-- 
2.27.0

