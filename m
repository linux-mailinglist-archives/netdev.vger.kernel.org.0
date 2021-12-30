Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6F0481825
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbhL3Bgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbhL3Bg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 20:36:29 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9468AC061574;
        Wed, 29 Dec 2021 17:36:29 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id w24so17062990ply.12;
        Wed, 29 Dec 2021 17:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eSFHa0IHlf9Zomm+XN5IkeoDcBJ7ELekCdhGkDi97eQ=;
        b=AJwzWInvWYIe/ibQFKQ9ooDd4Idh5etByQD4a1m6KF7EsJZJJSGc20OuWsJuqYx/3+
         dB2OOMZeI5Gc1oJgOE0xE7jq5Ap0w+mFLI5lqPDT5oXNEy9/xRS8GB9SxIapw2uk4QN6
         1mhvSjPA9Pax+jPI1wcscPo5X4isWS455YXcrK/8z5zz5x0KT27tBM3hc2BMzBTK+rN+
         rhOSvLlfqf2eLWZri3nUOz8JzIj69KZJ8l+OuYfqTf+3+MC3ymCM5iPWG2YsMxj0JL/K
         HzxRs/bum1fxnBzrynjJfHdjSla7NtOytRwCmko/JkzTRveiPx8pmBz2K61Vy3vmPMwi
         b//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eSFHa0IHlf9Zomm+XN5IkeoDcBJ7ELekCdhGkDi97eQ=;
        b=k4Rv5fus0FSawlNS26vwQFMC+DX75Z3nvAerlVcoFEuxaNCXR/DL6IVfloU3iYbmZS
         lUIWV0jiTd27Sy7/W79hm9k+kqgTPzfEDx7r2pBACKQdTOC30EQReZ+U2kWaAKo9HynC
         RihSzMDQ8oaelCpJfkPPSE637wVY/QJj0Hods2j5cdnR6H1tvFrr5xvkZLSQJvCUF+tN
         9tZ2HSQfFSPqp/AtonBp6w5UGur943nroT9CCT1F1NVPkaqV/CH7Ql8kfYVF0JbHTl8R
         F7Wvsp4nT0NdaO0iq1AO8qukn0i4x1Gzf8ZQsFne9vVbd+iOEwvhlIrSVUex4WPlQTQ4
         R1Sg==
X-Gm-Message-State: AOAM530cvvCxT8UOGJrvItyBiodN/P0xCegxR9cB3j9Kw1ArgBQl919S
        K75CHmZ1P3C1OPwd+MNPpuk=
X-Google-Smtp-Source: ABdhPJykUy5X/XEPEluxOo4Xn3C3kMqV+YH8R80mgtIFP+0V2//M079fU5uzJiCQgyxB39iy3LuOCQ==
X-Received: by 2002:a17:902:d50e:b0:148:b614:54a1 with SMTP id b14-20020a170902d50e00b00148b61454a1mr28782468plg.163.1640828189174;
        Wed, 29 Dec 2021 17:36:29 -0800 (PST)
Received: from integral2.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id v8sm19616795pfu.68.2021.12.29.17.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 17:36:28 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [RFC PATCH v1 3/3] io_uring: Add `sendto(2)` and `recvfrom(2)` support
Date:   Thu, 30 Dec 2021 08:35:43 +0700
Message-Id: <20211230013250.103267-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230013154.102910-1-ammar.faizi@intel.com>
References: <20211230013154.102910-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds sendto(2) and recvfrom(2) support for io_uring.

New opcodes:
  IORING_OP_SENDTO
  IORING_OP_RECVFROM

Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 fs/io_uring.c                 | 80 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  2 +
 2 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d564f98d5d3b..4406c044798f 100644
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
+		if (tmp < 0)
+			ret = tmp;
+	}
+
 out_free:
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock)
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

