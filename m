Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D337F322A25
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhBWL7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbhBWLz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:55:59 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438E8C061A29
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:52:24 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id f8so9671846plg.5
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kx223F6I1hgIgXiIIDDOAsjioq86iWLsXACPrPS1HVA=;
        b=OFtGQpWO+Ir3PPk881mk0o6vjPCtTLRoAY9YCPtCzHzPxYm6IB1YUZjgQT9z6+E/QI
         IaBQIWiMv+r0McIu60scEAKEcdu8iwRQT81n6DUoMPYWWU08HXKnUAhhiVK61x+NCRPO
         U//hQ7GB3QxU+gJEAwfhogNVQmGxyjJef5wfd0A34jTOLkNnxNSuC/IE6xBmw9/mUoW+
         J9GKcsOGDYWdIYcqrqQGlzm+s0VikurzM64kmzpTkSruhKrVsGNeVPXVnezDCnhMh/Xe
         uLgy5fUWCctul2mjq0okYPD9noMzO+5/tv1wstLqxTK/OFKd9xw6EJOGxM1VIwzhrcgK
         nIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kx223F6I1hgIgXiIIDDOAsjioq86iWLsXACPrPS1HVA=;
        b=AsV7lqQBcXiE1kAA5plEqhAMdinm2Ua2StMduoUqzCnkGXLLhNQO5EU3pttzeyaDIa
         QwU+KvcnD+8bvIaQ2izjnRGEC9dqpPSj+sbjf93/fQjyapTUOMYy87ePDbl7B5hkHUsj
         jJA78GFmlDB+4l5Ss7OGD/0kOLgJNJJPffX9Dc5DGOt4MG3ySjk82bfShdPob4+64cNj
         l+Me4j2ETg1CjTHG1J7xOdZqfL7fm904/ymXzkbUmzE8OtP6SKvHj1I77wTlbotfKD6X
         e4EfYq1HYsDFnpwdQJrg6BmGgXIdbLmMSLGqgo5hMtXIzR8nrkBKRLy+cyvP0OWpCUBY
         eedQ==
X-Gm-Message-State: AOAM531PYAWsLyqjeisIPgkYR1n0Mt2OkBZpdS3zE2hQHljhroqIqhgq
        pYPjO7HQsr4daSpaBAp2LUzo
X-Google-Smtp-Source: ABdhPJxCiZTw6J3O+SU1cFtjM3nZVrWxHdWG5XNpfJsIliABcgypEMAFrFZB+4ShrIxtU+FhvocD7w==
X-Received: by 2002:a17:90a:f87:: with SMTP id 7mr20859866pjz.98.1614081143880;
        Tue, 23 Feb 2021 03:52:23 -0800 (PST)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id m6sm3872111pfc.56.2021.02.23.03.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:52:23 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v4 11/11] vduse: Support binding irq to the specified cpu
Date:   Tue, 23 Feb 2021 19:50:48 +0800
Message-Id: <20210223115048.435-12-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223115048.435-1-xieyongji@bytedance.com>
References: <20210223115048.435-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a parameter for the ioctl VDUSE_INJECT_VQ_IRQ to support
injecting virtqueue's interrupt to the specified cpu.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 22 +++++++++++++++++-----
 include/uapi/linux/vduse.h         |  7 ++++++-
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index f5adeb9ee027..df3d467fff40 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -923,14 +923,27 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 		break;
 	}
 	case VDUSE_INJECT_VQ_IRQ: {
+		struct vduse_vq_irq irq;
 		struct vduse_virtqueue *vq;
 
+		ret = -EFAULT;
+		if (copy_from_user(&irq, argp, sizeof(irq)))
+			break;
+
 		ret = -EINVAL;
-		if (arg >= dev->vq_num)
+		if (irq.index >= dev->vq_num)
+			break;
+
+		if (irq.cpu != -1 && (irq.cpu >= nr_cpu_ids ||
+		    !cpu_online(irq.cpu)))
 			break;
 
-		vq = &dev->vqs[arg];
-		queue_work(vduse_irq_wq, &vq->inject);
+		ret = 0;
+		vq = &dev->vqs[irq.index];
+		if (irq.cpu == -1)
+			queue_work(vduse_irq_wq, &vq->inject);
+		else
+			queue_work_on(irq.cpu, vduse_irq_wq, &vq->inject);
 		break;
 	}
 	case VDUSE_INJECT_CONFIG_IRQ:
@@ -1342,8 +1355,7 @@ static int vduse_init(void)
 	if (ret)
 		goto err_chardev;
 
-	vduse_irq_wq = alloc_workqueue("vduse-irq",
-				WQ_HIGHPRI | WQ_SYSFS | WQ_UNBOUND, 0);
+	vduse_irq_wq = alloc_workqueue("vduse-irq", WQ_HIGHPRI, 0);
 	if (!vduse_irq_wq)
 		goto err_wq;
 
diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
index 9070cd512cb4..9c70fd842ce5 100644
--- a/include/uapi/linux/vduse.h
+++ b/include/uapi/linux/vduse.h
@@ -116,6 +116,11 @@ struct vduse_vq_eventfd {
 	int fd; /* eventfd, -1 means de-assigning the eventfd */
 };
 
+struct vduse_vq_irq {
+	__u32 index; /* virtqueue index */
+	int cpu; /* bind irq to the specified cpu, -1 means running on the current cpu */
+};
+
 #define VDUSE_BASE	0x81
 
 /* Create a vduse device which is represented by a char device (/dev/vduse/<name>) */
@@ -131,7 +136,7 @@ struct vduse_vq_eventfd {
 #define VDUSE_VQ_SETUP_KICKFD	_IOW(VDUSE_BASE, 0x04, struct vduse_vq_eventfd)
 
 /* Inject an interrupt for specific virtqueue */
-#define VDUSE_INJECT_VQ_IRQ	_IO(VDUSE_BASE, 0x05)
+#define VDUSE_INJECT_VQ_IRQ	_IOW(VDUSE_BASE, 0x05, struct vduse_vq_irq)
 
 /* Inject a config interrupt */
 #define VDUSE_INJECT_CONFIG_IRQ	_IO(VDUSE_BASE, 0x06)
-- 
2.11.0

