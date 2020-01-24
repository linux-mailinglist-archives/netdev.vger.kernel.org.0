Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57632148B6D
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389108AbgAXPqE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Jan 2020 10:46:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:59492 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389004AbgAXPqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:46:04 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-32-LqdHNSh2OjKe-f4p8Ey0qg-1; Fri, 24 Jan 2020 15:45:59 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 24 Jan 2020 15:45:58 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 24 Jan 2020 15:45:58 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: [PATCH 1/3] Use a struct for the on-stack 'struct iovec' cache for
 user sg requests.
Thread-Topic: [PATCH 1/3] Use a struct for the on-stack 'struct iovec' cache
 for user sg requests.
Thread-Index: AdXSzAU5/rHADL2mTWqu17tWnBJSKQ==
Date:   Fri, 24 Jan 2020 15:45:58 +0000
Message-ID: <78cebb9dc9ab4e5d80810b5d970e58cc@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: LqdHNSh2OjKe-f4p8Ey0qg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rw_copy_check_uvector() has an optimisation to save the kmalloc() for
small SG arrays.
However nothing really guarantees that the actual size of the (on stack)
cache actually matches that passed to the function.
Since all the callers that pass a cache use the same size (UIO_FASTIOV)
embed the array inside a struct so that the compiler checks the size.
This also saves the size being passed through several layers.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 block/scsi_ioctl.c     |  4 ++--
 drivers/scsi/sg.c      |  4 ++--
 fs/aio.c               | 13 ++++++-------
 fs/io_uring.c          | 11 +++++------
 fs/read_write.c        | 38 +++++++++++++++++++-------------------
 fs/splice.c            | 14 ++++++--------
 include/linux/compat.h |  2 +-
 include/linux/fs.h     | 10 ++++++++--
 include/linux/uio.h    |  9 +++++----
 include/net/compat.h   |  2 +-
 lib/iov_iter.c         | 22 ++++++++++------------
 mm/process_vm_access.c | 31 +++++++++++++++----------------
 net/compat.c           |  4 ++--
 net/socket.c           | 10 +++++-----
 security/keys/compat.c |  6 ++----
 security/keys/keyctl.c |  5 ++---
 16 files changed, 91 insertions(+), 94 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index f5e0ad6..a3fcba0 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -325,11 +325,11 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	ret = 0;
 	if (hdr->iovec_count) {
 		struct iov_iter i;
-		struct iovec *iov = NULL;
+		struct iovec_cache *iov = NULL;
 
 		ret = import_iovec(rq_data_dir(rq),
 				   hdr->dxferp, hdr->iovec_count,
-				   0, &iov, &i);
+				   &iov, &i);
 		if (ret < 0)
 			goto out_free_cdb;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index cce7575..7c3f9f6 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1794,10 +1794,10 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	}
 
 	if (iov_count) {
-		struct iovec *iov = NULL;
+		struct iovec_cache *iov = NULL;
 		struct iov_iter i;
 
-		res = import_iovec(rw, hp->dxferp, iov_count, 0, &iov, &i);
+		res = import_iovec(rw, hp->dxferp, iov_count, &iov, &i);
 		if (res < 0)
 			return res;
 
diff --git a/fs/aio.c b/fs/aio.c
index 01e0fb9..aed10d1 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1478,23 +1478,22 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 }
 
 static ssize_t aio_setup_rw(int rw, const struct iocb *iocb,
-		struct iovec **iovec, bool vectored, bool compat,
+		struct iovec_cache **iovec, bool vectored, bool compat,
 		struct iov_iter *iter)
 {
 	void __user *buf = (void __user *)(uintptr_t)iocb->aio_buf;
 	size_t len = iocb->aio_nbytes;
 
 	if (!vectored) {
-		ssize_t ret = import_single_range(rw, buf, len, *iovec, iter);
+		ssize_t ret = import_single_range(rw, buf, len, &(*iovec)->iovec[0], iter);
 		*iovec = NULL;
 		return ret;
 	}
 #ifdef CONFIG_COMPAT
 	if (compat)
-		return compat_import_iovec(rw, buf, len, UIO_FASTIOV, iovec,
-				iter);
+		return compat_import_iovec(rw, buf, len, iovec, iter);
 #endif
-	return import_iovec(rw, buf, len, UIO_FASTIOV, iovec, iter);
+	return import_iovec(rw, buf, len, iovec, iter);
 }
 
 static inline void aio_rw_done(struct kiocb *req, ssize_t ret)
@@ -1520,7 +1519,7 @@ static inline void aio_rw_done(struct kiocb *req, ssize_t ret)
 static int aio_read(struct kiocb *req, const struct iocb *iocb,
 			bool vectored, bool compat)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct iovec_cache inline_vecs, *iovec = &inline_vecs;
 	struct iov_iter iter;
 	struct file *file;
 	int ret;
@@ -1548,7 +1547,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 static int aio_write(struct kiocb *req, const struct iocb *iocb,
 			 bool vectored, bool compat)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct iovec_cache inline_vecs, *iovec = &inline_vecs;
 	struct iov_iter iter;
 	struct file *file;
 	int ret;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index f9a3899..bde73b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1229,7 +1229,7 @@ static int io_import_fixed(struct io_ring_ctx *ctx, int rw,
 }
 
 static ssize_t io_import_iovec(struct io_ring_ctx *ctx, int rw,
-			       const struct sqe_submit *s, struct iovec **iovec,
+			       const struct sqe_submit *s, struct iovec_cache **iovec,
 			       struct iov_iter *iter)
 {
 	const struct io_uring_sqe *sqe = s->sqe;
@@ -1258,11 +1258,10 @@ static ssize_t io_import_iovec(struct io_ring_ctx *ctx, int rw,
 
 #ifdef CONFIG_COMPAT
 	if (ctx->compat)
-		return compat_import_iovec(rw, buf, sqe_len, UIO_FASTIOV,
-						iovec, iter);
+		return compat_import_iovec(rw, buf, sqe_len, iovec, iter);
 #endif
 
-	return import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter);
+	return import_iovec(rw, buf, sqe_len, iovec, iter);
 }
 
 static inline bool io_should_merge(struct async_list *al, struct kiocb *kiocb)
@@ -1372,7 +1371,7 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 static int io_read(struct io_kiocb *req, const struct sqe_submit *s,
 		   bool force_nonblock)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct iovec_cache inline_vecs, *iovec = &inline_vecs;
 	struct kiocb *kiocb = &req->rw;
 	struct iov_iter iter;
 	struct file *file;
@@ -1437,7 +1436,7 @@ static int io_read(struct io_kiocb *req, const struct sqe_submit *s,
 static int io_write(struct io_kiocb *req, const struct sqe_submit *s,
 		    bool force_nonblock)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct iovec_cache inline_vecs, *iovec = &inline_vecs;
 	struct kiocb *kiocb = &req->rw;
 	struct iov_iter iter;
 	struct file *file;
diff --git a/fs/read_write.c b/fs/read_write.c
index 5bbf587..441d9ca 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -762,13 +762,13 @@ static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
  *   or a negative error code on error.
  */
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
-			      unsigned long nr_segs, unsigned long fast_segs,
-			      struct iovec *fast_pointer,
+			      unsigned long nr_segs,
+			      struct iovec_cache *fast_pointer,
 			      struct iovec **ret_pointer)
 {
 	unsigned long seg;
 	ssize_t ret;
-	struct iovec *iov = fast_pointer;
+	struct iovec *iov = &fast_pointer->iovec[0];
 
 	/*
 	 * SuS says "The readv() function *may* fail if the iovcnt argument
@@ -788,7 +788,7 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (nr_segs > fast_segs) {
+	if (!fast_pointer || nr_segs > ARRAY_SIZE(fast_pointer->iovec)) {
 		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
 		if (iov == NULL) {
 			ret = -ENOMEM;
@@ -839,11 +839,11 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 #ifdef CONFIG_COMPAT
 ssize_t compat_rw_copy_check_uvector(int type,
 		const struct compat_iovec __user *uvector, unsigned long nr_segs,
-		unsigned long fast_segs, struct iovec *fast_pointer,
+		struct iovec_cache *fast_pointer,
 		struct iovec **ret_pointer)
 {
 	compat_ssize_t tot_len;
-	struct iovec *iov = *ret_pointer = fast_pointer;
+	struct iovec *iov = *ret_pointer = &fast_pointer->iovec[0];
 	ssize_t ret = 0;
 	int seg;
 
@@ -858,7 +858,7 @@ ssize_t compat_rw_copy_check_uvector(int type,
 	ret = -EINVAL;
 	if (nr_segs > UIO_MAXIOV)
 		goto out;
-	if (nr_segs > fast_segs) {
+	if (!fast_pointer || nr_segs > ARRAY_SIZE(fast_pointer->iovec)) {
 		ret = -ENOMEM;
 		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
 		if (iov == NULL)
@@ -987,12 +987,12 @@ ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos,
 ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 		  unsigned long vlen, loff_t *pos, rwf_t flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache iovstack;
+	struct iovec_cache *iov = &iovstack;
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
+	ret = import_iovec(READ, vec, vlen, &iov, &iter);
 	if (ret >= 0) {
 		ret = do_iter_read(file, &iter, pos, flags);
 		kfree(iov);
@@ -1004,12 +1004,12 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 static ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 		   unsigned long vlen, loff_t *pos, rwf_t flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache iovstack;
+	struct iovec_cache *iov = &iovstack;
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = import_iovec(WRITE, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
+	ret = import_iovec(WRITE, vec, vlen, &iov, &iter);
 	if (ret >= 0) {
 		file_start_write(file);
 		ret = do_iter_write(file, &iter, pos, flags);
@@ -1176,12 +1176,12 @@ static size_t compat_readv(struct file *file,
 			   const struct compat_iovec __user *vec,
 			   unsigned long vlen, loff_t *pos, rwf_t flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache iovstack;
+	struct iovec_cache *iov = &iovstack;
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = compat_import_iovec(READ, vec, vlen, UIO_FASTIOV, &iov, &iter);
+	ret = compat_import_iovec(READ, vec, vlen, &iov, &iter);
 	if (ret >= 0) {
 		ret = do_iter_read(file, &iter, pos, flags);
 		kfree(iov);
@@ -1284,12 +1284,12 @@ static size_t compat_writev(struct file *file,
 			    const struct compat_iovec __user *vec,
 			    unsigned long vlen, loff_t *pos, rwf_t flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache iovstack;
+	struct iovec_cache *iov = &iovstack;
 	struct iov_iter iter;
 	ssize_t ret;
 
-	ret = compat_import_iovec(WRITE, vec, vlen, UIO_FASTIOV, &iov, &iter);
+	ret = compat_import_iovec(WRITE, vec, vlen, &iov, &iter);
 	if (ret >= 0) {
 		file_start_write(file);
 		ret = do_iter_write(file, &iter, pos, flags);
diff --git a/fs/splice.c b/fs/splice.c
index 9841272..ef919db 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1353,8 +1353,8 @@ static long do_vmsplice(struct file *f, struct iov_iter *iter, unsigned int flag
 SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 		unsigned long, nr_segs, unsigned int, flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache iovstack;
+	struct iovec_cache *iov = &iovstack;
 	struct iov_iter iter;
 	ssize_t error;
 	struct fd f;
@@ -1365,8 +1365,7 @@ static long do_vmsplice(struct file *f, struct iov_iter *iter, unsigned int flag
 	if (error)
 		return error;
 
-	error = import_iovec(type, uiov, nr_segs,
-			     ARRAY_SIZE(iovstack), &iov, &iter);
+	error = import_iovec(type, uiov, nr_segs, &iov, &iter);
 	if (error >= 0) {
 		error = do_vmsplice(f.file, &iter, flags);
 		kfree(iov);
@@ -1379,8 +1378,8 @@ static long do_vmsplice(struct file *f, struct iov_iter *iter, unsigned int flag
 COMPAT_SYSCALL_DEFINE4(vmsplice, int, fd, const struct compat_iovec __user *, iov32,
 		    unsigned int, nr_segs, unsigned int, flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache iovstack;
+	struct iovec_cache *iov = &iovstack;
 	struct iov_iter iter;
 	ssize_t error;
 	struct fd f;
@@ -1391,8 +1390,7 @@ static long do_vmsplice(struct file *f, struct iov_iter *iter, unsigned int flag
 	if (error)
 		return error;
 
-	error = compat_import_iovec(type, iov32, nr_segs,
-			     ARRAY_SIZE(iovstack), &iov, &iter);
+	error = compat_import_iovec(type, iov32, nr_segs, &iov, &iter);
 	if (error >= 0) {
 		error = do_vmsplice(f.file, &iter, flags);
 		kfree(iov);
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 16dafd9..3c6e3b3 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -485,7 +485,7 @@ extern long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 extern ssize_t compat_rw_copy_check_uvector(int type,
 		const struct compat_iovec __user *uvector,
 		unsigned long nr_segs,
-		unsigned long fast_segs, struct iovec *fast_pointer,
+		struct iovec_cache *fast_pointer,
 		struct iovec **ret_pointer);
 
 extern void __user *compat_alloc_user_space(unsigned long len);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0d909d..47329e1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -43,6 +43,7 @@
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
+#include <uapi/linux/uio.h>
 
 struct backing_dev_info;
 struct bdi_writeback;
@@ -1900,9 +1901,14 @@ static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
 	return file->f_op->mmap(file, vma);
 }
 
+/* On-stack buffer to avoid kmalloc() for small vectors */
+struct iovec_cache {
+	struct iovec iovec[UIO_FASTIOV];
+};
+
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
-			      unsigned long nr_segs, unsigned long fast_segs,
-			      struct iovec *fast_pointer,
+			      unsigned long nr_segs,
+			      struct iovec_cache *fast_pointer,
 			      struct iovec **ret_pointer);
 
 extern ssize_t __vfs_read(struct file *, char __user *, size_t, loff_t *);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index ab5f523..01c6979 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -267,15 +267,16 @@ static inline void iov_iter_reexpand(struct iov_iter *i, size_t count)
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 		struct iov_iter *i);
 
+struct iovec_cache;
 ssize_t import_iovec(int type, const struct iovec __user * uvector,
-		 unsigned nr_segs, unsigned fast_segs,
-		 struct iovec **iov, struct iov_iter *i);
+		 unsigned nr_segs,
+		 struct iovec_cache **iov_cache, struct iov_iter *i);
 
 #ifdef CONFIG_COMPAT
 struct compat_iovec;
 ssize_t compat_import_iovec(int type, const struct compat_iovec __user * uvector,
-		 unsigned nr_segs, unsigned fast_segs,
-		 struct iovec **iov, struct iov_iter *i);
+		 unsigned nr_segs,
+		 struct iovec_cache **iov_cache, struct iov_iter *i);
 #endif
 
 int import_single_range(int type, void __user *buf, size_t len,
diff --git a/include/net/compat.h b/include/net/compat.h
index f277653..65f1b8c 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -39,7 +39,7 @@ struct compat_cmsghdr {
 #endif /* defined(CONFIG_COMPAT) */
 
 int get_compat_msghdr(struct msghdr *, struct compat_msghdr __user *,
-		      struct sockaddr __user **, struct iovec **);
+		      struct sockaddr __user **, struct iovec_cache **);
 struct sock_fprog __user *get_compat_bpf_fprog(char __user *optval);
 int put_cmsg_compat(struct msghdr*, int, int, int, void *);
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 639d5e7..5cd7173 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1637,21 +1637,20 @@ const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags)
  * Return: Negative error code on error, bytes imported on success
  */
 ssize_t import_iovec(int type, const struct iovec __user * uvector,
-		 unsigned nr_segs, unsigned fast_segs,
-		 struct iovec **iov, struct iov_iter *i)
+		 unsigned nr_segs,
+		 struct iovec_cache **iov, struct iov_iter *i)
 {
 	ssize_t n;
 	struct iovec *p;
-	n = rw_copy_check_uvector(type, uvector, nr_segs, fast_segs,
-				  *iov, &p);
+	n = rw_copy_check_uvector(type, uvector, nr_segs, *iov, &p);
 	if (n < 0) {
-		if (p != *iov)
+		if (p != &(*iov)->iovec[0])
 			kfree(p);
 		*iov = NULL;
 		return n;
 	}
 	iov_iter_init(i, type, p, nr_segs, n);
-	*iov = p == *iov ? NULL : p;
+	*iov = p == &(*iov)->iovec[0] ? NULL : (void *)p;
 	return n;
 }
 EXPORT_SYMBOL(import_iovec);
@@ -1661,21 +1660,20 @@ ssize_t import_iovec(int type, const struct iovec __user * uvector,
 
 ssize_t compat_import_iovec(int type,
 		const struct compat_iovec __user * uvector,
-		unsigned nr_segs, unsigned fast_segs,
-		struct iovec **iov, struct iov_iter *i)
+		unsigned nr_segs,
+		struct iovec_cache **iov, struct iov_iter *i)
 {
 	ssize_t n;
 	struct iovec *p;
-	n = compat_rw_copy_check_uvector(type, uvector, nr_segs, fast_segs,
-				  *iov, &p);
+	n = compat_rw_copy_check_uvector(type, uvector, nr_segs, *iov, &p);
 	if (n < 0) {
-		if (p != *iov)
+		if (p != &(*iov)->iovec[0])
 			kfree(p);
 		*iov = NULL;
 		return n;
 	}
 	iov_iter_init(i, type, p, nr_segs, n);
-	*iov = p == *iov ? NULL : p;
+	*iov = p == &(*iov)->iovec[0] ? NULL : (void *)p;
 	return n;
 }
 #endif
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 357aa7b..5bb478c 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -258,10 +258,10 @@ static ssize_t process_vm_rw(pid_t pid,
 			     unsigned long riovcnt,
 			     unsigned long flags, int vm_write)
 {
-	struct iovec iovstack_l[UIO_FASTIOV];
-	struct iovec iovstack_r[UIO_FASTIOV];
-	struct iovec *iov_l = iovstack_l;
-	struct iovec *iov_r = iovstack_r;
+	struct iovec_cache iovstack_l;
+	struct iovec_cache iovstack_r;
+	struct iovec_cache *iov_l = &iovstack_l;
+	struct iovec *iov_r = NULL;
 	struct iov_iter iter;
 	ssize_t rc;
 	int dir = vm_write ? WRITE : READ;
@@ -270,21 +270,21 @@ static ssize_t process_vm_rw(pid_t pid,
 		return -EINVAL;
 
 	/* Check iovecs */
-	rc = import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter);
+	rc = import_iovec(dir, lvec, liovcnt, &iov_l, &iter);
 	if (rc < 0)
 		return rc;
 	if (!iov_iter_count(&iter))
 		goto free_iovecs;
 
-	rc = rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV,
-				   iovstack_r, &iov_r);
+	rc = rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt,
+				   &iovstack_r, &iov_r);
 	if (rc <= 0)
 		goto free_iovecs;
 
 	rc = process_vm_rw_core(pid, &iter, iov_r, riovcnt, flags, vm_write);
 
 free_iovecs:
-	if (iov_r != iovstack_r)
+	if (iov_r != &iovstack_r.iovec[0])
 		kfree(iov_r);
 	kfree(iov_l);
 
@@ -316,10 +316,10 @@ static ssize_t process_vm_rw(pid_t pid,
 		     unsigned long riovcnt,
 		     unsigned long flags, int vm_write)
 {
-	struct iovec iovstack_l[UIO_FASTIOV];
-	struct iovec iovstack_r[UIO_FASTIOV];
-	struct iovec *iov_l = iovstack_l;
-	struct iovec *iov_r = iovstack_r;
+	struct iovec_cache iovstack_l;
+	struct iovec_cache iovstack_r;
+	struct iovec_cache *iov_l = &iovstack_l;
+	struct iovec *iov_r = NULL;
 	struct iov_iter iter;
 	ssize_t rc = -EFAULT;
 	int dir = vm_write ? WRITE : READ;
@@ -327,21 +327,20 @@ static ssize_t process_vm_rw(pid_t pid,
 	if (flags != 0)
 		return -EINVAL;
 
-	rc = compat_import_iovec(dir, lvec, liovcnt, UIO_FASTIOV, &iov_l, &iter);
+	rc = compat_import_iovec(dir, lvec, liovcnt, &iov_l, &iter);
 	if (rc < 0)
 		return rc;
 	if (!iov_iter_count(&iter))
 		goto free_iovecs;
 	rc = compat_rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt,
-					  UIO_FASTIOV, iovstack_r,
-					  &iov_r);
+					  &iovstack_r, &iov_r);
 	if (rc <= 0)
 		goto free_iovecs;
 
 	rc = process_vm_rw_core(pid, &iter, iov_r, riovcnt, flags, vm_write);
 
 free_iovecs:
-	if (iov_r != iovstack_r)
+	if (iov_r != &iovstack_r.iovec[0])
 		kfree(iov_r);
 	kfree(iov_l);
 	return rc;
diff --git a/net/compat.c b/net/compat.c
index 0f7ded2..48f4de5 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -36,7 +36,7 @@
 int get_compat_msghdr(struct msghdr *kmsg,
 		      struct compat_msghdr __user *umsg,
 		      struct sockaddr __user **save_addr,
-		      struct iovec **iov)
+		      struct iovec_cache **iov)
 {
 	struct compat_msghdr msg;
 	ssize_t err;
@@ -82,7 +82,7 @@ int get_compat_msghdr(struct msghdr *kmsg,
 
 	err = compat_import_iovec(save_addr ? READ : WRITE,
 				   compat_ptr(msg.msg_iov), msg.msg_iovlen,
-				   UIO_FASTIOV, iov, &kmsg->msg_iter);
+				   iov, &kmsg->msg_iter);
 	return err < 0 ? err : 0;
 }
 
diff --git a/net/socket.c b/net/socket.c
index 6a9ab7a..cb67d82 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2183,7 +2183,7 @@ struct used_address {
 static int copy_msghdr_from_user(struct msghdr *kmsg,
 				 struct user_msghdr __user *umsg,
 				 struct sockaddr __user **save_addr,
-				 struct iovec **iov)
+				 struct iovec_cache **iov)
 {
 	struct user_msghdr msg;
 	ssize_t err;
@@ -2228,7 +2228,7 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 
 	err = import_iovec(save_addr ? READ : WRITE,
 			    msg.msg_iov, msg.msg_iovlen,
-			    UIO_FASTIOV, iov, &kmsg->msg_iter);
+			    iov, &kmsg->msg_iter);
 	return err < 0 ? err : 0;
 }
 
@@ -2240,7 +2240,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 	struct compat_msghdr __user *msg_compat =
 	    (struct compat_msghdr __user *)msg;
 	struct sockaddr_storage address;
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct iovec_cache iovstack, *iov = &iovstack;
 	unsigned char ctl[sizeof(struct cmsghdr) + 20]
 				__aligned(sizeof(__kernel_size_t));
 	/* 20 is size of ipv6_pktinfo */
@@ -2447,8 +2447,8 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 {
 	struct compat_msghdr __user *msg_compat =
 	    (struct compat_msghdr __user *)msg;
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache iovstack;
+	struct iovec_cache *iov = &iovstack;
 	unsigned long cmsg_ptr;
 	int len;
 	ssize_t err;
diff --git a/security/keys/compat.c b/security/keys/compat.c
index 9bcc404..d5ddf80 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -26,16 +26,14 @@ static long compat_keyctl_instantiate_key_iov(
 	unsigned ioc,
 	key_serial_t ringid)
 {
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct iovec_cache iovstack, *iov = &iovstack;
 	struct iov_iter from;
 	long ret;
 
 	if (!_payload_iov)
 		ioc = 0;
 
-	ret = compat_import_iovec(WRITE, _payload_iov, ioc,
-				  ARRAY_SIZE(iovstack), &iov,
-				  &from);
+	ret = compat_import_iovec(WRITE, _payload_iov, ioc, &iov, &from);
 	if (ret < 0)
 		return ret;
 
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 9b898c9..ee26360 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1208,15 +1208,14 @@ long keyctl_instantiate_key_iov(key_serial_t id,
 				unsigned ioc,
 				key_serial_t ringid)
 {
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct iovec_cache iovstack, *iov = &iovstack;
 	struct iov_iter from;
 	long ret;
 
 	if (!_payload_iov)
 		ioc = 0;
 
-	ret = import_iovec(WRITE, _payload_iov, ioc,
-				    ARRAY_SIZE(iovstack), &iov, &from);
+	ret = import_iovec(WRITE, _payload_iov, ioc, &iov, &from);
 	if (ret < 0)
 		return ret;
 	ret = keyctl_instantiate_key_common(id, &from, ringid);
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

