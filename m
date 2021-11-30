Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60654639D4
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245425AbhK3PYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245085AbhK3PX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:28 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43EDC061D64;
        Tue, 30 Nov 2021 07:19:26 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d9so24352431wrw.4;
        Tue, 30 Nov 2021 07:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wY1As03rF5TmjUCuV7yr/sjJ+OmJ/UHrJ+IXfv0oMnk=;
        b=Fce56+l13k3XBLtYTY3SV8DvM+jDhx35XvC5Ovm+Rcrb5mD33F0PD2UcLtlvRSct3P
         GJ+lalBXL2WrFdKoglE7FCPv450yNZPvrlEXGB2BfsqYgX4p0x+X2elSRs6oSVJKjrFM
         vV7IX7WN40jOzoHMlHsqk+4UMpbz4z7PRtdDzt7qDJvCnaoueZuJf+n1rfZOaeudOA+w
         bcNaTBcZHPe/EVG5tY8uPgZU/cf6mix+qZkKxG54Da6B7JWeOY72Zx5u8to3assLF2jW
         Flm3LSf/crHM1Q/7E8gkdk3BAyruqUSPmOCDPedzou0KjPgYSaQKEkEpdN+15M1jEo4x
         4Vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wY1As03rF5TmjUCuV7yr/sjJ+OmJ/UHrJ+IXfv0oMnk=;
        b=IiDLxNcZMhwrdMCd+dtPe+44xDyp45sL7rCK8IDQsevsmdKqcQbI4x9NrWGxUCO8No
         KpXhm6BtFraEmSLV5snwffdYuv67J1qaA69hieaaTwGSbDISTt4h9OgjQQ4BX7VOlqKk
         h6E9K5ZGr/YIhB+TfQKOcBOu+KY5v/2M0MUOyyURnwnC4+954LoDDfMzAOkN76bYHJYx
         VWIOVHbNcnxruImp/JOJoarQOQwTDhAzkPZGFdgcodpRBvGgXd4KYYxItj/GUVkaDZ/P
         yHw/ihwmq2zciIfAPVvM2If372MX5g2o8VKuTI/oSj7FvFYUqHpcCilvjXYjUaK2m6rJ
         DEjg==
X-Gm-Message-State: AOAM531CMf+EYy40AD5oUKFgTLQzYoVcUrllfH6O4hWcYqTIdAw1IS9y
        tH98MwqCfAlHTsDgliujKZDsXJLURGo=
X-Google-Smtp-Source: ABdhPJzbEKvbxueRTlTT7Mp7AlrSXRSpYDRNHgdxY6sidzxX9SNgqMuNTsYQMw9L7Lm+hPZFwlndJQ==
X-Received: by 2002:a5d:648e:: with SMTP id o14mr41003106wri.141.1638285565244;
        Tue, 30 Nov 2021 07:19:25 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:24 -0800 (PST)
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
Subject: [RFC 06/12] io_uring: add send notifiers registration
Date:   Tue, 30 Nov 2021 15:18:54 +0000
Message-Id: <1585ab7d7c7c987450f733b5773bc1ca1f673fce.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IORING_REGISTER_TX_CTX and IORING_UNREGISTER_TX_CTX. Transmission
(i.e. send) context will serve be used to notify the userspace when
fixed buffers used for zerocopy sends are released by the kernel.

Notification of a single tx context lives in generations, where each
generation posts one CQE with ->user_data equal to the specified tag and
->res is a generation number starting from 0. All requests issued
against a ctx will get attached to the current generation of
notifications. Then, the userspace will be able to request to flush the
notification allowing it to post a CQE when all buffers of all requests
attached to it are released by the kernel. It'll also switch the
generation to a new one with a sequence number incremented by one.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  7 ++++
 2 files changed, 79 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 59380e3454ad..a01f91e70fa5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -94,6 +94,8 @@
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
 
+#define IORING_MAX_TX_NOTIFIERS	(1U << 10)
+
 /* only define max */
 #define IORING_MAX_FIXED_FILES	(1U << 15)
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
@@ -326,6 +328,15 @@ struct io_submit_state {
 	struct blk_plug		plug;
 };
 
+struct io_tx_notifier {
+};
+
+struct io_tx_ctx {
+	struct io_tx_notifier	*notifier;
+	u64			tag;
+	u32			seq;
+};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -373,6 +384,8 @@ struct io_ring_ctx {
 		unsigned		nr_user_files;
 		unsigned		nr_user_bufs;
 		struct io_mapped_ubuf	**user_bufs;
+		struct io_tx_ctx	*tx_ctxs;
+		unsigned		nr_tx_ctxs;
 
 		struct io_submit_state	submit_state;
 		struct list_head	timeout_list;
@@ -9199,6 +9212,55 @@ static int io_buffer_validate(struct iovec *iov)
 	return 0;
 }
 
+static int io_sqe_tx_ctx_unregister(struct io_ring_ctx *ctx)
+{
+	if (!ctx->nr_tx_ctxs)
+		return -ENXIO;
+
+	kvfree(ctx->tx_ctxs);
+	ctx->tx_ctxs = NULL;
+	ctx->nr_tx_ctxs = 0;
+	return 0;
+}
+
+static int io_sqe_tx_ctx_register(struct io_ring_ctx *ctx,
+				  void __user *arg, unsigned int nr_args)
+{
+	struct io_uring_tx_ctx_register __user *tx_args = arg;
+	struct io_uring_tx_ctx_register tx_arg;
+	unsigned i;
+	int ret;
+
+	if (ctx->nr_tx_ctxs)
+		return -EBUSY;
+	if (!nr_args)
+		return -EINVAL;
+	if (nr_args > IORING_MAX_TX_NOTIFIERS)
+		return -EMFILE;
+
+	ctx->tx_ctxs = kvcalloc(nr_args, sizeof(ctx->tx_ctxs[0]),
+				GFP_KERNEL_ACCOUNT);
+	if (!ctx->tx_ctxs)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_args; i++, ctx->nr_tx_ctxs++) {
+		struct io_tx_ctx *tx_ctx = &ctx->tx_ctxs[i];
+
+		if (copy_from_user(&tx_arg, &tx_args[i], sizeof(tx_arg))) {
+			ret = -EFAULT;
+			goto out_fput;
+		}
+		tx_ctx->tag = tx_arg.tag;
+	}
+	return 0;
+
+out_fput:
+	kvfree(ctx->tx_ctxs);
+	ctx->tx_ctxs = NULL;
+	ctx->nr_tx_ctxs = 0;
+	return ret;
+}
+
 static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 				   unsigned int nr_args, u64 __user *tags)
 {
@@ -9429,6 +9491,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
+	io_sqe_tx_ctx_unregister(ctx);
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
@@ -11104,6 +11167,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_iowq_max_workers(ctx, arg);
 		break;
+	case IORING_REGISTER_TX_CTX:
+		ret = io_sqe_tx_ctx_register(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_TX_CTX:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_sqe_tx_ctx_unregister(ctx);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 787f491f0d2a..f2e8d18e40e0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -325,6 +325,9 @@ enum {
 	/* set/get max number of io-wq workers */
 	IORING_REGISTER_IOWQ_MAX_WORKERS	= 19,
 
+	IORING_REGISTER_TX_CTX			= 20,
+	IORING_UNREGISTER_TX_CTX		= 21,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -365,6 +368,10 @@ struct io_uring_rsrc_update2 {
 	__u32 resv2;
 };
 
+struct io_uring_tx_ctx_register {
+	__u64 tag;
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
-- 
2.34.0

