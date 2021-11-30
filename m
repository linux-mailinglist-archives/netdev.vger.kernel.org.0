Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C034639D9
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbhK3PYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245092AbhK3PX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:28 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7089FC061D67;
        Tue, 30 Nov 2021 07:19:30 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id q3so22360348wru.5;
        Tue, 30 Nov 2021 07:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eehkf30/vOkmB1EHeirvJM7RAs4zwrvYsLhDyfeMDEo=;
        b=JhzEfNn/4tTOE5NohqW/qiQ5gmxbxvBlbr399BuAjwjTpqYqRWbDZos3thQtWTUPbU
         Z4E9GxXMgczPJ6yaM8kwFTrm7ExdkonbQzTUMqJjTINOVRtb3i/GdznCzP/4jRbdylNN
         OIAFLzk+JqHCaF3o8AYgubBU91yaoM8D+Qc3VZgoW0MxpCXOcqiJ9QG+ukVcaUOzp0m4
         cRUqz+BvqxuxF62etuMRuemEvu2mbRnvBQPAOKTX2pf+t2yywuQXET7x8OvlAtyma4k+
         jydbIdChjjsQdlsIXgKbVPOwrzQxpI/euHA+CBQV8oqe4bfchyVtMYnMv3+3V6040gBC
         1lng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eehkf30/vOkmB1EHeirvJM7RAs4zwrvYsLhDyfeMDEo=;
        b=Qau3YxVmbJf5xx+2XP7urFigMxgth7QCZ0TmKSvGsjmff8/5SkY+R2tj41uhZsO0rO
         fBJj9RqBGBHcOQGza+NuOAF+IHAkXkFoK7jvga0+sR+dOsjWhsiB0YCKYNmlhuWQ2JgT
         gg1qkoXl/96tqkTH/EHS/sWlZvU28/eQR2ib9P/Fo4vJ2zbw9eYfQZTv0pMRK1pOx1Id
         AgjRH/fUXi6nuLxDlzV2V2y0PTJEEYI+zdqgq4FexgG6XJ0GMNLLF/N8dTtgiUqpUwvT
         pGV6ZnaKU3HJtu5uRd2rv20SiYuq8TwTC7lMzZJTcIBvliszaxdsHoFWeIVXoIuc9ixH
         fknQ==
X-Gm-Message-State: AOAM532DGxioiW6ub1d/4mdtWcNrgwntOBrJBWCBn2GHtf2a+wlWh7wz
        kTZfETBZVatEo9/ZLxhpPgUsQmwMVg0=
X-Google-Smtp-Source: ABdhPJwUfyjo09llrc+/Fo2zUYnofOzAAyc5suZLXTovy2jjrJiektOg0WRTBGGjqbiykKXwO7kOEg==
X-Received: by 2002:a05:6000:23a:: with SMTP id l26mr40998595wrz.215.1638285568859;
        Tue, 30 Nov 2021 07:19:28 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:28 -0800 (PST)
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
Subject: [RFC 09/12] io_uring: add an option to flush zc notifications
Date:   Tue, 30 Nov 2021 15:18:57 +0000
Message-Id: <c443a4ace7f7de989ac685809aad2c3379220c8d.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
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
index 337eb91f0198..e1360fde95d3 100644
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
2.34.0

