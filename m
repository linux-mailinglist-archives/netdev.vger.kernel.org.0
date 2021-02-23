Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620C0322A37
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhBWMCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbhBWL4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:56:09 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5B4C0611C0
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:52:14 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 23so4078453pgg.4
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mpSVO02WeSJyxcY7vakGLQAJ5J/bpLd3WEpRslAb7G4=;
        b=QP76S88RK8sDiyT5DP1Z3kQHCMsK8vvnIvMcPFvkOGolYPlpdLMZZL7limKAHNU0vp
         2HTlWrmdtg5fSl2IOsZnao5OzY4D2UmB0sRjdQB1qxpSB4uRor2JU4FF2Jmu5arsOOS6
         seZxyzkBfX45r2l7nikcXEuxFjbadNy0h9nK5WD4qhO905QPQYUdn+csUVDmHsFzJa7I
         kakRUrM8fK1hKjZeOTjI3JsY5BOzGSpMiLQjmNTRGsB0a95kEPrgJbcV/ff1eHBFrsox
         gm+dqb4dSHUvWmdy11i5Msa63WAOgULi2bMulXieC0+EPe4Auvkq/OBPfAYTxfCzq11k
         cbBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mpSVO02WeSJyxcY7vakGLQAJ5J/bpLd3WEpRslAb7G4=;
        b=kERckA4E/cNDU3VWL1VgLNyDGo7jrsx7Kpkhfw/8n8EzDn1L5eXXM93Fj3ndb9XFe0
         t6mmgM1o0s84GpiQHSUcQHD7sOE6WSfNYf8jpCBio2JjdZTUaWDR9l4lIZb++uFcbS++
         n27BzrJg8h6lJ8ql4nw6SVCOwaItiPcVWL09rTDPDNpj99RygUwD4cY3DyMmxP1b86g5
         E1HT3p9Ogd1dYGRCqGWPmnNJptQ8OssInahjxW44N/92rJ485oKqATWUQ/CeB/CcN8OT
         Uy2KawRwBW1iWNh6rPkMe7FJpHqMTmItkykTDhzwYIGYCmxpNVmk4E3Rnb6L3lgxrXn/
         3zWA==
X-Gm-Message-State: AOAM533DDznEaP4elcAP7iBgO/Pw6/FJMtQiEsHWCKHkrfTN0IdCrcH+
        44YNu7MoI3RHmgRR2M7D5lXo
X-Google-Smtp-Source: ABdhPJwI8V5ZPCWLM6hAXyzvq5bv+cbD+RJerofPpswHKL+YDPqoXOMdON/HY4//54QBqbR0Keo9vQ==
X-Received: by 2002:a63:5625:: with SMTP id k37mr4570893pgb.96.1614081133806;
        Tue, 23 Feb 2021 03:52:13 -0800 (PST)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id r15sm10303669pfh.97.2021.02.23.03.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:52:13 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v4 08/11] vduse: Add config interrupt support
Date:   Tue, 23 Feb 2021 19:50:45 +0800
Message-Id: <20210223115048.435-9-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223115048.435-1-xieyongji@bytedance.com>
References: <20210223115048.435-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new ioctl VDUSE_INJECT_CONFIG_IRQ
to support injecting config interrupt.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 24 +++++++++++++++++++++++-
 include/uapi/linux/vduse.h         |  3 +++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 393bf99c48be..8042d3fa57f1 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -66,6 +66,8 @@ struct vduse_dev {
 	struct list_head send_list;
 	struct list_head recv_list;
 	struct list_head list;
+	struct vdpa_callback config_cb;
+	spinlock_t irq_lock;
 	bool connected;
 	int minor;
 	u16 vq_size_max;
@@ -483,6 +485,11 @@ static void vduse_dev_reset(struct vduse_dev *dev)
 	vduse_iotlb_del_range(dev, 0ULL, ULLONG_MAX);
 	vduse_dev_update_iotlb(dev, 0ULL, ULLONG_MAX);
 
+	spin_lock(&dev->irq_lock);
+	dev->config_cb.callback = NULL;
+	dev->config_cb.private = NULL;
+	spin_unlock(&dev->irq_lock);
+
 	for (i = 0; i < dev->vq_num; i++) {
 		struct vduse_virtqueue *vq = &dev->vqs[i];
 
@@ -599,7 +606,12 @@ static int vduse_vdpa_set_features(struct vdpa_device *vdpa, u64 features)
 static void vduse_vdpa_set_config_cb(struct vdpa_device *vdpa,
 				  struct vdpa_callback *cb)
 {
-	/* We don't support config interrupt */
+	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+
+	spin_lock(&dev->irq_lock);
+	dev->config_cb.callback = cb->callback;
+	dev->config_cb.private = cb->private;
+	spin_unlock(&dev->irq_lock);
 }
 
 static u16 vduse_vdpa_get_vq_num_max(struct vdpa_device *vdpa)
@@ -913,6 +925,15 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 		spin_unlock_irq(&vq->irq_lock);
 		break;
 	}
+	case VDUSE_INJECT_CONFIG_IRQ:
+		ret = -EINVAL;
+		spin_lock_irq(&dev->irq_lock);
+		if (dev->config_cb.callback) {
+			dev->config_cb.callback(dev->config_cb.private);
+			ret = 0;
+		}
+		spin_unlock_irq(&dev->irq_lock);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
@@ -996,6 +1017,7 @@ static struct vduse_dev *vduse_dev_create(void)
 	INIT_LIST_HEAD(&dev->recv_list);
 	atomic64_set(&dev->msg_unique, 0);
 	spin_lock_init(&dev->iommu_lock);
+	spin_lock_init(&dev->irq_lock);
 	atomic_set(&dev->bounce_map, 0);
 
 	init_waitqueue_head(&dev->waitq);
diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
index 9391c4acfa53..9070cd512cb4 100644
--- a/include/uapi/linux/vduse.h
+++ b/include/uapi/linux/vduse.h
@@ -133,4 +133,7 @@ struct vduse_vq_eventfd {
 /* Inject an interrupt for specific virtqueue */
 #define VDUSE_INJECT_VQ_IRQ	_IO(VDUSE_BASE, 0x05)
 
+/* Inject a config interrupt */
+#define VDUSE_INJECT_CONFIG_IRQ	_IO(VDUSE_BASE, 0x06)
+
 #endif /* _UAPI_VDUSE_H_ */
-- 
2.11.0

