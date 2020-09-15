Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A73026B36F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgIOXCB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Sep 2020 19:02:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:27049 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727363AbgIOOzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 10:55:51 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-212-ouC9VtsePgW0zmxTBHC3SA-1; Tue, 15 Sep 2020 15:55:35 +0100
X-MC-Unique: ouC9VtsePgW0zmxTBHC3SA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 15 Sep 2020 15:55:34 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 15 Sep 2020 15:55:34 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 8/9 next] fs: Use iovec_import() instead of import_iovec().
Thread-Topic: [PATCH 8/9 next] fs: Use iovec_import() instead of
 import_iovec().
Thread-Index: AdaLblh1gZNjsQwuQPyq7LxxRCu5GQ==
Date:   Tue, 15 Sep 2020 14:55:34 +0000
Message-ID: <d8bd576f70d646219ccdc8bde82fafdd@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


iovec_import() has a safer calling convention than import_iovec().

Signed-off-by: David Laight <david.laight@aculab.com>
---
 fs/aio.c        | 34 ++++++++++++------------
 fs/read_write.c | 69 ++++++++++++++++++++++++++-----------------------
 fs/splice.c     | 22 +++++++++-------
 3 files changed, 65 insertions(+), 60 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index d5ec30385566..909c03143374 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1477,24 +1477,20 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 	return 0;
 }
 
-static ssize_t aio_setup_rw(int rw, const struct iocb *iocb,
-		struct iovec **iovec, bool vectored, bool compat,
+static struct iovec *aio_setup_rw(int rw, const struct iocb *iocb,
+		struct iovec_cache *cache, bool vectored, bool compat,
 		struct iov_iter *iter)
 {
 	void __user *buf = (void __user *)(uintptr_t)iocb->aio_buf;
 	size_t len = iocb->aio_nbytes;
 
-	if (!vectored) {
-		ssize_t ret = import_single_range(rw, buf, len, *iovec, iter);
-		*iovec = NULL;
-		return ret;
-	}
+	if (!vectored)
+		return ERR_PTR(import_single_range(rw, buf, len, cache->iov, iter));
 #ifdef CONFIG_COMPAT
 	if (compat)
-		return compat_import_iovec(rw, buf, len, UIO_FASTIOV, iovec,
-				iter);
+		return compat_iovec_import(rw, buf, len, cache, iter);
 #endif
-	return import_iovec(rw, buf, len, UIO_FASTIOV, iovec, iter);
+	return iovec_import(rw, buf, len, cache, iter);
 }
 
 static inline void aio_rw_done(struct kiocb *req, ssize_t ret)
@@ -1520,8 +1516,9 @@ static inline void aio_rw_done(struct kiocb *req, ssize_t ret)
 static int aio_read(struct kiocb *req, const struct iocb *iocb,
 			bool vectored, bool compat)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct iovec_cache cache;
 	struct iov_iter iter;
+	struct iovec *iovec;
 	struct file *file;
 	int ret;
 
@@ -1535,9 +1532,9 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 	if (unlikely(!file->f_op->read_iter))
 		return -EINVAL;
 
-	ret = aio_setup_rw(READ, iocb, &iovec, vectored, compat, &iter);
-	if (ret < 0)
-		return ret;
+	iovec = aio_setup_rw(READ, iocb, &cache, vectored, compat, &iter);
+	if (IS_ERR(iovec))
+		return PTR_ERR(iovec);
 	ret = rw_verify_area(READ, file, &req->ki_pos, iov_iter_count(&iter));
 	if (!ret)
 		aio_rw_done(req, call_read_iter(file, req, &iter));
@@ -1548,8 +1545,9 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 static int aio_write(struct kiocb *req, const struct iocb *iocb,
 			 bool vectored, bool compat)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct iovec_cache cache;
 	struct iov_iter iter;
+	struct iovec *iovec;
 	struct file *file;
 	int ret;
 
@@ -1563,9 +1561,9 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 	if (unlikely(!file->f_op->write_iter))
 		return -EINVAL;
 
-	ret = aio_setup_rw(WRITE, iocb, &iovec, vectored, compat, &iter);
-	if (ret < 0)
-		return ret;
+	iovec = aio_setup_rw(WRITE, iocb, &cache, vectored, compat, &iter);
+	if (IS_ERR(iovec))
+		return PTR_ERR(iovec);
 	ret = rw_verify_area(WRITE, file, &req->ki_pos, iov_iter_count(&iter));
 	if (!ret) {
 		/*
diff --git a/fs/read_write.c b/fs/read_write.c
index e5e891a88442..6e3d4a646f3c 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -884,35 +884,38 @@ EXPORT_SYMBOL(vfs_iter_write);
 ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 		  unsigned long vlen, loff_t *pos, rwf_t flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache cache;
 	struct iov_iter iter;
+	struct iovec *iov;
 	ssize_t ret;
 
-	ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
-	if (ret >= 0) {
-		ret = do_iter_read(file, &iter, pos, flags);
-		kfree(iov);
-	}
+	iov = iovec_import(READ, vec, vlen, &cache, &iter);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
+
+	ret = do_iter_read(file, &iter, pos, flags);
 
+	kfree(iov);
 	return ret;
 }
 
 static ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 		   unsigned long vlen, loff_t *pos, rwf_t flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache cache;
 	struct iov_iter iter;
+	struct iovec *iov;
 	ssize_t ret;
 
-	ret = import_iovec(WRITE, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
-	if (ret >= 0) {
-		file_start_write(file);
-		ret = do_iter_write(file, &iter, pos, flags);
-		file_end_write(file);
-		kfree(iov);
-	}
+	iov = iovec_import(WRITE, vec, vlen, &cache, &iter);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
+
+	file_start_write(file);
+	ret = do_iter_write(file, &iter, pos, flags);
+	file_end_write(file);
+
+	kfree(iov);
 	return ret;
 }
 
@@ -1073,16 +1076,17 @@ static size_t compat_readv(struct file *file,
 			   const struct compat_iovec __user *vec,
 			   unsigned long vlen, loff_t *pos, rwf_t flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache cache;
 	struct iov_iter iter;
+	struct iovec *iov;
 	ssize_t ret;
 
-	ret = compat_import_iovec(READ, vec, vlen, UIO_FASTIOV, &iov, &iter);
-	if (ret >= 0) {
-		ret = do_iter_read(file, &iter, pos, flags);
-		kfree(iov);
-	}
+	iov = compat_iovec_import(READ, vec, vlen, &cache, &iter);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
+
+	ret = do_iter_read(file, &iter, pos, flags);
+	kfree(iov);
 	if (ret > 0)
 		add_rchar(current, ret);
 	inc_syscr(current);
@@ -1181,18 +1185,19 @@ static size_t compat_writev(struct file *file,
 			    const struct compat_iovec __user *vec,
 			    unsigned long vlen, loff_t *pos, rwf_t flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache cache;
 	struct iov_iter iter;
+	struct iovec *iov;
 	ssize_t ret;
 
-	ret = compat_import_iovec(WRITE, vec, vlen, UIO_FASTIOV, &iov, &iter);
-	if (ret >= 0) {
-		file_start_write(file);
-		ret = do_iter_write(file, &iter, pos, flags);
-		file_end_write(file);
-		kfree(iov);
-	}
+	iov = compat_iovec_import(WRITE, vec, vlen, &cache, &iter);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
+
+	file_start_write(file);
+	ret = do_iter_write(file, &iter, pos, flags);
+	file_end_write(file);
+	kfree(iov);
 	if (ret > 0)
 		add_wchar(current, ret);
 	inc_syscw(current);
diff --git a/fs/splice.c b/fs/splice.c
index d7c8a7c4db07..ec1a825525d0 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1349,9 +1349,9 @@ static long do_vmsplice(struct file *f, struct iov_iter *iter, unsigned int flag
 SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 		unsigned long, nr_segs, unsigned int, flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache cache;
 	struct iov_iter iter;
+	struct iovec *iov;
 	ssize_t error;
 	struct fd f;
 	int type;
@@ -1361,9 +1361,10 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 	if (error)
 		return error;
 
-	error = import_iovec(type, uiov, nr_segs,
-			     ARRAY_SIZE(iovstack), &iov, &iter);
-	if (error >= 0) {
+	iov = iovec_import(type, uiov, nr_segs, &cache, &iter);
+	if (IS_ERR(iov)) {
+		error = PTR_ERR(iov);
+	} else {
 		error = do_vmsplice(f.file, &iter, flags);
 		kfree(iov);
 	}
@@ -1375,9 +1376,9 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 COMPAT_SYSCALL_DEFINE4(vmsplice, int, fd, const struct compat_iovec __user *, iov32,
 		    unsigned int, nr_segs, unsigned int, flags)
 {
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
+	struct iovec_cache cache;
 	struct iov_iter iter;
+	struct iovec *iov;
 	ssize_t error;
 	struct fd f;
 	int type;
@@ -1387,9 +1388,10 @@ COMPAT_SYSCALL_DEFINE4(vmsplice, int, fd, const struct compat_iovec __user *, io
 	if (error)
 		return error;
 
-	error = compat_import_iovec(type, iov32, nr_segs,
-			     ARRAY_SIZE(iovstack), &iov, &iter);
-	if (error >= 0) {
+	iov = compat_iovec_import(type, iov32, nr_segs, &cache, &iter);
+	if (IS_ERR(iov)) {
+		error = PTR_ERR(iov);
+	} else {
 		error = do_vmsplice(f.file, &iter, flags);
 		kfree(iov);
 	}
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

