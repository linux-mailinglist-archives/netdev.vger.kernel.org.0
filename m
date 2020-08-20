Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E3424C8D5
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgHTX44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgHTX4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:56:22 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5580FC06134D
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:50:29 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x6so112582pgx.12
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qobnCFVTWkfs7U2jqVYwHzId3JsX5devmX9LImldd+A=;
        b=c3a3StAtWKGmtVp43/Aq0TJXS0Om+PYmlXjwTMTJDsGmr7ZolpEHFQWg5sywrzBJ9h
         /xGEZFlYfzJCAWMHUDyTAHWarS5hhsvt2OUaZHdcMt5695K+hacVkD7TteE52+vrzxae
         KG6xEWRp9B22cNbcG4n9ZfN38QApkvc9GEBRX8269M2fsP3cB47/fNfDRtRuiwZF2T4e
         J5zKcBjwF2F65X4JigEawO0E+4HA2+X+SBPYIjA6VCITUCCGh3TNCLyUsqssAu//fGmu
         VoRcH6kXA92e94ZkR5RWdUjjHC4uoYE55i3rtHotfJv41gVbk+31Pc2S9i0EpT+eMbWY
         jtQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qobnCFVTWkfs7U2jqVYwHzId3JsX5devmX9LImldd+A=;
        b=eSau11UOI9JCJ4c15t4qmJtemVV0jo3SUyCd/oCbZTurYiPw2dEpzLUbIzyLbcEZyu
         0y+jVw6fip2i4FiYgrnmOdOWKJlkD02PrafRtFcgaI6hrOKcWd7p7dcyvWkGpJzXHB+A
         6iysbgEVE/v6E2hx6Dgh/RVNwI7aCXpvVXUfxCBTZTMFgyFXxJeB+OnLGoX5MuLgYQzu
         AN+0RiFlNAl4ZnBMobGKJie9EFTfJrw0kLOV83cWXwwNKeVOBWEPDrIJ/UTPm1Ry9rVK
         E3ffSGe+lpJg/tjM4WAiFubnJTQ26re6pMNa8ish+IS2XtrlmthldVVuMlYyLopIvigb
         I6nw==
X-Gm-Message-State: AOAM532V+QcgA0vctRu2lVV1Fth8Gd+rms5mZsbQ7sJrzHRcv7L0WsJU
        mon/dB67hstZ1Jj43DiaUJoCeZMqKYQ=
X-Google-Smtp-Source: ABdhPJxoQTk6TB2x2wRckZC5THjvyjw9L7NBijXzgs1vPfw0a0qxwNvQFL+IDhOyMMF/8vUHCW0Jqg==
X-Received: by 2002:a63:af47:: with SMTP id s7mr377554pgo.335.1597967428892;
        Thu, 20 Aug 2020 16:50:28 -0700 (PDT)
Received: from lukehsiao.c.googlers.com.com (40.156.233.35.bc.googleusercontent.com. [35.233.156.40])
        by smtp.gmail.com with ESMTPSA id x9sm194815pff.145.2020.08.20.16.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 16:50:28 -0700 (PDT)
From:   Luke Hsiao <luke.w.hsiao@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Luke Hsiao <lukehsiao@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 2/2] io_uring: ignore POLLIN for recvmsg on MSG_ERRQUEUE
Date:   Thu, 20 Aug 2020 16:49:54 -0700
Message-Id: <20200820234954.1784522-3-luke.w.hsiao@gmail.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
In-Reply-To: <20200820234954.1784522-1-luke.w.hsiao@gmail.com>
References: <20200820234954.1784522-1-luke.w.hsiao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luke Hsiao <lukehsiao@google.com>

Currently, io_uring's recvmsg subscribes to both POLLERR and POLLIN. In
the context of TCP tx zero-copy, this is inefficient since we are only
reading the error queue and not using recvmsg to read POLLIN responses.

This patch was tested by using a simple sending program to call recvmsg
using io_uring with MSG_ERRQUEUE set and verifying with printks that the
POLLIN is correctly unset when the msg flags are MSG_ERRQUEUE.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Luke Hsiao <lukehsiao@google.com>
---
 fs/io_uring.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dc506b75659c..664ce8739615 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -79,6 +79,7 @@
 #include <linux/splice.h>
 #include <linux/task_work.h>
 #include <linux/pagemap.h>
+#include <linux/socket.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -4902,7 +4903,8 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 	return mask;
 }
 
-static bool io_arm_poll_handler(struct io_kiocb *req)
+static bool io_arm_poll_handler(struct io_kiocb *req,
+				const struct io_uring_sqe *sqe)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
@@ -4932,6 +4934,11 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 		mask |= POLLIN | POLLRDNORM;
 	if (def->pollout)
 		mask |= POLLOUT | POLLWRNORM;
+
+	/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
+	if (req->opcode == IORING_OP_RECVMSG && (sqe->msg_flags & MSG_ERRQUEUE))
+		mask &= ~(POLLIN);
+
 	mask |= POLLERR | POLLPRI;
 
 	ipt.pt._qproc = io_async_queue_proc;
@@ -6146,7 +6153,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
-		if (!io_arm_poll_handler(req)) {
+		if (!io_arm_poll_handler(req, sqe)) {
 punt:
 			ret = io_prep_work_files(req);
 			if (unlikely(ret))
-- 
2.28.0.297.g1956fa8f8d-goog

