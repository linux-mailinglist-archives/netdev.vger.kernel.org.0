Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADD224E49A
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 04:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgHVCFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 22:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgHVCFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 22:05:08 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8518C061574
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 19:05:07 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g15so1692654plj.6
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 19:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZeyYNnKESh4/AMObQMqL54TNNFM6lWLlOLYyi1zJfxo=;
        b=RKmoBK/E0xLvxsY5MilCYiysQTK6kimEgjPtRzKmjvo6yosmpwtNkVoPazM1dTsHqD
         BJav3bTKGTY7qWy5mJC4jxp6gcaKyTZhwrIP5t9871yPYvdH2uNB7eQ++fUsTw4Qo+xV
         WN38STNz/mJXXKE91FeLdRcrsTM43NEwEqKt4Cha465cm+7dQMJP85vVK8lNU2kn7MQs
         YnQiUeqw6GXeDyAlgCKBStgXpfc7/8HXfg53qlS0D7wZT68NqRAb6AZZRHYuK+9SemFo
         ++XKEjGMZ/z5A4Uyib+w4lyuQYqx4STTFY5ts0K6wCXIJgQyHs1dy9wwRrdShZeQYCg1
         2PxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZeyYNnKESh4/AMObQMqL54TNNFM6lWLlOLYyi1zJfxo=;
        b=rxc9ATj+8staBvaN5nksj15r5QG2aMSUnkj6AWQ00HZ2fdD3a2MoKp0MoqE5DhkUDV
         wQPbzRd9PGSOChXJzGkOpPWJDkWWJUkYMrRT1iovls8kFIHgB1GRI9DoWNwnXcSiVOoD
         GSjuSsWW+ia+05D7u8Gk7qLRHekjTIKoE3NQmF2+conZhzM+cl9gKsC9UhtI/cWcEi1k
         h+hYXx85bzrZUajdzpNya0ng4NwS5LsAxpMmdL0cryJcaHJKFMcCEwk/YN7CDYzjubXP
         wuyy1ZyU2tjgdW1mcBVSWngTZpd1bS5s0pr4o3CoaiKRCFOD3XIiwPmDr+FtaRgPbjPY
         4TAQ==
X-Gm-Message-State: AOAM533pcX/ODvOIT0qK/8dLzUsKtUst4+B1brtcrNXz3xBtXDkwQaNz
        L4VJ2wBUVtL3VKN6Cmasaxw=
X-Google-Smtp-Source: ABdhPJwOIJhgp9YmoWd/X33HV2j423sHQkh+VwBKCUnNIHsuqWgXSsfIrOxeEEX3iuSr15vXbd7jPg==
X-Received: by 2002:a17:90b:283:: with SMTP id az3mr4777245pjb.10.1598061907255;
        Fri, 21 Aug 2020 19:05:07 -0700 (PDT)
Received: from lukehsiao.c.googlers.com.com (40.156.233.35.bc.googleusercontent.com. [35.233.156.40])
        by smtp.gmail.com with ESMTPSA id v78sm4129729pfc.121.2020.08.21.19.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 19:05:06 -0700 (PDT)
From:   Luke Hsiao <luke.w.hsiao@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jakub Kicinski <kuba@kernel.org>,
        Luke Hsiao <lukehsiao@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v2 2/2] io_uring: ignore POLLIN for recvmsg on MSG_ERRQUEUE
Date:   Fri, 21 Aug 2020 19:04:42 -0700
Message-Id: <20200822020442.2677358-2-luke.w.hsiao@gmail.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
In-Reply-To: <20200822020442.2677358-1-luke.w.hsiao@gmail.com>
References: <9abca73b-de63-f69d-caff-ae3ed24854de@kernel.dk>
 <20200822020442.2677358-1-luke.w.hsiao@gmail.com>
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
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Luke Hsiao <lukehsiao@google.com>
---
 fs/io_uring.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dc506b75659c..fd5353e31a2c 100644
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
+		mask &= ~POLLIN;
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

