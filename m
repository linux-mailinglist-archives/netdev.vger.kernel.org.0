Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969FD47C306
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbhLUPgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239492AbhLUPgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF54DC061799;
        Tue, 21 Dec 2021 07:36:07 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id s1so27794342wrg.1;
        Tue, 21 Dec 2021 07:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hLt51GiyEFtQsW2c2SV0I+9skcK5FTpjdlXoOT9qeCY=;
        b=DCw72oZlGLm+ELuI4uV5m6KTi/jUVR0+DVoApPRjg/O/I22izSzZkPO33WmjyzE/58
         1MKnYWd2IdGkaEJRnEcfR5cCLss0kIzTHSkYsumi5xAdOJiFvDKdhlRI3cjkNd/IBreh
         odG4EOAzjD2a5geQvyIt7/azMMYUePJwqNpflExuBJwmUig3Q1wvbz0eadS1jtR425IQ
         1HVVO1CDWWH3HaaNZOdCWThI6n/oisb52zJW733xdmE8EbIS2P7YGH+q/Agp3S/YRima
         7mQr2IyBQvDI7il/Ks1qzS/54Os5C98dHJMOD1D1BNY9zEYoi/NlI2BaXgRhAxVnWyle
         FuGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hLt51GiyEFtQsW2c2SV0I+9skcK5FTpjdlXoOT9qeCY=;
        b=2TeY1JnybOqW2iMOnhUcIcOflxEURPi/1MITN1kZMjB5dTPF9ch4xnq+1nMlACkA/+
         c6Bmz0tSFjxKRTBTC6YvV6qnqJpVcicTyeNuyIR1vTxhwNCXQE1giWvi5rykkdBu74PK
         +hc5LTrqnKQsg++TOerb7HfqDAVJjAhA+iURSDlcKhON8pBf2YbGD+z04J8uK5sWXUy3
         /vAg8cKmLC3cdtu+g0RG8s88LAfRTeSI+q0tnR2oYUodmXpqyN420QkQ09Do94ODPtJB
         E3UlGDcQOUIzqEpAPd/VFEPuu/nDpc5E3ULUvDVyEE+TNv22lOW+vMTDgh1i2XYt0Zla
         ld3A==
X-Gm-Message-State: AOAM532LNbq9tBC4impBvwUE8MCXR9nphib+/VIZqhrYM6bd+I6qiubn
        XTxPy0WDons4qHss1i4tQG7sjQ0wsxI=
X-Google-Smtp-Source: ABdhPJyP/hGbXJY71rBumaf5YNkP25VloEMxUPGCkAf3aaLiXI2Lp4eUugPa+yto92Av3nVHtQPNpg==
X-Received: by 2002:adf:e3d1:: with SMTP id k17mr3171511wrm.610.1640100966332;
        Tue, 21 Dec 2021 07:36:06 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:05 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 12/19] io_uring: wire send zc request type
Date:   Tue, 21 Dec 2021 15:35:34 +0000
Message-Id: <41c71e1dc27c3ba17acb5a8f43e1e140fca71f19.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new io_uring opcode IORING_OP_SENDZC. The main distinction from
other send requests is that the user should specify a tx context index,
which will notifiy the userspace when the kernel doesn't need the
buffers anymore and it's safe to reuse them. So, overwriting data
buffers is racy before getting a separate notification even when the
request is already completed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 120 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |   2 +
 2 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92190679f3f6..9452b4ec32b6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -600,6 +600,16 @@ struct io_sr_msg {
 	size_t				len;
 };
 
+struct io_sendzc {
+	struct file			*file;
+	void __user			*buf;
+	size_t				len;
+	struct io_tx_ctx 		*tx_ctx;
+	int				msg_flags;
+	int				addr_len;
+	void __user			*addr;
+};
+
 struct io_open {
 	struct file			*file;
 	int				dfd;
@@ -874,6 +884,7 @@ struct io_kiocb {
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
+		struct io_sendzc	msgzc;
 	};
 
 	u8				opcode;
@@ -1123,6 +1134,12 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_SENDZC] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.audit_skip		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -1999,7 +2016,6 @@ static struct io_tx_notifier *io_alloc_tx_notifier(struct io_ring_ctx *ctx,
 	return notifier;
 }
 
-__attribute__((unused))
 static inline struct io_tx_notifier *io_get_tx_notifier(struct io_ring_ctx *ctx,
 							struct io_tx_ctx *tx_ctx)
 {
@@ -5025,6 +5041,102 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_sendzc *sr = &req->msgzc;
+	unsigned int idx;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (READ_ONCE(sqe->ioprio))
+		return -EINVAL;
+
+	sr->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	sr->len = READ_ONCE(sqe->len);
+	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	if (sr->msg_flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+
+	idx = READ_ONCE(sqe->tx_ctx_idx);
+	if (idx > ctx->nr_tx_ctxs)
+		return -EINVAL;
+	idx = array_index_nospec(idx, ctx->nr_tx_ctxs);
+	req->msgzc.tx_ctx = &ctx->tx_ctxs[idx];
+
+	sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	sr->addr_len = READ_ONCE(sqe->__pad2[0]);
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		sr->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+	return 0;
+}
+
+static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct sockaddr_storage address;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_tx_notifier *notifier;
+	struct io_sendzc *sr = &req->msgzc;
+	struct msghdr msg;
+	struct iovec iov;
+	struct socket *sock;
+	unsigned flags;
+	int ret, min_ret = 0;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
+	if (unlikely(ret))
+		return ret;
+
+	msg.msg_name = NULL;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_namelen = 0;
+	if (sr->addr) {
+		ret = move_addr_to_kernel(sr->addr, sr->addr_len, &address);
+		if (ret < 0)
+			return ret;
+		msg.msg_name = (struct sockaddr *)&address;
+		msg.msg_namelen = sr->addr_len;
+	}
+
+	io_ring_submit_lock(ctx, issue_flags & IO_URING_F_UNLOCKED);
+	notifier = io_get_tx_notifier(ctx, req->msgzc.tx_ctx);
+	if (!notifier) {
+		req_set_fail(req);
+		ret = -ENOMEM;
+		goto out;
+	}
+	msg.msg_ubuf = &notifier->uarg;
+
+	flags = sr->msg_flags | MSG_ZEROCOPY;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&msg.msg_iter);
+	msg.msg_flags = flags;
+	ret = sock_sendmsg(sock, &msg);
+
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			goto out;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	}
+	io_ring_submit_unlock(ctx, issue_flags & IO_URING_F_UNLOCKED);
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+out:
+	io_ring_submit_unlock(ctx, issue_flags & IO_URING_F_UNLOCKED);
+	return ret;
+}
+
 static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 				 struct io_async_msghdr *iomsg)
 {
@@ -5428,6 +5540,7 @@ IO_NETOP_PREP_ASYNC(sendmsg);
 IO_NETOP_PREP_ASYNC(recvmsg);
 IO_NETOP_PREP_ASYNC(connect);
 IO_NETOP_PREP(accept);
+IO_NETOP_PREP(sendzc);
 IO_NETOP_FN(send);
 IO_NETOP_FN(recv);
 #endif /* CONFIG_NET */
@@ -6575,6 +6688,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
 		return io_sendmsg_prep(req, sqe);
+	case IORING_OP_SENDZC:
+		return io_sendzc_prep(req, sqe);
 	case IORING_OP_RECVMSG:
 	case IORING_OP_RECV:
 		return io_recvmsg_prep(req, sqe);
@@ -6832,6 +6947,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
index f2e8d18e40e0..bbc78fe8ca77 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -59,6 +59,7 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		__u32	tx_ctx_idx;
 	};
 	__u64	__pad2[2];
 };
@@ -143,6 +144,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_SENDZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.34.1

