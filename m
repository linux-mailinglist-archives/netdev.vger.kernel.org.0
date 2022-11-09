Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10019622BED
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiKIMy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiKIMyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:54:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DB82497E
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 04:54:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1075861A8D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07118C43141;
        Wed,  9 Nov 2022 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667998488;
        bh=sICr5f3eswdDCXesZYJ3U8P9MA3nw0q61zDg5xrB2iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e23xtIwQq4Wm8+CMPENmNp38uuwYV6dLqt3VBwriV8Yojq+h8dfM2Nd+y9jGyrbiA
         ds8GneVqAkR4rRXL0rokGtQ9XguNlebT6KPXz2Ci3UO1g593lSaZIE38IrUTXQyBN8
         MWmnB24WQQti/jhkp4jeuSqpeZBQqGoCGmjoC9rFiAll/ujA1UO6qiE6MGDYz/4oeS
         zevbbojIl3TMYOYzkCSN4DuTjPAS1/OIfpfcrdfjELYYdGhpILpnmCERmit9Zo3xed
         VH+lflQzfCFdLEPWS30aMo+m6jG2KJeOlBS9PllRbiz3G0jnNzCGLIOBQzwmF1A1tq
         +n82RDHIUTd0g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH xfrm-next v7 3/8] xfrm: add an interface to offload policy
Date:   Wed,  9 Nov 2022 14:54:31 +0200
Message-Id: <a6510a82f733c97742a76eb5c5fc34e4486a2a00.1667997522.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667997522.git.leonro@nvidia.com>
References: <cover.1667997522.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Extend netlink interface to add and delete XFRM policy from the device.
This functionality is a first step to implement packet IPsec offload solution.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/netdevice.h |  3 ++
 include/net/xfrm.h        | 45 +++++++++++++++++++++++++
 net/xfrm/xfrm_device.c    | 67 ++++++++++++++++++++++++++++++++++++-
 net/xfrm/xfrm_policy.c    | 69 +++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_user.c      | 18 ++++++++++
 5 files changed, 201 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d45713a06568..5eb25f2b082f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1033,6 +1033,9 @@ struct xfrmdev_ops {
 	bool	(*xdo_dev_offload_ok) (struct sk_buff *skb,
 				       struct xfrm_state *x);
 	void	(*xdo_dev_state_advance_esn) (struct xfrm_state *x);
+	int	(*xdo_dev_policy_add) (struct xfrm_policy *x);
+	void	(*xdo_dev_policy_delete) (struct xfrm_policy *x);
+	void	(*xdo_dev_policy_free) (struct xfrm_policy *x);
 };
 #endif
 
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 304001b76fc5..e9c0cc245623 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -129,6 +129,7 @@ struct xfrm_state_walk {
 enum {
 	XFRM_DEV_OFFLOAD_IN = 1,
 	XFRM_DEV_OFFLOAD_OUT,
+	XFRM_DEV_OFFLOAD_FWD,
 };
 
 enum {
@@ -541,6 +542,8 @@ struct xfrm_policy {
 	struct xfrm_tmpl       	xfrm_vec[XFRM_MAX_DEPTH];
 	struct hlist_node	bydst_inexact_list;
 	struct rcu_head		rcu;
+
+	struct xfrm_dev_offload xdo;
 };
 
 static inline struct net *xp_net(const struct xfrm_policy *xp)
@@ -1585,6 +1588,8 @@ struct xfrm_state *xfrm_find_acq_byseq(struct net *net, u32 mark, u32 seq);
 int xfrm_state_delete(struct xfrm_state *x);
 int xfrm_state_flush(struct net *net, u8 proto, bool task_valid, bool sync);
 int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_valid);
+int xfrm_dev_policy_flush(struct net *net, struct net_device *dev,
+			  bool task_valid);
 void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si);
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
@@ -1897,6 +1902,9 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		       struct xfrm_user_offload *xuo,
 		       struct netlink_ext_ack *extack);
+int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
+			struct xfrm_user_offload *xuo, u8 dir,
+			struct netlink_ext_ack *extack);
 bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
 
 static inline void xfrm_dev_state_advance_esn(struct xfrm_state *x)
@@ -1945,6 +1953,28 @@ static inline void xfrm_dev_state_free(struct xfrm_state *x)
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
@@ -1972,6 +2002,21 @@ static inline void xfrm_dev_state_free(struct xfrm_state *x)
 {
 }
 
+static inline int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
+				      struct xfrm_user_offload *xuo, u8 dir,
+				      struct netlink_ext_ack *extack)
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
index dc4fb58dd7eb..8e18abc5016f 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -312,6 +312,69 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 }
 EXPORT_SYMBOL_GPL(xfrm_dev_state_add);
 
+int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
+			struct xfrm_user_offload *xuo, u8 dir,
+			struct netlink_ext_ack *extack)
+{
+	struct xfrm_dev_offload *xdo = &xp->xdo;
+	struct net_device *dev;
+	int err;
+
+	if (!xuo->flags || xuo->flags & ~XFRM_OFFLOAD_PACKET) {
+		/* We support only packet offload mode and it means
+		 * that user must set XFRM_OFFLOAD_PACKET bit.
+		 */
+		NL_SET_ERR_MSG(extack, "Unrecognized flags in offload request");
+		return -EINVAL;
+	}
+
+	dev = dev_get_by_index(net, xuo->ifindex);
+	if (!dev)
+		return -EINVAL;
+
+	if (!dev->xfrmdev_ops || !dev->xfrmdev_ops->xdo_dev_policy_add) {
+		xdo->dev = NULL;
+		dev_put(dev);
+		NL_SET_ERR_MSG(extack, "Policy offload is not supported");
+		return -EINVAL;
+	}
+
+	xdo->dev = dev;
+	netdev_tracker_alloc(dev, &xdo->dev_tracker, GFP_ATOMIC);
+	xdo->real_dev = dev;
+	xdo->type = XFRM_DEV_OFFLOAD_PACKET;
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
+		NL_SET_ERR_MSG(extack, "Unrecognized oflload direction");
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
+		NL_SET_ERR_MSG(extack, "Device failed to offload this policy");
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
@@ -414,8 +477,10 @@ static int xfrm_api_check(struct net_device *dev)
 
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
index d80519c4e389..07f43729ac4e 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -425,6 +425,7 @@ void xfrm_policy_destroy(struct xfrm_policy *policy)
 	if (del_timer(&policy->timer) || del_timer(&policy->polq.hold_timer))
 		BUG();
 
+	xfrm_dev_policy_free(policy);
 	call_rcu(&policy->rcu, xfrm_policy_destroy_rcu);
 }
 EXPORT_SYMBOL(xfrm_policy_destroy);
@@ -1769,12 +1770,41 @@ xfrm_policy_flush_secctx_check(struct net *net, u8 type, bool task_valid)
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
+
+static inline int xfrm_dev_policy_flush_secctx_check(struct net *net,
+						     struct net_device *dev,
+						     bool task_valid)
+{
+	return 0;
+}
 #endif
 
 int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
@@ -1814,6 +1844,44 @@ int xfrm_policy_flush(struct net *net, u8 type, bool task_valid)
 }
 EXPORT_SYMBOL(xfrm_policy_flush);
 
+int xfrm_dev_policy_flush(struct net *net, struct net_device *dev,
+			  bool task_valid)
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
@@ -2245,6 +2313,7 @@ int xfrm_policy_delete(struct xfrm_policy *pol, int dir)
 	pol = __xfrm_policy_unlink(pol, dir);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 	if (pol) {
+		xfrm_dev_policy_delete(pol);
 		xfrm_policy_kill(pol);
 		return 0;
 	}
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 573b60873b60..e2b563395656 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1869,6 +1869,15 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net,
 	if (attrs[XFRMA_IF_ID])
 		xp->if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
 
+	/* configure the hardware if offload is requested */
+	if (attrs[XFRMA_OFFLOAD_DEV]) {
+		err = xfrm_dev_policy_add(net, xp,
+					  nla_data(attrs[XFRMA_OFFLOAD_DEV]),
+					  p->dir, extack);
+		if (err)
+			goto error;
+	}
+
 	return xp;
  error:
 	*errp = err;
@@ -1908,6 +1917,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	xfrm_audit_policy_add(xp, err ? 0 : 1, true);
 
 	if (err) {
+		xfrm_dev_policy_delete(xp);
 		security_xfrm_policy_free(xp->security);
 		kfree(xp);
 		return err;
@@ -2020,6 +2030,8 @@ static int dump_one_policy(struct xfrm_policy *xp, int dir, int count, void *ptr
 		err = xfrm_mark_put(skb, &xp->mark);
 	if (!err)
 		err = xfrm_if_id_put(skb, xp->if_id);
+	if (!err && xp->xdo.dev)
+		err = copy_user_offload(&xp->xdo, skb);
 	if (err) {
 		nlmsg_cancel(skb, nlh);
 		return err;
@@ -3343,6 +3355,8 @@ static int build_acquire(struct sk_buff *skb, struct xfrm_state *x,
 		err = xfrm_mark_put(skb, &xp->mark);
 	if (!err)
 		err = xfrm_if_id_put(skb, xp->if_id);
+	if (!err && xp->xdo.dev)
+		err = copy_user_offload(&xp->xdo, skb);
 	if (err) {
 		nlmsg_cancel(skb, nlh);
 		return err;
@@ -3461,6 +3475,8 @@ static int build_polexpire(struct sk_buff *skb, struct xfrm_policy *xp,
 		err = xfrm_mark_put(skb, &xp->mark);
 	if (!err)
 		err = xfrm_if_id_put(skb, xp->if_id);
+	if (!err && xp->xdo.dev)
+		err = copy_user_offload(&xp->xdo, skb);
 	if (err) {
 		nlmsg_cancel(skb, nlh);
 		return err;
@@ -3544,6 +3560,8 @@ static int xfrm_notify_policy(struct xfrm_policy *xp, int dir, const struct km_e
 		err = xfrm_mark_put(skb, &xp->mark);
 	if (!err)
 		err = xfrm_if_id_put(skb, xp->if_id);
+	if (!err && xp->xdo.dev)
+		err = copy_user_offload(&xp->xdo, skb);
 	if (err)
 		goto out_free_skb;
 
-- 
2.38.1

