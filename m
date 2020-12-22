Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE4B2E0C2E
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbgLVOzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbgLVOzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:55:09 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED44C0619D5
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:53:58 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id n10so8487198pgl.10
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LHvQD7OkJ4lGDapgVipEOlFAJokuqf9tiHbhgrtKHnQ=;
        b=RbF6t1URx0NXuDx34sfOQmiHT5wyMt7HcQz7xB3j7UlRJJ8qn6zNpUxhzqnhTkabhw
         cHNm5bWTktHQwlrssm1Bxy/zV5HBtRdwVWm7PD7miDmOEaj4RsheZ0pjhsoJHl9MtAck
         lRaz1T0kLTHs57YosK4erxKVciURD2nNzv+vy2/cLa8RhC57RP/v9FvpucBxRXTT+END
         rR9hlo8x0zAOGHsD97fDtU/+26SncIQFJorfgouF6bmMg+0LaV5JZ0Vh+2CbP+J4jyRD
         rDOz+XsvnhvnpjA8QO5lxzQLeshKdzqd6/G/oGoCHCm4ilN6Z9nDrUF33KtTgyvOgxox
         dFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LHvQD7OkJ4lGDapgVipEOlFAJokuqf9tiHbhgrtKHnQ=;
        b=bloR4fp2yoWPnU/iGg9NFl1asY6kByv3d4NeD3TIy3rrsXR+yOlBQJSt2sdxtdl9rV
         UAjB2ugsg4IteOfRyoE8PiEr0qBH/J7YMVopbY0gyjw2BMyXHVaO5BOWEBD2gGQxEBWF
         F020+2qltqX2BSvjS2rLF1TTGpmoMp+qfILCCZ98bY/AHx/7P/iVt38XzV0w48zM9837
         3bdXH+5cOmMFdLkrFOLlWw2OmI1TYl3IreBTz0B4pjonw9aKZpKa+bQhIQ7rINrtRAot
         As5ZnFnt3aq1DMSSwykaUDTYcY8dh1NgF2fXDzSA6mMwwLKHJ/f7t4Hx5UJTApb1nIHS
         q18A==
X-Gm-Message-State: AOAM530MVJCtQIzk0DbjWrBKJ59ypvz07PO/KYYfAXTZJimWbSwpcPXg
        a70+ObVSNQpYbOUU1qbdHaE3
X-Google-Smtp-Source: ABdhPJxHgVEI1a5PZz0mJOg/L7ZcxPgkg0e49rxJy8/9ZVyVLaCF/QiD5aZkOXPawm0UVGFmRu0uqQ==
X-Received: by 2002:a63:1c1d:: with SMTP id c29mr13018708pgc.94.1608648838484;
        Tue, 22 Dec 2020 06:53:58 -0800 (PST)
Received: from localhost ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id u12sm20339420pfh.98.2020.12.22.06.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 06:53:57 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, akpm@linux-foundation.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC v2 08/13] vdpa: Introduce process_iotlb_msg() in vdpa_config_ops
Date:   Tue, 22 Dec 2020 22:52:16 +0800
Message-Id: <20201222145221.711-9-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222145221.711-1-xieyongji@bytedance.com>
References: <20201222145221.711-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new method in the vdpa_config_ops to
support processing the raw vhost memory mapping message in the
vDPA device driver.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c | 5 ++++-
 include/linux/vdpa.h | 7 +++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 448be7875b6d..ccbb391e38be 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -728,6 +728,9 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	if (r)
 		return r;
 
+	if (ops->process_iotlb_msg)
+		return ops->process_iotlb_msg(vdpa, msg);
+
 	switch (msg->type) {
 	case VHOST_IOTLB_UPDATE:
 		r = vhost_vdpa_process_iotlb_update(v, msg);
@@ -770,7 +773,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 	int ret;
 
 	/* Device want to do DMA by itself */
-	if (ops->set_map || ops->dma_map)
+	if (ops->set_map || ops->dma_map || ops->process_iotlb_msg)
 		return 0;
 
 	bus = dma_dev->bus;
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 656fe264234e..7bccedf22f4b 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/vhost_types.h>
 #include <linux/vhost_iotlb.h>
 #include <net/genetlink.h>
 
@@ -172,6 +173,10 @@ struct vdpa_iova_range {
  *				@vdev: vdpa device
  *				Returns the iova range supported by
  *				the device.
+ * @process_iotlb_msg:		Process vhost memory mapping message (optional)
+ *				Only used for VDUSE device now
+ *				@vdev: vdpa device
+ *				@msg: vhost memory mapping message
  * @set_map:			Set device memory mapping (optional)
  *				Needed for device that using device
  *				specific DMA translation (on-chip IOMMU)
@@ -240,6 +245,8 @@ struct vdpa_config_ops {
 	struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
 
 	/* DMA ops */
+	int (*process_iotlb_msg)(struct vdpa_device *vdev,
+				 struct vhost_iotlb_msg *msg);
 	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
 	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
 		       u64 pa, u32 perm);
-- 
2.11.0

