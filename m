Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077112894A2
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391296AbgJITyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:54:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:15724 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391245AbgJITyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:54:06 -0400
IronPort-SDR: 7qaDjl2/ZxevUxp9SIgeuOAu8od3VQFfONS9RP6IrIk3xZmTXRvkzFi7/Qwdz+i1yGXcanWplh
 jXuBSYf4vxRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="164744163"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="164744163"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:54:04 -0700
IronPort-SDR: NEiErKYZfPZGqrWyxIZ0z43ef9+IKjrcXd9NJIRckxXQwdDEMd5poh/dknsqhifod6Ym/UoaZd
 Mu4h9c7DJvbA==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="462301216"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:54:03 -0700
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
Subject: [PATCH RFC PKS/PMEM 56/58] dax: Stray access protection for dax_direct_access()
Date:   Fri,  9 Oct 2020 12:50:31 -0700
Message-Id: <20201009195033.3208459-57-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

dax_direct_access() is a special case of accessing pmem via a page
offset and without a struct page.

Because the dax driver is well aware of the special protections it has
mapped memory with, call dev_access_[en|dis]able() directly instead of
the unnecessary overhead of trying to get a page to kmap.

Similar to kmap, we leverage existing functions, dax_read_[un]lock(),
because they are already required to surround the use of the memory
returned from dax_direct_access().

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/dax/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e84070b55463..0ddb3ee73e36 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -30,6 +30,7 @@ static DEFINE_SPINLOCK(dax_host_lock);
 
 int dax_read_lock(void)
 {
+	dev_access_enable(false);
 	return srcu_read_lock(&dax_srcu);
 }
 EXPORT_SYMBOL_GPL(dax_read_lock);
@@ -37,6 +38,7 @@ EXPORT_SYMBOL_GPL(dax_read_lock);
 void dax_read_unlock(int id)
 {
 	srcu_read_unlock(&dax_srcu, id);
+	dev_access_disable(false);
 }
 EXPORT_SYMBOL_GPL(dax_read_unlock);
 
-- 
2.28.0.rc0.12.gb6a658bd00c9

