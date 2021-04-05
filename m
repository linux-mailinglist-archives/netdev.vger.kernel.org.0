Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E80F353F96
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 12:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbhDEJNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 05:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239308AbhDEJNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17E9061002;
        Mon,  5 Apr 2021 09:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613978;
        bh=1GOnMOlLeJLuqLMNX4aSagmBsEVaUzYWZuK/D6aoQTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOE3JM7vpqdVHcNd65xnuvgmOD5+voH02gQNHWX1BTjn0MeYMQ3Jtue0zdHVbGnhT
         B0K4BThHn7dIoTzbRxPASv+zmoagvESwL8XteO50jD8dwO+Bde8iQsDFSvQV8vofrS
         Tk5/PCjCm/kUD7Ukw5OWh7qHDU+nf1EUbndtrUk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 039/152] io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL
Date:   Mon,  5 Apr 2021 10:53:08 +0200
Message-Id: <20210405085035.545987518@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 26b4af9831da..2b0b9c3dda33 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4628,6 +4628,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	unsigned flags;
+	int min_ret = 0;
 	int ret;
 
 	sock = sock_from_file(req->file);
@@ -4654,6 +4655,9 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 	if (force_nonblock && ret == -EAGAIN)
 		return io_setup_async_msg(req, kmsg);
@@ -4663,7 +4667,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret < min_ret)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
 	return 0;
@@ -4677,6 +4681,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	struct iovec iov;
 	struct socket *sock;
 	unsigned flags;
+	int min_ret = 0;
 	int ret;
 
 	sock = sock_from_file(req->file);
@@ -4698,6 +4703,9 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
 	if (force_nonblock && ret == -EAGAIN)
@@ -4705,7 +4713,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (ret < 0)
+	if (ret < min_ret)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
 	return 0;
@@ -4857,6 +4865,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
+	int min_ret = 0;
 	int ret, cflags = 0;
 
 	sock = sock_from_file(req->file);
@@ -4892,6 +4901,9 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 					kmsg->uaddr, flags);
 	if (force_nonblock && ret == -EAGAIN)
@@ -4904,7 +4916,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	if (kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, cflags, cs);
 	return 0;
@@ -4920,6 +4932,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	struct socket *sock;
 	struct iovec iov;
 	unsigned flags;
+	int min_ret = 0;
 	int ret, cflags = 0;
 
 	sock = sock_from_file(req->file);
@@ -4950,6 +4963,9 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
 	ret = sock_recvmsg(sock, &msg, flags);
 	if (force_nonblock && ret == -EAGAIN)
 		return -EAGAIN;
@@ -4958,7 +4974,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
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



