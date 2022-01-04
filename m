Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454DF48405C
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbiADK7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiADK7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:59:53 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32F1C061761;
        Tue,  4 Jan 2022 02:59:52 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id c3so13620393pls.5;
        Tue, 04 Jan 2022 02:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SYgfRIUfQDZ+bh3ZuPW/HiWBpPn3Xszv0t3cGorUnEk=;
        b=HvA2c190ATAkg7L1rHa3z9ucmwU1QMkCCDhM6QKjf1r+yqF76jn+Hpfcx1tkPC1Rrx
         qU28BtUAffyjYEF4MX7VJfjpsyVDFI3LA95kwbbEqS9PafeRPb60IBBXRjabUH9is135
         sUpetKSjSJD2dZYEDF+tnuYbv5qa8Jhgb40/LXBnnwEv0f/PvaPLf+t2x3WXNd90OU6j
         oUNkdL4nNIfhOviIQg2R7uDlKncG9KRS+rmz5mSrA6YXK+W3wTlVs2hqU5Nsen2PeiRs
         GppJerysFu/IrkqMdjkLSaEiUN4SjEB1nKQItLFMXVQSQgS/fFrExdwo/RDZ0TMRZE/O
         Tw6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SYgfRIUfQDZ+bh3ZuPW/HiWBpPn3Xszv0t3cGorUnEk=;
        b=Ah47ualIJMMhcwHqUVtaRisjYPHSJLBG0eae7A1kmniRucgc/XiPAxBVO9qLX/Fjq/
         z7A0ZzbARYgEQhuzrt6OrC4ZhG5pp/YAUQjD+4mpMxoM8p0BiCXXOJ0u9TL9IontlU59
         0VeCCgN88Q9hFT6Fcw4tvkAW3LhgAiX8idDw7g9Q7FSW0lqm3sFUAs0yL1UiigfTMRQ0
         t6IJ5tOjl0k862QNaRcn9kVjCSQUFqSsrLUuU3eCBA1J9t9WZ9mXKBMAO/YwQLgZEN6s
         ct2BFXKW2nn+3jUhxOTHxEJ+SmXfzsIpyFpF0gJ0INfg4WJlt1C4mYHUPtCNFpbnh9TS
         mhhw==
X-Gm-Message-State: AOAM530vT/Wsn0dwEZX8wL+TmR75ID+CXrwgGa3C2kzqBudgEBTRQXxV
        vEEwVyWn+f5U15v7RNgZPcY4P1Z/t/k=
X-Google-Smtp-Source: ABdhPJxT0lOIebRvFiruLUJVoNf0nUlDv53hY4VPLSc2dzbdMOTKoqZ+AZ6+7PxzBaPlC5Mo8QcZlg==
X-Received: by 2002:a17:902:6a82:b0:148:a2e7:fb5c with SMTP id n2-20020a1709026a8200b00148a2e7fb5cmr49132744plk.157.1641293992330;
        Tue, 04 Jan 2022 02:59:52 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h26sm7635701pfn.213.2022.01.04.02.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 02:59:52 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     xu.xin16@zte.com.cn, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Namespaceify mtu_expires sysctl
Date:   Tue,  4 Jan 2022 10:59:47 +0000
Message-Id: <20220104105947.601583-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104105739.601448-1-xu.xin16@zte.com.cn>
References: <20220104105739.601448-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

This patch enables the sysctl mtu_expires to be configured per net
namespace.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>

---
 include/net/netns/ipv4.h |  1 +
 net/ipv4/route.c         | 21 +++++++++++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 1ecbf82b07f1..78557643526e 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -86,6 +86,7 @@ struct netns_ipv4 {
 	int sysctl_icmp_ratemask;
 
 	u32 ip_rt_min_pmtu;
+	int ip_rt_mtu_expires;
 
 	struct local_ports ip_local_ports;
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f29637e85c05..ff6f91cdb6c4 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -111,6 +111,7 @@
 #define RT_GC_TIMEOUT (300*HZ)
 
 #define DEFAULT_MIN_PMTU (512 + 20 + 20)
+#define DEFAULT_MTU_EXPIRES (10 * 60 * HZ)
 
 static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
@@ -118,7 +119,6 @@ static int ip_rt_redirect_load __read_mostly	= HZ / 50;
 static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
 static int ip_rt_error_cost __read_mostly	= HZ;
 static int ip_rt_error_burst __read_mostly	= 5 * HZ;
-static int ip_rt_mtu_expires __read_mostly	= 10 * 60 * HZ;
 static int ip_rt_min_advmss __read_mostly	= 256;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
@@ -1025,7 +1025,7 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 	}
 
 	if (rt->rt_pmtu == mtu && !lock &&
-	    time_before(jiffies, dst->expires - ip_rt_mtu_expires / 2))
+	    time_before(jiffies, dst->expires - net->ipv4.ip_rt_mtu_expires / 2))
 		return;
 
 	rcu_read_lock();
@@ -1035,7 +1035,7 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 		fib_select_path(net, &res, fl4, NULL);
 		nhc = FIB_RES_NHC(res);
 		update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
-				      jiffies + ip_rt_mtu_expires);
+				      jiffies + net->ipv4.ip_rt_mtu_expires);
 	}
 	rcu_read_unlock();
 }
@@ -3535,13 +3535,6 @@ static struct ctl_table ipv4_route_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
-		.procname	= "mtu_expires",
-		.data		= &ip_rt_mtu_expires,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
 	{
 		.procname	= "min_adv_mss",
 		.data		= &ip_rt_min_advmss,
@@ -3569,6 +3562,13 @@ static struct ctl_table ipv4_route_netns_table[] = {
 		.proc_handler   = proc_dointvec_minmax,
 		.extra1         = &ip_min_valid_pmtu,
 	},
+	{
+		.procname       = "mtu_expires",
+		.data           = &init_net.ipv4.ip_rt_mtu_expires,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_jiffies,
+	},
 	{ },
 };
 
@@ -3630,6 +3630,7 @@ static __net_init int netns_ip_rt_init(struct net *net)
 {
 	/* Set default value for namespaceified sysctls */
 	net->ipv4.ip_rt_min_pmtu = DEFAULT_MIN_PMTU;
+	net->ipv4.ip_rt_mtu_expires = DEFAULT_MTU_EXPIRES;
 	return 0;
 }
 
-- 
2.25.1

