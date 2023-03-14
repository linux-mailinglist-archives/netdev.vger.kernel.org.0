Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91BC6B8E02
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjCNJAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjCNJAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:00:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A13A9660F
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:59:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1E34B818B6
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18B6C433EF;
        Tue, 14 Mar 2023 08:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678784382;
        bh=+obrUcE0JSjIth87hJhwHpiqlbf4R+NGb/loKVFt2ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kg2FlLxXwOJulfjbSLwQ/yXh8xid24axiy4DoNYoP9/NWMy81Nqx3AdbjjOZALPX5
         FFLtseFmrRGhhiLkudQQXb44u9IMfoiCNZl9PcfFJEz6Bl35agP7w+cZyI8jLwJxsU
         oi+fNeYkQoeRhZ2ShvsteZD6Op442z3e5llp2LNz3aozs5hAWuNhWqyDX4OtnzC4ze
         kibePLgv3tixo1aGyav23obtpebgyr3sTKJxVTvkTvllcKFZPdlRkXk5iUkIgxqkcP
         x2APoxW07rKcPJccsWDmnJMGnysp+y2CT/FtG6ox0gdK2ZAmG1YCiY3X2kw+EeDtkq
         nVRO8Bo+BcVvA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Raed Salem <raeds@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 7/9] net/mlx5e: Support IPsec acquire default SA
Date:   Tue, 14 Mar 2023 10:58:42 +0200
Message-Id: <8f36d6b61631dcd73fef0a0ac623456030bc9db0.1678714336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
References: <cover.1678714336.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

During XFRM stack acquire flow, a default SA is created to be updated
later, once acquire netlink message is handled in user space.

This SA is also passed to IPsec offload supporting driver, however this
SA acts only as placeholder and does not have context suitable for
offloading in HW yet. Identify this kind of SA by special offload flag
(XFRM_DEV_OFFLOAD_FLAG_ACQ), and create a SW only context.

In such cases with special mark so it won't be installed in HW in addition
flow and on remove/delete free this SW only context.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 26 +++++++++++++++----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 9cc59dc8b592..20a6bd1c03a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -308,6 +308,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	struct net_device *netdev = x->xso.real_dev;
 	struct mlx5e_ipsec *ipsec;
 	struct mlx5e_priv *priv;
+	gfp_t gfp;
 	int err;
 
 	priv = netdev_priv(netdev);
@@ -315,16 +316,20 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 		return -EOPNOTSUPP;
 
 	ipsec = priv->ipsec;
-	err = mlx5e_xfrm_validate_state(priv->mdev, x, extack);
-	if (err)
-		return err;
-
-	sa_entry = kzalloc(sizeof(*sa_entry), GFP_KERNEL);
+	gfp = (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ) ? GFP_ATOMIC : GFP_KERNEL;
+	sa_entry = kzalloc(sizeof(*sa_entry), gfp);
 	if (!sa_entry)
 		return -ENOMEM;
 
 	sa_entry->x = x;
 	sa_entry->ipsec = ipsec;
+	/* Check if this SA is originated from acquire flow temporary SA */
+	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
+		goto out;
+
+	err = mlx5e_xfrm_validate_state(priv->mdev, x, extack);
+	if (err)
+		goto err_xfrm;
 
 	/* check esn */
 	mlx5e_ipsec_update_esn_state(sa_entry);
@@ -353,6 +358,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 				mlx5e_ipsec_set_iv_esn : mlx5e_ipsec_set_iv;
 
 	INIT_WORK(&sa_entry->modify_work.work, _update_xfrm_state);
+out:
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	return 0;
 
@@ -372,6 +378,9 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 	struct mlx5e_ipsec_sa_entry *old;
 
+	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
+		return;
+
 	old = xa_erase_bh(&ipsec->sadb, sa_entry->ipsec_obj_id);
 	WARN_ON(old != sa_entry);
 }
@@ -380,9 +389,13 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
 
+	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
+		goto sa_entry_free;
+
 	cancel_work_sync(&sa_entry->modify_work.work);
 	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 	mlx5_ipsec_free_sa_ctx(sa_entry);
+sa_entry_free:
 	kfree(sa_entry);
 }
 
@@ -486,6 +499,9 @@ static void mlx5e_xfrm_update_curlft(struct xfrm_state *x)
 
 	lockdep_assert_held(&x->lock);
 
+	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
+		return;
+
 	if (sa_entry->attrs.soft_packet_limit == XFRM_INF)
 		/* Limits are not configured, as soft limit
 		 * must be lowever than hard limit.
-- 
2.39.2

