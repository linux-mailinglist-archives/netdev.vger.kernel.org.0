Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB01F137A98
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 01:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgAKA3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 19:29:11 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33080 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbgAKA3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 19:29:11 -0500
Received: by mail-pg1-f196.google.com with SMTP id 6so1770563pgk.0
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 16:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z1oljhl2ycEHZWbLZ+RzzjjF8KtGlR4IWad6y7qdb94=;
        b=gk7kGspB2snM/wkshYVIwZq62scQn7AiKzZqmvDmE1eeD9zllq+nCsUnqYZrxYgXw0
         rcSwqB0u7BZjt+oW0LeFqWCb8bZ1P7y2M2RR7zH4hRm2v9KnNZkL9G9ghJ5koK9wIYHF
         lWEkV3AFMrjLVWJ4rOYZBwAMZDI9rcsi8GwOYN3cw+CTjrN5MQntIrhKTYFKOz+4iyTg
         eXpk3HeNyZsorkEaykObyFQD2UgT7ETnr7gi3yI/K3MLTn6684Mg1av9TEglTLz9v8Na
         uRM7f/nctTSBp05yhpJ0rRcwZ9uibtojWeIio/RuGFQ9aSfViKebG8yJR0uCMEd8sT0f
         eNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z1oljhl2ycEHZWbLZ+RzzjjF8KtGlR4IWad6y7qdb94=;
        b=XD7EdAzgTbyigJi2Xn8Ur0v6sVfScpjm1QVqWRJH66edjAD7oxlmfSwjKzjA9Cr1Jb
         3nZxIYEfNFMh1hJpvZffXo3msLMTJ6Xh7uqbBPCQGttbpD1w0SiA+yCyGyfCjmpWLj/q
         cnXC5XPrwQZZU5OtLl3biU4LHgfmHaUjvQKYxmknMCzttaamQoxSytgU1tRr0djN4lcd
         qOKvR2QTdHMJq/bckfvoY8j08G/F4JHAZDFqxUjKzo1UTk1Zl1Jfm9QxYjVIawFyI6yD
         s8eOzW2pe+0vnhxIOuegWdafx3wPkgpxbQbeUnBxLk+aGVIiR43RM+yHKtATrGgwe9OO
         zr+A==
X-Gm-Message-State: APjAAAW3CfzOA50N/g2/UpGWYi2SbMFqRb+fkiAShSJkoEJKPfcVoYPv
        i9kvV6DibTt7/MmiGFiI2awW4taK
X-Google-Smtp-Source: APXvYqxlDo/HhhLT6RpUNEhLbMmrYm1u2/xqNvHPplpw3e/JAZOWpZA1TSDoKgYjE197YNwwCTRNpQ==
X-Received: by 2002:a62:62c4:: with SMTP id w187mr7300329pfb.216.1578702550723;
        Fri, 10 Jan 2020 16:29:10 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id h126sm4567066pfe.19.2020.01.10.16.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 16:29:10 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org
Cc:     arjunroy@google.com, Arjun Roy <arjunroy.kdev@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH mm,net-next 1/3] mm: Refactor insert_page to prepare for batched-lock insert.
Date:   Fri, 10 Jan 2020 16:28:47 -0800
Message-Id: <20200111002849.252704-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper methods for vm_insert_page()/insert_page() to prepare for
vm_insert_pages(), which batch-inserts pages to reduce spinlock
operations when inserting multiple consecutive pages into the user
page table.

The intention of this patch-set is to reduce atomic ops for
tcp zerocopy receives, which normally hits the same spinlock multiple
times consecutively.

Signed-off-by: Arjun Roy <arjunroy.kdev@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 mm/memory.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7c6e19bdc428..7e23a9275386 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1693,6 +1693,27 @@ pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
 	return pte_alloc_map_lock(mm, pmd, addr, ptl);
 }
 
+static int validate_page_before_insert(struct page *page)
+{
+	if (PageAnon(page) || PageSlab(page))
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
@@ -1708,28 +1729,14 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	retval = -EINVAL;
-	if (PageAnon(page) || PageSlab(page))
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
-	pte_unmap_unlock(pte, ptl);
-	return retval;
-out_unlock:
+	retval = insert_page_into_pte_locked(mm, pte, addr, page, prot);
 	pte_unmap_unlock(pte, ptl);
 out:
 	return retval;
-- 
2.25.0.rc1.283.g88dfdc4193-goog

