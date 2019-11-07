Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4792F38F6
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 20:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKGTvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 14:51:22 -0500
Received: from mail-ua1-f74.google.com ([209.85.222.74]:54909 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfKGTvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 14:51:22 -0500
Received: by mail-ua1-f74.google.com with SMTP id x2so1255079uaj.21
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 11:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zhpyjuWZ/k1ezMkhm0UPYsDdw1y5VuMvGibPUKSdDNQ=;
        b=fCq5CsISi+IOuuQXWPqEzzpJY1/BlB3fqc46UFe2NuwpRfzyjYQ6b5IH3RPf4aPNBf
         FMpph1/RcexnxTW2i+uMliCB4KYfVOqIlwob/hBzTitO7hn1qyoYFmfy1HEa/+ClkRnA
         bHespfwLjKv3Z03oGbxkQhcNVWd0hKAXWUe1h9wcAnTxDQAD6U8St9uyTuvq6XF6ORBF
         qRibDJygiIKbktuwgWQYfDC4jAbvMLXy1kLdfVFEwnqyDcb2JK67ZI8luWQI9qgT9NSz
         t6dkNks1BQNTAeYdAhctDiyH+RhOPkpTtwxh2SxjOR+jQIZEK5S/oSOU5ReMKSYigtoc
         zYxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zhpyjuWZ/k1ezMkhm0UPYsDdw1y5VuMvGibPUKSdDNQ=;
        b=ORjA0VW167TESlOkuqCuEKJMNcnCsILCkWqdJ9fi5QSj3pmYNXdehEG2xGQbnvOZYu
         tcaDunrAsbvi5E87GqoxzsmAPGlyy3jdF1UUZ/uc88ggxDh3KzbaOmq9db4xmB0A0N6f
         Aq1Bn4gnFcN5jCcFL+ECxZH1MNbARjqHSqaHi9CkrlEhKFlSZEqNlZ3UAvrpZ3vPRbnq
         WObBmX1T6VFfr3d+4PyAIuTpha86YOvSXprIMUTHjZzqsm8hEj41zNHbNcYBGgvuCI/8
         FW5cXLgh4Q5nMIYq7lfcXetKDzI+y6HpMllp6ciAo368QG3OJ1Rd8RyZ3IDeasFol9h+
         pvTA==
X-Gm-Message-State: APjAAAXe9olBCwj2snEAs7iiqFnhyDn3SnA12Lu6ok6UGYCny3q1VGyc
        KbiGRChM/ZJVO0hM8dJRYa8H/XU3Ex0Dcg==
X-Google-Smtp-Source: APXvYqx3UcoPLpbHZ8Gu/eAo+vBlWWgIUCiMcw/93rp7KwlLSexK5DKfFjvHQfFgEZP+NmxJwJOR+BeieRiPCQ==
X-Received: by 2002:ab0:240d:: with SMTP id f13mr3452169uan.71.1573156281611;
 Thu, 07 Nov 2019 11:51:21 -0800 (PST)
Date:   Thu,  7 Nov 2019 11:51:18 -0800
Message-Id: <20191107195118.200387-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] tcp: Remove one extra ktime_get_ns() from cookie_init_timestamp
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

tcp_make_synack() already uses tcp_clock_ns(), and can pass
the value to cookie_init_timestamp() to avoid another call
to ktime_get_ns() helper.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h     | 12 +++++++++---
 net/ipv4/syncookies.c |  4 ++--
 net/ipv4/tcp_output.c |  2 +-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ab4eb5eb5d0705b815e5eec3a772d4776be8653e..36f195fb576a26237e81a5890c5a2e9d9e304722 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -537,7 +537,7 @@ static inline u32 tcp_cookie_time(void)
 u32 __cookie_v4_init_sequence(const struct iphdr *iph, const struct tcphdr *th,
 			      u16 *mssp);
 __u32 cookie_v4_init_sequence(const struct sk_buff *skb, __u16 *mss);
-u64 cookie_init_timestamp(struct request_sock *req);
+u64 cookie_init_timestamp(struct request_sock *req, u64 now);
 bool cookie_timestamp_decode(const struct net *net,
 			     struct tcp_options_received *opt);
 bool cookie_ecn_ok(const struct tcp_options_received *opt,
@@ -757,10 +757,16 @@ static inline u32 tcp_time_stamp(const struct tcp_sock *tp)
 	return div_u64(tp->tcp_mstamp, USEC_PER_SEC / TCP_TS_HZ);
 }
 
+/* Convert a nsec timestamp into TCP TSval timestamp (ms based currently) */
+static inline u32 tcp_ns_to_ts(u64 ns)
+{
+	return div_u64(ns, NSEC_PER_SEC / TCP_TS_HZ);
+}
+
 /* Could use tcp_clock_us() / 1000, but this version uses a single divide */
 static inline u32 tcp_time_stamp_raw(void)
 {
-	return div_u64(tcp_clock_ns(), NSEC_PER_SEC / TCP_TS_HZ);
+	return tcp_ns_to_ts(tcp_clock_ns());
 }
 
 void tcp_mstamp_refresh(struct tcp_sock *tp);
@@ -772,7 +778,7 @@ static inline u32 tcp_stamp_us_delta(u64 t1, u64 t0)
 
 static inline u32 tcp_skb_timestamp(const struct sk_buff *skb)
 {
-	return div_u64(skb->skb_mstamp_ns, NSEC_PER_SEC / TCP_TS_HZ);
+	return tcp_ns_to_ts(skb->skb_mstamp_ns);
 }
 
 /* provide the departure time in us unit */
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 535b69326f66aa0733d8a443f1083a997f9683f2..345b2b0ff618509bc50e244c2ab44c0bbdfbba3e 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -62,10 +62,10 @@ static u32 cookie_hash(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport,
  * Since subsequent timestamps use the normal tcp_time_stamp value, we
  * must make sure that the resulting initial timestamp is <= tcp_time_stamp.
  */
-u64 cookie_init_timestamp(struct request_sock *req)
+u64 cookie_init_timestamp(struct request_sock *req, u64 now)
 {
 	struct inet_request_sock *ireq;
-	u32 ts, ts_now = tcp_time_stamp_raw();
+	u32 ts, ts_now = tcp_ns_to_ts(now);
 	u32 options = 0;
 
 	ireq = inet_rsk(req);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0488607c5cd3615633af207f0bb41bea0c0176ce..be6d22b8190fa375074062032105879270af4be5 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3290,7 +3290,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	now = tcp_clock_ns();
 #ifdef CONFIG_SYN_COOKIES
 	if (unlikely(req->cookie_ts))
-		skb->skb_mstamp_ns = cookie_init_timestamp(req);
+		skb->skb_mstamp_ns = cookie_init_timestamp(req, now);
 	else
 #endif
 	{
-- 
2.24.0.432.g9d3f5f5b63-goog

