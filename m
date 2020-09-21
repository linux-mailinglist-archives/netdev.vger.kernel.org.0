Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFE227277A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgIUOfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbgIUOeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:34:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989B5C061755;
        Mon, 21 Sep 2020 07:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Go9jhNaIOowAS6zneWVKxUnX9eeQI4Dg/fB924GqFYE=; b=Fj58CJcpE4sDehkNalXnmTWxw3
        DGiFYIP4alu/yNV8DzWwojGGHVbkvpmKEO7O+v0+KEtvpmTaC/8+AUg0vCnlW8Wpv+pAOL+TIHAXs
        Lf9zgvzv0nGbJApTt23suPBMJYvD/I52+eYKa80lYKU2kYmiupntzgNpmlacjuZmaAb/jexwc15yY
        OjMhbL124H+1M/SLeR2CIAEo+Lf9JqavRm3CepjlI3zAdY9MdM0FPRHh4OAXo3OG8B1/qJAe/+KNI
        w2LkgoRumDCz5RSjK0Fm3jjyQE6KRkOn4CicLrA3zvg0nRNU1GqT3jtXECzFud20JC5Wb2no3nlLO
        4ZZEkf/w==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMtd-0007rg-Jy; Mon, 21 Sep 2020 14:34:25 +0000
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
Subject: [PATCH 05/11] iov_iter: merge the compat case into rw_copy_check_uvector
Date:   Mon, 21 Sep 2020 16:34:28 +0200
Message-Id: <20200921143434.707844-6-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143434.707844-1-hch@lst.de>
References: <20200921143434.707844-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop duplicating the iovec verify code, and instead add add a
__import_iovec helper that does the whole verify and import, but takes
a bool compat to decided on the native or compat layout.  This also
ends up massively simplifying the calling conventions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/iov_iter.c | 195 ++++++++++++++++++-------------------------------
 1 file changed, 70 insertions(+), 125 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index a64867501a7483..8bfa47b63d39aa 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -10,6 +10,7 @@
 #include <net/checksum.h>
 #include <linux/scatterlist.h>
 #include <linux/instrumented.h>
+#include <linux/compat.h>
 
 #define PIPE_PARANOIA /* for now */
 
@@ -1650,43 +1651,76 @@ const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags)
 }
 EXPORT_SYMBOL(dup_iter);
 
-static ssize_t rw_copy_check_uvector(int type,
-		const struct iovec __user *uvector, unsigned long nr_segs,
-		unsigned long fast_segs, struct iovec *fast_pointer,
-		struct iovec **ret_pointer)
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
+static ssize_t __import_iovec(int type, const struct iovec __user *uvector,
+		unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
+		struct iov_iter *i, bool compat)
 {
+	struct iovec *iov = *iovp;
 	unsigned long seg;
-	ssize_t ret;
-	struct iovec *iov = fast_pointer;
+	ssize_t ret = 0;
 
 	/*
 	 * SuS says "The readv() function *may* fail if the iovcnt argument
 	 * was less than or equal to 0, or greater than {IOV_MAX}.  Linux has
 	 * traditionally returned zero for zero segments, so...
 	 */
-	if (nr_segs == 0) {
-		ret = 0;
-		goto out;
-	}
+	if (nr_segs == 0)
+		goto done;
 
 	/*
 	 * First get the "struct iovec" from user memory and
 	 * verify all the pointers
 	 */
-	if (nr_segs > UIO_MAXIOV) {
-		ret = -EINVAL;
-		goto out;
-	}
+	ret = -EINVAL;
+	if (nr_segs > UIO_MAXIOV)
+		goto fail;
 	if (nr_segs > fast_segs) {
+		ret = -ENOMEM;
 		iov = kmalloc_array(nr_segs, sizeof(struct iovec), GFP_KERNEL);
-		if (iov == NULL) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (!iov)
+			goto fail;
 	}
-	if (copy_from_user(iov, uvector, nr_segs*sizeof(*uvector))) {
+
+	if (compat) {
+		ret = compat_copy_iovecs_from_user(iov, uvector, nr_segs);
+		if (ret)
+			goto fail;
+	} else {
 		ret = -EFAULT;
-		goto out;
+		if (copy_from_user(iov, uvector, nr_segs * sizeof(*uvector)))
+			goto fail;
 	}
 
 	/*
@@ -1707,11 +1741,11 @@ static ssize_t rw_copy_check_uvector(int type,
 		 * it's about to overflow ssize_t */
 		if (len < 0) {
 			ret = -EINVAL;
-			goto out;
+			goto fail;
 		}
 		if (type != CHECK_IOVEC_ONLY && !access_ok(buf, len)) {
 			ret = -EFAULT;
-			goto out;
+			goto fail;
 		}
 		if (len > MAX_RW_COUNT - ret) {
 			len = MAX_RW_COUNT - ret;
@@ -1719,8 +1753,17 @@ static ssize_t rw_copy_check_uvector(int type,
 		}
 		ret += len;
 	}
-out:
-	*ret_pointer = iov;
+done:
+	iov_iter_init(i, type, iov, nr_segs, ret);
+	if (iov == *iovp)
+		*iovp = NULL;
+	else
+		*iovp = iov;
+	return ret;
+fail:
+	if (iov != *iovp)
+		kfree(iov);
+	*iovp = NULL;
 	return ret;
 }
 
@@ -1750,116 +1793,18 @@ ssize_t import_iovec(int type, const struct iovec __user * uvector,
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
-		*iov = NULL;
-		return n;
-	}
-	iov_iter_init(i, type, p, nr_segs, n);
-	*iov = p == *iov ? NULL : p;
-	return n;
+	return __import_iovec(type, uvector, nr_segs, fast_segs, iov, i, false);
 }
 EXPORT_SYMBOL(import_iovec);
 
 #ifdef CONFIG_COMPAT
-#include <linux/compat.h>
-
-static ssize_t compat_rw_copy_check_uvector(int type,
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
-
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
-		*iov = NULL;
-		return n;
-	}
-	iov_iter_init(i, type, p, nr_segs, n);
-	*iov = p == *iov ? NULL : p;
-	return n;
+	return __import_iovec(type, (const struct iovec __user *)uvector,
+			      nr_segs, fast_segs, iov, i, true);
 }
 EXPORT_SYMBOL(compat_import_iovec);
 #endif
-- 
2.28.0

