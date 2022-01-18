Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0754925D4
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbiARMlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 07:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbiARMlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 07:41:07 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0B2C061574;
        Tue, 18 Jan 2022 04:41:07 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id a21so8011212qkn.0;
        Tue, 18 Jan 2022 04:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aTab+jiF9JQUXlYtyRf6lOH1unQ6BdWfkpXxrhfccsg=;
        b=ZZ2u0eGtx7FdFPCguOedcfsxwA/XpXnDtj3SPvzlfVHtndhQqLVstpuluFoJGcFWgn
         dw4k8OHceOdWT+KerVi2A/l1jmi0s+9w8B0sfIOmuB7qVshLHpjP5C9Pq8+JyqXpO5Qh
         SDun3PUBAVV4t1TNVrgRGnzJIGH76f+acAl8az6+I8ZKaAqW5GG1FVOyWRfsO1MAL3kG
         ZQ9As5QwGBXk5OdZMhYrDb+1nNhnjAj2QL+wVTcKS/ah16rK1viF4bgbGu1BvSyl+7S9
         m6mfB0q8DSJaeouCog1nAReM1h8JciOU47lwpualO3unxceYLbLrMzwCA4Shc0Ff/kDz
         sOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aTab+jiF9JQUXlYtyRf6lOH1unQ6BdWfkpXxrhfccsg=;
        b=SM3ikcsmwaMGDUfQ06JOpjtGVe0V/SBxHbugYJvBbYwyaJRWcquU3hQRrsn3LBTu7L
         d0Wqat7wFtwExP8Qr09KEMsZYO/js7gwJXPm/QOuhzI6vASX38A0qwWxxjCBoettmgcl
         6KfQVgGZuvZjcD4Od+oS0AmzRHVkc0ciSEJQ76XzlwpoRKwUO2l9Tggw0h8DxtTTkWgK
         yvhJOQHWpoZkhLN2d4RSOKQNIyJ5jAk3feiuFVujCIVsMx6urjQFNVG9cvSXkZvgicnx
         XTUTIt87FuM1EV3lFU0wnuM8DS9mm60KYJ6G0JP3scfBie1sk2dJ64aTs/dq+yjwvizg
         RI1A==
X-Gm-Message-State: AOAM532+3u//K80qJ5g5wdHfCqHkS8eXGJYS/eWsqQ8SDFOTUoyOi5Nz
        XasYwT1RPdYSHGTd0wbrtmM=
X-Google-Smtp-Source: ABdhPJy++U5VH5STgYpoQJOwqGjdqIs/SsFw7B2OwDvzHU2g83Zm2MdVWULY2wv41UhffR87JX5HOg==
X-Received: by 2002:ae9:dc07:: with SMTP id q7mr11457411qkf.63.1642509666215;
        Tue, 18 Jan 2022 04:41:06 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id o6sm9801510qtk.50.2022.01.18.04.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 04:41:05 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, yoshfuji@linux-ipv6.org, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu xin <xu.xin16@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] ipv4: Namespaceify min_adv_mss sysctl knob
Date:   Tue, 18 Jan 2022 12:40:55 +0000
Message-Id: <20220118124055.927605-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

Different netns have different requirement on the setting of min_adv_mss
sysctl that the advertised MSS will be never lower than. The sysctl
min_adv_mss can indirectly affects the segmentation efficiency of TCP.

So enable min_adv_mss to be visible and configurable inside the netns.

Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 include/net/netns/ipv4.h |  1 +
 net/ipv4/route.c         | 21 +++++++++++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 7855764..8fea3cb 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -87,6 +87,7 @@ struct netns_ipv4 {
 
 	u32 ip_rt_min_pmtu;
 	int ip_rt_mtu_expires;
+	int ip_rt_min_advmss;
 
 	struct local_ports ip_local_ports;
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index ff6f91c..e42e283 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -112,14 +112,13 @@
 
 #define DEFAULT_MIN_PMTU (512 + 20 + 20)
 #define DEFAULT_MTU_EXPIRES (10 * 60 * HZ)
-
+#define DEFAULT_MIN_ADVMSS 256
 static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
 static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
 static int ip_rt_error_cost __read_mostly	= HZ;
 static int ip_rt_error_burst __read_mostly	= 5 * HZ;
-static int ip_rt_min_advmss __read_mostly	= 256;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
 
@@ -1298,9 +1297,10 @@ static void set_class_tag(struct rtable *rt, u32 tag)
 
 static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 {
+	struct net *net = dev_net(dst->dev);
 	unsigned int header_size = sizeof(struct tcphdr) + sizeof(struct iphdr);
 	unsigned int advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
-				    ip_rt_min_advmss);
+				    net->ipv4.ip_rt_min_advmss);
 
 	return min(advmss, IPV4_MAX_PMTU - header_size);
 }
@@ -3535,13 +3535,6 @@ static struct ctl_table ipv4_route_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
-		.procname	= "min_adv_mss",
-		.data		= &ip_rt_min_advmss,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
 	{ }
 };
 
@@ -3569,6 +3562,13 @@ static struct ctl_table ipv4_route_netns_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
+	{
+		.procname   = "min_adv_mss",
+		.data       = &init_net.ipv4.ip_rt_min_advmss,
+		.maxlen     = sizeof(int),
+		.mode       = 0644,
+		.proc_handler   = proc_dointvec,
+	},
 	{ },
 };
 
@@ -3631,6 +3631,7 @@ static __net_init int netns_ip_rt_init(struct net *net)
 	/* Set default value for namespaceified sysctls */
 	net->ipv4.ip_rt_min_pmtu = DEFAULT_MIN_PMTU;
 	net->ipv4.ip_rt_mtu_expires = DEFAULT_MTU_EXPIRES;
+	net->ipv4.ip_rt_min_advmss = DEFAULT_MIN_ADVMSS;
 	return 0;
 }
 
-- 
2.15.2

