Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6789D6456
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbfJNNsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 09:48:02 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:47214 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfJNNsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 09:48:02 -0400
Received: by mail-pg1-f201.google.com with SMTP id 186so12659598pgd.14
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 06:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6A48pLX4ovlxuq4rUz7T7G7wHkAxPBaLEXFYIzJJLTs=;
        b=WufVIaMkjAY/r9Mp2V1ZpDv7dI2T6wGfexJHaFWgye+ePJtTzjo5fQM4U+cqEKx1f4
         4Vumu32VVWncpejVDxpm0f/pq5P7fwbeiu1Z+MsNaKq7kIacc8QbLkv13VuZxZQMxWA+
         yqEHQNSPAzRaJ+/w4o6MVZoQ1J+ghwK01lWy6XDRpNNGUMNJ0TcpGGgYMu4S9r7KJpv/
         c0dIuROIK1Q/70SkB7sCZZ/81kcAtJ62ZYRlbDPk+4pPLTp3wuJZ2MpB5xDK/CJnZm8u
         /k5PZXgryxyHxdBd935IY51i2Pvi/RDsEDPoGUOd1aKNJjJkupUgHwziKB+fmqmMWKi0
         5HiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6A48pLX4ovlxuq4rUz7T7G7wHkAxPBaLEXFYIzJJLTs=;
        b=n32k3SbjCXR/h4FI6tJxe7cljDKJCHQkDwC6djU6oN/WPLMDeZkmjHypwBkrWbWiwD
         MxEWwfa+htOSHoeZqeuW74/earP1KWmqFDZHKYqusW/zw7VSJ6BO5e1d1tdiaF6D89qE
         dna/zUnHWtLHm3paTb12tjIOppJEDTSOImxU96UD2D9rtUXAq2obj+yE0hyu3ScuR35x
         XUxo7zwmNRq2gEValnurAbq7UQ7bSMvV+fpAzojyvTNmoqk81kOOpfIgJ0F25mofRDiV
         NTuOm6QIU9uWyD9hE6WZK8U+qEW+EvhCxHedUt0BvSrY1oq0cebO1wh0a5iBy5r763oE
         zrow==
X-Gm-Message-State: APjAAAU76/JBOmlGkV5sfEAs5Byean4Qjmb0C7mOz7IygBQHVRqtBW6m
        jaykdQzvEypmVbQytpBWH6B+JgUcujKkyw==
X-Google-Smtp-Source: APXvYqwfy+ei2lNAbVG22SmSjE0biqZ0OAZtjErY2foqD+sDsfITFHWKB0xwjbjPATpX7HuoieTOYuhFuCINYg==
X-Received: by 2002:a63:4046:: with SMTP id n67mr30745525pga.200.1571060881065;
 Mon, 14 Oct 2019 06:48:01 -0700 (PDT)
Date:   Mon, 14 Oct 2019 06:47:57 -0700
Message-Id: <20191014134757.185995-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net] tcp: fix a possible lockdep splat in tcp_done()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found that if __inet_inherit_port() returns an error,
we call tcp_done() after inet_csk_prepare_forced_close(),
meaning the socket lock is no longer held.

We might fix this in a different way in net-next, but
for 5.4 it seems safer to relax the lockdep check.

Fixes: d983ea6f16b8 ("tcp: add rcu protection around tp->fastopen_rsk")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/tcp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b2ac4f074e2da21db57923fda722b6d23f170de9..42187a3b82f4f6280d831c34d9ca6b7bcffc191f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3842,8 +3842,12 @@ void tcp_done(struct sock *sk)
 {
 	struct request_sock *req;
 
-	req = rcu_dereference_protected(tcp_sk(sk)->fastopen_rsk,
-					lockdep_sock_is_held(sk));
+	/* We might be called with a new socket, after
+	 * inet_csk_prepare_forced_close() has been called
+	 * so we can not use lockdep_sock_is_held(sk)
+	 */
+	req = rcu_dereference_protected(tcp_sk(sk)->fastopen_rsk, 1);
+
 	if (sk->sk_state == TCP_SYN_SENT || sk->sk_state == TCP_SYN_RECV)
 		TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
 
-- 
2.23.0.700.g56cf767bdb-goog

