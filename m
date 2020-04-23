Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B631B5422
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgDWFV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726625AbgDWFV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:21:28 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE56C03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 22:21:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y25so2370008pfn.5
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 22:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nit+zgWMxu1UwSDbfpMUvu9MfF7wpQ8WYQxwM73bS74=;
        b=QB7nKc2DV0NKGMM402Mo7BFBixbMK7jPtXjp/l4fJh9LyiOfT4X7Q98Pzs1x+61RMJ
         LgWGMzUmZtSJSR1MNXn+KS3gitrHajnA2aKHzF/e1aqUo5wghbllpEW9jvUn8HZ1oA3Q
         FC4yO2rdo8WgGfeOv62sHHAcw31YH5cVXKNSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nit+zgWMxu1UwSDbfpMUvu9MfF7wpQ8WYQxwM73bS74=;
        b=GQGsgd/JVUz7MxJ1LhKbKlUpmDNeCJixEE2gXTXFcYRlJMfbrR2saNR3/upk9m4xAg
         fuU7xjDincOU9aBKxMupe2iSzxjogXOfQxXtpo+PnoI+N7zSaB9rLWF43H3S8UBCgp1U
         lCbcJnu/anJh9fwNX9ltU/N/29pf46NpyicbMFnRdIpW+x932TqROiQfB3gwUhK1bR+O
         yRMDqnT3XTQF+45yGEtCy28wbx8YzhtFIFGkgH1lIUa4W3UF5T3UJ7RdPNQGK02tQCNv
         6dVDvSBGMlNwuSlS6MJZPZiV6q781Ey4O9rPvKPLYJrkQl3VebLjOYLYb7MOuAXMrU/t
         qtsw==
X-Gm-Message-State: AGi0PuZl2/citnDQ1gCF6fY1Ibg3dP+4B37buZAofJCoexOJvD85rAi+
        XGu56TYb8SPsNigxhGUC3MolcQ==
X-Google-Smtp-Source: APiQypImcyPLlS5icrcBHEIE3kcNsMFoNRt6Rfm0pD8LLVKzO4q/v+rPb6Fjs6CYULvZHU5/oP2wgQ==
X-Received: by 2002:a63:eb15:: with SMTP id t21mr2383619pgh.279.1587619287803;
        Wed, 22 Apr 2020 22:21:27 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id u3sm1279160pfn.217.2020.04.22.22.21.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 22:21:27 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        bpoirier@cumulusnetworks.com
Subject: [PATCH net-next 2/2] ipv6: add sysctl to skip route notify on nexthop changes
Date:   Wed, 22 Apr 2020 22:21:20 -0700
Message-Id: <1587619280-46386-3-git-send-email-roopa@cumulusnetworks.com>
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
nexthop API, these route update notifications cancel
the performance benefits provided by the new nexthop API.
This patch adds a sysctl to disable these route notifications.

The sysctl check is added in fib6_rt_update which seems
like the least intrusive approach. I have considered adding the
sysctl check in nexthop code that calls fib6_rt_update: But
that requires the sysctl access to be via ipv6_stub.
That seems overkill. I have also considered making fib6_rt_update
ipv6_stub op to take a nexthop, but that creates more problems
with exposing nexthop object to ipv6_stub.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 include/net/netns/ipv6.h |  1 +
 net/ipv6/route.c         | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 5ec0544..25818493 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -51,6 +51,7 @@ struct netns_sysctl_ipv6 {
 	int max_hbh_opts_len;
 	int seg6_flowlabel;
 	bool skip_notify_on_dev_down;
+	bool nexthop_skip_route_notify;
 };
 
 struct netns_ipv6 {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 310cbdd..d023ba0 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6006,6 +6006,9 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
+	if (net->ipv6.sysctl.nexthop_skip_route_notify)
+		return;
+
 	/* call_fib6_entry_notifiers will be removed when in-kernel notifier
 	 * is implemented and supported for nexthop objects
 	 */
@@ -6188,6 +6191,15 @@ static struct ctl_table ipv6_route_table_template[] = {
 		.extra1		=	SYSCTL_ZERO,
 		.extra2		=	SYSCTL_ONE,
 	},
+	{
+		.procname	=	"nexthop_skip_route_notify",
+		.data		=	&init_net.ipv6.sysctl.nexthop_skip_route_notify,
+		.maxlen		=	sizeof(int),
+		.mode		=	0644,
+		.proc_handler	=	proc_dointvec_minmax,
+		.extra1		=	SYSCTL_ZERO,
+		.extra2		=	SYSCTL_ONE,
+	},
 	{ }
 };
 
@@ -6212,6 +6224,7 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 		table[8].data = &net->ipv6.sysctl.ip6_rt_min_advmss;
 		table[9].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
 		table[10].data = &net->ipv6.sysctl.skip_notify_on_dev_down;
+		table[11].data = &net->ipv6.sysctl.nexthop_skip_route_notify;
 
 		/* Don't export sysctls to unprivileged users */
 		if (net->user_ns != &init_user_ns)
@@ -6283,6 +6296,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 	net->ipv6.sysctl.ip6_rt_mtu_expires = 10*60*HZ;
 	net->ipv6.sysctl.ip6_rt_min_advmss = IPV6_MIN_MTU - 20 - 40;
 	net->ipv6.sysctl.skip_notify_on_dev_down = 0;
+	net->ipv6.sysctl.nexthop_skip_route_notify = 0;
 
 	net->ipv6.ip6_rt_gc_expire = 30*HZ;
 
-- 
2.1.4

