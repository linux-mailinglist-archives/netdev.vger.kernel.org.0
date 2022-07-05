Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1875671FE
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbiGEPEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiGEPCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:50 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E851836E;
        Tue,  5 Jul 2022 08:02:16 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so9879459wmp.3;
        Tue, 05 Jul 2022 08:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tbxo2zxY0T1Ay96nPliwwxqArxsvLBHX36I30j8CQ68=;
        b=NCSNg1grb3sp1zJnbVBWrlZI1p9iBfgy2h2WVpCPVuYznLkf4LQy0FZAeSOnjO/Sh9
         NJ5HFg78astN1ajHtl4bg96EqQMecVpq8Tn52t+wMb6B7FBednF9Ozz0ZcPUHo0wDAqX
         MJ10tapRsL7i0GHM8UyMNc4ZwfCaSDKzSg8+Jf5kXlDj4RoHdUPa5V96sfM6NEl8+faC
         cYLEfCIWr89lYD/2mxLYQQnXbdnxt7WN20rkqdqao/AedTQrhKAn+WaHsa8eOCc81bvz
         BYniL/D20lf20pNINSIv/IrTA7SYw5+wdP4ZAwkqI77QxJB6JOVNMnBIXkVrpmfYZ31o
         UJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tbxo2zxY0T1Ay96nPliwwxqArxsvLBHX36I30j8CQ68=;
        b=7BgiqLAyMghlPuraAiFlWl5IVWrERZOWig2bk8M6crVNSG6HGTnJHir7tbuZFdr81+
         yG1xxdXkKIjnKVeijDjPht3pzAsoB9JsVkC8tQkuWPLGgDFQYDdKyOFzlHnJaJJKfoD4
         twGfH17ihhgElivTzRMS0jbJdVcamOJFPXeUj6OGWfE/h+GBTtlnGV8mBRAn8/U3WeXU
         G3A5X6AcBKXcPYZFA/dy04x2ak/SE7R4juqu4n3liRuaQnVn8cOb/FkBzPdVBVFOZW3a
         t1EDk9opBV1AQYDRiG/JIuCX+dtNxSXr6fEp/HAAp/NwSYswHN8hOb2jAcTvnI/HlT0z
         40NA==
X-Gm-Message-State: AJIora/OaDFRh9mC6Bg9hBDhJyAdKzkCkDnT4LvGjSexW/hd5CJg8Xhq
        zMpudXh7cbd9nZoDxFbdvEJAWjpjhFmmFw==
X-Google-Smtp-Source: AGRyM1tG5Re8Ez6RpeHcx2yU/rPLUkwLu09WetKbYfGBR1DZEQ/QvDTNjPW0Yse6uWImrH3q33XSpw==
X-Received: by 2002:a05:600c:3b1d:b0:3a2:60a1:fe30 with SMTP id m29-20020a05600c3b1d00b003a260a1fe30mr10800015wms.193.1657033333933;
        Tue, 05 Jul 2022 08:02:13 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 21/25] io_uring: sendzc with fixed buffers
Date:   Tue,  5 Jul 2022 16:01:21 +0100
Message-Id: <d9672980cdc25db17837152a58f2fea95c2c8e99.1656318994.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
References: <cover.1656318994.git.asml.silence@gmail.com>
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
 include/uapi/linux/io_uring.h |  7 ++++++
 io_uring/net.c                | 40 +++++++++++++++++++++++++++++------
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index abb8a9502f6e..2509e6184bc7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -272,6 +272,13 @@ enum io_uring_op {
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
 
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
diff --git a/io_uring/net.c b/io_uring/net.c
index e63dda89c222..3dfe07749b04 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -14,6 +14,7 @@
 #include "kbuf.h"
 #include "net.h"
 #include "notif.h"
+#include "rsrc.h"
 
 #if defined(CONFIG_NET)
 struct io_shutdown {
@@ -65,6 +66,7 @@ struct io_sendzc {
 	size_t				len;
 	u16				slot_idx;
 	int				msg_flags;
+	unsigned			zc_flags;
 	int				addr_len;
 	void __user			*addr;
 };
@@ -782,11 +784,14 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+#define IO_SENDZC_VALID_FLAGS IORING_SENDZC_FIXED_BUF
+
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sendzc *zc = io_kiocb_to_cmd(req);
+	struct io_ring_ctx *ctx = req->ctx;
 
-	if (READ_ONCE(sqe->ioprio) || READ_ONCE(sqe->__pad2[0]))
+	if (READ_ONCE(sqe->__pad2[0]))
 		return -EINVAL;
 
 	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -799,6 +804,20 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	zc->addr_len = READ_ONCE(sqe->addr_len);
 
+	zc->zc_flags = READ_ONCE(sqe->ioprio);
+	if (zc->zc_flags & ~IO_SENDZC_VALID_FLAGS)
+		return -EINVAL;
+
+	if (zc->zc_flags & IORING_SENDZC_FIXED_BUF) {
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
@@ -836,12 +855,21 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
-	msg.msg_managed_data = 0;
+	msg.msg_managed_data = 1;
 
-	ret = import_single_range(WRITE, zc->buf, zc->len, &iov, &msg.msg_iter);
-	if (unlikely(ret))
-		return ret;
-	mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
+	if (zc->zc_flags & IORING_SENDZC_FIXED_BUF) {
+		ret = io_import_fixed(WRITE, &msg.msg_iter, req->imu,
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
-- 
2.36.1

