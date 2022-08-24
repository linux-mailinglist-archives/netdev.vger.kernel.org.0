Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED33E59F138
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 04:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbiHXCD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 22:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiHXCD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 22:03:57 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B6586711;
        Tue, 23 Aug 2022 19:03:56 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id p185so671110pfb.13;
        Tue, 23 Aug 2022 19:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=7ofU2lgCpYY1MTlNsVIVEv5dtOBTMdU8c432THIlWs4=;
        b=aQdeP9pDunfS9FujeAzgmCY7t/dHVok+GvEkdZH0xXjkZ4X+InIGuKT4f3d4SNOToE
         27IEVWaU7bC0iL8mzukT27Id01uFCD/l3DMGS1Ip8y9vrFwxqVdRG/Vro0OJ40ntin5Z
         DQhO5zxF4LmkYUroZP+GtbpPnYrY+PO2h2lh/6qyTvkkedxdFJEG5QZAW/b5EFsX1bw7
         q0X6Jv7CB575yCkTJRxchK3mLzyDhGcvY19zoTqQzjBvIiN3W10IZybpBjJ5babyV/ln
         7Bt3QcCVi2sRbLy2sBFqKVxxoHGnOBqaH72jTEpe0Po/1/NOzDcvJvm2gLMcN7WwTPyN
         5q/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=7ofU2lgCpYY1MTlNsVIVEv5dtOBTMdU8c432THIlWs4=;
        b=itY6zfC52N4DfxSoDU99u5jUB91P6DixzTWVt9HGHkks1u6EVqH8KP/rG5+9noi70h
         KFVG0NiXT2rjxpiQWODPRiBVIRKAPMsqFh479hYd8AdkafAgkojvrOnME0IENytx/UcX
         zEjuVASQRbk5mrEXhezEskvKGS1a/WsSexgsvUm0edNfrcygIJhc9dXf4tmFYXZSP8LX
         M7LU1PPFGTGpFKHzBhIYho53luWUNtPA7/5uKJWkiTaj9nOEV4gkogbq32f+qiubY8y2
         5U+3OZdU+OnIk3dQ0BS1CIJNTVCXHTnzfWL9PDWloKtc9QdG/6Wph32ZLmWygclEDx2Z
         Z9Tw==
X-Gm-Message-State: ACgBeo370QE/tzOOoG7OEyEVOao4bzGZmF6PfVm2koK4p6vtej1+IIMy
        Fy9CVYHB+DHmFAea/aYXJQ0=
X-Google-Smtp-Source: AA6agR75nPxUcgL7iz/D6O3wwvcyYXf0MYELMcTN3cgefHDPFD1KLUoBqk4rIhPFzvs3z4Ot37yc7Q==
X-Received: by 2002:a63:170d:0:b0:415:f76d:45e1 with SMTP id x13-20020a63170d000000b00415f76d45e1mr22758662pgl.171.1661306636313;
        Tue, 23 Aug 2022 19:03:56 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y3-20020aa79e03000000b0052e78582aa2sm8762157pfq.181.2022.08.23.19.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 19:03:56 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn,
        Yunkai Zhang <zhang.yunkai@zte.com.cn>
Subject: [PATCH v2 1/3] ipv4: Namespaceify route/error_cost knob
Date:   Wed, 24 Aug 2022 02:03:43 +0000
Message-Id: <20220824020343.213715-1-xu.xin16@zte.com.cn>
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
 net/ipv4/route.c         | 23 +++++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

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
index 795cbe1de912..b022ae749640 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -118,7 +118,6 @@ static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
 static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
-static int ip_rt_error_cost __read_mostly	= HZ;
 static int ip_rt_error_burst __read_mostly	= 5 * HZ;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
@@ -949,6 +948,7 @@ static int ip_error(struct sk_buff *skb)
 	SKB_DR(reason);
 	bool send;
 	int code;
+	int error_cost;
 
 	if (netif_is_l3_master(skb->dev)) {
 		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
@@ -1002,11 +1002,13 @@ static int ip_error(struct sk_buff *skb)
 	if (peer) {
 		now = jiffies;
 		peer->rate_tokens += now - peer->rate_last;
+		error_cost = READ_ONCE(net->ipv4.ip_rt_error_cost);
+
 		if (peer->rate_tokens > ip_rt_error_burst)
 			peer->rate_tokens = ip_rt_error_burst;
 		peer->rate_last = now;
-		if (peer->rate_tokens >= ip_rt_error_cost)
-			peer->rate_tokens -= ip_rt_error_cost;
+		if (peer->rate_tokens >= error_cost)
+			peer->rate_tokens -= error_cost;
 		else
 			send = false;
 		inet_putpeer(peer);
@@ -3535,13 +3537,6 @@ static struct ctl_table ipv4_route_table[] = {
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
@@ -3590,6 +3585,13 @@ static struct ctl_table ipv4_route_netns_table[] = {
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
 
@@ -3653,6 +3655,7 @@ static __net_init int netns_ip_rt_init(struct net *net)
 	net->ipv4.ip_rt_min_pmtu = DEFAULT_MIN_PMTU;
 	net->ipv4.ip_rt_mtu_expires = DEFAULT_MTU_EXPIRES;
 	net->ipv4.ip_rt_min_advmss = DEFAULT_MIN_ADVMSS;
+	net->ipv4.ip_rt_error_cost = HZ;
 	return 0;
 }
 
-- 
2.25.1

