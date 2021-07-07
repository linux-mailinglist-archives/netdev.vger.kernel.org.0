Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC00A3BE74B
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 13:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhGGLnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 07:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhGGLnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 07:43:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBEFC061574;
        Wed,  7 Jul 2021 04:40:20 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t6so2667467wrm.9;
        Wed, 07 Jul 2021 04:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SjCPjtxsD7x8AhV/ce/R0ldaWbBbErIon5fucvDcAwE=;
        b=ueaVWLeB2tT5vn1d5Ycrggbk01HiU0EeCp6+WRfAFR7CbfGVsoNdg5qMI2/xxukzdt
         taZcicT/jA6fWn5me8Q3RODQyvPB3Mdiv3umhpbQ42sTlzvVJaPkBs56xJ1ESCKrAAMO
         b2++HLpJaEv4hflgKY8Z9YUp6QVZWXys6qssFIF6d1o/u8i3lH20zcEboBWc8MnVfSLa
         XBYx1KC50Zq0JeZic+F1OiVzv5eX6TkDNluBBz/VDavmu7XHDr4I63klnQ2D/JCmzzlS
         VTdsvhjMdCC6UQPEyirHcKuTlU9xXN7WHO/D5dM0fFxbxKL7f+qoEV8V//+wT0rmwQgw
         EKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SjCPjtxsD7x8AhV/ce/R0ldaWbBbErIon5fucvDcAwE=;
        b=qrmrxnHNeJPv9hRF5ziS4rh1g9e+FrKIdr8gIZBM8Xf//G49zUi9y4cdiKJxzoI5X9
         0GO0027K0E0aciq9mmGZnZs7XTi2xT6RTHz6QOTlnvyQXFcJBFJg5D7tLNmnDetXpyaQ
         IT6bBKkvp9bFe9Z0V2XUyBADsgrXlQA8mx2YU9o0WQfWGW/U+uVZVt/RXVGi1t/eQCpa
         kFPNxVZzLxtMY7vEZ00p5cHZVt4OVPt4XtKVZjwXLFhNbsmox3OHRRjjOR/eKBEn/mUn
         ydXZqVLTwZ2DBurb+yr0AobJjmUKfypEGa0lgBsV8wL20LVQcLTyNVTHAM2QwdC38lLi
         Qxlg==
X-Gm-Message-State: AOAM531ZTLNoOLmzwF4RlDT8N+sRS2cT7X/2KXz6/JhKLM/Q10ojlJtM
        csHdSDBVmt6T4VDIDZKYPjU=
X-Google-Smtp-Source: ABdhPJw5kfrSS+ALXPvamQOvU6udjvmtDg48XjGbJbXG1PnD7ThQuRncHqaYXRdUk4VU2ZO3yKwJqQ==
X-Received: by 2002:a5d:4001:: with SMTP id n1mr27826764wrp.159.1625658019235;
        Wed, 07 Jul 2021 04:40:19 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.206])
        by smtp.gmail.com with ESMTPSA id p9sm18415790wmm.17.2021.07.07.04.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 04:40:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 4/4] io_uring: accept directly into fixed file table
Date:   Wed,  7 Jul 2021 12:39:46 +0100
Message-Id: <1a57d821f6f3c35aef26316febe70e16f39f7c7d.1625657451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1625657451.git.asml.silence@gmail.com>
References: <cover.1625657451.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As done with open opcodes, allow accept to skip installing fd into
processes' file tables and put it directly into io_uring's fixed file
table. Same restrictions and design as for open.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fd0dcee251b0..f7db43bf7dad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4675,14 +4675,17 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
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
@@ -4695,28 +4698,34 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
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

