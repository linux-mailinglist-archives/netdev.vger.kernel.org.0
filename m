Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0550301830
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAWUGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbhAWUAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:13 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF8DC06121C
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:40 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id f2so5337287ljp.11
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=94fMBMJGVw8OxVT9BQu2sHrnWkzVR9OiBlBF0ObRZmc=;
        b=qdJcfhvIQmQasEM+UGe+wIw44nubzKflPLSmZZdpFeEXEhFDtWi2roQEm4cg9X+Xvs
         8QVzJx9kteVzuHH18ZgIDR9hZ8PSyyUA4KJFevKpiGV1rtLDT5faWswk5UNcG2KG8Fpl
         1qmgnthlpYFVY7e4+U4Ae4Tp1XGKnq/WCU4+vAXWfEZsUojNyf1szwvsU0YQbKIlS9Wn
         ylPdiON2IC/YMCCinAC4i4xKc2CeRy+rTETmcu3NymrYusZMWI1dIUIZyKH9nGTSFqr8
         sJKEhVeoAdMNJm30lDYJYHkisrUqM4FBbAL3BfJvXomRStEy80h3tPK0zpS9E05YLwdc
         rplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=94fMBMJGVw8OxVT9BQu2sHrnWkzVR9OiBlBF0ObRZmc=;
        b=UVGJptAsWKha+45leNeoXfP0sgwHZxu4UkMd1Li+H2LG1Ju1pQTwdg/frkaDtK8AfQ
         aYB6+nGLUFesLYDg7Skz3lYG5UZhYCviXtwXEQQaR4FlfwiB9Iz1FV3dACT/XqnudUcq
         aLWWFAa8nou/JXnIsr4CJCKeJctW0w55XClUjcdpsmd8OxV7TUDRE+SV0cV5Kf1dxtSw
         ZH4JTg94qccOLYguH8USbXVis+H7A4aL/S9WYk8WCZkiI5c2Q18Dir5S0OI8zxAqyVm8
         BvYdViHZMO+SIa3xwz7LmXAJH4EXd2LiUGjaFJKLzSoDveHkE7LlE2Pm7n7tlDu3Nkbz
         RqIw==
X-Gm-Message-State: AOAM532g4nBxei+XjGCnqT+VoSSEVr31gIZ30PDn4o/8CQj8GZW6AoBM
        pkoffG2o4fy4BQhhCTPzmeTm9e/dWlRBMg==
X-Google-Smtp-Source: ABdhPJwml1Qi8gp5Gyd7yXCihBncHe4pg8Jb0YClets5i/umJ+5UAQ1N8pIw1l4cAaXzU4hVmlV/KQ==
X-Received: by 2002:a2e:bc0c:: with SMTP id b12mr88003ljf.201.1611431978646;
        Sat, 23 Jan 2021 11:59:38 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:38 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 10/16] gtp: refactor check_ms back into version specific handlers
Date:   Sat, 23 Jan 2021 20:59:10 +0100
Message-Id: <20210123195916.2765481-11-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is preparatory work for adding flow based tunneling work by Pravin
Shelar.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index b20e17988bfa..c42092bb505f 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -181,13 +181,8 @@ static bool gtp_check_ms(struct sk_buff *skb, struct pdp_ctx *pctx,
 }
 
 static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
-			unsigned int hdrlen, unsigned int role)
+			unsigned int hdrlen)
 {
-	if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
-		netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
-		return 1;
-	}
-
 	/* Get rid of the GTP + UDP headers. */
 	if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
 				 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
@@ -234,7 +229,12 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 		return 1;
 	}
 
-	return gtp_rx(pctx, skb, hdrlen, gtp->role);
+	if (!gtp_check_ms(skb, pctx, hdrlen, gtp->role)) {
+		netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
+		return 1;
+	}
+
+	return gtp_rx(pctx, skb, hdrlen);
 }
 
 static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
@@ -276,7 +276,12 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 		return 1;
 	}
 
-	return gtp_rx(pctx, skb, hdrlen, gtp->role);
+	if (!gtp_check_ms(skb, pctx, hdrlen, gtp->role)) {
+		netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
+		return 1;
+	}
+
+	return gtp_rx(pctx, skb, hdrlen);
 }
 
 static void __gtp_encap_destroy(struct sock *sk)
-- 
2.27.0

