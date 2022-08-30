Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8DB5A5F04
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiH3JQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiH3JQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:16:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC8ED2E82;
        Tue, 30 Aug 2022 02:16:24 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so4162554pja.4;
        Tue, 30 Aug 2022 02:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=AwpPxJmpuD6vSXIYZsaR+0dhj1Xu9wkEAUjPZWS3YK8=;
        b=PVnmqVceveJBufyKnU/McUDwsQlCD76O7dwZf6FM9YAi1n3XqoPQwquTaqrBFdMwu1
         n3HinEu/VJi4GsgAngyHuqJUKDqYQvxNS4++CL8ufG1ajIcRF60Tar1yUF6OtizXsvSH
         xg8gtYB/lm3v9qmE99lD/PJr/LhlBN8KCEtwPPQWoFnHDaDh9y8oHinG9jyZOxoZGRZW
         kxiMxPuJQJmIKk4LEs1eqoKCDpBTcaexrXaHQysygYfb1dG4Ou9w8A1IYHrsD4kUe3fO
         Pw3nso5/otW7sdyb3mba6uO3aRlyMegc/YMY0SU8S0Rjra09A/ObTKULRZA7r0XNPyy7
         VkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=AwpPxJmpuD6vSXIYZsaR+0dhj1Xu9wkEAUjPZWS3YK8=;
        b=k7QLTXin4A0ZUnDxOIoMf993ScbA71Hg0M4Q0UBxa6YaRzwkrHQV005uT5RHJ+320u
         AcPZE61N/qyTxFlDbLWrwkQWSw0bV2Z9QYN7Borus0PZo6K5aVxYJ+94saJv2lCUmSmM
         hfuMjUTEyT0Qa687pZX1x+kTgtHLrbT8waOIZ8xT19Qwwj9tJHZDnverC81QG40YKMhy
         qMdPDnGJwQDJSGFiLjB4j9/ujtbs5U7oWill/t+GTGKEphcsbnOAZXv1uHd5e8eYTVLX
         y5+k5WfNyzyz1wDhJdkLpu76kLsZpKeqaXcx7QaDmIZLt5QlwW1OpUIa/B0hD5I68Iqw
         nLsA==
X-Gm-Message-State: ACgBeo2pnjREdLsbD68gUZIOJaBmsVxiUUxFXk1Bw/Hi7JmIa+6sQ2GJ
        7adtBFa177JkzE/e2OrVuuU=
X-Google-Smtp-Source: AA6agR4JYxLezfwNX3QqbaVzew3oDXyUuBNOpytQrWOMZWoiE59WRbkw1yOXMGJxvsNJpq4v00T/SQ==
X-Received: by 2002:a17:902:e94c:b0:171:3df0:c886 with SMTP id b12-20020a170902e94c00b001713df0c886mr21069633pll.39.1661850983724;
        Tue, 30 Aug 2022 02:16:23 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090a440700b001fa9e7b0c3esm7998294pjg.41.2022.08.30.02.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:16:23 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn, Yunkai Zhang <zhang.yunkai@zte.com.cn>
Subject: [PATCH v3 1/3] ipv4: Namespaceify route/error_cost knob
Date:   Tue, 30 Aug 2022 09:16:14 +0000
Message-Id: <20220830091614.286342-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220830091453.286285-1-xu.xin16@zte.com.cn>
References: <20220830091453.286285-1-xu.xin16@zte.com.cn>
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

Different netns has different requirement on the setting of error_cost
sysctl which is used to limit the max frequency of sending
ICMP_DEST_UNREACH packet together with error_burst. To put it simply,
it refers to the minimum time interval between two consecutive
ICMP_DEST_UNREACHABLE packets sent to the same peer when now is
icmp-stable period not the burst case after a long calm time.

Enable error_cost to be configured per network namespace.

Signed-off-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
Reviewed-by: Yunkai Zhang (CGEL ZTE) <zhang.yunkai@zte.com.cn>
---
 include/net/netns/ipv4.h |  1 +
 net/ipv4/route.c         | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index c7320ef356d9..319395bbad3c 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -85,6 +85,7 @@ struct netns_ipv4 {
 	u32 ip_rt_min_pmtu;
 	int ip_rt_mtu_expires;
 	int ip_rt_min_advmss;
+	int ip_rt_error_cost;
 
 	struct local_ports ip_local_ports;
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 795cbe1de912..209539c201c2 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -118,7 +118,6 @@ static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
 static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
-static int ip_rt_error_cost __read_mostly	= HZ;
 static int ip_rt_error_burst __read_mostly	= 5 * HZ;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
@@ -1000,6 +999,8 @@ static int ip_error(struct sk_buff *skb)
 
 	send = true;
 	if (peer) {
+		int ip_rt_error_cost = READ_ONCE(net->ipv4.ip_rt_error_cost);
+
 		now = jiffies;
 		peer->rate_tokens += now - peer->rate_last;
 		if (peer->rate_tokens > ip_rt_error_burst)
@@ -3535,13 +3536,6 @@ static struct ctl_table ipv4_route_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{
-		.procname	= "error_cost",
-		.data		= &ip_rt_error_cost,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
 	{
 		.procname	= "error_burst",
 		.data		= &ip_rt_error_burst,
@@ -3590,6 +3584,13 @@ static struct ctl_table ipv4_route_netns_table[] = {
 		.mode       = 0644,
 		.proc_handler   = proc_dointvec,
 	},
+	{
+		.procname   = "error_cost",
+		.data       = &init_net.ipv4.ip_rt_error_cost,
+		.maxlen     = sizeof(int),
+		.mode       = 0644,
+		.proc_handler   = proc_dointvec,
+	},
 	{ },
 };
 
@@ -3653,6 +3654,7 @@ static __net_init int netns_ip_rt_init(struct net *net)
 	net->ipv4.ip_rt_min_pmtu = DEFAULT_MIN_PMTU;
 	net->ipv4.ip_rt_mtu_expires = DEFAULT_MTU_EXPIRES;
 	net->ipv4.ip_rt_min_advmss = DEFAULT_MIN_ADVMSS;
+	net->ipv4.ip_rt_error_cost = HZ;
 	return 0;
 }
 
-- 
2.25.1

