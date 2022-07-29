Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761615851B4
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 16:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbiG2OkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 10:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbiG2Oj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 10:39:57 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BCB7E01E
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:39:55 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id z25so7644599lfr.2
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oIQ2EgXZ7Eu1hGVVR2fC7B5VBXnRV+BOddg67Ret5Q4=;
        b=NJxstEq42vakEqGC+uke+hdqSLktMMCvwdcZr1ANDDgB6wQexa5Lf4r4vbJaMivnlL
         9O0Y9oDwFzF5BO56Zdq+gJ9d4d9ivuEk7VQanyWHXNzsZXBSRENxi0dR+Av+/nWfP5Hu
         laVUrqdqR9d0QQzW02yEl72FZDPJ4XP4bpEbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oIQ2EgXZ7Eu1hGVVR2fC7B5VBXnRV+BOddg67Ret5Q4=;
        b=3NXmFmw8Rcgki2jBZ53ci33CRZNnMCPFCN3BCfnJLktbhtI1sUT7cBO28jn5367B6i
         +NbXfqPwoneT7EEbTHBKRgH/7eWuczgM2+XRNJuWO4NP3kDulMQG8ETvqqnVBRBCNEdS
         u2cyI5tlLFuuqeZ2koOqlEm8f7vv/ifwopEf1uF2ONCgzZlL2VOf3w3NxXGMhgFZj0IG
         5aA4pifHiPWOXxdO+scdtOvZeFX6MW0/8mzsaeT4nLrrZBXrSa1t5r0oSTV86GeRSi/x
         qJyymNRkMbbDcFk0tyU+eHLe4CJjyTIN2De9BKfhQ9VC3OT5oj/9QoLL3BBRi4F6IqFg
         3XhQ==
X-Gm-Message-State: ACgBeo3XWWLdcPQYBLUYVfFEub+5snbP/52LgNwZA6LNpxHMVjkslvBj
        qc8idGdTR3j1mreDibS+p1P1Kur/6gcsyw==
X-Google-Smtp-Source: AGRyM1smh87hj1rUrP8NxhlJUGOD7JPn+TwiY5ph3GYe8tLSXvh4ams6XoNHk2A7dji2rgc6pZp1ag==
X-Received: by 2002:a05:6512:3e03:b0:48a:9d32:5652 with SMTP id i3-20020a0565123e0300b0048a9d325652mr1302209lfv.41.1659105593537;
        Fri, 29 Jul 2022 07:39:53 -0700 (PDT)
Received: from localhost.localdomain ([2a01:110f:4304:1700:d82f:ac98:7032:476e])
        by smtp.gmail.com with ESMTPSA id i2-20020a196d02000000b0048ab15f2262sm678380lfc.96.2022.07.29.07.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 07:39:53 -0700 (PDT)
From:   Marek Majkowski <marek@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, kernel-team@cloudflare.com,
        ivan@cloudflare.com, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, brakmo@fb.com,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH net-next v2 1/2] RTAX_INITRWND should be able to set the rcv_ssthresh above 64KiB
Date:   Fri, 29 Jul 2022 16:39:34 +0200
Message-Id: <20220729143935.2432743-2-marek@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220729143935.2432743-1-marek@cloudflare.com>
References: <20220729143935.2432743-1-marek@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are three places where we initialize sockets:
 - tcp_output:tcp_connect_init
 - tcp_minisocks:tcp_openreq_init_rwin
 - syncookies

In the first two we already have a call to `tcp_rwnd_init_bpf` and
`dst_metric(RTAX_INITRWND)` which retrieve the bpf/path initrwnd
attribute. We use this value to bring `rcv_ssthresh` up, potentially
above the traditional 64KiB.

With higher initial `rcv_ssthresh` the receiver will open the receive
window more aggresively, which can improve large BDP flows - large
throughput and latency.

This patch does not cover the syncookies case.

Signed-off-by: Marek Majkowski <marek@cloudflare.com>
---
 include/linux/tcp.h      | 1 +
 net/ipv4/tcp_minisocks.c | 9 +++++++--
 net/ipv4/tcp_output.c    | 7 +++++--
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index a9fbe22732c3..c7a8c71536f8 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -164,6 +164,7 @@ struct tcp_request_sock {
 						  * FastOpen it's the seq#
 						  * after data-in-SYN.
 						  */
+	u32				rcv_ssthresh;
 	u8				syn_tos;
 };
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cb95d88497ae..8e5a3bd9a55b 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -355,11 +355,13 @@ void tcp_openreq_init_rwin(struct request_sock *req,
 			   const struct dst_entry *dst)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
+	struct tcp_request_sock *treq = tcp_rsk(req);
 	const struct tcp_sock *tp = tcp_sk(sk_listener);
 	int full_space = tcp_full_space(sk_listener);
 	u32 window_clamp;
 	__u8 rcv_wscale;
 	u32 rcv_wnd;
+	int adj_mss;
 	int mss;
 
 	mss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
@@ -377,16 +379,19 @@ void tcp_openreq_init_rwin(struct request_sock *req,
 		rcv_wnd = dst_metric(dst, RTAX_INITRWND);
 	else if (full_space < rcv_wnd * mss)
 		full_space = rcv_wnd * mss;
+	adj_mss = mss - (ireq->tstamp_ok ? TCPOLEN_TSTAMP_ALIGNED : 0);
+
 
 	/* tcp_full_space because it is guaranteed to be the first packet */
 	tcp_select_initial_window(sk_listener, full_space,
-		mss - (ireq->tstamp_ok ? TCPOLEN_TSTAMP_ALIGNED : 0),
+		adj_mss,
 		&req->rsk_rcv_wnd,
 		&req->rsk_window_clamp,
 		ireq->wscale_ok,
 		&rcv_wscale,
 		rcv_wnd);
 	ireq->rcv_wscale = rcv_wscale;
+	treq->rcv_ssthresh = max(tp->rcv_wnd, rcv_wnd * adj_mss);
 }
 EXPORT_SYMBOL(tcp_openreq_init_rwin);
 
@@ -502,7 +507,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	newtp->rx_opt.tstamp_ok = ireq->tstamp_ok;
 	newtp->rx_opt.sack_ok = ireq->sack_ok;
 	newtp->window_clamp = req->rsk_window_clamp;
-	newtp->rcv_ssthresh = req->rsk_rcv_wnd;
+	newtp->rcv_ssthresh = treq->rcv_ssthresh;
 	newtp->rcv_wnd = req->rsk_rcv_wnd;
 	newtp->rx_opt.wscale_ok = ireq->wscale_ok;
 	if (newtp->rx_opt.wscale_ok) {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 78b654ff421b..56f22d5da3a7 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3649,6 +3649,7 @@ static void tcp_connect_init(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	__u8 rcv_wscale;
 	u32 rcv_wnd;
+	u32 adj_mss;
 
 	/* We'll fix this up when we get a response from the other end.
 	 * See tcp_input.c:tcp_rcv_state_process case TCP_SYN_SENT.
@@ -3686,8 +3687,10 @@ static void tcp_connect_init(struct sock *sk)
 	if (rcv_wnd == 0)
 		rcv_wnd = dst_metric(dst, RTAX_INITRWND);
 
+	adj_mss = tp->advmss - (tp->rx_opt.ts_recent_stamp ?
+			    tp->tcp_header_len - sizeof(struct tcphdr) : 0);
 	tcp_select_initial_window(sk, tcp_full_space(sk),
-				  tp->advmss - (tp->rx_opt.ts_recent_stamp ? tp->tcp_header_len - sizeof(struct tcphdr) : 0),
+				  adj_mss,
 				  &tp->rcv_wnd,
 				  &tp->window_clamp,
 				  READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling),
@@ -3695,7 +3698,7 @@ static void tcp_connect_init(struct sock *sk)
 				  rcv_wnd);
 
 	tp->rx_opt.rcv_wscale = rcv_wscale;
-	tp->rcv_ssthresh = tp->rcv_wnd;
+	tp->rcv_ssthresh = max(tp->rcv_wnd, rcv_wnd * adj_mss);
 
 	sk->sk_err = 0;
 	sock_reset_flag(sk, SOCK_DONE);
-- 
2.25.1

