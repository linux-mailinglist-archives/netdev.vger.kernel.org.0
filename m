Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD5B1B8A66
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 02:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgDZAs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 20:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726088AbgDZAs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 20:48:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51ADEC09B04F
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 17:48:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j7so6711508pgj.13
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 17:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BkSJNoykt1mcxVnioMNZn++OtylBRwGXCOS0FRFUsbU=;
        b=M9tzFLZKbwH8Ldvs+hh1ttqnqCn0ckuuJWyatuc57FXho41BYDzdI8BWiJSdT2eGD0
         PZcHOGMFsM4xKMgqfD34S3mUUwdYwqYErtDA5XjKyDJyxssP9jQNoqD8EFkp1Gz2YGEX
         4yIdzRQjdl++d9a5Y0EypIwW83dWtM4MVdkIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BkSJNoykt1mcxVnioMNZn++OtylBRwGXCOS0FRFUsbU=;
        b=Z3KSxSdkFD/GoiZAacnAkkxTE9tmO37J84dWF73Cc7OQNJLLYK3Pci5BI3in52up9D
         6iDk4eMYqPZntwRWL5uzAL91u1+AGHgCPAncs/qFGOaNhsSo7dXDEaTUZ/bZVkqqRIAt
         QDeymnLy/5m+E4Ao3OWJjzer0FTDA83pWyj8mZsVugNnDzVT3il+m0eyl1DGc2hVHh3L
         qIz0xJMAYZewCPbBpcY+Ib3ON8GJb6Hc7faQlfIDqg7R7dz2H1CUQ8OfsuBU2ES7LeiS
         gtMW5h2s25s5nLQi9lLsaSG0r7mAbmDfcqg6Ac34ll/EFn8z5yx2rM3Zx0RYMX9CKvUV
         oCYw==
X-Gm-Message-State: AGi0PuZtZmfQpT6NpS3AU0C2JoByP64brGuSbJ5pbAUSI4T6yoxc68fe
        2IJxjCvIdB5WWt7RHhfFZQrRYA==
X-Google-Smtp-Source: APiQypKC6HYZOKajze5lrJDfjaSG0kFhMcQvk5P8ufXVoY2KKpY1/zUWSUhIq3MFVx63Kt0WIEaARQ==
X-Received: by 2002:a62:ee05:: with SMTP id e5mr17261546pfi.288.1587862136849;
        Sat, 25 Apr 2020 17:48:56 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id c59sm8242514pje.10.2020.04.25.17.48.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Apr 2020 17:48:56 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        bpoirier@cumulusnetworks.com
Subject: [PATCH net-next v2 2/3] ipv4: add sysctl for nexthop api compatibility mode
Date:   Sat, 25 Apr 2020 17:48:47 -0700
Message-Id: <1587862128-24319-3-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
References: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
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
 include/net/netns/ipv4.h   | 2 ++
 net/ipv4/af_inet.c         | 1 +
 net/ipv4/fib_semantics.c   | 3 +++
 net/ipv4/nexthop.c         | 5 +++--
 net/ipv4/sysctl_net_ipv4.c | 7 +++++++
 net/ipv6/route.c           | 3 ++-
 6 files changed, 18 insertions(+), 3 deletions(-)

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
index 81b267e..a613ecf 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -711,6 +711,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.proc_handler   = proc_tcp_early_demux
 	},
 	{
+		.procname       = "nexthop_compat_mode",
+		.data           = &init_net.ipv4.sysctl_nexthop_compat_mode,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec
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

