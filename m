Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6D04639D7
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245430AbhK3PYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245094AbhK3PX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:28 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D5EC061574;
        Tue, 30 Nov 2021 07:19:31 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so15035140wme.4;
        Tue, 30 Nov 2021 07:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QIxalKscV4CnpQCTwHXr7wtef9S8BsdHTlsrNhfGWA8=;
        b=n4yfrpbLbKFNvBlR8u1BtiNJEHRZi54HnhAXAPI6A9TsECywc7cEIbOwoj44HkOYz2
         k350sUS04ihFLp4KIqji9wf8RXcy9834pZ0TQ4zZ0qfc7B6bqB2jOzPk9Wdb/g8s2haC
         aivI1xAeHa07vFkc6htrT1eR6Yy2Twh8C4Ukq08zEMjXD6UGCikuLcTFk84ioIWyKGEZ
         9fPy+28Bh8+BvxPnNbgD8pDgJF67euZ/wqMxT24oKuhpnx6tHTnlLEFJbe4OdaLJnrga
         4HPhxwl3chDAGeGhn5mLKDZsYEHX8hAR+MieAmzTIpTDD3YYwqUNQguNPirvM6NgnKrh
         d32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QIxalKscV4CnpQCTwHXr7wtef9S8BsdHTlsrNhfGWA8=;
        b=W+lpE7P/06WaIT/s30qrkvb3yKmMUwifC7yDOF9JQQ7IPFh5ZmPjbOgFPuhI1RZrV4
         tT4AVSaA3NeyZ1qjp/SMtUBSMCB3VdF653G7L5B1+f0dILyfb8/RtWepsG24id4+RLTd
         ka0Y9PeiB00jQZKIiFhwmJbC1CRvhAys1POUwNgGx4MfpKmd9hWynrWp8XqByc2wi6er
         wBtj6ZRSjPWeQgVoIPiZud429EB91nY8/7KtoIaACLKt87whTBE/PxkV8IJ73FTpq6Rr
         WNPov8w96zdJsQN+xSTdLz88yutVDJSXpy2cZ6aeOkOsGcR5fYTAebjEIJNXB9ROEpBc
         JLrw==
X-Gm-Message-State: AOAM5318I0qjSxwD4UJk4MlTGIKR5pZAPkw1IEc11cRWQGY81KJDaJyo
        gGrVUjWKjlJ/8tpi9NuN6ERl5PNmLLw=
X-Google-Smtp-Source: ABdhPJxXlLFPGOmKYBW0swfM1LNYnW+7m7YlhMVltRZdQrtoIZctYEpzELKK8TnfbH1HdFr7JWVeJQ==
X-Received: by 2002:a05:600c:1d06:: with SMTP id l6mr14948wms.97.1638285570016;
        Tue, 30 Nov 2021 07:19:30 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:29 -0800 (PST)
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
Subject: [RFC 10/12] io_uring: opcode independent fixed buf import
Date:   Tue, 30 Nov 2021 15:18:58 +0000
Message-Id: <560cd5b8469874d16405bf4621d4336fad991fbf.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
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
index e1360fde95d3..bb991f4cee7b 100644
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
2.34.0

