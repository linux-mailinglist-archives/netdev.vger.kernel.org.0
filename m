Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B15447C309
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239589AbhLUPgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbhLUPgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:20 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C24C06139B;
        Tue, 21 Dec 2021 07:36:11 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id s1so27794706wrg.1;
        Tue, 21 Dec 2021 07:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e3GJ/1g8n4eGzQHYyUbOm+L11c82sD3eIdcK9sXM3cs=;
        b=Gf0c7lR7X3eg4NF/QjFVp4loJSvohG1TjxVrgzGtzyKlcx+BWv4xzPYSWIpsLE3EHq
         0cPxnF2jF48aPulfzCnKVTbT204anUebWv+8g1al26o8B+GKDuOoAB5XmKH55QhPPSpo
         0P5yDya6skYWF+hh4CWjhqB4yLO3UpqYf1YUBdQKwuPkRFLdBtLHzAFX4yyRLuoHkEAj
         2/T8zbsn4bdvddy+Ha79j1T1+v4KnK9H+V4nuvQtOZHIZZAW979hZtnJnSZSSjkNedHl
         C4bYnCzsgGrjW/hRHK3KrzRWgCWNXTTM3tACW2a0yS+VniXMkuzWqqF/huRK9NJ3tQSp
         CW/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e3GJ/1g8n4eGzQHYyUbOm+L11c82sD3eIdcK9sXM3cs=;
        b=dstq1hQudy0CtuVia6KeQuXYb9bjLn3GLvJcybaM7Q1WEsdOWeIwB21dJYVeF9d9Xj
         jhoGIXGqdYSV1FO5dwEwlfPq0V62OyRV48j8OGMiQHzxs8U1krNNgvMii/itE9yfH3Zf
         tRb8VFR8ZMTb2lG3lZB2k0aavCKh6VratQdKbMFWTmEqVOMF8eQKRvhgQjThjcpERImo
         G/xS4Wkd/qKUfCxpzaaHJxYhJoDrnN6TkCsd37ABF40ctQdLhpzmSOEfzB8M8XOmrSJB
         +i0J34GRelemOGMGEgdNJBFOX1y/3z2lUZFthUl2nejkkceYmy+o1ihnbQjYCJKijIYZ
         bfeQ==
X-Gm-Message-State: AOAM532y/+lGvbd+7nt6IG3iJi0WKJ7ZfzRwv7eT3XHq3zuR6leoudMr
        z6otZrF0b9i4OModaKaethIgPeaRPOg=
X-Google-Smtp-Source: ABdhPJxtkeDI3RwrW+z6fOVZ5f+C+Xe/VX2k0cpzAAasKiwrcmSKak1exY831XmeeioiWotsOVwnAw==
X-Received: by 2002:a5d:64ee:: with SMTP id g14mr3081526wri.52.1640100969695;
        Tue, 21 Dec 2021 07:36:09 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:09 -0800 (PST)
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
Subject: [RFC v2 15/19] io_uring: sendzc with fixed buffers
Date:   Tue, 21 Dec 2021 15:35:37 +0000
Message-Id: <ddc564fc92abfd13bfac2f6d9aa118ac15e8f078.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow zerocopy sends to use fixed buffers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 19 +++++++++++++++++--
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 40a8d7799be3..654023ba0b91 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5048,7 +5048,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-#define IO_SENDZC_VALID_FLAGS IORING_SENDZC_FLUSH
+#define IO_SENDZC_VALID_FLAGS (IORING_SENDZC_FLUSH | IORING_SENDZC_FIXED_BUF)
 
 static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -5078,6 +5078,15 @@ static int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->msgzc.zc_flags & ~IO_SENDZC_VALID_FLAGS)
 		return -EINVAL;
 
+	if (req->msgzc.zc_flags & IORING_SENDZC_FIXED_BUF) {
+		idx = READ_ONCE(sqe->buf_index);
+		if (unlikely(idx >= ctx->nr_user_bufs))
+			return -EFAULT;
+		idx = array_index_nospec(idx, ctx->nr_user_bufs);
+		req->imu = READ_ONCE(ctx->user_bufs[idx]);
+		io_req_set_rsrc_node(req, ctx);
+	}
+
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
@@ -5101,7 +5110,13 @@ static int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
+	if (req->msgzc.zc_flags & IORING_SENDZC_FIXED_BUF) {
+		ret = __io_import_fixed(WRITE, &msg.msg_iter, req->imu,
+					(u64)sr->buf, sr->len);
+	} else {
+		ret = import_single_range(WRITE, sr->buf, sr->len, &iov,
+					  &msg.msg_iter);
+	}
 	if (unlikely(ret))
 		return ret;
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ac18e8e6f86f..740af1d0409f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -189,6 +189,7 @@ enum {
 
 enum {
 	IORING_SENDZC_FLUSH		= (1U << 0),
+	IORING_SENDZC_FIXED_BUF		= (1U << 1),
 };
 
 /*
-- 
2.34.1

