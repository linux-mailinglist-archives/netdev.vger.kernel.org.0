Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6866F55ED64
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbiF1TBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbiF1TAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:36 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4425B1F2E5;
        Tue, 28 Jun 2022 12:00:25 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id ej4so18911320edb.7;
        Tue, 28 Jun 2022 12:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ox9QeHiY6HWuPvJfgNGG6WaFTtO2T886numczpXJZTA=;
        b=bMbLJIsrR1Tb7cS5HHG5VF8QBma2TQ+bPnX0ptlXlGNl15a7RnZiH9s+R1YKDUQw4n
         8K5th81a4IF76rwDN7Ww1IAcC80o42i9cViirk4ByviNLaTkbbZ9HzY60t0fgu+djiUl
         8P4KdTeNmUyKmELfCW7GZWcwqDon1btdcbMCVxXAWfe0U7KHH98LoxfC8PJQHHozqw/+
         CKR9b4ET8hgLBZWaBM2dfXRuOVToAUvI5dzntOFJaIdyE/kBvE311KHnLfXPy8mWURVn
         DMrQQhm5cSO3c0UF/AUpfYdSr9x/y/JlqQNJOVuQxifojkyATP1ZI+XjdZ3AW4tZl4G8
         nl0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ox9QeHiY6HWuPvJfgNGG6WaFTtO2T886numczpXJZTA=;
        b=e33BnT1Fq23r/2sW6xzw40fwH5TzeE0WFjiEZT7PUpv92uw/Hs3S86FIqaQ4OWBHub
         5UPue28qIrrY4hIyCtxMuRSe0XKGqZmFjpzUptXczhD1kUemWCDhGYEOwrntgG+aW81k
         6EAOBC5kCXxQo5+ozAKQU4YSePmsG5SjHLL2iOtyEzS/hIPr7irpCKJZuiRmgnZHTmkr
         lpkkF2lpZOF8uKVpaqb4sGQ6uxhHJZMVzv7qc95t5TCeyDhY7LiZ+AdDbEq9PUvTHDcu
         hoPsxWZjY1fYzbkR2HbFWNW4+kD6huj94Va5x88/ZW04blcKl77iMESoWoxq1yg4rq91
         bupA==
X-Gm-Message-State: AJIora+uMiCFfVR+fodOWUo4olXcphCIBsGHOkvtZPQqIFkS+chOmF0G
        R3DPh74Nb3yCDbsgm90LR0m8l9WHF9Mw6g==
X-Google-Smtp-Source: AGRyM1t6UXVD+LJFLiumTBQ1UH4oWqirtexXfZOToprQudgOKXHuHIJBoJDZGrflt4qFX8gvCKC6dA==
X-Received: by 2002:a05:6402:4386:b0:437:6450:b41f with SMTP id o6-20020a056402438600b004376450b41fmr25035456edc.97.1656442823586;
        Tue, 28 Jun 2022 12:00:23 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 26/29] io_uring: flush notifiers after sendzc
Date:   Tue, 28 Jun 2022 19:56:48 +0100
Message-Id: <bb686710d7a9fb9d126e03f22d129f0034ae1e5b.1653992701.git.asml.silence@gmail.com>
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

Allow to flush notifiers as a part of sendzc request by setting
IORING_SENDZC_FLUSH flag. When the sendzc request succeedes it will
flush the used [active] notifier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 7 +++++--
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 70b1f77ac64e..f5fe2ab5622a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6581,7 +6581,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-#define IO_SENDZC_VALID_FLAGS IORING_SENDZC_FIXED_BUF
+#define IO_SENDZC_VALID_FLAGS (IORING_SENDZC_FIXED_BUF|IORING_SENDZC_FLUSH)
 
 static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -6685,7 +6685,10 @@ static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_ubuf = &notif->uarg;
 	ret = sock_sendmsg(sock, &msg);
 
-	if (unlikely(ret < min_ret)) {
+	if (likely(ret >= min_ret)) {
+		if (req->msgzc.zc_flags & IORING_SENDZC_FLUSH)
+			io_notif_slot_flush_submit(notif_slot, 0);
+	} else {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 69100aa71448..7d77d90a5f8a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -279,6 +279,7 @@ enum {
  */
 enum {
 	IORING_SENDZC_FIXED_BUF		= (1U << 0),
+	IORING_SENDZC_FLUSH		= (1U << 1),
 };
 
 /*
-- 
2.36.1

