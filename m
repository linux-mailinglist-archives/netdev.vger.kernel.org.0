Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88C957CEA8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiGUPKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiGUPKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:10:49 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5485068DE6
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:10:48 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id p6so2173136ljc.8
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MnsWlVxaF7Srg+TkrPklfprDn+x//MhQnX3HOcVLJO4=;
        b=YjtCr2Gxh3gc1gRMcK3focPeBKwSklW36B92yHY52Npm0KqCkcpp7uxPAqeLZlcoM7
         pg2McOfr+qWhBXUDA+s6LySq2uo2SB6WIYxhNeppJgNKclhCD40nmJuCuJFpaZZ4neNd
         LOCoFE0IUSiaR99TeNxhYYgk54I+VUk71sJyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MnsWlVxaF7Srg+TkrPklfprDn+x//MhQnX3HOcVLJO4=;
        b=QNaJ+pcdxfZgWrjz2iv16YOonISZUHXrQtT1tXc7TOBxtefj7MhLPrcyQ3gh+2MDWM
         iqH6R1uNL9e6qMr3o+A9SIINzbvYwc8XP/L8Y24W6GuiaSLBSRmK89e2876jX9IQ7LX2
         ZCfSPxhU/yCmyHVTPXfMqF/lENopeOq6dhhkxKAblUQ/9Hc+xzDuSniTRGvXQ5l9Z4ei
         oQV+yN8FUMk335eVJiJyhv1RE1CuYCEL6+Dm0RJWKE6RCCZlMM5pzRBX2J1TusdBnsyA
         JUQH/Frp6GFofSXUl7N/VX4MrtFs87ZToZzQb4xYITctULBtG7xCFTQQfdAbxZsK0Xa6
         xHhA==
X-Gm-Message-State: AJIora9BWrHmr7XHIDLpw435IBBKyjsEEIPSkCB06E4IyIPVHCXNw+Ea
        VavHJz9sTAAGIWnfI1pfodL7LjfDKuUHSQ==
X-Google-Smtp-Source: AGRyM1tvjhR0FO0Zu1Zzqqh0d/4relKQA1AMwtEQp6yiNfEwOJdQS/pbOh+iUlFZU1uCy1k7Xwof2w==
X-Received: by 2002:a05:651c:150b:b0:25d:ead1:dfa1 with SMTP id e11-20020a05651c150b00b0025dead1dfa1mr359331ljf.172.1658416245175;
        Thu, 21 Jul 2022 08:10:45 -0700 (PDT)
Received: from mrprec.home (2a01-110f-4304-1700-37e6-7a9a-2637-d666.aa.ipv6.supernova.orange.pl. [2a01:110f:4304:1700:37e6:7a9a:2637:d666])
        by smtp.gmail.com with ESMTPSA id f3-20020a056512228300b00489dbecbd0csm205508lfu.189.2022.07.21.08.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:10:44 -0700 (PDT)
From:   Marek Majkowski <marek@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, kernel-team@cloudflare.com,
        ivan@cloudflare.com, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH net-next 1/2] RTAX_INITRWND should be able to bring the rcv_ssthresh above 64KiB
Date:   Thu, 21 Jul 2022 17:10:40 +0200
Message-Id: <20220721151041.1215017-2-marek@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220721151041.1215017-1-marek@cloudflare.com>
References: <20220721151041.1215017-1-marek@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We already support RTAX_INITRWND / initrwnd path attribute:

 $ ip route change local 127.0.0.0/8 dev lo initrwnd 1024

However normally, the initial advertised receive window is limited to
64KiB by rcv_ssthresh, regardless of initrwnd. This patch changes
that, bumping up rcv_ssthresh to value derived from initrwnd. This
allows for larger initial advertised receive windows, which is useful
for specific types of TCP flows: big BDP ones, where there is a lot of
data to send immediately after the flow is established.

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
 include/net/inet_sock.h  |  1 +
 net/ipv4/tcp_minisocks.c |  8 ++++++--
 net/ipv4/tcp_output.c    | 10 ++++++++--
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index daead5fb389a..bc68c9b70942 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -89,6 +89,7 @@ struct inet_request_sock {
 				no_srccheck: 1,
 				smc_ok	   : 1;
 	u32                     ir_mark;
+	u32                     rcv_ssthresh;
 	union {
 		struct ip_options_rcu __rcu	*ireq_opt;
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 6854bb1fb32b..89ba2a30a012 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -360,6 +360,7 @@ void tcp_openreq_init_rwin(struct request_sock *req,
 	u32 window_clamp;
 	__u8 rcv_wscale;
 	u32 rcv_wnd;
+	int adj_mss;
 	int mss;
 
 	mss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
@@ -378,15 +379,18 @@ void tcp_openreq_init_rwin(struct request_sock *req,
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
+	ireq->rcv_ssthresh = max(req->rsk_rcv_wnd, rcv_wnd * adj_mss);
 }
 EXPORT_SYMBOL(tcp_openreq_init_rwin);
 
@@ -502,7 +506,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	newtp->rx_opt.tstamp_ok = ireq->tstamp_ok;
 	newtp->rx_opt.sack_ok = ireq->sack_ok;
 	newtp->window_clamp = req->rsk_window_clamp;
-	newtp->rcv_ssthresh = req->rsk_rcv_wnd;
+	newtp->rcv_ssthresh = ireq->rcv_ssthresh;
 	newtp->rcv_wnd = req->rsk_rcv_wnd;
 	newtp->rx_opt.wscale_ok = ireq->wscale_ok;
 	if (newtp->rx_opt.wscale_ok) {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 18c913a2347a..0f2d4174ea59 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3642,6 +3642,7 @@ static void tcp_connect_init(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	__u8 rcv_wscale;
 	u32 rcv_wnd;
+	u32 mss;
 
 	/* We'll fix this up when we get a response from the other end.
 	 * See tcp_input.c:tcp_rcv_state_process case TCP_SYN_SENT.
@@ -3679,8 +3680,10 @@ static void tcp_connect_init(struct sock *sk)
 	if (rcv_wnd == 0)
 		rcv_wnd = dst_metric(dst, RTAX_INITRWND);
 
+	mss = tp->advmss - (tp->rx_opt.ts_recent_stamp ?
+			    tp->tcp_header_len - sizeof(struct tcphdr) : 0);
 	tcp_select_initial_window(sk, tcp_full_space(sk),
-				  tp->advmss - (tp->rx_opt.ts_recent_stamp ? tp->tcp_header_len - sizeof(struct tcphdr) : 0),
+				  mss,
 				  &tp->rcv_wnd,
 				  &tp->window_clamp,
 				  sock_net(sk)->ipv4.sysctl_tcp_window_scaling,
@@ -3688,7 +3691,10 @@ static void tcp_connect_init(struct sock *sk)
 				  rcv_wnd);
 
 	tp->rx_opt.rcv_wscale = rcv_wscale;
-	tp->rcv_ssthresh = tp->rcv_wnd;
+	if (rcv_wnd)
+		tp->rcv_ssthresh = max(tp->rcv_wnd, rcv_wnd * mss);
+	else
+		tp->rcv_ssthresh = tp->rcv_wnd;
 
 	sk->sk_err = 0;
 	sock_reset_flag(sk, SOCK_DONE);
-- 
2.25.1

