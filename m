Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3EE3F7455
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbhHYL1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 07:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240369AbhHYL1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 07:27:16 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6886C0613D9;
        Wed, 25 Aug 2021 04:26:29 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m25-20020a7bcb99000000b002e751bcb5dbso4318296wmi.5;
        Wed, 25 Aug 2021 04:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EkgdpcPWaQPjEyyP5RTALMN71ozX4FyAQ9zUilfKv9k=;
        b=ombk6WXWAbKL5ZvqCCbUUAAy0f2OT3fScYtcHpNvJZzYHP1DPeenonTVtjiLP2K1cG
         hOBd/wgK0pBfK9e4+qJcfSAx8iH89OPpl1X46Zc+rzZ10Mf4GSxSGEgLDj7DF+OYPE5n
         H0DnF6N+p1XPFsXakfrJk72CqdSWBwTkrjzCPFHVWOXVsEBsPtpuWFdaEMKKEWogXspp
         AscfqXOrYLL/0Sqa9yGMisUNEXKmmGkbAOgURrwf3r8BJYeNNmHeip98e1/bBSCSgbsW
         88Vfu0818WEo5Fxx+I1rAkgDlTKniOzXn/pirgwoqADH9M0bFsvgMOgT+0e5yF+TTp5G
         RRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EkgdpcPWaQPjEyyP5RTALMN71ozX4FyAQ9zUilfKv9k=;
        b=Jqk/CbSSWwasGcVVloxdlLSN4Ji5iKuLUfc+xeLAAvN9IE2VBUWUt/6UBQ2MsjTNpp
         EV/7BvEMHc5Be9Pc4NgxiPtpenHbdj8fRuKaGmAxea+ZpJKXkD2Ru8KxIwc2g38BGtAh
         k9s/AOmO8ygvlvaN/gCfrb3UwuoWbBuh0QvQ9ZyJs6N3ganvla2kA2KDaMohiwNPOkvm
         /Pc1pVlt1E3Skpq7Nijf0LES0T3cG9oRqgn27Tt5T45l0UgWiOaW1/J8cA2bwD2yIXDJ
         MnGyqGoEjQFVEj0eAsfwl8HbE0Cie48HVs4zuZyi5A43Dy+F5gH+GqkWGnNzKlPBtUHR
         5eyA==
X-Gm-Message-State: AOAM533rPSLlVOVAGTnk5c3UBnZa7PjdpY4hl3D3w7GO8ufaN9YKKCoW
        XR7r7grBbkcBne9sSc6Dyq8=
X-Google-Smtp-Source: ABdhPJwPZRSGH5av6ne3wi2OiigUm3ipOBRr+qdPfBcoqtVkb/BaOWeTdifSQ/8S0MdMC2nto0+KPg==
X-Received: by 2002:a1c:9acc:: with SMTP id c195mr8967002wme.69.1629890788478;
        Wed, 25 Aug 2021 04:26:28 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id b12sm25113730wrx.72.2021.08.25.04.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 04:26:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v4 4/4] io_uring: accept directly into fixed file table
Date:   Wed, 25 Aug 2021 12:25:47 +0100
Message-Id: <6d16163f376fac7ac26a656de6b42199143e9721.1629888991.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629888991.git.asml.silence@gmail.com>
References: <cover.1629888991.git.asml.silence@gmail.com>
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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a3b1a50e2537..95fd7dc7cbe6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -514,6 +514,7 @@ struct io_accept {
 	struct sockaddr __user		*addr;
 	int __user			*addr_len;
 	int				flags;
+	u32				file_slot;
 	unsigned long			nofile;
 };
 
@@ -4802,7 +4803,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->splice_fd_in)
+	if (sqe->ioprio || sqe->len || sqe->buf_index)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -4810,6 +4811,10 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
 
+	accept->file_slot = READ_ONCE(sqe->file_index);
+	if (accept->file_slot && ((req->open.how.flags & O_CLOEXEC) ||
+				  (accept->flags & SOCK_CLOEXEC)))
+		return -EINVAL;
 	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
 	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
@@ -4822,28 +4827,35 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_accept *accept = &req->accept;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
+	bool fixed = !!accept->file_slot;
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
+		ret = io_install_fixed_file(req, file, issue_flags,
+					    accept->file_slot - 1);
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
-- 
2.32.0

