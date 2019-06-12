Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A15D4490D
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404717AbfFMRN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbfFLWBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 18:01:04 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECBA920B7C;
        Wed, 12 Jun 2019 22:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560376863;
        bh=05dXGrGKCXPHaKO0jLEjsx1c8iyxgNPMzxixaWBU1Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AboYvTBemsNv4lHkJnmN3fRjqz8XXX+E25fN0bEhWhvgW3f5h7sG/yrdthbOx82sR
         /G1h5EN0zwuadF0X3NVvEkHnWtKM32g0NNzm11z/m6Ueqv6rzs9EjIr4bs8h+OtXGh
         e0Va7vDvzGUmYwaHuAvyzAUFX1ez0zDLy1YfKV5Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+111cb28d9f583693aefa@syzkaller.appspotmail.com>
Subject: [PATCH] io_uring: fix memory leak of UNIX domain socket inode
Date:   Wed, 12 Jun 2019 14:58:43 -0700
Message-Id: <20190612215843.91294-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
In-Reply-To: <0000000000005bc340058983fe8e@google.com>
References: <0000000000005bc340058983fe8e@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Opening and closing an io_uring instance leaks a UNIX domain socket
inode.  This is because the ->file of the io_uring instance's internal
UNIX domain socket is set to point to the io_uring file, but then
sock_release() sees the non-NULL ->file and assumes the inode reference
is held by the file so doesn't call iput().  That's not the case here,
since the reference is still meant to be held by the socket; the actual
inode of the io_uring file is different.

Fix this leak by NULL-ing out ->file before releasing the socket.

Reported-by: syzbot+111cb28d9f583693aefa@syzkaller.appspotmail.com
Fixes: 2b188cc1bb85 ("Add io_uring IO interface")
Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0fbb486a320e9..86a2bd7219005 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2777,8 +2777,10 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 
 #if defined(CONFIG_UNIX)
-	if (ctx->ring_sock)
+	if (ctx->ring_sock) {
+		ctx->ring_sock->file = NULL; /* so that iput() is called */
 		sock_release(ctx->ring_sock);
+	}
 #endif
 
 	io_mem_free(ctx->sq_ring);
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

