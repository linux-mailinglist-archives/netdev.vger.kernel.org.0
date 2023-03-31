Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44C86D2564
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbjCaQYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbjCaQYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:24:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6CB1BF51
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rdhhmJu37H1diE1YTKpbylxaJjF+u38cNy50QUFNMbM=;
        b=R+XjlURwiyacYPgFtTR0gSt6gDFGcRFSmkhWVZPD1r1imZ6cOESGJNATh2vOhQr8tOjSsv
        I5ItimGsjqDpNB8pTUi2yJ5CdtO7fh34CiNpVAWhuSGuTKlT1z5LKwiezeDAy2B22BWdnL
        vqAGhqhKVhl6+oy9e1gJyNSnvi7eEdo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-HXcdn5EjOZiGCXUameYioQ-1; Fri, 31 Mar 2023 12:11:02 -0400
X-MC-Unique: HXcdn5EjOZiGCXUameYioQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C329F3802AC3;
        Fri, 31 Mar 2023 16:10:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF6F714171B6;
        Fri, 31 Mar 2023 16:10:55 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v3 35/55] splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()
Date:   Fri, 31 Mar 2023 17:08:54 +0100
Message-Id: <20230331160914.1608208-36-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage() to splice data from
a pipe to a socket.  This paves the way for passing in multiple pages at
once from a pipe and the handling of multipage folios.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 fs/splice.c            | 42 +++++++++++++++++++++++-------------------
 include/linux/fs.h     |  2 --
 include/linux/splice.h |  2 ++
 net/socket.c           | 26 ++------------------------
 4 files changed, 27 insertions(+), 45 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index f46dd1fb367b..23ead122d631 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -32,6 +32,7 @@
 #include <linux/uio.h>
 #include <linux/security.h>
 #include <linux/gfp.h>
+#include <linux/net.h>
 #include <linux/socket.h>
 #include <linux/sched/signal.h>
 
@@ -410,29 +411,32 @@ const struct pipe_buf_operations nosteal_pipe_buf_ops = {
 };
 EXPORT_SYMBOL(nosteal_pipe_buf_ops);
 
+#ifdef CONFIG_NET
 /*
  * Send 'sd->len' bytes to socket from 'sd->file' at position 'sd->pos'
  * using sendpage(). Return the number of bytes sent.
  */
-static int pipe_to_sendpage(struct pipe_inode_info *pipe,
-			    struct pipe_buffer *buf, struct splice_desc *sd)
+static int pipe_to_sendmsg(struct pipe_inode_info *pipe,
+			   struct pipe_buffer *buf, struct splice_desc *sd)
 {
-	struct file *file = sd->u.file;
-	loff_t pos = sd->pos;
-	int more;
-
-	if (!likely(file->f_op->sendpage))
-		return -EINVAL;
+	struct socket *sock = sock_from_file(sd->u.file);
+	struct bio_vec bvec;
+	struct msghdr msg = {
+		.msg_flags = MSG_SPLICE_PAGES,
+	};
 
-	more = (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
+	if (sd->flags & SPLICE_F_MORE)
+		msg.msg_flags |= MSG_MORE;
 
 	if (sd->len < sd->total_len &&
 	    pipe_occupancy(pipe->head, pipe->tail) > 1)
-		more |= MSG_SENDPAGE_NOTLAST;
+		msg.msg_flags |= MSG_MORE;
 
-	return file->f_op->sendpage(file, buf->page, buf->offset,
-				    sd->len, &pos, more);
+	bvec_set_page(&bvec, buf->page, sd->len, buf->offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, sd->len);
+	return sock_sendmsg(sock, &msg);
 }
+#endif
 
 static void wakeup_pipe_writers(struct pipe_inode_info *pipe)
 {
@@ -614,7 +618,7 @@ static void splice_from_pipe_end(struct pipe_inode_info *pipe, struct splice_des
  * Description:
  *    This function does little more than loop over the pipe and call
  *    @actor to do the actual moving of a single struct pipe_buffer to
- *    the desired destination. See pipe_to_file, pipe_to_sendpage, or
+ *    the desired destination. See pipe_to_file, pipe_to_sendmsg, or
  *    pipe_to_user.
  *
  */
@@ -795,8 +799,9 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 
 EXPORT_SYMBOL(iter_file_splice_write);
 
+#ifdef CONFIG_NET
 /**
- * generic_splice_sendpage - splice data from a pipe to a socket
+ * splice_to_socket - splice data from a pipe to a socket
  * @pipe:	pipe to splice from
  * @out:	socket to write to
  * @ppos:	position in @out
@@ -808,13 +813,12 @@ EXPORT_SYMBOL(iter_file_splice_write);
  *    is involved.
  *
  */
-ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe, struct file *out,
-				loff_t *ppos, size_t len, unsigned int flags)
+ssize_t splice_to_socket(struct pipe_inode_info *pipe, struct file *out,
+			 loff_t *ppos, size_t len, unsigned int flags)
 {
-	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_sendpage);
+	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_sendmsg);
 }
-
-EXPORT_SYMBOL(generic_splice_sendpage);
+#endif
 
 static int warn_unsupported(struct file *file, const char *op)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c85916e9f7db..f3ccc243851e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2740,8 +2740,6 @@ extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t iter_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
-extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
-		struct file *out, loff_t *, size_t len, unsigned int flags);
 extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		loff_t *opos, size_t len, unsigned int flags);
 
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 8f052c3dae95..e6153feda86c 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -87,6 +87,8 @@ extern long do_splice(struct file *in, loff_t *off_in,
 
 extern long do_tee(struct file *in, struct file *out, size_t len,
 		   unsigned int flags);
+extern ssize_t splice_to_socket(struct pipe_inode_info *pipe, struct file *out,
+				loff_t *ppos, size_t len, unsigned int flags);
 
 /*
  * for dynamic pipe sizing
diff --git a/net/socket.c b/net/socket.c
index 0c39ce57d603..3e9bd8261357 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -57,6 +57,7 @@
 #include <linux/mm.h>
 #include <linux/socket.h>
 #include <linux/file.h>
+#include <linux/splice.h>
 #include <linux/net.h>
 #include <linux/interrupt.h>
 #include <linux/thread_info.h>
@@ -126,8 +127,6 @@ static long compat_sock_ioctl(struct file *file,
 			      unsigned int cmd, unsigned long arg);
 #endif
 static int sock_fasync(int fd, struct file *filp, int on);
-static ssize_t sock_sendpage(struct file *file, struct page *page,
-			     int offset, size_t size, loff_t *ppos, int more);
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 				struct pipe_inode_info *pipe, size_t len,
 				unsigned int flags);
@@ -162,8 +161,7 @@ static const struct file_operations socket_file_ops = {
 	.mmap =		sock_mmap,
 	.release =	sock_close,
 	.fasync =	sock_fasync,
-	.sendpage =	sock_sendpage,
-	.splice_write = generic_splice_sendpage,
+	.splice_write = splice_to_socket,
 	.splice_read =	sock_splice_read,
 	.show_fdinfo =	sock_show_fdinfo,
 };
@@ -1062,26 +1060,6 @@ int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
 }
 EXPORT_SYMBOL(kernel_recvmsg);
 
-static ssize_t sock_sendpage(struct file *file, struct page *page,
-			     int offset, size_t size, loff_t *ppos, int more)
-{
-	struct socket *sock;
-	int flags;
-	int ret;
-
-	sock = file->private_data;
-
-	flags = (file->f_flags & O_NONBLOCK) ? MSG_DONTWAIT : 0;
-	/* more is a combination of MSG_MORE and MSG_SENDPAGE_NOTLAST */
-	flags |= more;
-
-	ret = kernel_sendpage(sock, page, offset, size, flags);
-
-	if (trace_sock_send_length_enabled())
-		call_trace_sock_send_length(sock->sk, ret, 0);
-	return ret;
-}
-
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 				struct pipe_inode_info *pipe, size_t len,
 				unsigned int flags)

