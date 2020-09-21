Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66EC27279D
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgIUOgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgIUOef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:34:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E11FC061755;
        Mon, 21 Sep 2020 07:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HMS3wpmHJ08+TjASQ52pDgUhrjMpeVTpap30GBFvOAE=; b=FaYNCJyyME4i3uvXayjfkbvAqj
        z7tJWyj7bZEt0QdENw0WQ7ww4hTah5nBc2c2ZYSSjANmXgH5MhdZkY2vwwLERNLSdqHgqDMYrbdhA
        7Y1IUhSVsaLoqQXCT2FYvxcvjkCIZhdAnxRI60M1X9M+kWvZdxBNBkB6Tt0V4O0MvwNMj3L5s1NAl
        mjajE+5ZNJkcQm0JWVF9Efr6csREsE6r4SgdAjoDPcoC0HRp6t6pHecWQaQy8HBQFVDyodVwJe0bV
        Mzfpqr3Grxf3py+y+PrDRx4RHgYCqvX+UhqY27e2Y9L07pRI7fUC4KFQt/YUN1imvNFX0qVSNi19y
        tDqOx4sw==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMte-0007rq-Pi; Mon, 21 Sep 2020 14:34:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 06/11] iov_iter: handle the compat case in import_iovec
Date:   Mon, 21 Sep 2020 16:34:29 +0200
Message-Id: <20200921143434.707844-7-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143434.707844-1-hch@lst.de>
References: <20200921143434.707844-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use in compat_syscall to import either native or the compat iovecs, and
remove the now superflous compat_import_iovec, which removes the need for
special compat logic in most callers.  Only io_uring needs special
treatment given that it can call import_iovec from kernel threads acting
on behalf of native or compat syscalls.  Expose the low-level
__import_iovec helper and use it in io_uring to explicitly pick a iovec
layout.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/scsi_ioctl.c     | 12 ++----------
 drivers/scsi/sg.c      |  9 +--------
 fs/aio.c               | 38 ++++++++++++++------------------------
 fs/io_uring.c          | 20 ++++++++------------
 fs/read_write.c        |  6 ++++--
 fs/splice.c            |  2 +-
 include/linux/uio.h    | 10 +++-------
 lib/iov_iter.c         | 17 +++--------------
 mm/process_vm_access.c |  7 ++++---
 net/compat.c           |  4 ++--
 security/keys/compat.c |  5 ++---
 11 files changed, 44 insertions(+), 86 deletions(-)

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
index 3790c7fe9fee22..ba84ecea7cb1a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2837,13 +2837,8 @@ static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
 		return ret;
 	}
 
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		return compat_import_iovec(rw, buf, sqe_len, UIO_FASTIOV,
-						iovec, iter);
-#endif
-
-	return import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter);
+	return __import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter,
+			      req->ctx->compat);
 }
 
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
@@ -4179,8 +4174,9 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 				sr->len);
 		iomsg->iov = NULL;
 	} else {
-		ret = import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
-					&iomsg->iov, &iomsg->msg.msg_iter);
+		ret = __import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
+				     &iomsg->iov, &iomsg->msg.msg_iter,
+				     false);
 		if (ret > 0)
 			ret = 0;
 	}
@@ -4220,9 +4216,9 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 		sr->len = iomsg->iov[0].iov_len;
 		iomsg->iov = NULL;
 	} else {
-		ret = compat_import_iovec(READ, uiov, len, UIO_FASTIOV,
-						&iomsg->iov,
-						&iomsg->msg.msg_iter);
+		ret = __import_iovec(READ, (struct iovec __user *)uiov, len,
+				   UIO_FASTIOV, &iomsg->iov,
+				   &iomsg->msg.msg_iter, true);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/fs/read_write.c b/fs/read_write.c
index e5e891a88442ef..0a68037580b455 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1078,7 +1078,8 @@ static size_t compat_readv(struct file *file,
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = compat_import_iovec(READ, vec, vlen, UIO_FASTIOV, &iov, &iter);
+	ret = import_iovec(READ, (const struct iovec __user *)vec, vlen,
+			   UIO_FASTIOV, &iov, &iter);
 	if (ret >= 0) {
 		ret = do_iter_read(file, &iter, pos, flags);
 		kfree(iov);
@@ -1186,7 +1187,8 @@ static size_t compat_writev(struct file *file,
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
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 3835a8a8e9eae0..fff5d49dd0d53e 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -269,13 +269,9 @@ size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 ssize_t import_iovec(int type, const struct iovec __user * uvector,
 		 unsigned nr_segs, unsigned fast_segs,
 		 struct iovec **iov, struct iov_iter *i);
-
-#ifdef CONFIG_COMPAT
-struct compat_iovec;
-ssize_t compat_import_iovec(int type, const struct compat_iovec __user * uvector,
-		 unsigned nr_segs, unsigned fast_segs,
-		 struct iovec **iov, struct iov_iter *i);
-#endif
+ssize_t __import_iovec(int type, const struct iovec __user *uvector,
+		unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
+		struct iov_iter *i, bool compat);
 
 int import_single_range(int type, void __user *buf, size_t len,
 		 struct iovec *iov, struct iov_iter *i);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 8bfa47b63d39aa..632265178d8737 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1683,7 +1683,7 @@ static int compat_copy_iovecs_from_user(struct iovec *iov,
 	return ret;
 }
 
-static ssize_t __import_iovec(int type, const struct iovec __user *uvector,
+ssize_t __import_iovec(int type, const struct iovec __user *uvector,
 		unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
 		struct iov_iter *i, bool compat)
 {
@@ -1793,22 +1793,11 @@ ssize_t import_iovec(int type, const struct iovec __user * uvector,
 		 unsigned nr_segs, unsigned fast_segs,
 		 struct iovec **iov, struct iov_iter *i)
 {
-	return __import_iovec(type, uvector, nr_segs, fast_segs, iov, i, false);
+	return __import_iovec(type, uvector, nr_segs, fast_segs, iov, i,
+			      in_compat_syscall());
 }
 EXPORT_SYMBOL(import_iovec);
 
-#ifdef CONFIG_COMPAT
-ssize_t compat_import_iovec(int type,
-		const struct compat_iovec __user * uvector,
-		unsigned nr_segs, unsigned fast_segs,
-		struct iovec **iov, struct iov_iter *i)
-{
-	return __import_iovec(type, (const struct iovec __user *)uvector,
-			      nr_segs, fast_segs, iov, i, true);
-}
-EXPORT_SYMBOL(compat_import_iovec);
-#endif
-
 int import_single_range(int rw, void __user *buf, size_t len,
 		 struct iovec *iov, struct iov_iter *i)
 {
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 40cd502c337534..b759ed264840d8 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -331,13 +331,14 @@ compat_process_vm_rw(compat_pid_t pid,
 	if (flags != 0)
 		return -EINVAL;
 
-	rc = compat_import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter_l);
+	rc = import_iovec(dir, (const struct iovec __user *)iov_l, liovcnt,
+			  UIO_FASTIOV, &iov_l, &iter_l);
 	if (rc < 0)
 		return rc;
 	if (!iov_iter_count(&iter_l))
 		goto free_iovecs;
-	rc = compat_import_iovec(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV,
-				 &iov_r, &iter_r);
+	rc = import_iovec(CHECK_IOVEC_ONLY, iov_r, riovcnt, UIO_FASTIOV, &iov_r,
+			  &iter_r);
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

