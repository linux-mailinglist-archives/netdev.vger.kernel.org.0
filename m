Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F2428D305
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 19:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388292AbgJMRTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 13:19:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60012 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbgJMRS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 13:18:58 -0400
Received: from mail-ej1-f72.google.com ([209.85.218.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kleber.souza@canonical.com>)
        id 1kSNwu-0004BK-A7
        for netdev@vger.kernel.org; Tue, 13 Oct 2020 17:18:56 +0000
Received: by mail-ej1-f72.google.com with SMTP id b17so30528ejb.20
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 10:18:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y+5mpacNCVWBFfZBMH1bwrB+12TEvwJ4sAVV+tnbUb4=;
        b=cXJeCH/O7VkOCL+gEYkowZ01NO8dl9LpmRxZXgyvBwzNTKZb0It+rwLsLMY2LBk06S
         NgL0Ya2qCJ30u5O9clQrqyghhdjFR2o7J/ZWR264M3eJgsT0OCNvtmgfXXfWBtVtal4F
         r5NLnCCR57zu4kPOqNP6CJVT7XvSab68is3mkq9qgVTChe6YPk9nPYRZgnA/mRPKISZW
         zFI8oYwogHeRjme+G6m7Wc8P/uOyGVfHcqVTmrI//TPb99LKup025dW9KbomArWBFgkQ
         6nUoGOJRbiMFbtgSX1+gSdhDV41M4Y4v0LGGcqSS+E/1vUrghinYlQtRJ35Gf6WTjjB1
         QDrQ==
X-Gm-Message-State: AOAM530uF/ZeEGnwLEyKtTWewDdTRfv1bT852DjpAb7nYhckGgQ7IBrm
        suqfGWmqDFWxLENCJ3Fxw8rgp7Fv/uwJcckgrBdpTdJwc6KgpVDeAHYiQSxV7Z9C4amxz/ehJlR
        xGZ5kRdOLvVhY/jcPz3fbRQ0yu6Hnx2pfJg==
X-Received: by 2002:aa7:d143:: with SMTP id r3mr599106edo.103.1602609535672;
        Tue, 13 Oct 2020 10:18:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvS/uWFzyWvd6pBedmj5spzM1Fn3oGhFtoutMKdCDP6gx9C1zlx7DzzR0gk+YoFEhtAUeRmQ==
X-Received: by 2002:aa7:d143:: with SMTP id r3mr599070edo.103.1602609535334;
        Tue, 13 Oct 2020 10:18:55 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8108:4640:10c0:6cbe:6d37:31ed:e54b])
        by smtp.gmail.com with ESMTPSA id g9sm192776edv.81.2020.10.13.10.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 10:18:54 -0700 (PDT)
From:   Kleber Sacilotto de Souza <kleber.souza@canonical.com>
To:     netdev@vger.kernel.org
Cc:     Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        dccp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dccp: ccid: move timers to struct dccp_sock
Date:   Tue, 13 Oct 2020 19:18:48 +0200
Message-Id: <20201013171849.236025-2-kleber.souza@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013171849.236025-1-kleber.souza@canonical.com>
References: <20201013171849.236025-1-kleber.souza@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

When dccps_hc_tx_ccid is freed, ccid timers may still trigger. The reason
del_timer_sync can't be used is because this relies on keeping a reference
to struct sock. But as we keep a pointer to dccps_hc_tx_ccid and free that
during disconnect, the timer should really belong to struct dccp_sock.

This addresses CVE-2020-16119.

Fixes: 839a6094140a (net: dccp: Convert timers to use timer_setup())
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>
---
 include/linux/dccp.h   |  2 ++
 net/dccp/ccids/ccid2.c | 32 +++++++++++++++++++-------------
 net/dccp/ccids/ccid3.c | 30 ++++++++++++++++++++----------
 3 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/include/linux/dccp.h b/include/linux/dccp.h
index 07e547c02fd8..504afa1a4be6 100644
--- a/include/linux/dccp.h
+++ b/include/linux/dccp.h
@@ -259,6 +259,7 @@ struct dccp_ackvec;
  * @dccps_sync_scheduled - flag which signals "send out-of-band message soon"
  * @dccps_xmitlet - tasklet scheduled by the TX CCID to dequeue data packets
  * @dccps_xmit_timer - used by the TX CCID to delay sending (rate-based pacing)
+ * @dccps_ccid_timer - used by the CCIDs
  * @dccps_syn_rtt - RTT sample from Request/Response exchange (in usecs)
  */
 struct dccp_sock {
@@ -303,6 +304,7 @@ struct dccp_sock {
 	__u8				dccps_sync_scheduled:1;
 	struct tasklet_struct		dccps_xmitlet;
 	struct timer_list		dccps_xmit_timer;
+	struct timer_list		dccps_ccid_timer;
 };
 
 static inline struct dccp_sock *dccp_sk(const struct sock *sk)
diff --git a/net/dccp/ccids/ccid2.c b/net/dccp/ccids/ccid2.c
index 3da1f77bd039..dbca1f1e2449 100644
--- a/net/dccp/ccids/ccid2.c
+++ b/net/dccp/ccids/ccid2.c
@@ -126,21 +126,26 @@ static void dccp_tasklet_schedule(struct sock *sk)
 
 static void ccid2_hc_tx_rto_expire(struct timer_list *t)
 {
-	struct ccid2_hc_tx_sock *hc = from_timer(hc, t, tx_rtotimer);
-	struct sock *sk = hc->sk;
-	const bool sender_was_blocked = ccid2_cwnd_network_limited(hc);
+	struct dccp_sock *dp = from_timer(dp, t, dccps_ccid_timer);
+	struct sock *sk = (struct sock *)dp;
+	struct ccid2_hc_tx_sock *hc;
+	bool sender_was_blocked;
 
 	bh_lock_sock(sk);
+
+	if (inet_sk_state_load(sk) == DCCP_CLOSED)
+		goto out;
+
+	hc = ccid_priv(dp->dccps_hc_tx_ccid);
+	sender_was_blocked = ccid2_cwnd_network_limited(hc);
+
 	if (sock_owned_by_user(sk)) {
-		sk_reset_timer(sk, &hc->tx_rtotimer, jiffies + HZ / 5);
+		sk_reset_timer(sk, &dp->dccps_ccid_timer, jiffies + HZ / 5);
 		goto out;
 	}
 
 	ccid2_pr_debug("RTO_EXPIRE\n");
 
-	if (sk->sk_state == DCCP_CLOSED)
-		goto out;
-
 	/* back-off timer */
 	hc->tx_rto <<= 1;
 	if (hc->tx_rto > DCCP_RTO_MAX)
@@ -166,7 +171,7 @@ static void ccid2_hc_tx_rto_expire(struct timer_list *t)
 	if (sender_was_blocked)
 		dccp_tasklet_schedule(sk);
 	/* restart backed-off timer */
-	sk_reset_timer(sk, &hc->tx_rtotimer, jiffies + hc->tx_rto);
+	sk_reset_timer(sk, &dp->dccps_ccid_timer, jiffies + hc->tx_rto);
 out:
 	bh_unlock_sock(sk);
 	sock_put(sk);
@@ -330,7 +335,7 @@ static void ccid2_hc_tx_packet_sent(struct sock *sk, unsigned int len)
 	}
 #endif
 
-	sk_reset_timer(sk, &hc->tx_rtotimer, jiffies + hc->tx_rto);
+	sk_reset_timer(sk, &dp->dccps_ccid_timer, jiffies + hc->tx_rto);
 
 #ifdef CONFIG_IP_DCCP_CCID2_DEBUG
 	do {
@@ -700,9 +705,9 @@ static void ccid2_hc_tx_packet_recv(struct sock *sk, struct sk_buff *skb)
 
 	/* restart RTO timer if not all outstanding data has been acked */
 	if (hc->tx_pipe == 0)
-		sk_stop_timer(sk, &hc->tx_rtotimer);
+		sk_stop_timer(sk, &dp->dccps_ccid_timer);
 	else
-		sk_reset_timer(sk, &hc->tx_rtotimer, jiffies + hc->tx_rto);
+		sk_reset_timer(sk, &dp->dccps_ccid_timer, jiffies + hc->tx_rto);
 done:
 	/* check if incoming Acks allow pending packets to be sent */
 	if (sender_was_blocked && !ccid2_cwnd_network_limited(hc))
@@ -737,17 +742,18 @@ static int ccid2_hc_tx_init(struct ccid *ccid, struct sock *sk)
 	hc->tx_last_cong = hc->tx_lsndtime = hc->tx_cwnd_stamp = ccid2_jiffies32;
 	hc->tx_cwnd_used = 0;
 	hc->sk		 = sk;
-	timer_setup(&hc->tx_rtotimer, ccid2_hc_tx_rto_expire, 0);
+	timer_setup(&dp->dccps_ccid_timer, ccid2_hc_tx_rto_expire, 0);
 	INIT_LIST_HEAD(&hc->tx_av_chunks);
 	return 0;
 }
 
 static void ccid2_hc_tx_exit(struct sock *sk)
 {
+	struct dccp_sock *dp = dccp_sk(sk);
 	struct ccid2_hc_tx_sock *hc = ccid2_hc_tx_sk(sk);
 	int i;
 
-	sk_stop_timer(sk, &hc->tx_rtotimer);
+	sk_stop_timer(sk, &dp->dccps_ccid_timer);
 
 	for (i = 0; i < hc->tx_seqbufc; i++)
 		kfree(hc->tx_seqbuf[i]);
diff --git a/net/dccp/ccids/ccid3.c b/net/dccp/ccids/ccid3.c
index b9ee1a4a8955..685f4d046c0d 100644
--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -184,17 +184,24 @@ static inline void ccid3_hc_tx_update_win_count(struct ccid3_hc_tx_sock *hc,
 
 static void ccid3_hc_tx_no_feedback_timer(struct timer_list *t)
 {
-	struct ccid3_hc_tx_sock *hc = from_timer(hc, t, tx_no_feedback_timer);
-	struct sock *sk = hc->sk;
+	struct dccp_sock *dp = from_timer(dp, t, dccps_ccid_timer);
+	struct ccid3_hc_tx_sock *hc;
+	struct sock *sk = (struct sock *)dp;
 	unsigned long t_nfb = USEC_PER_SEC / 5;
 
 	bh_lock_sock(sk);
+
+	if (inet_sk_state_load(sk) == DCCP_CLOSED)
+		goto out;
+
 	if (sock_owned_by_user(sk)) {
 		/* Try again later. */
 		/* XXX: set some sensible MIB */
 		goto restart_timer;
 	}
 
+	hc = ccid_priv(dp->dccps_hc_tx_ccid);
+
 	ccid3_pr_debug("%s(%p, state=%s) - entry\n", dccp_role(sk), sk,
 		       ccid3_tx_state_name(hc->tx_state));
 
@@ -250,8 +257,8 @@ static void ccid3_hc_tx_no_feedback_timer(struct timer_list *t)
 		t_nfb = max(hc->tx_t_rto, 2 * hc->tx_t_ipi);
 
 restart_timer:
-	sk_reset_timer(sk, &hc->tx_no_feedback_timer,
-			   jiffies + usecs_to_jiffies(t_nfb));
+	sk_reset_timer(sk, &dp->dccps_ccid_timer,
+		       jiffies + usecs_to_jiffies(t_nfb));
 out:
 	bh_unlock_sock(sk);
 	sock_put(sk);
@@ -280,7 +287,7 @@ static int ccid3_hc_tx_send_packet(struct sock *sk, struct sk_buff *skb)
 		return -EBADMSG;
 
 	if (hc->tx_state == TFRC_SSTATE_NO_SENT) {
-		sk_reset_timer(sk, &hc->tx_no_feedback_timer, (jiffies +
+		sk_reset_timer(sk, &dp->dccps_ccid_timer, (jiffies +
 			       usecs_to_jiffies(TFRC_INITIAL_TIMEOUT)));
 		hc->tx_last_win_count	= 0;
 		hc->tx_t_last_win_count = now;
@@ -354,6 +361,7 @@ static void ccid3_hc_tx_packet_sent(struct sock *sk, unsigned int len)
 static void ccid3_hc_tx_packet_recv(struct sock *sk, struct sk_buff *skb)
 {
 	struct ccid3_hc_tx_sock *hc = ccid3_hc_tx_sk(sk);
+	struct dccp_sock *dp = dccp_sk(sk);
 	struct tfrc_tx_hist_entry *acked;
 	ktime_t now;
 	unsigned long t_nfb;
@@ -420,7 +428,7 @@ static void ccid3_hc_tx_packet_recv(struct sock *sk, struct sk_buff *skb)
 			       (unsigned int)(hc->tx_x >> 6));
 
 	/* unschedule no feedback timer */
-	sk_stop_timer(sk, &hc->tx_no_feedback_timer);
+	sk_stop_timer(sk, &dp->dccps_ccid_timer);
 
 	/*
 	 * As we have calculated new ipi, delta, t_nom it is possible
@@ -445,8 +453,8 @@ static void ccid3_hc_tx_packet_recv(struct sock *sk, struct sk_buff *skb)
 		       "expire in %lu jiffies (%luus)\n",
 		       dccp_role(sk), sk, usecs_to_jiffies(t_nfb), t_nfb);
 
-	sk_reset_timer(sk, &hc->tx_no_feedback_timer,
-			   jiffies + usecs_to_jiffies(t_nfb));
+	sk_reset_timer(sk, &dp->dccps_ccid_timer,
+		       jiffies + usecs_to_jiffies(t_nfb));
 }
 
 static int ccid3_hc_tx_parse_options(struct sock *sk, u8 packet_type,
@@ -488,21 +496,23 @@ static int ccid3_hc_tx_parse_options(struct sock *sk, u8 packet_type,
 
 static int ccid3_hc_tx_init(struct ccid *ccid, struct sock *sk)
 {
+	struct dccp_sock *dp = dccp_sk(sk);
 	struct ccid3_hc_tx_sock *hc = ccid_priv(ccid);
 
 	hc->tx_state = TFRC_SSTATE_NO_SENT;
 	hc->tx_hist  = NULL;
 	hc->sk	     = sk;
-	timer_setup(&hc->tx_no_feedback_timer,
+	timer_setup(&dp->dccps_ccid_timer,
 		    ccid3_hc_tx_no_feedback_timer, 0);
 	return 0;
 }
 
 static void ccid3_hc_tx_exit(struct sock *sk)
 {
+	struct dccp_sock *dp = dccp_sk(sk);
 	struct ccid3_hc_tx_sock *hc = ccid3_hc_tx_sk(sk);
 
-	sk_stop_timer(sk, &hc->tx_no_feedback_timer);
+	sk_stop_timer(sk, &dp->dccps_ccid_timer);
 	tfrc_tx_hist_purge(&hc->tx_hist);
 }
 
-- 
2.25.1

