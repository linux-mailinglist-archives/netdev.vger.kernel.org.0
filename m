Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37311BAFD3
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgD0U46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD0U44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:56:56 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D5CC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:56:56 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y25so9581295pfn.5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OJN0rquhCfz9o5krupFkSjN+5fo7apNC6hQZvTvaZaM=;
        b=GrqCxLGlpdTk3TkLBVmEtaIyz5pWBee9DA2jmmp1Mvx5VBXzsWpBN0WqcL5re8ZtjM
         sjb4aYPmj/dqa1pZ/86rYWXcgakogBWl24suPxs/8SK4MTBJLLONmOqY32HovBTyZ652
         iVGp9EXXR/fJLwh2IJuEXjgjuT3Epq9uDnzSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OJN0rquhCfz9o5krupFkSjN+5fo7apNC6hQZvTvaZaM=;
        b=oDL6KyiRJTNL3/g9zLLU6+X3Qp0N5ZsWBezMXDOybx2PvB5vSJwt9Nm3PqD1HTaJJ3
         8ie+QUE7kTRlUQbfI05KCm0KbX42BnrJlGbnu14vJZ6Gxi6kiRcizVlwkMXByqFcCw1+
         yTg8NZHkyX7PR1X75M0Lo2rF8BfYjanqRURAKZ/IhGpeKf/cqKrgwKFEAGa7erHuNuNX
         UbSNWQmNK0QmihcI/Jj3/ngQREfVfB4gx21cZtYE4Qm6rgcv7dLvTI0ZoCefClhVjtNm
         zuoSs1DNUNef7L2E6owWailOH8LYzUf/6yYznRjqGfPjbK0NejkzcdipF0TG6dhDtRoi
         RhBw==
X-Gm-Message-State: AGi0PuYW7X4UBxgMnpD2MafCqYBj3KPI9jFNW6lFyhc0sOG1TqNpD008
        jgl5FVqNWlpzfUwwB4if9f9D7g==
X-Google-Smtp-Source: APiQypKFtiTTelE3Sj4DaCKCzin7nTWsL/g1EPNEgBQFiLFu7zZHQE71HhJH0CYUSVOy7XijTpLeCw==
X-Received: by 2002:a63:1961:: with SMTP id 33mr25614891pgz.282.1588021015794;
        Mon, 27 Apr 2020 13:56:55 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id fh18sm443830pjb.0.2020.04.27.13.56.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 13:56:54 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
Subject: [PATCH net-next v4 2/3] net: ipv4: add sysctl for nexthop api compatibility mode
Date:   Mon, 27 Apr 2020 13:56:46 -0700
Message-Id: <1588021007-16914-3-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
References: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
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
 Documentation/networking/ip-sysctl.txt | 12 ++++++++++++
 include/net/netns/ipv4.h               |  2 ++
 net/ipv4/af_inet.c                     |  1 +
 net/ipv4/fib_semantics.c               |  3 +++
 net/ipv4/nexthop.c                     |  5 +++--
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 net/ipv6/route.c                       |  3 ++-
 7 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 6fcfd31..a8f2da4 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -1553,6 +1553,18 @@ skip_notify_on_dev_down - BOOLEAN
 	on userspace caches to track link events and evict routes.
 	Default: false (generate message)
 
+nexthop_compat_mode - BOOLEAN
+	New nexthop API provides a means for managing nexthops independent of
+	prefixes. Backwards compatibilty with old route format is enabled by
+	default which means route dumps and notifications contain the new
+	nexthop attribute but also the full, expanded nexthop definition.
+	Further, updates or deletes of a nexthop configuration generate route
+	notifications for each fib entry using the nexthop. Once a system
+	understands the new API, this sysctl can be disabled to achieve full
+	performance benefits of the new API by disabling the nexthop expansion
+	and extraneous notifications.
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

