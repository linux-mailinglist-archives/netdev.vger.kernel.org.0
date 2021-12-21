Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B696C47C2FF
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239543AbhLUPgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239534AbhLUPgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:11 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60E3C061761;
        Tue, 21 Dec 2021 07:36:05 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id p27-20020a05600c1d9b00b0033bf8532855so2341017wms.3;
        Tue, 21 Dec 2021 07:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G2De1nOYEnoTMy4aHTSVIFQ1gk/yEENXcYEdqgdPhSQ=;
        b=Xs0SKTkY3isypL7d070j113H9JYXWTyLwEpJKdCfDftM/MGwNiAVKGklpz2dTAI4zV
         1KIu1N9/yatXBdOqIlEVRCY4n+gn+/FyRfjD/h1ZRw1LIRIMzejactzXA9Fdb4u4nbn1
         YoYkWFILY/4D2hEdWqdMWCWKL5aom7SWyhp41ELvoiHfS5zoSWL4PPJBDP6uaHnNrId2
         r59NBW6UTEe9K2GAKsLkE8lV3cp7lx3mxhXrKocAd2Zb2if4GBeaD7uU/493JgBNM0gO
         vD64Vsy1wQi5pGnHQvZ3NzrA7RE+775Oh58YxMQvSayBnLjeDINF6jNmr2yQbt+pTQN2
         1Fag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G2De1nOYEnoTMy4aHTSVIFQ1gk/yEENXcYEdqgdPhSQ=;
        b=VgpuKJmYrG/IyHB23AeVVsUzU/vwPnh7bQSLW9l+knbc/n2Ne8kQImLRxHhKgEMNAB
         YX/PXuMqQG2FFrL0VZgS6kXBeKJlg9vObLSXPtuQfKcpHj9VVbbcXrd1pj2VF9EJipEJ
         PM8S7QXwSmI39yTwKPZJ9ek2gvXm9aLPJCzK+5T9YNibBHuVHXnFn4M08Te7KHkv4RvC
         5G3N0GIFp0qnVR/6239EUO19x3dF86Y0p3JOLLQ/P05k/Bg7twjvk/yDx7G1Fe4SoBBq
         ILY7rtffcmgmKCunnhLFBKIf2RyuiJdPfZqvdQlg7qiJfFN4W4FzVl3vyci26PEmNK6Z
         8L3A==
X-Gm-Message-State: AOAM533BNeqJACYJi7U3wZ9I5ydwxVVYDL744NFbyRWQtPBxT1blfJBJ
        mEB+qFb7kEaCItJq/tdaxZ1PHRnOV3k=
X-Google-Smtp-Source: ABdhPJwrgOzl0uZgDUnuUF7Zl7BEibR8u4Wo4ZCOE2RtIHIen3MlK5OpI+/HpM4Ad/XJWkRC3s8PIA==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr3170524wmk.168.1640100964092;
        Tue, 21 Dec 2021 07:36:04 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:03 -0800 (PST)
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
Subject: [RFC v2 10/19] io_uring: add send notifiers registration
Date:   Tue, 21 Dec 2021 15:35:32 +0000
Message-Id: <4cfeb88dc07fcdff2c0c864c031bb32b61439674.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
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
2.34.1

