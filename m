Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2EF90CF3
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 06:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbfHQE01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 00:26:27 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:39689 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfHQE01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 00:26:27 -0400
Received: by mail-qk1-f202.google.com with SMTP id x1so7374348qkn.6
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 21:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=J7j6/QBNMEM8mXt9IP9g5nAPHRV0T5L/sh6oyKu8TWM=;
        b=rDd962yxSfBf5HHjzRv0dFBikr0CSBt20aS5F/Y1sbYGv5j6guhk0RpkyCFnro6B49
         TmBFWeV/r63d16wTMA4lC/5IsYHifVuhDeStC2gPkicZgjFUs0xJrKeRbimVv+NDOEaE
         iPSc3jVb6q33Ww21zx54OGSOahD1ixf2fBszPdZ5wxOcZDg0x0vRUvDaV5bp1ygsI4hz
         RXFA0T0NHY1tQzWnM66RkraMO8wp9pA1PhjJNtjR3ygNVkhnPtrp83ve6mx1wryUKODk
         DJrYx3VLRrTw/ht6fuMVCXcbOnnZ7IuBTSMFA0ny6j+c1YLZWrGfr6/kkh5u9/9EAoAY
         zCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=J7j6/QBNMEM8mXt9IP9g5nAPHRV0T5L/sh6oyKu8TWM=;
        b=Fg+flAqfeTLWIQjwJnhGNZkxfFqnXiFGDzAY3GAth5Rmi3sntBotXtDVCwot7kiaSa
         x7LGrlY74Ep5CAnB/xAqTOPBiUZdEVoi/PSrdK9xLUf4aPTbHgOZpVgZkSMxfLZeZI8E
         RuJIvl92nUWX2pF+TQXvnbtb+jox/6+ammRBrnSxMIWijzsezbF1TZh6LiJikzM7rbY0
         oBeTA2Co/dSx9TlnS6kbUS1uJhJ5oVrdk81i+lsdYwTzHEH8dF1kFM7aEP+x5Dlz6i7H
         46S3I426TsoCXv+Dw2YC47E2YEtBgYTCi5z1YRLxh6x2TWNJKgqtgv0OJtMysUbo9Mn/
         +zEA==
X-Gm-Message-State: APjAAAUHfMo51JnUdMkHinkGhkhjz5MQcSNLQvA6CqOaQKnN0heb/1L8
        rHPWlKyjwgm6SaRZQIk2wQ2NcYZFjFne9w==
X-Google-Smtp-Source: APXvYqx0SEw3TIpBHHbqtvm32dlhwL+S1fJ4ISqsOrUkXdAvN0XWhfcN8yPqVD2OwMbjr7rLstbZ1rDNHHBh2g==
X-Received: by 2002:a0c:e588:: with SMTP id t8mr3952804qvm.179.1566015985918;
 Fri, 16 Aug 2019 21:26:25 -0700 (PDT)
Date:   Fri, 16 Aug 2019 21:26:22 -0700
Message-Id: <20190817042622.91497-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH net] tcp: make sure EPOLLOUT wont be missed
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        Vladimir Rutsky <rutsky@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Jason Baron explained in commit 790ba4566c1a ("tcp: set SOCK_NOSPACE
under memory pressure"), it is crucial we properly set SOCK_NOSPACE
when needed.

However, Jason patch had a bug, because the 'nonblocking' status
as far as sk_stream_wait_memory() is concerned is governed
by MSG_DONTWAIT flag passed at sendmsg() time :

    long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);

So it is very possible that tcp sendmsg() calls sk_stream_wait_memory(),
and that sk_stream_wait_memory() returns -EAGAIN with SOCK_NOSPACE
cleared, if sk->sk_sndtimeo has been set to a small (but not zero)
value.

This patch removes the 'noblock' variable since we must always
set SOCK_NOSPACE if -EAGAIN is returned.

It also renames the do_nonblock label since we might reach this
code path even if we were in blocking mode.

Fixes: 790ba4566c1a ("tcp: set SOCK_NOSPACE under memory pressure")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Reported-by: Vladimir Rutsky  <rutsky@google.com>
---
 net/core/stream.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/core/stream.c b/net/core/stream.c
index e94bb02a56295ec2db34ab423a8c7c890df0a696..4f1d4aa5fb38d989a9c81f32dfce3f31bbc1fa47 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -120,7 +120,6 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
 	int err = 0;
 	long vm_wait = 0;
 	long current_timeo = *timeo_p;
-	bool noblock = (*timeo_p ? false : true);
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
 	if (sk_stream_memory_free(sk))
@@ -133,11 +132,8 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
 
 		if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))
 			goto do_error;
-		if (!*timeo_p) {
-			if (noblock)
-				set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
-			goto do_nonblock;
-		}
+		if (!*timeo_p)
+			goto do_eagain;
 		if (signal_pending(current))
 			goto do_interrupted;
 		sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
@@ -169,7 +165,13 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
 do_error:
 	err = -EPIPE;
 	goto out;
-do_nonblock:
+do_eagain:
+	/* Make sure that whenever EAGAIN is returned, EPOLLOUT event can
+	 * be generated later.
+	 * When TCP receives ACK packets that make room, tcp_check_space()
+	 * only calls tcp_new_space() if SOCK_NOSPACE is set.
+	 */
+	set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 	err = -EAGAIN;
 	goto out;
 do_interrupted:
-- 
2.23.0.rc1.153.gdeed80330f-goog

