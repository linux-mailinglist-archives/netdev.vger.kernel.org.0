Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F2B6C891F
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjCXXOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjCXXOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:14:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABC31B557
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C533962D0B
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B836C4339B;
        Fri, 24 Mar 2023 23:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699643;
        bh=MlJpio0YZc8w6ckMgIdH5+/yMN7LAd99ceApx61dGrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlKA4C84SJz+lm5TYNmzFZ123sb9FbHuNnZ4rC7kDcCY3E5x9q95XR8LWwg3v2Ndm
         Qvj/8NvlxLf6pbRj6VUwhYiXDSV8kG2+ewZO/WcqJlY2gZa21h+3MrcNvlBx6GDOK8
         lNAudTf4k90mMoGwQ1R98BinDwgUNc5CoSDaD4x7I2GDpuCfzePqLvlGVFsy4kCpNF
         9/ZPwMnKYG8V9dPhH+zjA4yiPfzKVSruPXk2s9YVXoYOiTJeDFX9YpW2HL7zwIgUml
         JV2kVJreSEDM+FTAiG1GHbHacF6AQLB78eWcQdgO1NgYKdQzr2rvNPb53NmmvFOSwi
         flFRfLRn3Ubyg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eli Cohen <elic@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next V2 15/15] vdpa/mlx5: Support interrupt bypassing
Date:   Fri, 24 Mar 2023 16:13:41 -0700
Message-Id: <20230324231341.29808-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324231341.29808-1-saeed@kernel.org>
References: <20230324231341.29808-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Add support for generation of interrupts from the device directly to the
VM to the VCPU thus avoiding the overhead on the host CPU.

When supported, the driver will attempt to allocate vectors for each
data virtqueue. If a vector for a virtqueue cannot be provided it will
use the QP mode where notifications go through the driver.

In addition, we add a shutdown callback to make sure allocated
interrupts are released in case of shutdown to allow clean shutdown.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 139 ++++++++++++++++++++++++++++--
 drivers/vdpa/mlx5/net/mlx5_vnet.h |  14 +++
 2 files changed, 144 insertions(+), 9 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 520646ae7fa0..215a46cf8a98 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -83,6 +83,7 @@ struct mlx5_vq_restore_info {
 	u64 driver_addr;
 	u16 avail_index;
 	u16 used_index;
+	struct msi_map map;
 	bool ready;
 	bool restore;
 };
@@ -118,6 +119,7 @@ struct mlx5_vdpa_virtqueue {
 	u16 avail_idx;
 	u16 used_idx;
 	int fw_state;
+	struct msi_map map;
 
 	/* keep last in the struct */
 	struct mlx5_vq_restore_info ri;
@@ -792,6 +794,13 @@ static bool counters_supported(const struct mlx5_vdpa_dev *mvdev)
 	       BIT_ULL(MLX5_OBJ_TYPE_VIRTIO_Q_COUNTERS);
 }
 
+static bool msix_mode_supported(struct mlx5_vdpa_dev *mvdev)
+{
+	return (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, event_mode) &
+		(1 << MLX5_VIRTIO_Q_EVENT_MODE_MSIX_MODE) &&
+		pci_msix_can_alloc_dyn(mvdev->mdev->pdev));
+}
+
 static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_virtio_net_q_in);
@@ -829,9 +838,15 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
 	if (vq_is_tx(mvq->index))
 		MLX5_SET(virtio_net_q_object, obj_context, tisn_or_qpn, ndev->res.tisn);
 
-	MLX5_SET(virtio_q, vq_ctx, event_mode, MLX5_VIRTIO_Q_EVENT_MODE_QP_MODE);
+	if (mvq->map.virq) {
+		MLX5_SET(virtio_q, vq_ctx, event_mode, MLX5_VIRTIO_Q_EVENT_MODE_MSIX_MODE);
+		MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->map.index);
+	} else {
+		MLX5_SET(virtio_q, vq_ctx, event_mode, MLX5_VIRTIO_Q_EVENT_MODE_QP_MODE);
+		MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->fwqp.mqp.qpn);
+	}
+
 	MLX5_SET(virtio_q, vq_ctx, queue_index, mvq->index);
-	MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->fwqp.mqp.qpn);
 	MLX5_SET(virtio_q, vq_ctx, queue_size, mvq->num_ent);
 	MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0,
 		 !!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_F_VERSION_1)));
@@ -1174,6 +1189,32 @@ static void counter_set_dealloc(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_vir
 		mlx5_vdpa_warn(&ndev->mvdev, "dealloc counter set 0x%x\n", mvq->counter_set_id);
 }
 
+static void alloc_vector(struct mlx5_vdpa_net *ndev,
+			 struct mlx5_vdpa_virtqueue *mvq)
+{
+	struct mlx5_vdpa_irq_pool *irqp = &ndev->irqp;
+	int i;
+
+	for (i = 0; i < irqp->num_ent; i++) {
+		if (!irqp->entries[i].usecount) {
+			irqp->entries[i].usecount++;
+			mvq->map = irqp->entries[i].map;
+			return;
+		}
+	}
+}
+
+static void dealloc_vector(struct mlx5_vdpa_net *ndev,
+			   struct mlx5_vdpa_virtqueue *mvq)
+{
+	struct mlx5_vdpa_irq_pool *irqp = &ndev->irqp;
+	int i;
+
+	for (i = 0; i < irqp->num_ent; i++)
+		if (mvq->map.virq == irqp->entries[i].map.virq)
+			irqp->entries[i].usecount--;
+}
+
 static int setup_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
 {
 	u16 idx = mvq->index;
@@ -1203,27 +1244,31 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
 
 	err = counter_set_alloc(ndev, mvq);
 	if (err)
-		goto err_counter;
+		goto err_connect;
 
+	alloc_vector(ndev, mvq);
 	err = create_virtqueue(ndev, mvq);
 	if (err)
-		goto err_connect;
+		goto err_vq;
 
 	if (mvq->ready) {
 		err = modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
 		if (err) {
 			mlx5_vdpa_warn(&ndev->mvdev, "failed to modify to ready vq idx %d(%d)\n",
 				       idx, err);
-			goto err_connect;
+			goto err_modify;
 		}
 	}
 
 	mvq->initialized = true;
 	return 0;
 
-err_connect:
+err_modify:
+	destroy_virtqueue(ndev, mvq);
+err_vq:
+	dealloc_vector(ndev, mvq);
 	counter_set_dealloc(ndev, mvq);
-err_counter:
+err_connect:
 	qp_destroy(ndev, &mvq->vqqp);
 err_vqqp:
 	qp_destroy(ndev, &mvq->fwqp);
@@ -1267,6 +1312,7 @@ static void teardown_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *
 		return;
 
 	suspend_vq(ndev, mvq);
+	dealloc_vector(ndev, mvq);
 	destroy_virtqueue(ndev, mvq);
 	counter_set_dealloc(ndev, mvq);
 	qp_destroy(ndev, &mvq->vqqp);
@@ -2374,6 +2420,7 @@ static int save_channel_info(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
 	ri->desc_addr = mvq->desc_addr;
 	ri->device_addr = mvq->device_addr;
 	ri->driver_addr = mvq->driver_addr;
+	ri->map = mvq->map;
 	ri->restore = true;
 	return 0;
 }
@@ -2418,6 +2465,7 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
 		mvq->desc_addr = ri->desc_addr;
 		mvq->device_addr = ri->device_addr;
 		mvq->driver_addr = ri->driver_addr;
+		mvq->map = ri->map;
 	}
 }
 
@@ -2693,6 +2741,22 @@ static struct device *mlx5_get_vq_dma_dev(struct vdpa_device *vdev, u16 idx)
 	return mvdev->vdev.dma_dev;
 }
 
+static void free_irqs(struct mlx5_vdpa_net *ndev)
+{
+	struct mlx5_vdpa_irq_pool_entry *ent;
+	int i;
+
+	if (!msix_mode_supported(&ndev->mvdev))
+		return;
+
+	for (i = ndev->irqp.num_ent - 1; i >= 0; i--) {
+		ent = ndev->irqp.entries + i;
+		mlx5_msix_free(ndev->mvdev.mdev, ent->map);
+		ndev->irqp.num_ent--;
+	}
+	kfree(ndev->irqp.entries);
+}
+
 static void mlx5_vdpa_free(struct vdpa_device *vdev)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
@@ -2708,6 +2772,7 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev)
 		mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
 	}
 	mlx5_vdpa_free_resources(&ndev->mvdev);
+	free_irqs(ndev);
 	kfree(ndev->event_cbs);
 	kfree(ndev->vqs);
 }
@@ -2736,9 +2801,23 @@ static struct vdpa_notification_area mlx5_get_vq_notification(struct vdpa_device
 	return ret;
 }
 
-static int mlx5_get_vq_irq(struct vdpa_device *vdv, u16 idx)
+static int mlx5_get_vq_irq(struct vdpa_device *vdev, u16 idx)
 {
-	return -EOPNOTSUPP;
+	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+	struct mlx5_vdpa_virtqueue *mvq;
+
+	if (!is_index_valid(mvdev, idx))
+		return -EINVAL;
+
+	if (is_ctrl_vq_idx(mvdev, idx))
+		return -EOPNOTSUPP;
+
+	mvq = &ndev->vqs[idx];
+	if (!mvq->map.virq)
+		return -EOPNOTSUPP;
+
+	return mvq->map.virq;
 }
 
 static u64 mlx5_vdpa_get_driver_features(struct vdpa_device *vdev)
@@ -3095,6 +3174,35 @@ static int config_func_mtu(struct mlx5_core_dev *mdev, u16 mtu)
 	return err;
 }
 
+static irqreturn_t int_handler(int irq, void *nh)
+{
+	return IRQ_HANDLED;
+}
+
+static void allocate_irqs(struct mlx5_vdpa_net *ndev)
+{
+	struct mlx5_vdpa_irq_pool_entry *ent;
+	int i;
+
+	if (!msix_mode_supported(&ndev->mvdev))
+		return;
+
+	ndev->irqp.entries = kcalloc(ndev->mvdev.max_vqs, sizeof(*ndev->irqp.entries), GFP_KERNEL);
+	if (!ndev->irqp.entries)
+		return;
+
+	for (i = 0; i < ndev->mvdev.max_vqs; i++) {
+		ent = ndev->irqp.entries + i;
+		snprintf(ent->name, MLX5_VDPA_IRQ_NAME_LEN, "%s-vq-%d",
+			 dev_name(&ndev->mvdev.vdev.dev), i);
+		ent->map = mlx5_msix_alloc(ndev->mvdev.mdev, int_handler, NULL, ent->name);
+		if (!ent->map.virq)
+			return;
+
+		ndev->irqp.num_ent++;
+	}
+}
+
 static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 			     const struct vdpa_dev_set_config *add_config)
 {
@@ -3171,6 +3279,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	}
 
 	init_mvqs(ndev);
+	allocate_irqs(ndev);
 	init_rwsem(&ndev->reslock);
 	config = &ndev->config;
 
@@ -3358,6 +3467,17 @@ static void mlx5v_remove(struct auxiliary_device *adev)
 	kfree(mgtdev);
 }
 
+static void mlx5v_shutdown(struct auxiliary_device *auxdev)
+{
+	struct mlx5_vdpa_mgmtdev *mgtdev;
+	struct mlx5_vdpa_net *ndev;
+
+	mgtdev = auxiliary_get_drvdata(auxdev);
+	ndev = mgtdev->ndev;
+
+	free_irqs(ndev);
+}
+
 static const struct auxiliary_device_id mlx5v_id_table[] = {
 	{ .name = MLX5_ADEV_NAME ".vnet", },
 	{},
@@ -3369,6 +3489,7 @@ static struct auxiliary_driver mlx5v_driver = {
 	.name = "vnet",
 	.probe = mlx5v_probe,
 	.remove = mlx5v_remove,
+	.shutdown = mlx5v_shutdown,
 	.id_table = mlx5v_id_table,
 };
 
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.h b/drivers/vdpa/mlx5/net/mlx5_vnet.h
index c90a89e1de4d..e5063b310d3c 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.h
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.h
@@ -26,6 +26,19 @@ static inline u16 key2vid(u64 key)
 	return (u16)(key >> 48) & 0xfff;
 }
 
+#define MLX5_VDPA_IRQ_NAME_LEN 32
+
+struct mlx5_vdpa_irq_pool_entry {
+	struct msi_map map;
+	int usecount;
+	char name[MLX5_VDPA_IRQ_NAME_LEN];
+};
+
+struct mlx5_vdpa_irq_pool {
+	int num_ent;
+	struct mlx5_vdpa_irq_pool_entry *entries;
+};
+
 struct mlx5_vdpa_net {
 	struct mlx5_vdpa_dev mvdev;
 	struct mlx5_vdpa_net_resources res;
@@ -49,6 +62,7 @@ struct mlx5_vdpa_net {
 	struct vdpa_callback config_cb;
 	struct mlx5_vdpa_wq_ent cvq_ent;
 	struct hlist_head macvlan_hash[MLX5V_MACVLAN_SIZE];
+	struct mlx5_vdpa_irq_pool irqp;
 	struct dentry *debugfs;
 };
 
-- 
2.39.2

