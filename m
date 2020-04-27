Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A4D1B958C
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 05:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgD0Dld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 23:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726460AbgD0Dlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 23:41:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBFAC061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 20:41:32 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id fu13so6271559pjb.5
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 20:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PTOk53F33eTv8lkmO9IyswbUp3ncnE/JKpB7VxyzaS4=;
        b=P56c12/2tv8wLnalasEceSMUzR+sBdmfcyj/2IbJdG2AwVPvsjOEUlgVD2Kp97D9lB
         LQ23VUEPpMPxZKjynOPi8ZbNf/yuUIQiQAuwTYFN/CHdinzn9iIFgzjj85f0qOvIYT7j
         v6wy8fr3YeFQR5xrCHKrr7CuFdI3hIIaE0CLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PTOk53F33eTv8lkmO9IyswbUp3ncnE/JKpB7VxyzaS4=;
        b=DW/ISIuGK+l402qFdL1pWIATprQ6lyzGFJgkvYxXvJaa87K6EakTl4oGt1qVQ0lVt0
         TMe4tkf++yaYH+5lB1tokL70iIBKvH4co5CG5dD4+LaOfWoQiUu8qMz8CjFPe2P2ySq3
         G6B+20FDP4bF5KPuU5Gt3jKr4z7w+VsuJem4q4LNAegJ4p5JdFSpz5JMxK4Qk3fFTGia
         QudbDplh+AFHXyXpsJeJVY4oEXmm3btYxN0YABO3RT0v8ThVwTWd8/hKbmw0mUqag4fi
         pEyXMH9u+12oiK1JRyxnwFNAl+v7DyFLEVXEZAcYNKEiGor/pOnpxIJhmHrh+X0ncuEs
         cvEw==
X-Gm-Message-State: AGi0PuZsb1KdvOuZ3UWkj0Gkpn98gA5cTpUukfO1Rupkmw2w6pQ38Djo
        n0jY6T3nZImoWfXYreCYq4Uy8Q==
X-Google-Smtp-Source: APiQypLtMPmUZziTtdWU3B78/FTZrWl/TK4rWvhOsjowloch38liHLAO3ocgiwZbaRX7SayU96lW8g==
X-Received: by 2002:a17:90a:23a3:: with SMTP id g32mr21437481pje.78.1587958891827;
        Sun, 26 Apr 2020 20:41:31 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id 6sm11200858pfj.123.2020.04.26.20.41.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 20:41:31 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
Subject: [PATCH net-next v3 2/3] net: ipv4: add sysctl for nexthop api compatibility mode
Date:   Sun, 26 Apr 2020 20:41:24 -0700
Message-Id: <1587958885-29540-3-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1587958885-29540-1-git-send-email-roopa@cumulusnetworks.com>
References: <1587958885-29540-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

Current route nexthop API maintains user space compatibility
with old route API by default. Dumps and netlink notifications
support both new and old API format. In systems which have
moved to the new API, this compatibility mode cancels some
of the performance benefits provided by the new nexthop API.

This patch adds new sysctl nexthop_compat_mode which is on
by default but provides the ability to turn off compatibility
mode allowing systems to run entirely with the new routing
API. Old route API behaviour and support is not modified by this
sysctl.

Uses a single sysctl to cover both ipv4 and ipv6 following
other sysctls. Covers dumps and delete notifications as
suggested by David Ahern.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 Documentation/networking/ip-sysctl.txt | 14 ++++++++++++++
 include/net/netns/ipv4.h               |  2 ++
 net/ipv4/af_inet.c                     |  1 +
 net/ipv4/fib_semantics.c               |  3 +++
 net/ipv4/nexthop.c                     |  5 +++--
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 net/ipv6/route.c                       |  3 ++-
 7 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 6fcfd31..02029b5 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1553,6 +1553,20 @@ skip_notify_on_dev_down - BOOLEAN
 	on userspace caches to track link events and evict routes.
 	Default: false (generate message)
 
+nexthop_compat_mode - BOOLEAN
+	Controls whether new route nexthop API is backward compatible
+	with old route API. By default Route nexthop API maintains
+	user space compatibility with old route API: Which means
+	Route dumps and netlink notifications include both new and
+	old route attributes. In systems which have moved to the new API,
+	this compatibility mode provides a way to turn off the old
+	notifications and route attributes in dumps. This sysctl is on
+	by default but provides the ability to turn off compatibility
+	mode allowing systems to run entirely with the new routing
+	nexthop API. Old route API behaviour and support is not modified
+	by this sysctl
+	Default: true (backward compat mode)
+
 IPv6 Fragmentation:
 
 ip6frag_high_thresh - INTEGER
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 154b8f0..5acdb4d 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -111,6 +111,8 @@ struct netns_ipv4 {
 	int sysctl_tcp_early_demux;
 	int sysctl_udp_early_demux;
 
+	int sysctl_nexthop_compat_mode;
+
 	int sysctl_fwmark_reflect;
 	int sysctl_tcp_fwmark_accept;
 #ifdef CONFIG_NET_L3_MASTER_DEV
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index c618e24..6177c4b 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1835,6 +1835,7 @@ static __net_init int inet_init_net(struct net *net)
 	net->ipv4.sysctl_ip_early_demux = 1;
 	net->ipv4.sysctl_udp_early_demux = 1;
 	net->ipv4.sysctl_tcp_early_demux = 1;
+	net->ipv4.sysctl_nexthop_compat_mode = 1;
 #ifdef CONFIG_SYSCTL
 	net->ipv4.sysctl_ip_prot_sock = PROT_SOCK;
 #endif
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 6ed8c93..7546b88 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1780,6 +1780,8 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 			goto nla_put_failure;
 		if (nexthop_is_blackhole(fi->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
+		if (!fi->fib_net->ipv4.sysctl_nexthop_compat_mode)
+			goto offload;
 	}
 
 	if (nhs == 1) {
@@ -1805,6 +1807,7 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 			goto nla_put_failure;
 	}
 
+offload:
 	if (fri->offload)
 		rtm->rtm_flags |= RTM_F_OFFLOAD;
 	if (fri->trap)
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 9999687..3957364 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -784,7 +784,8 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 	list_for_each_entry_safe(f6i, tmp, &nh->f6i_list, nh_list) {
 		/* __ip6_del_rt does a release, so do a hold here */
 		fib6_info_hold(f6i);
-		ipv6_stub->ip6_del_rt(net, f6i, false);
+		ipv6_stub->ip6_del_rt(net, f6i,
+				      !net->ipv4.sysctl_nexthop_compat_mode);
 	}
 }
 
@@ -1041,7 +1042,7 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 	if (!rc) {
 		nh_base_seq_inc(net);
 		nexthop_notify(RTM_NEWNEXTHOP, new_nh, &cfg->nlinfo);
-		if (replace_notify)
+		if (replace_notify && net->ipv4.sysctl_nexthop_compat_mode)
 			nexthop_replace_notify(net, new_nh, &cfg->nlinfo);
 	}
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 81b267e..95ad71e 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -711,6 +711,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.proc_handler   = proc_tcp_early_demux
 	},
 	{
+		.procname       = "nexthop_compat_mode",
+		.data           = &init_net.ipv4.sysctl_nexthop_compat_mode,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
 		.procname	= "ip_default_ttl",
 		.data		= &init_net.ipv4.sysctl_ip_default_ttl,
 		.maxlen		= sizeof(int),
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 486c36a..803212a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5557,7 +5557,8 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		if (nexthop_is_blackhole(rt->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
 
-		if (rt6_fill_node_nexthop(skb, rt->nh, &nh_flags) < 0)
+		if (net->ipv4.sysctl_nexthop_compat_mode &&
+		    rt6_fill_node_nexthop(skb, rt->nh, &nh_flags) < 0)
 			goto nla_put_failure;
 
 		rtm->rtm_flags |= nh_flags;
-- 
2.1.4

