Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B390127976B
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 09:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgIZHAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 03:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIZHAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 03:00:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE03C0613CE;
        Sat, 26 Sep 2020 00:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=mdoBXcUze/cqT71aPHoAXg3dd9H5/KKyjvdFROrGqRc=; b=TW6GPMhI+/EkWCbPjwHWeE1G/o
        X1nAEdYLxAKcYIYSbbdAVNIsb9IbIMZW0sLwHfvz4OnxLd2S3ZGADHz6vK4TfQ9HmwTnYatxeUKl2
        iVS5hZWXaU5WzTKk0EEbIoxgNoUCQ8tLxo1oaNktlRTqlBGLElcT1rzIIER7y2QdRqGFyDjksvyYh
        lIewstKX5e4eW0okeKt59Ndsrt8ULVfX7rbNtYUJThBKSOjQMyoYpPRGK+CXvBj30bcchkxluaPV3
        bs40JLA4irMswidlsFS41v1vqNrdBMCO8wtSJyN1c5uS2zL0akBzywW6growufM9BH2PWrvuHj5n0
        kry6zRXg==;
Received: from [46.189.67.162] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kM4CP-0003m3-PE; Sat, 26 Sep 2020 07:00:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] fs: remove ->sendpage
Date:   Sat, 26 Sep 2020 09:00:49 +0200
Message-Id: <20200926070049.11513-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

->sendpage is only called from generic_splice_sendpage.  The only user of
generic_splice_sendpage is socket_file_ops, which is also the only
instance that actually implements ->sendpage.  Remove the ->sendpage file
operation and just open code the logic in the socket code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/splice.c        | 45 ---------------------------------------------
 include/linux/fs.h |  3 ---
 net/socket.c       | 33 ++++++++++++++++++++-------------
 3 files changed, 20 insertions(+), 61 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index d7c8a7c4db07ff..f644e293098dac 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -425,30 +425,6 @@ static ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 	return res;
 }
 
-/*
- * Send 'sd->len' bytes to socket from 'sd->file' at position 'sd->pos'
- * using sendpage(). Return the number of bytes sent.
- */
-static int pipe_to_sendpage(struct pipe_inode_info *pipe,
-			    struct pipe_buffer *buf, struct splice_desc *sd)
-{
-	struct file *file = sd->u.file;
-	loff_t pos = sd->pos;
-	int more;
-
-	if (!likely(file->f_op->sendpage))
-		return -EINVAL;
-
-	more = (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
-
-	if (sd->len < sd->total_len &&
-	    pipe_occupancy(pipe->head, pipe->tail) > 1)
-		more |= MSG_SENDPAGE_NOTLAST;
-
-	return file->f_op->sendpage(file, buf->page, buf->offset,
-				    sd->len, &pos, more);
-}
-
 static void wakeup_pipe_writers(struct pipe_inode_info *pipe)
 {
 	smp_mb();
@@ -815,27 +791,6 @@ static ssize_t default_file_splice_write(struct pipe_inode_info *pipe,
 	return ret;
 }
 
-/**
- * generic_splice_sendpage - splice data from a pipe to a socket
- * @pipe:	pipe to splice from
- * @out:	socket to write to
- * @ppos:	position in @out
- * @len:	number of bytes to splice
- * @flags:	splice modifier flags
- *
- * Description:
- *    Will send @len bytes from the pipe to a network socket. No data copying
- *    is involved.
- *
- */
-ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe, struct file *out,
-				loff_t *ppos, size_t len, unsigned int flags)
-{
-	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_sendpage);
-}
-
-EXPORT_SYMBOL(generic_splice_sendpage);
-
 /*
  * Attempt to initiate a splice from pipe to file.
  */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7519ae003a082c..1133b71417d28a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1819,7 +1819,6 @@ struct file_operations {
 	int (*fsync) (struct file *, loff_t, loff_t, int datasync);
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
-	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 	int (*check_flags)(int);
 	int (*flock) (struct file *, int, struct file_lock *);
@@ -3045,8 +3044,6 @@ extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t iter_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
-extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
-		struct file *out, loff_t *, size_t len, unsigned int flags);
 extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		loff_t *opos, size_t len, unsigned int flags);
 
diff --git a/net/socket.c b/net/socket.c
index 0c0144604f818a..dd93bbd61c22d3 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -123,8 +123,8 @@ static long compat_sock_ioctl(struct file *file,
 			      unsigned int cmd, unsigned long arg);
 #endif
 static int sock_fasync(int fd, struct file *filp, int on);
-static ssize_t sock_sendpage(struct file *file, struct page *page,
-			     int offset, size_t size, loff_t *ppos, int more);
+static ssize_t sock_splice_write(struct pipe_inode_info *pipe,
+		struct file *out, loff_t *ppos, size_t len, unsigned int flags);
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 				struct pipe_inode_info *pipe, size_t len,
 				unsigned int flags);
@@ -159,8 +159,7 @@ static const struct file_operations socket_file_ops = {
 	.mmap =		sock_mmap,
 	.release =	sock_close,
 	.fasync =	sock_fasync,
-	.sendpage =	sock_sendpage,
-	.splice_write = generic_splice_sendpage,
+	.splice_write = sock_splice_write,
 	.splice_read =	sock_splice_read,
 	.show_fdinfo =	sock_show_fdinfo,
 };
@@ -929,19 +928,27 @@ int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
 }
 EXPORT_SYMBOL(kernel_recvmsg);
 
-static ssize_t sock_sendpage(struct file *file, struct page *page,
-			     int offset, size_t size, loff_t *ppos, int more)
+static int pipe_to_sendpage(struct pipe_inode_info *pipe,
+			    struct pipe_buffer *buf, struct splice_desc *sd)
 {
-	struct socket *sock;
-	int flags;
+	struct socket *sock = sd->u.file->private_data;
+	int flags = 0;
 
-	sock = file->private_data;
+	if (sd->u.file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+	if (sd->flags & SPLICE_F_MORE)
+		flags |= MSG_MORE;
+	if (sd->len < sd->total_len &&
+	    pipe_occupancy(pipe->head, pipe->tail) > 1)
+		flags |= MSG_SENDPAGE_NOTLAST;
 
-	flags = (file->f_flags & O_NONBLOCK) ? MSG_DONTWAIT : 0;
-	/* more is a combination of MSG_MORE and MSG_SENDPAGE_NOTLAST */
-	flags |= more;
+	return kernel_sendpage(sock, buf->page, buf->offset, sd->len, flags);
+}
 
-	return kernel_sendpage(sock, page, offset, size, flags);
+static ssize_t sock_splice_write(struct pipe_inode_info *pipe,
+		struct file *out, loff_t *ppos, size_t len, unsigned int flags)
+{
+	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_sendpage);
 }
 
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
-- 
2.28.0

