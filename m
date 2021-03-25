Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEF3348F31
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhCYL0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhCYLZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F4861A37;
        Thu, 25 Mar 2021 11:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671556;
        bh=9N4CGskcVvF5rLhMoXkVHr7IDC6bh+2c7ymRONRjiMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czXjRFGzlThfs9yamozvS6DGuKc9JJj6TtrtXJ1PSH6qNg4sSlS1v8HwA3aTth3SF
         fMUsqHZR8Qgh6Ei6ClYbxlrXJN1k7yQaPE7ZIdMtz0FWB9RGi56E5HABGpThAQtJmL
         /B6VEKS2cgMLbcOkVSR4JgwGKjCR7pqwxloHaaVpPrE2lmMgqFVvtP3deypg+FJp5E
         HZfvHLTpbTCck8yAf3TZl9qU15TCaCRRmVx3D9e9wf9wh1ugWg/5FWtPdCx+pFtd2K
         2WPAL6oCuAZK5ZYt8O2CqJ1VV9I6rgSpBxf0zz2lINOiaRylIItIqb12aTMWe2llz0
         k0r0wNeg6K12Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 44/44] io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL
Date:   Thu, 25 Mar 2021 07:24:59 -0400
Message-Id: <20210325112459.1926846-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 0031275d119efe16711cd93519b595e6f9b4b330 ]

Without that it's not safe to use them in a linked combination with
others.

Now combinations like IORING_OP_SENDMSG followed by IORING_OP_SPLICE
should be possible.

We already handle short reads and writes for the following opcodes:

- IORING_OP_READV
- IORING_OP_READ_FIXED
- IORING_OP_READ
- IORING_OP_WRITEV
- IORING_OP_WRITE_FIXED
- IORING_OP_WRITE
- IORING_OP_SPLICE
- IORING_OP_TEE

Now we have it for these as well:

- IORING_OP_SENDMSG
- IORING_OP_SEND
- IORING_OP_RECVMSG
- IORING_OP_RECV

For IORING_OP_RECVMSG we also check for the MSG_TRUNC and MSG_CTRUNC
flags in order to call req_set_fail_links().

There might be applications arround depending on the behavior
that even short send[msg]()/recv[msg]() retuns continue an
IOSQE_IO_LINK chain.

It's very unlikely that such applications pass in MSG_WAITALL,
which is only defined in 'man 2 recvmsg', but not in 'man 2 sendmsg'.

It's expected that the low level sock_sendmsg() call just ignores
MSG_WAITALL, as MSG_ZEROCOPY is also ignored without explicitly set
SO_ZEROCOPY.

We also expect the caller to know about the implicit truncation to
MAX_RW_COUNT, which we don't detect.

cc: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/c4e1a4cc0d905314f4d5dc567e65a7b09621aab3.1615908477.git.metze@samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4ac24e75ae63..c06237c87527 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4625,6 +4625,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	unsigned flags;
+	int min_ret = 0;
 	int ret;
 
 	sock = sock_from_file(req->file);
@@ -4651,6 +4652,9 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 	if (force_nonblock && ret == -EAGAIN)
 		return io_setup_async_msg(req, kmsg);
@@ -4660,7 +4664,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret < min_ret)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
 	return 0;
@@ -4674,6 +4678,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	struct iovec iov;
 	struct socket *sock;
 	unsigned flags;
+	int min_ret = 0;
 	int ret;
 
 	sock = sock_from_file(req->file);
@@ -4695,6 +4700,9 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
 	if (force_nonblock && ret == -EAGAIN)
@@ -4702,7 +4710,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (ret < 0)
+	if (ret < min_ret)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
 	return 0;
@@ -4854,6 +4862,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
+	int min_ret = 0;
 	int ret, cflags = 0;
 
 	sock = sock_from_file(req->file);
@@ -4889,6 +4898,9 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 					kmsg->uaddr, flags);
 	if (force_nonblock && ret == -EAGAIN)
@@ -4901,7 +4913,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	if (kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, cflags, cs);
 	return 0;
@@ -4917,6 +4929,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	struct socket *sock;
 	struct iovec iov;
 	unsigned flags;
+	int min_ret = 0;
 	int ret, cflags = 0;
 
 	sock = sock_from_file(req->file);
@@ -4947,6 +4960,9 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
 	ret = sock_recvmsg(sock, &msg, flags);
 	if (force_nonblock && ret == -EAGAIN)
 		return -EAGAIN;
@@ -4955,7 +4971,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 out_free:
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
-	if (ret < 0)
+	if (ret < min_ret || ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, cflags, cs);
 	return 0;
-- 
2.30.1

