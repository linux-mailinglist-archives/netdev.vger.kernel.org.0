Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF13E1B5421
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgDWFV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725562AbgDWFV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:21:27 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139FCC03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 22:21:27 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t11so2336390pgg.2
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 22:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=idCGZ6bQfz5WdNkLrIRJT2qi6I/UEwDpf6Zl/Js3VPA=;
        b=av50NExPaz6tkU2O2me9/z+Z0+5cEuYK9LdKH3rFXkfAIBbGgzdKTwAvBN2uO/wu9Y
         EcUhqvOtNWfrT+fUnkYGYSXpS11rg8ze8nJnkZvUZbi8j/V3VKPGj3E8TdXDMcsThphN
         EwIn6x4xMPfJ2Ej5xBIwr9c4bRggmXEwZHuXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=idCGZ6bQfz5WdNkLrIRJT2qi6I/UEwDpf6Zl/Js3VPA=;
        b=ptz0f4T2C/2axgr2eyOwG/XPcDnPA7lc+fnEAHj3cy4raw6pkUKYGrWsMiu5OLNodx
         I+DUaVvUEOGiXHOzZgYTIPCbu5WSU34t3+JKHmQnkO+pAhlp+JWh8C08tR+/ltgZi6EV
         ErXak5adhEsqCkEFiqA/h/qATBKOF0+LFexVX7jMsjawqzTfHzx0gF6wV9CXI5lJwGQz
         rARvECMgzbCth+N4BjgrbCgw8Y01PTjpgcC1wBQYQpKGuSS7v0xWJrhl813bzhHUc7I3
         2XZMrMTE7lUp+gkRdW9x0etEafnMLUvyiSVyH4GY2JODQgwZRA3NAWQbUV97azlZs8mU
         RL0Q==
X-Gm-Message-State: AGi0PuYII9tgGoTfbrmos5moJWGeUDqLzyE/dPVm+EUg+D4jA8TpXM2j
        Rd2VSBzcrRhmoLYmrSUUJcsciaNuor6l7A==
X-Google-Smtp-Source: APiQypLMyeefb8AmfKmCO+fQdfkCtaEbuguTKOAFo7Yu9/X6dZXTqjn3qYrqRd/y1l3oGTpQi2wTRg==
X-Received: by 2002:aa7:85d3:: with SMTP id z19mr2057030pfn.215.1587619286618;
        Wed, 22 Apr 2020 22:21:26 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id u3sm1279160pfn.217.2020.04.22.22.21.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 22:21:26 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        bpoirier@cumulusnetworks.com
Subject: [PATCH net-next 1/2] ipv4: add sysctl to skip route notify on nexthop changes
Date:   Wed, 22 Apr 2020 22:21:19 -0700
Message-Id: <1587619280-46386-2-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1587619280-46386-1-git-send-email-roopa@cumulusnetworks.com>
References: <1587619280-46386-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

Route notifications on nexthop changes exists for backward
compatibility. In systems which have moved to the new
nexthop API, these route update notifications cancel the
performance benefits provided by the new nexthop API.
This patch adds a sysctl to disable these route notifications
generated for changes to nexthop objects.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 include/net/netns/ipv4.h   | 2 ++
 net/ipv4/af_inet.c         | 1 +
 net/ipv4/nexthop.c         | 3 ++-
 net/ipv4/sysctl_net_ipv4.c | 7 +++++++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 154b8f0..59a190c 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -111,6 +111,8 @@ struct netns_ipv4 {
 	int sysctl_tcp_early_demux;
 	int sysctl_udp_early_demux;
 
+	int sysctl_nexthop_skip_route_notify;
+
 	int sysctl_fwmark_reflect;
 	int sysctl_tcp_fwmark_accept;
 #ifdef CONFIG_NET_L3_MASTER_DEV
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index c618e24..7c1db4b 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1835,6 +1835,7 @@ static __net_init int inet_init_net(struct net *net)
 	net->ipv4.sysctl_ip_early_demux = 1;
 	net->ipv4.sysctl_udp_early_demux = 1;
 	net->ipv4.sysctl_tcp_early_demux = 1;
+	net->ipv4.sysctl_nexthop_skip_route_notify = 0;
 #ifdef CONFIG_SYSCTL
 	net->ipv4.sysctl_ip_prot_sock = PROT_SOCK;
 #endif
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index fdfca53..fc6c76b 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -895,7 +895,8 @@ static void __nexthop_replace_notify(struct net *net, struct nexthop *nh,
 {
 	struct fib6_info *f6i;
 
-	if (!list_empty(&nh->fi_list)) {
+	if (!net->ipv4.sysctl_nexthop_skip_route_notify &&
+	    !list_empty(&nh->fi_list)) {
 		struct fib_info *fi;
 
 		/* expectation is a few fib_info per nexthop and then
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 81b267e..1cd010d 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -711,6 +711,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.proc_handler   = proc_tcp_early_demux
 	},
 	{
+		.procname       = "nexthop_skip_route_notify",
+		.data           = &init_net.ipv4.sysctl_nexthop_skip_route_notify,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec
+	},
+	{
 		.procname	= "ip_default_ttl",
 		.data		= &init_net.ipv4.sysctl_ip_default_ttl,
 		.maxlen		= sizeof(int),
-- 
2.1.4

