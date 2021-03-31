Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6FC3505D7
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhCaRxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbhCaRw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:52:29 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0E2C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:28 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o2so8292948plg.1
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y2RxIdxDZ1xmeocPl/Q5cWxZLlyOTTwyKQrmeMR1ZsU=;
        b=B/TM8kmBYMt+t5sqjZUM5xZNCuhdGpMB/JqS4P2iEY5YZqOXRL0HHpGGo/JXVN7P7y
         gATFDHZWUAa5VAWgh+xA4Zitf4Cb1IC8g/Kh1ClKfj1H+3iA+TPtuIlyXQj8K2DbFuD1
         /Q+iUZCG/xf6LPHjRI4BVkP3XC9P0Dgdn6Us+c3OmWk2MGYSLUDAla6nrqbRy+J3smWZ
         qUARb/1Oo8dPwiesDpKLqppZpsAvQUd2NX96OlIOtz7Ca0zkTj62k5YDtxm862qSwkRm
         su+rWXvh4p8R9VBUD45OiAjETiIOeBEk5DhNeLYpzuVxjIX/+Qum9MzBPUwU/5MDOcLe
         rRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y2RxIdxDZ1xmeocPl/Q5cWxZLlyOTTwyKQrmeMR1ZsU=;
        b=Og9+RBrUh93NxV2W8f2jZV+JuxdviEsGUVk5aoxdtptnuG7iH33c4woAO60wnymEJO
         U9FrkJ7mnHmhUgf11MLXY/QLZYdCRdypyxu7MQ2eo2O98Z+9w0MM76YmGCdrAimQDXKl
         Ac9PIMZPMgg7y6z4ljNnyRhnFdlZrFhYTIWmkTE7LJ8kq5MqYQv0JsTqKNxU6miUKg6H
         WKFNppWPNLwflq2ubLODCebrnrPnuCzm95PwTIWwyEyUV6cyhhXxhfavG3iBxLxblUzU
         3L0g+EvxkJ+Fpt0FHgCSQ1fjfkwDXdCfLdXaq/GZKn6LAf//Nkapf98eGt9nwD6vBl0g
         I+2A==
X-Gm-Message-State: AOAM533uRzdKApbq4QOMf7eJD9WJXgcarJk5n4NraCOf6GANjbXB4Mpz
        Zcrl+2vrjFSYmXc/bItRgGE4s5SW1zA=
X-Google-Smtp-Source: ABdhPJwFDk3D15Z/xECXiZjh+rerRnQd4UmkHszxZA/MebJcsBU2FDt4rQWoYQny8/d1xFIPmBoMpQ==
X-Received: by 2002:a17:90b:244:: with SMTP id fz4mr4514424pjb.137.1617213148511;
        Wed, 31 Mar 2021 10:52:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id q17sm3319028pfq.171.2021.03.31.10.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:52:28 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 8/9] ipv6: convert elligible sysctls to u8
Date:   Wed, 31 Mar 2021 10:52:12 -0700
Message-Id: <20210331175213.691460-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210331175213.691460-1-eric.dumazet@gmail.com>
References: <20210331175213.691460-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Convert most sysctls that can fit in a byte.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv6.h   | 24 ++++++++++++------------
 net/ipv6/icmp.c            | 12 ++++++------
 net/ipv6/sysctl_net_ipv6.c | 38 ++++++++++++++++++--------------------
 3 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 21c0debbd39ee34fb029746b0920961747dc41fa..84f4a8bec397dc5a15d84fae118cda33d87671bb 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -20,7 +20,6 @@ struct netns_sysctl_ipv6 {
 	struct ctl_table_header *frags_hdr;
 	struct ctl_table_header *xfrm6_hdr;
 #endif
-	int bindv6only;
 	int flush_delay;
 	int ip6_rt_max_size;
 	int ip6_rt_gc_min_interval;
@@ -29,21 +28,22 @@ struct netns_sysctl_ipv6 {
 	int ip6_rt_gc_elasticity;
 	int ip6_rt_mtu_expires;
 	int ip6_rt_min_advmss;
-	int multipath_hash_policy;
-	int flowlabel_consistency;
-	int auto_flowlabels;
+	u8 bindv6only;
+	u8 multipath_hash_policy;
+	u8 flowlabel_consistency;
+	u8 auto_flowlabels;
 	int icmpv6_time;
-	int icmpv6_echo_ignore_all;
-	int icmpv6_echo_ignore_multicast;
-	int icmpv6_echo_ignore_anycast;
+	u8 icmpv6_echo_ignore_all;
+	u8 icmpv6_echo_ignore_multicast;
+	u8 icmpv6_echo_ignore_anycast;
 	DECLARE_BITMAP(icmpv6_ratemask, ICMPV6_MSG_MAX + 1);
 	unsigned long *icmpv6_ratemask_ptr;
-	int anycast_src_echo_reply;
-	int ip_nonlocal_bind;
-	int fwmark_reflect;
+	u8 anycast_src_echo_reply;
+	u8 ip_nonlocal_bind;
+	u8 fwmark_reflect;
+	u8 flowlabel_state_ranges;
 	int idgen_retries;
 	int idgen_delay;
-	int flowlabel_state_ranges;
 	int flowlabel_reflect;
 	int max_dst_opts_cnt;
 	int max_hbh_opts_cnt;
@@ -51,7 +51,7 @@ struct netns_sysctl_ipv6 {
 	int max_hbh_opts_len;
 	int seg6_flowlabel;
 	bool skip_notify_on_dev_down;
-	int fib_notify_on_flag_change;
+	u8 fib_notify_on_flag_change;
 };
 
 struct netns_ipv6 {
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 29d38d6b55fb3c6587d3813c606c3813d789ad62..1bca2b09d77e64e4dd6177afe4765c53d3b18c05 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -1169,23 +1169,23 @@ static struct ctl_table ipv6_icmp_table_template[] = {
 	{
 		.procname	= "echo_ignore_all",
 		.data		= &init_net.ipv6.sysctl.icmpv6_echo_ignore_all,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler = proc_dointvec,
+		.proc_handler = proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "echo_ignore_multicast",
 		.data		= &init_net.ipv6.sysctl.icmpv6_echo_ignore_multicast,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler = proc_dointvec,
+		.proc_handler = proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "echo_ignore_anycast",
 		.data		= &init_net.ipv6.sysctl.icmpv6_echo_ignore_anycast,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler = proc_dointvec,
+		.proc_handler = proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ratemask",
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 263ab43ed06bc964431235df8ff524ce74be5922..27102c3d6e1da00c194b43259d6db5b38234833a 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -23,7 +23,6 @@
 
 static int two = 2;
 static int flowlabel_reflect_max = 0x7;
-static int auto_flowlabels_min;
 static int auto_flowlabels_max = IP6_AUTO_FLOW_LABEL_MAX;
 
 static int proc_rt6_multipath_hash_policy(struct ctl_table *table, int write,
@@ -34,7 +33,7 @@ static int proc_rt6_multipath_hash_policy(struct ctl_table *table, int write,
 
 	net = container_of(table->data, struct net,
 			   ipv6.sysctl.multipath_hash_policy);
-	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
 	if (write && ret == 0)
 		call_netevent_notifiers(NETEVENT_IPV6_MPATH_HASH_UPDATE, net);
 
@@ -45,39 +44,38 @@ static struct ctl_table ipv6_table_template[] = {
 	{
 		.procname	= "bindv6only",
 		.data		= &init_net.ipv6.sysctl.bindv6only,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "anycast_src_echo_reply",
 		.data		= &init_net.ipv6.sysctl.anycast_src_echo_reply,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "flowlabel_consistency",
 		.data		= &init_net.ipv6.sysctl.flowlabel_consistency,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "auto_flowlabels",
 		.data		= &init_net.ipv6.sysctl.auto_flowlabels,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &auto_flowlabels_min,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra2		= &auto_flowlabels_max
 	},
 	{
 		.procname	= "fwmark_reflect",
 		.data		= &init_net.ipv6.sysctl.fwmark_reflect,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "idgen_retries",
@@ -96,16 +94,16 @@ static struct ctl_table ipv6_table_template[] = {
 	{
 		.procname	= "flowlabel_state_ranges",
 		.data		= &init_net.ipv6.sysctl.flowlabel_state_ranges,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_nonlocal_bind",
 		.data		= &init_net.ipv6.sysctl.ip_nonlocal_bind,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "flowlabel_reflect",
@@ -147,7 +145,7 @@ static struct ctl_table ipv6_table_template[] = {
 	{
 		.procname	= "fib_multipath_hash_policy",
 		.data		= &init_net.ipv6.sysctl.multipath_hash_policy,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler   = proc_rt6_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
@@ -163,9 +161,9 @@ static struct ctl_table ipv6_table_template[] = {
 	{
 		.procname	= "fib_notify_on_flag_change",
 		.data		= &init_net.ipv6.sysctl.fib_notify_on_flag_change,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = &two,
 	},
-- 
2.31.0.291.g576ba9dcdaf-goog

