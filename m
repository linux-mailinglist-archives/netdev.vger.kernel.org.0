Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7425BECE6
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbfD2Wqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:46:34 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:37708 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbfD2Wqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:46:33 -0400
Received: by mail-pg1-f201.google.com with SMTP id z12so8056574pgs.4
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 15:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MjrXChFdfqx4iZhHaJMNQ802cJzv3+cMZXlfwUwe+3Y=;
        b=s6CSIw9uxK7Vj0K87tLbUS90iB76zPfep8KKcOCm+jNxps3NgvDWEr7yMwOCt9g1oI
         Z8pcRIPGg3J+R6xwss74MUb0KEsXSpHae+LA3aZGjzu4c911+2ZMIxZVLLCNyeXQbx61
         GJMVUmNBNTH/xKPLcISw6+5ctUqqZEwgOai7X8acvxy/Z8CkG3rKtebPUyoQ8civumK5
         /xFbdd0yJ2WMUZxwo3CtOctb+fhSq4frC4D6DdJz6nBKm/nPbfwoW6txTQGpOLeJkXuh
         ebk1tJ8qTeEAO2dk7JohnNJOF4Maqudxt5daVX8Y6vqvwDFtvr+PRWTDk1PTxUb9WKEC
         lYwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MjrXChFdfqx4iZhHaJMNQ802cJzv3+cMZXlfwUwe+3Y=;
        b=e0rIgJ7bXK0kYCbbIaOFPfr4CY4ZvG+/WojBmTlqa1FxJ4fLSgxN1fg3biT2nUbdGV
         NHXU6nJ6/sYL0pZSzatbZeYpxcHw237IgoJOShGPadsa22Lr7qXQ5AwyOWHH9uPNJUIa
         MtDD7ydG9LYRncdsBb9ik2/6wDxB8mQuCLleJn2O+D7PLvUHnlse1SzKLFnwdRaaFwPz
         f4qV1kPAZOohyqm9Gr1AVz7QDRAy+PkqlMBmAf5kLYRew5SlngQVub7TnSop0JVG+4PU
         y1BVx6Bqes09EFV75oeaYWfXZkhF/OfZmHS9jwlL4VuPU9+spE79JPbdB1fdML46mteL
         bCQQ==
X-Gm-Message-State: APjAAAXgAuBXI3ynkVM4SWbLjrtS95HymI7h0L4mD39zj0CSqZboZQ0s
        lwCv4kZ6fSAK5cfT4rXoKmsqZo4b1U4=
X-Google-Smtp-Source: APXvYqz/Zt9ZLX1eZymMccfyhSvG7n5/b3l84IUmbrxTmeV6eu9I2nNWdvGUPqvJMHYICCmMRemoTv/21PE=
X-Received: by 2002:a63:4b21:: with SMTP id y33mr63863785pga.37.1556577992634;
 Mon, 29 Apr 2019 15:46:32 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:46:14 -0700
In-Reply-To: <20190429224620.151064-1-ycheng@google.com>
Message-Id: <20190429224620.151064-3-ycheng@google.com>
Mime-Version: 1.0
References: <20190429224620.151064-1-ycheng@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH net-next 2/8] tcp: undo initial congestion window on false SYN timeout
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, soheil@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux implements RFC6298 and use an initial congestion window of 1
upon establishing the connection if the SYN packet is retransmitted 2
or more times. In cellular networks SYN timeouts are often spurious
if the wireless radio was dormant or idle. Also some network path
is longer than the default SYN timeout. Having a minimal cwnd on
both cases are detrimental to TCP startup performance.

This patch extends TCP undo feature (RFC3522 aka TCP Eifel) to detect
spurious SYN timeout via TCP timestamps. Since tp->retrans_stamp
records the initial SYN timestamp instead of first retransmission, we
have to implement a different undo code additionally. The detection
also must happen before tcp_ack() as retrans_stamp is reset when
SYN is acknowledged.

Note this patch covers both active regular and fast open.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c   | 16 ++++++++++++++++
 net/ipv4/tcp_metrics.c |  2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e2cbfc3ffa3f..695f840acc14 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5748,6 +5748,21 @@ static void smc_check_reset_syn(struct tcp_sock *tp)
 #endif
 }
 
+static void tcp_try_undo_spurious_syn(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	u32 syn_stamp;
+
+	/* undo_marker is set when SYN or SYNACK times out. The timeout is
+	 * spurious if the ACK's timestamp option echo value matches the
+	 * original SYN timestamp.
+	 */
+	syn_stamp = tp->retrans_stamp;
+	if (tp->undo_marker && syn_stamp && tp->rx_opt.saw_tstamp &&
+	    syn_stamp == tp->rx_opt.rcv_tsecr)
+		tp->undo_marker = 0;
+}
+
 static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 					 const struct tcphdr *th)
 {
@@ -5815,6 +5830,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		tcp_ecn_rcv_synack(tp, th);
 
 		tcp_init_wl(tp, TCP_SKB_CB(skb)->seq);
+		tcp_try_undo_spurious_syn(sk);
 		tcp_ack(sk, skb, FLAG_SLOWPATH);
 
 		/* Ok.. it's good. Set up sequence numbers and
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index f262f2cace29..d4d687330e2b 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -517,7 +517,7 @@ void tcp_init_metrics(struct sock *sk)
 	 * initRTO, we only reset cwnd when more than 1 SYN/SYN-ACK
 	 * retransmission has occurred.
 	 */
-	if (tp->total_retrans > 1)
+	if (tp->total_retrans > 1 && tp->undo_marker)
 		tp->snd_cwnd = 1;
 	else
 		tp->snd_cwnd = tcp_init_cwnd(tp, dst);
-- 
2.21.0.593.g511ec345e18-goog

