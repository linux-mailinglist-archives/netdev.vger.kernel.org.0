Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E702893DE
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391061AbgJITxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:53:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:1664 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403996AbgJITvy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:51:54 -0400
IronPort-SDR: dx2C651xObHLbB3ebXZq7O3vvDLCkCp7YyEriat/+Fn1vQtkkOifEieLP9BqvQO5TVmymYi7WM
 okOGmreQGHCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="227178891"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="227178891"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:51:47 -0700
IronPort-SDR: vdHXKYZiEWUJ0fN4OExd2VqdiXE9aYdlaLF6p7mD2X3g24JwvvcNWIkVlfM1uW7/GA3kn+ap6+
 Rex2Wyxl2AaA==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="298531066"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:51:47 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>, x86@kernel.org,
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
Subject: [PATCH RFC PKS/PMEM 17/58] fs/nilfs2: Utilize new kmap_thread()
Date:   Fri,  9 Oct 2020 12:49:52 -0700
Message-Id: <20201009195033.3208459-18-ira.weiny@intel.com>
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

Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/nilfs2/alloc.c  | 34 +++++++++++++++++-----------------
 fs/nilfs2/cpfile.c |  4 ++--
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index adf3bb0a8048..2aa4c34094ef 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -524,7 +524,7 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 		ret = nilfs_palloc_get_desc_block(inode, group, 1, &desc_bh);
 		if (ret < 0)
 			return ret;
-		desc_kaddr = kmap(desc_bh->b_page);
+		desc_kaddr = kmap_thread(desc_bh->b_page);
 		desc = nilfs_palloc_block_get_group_desc(
 			inode, group, desc_bh, desc_kaddr);
 		n = nilfs_palloc_rest_groups_in_desc_block(inode, group,
@@ -536,7 +536,7 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 					inode, group, 1, &bitmap_bh);
 				if (ret < 0)
 					goto out_desc;
-				bitmap_kaddr = kmap(bitmap_bh->b_page);
+				bitmap_kaddr = kmap_thread(bitmap_bh->b_page);
 				bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 				pos = nilfs_palloc_find_available_slot(
 					bitmap, group_offset,
@@ -547,21 +547,21 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 						desc, lock, -1);
 					req->pr_entry_nr =
 						entries_per_group * group + pos;
-					kunmap(desc_bh->b_page);
-					kunmap(bitmap_bh->b_page);
+					kunmap_thread(desc_bh->b_page);
+					kunmap_thread(bitmap_bh->b_page);
 
 					req->pr_desc_bh = desc_bh;
 					req->pr_bitmap_bh = bitmap_bh;
 					return 0;
 				}
-				kunmap(bitmap_bh->b_page);
+				kunmap_thread(bitmap_bh->b_page);
 				brelse(bitmap_bh);
 			}
 
 			group_offset = 0;
 		}
 
-		kunmap(desc_bh->b_page);
+		kunmap_thread(desc_bh->b_page);
 		brelse(desc_bh);
 	}
 
@@ -569,7 +569,7 @@ int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
 	return -ENOSPC;
 
  out_desc:
-	kunmap(desc_bh->b_page);
+	kunmap_thread(desc_bh->b_page);
 	brelse(desc_bh);
 	return ret;
 }
@@ -605,10 +605,10 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 	spinlock_t *lock;
 
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
-	desc_kaddr = kmap(req->pr_desc_bh->b_page);
+	desc_kaddr = kmap_thread(req->pr_desc_bh->b_page);
 	desc = nilfs_palloc_block_get_group_desc(inode, group,
 						 req->pr_desc_bh, desc_kaddr);
-	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
+	bitmap_kaddr = kmap_thread(req->pr_bitmap_bh->b_page);
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 	lock = nilfs_mdt_bgl_lock(inode, group);
 
@@ -620,8 +620,8 @@ void nilfs_palloc_commit_free_entry(struct inode *inode,
 	else
 		nilfs_palloc_group_desc_add_entries(desc, lock, 1);
 
-	kunmap(req->pr_bitmap_bh->b_page);
-	kunmap(req->pr_desc_bh->b_page);
+	kunmap_thread(req->pr_bitmap_bh->b_page);
+	kunmap_thread(req->pr_desc_bh->b_page);
 
 	mark_buffer_dirty(req->pr_desc_bh);
 	mark_buffer_dirty(req->pr_bitmap_bh);
@@ -646,10 +646,10 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 	spinlock_t *lock;
 
 	group = nilfs_palloc_group(inode, req->pr_entry_nr, &group_offset);
-	desc_kaddr = kmap(req->pr_desc_bh->b_page);
+	desc_kaddr = kmap_thread(req->pr_desc_bh->b_page);
 	desc = nilfs_palloc_block_get_group_desc(inode, group,
 						 req->pr_desc_bh, desc_kaddr);
-	bitmap_kaddr = kmap(req->pr_bitmap_bh->b_page);
+	bitmap_kaddr = kmap_thread(req->pr_bitmap_bh->b_page);
 	bitmap = bitmap_kaddr + bh_offset(req->pr_bitmap_bh);
 	lock = nilfs_mdt_bgl_lock(inode, group);
 
@@ -661,8 +661,8 @@ void nilfs_palloc_abort_alloc_entry(struct inode *inode,
 	else
 		nilfs_palloc_group_desc_add_entries(desc, lock, 1);
 
-	kunmap(req->pr_bitmap_bh->b_page);
-	kunmap(req->pr_desc_bh->b_page);
+	kunmap_thread(req->pr_bitmap_bh->b_page);
+	kunmap_thread(req->pr_desc_bh->b_page);
 
 	brelse(req->pr_bitmap_bh);
 	brelse(req->pr_desc_bh);
@@ -754,7 +754,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 		/* Get the first entry number of the group */
 		group_min_nr = (__u64)group * epg;
 
-		bitmap_kaddr = kmap(bitmap_bh->b_page);
+		bitmap_kaddr = kmap_thread(bitmap_bh->b_page);
 		bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 		lock = nilfs_mdt_bgl_lock(inode, group);
 
@@ -800,7 +800,7 @@ int nilfs_palloc_freev(struct inode *inode, __u64 *entry_nrs, size_t nitems)
 			entry_start = rounddown(group_offset, epb);
 		} while (true);
 
-		kunmap(bitmap_bh->b_page);
+		kunmap_thread(bitmap_bh->b_page);
 		mark_buffer_dirty(bitmap_bh);
 		brelse(bitmap_bh);
 
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index 86d4d850d130..402ab8bfce29 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -235,11 +235,11 @@ int nilfs_cpfile_get_checkpoint(struct inode *cpfile,
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, create, &cp_bh);
 	if (ret < 0)
 		goto out_header;
-	kaddr = kmap(cp_bh->b_page);
+	kaddr = kmap_thread(cp_bh->b_page);
 	cp = nilfs_cpfile_block_get_checkpoint(cpfile, cno, cp_bh, kaddr);
 	if (nilfs_checkpoint_invalid(cp)) {
 		if (!create) {
-			kunmap(cp_bh->b_page);
+			kunmap_thread(cp_bh->b_page);
 			brelse(cp_bh);
 			ret = -ENOENT;
 			goto out_header;
-- 
2.28.0.rc0.12.gb6a658bd00c9

