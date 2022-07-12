Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E7E572806
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiGLUzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiGLUyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:54:37 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A75E6567;
        Tue, 12 Jul 2022 13:53:35 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v14so12825946wra.5;
        Tue, 12 Jul 2022 13:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4OVOf9IDPubhHkoLu+U0v1fqovo6hHLbrezmSTxRVeo=;
        b=GMi9+1Jdab22yW+S6P6gEbiOQ6kCcVOpmm67nF4awMz862hR+G9cxEvb/lNgYhNmOh
         rK3aBmGd6NorGC2R2StFFp3GaPQ3WkjtxlkF3q4GutFUDPqj6BdhjfjSeKwBQClbbMtP
         /FJWw6ajKWB4YKo9DZDgdyZiPKpGi4+g9LCFwbQoBR7yuiOLo1AvIgbVP0P9c09SPFGh
         Gnv62nbGBEzG04ZBsb3iY/7Z+310AwcE9vBbFemBnSpJugIAdBS28G7xD0GfBGordeXy
         wO7RjlmBh9UY0DVFhGPOolS2MswaTXSUtgpFYJKbRcAL74GKZpcLTGlwYseJVa4VfPoV
         mBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4OVOf9IDPubhHkoLu+U0v1fqovo6hHLbrezmSTxRVeo=;
        b=m3PKGWz0fCq37NzgSNB/Nn8BTe/zqCUrSRaHTLdsRP9tH/yVUcC4AjY3KQPq11KVYI
         HdNuB6+Lmhuqr5/gcFJfyUPwqMMZD7O2FcV3sogt5MY9/wWTdL2HVK/2sCp5//5NthpW
         98StNT4g1Wxr2hRknOsvBwsNYKXqEHkgL262SygFaxmAh/MIxK06/Om/9j2yagIAc/th
         7KviPRdCUxHNWshKa64uB0ODMM2eJS2dar7hs2MryD7r6ugI8SqMYVo9+JDVQJJcSRt4
         vjdAaYdwWv/P48eRjGhrwdE4BgcXE/2W5ogXSSifaX91GpmnTyovVTix1RynxWa12bYI
         lI+w==
X-Gm-Message-State: AJIora/wDUbSWoo6A5ofdupEZnmb7sZlAG1DDWcog76FTcAJBEK0F/9D
        OpqpgH4LHJfgwe5jlMtgckN7SyOcgVg=
X-Google-Smtp-Source: AGRyM1tLEiIMPU+NYy92WNx2lvrBRXuNzrH49l6b4b67UuFqmQWKjtm9PIXZTy+Fq+MZbEE7DvpqwQ==
X-Received: by 2002:a5d:6da5:0:b0:21d:9275:4de0 with SMTP id u5-20020a5d6da5000000b0021d92754de0mr22740683wrs.670.1657659213079;
        Tue, 12 Jul 2022 13:53:33 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 21/27] io_uring: allow to pass addr into sendzc
Date:   Tue, 12 Jul 2022 21:52:45 +0100
Message-Id: <70417a8f7c5b51ab454690bae08adc0c187f89e8.1657643355.git.asml.silence@gmail.com>
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

Allow to specify an address to zerocopy sends making it more like
sendto(2).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  2 +-
 io_uring/net.c                | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index dcef9d6e7f78..9303bf5236f7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -65,7 +65,7 @@ struct io_uring_sqe {
 		__u32	file_index;
 		struct {
 			__u16	notification_idx;
-			__u16	__pad;
+			__u16	addr_len;
 		};
 	};
 	union {
diff --git a/io_uring/net.c b/io_uring/net.c
index 69273d4f4ef0..2172cf3facd8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -66,6 +66,8 @@ struct io_sendzc {
 	u16				slot_idx;
 	unsigned			msg_flags;
 	unsigned			flags;
+	unsigned			addr_len;
+	void __user			*addr;
 };
 
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
@@ -666,8 +668,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sendzc *zc = io_kiocb_to_cmd(req);
 
-	if (READ_ONCE(sqe->addr2) || READ_ONCE(sqe->__pad2[0]) ||
-	    READ_ONCE(sqe->addr3))
+	if (READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3))
 		return -EINVAL;
 
 	zc->flags = READ_ONCE(sqe->ioprio);
@@ -680,6 +681,10 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->slot_idx = READ_ONCE(sqe->notification_idx);
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
+
+	zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	zc->addr_len = READ_ONCE(sqe->addr_len);
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		zc->msg_flags |= MSG_CMSG_COMPAT;
@@ -689,6 +694,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct sockaddr_storage address;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_sendzc *zc = io_kiocb_to_cmd(req);
 	struct io_notif_slot *notif_slot;
@@ -726,6 +732,14 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 	mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
 
+	if (zc->addr) {
+		ret = move_addr_to_kernel(zc->addr, zc->addr_len, &address);
+		if (unlikely(ret < 0))
+			return ret;
+		msg.msg_name = (struct sockaddr *)&address;
+		msg.msg_namelen = zc->addr_len;
+	}
+
 	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		msg_flags |= MSG_DONTWAIT;
-- 
2.37.0

