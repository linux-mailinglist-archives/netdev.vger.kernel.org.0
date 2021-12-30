Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E3A481BE6
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 13:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbhL3MBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 07:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239155AbhL3MB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 07:01:28 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C32C061574;
        Thu, 30 Dec 2021 04:01:28 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u16so18099454plg.9;
        Thu, 30 Dec 2021 04:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TDgv196gWb07CUyUUcwYdYWixQvIpSIJ3cIHNOMMxdA=;
        b=h2E5pj3CBlbfIatpL/8mghPAEsde92sVrILb0KJsZOaoWzMBWAKlozW0XVAzLgVtrX
         3N2oOmWrlihbXpVJbdRwHtW/jTsaFaPkTdOtQaTH4suqdLxSRFZ0wFCKMwIlUrP1PkeY
         U6d8IU6ah+7xRYShRqLAhtlBO3gcky4wiy85UR66CLHZhIcpOsmN3pBgbqeGkIhwUV/D
         luX6UwRh6c4e0T96thxfdgi6HrnwQ3hwSeUu9IxLxWkujfZeUJY9zzd5QM6PDBWod5Cz
         oXjG1dX2ePP1EcPRJeclyb3W6avcmC/S1gxrvx6ZWsCOuPeV1Ny2bMHdBVelKOROSA8k
         Ptxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TDgv196gWb07CUyUUcwYdYWixQvIpSIJ3cIHNOMMxdA=;
        b=Gat45n+t/zU4dO9SFnzjn9g0t0yfZdMeliPNUpTom8R23h1KoFkiJgdtX5hvlDk/IX
         rdcL46YLwiVjQ01+4yhve/lbn19WQdknzR4uIOxf6LVWBeednYnIa3s/VoBH/uUorS/i
         P4AjDZiDccAv02aqXeE5kW4+ZWnintBpElT63NSd5j5YwWYxyYqlrFkipWhzlwm6/+9s
         oGaODvF1Vneesz3LMIgiR276liNQdjoZK8u7SUsdg5mPcYHv5Fuxvfi5pfXOiKRy+2vg
         MxZ/3LYZf3z9gzpDfDwzoRPDIXq674qmC3LtOWnWFPeG1go7MyHpEgdsjdXGLqeVnsCF
         qUtQ==
X-Gm-Message-State: AOAM533hIWsyF2c+g+i1BjCu4WvNo8uuN1yTHjNYGfvzavda8hnL889q
        qobp/53Q6i2r2ZFpWajAq5A=
X-Google-Smtp-Source: ABdhPJxaQCUygBLiCTLvaAZ6SpNVkdZhcWBaL38Hipx0lk3rO69WkkThN8edSm63kJ3fnFp0c2cMGw==
X-Received: by 2002:a17:903:11c5:b0:149:a8cf:37da with SMTP id q5-20020a17090311c500b00149a8cf37damr1350032plh.132.1640865688190;
        Thu, 30 Dec 2021 04:01:28 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id nn16sm30121257pjb.54.2021.12.30.04.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 04:01:27 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH v2 3/3] io_uring: Add `sendto(2)` and `recvfrom(2)` support
Date:   Thu, 30 Dec 2021 19:00:44 +0700
Message-Id: <20211230115057.139187-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230114846.137954-1-ammar.faizi@intel.com>
References: <20211230114846.137954-1-ammar.faizi@intel.com>
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
Link: https://github.com/axboe/liburing/issues/397
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---

v2:
  - In `io_recvfrom()`, mark the error check of `move_addr_to_user()`
    call as unlikely.

  - Fix build error when CONFIG_NET is undefined.

 fs/io_uring.c                 | 84 ++++++++++++++++++++++++++++++++---
 include/uapi/linux/io_uring.h |  2 +
 2 files changed, 80 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d564f98d5d3b..3726958f8f58 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -575,7 +575,15 @@ struct io_sr_msg {
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
@@ -1133,6 +1141,19 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file = 1
 	},
 	[IORING_OP_GETXATTR] = {},
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
@@ -5216,12 +5237,24 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
+	}
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
@@ -5275,6 +5308,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct sockaddr_storage address;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
 	struct iovec iov;
@@ -5291,10 +5325,20 @@ static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -5309,6 +5353,7 @@ static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+	fail:
 		req_set_fail(req);
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
@@ -5427,13 +5472,25 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
+	}
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
@@ -5509,6 +5566,7 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
 	struct iovec iov;
 	unsigned flags;
 	int ret, min_ret = 0;
+	struct sockaddr_storage address;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
 	sock = sock_from_file(req->file);
@@ -5526,7 +5584,7 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		goto out_free;
 
-	msg.msg_name = NULL;
+	msg.msg_name = sr->addr ? (struct sockaddr *) &address : NULL;
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
@@ -5540,6 +5598,16 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	ret = sock_recvmsg(sock, &msg, flags);
+
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
@@ -5707,8 +5775,8 @@ IO_NETOP_PREP_ASYNC(sendmsg);
 IO_NETOP_PREP_ASYNC(recvmsg);
 IO_NETOP_PREP_ASYNC(connect);
 IO_NETOP_PREP(accept);
-IO_NETOP_FN(send);
-IO_NETOP_FN(recv);
+IO_NETOP_FN(sendto);
+IO_NETOP_FN(recvfrom);
 #endif /* CONFIG_NET */
 
 struct io_poll_table {
@@ -6778,9 +6846,11 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -7060,12 +7130,14 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index efc7ac9b3a6b..a360069d1e8e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -150,6 +150,8 @@ enum {
 	IORING_OP_SETXATTR,
 	IORING_OP_FGETXATTR,
 	IORING_OP_GETXATTR,
+	IORING_OP_SENDTO,
+	IORING_OP_RECVFROM,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.32.0

