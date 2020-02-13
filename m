Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC13815B740
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 03:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgBMClS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 21:41:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbgBMClS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 21:41:18 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 782A1206ED;
        Thu, 13 Feb 2020 02:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581561676;
        bh=0t6KHIJuCawpks8f0YEOVMRHbrFZCNj0rrv490GW5l4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X7Jcr6NSTwsp7aZfdB0TzJLVP+baZ7s1+HWyJGhnsJx2iGOh06dXPcbQAiuA7R5ZX
         MiAU46cdqwjcIxNtid0j06sUYiHU6KPJJYnSt7lRZya+seM5nwOKtWPvS01BuoMMOW
         Z3KvqqZV2sH071rmlNFpZNSXyWxJm/5H1m8pFmm8=
Date:   Wed, 12 Feb 2020 18:41:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        arjunroy@google.com, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH resend mm,net-next 1/3] mm: Refactor insert_page to
 prepare for batched-lock insert.
Message-Id: <20200212184115.127c17c6b0f9dab6fcae56c2@linux-foundation.org>
In-Reply-To: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 18:59:56 -0800 Arjun Roy <arjunroy.kdev@gmail.com> wrote:

> Add helper methods for vm_insert_page()/insert_page() to prepare for
> vm_insert_pages(), which batch-inserts pages to reduce spinlock
> operations when inserting multiple consecutive pages into the user
> page table.
> 
> The intention of this patch-set is to reduce atomic ops for
> tcp zerocopy receives, which normally hits the same spinlock multiple
> times consecutively.

I tweaked this a bit for the addition of page_has_type() to
insert_page().  Please check.



From: Arjun Roy <arjunroy.kdev@gmail.com>
Subject: mm: Refactor insert_page to prepare for batched-lock insert.

From: Arjun Roy <arjunroy@google.com>

Add helper methods for vm_insert_page()/insert_page() to prepare for
vm_insert_pages(), which batch-inserts pages to reduce spinlock
operations when inserting multiple consecutive pages into the user
page table.

The intention of this patch-set is to reduce atomic ops for
tcp zerocopy receives, which normally hits the same spinlock multiple
times consecutively.

Link: http://lkml.kernel.org/r/20200128025958.43490-1-arjunroy.kdev@gmail.com
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-refactor-insert_page-to-prepare-for-batched-lock-insert
+++ a/mm/memory.c
@@ -1430,6 +1430,27 @@ pte_t *__get_locked_pte(struct mm_struct
 	return pte_alloc_map_lock(mm, pmd, addr, ptl);
 }
 
+static int validate_page_before_insert(struct page *page)
+{
+	if (PageAnon(page) || PageSlab(page) || page_has_type(page))
+		return -EINVAL;
+	flush_dcache_page(page);
+	return 0;
+}
+
+static int insert_page_into_pte_locked(struct mm_struct *mm, pte_t *pte,
+			unsigned long addr, struct page *page, pgprot_t prot)
+{
+	if (!pte_none(*pte))
+		return -EBUSY;
+	/* Ok, finally just insert the thing.. */
+	get_page(page);
+	inc_mm_counter_fast(mm, mm_counter_file(page));
+	page_add_file_rmap(page, false);
+	set_pte_at(mm, addr, pte, mk_pte(page, prot));
+	return 0;
+}
+
 /*
  * This is the old fallback for page remapping.
  *
@@ -1445,26 +1466,14 @@ static int insert_page(struct vm_area_st
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	retval = -EINVAL;
-	if (PageAnon(page) || PageSlab(page) || page_has_type(page))
+	retval = validate_page_before_insert(page);
+	if (retval)
 		goto out;
 	retval = -ENOMEM;
-	flush_dcache_page(page);
 	pte = get_locked_pte(mm, addr, &ptl);
 	if (!pte)
 		goto out;
-	retval = -EBUSY;
-	if (!pte_none(*pte))
-		goto out_unlock;
-
-	/* Ok, finally just insert the thing.. */
-	get_page(page);
-	inc_mm_counter_fast(mm, mm_counter_file(page));
-	page_add_file_rmap(page, false);
-	set_pte_at(mm, addr, pte, mk_pte(page, prot));
-
-	retval = 0;
-out_unlock:
+	retval = insert_page_into_pte_locked(mm, pte, addr, page, prot);
 	pte_unmap_unlock(pte, ptl);
 out:
 	return retval;
_

