Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE77459B894
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 06:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbiHVEzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 00:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiHVEzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 00:55:41 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461331F2E8;
        Sun, 21 Aug 2022 21:55:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso10087545pjr.3;
        Sun, 21 Aug 2022 21:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=25P+EZZctT1ISNXeUzI2D6yvaxL/tWdLkOEEqCFAjF8=;
        b=JGqA8xVMWnfpIemQwxIddlq4e9Pa8CEltK3u16KCDRgc39Zw4h/bHyTak5hmvIfwnz
         354rfOw+Y/LuBdm2guGY4G3h8gk++v39FiyMYtOZudDptEw9nz5FR/gDoV7SQAMLHjDJ
         06dWUzEw5oKDAwyjq4ehwOeIAmnDFVjY60bi5gZR4S2bFPfEtWLXrCa20WF6AKQRtuvX
         c/Z01v6s0OR59kkUE9rkGq8AZXgANSA8GBVOwDwQHP/GGmjNn7Owb9cSDFBNWYOCN8MA
         sI9fX357rUzf/lsXrLmGVqthNWNGI2zIdPc2FfjQuc0cyBMN0TIAUIKmplGxfbGVLEqw
         XrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=25P+EZZctT1ISNXeUzI2D6yvaxL/tWdLkOEEqCFAjF8=;
        b=jcN8gI8szl8hvrGECVLs+0MHfF3ejk6axC0NYQ6b83lIJpnZG6WHjX3BBYWXbT6sy5
         vepmUdnjYTSuDTXWq7e7dnb//BypQCyZ/tjaNGS4E70JUcZehjow3QiGvUJBQCz+I3rp
         XoixcbE2oD0l/B09hf1onslWbG+jlOCKfY0CMJ0dpqqzacf6uWQ2kXCDluk6fSHfPu9K
         bNtsV7wWEZHLGNNAkG519A/fDYUcVv0KIuwgX5RKsTTWr3flYOX0GmdyvA/PJzIw16cI
         /zugD4Ow3Ux+35sueYZvUc0P0N/fOy+7l74j1M4WAO2BUAawjFntJV1Rm4NF/1MIbD4v
         Enmg==
X-Gm-Message-State: ACgBeo3CzYx5RImI6LQgoEfS1nogRjtXi7fSJGscQzrQShsBBIln8nDS
        iM2arbw7LyXEhtafPT/TjEU=
X-Google-Smtp-Source: AA6agR45xtz2qiqaZD3i6gbVM30B+4FJLdVTqmdMe+rxXtmlt38mOkeWzXVMqnXDkhrrF9260ES0tA==
X-Received: by 2002:a17:902:efd1:b0:172:d671:4db4 with SMTP id ja17-20020a170902efd100b00172d6714db4mr8420556plb.57.1661144139770;
        Sun, 21 Aug 2022 21:55:39 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a1-20020a170902ecc100b00172f0184b54sm621938plh.156.2022.08.21.21.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 21:55:39 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn,
        Yunkai Zhang <zhang.yunkai@zte.com.cn>,
        CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH 2/3] ipv4: Namespaceify route/error_burst knob
Date:   Mon, 22 Aug 2022 04:55:34 +0000
Message-Id: <20220822045534.203765-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822045310.203649-1-xu.xin16@zte.com.cn>
References: <20220822045310.203649-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

Different netns has different requirement on the setting of error_burst
sysctl which is used to limit the frequency of sending ICMP_DEST_UNREACH
packet together with error_cost. To put it simply, if the rate of
error_burst over error_cost is larger, then allowd burstly-sent
ICMP_DEST_UNREACH packets after a long calm time (no dest-unreachable
icmp packets) is more.

Enable error_burst to be configured per network namespace.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 include/net/netns/ipv4.h |  1 +
 net/ipv4/route.c         | 24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 319395bbad3c..03d16cf32508 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -86,6 +86,7 @@ struct netns_ipv4 {
 	int ip_rt_mtu_expires;
 	int ip_rt_min_advmss;
 	int ip_rt_error_cost;
+	int ip_rt_error_burst;
 
 	struct local_ports ip_local_ports;
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index b022ae749640..86fbb2b511c1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -114,11 +114,11 @@
 #define DEFAULT_MIN_PMTU (512 + 20 + 20)
 #define DEFAULT_MTU_EXPIRES (10 * 60 * HZ)
 #define DEFAULT_MIN_ADVMSS 256
+#define DEFAULT_ERROR_BURST	(5 * HZ)
 static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
 static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
-static int ip_rt_error_burst __read_mostly	= 5 * HZ;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
 
@@ -948,7 +948,7 @@ static int ip_error(struct sk_buff *skb)
 	SKB_DR(reason);
 	bool send;
 	int code;
-	int error_cost;
+	int error_cost, error_burst;
 
 	if (netif_is_l3_master(skb->dev)) {
 		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
@@ -1003,9 +1003,10 @@ static int ip_error(struct sk_buff *skb)
 		now = jiffies;
 		peer->rate_tokens += now - peer->rate_last;
 		error_cost = READ_ONCE(net->ipv4.ip_rt_error_cost);
+		error_burst = READ_ONCE(net->ipv4.ip_rt_error_burst);
 
-		if (peer->rate_tokens > ip_rt_error_burst)
-			peer->rate_tokens = ip_rt_error_burst;
+		if (peer->rate_tokens > error_burst)
+			peer->rate_tokens = error_burst;
 		peer->rate_last = now;
 		if (peer->rate_tokens >= error_cost)
 			peer->rate_tokens -= error_cost;
@@ -3537,13 +3538,6 @@ static struct ctl_table ipv4_route_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
-		.procname	= "error_burst",
-		.data		= &ip_rt_error_burst,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
 	{
 		.procname	= "gc_elasticity",
 		.data		= &ip_rt_gc_elasticity,
@@ -3592,6 +3586,13 @@ static struct ctl_table ipv4_route_netns_table[] = {
 		.mode       = 0644,
 		.proc_handler   = proc_dointvec,
 	},
+	{
+		.procname       = "error_burst",
+		.data           = &init_net.ipv4.ip_rt_error_burst,
+		.maxlen     = sizeof(int),
+		.mode       = 0644,
+		.proc_handler   = proc_dointvec,
+	},
 	{ },
 };
 
@@ -3656,6 +3657,7 @@ static __net_init int netns_ip_rt_init(struct net *net)
 	net->ipv4.ip_rt_mtu_expires = DEFAULT_MTU_EXPIRES;
 	net->ipv4.ip_rt_min_advmss = DEFAULT_MIN_ADVMSS;
 	net->ipv4.ip_rt_error_cost = HZ;
+	net->ipv4.ip_rt_error_burst = DEFAULT_ERROR_BURST;
 	return 0;
 }
 
-- 
2.25.1

