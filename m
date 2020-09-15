Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3217826B383
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgIOXER convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Sep 2020 19:04:17 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:36299 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727343AbgIOOzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 10:55:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-249-wtWq1SXZOrCYpxXqKQvBlw-1; Tue, 15 Sep 2020 15:55:18 +0100
X-MC-Unique: wtWq1SXZOrCYpxXqKQvBlw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 15 Sep 2020 15:55:17 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 15 Sep 2020 15:55:17 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 3/9 next] lib/iov_iter: Improved function for importing
 iovec[] from userpace.
Thread-Topic: [PATCH 3/9 next] lib/iov_iter: Improved function for importing
 iovec[] from userpace.
Thread-Index: AdaLbgrHxt5yVpCaR/OQiuIAS4DQuQ==
Date:   Tue, 15 Sep 2020 14:55:17 +0000
Message-ID: <a24498efacd94e61a2af9df3976b0de6@AcuMS.aculab.com>
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


import_iovec() has a 'pointer by reference' parameter to pass in the
(on-stack) iov[] cache and return the address of a larger copy that
the caller must free.
This is non-intuitive, faffy to setup, and not that efficient.
Instead just pass in the address of the cache and return the address
to free (on success) or PTR_ERR() (on error).

Additionally the size of the 'cache' is nominally variable but is
often specified in a different source file to the actual cache passed.
Use a structure for the 'cache' so that the compiler checks its size.

To avoid having to change everything at once the 'struct iov_iter *'
is passed to rw_copy_check_uvector() which is renamed iovec_import()
and returns the malloced address on success.

import_iovec() is then implemented using iovec_import().

The optimisation for zero length iov[] is removed (they'll now do a zero
length copy_from_user() before returning success).

The check for oversize iov[] is moved inside the check for iov[] larger
than the supplied cache.

The same changes have been made to the compat versions.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 include/linux/uio.h |  14 ++++
 lib/iov_iter.c      | 194 ++++++++++++++++++++------------------------
 2 files changed, 100 insertions(+), 108 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 3835a8a8e9ea..d26482d348f3 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -266,15 +266,29 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum, struct
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 		struct iov_iter *i);
 
+struct iovec_cache {
+	struct iovec  iov[UIO_FASTIOV];
+};
+
 ssize_t import_iovec(int type, const struct iovec __user * uvector,
 		 unsigned nr_segs, unsigned fast_segs,
 		 struct iovec **iov, struct iov_iter *i);
 
+struct iovec *iovec_import(int type, const struct iovec __user * uvector,
+		unsigned int nr_segs, struct iovec_cache *cache,
+		struct iov_iter *i);
+
 #ifdef CONFIG_COMPAT
 struct compat_iovec;
 ssize_t compat_import_iovec(int type, const struct compat_iovec __user * uvector,
 		 unsigned nr_segs, unsigned fast_segs,
 		 struct iovec **iov, struct iov_iter *i);
+
+struct iovec *compat_iovec_import(int type,
+		const struct compat_iovec __user * uvector,
+		unsigned int nr_segs, struct iovec_cache *cache,
+		struct iov_iter *i);
+
 #endif
 
 int import_single_range(int type, void __user *buf, size_t len,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 59b71dc24e02..743bddfcbb05 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1650,69 +1650,50 @@ const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags)
 }
 EXPORT_SYMBOL(dup_iter);
 
-
 /**
- * rw_copy_check_uvector() - Copy an array of &struct iovec from userspace
- *     into the kernel and check that it is valid.
+ * iovec_import() - Copy an array of &struct iovec from userspace
+ *     into the kernel, check that it is valid, and initialize a new
+ *     &struct iov_iter iterator to access it.
  *
- * @type: One of %CHECK_IOVEC_ONLY, %READ, or %WRITE.
+ * @type: One of %CHECK_IOVEC_ONLY, %READ or %WRITE.
  * @uvector: Pointer to the userspace array.
  * @nr_segs: Number of elements in userspace array.
- * @fast_segs: Number of elements in @fast_pointer.
- * @fast_pointer: Pointer to (usually small on-stack) kernel array.
- * @ret_pointer: (output parameter) Pointer to a variable that will point to
- *     either @fast_pointer, a newly allocated kernel array, or NULL,
- *     depending on which array was used.
- *
- * This function copies an array of &struct iovec of @nr_segs from
- * userspace into the kernel and checks that each element is valid (e.g.
- * it does not point to a kernel address or cause overflow by being too
- * large, etc.).
- *
- * As an optimization, the caller may provide a pointer to a small
- * on-stack array in @fast_pointer, typically %UIO_FASTIOV elements long
- * (the size of this array, or 0 if unused, should be given in @fast_segs).
- *
- * @ret_pointer will always point to the array that was used, so the
- * caller must take care not to call kfree() on it e.g. in case the
- * @fast_pointer array was used and it was allocated on the stack.
+ * @fast_segs: Number of elements in @iov.
+ * @fast_pointer:  Pointer to (usually small on-stack) kernel array.
+ * @i: Pointer to iterator that will be initialized on success.
  *
- * Return: The total number of bytes covered by the iovec array on success
- *   or a negative error code on error.
+ * Return: Negative error code on error.
+ *         Success address of iovec array array to free if there were
+ *         more than fast_segs items, NULL otherwise.
  */
-static ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
-			      unsigned long nr_segs, unsigned long fast_segs,
-			      struct iovec *fast_pointer,
-			      struct iovec **ret_pointer)
+struct iovec *iovec_import(int type, const struct iovec __user * uvector,
+			   unsigned int nr_segs, struct iovec_cache *cache,
+			   struct iov_iter *i)
 {
-	unsigned long seg;
-	ssize_t ret;
-	struct iovec *iov = fast_pointer;
+	struct iovec *iov = cache->iov;
+	struct iovec *iov_kmalloc = NULL;
+	unsigned int seg;
+	size_t count;
+	int ret;
 
 	/*
 	 * SuS says "The readv() function *may* fail if the iovcnt argument
 	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
-	 * traditionally returned zero for zero segments, so...
+	 * traditionally returned zero for zero segments.
+	 * No need to optimise...
 	 */
-	if (nr_segs == 0) {
-		ret = 0;
-		goto out;
-	}
 
 	/*
 	 * First get the "struct iovec" from user memory and
 	 * verify all the pointers
 	 */
-	if (nr_segs > UIO_MAXIOV) {
-		ret = -EINVAL;
-		goto out;
-	}
-	if (nr_segs > fast_segs) {
+	if (!cache || nr_segs > ARRAY_SIZE(cache->iov)) {
+		if (nr_segs > UIO_MAXIOV)
+			return ERR_PTR(-EINVAL);
 		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
-		if (iov == NULL) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (iov == NULL)
+			return ERR_PTR(-ENOMEM);
+		iov_kmalloc = iov;
 	}
 	if (copy_from_user(iov, uvector, nr_segs*sizeof(*uvector))) {
 		ret = -EFAULT;
@@ -1728,7 +1709,7 @@ static ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvect
 	 * Linux caps all read/write calls to MAX_RW_COUNT, and avoids the
 	 * overflow case.
 	 */
-	ret = 0;
+	count = 0;
 	for (seg = 0; seg < nr_segs; seg++) {
 		void __user *buf = iov[seg].iov_base;
 		ssize_t len = (ssize_t)iov[seg].iov_len;
@@ -1744,16 +1725,21 @@ static ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvect
 			ret = -EFAULT;
 			goto out;
 		}
-		if (len > MAX_RW_COUNT - ret) {
-			len = MAX_RW_COUNT - ret;
+		if (len > MAX_RW_COUNT - count) {
+			len = MAX_RW_COUNT - count;
 			iov[seg].iov_len = len;
 		}
-		ret += len;
+		count += len;
 	}
+
+	iov_iter_init(i, type, iov, nr_segs, count);
+	return iov_kmalloc;
+
 out:
-	*ret_pointer = iov;
-	return ret;
+	kfree(iov_kmalloc);
+	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL(iovec_import);
 
 /**
  * import_iovec() - Copy an array of &struct iovec from userspace
@@ -1781,57 +1767,47 @@ ssize_t import_iovec(int type, const struct iovec __user * uvector,
 		 unsigned nr_segs, unsigned fast_segs,
 		 struct iovec **iov, struct iov_iter *i)
 {
-	ssize_t n;
-	struct iovec *p;
-	n = rw_copy_check_uvector(type, uvector, nr_segs, fast_segs,
-				  *iov, &p);
-	if (n < 0) {
-		if (p != *iov)
-			kfree(p);
+	struct iovec *iov_kmalloc;
+
+	iov_kmalloc = iovec_import(type, uvector, nr_segs,
+		fast_segs >= UIO_FASTIOV ? (void *)*iov : NULL, i);
+
+	if (IS_ERR(iov_kmalloc)) {
 		*iov = NULL;
-		return n;
+		return PTR_ERR(iov_kmalloc);
 	}
-	iov_iter_init(i, type, p, nr_segs, n);
-	*iov = p == *iov ? NULL : p;
-	return n;
+
+	*iov = iov_kmalloc;
+	return i->count;
 }
 EXPORT_SYMBOL(import_iovec);
 
 #ifdef CONFIG_COMPAT
 #include <linux/compat.h>
 
-static ssize_t compat_rw_copy_check_uvector(int type,
-		const struct compat_iovec __user *uvector, unsigned long nr_segs,
-		unsigned long fast_segs, struct iovec *fast_pointer,
-		struct iovec **ret_pointer)
+struct iovec *compat_iovec_import(int type,
+		const struct compat_iovec __user *uvector, unsigned int nr_segs,
+		struct iovec_cache *cache, struct iov_iter *i)
 {
 	compat_ssize_t tot_len;
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
+	struct iovec *iov = cache->iov;
+	struct iovec *iov_kmalloc = NULL;
+	int ret;
+	unsigned int seg;
+
+	if (!cache || nr_segs > ARRAY_SIZE(cache->iov)) {
+		if (nr_segs > UIO_MAXIOV)
+			return ERR_PTR(-EINVAL);
 		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
 		if (iov == NULL)
-			goto out;
+			return ERR_PTR(-ENOMEM);
+		iov_kmalloc = iov;
 	}
-	*ret_pointer = iov;
 
-	ret = -EFAULT;
-	if (!access_ok(uvector, nr_segs*sizeof(*uvector)))
+	if (!access_ok(uvector, nr_segs*sizeof(*uvector))) {
+		ret = -EINVAL;
 		goto out;
+	}
 
 	/*
 	 * Single unix specification:
@@ -1842,18 +1818,19 @@ static ssize_t compat_rw_copy_check_uvector(int type,
 	 * no overflow possibility.
 	 */
 	tot_len = 0;
-	ret = -EINVAL;
 	for (seg = 0; seg < nr_segs; seg++) {
 		compat_uptr_t buf;
 		compat_ssize_t len;
 
-		if (__get_user(len, &uvector->iov_len) ||
-		   __get_user(buf, &uvector->iov_base)) {
+		if (__get_user(len, &uvector[seg].iov_len) ||
+		   __get_user(buf, &uvector[seg].iov_base)) {
 			ret = -EFAULT;
 			goto out;
 		}
-		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
+		if (len < 0) {	/* size_t not fitting in compat_ssize_t .. */
+			ret = -EINVAL;
 			goto out;
+		}
 		if (type >= 0 &&
 		    !access_ok(compat_ptr(buf), len)) {
 			ret = -EFAULT;
@@ -1862,35 +1839,36 @@ static ssize_t compat_rw_copy_check_uvector(int type,
 		if (len > MAX_RW_COUNT - tot_len)
 			len = MAX_RW_COUNT - tot_len;
 		tot_len += len;
-		iov->iov_base = compat_ptr(buf);
-		iov->iov_len = (compat_size_t) len;
-		uvector++;
-		iov++;
+		iov[seg].iov_base = compat_ptr(buf);
+		iov[seg].iov_len = len;
 	}
-	ret = tot_len;
+
+	iov_iter_init(i, type, iov, nr_segs, tot_len);
+	return iov_kmalloc;
 
 out:
-	return ret;
+	kfree(iov_kmalloc);
+	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL(compat_iovec_import);
 
 ssize_t compat_import_iovec(int type,
 		const struct compat_iovec __user * uvector,
 		unsigned nr_segs, unsigned fast_segs,
 		struct iovec **iov, struct iov_iter *i)
 {
-	ssize_t n;
-	struct iovec *p;
-	n = compat_rw_copy_check_uvector(type, uvector, nr_segs, fast_segs,
-				  *iov, &p);
-	if (n < 0) {
-		if (p != *iov)
-			kfree(p);
+	struct iovec *iov_kmalloc;
+
+	iov_kmalloc = compat_iovec_import(type, uvector, nr_segs,
+		fast_segs >= UIO_FASTIOV ? (void *)*iov : NULL, i);
+
+	if (IS_ERR(iov_kmalloc)) {
 		*iov = NULL;
-		return n;
+		return PTR_ERR(iov_kmalloc);
 	}
-	iov_iter_init(i, type, p, nr_segs, n);
-	*iov = p == *iov ? NULL : p;
-	return n;
+
+	*iov = iov_kmalloc;
+	return i->count;
 }
 EXPORT_SYMBOL(compat_import_iovec);
 #endif
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

