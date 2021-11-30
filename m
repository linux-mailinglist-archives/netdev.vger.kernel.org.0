Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30784639C7
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245320AbhK3PYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245087AbhK3PX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:28 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461B4C061D66;
        Tue, 30 Nov 2021 07:19:29 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso19808690wms.3;
        Tue, 30 Nov 2021 07:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AHZdLicu5JTswxvmP1cJP+tnU4fdIGy/YGmaAwYSNng=;
        b=JxJxAuiEXFOoi58byq6joGDTGf2JhnIfmxBFzRjTAYUXuWYv9rPisOm8L5vXXghWas
         egruRQt39gsr8Nns+Y0X1ie2tdAEhxNrCPcB961bAjhCSmVdMZg1jzGXllKjT4aMQusL
         dKz5WAVhequnihKy5xvcDRRcrP2A8ZX+QVJzBqNIHHzjiV0aVybbwe0ZutCk/3QawTHv
         pRM7E7GCLNl6NUW+eDcH2YzkXpH1S5HzK8nLx4ip9LfRKf2LYsxTykbn8Ok+5s7xv975
         I1veStJs2NObgfJyJfaIbzeVVk84rnZOAaUrQhpWHPdu1X5APXAsPiUyinn/+pznFSr5
         HVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AHZdLicu5JTswxvmP1cJP+tnU4fdIGy/YGmaAwYSNng=;
        b=BrYA4cYvdwPog2hfxJRGxh6kx6aC00fPjre4eYDobxwR8jU1qOdkjSlMjfRkKQHjGp
         0oMmlIUGscARCe6IXfqa8mikguZpq26WW+SWxzcJjnS3FepNzDpetsDsBapRfp3IeUxA
         gUOvOjIriUFuXCqArj0mDRamcysmMs7JpMqdCGdBPVwrfQNnT/AmHukDWrwFa6oR4X76
         1ZSi0tpAOrYF3VHK6h5Oy607ZVulNXzV1y5bpGATIPOGkoHE9di1TvOukRUU4PephOHH
         ILtEbuklXkbN05Gi8qcAGz6SY/hFeBAtlYfXuAKTnVBITSu8IhLB1ydl03qs57mJ6Ijh
         64Ww==
X-Gm-Message-State: AOAM532OI/Eh37uzNmnfL+MTMrhehCYhVUJj0GlNqzqzwx349m2Wk1qn
        KZ7MglrZr2qKI7EzlyTbLrdvY+r8emY=
X-Google-Smtp-Source: ABdhPJxiURr+gLV6BLitN1LZ2XVOPzmJ+4lLj+gBwpCBcbot95y/GHGwK/EY6/nogXD+enloBTpeiQ==
X-Received: by 2002:a7b:c756:: with SMTP id w22mr107379wmk.34.1638285567620;
        Tue, 30 Nov 2021 07:19:27 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC 08/12] io_uring: wire send zc request type
Date:   Tue, 30 Nov 2021 15:18:56 +0000
Message-Id: <e35fad0fdada4bb46397292c729663a337fcaf77.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
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
index 6ca02e60fa48..337eb91f0198 100644
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
+	flags = sr->msg_flags;
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
2.34.0

