Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CDB277F5B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 06:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgIYEwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 00:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYEwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 00:52:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8E3C0613CE;
        Thu, 24 Sep 2020 21:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ayH6wB0p+odadUMA151Oa1/UBa/wAaRLDxK5Z5uObHU=; b=dvqVoHrr5a6FoZeyVyAzu0RzXO
        /ZBuVbluq6fCO/sDnJN9PppNzVwJ2/AWbmhOST1riJZK7nzfcZWZy59q3Yux3Fb0/vRsf2Y1glCcy
        Yqm3UTCB9q2zwp9c4+CGVfaI37bCDW+9Bg8pDlEj4SjE2kaz62bs51P6u14jM+RIO5CIiKttymnu+
        8dyStDevGw1HntbTchUHp4KFY4D3brs9d/cpGzS5j2FV4yiNthi/IBCnwOb6MxERkVoWFa/hCtEWH
        swS87YnB0sM2NSVYe5gcJzX+wGdXfE/uFplAwEuy+JqqBpCJNbsRs3qChFts0+G1eLJwzMX9AgBq+
        H7U3noMg==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLfi3-0002pv-8H; Fri, 25 Sep 2020 04:51:52 +0000
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
Subject: [PATCH 3/9] iov_iter: refactor rw_copy_check_uvector and import_iovec
Date:   Fri, 25 Sep 2020 06:51:40 +0200
Message-Id: <20200925045146.1283714-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925045146.1283714-1-hch@lst.de>
References: <20200925045146.1283714-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split rw_copy_check_uvector into two new helpers with more sensible
calling conventions:

 - iovec_from_user copies a iovec from userspace either into the provided
   stack buffer if it fits, or allocates a new buffer for it.  Returns
   the actually used iovec.  It also verifies that iov_len does fit a
   signed type, and handles compat iovecs if the compat flag is set.
 - __import_iovec consolidates the native and compat versions of
   import_iovec. It calls iovec_from_user, then validates each iovec
   actually points to user addresses, and ensures the total length
   doesn't overflow.

This has two major implications:

 - the access_process_vm case loses the total lenght checking, which
   wasn't required anyway, given that each call receives two iovecs
   for the local and remote side of the operation, and it verifies
   the total length on the local side already.
 - instead of a single loop there now are two loops over the iovecs.
   Given that the iovecs are cache hot this doesn't make a major
   difference

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/compat.h |   6 -
 include/linux/fs.h     |  13 --
 include/linux/uio.h    |  12 +-
 lib/iov_iter.c         | 300 ++++++++++++++++-------------------------
 mm/process_vm_access.c |  34 +++--
 5 files changed, 138 insertions(+), 227 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 654c1ec36671a4..b930de791ff16b 100644
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
index 7519ae003a082c..e69b45b6cc7b5f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -178,14 +178,6 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File supports async buffered reads */
 #define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
 
-/*
- * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
- * that indicates that they should check the contents of the iovec are
- * valid, but not check the memory that the iovec elements
- * points too.
- */
-#define CHECK_IOVEC_ONLY -1
-
 /*
  * Attribute flags.  These should be or-ed together to figure out what
  * has been changed!
@@ -1887,11 +1879,6 @@ static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
 	return file->f_op->mmap(file, vma);
 }
 
-ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
-			      unsigned long nr_segs, unsigned long fast_segs,
-			      struct iovec *fast_pointer,
-			      struct iovec **ret_pointer);
-
 extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 3835a8a8e9eae0..92c11fe41c6228 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -266,9 +266,15 @@ bool csum_and_copy_from_iter_full(void *addr, size_t bytes, __wsum *csum, struct
 size_t hash_and_copy_to_iter(const void *addr, size_t bytes, void *hashp,
 		struct iov_iter *i);
 
-ssize_t import_iovec(int type, const struct iovec __user * uvector,
-		 unsigned nr_segs, unsigned fast_segs,
-		 struct iovec **iov, struct iov_iter *i);
+struct iovec *iovec_from_user(const struct iovec __user *uvector,
+		unsigned long nr_segs, unsigned long fast_segs,
+		struct iovec *fast_iov, bool compat);
+ssize_t import_iovec(int type, const struct iovec __user *uvec,
+		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
+		 struct iov_iter *i);
+ssize_t __import_iovec(int type, const struct iovec __user *uvec,
+		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
+		 struct iov_iter *i, bool compat);
 
 #ifdef CONFIG_COMPAT
 struct compat_iovec;
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index ccea9db3f72be8..d5d8afe31fca16 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/splice.h>
+#include <linux/compat.h>
 #include <net/checksum.h>
 #include <linux/scatterlist.h>
 #include <linux/instrumented.h>
@@ -1650,107 +1651,133 @@ const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags)
 }
 EXPORT_SYMBOL(dup_iter);
 
-/**
- * rw_copy_check_uvector() - Copy an array of &struct iovec from userspace
- *     into the kernel and check that it is valid.
- *
- * @type: One of %CHECK_IOVEC_ONLY, %READ, or %WRITE.
- * @uvector: Pointer to the userspace array.
- * @nr_segs: Number of elements in userspace array.
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
- *
- * Return: The total number of bytes covered by the iovec array on success
- *   or a negative error code on error.
- */
-ssize_t rw_copy_check_uvector(int type, const struct iovec __user *uvector,
-		unsigned long nr_segs, unsigned long fast_segs,
-		struct iovec *fast_pointer, struct iovec **ret_pointer)
+static int copy_compat_iovec_from_user(struct iovec *iov,
+		const struct iovec __user *uvec, unsigned long nr_segs)
+{
+	const struct compat_iovec __user *uiov =
+		(const struct compat_iovec __user *)uvec;
+	int ret = -EFAULT, i;
+
+	if (!user_access_begin(uvec, nr_segs * sizeof(*uvec)))
+		return -EFAULT;
+
+	for (i = 0; i < nr_segs; i++) {
+		compat_uptr_t buf;
+		compat_ssize_t len;
+
+		unsafe_get_user(len, &uiov[i].iov_len, uaccess_end);
+		unsafe_get_user(buf, &uiov[i].iov_base, uaccess_end);
+
+		/* check for compat_size_t not fitting in compat_ssize_t .. */
+		if (len < 0) {
+			ret = -EINVAL;
+			goto uaccess_end;
+		}
+		iov[i].iov_base = compat_ptr(buf);
+		iov[i].iov_len = len;
+	}
+
+	ret = 0;
+uaccess_end:
+	user_access_end();
+	return ret;
+}
+		
+static int copy_iovec_from_user(struct iovec *iov,
+		const struct iovec __user *uvec, unsigned long nr_segs)
 {
 	unsigned long seg;
-	ssize_t ret;
-	struct iovec *iov = fast_pointer;
 
-	/*
-	 * SuS says "The readv() function *may* fail if the iovcnt argument
-	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
-	 * traditionally returned zero for zero segments, so...
-	 */
-	if (nr_segs == 0) {
-		ret = 0;
-		goto out;
+	if (copy_from_user(iov, uvec, nr_segs * sizeof(*uvec)))
+		return -EFAULT;
+	for (seg = 0; seg < nr_segs; seg++) {
+		if ((ssize_t)iov[seg].iov_len < 0)
+			return -EINVAL;
 	}
 
+	return 0;
+}
+
+struct iovec *iovec_from_user(const struct iovec __user *uvec,
+		unsigned long nr_segs, unsigned long fast_segs,
+		struct iovec *fast_iov, bool compat)
+{
+	struct iovec *iov = fast_iov;
+	int ret;
+
 	/*
-	 * First get the "struct iovec" from user memory and
-	 * verify all the pointers
+	 * SuS says "The readv() function *may* fail if the iovcnt argument was
+	 * less than or equal to 0, or greater than {IOV_MAX}.  Linux has
+	 * traditionally returned zero for zero segments, so...
 	 */
-	if (nr_segs > UIO_MAXIOV) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (nr_segs == 0)
+		return iov;
+	if (nr_segs > UIO_MAXIOV)
+		return ERR_PTR(-EINVAL);
 	if (nr_segs > fast_segs) {
 		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
-		if (iov == NULL) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (!iov)
+			return ERR_PTR(-ENOMEM);
 	}
-	if (copy_from_user(iov, uvector, nr_segs*sizeof(*uvector))) {
-		ret = -EFAULT;
-		goto out;
+
+	if (compat)
+		ret = copy_compat_iovec_from_user(iov, uvec, nr_segs);
+	else
+		ret = copy_iovec_from_user(iov, uvec, nr_segs);
+	if (ret) {
+		if (iov != fast_iov)
+			kfree(iov);
+		return ERR_PTR(ret);
+	}
+
+	return iov;
+}
+
+ssize_t __import_iovec(int type, const struct iovec __user *uvec,
+		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
+		 struct iov_iter *i, bool compat)
+{
+	ssize_t total_len = 0;
+	unsigned long seg;
+	struct iovec *iov;
+
+	iov = iovec_from_user(uvec, nr_segs, fast_segs, *iovp, compat);
+	if (IS_ERR(iov)) {
+		*iovp = NULL;
+		return PTR_ERR(iov);
 	}
 
 	/*
-	 * According to the Single Unix Specification we should return EINVAL
-	 * if an element length is < 0 when cast to ssize_t or if the
-	 * total length would overflow the ssize_t return value of the
-	 * system call.
+	 * According to the Single Unix Specification we should return EINVAL if
+	 * an element length is < 0 when cast to ssize_t or if the total length
+	 * would overflow the ssize_t return value of the system call.
 	 *
 	 * Linux caps all read/write calls to MAX_RW_COUNT, and avoids the
 	 * overflow case.
 	 */
-	ret = 0;
 	for (seg = 0; seg < nr_segs; seg++) {
-		void __user *buf = iov[seg].iov_base;
 		ssize_t len = (ssize_t)iov[seg].iov_len;
 
-		/* see if we we're about to use an invalid len or if
-		 * it's about to overflow ssize_t */
-		if (len < 0) {
-			ret = -EINVAL;
-			goto out;
+		if (!access_ok(iov[seg].iov_base, len)) {
+			if (iov != *iovp)
+				kfree(iov);
+			*iovp = NULL;
+			return -EFAULT;
 		}
-		if (type >= 0
-		    && unlikely(!access_ok(buf, len))) {
-			ret = -EFAULT;
-			goto out;
-		}
-		if (len > MAX_RW_COUNT - ret) {
-			len = MAX_RW_COUNT - ret;
+
+		if (len > MAX_RW_COUNT - total_len) {
+			len = MAX_RW_COUNT - total_len;
 			iov[seg].iov_len = len;
 		}
-		ret += len;
+		total_len += len;
 	}
-out:
-	*ret_pointer = iov;
-	return ret;
+
+	iov_iter_init(i, type, iov, nr_segs, total_len);
+	if (iov == *iovp)
+		*iovp = NULL;
+	else
+		*iovp = iov;
+	return total_len;
 }
 
 /**
@@ -1759,10 +1786,10 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user *uvector,
  *     &struct iov_iter iterator to access it.
  *
  * @type: One of %READ or %WRITE.
- * @uvector: Pointer to the userspace array.
+ * @uvec: Pointer to the userspace array.
  * @nr_segs: Number of elements in userspace array.
  * @fast_segs: Number of elements in @iov.
- * @iov: (input and output parameter) Pointer to pointer to (usually small
+ * @iovp: (input and output parameter) Pointer to pointer to (usually small
  *     on-stack) kernel array.
  * @i: Pointer to iterator that will be initialized on success.
  *
@@ -1775,120 +1802,21 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user *uvector,
  *
  * Return: Negative error code on error, bytes imported on success
  */
-ssize_t import_iovec(int type, const struct iovec __user * uvector,
+ssize_t import_iovec(int type, const struct iovec __user *uvec,
 		 unsigned nr_segs, unsigned fast_segs,
-		 struct iovec **iov, struct iov_iter *i)
+		 struct iovec **iovp, struct iov_iter *i)
 {
-	ssize_t n;
-	struct iovec *p;
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
+	return __import_iovec(type, uvec, nr_segs, fast_segs, iovp, i, false);
 }
 EXPORT_SYMBOL(import_iovec);
 
 #ifdef CONFIG_COMPAT
-#include <linux/compat.h>
-
-ssize_t compat_rw_copy_check_uvector(int type,
-		const struct compat_iovec __user *uvector,
-		unsigned long nr_segs, unsigned long fast_segs,
-		struct iovec *fast_pointer, struct iovec **ret_pointer)
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
-		if (type >= 0 &&
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
-
-ssize_t compat_import_iovec(int type,
-		const struct compat_iovec __user * uvector,
-		unsigned nr_segs, unsigned fast_segs,
-		struct iovec **iov, struct iov_iter *i)
+ssize_t compat_import_iovec(int type, const struct compat_iovec __user *uvec,
+		unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
+		struct iov_iter *i)
 {
-	ssize_t n;
-	struct iovec *p;
-	n = compat_rw_copy_check_uvector(type, uvector, nr_segs, fast_segs,
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
+	return __import_iovec(type, (const struct iovec __user *)uvec, nr_segs,
+			     fast_segs, iovp, i, true);
 }
 EXPORT_SYMBOL(compat_import_iovec);
 #endif
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 29c052099affdc..5e728c20c2bead 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -276,20 +276,17 @@ static ssize_t process_vm_rw(pid_t pid,
 	if (rc < 0)
 		return rc;
 	if (!iov_iter_count(&iter))
-		goto free_iovecs;
-
-	rc = rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt, UIO_FASTIOV,
-				   iovstack_r, &iov_r);
-	if (rc <= 0)
-		goto free_iovecs;
-
+		goto free_iov_l;
+	iov_r = iovec_from_user(rvec, riovcnt, UIO_FASTIOV, iovstack_r, false);
+	if (IS_ERR(iov_r)) {
+		rc = PTR_ERR(iov_r);
+		goto free_iov_l;
+	}
 	rc = process_vm_rw_core(pid, &iter, iov_r, riovcnt, flags, vm_write);
-
-free_iovecs:
 	if (iov_r != iovstack_r)
 		kfree(iov_r);
+free_iov_l:
 	kfree(iov_l);
-
 	return rc;
 }
 
@@ -333,18 +330,17 @@ compat_process_vm_rw(compat_pid_t pid,
 	if (rc < 0)
 		return rc;
 	if (!iov_iter_count(&iter))
-		goto free_iovecs;
-	rc = compat_rw_copy_check_uvector(CHECK_IOVEC_ONLY, rvec, riovcnt,
-					  UIO_FASTIOV, iovstack_r,
-					  &iov_r);
-	if (rc <= 0)
-		goto free_iovecs;
-
+		goto free_iov_l;
+	iov_r = iovec_from_user((const struct iovec __user *)rvec, riovcnt,
+				UIO_FASTIOV, iovstack_r, true);
+	if (IS_ERR(iov_r)) {
+		rc = PTR_ERR(iov_r);
+		goto free_iov_l;
+	}
 	rc = process_vm_rw_core(pid, &iter, iov_r, riovcnt, flags, vm_write);
-
-free_iovecs:
 	if (iov_r != iovstack_r)
 		kfree(iov_r);
+free_iov_l:
 	kfree(iov_l);
 	return rc;
 }
-- 
2.28.0

