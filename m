Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CF855ED59
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbiF1TBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiF1TAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:34 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C93A1CB01;
        Tue, 28 Jun 2022 12:00:19 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id o9so18874953edt.12;
        Tue, 28 Jun 2022 12:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2f1AxK5FaO/U0unxlphFQ9xZ09TOUrK2OQGB6/IkU5Q=;
        b=M28CQDGd7UfSStv9n7ef92AA6sM8BSea4g+GMgjK3C53lhnbQ5YjjcSNSsoNRJBTTd
         QXQlbdCyCkHmzmY4pMrpxRgre0CGDT/sQnF6X0heS1QWHMWHvq7A/uLPO9gRP57M/y1g
         4723zSN2iNGXRGx8M7Iuf3czaFnJcD9zyNjgTaQhjjhso2dkqtaxpB/WC2q8ZuWQOwft
         bpI0ZLh4c8a06rGwAsR/Ui8Ex/4Hn3qhyG5rWW4nj25312e2M01uitVyDUt/c/a0Jk6a
         iMIkWn1vZ2DbeifJ6wisDgxYApJLThGejZXuZsZgBNo/Lo+CPNtAauA2rIYdRUBX7TiO
         hjLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2f1AxK5FaO/U0unxlphFQ9xZ09TOUrK2OQGB6/IkU5Q=;
        b=G81HUexszCcJ7TC8icgkT8ZY4u+Y1UJMHnosXhHqfH0Ls8a+uy7g/qY/p6xZY2Ts/m
         qesy9FMXqaLdpxzz+l3ysGWmqfJKNoGcojgUxprLIeEQQKFjHrinyZYjnhrxLC1pekUx
         StzSsfgoFiXWfa3pRfD6TifZr+FSffWiVUFtMh/M+6ijbWwphiACWd+K0ug/+DhsEozC
         iyHN848RjAmhheuCDNEB9VEe42UxYA7W5rLeE78l/MkEaoC5EEuNk3w8ncLka8AFXLds
         +r3CzzcgdNphS0sc+jHZry31p+y7J0gl2PeAufcIjk6Oj1btPenh431z562KoCN/vrMl
         A33g==
X-Gm-Message-State: AJIora9Qh9WC9iLC83wXRXyqnrT0OeQ3bnSTHhC48enPq1uxd9b4oVjg
        KpY21u3u+6mUM9DnybhdJbvpAD7oBTh4Og==
X-Google-Smtp-Source: AGRyM1tsvZyi0q1mjEcxSKNzX5+chxM1V6KXEbkMOnHkGbvjSI/ZMigUBzLf4F7lq2G5RUpEMJ1NGg==
X-Received: by 2002:a05:6402:42cb:b0:435:8c3b:faf8 with SMTP id i11-20020a05640242cb00b004358c3bfaf8mr25224341edc.300.1656442817541;
        Tue, 28 Jun 2022 12:00:17 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 21/29] io_uring: wire send zc request type
Date:   Tue, 28 Jun 2022 19:56:43 +0100
Message-Id: <b8af7329752169ad0fef9e5d8d41c40327a91fa1.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
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
 fs/io_uring.c                 | 103 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |   5 ++
 2 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a88c9c73ed1d..4a1a1d43e9b3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -716,6 +716,14 @@ struct io_sr_msg {
 	unsigned int			flags;
 };
 
+struct io_sendzc {
+	struct file			*file;
+	void __user			*buf;
+	size_t				len;
+	u16				slot_idx;
+	int				msg_flags;
+};
+
 struct io_open {
 	struct file			*file;
 	int				dfd;
@@ -1044,6 +1052,7 @@ struct io_kiocb {
 		struct io_socket	sock;
 		struct io_nop		nop;
 		struct io_uring_cmd	uring_cmd;
+		struct io_sendzc	msgzc;
 	};
 
 	u8				opcode;
@@ -1384,6 +1393,13 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_async_setup	= 1,
 		.async_size		= uring_cmd_pdu_size(1),
 	},
+	[IORING_OP_SENDZC] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -1525,6 +1541,8 @@ const char *io_uring_get_opcode(u8 opcode)
 		return "SOCKET";
 	case IORING_OP_URING_CMD:
 		return "URING_CMD";
+	case IORING_OP_SENDZC:
+		return "URING_SENDZC";
 	case IORING_OP_LAST:
 		return "INVALID";
 	}
@@ -2920,7 +2938,6 @@ static struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 	return notif;
 }
 
-__attribute__((unused))
 static inline struct io_notif *io_get_notif(struct io_ring_ctx *ctx,
 					    struct io_notif_slot *slot)
 {
@@ -2929,7 +2946,6 @@ static inline struct io_notif *io_get_notif(struct io_ring_ctx *ctx,
 	return slot->notif;
 }
 
-__attribute__((unused))
 static inline struct io_notif_slot *io_get_notif_slot(struct io_ring_ctx *ctx,
 						      int idx)
 	__must_hold(&ctx->uring_lock)
@@ -6546,6 +6562,83 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_sendzc *zc = &req->msgzc;
+
+	if (READ_ONCE(sqe->ioprio) || READ_ONCE(sqe->addr2) || READ_ONCE(sqe->__pad2[0]))
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
+static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_sendzc *zc = &req->msgzc;
+	struct io_notif_slot *notif_slot;
+	struct io_notif *notif;
+	struct msghdr msg;
+	struct iovec iov;
+	struct socket *sock;
+	unsigned msg_flags;
+	int ret, min_ret = 0;
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
+	msg.msg_managed_data = 0;
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
+	ret = sock_sendmsg(sock, &msg);
+
+	if (unlikely(ret < min_ret)) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	}
+
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
 static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 				 struct io_async_msghdr *iomsg)
 {
@@ -7064,6 +7157,7 @@ IO_NETOP_PREP_ASYNC(connect);
 IO_NETOP_PREP(accept);
 IO_NETOP_PREP(socket);
 IO_NETOP_PREP(shutdown);
+IO_NETOP_PREP(sendzc);
 IO_NETOP_FN(send);
 IO_NETOP_FN(recv);
 #endif /* CONFIG_NET */
@@ -8389,6 +8483,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
 		return io_sendmsg_prep(req, sqe);
+	case IORING_OP_SENDZC:
+		return io_sendzc_prep(req, sqe);
 	case IORING_OP_RECVMSG:
 	case IORING_OP_RECV:
 		return io_recvmsg_prep(req, sqe);
@@ -8689,6 +8785,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_SEND:
 		ret = io_send(req, issue_flags);
 		break;
+	case IORING_OP_SENDZC:
+		ret = io_sendzc(req, issue_flags);
+		break;
 	case IORING_OP_RECVMSG:
 		ret = io_recvmsg(req, issue_flags);
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 19b9d7a2da29..6c6f20ae5a95 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -61,6 +61,10 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		struct {
+			__u16	notification_idx;
+			__u16	__pad;
+		} __attribute__((packed));
 	};
 	union {
 		struct {
@@ -190,6 +194,7 @@ enum io_uring_op {
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
+	IORING_OP_SENDZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.36.1

