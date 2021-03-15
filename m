Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC84533AB23
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 06:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhCOFir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 01:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbhCOFiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 01:38:16 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F40C061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 22:38:16 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so14119058pjv.1
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 22:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W+exRWI6njC+NPtM/IYTo1hQodYIxG7deQqKDh/owdo=;
        b=PAS5v7I1HhZ6zj65QEcDJ258EHwqk3fOibLXg2dxN1kYU/Mzac+fxWfg4pRaXYqLwY
         9RkV+99InfcTPasN1LojvOdReLuVUnnFrwBv4O8aKoXJzqZppfdU2JrUcWIf8F9d7tIk
         z1zmsWygK5cgETFJaGBO5XCZdAOeBqkWsWBmMxlLEyuZBqggAuAEuCINJeWlz+bbzuoi
         LHYCgdqiEMEBU5xKEGaUqok2vLshgyWIN7Qm6ImkYZlaNUA5zp2UdGPNWUilI/BCBxjj
         Xz9nNODzUmgDI1qOegtvfW2jqCIvM2+nxZpqnCXzBIX1IrSyLZDgsYIp427ldXv5+6fn
         eAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W+exRWI6njC+NPtM/IYTo1hQodYIxG7deQqKDh/owdo=;
        b=gKsi3YBn/tv7u95epnf6VVXv6x67lSMY8x9P5d0KIlxUzouiyUDMwV/KkNzoGhopMt
         oyNrq/p5dI5YnT8RftgOncJ87dRSvt32HAjC99kewtmH0J3vVjtsur9xKW4lOoYZqT8i
         L55AEZxMxvZ7mdhamNOagZ1y7hj5736pTXZSga5BvVkNYHF1YUoQ2fAJBWvCIn6nE6BE
         rb16I2+0TKGhDuqVCh2bc2snEP/HKBILakq1+rVWdaYmDmSkthKHNNrIuwT1iVpfdurW
         GNwFbOh7q5/nAcghLSSZsKsIdykpEnpio+eADAMsrW9kFrWZfbJFLQ6RheU9kMo4FbZI
         d8cw==
X-Gm-Message-State: AOAM532+9ULQlGFFSEoOjL869Gpcf8kazaOpnsphPcOZDR41eMIWN49U
        zAtw/GFzZ0xgBk12o9EWFxR2
X-Google-Smtp-Source: ABdhPJxBFWigs9OW2eyvn77wPEclBtvkRb9P7hsuilf/3cKfPlTFpMlXpIZizSF+aVychY7FOkiG9w==
X-Received: by 2002:a17:90a:b898:: with SMTP id o24mr10675452pjr.14.1615786696187;
        Sun, 14 Mar 2021 22:38:16 -0700 (PDT)
Received: from localhost ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d20sm9325224pjv.47.2021.03.14.22.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 22:38:15 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 07/11] vdpa: Support transferring virtual addressing during DMA mapping
Date:   Mon, 15 Mar 2021 13:37:17 +0800
Message-Id: <20210315053721.189-8-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315053721.189-1-xieyongji@bytedance.com>
References: <20210315053721.189-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces an attribute for vDPA device to indicate
whether virtual address can be used. If vDPA device driver set
it, vhost-vdpa bus driver will not pin user page and transfer
userspace virtual address instead of physical address during
DMA mapping. And corresponding vma->vm_file and offset will be
also passed as an opaque pointer.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c   |   2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
 drivers/vdpa/vdpa.c               |   9 +++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c  |   2 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c |   2 +-
 drivers/vhost/vdpa.c              | 104 +++++++++++++++++++++++++++++++-------
 include/linux/vdpa.h              |  19 +++++--
 7 files changed, 113 insertions(+), 27 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index d555a6a5d1ba..aee013f3eb5f 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -431,7 +431,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
-				    dev, &ifc_vdpa_ops, NULL);
+				    dev, &ifc_vdpa_ops, NULL, false);
 	if (adapter == NULL) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
 		return -ENOMEM;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 71397fdafa6a..fb62ebcf464a 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1982,7 +1982,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
 
 	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
-				 NULL);
+				 NULL, false);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
 
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 5cffce67cab0..97fbac276c72 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -71,6 +71,7 @@ static void vdpa_release_dev(struct device *d)
  * @config: the bus operations that is supported by this device
  * @size: size of the parent structure that contains private data
  * @name: name of the vdpa device; optional.
+ * @use_va: indicate whether virtual address must be used by this device
  *
  * Driver should use vdpa_alloc_device() wrapper macro instead of
  * using this directly.
@@ -80,7 +81,8 @@ static void vdpa_release_dev(struct device *d)
  */
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					size_t size, const char *name)
+					size_t size, const char *name,
+					bool use_va)
 {
 	struct vdpa_device *vdev;
 	int err = -EINVAL;
@@ -91,6 +93,10 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 	if (!!config->dma_map != !!config->dma_unmap)
 		goto err;
 
+	/* It should only work for the device that use on-chip IOMMU */
+	if (use_va && !(config->dma_map || config->set_map))
+		goto err;
+
 	err = -ENOMEM;
 	vdev = kzalloc(size, GFP_KERNEL);
 	if (!vdev)
@@ -106,6 +112,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 	vdev->index = err;
 	vdev->config = config;
 	vdev->features_valid = false;
+	vdev->use_va = use_va;
 
 	if (name)
 		err = dev_set_name(&vdev->dev, "%s", name);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index ff331f088baf..d26334e9a412 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -235,7 +235,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 		ops = &vdpasim_config_ops;
 
 	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
-				    dev_attr->name);
+				    dev_attr->name, false);
 	if (!vdpasim)
 		goto err_alloc;
 
diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index 1321a2fcd088..03b36aed48d6 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -377,7 +377,7 @@ static int vp_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 
 	vp_vdpa = vdpa_alloc_device(struct vp_vdpa, vdpa,
-				    dev, &vp_vdpa_ops, NULL);
+				    dev, &vp_vdpa_ops, NULL, false);
 	if (vp_vdpa == NULL) {
 		dev_err(dev, "vp_vdpa: Failed to allocate vDPA structure\n");
 		return -ENOMEM;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7c83fbf3edac..b65c21ae98d1 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -480,21 +480,30 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 {
 	struct vhost_dev *dev = &v->vdev;
+	struct vdpa_device *vdpa = v->vdpa;
 	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct vhost_iotlb_map *map;
+	struct vdpa_map_file *map_file;
 	struct page *page;
 	unsigned long pfn, pinned;
 
 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
-		pinned = map->size >> PAGE_SHIFT;
-		for (pfn = map->addr >> PAGE_SHIFT;
-		     pinned > 0; pfn++, pinned--) {
-			page = pfn_to_page(pfn);
-			if (map->perm & VHOST_ACCESS_WO)
-				set_page_dirty_lock(page);
-			unpin_user_page(page);
+		if (!vdpa->use_va) {
+			pinned = map->size >> PAGE_SHIFT;
+			for (pfn = map->addr >> PAGE_SHIFT;
+			     pinned > 0; pfn++, pinned--) {
+				page = pfn_to_page(pfn);
+				if (map->perm & VHOST_ACCESS_WO)
+					set_page_dirty_lock(page);
+				unpin_user_page(page);
+			}
+			atomic64_sub(map->size >> PAGE_SHIFT,
+					&dev->mm->pinned_vm);
+		} else {
+			map_file = (struct vdpa_map_file *)map->opaque;
+			fput(map_file->file);
+			kfree(map_file);
 		}
-		atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
@@ -530,21 +539,21 @@ static int perm_to_iommu_flags(u32 perm)
 	return flags | IOMMU_CACHE;
 }
 
-static int vhost_vdpa_map(struct vhost_vdpa *v,
-			  u64 iova, u64 size, u64 pa, u32 perm)
+static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
+			  u64 size, u64 pa, u32 perm, void *opaque)
 {
 	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	int r = 0;
 
-	r = vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
-				  pa, perm);
+	r = vhost_iotlb_add_range_ctx(dev->iotlb, iova, iova + size - 1,
+				      pa, perm, opaque);
 	if (r)
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, iova, size, pa, perm, NULL);
+		r = ops->dma_map(vdpa, iova, size, pa, perm, opaque);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
 			r = ops->set_map(vdpa, dev->iotlb);
@@ -552,13 +561,15 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
 	}
-
-	if (r)
+	if (r) {
 		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
-	else
+		return r;
+	}
+
+	if (!vdpa->use_va)
 		atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
 
-	return r;
+	return 0;
 }
 
 static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
@@ -579,6 +590,56 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
 	}
 }
 
+static int vhost_vdpa_va_map(struct vhost_vdpa *v,
+			     u64 iova, u64 size, u64 uaddr, u32 perm)
+{
+	struct vhost_dev *dev = &v->vdev;
+	u64 offset, map_size, map_iova = iova;
+	struct vdpa_map_file *map_file;
+	struct vm_area_struct *vma;
+	int ret;
+
+	mmap_read_lock(dev->mm);
+
+	while (size) {
+		vma = find_vma(dev->mm, uaddr);
+		if (!vma) {
+			ret = -EINVAL;
+			break;
+		}
+		map_size = min(size, vma->vm_end - uaddr);
+		if (!(vma->vm_file && (vma->vm_flags & VM_SHARED) &&
+			!(vma->vm_flags & (VM_IO | VM_PFNMAP))))
+			goto next;
+
+		map_file = kzalloc(sizeof(*map_file), GFP_KERNEL);
+		if (!map_file) {
+			ret = -ENOMEM;
+			break;
+		}
+		offset = (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->vm_start;
+		map_file->offset = offset;
+		map_file->file = get_file(vma->vm_file);
+		ret = vhost_vdpa_map(v, map_iova, map_size, uaddr,
+				     perm, map_file);
+		if (ret) {
+			fput(map_file->file);
+			kfree(map_file);
+			break;
+		}
+next:
+		size -= map_size;
+		uaddr += map_size;
+		map_iova += map_size;
+	}
+	if (ret)
+		vhost_vdpa_unmap(v, iova, map_iova - iova);
+
+	mmap_read_unlock(dev->mm);
+
+	return ret;
+}
+
 static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			     u64 iova, u64 size, u64 uaddr, u32 perm)
 {
@@ -645,7 +706,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
 				ret = vhost_vdpa_map(v, iova, csize,
 						     map_pfn << PAGE_SHIFT,
-						     perm);
+						     perm, NULL);
 				if (ret) {
 					/*
 					 * Unpin the pages that are left unmapped
@@ -674,7 +735,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 
 	/* Pin the rest chunk */
 	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, perm);
+			     map_pfn << PAGE_SHIFT, perm, NULL);
 out:
 	if (ret) {
 		if (nchunks) {
@@ -707,6 +768,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 					   struct vhost_iotlb_msg *msg)
 {
 	struct vhost_dev *dev = &v->vdev;
+	struct vdpa_device *vdpa = v->vdpa;
 	struct vhost_iotlb *iotlb = dev->iotlb;
 
 	if (msg->iova < v->range.first ||
@@ -717,6 +779,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				    msg->iova + msg->size - 1))
 		return -EEXIST;
 
+	if (vdpa->use_va)
+		return vhost_vdpa_va_map(v, msg->iova, msg->size,
+					 msg->uaddr, msg->perm);
+
 	return vhost_vdpa_pa_map(v, msg->iova, msg->size, msg->uaddr,
 				 msg->perm);
 }
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index b01f7c9096bf..e67404e4b23e 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -44,6 +44,7 @@ struct vdpa_mgmt_dev;
  * @config: the configuration ops for this device.
  * @index: device index
  * @features_valid: were features initialized? for legacy guests
+ * @use_va: indicate whether virtual address must be used by this device
  * @nvqs: maximum number of supported virtqueues
  * @mdev: management device pointer; caller must setup when registering device as part
  *	  of dev_add() mgmtdev ops callback before invoking _vdpa_register_device().
@@ -54,6 +55,7 @@ struct vdpa_device {
 	const struct vdpa_config_ops *config;
 	unsigned int index;
 	bool features_valid;
+	bool use_va;
 	int nvqs;
 	struct vdpa_mgmt_dev *mdev;
 };
@@ -69,6 +71,16 @@ struct vdpa_iova_range {
 };
 
 /**
+ * Corresponding file area for device memory mapping
+ * @file: vma->vm_file for the mapping
+ * @offset: mapping offset in the vm_file
+ */
+struct vdpa_map_file {
+	struct file *file;
+	u64 offset;
+};
+
+/**
  * vDPA_config_ops - operations for configuring a vDPA device.
  * Note: vDPA device drivers are required to implement all of the
  * operations unless it is mentioned to be optional in the following
@@ -250,14 +262,15 @@ struct vdpa_config_ops {
 
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					size_t size, const char *name);
+					size_t size, const char *name,
+					bool use_va);
 
-#define vdpa_alloc_device(dev_struct, member, parent, config, name)   \
+#define vdpa_alloc_device(dev_struct, member, parent, config, name, use_va)   \
 			  container_of(__vdpa_alloc_device( \
 				       parent, config, \
 				       sizeof(dev_struct) + \
 				       BUILD_BUG_ON_ZERO(offsetof( \
-				       dev_struct, member)), name), \
+				       dev_struct, member)), name, use_va), \
 				       dev_struct, member)
 
 int vdpa_register_device(struct vdpa_device *vdev, int nvqs);
-- 
2.11.0

