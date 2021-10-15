Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BEF42F3C5
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbhJONkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240123AbhJONkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:40:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3161161164;
        Fri, 15 Oct 2021 13:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634305081;
        bh=17+5dVIzHaa9AclJ8cie2QB4xpM7OWjPMngX/X9X4vI=;
        h=From:To:Cc:Subject:Date:From;
        b=lCIWtfTNGUPUpee0wga01V4RP64zSMFIrO0S+0jvrtCkoR4VcXZ2NU2759D5iTnts
         ZDQToi+FXidjMJQVPh3EAwTKrOgwX0SR7Nav5w0tUnrA3Wdm1hm5ueQ9GdFYjx371Z
         7rSjUEZ9b8vZNDu5PWIg7jmrN3SYvRzajC0elRmXCy8DznmvZK6yxQhWOMUAkG136s
         Az+5Y1UhsjmkQpBh5E3aO0ny2AiPhFu7G4hU8B7/iId+yek42V9Wog6MlwW2AVcnAi
         LMTG0obCV7pBQTLJKi6OjcNr2+DSnE8v4HqcLbbexVIk/y6FsO/i/D4yfzFjGk0f9z
         82dLjkIG5H1AA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: stream: don't purge sk_error_queue in sk_stream_kill_queues()
Date:   Fri, 15 Oct 2021 06:37:39 -0700
Message-Id: <20211015133739.672915-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_stream_kill_queues() can be called on close when there are
still outstanding skbs to transmit. Those skbs may try to queue
notifications to the error queue (e.g. timestamps).
If sk_stream_kill_queues() purges the queue without taking
its lock the queue may get corrupted, and skbs leaked.

This shows up as a warning about an rmem leak:

WARNING: CPU: 24 PID: 0 at net/ipv4/af_inet.c:154 inet_sock_destruct+0x...

The leak is always a multiple of 0x300 bytes (the value is in
%rax on my builds, so RAX: 0000000000000300). 0x300 is truesize of
an empty sk_buff. Indeed if we dump the socket state at the time
of the warning the sk_error_queue is often (but not always)
corrupted. The ->next pointer points back at the list head,
but not the ->prev pointer. Indeed we can find the leaked skb
by scanning the kernel memory for something that looks like
an skb with ->sk = socket in question, and ->truesize = 0x300.
The contents of ->cb[] of the skb confirms the suspicion that
it is indeed a timestamp notification (as generated in
__skb_complete_tx_timestamp()).

Removing purging of sk_error_queue should be okay, since
inet_sock_destruct() does it again once all socket refs
are gone. Eric suggests this may cause sockets that go
thru disconnect() to maintain notifications from the
previous incarnations of the socket, but that should be
okay since the race was there anyway, and disconnect()
is not exactly dependable.

Thanks to Jonathan Lemon and Omar Sandoval for help at various
stages of tracing the issue.

Fixes: cb9eff097831 ("net: new user space API for time stamping of incoming and outgoing packets")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v1: delete the purge completely

Sorry for the delay from RFC, took a while to get enough
production signal to confirm the fix.
---
 net/core/stream.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/core/stream.c b/net/core/stream.c
index e09ffd410685..06b36c730ce8 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -195,9 +195,6 @@ void sk_stream_kill_queues(struct sock *sk)
 	/* First the read buffer. */
 	__skb_queue_purge(&sk->sk_receive_queue);
 
-	/* Next, the error queue. */
-	__skb_queue_purge(&sk->sk_error_queue);
-
 	/* Next, the write queue. */
 	WARN_ON(!skb_queue_empty(&sk->sk_write_queue));
 
-- 
2.31.1

