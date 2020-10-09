Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1593B289518
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390144AbgJITzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:55:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:28724 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391234AbgJITx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:53:59 -0400
IronPort-SDR: 3iDe5NejxsDh9FOYg6KOLN9iu6KOFOJjJxeE0i5kD8Ld7EF88MErV+Y2f55npStNuALGtPOVmt
 VstioKeBLamQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="165643381"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="165643381"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:53:57 -0700
IronPort-SDR: I2dap8dqfU4jkUPjfDUEInlXytro00aRpG9kPai7q+149QpAXJ//5ZcvM1PB/3zTdLq6ZFWD0B
 HAucu70KNsIA==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="343972515"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:53:56 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, x86@kernel.org,
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
Subject: [PATCH RFC PKS/PMEM 54/58] powerpc: Utilize new kmap_thread()
Date:   Fri,  9 Oct 2020 12:50:29 -0700
Message-Id: <20201009195033.3208459-55-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

These kmap() calls are localized to a single thread.  To avoid the over
head of global PKRS updates use the new kmap_thread() call.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 arch/powerpc/mm/mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 42e25874f5a8..6ef557b8dda6 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -573,9 +573,9 @@ void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 {
 	unsigned long maddr;
 
-	maddr = (unsigned long) kmap(page) + (addr & ~PAGE_MASK);
+	maddr = (unsigned long) kmap_thread(page) + (addr & ~PAGE_MASK);
 	flush_icache_range(maddr, maddr + len);
-	kunmap(page);
+	kunmap_thread(page);
 }
 
 /*
-- 
2.28.0.rc0.12.gb6a658bd00c9

