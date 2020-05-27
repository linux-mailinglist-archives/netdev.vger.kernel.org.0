Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F481E35DF
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 04:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgE0CtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 22:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0CtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 22:49:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137CEC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 19:49:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h129so23117894ybc.3
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 19:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B1e+m3MZixl0oCp8sU0iwCzGTDQQ+5RrheGCvqq1/GY=;
        b=MH67Fk7UmPbLgWJ8UQB5wpSIkV/q+rcec7gQA/1WxFSO/Yr7n8Cr28X7ZROx/zu4bq
         GVT+4kVgLoysjNniORtPySI4hBjUZonlXMOMidM0BAPpcr70S+K4J+9lx5SZoD9wt6At
         C0mOweuRNFm63wQ4X2JQBjMNSPGkeyHg9huMNibr9VTG7qvF/aOH4xrtCJSG0VObddcn
         Aue9TLly6ZsYOF0b7DeKHSyd7nCphz6X/QuReaGVui/x4yolfx2pbziXyPJAKVZChS4v
         d7CDh9r5/jKRZxjjoGWHb2f9h2JP1Xs+j8bm/7lWzV2MbIbGNP1pIWdQkoYeoQ7RA0P4
         ljdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B1e+m3MZixl0oCp8sU0iwCzGTDQQ+5RrheGCvqq1/GY=;
        b=ZH4ZMnEuSx2FWEB/wLLq6QjTGQAiSJDQLzadCWGdHcSpKHGJdZJDBHkdFErJyZd6j6
         kA4aZm97AtuzJ3sUeF46XTKUWPqZBm2sBA3uXAzNrOVFFZUT/IqeP/bOZHPCkQ0Q20uO
         w29byNb3Jg9cPUSTXENXn/y3kI6LJgxxy3rZUvC2OFDmVmkNTeGbKMXqU7rwg7x6aYh1
         utQrbUZVj9zgZTCX5bMyoiz/soyaZf5q8Hni/PUtp+EgMv0rM89FAvLdXsqqaYefhwxZ
         oITEy2luwnGqEws2+PKih739bOirgAMNQTd+z5FKo7G2/q2tvKBQNwZPadqXZMkaE28w
         Zb6g==
X-Gm-Message-State: AOAM5322LjfbmiMgv2zKbgn77IWXTpO3EMJFlHkwaEwiWD34Cd1NQ/kJ
        +QrU6rYBnd6pUpZYTqZXL6Ct4evW4+IpSw==
X-Google-Smtp-Source: ABdhPJxSbtzIz/Qe635l+6w389L6BtM79iK5VsV7ho2LlJeTJHql0fTZTihmk/dKQbrUb/iL4fPprWn9pkHhpA==
X-Received: by 2002:a25:25cd:: with SMTP id l196mr6530549ybl.356.1590547739192;
 Tue, 26 May 2020 19:48:59 -0700 (PDT)
Date:   Tue, 26 May 2020 19:48:49 -0700
In-Reply-To: <20200527024850.81404-1-edumazet@google.com>
Message-Id: <20200527024850.81404-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200527024850.81404-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH net-next 1/2] tcp: add tcp_ld_RTO_revert() helper
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

RFC 6069 logic has been implemented for IPv4 only so far,
right in the middle of tcp_v4_err() and was error prone.

Move this code to one helper, to make tcp_v4_err() more
readable and to eventually expand RFC 6069 to IPv6 in
the future.

Also perform sock_owned_by_user() check a bit sooner.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_ipv4.c | 85 ++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 40 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3ac0a7523923e0f1d959dfa65cf2b73bd6a4af15..8b257a92c98ffdb4618b8cde0937740ad5fe2e64 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -403,6 +403,45 @@ void tcp_req_err(struct sock *sk, u32 seq, bool abort)
 }
 EXPORT_SYMBOL(tcp_req_err);
 
+/* TCP-LD (RFC 6069) logic */
+static void tcp_ld_RTO_revert(struct sock *sk, u32 seq)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct sk_buff *skb;
+	s32 remaining;
+	u32 delta_us;
+
+	if (sock_owned_by_user(sk))
+		return;
+
+	if (seq != tp->snd_una  || !icsk->icsk_retransmits ||
+	    !icsk->icsk_backoff)
+		return;
+
+	skb = tcp_rtx_queue_head(sk);
+	if (WARN_ON_ONCE(!skb))
+		return;
+
+	icsk->icsk_backoff--;
+	icsk->icsk_rto = tp->srtt_us ? __tcp_set_rto(tp) : TCP_TIMEOUT_INIT;
+	icsk->icsk_rto = inet_csk_rto_backoff(icsk, TCP_RTO_MAX);
+
+	tcp_mstamp_refresh(tp);
+	delta_us = (u32)(tp->tcp_mstamp - tcp_skb_timestamp_us(skb));
+	remaining = icsk->icsk_rto - usecs_to_jiffies(delta_us);
+
+	if (remaining > 0) {
+		inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
+					  remaining, TCP_RTO_MAX);
+	} else {
+		/* RTO revert clocked out retransmission.
+		 * Will retransmit now.
+		 */
+		tcp_retransmit_timer(sk);
+	}
+}
+
 /*
  * This routine is called by the ICMP module when it gets some
  * sort of error condition.  If err < 0 then the socket should
@@ -423,17 +462,13 @@ int tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 {
 	const struct iphdr *iph = (const struct iphdr *)icmp_skb->data;
 	struct tcphdr *th = (struct tcphdr *)(icmp_skb->data + (iph->ihl << 2));
-	struct inet_connection_sock *icsk;
 	struct tcp_sock *tp;
 	struct inet_sock *inet;
 	const int type = icmp_hdr(icmp_skb)->type;
 	const int code = icmp_hdr(icmp_skb)->code;
 	struct sock *sk;
-	struct sk_buff *skb;
 	struct request_sock *fastopen;
 	u32 seq, snd_una;
-	s32 remaining;
-	u32 delta_us;
 	int err;
 	struct net *net = dev_net(icmp_skb->dev);
 
@@ -476,7 +511,6 @@ int tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 		goto out;
 	}
 
-	icsk = inet_csk(sk);
 	tp = tcp_sk(sk);
 	/* XXX (TFO) - tp->snd_una should be ISN (tcp_create_openreq_child() */
 	fastopen = rcu_dereference(tp->fastopen_rsk);
@@ -521,41 +555,12 @@ int tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 		}
 
 		err = icmp_err_convert[code].errno;
-		/* check if icmp_skb allows revert of backoff
-		 * (see draft-zimmermann-tcp-lcd) */
-		if (code != ICMP_NET_UNREACH && code != ICMP_HOST_UNREACH)
-			break;
-		if (seq != tp->snd_una  || !icsk->icsk_retransmits ||
-		    !icsk->icsk_backoff || fastopen)
-			break;
-
-		if (sock_owned_by_user(sk))
-			break;
-
-		skb = tcp_rtx_queue_head(sk);
-		if (WARN_ON_ONCE(!skb))
-			break;
-
-		icsk->icsk_backoff--;
-		icsk->icsk_rto = tp->srtt_us ? __tcp_set_rto(tp) :
-					       TCP_TIMEOUT_INIT;
-		icsk->icsk_rto = inet_csk_rto_backoff(icsk, TCP_RTO_MAX);
-
-
-		tcp_mstamp_refresh(tp);
-		delta_us = (u32)(tp->tcp_mstamp - tcp_skb_timestamp_us(skb));
-		remaining = icsk->icsk_rto -
-			    usecs_to_jiffies(delta_us);
-
-		if (remaining > 0) {
-			inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
-						  remaining, TCP_RTO_MAX);
-		} else {
-			/* RTO revert clocked out retransmission.
-			 * Will retransmit now */
-			tcp_retransmit_timer(sk);
-		}
-
+		/* check if this ICMP message allows revert of backoff.
+		 * (see RFC 6069)
+		 */
+		if (!fastopen &&
+		    (code == ICMP_NET_UNREACH || code == ICMP_HOST_UNREACH))
+			tcp_ld_RTO_revert(sk, seq);
 		break;
 	case ICMP_TIME_EXCEEDED:
 		err = EHOSTUNREACH;
-- 
2.27.0.rc0.183.gde8f92d652-goog

