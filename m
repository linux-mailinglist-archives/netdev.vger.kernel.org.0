Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730A32BBA4
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfE0VLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:11:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:23653 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfE0VLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 17:11:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 14:11:24 -0700
X-ExtLoop1: 1
Received: from rpedgeco-mobl.amr.corp.intel.com (HELO localhost.intel.com) ([10.251.0.167])
  by orsmga008.jf.intel.com with ESMTP; 27 May 2019 14:11:24 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        sparclinux@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, luto@kernel.org
Cc:     dave.hansen@intel.com, namit@vmware.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Meelis Roos <mroos@linux.ee>,
        "David S. Miller" <davem@davemloft.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v5 1/2] vmalloc: Fix calculation of direct map addr range
Date:   Mon, 27 May 2019 14:10:57 -0700
Message-Id: <20190527211058.2729-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190527211058.2729-1-rick.p.edgecombe@intel.com>
References: <20190527211058.2729-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The calculation of the direct map address range to flush was wrong.
This could cause the RO direct map alias to not get flushed. Today
this shouldn't be a problem because this flush is only needed on x86
right now and the spurious fault handler will fix cached RO->RW
translations. In the future though, it could cause the permissions
to remain RO in the TLB for the direct map alias, and then the page
would return from the page allocator to some other component as RO
and cause a crash.

So fix fix the address range calculation so the flush will include the
direct map range.

Fixes: 868b104d7379 ("mm/vmalloc: Add flag for freeing of special permsissions")
Cc: Meelis Roos <mroos@linux.ee>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 mm/vmalloc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 233af6936c93..3ede9c064477 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2123,7 +2123,6 @@ static inline void set_area_direct_map(const struct vm_struct *area,
 /* Handle removing and resetting vm mappings related to the vm_struct. */
 static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 {
-	unsigned long addr = (unsigned long)area->addr;
 	unsigned long start = ULONG_MAX, end = 0;
 	int flush_reset = area->flags & VM_FLUSH_RESET_PERMS;
 	int i;
@@ -2135,8 +2134,8 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 	 * execute permissions, without leaving a RW+X window.
 	 */
 	if (flush_reset && !IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		set_memory_nx(addr, area->nr_pages);
-		set_memory_rw(addr, area->nr_pages);
+		set_memory_nx((unsigned long)area->addr, area->nr_pages);
+		set_memory_rw((unsigned long)area->addr, area->nr_pages);
 	}
 
 	remove_vm_area(area->addr);
@@ -2160,9 +2159,11 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 	 * the vm_unmap_aliases() flush includes the direct map.
 	 */
 	for (i = 0; i < area->nr_pages; i++) {
-		if (page_address(area->pages[i])) {
+		unsigned long addr =
+				(unsigned long)page_address(area->pages[i]);
+		if (addr) {
 			start = min(addr, start);
-			end = max(addr, end);
+			end = max(addr + PAGE_SIZE, end);
 		}
 	}
 
-- 
2.20.1

