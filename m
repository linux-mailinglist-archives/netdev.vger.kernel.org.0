Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F782635B2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgIISQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIISQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:16:17 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3973C061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:16:14 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id r128so1892241qkc.9
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wZb+bYOBCFyLXSATRBr9zjdlrGh9pUT/rzRHEgOsJSQ=;
        b=RRAGhKxkOOGzImEtbPe9UP8agWsW2AKPv9loFyGJK06nSt7a/fvXKSwe8jlcL+T1RX
         16bVL/MntfQJtSaoxnP6wVIHXdHOYBI887VV3nh1AFb/gHvxY79jGvfD9/QHsn3cXP1n
         YeTAh1yN4V6OuFRT1vGjwhLSrSeNiiZs5u1B/Z9aXeGVCe0chAeXGtPbp6P3fPwL73T/
         G5jPD6eethNLxLxld0qCYzKfw8qSYlwt+Eyf/VzN9jtteGQvaMIBxoED+AEeXIcvnldx
         pjTv5q4UTGFs3GuCgF1KPi8brc0j36kMjuGXfW3K70XC8QqTBVJvpv5MqkjfdFs8QsYI
         G+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wZb+bYOBCFyLXSATRBr9zjdlrGh9pUT/rzRHEgOsJSQ=;
        b=cHPGcpHx9R3XEmYIA2bDaGzIyrNzHrR21KG1DhM9RrRHHvKgNWo375qj3JuL4I4TaY
         kRtAMpaj27++M4213jdhGvUJJmRIPU/L+4M9Bs6tpBf4FoJiR3Cih7t6tQog+vN7UZyT
         rZaUIB0XiEH4YcqCzrYvSI77aNnRdulqKE+NAF508nz4eQLDUSkpN3AuWwYtAY2QVWQ+
         KD/JK5Z2LAr5I8cj3zXoRIxZ6a4w/ea6B3kHWCszVTutqSXYIxha95o5O43cbTqCOlli
         AVzanabrPxAlvvPmYFuoOQXerqxt0KTUKHwf34QeaL6eQfNGAbPpp/mk7dDxt9W5peQy
         yspw==
X-Gm-Message-State: AOAM533NW7rB07OW6G1XNsa+6WHRX5bvJe9pc+ZfHgf1tZvxwqhM/tPB
        DkPPKysMR2M98SJqpMhUVsdoru0iX447oBc=
X-Google-Smtp-Source: ABdhPJwLfvITa9OfIOIuLa+sx6Rhs1vMwYyxLgri5RF1dM4Qv/5g6QkH2aEun0Q8rUo0qeL2P5gHX0mXCFwb56A=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a0c:c289:: with SMTP id
 b9mr5311858qvi.31.1599675373343; Wed, 09 Sep 2020 11:16:13 -0700 (PDT)
Date:   Wed,  9 Sep 2020 14:15:53 -0400
In-Reply-To: <20200909181556.2945496-1-ncardwell@google.com>
Message-Id: <20200909181556.2945496-2-ncardwell@google.com>
Mime-Version: 1.0
References: <20200909181556.2945496-1-ncardwell@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next 1/4] tcp: only init congestion control if not
 initialized already
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
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

