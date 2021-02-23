Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1F73229DC
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhBWL4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbhBWLyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:54:02 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3993EC06121D
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:52:03 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 17so6365852pli.10
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zeWBLNOmvHk2uzJtT08aziawVH2bGNkCBZ8pCGe6rTs=;
        b=j3fUQX1Yzwi+2H7CrwXa5Znp+qotVkSpB9LCt/UVgfqrilOIdc9iniDJIcFocOxuME
         YhvJA7SGFwVSyMbouQoYSdUFLxHsN/OSh87w8FGPKOT0PdbqgbCW2F/Fbt6ZXn/3W/kA
         SmxFOPCd6NBfVW7JSIb+qF+tfZP8giAD0Vo+pBFzS9rlr7Hx4KPIUXCoqyobv3Yen/Vf
         LpxaGNLkCb/ywX/svmafrZ1jTxJJj5zCrzO5zm2xxhn/hNez1pl4+OZdV2S+efEP0rw2
         Ki9MBYOgLlcG/k1lNrvgqrh7Vr9K058hE3xsZqQd6A8ZNmOOpUipcN1atkJnYGcD79+W
         HH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zeWBLNOmvHk2uzJtT08aziawVH2bGNkCBZ8pCGe6rTs=;
        b=ptufwkGl5/h2FE6QJbz5im+lmknuBJLR9zR3zD731xu/wp+9MMEfTIP/uptJ3fUhep
         ygXqnYXkgvNemK3kE0A7VPbr0q8iuQx01mzeg+c6+bC2lb6QbkdPxCyQ46QR5b8C5A9/
         OeWcRg9Fiuirbv6TEKW37jeSrWCVSyfNsVdyXilKEuDGlDSPwMRgdjIN8WNP1vkmqsJP
         OtkN0RZOmddVd8uiM++aK2TuMQa0UF60Y9FElgBQJBCxjxYzEHhrcgZygylIKuhW4wMi
         lz7n41MX3CGXKXlVTSM2vZGsTdes2WQf0tGFJGhN7/Vbw62lXbOIpd1BSJ+R99ax0RY5
         z9nQ==
X-Gm-Message-State: AOAM533DSdaBPHgDBhpcRWUBhFDYgocHyPKyN0ffdMMMxyh9/EiyWJQv
        fSMI1HRhsgFFvPZAoNoEzN9j
X-Google-Smtp-Source: ABdhPJw5v8mbOS7u5okybguNh3KqUCGlQaPTZnIUz/s1q68zd7C/AdZV+jRNKyGhPwp+6Jq3HNG5vw==
X-Received: by 2002:a17:90a:1389:: with SMTP id i9mr28470525pja.104.1614081122785;
        Tue, 23 Feb 2021 03:52:02 -0800 (PST)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id o21sm2835896pjp.42.2021.02.23.03.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:52:02 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v4 05/11] vdpa: Support transferring virtual addressing during DMA mapping
Date:   Tue, 23 Feb 2021 19:50:42 +0800
Message-Id: <20210223115048.435-6-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223115048.435-1-xieyongji@bytedance.com>
References: <20210223115048.435-1-xieyongji@bytedance.com>
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
 drivers/vhost/vdpa.c              | 104 +++++++++++++++++++++++++++++++-------
 include/linux/vdpa.h              |  20 ++++++--
 6 files changed, 113 insertions(+), 26 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 7c8bbfcf6c3e..228b9f920fea 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -432,7 +432,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
 				    dev, &ifc_vdpa_ops,
-				    IFCVF_MAX_QUEUE_PAIRS * 2, NULL);
+				    IFCVF_MAX_QUEUE_PAIRS * 2, NULL, false);
 	if (adapter == NULL) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
 		return -ENOMEM;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 029822060017..54290438da28 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1964,7 +1964,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
 
 	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
-				 2 * mlx5_vdpa_max_qps(max_vqs), NULL);
+				 2 * mlx5_vdpa_max_qps(max_vqs), NULL, false);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
 
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 9700a0adcca0..fafc0ee5eb05 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -72,6 +72,7 @@ static void vdpa_release_dev(struct device *d)
  * @nvqs: number of virtqueues supported by this device
  * @size: size of the parent structure that contains private data
  * @name: name of the vdpa device; optional.
+ * @use_va: indicate whether virtual address can be used by this device
  *
  * Driver should use vdpa_alloc_device() wrapper macro instead of
  * using this directly.
@@ -81,7 +82,8 @@ static void vdpa_release_dev(struct device *d)
  */
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					int nvqs, size_t size, const char *name)
+					int nvqs, size_t size, const char *name,
+					bool use_va)
 {
 	struct vdpa_device *vdev;
 	int err = -EINVAL;
@@ -92,6 +94,10 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 	if (!!config->dma_map != !!config->dma_unmap)
 		goto err;
 
+	/* It should only work for the device that use on-chip IOMMU */
+	if (use_va && !(config->dma_map || config->set_map))
+		goto err;
+
 	err = -ENOMEM;
 	vdev = kzalloc(size, GFP_KERNEL);
 	if (!vdev)
@@ -108,6 +114,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 	vdev->config = config;
 	vdev->features_valid = false;
 	vdev->nvqs = nvqs;
+	vdev->use_va = use_va;
 
 	if (name)
 		err = dev_set_name(&vdev->dev, "%s", name);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 5cfc262ce055..3a9a2dd4e987 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -235,7 +235,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 		ops = &vdpasim_config_ops;
 
 	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
-				    dev_attr->nvqs, dev_attr->name);
+				    dev_attr->nvqs, dev_attr->name, false);
 	if (!vdpasim)
 		goto err_alloc;
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 70857fe3263c..93769ace34df 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -480,21 +480,31 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
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
+			if (map_file->file)
+				fput(map_file->file);
+			kfree(map_file);
 		}
-		atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
@@ -530,21 +540,21 @@ static int perm_to_iommu_flags(u32 perm)
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
@@ -552,13 +562,15 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
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
@@ -579,10 +591,60 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
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
+			goto err;
+		}
+		map_size = min(size, vma->vm_end - uaddr);
+		offset = (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->vm_start;
+		map_file = kzalloc(sizeof(*map_file), GFP_KERNEL);
+		if (!map_file) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		if (vma->vm_file && (vma->vm_flags & VM_SHARED) &&
+			!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
+			map_file->file = get_file(vma->vm_file);
+			map_file->offset = offset;
+		}
+		ret = vhost_vdpa_map(v, map_iova, map_size, uaddr,
+				     perm, map_file);
+		if (ret) {
+			if (map_file->file)
+				fput(map_file->file);
+			kfree(map_file);
+			goto err;
+		}
+		size -= map_size;
+		uaddr += map_size;
+		map_iova += map_size;
+	}
+	mmap_read_unlock(dev->mm);
+
+	return 0;
+err:
+	vhost_vdpa_unmap(v, iova, map_iova - iova);
+	return ret;
+}
+
 static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 					   struct vhost_iotlb_msg *msg)
 {
 	struct vhost_dev *dev = &v->vdev;
+	struct vdpa_device *vdpa = v->vdpa;
 	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct page **page_list;
 	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
@@ -601,6 +663,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				    msg->iova + msg->size - 1))
 		return -EEXIST;
 
+	if (vdpa->use_va)
+		return vhost_vdpa_va_map(v, msg->iova, msg->size,
+					 msg->uaddr, msg->perm);
+
 	/* Limit the use of memory for bookkeeping */
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
 	if (!page_list)
@@ -654,7 +720,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
 				ret = vhost_vdpa_map(v, iova, csize,
 						     map_pfn << PAGE_SHIFT,
-						     msg->perm);
+						     msg->perm, NULL);
 				if (ret) {
 					/*
 					 * Unpin the pages that are left unmapped
@@ -683,7 +749,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 
 	/* Pin the rest chunk */
 	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, msg->perm);
+			     map_pfn << PAGE_SHIFT, msg->perm, NULL);
 out:
 	if (ret) {
 		if (nchunks) {
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 93dca2c328ae..bfae6d780c38 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -44,6 +44,7 @@ struct vdpa_mgmt_dev;
  * @config: the configuration ops for this device.
  * @index: device index
  * @features_valid: were features initialized? for legacy guests
+ * @use_va: indicate whether virtual address can be used by this device
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
@@ -250,14 +262,16 @@ struct vdpa_config_ops {
 
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					int nvqs, size_t size, const char *name);
+					int nvqs, size_t size,
+					const char *name, bool use_va);
 
-#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs, name)   \
+#define vdpa_alloc_device(dev_struct, member, parent, config, \
+			  nvqs, name, use_va) \
 			  container_of(__vdpa_alloc_device( \
 				       parent, config, nvqs, \
 				       sizeof(dev_struct) + \
 				       BUILD_BUG_ON_ZERO(offsetof( \
-				       dev_struct, member)), name), \
+				       dev_struct, member)), name, use_va), \
 				       dev_struct, member)
 
 int vdpa_register_device(struct vdpa_device *vdev);
-- 
2.11.0

