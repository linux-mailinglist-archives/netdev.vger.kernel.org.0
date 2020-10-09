Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C8289933
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391611AbgJIUKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:10:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:40406 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403832AbgJITvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:51:06 -0400
IronPort-SDR: SD9nz5fTmWZyBOKnNyNhFLCkSRCkJ1a/XNJy/OvFfOQBQwdny4dR7EruCRRxmv68e4U8o8tfxx
 MKHZNHFKQmKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="162067781"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="162067781"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:51:03 -0700
IronPort-SDR: Zj7B8Ym6Opm+j7NgzILIxHvFMHLpJ+KeG5qMdRlGsqJzYlMhgHY+wciO+/VIwDrpca7gdal3tS
 LaUxL8Xa1x8w==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="343971995"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:51:02 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-cachefs@redhat.com,
        samba-technical@lists.samba.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH RFC PKS/PMEM 05/58] kmap: Introduce k[un]map_thread
Date:   Fri,  9 Oct 2020 12:49:40 -0700
Message-Id: <20201009195033.3208459-6-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

To correctly support the semantics of kmap() with Kernel protection keys
(PKS), kmap() may be required to set the protections on multiple
processors (globally).  Enabling PKS globally can be very expensive
depending on the requested operation.  Furthermore, enabling a domain
globally reduces the protection afforded by PKS.

Most kmap() (Aprox 209 of 229) callers use the map within a single thread and
have no need for the protection domain to be enabled globally.  However, the
remaining callers do not follow this pattern and, as best I can tell, expect
the mapping to be 'global' and available to any thread who may access the
mapping.[1]

We don't anticipate global mappings to pmem, however in general there is a
danger in changing the semantics of kmap().  Effectively, this would cause an
unresolved page fault with little to no information about why the failure
occurred.

To resolve this a number of options were considered.

1) Attempt to change all the thread local kmap() calls to kmap_atomic()[2]
2) Introduce a flags parameter to kmap() to indicate if the mapping should be
   global or not
3) Change ~20 call sites to 'kmap_global()' to indicate that they require a
   global enablement of the pages.
4) Change ~209 call sites to 'kmap_thread()' to indicate that the mapping is to
   be used within that thread of execution only

Option 1 is simply not feasible.  Option 2 would require all of the call sites
of kmap() to change.  Option 3 seems like a good minimal change but there is a
danger that new code may miss the semantic change of kmap() and not get the
behavior the developer intended.  Therefore, #4 was chosen.

Subsequent patches will convert most ~90% of the kmap callers to this new call
leaving about 10% of the existing kmap callers to enable PKS globally.

Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 include/linux/highmem.h | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 2a9806e3b8d2..ef7813544719 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -60,7 +60,7 @@ static inline void kmap_flush_tlb(unsigned long addr) { }
 #endif
 
 void *kmap_high(struct page *page);
-static inline void *kmap(struct page *page)
+static inline void *__kmap(struct page *page, bool global)
 {
 	void *addr;
 
@@ -74,20 +74,20 @@ static inline void *kmap(struct page *page)
 	 * Even non-highmem pages may have additional access protections which
 	 * need to be checked and potentially enabled.
 	 */
-	dev_page_enable_access(page, true);
+	dev_page_enable_access(page, global);
 	return addr;
 }
 
 void kunmap_high(struct page *page);
 
-static inline void kunmap(struct page *page)
+static inline void __kunmap(struct page *page, bool global)
 {
 	might_sleep();
 	/*
 	 * Even non-highmem pages may have additional access protections which
 	 * need to be checked and potentially disabled.
 	 */
-	dev_page_disable_access(page, true);
+	dev_page_disable_access(page, global);
 	if (!PageHighMem(page))
 		return;
 	kunmap_high(page);
@@ -160,10 +160,10 @@ static inline struct page *kmap_to_page(void *addr)
 
 static inline unsigned long totalhigh_pages(void) { return 0UL; }
 
-static inline void *kmap(struct page *page)
+static inline void *__kmap(struct page *page, bool global)
 {
 	might_sleep();
-	dev_page_enable_access(page, true);
+	dev_page_enable_access(page, global);
 	return page_address(page);
 }
 
@@ -171,9 +171,9 @@ static inline void kunmap_high(struct page *page)
 {
 }
 
-static inline void kunmap(struct page *page)
+static inline void __kunmap(struct page *page, bool global)
 {
-	dev_page_disable_access(page, true);
+	dev_page_disable_access(page, global);
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
 	kunmap_flush_on_unmap(page_address(page));
 #endif
@@ -238,6 +238,24 @@ static inline void kmap_atomic_idx_pop(void)
 
 #endif
 
+static inline void *kmap(struct page *page)
+{
+	return __kmap(page, true);
+}
+static inline void kunmap(struct page *page)
+{
+	__kunmap(page, true);
+}
+
+static inline void *kmap_thread(struct page *page)
+{
+	return __kmap(page, false);
+}
+static inline void kunmap_thread(struct page *page)
+{
+	__kunmap(page, false);
+}
+
 /*
  * Prevent people trying to call kunmap_atomic() as if it were kunmap()
  * kunmap_atomic() should get the return value of kmap_atomic, not the page.
-- 
2.28.0.rc0.12.gb6a658bd00c9

