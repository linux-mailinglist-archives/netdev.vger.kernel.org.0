Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0974D8031
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiCNKsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiCNKsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:48:53 -0400
X-Greylist: delayed 557 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Mar 2022 03:47:43 PDT
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BE472E68D
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:47:43 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id CC96C600AB;
        Mon, 14 Mar 2022 11:38:24 +0100 (CET)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1nTi5o-0008Ft-Mx; Mon, 14 Mar 2022 11:38:24 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        antony.antony@secunet.com
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec-next v2] xfrm: rework default policy structure
Date:   Mon, 14 Mar 2022 11:38:22 +0100
Message-Id: <20220314103822.31720-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <YZpSlpVuE9G+Ebh4@unreal>
References: <YZpSlpVuE9G+Ebh4@unreal>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up of commit f8d858e607b2 ("xfrm: make user policy API
complete"). The goal is to align userland API to the internal structures.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

v1 -> v2: introduce __xfrm_check_nopolicy()

 include/net/netns/xfrm.h |  6 +----
 include/net/xfrm.h       | 48 +++++++++++++++-------------------------
 net/xfrm/xfrm_policy.c   | 10 ++++++---
 net/xfrm/xfrm_user.c     | 43 +++++++++++++++--------------------
 4 files changed, 44 insertions(+), 63 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index 947733a639a6..bd7c3be4af5d 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -66,11 +66,7 @@ struct netns_xfrm {
 	int			sysctl_larval_drop;
 	u32			sysctl_acq_expires;
 
-	u8			policy_default;
-#define XFRM_POL_DEFAULT_IN	1
-#define XFRM_POL_DEFAULT_OUT	2
-#define XFRM_POL_DEFAULT_FWD	4
-#define XFRM_POL_DEFAULT_MASK	7
+	u8			policy_default[XFRM_POLICY_MAX];
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_hdr;
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index fdb41e8bb626..1541ca0cb13c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1081,25 +1081,18 @@ xfrm_state_addr_cmp(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x, un
 }
 
 #ifdef CONFIG_XFRM
-static inline bool
-xfrm_default_allow(struct net *net, int dir)
-{
-	u8 def = net->xfrm.policy_default;
-
-	switch (dir) {
-	case XFRM_POLICY_IN:
-		return def & XFRM_POL_DEFAULT_IN ? false : true;
-	case XFRM_POLICY_OUT:
-		return def & XFRM_POL_DEFAULT_OUT ? false : true;
-	case XFRM_POLICY_FWD:
-		return def & XFRM_POL_DEFAULT_FWD ? false : true;
-	}
-	return false;
-}
-
 int __xfrm_policy_check(struct sock *, int dir, struct sk_buff *skb,
 			unsigned short family);
 
+static inline bool __xfrm_check_nopolicy(struct net *net, struct sk_buff *skb,
+					 int dir)
+{
+	if (!net->xfrm.policy_count[dir] && !secpath_exists(skb))
+		return net->xfrm.policy_default[dir] == XFRM_USERPOLICY_ACCEPT;
+
+	return false;
+}
+
 static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 				       struct sk_buff *skb,
 				       unsigned int family, int reverse)
@@ -1110,13 +1103,9 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
 	if (sk && sk->sk_policy[XFRM_POLICY_IN])
 		return __xfrm_policy_check(sk, ndir, skb, family);
 
-	if (xfrm_default_allow(net, dir))
-		return (!net->xfrm.policy_count[dir] && !secpath_exists(skb)) ||
-		       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
-		       __xfrm_policy_check(sk, ndir, skb, family);
-	else
-		return (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
-		       __xfrm_policy_check(sk, ndir, skb, family);
+	return __xfrm_check_nopolicy(net, skb, dir) ||
+	       (skb_dst(skb) && (skb_dst(skb)->flags & DST_NOPOLICY)) ||
+	       __xfrm_policy_check(sk, ndir, skb, family);
 }
 
 static inline int xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb, unsigned short family)
@@ -1168,13 +1157,12 @@ static inline int xfrm_route_forward(struct sk_buff *skb, unsigned short family)
 {
 	struct net *net = dev_net(skb->dev);
 
-	if (xfrm_default_allow(net, XFRM_POLICY_OUT))
-		return !net->xfrm.policy_count[XFRM_POLICY_OUT] ||
-			(skb_dst(skb)->flags & DST_NOXFRM) ||
-			__xfrm_route_forward(skb, family);
-	else
-		return (skb_dst(skb)->flags & DST_NOXFRM) ||
-			__xfrm_route_forward(skb, family);
+	if (!net->xfrm.policy_count[XFRM_POLICY_OUT] &&
+	    net->xfrm.policy_default[XFRM_POLICY_OUT] == XFRM_USERPOLICY_ACCEPT)
+		return true;
+
+	return (skb_dst(skb)->flags & DST_NOXFRM) ||
+	       __xfrm_route_forward(skb, family);
 }
 
 static inline int xfrm4_route_forward(struct sk_buff *skb)
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 04d1ce9b510f..01fe1e9cff86 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3158,7 +3158,7 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 
 nopol:
 	if (!(dst_orig->dev->flags & IFF_LOOPBACK) &&
-	    !xfrm_default_allow(net, dir)) {
+	    net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
 		err = -EPERM;
 		goto error;
 	}
@@ -3569,7 +3569,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 	}
 
 	if (!pol) {
-		if (!xfrm_default_allow(net, dir)) {
+		if (net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOPOLS);
 			return 0;
 		}
@@ -3629,7 +3629,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 		xfrm_nr = ti;
 
-		if (!xfrm_default_allow(net, dir) && !xfrm_nr) {
+		if (net->xfrm.policy_default[dir] == XFRM_USERPOLICY_BLOCK &&
+		    !xfrm_nr) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOSTATES);
 			goto reject;
 		}
@@ -4118,6 +4119,9 @@ static int __net_init xfrm_net_init(struct net *net)
 	spin_lock_init(&net->xfrm.xfrm_policy_lock);
 	seqcount_spinlock_init(&net->xfrm.xfrm_policy_hash_generation, &net->xfrm.xfrm_policy_lock);
 	mutex_init(&net->xfrm.xfrm_cfg_mutex);
+	net->xfrm.policy_default[XFRM_POLICY_IN] = XFRM_USERPOLICY_ACCEPT;
+	net->xfrm.policy_default[XFRM_POLICY_FWD] = XFRM_USERPOLICY_ACCEPT;
+	net->xfrm.policy_default[XFRM_POLICY_OUT] = XFRM_USERPOLICY_ACCEPT;
 
 	rv = xfrm_statistics_init(net);
 	if (rv < 0)
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 8cd6c8129004..2f6b64cf0975 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2009,12 +2009,9 @@ static int xfrm_notify_userpolicy(struct net *net)
 	}
 
 	up = nlmsg_data(nlh);
-	up->in = net->xfrm.policy_default & XFRM_POL_DEFAULT_IN ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
-	up->fwd = net->xfrm.policy_default & XFRM_POL_DEFAULT_FWD ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
-	up->out = net->xfrm.policy_default & XFRM_POL_DEFAULT_OUT ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
+	up->in = net->xfrm.policy_default[XFRM_POLICY_IN];
+	up->fwd = net->xfrm.policy_default[XFRM_POLICY_FWD];
+	up->out = net->xfrm.policy_default[XFRM_POLICY_OUT];
 
 	nlmsg_end(skb, nlh);
 
@@ -2025,26 +2022,26 @@ static int xfrm_notify_userpolicy(struct net *net)
 	return err;
 }
 
+static bool xfrm_userpolicy_is_valid(__u8 policy)
+{
+	return policy == XFRM_USERPOLICY_BLOCK ||
+	       policy == XFRM_USERPOLICY_ACCEPT;
+}
+
 static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 			    struct nlattr **attrs)
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
 
-	if (up->in == XFRM_USERPOLICY_BLOCK)
-		net->xfrm.policy_default |= XFRM_POL_DEFAULT_IN;
-	else if (up->in == XFRM_USERPOLICY_ACCEPT)
-		net->xfrm.policy_default &= ~XFRM_POL_DEFAULT_IN;
+	if (xfrm_userpolicy_is_valid(up->in))
+		net->xfrm.policy_default[XFRM_POLICY_IN] = up->in;
 
-	if (up->fwd == XFRM_USERPOLICY_BLOCK)
-		net->xfrm.policy_default |= XFRM_POL_DEFAULT_FWD;
-	else if (up->fwd == XFRM_USERPOLICY_ACCEPT)
-		net->xfrm.policy_default &= ~XFRM_POL_DEFAULT_FWD;
+	if (xfrm_userpolicy_is_valid(up->fwd))
+		net->xfrm.policy_default[XFRM_POLICY_FWD] = up->fwd;
 
-	if (up->out == XFRM_USERPOLICY_BLOCK)
-		net->xfrm.policy_default |= XFRM_POL_DEFAULT_OUT;
-	else if (up->out == XFRM_USERPOLICY_ACCEPT)
-		net->xfrm.policy_default &= ~XFRM_POL_DEFAULT_OUT;
+	if (xfrm_userpolicy_is_valid(up->out))
+		net->xfrm.policy_default[XFRM_POLICY_OUT] = up->out;
 
 	rt_genid_bump_all(net);
 
@@ -2074,13 +2071,9 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	r_up = nlmsg_data(r_nlh);
-
-	r_up->in = net->xfrm.policy_default & XFRM_POL_DEFAULT_IN ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
-	r_up->fwd = net->xfrm.policy_default & XFRM_POL_DEFAULT_FWD ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
-	r_up->out = net->xfrm.policy_default & XFRM_POL_DEFAULT_OUT ?
-			XFRM_USERPOLICY_BLOCK : XFRM_USERPOLICY_ACCEPT;
+	r_up->in = net->xfrm.policy_default[XFRM_POLICY_IN];
+	r_up->fwd = net->xfrm.policy_default[XFRM_POLICY_FWD];
+	r_up->out = net->xfrm.policy_default[XFRM_POLICY_OUT];
 	nlmsg_end(r_skb, r_nlh);
 
 	return nlmsg_unicast(net->xfrm.nlsk, r_skb, portid);
-- 
2.33.0

