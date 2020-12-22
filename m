Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD5D2E0C29
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgLVOy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgLVOy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:54:57 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E81C0619DE
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:54:21 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id n25so2991108pgb.0
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cR7jZ79Sb8lqcBGvyOl+8bdB8wHIq1EQVGYqgM9O97E=;
        b=z/yt6Hd1hZv+ox368PvLBGyeWoiEP3AjT55CJn/qkKnI5c1649754/dXxODxT6gcnk
         esn4XxR5pM7VVN83bkwR+M1aAnPPtXhkHjtA0zgGy9lLzbccaI74Cuxn7jlUl+sO0uJb
         0S4Mvyyv6b0/RmuybT6zmD6fYhaX5XQEU/a7PBLiOV8EJ884+cksPse1iEC61dEi7S3Z
         Lg1XioKH4nqXPkD60fPdwgMoDpPQAYpbb5Kae8h0JetEGoKBx+qiHqAo8OpUcxZluOA8
         KtpYhpmZOHygn+LFpX963N2wZNyCEZahTb7eUQ3OFWQ19vZ8MDDXdPp9fuhHQxtPslcf
         IRxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cR7jZ79Sb8lqcBGvyOl+8bdB8wHIq1EQVGYqgM9O97E=;
        b=GD4Q5cjqeKW3SM59B2MDXHuGtUxP0uYkJSx8tXWdgFb2698k1IaOkQtu+RyUK+rzng
         hcxrT0Jr1ah4YtbHNsjHjpApjfuVcQaV+6oMagOtv6rFO9Ur75/vGv+PhPWJe1cc7gcg
         mVCEWYFF5b8hotcs2OWsF7nfu7nS2103gGFbkPIzFeUW7/xHFo9tYP1PsVjDKuOF6TN0
         J7VH7F7AtG9KgUBremjZLoEOO2UERxHg/+K7hgkb3GsBW0UzZvHFVX+icWjmpIrAizIP
         4go2dKl7mmWo42Omdp2RiylPAhKQh+G1nsXnPkXDFEK2a+jj5isdNl6Rxy6LUBDlpFzw
         B9Ow==
X-Gm-Message-State: AOAM531meEMWg0R0FmlJslTb1MiNaZ/3V/yLtYq0365cwnIn7UydaRaA
        hh62WCYUnwIj+LNFQzE1hzOM
X-Google-Smtp-Source: ABdhPJxXMqptUBDlJmnO+A6ZpHHaPhrTIrYuz6A++hcMoz2+nU+3pr189Qont8EBCkjnXew1W8fVZw==
X-Received: by 2002:a63:4517:: with SMTP id s23mr2068953pga.267.1608648861396;
        Tue, 22 Dec 2020 06:54:21 -0800 (PST)
Received: from localhost ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id q23sm21530540pfg.18.2020.12.22.06.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 06:54:20 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, akpm@linux-foundation.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC v2 11/13] vduse/iova_domain: Support reclaiming bounce pages
Date:   Tue, 22 Dec 2020 22:52:19 +0800
Message-Id: <20201222145221.711-12-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222145221.711-1-xieyongji@bytedance.com>
References: <20201222145221.711-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce vduse_domain_reclaim() to support reclaiming bounce page
when necessary. We will do reclaiming chunk by chunk. And only
reclaim the iova chunk that no one used.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_user/iova_domain.c | 83 ++++++++++++++++++++++++++++++++++--
 drivers/vdpa/vdpa_user/iova_domain.h | 10 +++++
 2 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
index 27022157abc6..c438cc85d33d 100644
--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -29,6 +29,8 @@ struct vduse_mmap_vma {
 	struct list_head list;
 };
 
+struct percpu_counter vduse_total_bounce_pages;
+
 static inline struct page *
 vduse_domain_get_bounce_page(struct vduse_iova_domain *domain,
 				unsigned long iova)
@@ -48,6 +50,13 @@ vduse_domain_set_bounce_page(struct vduse_iova_domain *domain,
 	unsigned long chunkoff = iova & ~IOVA_CHUNK_MASK;
 	unsigned long pgindex = chunkoff >> PAGE_SHIFT;
 
+	if (page) {
+		domain->chunks[index].used_bounce_pages++;
+		percpu_counter_inc(&vduse_total_bounce_pages);
+	} else {
+		domain->chunks[index].used_bounce_pages--;
+		percpu_counter_dec(&vduse_total_bounce_pages);
+	}
 	domain->chunks[index].bounce_pages[pgindex] = page;
 }
 
@@ -175,6 +184,29 @@ void vduse_domain_remove_mapping(struct vduse_iova_domain *domain,
 	}
 }
 
+static bool vduse_domain_try_unmap(struct vduse_iova_domain *domain,
+				unsigned long iova, size_t size)
+{
+	struct vduse_mmap_vma *mmap_vma;
+	unsigned long uaddr;
+	bool unmap = true;
+
+	mutex_lock(&domain->vma_lock);
+	list_for_each_entry(mmap_vma, &domain->vma_list, list) {
+		if (!mmap_read_trylock(mmap_vma->vma->vm_mm)) {
+			unmap = false;
+			break;
+		}
+
+		uaddr = iova + mmap_vma->vma->vm_start;
+		zap_page_range(mmap_vma->vma, uaddr, size);
+		mmap_read_unlock(mmap_vma->vma->vm_mm);
+	}
+	mutex_unlock(&domain->vma_lock);
+
+	return unmap;
+}
+
 void vduse_domain_unmap(struct vduse_iova_domain *domain,
 			unsigned long iova, size_t size)
 {
@@ -302,6 +334,32 @@ bool vduse_domain_is_direct_map(struct vduse_iova_domain *domain,
 	return atomic_read(&chunk->map_type) == TYPE_DIRECT_MAP;
 }
 
+int vduse_domain_reclaim(struct vduse_iova_domain *domain)
+{
+	struct vduse_iova_chunk *chunk;
+	int i, freed = 0;
+
+	for (i = domain->chunk_num - 1; i >= 0; i--) {
+		chunk = &domain->chunks[i];
+		if (!chunk->used_bounce_pages)
+			continue;
+
+		if (atomic_cmpxchg(&chunk->state, 0, INT_MIN) != 0)
+			continue;
+
+		if (!vduse_domain_try_unmap(domain,
+				chunk->start, IOVA_CHUNK_SIZE)) {
+			atomic_sub(INT_MIN, &chunk->state);
+			break;
+		}
+		freed += vduse_domain_free_bounce_pages(domain,
+				chunk->start, IOVA_CHUNK_SIZE);
+		atomic_sub(INT_MIN, &chunk->state);
+	}
+
+	return freed;
+}
+
 unsigned long vduse_domain_alloc_iova(struct vduse_iova_domain *domain,
 					size_t size, enum iova_map_type type)
 {
@@ -319,10 +377,13 @@ unsigned long vduse_domain_alloc_iova(struct vduse_iova_domain *domain,
 		if (atomic_read(&chunk->map_type) != type)
 			continue;
 
-		iova = gen_pool_alloc_algo(chunk->pool, size,
+		if (atomic_fetch_inc(&chunk->state) >= 0) {
+			iova = gen_pool_alloc_algo(chunk->pool, size,
 					gen_pool_first_fit_align, &data);
-		if (iova)
-			break;
+			if (iova)
+				break;
+		}
+		atomic_dec(&chunk->state);
 	}
 
 	return iova;
@@ -335,6 +396,7 @@ void vduse_domain_free_iova(struct vduse_iova_domain *domain,
 	struct vduse_iova_chunk *chunk = &domain->chunks[index];
 
 	gen_pool_free(chunk->pool, iova, size);
+	atomic_dec(&chunk->state);
 }
 
 static void vduse_iova_chunk_cleanup(struct vduse_iova_chunk *chunk)
@@ -351,7 +413,8 @@ void vduse_iova_domain_destroy(struct vduse_iova_domain *domain)
 
 	for (i = 0; i < domain->chunk_num; i++) {
 		chunk = &domain->chunks[i];
-		vduse_domain_free_bounce_pages(domain,
+		if (chunk->used_bounce_pages)
+			vduse_domain_free_bounce_pages(domain,
 					chunk->start, IOVA_CHUNK_SIZE);
 		vduse_iova_chunk_cleanup(chunk);
 	}
@@ -390,8 +453,10 @@ static int vduse_iova_chunk_init(struct vduse_iova_chunk *chunk,
 	if (!chunk->iova_map)
 		goto err;
 
+	chunk->used_bounce_pages = 0;
 	chunk->start = addr;
 	atomic_set(&chunk->map_type, TYPE_NONE);
+	atomic_set(&chunk->state, 0);
 
 	return 0;
 err:
@@ -440,3 +505,13 @@ struct vduse_iova_domain *vduse_iova_domain_create(size_t size)
 
 	return NULL;
 }
+
+int vduse_domain_init(void)
+{
+	return percpu_counter_init(&vduse_total_bounce_pages, 0, GFP_KERNEL);
+}
+
+void vduse_domain_exit(void)
+{
+	percpu_counter_destroy(&vduse_total_bounce_pages);
+}
diff --git a/drivers/vdpa/vdpa_user/iova_domain.h b/drivers/vdpa/vdpa_user/iova_domain.h
index fe1816287f5f..6815b00629d2 100644
--- a/drivers/vdpa/vdpa_user/iova_domain.h
+++ b/drivers/vdpa/vdpa_user/iova_domain.h
@@ -31,8 +31,10 @@ struct vduse_iova_chunk {
 	struct gen_pool *pool;
 	struct page **bounce_pages;
 	struct vduse_iova_map **iova_map;
+	int used_bounce_pages;
 	unsigned long start;
 	atomic_t map_type;
+	atomic_t state;
 };
 
 struct vduse_iova_domain {
@@ -44,6 +46,8 @@ struct vduse_iova_domain {
 	struct list_head vma_list;
 };
 
+extern struct percpu_counter vduse_total_bounce_pages;
+
 int vduse_domain_add_vma(struct vduse_iova_domain *domain,
 				struct vm_area_struct *vma);
 
@@ -77,6 +81,8 @@ int vduse_domain_bounce_map(struct vduse_iova_domain *domain,
 bool vduse_domain_is_direct_map(struct vduse_iova_domain *domain,
 				unsigned long iova);
 
+int vduse_domain_reclaim(struct vduse_iova_domain *domain);
+
 unsigned long vduse_domain_alloc_iova(struct vduse_iova_domain *domain,
 					size_t size, enum iova_map_type type);
 
@@ -90,4 +96,8 @@ void vduse_iova_domain_destroy(struct vduse_iova_domain *domain);
 
 struct vduse_iova_domain *vduse_iova_domain_create(size_t size);
 
+int vduse_domain_init(void);
+
+void vduse_domain_exit(void);
+
 #endif /* _VDUSE_IOVA_DOMAIN_H */
-- 
2.11.0

