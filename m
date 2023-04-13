Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3836E0D75
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjDMMaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjDMMaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60ABA253
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 05:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C81B163DFD
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B49C433D2;
        Thu, 13 Apr 2023 12:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681389003;
        bh=NHPwBqSWcXk2fCZyUrdEekb1rtsFvQ7b3ELweDF1nS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DowqLdb8vbPuPhdzjZuKD10mYdnoQiTB2U8yeZ6Fvm3i7Z6HZc+HMjd8WQYtfPV1F
         d4l/8lAlLoyIB9Oj6hGQtayOy5blRC67q9x/tpRtWsKOvIaZDvMQwZyfGPZwbflY6T
         LIxpsy44kVfAI4N0YDeZanb1Ztw71YYsBjFEnl7y8xK/A2NWxA+SegzhdRAUujazwh
         ofzMUX/bCGexWy09YEnGCakx/vJtSvhdYRBqDmXrqx1jWzrhYXvBEBkOct/zwbGSZ1
         Q1IJ849AZ7BgkCIXvJyrbn3CdEBLJYCDqvU/YDkOLdWVHHhngHx4Dk1gvbPc3/rnEi
         eVVbfNsWdf27g==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v1 07/10] net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode
Date:   Thu, 13 Apr 2023 15:29:25 +0300
Message-Id: <b08025ba8fe3e117adebbbb69032e3d97de506bb.1681388425.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681388425.git.leonro@nvidia.com>
References: <cover.1681388425.git.leonro@nvidia.com>
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

In IPsec packet offload mode all header manipulations are performed by
hardware, which is responsible to add/remove L2 header with source and
destinations MACs.

CX-7 devices don't support offload of in-kernel routing functionality,
as such HW needs external help to fill other side MAC as it isn't
available for HW.

As a solution, let's listen to neigh ARP updates and reconfigure IPsec
rules on the fly once new MAC data information arrives.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 132 +++++++++++++++++-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   5 +
 2 files changed, 130 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 36f3ffd54355..b64281fd4142 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -35,12 +35,14 @@
 #include <crypto/aead.h>
 #include <linux/inetdevice.h>
 #include <linux/netdevice.h>
+#include <net/netevent.h>
 
 #include "en.h"
 #include "ipsec.h"
 #include "ipsec_rxtx.h"
 
 #define MLX5_IPSEC_RESCHED msecs_to_jiffies(1000)
+#define MLX5E_IPSEC_TUNNEL_SA XA_MARK_1
 
 static struct mlx5e_ipsec_sa_entry *to_ipsec_sa_entry(struct xfrm_state *x)
 {
@@ -251,7 +253,7 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	struct neighbour *n;
 	u8 addr[ETH_ALEN];
 
-	if (attrs->mode != XFRM_MODE_TUNNEL &&
+	if (attrs->mode != XFRM_MODE_TUNNEL ||
 	    attrs->type != XFRM_DEV_OFFLOAD_PACKET)
 		return;
 
@@ -267,6 +269,8 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 			if (IS_ERR(n))
 				return;
 			neigh_event_send(n, NULL);
+			attrs->drop = true;
+			break;
 		}
 		neigh_ha_snapshot(addr, n, netdev);
 		ether_addr_copy(attrs->smac, addr);
@@ -279,6 +283,8 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 			if (IS_ERR(n))
 				return;
 			neigh_event_send(n, NULL);
+			attrs->drop = true;
+			break;
 		}
 		neigh_ha_snapshot(addr, n, netdev);
 		ether_addr_copy(attrs->dmac, addr);
@@ -507,34 +513,81 @@ static void mlx5e_ipsec_set_esn_ops(struct mlx5e_ipsec_sa_entry *sa_entry)
 	sa_entry->set_iv_op = mlx5e_ipsec_set_iv;
 }
 
+static void mlx5e_ipsec_handle_netdev_event(struct work_struct *_work)
+{
+	struct mlx5e_ipsec_work *work =
+		container_of(_work, struct mlx5e_ipsec_work, work);
+	struct mlx5e_ipsec_sa_entry *sa_entry = work->sa_entry;
+	struct mlx5e_ipsec_netevent_data *data = work->data;
+	struct mlx5_accel_esp_xfrm_attrs *attrs;
+
+	attrs = &sa_entry->attrs;
+
+	switch (attrs->dir) {
+	case XFRM_DEV_OFFLOAD_IN:
+		ether_addr_copy(attrs->smac, data->addr);
+		break;
+	case XFRM_DEV_OFFLOAD_OUT:
+		ether_addr_copy(attrs->dmac, data->addr);
+		break;
+	default:
+		WARN_ON_ONCE(true);
+	}
+	attrs->drop = false;
+	mlx5e_accel_ipsec_fs_modify(sa_entry);
+}
+
 static int mlx5_ipsec_create_work(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct xfrm_state *x = sa_entry->x;
 	struct mlx5e_ipsec_work *work;
+	void *data = NULL;
 
 	switch (x->xso.type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
 		if (!(x->props.flags & XFRM_STATE_ESN))
 			return 0;
 		break;
+	case XFRM_DEV_OFFLOAD_PACKET:
+		if (x->props.mode != XFRM_MODE_TUNNEL)
+			return 0;
+		break;
 	default:
-		return 0;
+		break;
 	}
 
 	work = kzalloc(sizeof(*work), GFP_KERNEL);
 	if (!work)
 		return -ENOMEM;
 
-	work->data = kzalloc(sizeof(*sa_entry), GFP_KERNEL);
-	if (!work->data) {
-		kfree(work);
-		return -ENOMEM;
+	switch (x->xso.type) {
+	case XFRM_DEV_OFFLOAD_CRYPTO:
+		data = kzalloc(sizeof(*sa_entry), GFP_KERNEL);
+		if (!data)
+			goto free_work;
+
+		INIT_WORK(&work->work, mlx5e_ipsec_modify_state);
+		break;
+	case XFRM_DEV_OFFLOAD_PACKET:
+		data = kzalloc(sizeof(struct mlx5e_ipsec_netevent_data),
+			       GFP_KERNEL);
+		if (!data)
+			goto free_work;
+
+		INIT_WORK(&work->work, mlx5e_ipsec_handle_netdev_event);
+		break;
+	default:
+		break;
 	}
 
-	INIT_WORK(&work->work, mlx5e_ipsec_modify_state);
+	work->data = data;
 	work->sa_entry = sa_entry;
 	sa_entry->work = work;
 	return 0;
+
+free_work:
+	kfree(work);
+	return -ENOMEM;
 }
 
 static int mlx5e_ipsec_create_dwork(struct mlx5e_ipsec_sa_entry *sa_entry)
@@ -629,6 +682,12 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	if (sa_entry->dwork)
 		queue_delayed_work(ipsec->wq, &sa_entry->dwork->dwork,
 				   MLX5_IPSEC_RESCHED);
+
+	if (x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
+	    x->props.mode == XFRM_MODE_TUNNEL)
+		xa_set_mark(&ipsec->sadb, sa_entry->ipsec_obj_id,
+			    MLX5E_IPSEC_TUNNEL_SA);
+
 out:
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	return 0;
@@ -651,6 +710,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 	struct mlx5e_ipsec_sa_entry *old;
 
@@ -659,6 +719,12 @@ static void mlx5e_xfrm_del_state(struct xfrm_state *x)
 
 	old = xa_erase_bh(&ipsec->sadb, sa_entry->ipsec_obj_id);
 	WARN_ON(old != sa_entry);
+
+	if (attrs->mode == XFRM_MODE_TUNNEL &&
+	    attrs->type == XFRM_DEV_OFFLOAD_PACKET)
+		/* Make sure that no ARP requests are running in parallel */
+		flush_workqueue(ipsec->wq);
+
 }
 
 static void mlx5e_xfrm_free_state(struct xfrm_state *x)
@@ -683,6 +749,46 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	kfree(sa_entry);
 }
 
+static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
+				      unsigned long event, void *ptr)
+{
+	struct mlx5_accel_esp_xfrm_attrs *attrs;
+	struct mlx5e_ipsec_netevent_data *data;
+	struct mlx5e_ipsec_sa_entry *sa_entry;
+	struct mlx5e_ipsec *ipsec;
+	struct neighbour *n = ptr;
+	struct net_device *netdev;
+	struct xfrm_state *x;
+	unsigned long idx;
+
+	if (event != NETEVENT_NEIGH_UPDATE || !(n->nud_state & NUD_VALID))
+		return NOTIFY_DONE;
+
+	ipsec = container_of(nb, struct mlx5e_ipsec, netevent_nb);
+	xa_for_each_marked(&ipsec->sadb, idx, sa_entry, MLX5E_IPSEC_TUNNEL_SA) {
+		attrs = &sa_entry->attrs;
+
+		if (attrs->family == AF_INET) {
+			if (!neigh_key_eq32(n, &attrs->saddr.a4) &&
+			    !neigh_key_eq32(n, &attrs->daddr.a4))
+				continue;
+		} else {
+			if (!neigh_key_eq128(n, &attrs->saddr.a4) &&
+			    !neigh_key_eq128(n, &attrs->daddr.a4))
+				continue;
+		}
+
+		x = sa_entry->x;
+		netdev = x->xso.real_dev;
+		data = sa_entry->work->data;
+
+		neigh_ha_snapshot(data->addr, n, netdev);
+		queue_work(ipsec->wq, &sa_entry->work->work);
+	}
+
+	return NOTIFY_DONE;
+}
+
 void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_ipsec *ipsec;
@@ -711,6 +817,13 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 			goto err_aso;
 	}
 
+	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_TUNNEL) {
+		ipsec->netevent_nb.notifier_call = mlx5e_ipsec_netevent_event;
+		ret = register_netevent_notifier(&ipsec->netevent_nb);
+		if (ret)
+			goto clear_aso;
+	}
+
 	ret = mlx5e_accel_ipsec_fs_init(ipsec);
 	if (ret)
 		goto err_fs_init;
@@ -721,6 +834,9 @@ void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	return;
 
 err_fs_init:
+	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_TUNNEL)
+		unregister_netevent_notifier(&ipsec->netevent_nb);
+clear_aso:
 	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_PACKET_OFFLOAD)
 		mlx5e_ipsec_aso_cleanup(ipsec);
 err_aso:
@@ -739,6 +855,8 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 		return;
 
 	mlx5e_accel_ipsec_fs_cleanup(ipsec);
+	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_TUNNEL)
+		unregister_netevent_notifier(&ipsec->netevent_nb);
 	if (mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_PACKET_OFFLOAD)
 		mlx5e_ipsec_aso_cleanup(ipsec);
 	destroy_workqueue(ipsec->wq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 77384ffa4451..d06c896eadb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -144,6 +144,10 @@ struct mlx5e_ipsec_work {
 	void *data;
 };
 
+struct mlx5e_ipsec_netevent_data {
+	u8 addr[ETH_ALEN];
+};
+
 struct mlx5e_ipsec_dwork {
 	struct delayed_work dwork;
 	struct mlx5e_ipsec_sa_entry *sa_entry;
@@ -169,6 +173,7 @@ struct mlx5e_ipsec {
 	struct mlx5e_ipsec_tx *tx;
 	struct mlx5e_ipsec_aso *aso;
 	struct notifier_block nb;
+	struct notifier_block netevent_nb;
 	struct mlx5_ipsec_fs *roce;
 };
 
-- 
2.39.2

