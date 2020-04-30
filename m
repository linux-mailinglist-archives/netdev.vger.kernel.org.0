Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE7E1C03F5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgD3Rf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3Rf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:35:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEBBC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:35:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j4so8640869ybj.20
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W4d+TDCXfiDdRa/mgZ6+hJRk02dZzOplm8YW3cYbnMo=;
        b=fvMYYwsxjhpK8syDiVlBJ1himbhz1ctFLfDNn2Am8LSXfMKMsljovV+bcTfc4utbAC
         ACBndEC16iQZn65RhM5fxFhdPIINIFEfv12jalvaP7AUfuy4R8m4eE6iqxM8+njDtXAM
         acM1oEhaIIHXd8mqomBc7O1PTvcpvPB6U04iFAknmHNkqr3EqcfR6V+Jzat06ptP/FQj
         /LlQKtczACeTi2L6A8Of2ZfHlphLV5Gu5MJQF+84fYPTF/JZv/0KhfI7BEQfbKf9QZF2
         49ObNgTlb40IWHQVvPtTqkExgsUeZBPlU+iL/C8kXUPkHiMexUnRpwSCu+OjrlsHAKHi
         shEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W4d+TDCXfiDdRa/mgZ6+hJRk02dZzOplm8YW3cYbnMo=;
        b=fyjW0BMUvbmEQkA1VJE7C+18JFpFwK+4onIi4yEPSRLpHcInZLDqoJ2obpTsasNJ+X
         +cpViAnobCayAOyKDYLOPMaS46+Tl/dwUIgO+xmj5UUHbBdGzNRL4N1+vzCxpr5WXt8W
         ASDbhbAYacfy2qiMXYl6u3Now6Ry9YU6zws5L7IEIgiXs13AyNWMarQcTDkvjZ6619n8
         coKPD+1S2Yy4O9H735tilzum2BCi61hpCswYV+5LYOAT5Crtf43IWGK8S3LOR6rIemgc
         TzaDTIuTZNaGapGSCnxTfM59BGGQNg19aP72MV/rLxB3Xel++qRqU9QpmVakM0Xy//oR
         SM7Q==
X-Gm-Message-State: AGi0PubqdVV0+QeIAljHaz3QJaq8R6J+F+uVnso7Z4EilLD9z4nBc1eS
        DnduDDeQCeTofRCMnDnlq91hHwBtm6jNPw==
X-Google-Smtp-Source: APiQypL7jcIwOPbwEe4bx0kJlIoawTg36EEdgAtdFN/JtbEd5si3+UuhygsTFubXL+eWYp6qr8e3gKfEDoD8kA==
X-Received: by 2002:a25:1304:: with SMTP id 4mr7480942ybt.431.1588268154948;
 Thu, 30 Apr 2020 10:35:54 -0700 (PDT)
Date:   Thu, 30 Apr 2020 10:35:43 -0700
In-Reply-To: <20200430173543.41026-1-edumazet@google.com>
Message-Id: <20200430173543.41026-4-edumazet@google.com>
Mime-Version: 1.0
References: <20200430173543.41026-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH net-next 3/3] tcp: add hrtimer slack to sack compression
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a sysctl to control hrtimer slack, default of 100 usec.

This gives the opportunity to reduce system overhead,
and help very short RTT flows.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
---
 Documentation/networking/ip-sysctl.rst | 8 ++++++++
 include/net/netns/ipv4.h               | 1 +
 net/ipv4/sysctl_net_ipv4.c             | 7 +++++++
 net/ipv4/tcp_input.c                   | 5 +++--
 net/ipv4/tcp_ipv4.c                    | 1 +
 5 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 38f811d4b2f09fa81cd2ec22cefe95f9353858c9..bbefd5c6d96db4115a8aa7948a93868c0ae55a2f 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -651,6 +651,14 @@ tcp_comp_sack_delay_ns - LONG INTEGER
 
 	Default : 1,000,000 ns (1 ms)
 
+tcp_comp_sack_slack_ns - LONG INTEGER
+	This sysctl control the slack used when arming the
+	timer used by SACK compression. This gives extra time
+	for small RTT flows, and reduces system overhead by allowing
+	opportunistic reduction of timer interrupts.
+
+	Default : 100,000 ns (100 us)
+
 tcp_comp_sack_nr - INTEGER
 	Max number of SACK that can be compressed.
 	Using 0 disables SACK compression.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 5acdb4d414c4fe3cb96b62e6bf3500f447371247..9e36738c1fe164fa75cb6c4a0802773925f73b9a 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -173,6 +173,7 @@ struct netns_ipv4 {
 	int sysctl_tcp_rmem[3];
 	int sysctl_tcp_comp_sack_nr;
 	unsigned long sysctl_tcp_comp_sack_delay_ns;
+	unsigned long sysctl_tcp_comp_sack_slack_ns;
 	struct inet_timewait_death_row tcp_death_row;
 	int sysctl_max_syn_backlog;
 	int sysctl_tcp_fastopen;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 95ad71e76cc3f62348c416e296be777decbc1e12..3a628423d27bfe28d5dfc5b70c5b9f980275fc7f 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1329,6 +1329,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
+	{
+		.procname	= "tcp_comp_sack_slack_ns",
+		.data		= &init_net.ipv4.sysctl_tcp_comp_sack_slack_ns,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
 	{
 		.procname	= "tcp_comp_sack_nr",
 		.data		= &init_net.ipv4.sysctl_tcp_comp_sack_nr,
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index ef921ecba4155abe9d078152ca8bd6a0be68317e..d68128a672ab05899d26eb9b1978c4a34023d51f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5324,8 +5324,9 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 	delay = min_t(unsigned long, sock_net(sk)->ipv4.sysctl_tcp_comp_sack_delay_ns,
 		      rtt * (NSEC_PER_USEC >> 3)/20);
 	sock_hold(sk);
-	hrtimer_start(&tp->compressed_ack_timer, ns_to_ktime(delay),
-		      HRTIMER_MODE_REL_PINNED_SOFT);
+	hrtimer_start_range_ns(&tp->compressed_ack_timer, ns_to_ktime(delay),
+			       sock_net(sk)->ipv4.sysctl_tcp_comp_sack_slack_ns,
+			       HRTIMER_MODE_REL_PINNED_SOFT);
 }
 
 static inline void tcp_ack_snd_check(struct sock *sk)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 83a5d24e13b8c0079d80950acde13c232b4a845e..6c05f1ceb538cbb9981835440163485de2ccf716 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2780,6 +2780,7 @@ static int __net_init tcp_sk_init(struct net *net)
 		       sizeof(init_net.ipv4.sysctl_tcp_wmem));
 	}
 	net->ipv4.sysctl_tcp_comp_sack_delay_ns = NSEC_PER_MSEC;
+	net->ipv4.sysctl_tcp_comp_sack_slack_ns = 100 * NSEC_PER_USEC;
 	net->ipv4.sysctl_tcp_comp_sack_nr = 44;
 	net->ipv4.sysctl_tcp_fastopen = TFO_CLIENT_ENABLE;
 	spin_lock_init(&net->ipv4.tcp_fastopen_ctx_lock);
-- 
2.26.2.303.gf8c07b1a785-goog

