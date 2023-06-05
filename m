Return-Path: <netdev+bounces-7997-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB302722639
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33C551C20AF1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBD4171C8;
	Mon,  5 Jun 2023 12:46:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E3018C20
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:46:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983B7A1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685969178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C5MeH3bkXFVlppirWEf/JAhtMhZSTtHegYn7rkL31b8=;
	b=ETwTArOeNQ7XayQo1V9l/DlqiEkgDpavRZVwFrtcAj4ERUFlcplPKBqMiMRLckADVMH3Ox
	JW1EJTqJOkW+dPaPJh5aI/HrK6uoOsC6vCFKzuSxnRshVc2VtCypeGTA6GkWxE84vkQTRs
	FN9rn8VJnHfZ5J+fL0P5CpmkoDIRuS8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-bdPEAlfdMymvJ-XIJ90puw-1; Mon, 05 Jun 2023 08:46:14 -0400
X-MC-Unique: bdPEAlfdMymvJ-XIJ90puw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFE8B85A5A8;
	Mon,  5 Jun 2023 12:46:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D2BE6400F4E;
	Mon,  5 Jun 2023 12:46:11 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 03/11] splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()
Date: Mon,  5 Jun 2023 13:45:52 +0100
Message-ID: <20230605124600.1722160-4-dhowells@redhat.com>
In-Reply-To: <20230605124600.1722160-1-dhowells@redhat.com>
References: <20230605124600.1722160-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace generic_splice_sendpage() + splice_from_pipe + pipe_to_sendpage()
with a net-specific handler, splice_to_socket(), that calls sendmsg() with
MSG_SPLICE_PAGES set instead of calling ->sendpage().

MSG_MORE is used to indicate if the sendmsg() is expected to be followed
with more data.

This allows multiple pipe-buffer pages to be passed in a single call in a
BVEC iterator, allowing the processing to be pushed down to a loop in the
protocol driver.  This helps pave the way for passing multipage folios down
too.

Protocols that haven't been converted to handle MSG_SPLICE_PAGES yet should
just ignore it and do a normal sendmsg() for now - although that may be a
bit slower as it may copy everything.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 fs/splice.c            | 158 +++++++++++++++++++++++++++++++++--------
 include/linux/fs.h     |   2 -
 include/linux/splice.h |   2 +
 net/socket.c           |  26 +------
 4 files changed, 131 insertions(+), 57 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 3e06611d19ae..9b1d43c0c562 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -33,6 +33,7 @@
 #include <linux/fsnotify.h>
 #include <linux/security.h>
 #include <linux/gfp.h>
+#include <linux/net.h>
 #include <linux/socket.h>
 #include <linux/sched/signal.h>
 
@@ -448,30 +449,6 @@ const struct pipe_buf_operations nosteal_pipe_buf_ops = {
 };
 EXPORT_SYMBOL(nosteal_pipe_buf_ops);
 
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
@@ -652,7 +629,7 @@ static void splice_from_pipe_end(struct pipe_inode_info *pipe, struct splice_des
  * Description:
  *    This function does little more than loop over the pipe and call
  *    @actor to do the actual moving of a single struct pipe_buffer to
- *    the desired destination. See pipe_to_file, pipe_to_sendpage, or
+ *    the desired destination. See pipe_to_file, pipe_to_sendmsg, or
  *    pipe_to_user.
  *
  */
@@ -833,8 +810,9 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 
 EXPORT_SYMBOL(iter_file_splice_write);
 
+#ifdef CONFIG_NET
 /**
- * generic_splice_sendpage - splice data from a pipe to a socket
+ * splice_to_socket - splice data from a pipe to a socket
  * @pipe:	pipe to splice from
  * @out:	socket to write to
  * @ppos:	position in @out
@@ -846,13 +824,131 @@ EXPORT_SYMBOL(iter_file_splice_write);
  *    is involved.
  *
  */
-ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe, struct file *out,
-				loff_t *ppos, size_t len, unsigned int flags)
+ssize_t splice_to_socket(struct pipe_inode_info *pipe, struct file *out,
+			 loff_t *ppos, size_t len, unsigned int flags)
 {
-	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_sendpage);
-}
+	struct socket *sock = sock_from_file(out);
+	struct bio_vec bvec[16];
+	struct msghdr msg = {};
+	ssize_t ret;
+	size_t spliced = 0;
+	bool need_wakeup = false;
+
+	pipe_lock(pipe);
+
+	while (len > 0) {
+		unsigned int head, tail, mask, bc = 0;
+		size_t remain = len;
+
+		/*
+		 * Check for signal early to make process killable when there
+		 * are always buffers available
+		 */
+		ret = -ERESTARTSYS;
+		if (signal_pending(current))
+			break;
+
+		while (pipe_empty(pipe->head, pipe->tail)) {
+			ret = 0;
+			if (!pipe->writers)
+				goto out;
+
+			if (spliced)
+				goto out;
+
+			ret = -EAGAIN;
+			if (flags & SPLICE_F_NONBLOCK)
+				goto out;
+
+			ret = -ERESTARTSYS;
+			if (signal_pending(current))
+				goto out;
+
+			if (need_wakeup) {
+				wakeup_pipe_writers(pipe);
+				need_wakeup = false;
+			}
+
+			pipe_wait_readable(pipe);
+		}
+
+		head = pipe->head;
+		tail = pipe->tail;
+		mask = pipe->ring_size - 1;
+
+		while (!pipe_empty(head, tail)) {
+			struct pipe_buffer *buf = &pipe->bufs[tail & mask];
+			size_t seg;
 
-EXPORT_SYMBOL(generic_splice_sendpage);
+			if (!buf->len) {
+				tail++;
+				continue;
+			}
+
+			seg = min_t(size_t, remain, buf->len);
+			seg = min_t(size_t, seg, PAGE_SIZE);
+
+			ret = pipe_buf_confirm(pipe, buf);
+			if (unlikely(ret)) {
+				if (ret == -ENODATA)
+					ret = 0;
+				break;
+			}
+
+			bvec_set_page(&bvec[bc++], buf->page, seg, buf->offset);
+			remain -= seg;
+			if (seg >= buf->len)
+				tail++;
+			if (bc >= ARRAY_SIZE(bvec))
+				break;
+		}
+
+		if (!bc)
+			break;
+
+		msg.msg_flags = MSG_SPLICE_PAGES;
+		if (flags & SPLICE_F_MORE)
+			msg.msg_flags |= MSG_MORE;
+		if (remain && pipe_occupancy(pipe->head, tail) > 0)
+			msg.msg_flags |= MSG_MORE;
+
+		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, bvec, bc,
+			      len - remain);
+		ret = sock_sendmsg(sock, &msg);
+		if (ret <= 0)
+			break;
+
+		spliced += ret;
+		len -= ret;
+		tail = pipe->tail;
+		while (ret > 0) {
+			struct pipe_buffer *buf = &pipe->bufs[tail & mask];
+			size_t seg = min_t(size_t, ret, buf->len);
+
+			buf->offset += seg;
+			buf->len -= seg;
+			ret -= seg;
+
+			if (!buf->len) {
+				pipe_buf_release(pipe, buf);
+				tail++;
+			}
+		}
+
+		if (tail != pipe->tail) {
+			pipe->tail = tail;
+			if (pipe->files)
+				need_wakeup = true;
+		}
+	}
+
+out:
+	pipe_unlock(pipe);
+	if (need_wakeup)
+		wakeup_pipe_writers(pipe);
+	return spliced ?: ret;
+}
+#endif
 
 static int warn_unsupported(struct file *file, const char *op)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 21a981680856..f8254c3acf83 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2759,8 +2759,6 @@ extern ssize_t generic_file_splice_read(struct file *, loff_t *,
 		struct pipe_inode_info *, size_t, unsigned int);
 extern ssize_t iter_file_splice_write(struct pipe_inode_info *,
 		struct file *, loff_t *, size_t, unsigned int);
-extern ssize_t generic_splice_sendpage(struct pipe_inode_info *pipe,
-		struct file *out, loff_t *, size_t len, unsigned int flags);
 extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		loff_t *opos, size_t len, unsigned int flags);
 
diff --git a/include/linux/splice.h b/include/linux/splice.h
index a55179fd60fc..991ae318b6eb 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -84,6 +84,8 @@ extern long do_splice(struct file *in, loff_t *off_in,
 
 extern long do_tee(struct file *in, struct file *out, size_t len,
 		   unsigned int flags);
+extern ssize_t splice_to_socket(struct pipe_inode_info *pipe, struct file *out,
+				loff_t *ppos, size_t len, unsigned int flags);
 
 /*
  * for dynamic pipe sizing
diff --git a/net/socket.c b/net/socket.c
index 3df96e9ba4e2..c4d9104418c8 100644
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
@@ -1066,26 +1064,6 @@ int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
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


