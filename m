Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1989B6D6296
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbjDDNSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbjDDNS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:18:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA804201
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680614249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dJgV3Uny0vAQYBeBkJItoY2HRKhsGCmVf+cCCim+XIk=;
        b=DE24mP5nwB1vgACd9oc3hM/2hMep1c+AQ08C571Gwu/h4WaNblOrVt6RhiEPMQsn3rlqFK
        pgyTsNV4p0ZsFTB9igpdP049HwBcN3m/vQUGyUit2nkyvhHCLHTA+V7l4yTJUxUVlopuoX
        ReuloTEy1XDurmv3ppP59mKGCHBTSxg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-V7CfG0VzOceZXsEH5XG6ew-1; Tue, 04 Apr 2023 09:17:26 -0400
X-MC-Unique: V7CfG0VzOceZXsEH5XG6ew-1
Received: by mail-qk1-f198.google.com with SMTP id s2-20020a37a902000000b0074a28a891baso4163990qke.18
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 06:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680614246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJgV3Uny0vAQYBeBkJItoY2HRKhsGCmVf+cCCim+XIk=;
        b=0o7nNKXN2RMYNlK75TUTedxz7MISLHLT5uuqGm+pY2Nnirr0ev8YQJdNiLP9YyAgVd
         Z7dKzucBtU4oFjaoJuHcByeyd4FpIMz8ERkApuvh4Z/OaFMXYfPF8DxAxXLehZoXIH7l
         KUTIz3Sk+cJ+FiKFRa8W8h00VOCueh9RmWWtCnbKjEXPGeTnfTL/bhwqkfNujwpPcD2T
         a/vK3kqnaD+yw1H8AgMpL27RgHs9V6z3ucWehLIpdrs2wwt9V9DtONIyUIA5i7oaO8om
         ujnqhwTTYBixPaxzDLaGE5QEQvoD2kY4s0+5JyR8QkBy0c3ifyV4x2i+WdY7EXMjd16C
         EzDA==
X-Gm-Message-State: AAQBX9eIqpUyVKglq/y0hmGBA1zvKpef+ufjawrbD4WNMBoozGn3GZxD
        DkZuNu9SHi8cAQrPXwTtD9LKvvOuaL9uPMMhEH8HZnRjJgKgUat5Aye/7sS2SYeHrYHjq4NI7yW
        opW9q7uTOxbUC779L
X-Received: by 2002:ac8:7e95:0:b0:3db:8942:cbd2 with SMTP id w21-20020ac87e95000000b003db8942cbd2mr3082599qtj.61.1680614245810;
        Tue, 04 Apr 2023 06:17:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350YMd/Weusi+zE8RYXgtRK+Bjy3NmTK3bIgXuYUmwBU7kwp1jLwlSvGzCLVFs/61kWcH/ZT71w==
X-Received: by 2002:ac8:7e95:0:b0:3db:8942:cbd2 with SMTP id w21-20020ac87e95000000b003db8942cbd2mr3082543qtj.61.1680614245400;
        Tue, 04 Apr 2023 06:17:25 -0700 (PDT)
Received: from step1.redhat.com (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id y25-20020a37f619000000b0074382b756c2sm3565606qkj.14.2023.04.04.06.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 06:17:24 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, eperezma@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v5 6/9] vdpa_sim: make devices agnostic for work management
Date:   Tue,  4 Apr 2023 15:17:21 +0200
Message-Id: <20230404131721.45886-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404131326.44403-1-sgarzare@redhat.com>
References: <20230404131326.44403-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's move work management inside the vdpa_sim core.
This way we can easily change how we manage the works, without
having to change the devices each time.

Acked-by: Eugenio Pérez Martin <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  3 ++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 17 +++++++++++++++--
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  6 ++----
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  6 ++----
 4 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index 144858636c10..acee20faaf6a 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -45,7 +45,7 @@ struct vdpasim_dev_attr {
 	u32 ngroups;
 	u32 nas;
 
-	work_func_t work_fn;
+	void (*work_fn)(struct vdpasim *vdpasim);
 	void (*get_config)(struct vdpasim *vdpasim, void *config);
 	void (*set_config)(struct vdpasim *vdpasim, const void *config);
 	int (*get_stats)(struct vdpasim *vdpasim, u16 idx,
@@ -78,6 +78,7 @@ struct vdpasim {
 
 struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *attr,
 			       const struct vdpa_dev_set_config *config);
+void vdpasim_schedule_work(struct vdpasim *vdpasim);
 
 /* TODO: cross-endian support */
 static inline bool vdpasim_is_little_endian(struct vdpasim *vdpasim)
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index eea23c630f7c..2df5227e0b62 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -127,6 +127,13 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
 static const struct vdpa_config_ops vdpasim_config_ops;
 static const struct vdpa_config_ops vdpasim_batch_config_ops;
 
+static void vdpasim_work_fn(struct work_struct *work)
+{
+	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
+
+	vdpasim->dev_attr.work_fn(vdpasim);
+}
+
 struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 			       const struct vdpa_dev_set_config *config)
 {
@@ -163,7 +170,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 
 	vdpasim = vdpa_to_sim(vdpa);
 	vdpasim->dev_attr = *dev_attr;
-	INIT_WORK(&vdpasim->work, dev_attr->work_fn);
+	INIT_WORK(&vdpasim->work, vdpasim_work_fn);
 	spin_lock_init(&vdpasim->lock);
 	spin_lock_init(&vdpasim->iommu_lock);
 
@@ -214,6 +221,12 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 }
 EXPORT_SYMBOL_GPL(vdpasim_create);
 
+void vdpasim_schedule_work(struct vdpasim *vdpasim)
+{
+	schedule_work(&vdpasim->work);
+}
+EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
+
 static int vdpasim_set_vq_address(struct vdpa_device *vdpa, u16 idx,
 				  u64 desc_area, u64 driver_area,
 				  u64 device_area)
@@ -248,7 +261,7 @@ static void vdpasim_kick_vq(struct vdpa_device *vdpa, u16 idx)
 	}
 
 	if (vq->ready)
-		schedule_work(&vdpasim->work);
+		vdpasim_schedule_work(vdpasim);
 }
 
 static void vdpasim_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index 5117959bed8a..eb4897c8541e 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/blkdev.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
@@ -286,9 +285,8 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
 	return handled;
 }
 
-static void vdpasim_blk_work(struct work_struct *work)
+static void vdpasim_blk_work(struct vdpasim *vdpasim)
 {
-	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
 	bool reschedule = false;
 	int i;
 
@@ -326,7 +324,7 @@ static void vdpasim_blk_work(struct work_struct *work)
 	spin_unlock(&vdpasim->lock);
 
 	if (reschedule)
-		schedule_work(&vdpasim->work);
+		vdpasim_schedule_work(vdpasim);
 }
 
 static void vdpasim_blk_get_config(struct vdpasim *vdpasim, void *config)
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index 862f405362de..e61a9ecbfafe 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
-#include <linux/sched.h>
 #include <linux/etherdevice.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
@@ -192,9 +191,8 @@ static void vdpasim_handle_cvq(struct vdpasim *vdpasim)
 	u64_stats_update_end(&net->cq_stats.syncp);
 }
 
-static void vdpasim_net_work(struct work_struct *work)
+static void vdpasim_net_work(struct vdpasim *vdpasim)
 {
-	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
 	struct vdpasim_virtqueue *txq = &vdpasim->vqs[1];
 	struct vdpasim_virtqueue *rxq = &vdpasim->vqs[0];
 	struct vdpasim_net *net = sim_to_net(vdpasim);
@@ -260,7 +258,7 @@ static void vdpasim_net_work(struct work_struct *work)
 		vdpasim_net_complete(rxq, write);
 
 		if (tx_pkts > 4) {
-			schedule_work(&vdpasim->work);
+			vdpasim_schedule_work(vdpasim);
 			goto out;
 		}
 	}
-- 
2.39.2

