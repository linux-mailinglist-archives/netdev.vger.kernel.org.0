Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F3B342F48
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 20:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhCTTea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 15:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTTeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 15:34:04 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026ECC061574;
        Sat, 20 Mar 2021 12:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=rMGUY++m322+w5Ub86qe3mkvPr0CfrAZ5ssaHcPRAo4=; b=cff3O8Snb9KjXbxFsgZBIQGzIX
        SqbWqL5x7SWEs7/q/DLckeaEilDzxjS+gP1Tau8AJu4eHSIPATheJcPFRRJUXXjjCjmWkpGMO4+zC
        1yt6O8cSjXNk1VRqRpdtgZ0mXM257zdcGL+l7kJDYDE/yHw0oQ+12rR9M9F2+ze1yNkYWjATCUhhz
        OWGhIw6atYEr1YmeXuSO5GJ/+fSFFicX08eiCXjmXAOXCynL89jSkHmSG9h8Zi9oLvzuSY0J845hr
        3ZIaxE0AliMYGMbdlTlNfrfpSs5v4J4/3gM76uUtE79ntlK2mOjvFkGamcamwfSMXKjUSBmvJ3OyU
        ufkYK9q6DwzQux5uzASMQnoUOt0EVtJiXIno4aTtkDtPc+Jj6dfcC/BPgl167tmlecl1q18Iaj3Sz
        KMUu4sB1lkvzg21/VajcF9JW20G+dmOwQXdYK4rC7CgINQPphIiiEZ69/2sVGapf1o4nKyuPiZAU6
        2QCHfWlpqqu0R+f5P0cil+1L;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lNhMH-0005vY-Vg; Sat, 20 Mar 2021 19:34:02 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, netdev@vger.kernel.org
Subject: [PATCH v2 1/1] io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL
Date:   Sat, 20 Mar 2021 20:33:36 +0100
Message-Id: <12efc18b6bef3955500080a238197e90ca6a402c.1616268538.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <c4e1a4cc0d905314f4d5dc567e65a7b09621aab3.1615908477.git.metze@samba.org>
References: <c4e1a4cc0d905314f4d5dc567e65a7b09621aab3.1615908477.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 fs/io_uring.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 75b791ff21ec..746435e3f534 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4386,6 +4386,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	unsigned flags;
+	int min_ret = 0;
 	int ret;
 
 	sock = sock_from_file(req->file);
@@ -4406,6 +4407,9 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
 		return io_setup_async_msg(req, kmsg);
@@ -4416,7 +4420,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret < min_ret)
 		req_set_fail_links(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
@@ -4429,6 +4433,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	struct iovec iov;
 	struct socket *sock;
 	unsigned flags;
+	int min_ret = 0;
 	int ret;
 
 	sock = sock_from_file(req->file);
@@ -4450,6 +4455,9 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	else if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
 	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
@@ -4457,7 +4465,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (ret < 0)
+	if (ret < min_ret)
 		req_set_fail_links(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
@@ -4609,6 +4617,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
+	int min_ret = 0;
 	int ret, cflags = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
@@ -4640,6 +4649,9 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 					kmsg->uaddr, flags);
 	if (force_nonblock && ret == -EAGAIN)
@@ -4653,7 +4665,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
+	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
 		req_set_fail_links(req);
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
@@ -4668,6 +4680,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	struct socket *sock;
 	struct iovec iov;
 	unsigned flags;
+	int min_ret = 0;
 	int ret, cflags = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
@@ -4699,6 +4712,9 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	else if (force_nonblock)
 		flags |= MSG_DONTWAIT;
 
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
 	ret = sock_recvmsg(sock, &msg, flags);
 	if (force_nonblock && ret == -EAGAIN)
 		return -EAGAIN;
@@ -4707,7 +4723,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 out_free:
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
-	if (ret < 0)
+	if (ret < min_ret || ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
 		req_set_fail_links(req);
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
-- 
2.25.1

