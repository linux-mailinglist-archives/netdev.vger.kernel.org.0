Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704346C3633
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjCUPtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCUPtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:49:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABE950FAD
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679413696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qQNTryMkijjvv0zrmCG/46urX2+Q+d1Ofd7Juu04IrA=;
        b=iiawttliNbbLhv0B9+RWRYgZEkCM2VcgVKrzeraJ2vS75gt6k6Cu4NlVwOrzgmK60d7kjE
        TMizqUMD+epfCYDOWNr/KRSq6IfJu1bs7Wbx98WYUWjPQ977fCtCrNU+Qoocx1LNApV9b7
        z9ushf4nDjP9vpkk8z4ozEnkhBjdcLs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-De3p0wZ9OXO48eb7uW9Rcg-1; Tue, 21 Mar 2023 11:48:14 -0400
X-MC-Unique: De3p0wZ9OXO48eb7uW9Rcg-1
Received: by mail-wm1-f70.google.com with SMTP id fl22-20020a05600c0b9600b003ed26ca6206so10207760wmb.2
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679413693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qQNTryMkijjvv0zrmCG/46urX2+Q+d1Ofd7Juu04IrA=;
        b=qZrRk54tjpty0X62UoB7tPGU6bwXC5CCUYRAoBH9jdKbxQ6vFImxIbZzgsU30S1BF2
         NdV1KCSYkgnMA7kjQ0EzgBYMX5Ec3gN3/V3Bu4EGEFsiudQwofwhRcWeSUts4RL6BM5S
         ABZ4vRqM887peclg8K4ziscfEi5wIMA9FKXgtaXTKIY2+qXi5IcZ+6RDUacb+CtWT/99
         iBcDyDNcZcYhFC94e+VrsWaK4+QorESi4e3ttu2E2EX4fpj5ppa+PI/M09hV+BFwbFJh
         H6hMyYqedXtZCkoVUqSJPrKwCHmaYdTq8yLvD8jVoRy0a6wldmOHbH5gVDHRnVTueB1f
         ZvNg==
X-Gm-Message-State: AO0yUKVevDLMd14HburIeXWRVLh9RrnjrJ5kxEM8+F+cPXqoM276UnJ1
        xaMYgSWQG/od3xSVVQmFpUJD9RVA2//B96CGvhCqbWjv7n5/8nL7LuGHJI1KWuGAoGsQ1W9bvVn
        kxp9IgtTwYZGWF5QK
X-Received: by 2002:adf:dd0e:0:b0:2d8:a55e:1fd7 with SMTP id a14-20020adfdd0e000000b002d8a55e1fd7mr2462138wrm.21.1679413693506;
        Tue, 21 Mar 2023 08:48:13 -0700 (PDT)
X-Google-Smtp-Source: AK7set/xI0H0dOoLdAbl2l/hpTPg6jU0iUTNn4I4nwVi9pUuko/W56u8IgfhRZaIVSLS5/ma3hJA/Q==
X-Received: by 2002:adf:dd0e:0:b0:2d8:a55e:1fd7 with SMTP id a14-20020adfdd0e000000b002d8a55e1fd7mr2462125wrm.21.1679413693229;
        Tue, 21 Mar 2023 08:48:13 -0700 (PDT)
Received: from step1.redhat.com (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm11692694wrr.84.2023.03.21.08.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 08:48:12 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        stefanha@redhat.com, linux-kernel@vger.kernel.org,
        eperezma@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v3 8/8] vdpa_sim: add support for user VA
Date:   Tue, 21 Mar 2023 16:48:04 +0100
Message-Id: <20230321154804.184577-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321154804.184577-1-sgarzare@redhat.com>
References: <20230321154228.182769-1-sgarzare@redhat.com>
 <20230321154804.184577-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
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
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 80 +++++++++++++++++++++++++++++++-
 2 files changed, 79 insertions(+), 2 deletions(-)

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
index ab4cfb82c237..23c891cdcd54 100644
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
@@ -59,8 +93,10 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 {
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 	uint16_t last_avail_idx = vq->vring.last_avail_idx;
+	bool va_enabled = use_va && vdpasim->mm_bound;
 
-	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, false,
+	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
+			  va_enabled,
 			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
 			  (struct vring_avail *)
 			  (uintptr_t)vq->driver_addr,
@@ -130,8 +166,20 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops;
 static void vdpasim_work_fn(struct kthread_work *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
+	struct mm_struct *mm = vdpasim->mm_bound;
+
+	if (mm) {
+		if (!mmget_not_zero(mm))
+			return;
+		kthread_use_mm(mm);
+	}
 
 	vdpasim->dev_attr.work_fn(vdpasim);
+
+	if (mm) {
+		kthread_unuse_mm(mm);
+		mmput(mm);
+	}
 }
 
 struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
@@ -162,7 +210,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 	vdpa = __vdpa_alloc_device(NULL, ops,
 				   dev_attr->ngroups, dev_attr->nas,
 				   dev_attr->alloc_size,
-				   dev_attr->name, false);
+				   dev_attr->name, use_va);
 	if (IS_ERR(vdpa)) {
 		ret = PTR_ERR(vdpa);
 		goto err_alloc;
@@ -582,6 +630,30 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
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
@@ -678,6 +750,8 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.set_group_asid         = vdpasim_set_group_asid,
 	.dma_map                = vdpasim_dma_map,
 	.dma_unmap              = vdpasim_dma_unmap,
+	.bind_mm		= vdpasim_bind_mm,
+	.unbind_mm		= vdpasim_unbind_mm,
 	.free                   = vdpasim_free,
 };
 
@@ -712,6 +786,8 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.get_iova_range         = vdpasim_get_iova_range,
 	.set_group_asid         = vdpasim_set_group_asid,
 	.set_map                = vdpasim_set_map,
+	.bind_mm		= vdpasim_bind_mm,
+	.unbind_mm		= vdpasim_unbind_mm,
 	.free                   = vdpasim_free,
 };
 
-- 
2.39.2

