Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F06155ED5F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiF1TBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbiF1TAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:35 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141131EEFC;
        Tue, 28 Jun 2022 12:00:23 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id lw20so27726288ejb.4;
        Tue, 28 Jun 2022 12:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DkkJV+I1xqoSsdjvbVDAbb8FThJ4wemGZq1lcjOE1/4=;
        b=bqKdU4EHepi9SUPDDuE6qYVQOWMlNVyMjLsQMLac4oIkcAwIcoKdhFpwBuSXfEuxTY
         lMEghLkIoeTGlsEITzdPnuHXFFPAgMwXo0VkUMAvCjB8W5Fi90NsMRKIhFZlPEvw4LOr
         +PYAyvEmGEfgjXaOLgQ/zs7n8svEMdUVhdFUkx4itqZh65vSW38tL8IY6hyRjNAFoxdi
         pRt8uNHLxLgKnx9yEc7ZiglfikO1mlG2+10o1deqc41x/qgujIr37OgWFqxVTHiM/3qB
         wda9Z1riP65r2ThAWFBheEvHOCn8KYrNleqTKPIlTcn9iO2/Ei1TCyi8lnRZqLNjTMKU
         6HNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DkkJV+I1xqoSsdjvbVDAbb8FThJ4wemGZq1lcjOE1/4=;
        b=himbGjpM/bFUdIZIHZgO1vgNH5EiiTNqd/41MKzBqn7Z17rkJV9z6hGPVt+oFlWRWO
         V+gsSbHquztt1VdMqlRYJteG3VFobmq4ANhIVZs7KOcYNKOGHl/WaccqCABhMoQvE+qu
         ZoJnHiBEDH8lL+cHSognoFyx3PPy5tbQ1k2Lsrub98pozUJ1N9EkDZeOb1WyrIRQxshU
         FzjqIrNO3sZmJ+M9U5BznT8Lg0Zfy+CiLrcKgH/aBr7v26dNQ71QzxniE2o7FechxsKv
         ydRiIp9ymiQOmYlX3Th3XdPxwPQJ/XT6Q9b8ERJZNK3oWPDbc7fd+m7Bz2jQkW06GJPp
         cEyA==
X-Gm-Message-State: AJIora/vq6dr77nj+hdC+FT1blnyTKc11kcFKXf5v/d5IMgBLjwU+rOw
        tvQLk9W3GcSRQqTLpr43ttw3UYWadkPqRw==
X-Google-Smtp-Source: AGRyM1tQmPVip+5n1Y8yQ2uexWKTWxnz+s41uN6RYVlElwRuwIoUnOpZ2HcMZYLug7CY5IM70sO1Kw==
X-Received: by 2002:a17:906:b048:b0:6fe:be4a:3ecf with SMTP id bj8-20020a170906b04800b006febe4a3ecfmr19858600ejb.104.1656442822374;
        Tue, 28 Jun 2022 12:00:22 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 25/29] io_uring: sendzc with fixed buffers
Date:   Tue, 28 Jun 2022 19:56:47 +0100
Message-Id: <672444088a4a08b3b098a0edb60d2669ec253161.1653992701.git.asml.silence@gmail.com>
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

Allow zerocopy sends to use fixed buffers. There is an optimisation for
this case, the network layer don't need to reference the pages, see
SKBFL_MANAGED_FRAG_REFS, so io_uring have to ensure validity of fixed
buffers until the notifier is released.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 39 +++++++++++++++++++++++++++++------
 include/uapi/linux/io_uring.h |  7 +++++++
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 07d09d06e8ab..70b1f77ac64e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -723,6 +723,7 @@ struct io_sendzc {
 	size_t				len;
 	u16				slot_idx;
 	int				msg_flags;
+	unsigned			zc_flags;
 	int				addr_len;
 	void __user			*addr;
 };
@@ -6580,11 +6581,14 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+#define IO_SENDZC_VALID_FLAGS IORING_SENDZC_FIXED_BUF
+
 static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sendzc *zc = &req->msgzc;
+	struct io_ring_ctx *ctx = req->ctx;
 
-	if (READ_ONCE(sqe->ioprio) || READ_ONCE(sqe->__pad2[0]))
+	if (READ_ONCE(sqe->__pad2[0]))
 		return -EINVAL;
 
 	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -6596,6 +6600,20 @@ static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	zc->addr_len = READ_ONCE(sqe->addr_len);
 
+	zc->zc_flags = READ_ONCE(sqe->ioprio);
+	if (req->msgzc.zc_flags & ~IO_SENDZC_VALID_FLAGS)
+		return -EINVAL;
+
+	if (req->msgzc.zc_flags & IORING_SENDZC_FIXED_BUF) {
+		unsigned idx = READ_ONCE(sqe->buf_index);
+
+		if (unlikely(idx >= ctx->nr_user_bufs))
+			return -EFAULT;
+		idx = array_index_nospec(idx, ctx->nr_user_bufs);
+		req->imu = READ_ONCE(ctx->user_bufs[idx]);
+		io_req_set_rsrc_node(req, ctx, 0);
+	}
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		zc->msg_flags |= MSG_CMSG_COMPAT;
@@ -6633,12 +6651,21 @@ static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
-	msg.msg_managed_data = 0;
+	msg.msg_managed_data = 1;
 
-	ret = import_single_range(WRITE, zc->buf, zc->len, &iov, &msg.msg_iter);
-	if (unlikely(ret))
-		return ret;
-	mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
+	if (req->msgzc.zc_flags & IORING_SENDZC_FIXED_BUF) {
+		ret = __io_import_fixed(WRITE, &msg.msg_iter, req->imu,
+					(u64)zc->buf, zc->len);
+		if (unlikely(ret))
+				return ret;
+	} else {
+		msg.msg_managed_data = 0;
+		ret = import_single_range(WRITE, zc->buf, zc->len, &iov,
+					  &msg.msg_iter);
+		if (unlikely(ret))
+			return ret;
+		mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
+	}
 
 	if (zc->addr) {
 		ret = move_addr_to_kernel(zc->addr, zc->addr_len, &address);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 689aa1444cd4..69100aa71448 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -274,6 +274,13 @@ enum {
 	IORING_RSRC_UPDATE_NOTIF,
 };
 
+/*
+ * IORING_OP_SENDZC flags
+ */
+enum {
+	IORING_SENDZC_FIXED_BUF		= (1U << 0),
+};
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.36.1

