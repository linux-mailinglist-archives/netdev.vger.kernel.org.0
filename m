Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D094A2FA5
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 14:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350504AbiA2NDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 08:03:40 -0500
Received: from ip59.38.31.103.in-addr.arpa.unknwn.cloudhost.asia ([103.31.38.59]:49230
        "EHLO gnuweeb.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1345721AbiA2NDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 08:03:33 -0500
Received: from integral2.. (unknown [36.81.38.25])
        by gnuweeb.org (Postfix) with ESMTPSA id 3F340C32C8;
        Sat, 29 Jan 2022 13:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1643461402;
        bh=lLuXbaCaWQYUNdk+Oqic6Z0r79tsKycp/zlNABrRk3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LE/qSBUKDvG5mDZ/yrULH+LR2bI2y5LvolkELJTS2hUhosd+mOsXXkPg+mHOs4v0y
         ATvr1oF6COfa9dM0n1omXePfPNkeFxHL9uvLV9Uf/cT0zIuV9pkaM5leDkslg7cm0I
         9DvcX3shBXy0YLtMbpWxS9oJ/DBSrUBKm7bukbDuxCKGe8Weuye8umUABVEPetJ8HZ
         z1du6CWa954PNCgoIT9IN1ayuyNfrL8eiO73cMPJBIhXZWEIgPGj/P+1BpypJcuHHX
         R4hEbTP0TxYE64lnEssgpK/Rl19MiQEFfbn40lX+a06E/lUReZ2f6WWfsDhhYl5S8I
         2x6r9T0jSjlaQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Nugra <richiisei@gmail.com>,
        Praveen Kumar <kpraveen.lkml@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [PATCH for-5.18 v1 3/3] io_uring: Add `sendto(2)` and `recvfrom(2)` support
Date:   Sat, 29 Jan 2022 19:50:21 +0700
Message-Id: <20220129125021.15223-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220129125021.15223-1-ammarfaizi2@gnuweeb.org>
References: <20220129125021.15223-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds sendto(2) and recvfrom(2) support for io_uring.

New opcodes:
  IORING_OP_SENDTO
  IORING_OP_RECVFROM

Cc: Nugra <richiisei@gmail.com>
Cc: Praveen Kumar <kpraveen.lkml@gmail.com>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Link: https://github.com/axboe/liburing/issues/397
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
v1:
  - Add BUILD_BUG_SQE_ELEM(48, __u64,  addr3); for compile time
    assertion.
  - Add Alviro Iskandar Setiawan to CC list (tester).

RFC v4:
  - Rebase the work (sync with "for-next" branch in Jens' tree).
  - Remove Tested-by tag from Nugra as this patch changes.
  - (Address Praveen's comment) Zero `sendto_addr_len` and
    `recvfrom_addr_len` on prep when the `req->opcode` is not
    `IORING_OP_{SENDTO,RECVFROM}`.

RFC v3:
  - Fix build error when CONFIG_NET is undefined should be done in
    the first patch, not this patch.
  - Add Tested-by tag from Nugra.

RFC v2:
  - In `io_recvfrom()`, mark the error check of `move_addr_to_user()`
    call as unlikely.
  - Fix build error when CONFIG_NET is undefined.
  - Added Nugra to CC list (tester).
---
---
 fs/io_uring.c                 | 83 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  5 ++-
 2 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 742e252a052a..0c322e89de84 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -574,7 +574,15 @@ struct io_sr_msg {
 	union {
 		struct compat_msghdr __user	*umsg_compat;
 		struct user_msghdr __user	*umsg;
-		void __user			*buf;
+
+		struct {
+			void __user		*buf;
+			struct sockaddr __user	*addr;
+			union {
+				int		sendto_addr_len;
+				int __user	*recvfrom_addr_len;
+			};
+		};
 	};
 	int				msg_flags;
 	int				bgid;
@@ -1105,6 +1113,19 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_SENDTO] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.audit_skip		= 1,
+	},
+	[IORING_OP_RECVFROM] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.buffer_select		= 1,
+		.audit_skip		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -4904,12 +4925,25 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
+	/*
+	 * For IORING_OP_SEND{,TO}, the assignment to @sr->umsg
+	 * is equivalent to an assignment to @sr->buf.
+	 */
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+
 	sr->len = READ_ONCE(sqe->len);
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
+	if (req->opcode == IORING_OP_SENDTO) {
+		sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		sr->sendto_addr_len = READ_ONCE(sqe->addr3);
+	} else {
+		sr->addr = (struct sockaddr __user *) NULL;
+		sr->sendto_addr_len = 0;
+	}
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
@@ -4963,6 +4997,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct sockaddr_storage address;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
 	struct iovec iov;
@@ -4979,10 +5014,20 @@ static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	msg.msg_name = NULL;
+
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
-	msg.msg_namelen = 0;
+	if (sr->addr) {
+		ret = move_addr_to_kernel(sr->addr, sr->sendto_addr_len,
+					  &address);
+		if (unlikely(ret < 0))
+			goto fail;
+		msg.msg_name = (struct sockaddr *) &address;
+		msg.msg_namelen = sr->sendto_addr_len;
+	} else {
+		msg.msg_name = NULL;
+		msg.msg_namelen = 0;
+	}
 
 	flags = req->sr_msg.msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -4997,6 +5042,7 @@ static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+fail:
 		req_set_fail(req);
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
@@ -5115,13 +5161,26 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
+	/*
+	 * For IORING_OP_RECV{,FROM}, the assignment to @sr->umsg
+	 * is equivalent to an assignment to @sr->buf.
+	 */
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+
 	sr->len = READ_ONCE(sqe->len);
 	sr->bgid = READ_ONCE(sqe->buf_group);
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
+	if (req->opcode == IORING_OP_RECVFROM) {
+		sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		sr->recvfrom_addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr3));
+	} else {
+		sr->addr = (struct sockaddr __user *) NULL;
+		sr->recvfrom_addr_len = (int __user *) NULL;
+	}
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
@@ -5197,6 +5256,7 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
 	struct iovec iov;
 	unsigned flags;
 	int ret, min_ret = 0;
+	struct sockaddr_storage address;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	sock = sock_from_file(req->file);
@@ -5214,9 +5274,10 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		goto out_free;
 
-	msg.msg_name = NULL;
+	msg.msg_name = sr->addr ? (struct sockaddr *) &address : NULL;
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
+	/* We assume all kernel code knows the size of sockaddr_storage */
 	msg.msg_namelen = 0;
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
@@ -5228,6 +5289,15 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	ret = sock_recvmsg(sock, &msg, flags);
+	if (ret >= 0 && sr->addr != NULL) {
+		int tmp;
+
+		tmp = move_addr_to_user(&address, msg.msg_namelen, sr->addr,
+					sr->recvfrom_addr_len);
+		if (unlikely(tmp < 0))
+			ret = tmp;
+	}
+
 out_free:
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock)
@@ -6513,9 +6583,11 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_SYNC_FILE_RANGE:
 		return io_sfr_prep(req, sqe);
 	case IORING_OP_SENDMSG:
+	case IORING_OP_SENDTO:
 	case IORING_OP_SEND:
 		return io_sendmsg_prep(req, sqe);
 	case IORING_OP_RECVMSG:
+	case IORING_OP_RECVFROM:
 	case IORING_OP_RECV:
 		return io_recvmsg_prep(req, sqe);
 	case IORING_OP_CONNECT:
@@ -6770,12 +6842,14 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_SENDMSG:
 		ret = io_sendmsg(req, issue_flags);
 		break;
+	case IORING_OP_SENDTO:
 	case IORING_OP_SEND:
 		ret = io_sendto(req, issue_flags);
 		break;
 	case IORING_OP_RECVMSG:
 		ret = io_recvmsg(req, issue_flags);
 		break;
+	case IORING_OP_RECVFROM:
 	case IORING_OP_RECV:
 		ret = io_recvfrom(req, issue_flags);
 		break;
@@ -11218,6 +11292,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
+	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 787f491f0d2a..a58cde19b4d0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -60,7 +60,8 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	__pad2[2];
+	__u64	addr3;
+	__u64	__pad2[1];
 };
 
 enum {
@@ -143,6 +144,8 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_SENDTO,
+	IORING_OP_RECVFROM,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.32.0

