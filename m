Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB828989B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391759AbgJIUHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:07:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:1621 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403959AbgJITvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:51:42 -0400
IronPort-SDR: OvUdnTIo53H2AyyTnYh4FWnAgUT0vb6jIYBsFTvfZM4VsCqvxXdHL/PCZfQ+hdONhRPcaXWgsk
 GWtbV+Ff7Znw==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="227178845"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="227178845"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:51:39 -0700
IronPort-SDR: 6nDyG/rNIU8VCp7PRxt8N7VM6Ts7FaR6Cq3BMAOPdzxAbIieQhQY1hWISzmf8TSYIGXE2cP/wS
 1DDas2UbMNkw==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="345147432"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:51:37 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>, Steve French <sfrench@samba.org>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: [PATCH RFC PKS/PMEM 14/58] fs/cifs: Utilize new kmap_thread()
Date:   Fri,  9 Oct 2020 12:49:49 -0700
Message-Id: <20201009195033.3208459-15-ira.weiny@intel.com>
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

Cc: Steve French <sfrench@samba.org>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/cifs/cifsencrypt.c |  6 +++---
 fs/cifs/file.c        | 16 ++++++++--------
 fs/cifs/smb2ops.c     |  8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 9daa256f69d4..2f8232d01a56 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -82,17 +82,17 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 
 		rqst_page_get_length(rqst, i, &len, &offset);
 
-		kaddr = (char *) kmap(rqst->rq_pages[i]) + offset;
+		kaddr = (char *) kmap_thread(rqst->rq_pages[i]) + offset;
 
 		rc = crypto_shash_update(shash, kaddr, len);
 		if (rc) {
 			cifs_dbg(VFS, "%s: Could not update with payload\n",
 				 __func__);
-			kunmap(rqst->rq_pages[i]);
+			kunmap_thread(rqst->rq_pages[i]);
 			return rc;
 		}
 
-		kunmap(rqst->rq_pages[i]);
+		kunmap_thread(rqst->rq_pages[i]);
 	}
 
 	rc = crypto_shash_final(shash, signature);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index be46fab4c96d..6db2caab8852 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2145,17 +2145,17 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	inode = page->mapping->host;
 
 	offset += (loff_t)from;
-	write_data = kmap(page);
+	write_data = kmap_thread(page);
 	write_data += from;
 
 	if ((to > PAGE_SIZE) || (from > to)) {
-		kunmap(page);
+		kunmap_thread(page);
 		return -EIO;
 	}
 
 	/* racing with truncate? */
 	if (offset > mapping->host->i_size) {
-		kunmap(page);
+		kunmap_thread(page);
 		return 0; /* don't care */
 	}
 
@@ -2183,7 +2183,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 			rc = -EIO;
 	}
 
-	kunmap(page);
+	kunmap_thread(page);
 	return rc;
 }
 
@@ -2559,10 +2559,10 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 		   known which we might as well	leverage */
 		/* BB check if anything else missing out of ppw
 		   such as updating last write time */
-		page_data = kmap(page);
+		page_data = kmap_thread(page);
 		rc = cifs_write(cfile, pid, page_data + offset, copied, &pos);
 		/* if (rc < 0) should we set writebehind rc? */
-		kunmap(page);
+		kunmap_thread(page);
 
 		free_xid(xid);
 	} else {
@@ -4511,7 +4511,7 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 	if (rc == 0)
 		goto read_complete;
 
-	read_data = kmap(page);
+	read_data = kmap_thread(page);
 	/* for reads over a certain size could initiate async read ahead */
 
 	rc = cifs_read(file, read_data, PAGE_SIZE, poffset);
@@ -4540,7 +4540,7 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 	rc = 0;
 
 io_error:
-	kunmap(page);
+	kunmap_thread(page);
 	unlock_page(page);
 
 read_complete:
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 32f90dc82c84..a3e7ebab38b6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4068,12 +4068,12 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 
 			rqst_page_get_length(&new_rq[i], j, &len, &offset);
 
-			dst = (char *) kmap(new_rq[i].rq_pages[j]) + offset;
-			src = (char *) kmap(old_rq[i - 1].rq_pages[j]) + offset;
+			dst = (char *) kmap_thread(new_rq[i].rq_pages[j]) + offset;
+			src = (char *) kmap_thread(old_rq[i - 1].rq_pages[j]) + offset;
 
 			memcpy(dst, src, len);
-			kunmap(new_rq[i].rq_pages[j]);
-			kunmap(old_rq[i - 1].rq_pages[j]);
+			kunmap_thread(new_rq[i].rq_pages[j]);
+			kunmap_thread(old_rq[i - 1].rq_pages[j]);
 		}
 	}
 
-- 
2.28.0.rc0.12.gb6a658bd00c9

