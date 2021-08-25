Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8103C3F7452
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240520AbhHYL1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 07:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbhHYL1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 07:27:16 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD26C0613C1;
        Wed, 25 Aug 2021 04:26:28 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u9so974668wrg.8;
        Wed, 25 Aug 2021 04:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cBkEN0P8k5mEHRmkbodUOJHAKqSoKNmp6ynbLEfPluU=;
        b=P+TyQnz4XSV0F8eL0RvmM8DBJSOnwFWa3CKhAo9JeRT4DhKzPon5PlkJt+jCbi7iKE
         Mqr4Ohz7mbwJulwVHWEjUxAQlKNpGYAB4FmG6kdYoeup8itKw6V4SWHplEUbTgcbnwX7
         EOTLS7mGLQdcV9DIWQFKEeCzAYnw/CyJe/4Mz1CNfsxJWyCvhAAGK4GqOnWGlIVWyN5D
         KGNdUnn2BE+gbeagTo3NbX4YEJ6fG4USAV9tBgZhHnmwHn5Jp79pLYmuzQv1FrfBgOd2
         6JKWAzxUmP7uuKCivBoTDAGoWHaTZ8Pe4Uq4uY+BKebEmO16XlofkES2aMmNYFxoZsAI
         Vg4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cBkEN0P8k5mEHRmkbodUOJHAKqSoKNmp6ynbLEfPluU=;
        b=B1hLw4Pq844c+PUEug29uVTGkzISBOdy69HE3h5w8nBBkq8fiBsagII44njB2b50mQ
         nCXcEgUxAL2c9oJaJzXpklQk1STsoKGkO43GUgxeVBkvceuOHpItjdF/lVk8KD6LFFTj
         /oD3LEIUY7nbzjjV0SYzShQzKa1ZZ0ARgPKgOXyU+MSnLhUrDIC4yHAU3JzYv+HTYH9J
         G+OUdchmBHsRBpzQQ1/KKENieAgerPqDjsLKLac30dNGQzMIETYfgnS+McITZf31JRbc
         bKnUOR3HQVif3Cxccl64sgeyC36MqIoETcD6C55mKI5HitLfH/7loQ1+HvZf7ggslqeb
         19fA==
X-Gm-Message-State: AOAM530t6KBhhH4FmCO/wgLpxC9FSKYQ8oc28vA6jr6y7YUWi09JYhtM
        +ucqXmH9qmveOdcz5xKMmVw=
X-Google-Smtp-Source: ABdhPJxgEsN1RiTYPUz2QS4YIxv0bzCKfWT5uPK5tpDUtVP0zIUHCUs8taPQeuOaQnEDgzWrnYY55Q==
X-Received: by 2002:adf:f984:: with SMTP id f4mr22285152wrr.331.1629890787591;
        Wed, 25 Aug 2021 04:26:27 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id b12sm25113730wrx.72.2021.08.25.04.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 04:26:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v4 3/4] io_uring: hand code io_accept() fd installing
Date:   Wed, 25 Aug 2021 12:25:46 +0100
Message-Id: <5b73d204caa0ce979ccb98136695b60f52a3d98c.1629888991.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629888991.git.asml.silence@gmail.com>
References: <cover.1629888991.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make io_accept() to handle file descriptor allocations and installation.
A preparation patch for bypassing file tables.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2ef81cd6a0ec..a3b1a50e2537 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4809,6 +4809,11 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
+
+	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+		return -EINVAL;
+	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
+		accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 	return 0;
 }
 
@@ -4817,20 +4822,28 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_accept *accept = &req->accept;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
-	int ret;
+	struct file *file;
+	int ret, fd;
 
 	if (req->file->f_flags & O_NONBLOCK)
 		req->flags |= REQ_F_NOWAIT;
 
-	ret = __sys_accept4_file(req->file, file_flags, accept->addr,
-					accept->addr_len, accept->flags,
-					accept->nofile);
-	if (ret == -EAGAIN && force_nonblock)
-		return -EAGAIN;
-	if (ret < 0) {
+	fd = __get_unused_fd_flags(accept->flags, accept->nofile);
+	if (unlikely(fd < 0))
+		return fd;
+
+	file = do_accept(req->file, file_flags, accept->addr, accept->addr_len,
+			 accept->flags);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		if (ret == -EAGAIN && force_nonblock)
+			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
+	} else {
+		fd_install(fd, file);
+		ret = fd;
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
-- 
2.32.0

