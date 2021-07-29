Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171E53D9EC6
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhG2Hhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbhG2HhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:37:17 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABE2C0617B9
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:37:08 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n10so5962432plf.4
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xt4FGBYlYCoBvTMGFX8wpRBaBLf3wJnovwT0LsUO8q8=;
        b=jefg0U/kzqo2Pke+8yiv3pEOPdiX1EjTSI6KBzKyFhVx64UqKq7qiLLTWqKV406/Nb
         irltMT9UNo8mJi+m2HnKk6IsCvSxh03oBQmXR9OWpIlmvaYRutNy9baslJz94516Ybc0
         cZGHsV129zEbgnuCI6zU080NbKD/oSR4w+y5OgKGuugQ68BI4fCJfguQLA4wajt1dhvv
         jU57+T+MmNRurFDGFdKHCTYH0rglaFlnlUqcWyzUJVtteTzzXIL3xsKELstmNBhXRA7/
         k9EmY4OGd4Vg9oU1OCPvScIgzqDOGx83HN771IYqfCvYarnahsBRQ1Bwx+YsyCRlL9Z0
         kmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xt4FGBYlYCoBvTMGFX8wpRBaBLf3wJnovwT0LsUO8q8=;
        b=Eo8tSyLaCD7HIYCK5WApImKPsY4ZSndaaIEgdJEuaC9Bi28kMlWuk29eycO87lE0u2
         IciK/+pWAsh9EhOPQBFOxZIw93uPe2HKIZINHjhWhbvUGrcj4uib8rq5iqjkMHAVRqOT
         gHdEarOXl5/rIiEx+XAU0VE41CwYpJYePmzJtubGXrW4Lw6GflOS3CprePDm/rbiGAVo
         y0nKYgQrM8FPBSVmdD1DykoSIpBMJSvUmQ16HJz3zTRyrmAu0ylKPYfeXu+zfLPy2651
         e2wUEVyFezLiTKpEoezEOs4Zigx4+ICEVMxuFtzKF99nf7KbpLrkx2AI9X/I3uGfqYZY
         md0A==
X-Gm-Message-State: AOAM533zcbRnIifwMB8MISOmIn1zYa8zx9i7+Bc0tGKCHRrNpTjjcYgG
        glysJFYxIsuFUUyXZcFja0ry
X-Google-Smtp-Source: ABdhPJws3wzZj48/U7aBZtfKzdhkEFhOmachOQWeVbMby2BnglajLLXmR3OSjhKfTXb1IqETdZekfg==
X-Received: by 2002:a62:a20d:0:b029:35b:73da:dc8d with SMTP id m13-20020a62a20d0000b029035b73dadc8dmr3762117pff.54.1627544228102;
        Thu, 29 Jul 2021 00:37:08 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id y2sm2455191pfe.146.2021.07.29.00.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:37:07 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 13/17] vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
Date:   Thu, 29 Jul 2021 15:34:59 +0800
Message-Id: <20210729073503.187-14-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729073503.187-1-xieyongji@bytedance.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
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
 drivers/vhost/vdpa.c | 55 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 05536ada6d93..dec43895e84b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -511,7 +511,7 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	return r;
 }
 
-static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
+static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 {
 	struct vhost_dev *dev = &v->vdev;
 	struct vhost_iotlb *iotlb = dev->iotlb;
@@ -533,6 +533,11 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
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
@@ -613,38 +618,28 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
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
 
-	if (msg->iova < v->range.first || !msg->size ||
-	    msg->iova > U64_MAX - msg->size + 1 ||
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
@@ -658,7 +653,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 		goto unlock;
 	}
 
-	cur_base = msg->uaddr & PAGE_MASK;
+	cur_base = uaddr & PAGE_MASK;
 	iova &= PAGE_MASK;
 	nchunks = 0;
 
@@ -689,7 +684,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
 				ret = vhost_vdpa_map(v, iova, csize,
 						     map_pfn << PAGE_SHIFT,
-						     msg->perm);
+						     perm);
 				if (ret) {
 					/*
 					 * Unpin the pages that are left unmapped
@@ -718,7 +713,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 
 	/* Pin the rest chunk */
 	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, msg->perm);
+			     map_pfn << PAGE_SHIFT, perm);
 out:
 	if (ret) {
 		if (nchunks) {
@@ -737,13 +732,33 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
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
+	if (msg->iova < v->range.first || !msg->size ||
+	    msg->iova > U64_MAX - msg->size + 1 ||
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

