Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10682893E4
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391045AbgJITxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:53:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:3587 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390882AbgJITvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:51:53 -0400
IronPort-SDR: mzoU95oSP1VwD5uWDae0guS0a6cE+H7YgLc5+R2J4zXJztdZotOqq9cM2YFYDL1izjhOdl5LMS
 EbOn31fl/5qQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="182976174"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="182976174"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:51:51 -0700
IronPort-SDR: OASmflq+Rx+yTtbdwfMJ0o3fYX/22afbp7t4aASuh19KdC4DJdh+fKQIdVVFr7y3ZwUlZzPFTz
 pRsXSfU26jow==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="529053257"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:51:50 -0700
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
Subject: [PATCH RFC PKS/PMEM 18/58] fs/hfs: Utilize new kmap_thread()
Date:   Fri,  9 Oct 2020 12:49:53 -0700
Message-Id: <20201009195033.3208459-19-ira.weiny@intel.com>
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

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/hfs/bnode.c | 14 +++++++-------
 fs/hfs/btree.c | 20 ++++++++++----------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index b63a4df7327b..8b4d02576405 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -23,8 +23,8 @@ void hfs_bnode_read(struct hfs_bnode *node, void *buf,
 	off += node->page_offset;
 	page = node->page[0];
 
-	memcpy(buf, kmap(page) + off, len);
-	kunmap(page);
+	memcpy(buf, kmap_thread(page) + off, len);
+	kunmap_thread(page);
 }
 
 u16 hfs_bnode_read_u16(struct hfs_bnode *node, int off)
@@ -108,9 +108,9 @@ void hfs_bnode_copy(struct hfs_bnode *dst_node, int dst,
 	src_page = src_node->page[0];
 	dst_page = dst_node->page[0];
 
-	memcpy(kmap(dst_page) + dst, kmap(src_page) + src, len);
-	kunmap(src_page);
-	kunmap(dst_page);
+	memcpy(kmap_thread(dst_page) + dst, kmap_thread(src_page) + src, len);
+	kunmap_thread(src_page);
+	kunmap_thread(dst_page);
 	set_page_dirty(dst_page);
 }
 
@@ -125,9 +125,9 @@ void hfs_bnode_move(struct hfs_bnode *node, int dst, int src, int len)
 	src += node->page_offset;
 	dst += node->page_offset;
 	page = node->page[0];
-	ptr = kmap(page);
+	ptr = kmap_thread(page);
 	memmove(ptr + dst, ptr + src, len);
-	kunmap(page);
+	kunmap_thread(page);
 	set_page_dirty(page);
 }
 
diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 19017d296173..bd4a6d35e361 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -80,7 +80,7 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 		goto free_inode;
 
 	/* Load the header */
-	head = (struct hfs_btree_header_rec *)(kmap(page) + sizeof(struct hfs_bnode_desc));
+	head = (struct hfs_btree_header_rec *)(kmap_thread(page) + sizeof(struct hfs_bnode_desc));
 	tree->root = be32_to_cpu(head->root);
 	tree->leaf_count = be32_to_cpu(head->leaf_count);
 	tree->leaf_head = be32_to_cpu(head->leaf_head);
@@ -119,7 +119,7 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp ke
 	tree->node_size_shift = ffs(size) - 1;
 	tree->pages_per_bnode = (tree->node_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-	kunmap(page);
+	kunmap_thread(page);
 	put_page(page);
 	return tree;
 
@@ -268,7 +268,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 
 	off += node->page_offset;
 	pagep = node->page + (off >> PAGE_SHIFT);
-	data = kmap(*pagep);
+	data = kmap_thread(*pagep);
 	off &= ~PAGE_MASK;
 	idx = 0;
 
@@ -281,7 +281,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 						idx += i;
 						data[off] |= m;
 						set_page_dirty(*pagep);
-						kunmap(*pagep);
+						kunmap_thread(*pagep);
 						tree->free_nodes--;
 						mark_inode_dirty(tree->inode);
 						hfs_bnode_put(node);
@@ -290,14 +290,14 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 				}
 			}
 			if (++off >= PAGE_SIZE) {
-				kunmap(*pagep);
-				data = kmap(*++pagep);
+				kunmap_thread(*pagep);
+				data = kmap_thread(*++pagep);
 				off = 0;
 			}
 			idx += 8;
 			len--;
 		}
-		kunmap(*pagep);
+		kunmap_thread(*pagep);
 		nidx = node->next;
 		if (!nidx) {
 			printk(KERN_DEBUG "create new bmap node...\n");
@@ -313,7 +313,7 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 		off = off16;
 		off += node->page_offset;
 		pagep = node->page + (off >> PAGE_SHIFT);
-		data = kmap(*pagep);
+		data = kmap_thread(*pagep);
 		off &= ~PAGE_MASK;
 	}
 }
@@ -360,7 +360,7 @@ void hfs_bmap_free(struct hfs_bnode *node)
 	}
 	off += node->page_offset + nidx / 8;
 	page = node->page[off >> PAGE_SHIFT];
-	data = kmap(page);
+	data = kmap_thread(page);
 	off &= ~PAGE_MASK;
 	m = 1 << (~nidx & 7);
 	byte = data[off];
@@ -373,7 +373,7 @@ void hfs_bmap_free(struct hfs_bnode *node)
 	}
 	data[off] = byte & ~m;
 	set_page_dirty(page);
-	kunmap(page);
+	kunmap_thread(page);
 	hfs_bnode_put(node);
 	tree->free_nodes++;
 	mark_inode_dirty(tree->inode);
-- 
2.28.0.rc0.12.gb6a658bd00c9

