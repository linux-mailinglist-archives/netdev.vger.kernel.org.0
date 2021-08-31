Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D213FC621
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241333AbhHaKkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 06:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241134AbhHaKib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 06:38:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF66C0612AD
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 03:37:26 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so1777973pje.0
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 03:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C07xaPneecmbOG/2S1p4CJrqrccH6w7GBsTKs/jZSu8=;
        b=rvwTBW/chQwCs1ysBZtuOOGvFV8AoCOi2faEBCshYAhgiqxCHJHsLU0lvpLAKEC53A
         1Z5uB9MoFNJQ139cNkZQqj6o8M0OCSAnRE+xkYtpVBsgR1y8wlVPd5z+MlKaFK0bUjd+
         7w/E8RZ493mxhz0AMH5vxE5KH84DplzEYfrK5DhdpkG4TE+28RB7vzCAkgB0SnPeRW9C
         TJdrtE5YLJ+ARxPEjRFIKdCcIyOOqIynFi2Ax9SG5k5/U0yencRx0YXDRFcVDWOziXrf
         SyQglSnRCjXJD8ieWRepwEggqDxJ4QqyQPDRHM97ybs3J0jftdCffrf22EKTlZaiK/6L
         JznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C07xaPneecmbOG/2S1p4CJrqrccH6w7GBsTKs/jZSu8=;
        b=faNTOM+tHa8emOwctDg8tbQLTU4ErG/bhr3dmtPJi1oe+KVaiBFH0HkhIgRn44J9d4
         uBgfm5x7zPXVe9IS7M9oqGg2XETtpr/YAe396J2+olCL6ViaQjUHbHhMBdVHrQq8cgDY
         p2q/eEGKnI9wX5xo/kFkwZvbDqqdvwxF18ncz/DytYy2XYdkBeXGHYGCH55fX5OYcCaa
         lrjW1wXJlq5kKC9Xcugzhjket2u/tLfCprgw7VRPeyjQOB8uA9okfAFhaSCLxPjXPfd6
         5Egp1Sf3wMI1qoRqDnHcNJIEoYeM7uOb375lYcO3uxI5uQRthd7xsbo+eDqDkx7c4tVn
         w3Rw==
X-Gm-Message-State: AOAM530dpH8xgEl3+b9/PChfwYJM69Suntnet32vJEYKklM0Tkw9KQ/K
        xjTisFN/OxWYPGz3GpBaAq6b
X-Google-Smtp-Source: ABdhPJxayXvJMyHxVP3rT4nojLNgd/ffmXKTeSHlwaQVlvgNs+l4lB1isTVsta0CNNQ1iuiXOsbF6w==
X-Received: by 2002:a17:90a:d590:: with SMTP id v16mr4584722pju.205.1630406245702;
        Tue, 31 Aug 2021 03:37:25 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id l127sm7169012pfl.99.2021.08.31.03.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 03:37:25 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 06/13] vhost-vdpa: Handle the failure of vdpa_reset()
Date:   Tue, 31 Aug 2021 18:36:27 +0800
Message-Id: <20210831103634.33-7-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210831103634.33-1-xieyongji@bytedance.com>
References: <20210831103634.33-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vdpa_reset() may fail now. This adds check to its return
value and fail the vhost_vdpa_open().

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ab7a24613982..ab39805ecff1 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -116,12 +116,13 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
 }
 
-static void vhost_vdpa_reset(struct vhost_vdpa *v)
+static int vhost_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 
-	vdpa_reset(vdpa);
 	v->in_batch = 0;
+
+	return vdpa_reset(vdpa);
 }
 
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
@@ -865,7 +866,9 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 		return -EBUSY;
 
 	nvqs = v->nvqs;
-	vhost_vdpa_reset(v);
+	r = vhost_vdpa_reset(v);
+	if (r)
+		goto err;
 
 	vqs = kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
-- 
2.11.0

