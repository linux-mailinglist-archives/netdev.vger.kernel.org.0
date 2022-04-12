Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11684FE982
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 22:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiDLUkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 16:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiDLUjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 16:39:36 -0400
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F5890AD
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:35:27 -0700 (PDT)
Received: by mail-il1-f178.google.com with SMTP id h4so6054268ilq.8
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=USVVp1hK54jHeAqy/lUDZNBBqIJDjeW4jtH5P9usO7U=;
        b=y6SpbqynDTaeScwaA/pU4EiSBCsWW1ugzYwUe4tqzVe54p7UUY4mhgVu/f+YAD+aXQ
         auIZkr4d4IaK9QvuvJnbmGI3LhqEgPs3zXgNGB6Ez/I2HEfs/1aBtEm60n0mfFHHpLhM
         Qr6NBj5R5o+fXOYioZH8ftLvqyBP18neW2Ft36Dd7fmdMjOk4/rzO0uHL8i2zl/QQaH7
         w48bR8xtnKqv72A8c2BP9hUZE2/ULfJpNcaYWOSJ6ansrjiPfMfVwEWPoqccknekRz8D
         xC41IkSmvqrxCGybigZReEGn7sDieG5qXnq8UFwFrq0T3NJIWQ4DGV29L6QymKN3ZclO
         eAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=USVVp1hK54jHeAqy/lUDZNBBqIJDjeW4jtH5P9usO7U=;
        b=qV1c/XN3L6jRymiOJwCogURnfdR+aJP5ooUvcXUjC4/4lxERTtofnnB18YCYI62rHp
         MujON8SHOdYXDjHFOor4+868wyNM8mDQXwuFqZ/pxYdC6CDdDNfFXP1NtLkE5g1YXuSv
         DIfHTN+o5r6iOCPLcQCLQJznke1IZkq1wBil605Kyu4Cxp7EisRhJWn/wsP0ZVKBlt+L
         7ORjCIciDASlTKASZjbjTTU9MdguADmT7bYPy05Kpvry7jqs2L6bzKRsjxy0BLksx1Py
         caCl411+Q/8rQpfFvsnhfyH9sTifx0aM82UCoc6OpVJOP0MKguilTeel/qMClyHsSp7O
         Us0g==
X-Gm-Message-State: AOAM530zVzj/Ak1iLW0WcD+RzKeCOAb6pzXmKGKf2+cTXinuzFN7ctMP
        e+1k4cXOxznbAWd6T5GD16LqMNj8kUqlQk2E
X-Google-Smtp-Source: ABdhPJxVMmWRPZgak0ACi4mGWFKAVePCuGtLDsT3AYqFZm2YFpl3R8ulupFitXx++nlIu1K+VoPe3Q==
X-Received: by 2002:a63:5310:0:b0:39c:f338:407e with SMTP id h16-20020a635310000000b0039cf338407emr20694065pgb.600.1649794967758;
        Tue, 12 Apr 2022 13:22:47 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 2-20020a17090a0f0200b001cb6621403csm359541pjy.24.2022.04.12.13.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:22:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: add socket(2) support
Date:   Tue, 12 Apr 2022 14:22:40 -0600
Message-Id: <20220412202240.234207-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412202240.234207-1-axboe@kernel.dk>
References: <20220412202240.234207-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supports both regular socket(2) where a normal file descriptor is
instantiated when called, or direct descriptors.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 77 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 78 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b83134906a3a..1523a43c4469 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -558,6 +558,16 @@ struct io_accept {
 	unsigned long			nofile;
 };
 
+struct io_socket {
+	struct file			*file;
+	int				domain;
+	int				type;
+	int				protocol;
+	int				flags;
+	u32				file_slot;
+	unsigned long			nofile;
+};
+
 struct io_sync {
 	struct file			*file;
 	loff_t				len;
@@ -926,6 +936,7 @@ struct io_kiocb {
 		struct io_hardlink	hardlink;
 		struct io_msg		msg;
 		struct io_xattr		xattr;
+		struct io_socket	sock;
 	};
 
 	u8				opcode;
@@ -1192,6 +1203,9 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file = 1
 	},
 	[IORING_OP_GETXATTR] = {},
+	[IORING_OP_SOCKET] = {
+		.audit_skip		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -5968,6 +5982,63 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_socket *sock = &req->sock;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->addr || sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
+
+	sock->domain = READ_ONCE(sqe->fd);
+	sock->type = READ_ONCE(sqe->off);
+	sock->protocol = READ_ONCE(sqe->len);
+	sock->file_slot = READ_ONCE(sqe->file_index);
+	sock->nofile = rlimit(RLIMIT_NOFILE);
+
+	sock->flags = sock->type & ~SOCK_TYPE_MASK;
+	if (sock->file_slot && (sock->flags & SOCK_CLOEXEC))
+		return -EINVAL;
+	if (sock->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+		return -EINVAL;
+	return 0;
+}
+
+static int io_socket(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_socket *sock = &req->sock;
+	bool fixed = !!sock->file_slot;
+	struct file *file;
+	int ret, fd;
+
+	if (!fixed) {
+		fd = __get_unused_fd_flags(sock->flags, sock->nofile);
+		if (unlikely(fd < 0))
+			return fd;
+	}
+	file = __sys_socket_file(sock->domain, sock->type, sock->protocol);
+	if (IS_ERR(file)) {
+		if (!fixed)
+			put_unused_fd(fd);
+		ret = PTR_ERR(file);
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	} else if (!fixed) {
+		fd_install(fd, file);
+		ret = fd;
+	} else {
+		io_sock_nolock_set(file);
+		ret = io_install_fixed_file(req, file, issue_flags,
+					    sock->file_slot - 1);
+	}
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
 static int io_connect_prep_async(struct io_kiocb *req)
 {
 	struct io_async_connect *io = req->async_data;
@@ -6055,6 +6126,7 @@ IO_NETOP_PREP_ASYNC(sendmsg);
 IO_NETOP_PREP_ASYNC(recvmsg);
 IO_NETOP_PREP_ASYNC(connect);
 IO_NETOP_PREP(accept);
+IO_NETOP_PREP(socket);
 IO_NETOP_FN(send);
 IO_NETOP_FN(recv);
 #endif /* CONFIG_NET */
@@ -7269,6 +7341,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_fgetxattr_prep(req, sqe);
 	case IORING_OP_GETXATTR:
 		return io_getxattr_prep(req, sqe);
+	case IORING_OP_SOCKET:
+		return io_socket_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -7590,6 +7664,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_GETXATTR:
 		ret = io_getxattr(req, issue_flags);
 		break;
+	case IORING_OP_SOCKET:
+		ret = io_socket(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 696a05aa9618..9e28014b1e10 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -151,6 +151,7 @@ enum {
 	IORING_OP_SETXATTR,
 	IORING_OP_FGETXATTR,
 	IORING_OP_GETXATTR,
+	IORING_OP_SOCKET,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.35.1

