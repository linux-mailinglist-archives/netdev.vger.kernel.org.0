Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58306348FA2
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCYL2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231304AbhCYL0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E533661A36;
        Thu, 25 Mar 2021 11:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671609;
        bh=0aF/PdqEgb2ANeMXTtBHFO+YHGb1fKkmuij9qI2K66k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSOATvyl5LsGsFiGkdS7TISGUVRJXEFqJkWKfzDQvFL9P+Bnka7aEB9sfck+oXuzV
         wIwkkLAjTEnjooLu8s4f42HzLPR1Ebs+8gdk28GOXNg85DsjnmkMLHzsnfU9fFKGCr
         aGWtlgKX61NXSInqD6kAQ26/RJuPV53laUrOoeg9Or4x5RGwv2NfTkCPNlRIISnabX
         ORr4m+WHYHXNtBYfkGgvGPFPdx4LsbQPocO6J6eZNEqaPy0g2fD7DB2z3qTJaXBxPY
         Slt5gw4YixF9FNbsQORxA0GimWkab3H0qHpvDfKAtM1aXRrG7pbkgzt9I9M4FiVoHF
         Xu5WMVqm2knJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 39/39] io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL
Date:   Thu, 25 Mar 2021 07:25:58 -0400
Message-Id: <20210325112558.1927423-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
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
index 38a394c6260d..f8a47cebeacd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4390,6 +4390,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	unsigned flags;
+	int min_ret = 0;
 	int ret;
 
 	sock = sock_from_file(req->file, &ret);
@@ -4416,6 +4417,9 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 	if (force_nonblock && ret == -EAGAIN)
 		return io_setup_async_msg(req, kmsg);
@@ -4425,7 +4429,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret < min_ret)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
 	return 0;
@@ -4439,6 +4443,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	struct iovec iov;
 	struct socket *sock;
 	unsigned flags;
+	int min_ret = 0;
 	int ret;
 
 	sock = sock_from_file(req->file, &ret);
@@ -4460,6 +4465,9 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
 	if (force_nonblock && ret == -EAGAIN)
@@ -4467,7 +4475,7 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (ret < 0)
+	if (ret < min_ret)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, 0, cs);
 	return 0;
@@ -4619,6 +4627,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
+	int min_ret = 0;
 	int ret, cflags = 0;
 
 	sock = sock_from_file(req->file, &ret);
@@ -4654,6 +4663,9 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 					kmsg->uaddr, flags);
 	if (force_nonblock && ret == -EAGAIN)
@@ -4666,7 +4678,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	if (kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, cflags, cs);
 	return 0;
@@ -4682,6 +4694,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	struct socket *sock;
 	struct iovec iov;
 	unsigned flags;
+	int min_ret = 0;
 	int ret, cflags = 0;
 
 	sock = sock_from_file(req->file, &ret);
@@ -4712,6 +4725,9 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
 	ret = sock_recvmsg(sock, &msg, flags);
 	if (force_nonblock && ret == -EAGAIN)
 		return -EAGAIN;
@@ -4720,7 +4736,7 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
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

