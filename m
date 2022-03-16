Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFF94DACE2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348334AbiCPIxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiCPIxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:53:02 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D010F64BF4;
        Wed, 16 Mar 2022 01:51:48 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:37546.597671551
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.39 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 18EFC2800ED;
        Wed, 16 Mar 2022 16:51:42 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id aad3f8a1d9eb46ce9f50b380442d6553 for j.vosburgh@gmail.com;
        Wed, 16 Mar 2022 16:51:47 CST
X-Transaction-ID: aad3f8a1d9eb46ce9f50b380442d6553
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH v3 1/4] net:ipv6:Refactor ndisc_send_na to support sending na by slave directly
Date:   Wed, 16 Mar 2022 04:49:55 -0400
Message-Id: <20220316084958.21169-2-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220316084958.21169-1-sunshouxin@chinatelecom.cn>
References: <20220316084958.21169-1-sunshouxin@chinatelecom.cn>
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

Refactor ndisc_send_na to support sending na by slave directly.

Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
---
changelog:
v1-->v2: remove ndisc_bond_send_na and refactor ndisc_send_na
v2-->v3: don't export ndisc_send_na
---
 include/net/ipv6_stubs.h |  3 +-
 include/net/ndisc.h      |  9 +++++-
 net/ipv6/ndisc.c         | 64 +++++++++++++++++++++++++++++-----------
 3 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 45e0339be6fa..2b64ea6590b6 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -56,7 +56,8 @@ struct ipv6_stub {
 	void (*udpv6_encap_enable)(void);
 	void (*ndisc_send_na)(struct net_device *dev, const struct in6_addr *daddr,
 			      const struct in6_addr *solicited_addr,
-			      bool router, bool solicited, bool override, bool inc_opt);
+			      bool router, bool solicited, bool override,
+			      bool inc_opt, void *data);
 #if IS_ENABLED(CONFIG_XFRM)
 	void (*xfrm6_local_rxpmtu)(struct sk_buff *skb, u32 mtu);
 	int (*xfrm6_udp_encap_rcv)(struct sock *sk, struct sk_buff *skb);
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index da7eec8669ec..e71702a44a3d 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -107,6 +107,12 @@ struct nd_opt_hdr {
 	__u8		nd_opt_len;
 } __packed;
 
+struct nd_sendinfo {
+	__u16 vlanid;
+	void *mac_dst;
+	const void *mac_src;
+};
+
 /* ND options */
 struct ndisc_options {
 	struct nd_opt_hdr *nd_opt_array[__ND_OPT_ARRAY_MAX];
@@ -460,7 +466,8 @@ void ndisc_send_rs(struct net_device *dev,
 		   const struct in6_addr *saddr, const struct in6_addr *daddr);
 void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 		   const struct in6_addr *solicited_addr,
-		   bool router, bool solicited, bool override, bool inc_opt);
+		   bool router, bool solicited, bool override, bool inc_opt,
+		   void *data);
 
 void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target);
 
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index fcb288b0ae13..47875aab86e5 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -518,29 +518,37 @@ EXPORT_SYMBOL(ndisc_send_skb);
 
 void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 		   const struct in6_addr *solicited_addr,
-		   bool router, bool solicited, bool override, bool inc_opt)
+		   bool router, bool solicited, bool override, bool inc_opt,
+		   void *data)
 {
 	struct sk_buff *skb;
 	struct in6_addr tmpaddr;
 	struct inet6_ifaddr *ifp;
 	const struct in6_addr *src_addr;
 	struct nd_msg *msg;
+	struct nd_sendinfo *sendinfo = data;
+	struct net *net = dev_net(dev);
+	struct sock *sk = net->ipv6.ndisc_sk;
 	int optlen = 0;
 
-	/* for anycast or proxy, solicited_addr != src_addr */
-	ifp = ipv6_get_ifaddr(dev_net(dev), solicited_addr, dev, 1);
-	if (ifp) {
-		src_addr = solicited_addr;
-		if (ifp->flags & IFA_F_OPTIMISTIC)
-			override = false;
-		inc_opt |= ifp->idev->cnf.force_tllao;
-		in6_ifa_put(ifp);
+	if (!sendinfo) {
+		/* for anycast or proxy, solicited_addr != src_addr */
+		ifp = ipv6_get_ifaddr(dev_net(dev), solicited_addr, dev, 1);
+		if (ifp) {
+			src_addr = solicited_addr;
+			if (ifp->flags & IFA_F_OPTIMISTIC)
+				override = false;
+			inc_opt |= ifp->idev->cnf.force_tllao;
+			in6_ifa_put(ifp);
+		} else {
+			if (ipv6_dev_get_saddr(dev_net(dev), dev, daddr,
+					       inet6_sk(dev_net(dev)->ipv6.ndisc_sk)->srcprefs,
+					       &tmpaddr))
+				return;
+			src_addr = &tmpaddr;
+		}
 	} else {
-		if (ipv6_dev_get_saddr(dev_net(dev), dev, daddr,
-				       inet6_sk(dev_net(dev)->ipv6.ndisc_sk)->srcprefs,
-				       &tmpaddr))
-			return;
-		src_addr = &tmpaddr;
+		src_addr = solicited_addr;
 	}
 
 	if (!dev->addr_len)
@@ -568,8 +576,28 @@ void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 		ndisc_fill_addr_option(skb, ND_OPT_TARGET_LL_ADDR,
 				       dev->dev_addr,
 				       NDISC_NEIGHBOUR_ADVERTISEMENT);
+	if (!sendinfo) {
+		ndisc_send_skb(skb, daddr, src_addr);
+	} else {
+		if (sendinfo->vlanid)
+			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+					       sendinfo->vlanid);
+
+		msg->icmph.icmp6_cksum = csum_ipv6_magic(src_addr, daddr, skb->len,
+							 IPPROTO_ICMPV6,
+							 csum_partial(&msg->icmph,
+								      skb->len, 0));
 
-	ndisc_send_skb(skb, daddr, src_addr);
+		ip6_nd_hdr(skb, src_addr, daddr, inet6_sk(sk)->hop_limit, skb->len);
+
+		skb->protocol = htons(ETH_P_IPV6);
+		skb->dev = dev;
+		if (dev_hard_header(skb, dev, ETH_P_IPV6, sendinfo->mac_dst,
+				    sendinfo->mac_src, skb->len) < 0)
+			return;
+
+		dev_queue_xmit(skb);
+	}
 }
 
 static void ndisc_send_unsol_na(struct net_device *dev)
@@ -591,7 +619,7 @@ static void ndisc_send_unsol_na(struct net_device *dev)
 		ndisc_send_na(dev, &in6addr_linklocal_allnodes, &ifa->addr,
 			      /*router=*/ !!idev->cnf.forwarding,
 			      /*solicited=*/ false, /*override=*/ true,
-			      /*inc_opt=*/ true);
+			      /*inc_opt=*/ true, NULL);
 	}
 	read_unlock_bh(&idev->lock);
 
@@ -932,7 +960,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 
 	if (dad) {
 		ndisc_send_na(dev, &in6addr_linklocal_allnodes, &msg->target,
-			      !!is_router, false, (ifp != NULL), true);
+			      !!is_router, false, ifp, true, NULL);
 		goto out;
 	}
 
@@ -954,7 +982,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 			     NDISC_NEIGHBOUR_SOLICITATION, &ndopts);
 	if (neigh || !dev->header_ops) {
 		ndisc_send_na(dev, saddr, &msg->target, !!is_router,
-			      true, (ifp != NULL && inc), inc);
+			      true, (ifp && inc), inc, NULL);
 		if (neigh)
 			neigh_release(neigh);
 	}
-- 
2.27.0

