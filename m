Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5EF2F53E9
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 21:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbhAMUMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 15:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbhAMUMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 15:12:50 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5006DC0617A3;
        Wed, 13 Jan 2021 12:12:04 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id w124so3487317oia.6;
        Wed, 13 Jan 2021 12:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ckYX1tzSzLLS+hQigphiHUuay4P54RFcikUN7TeKvic=;
        b=cZFt3IfRkwxYWs23QvzY2VVxvh6HeTfDMhDW+WrxBYi2sM9EyUH+CHrXibGrbjogu6
         aZC2EDCjuw9XO10ne0BNEzqxa3R5iRW+d+RswMmlDROQgCyiGFcXoIdNYH6AUXyeM1+M
         4NYRTko9LFLIMuGIPlTPcuGMC03AcwpHVnPHSdWG1IRsTVhJnOuCcvmdaI+kArXquq6N
         KmsXZ4Wg5GfZ/3jgFb3lkiGlx9P9XywKA4Fqte/BH0+iZuv5B/J2x0M+xx+2BjimFKkX
         UZkW0wPnFjIy1ZoDY7QIHwXqZCG0+Q2xpHNbWhStYtpRSrdHdua4DdjqMqK9zUSUXDcz
         24Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ckYX1tzSzLLS+hQigphiHUuay4P54RFcikUN7TeKvic=;
        b=P4oTnzr2HuoznRSgqUaodzCmA2LHz+x0Zw+pKwMnfI1nDqrNGmdg2i2VQX5tuTlF+J
         Lx+K80lIcVMlxvFvKZQAUhJcduADMrocSi5RveSbRoGORZNaKBvbPu53I44+WpAeWrlM
         iZ30bgJzAlupr+pc0pIqJ8/FiUv1x/xwcxpIERlH/RGDYvaelQWQ90NozTpYgonVbqkG
         xvbyO3D7Td+DnAHc7L0QvRO68cd43n6HU2xkB3s+btmdl0wbd/UDBxxI5LPZuvHGo1xl
         EvIKnpWckXWCBARejjfzLNk8zs3ubqMRBRxA4KsORqm31+q/cw2ZWr8jnUoD3+ejBq/S
         5j3w==
X-Gm-Message-State: AOAM533wgFpTsOuinmtnEqd9upfmFhAD5TXYm9AgKYYIqORcJ8kCtVno
        0Uko/6Wk7iYGhHSGqHXJjfg=
X-Google-Smtp-Source: ABdhPJyrnBkuNZAhJzcpKtl28uXoJKTP6CCUo9YzV7bhqKWCxzUL+bYJBVKOqbknfbomGfGeShZwFg==
X-Received: by 2002:aca:bac3:: with SMTP id k186mr576108oif.93.1610568723788;
        Wed, 13 Jan 2021 12:12:03 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id l73sm616014ooc.43.2021.01.13.12.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 12:12:03 -0800 (PST)
Date:   Wed, 13 Jan 2021 12:12:01 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        William McCall <william.mccall@gmail.com>,
        enkechen2020@gmail.com
Subject: [PATCH] tcp: fix TCP_USER_TIMEOUT with zero window
Message-ID: <20210113201201.GC2274@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enke Chen <enchen@paloaltonetworks.com>

The TCP session does not terminate with TCP_USER_TIMEOUT when data
remain untransmitted due to zero window.

The number of unanswered zero-window probes (tcp_probes_out) is
reset to zero with incoming acks irrespective of the window size,
as described in tcp_probe_timer():

    RFC 1122 4.2.2.17 requires the sender to stay open indefinitely
    as long as the receiver continues to respond probes. We support
    this by default and reset icsk_probes_out with incoming ACKs.

This counter, however, is the wrong one to be used in calculating the
duration that the window remains closed and data remain untransmitted.
Thanks to Jonathan Maxwell <jmaxwell37@gmail.com> for diagnosing the
actual issue.

In this patch a separate counter is introduced to track the number of
zero-window probes that are not answered with any non-zero window ack.
This new counter is used in determining when to abort the session with
TCP_USER_TIMEOUT.

Cc: stable@vger.kernel.org
Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
Reported-by: William McCall <william.mccall@gmail.com>
Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
---
 include/linux/tcp.h   | 5 +++++
 net/ipv4/tcp.c        | 1 +
 net/ipv4/tcp_input.c  | 3 ++-
 net/ipv4/tcp_output.c | 2 ++
 net/ipv4/tcp_timer.c  | 5 +++--
 5 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 2f87377e9af7..c9415b30fa67 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -352,6 +352,11 @@ struct tcp_sock {
 
 	int			linger2;
 
+	/* While icsk_probes_out is for unanswered 0 window probes, this
+	 * counter is for 0-window probes that are not answered with any
+	 * non-zero window (nzw) acks.
+	 */
+	u8	probes_nzw;
 
 /* Sock_ops bpf program related variables */
 #ifdef CONFIG_BPF
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ed42d2193c5c..af6a41a5a5ac 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2940,6 +2940,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_rto = TCP_TIMEOUT_INIT;
 	icsk->icsk_rto_min = TCP_RTO_MIN;
 	icsk->icsk_delack_max = TCP_DELACK_MAX;
+	tp->probes_nzw = 0;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd = TCP_INIT_CWND;
 	tp->snd_cwnd_cnt = 0;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c7e16b0ed791..4812a969c18a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3377,13 +3377,14 @@ static void tcp_ack_probe(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct sk_buff *head = tcp_send_head(sk);
-	const struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
 
 	/* Was it a usable window open? */
 	if (!head)
 		return;
 	if (!after(TCP_SKB_CB(head)->end_seq, tcp_wnd_end(tp))) {
 		icsk->icsk_backoff = 0;
+		tp->probes_nzw = 0;
 		inet_csk_clear_xmit_timer(sk, ICSK_TIME_PROBE0);
 		/* Socket must be waked up by subsequent tcp_data_snd_check().
 		 * This function is not for random using!
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f322e798a351..1b64cdabc299 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4084,10 +4084,12 @@ void tcp_send_probe0(struct sock *sk)
 		/* Cancel probe timer, if it is not required. */
 		icsk->icsk_probes_out = 0;
 		icsk->icsk_backoff = 0;
+		tp->probes_nzw = 0;
 		return;
 	}
 
 	icsk->icsk_probes_out++;
+	tp->probes_nzw++;
 	if (err <= 0) {
 		if (icsk->icsk_backoff < net->ipv4.sysctl_tcp_retries2)
 			icsk->icsk_backoff++;
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 6c62b9ea1320..87e9f5998b8e 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -349,6 +349,7 @@ static void tcp_probe_timer(struct sock *sk)
 
 	if (tp->packets_out || !skb) {
 		icsk->icsk_probes_out = 0;
+		tp->probes_nzw = 0;
 		return;
 	}
 
@@ -360,8 +361,8 @@ static void tcp_probe_timer(struct sock *sk)
 	 * corresponding system limit. We also implement similar policy when
 	 * we use RTO to probe window in tcp_retransmit_timer().
 	 */
-	if (icsk->icsk_user_timeout) {
-		u32 elapsed = tcp_model_timeout(sk, icsk->icsk_probes_out,
+	if (icsk->icsk_user_timeout && tp->probes_nzw) {
+		u32 elapsed = tcp_model_timeout(sk, tp->probes_nzw,
 						tcp_probe0_base(sk));
 
 		if (elapsed >= icsk->icsk_user_timeout)
-- 
2.29.2

