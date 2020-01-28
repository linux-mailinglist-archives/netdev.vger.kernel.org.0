Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6468614AE3C
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 04:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgA1DAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 22:00:03 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39480 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgA1DAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 22:00:03 -0500
Received: by mail-pj1-f66.google.com with SMTP id e9so351489pjr.4
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 19:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zb3vaMlCnEIaKoKuEPxaWXPkDmU9sA/hlBePDwvbZxg=;
        b=LiOCq7RXddMvB8gqmSOf6SqFzuigpHoidXnqfx1tmw4gchYK7DyHGRfRRMRmeiQHa5
         JKbTG4aY/Gr6SoFpadbwo62q0ywyr/n3o3LOMTlg76mA6a63mFuE5xmU2ZXO7uZumOi5
         Ec4mciVce/7oP2Y+cfIVVW1kxwUFSxeUg4pH3SUXeYl4DyzslPuFRAB/+J9lGqn91bSw
         NDPQpuPhm/U3Co3DSk5D3hf1a8Wi4F2OIjUJYK6oDRB9CHUGrV2oQ4CykjitPHhMQwRI
         sgCs2Am8qmGS/sulZboX2fGRFlECoQ31PNVW3HfBi/6L1+mSoit81VWMFpIPqY8Sktiu
         bIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zb3vaMlCnEIaKoKuEPxaWXPkDmU9sA/hlBePDwvbZxg=;
        b=eOJrtpE/QY9qWdNnF0PiuOoib+dlgNWwAW74VdICXbUPL8g5fcvD+RcH6dofK+HpL+
         3s+TQcfiyHwuqRm+4tUrh6ZB7wq/Zen2WrfhcdlKnIWQ3v4G9xbQ6SBdpavKj3CFVr/z
         8Scowjju1iV3iYUzqRJA0azaOih2if/VY++/gNMJeaOq2GejwelNDFSXpWf4UTiY6a1b
         AY9Iju5q6v9B0RM77J9mJHx4ZiMjz3XMpbgjWFhSYJ4ZfI2jBVNxuYdjY/NrMDpIuXt0
         TJ+J6VWBG5BHyioRQurcEgYvtzQtpv4jOori22yvl6XSjT7IwCBldz3IPVuoZ6AxNQS4
         LQgA==
X-Gm-Message-State: APjAAAW+22FhIuQzMhx8BC2zRC09vdR5v8pLRZF8v3FyB+QoTawTXTLL
        LHVIkUhfAYTx+MFo525r7TXQYizE
X-Google-Smtp-Source: APXvYqxdehSUpRTXWeeWl84SjIcqzzB1FI5QVI5bMLYuYQHCyF2qDcEOjLEyJArRTHCaPCpAvV9H9w==
X-Received: by 2002:a17:90a:858a:: with SMTP id m10mr2092329pjn.117.1580180402682;
        Mon, 27 Jan 2020 19:00:02 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:2b0a:8c1:6a84:1aa0])
        by smtp.gmail.com with ESMTPSA id p5sm18184677pga.69.2020.01.27.19.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 19:00:02 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org
Cc:     arjunroy@google.com, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH resend mm,net-next 1/3] mm: Refactor insert_page to prepare for batched-lock insert.
Date:   Mon, 27 Jan 2020 18:59:56 -0800
Message-Id: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Add helper methods for vm_insert_page()/insert_page() to prepare for
vm_insert_pages(), which batch-inserts pages to reduce spinlock
operations when inserting multiple consecutive pages into the user
page table.

The intention of this patch-set is to reduce atomic ops for
tcp zerocopy receives, which normally hits the same spinlock multiple
times consecutively.

Signed-off-by: Arjun Roy <arjunroy@google.com>
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

