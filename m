Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173FE2647BF
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbgIJOHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbgIJOEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:04:46 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABD9C061345
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:04:42 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id o14so4253325qtq.0
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wZb+bYOBCFyLXSATRBr9zjdlrGh9pUT/rzRHEgOsJSQ=;
        b=ZA30eiw2EqodgjOkBTLdZpJZcv8nDCXfV/j35v6bFXfhwKpVt/eOLgdRg50bB8owQP
         bP7mXWsdrXng1cOi4gOAYiKVYqWw4aDeYA7GqCQ9pGRt2U79slTkm/9oPpdHOHJetV7x
         W3Ko40S9v5oHvTWqMRUTQN3ubB9uupPowEhs8+8zb0XpRaW4ED19PbdlMH7Jf5gf8B9W
         zFuJYR1RoDo7yXVtFNVr/NmwyHmY5xOQStgMYD5gi1ZK1KlXaLM45yoamA8hL4X91Qin
         fy0gb4HabaA27lRux/YOVj1dOkM8pg0fh6heuo4INUhhggz1ptr0DXAfDXloBYB7M/rw
         PBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wZb+bYOBCFyLXSATRBr9zjdlrGh9pUT/rzRHEgOsJSQ=;
        b=eHxCgkuVL7GIfwdj6R7c/8nq4dBLoz0W65U8v0p+Pe4G7AliLBNn84yameqEtnTgkF
         vsgKDTCRR9UlZfFxaspPeD4aRZqH3Gdllq+L0XB1UxYUE6NLxK/k/LYi9EoTBa4Do9d6
         1HWbzPRFEy2bFeSSTikyAvVEJzIvYcm0R0+ws4smD4/LQtxaug7z8AhwKxtCiQzLRwkn
         zU6gyGKLDTRp7Tad8MvhbvkIWRado2r7mHyECpvpicwpeZ28IYy47BzR08RxBssNpzkx
         e1ut7BF6sesIJ5v7a8Y+sgyS08l8QZ60zMeCK+j/655muTGBQ8k5YTfFYdAqBswEpTMa
         mDrQ==
X-Gm-Message-State: AOAM5321V/FneKQmN5LewzkMyJfO0CDVWVesPIEOJYG6DUqbvCKHaybZ
        6wIIsyoLJCLEIqw/5fkUbtbocqxxJyVT3Ew=
X-Google-Smtp-Source: ABdhPJwstIQ+ToMb2krrdnUUZuhBvvKyjAYX6JCmXbRjV+aCMnn6RfXtLPry0J2KPHbvL+WQ2Fwgxlo2juKvffE=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a0c:a063:: with SMTP id
 b90mr6224285qva.25.1599746682043; Thu, 10 Sep 2020 07:04:42 -0700 (PDT)
Date:   Thu, 10 Sep 2020 10:04:24 -0400
In-Reply-To: <20200910140428.751193-1-ncardwell@google.com>
Message-Id: <20200910140428.751193-2-ncardwell@google.com>
Mime-Version: 1.0
References: <20200910140428.751193-1-ncardwell@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 1/5] tcp: only init congestion control if not
 initialized already
From:   Neal Cardwell <ncardwell@google.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.28.0.526.ge36021eeef-goog

