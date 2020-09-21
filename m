Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62439272734
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgIUOew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbgIUOek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:34:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2763DC0613D0;
        Mon, 21 Sep 2020 07:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ZJRp28PMlTdViRaEFVh58ely0fCO34dl1prBreJiUZM=; b=YNCWa3mX687pVucLxXxvPrQldG
        Z0M2GtU77O8snqhA9+YgkU1wiAgh4wbEEGyi+fz4ekuRST2iyNujOPH5AOtUK9g8jmtfKF3O2hygo
        NZxZ8kFlBzg1ouAb7F32WmKxUHj5CfofDEAHeJp3L3AqA2ffk25xEHVMP5idPlD9ysaUH5J7xQme2
        2wQ53TXN8lgBWEh2eWaUWUfMKr+UApc491vwNqZeVIPfBnXV7AnV6ecVqhPaT/PavvUNFjiMQMmvj
        BucDdsicEwoOjNhwnA9weyl5aOATSJ20woh9vdtcaLdU8VxPpOyRQEzeNxPCknxciF7txjYrNZVTW
        uPOntnHA==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMtf-0007ry-T6; Mon, 21 Sep 2020 14:34:28 +0000
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
Subject: [PATCH 07/11] fs: remove various compat readv/writev helpers
Date:   Mon, 21 Sep 2020 16:34:30 +0200
Message-Id: <20200921143434.707844-8-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143434.707844-1-hch@lst.de>
References: <20200921143434.707844-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that import_iovec handles compat iovecs as well, all the duplicated
code in the compat readv/writev helpers is not needed.  Remove them
and switch the compat syscall handlers to use the native helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c | 179 ++++++++----------------------------------------
 1 file changed, 30 insertions(+), 149 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 0a68037580b455..eab427b7cc0a3f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1068,226 +1068,107 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
 	return do_pwritev(fd, vec, vlen, pos, flags);
 }
 
+/*
+ * Various compat syscalls.  Note that they all pretend to take a native
+ * iovec - import_iovec will properly treat those as compat_iovecs based on
+ * in_compat_syscall().
+ */
 #ifdef CONFIG_COMPAT
-static size_t compat_readv(struct file *file,
-			   const struct compat_iovec __user *vec,
-			   unsigned long vlen, loff_t *pos, rwf_t flags)
-{
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
-	struct iov_iter iter;
-	ssize_t ret;
-
-	ret = import_iovec(READ, (const struct iovec __user *)vec, vlen,
-			   UIO_FASTIOV, &iov, &iter);
-	if (ret >= 0) {
-		ret = do_iter_read(file, &iter, pos, flags);
-		kfree(iov);
-	}
-	if (ret > 0)
-		add_rchar(current, ret);
-	inc_syscr(current);
-	return ret;
-}
-
-static size_t do_compat_readv(compat_ulong_t fd,
-				 const struct compat_iovec __user *vec,
-				 compat_ulong_t vlen, rwf_t flags)
-{
-	struct fd f = fdget_pos(fd);
-	ssize_t ret;
-	loff_t pos;
-
-	if (!f.file)
-		return -EBADF;
-	pos = f.file->f_pos;
-	ret = compat_readv(f.file, vec, vlen, &pos, flags);
-	if (ret >= 0)
-		f.file->f_pos = pos;
-	fdput_pos(f);
-	return ret;
-
-}
-
 COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
-		const struct compat_iovec __user *,vec,
+		const struct iovec __user *, vec,
 		compat_ulong_t, vlen)
 {
-	return do_compat_readv(fd, vec, vlen, 0);
-}
-
-static long do_compat_preadv64(unsigned long fd,
-				  const struct compat_iovec __user *vec,
-				  unsigned long vlen, loff_t pos, rwf_t flags)
-{
-	struct fd f;
-	ssize_t ret;
-
-	if (pos < 0)
-		return -EINVAL;
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
-	ret = -ESPIPE;
-	if (f.file->f_mode & FMODE_PREAD)
-		ret = compat_readv(f.file, vec, vlen, &pos, flags);
-	fdput(f);
-	return ret;
+	return do_readv(fd, vec, vlen, 0);
 }
 
 #ifdef __ARCH_WANT_COMPAT_SYS_PREADV64
 COMPAT_SYSCALL_DEFINE4(preadv64, unsigned long, fd,
-		const struct compat_iovec __user *,vec,
+		const struct iovec __user *, vec,
 		unsigned long, vlen, loff_t, pos)
 {
-	return do_compat_preadv64(fd, vec, vlen, pos, 0);
+	return do_preadv(fd, vec, vlen, pos, 0);
 }
 #endif
 
 COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
-		const struct compat_iovec __user *,vec,
+		const struct iovec __user *, vec,
 		compat_ulong_t, vlen, u32, pos_low, u32, pos_high)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 
-	return do_compat_preadv64(fd, vec, vlen, pos, 0);
+	return do_preadv(fd, vec, vlen, pos, 0);
 }
 
 #ifdef __ARCH_WANT_COMPAT_SYS_PREADV64V2
 COMPAT_SYSCALL_DEFINE5(preadv64v2, unsigned long, fd,
-		const struct compat_iovec __user *,vec,
+		const struct iovec __user *, vec,
 		unsigned long, vlen, loff_t, pos, rwf_t, flags)
 {
 	if (pos == -1)
-		return do_compat_readv(fd, vec, vlen, flags);
-
-	return do_compat_preadv64(fd, vec, vlen, pos, flags);
+		return do_readv(fd, vec, vlen, flags);
+	return do_preadv(fd, vec, vlen, pos, flags);
 }
 #endif
 
 COMPAT_SYSCALL_DEFINE6(preadv2, compat_ulong_t, fd,
-		const struct compat_iovec __user *,vec,
+		const struct iovec __user *, vec,
 		compat_ulong_t, vlen, u32, pos_low, u32, pos_high,
 		rwf_t, flags)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 
 	if (pos == -1)
-		return do_compat_readv(fd, vec, vlen, flags);
-
-	return do_compat_preadv64(fd, vec, vlen, pos, flags);
-}
-
-static size_t compat_writev(struct file *file,
-			    const struct compat_iovec __user *vec,
-			    unsigned long vlen, loff_t *pos, rwf_t flags)
-{
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
-	struct iov_iter iter;
-	ssize_t ret;
-
-	ret = import_iovec(WRITE, (const struct iovec __user *)vec, vlen,
-			   UIO_FASTIOV, &iov, &iter);
-	if (ret >= 0) {
-		file_start_write(file);
-		ret = do_iter_write(file, &iter, pos, flags);
-		file_end_write(file);
-		kfree(iov);
-	}
-	if (ret > 0)
-		add_wchar(current, ret);
-	inc_syscw(current);
-	return ret;
-}
-
-static size_t do_compat_writev(compat_ulong_t fd,
-				  const struct compat_iovec __user* vec,
-				  compat_ulong_t vlen, rwf_t flags)
-{
-	struct fd f = fdget_pos(fd);
-	ssize_t ret;
-	loff_t pos;
-
-	if (!f.file)
-		return -EBADF;
-	pos = f.file->f_pos;
-	ret = compat_writev(f.file, vec, vlen, &pos, flags);
-	if (ret >= 0)
-		f.file->f_pos = pos;
-	fdput_pos(f);
-	return ret;
+		return do_readv(fd, vec, vlen, flags);
+	return do_preadv(fd, vec, vlen, pos, flags);
 }
 
 COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
-		const struct compat_iovec __user *, vec,
+		const struct iovec __user *, vec,
 		compat_ulong_t, vlen)
 {
-	return do_compat_writev(fd, vec, vlen, 0);
-}
-
-static long do_compat_pwritev64(unsigned long fd,
-				   const struct compat_iovec __user *vec,
-				   unsigned long vlen, loff_t pos, rwf_t flags)
-{
-	struct fd f;
-	ssize_t ret;
-
-	if (pos < 0)
-		return -EINVAL;
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
-	ret = -ESPIPE;
-	if (f.file->f_mode & FMODE_PWRITE)
-		ret = compat_writev(f.file, vec, vlen, &pos, flags);
-	fdput(f);
-	return ret;
+	return do_writev(fd, vec, vlen, 0);
 }
 
 #ifdef __ARCH_WANT_COMPAT_SYS_PWRITEV64
 COMPAT_SYSCALL_DEFINE4(pwritev64, unsigned long, fd,
-		const struct compat_iovec __user *,vec,
+		const struct iovec __user *, vec,
 		unsigned long, vlen, loff_t, pos)
 {
-	return do_compat_pwritev64(fd, vec, vlen, pos, 0);
+	return do_pwritev(fd, vec, vlen, pos, 0);
 }
 #endif
 
 COMPAT_SYSCALL_DEFINE5(pwritev, compat_ulong_t, fd,
-		const struct compat_iovec __user *,vec,
+		const struct iovec __user *,vec,
 		compat_ulong_t, vlen, u32, pos_low, u32, pos_high)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 
-	return do_compat_pwritev64(fd, vec, vlen, pos, 0);
+	return do_pwritev(fd, vec, vlen, pos, 0);
 }
 
 #ifdef __ARCH_WANT_COMPAT_SYS_PWRITEV64V2
 COMPAT_SYSCALL_DEFINE5(pwritev64v2, unsigned long, fd,
-		const struct compat_iovec __user *,vec,
+		const struct iovec __user *, vec,
 		unsigned long, vlen, loff_t, pos, rwf_t, flags)
 {
 	if (pos == -1)
-		return do_compat_writev(fd, vec, vlen, flags);
-
-	return do_compat_pwritev64(fd, vec, vlen, pos, flags);
+		return do_writev(fd, vec, vlen, flags);
+	return do_pwritev(fd, vec, vlen, pos, flags);
 }
 #endif
 
 COMPAT_SYSCALL_DEFINE6(pwritev2, compat_ulong_t, fd,
-		const struct compat_iovec __user *,vec,
+		const struct iovec __user *,vec,
 		compat_ulong_t, vlen, u32, pos_low, u32, pos_high, rwf_t, flags)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 
 	if (pos == -1)
-		return do_compat_writev(fd, vec, vlen, flags);
-
-	return do_compat_pwritev64(fd, vec, vlen, pos, flags);
+		return do_writev(fd, vec, vlen, flags);
+	return do_pwritev(fd, vec, vlen, pos, flags);
 }
-
-#endif
+#endif /* CONFIG_COMPAT */
 
 static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 		  	   size_t count, loff_t max)
-- 
2.28.0

