Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD36A47C30C
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbhLUPgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239428AbhLUPgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:19 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EBFC061398;
        Tue, 21 Dec 2021 07:36:10 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id s1so22327014wra.6;
        Tue, 21 Dec 2021 07:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X+6VtJkR3VMuMq3+b2gwsMV704hlEufeWq+iIvQzNDs=;
        b=TSHWX7NDcSGSfQEIvmvElnqi946tL+U/oVHP114lPaKADFyR2dvWkPBoQUT9Xmr53a
         /ja3U+Z7JYCNmR9tMw4AajR7zDVEjmiizjRIHaJwdE+pziRSF+ItBY1qkNd5AMjEZH/K
         eJVRI0zPmP3ApLN64BTjADvEK5Q/G2BYtYhOT5KxFPjSHVlmLAXDZdHYzwKfUtztQkpX
         tvpBBIlG3C0xKS77t55cctLW6v1VXgC7QEXj0uK3/YD3FJc8qc1JKRXI8RqCZ8l5CEtl
         pz+9Kdt3w3Zxv2BQAOZ13QBF1ooy9ErLj6N56XAoAArMdXPQwRpFqJGm/uvKgX1Gysre
         51HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X+6VtJkR3VMuMq3+b2gwsMV704hlEufeWq+iIvQzNDs=;
        b=KCB3dPueg2D2paCiJymAbuMx7ArmbEZCfuMf9iOPrmiKXcEEWWkXgv7XwWON7u0Cxb
         5ziR29cI3qKZbBSdtGqtk1bQc4SvhIk+tmxvGNgCZ3/wJ9/9YNcDWQv/nj0S0oCsQyIJ
         Tg3cCdQSbMw5EWtXx4u8lc5RQ9qV0Nn6bctvqguwVv2FX/LrxK0liRECMDuwzxY8Xjfu
         EUmiDPEzTzJehk2H/k4QtDkc+TO2DPLAqSTbV54XVadUV2nP9FrQpK607iUyR2NjKQBO
         ELr36M941cAvFe2dpp0Gl3SNgjhdQ8PT6oa+9KDfs1EW1621jRYKXGPlpKs37rRh37Jv
         TvOQ==
X-Gm-Message-State: AOAM531N6y9JAKh+QESLWyXMhDZH0E80EBYejeEW88GtXn1UyQPy+hkR
        19pq6G9vcZVFWhWoPpB4OkQXPZeMcRM=
X-Google-Smtp-Source: ABdhPJz9wmIfpBK627vI8d2owN4QYbpLc3jwZ3G9EsyEV4A22XcwN0QmF5WhpmT1GNKyBBxQn51Yzg==
X-Received: by 2002:a5d:64c3:: with SMTP id f3mr3003911wri.295.1640100968525;
        Tue, 21 Dec 2021 07:36:08 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:08 -0800 (PST)
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
Subject: [RFC v2 14/19] io_uring: opcode independent fixed buf import
Date:   Tue, 21 Dec 2021 15:35:36 +0000
Message-Id: <014cf9d888bb9531742ba53ecabbf8e586ac6f0b.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract an opcode independent helper from io_import_fixed for
initialising an iov_iter with a fixed buffer with

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ec1f6c60a14c..40a8d7799be3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3152,11 +3152,11 @@ static void kiocb_done(struct io_kiocb *req, ssize_t ret,
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
@@ -3225,7 +3225,7 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 		imu = READ_ONCE(ctx->user_bufs[index]);
 		req->imu = imu;
 	}
-	return __io_import_fixed(req, rw, iter, imu);
+	return __io_import_fixed(rw, iter, imu, req->rw.addr, req->rw.len);
 }
 
 static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)
-- 
2.34.1

