Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DD1BCAC1
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403795AbfIXPBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:01:39 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:42795 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388811AbfIXPBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:01:39 -0400
Received: by mail-qt1-f202.google.com with SMTP id w9so2253442qto.9
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 08:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6lhNUnzlY9YS7mlEkYDHRyFhi9aNMXD3vn90zGYaf64=;
        b=j4b6K8AUB27bcdNNvp5qacOQ0puaXh4AZ6oTXYEnZzJ4pauqPta7RaFlivkb0FX790
         30gZNs6SNeuopr7Rq5x3T53gpc1/Cjlu8oP7oFLgempAhNZOrXCDI/ExqSva3PaebR7w
         mENB+TRZfa+Ym4+XixWVvU+LI/zOeNXoxAJZ9i1tsXp1Cpk8V8B7i/82j/iv4gAn52VY
         nQngMJhZpvM0mMZTvocrGC15IWvkyfN2U6uOPBD2CIGZ/f3qn4GY5ScBwp2okueZ6VtE
         dIn4TpUhxRaxe0yJ7iMxiMNDAkWkGhPCuajRK040bADQojO7NNM6TNWP0L2XXzPD08rW
         rYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6lhNUnzlY9YS7mlEkYDHRyFhi9aNMXD3vn90zGYaf64=;
        b=n8iwqAH2ytcIF9CjKiHHnTjcsOSaXiSFk8WjtfRk4nJhUKwQaAjbIFjqi9T7tnhdqf
         leJP9lKRvGGy+PLtYlv0R/CrrhD8y6pjySmp3z+ebKG0AYGR37LxjB9TYmiEXTD/YJO+
         Qp0yvwFwwTmgpL6Y52qjg+cIwpBE9R1LAszeLfu+nEqShGDZrlSQjhxtGY41k7TMT/Vw
         5eGsWhkBNut/s3T143bZSUVVNV1OD7fhk9E4uH/YmBYsws/oKel3AuN5nR811aHSd+2J
         qhGlUrq/WOB0KBPfxMnb1v3XM+rQ9u8B8VepjMddNlfai/8GCKlxOyyCmgiuxO2JZhOn
         ombA==
X-Gm-Message-State: APjAAAVd/2cVXRvKTuBdC70MyQ0XsBXIQka6FQV9ytqSb23JjrbiiOHn
        G1djp8yl1SEVwf9vd79ot2Omm/b7GJL6dg==
X-Google-Smtp-Source: APXvYqwSzWLyTI70f+lxbmzyopLJWchpffSX62UtjKeQ2Vt3Z47C7UVS/PXQmdQIpLvACqd/R+JKrZzy+Hsvmg==
X-Received: by 2002:aed:21a3:: with SMTP id l32mr3294197qtc.339.1569337297763;
 Tue, 24 Sep 2019 08:01:37 -0700 (PDT)
Date:   Tue, 24 Sep 2019 08:01:16 -0700
In-Reply-To: <20190924150116.199028-1-edumazet@google.com>
Message-Id: <20190924150116.199028-4-edumazet@google.com>
Mime-Version: 1.0
References: <20190924150116.199028-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH net 3/3] tcp: honor SO_PRIORITY in TIME_WAIT state
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ctl packets sent on behalf of TIME_WAIT sockets currently
have a zero skb->priority, which can cause various problems.

In this patch we :

- add a tw_priority field in struct inet_timewait_sock.

- populate it from sk->sk_priority when a TIME_WAIT is created.

- For IPv4, change ip_send_unicast_reply() and its two
  callers to propagate tw_priority correctly.
  ip_send_unicast_reply() no longer changes sk->sk_priority.

- For IPv6, make sure TIME_WAIT sockets pass their tw_priority
  field to tcp_v6_send_response() and tcp_v6_send_ack().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_timewait_sock.h | 1 +
 net/ipv4/ip_output.c             | 1 -
 net/ipv4/tcp_ipv4.c              | 4 ++++
 net/ipv4/tcp_minisocks.c         | 1 +
 net/ipv6/tcp_ipv6.c              | 6 ++++--
 5 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index aef38c140014600dbf88b1d664bad1b0adf63668..dfd919b3119e8efcbc436a67e3e6fbd02091db10 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -71,6 +71,7 @@ struct inet_timewait_sock {
 				tw_pad		: 2,	/* 2 bits hole */
 				tw_tos		: 8;
 	u32			tw_txhash;
+	u32			tw_priority;
 	struct timer_list	tw_timer;
 	struct inet_bind_bucket	*tw_tb;
 };
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index a77c3a4c24de40ff6bf3fa9da9a018457139e2b5..28fca408812c5576fc4ea957c1c4dec97ec8faf3 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1694,7 +1694,6 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 
 	inet_sk(sk)->tos = arg->tos;
 
-	sk->sk_priority = skb->priority;
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
 	sk->sk_sndbuf = sysctl_wmem_default;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fd394ad179a008085b4e87215290f243ea1993b6..2ee45e3755e92e60b5e1810e2f68205221b8308d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -771,6 +771,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	if (sk) {
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_mark : sk->sk_mark;
+		ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
+				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
 	}
 	ip_send_unicast_reply(ctl_sk,
@@ -866,6 +868,8 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
 	ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 			   inet_twsk(sk)->tw_mark : sk->sk_mark;
+	ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
+			   inet_twsk(sk)->tw_priority : sk->sk_priority;
 	transmit_time = tcp_transmit_time(sk);
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 8bcaf2586b6892b52fc3b25545017ec21afb0bde..bb140a5db8c066e57f1018fd47bccd4628def642 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -266,6 +266,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 
 		tw->tw_transparent	= inet->transparent;
 		tw->tw_mark		= sk->sk_mark;
+		tw->tw_priority		= sk->sk_priority;
 		tw->tw_rcv_wscale	= tp->rx_opt.rcv_wscale;
 		tcptw->tw_rcv_nxt	= tp->rcv_nxt;
 		tcptw->tw_snd_nxt	= tp->snd_nxt;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5f557bf27da2ba6bcc74034a53a3f76a99fdf9f4..e3d9f4559c99f252eba448845cce434bc53f3fd8 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -995,8 +995,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 				label = ip6_flowlabel(ipv6h);
 			priority = sk->sk_priority;
 		}
-		if (sk->sk_state == TCP_TIME_WAIT)
+		if (sk->sk_state == TCP_TIME_WAIT) {
 			label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
+			priority = inet_twsk(sk)->tw_priority;
+		}
 	} else {
 		if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_TCP_RESET)
 			label = ip6_flowlabel(ipv6h);
@@ -1029,7 +1031,7 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			tcptw->tw_rcv_wnd >> tw->tw_rcv_wscale,
 			tcp_time_stamp_raw() + tcptw->tw_ts_offset,
 			tcptw->tw_ts_recent, tw->tw_bound_dev_if, tcp_twsk_md5_key(tcptw),
-			tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel), 0);
+			tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel), tw->tw_priority);
 
 	inet_twsk_put(tw);
 }
-- 
2.23.0.351.gc4317032e6-goog

