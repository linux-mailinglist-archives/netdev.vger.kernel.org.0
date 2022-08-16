Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122EF595340
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiHPHBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiHPHAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:00:50 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C439977E9B;
        Mon, 15 Aug 2022 19:27:06 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v4so3739979pgi.10;
        Mon, 15 Aug 2022 19:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=zW+Ip+V7aRjAqrJGVcvTx1BQTy2Ro/r2AmGTaww/urM=;
        b=GM/Jvw4xnUdU1dl5k5TiK1F37rgEtxvlAtjS7LPVhQSuzUjHqOXXFhPztCIhMRd10M
         SVupfZaFxVDmomZR7SxVZ82i2ygCB3J86HVJsDczqTih48UaPbpRzqApNmREQBGX01LO
         sU1zF1DsrI/SNtqYK9/9RmxEszjzFO95NhkraOjWQyxrX/5wlBi6OS9c9imskKezPOcU
         hif8g0ByKX0iAjMCPOsmd5LBYcEYVmKRg3pK260Yf4bNNfmv40BwcOgrMn6BjvzwWIAU
         bQthxmL0oEyMR/ciH0eirjf56NfhMTQzyT62/w/fNOtB07jeO0rlCkpx+McdBINMcQn7
         C5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=zW+Ip+V7aRjAqrJGVcvTx1BQTy2Ro/r2AmGTaww/urM=;
        b=VRdmCiKnmx1EI/Pk9LzZAdxJGtQzFGBLU3blKhekR0VdGYy9aehkaBdgFOtjAiZi2v
         LQ48IvkK50dRDGAgWDKqGInhopn61m0TPRgNv8WnmUAkg8jZz7bcc3A4c1LDMbhEjGEC
         GPRncFY9Rt2dzG+SgNOq5PXLKvQ5qT6itCjkeo5ISmv/Nc2WNsAY6v1LYrIkEVfWM359
         Sph53cQxeqZ9PcaXoRWNfwY+12PjdB8ATJrytIr9rka5o0MOre4YijgCiFPTKadae3pD
         EuibmOH0tv1LaS0LXF2mdRD9eyvlV3RpfL7a2JJ4sRMpZ4tLCBlmLpE2EaYkZGZd8SHN
         BjSw==
X-Gm-Message-State: ACgBeo3QKJiB++cXgu5Gb2dlz9mPAcnCDxwU0NCAZaYiOHjRcFGIHEQd
        rxEPvStx15Y1tvkVdznvN2thaTXo12k=
X-Google-Smtp-Source: AA6agR6oc6Gnl7+FJciCACvN5SAnMuG6ZSX4B+3X5hjzE/iV2NymIehqyboz8HlkVSygB1fxv5lGYw==
X-Received: by 2002:a63:8241:0:b0:41b:c27b:c18 with SMTP id w62-20020a638241000000b0041bc27b0c18mr16568360pgd.370.1660616826324;
        Mon, 15 Aug 2022 19:27:06 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t11-20020a1709027fcb00b0016f8e8032c4sm632931plb.129.2022.08.15.19.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 19:27:05 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn
Subject: [PATCH 2/2] ipv4: Namespaceify route/error_burst knob
Date:   Tue, 16 Aug 2022 02:27:02 +0000
Message-Id: <20220816022702.81884-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220816022522.81772-1-xu.xin16@zte.com.cn>
References: <20220816022522.81772-1-xu.xin16@zte.com.cn>
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
packet.

Enable error_burst to be configured per network namespace.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 include/net/netns/ipv4.h |  1 +
 net/ipv4/route.c         | 21 +++++++++++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

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
index 0598393e03ac..4e40b667e3fc 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -114,11 +114,11 @@
 #define DEFAULT_MIN_PMTU (512 + 20 + 20)
 #define DEFAULT_MTU_EXPIRES (10 * 60 * HZ)
 #define DEFAULT_MIN_ADVMSS 256
+#define DEFAULT_ERROR_BURST (5 * HZ)
 static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
 static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
-static int ip_rt_error_burst __read_mostly	= 5 * HZ;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
 
@@ -1001,8 +1001,8 @@ static int ip_error(struct sk_buff *skb)
 	if (peer) {
 		now = jiffies;
 		peer->rate_tokens += now - peer->rate_last;
-		if (peer->rate_tokens > ip_rt_error_burst)
-			peer->rate_tokens = ip_rt_error_burst;
+		if (peer->rate_tokens > net->ipv4.ip_rt_error_burst)
+			peer->rate_tokens = net->ipv4.ip_rt_error_burst;
 		peer->rate_last = now;
 		if (peer->rate_tokens >= net->ipv4.ip_rt_error_cost)
 			peer->rate_tokens -= net->ipv4.ip_rt_error_cost;
@@ -3534,13 +3534,6 @@ static struct ctl_table ipv4_route_table[] = {
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
@@ -3589,6 +3582,13 @@ static struct ctl_table ipv4_route_netns_table[] = {
 		.mode       = 0644,
 		.proc_handler   = proc_dointvec,
 	},
+	{
+		.procname   = "error_burst",
+		.data       = &init_net.ipv4.ip_rt_error_burst,
+		.maxlen     = sizeof(int),
+		.mode       = 0644,
+		.proc_handler   = proc_dointvec,
+	},
 	{ },
 };
 
@@ -3653,6 +3653,7 @@ static __net_init int netns_ip_rt_init(struct net *net)
 	net->ipv4.ip_rt_mtu_expires = DEFAULT_MTU_EXPIRES;
 	net->ipv4.ip_rt_min_advmss = DEFAULT_MIN_ADVMSS;
 	net->ipv4.ip_rt_error_cost = HZ;
+	net->ipv4.ip_rt_error_burst =  DEFAULT_ERROR_BURST;
 	return 0;
 }
 
-- 
2.25.1

