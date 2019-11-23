Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0532B1080CB
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKWV1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:27:21 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39419 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWV1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:27:21 -0500
Received: by mail-pg1-f193.google.com with SMTP id b137so2847667pga.6
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 13:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UR0UVLJ/IUMWn5l60pc0zwFWn8/sSH1s224oij3hpAM=;
        b=yU1tw9usSS8pHAUxiyMghvfPl9agwLDQlGDGDrZUcnwFlxNbugiJLyFne8oc8OA++R
         toBQmjX4ZkL8k/TNT6DfFyGIW71oAVMEHy7zIC/KuPxxWP7p49dFpxSFRqLgV2MFLbCH
         ugZo05HKbJQJdTRNk0ebtbj4dbnVetxGYu9M+c3mIXgcZchd+i6oQc0b0OA8JUVRa4Tm
         /hhSVcn4z7YzH/NwbI3M1Ai7CoF7IRFVfQJESSZEao+D9TYNKdeTeFs8Pb0vuCiHo8pz
         AxPBK7i/4G08ndlcc67b3qESSGRDXqsJSvXQzoC5oh4hcGPP1FmDGcfwx8NjJDqloyCp
         61sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UR0UVLJ/IUMWn5l60pc0zwFWn8/sSH1s224oij3hpAM=;
        b=fnbDTUiSbFZ/Td9vVLB8lbrRPST3qITxLV94og1j7ihTzJrh7mAx9hEdj5mwGhnwoz
         /mlLrSet9sjVv6RD5Vffm3ZWHMBx5iAow6jm6tUkLr62WrFoYz6UmUe3jSE03UPg4EEt
         sDc+fjh9akxQB+ZA9ApjV3sT0Z+QzKBMlxFydaNOecejg35dARvjW6vlK49ktnZANKrh
         n/RmPvfPHxeswEm3NxJU40MguCyJXCQV0eoF5OCHz7pU7zjMjjIgGcezIXk/FYnk3r0K
         bd5QCZ0kfqC5tRMnsr5sRiyQC4CpmKUGORC9CyXIhjp7B6RW5kWoQhChqb1GwwOspdeL
         z42A==
X-Gm-Message-State: APjAAAVJLMAYJxsMg1fXZzQZxU1/jq/R1uYhfFokygOdkApbbl23Sekl
        w6QUzBff9saXo8Wclm2UjWnjfQ==
X-Google-Smtp-Source: APXvYqxQHtPuijF5lw+QxGLslaUuwSbemBzgSxJB9ARi0Tx6pdmy2IK2/xaCyymVvoZ+wzDNdBxnNw==
X-Received: by 2002:a65:520d:: with SMTP id o13mr9352862pgp.433.1574544439102;
        Sat, 23 Nov 2019 13:27:19 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id gx16sm2981169pjb.10.2019.11.23.13.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 13:27:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: add support for IORING_OP_CONNECT
Date:   Sat, 23 Nov 2019 14:27:09 -0700
Message-Id: <20191123212709.4598-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191123212709.4598-1-axboe@kernel.dk>
References: <20191123212709.4598-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows an application to call connect() in an async fashion. Like
other opcodes, we first try a non-blocking accept, then punt to async
context if we have to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 37 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 38 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0c66cd6ed0b0..5ceec1a4faad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1968,6 +1968,40 @@ static int io_accept(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 #endif
 }
 
+static int io_connect(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      struct io_kiocb **nxt, bool force_nonblock)
+{
+#if defined(CONFIG_NET)
+	struct sockaddr __user *addr;
+	unsigned file_flags;
+	int addr_len, ret;
+
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index || sqe->flags)
+		return -EINVAL;
+
+	addr = (struct sockaddr __user *) (unsigned long) READ_ONCE(sqe->addr);
+	addr_len = READ_ONCE(sqe->addr2);
+	file_flags = force_nonblock ? O_NONBLOCK : 0;
+
+	ret = __sys_connect_file(req->file, addr, addr_len, file_flags);
+	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
+		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+		return -EAGAIN;
+	}
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+	if (ret < 0 && (req->flags & REQ_F_LINK))
+		req->flags |= REQ_F_FAIL_LINK;
+	io_cqring_add_event(req, ret);
+	io_put_req_find_next(req, nxt);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
 static inline void io_poll_remove_req(struct io_kiocb *req)
 {
 	if (!RB_EMPTY_NODE(&req->rb_node)) {
@@ -2622,6 +2656,9 @@ static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 	case IORING_OP_ACCEPT:
 		ret = io_accept(req, s->sqe, nxt, force_nonblock);
 		break;
+	case IORING_OP_CONNECT:
+		ret = io_connect(req, s->sqe, nxt, force_nonblock);
+		break;
 	case IORING_OP_ASYNC_CANCEL:
 		ret = io_async_cancel(req, s->sqe, nxt);
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2a1569211d87..4637ed1d9949 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -73,6 +73,7 @@ struct io_uring_sqe {
 #define IORING_OP_ACCEPT	13
 #define IORING_OP_ASYNC_CANCEL	14
 #define IORING_OP_LINK_TIMEOUT	15
+#define IORING_OP_CONNECT	16
 
 /*
  * sqe->fsync_flags
-- 
2.24.0

