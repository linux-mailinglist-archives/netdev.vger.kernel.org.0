Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0B231A842
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhBLXXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhBLXXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 18:23:02 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0000DC061756
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:22:21 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gb24so456983pjb.4
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OA9jl+qltSvZN2XmtYv7p5wUHqDmkLnYtHrCz0b4Bms=;
        b=bYZ6OdMiwNSB6Ij5eZOaVY5VpTAMenPs2b1KYYnS/mbwO3fC5DCebV0HUyTgBDS9ie
         YUfT9qhN6igvj6nUx1ZqRCk3a8vdw2U5hl07VGZxrsaW5D3/CFBfUFIOG8ihgI5d+KFt
         Z1sRS7jD06wpOoy6p4LzCvP1g+p287YeMQ3zQkyel/hyfsgJ1u8Y4D6g8u4+fmLAaQpb
         Y+kxQVKvh9DcYKYL5aLH0v9p8Dv0rrX2bpNcLCeO6Kh4KOCZOQP1CTYAM20XChws5J1n
         qodbild7EOe0ZZt1hnO1NRXqYglbBON089MmLTWgzWiLLEmBO8nFIaaNvrbVqwz2Ftlb
         nksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OA9jl+qltSvZN2XmtYv7p5wUHqDmkLnYtHrCz0b4Bms=;
        b=oo+rNLQTv8Apu4GSb5j5KF8ZDo9CscjU8wtJ7altrhhVzNoe0d4ku/jD3b+QATUZov
         mOUzDQ9BsfPCandgQ19MWJiNTt5LcanF8j0rTWGvYGN5jL+EN5V7y2DVTr00jbhI0EaZ
         OdJvAELexco03HenxQdG3jZTibboSy9MeVpdHf/1DYzTmMzSMykl7NQ7E9RX9Ra1uMDb
         A4yYHPduNKzR6/aHr7WATSLOYHpaGjfUXXu9H4XK0DivhrjRubSUtxJWHKIGwx6tVtYl
         jZJQt77pXNpQEqhCnAZjgziENsJM2NVN1N62ykJqtDN5yF1WWXLXiJJ9Or90AXjtyjWs
         MWqA==
X-Gm-Message-State: AOAM531rET/1v+6EFINwbMeJM3APXXhxf/FJhBaYLRxEi1HDU1vhJsZV
        b4T0kgRaS7+w86vKdvN6tQM=
X-Google-Smtp-Source: ABdhPJyuYrvaYeHh+qepBvbP6lb0CavFlBWCtduiWuNsYzFQZUKjnzhL54Hjg358VOCP/s96yYJ+/A==
X-Received: by 2002:a17:90a:7025:: with SMTP id f34mr4722928pjk.116.1613172141581;
        Fri, 12 Feb 2021 15:22:21 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:449f:1ef7:3640:824a])
        by smtp.gmail.com with ESMTPSA id f7sm9160614pjh.45.2021.02.12.15.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 15:22:21 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjun Roy <arjunroy@google.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH net-next 1/2] tcp: fix SO_RCVLOWAT related hangs under mem pressure
Date:   Fri, 12 Feb 2021 15:22:13 -0800
Message-Id: <20210212232214.2869897-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
In-Reply-To: <20210212232214.2869897-1-eric.dumazet@gmail.com>
References: <20210212232214.2869897-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While commit 24adbc1676af ("tcp: fix SO_RCVLOWAT hangs with fat skbs")
fixed an issue vs too small sk_rcvbuf for given sk_rcvlowat constraint,
it missed to address issue caused by memory pressure.

1) If we are under memory pressure and socket receive queue is empty.
First incoming packet is allowed to be queued, after commit
76dfa6082032 ("tcp: allow one skb to be received per socket under memory pressure")

But we do not send EPOLLIN yet, in case tcp_data_ready() sees sk_rcvlowat
is bigger than skb length.

2) Then, when next packet comes, it is dropped, and we directly
call sk->sk_data_ready().

3) If application is using poll(), tcp_poll() will then use
tcp_stream_is_readable() and decide the socket receive queue is
not yet filled, so nothing will happen.

Even when sender retransmits packets, phases 2) & 3) repeat
and flow is effectively frozen, until memory pressure is off.

Fix is to consider tcp_under_memory_pressure() to take care
of global memory pressure or memcg pressure.

Fixes: 24adbc1676af ("tcp: fix SO_RCVLOWAT hangs with fat skbs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Arjun Roy <arjunroy@google.com>
Suggested-by: Wei Wang <weiwan@google.com>
---
 include/net/tcp.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 25bbada379c46add16fb7239733bd6571f10f680..244208f6f6c2ace87920b633e469421f557427a6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1431,8 +1431,13 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied);
  */
 static inline bool tcp_rmem_pressure(const struct sock *sk)
 {
-	int rcvbuf = READ_ONCE(sk->sk_rcvbuf);
-	int threshold = rcvbuf - (rcvbuf >> 3);
+	int rcvbuf, threshold;
+
+	if (tcp_under_memory_pressure(sk))
+		return true;
+
+	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
+	threshold = rcvbuf - (rcvbuf >> 3);
 
 	return atomic_read(&sk->sk_rmem_alloc) > threshold;
 }
-- 
2.30.0.478.g8a0d178c01-goog

