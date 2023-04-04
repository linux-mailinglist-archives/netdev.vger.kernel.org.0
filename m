Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303776D629B
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbjDDNSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235190AbjDDNSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:18:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD8F420C
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680614255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQ8fDN2h9p4iTg0iFPY/+DuAnJcVPz4edknSv7QjGbU=;
        b=KHiSjet1eCLrGpX8LSKISqym8Nb+TQTse/N1v+z/uZgkEZtvOWtBBwNQax/e2u32a5COR/
        kbVBAGUxaWiYqDGLy14XZfHghrfe7LEvUrI0oXlez5K9qVw2MmT/6Xjs/IFkvSurWzlROF
        bdZZ+r/q/BpqjNKtwAIg8V9PtHqpvxo=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-bQFeW8kKOv2rsFuEAN9pLw-1; Tue, 04 Apr 2023 09:17:34 -0400
X-MC-Unique: bQFeW8kKOv2rsFuEAN9pLw-1
Received: by mail-yb1-f200.google.com with SMTP id 8-20020a250508000000b00b7c653a0a4aso24316055ybf.23
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 06:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680614254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQ8fDN2h9p4iTg0iFPY/+DuAnJcVPz4edknSv7QjGbU=;
        b=Xd0dHAsdaqvk/2UxgGW79VzSdk/3oFsdcZdOxUeYdwcNiYhbGa6inveycmo4iPRLhl
         7hrx1dEyMi5IUyeWnhdJNGicCSs7FFqR5kzHMeksnmBuYNKIYZKHAecNqmEwgNKYw8sX
         YsSI/2uwc6pKayT/Nca2hkfwlJU3qzQ6DG1j8x0xXrGETKOHjiG0lsUAs41pS4AVmmcP
         wR6QLkpy/dE0x1y54YQyn80yjs35Y7z1jEh9ON+RHOSCEviTDIcunWD/WTJUN4Zy2zEv
         iAxEhF5TA1STBbJLF5OleX61CeCXXuHRoSLc7sjauxQwq2O+CfMpyRgYVmWJ2URJRu11
         mcOw==
X-Gm-Message-State: AAQBX9cku1hvdkyW2GvXhA89qTgqtikFaGn3Jw3UZaQXGH2CHh5n7f+k
        wbXG8jvQjqYwta9lalK6Ux0+32dG77XtpEwJGIHH5wkb5g0P+tBo88NzxBB5HdAhGiBgfqZijBY
        gGAgI2IJXGlYF0UPs
X-Received: by 2002:a0d:e003:0:b0:544:9cfb:72bb with SMTP id j3-20020a0de003000000b005449cfb72bbmr2116756ywe.52.1680614254244;
        Tue, 04 Apr 2023 06:17:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350bsCle0WG2zzZfNAuJuVeI37DETAsMZmIkB4vwvojUB3+nQyroa9J5emVzIkAjvOma47Ny30A==
X-Received: by 2002:a0d:e003:0:b0:544:9cfb:72bb with SMTP id j3-20020a0de003000000b005449cfb72bbmr2116728ywe.52.1680614253971;
        Tue, 04 Apr 2023 06:17:33 -0700 (PDT)
Received: from step1.redhat.com (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id v67-20020a379346000000b007460093cccdsm3586891qkd.25.2023.04.04.06.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 06:17:33 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, eperezma@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v5 8/9] vdpa_sim: replace the spinlock with a mutex to protect the state
Date:   Tue,  4 Apr 2023 15:17:29 +0200
Message-Id: <20230404131730.45920-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404131326.44403-1-sgarzare@redhat.com>
References: <20230404131326.44403-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The spinlock we use to protect the state of the simulator is sometimes
held for a long time (for example, when devices handle requests).

This also prevents us from calling functions that might sleep (such as
kthread_flush_work() in the next patch), and thus having to release
and retake the lock.

For these reasons, let's replace the spinlock with a mutex that gives
us more flexibility.

Suggested-by: Jason Wang <jasowang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  4 ++--
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 34 ++++++++++++++--------------
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  4 ++--
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  4 ++--
 4 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index ce83f9130a5d..4774292fba8c 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -60,8 +60,8 @@ struct vdpasim {
 	struct kthread_worker *worker;
 	struct kthread_work work;
 	struct vdpasim_dev_attr dev_attr;
-	/* spinlock to synchronize virtqueue state */
-	spinlock_t lock;
+	/* mutex to synchronize virtqueue state */
+	struct mutex mutex;
 	/* virtio config according to device type */
 	void *config;
 	struct vhost_iotlb *iommu;
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index bd9f9054de94..2b2e439a66f7 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -178,7 +178,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 	if (IS_ERR(vdpasim->worker))
 		goto err_iommu;
 
-	spin_lock_init(&vdpasim->lock);
+	mutex_init(&vdpasim->mutex);
 	spin_lock_init(&vdpasim->iommu_lock);
 
 	dev->dma_mask = &dev->coherent_dma_mask;
@@ -286,13 +286,13 @@ static void vdpasim_set_vq_ready(struct vdpa_device *vdpa, u16 idx, bool ready)
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 	bool old_ready;
 
-	spin_lock(&vdpasim->lock);
+	mutex_lock(&vdpasim->mutex);
 	old_ready = vq->ready;
 	vq->ready = ready;
 	if (vq->ready && !old_ready) {
 		vdpasim_queue_ready(vdpasim, idx);
 	}
-	spin_unlock(&vdpasim->lock);
+	mutex_unlock(&vdpasim->mutex);
 }
 
 static bool vdpasim_get_vq_ready(struct vdpa_device *vdpa, u16 idx)
@@ -310,9 +310,9 @@ static int vdpasim_set_vq_state(struct vdpa_device *vdpa, u16 idx,
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 	struct vringh *vrh = &vq->vring;
 
-	spin_lock(&vdpasim->lock);
+	mutex_lock(&vdpasim->mutex);
 	vrh->last_avail_idx = state->split.avail_index;
-	spin_unlock(&vdpasim->lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return 0;
 }
@@ -409,9 +409,9 @@ static u8 vdpasim_get_status(struct vdpa_device *vdpa)
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	u8 status;
 
-	spin_lock(&vdpasim->lock);
+	mutex_lock(&vdpasim->mutex);
 	status = vdpasim->status;
-	spin_unlock(&vdpasim->lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return status;
 }
@@ -420,19 +420,19 @@ static void vdpasim_set_status(struct vdpa_device *vdpa, u8 status)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
-	spin_lock(&vdpasim->lock);
+	mutex_lock(&vdpasim->mutex);
 	vdpasim->status = status;
-	spin_unlock(&vdpasim->lock);
+	mutex_unlock(&vdpasim->mutex);
 }
 
 static int vdpasim_reset(struct vdpa_device *vdpa)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
-	spin_lock(&vdpasim->lock);
+	mutex_lock(&vdpasim->mutex);
 	vdpasim->status = 0;
 	vdpasim_do_reset(vdpasim);
-	spin_unlock(&vdpasim->lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return 0;
 }
@@ -441,9 +441,9 @@ static int vdpasim_suspend(struct vdpa_device *vdpa)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
-	spin_lock(&vdpasim->lock);
+	mutex_lock(&vdpasim->mutex);
 	vdpasim->running = false;
-	spin_unlock(&vdpasim->lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return 0;
 }
@@ -453,7 +453,7 @@ static int vdpasim_resume(struct vdpa_device *vdpa)
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int i;
 
-	spin_lock(&vdpasim->lock);
+	mutex_lock(&vdpasim->mutex);
 	vdpasim->running = true;
 
 	if (vdpasim->pending_kick) {
@@ -464,7 +464,7 @@ static int vdpasim_resume(struct vdpa_device *vdpa)
 		vdpasim->pending_kick = false;
 	}
 
-	spin_unlock(&vdpasim->lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return 0;
 }
@@ -536,14 +536,14 @@ static int vdpasim_set_group_asid(struct vdpa_device *vdpa, unsigned int group,
 
 	iommu = &vdpasim->iommu[asid];
 
-	spin_lock(&vdpasim->lock);
+	mutex_lock(&vdpasim->mutex);
 
 	for (i = 0; i < vdpasim->dev_attr.nvqs; i++)
 		if (vdpasim_get_vq_group(vdpa, i) == group)
 			vringh_set_iotlb(&vdpasim->vqs[i].vring, iommu,
 					 &vdpasim->iommu_lock);
 
-	spin_unlock(&vdpasim->lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	return 0;
 }
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index eb4897c8541e..568119e1553f 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -290,7 +290,7 @@ static void vdpasim_blk_work(struct vdpasim *vdpasim)
 	bool reschedule = false;
 	int i;
 
-	spin_lock(&vdpasim->lock);
+	mutex_lock(&vdpasim->mutex);
 
 	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
 		goto out;
@@ -321,7 +321,7 @@ static void vdpasim_blk_work(struct vdpasim *vdpasim)
 		}
 	}
 out:
-	spin_unlock(&vdpasim->lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	if (reschedule)
 		vdpasim_schedule_work(vdpasim);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index e61a9ecbfafe..7ab434592bfe 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -201,7 +201,7 @@ static void vdpasim_net_work(struct vdpasim *vdpasim)
 	u64 rx_drops = 0, rx_overruns = 0, rx_errors = 0, tx_errors = 0;
 	int err;
 
-	spin_lock(&vdpasim->lock);
+	mutex_lock(&vdpasim->mutex);
 
 	if (!vdpasim->running)
 		goto out;
@@ -264,7 +264,7 @@ static void vdpasim_net_work(struct vdpasim *vdpasim)
 	}
 
 out:
-	spin_unlock(&vdpasim->lock);
+	mutex_unlock(&vdpasim->mutex);
 
 	u64_stats_update_begin(&net->tx_stats.syncp);
 	net->tx_stats.pkts += tx_pkts;
-- 
2.39.2

