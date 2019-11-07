Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B700F3451
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389358AbfKGQJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:09:37 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53669 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389683AbfKGQJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:09:35 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:09:29 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4Q007213;
        Thu, 7 Nov 2019 18:09:27 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 16/19] net/mlx5: Implement dma ops and params for mediated device
Date:   Thu,  7 Nov 2019 10:08:31 -0600
Message-Id: <20191107160834.21087-16-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement dma ops wrapper to divert dma ops to its parent PCI device
because Intel IOMMU (and may be other IOMMU) is limited to PCI devices.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/meddev/sf.c   | 151 ++++++++++++++++++
 1 file changed, 151 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
index cfbbb2d32aca..4b0718418bc5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.c
@@ -207,6 +207,156 @@ u16 mlx5_core_max_sfs(const struct mlx5_core_dev *dev,
 	return mlx5_core_is_sf_supported(dev) ? sf_table->max_sfs : 0;
 }
 
+static void *mlx5_sf_dma_alloc(struct device *dev, size_t size,
+			       dma_addr_t *dma_handle, gfp_t gfp,
+			       unsigned long attrs)
+{
+	return dma_alloc_attrs(dev->parent, size, dma_handle, gfp, attrs);
+}
+
+static void
+mlx5_sf_dma_free(struct device *dev, size_t size,
+		 void *vaddr, dma_addr_t dma_handle,
+		 unsigned long attrs)
+{
+	dma_free_attrs(dev->parent, size, vaddr, dma_handle, attrs);
+}
+
+static int
+mlx5_sf_dma_mmap(struct device *dev, struct vm_area_struct *vma,
+		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
+		 unsigned long attrs)
+{
+	return dma_mmap_attrs(dev->parent, vma, cpu_addr,
+			      dma_addr, size, attrs);
+}
+
+static int
+mlx5_sf_dma_get_sgtable(struct device *dev, struct sg_table *sgt,
+			void *cpu_addr, dma_addr_t dma_addr, size_t size,
+			unsigned long attrs)
+{
+	return dma_get_sgtable_attrs(dev->parent, sgt, cpu_addr,
+				     dma_addr, size, attrs);
+}
+
+static dma_addr_t
+mlx5_sf_dma_map_page(struct device *dev, struct page *page,
+		     unsigned long offset, size_t size,
+		     enum dma_data_direction dir,
+		     unsigned long attrs)
+{
+	return dma_map_page_attrs(dev->parent, page, offset, size, dir, attrs);
+}
+
+static void
+mlx5_sf_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
+		       size_t size, enum dma_data_direction dir,
+		       unsigned long attrs)
+{
+	dma_unmap_page_attrs(dev->parent, dma_handle, size, dir, attrs);
+}
+
+static int
+mlx5_sf_dma_map_sg(struct device *dev, struct scatterlist *sg,
+		   int nents, enum dma_data_direction dir,
+		   unsigned long attrs)
+{
+	return dma_map_sg_attrs(dev->parent, sg, nents, dir, attrs);
+}
+
+static void
+mlx5_sf_dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
+		     enum dma_data_direction dir, unsigned long attrs)
+{
+	dma_unmap_sg_attrs(dev->parent, sg, nents, dir, attrs);
+}
+
+static dma_addr_t
+mlx5_sf_dma_map_resource(struct device *dev, phys_addr_t phys_addr,
+			 size_t size, enum dma_data_direction dir,
+			 unsigned long attrs)
+{
+	return dma_map_resource(dev->parent, phys_addr, size, dir, attrs);
+}
+
+static void
+mlx5_sf_dma_unmap_resource(struct device *dev, dma_addr_t dma_handle,
+			   size_t size, enum dma_data_direction dir,
+			   unsigned long attrs)
+{
+	dma_unmap_resource(dev->parent, dma_handle, size, dir, attrs);
+}
+
+static void
+mlx5_sf_dma_sync_single_for_cpu(struct device *dev,
+				dma_addr_t dma_handle, size_t size,
+				enum dma_data_direction dir)
+{
+	dma_sync_single_for_cpu(dev->parent, dma_handle, size, dir);
+}
+
+static void
+mlx5_sf_dma_sync_single_for_device(struct device *dev,
+				   dma_addr_t dma_handle, size_t size,
+				   enum dma_data_direction dir)
+{
+	dma_sync_single_for_device(dev->parent, dma_handle, size, dir);
+}
+
+static void
+mlx5_sf_dma_sync_sg_for_cpu(struct device *dev,
+			    struct scatterlist *sg, int nents,
+			    enum dma_data_direction dir)
+{
+	dma_sync_sg_for_cpu(dev->parent, sg, nents, dir);
+}
+
+static void
+mlx5_sf_dma_sync_sg_for_device(struct device *dev,
+			       struct scatterlist *sg, int nents,
+			       enum dma_data_direction dir)
+{
+	dma_sync_sg_for_device(dev->parent, sg, nents, dir);
+}
+
+static void
+mlx5_sf_dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+		       enum dma_data_direction dir)
+{
+	dma_cache_sync(dev->parent, vaddr, size, dir);
+}
+
+static const struct dma_map_ops mlx5_sf_dma_ops = {
+	.alloc = mlx5_sf_dma_alloc,
+	.free = mlx5_sf_dma_free,
+	.mmap = mlx5_sf_dma_mmap,
+	.get_sgtable = mlx5_sf_dma_get_sgtable,
+	.map_page = mlx5_sf_dma_map_page,
+	.unmap_page = mlx5_sf_dma_unmap_page,
+	.map_sg = mlx5_sf_dma_map_sg,
+	.unmap_sg = mlx5_sf_dma_unmap_sg,
+	.map_resource = mlx5_sf_dma_map_resource,
+	.unmap_resource = mlx5_sf_dma_unmap_resource,
+	.sync_single_for_cpu = mlx5_sf_dma_sync_single_for_cpu,
+	.sync_sg_for_cpu = mlx5_sf_dma_sync_sg_for_cpu,
+	.sync_sg_for_device = mlx5_sf_dma_sync_sg_for_device,
+	.sync_single_for_device = mlx5_sf_dma_sync_single_for_device,
+	.cache_sync = mlx5_sf_dma_cache_sync,
+};
+
+static void
+set_dma_params(struct device *dev, const struct mlx5_core_dev *coredev)
+{
+	struct pci_dev *pdev = coredev->pdev;
+
+	dev->dma_ops = &mlx5_sf_dma_ops;
+	dev->dma_mask = pdev->dev.dma_mask;
+	dev->dma_parms = pdev->dev.dma_parms;
+	dma_set_coherent_mask(dev, pdev->dev.coherent_dma_mask);
+	dma_set_max_seg_size(dev, dma_get_max_seg_size(&pdev->dev));
+}
+
 int mlx5_sf_load(struct mlx5_sf *sf, struct device *device,
 		 const struct mlx5_core_dev *parent_dev)
 {
@@ -231,6 +381,7 @@ int mlx5_sf_load(struct mlx5_sf *sf, struct device *device,
 		err = -ENOMEM;
 		goto remap_err;
 	}
+	set_dma_params(dev->device, parent_dev);
 
 	err = mlx5_mdev_init(dev, MLX5_DEFAULT_PROF);
 	if (err) {
-- 
2.19.2

