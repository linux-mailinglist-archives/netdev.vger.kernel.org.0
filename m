Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69CB6D6295
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbjDDNSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbjDDNS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:18:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718BA40CD
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680614253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VVAueuORiKGKOw5iPuuD3Ux7+pQ6EAyahLBg2nxd2sw=;
        b=buBf2V3LSWF66e3LXPX8JEDZhxD+thOEKyLRq2UO7iTKubv1dJvp8OC5j1JslMkOALgQ41
        ExvJiBRH/zugASMSwukqxCulBzBgFkN4q7N2I6NNL9Ekk96nO7qDLPhB2zXOeVM0Ws7hMm
        8loEEufcrmbxBg5PKQv9yFjqmtQuzjA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-7lud_ondOQ-fTNcjQqHsug-1; Tue, 04 Apr 2023 09:17:30 -0400
X-MC-Unique: 7lud_ondOQ-fTNcjQqHsug-1
Received: by mail-qt1-f197.google.com with SMTP id f36-20020a05622a1a2400b003deb2fa544bso22177821qtb.0
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 06:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680614250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VVAueuORiKGKOw5iPuuD3Ux7+pQ6EAyahLBg2nxd2sw=;
        b=jAEs1tAz27cyDT0O6GR6pMZF46D9ExU263UvQwXb3IC7Tf4N2hjEZGLe+riVkL6vSQ
         1AbxnVjF2eydb4Hu1Gr5pqd1OCHWlyhzlLx0OSCBWw7YcR8k9MBQtF2/JaxDKXOtbJ0z
         Vvsu3syPBEyCRmW9cJq+kzRa70zrylZcoKddL0u0FNQ2KU4lxOQe09eDXhRg588GfPmT
         8TeNhj/7AnZUDJ4w64acqcSGiAx7l4eyzmGrjKIfvX+v9eOfzy3nCY0u2npo23hZJxUZ
         wKIsM5zA7uf8T8AiIpA3SnHD6W0eAiJj7ACsi38zboW3dTmYkA1fNRU7DI72HPo8OqZ5
         Ad/A==
X-Gm-Message-State: AAQBX9esMwncAH3Wdhh2Pg5xDdy7B8UXtFNhVWqiFrYZd0ljKd9++lpE
        DohpJpCP6jKrDrQzQ3PO36baHu9f7ECP00nHcLk60zTTi8sc8Axt2kPIBSu6fPkloG8VH8wRz5J
        x8BWM5riWNxIIRwA3
X-Received: by 2002:ad4:4ea1:0:b0:5e0:30cc:8305 with SMTP id ed1-20020ad44ea1000000b005e030cc8305mr4392639qvb.3.1680614249887;
        Tue, 04 Apr 2023 06:17:29 -0700 (PDT)
X-Google-Smtp-Source: AKy350YduoPEsDNfhywI6pTsbGEgxxUAEQzouDgh6xMHvG5Fhh2pSHyAQuNU1HO2BvLwhdwcU+JXVQ==
X-Received: by 2002:ad4:4ea1:0:b0:5e0:30cc:8305 with SMTP id ed1-20020ad44ea1000000b005e030cc8305mr4392609qvb.3.1680614249664;
        Tue, 04 Apr 2023 06:17:29 -0700 (PDT)
Received: from step1.redhat.com (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id jh14-20020a0562141fce00b005dd8b9345b6sm3386975qvb.78.2023.04.04.06.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 06:17:28 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, eperezma@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v5 7/9] vdpa_sim: use kthread worker
Date:   Tue,  4 Apr 2023 15:17:25 +0200
Message-Id: <20230404131725.45908-1-sgarzare@redhat.com>
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

Let's use our own kthread to run device jobs.
This allows us more flexibility, especially we can attach the kthread
to the user address space when vDPA uses user's VA.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v3:
    - fix `dev` not initialized in the error path [Simon Horman]

 drivers/vdpa/vdpa_sim/vdpa_sim.h |  3 ++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 19 +++++++++++++------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index acee20faaf6a..ce83f9130a5d 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -57,7 +57,8 @@ struct vdpasim_dev_attr {
 struct vdpasim {
 	struct vdpa_device vdpa;
 	struct vdpasim_virtqueue *vqs;
-	struct work_struct work;
+	struct kthread_worker *worker;
+	struct kthread_work work;
 	struct vdpasim_dev_attr dev_attr;
 	/* spinlock to synchronize virtqueue state */
 	spinlock_t lock;
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 2df5227e0b62..bd9f9054de94 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -11,8 +11,8 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/dma-map-ops.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
@@ -127,7 +127,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
 static const struct vdpa_config_ops vdpasim_config_ops;
 static const struct vdpa_config_ops vdpasim_batch_config_ops;
 
-static void vdpasim_work_fn(struct work_struct *work)
+static void vdpasim_work_fn(struct kthread_work *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
 
@@ -170,11 +170,17 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 
 	vdpasim = vdpa_to_sim(vdpa);
 	vdpasim->dev_attr = *dev_attr;
-	INIT_WORK(&vdpasim->work, vdpasim_work_fn);
+	dev = &vdpasim->vdpa.dev;
+
+	kthread_init_work(&vdpasim->work, vdpasim_work_fn);
+	vdpasim->worker = kthread_create_worker(0, "vDPA sim worker: %s",
+						dev_attr->name);
+	if (IS_ERR(vdpasim->worker))
+		goto err_iommu;
+
 	spin_lock_init(&vdpasim->lock);
 	spin_lock_init(&vdpasim->iommu_lock);
 
-	dev = &vdpasim->vdpa.dev;
 	dev->dma_mask = &dev->coherent_dma_mask;
 	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)))
 		goto err_iommu;
@@ -223,7 +229,7 @@ EXPORT_SYMBOL_GPL(vdpasim_create);
 
 void vdpasim_schedule_work(struct vdpasim *vdpasim)
 {
-	schedule_work(&vdpasim->work);
+	kthread_queue_work(vdpasim->worker, &vdpasim->work);
 }
 EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
 
@@ -623,7 +629,8 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int i;
 
-	cancel_work_sync(&vdpasim->work);
+	kthread_cancel_work_sync(&vdpasim->work);
+	kthread_destroy_worker(vdpasim->worker);
 
 	for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
 		vringh_kiov_cleanup(&vdpasim->vqs[i].out_iov);
-- 
2.39.2

