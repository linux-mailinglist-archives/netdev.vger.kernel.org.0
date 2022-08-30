Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3643B5A5F09
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiH3JRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiH3JRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:17:06 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB8DD2EB0;
        Tue, 30 Aug 2022 02:17:05 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 145so10385653pfw.4;
        Tue, 30 Aug 2022 02:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=HSIgRfOrSPDJb/X5S53DyHalzzKyLtpCJJH7LjGnj5I=;
        b=c4HJG4dUuEPntFjcys0mnlZVjQzSqR0wR+PYGc1wjQOJ/GyrcBk2klcpX7gwbghQEI
         jsNHe70AAVKbkiK6c+VJm6CgMdkIpp266fALujvZ4MC2rXO+TPN1SH3Q4pD8D5NgIkz5
         6FLJP8vLeTXuesu0cI3iMdvqL1RoLcG4DUZVBn5OzsCT85GlQJUYVTrkMRk93rN2tVN4
         dB5NRqw8JjJRiNWDNz8CBy7EeB4mP3jZ+cJYqYvPLonuZ4o1IXbIoSsH3xpBN2MulNZt
         pJIWwg05MIvRWhpqAc/N4/ecZG2vrGd3fqnJhh0Z/UjBD0Tgobfpl9tdcxuR0eCR6scX
         +lAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=HSIgRfOrSPDJb/X5S53DyHalzzKyLtpCJJH7LjGnj5I=;
        b=2ZOEZ3APKFXbMJ68UPHAZK2n04fJrIWt7x5bFo3oW0WrKQ17IXPF8vWemWbP/ZbqS0
         iwwpiUknvrn5Ib78YrZVrksSPgTPm1zihNMWtptRiVigWeWes+UEUZx2+0sxOJirhoik
         dv+mh9jcR5x1KKa/MMKDuVhOga2a1CGA0EZWjaxhaOnOf0NBMSMQRkqtg9eC/0i18OAM
         qW2ZqK5v4yLSKz+LC2C4fLGcSkQRKorf84r8i6YjuA3/CN1AHyQ83es0HvY/YIsvTRgp
         TUh+WZFSme9Oi3UYh/+fuY5aTyFh2Lja4+184D4eTKWW1I5E+n2P5Q532IdRS8V5zloB
         mpbQ==
X-Gm-Message-State: ACgBeo1YBDAK1uICT2nCYFDvhYae78JF2gqRyrAKz3e0bnVQ+N9UBDlR
        wTBiHOIcP9foIJztfBw5z7o=
X-Google-Smtp-Source: AA6agR7U6ZrD1KdTPgQf2Tzvf+CrSS+Bl8W8vVwe3LWXmQLp/kpzn5aBsFTWY+mL7kKBrloQkF4i6g==
X-Received: by 2002:a05:6a00:88f:b0:52c:6962:274f with SMTP id q15-20020a056a00088f00b0052c6962274fmr21161017pfj.12.1661851024971;
        Tue, 30 Aug 2022 02:17:04 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i63-20020a626d42000000b00537b8aa0a46sm8955406pfc.96.2022.08.30.02.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 02:17:04 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn, Yunkai Zhang <zhang.yunkai@zte.com.cn>
Subject: [PATCH v3 2/3] ipv4: Namespaceify route/error_burst knob
Date:   Tue, 30 Aug 2022 09:16:57 +0000
Message-Id: <20220830091657.286396-1-xu.xin16@zte.com.cn>
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
 net/ipv4/route.c         | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 8 deletions(-)

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
index 209539c201c2..4745a4085de5 100644
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
 
@@ -1000,6 +1000,7 @@ static int ip_error(struct sk_buff *skb)
 	send = true;
 	if (peer) {
 		int ip_rt_error_cost = READ_ONCE(net->ipv4.ip_rt_error_cost);
+		int ip_rt_error_burst = READ_ONCE(net->ipv4.ip_rt_error_burst);
 
 		now = jiffies;
 		peer->rate_tokens += now - peer->rate_last;
@@ -3536,13 +3537,6 @@ static struct ctl_table ipv4_route_table[] = {
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
@@ -3591,6 +3585,13 @@ static struct ctl_table ipv4_route_netns_table[] = {
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
 
@@ -3655,6 +3656,7 @@ static __net_init int netns_ip_rt_init(struct net *net)
 	net->ipv4.ip_rt_mtu_expires = DEFAULT_MTU_EXPIRES;
 	net->ipv4.ip_rt_min_advmss = DEFAULT_MIN_ADVMSS;
 	net->ipv4.ip_rt_error_cost = HZ;
+	net->ipv4.ip_rt_error_burst = DEFAULT_ERROR_BURST;
 	return 0;
 }
 
-- 
2.25.1

