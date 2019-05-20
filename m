Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2369224472
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 01:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfETXjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 19:39:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:25217 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727216AbfETXjF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 19:39:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 16:39:05 -0700
X-ExtLoop1: 1
Received: from rpedgeco-mobl.amr.corp.intel.com (HELO localhost.intel.com) ([10.254.114.95])
  by fmsmga008.fm.intel.com with ESMTP; 20 May 2019 16:39:04 -0700
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
Subject: [PATCH v2 1/2] vmalloc: Fix calculation of direct map addr range
Date:   Mon, 20 May 2019 16:38:40 -0700
Message-Id: <20190520233841.17194-2-rick.p.edgecombe@intel.com>
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

The calculation of the direct map address range to flush was wrong.
This could cause problems on x86 if a RO direct map alias ever got loaded
into the TLB. This shouldn't normally happen, but it could cause the
permissions to remain RO on the direct map alias, and then the page
would return from the page allocator to some other component as RO and
cause a crash.

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
 mm/vmalloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c42872ed82ac..836888ae01f6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2159,9 +2159,10 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
 	 * the vm_unmap_aliases() flush includes the direct map.
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
 
-- 
2.20.1

