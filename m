Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6C4BCAC0
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389160AbfIXPBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:01:36 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:46655 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388811AbfIXPBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 11:01:36 -0400
Received: by mail-ua1-f73.google.com with SMTP id q34so480388uad.13
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 08:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=G02TaopAHL3sQvyO0fGLq1rgSwiaFNmUqfxQCNkHNss=;
        b=jztcPF3avuePZVFCBP90DnyWpDliOh2JRygc8REWLqBsIFkFm3h1Ce6kbpQG4monj8
         OmMSCAslwPJ5hBfhi4UGPtTka8/YyCou+tYrUEBnyavgmgAs/AlLyqz8PS9vSN1yNTOb
         Ps6zkxoER2ihIYJRah00qGJ1lCQ+cn3hQ0mr1y0+hEUAogUtF1RC9q1BtybLWEqfMueT
         IbvUj/7ViWPh6an9hy6KDXOzZFikNCXtAIaIvSbuCVaQ0QRhsuiB1cz1iEPIqLXTLSV3
         THER3XUN04BU/1w49DOHnD7iMsnODofgMBarU7z/jQJhO1TWVrvVAMG2GkCzcGb6aoq0
         gi+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=G02TaopAHL3sQvyO0fGLq1rgSwiaFNmUqfxQCNkHNss=;
        b=NtqXOLGb5KoeDokrsJPL//G95F2LLTCHQc5Mzweb3bpyV23F4ixhTgz4TN5wGfMFDx
         BQ0Y5ASiN3tl7hXiseJcOrLtf5oprZxgf1/ORHXCeIcgBaTceksG2zvcnXOk4nPZU1nn
         YUEp+VBhhWtGrjar/pinjmc5NgGkMmcNrDO+2pUlXVssku1dobRiIqEvAt/TerKU7pFy
         2XfP/pw62y6HqZ4ODqeCQpya7a6Qh4NyUzS8Cotb9alXHDKT5rxOc2+LPlWaPxAyp9C1
         z6pSm57r+L3+0OyUtWelxyzYmziyIhlcPYxxoOsuAIvgZKcmmDJFZktglFnQZDssUIRV
         pFhw==
X-Gm-Message-State: APjAAAWK3GqKrubetxyUhPpvFMth2uAx08Ws2DZBitMEMmFrVY4biEHc
        ZeCkPToSqfTv/ZS5lCZkJqoShuvsVUHUhw==
X-Google-Smtp-Source: APXvYqy5228LVCESghHlyEwUQX75JqYdDzIqU0BddYn9LK0c8tdPFVCBB9X3xouItHr+lFQDBMF5gGW2tEyZbA==
X-Received: by 2002:a1f:f445:: with SMTP id s66mr1722614vkh.62.1569337294466;
 Tue, 24 Sep 2019 08:01:34 -0700 (PDT)
Date:   Tue, 24 Sep 2019 08:01:15 -0700
In-Reply-To: <20190924150116.199028-1-edumazet@google.com>
Message-Id: <20190924150116.199028-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190924150116.199028-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH net 2/3] ipv6: tcp: provide sk->sk_priority to ctl packets
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

We can populate skb->priority for some ctl packets
instead of always using zero.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/tcp_ipv6.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 806064c2886777ad37a1f0b8406aa8bee7945723..5f557bf27da2ba6bcc74034a53a3f76a99fdf9f4 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -804,7 +804,7 @@ static const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32 seq,
 				 u32 ack, u32 win, u32 tsval, u32 tsecr,
 				 int oif, struct tcp_md5sig_key *key, int rst,
-				 u8 tclass, __be32 label)
+				 u8 tclass, __be32 label, u32 priority)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcphdr *t1;
@@ -909,7 +909,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL, tclass,
-			 0);
+			 priority);
 		TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 		if (rst)
 			TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
@@ -932,6 +932,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	struct sock *sk1 = NULL;
 #endif
 	__be32 label = 0;
+	u32 priority = 0;
 	struct net *net;
 	int oif = 0;
 
@@ -992,6 +993,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 			trace_tcp_send_reset(sk, skb);
 			if (np->repflow)
 				label = ip6_flowlabel(ipv6h);
+			priority = sk->sk_priority;
 		}
 		if (sk->sk_state == TCP_TIME_WAIT)
 			label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
@@ -1001,7 +1003,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	}
 
 	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1, 0,
-			     label);
+			     label, priority);
 
 #ifdef CONFIG_TCP_MD5SIG
 out:
@@ -1012,10 +1014,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 static void tcp_v6_send_ack(const struct sock *sk, struct sk_buff *skb, u32 seq,
 			    u32 ack, u32 win, u32 tsval, u32 tsecr, int oif,
 			    struct tcp_md5sig_key *key, u8 tclass,
-			    __be32 label)
+			    __be32 label, u32 priority)
 {
 	tcp_v6_send_response(sk, skb, seq, ack, win, tsval, tsecr, oif, key, 0,
-			     tclass, label);
+			     tclass, label, priority);
 }
 
 static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
@@ -1027,7 +1029,7 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			tcptw->tw_rcv_wnd >> tw->tw_rcv_wscale,
 			tcp_time_stamp_raw() + tcptw->tw_ts_offset,
 			tcptw->tw_ts_recent, tw->tw_bound_dev_if, tcp_twsk_md5_key(tcptw),
-			tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel));
+			tw->tw_tclass, cpu_to_be32(tw->tw_flowlabel), 0);
 
 	inet_twsk_put(tw);
 }
@@ -1050,7 +1052,7 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			req->ts_recent, sk->sk_bound_dev_if,
 			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr),
-			0, 0);
+			0, 0, sk->sk_priority);
 }
 
 
-- 
2.23.0.351.gc4317032e6-goog

