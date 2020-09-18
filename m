Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887FA26FCF0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIRMqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbgIRMpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:45:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02944C06174A;
        Fri, 18 Sep 2020 05:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=KK7IgR2CMF5YRRGUzRRMNzfvcQVoZOlIu5tIkEcJClw=; b=W/Cc86rPhELys3E2tpcxd0WzM4
        SfMythDWxNIKXXEKlC2dycuQNsVQBCguS2qgBdAlMDKaj2AQmjnp0bL7R3/V83Bs65oleR+aOEZts
        tECo6IxMLI9KUyO9hFjs8OHVDZBHQQ7dTVGmzxlrUyLBa3PylGVrMsGbV0wkVnPdTBpwQAuRWPz5o
        PPLGP7q5lOHdEVjYa/49ZedCIkpFTvabo5RCWRS/bKcSmEZsSpAjGsKMU6o7FYrpK7bSLRcFTBhOs
        TKEvXyuLdziCkakH7l1jobNbQ854evUOJbrKnqIXvEtOCgFhSOZ2RYc/i9W4hnn0NESnFhZbtayjN
        r4Ep667g==;
Received: from [80.122.85.238] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJFll-0008TH-G9; Fri, 18 Sep 2020 12:45:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 4/9] fs: handle the compat case in import_iovec
Date:   Fri, 18 Sep 2020 14:45:28 +0200
Message-Id: <20200918124533.3487701-5-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918124533.3487701-1-hch@lst.de>
References: <20200918124533.3487701-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use in compat_syscall to import either native or the compat iovecs, and
remove the now superflous compat_import_iovec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/scsi_ioctl.c     |  12 +---
 drivers/scsi/sg.c      |   9 +--
 fs/aio.c               |  38 +++++-------
 fs/io_uring.c          |  12 +---
 fs/read_write.c        | 127 +++++++++++++++--------------------------
 fs/splice.c            |   2 +-
 include/linux/compat.h |   6 --
 include/linux/fs.h     |   7 +--
 include/linux/uio.h    |   7 ---
 lib/iov_iter.c         |  30 +---------
 mm/process_vm_access.c |   9 +--
 net/compat.c           |   4 +-
 security/keys/compat.c |   5 +-
 13 files changed, 83 insertions(+), 185 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index ef722f04f88a93..e08df86866ee5d 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -333,16 +333,8 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		struct iov_iter i;
 		struct iovec *iov = NULL;
 
-#ifdef CONFIG_COMPAT
-		if (in_compat_syscall())
-			ret = compat_import_iovec(rq_data_dir(rq),
-				   hdr->dxferp, hdr->iovec_count,
-				   0, &iov, &i);
-		else
-#endif
-			ret = import_iovec(rq_data_dir(rq),
-				   hdr->dxferp, hdr->iovec_count,
-				   0, &iov, &i);
+		ret = import_iovec(rq_data_dir(rq), hdr->dxferp,
+				   hdr->iovec_count, 0, &iov, &i);
 		if (ret < 0)
 			goto out_free_cdb;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 20472aaaf630a4..bfa8d77322d732 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1820,14 +1820,7 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 		struct iovec *iov = NULL;
 		struct iov_iter i;
 
-#ifdef CONFIG_COMPAT
-		if (in_compat_syscall())
-			res = compat_import_iovec(rw, hp->dxferp, iov_count,
-						  0, &iov, &i);
-		else
-#endif
-			res = import_iovec(rw, hp->dxferp, iov_count,
-					   0, &iov, &i);
+		res = import_iovec(rw, hp->dxferp, iov_count, 0, &iov, &i);
 		if (res < 0)
 			return res;
 
diff --git a/fs/aio.c b/fs/aio.c
index d5ec303855669d..b377f5c2048e18 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1478,8 +1478,7 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 }
 
 static ssize_t aio_setup_rw(int rw, const struct iocb *iocb,
-		struct iovec **iovec, bool vectored, bool compat,
-		struct iov_iter *iter)
+		struct iovec **iovec, bool vectored, struct iov_iter *iter)
 {
 	void __user *buf = (void __user *)(uintptr_t)iocb->aio_buf;
 	size_t len = iocb->aio_nbytes;
@@ -1489,11 +1488,6 @@ static ssize_t aio_setup_rw(int rw, const struct iocb *iocb,
 		*iovec = NULL;
 		return ret;
 	}
-#ifdef CONFIG_COMPAT
-	if (compat)
-		return compat_import_iovec(rw, buf, len, UIO_FASTIOV, iovec,
-				iter);
-#endif
 	return import_iovec(rw, buf, len, UIO_FASTIOV, iovec, iter);
 }
 
@@ -1517,8 +1511,7 @@ static inline void aio_rw_done(struct kiocb *req, ssize_t ret)
 	}
 }
 
-static int aio_read(struct kiocb *req, const struct iocb *iocb,
-			bool vectored, bool compat)
+static int aio_read(struct kiocb *req, const struct iocb *iocb, bool vectored)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct iov_iter iter;
@@ -1535,7 +1528,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 	if (unlikely(!file->f_op->read_iter))
 		return -EINVAL;
 
-	ret = aio_setup_rw(READ, iocb, &iovec, vectored, compat, &iter);
+	ret = aio_setup_rw(READ, iocb, &iovec, vectored, &iter);
 	if (ret < 0)
 		return ret;
 	ret = rw_verify_area(READ, file, &req->ki_pos, iov_iter_count(&iter));
@@ -1545,8 +1538,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 	return ret;
 }
 
-static int aio_write(struct kiocb *req, const struct iocb *iocb,
-			 bool vectored, bool compat)
+static int aio_write(struct kiocb *req, const struct iocb *iocb, bool vectored)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct iov_iter iter;
@@ -1563,7 +1555,7 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 	if (unlikely(!file->f_op->write_iter))
 		return -EINVAL;
 
-	ret = aio_setup_rw(WRITE, iocb, &iovec, vectored, compat, &iter);
+	ret = aio_setup_rw(WRITE, iocb, &iovec, vectored, &iter);
 	if (ret < 0)
 		return ret;
 	ret = rw_verify_area(WRITE, file, &req->ki_pos, iov_iter_count(&iter));
@@ -1799,8 +1791,7 @@ static int aio_poll(struct aio_kiocb *aiocb, const struct iocb *iocb)
 }
 
 static int __io_submit_one(struct kioctx *ctx, const struct iocb *iocb,
-			   struct iocb __user *user_iocb, struct aio_kiocb *req,
-			   bool compat)
+			   struct iocb __user *user_iocb, struct aio_kiocb *req)
 {
 	req->ki_filp = fget(iocb->aio_fildes);
 	if (unlikely(!req->ki_filp))
@@ -1833,13 +1824,13 @@ static int __io_submit_one(struct kioctx *ctx, const struct iocb *iocb,
 
 	switch (iocb->aio_lio_opcode) {
 	case IOCB_CMD_PREAD:
-		return aio_read(&req->rw, iocb, false, compat);
+		return aio_read(&req->rw, iocb, false);
 	case IOCB_CMD_PWRITE:
-		return aio_write(&req->rw, iocb, false, compat);
+		return aio_write(&req->rw, iocb, false);
 	case IOCB_CMD_PREADV:
-		return aio_read(&req->rw, iocb, true, compat);
+		return aio_read(&req->rw, iocb, true);
 	case IOCB_CMD_PWRITEV:
-		return aio_write(&req->rw, iocb, true, compat);
+		return aio_write(&req->rw, iocb, true);
 	case IOCB_CMD_FSYNC:
 		return aio_fsync(&req->fsync, iocb, false);
 	case IOCB_CMD_FDSYNC:
@@ -1852,8 +1843,7 @@ static int __io_submit_one(struct kioctx *ctx, const struct iocb *iocb,
 	}
 }
 
-static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-			 bool compat)
+static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb)
 {
 	struct aio_kiocb *req;
 	struct iocb iocb;
@@ -1882,7 +1872,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	if (unlikely(!req))
 		return -EAGAIN;
 
-	err = __io_submit_one(ctx, &iocb, user_iocb, req, compat);
+	err = __io_submit_one(ctx, &iocb, user_iocb, req);
 
 	/* Done with the synchronous reference */
 	iocb_put(req);
@@ -1941,7 +1931,7 @@ SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
 			break;
 		}
 
-		ret = io_submit_one(ctx, user_iocb, false);
+		ret = io_submit_one(ctx, user_iocb);
 		if (ret)
 			break;
 	}
@@ -1983,7 +1973,7 @@ COMPAT_SYSCALL_DEFINE3(io_submit, compat_aio_context_t, ctx_id,
 			break;
 		}
 
-		ret = io_submit_one(ctx, compat_ptr(user_iocb), true);
+		ret = io_submit_one(ctx, compat_ptr(user_iocb));
 		if (ret)
 			break;
 	}
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5755d557c3f7bc..dc888f911f04b4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2837,12 +2837,6 @@ static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
 		return ret;
 	}
 
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		return compat_import_iovec(rw, buf, sqe_len, UIO_FASTIOV,
-						iovec, iter);
-#endif
-
 	return import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter);
 }
 
@@ -4220,9 +4214,9 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 		sr->len = iomsg->iov[0].iov_len;
 		iomsg->iov = NULL;
 	} else {
-		ret = compat_import_iovec(READ, uiov, len, UIO_FASTIOV,
-						&iomsg->iov,
-						&iomsg->msg.msg_iter);
+		ret = import_iovec(READ, (struct iovec __user *)uiov, len,
+				   UIO_FASTIOV, &iomsg->iov,
+				   &iomsg->msg.msg_iter);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/fs/read_write.c b/fs/read_write.c
index f153116bc5399b..2f961c653ce561 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -752,6 +752,38 @@ static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
 	return ret;
 }
 
+static int compat_copy_iovecs_from_user(struct iovec *iov,
+		const struct iovec __user *uvector, unsigned long nr_segs)
+{
+	const struct compat_iovec __user *uiov =
+		(const struct compat_iovec __user *)uvector;
+	unsigned long i;
+	int ret = -EFAULT;
+
+	if (!user_access_begin(uvector, nr_segs * sizeof(*uvector)))
+		return -EFAULT;
+
+	for (i = 0; i < nr_segs; i++) {
+		compat_uptr_t buf;
+		compat_ssize_t len;
+
+		unsafe_get_user(len, &uiov[i].iov_len, out);
+		unsafe_get_user(buf, &uiov[i].iov_base, out);
+
+		/* check for compat_size_t not fitting in compat_ssize_t .. */
+		if (len < 0) {
+			ret = -EINVAL;
+			goto out;
+		}
+		iov[i].iov_base = compat_ptr(buf);
+		iov[i].iov_len = len;
+	}
+	ret = 0;
+out:
+	user_access_end();
+	return ret;
+}
+
 /**
  * rw_copy_check_uvector() - Copy an array of &struct iovec from userspace
  *     into the kernel and check that it is valid.
@@ -808,6 +840,7 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 		ret = -EINVAL;
 		goto out;
 	}
+
 	if (nr_segs > fast_segs) {
 		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
 		if (iov == NULL) {
@@ -815,9 +848,16 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			goto out;
 		}
 	}
-	if (copy_from_user(iov, uvector, nr_segs*sizeof(*uvector))) {
-		ret = -EFAULT;
-		goto out;
+
+	if (in_compat_syscall()) {
+		ret = compat_copy_iovecs_from_user(iov, uvector, nr_segs);
+		if (ret)
+			goto out;
+	} else {
+		if (copy_from_user(iov, uvector, nr_segs * sizeof(*uvector))) {
+			ret = -EFAULT;
+			goto out;
+		}
 	}
 
 	/*
@@ -855,81 +895,6 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 	return ret;
 }
 
-#ifdef CONFIG_COMPAT
-ssize_t compat_rw_copy_check_uvector(int type,
-		const struct compat_iovec __user *uvector, unsigned long nr_segs,
-		unsigned long fast_segs, struct iovec *fast_pointer,
-		struct iovec **ret_pointer)
-{
-	compat_ssize_t tot_len;
-	struct iovec *iov = *ret_pointer = fast_pointer;
-	ssize_t ret = 0;
-	int seg;
-
-	/*
-	 * SuS says "The readv() function *may* fail if the iovcnt argument
-	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
-	 * traditionally returned zero for zero segments, so...
-	 */
-	if (nr_segs == 0)
-		goto out;
-
-	ret = -EINVAL;
-	if (nr_segs > UIO_MAXIOV)
-		goto out;
-	if (nr_segs > fast_segs) {
-		ret = -ENOMEM;
-		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
-		if (iov == NULL)
-			goto out;
-	}
-	*ret_pointer = iov;
-
-	ret = -EFAULT;
-	if (!access_ok(uvector, nr_segs*sizeof(*uvector)))
-		goto out;
-
-	/*
-	 * Single unix specification:
-	 * We should -EINVAL if an element length is not >= 0 and fitting an
-	 * ssize_t.
-	 *
-	 * In Linux, the total length is limited to MAX_RW_COUNT, there is
-	 * no overflow possibility.
-	 */
-	tot_len = 0;
-	ret = -EINVAL;
-	for (seg = 0; seg < nr_segs; seg++) {
-		compat_uptr_t buf;
-		compat_ssize_t len;
-
-		if (__get_user(len, &uvector->iov_len) ||
-		   __get_user(buf, &uvector->iov_base)) {
-			ret = -EFAULT;
-			goto out;
-		}
-		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
-			goto out;
-		if (type != CHECK_IOVEC_ONLY &&
-		    !access_ok(compat_ptr(buf), len)) {
-			ret = -EFAULT;
-			goto out;
-		}
-		if (len > MAX_RW_COUNT - tot_len)
-			len = MAX_RW_COUNT - tot_len;
-		tot_len += len;
-		iov->iov_base = compat_ptr(buf);
-		iov->iov_len = (compat_size_t) len;
-		uvector++;
-		iov++;
-	}
-	ret = tot_len;
-
-out:
-	return ret;
-}
-#endif
-
 static ssize_t do_iter_read(struct file *file, struct iov_iter *iter,
 		loff_t *pos, rwf_t flags)
 {
@@ -1256,7 +1221,8 @@ static size_t compat_readv(struct file *file,
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = compat_import_iovec(READ, vec, vlen, UIO_FASTIOV, &iov, &iter);
+	ret = import_iovec(READ, (const struct iovec __user *)vec, vlen,
+			   UIO_FASTIOV, &iov, &iter);
 	if (ret >= 0) {
 		ret = do_iter_read(file, &iter, pos, flags);
 		kfree(iov);
@@ -1364,7 +1330,8 @@ static size_t compat_writev(struct file *file,
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = compat_import_iovec(WRITE, vec, vlen, UIO_FASTIOV, &iov, &iter);
+	ret = import_iovec(WRITE, (const struct iovec __user *)vec, vlen,
+			   UIO_FASTIOV, &iov, &iter);
 	if (ret >= 0) {
 		file_start_write(file);
 		ret = do_iter_write(file, &iter, pos, flags);
diff --git a/fs/splice.c b/fs/splice.c
index d7c8a7c4db07ff..132d42b9871f9b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1387,7 +1387,7 @@ COMPAT_SYSCALL_DEFINE4(vmsplice, int, fd, const struct compat_iovec __user *, io
 	if (error)
 		return error;
 
-	error = compat_import_iovec(type, iov32, nr_segs,
+	error = import_iovec(type, (struct iovec __user *)iov32, nr_segs,
 			     ARRAY_SIZE(iovstack), &iov, &iter);
 	if (error >= 0) {
 		error = do_vmsplice(f.file, &iter, flags);
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 69968c124b3cad..ad6dc56e8828d6 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -451,12 +451,6 @@ extern long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 
 struct epoll_event;	/* fortunately, this one is fixed-layout */
 
-extern ssize_t compat_rw_copy_check_uvector(int type,
-		const struct compat_iovec __user *uvector,
-		unsigned long nr_segs,
-		unsigned long fast_segs, struct iovec *fast_pointer,
-		struct iovec **ret_pointer);
-
 extern void __user *compat_alloc_user_space(unsigned long len);
 
 int compat_restore_altstack(const compat_stack_t __user *uss);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7519ae003a082c..3cc0ee0de45648 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -179,10 +179,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
 
 /*
- * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
- * that indicates that they should check the contents of the iovec are
- * valid, but not check the memory that the iovec elements
- * points too.
+ * Flag for rw_copy_check_uvector  that indicates that they should check the
+ * contents of the iovec are valid, but not check the memory that the iovec
+ * elements points too.
  */
 #define CHECK_IOVEC_ONLY -1
 
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 3835a8a8e9eae0..2c14e55687fec6 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -270,13 +270,6 @@ ssize_t import_iovec(int type, const struct iovec __user * uvector,
 		 unsigned nr_segs, unsigned fast_segs,
 		 struct iovec **iov, struct iov_iter *i);
 
-#ifdef CONFIG_COMPAT
-struct compat_iovec;
-ssize_t compat_import_iovec(int type, const struct compat_iovec __user * uvector,
-		 unsigned nr_segs, unsigned fast_segs,
-		 struct iovec **iov, struct iov_iter *i);
-#endif
-
 int import_single_range(int type, void __user *buf, size_t len,
 		 struct iovec *iov, struct iov_iter *i);
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 5e40786c8f1232..792f31c1cd96ba 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -10,6 +10,7 @@
 #include <net/checksum.h>
 #include <linux/scatterlist.h>
 #include <linux/instrumented.h>
+#include <linux/compat.h>
 
 #define PIPE_PARANOIA /* for now */
 
@@ -1678,32 +1679,8 @@ ssize_t import_iovec(int type, const struct iovec __user * uvector,
 {
 	ssize_t n;
 	struct iovec *p;
-	n = rw_copy_check_uvector(type, uvector, nr_segs, fast_segs,
-				  *iov, &p);
-	if (n < 0) {
-		if (p != *iov)
-			kfree(p);
-		*iov = NULL;
-		return n;
-	}
-	iov_iter_init(i, type, p, nr_segs, n);
-	*iov = p == *iov ? NULL : p;
-	return n;
-}
-EXPORT_SYMBOL(import_iovec);
 
-#ifdef CONFIG_COMPAT
-#include <linux/compat.h>
-
-ssize_t compat_import_iovec(int type,
-		const struct compat_iovec __user * uvector,
-		unsigned nr_segs, unsigned fast_segs,
-		struct iovec **iov, struct iov_iter *i)
-{
-	ssize_t n;
-	struct iovec *p;
-	n = compat_rw_copy_check_uvector(type, uvector, nr_segs, fast_segs,
-				  *iov, &p);
+	n = rw_copy_check_uvector(type, uvector, nr_segs, fast_segs, *iov, &p);
 	if (n < 0) {
 		if (p != *iov)
 			kfree(p);
@@ -1714,8 +1691,7 @@ ssize_t compat_import_iovec(int type,
 	*iov = p == *iov ? NULL : p;
 	return n;
 }
-EXPORT_SYMBOL(compat_import_iovec);
-#endif
+EXPORT_SYMBOL(import_iovec);
 
 int import_single_range(int rw, void __user *buf, size_t len,
 		 struct iovec *iov, struct iov_iter *i)
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 29c052099affdc..f21feebbd48f39 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -329,14 +329,15 @@ compat_process_vm_rw(compat_pid_t pid,
 	if (flags != 0)
 		return -EINVAL;
 
-	rc = compat_import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter);
+	rc = import_iovec(dir, (const struct iovec __user *)lvec, liovcnt,
+			  UIO_FASTIOV, &iov_l, &iter);
 	if (rc < 0)
 		return rc;
 	if (!iov_iter_count(&iter))
 		goto free_iovecs;
-	rc = compat_rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt,
-					  UIO_FASTIOV, iovstack_r,
-					  &iov_r);
+	rc = rw_copy_check_uvector(CHECK_IOVEC_ONLY,
+				   (const struct iovec __user *)rvec, riovcnt,
+				   UIO_FASTIOV, iovstack_r, &iov_r);
 	if (rc <= 0)
 		goto free_iovecs;
 
diff --git a/net/compat.c b/net/compat.c
index 95ce707a30a31d..ddd15af3a2837b 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -98,8 +98,8 @@ int get_compat_msghdr(struct msghdr *kmsg,
 	if (err)
 		return err;
 
-	err = compat_import_iovec(save_addr ? READ : WRITE, compat_ptr(ptr),
-				   len, UIO_FASTIOV, iov, &kmsg->msg_iter);
+	err = import_iovec(save_addr ? READ : WRITE, compat_ptr(ptr), len,
+			   UIO_FASTIOV, iov, &kmsg->msg_iter);
 	return err < 0 ? err : 0;
 }
 
diff --git a/security/keys/compat.c b/security/keys/compat.c
index 6ee9d8f6a4a5bb..7ae531db031cf8 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -33,9 +33,8 @@ static long compat_keyctl_instantiate_key_iov(
 	if (!_payload_iov)
 		ioc = 0;
 
-	ret = compat_import_iovec(WRITE, _payload_iov, ioc,
-				  ARRAY_SIZE(iovstack), &iov,
-				  &from);
+	ret = import_iovec(WRITE, (const struct iovec __user *)_payload_iov,
+			   ioc, ARRAY_SIZE(iovstack), &iov, &from);
 	if (ret < 0)
 		return ret;
 
-- 
2.28.0

