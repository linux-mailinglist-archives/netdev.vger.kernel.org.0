Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC89A264F25
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgIJTgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgIJTfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:35:40 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255D7C061756
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:40 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id o16so7292002qkj.10
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzuy3mS2lrkDeS7MZAGJqfQvUzhOaWlcvy00vqFK1zA=;
        b=Onbeu+PChyU7NN/ZTdQi5zhItFgvCcwm1DMiaelclC2tnn+f1IcJcZ2Kej4HhyJxNX
         bfU3idyFO3eZeW0/oIuVZucyij88cyCLqRjLK7hkXRbXL77kgmwOvAu97l1LEGT+ktkM
         yWZkcx26PTWwtcLYqNHf2cj6PnTqg0eGjcMlh/flhcAbBoRFGAIPyGP4voi0Dqpj7cbK
         xVRGIufO/TZI13BhCgYdpjjqwqHsi4Lvp2Li/4/Y0V9TNKOQIXvFt3vTW6l0TbT3GjAJ
         rwKhpD2uk9/ayGIE6QFIIFJaJnrF4MATddE1MkgaEtlkvUcoVtVc8yHzLf0hbcDa78Q7
         pwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzuy3mS2lrkDeS7MZAGJqfQvUzhOaWlcvy00vqFK1zA=;
        b=WjVpdZyM0B/7gK/luBQ0aPxh6XJeXYYftaJc1GxXcTMJJsrJNb4HdSEq+ApdJ4UdaT
         8Z/6pGqy1jz3p5xKXI3yhO6z+0VRHQ8YQoSHRGA6me4lCWoWE+WzLR5Oj6UybfQ6daQE
         pYroXQ/gg6gMcTsIfsdYvtLQ43HWIe0Rb0H/mmVkK9akx1xVa7GOtrr2ZTmKXSLHnu9Y
         zIN06fgJaQQA8MDgM1FXDs4ikCGA9G74p9En2duBrYrj6DpI4dTxfzjmjYvtwiv4SfuD
         lfUMWG83NU3ODz6b7WmvZgs3TtAn7UmLmjTzkMTi9W5UoA06FYJiwYmVbZDDnIc09RX/
         mdLQ==
X-Gm-Message-State: AOAM533sQhKBtDJsoldmiSNyotJwN0uiQywfSBbijd64t6r792JTxhmK
        YxEVJZMJcR/23e9FZ/nBgJ49UMiXPEZh9Mh8
X-Google-Smtp-Source: ABdhPJzmdtq5BVUMJl9aUIeVlz5lpPVcUGGUVjODts2X3koY2kq+6YspPjxvwADMu25qQI72zO2teQ==
X-Received: by 2002:a37:9c8:: with SMTP id 191mr9534538qkj.292.1599766539412;
        Thu, 10 Sep 2020 12:35:39 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id f13sm7735484qko.122.2020.09.10.12.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:35:38 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Subject: [PATCH bpf-next v3 1/5] tcp: only init congestion control if not initialized already
Date:   Thu, 10 Sep 2020 15:35:32 -0400
Message-Id: <20200910193536.2980613-2-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200910193536.2980613-1-ncardwell.kernel@gmail.com>
References: <20200910193536.2980613-1-ncardwell.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

Change tcp_init_transfer() to only initialize congestion control if it
has not been initialized already.

With this new approach, we can arrange things so that if the EBPF code
sets the congestion control by calling setsockopt(TCP_CONGESTION) then
tcp_init_transfer() will not re-initialize the CC module.

This is an approach that has the following beneficial properties:

(1) This allows CC module customizations made by the EBPF called in
    tcp_init_transfer() to persist, and not be wiped out by a later
    call to tcp_init_congestion_control() in tcp_init_transfer().

(2) Does not flip the order of EBPF and CC init, to avoid causing bugs
    for existing code upstream that depends on the current order.

(3) Does not cause 2 initializations for for CC in the case where the
    EBPF called in tcp_init_transfer() wants to set the CC to a new CC
    algorithm.

(4) Allows follow-on simplifications to the code in net/core/filter.c
    and net/ipv4/tcp_cong.c, which currently both have some complexity
    to special-case CC initialization to avoid double CC
    initialization if EBPF sets the CC.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Kevin Yang <yyd@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lawrence Brakmo <brakmo@fb.com>
---
 include/net/inet_connection_sock.h | 3 ++-
 net/ipv4/tcp.c                     | 1 +
 net/ipv4/tcp_cong.c                | 3 ++-
 net/ipv4/tcp_input.c               | 4 +++-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c738abeb3265..dc763ca9413c 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -96,7 +96,8 @@ struct inet_connection_sock {
 	void (*icsk_clean_acked)(struct sock *sk, u32 acked_seq);
 	struct hlist_node         icsk_listen_portaddr_node;
 	unsigned int		  (*icsk_sync_mss)(struct sock *sk, u32 pmtu);
-	__u8			  icsk_ca_state:6,
+	__u8			  icsk_ca_state:5,
+				  icsk_ca_initialized:1,
 				  icsk_ca_setsockopt:1,
 				  icsk_ca_dst_locked:1;
 	__u8			  icsk_retransmits;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 57a568875539..7360d3db2b61 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2698,6 +2698,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	if (icsk->icsk_ca_ops->release)
 		icsk->icsk_ca_ops->release(sk);
 	memset(icsk->icsk_ca_priv, 0, sizeof(icsk->icsk_ca_priv));
+	icsk->icsk_ca_initialized = 0;
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
 	tcp_clear_retrans(tp);
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 62878cf26d9c..d18d7a1ce4ce 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -176,7 +176,7 @@ void tcp_assign_congestion_control(struct sock *sk)
 
 void tcp_init_congestion_control(struct sock *sk)
 {
-	const struct inet_connection_sock *icsk = inet_csk(sk);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 
 	tcp_sk(sk)->prior_ssthresh = 0;
 	if (icsk->icsk_ca_ops->init)
@@ -185,6 +185,7 @@ void tcp_init_congestion_control(struct sock *sk)
 		INET_ECN_xmit(sk);
 	else
 		INET_ECN_dontxmit(sk);
+	icsk->icsk_ca_initialized = 1;
 }
 
 static void tcp_reinit_congestion_control(struct sock *sk,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4337841faeff..0e5ac0d33fd3 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5894,8 +5894,10 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 		tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 
+	icsk->icsk_ca_initialized = 0;
 	bpf_skops_established(sk, bpf_op, skb);
-	tcp_init_congestion_control(sk);
+	if (!icsk->icsk_ca_initialized)
+		tcp_init_congestion_control(sk);
 	tcp_init_buffer_space(sk);
 }
 
-- 
2.28.0.618.gf4bc123cb7-goog

