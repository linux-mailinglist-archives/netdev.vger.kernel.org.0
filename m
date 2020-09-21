Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0FC2727A9
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgIUOgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgIUOef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:34:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFE2C0613CF;
        Mon, 21 Sep 2020 07:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=LCXn2FJbni+/tCTK8D6nVLYSdWCMV5d/zHCD2VrYDAs=; b=mbONURe77St7uQ3PnKdyMO8YWN
        lHHxh8Rej95j3EcLKqhP+y4tGyd99cd/ffdxqZV8yebCrwLM4eoxys1lPtV4nVdcd41zESCOCPd2p
        95UzbhUrv2C0Zdd6/UauA1rhV5yGsydVTGeKguxbWl7TGmSbLoMHa4oxCvrISI4jXTzJPl9t/ozf0
        3zgYR6Q2PTzlKw8BHxuK6Qw05qaz8+AyJOCrLu1xBMHb4joZOGQAT0ZIWIWSX26qT2lyaclnBdPz4
        K58eZEN+KtEyvxIyL1cW01OE8EcmQ61Ns90iHf2WcQeGgqx1xswzI6xvrLYFrpcdHJHk8/G7gWXzW
        SBn8XVIg==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMta-0007rG-G7; Mon, 21 Sep 2020 14:34:23 +0000
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
        linux-security-module@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>,
        David Laight <david.laight@aculab.com>
Subject: [PATCH 03/11] iov_iter: move rw_copy_check_uvector() into lib/iov_iter.c and mark it static
Date:   Mon, 21 Sep 2020 16:34:26 +0200
Message-Id: <20200921143434.707844-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143434.707844-1-hch@lst.de>
References: <20200921143434.707844-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>

This lets the compiler inline it into import_iovec() generating
much better code.

Signed-off-by: David Laight <david.laight@aculab.com>
[hch: drop the now pointless kerneldoc for a static function, and update
      a few other comments]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c        | 179 -----------------------------------------
 include/linux/compat.h |   6 --
 include/linux/fs.h     |  11 +--
 lib/iov_iter.c         | 150 +++++++++++++++++++++++++++++++++-
 4 files changed, 151 insertions(+), 195 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 5db58b8c78d0dd..e5e891a88442ef 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -752,185 +752,6 @@ static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
 	return ret;
 }
 
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
-ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
-			      unsigned long nr_segs, unsigned long fast_segs,
-			      struct iovec *fast_pointer,
-			      struct iovec **ret_pointer)
-{
-	unsigned long seg;
-	ssize_t ret;
-	struct iovec *iov = fast_pointer;
-
-	/*
-	 * SuS says "The readv() function *may* fail if the iovcnt argument
-	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
-	 * traditionally returned zero for zero segments, so...
-	 */
-	if (nr_segs == 0) {
-		ret = 0;
-		goto out;
-	}
-
-	/*
-	 * First get the "struct iovec" from user memory and
-	 * verify all the pointers
-	 */
-	if (nr_segs > UIO_MAXIOV) {
-		ret = -EINVAL;
-		goto out;
-	}
-	if (nr_segs > fast_segs) {
-		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
-		if (iov == NULL) {
-			ret = -ENOMEM;
-			goto out;
-		}
-	}
-	if (copy_from_user(iov, uvector, nr_segs*sizeof(*uvector))) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	/*
-	 * According to the Single Unix Specification we should return EINVAL
-	 * if an element length is < 0 when cast to ssize_t or if the
-	 * total length would overflow the ssize_t return value of the
-	 * system call.
-	 *
-	 * Linux caps all read/write calls to MAX_RW_COUNT, and avoids the
-	 * overflow case.
-	 */
-	ret = 0;
-	for (seg = 0; seg < nr_segs; seg++) {
-		void __user *buf = iov[seg].iov_base;
-		ssize_t len = (ssize_t)iov[seg].iov_len;
-
-		/* see if we we're about to use an invalid len or if
-		 * it's about to overflow ssize_t */
-		if (len < 0) {
-			ret = -EINVAL;
-			goto out;
-		}
-		if (type >= 0
-		    && unlikely(!access_ok(buf, len))) {
-			ret = -EFAULT;
-			goto out;
-		}
-		if (len > MAX_RW_COUNT - ret) {
-			len = MAX_RW_COUNT - ret;
-			iov[seg].iov_len = len;
-		}
-		ret += len;
-	}
-out:
-	*ret_pointer = iov;
-	return ret;
-}
-
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
-#endif
-
 static ssize_t do_iter_read(struct file *file, struct iov_iter *iter,
 		loff_t *pos, rwf_t flags)
 {
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
index 7519ae003a082c..5420822104a99d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -179,10 +179,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
 
 /*
- * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
- * that indicates that they should check the contents of the iovec are
- * valid, but not check the memory that the iovec elements
- * points too.
+ * Flag for import_iovec that indicates that it should check the contents of the
+ * iovec is valid, but not check the memory that the iovec elements points too.
  */
 #define CHECK_IOVEC_ONLY -1
 
@@ -1887,11 +1885,6 @@ static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
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
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index db54588406dfae..d7e72343c360eb 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1650,12 +1650,87 @@ const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags)
 }
 EXPORT_SYMBOL(dup_iter);
 
+static ssize_t rw_copy_check_uvector(int type,
+		const struct iovec __user *uvector, unsigned long nr_segs,
+		unsigned long fast_segs, struct iovec *fast_pointer,
+		struct iovec **ret_pointer)
+{
+	unsigned long seg;
+	ssize_t ret;
+	struct iovec *iov = fast_pointer;
+
+	/*
+	 * SuS says "The readv() function *may* fail if the iovcnt argument
+	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
+	 * traditionally returned zero for zero segments, so...
+	 */
+	if (nr_segs == 0) {
+		ret = 0;
+		goto out;
+	}
+
+	/*
+	 * First get the "struct iovec" from user memory and
+	 * verify all the pointers
+	 */
+	if (nr_segs > UIO_MAXIOV) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (nr_segs > fast_segs) {
+		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
+		if (iov == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+	if (copy_from_user(iov, uvector, nr_segs*sizeof(*uvector))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/*
+	 * According to the Single Unix Specification we should return EINVAL
+	 * if an element length is < 0 when cast to ssize_t or if the
+	 * total length would overflow the ssize_t return value of the
+	 * system call.
+	 *
+	 * Linux caps all read/write calls to MAX_RW_COUNT, and avoids the
+	 * overflow case.
+	 */
+	ret = 0;
+	for (seg = 0; seg < nr_segs; seg++) {
+		void __user *buf = iov[seg].iov_base;
+		ssize_t len = (ssize_t)iov[seg].iov_len;
+
+		/* see if we we're about to use an invalid len or if
+		 * it's about to overflow ssize_t */
+		if (len < 0) {
+			ret = -EINVAL;
+			goto out;
+		}
+		if (type >= 0
+		    && unlikely(!access_ok(buf, len))) {
+			ret = -EFAULT;
+			goto out;
+		}
+		if (len > MAX_RW_COUNT - ret) {
+			len = MAX_RW_COUNT - ret;
+			iov[seg].iov_len = len;
+		}
+		ret += len;
+	}
+out:
+	*ret_pointer = iov;
+	return ret;
+}
+
 /**
  * import_iovec() - Copy an array of &struct iovec from userspace
  *     into the kernel, check that it is valid, and initialize a new
  *     &struct iov_iter iterator to access it.
  *
- * @type: One of %READ or %WRITE.
+ * @type: One of %CHECK_IOVEC_ONLY, %READ, or %WRITE.
  * @uvector: Pointer to the userspace array.
  * @nr_segs: Number of elements in userspace array.
  * @fast_segs: Number of elements in @iov.
@@ -1695,6 +1770,79 @@ EXPORT_SYMBOL(import_iovec);
 #ifdef CONFIG_COMPAT
 #include <linux/compat.h>
 
+static ssize_t compat_rw_copy_check_uvector(int type,
+		const struct compat_iovec __user *uvector, unsigned long nr_segs,
+		unsigned long fast_segs, struct iovec *fast_pointer,
+		struct iovec **ret_pointer)
+{
+	compat_ssize_t tot_len;
+	struct iovec *iov = *ret_pointer = fast_pointer;
+	ssize_t ret = 0;
+	int seg;
+
+	/*
+	 * SuS says "The readv() function *may* fail if the iovcnt argument
+	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
+	 * traditionally returned zero for zero segments, so...
+	 */
+	if (nr_segs == 0)
+		goto out;
+
+	ret = -EINVAL;
+	if (nr_segs > UIO_MAXIOV)
+		goto out;
+	if (nr_segs > fast_segs) {
+		ret = -ENOMEM;
+		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
+		if (iov == NULL)
+			goto out;
+	}
+	*ret_pointer = iov;
+
+	ret = -EFAULT;
+	if (!access_ok(uvector, nr_segs*sizeof(*uvector)))
+		goto out;
+
+	/*
+	 * Single unix specification:
+	 * We should -EINVAL if an element length is not >= 0 and fitting an
+	 * ssize_t.
+	 *
+	 * In Linux, the total length is limited to MAX_RW_COUNT, there is
+	 * no overflow possibility.
+	 */
+	tot_len = 0;
+	ret = -EINVAL;
+	for (seg = 0; seg < nr_segs; seg++) {
+		compat_uptr_t buf;
+		compat_ssize_t len;
+
+		if (__get_user(len, &uvector->iov_len) ||
+		   __get_user(buf, &uvector->iov_base)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		if (len < 0)	/* size_t not fitting in compat_ssize_t .. */
+			goto out;
+		if (type >= 0 &&
+		    !access_ok(compat_ptr(buf), len)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		if (len > MAX_RW_COUNT - tot_len)
+			len = MAX_RW_COUNT - tot_len;
+		tot_len += len;
+		iov->iov_base = compat_ptr(buf);
+		iov->iov_len = (compat_size_t) len;
+		uvector++;
+		iov++;
+	}
+	ret = tot_len;
+
+out:
+	return ret;
+}
+
 ssize_t compat_import_iovec(int type,
 		const struct compat_iovec __user * uvector,
 		unsigned nr_segs, unsigned fast_segs,
-- 
2.28.0

