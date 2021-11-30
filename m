Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0028D4639E1
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242600AbhK3PYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245096AbhK3PX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:28 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1FCC061748;
        Tue, 30 Nov 2021 07:19:32 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m25-20020a7bcb99000000b0033aa12cdd33so7898700wmi.1;
        Tue, 30 Nov 2021 07:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sz0U0TnMDqzg3fATGdUww/ooCVGg4JrbsKMAkl6AooM=;
        b=YGM0vLPzRDvFDCbOBrI/Qn9dINi5sqHIH4bX2tjI4VsNz/J2v94ogyGPCpnnon2FGQ
         yoKtwcx2Q2GqGroFbt7hb7Xhg4ghwj45wd0H802VN6e0gqtw+xcUQfX90g+LWQ1Ab86K
         4OMcU9X9KKKfo7uEYGaNgsf19VWd8L1+dOlzRYlBwOzXVeLob6WrjnIsypHABPLfV8L5
         JkQlbE4jhMyBY/uVp2BeJu7+JWedO7HejdprgbRvlM5ZI94addpcvbUWVNi4c+cUtPsm
         iR60lrg/SLAfyzjyG5dDfsf2SGRRPfm3zpUiJKam0qthBWvys7PWzuLY1AvkuZ1sd1p3
         qjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sz0U0TnMDqzg3fATGdUww/ooCVGg4JrbsKMAkl6AooM=;
        b=CbLxcp+UTvxMTtngOeaGq8Xx5PBGae7yZ+1/K/0zFFTOfU23hYXWjGSqWM6UIBIT0T
         wbv1PLA47wmef6+/YDZAC9tsuO6J3Vlk3JKQ3L0useis9kxFG2w2Kh3+rjepPXPpXzQY
         XC/1g/UAPfc5teEkuRwUCwr6KRfTsBmfItBnPzHIPlN9ChmlUDt2faL2y7eoBkUpyDY3
         QWKSFo9hDkVLLm+B7rrPkyWS/YvdohIWBFQvuVv+YnufMVY+qvUtlUtwBS1o4ef8LkXt
         wDLg9bfZjqbRQVgCSpXN0iCxn5SdZJg403qsEw5HVER8k0jnaHmx5zHyh6ln1ImeCCTR
         3TVQ==
X-Gm-Message-State: AOAM533ARYXUDaepLc8SE1AmoQpEPutiS3A6wlJcN/Pur+qqHNdpXfS3
        aXQRRbkX2gebsQqjHo7Qp8hoCmAa9xI=
X-Google-Smtp-Source: ABdhPJxbvOD0dN4fxyx/1eBrykrogL7u3dD+bXaXMgZonAjlZHnrLKVZdIYG/vokMZDn2bU3HBiy7Q==
X-Received: by 2002:a05:600c:190c:: with SMTP id j12mr9882wmq.117.1638285571117;
        Tue, 30 Nov 2021 07:19:31 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:30 -0800 (PST)
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
Subject: [RFC 11/12] io_uring: sendzc with fixed buffers
Date:   Tue, 30 Nov 2021 15:18:59 +0000
Message-Id: <962f2f1c524d25356cdda188070d8653ee28f012.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
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
index bb991f4cee7b..5a0adfadf759 100644
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
2.34.0

