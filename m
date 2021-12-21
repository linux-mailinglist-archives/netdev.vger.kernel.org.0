Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFA847C310
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239568AbhLUPgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239569AbhLUPgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:18 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142AEC0617A0;
        Tue, 21 Dec 2021 07:36:09 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t26so27716393wrb.4;
        Tue, 21 Dec 2021 07:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xKWnCIr57BIRr7RkCif3zIfB498scrfOaP1CdH60oZI=;
        b=Q4pqg94M/1Wio3VPfAk2V/9ZGGdhbKj4STAWfEHDUQHsNxM3Ej1Ob3PR7IlVzf2tuX
         BhdNP/MKLWJRSaBMOpf64ZBdhOqL8CBvBABI4PYLyJU58zw1dZV9GQ0Ret2qqiIGRmoe
         1500Cj5MW7hXhu/Z0dhn2Fy/Es/Q/0bO8jiGlTimwzhcF2Hzs7++FGZwGaXcsRb2bzN8
         ysZAeFQFwi+2tzGbjQyd276fjLpo6WpuzJQXyql9rDYjJsQDxj6XwiZyTixzBS8tVli4
         zJoUJex0ZtfwPPdQ+4JZbUCyG0QqnY1XbRGm4LsxGkgraQoAZGz23+J8ak78dRfIEUkC
         nnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xKWnCIr57BIRr7RkCif3zIfB498scrfOaP1CdH60oZI=;
        b=cja9FXZCUYtAIXYKampTsomFjqYk+JkGRzFxxXp3046d6WN9P+ggW4qPmKYw+ZQyFm
         fhsJByunK59Bx90Ws+5D6FyNwSD2OUqki3nHf9/mrqWrvQj9g6+zdhVqhjB//JORTfJH
         ewNruK87RP1o9/JJpGUxrj4WyZWINQpFSMEqo00G+xvfY75DAu672Z4HQ8pJFxjXmHX5
         FShmyrPUPFgYqM6T7tKzHnE9ttkWnDElKyPQph+SiaGlNMGZdTeXJEHvh3c4EXU3uPYN
         J+5trbS0EC8Wrb7jkYd9+mQ1Uc/Wri4RLYVkKEOZxPgvOtG7Ko5pvEYdFcyKiWFt2I3k
         yZsA==
X-Gm-Message-State: AOAM530APZDlbmaHDzKmQ3HjEjxs5SGDBqwMXnTaii7WjyuiMfH7Rkc0
        uFTiszZ5N4rQI1m43YeiY3rlO3AjRKI=
X-Google-Smtp-Source: ABdhPJxEkQKoHGj3EJXOopMDDIVTk8uc8YdMho6igfIg6ANVzbdWvJED6RTYNDh1Cu46EkRV5Pka7Q==
X-Received: by 2002:a5d:4706:: with SMTP id y6mr3171281wrq.435.1640100967487;
        Tue, 21 Dec 2021 07:36:07 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:06 -0800 (PST)
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
Subject: [RFC v2 13/19] io_uring: add an option to flush zc notifications
Date:   Tue, 21 Dec 2021 15:35:35 +0000
Message-Id: <d392b2ee845110d1e166249c58a278cac273cc89.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IORING_SENDZC_FLUSH flag. If specified, a send zc operation on
success should also flush a corresponding ubuf_info.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 26 +++++++++++++++++++-------
 include/uapi/linux/io_uring.h |  4 ++++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9452b4ec32b6..ec1f6c60a14c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -608,6 +608,7 @@ struct io_sendzc {
 	int				msg_flags;
 	int				addr_len;
 	void __user			*addr;
+	unsigned int			zc_flags;
 };
 
 struct io_open {
@@ -1992,6 +1993,12 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 	}
 }
 
+static void io_tx_kill_notification(struct io_tx_ctx *tx_ctx)
+{
+	io_uring_tx_zerocopy_callback(NULL, &tx_ctx->notifier->uarg, true);
+	tx_ctx->notifier = NULL;
+}
+
 static struct io_tx_notifier *io_alloc_tx_notifier(struct io_ring_ctx *ctx,
 						   struct io_tx_ctx *tx_ctx)
 {
@@ -5041,6 +5048,8 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+#define IO_SENDZC_VALID_FLAGS IORING_SENDZC_FLUSH
+
 static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5049,8 +5058,6 @@ static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (READ_ONCE(sqe->ioprio))
-		return -EINVAL;
 
 	sr->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -5067,6 +5074,10 @@ static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	sr->addr_len = READ_ONCE(sqe->__pad2[0]);
 
+	req->msgzc.zc_flags = READ_ONCE(sqe->ioprio);
+	if (req->msgzc.zc_flags & ~IO_SENDZC_VALID_FLAGS)
+		return -EINVAL;
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
@@ -5089,6 +5100,7 @@ static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
+
 	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
 		return ret;
@@ -5128,6 +5140,8 @@ static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
+	} else if (req->msgzc.zc_flags & IORING_SENDZC_FLUSH) {
+		io_tx_kill_notification(req->msgzc.tx_ctx);
 	}
 	io_ring_submit_unlock(ctx, issue_flags & IO_URING_F_UNLOCKED);
 	__io_req_complete(req, issue_flags, ret, 0);
@@ -9417,11 +9431,9 @@ static void io_sqe_tx_ctx_kill_ubufs(struct io_ring_ctx *ctx)
 
 	for (i = 0; i < ctx->nr_tx_ctxs; i++) {
 		tx_ctx = &ctx->tx_ctxs[i];
-		if (!tx_ctx->notifier)
-			continue;
-		io_uring_tx_zerocopy_callback(NULL, &tx_ctx->notifier->uarg,
-					      true);
-		tx_ctx->notifier = NULL;
+
+		if (tx_ctx->notifier)
+			io_tx_kill_notification(tx_ctx);
 	}
 }
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index bbc78fe8ca77..ac18e8e6f86f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -187,6 +187,10 @@ enum {
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
 
+enum {
+	IORING_SENDZC_FLUSH		= (1U << 0),
+};
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.34.1

