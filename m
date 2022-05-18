Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD25C52B1EC
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 07:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiERFbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 01:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiERFbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 01:31:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F15D62ED
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 22:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9172E6175F
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D3CC385A5;
        Wed, 18 May 2022 05:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652851859;
        bh=ruH8togPJ1dt+D9kMKjiTdanuGCWMhotykWL7q6WsLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEwCtl+gglwYdPJCKyBqo2ZoMM38SJ0woLn9b+/nSWjROMRK2o5pjDM/c7Cg6EvY9
         EDgqAr/lrmjcZr/xcyR7uOwbwttFujbLveucMPJ2rLNK9nhdqd8t2o2DNcKnYEZjfB
         h3m2TvoODft5byuGH7odalwOBal6xT8hFujre1OCVYre89NM5OafTjIsk4/Cif4AzY
         mkguXPIPIrXspB8NZtTdFKw0nQMkt+x3zgRFZlhPoN7rLIP0g5qRuULrfmHzOX/Q26
         lVEL15VLGz9TxMWdl1kZaLv7Vj5b756Y+tTxq+TxLFzUXLu3TrEfjhm3T6HJQ4Uw3c
         P2MKaEzNflAQw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH ipsec-next v1 3/6] xfrm: add an interface to offload policy
Date:   Wed, 18 May 2022 08:30:23 +0300
Message-Id: <5dcaf3dc06aa6266e73aec0fea8265ede4b50786.1652851393.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1652851393.git.leonro@nvidia.com>
References: <cover.1652851393.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Extend netlink interface to add and delete XFRM policy from the device.
This functionality is a first step to implement full IPsec offload solution.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/netdevice.h |  3 +++
 include/net/xfrm.h        | 40 +++++++++++++++++++++++++++
 net/xfrm/xfrm_device.c    | 57 +++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_policy.c    |  2 ++
 net/xfrm/xfrm_user.c      |  9 +++++++
 5 files changed, 111 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cbaf312e365b..e6fefcdb4dcc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1012,6 +1012,9 @@ struct xfrmdev_ops {
 	bool	(*xdo_dev_offload_ok) (struct sk_buff *skb,
 				       struct xfrm_state *x);
 	void	(*xdo_dev_state_advance_esn) (struct xfrm_state *x);
+	int	(*xdo_dev_policy_add) (struct xfrm_policy *x);
+	void	(*xdo_dev_policy_delete) (struct xfrm_policy *x);
+	void	(*xdo_dev_policy_free) (struct xfrm_policy *x);
 };
 #endif
 
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 77e06e8208d8..21be19ece4f7 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -129,6 +129,7 @@ struct xfrm_state_walk {
 enum {
 	XFRM_DEV_OFFLOAD_IN = 1,
 	XFRM_DEV_OFFLOAD_OUT,
+	XFRM_DEV_OFFLOAD_FWD,
 };
 
 enum {
@@ -534,6 +535,8 @@ struct xfrm_policy {
 	struct xfrm_tmpl       	xfrm_vec[XFRM_MAX_DEPTH];
 	struct hlist_node	bydst_inexact_list;
 	struct rcu_head		rcu;
+
+	struct xfrm_dev_offload xdo;
 };
 
 static inline struct net *xp_net(const struct xfrm_policy *xp)
@@ -1873,6 +1876,8 @@ void xfrm_dev_backlog(struct softnet_data *sd);
 struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again);
 int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		       struct xfrm_user_offload *xuo);
+int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
+		       struct xfrm_user_offload *xuo, u8 dir);
 bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
 
 static inline void xfrm_dev_state_advance_esn(struct xfrm_state *x)
@@ -1921,6 +1926,27 @@ static inline void xfrm_dev_state_free(struct xfrm_state *x)
 		dev_put_track(dev, &xso->dev_tracker);
 	}
 }
+
+static inline void xfrm_dev_policy_delete(struct xfrm_policy *x)
+{
+	struct xfrm_dev_offload *xdo = &x->xdo;
+
+	if (xdo->dev)
+		xdo->dev->xfrmdev_ops->xdo_dev_policy_delete(x);
+}
+
+static inline void xfrm_dev_policy_free(struct xfrm_policy *x)
+{
+	struct xfrm_dev_offload *xdo = &x->xdo;
+	struct net_device *dev = xdo->dev;
+
+	if (dev && dev->xfrmdev_ops) {
+		if (dev->xfrmdev_ops->xdo_dev_policy_free)
+			dev->xfrmdev_ops->xdo_dev_policy_free(x);
+		xdo->dev = NULL;
+		dev_put_track(dev, &xdo->dev_tracker);
+	}
+}
 #else
 static inline void xfrm_dev_resume(struct sk_buff *skb)
 {
@@ -1948,6 +1974,20 @@ static inline void xfrm_dev_state_free(struct xfrm_state *x)
 {
 }
 
+static inline int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
+				      struct xfrm_user_offload *xuo, u8 dir)
+{
+	return 0;
+}
+
+static inline void xfrm_dev_policy_delete(struct xfrm_policy *x)
+{
+}
+
+static inline void xfrm_dev_policy_free(struct xfrm_policy *x)
+{
+}
+
 static inline bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 {
 	return false;
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index c4c469a85663..d7792a195c4e 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -302,6 +302,63 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 }
 EXPORT_SYMBOL_GPL(xfrm_dev_state_add);
 
+int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
+			struct xfrm_user_offload *xuo, u8 dir)
+{
+	struct xfrm_dev_offload *xdo = &xp->xdo;
+	struct net_device *dev;
+	int err;
+
+	/* We support only Full offload mode and it means
+	 * that user must set XFRM_OFFLOAD_FULL bit.
+	 */
+	if (!xuo->flags || xuo->flags & ~XFRM_OFFLOAD_FULL)
+		return -EINVAL;
+
+	dev = dev_get_by_index(net, xuo->ifindex);
+	if (!dev)
+		return -EINVAL;
+
+	if (!dev->xfrmdev_ops || !dev->xfrmdev_ops->xdo_dev_policy_add) {
+		xdo->dev = NULL;
+		dev_put(dev);
+		return -EINVAL;
+	}
+
+	xdo->dev = dev;
+	netdev_tracker_alloc(dev, &xdo->dev_tracker, GFP_ATOMIC);
+	xdo->real_dev = dev;
+	xdo->type = XFRM_DEV_OFFLOAD_FULL;
+	switch (dir) {
+	case XFRM_POLICY_IN:
+		xdo->dir = XFRM_DEV_OFFLOAD_IN;
+		break;
+	case XFRM_POLICY_OUT:
+		xdo->dir = XFRM_DEV_OFFLOAD_OUT;
+		break;
+	case XFRM_POLICY_FWD:
+		xdo->dir = XFRM_DEV_OFFLOAD_FWD;
+		break;
+	default:
+		xdo->dev = NULL;
+		dev_put(dev);
+		return -EINVAL;
+	}
+
+	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp);
+	if (err) {
+		xdo->dev = NULL;
+		xdo->real_dev = NULL;
+		xdo->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
+		xdo->dir = 0;
+		dev_put_track(dev, &xdo->dev_tracker);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xfrm_dev_policy_add);
+
 bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 {
 	int mtu;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 00bd0ecff5a1..681670f7d50f 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -425,6 +425,7 @@ void xfrm_policy_destroy(struct xfrm_policy *policy)
 	if (del_timer(&policy->timer) || del_timer(&policy->polq.hold_timer))
 		BUG();
 
+	xfrm_dev_policy_free(policy);
 	call_rcu(&policy->rcu, xfrm_policy_destroy_rcu);
 }
 EXPORT_SYMBOL(xfrm_policy_destroy);
@@ -2246,6 +2247,7 @@ int xfrm_policy_delete(struct xfrm_policy *pol, int dir)
 	pol = __xfrm_policy_unlink(pol, dir);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 	if (pol) {
+		xfrm_dev_policy_delete(pol);
 		xfrm_policy_kill(pol);
 		return 0;
 	}
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 0df71449abe9..00474559d079 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1747,6 +1747,14 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net, struct xfrm_us
 	if (attrs[XFRMA_IF_ID])
 		xp->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
 
+	/* configure the hardware if offload is requested */
+	if (attrs[XFRMA_OFFLOAD_DEV]) {
+		err = xfrm_dev_policy_add(net, xp,
+				nla_data(attrs[XFRMA_OFFLOAD_DEV]), p->dir);
+		if (err)
+			goto error;
+	}
+
 	return xp;
  error:
 	*errp = err;
@@ -1785,6 +1793,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	xfrm_audit_policy_add(xp, err ? 0 : 1, true);
 
 	if (err) {
+		xfrm_dev_policy_delete(xp);
 		security_xfrm_policy_free(xp->security);
 		kfree(xp);
 		return err;
-- 
2.36.1

