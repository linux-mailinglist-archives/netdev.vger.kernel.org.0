Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD4E59B890
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 06:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiHVEzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 00:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiHVEzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 00:55:07 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34037101D5;
        Sun, 21 Aug 2022 21:55:06 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id bh13so8410887pgb.4;
        Sun, 21 Aug 2022 21:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=IszYOtnFBU1gmjy/XVRVYew1Zn5AOIACo9BduvN3ShA=;
        b=GSezJdPdUNYkP6hTUhOG4LgnDoVHkOi+t8oxbHsUY0OArxcfoPD1+XXOfE/rEgCt/z
         ft5nb8or4zgzMk8mDSs8Nc3TdZHxRw1UqmmZyWXiyqLOueihfOGjeno4V4CoWBgZft4s
         v/gkMFFuu1t5sxNyb4KQHtIg6mc78zQT6+Yh5DD8SkMF11UxH1j31kjldZwKWaza7IYK
         JFiTFABwnhza1Y3IKHLF00UPmGBV9Fckco1sKFMrnGc53wuUuV2N6tnRmGPkn9RVwXjZ
         Mq/GHyc85vgndIMzFr6KYAqrHrUWZNquDWMKAnQ5LJJmuwZeHPiRRffVvzAVPSPx5l+Q
         cyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=IszYOtnFBU1gmjy/XVRVYew1Zn5AOIACo9BduvN3ShA=;
        b=54GSYOXXUHtBztLv0xqmA8SOzeIgW/DMUW1fhsySV7VlcBsWhTd1Zi01LvrR8wSSWZ
         uXJj/8yH/OBD1xcAMN+kP2Ada+X6/OgVGmRYwEKwQD0+Rr59OTojgcJGAml2HSkntXuT
         7GSQaiE8a5Q4XgZe2rAQF+D/W8EBi8i0AbtzmtXb9D8qgcEQYOmjFFpI9flh4a+zAhg8
         Jn8/roobUvqdxzfad42gVAv9zT3cgANg8Eyko0BDeddDZ5DxxNbOZVw6UrgXgpV+CA8f
         mzb5WSKA0ZleUEx/Q5oxpjpQig45EwvcOT2rsGmqID0XyLlGXfBi2lUfW/mvJYdvTLvD
         PC5Q==
X-Gm-Message-State: ACgBeo00zRa831+EzmI+t16q47j5qRZinXpIk6qdT+jLnZNVfbwZIMg1
        xXvjHcy6wBeklJOg9gHrnIVs0KmtocA=
X-Google-Smtp-Source: AA6agR7CkhhsI8/Sohei1svaaV9WHoklyAKV8yGDHmx964eNVKOvbFmqI7WbMYrmozqMCaAw4hraOQ==
X-Received: by 2002:a65:68cd:0:b0:42a:9a57:157d with SMTP id k13-20020a6568cd000000b0042a9a57157dmr4872562pgt.426.1661144105746;
        Sun, 21 Aug 2022 21:55:05 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d19-20020a17090ad99300b001f53705ee92sm7138345pjv.6.2022.08.21.21.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 21:55:05 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn,
        Yunkai Zhang <zhang.yunkai@zte.com.cn>,
        CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH 1/3] ipv4: Namespaceify route/error_cost knob
Date:   Mon, 22 Aug 2022 04:54:57 +0000
Message-Id: <20220822045457.203708-1-xu.xin16@zte.com.cn>
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

Different netns has different requirement on the setting of error_cost
sysctl which is used to limit the max frequency of sending
ICMP_DEST_UNREACH packet together with error_burst. To put it simply,
it refers to the minimum time interval between two consecutive
ICMP_DEST_UNREACHABLE packets sent to the same peer when now is
icmp-stable period not the burst case after a long calm time.

Enable error_cost to be configured per network namespace.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Yunkai Zhang <zhang.yunkai@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
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

