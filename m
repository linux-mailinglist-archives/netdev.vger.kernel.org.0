Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43563EBA4A
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 18:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbhHMQo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 12:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237118AbhHMQoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 12:44:22 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00BBC061756;
        Fri, 13 Aug 2021 09:43:54 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so10089435wms.2;
        Fri, 13 Aug 2021 09:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NelZKyRIOnA4dGpeG33lwddD90VVcPtbBw8as+67pdQ=;
        b=pMGbJX2KgNHCeBUnxAsO9J5dTQ34bwvP7JE9+fORl7tgeh9h2uacIQ9rgWTDnwOIKR
         wQ3RmvEAq2qTu2FCWcgHFRAIV8KpEoP4S1sLXCmOyiricKEL+uXADqPYfupMfY96NAJw
         /0Q5sza2eBEd/6FiNN0hyRRBxXkpTzU2Vp8Ed02KA9APkIrd0Xr8+f2gtrhY7LBk8DIF
         lO75QwldNKzMY/TWiwf+2bMxcw6T8Hq8oZ3zNJRwpORyBcPqf+tufIa/t9poVUDszdsE
         DOAptjnx3luJkr7YHQSBf4UZvO+riyDmJaXVf+Daj+ZoPIzHjQ+kgiAXDgoCambOo4t7
         mU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NelZKyRIOnA4dGpeG33lwddD90VVcPtbBw8as+67pdQ=;
        b=eV0ctbL6ftFe5JgMtPtL720tX1e/F410ULPW41yDLNyGSOY20o/ofXJb7eqLG7MhwS
         y/F0ZRoF35ysW1D8El1EoZFfBzN/qk2QOva8DDm9PivqrBQOea6+Nw/TbQggB+3+Ehp2
         08HTIKCs/n3CyybUA3NY0RgJXfpXKzBZZF2aMjPTXuS0kY6C1KkCqhUhHNrLvMJRKshi
         AGwdcr/IzMn05LUZGcdcn7zEw7879wvvFH7lT2CKC9MMkMCYlkTYSCDqZjlO0OVU+Bj+
         PAqbjde3NL3RWSd6vGwnkjOihM/ZNX6nk13WfELqGh3M40s07ZwcoXeMmgZNkDAwTkQH
         ZKEQ==
X-Gm-Message-State: AOAM533H1W3XpIE2pwZTSxjgQhx4Qi+eTOIz9MnXBV0O4RaDc9qUItOZ
        xchUpjrHgHUvWmyXPNk/RiE=
X-Google-Smtp-Source: ABdhPJwLklC5mLfwRq9IGHnBA4JB7RU/Cb9lir3Gt0KFaponZBJJr68qMiG+8cv6lMCWJZ1J+GjGuQ==
X-Received: by 2002:a1c:1b87:: with SMTP id b129mr3450129wmb.80.1628873033531;
        Fri, 13 Aug 2021 09:43:53 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.210])
        by smtp.gmail.com with ESMTPSA id s10sm2495829wrv.54.2021.08.13.09.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 09:43:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 3/4] io_uring: hand code io_accept() fd installing
Date:   Fri, 13 Aug 2021 17:43:12 +0100
Message-Id: <72145792a5db2cd3511e45234a3b2f3302e69459.1628871893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871893.git.asml.silence@gmail.com>
References: <cover.1628871893.git.asml.silence@gmail.com>
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
index b4f7de5147dc..f92adfbc9a6b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4743,6 +4743,11 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 
@@ -4751,20 +4756,28 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
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

