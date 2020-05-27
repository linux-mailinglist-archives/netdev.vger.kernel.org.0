Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26691E3E30
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgE0J5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:57:41 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59040 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725822AbgE0J5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:57:41 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maxg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 May 2020 12:46:35 +0300
Received: from mtr-vdi-031.wap.labs.mlnx. (mtr-vdi-031.wap.labs.mlnx [10.209.102.136])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04R9kYij009430;
        Wed, 27 May 2020 12:46:35 +0300
From:   Max Gurtovoy <maxg@mellanox.com>
To:     jgg@mellanox.com, dledford@redhat.com, leon@kernel.org,
        galpress@amazon.com, dennis.dalessandro@intel.com,
        netdev@vger.kernel.org, sagi@grimberg.me,
        linux-rdma@vger.kernel.org, bvanassche@acm.org,
        santosh.shilimkar@oracle.com, tom@talpey.com
Cc:     aron.silverton@oracle.com, israelr@mellanox.com, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com,
        Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH 2/9] RDMA/mlx4: remove FMR support for memory registration
Date:   Wed, 27 May 2020 12:46:27 +0300
Message-Id: <20200527094634.24240-3-maxg@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200527094634.24240-1-maxg@mellanox.com>
References: <20200527094634.24240-1-maxg@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HCA's that are driven by mlx4 driver support FRWR method to register
memory. Remove the ancient and unsafe FMR method.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
---
 drivers/infiniband/hw/mlx4/main.c       |  10 --
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |  16 ---
 drivers/infiniband/hw/mlx4/mr.c         |  93 ----------------
 drivers/net/ethernet/mellanox/mlx4/mr.c | 183 --------------------------------
 include/linux/mlx4/device.h             |  21 +---
 5 files changed, 2 insertions(+), 321 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 275722c..778dccf 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2600,13 +2600,6 @@ static void get_fw_ver_str(struct ib_device *device, char *str)
 	.modify_wq = mlx4_ib_modify_wq,
 };
 
-static const struct ib_device_ops mlx4_ib_dev_fmr_ops = {
-	.alloc_fmr = mlx4_ib_fmr_alloc,
-	.dealloc_fmr = mlx4_ib_fmr_dealloc,
-	.map_phys_fmr = mlx4_ib_map_phys_fmr,
-	.unmap_fmr = mlx4_ib_unmap_fmr,
-};
-
 static const struct ib_device_ops mlx4_ib_dev_mw_ops = {
 	.alloc_mw = mlx4_ib_alloc_mw,
 	.dealloc_mw = mlx4_ib_dealloc_mw,
@@ -2724,9 +2717,6 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		ib_set_device_ops(&ibdev->ib_dev, &mlx4_ib_dev_wq_ops);
 	}
 
-	if (!mlx4_is_slave(ibdev->dev))
-		ib_set_device_ops(&ibdev->ib_dev, &mlx4_ib_dev_fmr_ops);
-
 	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_MEM_WINDOW ||
 	    dev->caps.bmme_flags & MLX4_BMME_FLAG_TYPE_2_WIN) {
 		ibdev->ib_dev.uverbs_cmd_mask |=
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index d188573..ebdeffd 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -146,11 +146,6 @@ struct mlx4_ib_mw {
 	struct mlx4_mw		mmw;
 };
 
-struct mlx4_ib_fmr {
-	struct ib_fmr           ibfmr;
-	struct mlx4_fmr         mfmr;
-};
-
 #define MAX_REGS_PER_FLOW 2
 
 struct mlx4_flow_reg_id {
@@ -679,11 +674,6 @@ static inline struct mlx4_ib_mw *to_mmw(struct ib_mw *ibmw)
 	return container_of(ibmw, struct mlx4_ib_mw, ibmw);
 }
 
-static inline struct mlx4_ib_fmr *to_mfmr(struct ib_fmr *ibfmr)
-{
-	return container_of(ibfmr, struct mlx4_ib_fmr, ibfmr);
-}
-
 static inline struct mlx4_ib_flow *to_mflow(struct ib_flow *ibflow)
 {
 	return container_of(ibflow, struct mlx4_ib_flow, ibflow);
@@ -794,12 +784,6 @@ int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 int mlx4_ib_mad_init(struct mlx4_ib_dev *dev);
 void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev);
 
-struct ib_fmr *mlx4_ib_fmr_alloc(struct ib_pd *pd, int mr_access_flags,
-				  struct ib_fmr_attr *fmr_attr);
-int mlx4_ib_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list, int npages,
-			 u64 iova);
-int mlx4_ib_unmap_fmr(struct list_head *fmr_list);
-int mlx4_ib_fmr_dealloc(struct ib_fmr *fmr);
 int __mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 			 struct ib_port_attr *props, int netw_view);
 int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index b0121c9..e2fb71b 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -698,99 +698,6 @@ struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
 	return ERR_PTR(err);
 }
 
-struct ib_fmr *mlx4_ib_fmr_alloc(struct ib_pd *pd, int acc,
-				 struct ib_fmr_attr *fmr_attr)
-{
-	struct mlx4_ib_dev *dev = to_mdev(pd->device);
-	struct mlx4_ib_fmr *fmr;
-	int err = -ENOMEM;
-
-	fmr = kmalloc(sizeof *fmr, GFP_KERNEL);
-	if (!fmr)
-		return ERR_PTR(-ENOMEM);
-
-	err = mlx4_fmr_alloc(dev->dev, to_mpd(pd)->pdn, convert_access(acc),
-			     fmr_attr->max_pages, fmr_attr->max_maps,
-			     fmr_attr->page_shift, &fmr->mfmr);
-	if (err)
-		goto err_free;
-
-	err = mlx4_fmr_enable(to_mdev(pd->device)->dev, &fmr->mfmr);
-	if (err)
-		goto err_mr;
-
-	fmr->ibfmr.rkey = fmr->ibfmr.lkey = fmr->mfmr.mr.key;
-
-	return &fmr->ibfmr;
-
-err_mr:
-	(void) mlx4_mr_free(to_mdev(pd->device)->dev, &fmr->mfmr.mr);
-
-err_free:
-	kfree(fmr);
-
-	return ERR_PTR(err);
-}
-
-int mlx4_ib_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-		      int npages, u64 iova)
-{
-	struct mlx4_ib_fmr *ifmr = to_mfmr(ibfmr);
-	struct mlx4_ib_dev *dev = to_mdev(ifmr->ibfmr.device);
-
-	return mlx4_map_phys_fmr(dev->dev, &ifmr->mfmr, page_list, npages, iova,
-				 &ifmr->ibfmr.lkey, &ifmr->ibfmr.rkey);
-}
-
-int mlx4_ib_unmap_fmr(struct list_head *fmr_list)
-{
-	struct ib_fmr *ibfmr;
-	int err;
-	struct mlx4_dev *mdev = NULL;
-
-	list_for_each_entry(ibfmr, fmr_list, list) {
-		if (mdev && to_mdev(ibfmr->device)->dev != mdev)
-			return -EINVAL;
-		mdev = to_mdev(ibfmr->device)->dev;
-	}
-
-	if (!mdev)
-		return 0;
-
-	list_for_each_entry(ibfmr, fmr_list, list) {
-		struct mlx4_ib_fmr *ifmr = to_mfmr(ibfmr);
-
-		mlx4_fmr_unmap(mdev, &ifmr->mfmr, &ifmr->ibfmr.lkey, &ifmr->ibfmr.rkey);
-	}
-
-	/*
-	 * Make sure all MPT status updates are visible before issuing
-	 * SYNC_TPT firmware command.
-	 */
-	wmb();
-
-	err = mlx4_SYNC_TPT(mdev);
-	if (err)
-		pr_warn("SYNC_TPT error %d when "
-		       "unmapping FMRs\n", err);
-
-	return 0;
-}
-
-int mlx4_ib_fmr_dealloc(struct ib_fmr *ibfmr)
-{
-	struct mlx4_ib_fmr *ifmr = to_mfmr(ibfmr);
-	struct mlx4_ib_dev *dev = to_mdev(ibfmr->device);
-	int err;
-
-	err = mlx4_fmr_free(dev->dev, &ifmr->mfmr);
-
-	if (!err)
-		kfree(ifmr);
-
-	return err;
-}
-
 static int mlx4_set_page(struct ib_mr *ibmr, u64 addr)
 {
 	struct mlx4_ib_mr *mr = to_mmr(ibmr);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mr.c b/drivers/net/ethernet/mellanox/mlx4/mr.c
index 1a11bc0..d2986f1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -966,189 +966,6 @@ void mlx4_cleanup_mr_table(struct mlx4_dev *dev)
 	mlx4_bitmap_cleanup(&mr_table->mpt_bitmap);
 }
 
-static inline int mlx4_check_fmr(struct mlx4_fmr *fmr, u64 *page_list,
-				  int npages, u64 iova)
-{
-	int i, page_mask;
-
-	if (npages > fmr->max_pages)
-		return -EINVAL;
-
-	page_mask = (1 << fmr->page_shift) - 1;
-
-	/* We are getting page lists, so va must be page aligned. */
-	if (iova & page_mask)
-		return -EINVAL;
-
-	/* Trust the user not to pass misaligned data in page_list */
-	if (0)
-		for (i = 0; i < npages; ++i) {
-			if (page_list[i] & ~page_mask)
-				return -EINVAL;
-		}
-
-	if (fmr->maps >= fmr->max_maps)
-		return -EINVAL;
-
-	return 0;
-}
-
-int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list,
-		      int npages, u64 iova, u32 *lkey, u32 *rkey)
-{
-	u32 key;
-	int i, err;
-
-	err = mlx4_check_fmr(fmr, page_list, npages, iova);
-	if (err)
-		return err;
-
-	++fmr->maps;
-
-	key = key_to_hw_index(fmr->mr.key);
-	key += dev->caps.num_mpts;
-	*lkey = *rkey = fmr->mr.key = hw_index_to_key(key);
-
-	*(u8 *) fmr->mpt = MLX4_MPT_STATUS_SW;
-
-	/* Make sure MPT status is visible before writing MTT entries */
-	wmb();
-
-	dma_sync_single_for_cpu(&dev->persist->pdev->dev, fmr->dma_handle,
-				npages * sizeof(u64), DMA_TO_DEVICE);
-
-	for (i = 0; i < npages; ++i)
-		fmr->mtts[i] = cpu_to_be64(page_list[i] | MLX4_MTT_FLAG_PRESENT);
-
-	dma_sync_single_for_device(&dev->persist->pdev->dev, fmr->dma_handle,
-				   npages * sizeof(u64), DMA_TO_DEVICE);
-
-	fmr->mpt->key    = cpu_to_be32(key);
-	fmr->mpt->lkey   = cpu_to_be32(key);
-	fmr->mpt->length = cpu_to_be64(npages * (1ull << fmr->page_shift));
-	fmr->mpt->start  = cpu_to_be64(iova);
-
-	/* Make MTT entries are visible before setting MPT status */
-	wmb();
-
-	*(u8 *) fmr->mpt = MLX4_MPT_STATUS_HW;
-
-	/* Make sure MPT status is visible before consumer can use FMR */
-	wmb();
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mlx4_map_phys_fmr);
-
-int mlx4_fmr_alloc(struct mlx4_dev *dev, u32 pd, u32 access, int max_pages,
-		   int max_maps, u8 page_shift, struct mlx4_fmr *fmr)
-{
-	struct mlx4_priv *priv = mlx4_priv(dev);
-	int err = -ENOMEM;
-
-	if (max_maps > dev->caps.max_fmr_maps)
-		return -EINVAL;
-
-	if (page_shift < (ffs(dev->caps.page_size_cap) - 1) || page_shift >= 32)
-		return -EINVAL;
-
-	/* All MTTs must fit in the same page */
-	if (max_pages * sizeof(*fmr->mtts) > PAGE_SIZE)
-		return -EINVAL;
-
-	fmr->page_shift = page_shift;
-	fmr->max_pages  = max_pages;
-	fmr->max_maps   = max_maps;
-	fmr->maps = 0;
-
-	err = mlx4_mr_alloc(dev, pd, 0, 0, access, max_pages,
-			    page_shift, &fmr->mr);
-	if (err)
-		return err;
-
-	fmr->mtts = mlx4_table_find(&priv->mr_table.mtt_table,
-				    fmr->mr.mtt.offset,
-				    &fmr->dma_handle);
-
-	if (!fmr->mtts) {
-		err = -ENOMEM;
-		goto err_free;
-	}
-
-	return 0;
-
-err_free:
-	(void) mlx4_mr_free(dev, &fmr->mr);
-	return err;
-}
-EXPORT_SYMBOL_GPL(mlx4_fmr_alloc);
-
-int mlx4_fmr_enable(struct mlx4_dev *dev, struct mlx4_fmr *fmr)
-{
-	struct mlx4_priv *priv = mlx4_priv(dev);
-	int err;
-
-	err = mlx4_mr_enable(dev, &fmr->mr);
-	if (err)
-		return err;
-
-	fmr->mpt = mlx4_table_find(&priv->mr_table.dmpt_table,
-				    key_to_hw_index(fmr->mr.key), NULL);
-	if (!fmr->mpt)
-		return -ENOMEM;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mlx4_fmr_enable);
-
-void mlx4_fmr_unmap(struct mlx4_dev *dev, struct mlx4_fmr *fmr,
-		    u32 *lkey, u32 *rkey)
-{
-	if (!fmr->maps)
-		return;
-
-	/* To unmap: it is sufficient to take back ownership from HW */
-	*(u8 *)fmr->mpt = MLX4_MPT_STATUS_SW;
-
-	/* Make sure MPT status is visible */
-	wmb();
-
-	fmr->maps = 0;
-}
-EXPORT_SYMBOL_GPL(mlx4_fmr_unmap);
-
-int mlx4_fmr_free(struct mlx4_dev *dev, struct mlx4_fmr *fmr)
-{
-	int ret;
-
-	if (fmr->maps)
-		return -EBUSY;
-	if (fmr->mr.enabled == MLX4_MPT_EN_HW) {
-		/* In case of FMR was enabled and unmapped
-		 * make sure to give ownership of MPT back to HW
-		 * so HW2SW_MPT command will success.
-		 */
-		*(u8 *)fmr->mpt = MLX4_MPT_STATUS_SW;
-		/* Make sure MPT status is visible before changing MPT fields */
-		wmb();
-		fmr->mpt->length = 0;
-		fmr->mpt->start  = 0;
-		/* Make sure MPT data is visible after changing MPT status */
-		wmb();
-		*(u8 *)fmr->mpt = MLX4_MPT_STATUS_HW;
-		/* make sure MPT status is visible */
-		wmb();
-	}
-
-	ret = mlx4_mr_free(dev, &fmr->mr);
-	if (ret)
-		return ret;
-	fmr->mr.enabled = MLX4_MPT_DISABLED;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mlx4_fmr_free);
-
 int mlx4_SYNC_TPT(struct mlx4_dev *dev)
 {
 	return mlx4_cmd(dev, 0, 0, 0, MLX4_CMD_SYNC_TPT,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 20372de..dd53d96 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -707,17 +707,6 @@ struct mlx4_mw {
 	int			enabled;
 };
 
-struct mlx4_fmr {
-	struct mlx4_mr		mr;
-	struct mlx4_mpt_entry  *mpt;
-	__be64		       *mtts;
-	dma_addr_t		dma_handle;
-	int			max_pages;
-	int			max_maps;
-	int			maps;
-	u8			page_shift;
-};
-
 struct mlx4_uar {
 	unsigned long		pfn;
 	int			index;
@@ -1412,14 +1401,6 @@ void mlx4_handle_eth_header_mcast_prio(struct mlx4_net_trans_rule_hw_ctrl *ctrl,
 int mlx4_register_vlan(struct mlx4_dev *dev, u8 port, u16 vlan, int *index);
 void mlx4_unregister_vlan(struct mlx4_dev *dev, u8 port, u16 vlan);
 
-int mlx4_map_phys_fmr(struct mlx4_dev *dev, struct mlx4_fmr *fmr, u64 *page_list,
-		      int npages, u64 iova, u32 *lkey, u32 *rkey);
-int mlx4_fmr_alloc(struct mlx4_dev *dev, u32 pd, u32 access, int max_pages,
-		   int max_maps, u8 page_shift, struct mlx4_fmr *fmr);
-int mlx4_fmr_enable(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
-void mlx4_fmr_unmap(struct mlx4_dev *dev, struct mlx4_fmr *fmr,
-		    u32 *lkey, u32 *rkey);
-int mlx4_fmr_free(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
 int mlx4_SYNC_TPT(struct mlx4_dev *dev);
 int mlx4_test_interrupt(struct mlx4_dev *dev, int vector);
 int mlx4_test_async(struct mlx4_dev *dev);
@@ -1522,6 +1503,8 @@ struct mlx4_slaves_pport mlx4_phys_to_slaves_pport_actv(
 int mlx4_vf_get_enable_smi_admin(struct mlx4_dev *dev, int slave, int port);
 int mlx4_vf_set_enable_smi_admin(struct mlx4_dev *dev, int slave, int port,
 				 int enable);
+
+struct mlx4_mpt_entry;
 int mlx4_mr_hw_get_mpt(struct mlx4_dev *dev, struct mlx4_mr *mmr,
 		       struct mlx4_mpt_entry ***mpt_entry);
 int mlx4_mr_hw_write_mpt(struct mlx4_dev *dev, struct mlx4_mr *mmr,
-- 
1.8.3.1

