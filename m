Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2589E366919
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 12:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbhDUKV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 06:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238390AbhDUKV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 06:21:56 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B927EC06174A;
        Wed, 21 Apr 2021 03:21:23 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z5so12205861edr.11;
        Wed, 21 Apr 2021 03:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g8LULkbDRZ8eVfXCHGC767kB3FBP1zfeEdAZN5jFV9c=;
        b=tevUl7sxPd6UdAoVqq8vzKQLBkAHjFHSy03QAxJJbnNhGjv/nyn/WtbkRcnhrClYVK
         0ZfSjTHAjTTk7VN+KYDySPw1ydes6msX0ACP53L4ER5mPjwcZkt2xPbUCzdMtvOiEa8O
         xZ+ajNNndiqZaOHUics3D/1kVWu3fYBqU7K6h8IxyI79aRtOdD3n+OoOtGUBtatUKNoM
         5hucAEtkhWmWEp0XfxQfrke9/HkE2J41O1OM7NPZLFQJYc2yw+8D4YHWDNJt8jE+HK0p
         gFjYcXuDOikrX6+P7gQgaVKRYjxYS3gGrY8Rld8v2Gto55TebKDo1XBEN5vmyWiv6Ksc
         JEVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g8LULkbDRZ8eVfXCHGC767kB3FBP1zfeEdAZN5jFV9c=;
        b=bCPyGsJE7Xna54rVJWYJdDXdOW/GWkOw0It4O7kmKph5HKlO2XPh6FTxKUuh4+3/mw
         87Oh6qOsbvPVtgofMIYJMMQRZQoIVv1DbE4uqO9J8ULEAB2vTErvjBFvQEIb2Rlwzuo4
         blgErXsruknZxHbn+NnicAHRdw4IBIUC3AlTLDy7dAMAh9DqLU+sDBzKbQj+BQNHxd87
         Z86qI2UTs96071jrXWXkUYWvbGJuAl1Wan6jyrLSDnj9HzcB1QoETPiC2ANskFffjvtb
         goiaRhuPOVh3BlquKs1nssOhG0OF1nOaiVod/eZIgeNO1W9TFjJVrT742dimfsMKOIRS
         haXw==
X-Gm-Message-State: AOAM5338WxRcM62I5kscRxylczzw6LLOWdwM5LLE0O6zUn4pOcxaUMuB
        eeL46siBty+oK9v5zagEmHs=
X-Google-Smtp-Source: ABdhPJzzIsH1DrQHKrRxRUYhls4ojSiQ/r+11NGATWyliEdg4oW+w+51aTfSUVBJ/24WKkLmBx4wlQ==
X-Received: by 2002:a05:6402:31ac:: with SMTP id dj12mr19503851edb.267.1619000482455;
        Wed, 21 Apr 2021 03:21:22 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:445:7a19:e51f:9a1e])
        by smtp.gmail.com with ESMTPSA id ke14sm1975113ejc.1.2021.04.21.03.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 03:21:21 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Willem de Bruijn <willemb@google.com>,
        Ilya Lesokhin <ilyal@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] tcp: Delay sending non-probes for RFC4821 mtu probing
Date:   Wed, 21 Apr 2021 13:21:11 +0300
Message-Id: <d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
in order to accumulate enough data" but linux almost never does that.

Linux waits for probe_size + (1 + retries) * mss_cache to be available
in the send buffer and if that condition is not met it will send anyway
using the current MSS. The feature can be made to work by sending very
large chunks of data from userspace (for example 128k) but for small writes
on fast links probes almost never happen.

This patch tries to implement the "MAY" by adding an extra flag
"wait_data" to icsk_mtup which is set to 1 if a probe is possible but
insufficient data is available. Then data is held back in
tcp_write_xmit until a probe is sent, probing conditions are no longer
met, or 500ms pass.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>

---
 Documentation/networking/ip-sysctl.rst |  4 ++
 include/net/inet_connection_sock.h     |  7 +++-
 include/net/netns/ipv4.h               |  1 +
 include/net/tcp.h                      |  2 +
 net/ipv4/sysctl_net_ipv4.c             |  7 ++++
 net/ipv4/tcp_ipv4.c                    |  1 +
 net/ipv4/tcp_output.c                  | 54 ++++++++++++++++++++++++--
 7 files changed, 71 insertions(+), 5 deletions(-)

My tests are here: https://github.com/cdleonard/test-tcp-mtu-probing

This patch makes the test pass quite reliably with
ICMP_BLACKHOLE=1 TCP_MTU_PROBING=1 IPERF_WINDOW=256k IPERF_LEN=8k while
before it only worked with much higher IPERF_LEN=256k

In my loopback tests I also observed another issue when tcp_retries
increases because of SACKReorder. This makes the original problem worse
(since the retries amount factors in buffer requirement) and seems to be
unrelated issue. Maybe when loss happens due to MTU shrinkage the sender
sack logic is confused somehow?

I know it's towards the end of the cycle but this is mostly just intended for
discussion.

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c2ecc9894fd0..47945a6b435d 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -550,10 +550,14 @@ tcp_probe_interval - UNSIGNED INTEGER
 tcp_probe_threshold - INTEGER
 	Controls when TCP Packetization-Layer Path MTU Discovery probing
 	will stop in respect to the width of search range in bytes. Default
 	is 8 bytes.
 
+tcp_probe_wait - INTEGER
+	How long to wait for data for a tcp mtu probe. The default is 500
+	milliseconds, zero can be used to disable this feature.
+
 tcp_no_metrics_save - BOOLEAN
 	By default, TCP saves various connection metrics in the route cache
 	when the connection closes, so that connections established in the
 	near future can use these to set initial conditions.  Usually, this
 	increases overall performance, but may sometimes cause performance
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 3c8c59471bc1..19afcc7a4f4a 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -123,15 +123,20 @@ struct inet_connection_sock {
 		/* Range of MTUs to search */
 		int		  search_high;
 		int		  search_low;
 
 		/* Information on the current probe. */
-		u32		  probe_size:31,
+		u32		  probe_size:30,
+		/* Are we actively accumulating data for an mtu probe? */
+				  wait_data:1,
 		/* Is the MTUP feature enabled for this connection? */
 				  enabled:1;
 
 		u32		  probe_timestamp;
+
+		/* Timer for wait_data */
+		struct	  timer_list	wait_data_timer;
 	} icsk_mtup;
 	u32			  icsk_probes_tstamp;
 	u32			  icsk_user_timeout;
 
 	u64			  icsk_ca_priv[104 / sizeof(u64)];
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 87e1612497ea..5af1e8a31a02 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -126,10 +126,11 @@ struct netns_ipv4 {
 	int sysctl_tcp_mtu_probe_floor;
 	int sysctl_tcp_base_mss;
 	int sysctl_tcp_min_snd_mss;
 	int sysctl_tcp_probe_threshold;
 	u32 sysctl_tcp_probe_interval;
+	int sysctl_tcp_probe_wait;
 
 	int sysctl_tcp_keepalive_time;
 	int sysctl_tcp_keepalive_intvl;
 	u8 sysctl_tcp_keepalive_probes;
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index eaea43afcc97..9060cc855363 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1375,10 +1375,12 @@ static inline void tcp_slow_start_after_idle_check(struct sock *sk)
 	s32 delta;
 
 	if (!sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle || tp->packets_out ||
 	    ca_ops->cong_control)
 		return;
+	if (inet_csk(sk)->icsk_mtup.wait_data)
+		return;
 	delta = tcp_jiffies32 - tp->lsndtime;
 	if (delta > inet_csk(sk)->icsk_rto)
 		tcp_cwnd_restart(sk, delta);
 }
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a62934b9f15a..1b6bbb24138a 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -842,10 +842,17 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u32),
 		.mode		= 0644,
 		.proc_handler	= proc_douintvec_minmax,
 		.extra2		= &u32_max_div_HZ,
 	},
+	{
+		.procname	= "tcp_probe_wait",
+		.data		= &init_net.ipv4.sysctl_tcp_probe_wait,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_ms_jiffies,
+	},
 	{
 		.procname	= "igmp_link_local_mcast_reports",
 		.data		= &init_net.ipv4.sysctl_igmp_llm_reports,
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 312184cead57..39f74f04e8b5 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2889,10 +2889,11 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_base_mss = TCP_BASE_MSS;
 	net->ipv4.sysctl_tcp_min_snd_mss = TCP_MIN_SND_MSS;
 	net->ipv4.sysctl_tcp_probe_threshold = TCP_PROBE_THRESHOLD;
 	net->ipv4.sysctl_tcp_probe_interval = TCP_PROBE_INTERVAL;
 	net->ipv4.sysctl_tcp_mtu_probe_floor = TCP_MIN_SND_MSS;
+	net->ipv4.sysctl_tcp_probe_wait = HZ / 2;
 
 	net->ipv4.sysctl_tcp_keepalive_time = TCP_KEEPALIVE_TIME;
 	net->ipv4.sysctl_tcp_keepalive_probes = TCP_KEEPALIVE_PROBES;
 	net->ipv4.sysctl_tcp_keepalive_intvl = TCP_KEEPALIVE_INTVL;
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bde781f46b41..15bbf0c97959 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1754,10 +1754,39 @@ int tcp_mss_to_mtu(struct sock *sk, int mss)
 	}
 	return mtu;
 }
 EXPORT_SYMBOL(tcp_mss_to_mtu);
 
+void tcp_mtu_probe_wait_stop(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	if (icsk->icsk_mtup.wait_data) {
+		icsk->icsk_mtup.wait_data = false;
+		sk_stop_timer(sk, &icsk->icsk_mtup.wait_data_timer);
+	}
+}
+
+static void tcp_mtu_probe_wait_timer(struct timer_list *t)
+{
+	struct inet_connection_sock *icsk = from_timer(icsk, t, icsk_mtup.wait_data_timer);
+	struct sock *sk = &icsk->icsk_inet.sk;
+
+	bh_lock_sock(sk);
+	if (!sock_owned_by_user(sk)) {
+		/* push pending frames now */
+		icsk->icsk_mtup.wait_data = false;
+		tcp_push_pending_frames(sk);
+	} else {
+		/* flush later if sock locked by user */
+		sk_reset_timer(sk, &icsk->icsk_mtup.wait_data_timer, jiffies + HZ / 10);
+	}
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
+
 /* MTU probing init per socket */
 void tcp_mtup_init(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -1768,10 +1797,11 @@ void tcp_mtup_init(struct sock *sk)
 			       icsk->icsk_af_ops->net_header_len;
 	icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, net->ipv4.sysctl_tcp_base_mss);
 	icsk->icsk_mtup.probe_size = 0;
 	if (icsk->icsk_mtup.enabled)
 		icsk->icsk_mtup.probe_timestamp = tcp_jiffies32;
+	timer_setup(&icsk->icsk_mtup.wait_data_timer, tcp_mtu_probe_wait_timer, 0);
 }
 EXPORT_SYMBOL(tcp_mtup_init);
 
 /* This function synchronize snd mss to current pmtu/exthdr set.
 
@@ -2366,16 +2396,18 @@ static int tcp_mtu_probe(struct sock *sk)
 		 */
 		tcp_mtu_check_reprobe(sk);
 		return -1;
 	}
 
+	/* Can probe ever fit inside window? */
+	if (tp->snd_wnd < size_needed)
+		return -1;
+
 	/* Have enough data in the send queue to probe? */
 	if (tp->write_seq - tp->snd_nxt < size_needed)
-		return -1;
+		return net->ipv4.sysctl_tcp_probe_wait ? 0 : -1;
 
-	if (tp->snd_wnd < size_needed)
-		return -1;
 	if (after(tp->snd_nxt + size_needed, tcp_wnd_end(tp)))
 		return 0;
 
 	/* Do we need to wait to drain cwnd? With none in flight, don't stall */
 	if (tcp_packets_in_flight(tp) + 2 > tp->snd_cwnd) {
@@ -2596,28 +2628,42 @@ void tcp_chrono_stop(struct sock *sk, const enum tcp_chrono type)
  * but cannot send anything now because of SWS or another problem.
  */
 static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 			   int push_one, gfp_t gfp)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
+	struct net *net = sock_net(sk);
 	struct sk_buff *skb;
 	unsigned int tso_segs, sent_pkts;
 	int cwnd_quota;
 	int result;
 	bool is_cwnd_limited = false, is_rwnd_limited = false;
 	u32 max_segs;
 
 	sent_pkts = 0;
 
 	tcp_mstamp_refresh(tp);
-	if (!push_one) {
+	/*
+	 * Waiting for tcp probe data also applies when push_one=1
+	 * If user does many small writes we hold them until we have have enough
+	 * for a probe.
+	 */
+	if (!push_one || (push_one < 2 && net->ipv4.sysctl_tcp_probe_wait)) {
 		/* Do MTU probing. */
 		result = tcp_mtu_probe(sk);
 		if (!result) {
+			if (net->ipv4.sysctl_tcp_probe_wait && !icsk->icsk_mtup.wait_data) {
+				icsk->icsk_mtup.wait_data = true;
+				sk_reset_timer(sk, &icsk->icsk_mtup.wait_data_timer, jiffies + net->ipv4.sysctl_tcp_probe_wait);
+			}
 			return false;
 		} else if (result > 0) {
+			tcp_mtu_probe_wait_stop(sk);
 			sent_pkts = 1;
+		} else {
+			tcp_mtu_probe_wait_stop(sk);
 		}
 	}
 
 	max_segs = tcp_tso_segs(sk, mss_now);
 	while ((skb = tcp_send_head(sk))) {
-- 
2.25.1

