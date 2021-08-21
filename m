Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7F23F3B41
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 17:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbhHUPyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 11:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhHUPyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 11:54:05 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538C4C061575;
        Sat, 21 Aug 2021 08:53:23 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so7900850wma.0;
        Sat, 21 Aug 2021 08:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T9hSEtjzfHSv5Qc6zennG3aDrXEe0nuk9SGx+JOGQnY=;
        b=HrJaMK4Qa5KJmEidFQ/Nm+zDbj3N9EamKJfns0LeBBwtr5CPG+z3PFQ8YZEHwojvIV
         JRG4tK3nvfWkIH8K9GCZAOb0wFZOJxoMRSdUT+vad4V6KriPh/6uZEJ0k1gMs1oK2N8/
         fnLX2scNdCM21m1ZEYqspQ291IS3vqpIoTG9Gal7Vqgt4R+0L1YdwCntLHMUmJO7akax
         wiftG0DwMkCJyK9ASaUAdkbT+I8rYLGz6GDz613SZyferf8TImI1pK+pahdfQa2p3hoD
         wDrwj2AHvnF9A5Xw2h3gMDTEXJ7QWOaaMIEy/5sipEnDYga0JgLJXVAmAbslM7fnrgvi
         fznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T9hSEtjzfHSv5Qc6zennG3aDrXEe0nuk9SGx+JOGQnY=;
        b=qEFJtPbPZJ2vqGrVeTGqyyzo7bXpkEJ8KQPzuBiLtYS3Ga01cJgB2L6h1VVGwaoyjI
         kiQbhO083Oi8Sl3RiEXhNnQfVvIEciIBunAFW471e4OKObt4rKHCVJCIXqIgDSgdPMF2
         NqIQ2tsiUrZx5qMQunJ2rhR1YGDqpziBMd7qtJS+jP0oTjUorWEbcwHeoqWHAaBc/49w
         XiM9xevkpgNOmD2hNo6ChscvaiXzKqEkViHfZTnuvP+8mnvucYBwJK6axA6tKV0Lj6E8
         KBZKPUQJZvWrHKkYLC+9j2+wKIr4QcAd5gK5IK1P0KCIq9TtmB6adtRZl3SJyaqAbGMM
         1dHw==
X-Gm-Message-State: AOAM533lIQL0ezQuTE/F3z8rWLY5g1zxSfge/ItUa1srl1rpvVfheHog
        AgyOrtd697/06FOXa1yjaqo=
X-Google-Smtp-Source: ABdhPJxLC0kr1QaorLsYm55zJ3hdxsXugMGNP+mxq85JYQNXbjeKzBVtc1RZitUtMdns/fBtNk6Lww==
X-Received: by 2002:a1c:29c3:: with SMTP id p186mr8905622wmp.22.1629561202011;
        Sat, 21 Aug 2021 08:53:22 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id e3sm9479554wro.15.2021.08.21.08.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 08:53:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 3/4] io_uring: hand code io_accept() fd installing
Date:   Sat, 21 Aug 2021 16:52:39 +0100
Message-Id: <8ac4c960937ee595545344c28b73c3ec9b1e8639.1629559905.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629559905.git.asml.silence@gmail.com>
References: <cover.1629559905.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make io_accept() to handle file descriptor allocations and installation.
A preparation patch for bypassing file tables.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b8ef5ac1f90d..a54994a4f4ae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4769,6 +4769,11 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 
@@ -4777,20 +4782,28 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
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

