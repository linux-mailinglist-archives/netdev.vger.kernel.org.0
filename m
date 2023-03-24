Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24FE6C8191
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjCXPlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 11:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjCXPlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A92810265
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 08:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679672413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gKYp+kOgUX/GJB2EDtARo8NYPrwRtHr03kQCkOwXG8g=;
        b=cBn5KOpGpqpUIbnmaszgQntT2hvc7oAfIxyBdGz9rIy1VuYX7EHhLX7UCyvgkeBfsw4c2k
        H6TNYkTCf2sBQ/alI3InMAZWynIH8kcTKEr1/ZUCwSU8821XYmW5paXohhAzh+zH1uRv3S
        HFVm8Ig95mSTObl79IiKjaPJI4RIoCA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-LBp_wyejMDq9Cz7sf3hE-g-1; Fri, 24 Mar 2023 11:40:12 -0400
X-MC-Unique: LBp_wyejMDq9Cz7sf3hE-g-1
Received: by mail-ed1-f70.google.com with SMTP id i22-20020a05640242d600b004f5962985f4so3802338edc.12
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 08:40:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679672411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKYp+kOgUX/GJB2EDtARo8NYPrwRtHr03kQCkOwXG8g=;
        b=6tLuRDUIwaapu971fjll5Gj9sN6jL0M9lzATTm+X0qe8lQT1It6XyoQChDPDsL/oNv
         eOI+DkEJNg/xipBdNOSkG6gsbiUYz5wMDwcPxesISC1/xrIm96OlpWTqJ6P5yPcBwqAw
         BNhIiI85ElumY0/aVtZj+3uG5xSN8r83z5rQ0JiRl1bagAcb4rP0DBIgQsBDfQ2Ad7GK
         7hbQB1plm7RamGyTPjCobqC29is0lJe7bJO0dL0YdtV6guHbbsyQfiJSx7Vu3weWtbZu
         cXh6juW2byTzKHVf1ql5O7qPMaWWYfEu1uMDRvQ2AdTfzYea2S7Xn6m1NjtlkB6nCzAX
         eQUg==
X-Gm-Message-State: AAQBX9c5a+A0DxWqG69DBIhNm2X4vHIgF5pnpa5D2iDNXGA4uuwfM5dv
        7gzUumtipq65B0tBvPjOkg/yQNpR0GoZpybE+ramwjbpriYAQnGyyNNQyhNuaZE2Y+PnjfH5VC4
        a+YrmIhGlVdaSIQJm
X-Received: by 2002:a17:907:161f:b0:932:7f5c:4bb2 with SMTP id hb31-20020a170907161f00b009327f5c4bb2mr3662673ejc.75.1679672410843;
        Fri, 24 Mar 2023 08:40:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350bOoCuwJSj7M6y3xIb2GqOaJXnqsAm1iiu9XIoxjTNWkiXIxcyzzt0vuR0WGchtmVY+X6sMOg==
X-Received: by 2002:a17:907:161f:b0:932:7f5c:4bb2 with SMTP id hb31-20020a170907161f00b009327f5c4bb2mr3662649ejc.75.1679672410627;
        Fri, 24 Mar 2023 08:40:10 -0700 (PDT)
Received: from localhost.localdomain (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id rk28-20020a170907215c00b00933b38505f9sm7857073ejb.152.2023.03.24.08.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 08:40:09 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        Jason Wang <jasowang@redhat.com>, eperezma@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v4 9/9] vdpa_sim: add support for user VA
Date:   Fri, 24 Mar 2023 16:40:00 +0100
Message-Id: <20230324154000.47809-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324153607.46836-1-sgarzare@redhat.com>
References: <20230324153607.46836-1-sgarzare@redhat.com>
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

The new "use_va" module parameter (default: true) is used in
vdpa_alloc_device() to inform the vDPA framework that the device
supports VA.

vringh is initialized to use VA only when "use_va" is true and the
user's mm has been bound. So, only when the bus supports user VA
(e.g. vhost-vdpa).

vdpasim_mm_work_fn work is used to serialize the binding to a new
address space when the .bind_mm callback is invoked, and unbinding
when the .unbind_mm callback is invoked.

Call mmget_not_zero()/kthread_use_mm() inside the worker function
to pin the address space only as long as needed, following the
documentation of mmget() in include/linux/sched/mm.h:

  * Never use this function to pin this address space for an
  * unbounded/indefinite amount of time.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v4:
    - checked `use_va` in vdpasim_work_fn() [Jason]
    - removed `va_enabled` variable now used only in the if condition
    v3:
    - called mmget_not_zero() before kthread_use_mm() [Jason]
      As the documentation of mmget() in include/linux/sched/mm.h says:
    
      * Never use this function to pin this address space for an
      * unbounded/indefinite amount of time.
    
      I moved mmget_not_zero/kthread_use_mm inside the worker function,
      this way we pin the address space only as long as needed.
      This is similar to what vfio_iommu_type1_dma_rw_chunk() does in
      drivers/vfio/vfio_iommu_type1.c
    - simplified the mm bind/unbind [Jason]
    - renamed vdpasim_worker_change_mm_sync() [Jason]
    - fix commit message (s/default: false/default: true)
    v2:
    - `use_va` set to true by default [Eugenio]
    - supported the new unbind_mm callback [Jason]
    - removed the unbind_mm call in vdpasim_do_reset() [Jason]
    - avoided to release the lock while call kthread_flush_work() since we
      are now using a mutex to protect the device state

 drivers/vdpa/vdpa_sim/vdpa_sim.h |  1 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 97 +++++++++++++++++++++++++++++---
 2 files changed, 90 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index 4774292fba8c..3a42887d05d9 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -59,6 +59,7 @@ struct vdpasim {
 	struct vdpasim_virtqueue *vqs;
 	struct kthread_worker *worker;
 	struct kthread_work work;
+	struct mm_struct *mm_bound;
 	struct vdpasim_dev_attr dev_attr;
 	/* mutex to synchronize virtqueue state */
 	struct mutex mutex;
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 2b2e439a66f7..2c706bb18897 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -35,10 +35,44 @@ module_param(max_iotlb_entries, int, 0444);
 MODULE_PARM_DESC(max_iotlb_entries,
 		 "Maximum number of iotlb entries for each address space. 0 means unlimited. (default: 2048)");
 
+static bool use_va = true;
+module_param(use_va, bool, 0444);
+MODULE_PARM_DESC(use_va, "Enable/disable the device's ability to use VA");
+
 #define VDPASIM_QUEUE_ALIGN PAGE_SIZE
 #define VDPASIM_QUEUE_MAX 256
 #define VDPASIM_VENDOR_ID 0
 
+struct vdpasim_mm_work {
+	struct kthread_work work;
+	struct vdpasim *vdpasim;
+	struct mm_struct *mm_to_bind;
+	int ret;
+};
+
+static void vdpasim_mm_work_fn(struct kthread_work *work)
+{
+	struct vdpasim_mm_work *mm_work =
+		container_of(work, struct vdpasim_mm_work, work);
+	struct vdpasim *vdpasim = mm_work->vdpasim;
+
+	mm_work->ret = 0;
+
+	//TODO: should we attach the cgroup of the mm owner?
+	vdpasim->mm_bound = mm_work->mm_to_bind;
+}
+
+static void vdpasim_worker_change_mm_sync(struct vdpasim *vdpasim,
+					  struct vdpasim_mm_work *mm_work)
+{
+	struct kthread_work *work = &mm_work->work;
+
+	kthread_init_work(work, vdpasim_mm_work_fn);
+	kthread_queue_work(vdpasim->worker, work);
+
+	kthread_flush_work(work);
+}
+
 static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
 {
 	return container_of(vdpa, struct vdpasim, vdpa);
@@ -59,13 +93,20 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 {
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 	uint16_t last_avail_idx = vq->vring.last_avail_idx;
-
-	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
-			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
-			  (struct vring_avail *)
-			  (uintptr_t)vq->driver_addr,
-			  (struct vring_used *)
-			  (uintptr_t)vq->device_addr);
+	struct vring_desc *desc = (struct vring_desc *)
+				  (uintptr_t)vq->desc_addr;
+	struct vring_avail *avail = (struct vring_avail *)
+				    (uintptr_t)vq->driver_addr;
+	struct vring_used *used = (struct vring_used *)
+				  (uintptr_t)vq->device_addr;
+
+	if (use_va && vdpasim->mm_bound) {
+		vringh_init_iotlb_va(&vq->vring, vdpasim->features, vq->num,
+				     true, desc, avail, used);
+	} else {
+		vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num,
+				  true, desc, avail, used);
+	}
 
 	vq->vring.last_avail_idx = last_avail_idx;
 
@@ -130,8 +171,20 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops;
 static void vdpasim_work_fn(struct kthread_work *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
+	struct mm_struct *mm = vdpasim->mm_bound;
+
+	if (use_va && mm) {
+		if (!mmget_not_zero(mm))
+			return;
+		kthread_use_mm(mm);
+	}
 
 	vdpasim->dev_attr.work_fn(vdpasim);
+
+	if (use_va && mm) {
+		kthread_unuse_mm(mm);
+		mmput(mm);
+	}
 }
 
 struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
@@ -162,7 +215,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 	vdpa = __vdpa_alloc_device(NULL, ops,
 				   dev_attr->ngroups, dev_attr->nas,
 				   dev_attr->alloc_size,
-				   dev_attr->name, false);
+				   dev_attr->name, use_va);
 	if (IS_ERR(vdpa)) {
 		ret = PTR_ERR(vdpa);
 		goto err_alloc;
@@ -582,6 +635,30 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 	return ret;
 }
 
+static int vdpasim_bind_mm(struct vdpa_device *vdpa, struct mm_struct *mm)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+	struct vdpasim_mm_work mm_work;
+
+	mm_work.vdpasim = vdpasim;
+	mm_work.mm_to_bind = mm;
+
+	vdpasim_worker_change_mm_sync(vdpasim, &mm_work);
+
+	return mm_work.ret;
+}
+
+static void vdpasim_unbind_mm(struct vdpa_device *vdpa)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+	struct vdpasim_mm_work mm_work;
+
+	mm_work.vdpasim = vdpasim;
+	mm_work.mm_to_bind = NULL;
+
+	vdpasim_worker_change_mm_sync(vdpasim, &mm_work);
+}
+
 static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
 			   u64 iova, u64 size,
 			   u64 pa, u32 perm, void *opaque)
@@ -678,6 +755,8 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.set_group_asid         = vdpasim_set_group_asid,
 	.dma_map                = vdpasim_dma_map,
 	.dma_unmap              = vdpasim_dma_unmap,
+	.bind_mm		= vdpasim_bind_mm,
+	.unbind_mm		= vdpasim_unbind_mm,
 	.free                   = vdpasim_free,
 };
 
@@ -712,6 +791,8 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.get_iova_range         = vdpasim_get_iova_range,
 	.set_group_asid         = vdpasim_set_group_asid,
 	.set_map                = vdpasim_set_map,
+	.bind_mm		= vdpasim_bind_mm,
+	.unbind_mm		= vdpasim_unbind_mm,
 	.free                   = vdpasim_free,
 };
 
-- 
2.39.2

