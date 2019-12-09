Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF310117581
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfLITUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:20:23 -0500
Received: from mail-qt1-f202.google.com ([209.85.160.202]:33675 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfLITUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 14:20:23 -0500
Received: by mail-qt1-f202.google.com with SMTP id l25so182575qtu.0
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 11:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=I3KybXhgQuNDISrawqDH7k3yYYMVZaoMAPC2ii/oT+8=;
        b=TEhjCHmqR4bpLdcoTf1Ds9p+Vd7AYrzWNCuRjjSlStK/yM0GC6s/u4yd+I8XA4Womk
         zmd5eKwnmkkIvU9oYWVj5XQ7LTd1U/F/g8tertCu76XbBz8/LTD7gZNh7wILSc2shiqA
         gudYbPgtPyuBpdIBWHUv3GayP7OvKrC4fJ/iEzEBxyEucMgJwBHKIJgnHsq0fDEydWpY
         548d3sxr5tn7pkQD3OMFdr0z4nHQL+3nociRqNVbYKCZuO9Ne5vI0o+hjBYpelv/ZWV6
         wOrwxV+GhVfbU+6NoakZ0FXUpPv/WvtO6L2eBQhm4JN0Lc8WhusQghjJIKQy53socBn/
         JN2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=I3KybXhgQuNDISrawqDH7k3yYYMVZaoMAPC2ii/oT+8=;
        b=WAfxYusLuhPlrws74k2Mu1bDhEEWYAr84LcFn9raDXJBcbEc1NfLaaYwhn/eRx4zUZ
         Z7jwopIaxOntqaH9qU2H5c3RYi3f3Y3y6XwcVrBUFtto9GpH6SHJAhM9my6CaH4GW7sm
         fmUVhyrHRDlEG/2/RlZ3yZCSWwDhUErrStwOaF9mWJEl3ykoJTLCK5JFoFY9CHKNwewy
         8VlmSKzBk2NMWZSufMhKsLOSaYYFBCGq0o+D8gHZFNezYsAf6Y7FBzNFm8sTvRC5IZWj
         AJYEQQsYoRwIlBHLcP/A+3TQgvsGH7yD+d87PQZcDD6nvzWLEZPkvmItIVST8Lq00++B
         A23g==
X-Gm-Message-State: APjAAAXcwz5qRnSTCWXElM8q+/lTCrT85YeMkvJsCIhYe71vaUuQ/J0W
        seqsD9D5c5K9pqfHusNd3RuxQoA=
X-Google-Smtp-Source: APXvYqyQ3XdhPaTdpeFmkAOS365Dr7WMmmaCZ4kDWrpbtFW6QAHCfxg/aya3R5tHqgySf4OMrMWJecc=
X-Received: by 2002:a37:a18b:: with SMTP id k133mr11455137qke.83.1575919222230;
 Mon, 09 Dec 2019 11:20:22 -0800 (PST)
Date:   Mon,  9 Dec 2019 14:19:59 -0500
Message-Id: <20191209191959.100759-1-yyd@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH net-next] net-tcp: Disable TCP ssthresh metrics cache by default
From:   "Kevin(Yudong) Yang" <yyd@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, "Kevin(Yudong) Yang" <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a sysctl knob "net.ipv4.tcp_no_ssthresh_metrics_save"
that disables TCP ssthresh metrics cache by default. Other parts of TCP
metrics cache, e.g. rtt, cwnd, remain unchanged.

As modern networks becoming more and more dynamic, TCP metrics cache
today often causes more harm than benefits. For example, the same IP
address is often shared by different subscribers behind NAT in residential
networks. Even if the IP address is not shared by different users,
caching the slow-start threshold of a previous short flow using loss-based
congestion control (e.g. cubic) often causes the future longer flows of
the same network path to exit slow-start prematurely with abysmal
throughput.

Caching ssthresh is very risky and can lead to terrible performance.
Therefore it makes sense to make disabling ssthresh caching by
default and opt-in for specific networks by the administrators.
This practice also has worked well for several years of deployment with
CUBIC congestion control at Google.

Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>
---
 Documentation/networking/ip-sysctl.txt |  4 ++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 net/ipv4/tcp_ipv4.c                    |  1 +
 net/ipv4/tcp_metrics.c                 | 13 +++++++++----
 5 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 099a55bd1432d..b865b3b2f81ae 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -479,6 +479,10 @@ tcp_no_metrics_save - BOOLEAN
 	degradation.  If set, TCP will not cache metrics on closing
 	connections.
 
+tcp_no_ssthresh_metrics_save - BOOLEAN
+	Controls whether TCP saves ssthresh metrics in the route cache.
+	Default is 1, which disables ssthresh metrics.
+
 tcp_orphan_retries - INTEGER
 	This value influences the timeout of a locally closed TCP connection,
 	when RTO retransmissions remain unacknowledged.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index c0c0791b19123..08b98414d94e5 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -154,6 +154,7 @@ struct netns_ipv4 {
 	int sysctl_tcp_adv_win_scale;
 	int sysctl_tcp_frto;
 	int sysctl_tcp_nometrics_save;
+	int sysctl_tcp_no_ssthresh_metrics_save;
 	int sysctl_tcp_moderate_rcvbuf;
 	int sysctl_tcp_tso_win_divisor;
 	int sysctl_tcp_workaround_signed_windows;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index fcb2cd167f64a..9684af02e0a59 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1192,6 +1192,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "tcp_no_ssthresh_metrics_save",
+		.data		= &init_net.ipv4.sysctl_tcp_no_ssthresh_metrics_save,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{
 		.procname	= "tcp_moderate_rcvbuf",
 		.data		= &init_net.ipv4.sysctl_tcp_moderate_rcvbuf,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 92282f98dc822..26637fce324d8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2674,6 +2674,7 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_fin_timeout = TCP_FIN_TIMEOUT;
 	net->ipv4.sysctl_tcp_notsent_lowat = UINT_MAX;
 	net->ipv4.sysctl_tcp_tw_reuse = 2;
+	net->ipv4.sysctl_tcp_no_ssthresh_metrics_save = 1;
 
 	cnt = tcp_hashinfo.ehash_mask + 1;
 	net->ipv4.tcp_death_row.sysctl_max_tw_buckets = cnt / 2;
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index c4848e7a0aad1..279db8822439d 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -385,7 +385,8 @@ void tcp_update_metrics(struct sock *sk)
 
 	if (tcp_in_initial_slowstart(tp)) {
 		/* Slow start still did not finish. */
-		if (!tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
+		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 			if (val && (tp->snd_cwnd >> 1) > val)
 				tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
@@ -400,7 +401,8 @@ void tcp_update_metrics(struct sock *sk)
 	} else if (!tcp_in_slow_start(tp) &&
 		   icsk->icsk_ca_state == TCP_CA_Open) {
 		/* Cong. avoidance phase, cwnd is reliable. */
-		if (!tcp_metric_locked(tm, TCP_METRIC_SSTHRESH))
+		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH))
 			tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
 				       max(tp->snd_cwnd >> 1, tp->snd_ssthresh));
 		if (!tcp_metric_locked(tm, TCP_METRIC_CWND)) {
@@ -416,7 +418,8 @@ void tcp_update_metrics(struct sock *sk)
 			tcp_metric_set(tm, TCP_METRIC_CWND,
 				       (val + tp->snd_ssthresh) >> 1);
 		}
-		if (!tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
+		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 			if (val && tp->snd_ssthresh > val)
 				tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
@@ -441,6 +444,7 @@ void tcp_init_metrics(struct sock *sk)
 {
 	struct dst_entry *dst = __sk_dst_get(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
+	struct net *net = sock_net(sk);
 	struct tcp_metrics_block *tm;
 	u32 val, crtt = 0; /* cached RTT scaled by 8 */
 
@@ -458,7 +462,8 @@ void tcp_init_metrics(struct sock *sk)
 	if (tcp_metric_locked(tm, TCP_METRIC_CWND))
 		tp->snd_cwnd_clamp = tcp_metric_get(tm, TCP_METRIC_CWND);
 
-	val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
+	val = net->ipv4.sysctl_tcp_no_ssthresh_metrics_save ?
+	      0 : tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 	if (val) {
 		tp->snd_ssthresh = val;
 		if (tp->snd_ssthresh > tp->snd_cwnd_clamp)
-- 
2.24.0.432.g9d3f5f5b63-goog

