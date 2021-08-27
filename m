Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065BC3F957B
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 09:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244515AbhH0HvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 03:51:15 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41168 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244511AbhH0HvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 03:51:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5B7A320582;
        Fri, 27 Aug 2021 09:50:24 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6Yy7BLZqyKzT; Fri, 27 Aug 2021 09:50:20 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 91F91205B2;
        Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 83E2C80004A;
        Fri, 27 Aug 2021 09:50:18 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 09:50:18 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 27 Aug
 2021 09:50:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AD0843180445; Fri, 27 Aug 2021 09:50:17 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/3] xfrm: Add possibility to set the default to block if we have no policy
Date:   Fri, 27 Aug 2021 09:50:14 +0200
Message-ID: <20210827075015.2584560-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827075015.2584560-1-steffen.klassert@secunet.com>
References: <20210827075015.2584560-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the default we assume the traffic to pass, if we have no
matching IPsec policy. With this patch, we have a possibility to
change this default from allow to block. It can be configured
via netlink. Each direction (input/output/forward) can be
configured separately. With the default to block configuered,
we need allow policies for all packet flows we accept.
We do not use default policy lookup for the loopback device.

v1->v2
 - fix compiling when XFRM is disabled
 - Reported-by: kernel test robot <lkp@intel.com>

Co-developed-by: Christian Langrock <christian.langrock@secunet.com>
Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
Co-developed-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/netns/xfrm.h  |  7 ++++++
 include/net/xfrm.h        | 36 ++++++++++++++++++++++-----
 include/uapi/linux/xfrm.h | 10 ++++++++
 net/xfrm/xfrm_policy.c    | 16 ++++++++++++
 net/xfrm/xfrm_user.c      | 52 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 115 insertions(+), 6 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index e946366e8ba5..88c647302977 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -65,6 +65,13 @@ struct netns_xfrm {
 	u32			sysctl_aevent_rseqth;
 	int			sysctl_larval_drop;
 	u32			sysctl_acq_expires;
+
+	u8			policy_default;
+#define XFRM_POL_DEFAULT_IN	1
+#define XFRM_POL_DEFAULT_OUT	2
+#define XFRM_POL_DEFAULT_FWD	4
+#define XFRM_POL_DEFAULT_MASK	7
+
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_hdr;
 #endif
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index cbff7c2a9724..2308210793a0 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1075,6 +1075,22 @@ xfrm_state_addr_cmp(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x, un
 }
 
 #ifdef CONFIG_XFRM
+static inline bool
+xfrm_default_allow(struct net *net, int dir)
+{
+	u8 def = net->xfrm.policy_default;
+
+	switch (dir) {
+	case XFRM_POLICY_IN:
+		return def & XFRM_POL_DEFAULT_IN ? false : true;
+	case XFRM_POLICY_OUT:
+		return def & XFRM_POL_DEFAULT_OUT ? false : true;
+	case XFRM_POLICY_FWD:
+		return def & XFRM_POL_DEFAULT_FWD ? false : true;
+	}
+	return false;
+}
+
 int __xfrm_policy_check(struct sock *, int dir, struct sk_buff *skb,
 			unsigned short family);
 
@@ -1088,9 +1104,13 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 	if (sk && sk->sk_policy[XFRM_POLICY_IN])
 		return __xfrm_policy_check(sk, ndir, skb, family);
 
-	return	(!net->xfrm.policy_count[dir] && !secpath_exists(skb)) ||
-		(skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
-		__xfrm_policy_check(sk, ndir, skb, family);
+	if (xfrm_default_allow(net, dir))
+		return (!net->xfrm.policy_count[dir] && !secpath_exists(skb)) ||
+		       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
+		       __xfrm_policy_check(sk, ndir, skb, family);
+	else
+		return (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
+		       __xfrm_policy_check(sk, ndir, skb, family);
 }
 
 static inline int xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb, unsigned short family)
@@ -1142,9 +1162,13 @@ static inline int xfrm_route_forward(struct sk_buff *skb, unsigned short family)
 {
 	struct net *net = dev_net(skb->dev);
 
-	return	!net->xfrm.policy_count[XFRM_POLICY_OUT] ||
-		(skb_dst(skb)->flags & DST_NOXFRM) ||
-		__xfrm_route_forward(skb, family);
+	if (xfrm_default_allow(net, XFRM_POLICY_FWD))
+		return !net->xfrm.policy_count[XFRM_POLICY_OUT] ||
+			(skb_dst(skb)->flags & DST_NOXFRM) ||
+			__xfrm_route_forward(skb, family);
+	else
+		return (skb_dst(skb)->flags & DST_NOXFRM) ||
+			__xfrm_route_forward(skb, family);
 }
 
 static inline int xfrm4_route_forward(struct sk_buff *skb)
diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index ffc6a5391bb7..6e8095106192 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -213,6 +213,11 @@ enum {
 	XFRM_MSG_GETSPDINFO,
 #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
 
+	XFRM_MSG_SETDEFAULT,
+#define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
+	XFRM_MSG_GETDEFAULT,
+#define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
+
 	XFRM_MSG_MAPPING,
 #define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
 	__XFRM_MSG_MAX
@@ -508,6 +513,11 @@ struct xfrm_user_offload {
 #define XFRM_OFFLOAD_IPV6	1
 #define XFRM_OFFLOAD_INBOUND	2
 
+struct xfrm_userpolicy_default {
+	__u8				dirmask;
+	__u8				action;
+};
+
 #ifndef __KERNEL__
 /* backwards compatibility for userspace */
 #define XFRMGRP_ACQUIRE		1
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 827d84255021..d5cb082e11fc 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3165,6 +3165,11 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 	return dst;
 
 nopol:
+	if (!(dst_orig->dev->flags & IFF_LOOPBACK) &&
+	    !xfrm_default_allow(net, dir)) {
+		err = -EPERM;
+		goto error;
+	}
 	if (!(flags & XFRM_LOOKUP_ICMP)) {
 		dst = dst_orig;
 		goto ok;
@@ -3553,6 +3558,11 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	}
 
 	if (!pol) {
+		if (!xfrm_default_allow(net, dir)) {
+			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOPOLS);
+			return 0;
+		}
+
 		if (sp && secpath_has_nontransport(sp, 0, &xerr_idx)) {
 			xfrm_secpath_reject(xerr_idx, skb, &fl);
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOPOLS);
@@ -3607,6 +3617,12 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 				tpp[ti++] = &pols[pi]->xfrm_vec[i];
 		}
 		xfrm_nr = ti;
+
+		if (!xfrm_default_allow(net, dir) && !xfrm_nr) {
+			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOSTATES);
+			goto reject;
+		}
+
 		if (npols > 1) {
 			xfrm_tmpl_sort(stp, tpp, xfrm_nr, family);
 			tpp = stp;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b47d613409b7..4eafd1130c3e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1961,6 +1961,54 @@ static struct sk_buff *xfrm_policy_netlink(struct sk_buff *in_skb,
 	return skb;
 }
 
+static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
+			    struct nlattr **attrs)
+{
+	struct net *net = sock_net(skb->sk);
+	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
+	u8 dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK;
+	u8 old_default = net->xfrm.policy_default;
+
+	net->xfrm.policy_default = (old_default & (0xff ^ dirmask))
+				    | (up->action << up->dirmask);
+
+	rt_genid_bump_all(net);
+
+	return 0;
+}
+
+static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
+			    struct nlattr **attrs)
+{
+	struct sk_buff *r_skb;
+	struct nlmsghdr *r_nlh;
+	struct net *net = sock_net(skb->sk);
+	struct xfrm_userpolicy_default *r_up, *up;
+	int len = NLMSG_ALIGN(sizeof(struct xfrm_userpolicy_default));
+	u32 portid = NETLINK_CB(skb).portid;
+	u32 seq = nlh->nlmsg_seq;
+
+	up = nlmsg_data(nlh);
+
+	r_skb = nlmsg_new(len, GFP_ATOMIC);
+	if (!r_skb)
+		return -ENOMEM;
+
+	r_nlh = nlmsg_put(r_skb, portid, seq, XFRM_MSG_GETDEFAULT, sizeof(*r_up), 0);
+	if (!r_nlh) {
+		kfree_skb(r_skb);
+		return -EMSGSIZE;
+	}
+
+	r_up = nlmsg_data(r_nlh);
+
+	r_up->action = ((net->xfrm.policy_default & (1 << up->dirmask)) >> up->dirmask);
+	r_up->dirmask = up->dirmask;
+	nlmsg_end(r_skb, r_nlh);
+
+	return nlmsg_unicast(net->xfrm.nlsk, r_skb, portid);
+}
+
 static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct nlattr **attrs)
 {
@@ -2664,6 +2712,8 @@ const int xfrm_msg_min[XFRM_NR_MSGTYPES] = {
 	[XFRM_MSG_GETSADINFO  - XFRM_MSG_BASE] = sizeof(u32),
 	[XFRM_MSG_NEWSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
 	[XFRM_MSG_GETSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
+	[XFRM_MSG_SETDEFAULT  - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_default),
+	[XFRM_MSG_GETDEFAULT  - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_default),
 };
 EXPORT_SYMBOL_GPL(xfrm_msg_min);
 
@@ -2743,6 +2793,8 @@ static const struct xfrm_link {
 						   .nla_pol = xfrma_spd_policy,
 						   .nla_max = XFRMA_SPD_MAX },
 	[XFRM_MSG_GETSPDINFO  - XFRM_MSG_BASE] = { .doit = xfrm_get_spdinfo   },
+	[XFRM_MSG_SETDEFAULT  - XFRM_MSG_BASE] = { .doit = xfrm_set_default   },
+	[XFRM_MSG_GETDEFAULT  - XFRM_MSG_BASE] = { .doit = xfrm_get_default   },
 };
 
 static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.25.1

