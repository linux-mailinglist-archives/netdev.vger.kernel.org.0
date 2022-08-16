Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E8D595998
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbiHPLMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiHPLMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:12:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B02AE2B
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 076E6611A1
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84E9C433D6;
        Tue, 16 Aug 2022 08:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660640382;
        bh=EtsXcvmwqhjHxTB/G4HFtsI+Ff27pBQMQscZd4kxuH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RC9pOK4TpdSOUfJSxigyrkOSwy9iWy3W92f8r5yp/zC0vG7qe9iBExLJAs9gwx/Dt
         yE6u8vx86BgxMQl9KeE4YkF4HDd319dkr4b0Rm+yi3nazG55Xr9Q6bw0CbT2jzob/E
         BrtRdsDeqBqsGQ0A8VIbPtDoIfAHM/3Q9Va01NkaPZnxCmSjpOBQel1LeyI2czC2bq
         X8XNXCZlW82dewZTnrBrF67NkkvGy+B2+0n3DtL9G9hW9U+OAeUhAVuCVGLXgfvOgC
         MJYESDNZzOgqCImN6/YiN49IPtZwce+QX/++JReMkiIiTTmQBPAG+lfsOyf2/P19p7
         5mB9vBeBINxFQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next v2 3/6] xfrm: add an interface to offload policy
Date:   Tue, 16 Aug 2022 11:59:24 +0300
Message-Id: <ab736e4673f978814400333d1ba374b239ca300c.1660639789.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660639789.git.leonro@nvidia.com>
References: <cover.1660639789.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/netdevice.h |  3 ++
 include/net/xfrm.h        | 42 ++++++++++++++++++++++++
 net/xfrm/xfrm_device.c    | 61 ++++++++++++++++++++++++++++++++++-
 net/xfrm/xfrm_policy.c    | 67 +++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_user.c      | 17 ++++++++++
 5 files changed, 189 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1a3cb93c3dcc..401c52aeab0e 100644
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
index b4d487053dfd..587697eb1d31 100644
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
@@ -1577,6 +1580,7 @@ struct xfrm_state *xfrm_find_acq_byseq(struct net *net, u32 mark, u32 seq);
 int xfrm_state_delete(struct xfrm_state *x);
 int xfrm_state_flush(struct net *net, u8 proto, bool task_valid, bool sync);
 int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_valid);
+int xfrm_dev_policy_flush(struct net *net, struct net_device *dev, bool task_valid);
 void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si);
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
@@ -1887,6 +1891,8 @@ void xfrm_dev_backlog(struct softnet_data *sd);
 struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again);
 int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		       struct xfrm_user_offload *xuo);
+int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
+		       struct xfrm_user_offload *xuo, u8 dir);
 bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
 
 static inline void xfrm_dev_state_advance_esn(struct xfrm_state *x)
@@ -1935,6 +1941,28 @@ static inline void xfrm_dev_state_free(struct xfrm_state *x)
 		netdev_put(dev, &xso->dev_tracker);
 	}
 }
+
+static inline void xfrm_dev_policy_delete(struct xfrm_policy *x)
+{
+	struct xfrm_dev_offload *xdo = &x->xdo;
+	struct net_device *dev = xdo->dev;
+
+	if (dev && dev->xfrmdev_ops && dev->xfrmdev_ops->xdo_dev_policy_delete)
+		dev->xfrmdev_ops->xdo_dev_policy_delete(x);
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
+		netdev_put(dev, &xdo->dev_tracker);
+	}
+}
 #else
 static inline void xfrm_dev_resume(struct sk_buff *skb)
 {
@@ -1962,6 +1990,20 @@ static inline void xfrm_dev_state_free(struct xfrm_state *x)
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
index 5b04e5cdca64..1cc482e9c87d 100644
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
+	if (!xuo->flags || xuo->flags & ~XFRM_OFFLOAD_FULL)
+		/* We support only Full offload mode and it means
+		 * that user must set XFRM_OFFLOAD_FULL bit.
+		 */
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
+		netdev_put(dev, &xdo->dev_tracker);
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
@@ -404,8 +461,10 @@ static int xfrm_api_check(struct net_device *dev)
 
 static int xfrm_dev_down(struct net_device *dev)
 {
-	if (dev->features & NETIF_F_HW_ESP)
+	if (dev->features & NETIF_F_HW_ESP) {
 		xfrm_dev_state_flush(dev_net(dev), dev, true);
+		xfrm_dev_policy_flush(dev_net(dev), dev, true);
+	}
 
 	return NOTIFY_DONE;
 }
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1a0bab920a5..3049fdcf8411 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -425,6 +425,7 @@ void xfrm_policy_destroy(struct xfrm_policy *policy)
 	if (del_timer(&policy->timer) || del_timer(&policy->polq.hold_timer))
 		BUG();
 
+	xfrm_dev_policy_free(policy);
 	call_rcu(&policy->rcu, xfrm_policy_destroy_rcu);
 }
 EXPORT_SYMBOL(xfrm_policy_destroy);
@@ -1769,12 +1770,40 @@ xfrm_policy_flush_secctx_check(struct net *net, u8 type, bool task_valid)
 	}
 	return err;
 }
+
+static inline int xfrm_dev_policy_flush_secctx_check(struct net *net,
+						     struct net_device *dev,
+						     bool task_valid)
+{
+	struct xfrm_policy *pol;
+	int err = 0;
+
+	list_for_each_entry(pol, &net->xfrm.policy_all, walk.all) {
+		if (pol->walk.dead ||
+		    xfrm_policy_id2dir(pol->index) >= XFRM_POLICY_MAX ||
+		    pol->xdo.dev != dev)
+			continue;
+
+		err = security_xfrm_policy_delete(pol->security);
+		if (err) {
+			xfrm_audit_policy_delete(pol, 0, task_valid);
+			return err;
+		}
+	}
+	return err;
+}
 #else
 static inline int
 xfrm_policy_flush_secctx_check(struct net *net, u8 type, bool task_valid)
 {
 	return 0;
 }
+static inline int xfrm_dev_policy_flush_secctx_check(struct net *net,
+						     struct net_device *dev,
+						     bool task_valid)
+{
+	return 0;
+}
 #endif
 
 int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
@@ -1814,6 +1843,43 @@ int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
 }
 EXPORT_SYMBOL(xfrm_policy_flush);
 
+int xfrm_dev_policy_flush(struct net *net, struct net_device *dev, bool task_valid)
+{
+	int dir, err = 0, cnt = 0;
+	struct xfrm_policy *pol;
+
+	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
+
+	err = xfrm_dev_policy_flush_secctx_check(net, dev, task_valid);
+	if (err)
+		goto out;
+
+again:
+	list_for_each_entry(pol, &net->xfrm.policy_all, walk.all) {
+		dir = xfrm_policy_id2dir(pol->index);
+		if (pol->walk.dead ||
+		    dir >= XFRM_POLICY_MAX ||
+		    pol->xdo.dev != dev)
+			continue;
+
+		__xfrm_policy_unlink(pol, dir);
+		spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
+		cnt++;
+		xfrm_audit_policy_delete(pol, 1, task_valid);
+		xfrm_policy_kill(pol);
+		spin_lock_bh(&net->xfrm.xfrm_policy_lock);
+		goto again;
+	}
+	if (cnt)
+		__xfrm_policy_inexact_flush(net);
+	else
+		err = -ESRCH;
+out:
+	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
+	return err;
+}
+EXPORT_SYMBOL(xfrm_dev_policy_flush);
+
 int xfrm_policy_walk(struct net *net, struct xfrm_policy_walk *walk,
 		     int (*func)(struct xfrm_policy *, int, int, void*),
 		     void *data)
@@ -2246,6 +2312,7 @@ int xfrm_policy_delete(struct xfrm_policy *pol, int dir)
 	pol = __xfrm_policy_unlink(pol, dir);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 	if (pol) {
+		xfrm_dev_policy_delete(pol);
 		xfrm_policy_kill(pol);
 		return 0;
 	}
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 9c0aef815730..698ff84da6ba 100644
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
@@ -1897,6 +1906,8 @@ static int dump_one_policy(struct xfrm_policy *xp, int dir, int count, void *ptr
 		err = xfrm_mark_put(skb, &xp->mark);
 	if (!err)
 		err = xfrm_if_id_put(skb, xp->if_id);
+	if (!err && xp->xdo.dev)
+		err = copy_user_offload(&xp->xdo, skb);
 	if (err) {
 		nlmsg_cancel(skb, nlh);
 		return err;
@@ -3213,6 +3224,8 @@ static int build_acquire(struct sk_buff *skb, struct xfrm_state *x,
 		err = xfrm_mark_put(skb, &xp->mark);
 	if (!err)
 		err = xfrm_if_id_put(skb, xp->if_id);
+	if (!err && xp->xdo.dev)
+		err = copy_user_offload(&xp->xdo, skb);
 	if (err) {
 		nlmsg_cancel(skb, nlh);
 		return err;
@@ -3331,6 +3344,8 @@ static int build_polexpire(struct sk_buff *skb, struct xfrm_policy *xp,
 		err = xfrm_mark_put(skb, &xp->mark);
 	if (!err)
 		err = xfrm_if_id_put(skb, xp->if_id);
+	if (!err && xp->xdo.dev)
+		err = copy_user_offload(&xp->xdo, skb);
 	if (err) {
 		nlmsg_cancel(skb, nlh);
 		return err;
@@ -3414,6 +3429,8 @@ static int xfrm_notify_policy(struct xfrm_policy *xp, int dir, const struct km_e
 		err = xfrm_mark_put(skb, &xp->mark);
 	if (!err)
 		err = xfrm_if_id_put(skb, xp->if_id);
+	if (!err && xp->xdo.dev)
+		err = copy_user_offload(&xp->xdo, skb);
 	if (err)
 		goto out_free_skb;
 
-- 
2.37.2

