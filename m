Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E3234992C
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhCYSIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhCYSId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:08:33 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2170C06175F
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:32 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y5so2899195pfn.1
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YNpC8NhdW9tWzF3J/HjQSg/ShP8h4yjI1tok4iieMKU=;
        b=aIq9hR1DM6Rbj5yROX6c7dJXBwxR/x9g2T27J0zJhz160wFriAmisKdBOzGDZY5HMm
         ic8EznSZU7aeuq/D8ag9R9jWyRzaSf2cPggJ+CVMucJTuaMzGV1Purz84CsR93IZZff4
         s26ABsCYViX8+Nl5YH833ulPKIcrXWvXQbU86XbSdRjMbzrO2sNbzoLRd4jp8BqrPc7+
         CQQl2yq0z/U+hyna/4Q4lXiDMnSUKiKkoGh6ek6NNvw4N3BF/RxqwnRdUEO7rvO/g9mO
         Ps9xLiXygbhAzgwJ+eoMpe38UQRjoX9zK6qsTn0mfCyeu4CeGfSekp91TuDPiFoGSmWL
         lhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YNpC8NhdW9tWzF3J/HjQSg/ShP8h4yjI1tok4iieMKU=;
        b=mDN1ok5VboewkBxbfbN6hZoJtaq5NTVCiFuJcKU16wHbjQlaq5JiRcgSd9HcjRZAbS
         7bpD6exvS1VFA5yap+EopIyDqUIN5qWNX13PfhViNYr/kmbhlcoAVmiZdqQNw2t9aPEl
         bRN6Mr2e3Jca9JtuFuA+FqS2NyxHcUbJ/3B9F56vMG30BlDTWNRont3ElMwkM68RO0wC
         Ccy4VZ0lND9eGPeh04bOytsGilyjAaIEx08LpbP/v6gJZMuNYOgw/fb/0YiS2d0ZWFbH
         ziBGdlBwjWCo2urGE4FYb+4g1yDryM8TNaRlYKqyOt52TEgg9qikN/kaCHMjdAlq490W
         M5fg==
X-Gm-Message-State: AOAM530RWe0QC2J4G2/3bjiXyKMZfWAf8Hp6jsZb4ELW9qNCcxEAvrFb
        9YeB1di5eh8unB4nMJ8/HNg=
X-Google-Smtp-Source: ABdhPJxj8M83zPPAiy3jGJ9WCYG2Bf6Xn/liweJiWTlbjB8WwedER7GOvHoJnW4c5W0Gw2zxsqvEGQ==
X-Received: by 2002:a62:6413:0:b029:1f3:a5b4:d978 with SMTP id y19-20020a6264130000b02901f3a5b4d978mr9174564pfb.44.1616695712251;
        Thu, 25 Mar 2021 11:08:32 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2c0c:35d8:b060:81b3])
        by smtp.gmail.com with ESMTPSA id j20sm5968359pjn.27.2021.03.25.11.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:08:31 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/5] ipv4: shrink netns_ipv4 with sysctl conversions
Date:   Thu, 25 Mar 2021 11:08:14 -0700
Message-Id: <20210325180817.840042-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210325180817.840042-1-eric.dumazet@gmail.com>
References: <20210325180817.840042-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

These sysctls that can fit in one byte instead of one int
are converted to save space and thus reduce cache line misses.

 - icmp_echo_ignore_all, icmp_echo_ignore_broadcasts,
 - icmp_ignore_bogus_error_responses, icmp_errors_use_inbound_ifaddr
 - tcp_ecn, tcp_ecn_fallback
 - ip_default_ttl, ip_no_pmtu_disc, ip_fwd_use_pmtu
 - ip_nonlocal_bind, ip_autobind_reuse
 - ip_dynaddr, ip_early_demux, raw_l3mdev_accept
 - nexthop_compat_mode, fwmark_reflect

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h   | 32 +++++++++----------
 net/ipv4/sysctl_net_ipv4.c | 64 +++++++++++++++++++-------------------
 2 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 9e3cb2722b804bc6618632128185c311e5210146..7b572d468fde5ae104ecdf4bd5b8118290deb81d 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -83,36 +83,36 @@ struct netns_ipv4 {
 	struct xt_table		*nat_table;
 #endif
 
-	int sysctl_icmp_echo_ignore_all;
-	int sysctl_icmp_echo_ignore_broadcasts;
-	int sysctl_icmp_ignore_bogus_error_responses;
+	u8 sysctl_icmp_echo_ignore_all;
+	u8 sysctl_icmp_echo_ignore_broadcasts;
+	u8 sysctl_icmp_ignore_bogus_error_responses;
+	u8 sysctl_icmp_errors_use_inbound_ifaddr;
 	int sysctl_icmp_ratelimit;
 	int sysctl_icmp_ratemask;
-	int sysctl_icmp_errors_use_inbound_ifaddr;
 
 	struct local_ports ip_local_ports;
 
-	int sysctl_tcp_ecn;
-	int sysctl_tcp_ecn_fallback;
+	u8 sysctl_tcp_ecn;
+	u8 sysctl_tcp_ecn_fallback;
 
-	int sysctl_ip_default_ttl;
-	int sysctl_ip_no_pmtu_disc;
-	int sysctl_ip_fwd_use_pmtu;
+	u8 sysctl_ip_default_ttl;
+	u8 sysctl_ip_no_pmtu_disc;
+	u8 sysctl_ip_fwd_use_pmtu;
 	int sysctl_ip_fwd_update_priority;
-	int sysctl_ip_nonlocal_bind;
-	int sysctl_ip_autobind_reuse;
+	u8 sysctl_ip_nonlocal_bind;
+	u8 sysctl_ip_autobind_reuse;
 	/* Shall we try to damage output packets if routing dev changes? */
-	int sysctl_ip_dynaddr;
-	int sysctl_ip_early_demux;
+	u8 sysctl_ip_dynaddr;
+	u8 sysctl_ip_early_demux;
 #ifdef CONFIG_NET_L3_MASTER_DEV
-	int sysctl_raw_l3mdev_accept;
+	u8 sysctl_raw_l3mdev_accept;
 #endif
 	int sysctl_tcp_early_demux;
 	int sysctl_udp_early_demux;
 
-	int sysctl_nexthop_compat_mode;
+	u8 sysctl_nexthop_compat_mode;
 
-	int sysctl_fwmark_reflect;
+	u8 sysctl_fwmark_reflect;
 	int sysctl_tcp_fwmark_accept;
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	int sysctl_tcp_l3mdev_accept;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index f55095d3ed1656fdb8badaed7eb58832c5063299..e5ff17526603c274d50350bc1ebb21e20c598c9a 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -595,30 +595,30 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "icmp_echo_ignore_all",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_all,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_echo_ignore_broadcasts",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_broadcasts,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_ignore_bogus_error_responses",
 		.data		= &init_net.ipv4.sysctl_icmp_ignore_bogus_error_responses,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_errors_use_inbound_ifaddr",
 		.data		= &init_net.ipv4.sysctl_icmp_errors_use_inbound_ifaddr,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_ratelimit",
@@ -645,9 +645,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "raw_l3mdev_accept",
 		.data		= &init_net.ipv4.sysctl_raw_l3mdev_accept,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
@@ -655,30 +655,30 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_ecn",
 		.data		= &init_net.ipv4.sysctl_tcp_ecn,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_ecn_fallback",
 		.data		= &init_net.ipv4.sysctl_tcp_ecn_fallback,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_dynaddr",
 		.data		= &init_net.ipv4.sysctl_ip_dynaddr,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_early_demux",
 		.data		= &init_net.ipv4.sysctl_ip_early_demux,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname       = "udp_early_demux",
@@ -697,18 +697,18 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname       = "nexthop_compat_mode",
 		.data           = &init_net.ipv4.sysctl_nexthop_compat_mode,
-		.maxlen         = sizeof(int),
+		.maxlen         = sizeof(u8),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec_minmax,
+		.proc_handler   = proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "ip_default_ttl",
 		.data		= &init_net.ipv4.sysctl_ip_default_ttl,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= &ip_ttl_min,
 		.extra2		= &ip_ttl_max,
 	},
@@ -729,16 +729,16 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "ip_no_pmtu_disc",
 		.data		= &init_net.ipv4.sysctl_ip_no_pmtu_disc,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_forward_use_pmtu",
 		.data		= &init_net.ipv4.sysctl_ip_fwd_use_pmtu,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_forward_update_priority",
@@ -752,25 +752,25 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "ip_nonlocal_bind",
 		.data		= &init_net.ipv4.sysctl_ip_nonlocal_bind,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_autobind_reuse",
 		.data		= &init_net.ipv4.sysctl_ip_autobind_reuse,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "fwmark_reflect",
 		.data		= &init_net.ipv4.sysctl_fwmark_reflect,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_fwmark_accept",
-- 
2.31.0.291.g576ba9dcdaf-goog

