Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879AD6A813E
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCBLgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCBLgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:36:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929541A496
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 03:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677756914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=garxf7u2PYyPkA/AdwQgG8IfzxLSGUACcilXDazWE4o=;
        b=eYfmIggrFzs+QlJskU3P1wY5oLW8cnrT8NCG7jz8PNEMfCDXvtrKKLTBkqD5HXUNTdbB/N
        1594+iYYehYrAJGWUffQ+yIXPAnIwgD3KkiRDPx9Ov6wIytgpWrkr8+TwIaPmwDi3O4RKq
        rUK1tysPzyQmgQR9189E3Y4G1g29Tvc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-Jzpn6YG4OBq6zh-V0LnD9w-1; Thu, 02 Mar 2023 06:35:13 -0500
X-MC-Unique: Jzpn6YG4OBq6zh-V0LnD9w-1
Received: by mail-qt1-f197.google.com with SMTP id l12-20020ac84a8c000000b003bfe751a7fdso4814491qtq.1
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 03:35:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=garxf7u2PYyPkA/AdwQgG8IfzxLSGUACcilXDazWE4o=;
        b=e5TVQ3/EJPfsSbMXRt5pGBGJ1DZhFhMCGjv9Gvd8SIIeSwcOJtF0lV1+M2ZdRd7xVk
         +9ur//4uJKhMyS+3j1I9CAezqYCKWBhoVJAhEMpP6wCzPG6wxoseE/TJ2D3YzySAa2NV
         JkVEhBfaDlSqJV+hgtnZ+uzLniApRGxNa0dmANzDlwpcSyuIVkHse+HBQMiWBDrPgL1c
         6HzRQI/XOeC6YA5aCLeQ8iPwGWV1FkA8Sw8ZFrLigfv8+PyrlRnPwNjgDg/xxxXYUsd2
         W0XYlKV8n6xU93l6mD4mHMyf5oPS+/brn8cW7Rr7CkiNCTgayfPDsWO/6G5e5a9M6Y8y
         lmKw==
X-Gm-Message-State: AO0yUKXWcQHAAfRdAp3IiALaW4NKNthfu3PIt/asQb0x8N9ydmzuRQQw
        82BoHTRAr8C9HGQsKYhvgd5g+wuxcjIkDvG0DE9Ln0AOcpRUNoRirhD/Uu39q8DJiI4LnYSeiG/
        rbEjZBbDT++99vnLU
X-Received: by 2002:a05:6214:ca2:b0:56e:a620:7b39 with SMTP id s2-20020a0562140ca200b0056ea6207b39mr2884834qvs.4.1677756913182;
        Thu, 02 Mar 2023 03:35:13 -0800 (PST)
X-Google-Smtp-Source: AK7set+PZ/909SePXSEHKpmXpgvXRGxl6z5c0ldwKhD+c5TD8rRI1RDC5SJdB6Y2WkYalG0LWvNEBA==
X-Received: by 2002:a05:6214:ca2:b0:56e:a620:7b39 with SMTP id s2-20020a0562140ca200b0056ea6207b39mr2884814qvs.4.1677756912950;
        Thu, 02 Mar 2023 03:35:12 -0800 (PST)
Received: from step1.redhat.com (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id p12-20020a37420c000000b007426ec97253sm8383058qka.111.2023.03.02.03.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:35:12 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 6/8] vdpa_sim: use kthread worker
Date:   Thu,  2 Mar 2023 12:34:19 +0100
Message-Id: <20230302113421.174582-7-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302113421.174582-1-sgarzare@redhat.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
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
index a6ee830efc38..6feb29726c2a 100644
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
@@ -116,7 +116,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
 static const struct vdpa_config_ops vdpasim_config_ops;
 static const struct vdpa_config_ops vdpasim_batch_config_ops;
 
-static void vdpasim_work_fn(struct work_struct *work)
+static void vdpasim_work_fn(struct kthread_work *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
 
@@ -159,7 +159,13 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 
 	vdpasim = vdpa_to_sim(vdpa);
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
 
@@ -212,7 +218,7 @@ EXPORT_SYMBOL_GPL(vdpasim_create);
 
 void vdpasim_schedule_work(struct vdpasim *vdpasim)
 {
-	schedule_work(&vdpasim->work);
+	kthread_queue_work(vdpasim->worker, &vdpasim->work);
 }
 EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
 
@@ -612,7 +618,8 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int i;
 
-	cancel_work_sync(&vdpasim->work);
+	kthread_cancel_work_sync(&vdpasim->work);
+	kthread_destroy_worker(vdpasim->worker);
 
 	for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
 		vringh_kiov_cleanup(&vdpasim->vqs[i].out_iov);
-- 
2.39.2

