Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30FA6D629D
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbjDDNSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbjDDNSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:18:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AC62709
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680614263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gKYp+kOgUX/GJB2EDtARo8NYPrwRtHr03kQCkOwXG8g=;
        b=CEzs8Z0n2Lx2jz57wuJgBk6zAWKq6MZ+HnRtIPTZMlLVnxSObhFudhW1K40cJezqcaLYM+
        yx7A/PCmULuBedbXAs/l2exENSk3TTijJ7RQ72BvlZSRb7CXncq91Wl2ufI0Ln0aX9ae0/
        j0tEJFWmAX1D58HAME/v+4L6PR30SS0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-1drDmJmqOga34-JxJnUYVw-1; Tue, 04 Apr 2023 09:17:40 -0400
X-MC-Unique: 1drDmJmqOga34-JxJnUYVw-1
Received: by mail-qk1-f199.google.com with SMTP id d187-20020a3768c4000000b00746864b272cso14685828qkc.15
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 06:17:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680614259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKYp+kOgUX/GJB2EDtARo8NYPrwRtHr03kQCkOwXG8g=;
        b=6vMC2UmEUTktwVSYLK+FUSTdky11mOrc1OQl15sgNT95xqmBMU1UNPZIgklIc2SFa/
         KY8MtXyuEuxVeFWRVMc1NgIXi3DlOYdAhWAGBiZYs8Op/iqMegtCpaHwApmrMHRTAmmv
         YJto10zRT5kgO4KqseheQbIq5T76cxUc3aqaC46PASaZ7hJeTlTO8+ojyilKSD8lyy+j
         IWXnj/pE4M8xXyI/vMA4H7OhFcS4lEJE5RqX5op15CLR4/RhSR/AFbbm2Lts6nyeG4l2
         JGlksm0LL3xuMrFpcIL+lrGwndbHh0jgggBqiAchdZlcjtHtNm9aLkRHBQ0rKHVEZxL2
         muOQ==
X-Gm-Message-State: AAQBX9d3VctQzj42WpxIY2aeviuxPaEoZEnDPnHL0XoqmzPBdVk+iIJa
        uIdn+6YPqcfxsO6Y9zq8bcihlI0KJ2XdCLWSG0kGA3Wi0dEhJcCG4NoruXfVW9u/E6l6pY7DZW7
        oVojrFfzSL4PYqsmW
X-Received: by 2002:a05:6214:2348:b0:5e0:2461:d313 with SMTP id hu8-20020a056214234800b005e02461d313mr3635653qvb.13.1680614259100;
        Tue, 04 Apr 2023 06:17:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZQHHw9QMgxTDZ7Gx0mKxPm59F+7zD2PSm56JxGEVUgQJCxRQ0usDmkGmew2XpIoXpNgEcGmQ==
X-Received: by 2002:a05:6214:2348:b0:5e0:2461:d313 with SMTP id hu8-20020a056214234800b005e02461d313mr3635618qvb.13.1680614258783;
        Tue, 04 Apr 2023 06:17:38 -0700 (PDT)
Received: from step1.redhat.com (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id oh4-20020a056214438400b005dd8b9345e6sm3374101qvb.126.2023.04.04.06.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 06:17:38 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, eperezma@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v5 9/9] vdpa_sim: add support for user VA
Date:   Tue,  4 Apr 2023 15:17:34 +0200
Message-Id: <20230404131734.45943-1-sgarzare@redhat.com>
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

