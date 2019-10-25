Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90570E525A
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 19:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505891AbfJYRbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 13:31:41 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:38363 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502816AbfJYRap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 13:30:45 -0400
Received: by mail-il1-f195.google.com with SMTP id y5so2526361ilb.5
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 10:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xtMxYmqRKSbwDpEY25WYyVtGPb61T4kFCH3oEpXXy68=;
        b=eO2sEvBRfDw2BEa78HcquHbYUy0RhJZx4eUsUoRTxcYx8NzQ+73cAFHIAlT+BdJvSM
         RR8Zng9yyw7W34H3jsoTaueTKN8ZFTbuhDNY7Uv0XHv2SnVDrUTmDHtC+SvNaE9d0ve3
         4iq0/mbqiJ+O0NfwqTid1112TlmXnayjlpAdFmdM5D2BUhhEDehX6c6h8jIH950u3ZGn
         /yAUcMG0kANuUIiXPnqhrxqACGlG6eIVyp+PpjRqEyCPfJCDLLcypWKswqopy3+ynjAq
         W1aKTavU+7DSDLIbarMLXWYNjYTy+27+I6kK7e875Shizwvt0oR8AdErvNVjK8REwsKd
         e/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xtMxYmqRKSbwDpEY25WYyVtGPb61T4kFCH3oEpXXy68=;
        b=mPoDvf3I9eiMyfpczpqMaLL4QE6aUzQlgzdJ2ycX9oFovmvyhrOCc0ft1Mus/cUelO
         VgzGPzSiTNJGvnyoqbNYzdLUNvC45+zhCj4p5X24Iad+GCyY213IZmMVD95SnjfDNyvG
         dB5T298xzE7KbOiBceo0JdolkzcTgzXKXL9ujXnPOpiovwtoXEdS0KTdpw0/7I5QnkEP
         An7xlLlgn+e+T1ed8KFBIgj9LKaQvXZUjRZll0WXx2CJluMipvF5GidkVMwa3nqmY7JO
         7XIz5IuYTuN91+d7u0r2EJtGYaOuxrru8ojV5Gnm8aS1A5CwB6w8VUEwjGEQRICDckm5
         STiw==
X-Gm-Message-State: APjAAAXc06xMZ9yikwARbbmEkpp2il72DYtqAry75yIO3H8nHs6SmK1S
        pgN0ZDHaIKK4zxpbQShiCyn+Cw==
X-Google-Smtp-Source: APXvYqzLUoLBx6alLytHVjGHDF10wjNoUs8zmUqhKKGfDvC3ay9LiURfxPT3wAjapKuZrMIKv7ZwPg==
X-Received: by 2002:a92:5c4f:: with SMTP id q76mr5363295ilb.158.1572024643144;
        Fri, 25 Oct 2019 10:30:43 -0700 (PDT)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g23sm323674ioe.73.2019.10.25.10.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 10:30:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jannh@google.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: reorder struct sqe_submit
Date:   Fri, 25 Oct 2019 11:30:34 -0600
Message-Id: <20191025173037.13486-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191025173037.13486-1-axboe@kernel.dk>
References: <20191025173037.13486-1-axboe@kernel.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorder it to pack it better, takes it from 24 bytes to 16 bytes,
and io_kiocb from 192 to 184 bytes.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 13c1ebf96626..effa385ebe72 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -260,10 +260,10 @@ struct io_ring_ctx {
 struct sqe_submit {
 	const struct io_uring_sqe	*sqe;
 	unsigned short			index;
+	bool				has_user : 1;
+	bool				in_async : 1;
+	bool				needs_fixed_file : 1;
 	u32				sequence;
-	bool				has_user;
-	bool				in_async;
-	bool				needs_fixed_file;
 };
 
 /*
-- 
2.17.1

