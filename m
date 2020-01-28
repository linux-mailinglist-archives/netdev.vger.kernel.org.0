Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8FF314AE3D
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 04:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgA1DAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 22:00:21 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54299 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgA1DAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 22:00:21 -0500
Received: by mail-pj1-f68.google.com with SMTP id dw13so354369pjb.4
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 19:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u9CzNOXIQWZlZqSBymnaz40dX76g7CidfQDhyQLunV0=;
        b=ktck6rNzKgV+z8cK9f5AxtP6c2b9DiRTFwa6YKfxS9smE9gMTMi4HF0CxjrWsUsfiD
         rftj6QKxMoIWFhuEnwheFZIr6nEddEjymzjrvNEhYQFnSOYjTXMGW8ztoSMqxwaMBWlq
         ZRkahb7/zhHkZBEqSJA2+ezqQLa8NnpHYjgs8rG5ya7T1H+whnhqmnd1hMbygGp2rNha
         tGCcujD3v9UJ+alQxIyuCJ75F1+e3a+hLmKq8xZeWR9B55pvUnUKUCyR3JklDlVqQJfe
         T4TDVBGlEHRm3BsN6lsWOUn8s8HlvrCii3ynoh6mLIm4SHd7GYVfD+27CX57I8Y4NXae
         B8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u9CzNOXIQWZlZqSBymnaz40dX76g7CidfQDhyQLunV0=;
        b=L1tsEVq4zkEkEy1B1ckSdSQoymjZaXfS8LtNZ064C/eHs4v1JdXiZxUc2PAkuV6rTd
         0aF8dxSkRgcvWsxcHCWnJhmV5t9HPGcl07AspEcF4x5MbTHwZqFU+FTpZ+yY0SZyAgkM
         ndTfn5pG4i5QCuo+4IvC4LxqIoTIjER29OrmeDV1kRAA3CNyaNaIPFwJpDw2Fe3S0/O4
         1qnRLPDPHMjGa+vFQgoBET92+XeA8Mu14JB35UJxwthN3kp38/4C/PWp6a4T1j9Xdinq
         jiLx1qsZLxmmyo/7LrOvo/JYtSuBGLsQUhJMu5aJiIXiR0yPTZlGKr7f2vvwax2ltNhf
         8KMA==
X-Gm-Message-State: APjAAAX7brEbbclsSGWQ1KZ3Y3+7Ms/U+9wkGz4fQHiTEQ6n1wofmR6f
        u7hZzVUtklY7ZtLaSVBjQNw=
X-Google-Smtp-Source: APXvYqw5WiiIVyo6WzOzJHmUPVYQBAJazgKKZP75PI8ASKBX8KGyUw7sj3mxbRWuC8No+dYA+u/BPg==
X-Received: by 2002:a17:90a:d141:: with SMTP id t1mr2118751pjw.38.1580180420595;
        Mon, 27 Jan 2020 19:00:20 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id p5sm18184677pga.69.2020.01.27.19.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 19:00:20 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org
Cc:     arjunroy@google.com, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH resend mm,net-next 2/3] mm: Add vm_insert_pages().
Date:   Mon, 27 Jan 2020 18:59:57 -0800
Message-Id: <20200128025958.43490-2-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
In-Reply-To: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Add the ability to insert multiple pages at once to a user VM with
lower PTE spinlock operations.

The intention of this patch-set is to reduce atomic ops for
tcp zerocopy receives, which normally hits the same spinlock multiple
times consecutively.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 include/linux/mm.h |   2 +
 mm/memory.c        | 111 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 29c928ba6b42..a3ac40fbe8fd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2563,6 +2563,8 @@ struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
+int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long *num);
 int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 int vm_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
diff --git a/mm/memory.c b/mm/memory.c
index 7e23a9275386..1655c5feaf32 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1670,8 +1670,7 @@ int zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
-pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
-			spinlock_t **ptl)
+static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -1690,6 +1689,16 @@ pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
 		return NULL;
 
 	VM_BUG_ON(pmd_trans_huge(*pmd));
+	return pmd;
+}
+
+pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
+			spinlock_t **ptl)
+{
+	pmd_t *pmd = walk_to_pmd(mm, addr);
+
+	if (!pmd)
+		return NULL;
 	return pte_alloc_map_lock(mm, pmd, addr, ptl);
 }
 
@@ -1714,6 +1723,15 @@ static int insert_page_into_pte_locked(struct mm_struct *mm, pte_t *pte,
 	return 0;
 }
 
+static int insert_page_in_batch_locked(struct mm_struct *mm, pmd_t *pmd,
+			unsigned long addr, struct page *page, pgprot_t prot)
+{
+	const int err = validate_page_before_insert(page);
+
+	return err ? err : insert_page_into_pte_locked(
+		mm, pte_offset_map(pmd, addr), addr, page, prot);
+}
+
 /*
  * This is the old fallback for page remapping.
  *
@@ -1742,6 +1760,95 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 	return retval;
 }
 
+/* insert_pages() amortizes the cost of spinlock operations
+ * when inserting pages in a loop.
+ */
+static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long *num, pgprot_t prot)
+{
+	pmd_t *pmd = NULL;
+	spinlock_t *pte_lock = NULL;
+	struct mm_struct *const mm = vma->vm_mm;
+	unsigned long curr_page_idx = 0;
+	unsigned long remaining_pages_total = *num;
+	unsigned long pages_to_write_in_pmd;
+	int ret;
+more:
+	ret = -EFAULT;
+	pmd = walk_to_pmd(mm, addr);
+	if (!pmd)
+		goto out;
+
+	pages_to_write_in_pmd = min_t(unsigned long,
+		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));
+
+	/* Allocate the PTE if necessary; takes PMD lock once only. */
+	ret = -ENOMEM;
+	if (pte_alloc(mm, pmd, addr))
+		goto out;
+	pte_lock = pte_lockptr(mm, pmd);
+
+	while (pages_to_write_in_pmd) {
+		int pte_idx = 0;
+		const int batch_size = min_t(int, pages_to_write_in_pmd, 8);
+
+		spin_lock(pte_lock);
+		for (; pte_idx < batch_size; ++pte_idx) {
+			int err = insert_page_in_batch_locked(mm, pmd,
+				addr, pages[curr_page_idx], prot);
+			if (unlikely(err)) {
+				spin_unlock(pte_lock);
+				ret = err;
+				remaining_pages_total -= pte_idx;
+				goto out;
+			}
+			addr += PAGE_SIZE;
+			++curr_page_idx;
+		}
+		spin_unlock(pte_lock);
+		pages_to_write_in_pmd -= batch_size;
+		remaining_pages_total -= batch_size;
+	}
+	if (remaining_pages_total)
+		goto more;
+	ret = 0;
+out:
+	*num = remaining_pages_total;
+	return ret;
+}
+
+/**
+ * vm_insert_pages - insert multiple pages into user vma, batching the pmd lock.
+ * @vma: user vma to map to
+ * @addr: target start user address of these pages
+ * @pages: source kernel pages
+ * @num: in: number of pages to map. out: number of pages that were *not*
+ * mapped. (0 means all pages were successfully mapped).
+ *
+ * Preferred over vm_insert_page() when inserting multiple pages.
+ *
+ * In case of error, we may have mapped a subset of the provided
+ * pages. It is the caller's responsibility to account for this case.
+ *
+ * The same restrictions apply as in vm_insert_page().
+ */
+int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
+			struct page **pages, unsigned long *num)
+{
+	const unsigned long end_addr = addr + (*num * PAGE_SIZE) - 1;
+
+	if (addr < vma->vm_start || end_addr >= vma->vm_end)
+		return -EFAULT;
+	if (!(vma->vm_flags & VM_MIXEDMAP)) {
+		BUG_ON(down_read_trylock(&vma->vm_mm->mmap_sem));
+		BUG_ON(vma->vm_flags & VM_PFNMAP);
+		vma->vm_flags |= VM_MIXEDMAP;
+	}
+	/* Defer page refcount checking till we're about to map that page. */
+	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
+}
+EXPORT_SYMBOL(vm_insert_pages);
+
 /**
  * vm_insert_page - insert single page into user vma
  * @vma: user vma to map to
-- 
2.25.0.rc1.283.g88dfdc4193-goog

