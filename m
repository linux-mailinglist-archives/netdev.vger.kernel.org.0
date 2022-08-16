Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3905C59533E
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiHPHBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiHPHAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:00:45 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF88C77E9F;
        Mon, 15 Aug 2022 19:26:43 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 13so7955844plo.12;
        Mon, 15 Aug 2022 19:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=T9vSQ1heKH3HxkPobfgJS5HgEo+rMqThdek5u6kjGpA=;
        b=Q7/cbQGf0OTq3fFuenLCuyVvJZhwAo7FzjGH3AONwecfXcY/chYuwwmZS1PI+MH1Vd
         vVMdch4u+qKBFiwH47DuPBBOY0dcPDrxM0RyLQqyLyiPFW34JoxgEXpU5CZtwGjYm1kY
         3u9DG6ncfzGoQHZW4vguy5jZHJeykcChQpmWa5B5+6AEahHB8DkyWNVG9BSbzkuYILWX
         bv1jPGap1wX+vQgEuURGfFsS792N91BlzhdmhpOqqNp0k6zWaXR4wPKk/pt1QWTy8cQq
         uubkdc7K+TLP2oouWOaclQcz6XsPHQuPHr3IviNavrG5DxZa9QCB7ncShIrHmGehXm5c
         ATPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=T9vSQ1heKH3HxkPobfgJS5HgEo+rMqThdek5u6kjGpA=;
        b=zk8Fdr/2uJEhi4bw/5sbFCPIPjMAsfPPWGjHl3jkEvU5rZRwme6ZabvCjfKkIW14Zm
         CR3uQZ3YUrxWPZkzhxEjyBQ3O91/i1S/tmd2d02DmHWAiNAPwX1m5MDz9sQX/1q4jSQi
         X9TOYaEBszgfWTgKM/DmxyGKV2/UUTcGdQI9SWv6J9+6/TtaS2cf10q2LPMPQ3kzcDPW
         Wo+UMDe2YbXZArF6ysBfVN88qFBih/i/XM6v36N9qOF0VcwHO2TF1fCXUUVyRzV7ZVeK
         rLYAqR/aq6s+A+QwC51/iaRUVh6PJyJHPuLT5Rdul3tpgS3ew+dE8S0IrhfHLbmOMqJu
         48Tw==
X-Gm-Message-State: ACgBeo2oN/DpEHh9M1Ao3ui7JBxv2Z61CVus0i4Z7Rsf72vGoFaKtP6z
        ZYsMdwR9TA3QeXu3g53XBT4=
X-Google-Smtp-Source: AA6agR62DGBmp6yp3A0SDnq9jMAkuMRN3gIa3YviZDaDAhHB7RJlSTHLJ5fbYOm9n+xp/oVrEb5rvQ==
X-Received: by 2002:a17:902:7596:b0:170:a235:b737 with SMTP id j22-20020a170902759600b00170a235b737mr20248147pll.118.1660616803405;
        Mon, 15 Aug 2022 19:26:43 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id e10-20020a170902784a00b0015ee60ef65bsm7638061pln.260.2022.08.15.19.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 19:26:43 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.xin16@zte.com.cn
Subject: [PATCH 1/2] ipv4: Namespaceify route/error_cost knob
Date:   Tue, 16 Aug 2022 02:26:22 +0000
Message-Id: <20220816022622.81830-1-xu.xin16@zte.com.cn>
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

Different netns has different requirement on the setting of error_cost
sysctl which is used to limit the max frequency of sending
ICMP_DEST_UNREACH packet together with error_burst.

Enable error_cost to be configured per network namespace.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 include/net/netns/ipv4.h |  1 +
 net/ipv4/route.c         | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

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
index 795cbe1de912..0598393e03ac 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -118,7 +118,6 @@ static int ip_rt_max_size;
 static int ip_rt_redirect_number __read_mostly	= 9;
 static int ip_rt_redirect_load __read_mostly	= HZ / 50;
 static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
-static int ip_rt_error_cost __read_mostly	= HZ;
 static int ip_rt_error_burst __read_mostly	= 5 * HZ;
 
 static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
@@ -1005,8 +1004,8 @@ static int ip_error(struct sk_buff *skb)
 		if (peer->rate_tokens > ip_rt_error_burst)
 			peer->rate_tokens = ip_rt_error_burst;
 		peer->rate_last = now;
-		if (peer->rate_tokens >= ip_rt_error_cost)
-			peer->rate_tokens -= ip_rt_error_cost;
+		if (peer->rate_tokens >= net->ipv4.ip_rt_error_cost)
+			peer->rate_tokens -= net->ipv4.ip_rt_error_cost;
 		else
 			send = false;
 		inet_putpeer(peer);
@@ -3535,13 +3534,6 @@ static struct ctl_table ipv4_route_table[] = {
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
@@ -3590,6 +3582,13 @@ static struct ctl_table ipv4_route_netns_table[] = {
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
 
@@ -3653,6 +3652,7 @@ static __net_init int netns_ip_rt_init(struct net *net)
 	net->ipv4.ip_rt_min_pmtu = DEFAULT_MIN_PMTU;
 	net->ipv4.ip_rt_mtu_expires = DEFAULT_MTU_EXPIRES;
 	net->ipv4.ip_rt_min_advmss = DEFAULT_MIN_ADVMSS;
+	net->ipv4.ip_rt_error_cost = HZ;
 	return 0;
 }
 
-- 
2.25.1

