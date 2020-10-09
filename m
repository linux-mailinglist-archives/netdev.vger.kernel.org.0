Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD9A2894D7
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389633AbgJITzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:55:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:15724 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391255AbgJITyI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:54:08 -0400
IronPort-SDR: PD9NuRA2y6vLuu3OosnNPzcT1pNAov1T/CEwGxuuRvOmvcbi4nkWO5n3VSTlagk71ZTFri+BcW
 DyTljUks/Rvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="164744176"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="164744176"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:54:07 -0700
IronPort-SDR: src9VKOvZKZdzmhAmOplZF/CbXKWViy2IZEce2k3Dk75HVdMa01qWYEbu8ywq24hGpakhLlrfI
 iYxmJaXcxtuw==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="519847335"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:54:06 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>, x86@kernel.org,
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
Subject: [PATCH RFC PKS/PMEM 57/58] nvdimm/pmem: Stray access protection for pmem->virt_addr
Date:   Fri,  9 Oct 2020 12:50:32 -0700
Message-Id: <20201009195033.3208459-58-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

The pmem driver uses a cached virtual address to access its memory
directly.  Because the nvdimm driver is well aware of the special
protections it has mapped memory with, we call dev_access_[en|dis]able()
around the direct pmem->virt_addr (pmem_addr) usage instead of the
unnecessary overhead of trying to get a page to kmap.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/nvdimm/pmem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index fab29b514372..e4dc1ae990fc 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -148,7 +148,9 @@ static blk_status_t pmem_do_read(struct pmem_device *pmem,
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
 		return BLK_STS_IOERR;
 
+	dev_access_enable(false);
 	rc = read_pmem(page, page_off, pmem_addr, len);
+	dev_access_disable(false);
 	flush_dcache_page(page);
 	return rc;
 }
@@ -180,11 +182,13 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
 	 * after clear poison.
 	 */
 	flush_dcache_page(page);
+	dev_access_enable(false);
 	write_pmem(pmem_addr, page, page_off, len);
 	if (unlikely(bad_pmem)) {
 		rc = pmem_clear_poison(pmem, pmem_off, len);
 		write_pmem(pmem_addr, page, page_off, len);
 	}
+	dev_access_disable(false);
 
 	return rc;
 }
-- 
2.28.0.rc0.12.gb6a658bd00c9

