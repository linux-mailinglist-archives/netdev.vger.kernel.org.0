Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD2264CE13
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbiLNQcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239058AbiLNQbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:31:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4951525D1
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671035463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eNeRnQ41YTwI7Dv9IlQ//H1saK0wcCg2ACIcfcXrP3k=;
        b=AX1VjMqeix+dYY6ip5qDzgEGxtlxx8+xn75UrLvALhvYLQmibwZUA3/y9GtmJ9Do/SbYM1
        UbggPo6dLS7iP+NDLK4h17ID9CFb96QgzmpDKI3k5NJUGvVzMb7MyXRFsXlZTAQX3cE8fM
        jMWQ+aVuwjZzJqr1wSDuAyXUKhkbKPI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-365-pi20dwqWNxiBy2mPBTHNEQ-1; Wed, 14 Dec 2022 11:30:59 -0500
X-MC-Unique: pi20dwqWNxiBy2mPBTHNEQ-1
Received: by mail-wm1-f71.google.com with SMTP id h9-20020a1c2109000000b003cfd37aec58so6633888wmh.1
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:30:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eNeRnQ41YTwI7Dv9IlQ//H1saK0wcCg2ACIcfcXrP3k=;
        b=kwqQ6UFSsFUxAL3FEm2oVhOayUfIXOgdj53J4deNr7sBJEg0tyDjmjwHVAjtfMcnlp
         L41c1mgiNf5mOyWNhLBq3oSe5SC7bB2VNA2ASJkdz/StW+NIV7cnnm//hcitZf9vRHqE
         6F/qF0QpobLM9mTmLhTyLJRByFrWfAeI21S4TyU28gJ4c3pvjO6tPCjJl+KUk47HUivz
         h5573iZ+wiQU8cHZBgG3146EeVmWgHJQBKRobHUEiAbEo0ch8FdG0zNYj3m8OVY2NhDG
         aydKYqZKJHdk51SUebYaW9IeNBXIwOZ5uv6TNizRLEvk6IsIThIZXKhKj6GaSNquV2Z+
         KtTA==
X-Gm-Message-State: ANoB5pnJUXY0Wnwk3dMVsfFNIlnOpM/rywcbIBAzdgwe3WWsXBGqu80h
        Mw3h5gqp86OCfSxRoCqFXadfKsSfnX9B47PzHXmI+DW7k642CGMqBqBQRtYMq5WKFgRvUDLJGkU
        xtsrmnyze9gRGNhTa
X-Received: by 2002:a05:600c:3b15:b0:3d0:d177:cac1 with SMTP id m21-20020a05600c3b1500b003d0d177cac1mr19372598wms.36.1671035458590;
        Wed, 14 Dec 2022 08:30:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf41TbDFZYAxyeY/6/VgR7BHHW22n4sdvEUddOO8zMQQsvGDfuNF6JjoQjUcHxV0WQ+cml5BAg==
X-Received: by 2002:a05:600c:3b15:b0:3d0:d177:cac1 with SMTP id m21-20020a05600c3b1500b003d0d177cac1mr19372586wms.36.1671035458429;
        Wed, 14 Dec 2022 08:30:58 -0800 (PST)
Received: from step1.redhat.com (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id c6-20020a05600c0a4600b003d1e3b1624dsm3850323wmq.2.2022.12.14.08.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:30:57 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        stefanha@redhat.com, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [RFC PATCH 5/6] vdpa_sim: use kthread worker
Date:   Wed, 14 Dec 2022 17:30:24 +0100
Message-Id: <20221214163025.103075-6-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221214163025.103075-1-sgarzare@redhat.com>
References: <20221214163025.103075-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's use our own kthread to run device jobs.
This allows us more flexibility, especially we can attach the kthread
to the user address space when vDPA uses user's VA.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.h |  3 ++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 17 ++++++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index 7e6dd366856f..07ef53ea375e 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -53,7 +53,8 @@ struct vdpasim_dev_attr {
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
index 9bde33e38e27..36a1d2e0a6ba 100644
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
@@ -245,7 +245,7 @@ static const struct dma_map_ops vdpasim_dma_ops = {
 static const struct vdpa_config_ops vdpasim_config_ops;
 static const struct vdpa_config_ops vdpasim_batch_config_ops;
 
-static void vdpasim_work_fn(struct work_struct *work)
+static void vdpasim_work_fn(struct kthread_work *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
 
@@ -282,7 +282,13 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 	}
 
 	vdpasim->dev_attr = *dev_attr;
-	INIT_WORK(&vdpasim->work, vdpasim_work_fn);
+
+	kthread_init_work(&vdpasim->work, vdpasim_work_fn);
+	vdpasim->worker = kthread_create_worker(0, "vDPA sim worker: %s",
+						dev_attr->name);
+	if (IS_ERR(vdpasim->worker))
+		goto err_iommu;
+
 	spin_lock_init(&vdpasim->lock);
 	spin_lock_init(&vdpasim->iommu_lock);
 
@@ -338,7 +344,7 @@ EXPORT_SYMBOL_GPL(vdpasim_create);
 
 void vdpasim_schedule_work(struct vdpasim *vdpasim)
 {
-	schedule_work(&vdpasim->work);
+	kthread_queue_work(vdpasim->worker, &vdpasim->work);
 }
 EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
 
@@ -689,7 +695,8 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int i;
 
-	cancel_work_sync(&vdpasim->work);
+	kthread_cancel_work_sync(&vdpasim->work);
+	kthread_destroy_worker(vdpasim->worker);
 
 	for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
 		vringh_kiov_cleanup(&vdpasim->vqs[i].out_iov);
-- 
2.38.1

