Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBAE27E902
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 14:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgI3MzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 08:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgI3MzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 08:55:05 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B01C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 05:55:05 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 7so1043053pgm.11
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 05:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=exNMrYvf5Zan3NTS8tDCjRd9OqmOyigUFV0M2BWpqvo=;
        b=Skgo3bb13kUd1br5zpXdiS7QgVR9YrizAyn9YljQS5hKdEmYAe+J9PZBypCb02X1N/
         yp7jTsLLL4T2Xc4BmdHW1fU/rg/PQoixGF7MtlZ3B9uJT+77ZNBsFsPRW5Zv+KksjnOy
         BkhTDNfjebBJ+a63isjSxPkarbqJUsxMEBPIS5d6f2+l7VxNf0MTGYbF1rwJcaWVEnOS
         o2km53WuC/mVNBwfR6TfE8c+iaX2CJ6v8KHHe69gVX6oCwN0ffKRYuaHyrfVipIGQJ1I
         S7HgZ0TMS98V/EQN6PElCpfbdSOOjjlAkfH0LgQhI80VAVaOnRSvNSEebzda5nqJ3noS
         lRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=exNMrYvf5Zan3NTS8tDCjRd9OqmOyigUFV0M2BWpqvo=;
        b=V7b4WNY4k7+RlKtKMU86WWDoqp88Txa5gHfuY8IoLd7aaik/mATpDFlHHiQ9Icvk0l
         9tgItsJzpjE303O+bgZMAe+Sf1SGMVy8z8ev9GfKTzsSxzQ0nkRlNjoe0ax3Ja7I4/tm
         9JirG366zlWLa5/OEnZnQsiQonQL66tOZVUsq/4RV0fmbdfnwVmJXiJ/k2tQZs6k5jfT
         7ZhVsZyXd4+x3zEdCDQiP9swW4TuvkggTOWiKjzk/dqYLU9SliE/vcIvTxc7eQ6ypxdR
         RZ+zBwj2KB35CL/pLTQ0tw1mkoGtybfuI4E/hNck3BdC69QuFhUyS2WNqpX/4j+ohZpW
         PZcA==
X-Gm-Message-State: AOAM533AfRco1tyvvO3LHbnxeM3u10z3buTQprll5g0y7MlYK5Alb+HP
        ve9KlrUzxqJR3MovpXjW7nY=
X-Google-Smtp-Source: ABdhPJyCSseDyDP2dFe3/STJg5bHeblU2mTr1iJ7EeO/6UatjhqwlEKuJjycIAW6K308h6Nz+xZjtw==
X-Received: by 2002:aa7:8f21:0:b029:142:2501:39e0 with SMTP id y1-20020aa78f210000b0290142250139e0mr2325033pfr.47.1601470504592;
        Wed, 30 Sep 2020 05:55:04 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id e21sm2235235pgi.91.2020.09.30.05.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 05:55:04 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] inet: remove icsk_ack.blocked
Date:   Wed, 30 Sep 2020 05:54:56 -0700
Message-Id: <20200930125457.1579469-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
In-Reply-To: <20200930125457.1579469-1-eric.dumazet@gmail.com>
References: <20200930125457.1579469-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

TCP has been using it to work around the possibility of tcp_delack_timer()
finding the socket owned by user.

After commit 6f458dfb4092 ("tcp: improve latencies of timer triggered events")
we added TCP_DELACK_TIMER_DEFERRED atomic bit for more immediate recovery,
so we can get rid of icsk_ack.blocked

This frees space that following patch will reuse.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_connection_sock.h | 4 ++--
 net/dccp/timer.c                   | 1 -
 net/ipv4/inet_connection_sock.c    | 2 +-
 net/ipv4/tcp.c                     | 6 ++----
 net/ipv4/tcp_output.c              | 7 ++-----
 net/ipv4/tcp_timer.c               | 1 -
 6 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index dc763ca9413cc9c6279a59f9d1776cf2dbb1e853..79875f976190750819948425e63dd0309c699050 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -110,7 +110,7 @@ struct inet_connection_sock {
 		__u8		  pending;	 /* ACK is pending			   */
 		__u8		  quick;	 /* Scheduled number of quick acks	   */
 		__u8		  pingpong;	 /* The session is interactive		   */
-		__u8		  blocked;	 /* Delayed ACK was blocked by socket lock */
+		/* one byte hole. */
 		__u32		  ato;		 /* Predicted tick of soft clock	   */
 		unsigned long	  timeout;	 /* Currently scheduled timeout		   */
 		__u32		  lrcvtime;	 /* timestamp of last received data packet */
@@ -198,7 +198,7 @@ static inline void inet_csk_clear_xmit_timer(struct sock *sk, const int what)
 		sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
 #endif
 	} else if (what == ICSK_TIME_DACK) {
-		icsk->icsk_ack.blocked = icsk->icsk_ack.pending = 0;
+		icsk->icsk_ack.pending = 0;
 #ifdef INET_CSK_CLEAR_TIMERS
 		sk_stop_timer(sk, &icsk->icsk_delack_timer);
 #endif
diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index 927c796d76825439a35c4deb3fb2e45e4313f9b3..a934d293237366aeca87bd3c32241880639291c5 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -176,7 +176,6 @@ static void dccp_delack_timer(struct timer_list *t)
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
 		/* Try again later. */
-		icsk->icsk_ack.blocked = 1;
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKLOCKED);
 		sk_reset_timer(sk, &icsk->icsk_delack_timer,
 			       jiffies + TCP_DELACK_MIN);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index b457dd2d6c75b2f63bc7849474ac909adb14d603..4148f5f78f313cde1e0596b9eb3696df16e3f990 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -564,7 +564,7 @@ void inet_csk_clear_xmit_timers(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
-	icsk->icsk_pending = icsk->icsk_ack.pending = icsk->icsk_ack.blocked = 0;
+	icsk->icsk_pending = icsk->icsk_ack.pending = 0;
 
 	sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
 	sk_stop_timer(sk, &icsk->icsk_delack_timer);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2a8bfa89a5159837e3687e4e0f8cddba7fe54899..ed2805564424a90f003eed867bbed7f5ac4ae833 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1538,10 +1538,8 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied)
 
 	if (inet_csk_ack_scheduled(sk)) {
 		const struct inet_connection_sock *icsk = inet_csk(sk);
-		   /* Delayed ACKs frequently hit locked sockets during bulk
-		    * receive. */
-		if (icsk->icsk_ack.blocked ||
-		    /* Once-per-two-segments ACK was not sent by tcp_input.c */
+
+		if (/* Once-per-two-segments ACK was not sent by tcp_input.c */
 		    tp->rcv_nxt - tp->rcv_wup > icsk->icsk_ack.rcv_mss ||
 		    /*
 		     * If this read emptied read buffer, we send ACK, if
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 386978dcd318d84af486d0d1a5bb1786f4a493cf..6bd4e383030ea20441332a30e98fbda8cd90f84a 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3911,11 +3911,8 @@ void tcp_send_delayed_ack(struct sock *sk)
 
 	/* Use new timeout only if there wasn't a older one earlier. */
 	if (icsk->icsk_ack.pending & ICSK_ACK_TIMER) {
-		/* If delack timer was blocked or is about to expire,
-		 * send ACK now.
-		 */
-		if (icsk->icsk_ack.blocked ||
-		    time_before_eq(icsk->icsk_ack.timeout, jiffies + (ato >> 2))) {
+		/* If delack timer is about to expire, send ACK now. */
+		if (time_before_eq(icsk->icsk_ack.timeout, jiffies + (ato >> 2))) {
 			tcp_send_ack(sk);
 			return;
 		}
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 0c08c420fbc21a98dedf72148ea2a6f85bf3ff7a..6c62b9ea1320d9bbd26ed86b9f41de02fee6c491 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -331,7 +331,6 @@ static void tcp_delack_timer(struct timer_list *t)
 	if (!sock_owned_by_user(sk)) {
 		tcp_delack_timer_handler(sk);
 	} else {
-		icsk->icsk_ack.blocked = 1;
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKLOCKED);
 		/* deleguate our work to tcp_release_cb() */
 		if (!test_and_set_bit(TCP_DELACK_TIMER_DEFERRED, &sk->sk_tsq_flags))
-- 
2.28.0.806.g8561365e88-goog

