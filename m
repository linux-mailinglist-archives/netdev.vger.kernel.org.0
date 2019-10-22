Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1452AE0E76
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 01:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389650AbfJVXLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 19:11:19 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42227 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389647AbfJVXLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 19:11:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id 21so350242pfj.9
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 16:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P2c/8plpwMSofPQHA6q0oGffHZXYNWk1bB7ctoUuHgE=;
        b=ciZl7tXFeXTGBFSw3CTUlwWi84eAllahDryhi2Vzg6687TNqgat7ZvwOpAIRfUZz72
         wwd0Vi4pvUtlNzBBR4wgdUpGxLEfCwRjAeLAQpq46loyQEh5TEjRiGWDGOV0Ye3pyO/y
         1AOOpTZ1sPK0ecZxsgD7E3ILJJLdriJphQukwNx3QpJ77tv7q7pjiLyP9ZJEu97rf1Vt
         YtZSLU5+NyTdzSLCejIvMY3CkM5bftNfWEgfhkKOv070/w1Tku38iylPKqqHm8nFu9zI
         +PdLVs7yWHlxqaou9+9I/K6LLZezqHC6/GuIu6hIzLXKO8GicBDPAAr0N4oQwibTv6ao
         lm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P2c/8plpwMSofPQHA6q0oGffHZXYNWk1bB7ctoUuHgE=;
        b=s+kXzN17qPeJSCRElgz0nV1IJX31jRiM3LF/0YQlM0/lm3j7q4M0/FbS6s/3K7CwkG
         nUhty9mmGJhhrFnaD35GcMpK4iNRfeU+M3hodEOSP6SItGTapO/R4dnHe94NucuUn8eZ
         HYOlycxyWKKpo3zzjwWjzann83cRidNxYG5sgoeV5kRtPGCV7cFQEYHsM8IXhsRkgxh+
         frYlwackfJXbXjUX4Qbs2t5u9pUYOgsfbOqg844rr/Ru5j0rOf8dhN2yAgZz/sGNWHm5
         AbzYientl3WcpDg2dcc/72GXkcilQMiaEfrX/4V7ao8f1Wyukfh8terKiLKED5/3X3+S
         5MjQ==
X-Gm-Message-State: APjAAAUdNzPO/0Yf1zn+yPR9e4mXLBbqq8mNnxtYyYHVr+hfhMYMpa/R
        hWKY71/uzBvUykUCQlcuo2dF1oA+
X-Google-Smtp-Source: APXvYqy2aAZMGUoutyA6wPtcH35sJn+cfJA08EfyE3sP66ksEpmjXfr7UvBcA6D+0K/0+2+hwUTc1w==
X-Received: by 2002:a62:37c7:: with SMTP id e190mr7355670pfa.130.1571785876260;
        Tue, 22 Oct 2019 16:11:16 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id j24sm20619284pff.71.2019.10.22.16.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 16:11:15 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ycheng@google.com, ncardwell@google.com, edumazet@google.com,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net-next 2/3] tcp: make tcp_send_loss_probe() boolean
Date:   Tue, 22 Oct 2019 16:10:50 -0700
Message-Id: <20191022231051.30770-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let tcp_send_loss_probe() return whether a TLP has been
sent or not. This is needed by the folllowing patch.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/net/tcp.h     | 2 +-
 net/ipv4/tcp_output.c | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ab4eb5eb5d07..0ee5400e751c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -581,7 +581,7 @@ void tcp_push_one(struct sock *, unsigned int mss_now);
 void __tcp_send_ack(struct sock *sk, u32 rcv_nxt);
 void tcp_send_ack(struct sock *sk);
 void tcp_send_delayed_ack(struct sock *sk);
-void tcp_send_loss_probe(struct sock *sk);
+bool tcp_send_loss_probe(struct sock *sk);
 bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto);
 void tcp_skb_collapse_tstamp(struct sk_buff *skb,
 			     const struct sk_buff *next_skb);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0488607c5cd3..9822820edca4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2539,12 +2539,13 @@ static bool skb_still_in_host_queue(const struct sock *sk,
 /* When probe timeout (PTO) fires, try send a new segment if possible, else
  * retransmit the last segment.
  */
-void tcp_send_loss_probe(struct sock *sk)
+bool tcp_send_loss_probe(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
 	int pcount;
 	int mss = tcp_current_mss(sk);
+	bool sent = false;
 
 	skb = tcp_send_head(sk);
 	if (skb && tcp_snd_wnd_test(tp, skb, mss)) {
@@ -2560,7 +2561,7 @@ void tcp_send_loss_probe(struct sock *sk)
 			  "invalid inflight: %u state %u cwnd %u mss %d\n",
 			  tp->packets_out, sk->sk_state, tp->snd_cwnd, mss);
 		inet_csk(sk)->icsk_pending = 0;
-		return;
+		return false;
 	}
 
 	/* At most one outstanding TLP retransmission. */
@@ -2592,11 +2593,13 @@ void tcp_send_loss_probe(struct sock *sk)
 	tp->tlp_high_seq = tp->snd_nxt;
 
 probe_sent:
+	sent = true;
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPLOSSPROBES);
 	/* Reset s.t. tcp_rearm_rto will restart timer from now */
 	inet_csk(sk)->icsk_pending = 0;
 rearm_timer:
 	tcp_rearm_rto(sk);
+	return sent;
 }
 
 /* Push out any pending frames which were held back due to
-- 
2.21.0

