Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A1A289709
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388186AbgJIUCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:02:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:40581 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388824AbgJITw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:52:58 -0400
IronPort-SDR: tGU1WWM0mFtP4sQxNjAr1vD1TEE/S82Fwey3kuQK7biXKtIM+OTpRGX42MrzZrbh17sxY7EBCK
 BJwnIk9ZOKlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="162068045"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="162068045"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:52:55 -0700
IronPort-SDR: TN82OMSOJnR+1dzdu/wtYu+HarPMiqU5tCJLq9k+HDWuiKzSJliaVoZHfBedXzzykRk72guGi9
 gJFQG6Pg4N1Q==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="529053748"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:52:54 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, x86@kernel.org,
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
Subject: [PATCH RFC PKS/PMEM 35/58] fs: Utilize new kmap_thread()
Date:   Fri,  9 Oct 2020 12:50:10 -0700
Message-Id: <20201009195033.3208459-36-ira.weiny@intel.com>
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

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/aio.c              |  4 ++--
 fs/binfmt_elf.c       |  4 ++--
 fs/binfmt_elf_fdpic.c |  4 ++--
 fs/exec.c             | 10 +++++-----
 fs/io_uring.c         |  4 ++--
 fs/splice.c           |  4 ++--
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index d5ec30385566..27f95996d25f 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1223,10 +1223,10 @@ static long aio_read_events_ring(struct kioctx *ctx,
 		avail = min(avail, nr - ret);
 		avail = min_t(long, avail, AIO_EVENTS_PER_PAGE - pos);
 
-		ev = kmap(page);
+		ev = kmap_thread(page);
 		copy_ret = copy_to_user(event + ret, ev + pos,
 					sizeof(*ev) * avail);
-		kunmap(page);
+		kunmap_thread(page);
 
 		if (unlikely(copy_ret)) {
 			ret = -EFAULT;
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 13d053982dd7..1a332ef1ae03 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2430,9 +2430,9 @@ static int elf_core_dump(struct coredump_params *cprm)
 
 			page = get_dump_page(addr);
 			if (page) {
-				void *kaddr = kmap(page);
+				void *kaddr = kmap_thread(page);
 				stop = !dump_emit(cprm, kaddr, PAGE_SIZE);
-				kunmap(page);
+				kunmap_thread(page);
 				put_page(page);
 			} else
 				stop = !dump_skip(cprm, PAGE_SIZE);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 50f845702b92..8fbe188e0fdd 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1542,9 +1542,9 @@ static bool elf_fdpic_dump_segments(struct coredump_params *cprm)
 			bool res;
 			struct page *page = get_dump_page(addr);
 			if (page) {
-				void *kaddr = kmap(page);
+				void *kaddr = kmap_thread(page);
 				res = dump_emit(cprm, kaddr, PAGE_SIZE);
-				kunmap(page);
+				kunmap_thread(page);
 				put_page(page);
 			} else {
 				res = dump_skip(cprm, PAGE_SIZE);
diff --git a/fs/exec.c b/fs/exec.c
index a91003e28eaa..3948b8511e3a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -575,11 +575,11 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
 
 				if (kmapped_page) {
 					flush_kernel_dcache_page(kmapped_page);
-					kunmap(kmapped_page);
+					kunmap_thread(kmapped_page);
 					put_arg_page(kmapped_page);
 				}
 				kmapped_page = page;
-				kaddr = kmap(kmapped_page);
+				kaddr = kmap_thread(kmapped_page);
 				kpos = pos & PAGE_MASK;
 				flush_arg_page(bprm, kpos, kmapped_page);
 			}
@@ -593,7 +593,7 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
 out:
 	if (kmapped_page) {
 		flush_kernel_dcache_page(kmapped_page);
-		kunmap(kmapped_page);
+		kunmap_thread(kmapped_page);
 		put_arg_page(kmapped_page);
 	}
 	return ret;
@@ -871,11 +871,11 @@ int transfer_args_to_stack(struct linux_binprm *bprm,
 
 	for (index = MAX_ARG_PAGES - 1; index >= stop; index--) {
 		unsigned int offset = index == stop ? bprm->p & ~PAGE_MASK : 0;
-		char *src = kmap(bprm->page[index]) + offset;
+		char *src = kmap_thread(bprm->page[index]) + offset;
 		sp -= PAGE_SIZE - offset;
 		if (copy_to_user((void *) sp, src, PAGE_SIZE - offset) != 0)
 			ret = -EFAULT;
-		kunmap(bprm->page[index]);
+		kunmap_thread(bprm->page[index]);
 		if (ret)
 			goto out;
 	}
diff --git a/fs/io_uring.c b/fs/io_uring.c
index aae0ef2ec34d..f59bb079822d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2903,7 +2903,7 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 			iovec = iov_iter_iovec(iter);
 		} else {
 			/* fixed buffers import bvec */
-			iovec.iov_base = kmap(iter->bvec->bv_page)
+			iovec.iov_base = kmap_thread(iter->bvec->bv_page)
 						+ iter->iov_offset;
 			iovec.iov_len = min(iter->count,
 					iter->bvec->bv_len - iter->iov_offset);
@@ -2918,7 +2918,7 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 		}
 
 		if (iov_iter_is_bvec(iter))
-			kunmap(iter->bvec->bv_page);
+			kunmap_thread(iter->bvec->bv_page);
 
 		if (nr < 0) {
 			if (!ret)
diff --git a/fs/splice.c b/fs/splice.c
index ce75aec52274..190c4d218c30 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -815,9 +815,9 @@ static int write_pipe_buf(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	void *data;
 	loff_t tmp = sd->pos;
 
-	data = kmap(buf->page);
+	data = kmap_thread(buf->page);
 	ret = __kernel_write(sd->u.file, data + buf->offset, sd->len, &tmp);
-	kunmap(buf->page);
+	kunmap_thread(buf->page);
 
 	return ret;
 }
-- 
2.28.0.rc0.12.gb6a658bd00c9

