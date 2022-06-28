Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD2955ED3F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbiF1TBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiF1TA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:28 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE90418B28;
        Tue, 28 Jun 2022 12:00:10 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id lw20so27726288ejb.4;
        Tue, 28 Jun 2022 12:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UONJeK+9EHyQ+C5KYc2Q0yOxdhk4aZ1zarcHPxbpVEY=;
        b=FjK/M13ETjiXIqAKhIdhfR2WpMeaoovAIhcP2sJfYOENz6mOGZrIdO8aH75lI/KPt/
         Bw6w/brAwILJ5A1STFGloCjay/dkeIX8LVUoVsiv1DPDXuVLNMJ6tnnoY2yqfVjgmkUJ
         RJu9ettGHpJJRqrpuhvHkFgzuXHD9uH2jS/FRM2xYgm5XuWFgHwCLjllPdIhcWLj0bTA
         53DWfk2ytIDL1j1WXZ2XNtjRv+kaU0dYAFMjMvdSEDjQx+4VrzfVxgdx5IDiYUuA47so
         Nflx+Xnrx98AqgZRKw3crBq9oXycoJhapIZXVBZjS7zQ/yeqi+XCw4gaNNJBwtDNuuyd
         ksTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UONJeK+9EHyQ+C5KYc2Q0yOxdhk4aZ1zarcHPxbpVEY=;
        b=56+0NVYO+oV4DNIk609mZ/gb7cAqvPR3DEqu0S7OoOQGwYMwqSJPPC8ITw0MPF/Bt+
         OBR5uOHsCSJp2NXfkYcj65CxVq+9sPUx+lurfGkWI/lWykosusC9HUwTQ8G3pMf/9UuM
         +7Vh0HiSUPwnDFhaOVdT8w6EhFioG9ChXDFnoSnZ4qjYaLT5oBwUBH76/ziQaKbkx7wV
         eLuwm6f6ViohaR7KCf05uxTqDIPmdAX/aKnTVhzshJiYp569bgAsPfz+r/HUpaay7nAC
         1iPSXL1bhHpKH6upNKHZxd68/STCcDDiyiC6jjwHuptC9XgMEC43k7lUoW+jex0WimLV
         qmvQ==
X-Gm-Message-State: AJIora+vFrM4zFYWLKn3cYZDoWloWNarxxL/lr1rDOHSV3Y8snf82Px6
        UW/IH9Mu3G19783COhiMgiPIc9wAAqO3Pw==
X-Google-Smtp-Source: AGRyM1sqoPxWmG3jBD+RHQNAsgIEpV0+nyh4rKhc8jV5q3gGuiC0v43l5+foAmsZFEKZB9WiRCqV2Q==
X-Received: by 2002:a17:907:1c01:b0:6f4:2692:e23 with SMTP id nc1-20020a1709071c0100b006f426920e23mr18883015ejc.243.1656442809225;
        Tue, 28 Jun 2022 12:00:09 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 14/29] io_uring: opcode independent fixed buf import
Date:   Tue, 28 Jun 2022 19:56:36 +0100
Message-Id: <b72ba1d67363445c1b660cb166713f68468f09a2.1653992701.git.asml.silence@gmail.com>
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

Extract an opcode independent helper from io_import_fixed for
initialising an iov_iter with a fixed buffer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6a57a5ae18fb..e47629adf3f7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3728,11 +3728,11 @@ static void kiocb_done(struct io_kiocb *req, ssize_t ret,
 	}
 }
 
-static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
-			     struct io_mapped_ubuf *imu)
+static int __io_import_fixed(int rw, struct iov_iter *iter,
+			     struct io_mapped_ubuf *imu,
+			     u64 buf_addr, size_t len)
 {
-	size_t len = req->rw.len;
-	u64 buf_end, buf_addr = req->rw.addr;
+	u64 buf_end;
 	size_t offset;
 
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
@@ -3802,7 +3802,7 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
 		imu = READ_ONCE(ctx->user_bufs[index]);
 		req->imu = imu;
 	}
-	return __io_import_fixed(req, rw, iter, imu);
+	return __io_import_fixed(rw, iter, imu, req->rw.addr, req->rw.len);
 }
 
 static int io_buffer_add_list(struct io_ring_ctx *ctx,
-- 
2.36.1

