Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CE73D9EAC
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhG2HhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbhG2Hgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:36:46 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A20BC061383
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:36:40 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so14306167pjb.0
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t/Mv+HEad+Mm0KXM51+RZNvY/SJHCBiAHseh+BVH8NU=;
        b=m90svpJzE0nzBWjlFAdvM3aAFHtWP/DlxqcYbayFc782jYlMWShvCEVJ0CTahZE/4c
         OFcZuIKMRY7g/484tMHPBybe/0F58rG2ian0mz6D2JwKCvUXXG0YIQIgDOENccOXypun
         5n1IX472knippk8leuZrYqHK0NPdOkkBE9wzi/IOAvv/VaXFlofWyjGV7EAW2m1Cdjmc
         riCH1qwqxWeaz29T80miRK27dO8k6o3PtY2CGlFq/NE13QmSrReo7eR7gBPi8fS9c1P8
         y351q7SiHU47741aY4t6v82hxTS7BcTp9jciEVxgSv8YcKn8TV94Lr6dI+nWRMf2NQCz
         5x2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t/Mv+HEad+Mm0KXM51+RZNvY/SJHCBiAHseh+BVH8NU=;
        b=K8q7kBatY1Oa1YpFzG2kaaOqZpOU/BPZZlum6biOi+YYOwN5VeKxjico2IDjVB7v9/
         rZ4EACqwL44cIsXvlL3PfGE3Qj5AQpoo6w868pp5JCJmk8/8S3GrwsH+kYR+1c8ekG1j
         W/UA+1kZ+1xFIbUQr4W6kZ9wvNwNwFGZhfCgLlyGvd+JLK+R2ryr/ZlU9j0rihngvmDA
         qkal8qWBcF5UM7PV6k6vDqOLk+exq3qJCICWpZ0GgKq2msA/lfeT3UpDAnCYB6EIkYRz
         hwttgxAYxfw/wZnj2jX/j91fhejf6ZERzp3t6hHgsI6OUvM3UwyZVluaV9jj29yxt+bW
         JZfg==
X-Gm-Message-State: AOAM533j+mUliZ3gZXEhNp/JXQ+EMRMkolYV5AnQy4g5h9CMzSeLk3ca
        RKedBx03FcVrTQTH3fOLSRdb
X-Google-Smtp-Source: ABdhPJyhmuXfKE1NaeP74fAHMH1dtIHSozYXkqdngLO3jW1LBkz8W+OaQ0EIVcLXjVhhD5uH00JunQ==
X-Received: by 2002:a17:902:e742:b029:12b:5431:24fe with SMTP id p2-20020a170902e742b029012b543124femr3584330plf.20.1627544199577;
        Thu, 29 Jul 2021 00:36:39 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id dw15sm2121343pjb.42.2021.07.29.00.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:36:39 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 08/17] virtio_config: Add a return value to reset function
Date:   Thu, 29 Jul 2021 15:34:54 +0800
Message-Id: <20210729073503.187-9-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729073503.187-1-xieyongji@bytedance.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a return value to reset function so that we can
handle the reset failure later. No functional changes.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 arch/um/drivers/virtio_uml.c             | 4 +++-
 drivers/platform/mellanox/mlxbf-tmfifo.c | 4 +++-
 drivers/remoteproc/remoteproc_virtio.c   | 4 +++-
 drivers/s390/virtio/virtio_ccw.c         | 6 ++++--
 drivers/virtio/virtio_mmio.c             | 4 +++-
 drivers/virtio/virtio_pci_legacy.c       | 4 +++-
 drivers/virtio/virtio_pci_modern.c       | 4 +++-
 drivers/virtio/virtio_vdpa.c             | 4 +++-
 include/linux/virtio_config.h            | 3 ++-
 9 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 4412d6febade..ca02deaf9b32 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -828,11 +828,13 @@ static void vu_set_status(struct virtio_device *vdev, u8 status)
 	vu_dev->status = status;
 }
 
-static void vu_reset(struct virtio_device *vdev)
+static int vu_reset(struct virtio_device *vdev)
 {
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
 
 	vu_dev->status = 0;
+
+	return 0;
 }
 
 static void vu_del_vq(struct virtqueue *vq)
diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index 38800e86ed8a..e3c513c2d4fa 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -989,11 +989,13 @@ static void mlxbf_tmfifo_virtio_set_status(struct virtio_device *vdev,
 }
 
 /* Reset the device. Not much here for now. */
-static void mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
+static int mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
 {
 	struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
 
 	tm_vdev->status = 0;
+
+	return 0;
 }
 
 /* Read the value of a configuration field. */
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index cf4d54e98e6a..975c845b3187 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -191,7 +191,7 @@ static void rproc_virtio_set_status(struct virtio_device *vdev, u8 status)
 	dev_dbg(&vdev->dev, "status: %d\n", status);
 }
 
-static void rproc_virtio_reset(struct virtio_device *vdev)
+static int rproc_virtio_reset(struct virtio_device *vdev)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 	struct fw_rsc_vdev *rsc;
@@ -200,6 +200,8 @@ static void rproc_virtio_reset(struct virtio_device *vdev)
 
 	rsc->status = 0;
 	dev_dbg(&vdev->dev, "reset !\n");
+
+	return 0;
 }
 
 /* provide the vdev features as retrieved from the firmware */
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index d35e7a3f7067..5221cdad531d 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -710,14 +710,14 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	return ret;
 }
 
-static void virtio_ccw_reset(struct virtio_device *vdev)
+static int virtio_ccw_reset(struct virtio_device *vdev)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct ccw1 *ccw;
 
 	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
 	if (!ccw)
-		return;
+		return -ENOMEM;
 
 	/* Zero status bits. */
 	vcdev->dma_area->status = 0;
@@ -729,6 +729,8 @@ static void virtio_ccw_reset(struct virtio_device *vdev)
 	ccw->cda = 0;
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
 	ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
+
+	return 0;
 }
 
 static u64 virtio_ccw_get_features(struct virtio_device *vdev)
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 56128b9c46eb..c0a65efa4a65 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -256,12 +256,14 @@ static void vm_set_status(struct virtio_device *vdev, u8 status)
 	writel(status, vm_dev->base + VIRTIO_MMIO_STATUS);
 }
 
-static void vm_reset(struct virtio_device *vdev)
+static int vm_reset(struct virtio_device *vdev)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 
 	/* 0 status means a reset. */
 	writel(0, vm_dev->base + VIRTIO_MMIO_STATUS);
+
+	return 0;
 }
 
 
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index d62e9835aeec..0b5d95e3efa1 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -89,7 +89,7 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 }
 
-static void vp_reset(struct virtio_device *vdev)
+static int vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	/* 0 status means a reset. */
@@ -99,6 +99,8 @@ static void vp_reset(struct virtio_device *vdev)
 	ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
+
+	return 0;
 }
 
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 30654d3a0b41..b0cde3b2f0ff 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -158,7 +158,7 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	vp_modern_set_status(&vp_dev->mdev, status);
 }
 
-static void vp_reset(struct virtio_device *vdev)
+static int vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
@@ -174,6 +174,8 @@ static void vp_reset(struct virtio_device *vdev)
 		msleep(1);
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
+
+	return 0;
 }
 
 static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index ff43f9b62b2f..3e666f70e829 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -97,11 +97,13 @@ static void virtio_vdpa_set_status(struct virtio_device *vdev, u8 status)
 	return ops->set_status(vdpa, status);
 }
 
-static void virtio_vdpa_reset(struct virtio_device *vdev)
+static int virtio_vdpa_reset(struct virtio_device *vdev)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
 	vdpa_reset(vdpa);
+
+	return 0;
 }
 
 static bool virtio_vdpa_notify(struct virtqueue *vq)
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 8519b3ae5d52..203407992c30 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -47,6 +47,7 @@ struct virtio_shm_region {
  *	After this, status and feature negotiation must be done again
  *	Device must not be reset from its vq/config callbacks, or in
  *	parallel with being added/removed.
+ *	Returns 0 on success or error status
  * @find_vqs: find virtqueues and instantiate them.
  *	vdev: the virtio_device
  *	nvqs: the number of virtqueues to find
@@ -82,7 +83,7 @@ struct virtio_config_ops {
 	u32 (*generation)(struct virtio_device *vdev);
 	u8 (*get_status)(struct virtio_device *vdev);
 	void (*set_status)(struct virtio_device *vdev, u8 status);
-	void (*reset)(struct virtio_device *vdev);
+	int (*reset)(struct virtio_device *vdev);
 	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
 			struct virtqueue *vqs[], vq_callback_t *callbacks[],
 			const char * const names[], const bool *ctx,
-- 
2.11.0

