Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40D6289856
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391665AbgJIUHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:07:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:57645 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390898AbgJITwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:52:00 -0400
IronPort-SDR: 5+LUY2Awrr9j/tUQIAvjFtQA09wGVszIUmNQ5L2DFU9VGy9iI/QOZXZ6nS089EMR6yn+dOlt80
 BHiurkWZK9Mw==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="152450896"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="152450896"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:51:59 -0700
IronPort-SDR: eWSKFRksQmWHvS1j4lFouXjU/VQ78asIZFlodYo3aryNHFOArT/TLAMBqja15iBonRYEaVT+Tm
 vvSyZvytK3gg==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="462300719"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:51:57 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org,
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
Subject: [PATCH RFC PKS/PMEM 20/58] fs/jffs2: Utilize new kmap_thread()
Date:   Fri,  9 Oct 2020 12:49:55 -0700
Message-Id: <20201009195033.3208459-21-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

The kmap() calls in this FS are localized to a single thread.  To avoid
the over head of global PKRS updates use the new kmap_thread() call.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/jffs2/file.c | 4 ++--
 fs/jffs2/gc.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index f8fb89b10227..3e6d54f9b011 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -88,7 +88,7 @@ static int jffs2_do_readpage_nolock (struct inode *inode, struct page *pg)
 
 	BUG_ON(!PageLocked(pg));
 
-	pg_buf = kmap(pg);
+	pg_buf = kmap_thread(pg);
 	/* FIXME: Can kmap fail? */
 
 	ret = jffs2_read_inode_range(c, f, pg_buf, pg->index << PAGE_SHIFT,
@@ -103,7 +103,7 @@ static int jffs2_do_readpage_nolock (struct inode *inode, struct page *pg)
 	}
 
 	flush_dcache_page(pg);
-	kunmap(pg);
+	kunmap_thread(pg);
 
 	jffs2_dbg(2, "readpage finished\n");
 	return ret;
diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index 373b3b7c9f44..a7259783ab84 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -1335,7 +1335,7 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 		return PTR_ERR(page);
 	}
 
-	pg_ptr = kmap(page);
+	pg_ptr = kmap_thread(page);
 	mutex_lock(&f->sem);
 
 	offset = start;
@@ -1400,7 +1400,7 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 		}
 	}
 
-	kunmap(page);
+	kunmap_thread(page);
 	put_page(page);
 	return ret;
 }
-- 
2.28.0.rc0.12.gb6a658bd00c9

