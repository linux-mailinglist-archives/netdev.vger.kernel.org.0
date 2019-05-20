Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BB224474
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 01:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfETXjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 19:39:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:25217 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727216AbfETXjG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 19:39:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 16:39:06 -0700
X-ExtLoop1: 1
Received: from rpedgeco-mobl.amr.corp.intel.com (HELO localhost.intel.com) ([10.254.114.95])
  by fmsmga008.fm.intel.com with ESMTP; 20 May 2019 16:39:05 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        sparclinux@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, luto@amacapital.net
Cc:     dave.hansen@intel.com, namit@vmware.com, davem@davemloft.net,
        Rick Edgecombe <redgecombe.lkml@gmail.com>,
        Meelis Roos <mroos@linux.ee>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v2 2/2] vmalloc: Remove work as from vfree path
Date:   Mon, 20 May 2019 16:38:41 -0700
Message-Id: <20190520233841.17194-3-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520233841.17194-1-rick.p.edgecombe@intel.com>
References: <20190520233841.17194-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rick Edgecombe <redgecombe.lkml@gmail.com>

Calling vm_unmap_alias() in vm_remove_mappings() could potentially be a
lot of work to do on a free operation. Simply flushing the TLB instead of
the whole vm_unmap_alias() operation makes the frees faster and pushes
the heavy work to happen on allocation where it would be more expected.
In addition to the extra work, vm_unmap_alias() takes some locks including
a long hold of vmap_purge_lock, which will make all other
VM_FLUSH_RESET_PERMS vfrees wait while the purge operation happens.

Lastly, page_address() can involve locking and lookups on some
configurations, so skip calling this by exiting out early when
!CONFIG_ARCH_HAS_SET_DIRECT_MAP.

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
 mm/vmalloc.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 836888ae01f6..8d03427626dc 100644
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
@@ -2146,17 +2147,18 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 
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
 		addr = (unsigned long)page_address(area->pages[i]);
@@ -2172,7 +2174,7 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 	 * reset the direct map permissions to the default.
 	 */
 	set_area_direct_map(area, set_direct_map_invalid_noflush);
-	_vm_unmap_aliases(start, end, 1);
+	flush_tlb_kernel_range(start, end);
 	set_area_direct_map(area, set_direct_map_default_noflush);
 }
 
-- 
2.20.1

