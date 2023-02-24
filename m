Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27896A1DF5
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjBXPE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjBXPEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:04:25 -0500
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2E32CFDC
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:04:18 -0800 (PST)
Received: from [2a02:169:59c5:0:3123:be7a:793e:68c4] (helo=areia)
        by eidolon.nox.tf with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1pVZcN-00AISd-KD; Fri, 24 Feb 2023 16:04:15 +0100
Received: from equinox by areia with local (Exim 4.96)
        (envelope-from <equinox@diac24.net>)
        id 1pVZbz-000XVo-1T;
        Fri, 24 Feb 2023 16:03:51 +0100
From:   David Lamparter <equinox@diac24.net>
To:     io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, David Lamparter <equinox@diac24.net>,
        Eric Dumazet <edumazet@google.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: remove MSG_NOSIGNAL from recvmsg
Date:   Fri, 24 Feb 2023 16:01:24 +0100
Message-Id: <20230224150123.128346-1-equinox@diac24.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <CANn89iJE6SpB2bfXEc=73km6B2xtBSWHj==WsYFnH089WPKtSA@mail.gmail.com>
References: <CANn89iJE6SpB2bfXEc=73km6B2xtBSWHj==WsYFnH089WPKtSA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MSG_NOSIGNAL is not applicable for the receiving side, SIGPIPE is
generated when trying to write to a "broken pipe".  AF_PACKET's
packet_recvmsg() does enforce this, giving back EINVAL when MSG_NOSIGNAL
is set - making it unuseable in io_uring's recvmsg.

Remove MSG_NOSIGNAL from io_recvmsg_prep().

Signed-off-by: David Lamparter <equinox@diac24.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
---

> Sure, or perhaps David wanted to take care of this.

Here you go.  But maybe give me a few hours to test/confirm...

diff --git a/io_uring/net.c b/io_uring/net.c
index cbd4b725f58c..b7f190ca528e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -567,7 +567,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~(RECVMSG_FLAGS))
 		return -EINVAL;
-	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	if (sr->msg_flags & MSG_ERRQUEUE)
-- 
2.39.2

