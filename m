Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6BAF241BE
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 22:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfETUHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 16:07:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:5053 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfETUHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 16:07:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 13:07:49 -0700
X-ExtLoop1: 1
Received: from cavannie-mobl1.amr.corp.intel.com (HELO localhost.intel.com) ([10.254.114.95])
  by fmsmga007.fm.intel.com with ESMTP; 20 May 2019 13:07:48 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        sparclinux@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org
Cc:     dave.hansen@intel.com, namit@vmware.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Meelis Roos <mroos@linux.ee>,
        "David S. Miller" <davem@davemloft.net>,
        Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2] vmalloc: Fix issues with flush flag
Date:   Mon, 20 May 2019 13:07:03 -0700
Message-Id: <20190520200703.15997-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch VM_FLUSH_RESET_PERMS to use a regular TLB flush intead of
vm_unmap_aliases() and fix calculation of the direct map for the
CONFIG_ARCH_HAS_SET_DIRECT_MAP case.

Meelis Roos reported issues with the new VM_FLUSH_RESET_PERMS flag on a
sparc machine. On investigation some issues were noticed:

1. The calculation of the direct map address range to flush was wrong.
This could cause problems on x86 if a RO direct map alias ever got loaded
into the TLB. This shouldn't normally happen, but it could cause the
permissions to remain RO on the direct map alias, and then the page
would return from the page allocator to some other component as RO and
cause a crash.

2. Calling vm_unmap_alias() on vfree could potentially be a lot of work to
do on a free operation. Simply flushing the TLB instead of the whole
vm_unmap_alias() operation makes the frees faster and pushes the heavy
work to happen on allocation where it would be more expected.
In addition to the extra work, vm_unmap_alias() takes some locks including
a long hold of vmap_purge_lock, which will make all other
VM_FLUSH_RESET_PERMS vfrees wait while the purge operation happens.

3. page_address() can have locking on some configurations, so skip calling
this when possible to further speed this up.

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

Changes since v1:
 - Update commit message with more detail
 - Fix flush end range on !CONFIG_ARCH_HAS_SET_DIRECT_MAP case

 mm/vmalloc.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c42872ed82ac..8d03427626dc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2122,9 +2122,10 @@ static inline void set_area_direct_map(const struct vm_struct *area,
 /* Handle removing and resetting vm mappings related to the vm_struct. */
 static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 {
+	const bool has_set_direct = IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP);
+	const bool flush_reset = area->flags & VM_FLUSH_RESET_PERMS;
 	unsigned long addr = (unsigned long)area->addr;
-	unsigned long start = ULONG_MAX, end = 0;
-	int flush_reset = area->flags & VM_FLUSH_RESET_PERMS;
+	unsigned long start = addr, end = addr + area->size;
 	int i;
 
 	/*
@@ -2133,7 +2134,7 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 	 * This is concerned with resetting the direct map any an vm alias with
 	 * execute permissions, without leaving a RW+X window.
 	 */
-	if (flush_reset && !IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
+	if (flush_reset && !has_set_direct) {
 		set_memory_nx(addr, area->nr_pages);
 		set_memory_rw(addr, area->nr_pages);
 	}
@@ -2146,22 +2147,24 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 
 	/*
 	 * If not deallocating pages, just do the flush of the VM area and
-	 * return.
+	 * return. If the arch doesn't have set_direct_map_(), also skip the
+	 * below work.
 	 */
-	if (!deallocate_pages) {
-		vm_unmap_aliases();
+	if (!deallocate_pages || !has_set_direct) {
+		flush_tlb_kernel_range(start, end);
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
 
@@ -2171,7 +2174,7 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 	 * reset the direct map permissions to the default.
 	 */
 	set_area_direct_map(area, set_direct_map_invalid_noflush);
-	_vm_unmap_aliases(start, end, 1);
+	flush_tlb_kernel_range(start, end);
 	set_area_direct_map(area, set_direct_map_default_noflush);
 }
 
-- 
2.20.1

