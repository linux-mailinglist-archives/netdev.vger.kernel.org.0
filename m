Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2C734FB29
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhCaIG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbhCaIGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:06:40 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C810C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:06:39 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h25so13656063pgm.3
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rtJRvLLxqYfbQp3k0gxj2srSIbASh6xiOG9Mep0BSmk=;
        b=w5hDeZv0IPaw+gqFRpEaMlZdT7oT4DNs6bmIznvJK7+yn5Op4/jEIFUooqO/yf7Odf
         foqq+oRANL2424ymkzYHi9jqsgdZ5LWNeumtpctkH/Hd+LoXsWnwJp1aZ88R3Q1X7y2Z
         FAWenN3c5A3UX6ZnkfyoM28Eri6ELfGfCT3mUSRH0zh4kXBbLEmRTdB/mDR+ZU20SLef
         MBTaBZhn6XNz7Gq113Pw45gBApk6HQ58W4e9dXp2kXsfuOu+Nq6sT6q6Xm7SCJp4VuXa
         U5JLZJazm/OgF0+fwBP1zXBjCt6WN15OALNq0ZkozXUACtF0PKU4xgtQofTuVi9Jktcp
         nnAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rtJRvLLxqYfbQp3k0gxj2srSIbASh6xiOG9Mep0BSmk=;
        b=KF2racky1QqeBCtlpTtzH/+68re2ez2lC50Jtjb6XD1LB4KzSDqdVJOt5Ah3tX1EQp
         OojE8K7B3eFIXHEfqvNR4A7tZ2ufqMSn58xDG1azO/EuwNvEz7QCujKIlDrWQxzd+xus
         sWSQawYADxSWqIgpJ+luDLMuMKBEDz+W8y93MjL0P0GBLvTlIrB2f/S2r02QtcjuDDyh
         ASoLEk1S3l4K5tKbrXL4SpaQM7Mj6KPPjV3/IyeECvBqzShTLCPPiU4/I7r0tjP6gqut
         2BsBXS+h6t2iOKiby2zkWK6XSqFoxDaWPHulJ8tVSddI3FZCinmVPGt7sDpctGQBvvix
         oUfg==
X-Gm-Message-State: AOAM5337Ho6YwBQTAdxcMZS9wd1cCnasf4KaxgTkrAj/1f2LaqAoA7zg
        TnEPSoOuiXu8+W2xkUEzUPGw
X-Google-Smtp-Source: ABdhPJxykFPDlbo5t2zr7wx1yYTSCAqgzyvVTf6J3sWPsHKgXsLVdyCoeIH5gAzysavU9FcOJicdAg==
X-Received: by 2002:a63:2321:: with SMTP id j33mr2142411pgj.120.1617177999238;
        Wed, 31 Mar 2021 01:06:39 -0700 (PDT)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id d24sm1333563pjw.37.2021.03.31.01.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:06:38 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 06/10] vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
Date:   Wed, 31 Mar 2021 16:05:15 +0800
Message-Id: <20210331080519.172-7-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331080519.172-1-xieyongji@bytedance.com>
References: <20210331080519.172-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The upcoming patch is going to support VA mapping/unmapping.
So let's factor out the logic of PA mapping/unmapping firstly
to make the code more readable.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 53 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 22cab98610a1..f9aab9013745 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -483,7 +483,7 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	return r;
 }
 
-static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 {
 	struct vhost_dev *dev = &v->vdev;
 	struct vhost_iotlb *iotlb = dev->iotlb;
@@ -505,6 +505,11 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 	}
 }
 
+static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+{
+	return vhost_vdpa_pa_unmap(v, start, last);
+}
+
 static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
 {
 	struct vhost_dev *dev = &v->vdev;
@@ -585,37 +590,28 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
 	}
 }
 
-static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
-					   struct vhost_iotlb_msg *msg)
+static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
+			     u64 iova, u64 size, u64 uaddr, u32 perm)
 {
 	struct vhost_dev *dev = &v->vdev;
-	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct page **page_list;
 	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
 	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
 	unsigned long lock_limit, sz2pin, nchunks, i;
-	u64 iova = msg->iova;
+	u64 start = iova;
 	long pinned;
 	int ret = 0;
 
-	if (msg->iova < v->range.first ||
-	    msg->iova + msg->size - 1 > v->range.last)
-		return -EINVAL;
-
-	if (vhost_iotlb_itree_first(iotlb, msg->iova,
-				    msg->iova + msg->size - 1))
-		return -EEXIST;
-
 	/* Limit the use of memory for bookkeeping */
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
 	if (!page_list)
 		return -ENOMEM;
 
-	if (msg->perm & VHOST_ACCESS_WO)
+	if (perm & VHOST_ACCESS_WO)
 		gup_flags |= FOLL_WRITE;
 
-	npages = PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
+	npages = PAGE_ALIGN(size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
 	if (!npages) {
 		ret = -EINVAL;
 		goto free;
@@ -629,7 +625,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 		goto unlock;
 	}
 
-	cur_base = msg->uaddr & PAGE_MASK;
+	cur_base = uaddr & PAGE_MASK;
 	iova &= PAGE_MASK;
 	nchunks = 0;
 
@@ -660,7 +656,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
 				ret = vhost_vdpa_map(v, iova, csize,
 						     map_pfn << PAGE_SHIFT,
-						     msg->perm);
+						     perm);
 				if (ret) {
 					/*
 					 * Unpin the pages that are left unmapped
@@ -689,7 +685,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 
 	/* Pin the rest chunk */
 	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, msg->perm);
+			     map_pfn << PAGE_SHIFT, perm);
 out:
 	if (ret) {
 		if (nchunks) {
@@ -708,13 +704,32 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
 				unpin_user_page(pfn_to_page(pfn));
 		}
-		vhost_vdpa_unmap(v, msg->iova, msg->size);
+		vhost_vdpa_unmap(v, start, size);
 	}
 unlock:
 	mmap_read_unlock(dev->mm);
 free:
 	free_page((unsigned long)page_list);
 	return ret;
+
+}
+
+static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
+					   struct vhost_iotlb_msg *msg)
+{
+	struct vhost_dev *dev = &v->vdev;
+	struct vhost_iotlb *iotlb = dev->iotlb;
+
+	if (msg->iova < v->range.first ||
+	    msg->iova + msg->size - 1 > v->range.last)
+		return -EINVAL;
+
+	if (vhost_iotlb_itree_first(iotlb, msg->iova,
+				    msg->iova + msg->size - 1))
+		return -EEXIST;
+
+	return vhost_vdpa_pa_map(v, msg->iova, msg->size, msg->uaddr,
+				 msg->perm);
 }
 
 static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
-- 
2.11.0

