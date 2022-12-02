Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD87640F04
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiLBUQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiLBUPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164B5F2325
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8A96622C0
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B552C433D6;
        Fri,  2 Dec 2022 20:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012151;
        bh=SmeUgS/fQtOif/ZlOUTxDVgcm084ANwSd3KdDh7b3dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxGmtI+z6zYic1bPtgHNjGcsShNhISVSPP8m+U6Cud2sU7mTPYDAXncSvilahFqmK
         HfvGbWYRQu8JXHEOg1LgCHwtpjsYfVPvru9igkpUc61QXyDxdjvXjbAa20C4VMWcuD
         vP3m8SjVPC3AK81hajmnKcuBuPWveWJvppO+diwN81xzWKLtjgLPLO2vwD214tCgBd
         0ze5fklMTdplHuj+s2G1L6idARBz7T9OWU04XuI3fNPsJkvpj3UViBg/XlJ5s8Znu5
         ad5W8/w80rCG1heIIV6fv513lss0049SXwe+m3ZuUFqJ+os1hdtQuvyjjDzsUoK4OY
         PF30Zqn7N5azg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next 11/13] net/mlx5e: Handle hardware IPsec limits events
Date:   Fri,  2 Dec 2022 22:14:55 +0200
Message-Id: <2f3c597105e827b7234feeb70be533111a36c6c4.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
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

Enable object changed event to signal IPsec about hitting
soft and hard limits.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  2 +-
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 19 +++-
 .../mlx5/core/en_accel/ipsec_offload.c        | 97 ++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  5 +
 4 files changed, 118 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 8d0c605d4cdb..4f176bd8395a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -470,7 +470,7 @@ static void mlx5e_xfrm_update_curlft(struct xfrm_state *x)
 		 */
 		return;
 
-	err = mlx5e_ipsec_aso_query(sa_entry);
+	err = mlx5e_ipsec_aso_query(sa_entry, NULL);
 	if (err)
 		return;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index aac1e6a83631..e7f21e449268 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -34,8 +34,6 @@
 #ifndef __MLX5E_IPSEC_H__
 #define __MLX5E_IPSEC_H__
 
-#ifdef CONFIG_MLX5_EN_IPSEC
-
 #include <linux/mlx5/device.h>
 #include <net/xfrm.h>
 #include <linux/idr.h>
@@ -114,10 +112,21 @@ struct mlx5e_ipsec_sw_stats {
 struct mlx5e_ipsec_rx;
 struct mlx5e_ipsec_tx;
 
+struct mlx5e_ipsec_work {
+	struct work_struct work;
+	struct mlx5e_ipsec *ipsec;
+	u32 id;
+};
+
 struct mlx5e_ipsec_aso {
 	u8 ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
 	dma_addr_t dma_addr;
 	struct mlx5_aso *aso;
+	/* IPsec ASO caches data on every query call,
+	 * so in nested calls, we can use this boolean to save
+	 * recursive calls to mlx5e_ipsec_aso_query()
+	 */
+	u8 use_cache : 1;
 };
 
 struct mlx5e_ipsec {
@@ -131,6 +140,7 @@ struct mlx5e_ipsec {
 	struct mlx5e_ipsec_rx *rx_ipv6;
 	struct mlx5e_ipsec_tx *tx;
 	struct mlx5e_ipsec_aso *aso;
+	struct notifier_block nb;
 };
 
 struct mlx5e_ipsec_esn_state {
@@ -188,6 +198,8 @@ struct mlx5e_ipsec_pol_entry {
 	struct mlx5_accel_pol_xfrm_attrs attrs;
 };
 
+#ifdef CONFIG_MLX5_EN_IPSEC
+
 void mlx5e_ipsec_init(struct mlx5e_priv *priv);
 void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv);
 void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv);
@@ -210,7 +222,8 @@ void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec);
 void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec);
 
-int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry);
+int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
+			  struct mlx5_wqe_aso_ctrl_seg *data);
 void mlx5e_ipsec_aso_update_curlft(struct mlx5e_ipsec_sa_entry *sa_entry,
 				   u64 *packets);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 8790558ea859..1b5014ffa257 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -260,6 +260,73 @@ void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 	memcpy(&sa_entry->attrs, attrs, sizeof(sa_entry->attrs));
 }
 
+static void mlx5e_ipsec_handle_event(struct work_struct *_work)
+{
+	struct mlx5e_ipsec_work *work =
+		container_of(_work, struct mlx5e_ipsec_work, work);
+	struct mlx5_accel_esp_xfrm_attrs *attrs;
+	struct mlx5e_ipsec_sa_entry *sa_entry;
+	struct mlx5e_ipsec_aso *aso;
+	struct mlx5e_ipsec *ipsec;
+	int ret;
+
+	sa_entry = xa_load(&work->ipsec->sadb, work->id);
+	if (!sa_entry)
+		goto out;
+
+	ipsec = sa_entry->ipsec;
+	aso = ipsec->aso;
+	attrs = &sa_entry->attrs;
+
+	spin_lock(&sa_entry->x->lock);
+	ret = mlx5e_ipsec_aso_query(sa_entry, NULL);
+	if (ret)
+		goto unlock;
+
+	aso->use_cache = true;
+	if (attrs->soft_packet_limit != XFRM_INF)
+		if (!MLX5_GET(ipsec_aso, aso->ctx, soft_lft_arm) ||
+		    !MLX5_GET(ipsec_aso, aso->ctx, hard_lft_arm) ||
+		    !MLX5_GET(ipsec_aso, aso->ctx, remove_flow_enable))
+			xfrm_state_check_expire(sa_entry->x);
+	aso->use_cache = false;
+
+unlock:
+	spin_unlock(&sa_entry->x->lock);
+out:
+	kfree(work);
+}
+
+static int mlx5e_ipsec_event(struct notifier_block *nb, unsigned long event,
+			     void *data)
+{
+	struct mlx5e_ipsec *ipsec = container_of(nb, struct mlx5e_ipsec, nb);
+	struct mlx5_eqe_obj_change *object;
+	struct mlx5e_ipsec_work *work;
+	struct mlx5_eqe *eqe = data;
+	u16 type;
+
+	if (event != MLX5_EVENT_TYPE_OBJECT_CHANGE)
+		return NOTIFY_DONE;
+
+	object = &eqe->data.obj_change;
+	type = be16_to_cpu(object->obj_type);
+
+	if (type != MLX5_GENERAL_OBJECT_TYPES_IPSEC)
+		return NOTIFY_DONE;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return NOTIFY_DONE;
+
+	INIT_WORK(&work->work, mlx5e_ipsec_handle_event);
+	work->ipsec = ipsec;
+	work->id = be32_to_cpu(object->obj_id);
+
+	queue_work(ipsec->wq, &work->work);
+	return NOTIFY_OK;
+}
+
 int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec)
 {
 	struct mlx5_core_dev *mdev = ipsec->mdev;
@@ -287,6 +354,9 @@ int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec)
 		goto err_aso_create;
 	}
 
+	ipsec->nb.notifier_call = mlx5e_ipsec_event;
+	mlx5_notifier_register(mdev, &ipsec->nb);
+
 	ipsec->aso = aso;
 	return 0;
 
@@ -307,13 +377,33 @@ void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec)
 	aso = ipsec->aso;
 	pdev = mlx5_core_dma_dev(mdev);
 
+	mlx5_notifier_unregister(mdev, &ipsec->nb);
 	mlx5_aso_destroy(aso->aso);
 	dma_unmap_single(pdev, aso->dma_addr, sizeof(aso->ctx),
 			 DMA_BIDIRECTIONAL);
 	kfree(aso);
 }
 
-int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry)
+static void mlx5e_ipsec_aso_copy(struct mlx5_wqe_aso_ctrl_seg *ctrl,
+				 struct mlx5_wqe_aso_ctrl_seg *data)
+{
+	if (!data)
+		return;
+
+	ctrl->data_mask_mode = data->data_mask_mode;
+	ctrl->condition_1_0_operand = data->condition_1_0_operand;
+	ctrl->condition_1_0_offset = data->condition_1_0_offset;
+	ctrl->data_offset_condition_operand = data->data_offset_condition_operand;
+	ctrl->condition_0_data = data->condition_0_data;
+	ctrl->condition_0_mask = data->condition_0_mask;
+	ctrl->condition_1_data = data->condition_1_data;
+	ctrl->condition_1_mask = data->condition_1_mask;
+	ctrl->bitwise_data = data->bitwise_data;
+	ctrl->data_mask = data->data_mask;
+}
+
+int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
+			  struct mlx5_wqe_aso_ctrl_seg *data)
 {
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 	struct mlx5e_ipsec_aso *aso = ipsec->aso;
@@ -323,6 +413,10 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_aso_wqe *wqe;
 	u8 ds_cnt;
 
+	lockdep_assert_held(&sa_entry->x->lock);
+	if (aso->use_cache)
+		return 0;
+
 	res = &mdev->mlx5e_res.hw_objs;
 
 	memset(aso->ctx, 0, sizeof(aso->ctx));
@@ -336,6 +430,7 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry)
 		cpu_to_be32(lower_32_bits(aso->dma_addr) | ASO_CTRL_READ_EN);
 	ctrl->va_h = cpu_to_be32(upper_32_bits(aso->dma_addr));
 	ctrl->l_key = cpu_to_be32(res->mkey);
+	mlx5e_ipsec_aso_copy(ctrl, data);
 
 	mlx5_aso_post_wqe(aso->aso, false, &wqe->ctrl);
 	return mlx5_aso_poll_cq(aso->aso, false);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index a0242dc15741..8f7580fec193 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -19,6 +19,7 @@
 #include "diag/fw_tracer.h"
 #include "mlx5_irq.h"
 #include "devlink.h"
+#include "en_accel/ipsec.h"
 
 enum {
 	MLX5_EQE_OWNER_INIT_VAL	= 0x1,
@@ -578,6 +579,10 @@ static void gather_async_events_mask(struct mlx5_core_dev *dev, u64 mask[4])
 	if (MLX5_CAP_MACSEC(dev, log_max_macsec_offload))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_OBJECT_CHANGE);
 
+	if (mlx5_ipsec_device_caps(dev) & MLX5_IPSEC_CAP_PACKET_OFFLOAD)
+		async_event_mask |=
+			(1ull << MLX5_EVENT_TYPE_OBJECT_CHANGE);
+
 	mask[0] = async_event_mask;
 
 	if (MLX5_CAP_GEN(dev, event_cap))
-- 
2.38.1

