Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23A5277F48
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 06:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgIYEwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 00:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgIYEwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 00:52:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E740C0613CE;
        Thu, 24 Sep 2020 21:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=A1w/LQ8OkWuIFrWoMQToRKoMxSSZmXSepTFOY8KoKk4=; b=OnPFnpeJ3jvP6+sqXmYng7a63A
        +Po739XsiMAWgUmrhcj1IRgFVGqMcBSOsUXOyjcU11CvvnHWLNf3AQoYOtY/rB0KEZ5yviq7TLjNw
        DbQNPxVA0+B0WXcXw3uwuYsIiQfia2wfklZ9D70xD8AxGwfKu4kEQmh6tvxtrJvKsQNIk/+QL4xQE
        EVfAcYoCUwxnv4IbumJHzD0+QPrZhTCHgrkNypjkfCqJETygdWuwzsHBGUUMCa00U9FjTPCIAUSrI
        IeI28Fxe4TqvwRLRa9nCAKH/gN4oTWjVyom+ihC6nR7soNcbk8pvIx1xDqVuvRX0oMAa+AP2y/3wL
        GtcddMnA==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLfi5-0002qb-3M; Fri, 25 Sep 2020 04:51:53 +0000
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
Subject: [PATCH 4/9] iov_iter: transparently handle compat iovecs in import_iovec
Date:   Fri, 25 Sep 2020 06:51:41 +0200
Message-Id: <20200925045146.1283714-5-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925045146.1283714-1-hch@lst.de>
References: <20200925045146.1283714-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use in compat_syscall to import either native or the compat iovecs, and
remove the now superflous compat_import_iovec.

This removes the need for special compat logic in most callers, and
the remaining ones can still be simplified by using __import_iovec
with a bool compat parameter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/scsi_ioctl.c     | 12 ++----------
 drivers/scsi/sg.c      |  9 +--------
 fs/aio.c               |  8 ++------
 fs/io_uring.c          | 20 ++++++++------------
 fs/read_write.c        |  6 ++++--
 fs/splice.c            |  2 +-
 include/linux/uio.h    |  8 --------
 lib/iov_iter.c         | 14 ++------------
 mm/process_vm_access.c |  3 ++-
 net/compat.c           |  4 ++--
 security/keys/compat.c |  5 ++---
 11 files changed, 26 insertions(+), 65 deletions(-)

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
index d5ec303855669d..c45c20d875388c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1489,12 +1489,8 @@ static ssize_t aio_setup_rw(int rw, const struct iocb *iocb,
 		*iovec = NULL;
 		return ret;
 	}
-#ifdef CONFIG_COMPAT
-	if (compat)
-		return compat_import_iovec(rw, buf, len, UIO_FASTIOV, iovec,
-				iter);
-#endif
-	return import_iovec(rw, buf, len, UIO_FASTIOV, iovec, iter);
+
+	return __import_iovec(rw, buf, len, UIO_FASTIOV, iovec, iter, compat);
 }
 
 static inline void aio_rw_done(struct kiocb *req, ssize_t ret)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b426aa29668cb..8c27dc28da182a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2852,13 +2852,8 @@ static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
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
@@ -4200,8 +4195,9 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
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
@@ -4241,9 +4237,9 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
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
index 92c11fe41c6228..daedc61ad3706e 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -275,14 +275,6 @@ ssize_t import_iovec(int type, const struct iovec __user *uvec,
 ssize_t __import_iovec(int type, const struct iovec __user *uvec,
 		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
 		 struct iov_iter *i, bool compat);
-
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
index d5d8afe31fca16..8c51e1b03814a3 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1806,21 +1806,11 @@ ssize_t import_iovec(int type, const struct iovec __user *uvec,
 		 unsigned nr_segs, unsigned fast_segs,
 		 struct iovec **iovp, struct iov_iter *i)
 {
-	return __import_iovec(type, uvec, nr_segs, fast_segs, iovp, i, false);
+	return __import_iovec(type, uvec, nr_segs, fast_segs, iovp, i,
+			      in_compat_syscall());
 }
 EXPORT_SYMBOL(import_iovec);
 
-#ifdef CONFIG_COMPAT
-ssize_t compat_import_iovec(int type, const struct compat_iovec __user *uvec,
-		unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		struct iov_iter *i)
-{
-	return __import_iovec(type, (const struct iovec __user *)uvec, nr_segs,
-			     fast_segs, iovp, i, true);
-}
-EXPORT_SYMBOL(compat_import_iovec);
-#endif
-
 int import_single_range(int rw, void __user *buf, size_t len,
 		 struct iovec *iov, struct iov_iter *i)
 {
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 5e728c20c2bead..3f2156aab44263 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -326,7 +326,8 @@ compat_process_vm_rw(compat_pid_t pid,
 	if (flags != 0)
 		return -EINVAL;
 
-	rc = compat_import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter);
+	rc = import_iovec(dir, (const struct iovec __user *)lvec, liovcnt,
+			  UIO_FASTIOV, &iov_l, &iter);
 	if (rc < 0)
 		return rc;
 	if (!iov_iter_count(&iter))
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

