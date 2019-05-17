Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 856B421F53
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 23:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfEQVFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 17:05:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:33100 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbfEQVFK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 17:05:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 14:05:09 -0700
X-ExtLoop1: 1
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by fmsmga004.fm.intel.com with ESMTP; 17 May 2019 14:05:09 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     peterz@infradead.org, linux-mm@kvack.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     dave.hansen@intel.com, namit@vmware.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Meelis Roos <mroos@linux.ee>,
        "David S. Miller" <davem@davemloft.net>,
        Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/1] vmalloc: Fix issues with flush flag
Date:   Fri, 17 May 2019 14:01:23 -0700
Message-Id: <20190517210123.5702-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190517210123.5702-1-rick.p.edgecombe@intel.com>
References: <20190517210123.5702-1-rick.p.edgecombe@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Meelis Roos reported issues with the new VM_FLUSH_RESET_PERMS flag on the
sparc architecture.

When freeing many BPF JITs at once the free operations can become stuck
waiting for locks as they each try to vm_unmap_aliases(). Calls to this
function happen frequently on some archs, but in vmalloc itself the lazy
purge operations happens more rarely, where only in extreme cases could
multiple purges be happening at once. Since this is cross platform code we
shouldn't do this here where it could happen concurrently in a burst, and
instead just flush the TLB. Also, add a little logic to skip calls to
page_address() when possible to further speed this up, since they may have
locking on some archs.

Lastly, it appears that the calculation of the address range to flush
was broken at some point, so fix that as well.

Fixes: 868b104d7379 ("mm/vmalloc: Add flag for freeing of special permsissions")
Reported-by: Meelis Roos <mroos@linux.ee>
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
 mm/vmalloc.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 67bbb8d2a0a8..5daa7ec8950f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1531,9 +1531,10 @@ static inline void set_area_direct_map(const struct vm_struct *area,
 /* Handle removing and resetting vm mappings related to the vm_struct. */
 static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 {
+	const bool has_set_direct = IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP);
+	const bool flush_reset = area->flags & VM_FLUSH_RESET_PERMS;
 	unsigned long addr = (unsigned long)area->addr;
-	unsigned long start = ULONG_MAX, end = 0;
-	int flush_reset = area->flags & VM_FLUSH_RESET_PERMS;
+	unsigned long start = addr, end = addr + get_vm_area_size(area);
 	int i;
 
 	/*
@@ -1542,7 +1543,7 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 	 * This is concerned with resetting the direct map any an vm alias with
 	 * execute permissions, without leaving a RW+X window.
 	 */
-	if (flush_reset && !IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
+	if (flush_reset && !has_set_direct) {
 		set_memory_nx(addr, area->nr_pages);
 		set_memory_rw(addr, area->nr_pages);
 	}
@@ -1555,22 +1556,24 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 
 	/*
 	 * If not deallocating pages, just do the flush of the VM area and
-	 * return.
+	 * return. If the arch doesn't have set_direct_map_(), also skip the
+	 * below work.
 	 */
-	if (!deallocate_pages) {
-		vm_unmap_aliases();
+	if (!deallocate_pages || !has_set_direct) {
+		flush_tlb_kernel_range(addr, get_vm_area_size(area));
 		return;
 	}
 
 	/*
 	 * If execution gets here, flush the vm mapping and reset the direct
 	 * map. Find the start and end range of the direct mappings to make sure
-	 * the vm_unmap_aliases() flush includes the direct map.
+	 * the flush_tlb_kernel_range() includes the direct map.
 	 */
 	for (i = 0; i < area->nr_pages; i++) {
-		if (page_address(area->pages[i])) {
+		addr = (unsigned long)page_address(area->pages[i]);
+		if (addr) {
 			start = min(addr, start);
-			end = max(addr, end);
+			end = max(addr + PAGE_SIZE, end);
 		}
 	}
 
@@ -1580,7 +1583,7 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 	 * reset the direct map permissions to the default.
 	 */
 	set_area_direct_map(area, set_direct_map_invalid_noflush);
-	_vm_unmap_aliases(start, end, 1);
+	flush_tlb_kernel_range(start, end);
 	set_area_direct_map(area, set_direct_map_default_noflush);
 }
 
-- 
2.17.1

