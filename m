Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C259269859
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgINVw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgINVwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:52:21 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA2AC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:52:20 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id d20so2045532qka.5
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1LF/TjjDplazqZrihwYxLyCv+1SkkN89haVSx4X5K78=;
        b=jmCD5vi4CCAHsQbJ26ym9HeFUT8r+qfebXTVAzZszwSzAtil3jwvPXm9slFJD1UaUC
         Je6jwIx/+JFUTacFzlCk4+4ShvKOKTDkmogw8K7UWa7d1Vo8EjgOP6QEzLME+rOWLnLo
         FIRqzSo7gexm3gxLqYXD170Wqid4KcgCxy4ZQMOMWDLacGT0YubZLQ6VFiMlCOPDL6SN
         nMLO7DG1+WcyLzsqt9a0dj1x67w2Rxgc+l4ltXdu59Dogz84VW+X6cJBun3t3dPDJ/0Q
         jzrBJYPrKTfj4TKSrn/AxvkPpDoh/lxhOT/DMsm1vUstHUh8GsbxD8wqmwucEsBEmHoG
         Gr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1LF/TjjDplazqZrihwYxLyCv+1SkkN89haVSx4X5K78=;
        b=QDEG1+MC2YulJWSkTp3Ry/OTPh9XdDdY3Z8RHJY+ROI015j12PHHOVFyxY0+3SAGgL
         FlxuZt5lY9dchGx0kwkQQo0WkuG5XOpaUk/R+GxJFMcKukBUaeMNbLjOTpv9qdY3ya3v
         1WPRBx31uAtt1+FxGV+QTZM4u6IJn4upoCxZ9ENOn4nGvqR9A7Y98FHGFYhY5R0D9Iir
         44RGYXLrDkX4+bupBffhGysyJfogU7CA186pUg3CQ20un251cGK/iKb/WJRVKGubCZYM
         gDmn7ysHtMmFK/DP+9gI8Njy8mE1h3TIkFuHCAsUj/vXi3cUiKilZEE4fOD46qqt+qTl
         K+uQ==
X-Gm-Message-State: AOAM530353B7lifSt14D5rUWWVKfwA6YmncVK+N0I5kGRUhD/S9Jf/E7
        xkiwT8lWALlHZX6Pq7AjJ+fisMGgYD0=
X-Google-Smtp-Source: ABdhPJymfDgvQjHBCRhM1KMarycoVxAbY2IFhbfta11ztxvAoN7WG3Pr0uGDacnoZmtQbtnJ1+So0w==
X-Received: by 2002:ae9:e602:: with SMTP id z2mr15230199qkf.259.1600120340062;
        Mon, 14 Sep 2020 14:52:20 -0700 (PDT)
Received: from soheil4.nyc.corp.google.com ([2620:0:1003:312:a6ae:11ff:fe18:6946])
        by smtp.gmail.com with ESMTPSA id r195sm14755232qke.74.2020.09.14.14.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 14:52:19 -0700 (PDT)
From:   Soheil Hassas Yeganeh <soheil.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     edumazet@google.com, Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH net-next 1/2] tcp: return EPOLLOUT from tcp_poll only when notsent_bytes is half the limit
Date:   Mon, 14 Sep 2020 17:52:09 -0400
Message-Id: <20200914215210.2288109-1-soheil.kdev@gmail.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Soheil Hassas Yeganeh <soheil@google.com>

If there was any event available on the TCP socket, tcp_poll()
will be called to retrieve all the events.  In tcp_poll(), we call
sk_stream_is_writeable() which returns true as long as we are at least
one byte below notsent_lowat.  This will result in quite a few
spurious EPLLOUT and frequent tiny sendmsg() calls as a result.

Similar to sk_stream_write_space(), use __sk_stream_is_writeable
with a wake value of 1, so that we set EPOLLOUT only if half the
space is available for write.

Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d3781b6087cb..48c351804efc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -564,7 +564,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 			mask |= EPOLLIN | EPOLLRDNORM;
 
 		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
-			if (sk_stream_is_writeable(sk)) {
+			if (__sk_stream_is_writeable(sk, 1)) {
 				mask |= EPOLLOUT | EPOLLWRNORM;
 			} else {  /* send SIGIO later */
 				sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
@@ -576,7 +576,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 				 * pairs with the input side.
 				 */
 				smp_mb__after_atomic();
-				if (sk_stream_is_writeable(sk))
+				if (__sk_stream_is_writeable(sk, 1))
 					mask |= EPOLLOUT | EPOLLWRNORM;
 			}
 		} else
-- 
2.28.0.618.gf4bc123cb7-goog

