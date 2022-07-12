Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435AC572804
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiGLU4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiGLUyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:54:55 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89B31172;
        Tue, 12 Jul 2022 13:53:43 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id bk26so12796473wrb.11;
        Tue, 12 Jul 2022 13:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lTEKopEUAeQr5d74gqsIxK77ORJixv2HTggIm0W0E6c=;
        b=XmSKQIQuCqY/uVsXhKKb1J3A1zYatMru/4pa7BBb8xXRz90QUz5IbSZV1pCxmrtKJs
         3dPfzpdPc5wMlbGojMzs7TPgv//zAsgnRmhhe6vwENqPw8UjPzVmKYt7iEjLvZ1M1vwa
         xp0NIwC9T+pStJ7k+xRugEWK83w5YkaR4BZ3VipYK8wY+i4p466HRKwPHAYvz8I5gM2Q
         Co9/PmV+z8HB0KMcQ6APltCLYzrkZZ6+KszBZ24q/4kyBVKoJKDew2xCkKHPIgdl/vT/
         dQQXu1XclWFXVcWF/elfOybBkbK05Vsg7g3QQQiRCmiHInnLdBYtkOZYaIhWg9l1CZ/T
         +P4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lTEKopEUAeQr5d74gqsIxK77ORJixv2HTggIm0W0E6c=;
        b=iTog5NjvB12UFidFA2nmltdGKbzPYhhpZTNJ5n3VdnlQGSdVRf3gfP0peis39eRB6Z
         /LoOBi7LgGDmriQ1bY5sSsVgRLNM/G9V7ZraYR+EBLOcZ8Q3HIJIvaHw+/wfp4OPaBtf
         k4F83A88+m/El+9vjZr6JzGaQwv8+Bl90X02XsZyCuxfxhGqG0lUnUevXTeS/G/pb/mk
         77AtQi3z4oMfsjs3DlzS+U7/JZ4d+vJQ/7SItzyq8OCXSSIJoh1TarjQ/Pqkmwnl+EcK
         6wOm0sVFxmxDZTPhP7xQlPR1MOvcEcTaB9bD7M1Kmzs7bCQEoLUJp7y+6O57KaGUfMsZ
         DZtQ==
X-Gm-Message-State: AJIora8HGU9WsQppGJJSX5j4JfXnR6x66I5JDNn5ARraTwKpA+HsukUj
        fYEcFXtVetAEqSZdwe20tgar4eM/6ZU=
X-Google-Smtp-Source: AGRyM1vvX0Sob/YNDt7bpKNdszodUoKWSI0yDRqYSfbrj0q9XwxNkvJ9nhdwp5iFWM46ebnCNOobuQ==
X-Received: by 2002:a05:6000:1ac8:b0:21d:b7d9:3c03 with SMTP id i8-20020a0560001ac800b0021db7d93c03mr2006827wry.149.1657659218010;
        Tue, 12 Jul 2022 13:53:38 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 25/27] io_uring: add zc notification flush requests
Date:   Tue, 12 Jul 2022 21:52:49 +0100
Message-Id: <df13e2363400682a73dd9e71c3b990b8d1ff0333.1657643355.git.asml.silence@gmail.com>
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

Overlay notification control onto IORING_OP_RSRC_UPDATE (former
IORING_OP_FILES_UPDATE). It allows to flush a range of zc notifications
from slots with indexes [sqe->off, sqe->off+sqe->len). If sqe->arg is
not zero, it also copies sqe->arg as a new tag for all flushed
notifications.

Note, it doesn't flush a notification of a slot if there was no requests
attached to it (since last flush or registration).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/rsrc.c               | 38 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 37e8c104d31f..9a7aa25d09a1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -294,6 +294,7 @@ enum io_uring_op {
  */
 enum {
 	IORING_RSRC_UPDATE_FILES,
+	IORING_RSRC_UPDATE_NOTIF,
 };
 
 /*
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 98ce8a93a816..088a2dc32e2c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -15,6 +15,7 @@
 #include "io_uring.h"
 #include "openclose.h"
 #include "rsrc.h"
+#include "notif.h"
 
 struct io_rsrc_update {
 	struct file			*file;
@@ -742,6 +743,41 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static int io_notif_update(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned len = up->nr_args;
+	unsigned idx_end, idx = up->offset;
+	int ret = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	if (unlikely(check_add_overflow(idx, len, &idx_end))) {
+		ret = -EOVERFLOW;
+		goto out;
+	}
+	if (unlikely(idx_end > ctx->nr_notif_slots)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (; idx < idx_end; idx++) {
+		struct io_notif_slot *slot = &ctx->notif_slots[idx];
+
+		if (!slot->notif)
+			continue;
+		if (up->arg)
+			slot->tag = up->arg;
+		io_notif_slot_flush_submit(slot, issue_flags);
+	}
+out:
+	io_ring_submit_unlock(ctx, issue_flags);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
+
 int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
@@ -749,6 +785,8 @@ int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
 	switch (up->type) {
 	case IORING_RSRC_UPDATE_FILES:
 		return io_files_update(req, issue_flags);
+	case IORING_RSRC_UPDATE_NOTIF:
+		return io_notif_update(req, issue_flags);
 	}
 	return -EINVAL;
 }
-- 
2.37.0

