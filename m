Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8992459F137
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 04:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiHXCEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 22:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiHXCEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 22:04:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996F3868A3;
        Tue, 23 Aug 2022 19:04:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id c13-20020a17090a4d0d00b001fb6921b42aso117524pjg.2;
        Tue, 23 Aug 2022 19:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=yQJDlMHUJFrwemGaRL3nn+/DlN8fFYrWml/BqHE75vg=;
        b=ICj+k/77AyOnQFdDH9ULlcYh/RFKVzOKM00+zNX9ihnsz/+nYW4ZoI4rxJkdcYSSMJ
         MoSbJyCISLdwGTOkiOmhTTNQlDDmZXmlvzF1CGifx0ifR1vwznhsJ4pVZYVFbp2XuX4G
         2AI7M+ZSxiPvLi3Cafbf8cF6mNPT6t+WZmalqcncOgL/xEaVDHyv/7dbrab+urWrJbFu
         sUnR6flrjB8IYSIc58av9dkrI35doOMLBT+/TrzncJ7mvsjXR0zQDDtY0bsM4pQu9bYU
         fXaWmdElV8Aw8i2q9MTkEV4dm74okMllsS9PsnkJLRNER49pWTjm7yNejydmGkIRolcK
         MMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=yQJDlMHUJFrwemGaRL3nn+/DlN8fFYrWml/BqHE75vg=;
        b=BbWpkv0+F0BS1piKLGZ2hWsPN3mjDBSCHzfXH+osomryFZX0Od/vsQWJfskjA32F/I
         7YyZ2S/KD6HMU2vdzFRBhUGCT3afg6rXVVpMzbR5gSGaZB3iwqIcrULYlwyV1SvPcvt8
         V5t5NLFfPSbmmkUobwbub+3bpSQVekiyo2gCNYIKd4Z5S4NaAq26M5PAe2CSXmbo4zS7
         /q/1iOyCB6tSiK9wh65+6PMMkecrbwjf8SiuCsXPc1FCjj1tlCJIOfotZ9OllW3uNZYH
         lsxcuu6pA9eQRv4NaYK4i7ngFXudxwVzmIL4ySbpOBCTSIYeD0dumyDBxXwR7W4xMkWi
         mkGQ==
X-Gm-Message-State: ACgBeo0+U7Y7GUsu201pVm/epbzhx0HVaEiHYmj5WkVt+c2z/BZ2G/mr
        sleZb/diYdFV2BTP7IjM4Yk=
X-Google-Smtp-Source: AA6agR7lZLvWfZe1DhuwEoVz6AVeNjOhhpG7a/cq7b91Q0VY8PrOlzYAWa/8H/c2sDgMlbWScY66kQ==
X-Received: by 2002:a17:90a:304a:b0:1fa:d832:5aca with SMTP id q10-20020a17090a304a00b001fad8325acamr5877403pjl.16.1661306662178;
        Tue, 23 Aug 2022 19:04:22 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d188-20020a6236c5000000b0052d1275a570sm11349951pfa.64.2022.08.23.19.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 19:04:21 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn,
        Yunkai Zhang <zhang.yunkai@zte.com.cn>
Subject: [PATCH v2 2/3] ipv4: Namespaceify route/error_burst knob
Date:   Wed, 24 Aug 2022 02:04:17 +0000
Message-Id: <20220824020417.213771-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220824020051.213658-1-xu.xin16@zte.com.cn>
References: <20220824020051.213658-1-xu.xin16@zte.com.cn>
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

Signed-off-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
Reviewed-by: Yunkai Zhang (CGEL ZTE) <zhang.yunkai@zte.com.cn>
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

