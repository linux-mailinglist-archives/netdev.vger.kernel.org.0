Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B753F0C72
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 22:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhHRUKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 16:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhHRUKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 16:10:36 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD16C061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 13:10:01 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id p22so4460802qki.10
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 13:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i0TtOFF7aBxgjC5dg+o9iwofV4wL+vTk4g/CyzgUVhg=;
        b=n95uPS756cgjVj5FCpnP2HxVTrZPlFxMDbX0ek71VbPANHOhan4wQ8HZ6VbLCEUchX
         QhlorR1jvcNymKzchUyfrv2lF/b68wKNtinvhTxKPqVf1C+0vvWyv8i1Pu2W3grgvTTF
         fXGTOmCAMhi2qy/SUotoJXU62JnrNAFd0oSVufyAKxjGEd6XEcgF+oB448CW6IXH2etA
         VilhVW9XXRSQPZJDXo0JRsxtQ6ASlvxcTiflUhgGT9KnGFO1yNQsRGyhtbJBehNqY1Xv
         dapJICnFsgaP6qF34smrVYM6G3Lt0LlZDQqab32J6K4CcKdvlPHc9B7xaBWv/CPYSqzH
         cg7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i0TtOFF7aBxgjC5dg+o9iwofV4wL+vTk4g/CyzgUVhg=;
        b=RUbCuoeNrkkWq2OznE1RK6SA+tEmAS1vWkQvb66eS75Ea7XNKq4BXwh+NOs/1/i0Oj
         FngS9WIrlJRMiYWbrUkQgV5bh+jO/D0B5N8za52j47fZwVyP5Jlj7q3nJSslB0TN6j23
         f3Mo6Y1t04MNY0EScDvjGoCHV534EsTkGW7o423+0fjYr9WPCSHBH7j7Eqyhd2LG3V5D
         XJoqGd3roBsRsjxmmIfkAo+eB+LHGo5OGnQcBA27TlBZxej7L7xOgqY4Fs+NDmW99pft
         UexfqDIQ2P3s3oq+oNdZVmk3fz5avPjm203SEgvNLgYtij+Ccr9tBq5N5p+6qloEcHPR
         MTfQ==
X-Gm-Message-State: AOAM531YXfsEbz/1LeAQ9tTjU4Fp6JrXXL5e2bMWqsdgC8hjYQUlCxvM
        IpcnW6nEEPxSN3zMymaTOil9QxzRdg==
X-Google-Smtp-Source: ABdhPJxYMBpzitDX/h/c+1jx83h51KW1BWaIA7rkNmdkw5is0LPaxRP1mRAFzCLJSclOrc3VZYv/Ug==
X-Received: by 2002:a05:620a:14b6:: with SMTP id x22mr11741qkj.321.1629317400460;
        Wed, 18 Aug 2021 13:10:00 -0700 (PDT)
Received: from ssuryadesk.lan ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id 207sm450419qkj.29.2021.08.18.13.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 13:10:00 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next] ipmr: ip6mr: Add ability to display non default caches and vifs
Date:   Wed, 18 Aug 2021 16:09:51 -0400
Message-Id: <20210818200951.7621-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With multiple mroute tables it seems that there should be a way to
display caches and vifs for the non-default table. Add two sysctls to
control what to display. The default values for the sysctls are
RT_TABLE_DEFAULT (253) and RT6_TABLE_DFLT (254).

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 14 ++++++++++++++
 include/net/netns/ipv4.h               |  3 +++
 include/net/netns/ipv6.h               |  3 +++
 net/ipv4/af_inet.c                     |  3 +++
 net/ipv4/ipmr.c                        | 14 ++++++++++++--
 net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
 net/ipv6/ip6mr.c                       | 14 ++++++++++++--
 net/ipv6/route.c                       |  3 +++
 net/ipv6/sysctl_net_ipv6.c             |  9 +++++++++
 9 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index d91ab28718d4..de47563514f0 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1382,6 +1382,13 @@ mc_forwarding - BOOLEAN
 	conf/all/mc_forwarding must also be set to TRUE to enable multicast
 	routing	for the interface
 
+ip_mr_table_id - UNSIGNED INTEGER
+	Only valid for kernels built with CONFIG_IP_MROUTE_MULTIPLE_TABLES and
+	CONFIG_PROC_FS enabled. It is used to set the multicast routing table id
+	to display in /proc/net/ip_mr_cache and /proc/net/ip_mr_vif
+
+	Default: 253 (RT_TABLE_DEFAULT)
+
 medium_id - INTEGER
 	Integer value used to differentiate the devices by the medium they
 	are attached to. Two devices can have different id values when
@@ -2192,6 +2199,13 @@ mtu - INTEGER
 
 	Default: 1280 (IPv6 required minimum)
 
+ip6_mr_table_id - UNSIGNED INTEGER
+	Only valid for kernels built with CONFIG_IPV6_MROUTE_MULTIPLE_TABLES and
+	CONFIG_PROC_FS enabled. It is used to set the multicast routing table id
+	to display in /proc/net/ip6_mr_cache and /proc/net/ip6_mr_vif
+
+	Default: 254 (RT6_TABLE_DFLT)
+
 ip_nonlocal_bind - BOOLEAN
 	If set, allows processes to bind() to non-local IPv6 addresses,
 	which can be quite useful - but may break some applications.
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 2f65701a43c9..1c5c6bbdda1e 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -207,6 +207,9 @@ struct netns_ipv4 {
 #else
 	struct list_head	mr_tables;
 	struct fib_rules_ops	*mr_rules_ops;
+#ifdef CONFIG_PROC_FS
+	u32 sysctl_ip_mr_table_id;
+#endif
 #endif
 #endif
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index a4b550380316..f1b9fa46ca2c 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -99,6 +99,9 @@ struct netns_ipv6 {
 #else
 	struct list_head	mr6_tables;
 	struct fib_rules_ops	*mr6_rules_ops;
+#ifdef CONFIG_PROC_FS
+	u32 sysctl_ip6_mr_table_id;
+#endif
 #endif
 #endif
 	atomic_t		dev_addr_genid;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 0e4d758c2585..2769ea08c519 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1870,6 +1870,9 @@ static __net_init int inet_init_net(struct net *net)
 
 	net->ipv4.sysctl_fib_notify_on_flag_change = 0;
 
+#if defined(CONFIG_IP_MROUTE_MULTIPLE_TABLES) && defined(CONFIG_PROC_FS)
+	net->ipv4.sysctl_ip_mr_table_id = RT_TABLE_DEFAULT;
+#endif
 	return 0;
 }
 
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2dda856ca260..8a955b6853c6 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2896,8 +2896,13 @@ static void *ipmr_vif_seq_start(struct seq_file *seq, loff_t *pos)
 	struct mr_vif_iter *iter = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct mr_table *mrt;
+#ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
+	u32 mr_table_id = net->ipv4.sysctl_ip_mr_table_id;
+#else
+	u32 mr_table_id = RT_TABLE_DEFAULT;
+#endif
 
-	mrt = ipmr_get_table(net, RT_TABLE_DEFAULT);
+	mrt = ipmr_get_table(net, mr_table_id);
 	if (!mrt)
 		return ERR_PTR(-ENOENT);
 
@@ -2947,8 +2952,13 @@ static void *ipmr_mfc_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct net *net = seq_file_net(seq);
 	struct mr_table *mrt;
+#ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
+	u32 mr_table_id = net->ipv4.sysctl_ip_mr_table_id;
+#else
+	u32 mr_table_id = RT_TABLE_DEFAULT;
+#endif
 
-	mrt = ipmr_get_table(net, RT_TABLE_DEFAULT);
+	mrt = ipmr_get_table(net, mr_table_id);
 	if (!mrt)
 		return ERR_PTR(-ENOENT);
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 6f1e64d49232..f2133a4aab86 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1406,6 +1406,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
+#if defined(CONFIG_IP_MROUTE_MULTIPLE_TABLES) && defined(CONFIG_PROC_FS)
+	{
+		.procname	= "ip_mr_table_id",
+		.data		= &init_net.ipv4.sysctl_ip_mr_table_id,
+		.maxlen		= sizeof(init_net.ipv4.sysctl_ip_mr_table_id),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec,
+	},
+#endif
 	{ }
 };
 
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 36ed9efb8825..56df543e298d 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -408,8 +408,13 @@ static void *ip6mr_vif_seq_start(struct seq_file *seq, loff_t *pos)
 	struct mr_vif_iter *iter = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct mr_table *mrt;
+#ifdef CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
+	u32 mr_table_id = net->ipv6.sysctl_ip6_mr_table_id;
+#else
+	u32 mr_table_id = RT6_TABLE_DFLT;
+#endif
 
-	mrt = ip6mr_get_table(net, RT6_TABLE_DFLT);
+	mrt = ip6mr_get_table(net, mr_table_id);
 	if (!mrt)
 		return ERR_PTR(-ENOENT);
 
@@ -458,8 +463,13 @@ static void *ipmr_mfc_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct net *net = seq_file_net(seq);
 	struct mr_table *mrt;
+#ifdef CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
+	u32 mr_table_id = net->ipv6.sysctl_ip6_mr_table_id;
+#else
+	u32 mr_table_id = RT6_TABLE_DFLT;
+#endif
 
-	mrt = ip6mr_get_table(net, RT6_TABLE_DFLT);
+	mrt = ip6mr_get_table(net, mr_table_id);
 	if (!mrt)
 		return ERR_PTR(-ENOENT);
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 6cf4bb89ca69..5c91546abc26 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6470,6 +6470,9 @@ static int __net_init ip6_route_net_init(struct net *net)
 
 	net->ipv6.ip6_rt_gc_expire = 30*HZ;
 
+#if defined(CONFIG_IPV6_MROUTE_MULTIPLE_TABLES) && defined(CONFIG_PROC_FS)
+	net->ipv6.sysctl_ip6_mr_table_id = RT6_TABLE_DFLT;
+#endif
 	ret = 0;
 out:
 	return ret;
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index d53dd142bf87..053314dbbfff 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -215,6 +215,15 @@ static struct ctl_table ipv6_table_template[] = {
 		.proc_handler	= proc_doulongvec_minmax,
 		.extra2		= &ioam6_id_wide_max,
 	},
+#if defined(CONFIG_IPV6_MROUTE_MULTIPLE_TABLES) && defined(CONFIG_PROC_FS)
+	{
+		.procname	= "ip6_mr_table_id",
+		.data		= &init_net.ipv6.sysctl_ip6_mr_table_id,
+		.maxlen		= sizeof(init_net.ipv6.sysctl_ip6_mr_table_id),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec,
+	},
+#endif
 	{ }
 };
 
-- 
2.25.1

