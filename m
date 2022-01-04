Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE17F48405A
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiADK7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiADK7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:59:40 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59C6C061761;
        Tue,  4 Jan 2022 02:59:40 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso27312664pje.0;
        Tue, 04 Jan 2022 02:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pl73crA3ZsXWmqBtT+jaLH5Nlk6wAvpXPCITxe/3VfM=;
        b=oegir/7g5A1g0GuNbOlSOU1NL+FVmDpkU2FOIzLzistsa8JsMU1NHBHSPku+Gv74CB
         ui6Ht/9vxhiNTxxFAhI1NaD7P9aOAS5qY0LcrE1reM86O2KaHYX48nvgRFFEcCn44FNq
         Nk07U5FRA9AgXTsUgS4IQkXPXCF8oqAQY+sPwn5y7ZSkNS5SS5PjkACWpExaVLaEcriE
         hQD42QeecY5wd8Qu9nD8SWus2Zce/Kw4Zah7H84yZmKIWc5b/iuHaopMn1opzylOuDkC
         WARsJnXMr1tdkvWXkJT9h9Y5kMg4k4RoOk5f+22SyiCr3JjdhQfeSSPRLdIumNnos3kL
         KFzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pl73crA3ZsXWmqBtT+jaLH5Nlk6wAvpXPCITxe/3VfM=;
        b=4S1Ix9ejqOOYj1FG0TDVK4Z5Tte2f0pj++3QhJwKmJYFkxkUcPjSoWVPTfrVFgLhqg
         uxV8ttwbfBODDP2ypBQSp/Pynd5vGjcq6L8MDz9kF/JXDWHRmZ0Y5p4v58nE2yq6NeuJ
         NwJB2pnPZQROXqLek91dIXzJ3CXw/yGEFGdfqs/8DaRSEEyCGITuaoF73aEVTRkfVOLs
         1iScls82tgLFUmT86oRk/L/v7qY/vkQptfnRorEXKvBP5G0AODhTKR6QhiJrn4tdK1bG
         RQTcwAYgRsifQ+LV1iN6r/e98+p+PL4c2mFio5GFq2/CvHCDjajY2UM8AJCtO0zAIL5u
         19Gw==
X-Gm-Message-State: AOAM533F42NLPuQA4Na65Y16VHWIrKDZOIOantmXPYpmwvicN5lCjcMR
        51UFNRp1AGtA4GsAV9XOa5zr+ZsMbHs=
X-Google-Smtp-Source: ABdhPJxziaFPjzO9AAw1SsbIg9w1KU36xR0t7EfnvMkWBNDnVb+yG27J2CuCPqrf7AJ+ahGKUsQS8g==
X-Received: by 2002:a17:903:2055:b0:149:b473:8b95 with SMTP id q21-20020a170903205500b00149b4738b95mr13374358pla.172.1641293980339;
        Tue, 04 Jan 2022 02:59:40 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s192sm35345187pgc.7.2022.01.04.02.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 02:59:40 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     xu.xin16@zte.com.cn, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Namespaceify min_pmtu sysctl
Date:   Tue,  4 Jan 2022 10:59:34 +0000
Message-Id: <20220104105934.601526-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104105739.601448-1-xu.xin16@zte.com.cn>
References: <20220104105739.601448-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

This patch enables the sysctl min_pmtu to be configured per net
namespace.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 include/net/netns/ipv4.h |  2 ++
 net/ipv4/route.c         | 53 ++++++++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 6c5b2efc4f17..1ecbf82b07f1 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -85,6 +85,8 @@ struct netns_ipv4 {
 	int sysctl_icmp_ratelimit;
 	int sysctl_icmp_ratemask;
 
+	u32 ip_rt_min_pmtu;
+
 	struct local_ports ip_local_ports;
 
 	u8 sysctl_tcp_ecn;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 843a7a3699fe..f29637e85c05 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -110,6 +110,8 @@
 
 #define RT_GC_TIMEOUT (300*HZ)
 
+#define DEFAULT_MIN_PMTU (512 + 20 + 20)
+
 static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
@@ -117,7 +119,6 @@ static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
 static int ip_rt_error_cost __read_mostly	= HZ;
 static int ip_rt_error_burst __read_mostly	= 5 * HZ;
 static int ip_rt_mtu_expires __read_mostly	= 10 * 60 * HZ;
-static u32 ip_rt_min_pmtu __read_mostly		= 512 + 20 + 20;
 static int ip_rt_min_advmss __read_mostly	= 256;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
@@ -1018,9 +1019,9 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 	if (old_mtu < mtu)
 		return;
 
-	if (mtu < ip_rt_min_pmtu) {
+	if (mtu < net->ipv4.ip_rt_min_pmtu) {
 		lock = true;
-		mtu = min(old_mtu, ip_rt_min_pmtu);
+		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
 	}
 
 	if (rt->rt_pmtu == mtu && !lock &&
@@ -3541,14 +3542,6 @@ static struct ctl_table ipv4_route_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	{
-		.procname	= "min_pmtu",
-		.data		= &ip_rt_min_pmtu,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &ip_min_valid_pmtu,
-	},
 	{
 		.procname	= "min_adv_mss",
 		.data		= &ip_rt_min_advmss,
@@ -3561,13 +3554,21 @@ static struct ctl_table ipv4_route_table[] = {
 
 static const char ipv4_route_flush_procname[] = "flush";
 
-static struct ctl_table ipv4_route_flush_table[] = {
+static struct ctl_table ipv4_route_netns_table[] = {
 	{
 		.procname	= ipv4_route_flush_procname,
 		.maxlen		= sizeof(int),
 		.mode		= 0200,
 		.proc_handler	= ipv4_sysctl_rtcache_flush,
 	},
+	{
+		.procname       = "min_pmtu",
+		.data           = &init_net.ipv4.ip_rt_min_pmtu,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = &ip_min_valid_pmtu,
+	},
 	{ },
 };
 
@@ -3575,9 +3576,11 @@ static __net_init int sysctl_route_net_init(struct net *net)
 {
 	struct ctl_table *tbl;
 
-	tbl = ipv4_route_flush_table;
+	tbl = ipv4_route_netns_table;
 	if (!net_eq(net, &init_net)) {
-		tbl = kmemdup(tbl, sizeof(ipv4_route_flush_table), GFP_KERNEL);
+		int i;
+
+		tbl = kmemdup(tbl, sizeof(ipv4_route_netns_table), GFP_KERNEL);
 		if (!tbl)
 			goto err_dup;
 
@@ -3586,6 +3589,12 @@ static __net_init int sysctl_route_net_init(struct net *net)
 			if (tbl[0].procname != ipv4_route_flush_procname)
 				tbl[0].procname = NULL;
 		}
+
+		/* Update the variables to point into the current struct net
+		 * except for the first element flush
+		 */
+		for (i = 1; i < ARRAY_SIZE(ipv4_route_netns_table) - 1; i++)
+			tbl[i].data += (void *)net - (void *)&init_net;
 	}
 	tbl[0].extra1 = net;
 
@@ -3595,7 +3604,7 @@ static __net_init int sysctl_route_net_init(struct net *net)
 	return 0;
 
 err_reg:
-	if (tbl != ipv4_route_flush_table)
+	if (tbl != ipv4_route_netns_table)
 		kfree(tbl);
 err_dup:
 	return -ENOMEM;
@@ -3607,7 +3616,7 @@ static __net_exit void sysctl_route_net_exit(struct net *net)
 
 	tbl = net->ipv4.route_hdr->ctl_table_arg;
 	unregister_net_sysctl_table(net->ipv4.route_hdr);
-	BUG_ON(tbl == ipv4_route_flush_table);
+	BUG_ON(tbl == ipv4_route_netns_table);
 	kfree(tbl);
 }
 
@@ -3617,6 +3626,17 @@ static __net_initdata struct pernet_operations sysctl_route_ops = {
 };
 #endif
 
+static __net_init int netns_ip_rt_init(struct net *net)
+{
+	/* Set default value for namespaceified sysctls */
+	net->ipv4.ip_rt_min_pmtu = DEFAULT_MIN_PMTU;
+	return 0;
+}
+
+static struct pernet_operations __net_initdata ip_rt_ops = {
+	.init = netns_ip_rt_init,
+};
+
 static __net_init int rt_genid_init(struct net *net)
 {
 	atomic_set(&net->ipv4.rt_genid, 0);
@@ -3722,6 +3742,7 @@ int __init ip_rt_init(void)
 #ifdef CONFIG_SYSCTL
 	register_pernet_subsys(&sysctl_route_ops);
 #endif
+	register_pernet_subsys(&ip_rt_ops);
 	register_pernet_subsys(&rt_genid_ops);
 	register_pernet_subsys(&ipv4_inetpeer_ops);
 	return 0;
-- 
2.25.1

