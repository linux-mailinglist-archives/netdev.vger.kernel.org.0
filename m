Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EDD3BE74A
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 13:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhGGLnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 07:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbhGGLnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 07:43:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7530C061760;
        Wed,  7 Jul 2021 04:40:19 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k16-20020a05600c1c90b02901f4ed0fcfe7so1468432wms.5;
        Wed, 07 Jul 2021 04:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8XU7B8vZrtAByElCUR6Aa9OSdefIZetqBITr1MgcSIM=;
        b=jzML26jZSPEDlK4vRBPKrqhry8GT17/ThVj1R/38LRujFXZKeBbutZ5z4t613EYbTn
         0at5+Wtt2FrSgyXZf/1LiS2Bv+FN44MBBif/9dgfD8bQFuudppKtHuKtyVCgM9Z2gJhd
         EmWJ+5aTeyW2v0Qw9w7cXon+kdTzFNns3linnKx6LjnDt3JNgfO1vv4Phs+pfwNcHf6e
         /aHABi97+q1OnWvzsIMO62j27xvKUrtXdZAGXiviQKpnP2Z4KDEzFeHsHTDbnNMNAg5x
         Mbo/a4lK9vTBqZjj8S25RfoKYJ4BUUomAdJ/kf7QzMBDDXtv3ZN98wdzzdPX1Ypaxjzv
         gkVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8XU7B8vZrtAByElCUR6Aa9OSdefIZetqBITr1MgcSIM=;
        b=Y42gWr8bLXW66nOZDFvH5bnI4vUUkqpggE4v/wCblPmBcJXFT223+8muJcSvoX7qHa
         p5PCnu+j0PRR92G9RzZZQVxi6sm7X3KN8Mn3odgq7aFfyHIiAUWpFDWyLO+D6X5T85na
         LMc2hFJRWJ2XCXNs9RhB7lNbHq4cjp74BKqheWsCXyhlyfVWoEaD+0MEi5bODimkH3se
         mNU+n5FJIKuufUP3RC/jaIFcjeUiu5SXYfKaus2R73O06BEqhBV97+32aUPwf8Y7ntr5
         SbVZehItcLiQ8J8DVlidorPcyCPGmOegMFUILm4Lp4iOnX2WiKE4uqWgdFGob1tuMU/v
         3K8g==
X-Gm-Message-State: AOAM530LKkfZ2snfk+slvzVMfqzjWAIllgu1YaU71iFDzo5H4DzlXjxg
        oY0ich0Mn972us2M8BVAWc/mbVNMrBPkcg==
X-Google-Smtp-Source: ABdhPJwq7AuciAOEjX+2BD1LyauREQYtt61pY3XWv3ssIwpl1HbxDUnwjY+L1OvaforSiPd+wdB9/Q==
X-Received: by 2002:a7b:cd88:: with SMTP id y8mr26675587wmj.8.1625658018430;
        Wed, 07 Jul 2021 04:40:18 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.206])
        by smtp.gmail.com with ESMTPSA id p9sm18415790wmm.17.2021.07.07.04.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 04:40:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 3/4] io_uring: hand code io_accept()' fd installing
Date:   Wed,  7 Jul 2021 12:39:45 +0100
Message-Id: <4c5fd2618a3e9ea6f2eb4ddce9eec7a3391319b8.1625657451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1625657451.git.asml.silence@gmail.com>
References: <cover.1625657451.git.asml.silence@gmail.com>
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
index 17d2c0eb89dc..fd0dcee251b0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4682,6 +4682,11 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 
@@ -4690,20 +4695,28 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
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

