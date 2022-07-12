Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15617572800
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbiGLUzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiGLUye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:54:34 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBC71FD;
        Tue, 12 Jul 2022 13:53:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id bk26so12796144wrb.11;
        Tue, 12 Jul 2022 13:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pw3xCF+IE0zNhMTl93PD4uOC8iaBTkE5EoQbu6T6UBI=;
        b=SJVWG8+ZpxKYt9//cbmEV1CwWTzVT6ePgkcZN6bT73VKRqsh7yfkwcjYi59+pLRbfV
         hUQiTkI/FvxUMLpxO/rXKB72qsIQ4Ic9V3Q4cBfH/S7Bu3OAQj1ZbSlzZU06O8qEFMAI
         wuTRp17yjQeNwVgZXpaJur8q7qRiaYa3n9xAZs8PZ2H8ikD1c5PFnGV4pbkGdVQ+ROfZ
         NO42tFrcoppZXzQvHC5mDV7OiYQrAEUyF+E9/crFsrE381Fb/Va/Ysut6DKBpeM/UPer
         8DI9F/1c7YxT4hMdp0vR8zHDS1bqR7Sa6IMtBuXzHQ4VNH0cmBzG5sgQpuof3eA8Bbp+
         n6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pw3xCF+IE0zNhMTl93PD4uOC8iaBTkE5EoQbu6T6UBI=;
        b=p/e5vEvkTAdSjPJ9G7liWW2lV86kaiTxjWootG2uNLGI/dPLuVW+BWjdsXT8092FGv
         15kMyKW0olUo43H1RFtDppRW+RPDkpThgD3LjXJpReSEcVqTAsU6e5nLso4Y2gBUuMQo
         swNT7kNBVdv6gIoTXx9Ur1bXrdihObEunLzqbrVZ4SL4GUBBy7biKn8t/6vfKsB7tAsC
         jUeWTtEyOMxtZONBhhWmscs10Q1UE1ksD53hcesxnTnfNlXsf62P8JwzHiLcQo4eHdDf
         6OTOrynC2rKL0aEm09LdUHfqjP1wTOhsvbWUjDOykUtu8pVO5YqumpVkjxOb73YoBw8Y
         I4eg==
X-Gm-Message-State: AJIora/j9dMb+yvzJ8VVEHva9mKwY2py71eQXvKr0b98O++EqaWq5BEM
        ct8UdtKsc24GQzlPA+AR51iQpomkffY=
X-Google-Smtp-Source: AGRyM1sgaP0mGniZtsIizQQ/BZ406MWmZevgqCljJnKhPDUYmuViayCwwRPDuujhrswvmUBsp7DoVQ==
X-Received: by 2002:a5d:5c05:0:b0:21d:83b4:d339 with SMTP id cc5-20020a5d5c05000000b0021d83b4d339mr23673286wrb.611.1657659210420;
        Tue, 12 Jul 2022 13:53:30 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 19/27] io_uring: wire send zc request type
Date:   Tue, 12 Jul 2022 21:52:43 +0100
Message-Id: <a80387c6a68ce9cf99b3b6ef6f71068468761fb7.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new io_uring opcode IORING_OP_SENDZC. The main distinction from
IORING_OP_SEND is that the user should specify a notification slot
index in sqe::notification_idx and the buffers are safe to reuse only
when the used notification is flushed and completes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  5 ++
 io_uring/net.c                | 94 +++++++++++++++++++++++++++++++++++
 io_uring/net.h                |  4 ++
 io_uring/opdef.c              | 15 ++++++
 4 files changed, 118 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f1ba8e934168..dcef9d6e7f78 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -63,6 +63,10 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		struct {
+			__u16	notification_idx;
+			__u16	__pad;
+		};
 	};
 	union {
 		struct {
@@ -194,6 +198,7 @@ enum io_uring_op {
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
+	IORING_OP_SENDZC_NOTIF,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index 2dd61fcf91d8..399267e8f1ef 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -13,6 +13,7 @@
 #include "io_uring.h"
 #include "kbuf.h"
 #include "net.h"
+#include "notif.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -58,6 +59,15 @@ struct io_sr_msg {
 	unsigned int			flags;
 };
 
+struct io_sendzc {
+	struct file			*file;
+	void __user			*buf;
+	size_t				len;
+	u16				slot_idx;
+	unsigned			msg_flags;
+	unsigned			flags;
+};
+
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
 
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -652,6 +662,90 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_sendzc *zc = io_kiocb_to_cmd(req);
+
+	if (READ_ONCE(sqe->addr2) || READ_ONCE(sqe->__pad2[0]) ||
+	    READ_ONCE(sqe->addr3))
+		return -EINVAL;
+
+	zc->flags = READ_ONCE(sqe->ioprio);
+	if (zc->flags & ~IORING_RECVSEND_POLL_FIRST)
+		return -EINVAL;
+
+	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	zc->len = READ_ONCE(sqe->len);
+	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	zc->slot_idx = READ_ONCE(sqe->notification_idx);
+	if (zc->msg_flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		zc->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+	return 0;
+}
+
+int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_sendzc *zc = io_kiocb_to_cmd(req);
+	struct io_notif_slot *notif_slot;
+	struct io_notif *notif;
+	struct msghdr msg;
+	struct iovec iov;
+	struct socket *sock;
+	unsigned msg_flags;
+	int ret, min_ret = 0;
+
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
+
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		return -EAGAIN;
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	notif_slot = io_get_notif_slot(ctx, zc->slot_idx);
+	if (!notif_slot)
+		return -EINVAL;
+	notif = io_get_notif(ctx, notif_slot);
+	if (!notif)
+		return -ENOMEM;
+
+	msg.msg_name = NULL;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_namelen = 0;
+
+	ret = import_single_range(WRITE, zc->buf, zc->len, &iov, &msg.msg_iter);
+	if (unlikely(ret))
+		return ret;
+
+	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		msg_flags |= MSG_DONTWAIT;
+	if (msg_flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+
+	msg.msg_flags = msg_flags;
+	msg.msg_ubuf = &notif->uarg;
+	msg.sg_from_iter = NULL;
+	ret = sock_sendmsg(sock, &msg);
+
+	if (unlikely(ret < min_ret)) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+		return ret == -ERESTARTSYS ? -EINTR : ret;
+	}
+
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = io_kiocb_to_cmd(req);
diff --git a/io_uring/net.h b/io_uring/net.h
index 81d71d164770..1dba8befebb3 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -40,4 +40,8 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags);
 int io_connect_prep_async(struct io_kiocb *req);
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_sendzc(struct io_kiocb *req, unsigned int issue_flags);
+int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+
 #endif
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a7b84b43e6c2..7ab19bbf3126 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -470,6 +470,21 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_uring_cmd,
 		.prep_async		= io_uring_cmd_prep_async,
 	},
+	[IORING_OP_SENDZC_NOTIF] = {
+		.name			= "SENDZC_NOTIF",
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+#if defined(CONFIG_NET)
+		.prep			= io_sendzc_prep,
+		.issue			= io_sendzc,
+#else
+		.prep			= io_eopnotsupp_prep,
+#endif
+
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.37.0

