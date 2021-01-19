Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8B12FB415
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389157AbhASFYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 00:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389390AbhASFG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 00:06:57 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BC3C061799
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:04:53 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y205so5690751pfc.5
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U0120iNFu1UQ+XQP2804t9yWUT9nyzP1s7JWVirZ0CQ=;
        b=tT/tmNAi6NU57xmHjfGmqHgX95hCN5stlPBS4x34MDgSRzGJgUPlWjosZg+6PyfxjO
         IlCL7iHuRliYzhRIUJwqVTWRZl33hJvmOwmriMEbSe8wcZxoyWzpiSsyMJjN59tnB6yK
         PPMsjJIyNWtdFwH4fXQAEjDjWjDvv/QoSFx+BpJjhKLG5bk2eHnhh3/IMNIoj7J3zH/U
         kQegq2euiTFuF9uqisspaevugD1zMGgphJ3VAW+xVbApOGXlsUBgHcU+0uBphjIjnbvF
         99auMuVMqsaT7A8eptrh9JDdjA7uJnYlGEhuScmBxfPlLzwx4zdrr4WesSpAulQibsru
         5Lcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U0120iNFu1UQ+XQP2804t9yWUT9nyzP1s7JWVirZ0CQ=;
        b=Pgh4VRR6As0z1L0l7t5Umn3r8PJVVF+OUHlVxZtA2sM0cKv+SNRjz4YB76A7iITKSW
         bdNsAgo1wdd4U2m1VhsOw4G66Bsfl0mYA0pineNlo9YLJ+OjY/99uGNpO0gHLX2dBcFc
         wHpwoxs6sjs1xiFIdMEIu0B/sQkZvTCRodMySkW0H4zqloE/f6rqhzdVCaSnPgU5+Ua9
         F4WEuuzAxVhD0T5LZabFiAz7CLSk47L2pXghGT7p2dRnjBtlDsQbJJu/cqnIuI05/YNL
         1vuPb1BLU8u9b+VmpRkhiYNGBPSWAKmoAuAyIypYOIcnQglLZE/fCTpyQYv+QsC0M9sX
         2jeg==
X-Gm-Message-State: AOAM533HavGTU2CJc+tcjNpEqjzYkqVziMrpItLL23x/Tgz2Xw9RYPXM
        PsArZCt80x6Bm0G+sUNt85iV
X-Google-Smtp-Source: ABdhPJz29+5qkk0tFpBdHE1YKxTcsaEJOC9RJCsgQpfbCkBSRwz57KBR46or6uBk7ojXObygUicQrg==
X-Received: by 2002:a63:d601:: with SMTP id q1mr2833194pgg.417.1611032692863;
        Mon, 18 Jan 2021 21:04:52 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id ob6sm1047360pjb.30.2021.01.18.21.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:04:52 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 05/11] vdpa: shared virtual addressing support
Date:   Tue, 19 Jan 2021 12:59:14 +0800
Message-Id: <20210119045920.447-6-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119045920.447-1-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patches introduces SVA (Shared Virtual Addressing)
support for vDPA device. During vDPA device allocation,
vDPA device driver needs to indicate whether SVA is
supported by the device. Then vhost-vdpa bus driver
will not pin user page and transfer userspace virtual
address instead of physical address during DMA mapping.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c |  2 +-
 drivers/vdpa/vdpa.c               |  5 ++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c  |  3 ++-
 drivers/vhost/vdpa.c              | 35 +++++++++++++++++++++++------------
 include/linux/vdpa.h              | 10 +++++++---
 6 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 23474af7da40..95c4601f82f5 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -439,7 +439,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
 				    dev, &ifc_vdpa_ops,
-				    IFCVF_MAX_QUEUE_PAIRS * 2, NULL);
+				    IFCVF_MAX_QUEUE_PAIRS * 2, NULL, false);
 	if (adapter == NULL) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
 		return -ENOMEM;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 77595c81488d..05988d6907f2 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1959,7 +1959,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
 
 	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
-				 2 * mlx5_vdpa_max_qps(max_vqs), NULL);
+				 2 * mlx5_vdpa_max_qps(max_vqs), NULL, false);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
 
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 32bd48baffab..50cab930b2e5 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -72,6 +72,7 @@ static void vdpa_release_dev(struct device *d)
  * @nvqs: number of virtqueues supported by this device
  * @size: size of the parent structure that contains private data
  * @name: name of the vdpa device; optional.
+ * @sva: indicate whether SVA (Shared Virtual Addressing) is supported
  *
  * Driver should use vdpa_alloc_device() wrapper macro instead of
  * using this directly.
@@ -81,7 +82,8 @@ static void vdpa_release_dev(struct device *d)
  */
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					int nvqs, size_t size, const char *name)
+					int nvqs, size_t size, const char *name,
+					bool sva)
 {
 	struct vdpa_device *vdev;
 	int err = -EINVAL;
@@ -108,6 +110,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 	vdev->config = config;
 	vdev->features_valid = false;
 	vdev->nvqs = nvqs;
+	vdev->sva = sva;
 
 	if (name)
 		err = dev_set_name(&vdev->dev, "%s", name);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 85776e4e6749..03c796873a6b 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -367,7 +367,8 @@ static struct vdpasim *vdpasim_create(const char *name)
 	else
 		ops = &vdpasim_net_config_ops;
 
-	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, VDPASIM_VQ_NUM, name);
+	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
+				VDPASIM_VQ_NUM, name, false);
 	if (!vdpasim)
 		goto err_alloc;
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 4a241d380c40..36b6950ba37f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -486,21 +486,25 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 {
 	struct vhost_dev *dev = &v->vdev;
+	struct vdpa_device *vdpa = v->vdpa;
 	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct vhost_iotlb_map *map;
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
+		if (!vdpa->sva) {
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
 		}
-		atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
@@ -558,13 +562,15 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
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
+	if (!vdpa->sva)
 		atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
 
-	return r;
+	return 0;
 }
 
 static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
@@ -589,6 +595,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 					   struct vhost_iotlb_msg *msg)
 {
 	struct vhost_dev *dev = &v->vdev;
+	struct vdpa_device *vdpa = v->vdpa;
 	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct page **page_list;
 	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
@@ -607,6 +614,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				    msg->iova + msg->size - 1))
 		return -EEXIST;
 
+	if (vdpa->sva)
+		return vhost_vdpa_map(v, msg->iova, msg->size,
+				      msg->uaddr, msg->perm);
+
 	/* Limit the use of memory for bookkeeping */
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
 	if (!page_list)
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index cb5a3d847af3..f86869651614 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -44,6 +44,7 @@ struct vdpa_parent_dev;
  * @config: the configuration ops for this device.
  * @index: device index
  * @features_valid: were features initialized? for legacy guests
+ * @sva: indicate whether SVA (Shared Virtual Addressing) is supported
  * @nvqs: maximum number of supported virtqueues
  * @pdev: parent device pointer; caller must setup when registering device as part
  *	  of dev_add() parentdev ops callback before invoking _vdpa_register_device().
@@ -54,6 +55,7 @@ struct vdpa_device {
 	const struct vdpa_config_ops *config;
 	unsigned int index;
 	bool features_valid;
+	bool sva;
 	int nvqs;
 	struct vdpa_parent_dev *pdev;
 };
@@ -250,14 +252,16 @@ struct vdpa_config_ops {
 
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					int nvqs, size_t size, const char *name);
+					int nvqs, size_t size,
+					const char *name, bool sva);
 
-#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs, name)   \
+#define vdpa_alloc_device(dev_struct, member, parent, config, \
+			  nvqs, name, sva) \
 			  container_of(__vdpa_alloc_device( \
 				       parent, config, nvqs, \
 				       sizeof(dev_struct) + \
 				       BUILD_BUG_ON_ZERO(offsetof( \
-				       dev_struct, member)), name), \
+				       dev_struct, member)), name, sva), \
 				       dev_struct, member)
 
 int vdpa_register_device(struct vdpa_device *vdev);
-- 
2.11.0

