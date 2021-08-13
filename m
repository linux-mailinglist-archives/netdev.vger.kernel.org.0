Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3673EBA4C
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 18:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbhHMQo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 12:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbhHMQoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 12:44:23 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36EAC0617AD;
        Fri, 13 Aug 2021 09:43:55 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r7so14188157wrs.0;
        Fri, 13 Aug 2021 09:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KGUf89VstkMW69bAYZr9iyqMebO2WnyTgQSpQt32rdk=;
        b=Nke1JSVLr4L4GXr63jVCc9h5JkTOZ+BeTR0rq2ONhwX5DkN10gSKNtSJU9mAJHldGK
         Cjsmk+Wdn/kYKpeuhi4U5Gl9aJAYbqC13cfN1U/gDDv7CJrI2u9hiU6JwpFAxxC3Q82f
         TTVWBDUKwoTvruCeOmrNxNrC+LE/4Sc+7s2oyvSVI5pkeA9Gdaa4qbcKnOT3XnaoDoKF
         ma438YO9zIC0Rj3/RS3pFY2V4At+RqRS0NZwhPb34ju93WmQ99n8OY5OuvbZCkaIV6Ku
         hwS2dOunq9g9Er+fNWaDa0e1ydZhyakYx8a2TD4x5NngUwU+DQz39uphJnNRtjIwH0yb
         Ah1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KGUf89VstkMW69bAYZr9iyqMebO2WnyTgQSpQt32rdk=;
        b=m7Ht6A3YDkqlsraBxKBs0keCj2ay595lQgLwtC94p8ebMK6RNUxkE/ghbicHr7WaaV
         GK37xTt9//OWbZgxsClKxyJb7mYmFj9kRnU7M43oDkb1dJPW53J35//fM2l0xYCgCJsZ
         ZUS14ydxfX2jtrASEDEzEAMQSrk03tTLNY1pkPDClOGzhNS7R655tbYIIdsTWaZz6rc2
         oruHYVyXKxBK5YOoTb2EviA4fcva2Dh1k7IgPCSVHFNdW+X/QQ4mS9hv1yJkwGExhfKW
         YPVvRbUlB4Orrx9BJ2J8anDVWCnDfWe5ghElgs6wU72nJTRquvMohIT49cbwDhygo0jM
         hgMg==
X-Gm-Message-State: AOAM532t60Jyhu2dNkR0WHSPpP8aOJruD9J895WkESLryhmiLwy5FBGp
        nr/hiokkzMWsEhE8zMFj16FNji08pDw=
X-Google-Smtp-Source: ABdhPJyXDhiUH3fMG+2Ci4GnXD3FELWqG6MpVUuan6xzGoz5/bsaQI65YrKshWpcGocHOQ+JzwC+Gg==
X-Received: by 2002:a5d:4b49:: with SMTP id w9mr4276354wrs.242.1628873034660;
        Fri, 13 Aug 2021 09:43:54 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.210])
        by smtp.gmail.com with ESMTPSA id s10sm2495829wrv.54.2021.08.13.09.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 09:43:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 4/4] io_uring: accept directly into fixed file table
Date:   Fri, 13 Aug 2021 17:43:13 +0100
Message-Id: <eeeeea2beb47e0debfdf8a19fa1c7cdfef092fb6.1628871893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871893.git.asml.silence@gmail.com>
References: <cover.1628871893.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As done with open opcodes, allow accept to skip installing fd into
processes' file tables and put it directly into io_uring's fixed file
table. Same restrictions and design as for open.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f92adfbc9a6b..0e6189864d12 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4736,14 +4736,17 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
+	if (sqe->ioprio || sqe->len)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
+	req->buf_index = READ_ONCE(sqe->file_index);
 
+	if (req->buf_index && (accept->flags & SOCK_CLOEXEC))
+		return -EINVAL;
 	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
 	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
@@ -4756,28 +4759,34 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_accept *accept = &req->accept;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
+	bool fixed = !!req->buf_index;
 	struct file *file;
 	int ret, fd;
 
 	if (req->file->f_flags & O_NONBLOCK)
 		req->flags |= REQ_F_NOWAIT;
 
-	fd = __get_unused_fd_flags(accept->flags, accept->nofile);
-	if (unlikely(fd < 0))
-		return fd;
-
+	if (!fixed) {
+		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
+		if (unlikely(fd < 0))
+			return fd;
+	}
 	file = do_accept(req->file, file_flags, accept->addr, accept->addr_len,
 			 accept->flags);
 	if (IS_ERR(file)) {
+		if (!fixed)
+			put_unused_fd(fd);
 		ret = PTR_ERR(file);
 		if (ret == -EAGAIN && force_nonblock)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
-	} else {
+	} else if (!fixed) {
 		fd_install(fd, file);
 		ret = fd;
+	} else {
+		ret = io_install_fixed_file(req, file, issue_flags);
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
-- 
2.32.0

