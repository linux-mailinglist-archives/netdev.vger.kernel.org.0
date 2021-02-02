Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133AB30B812
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhBBGxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbhBBGxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:53:39 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94229C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 22:52:15 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id u4so21175634ljh.6
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 22:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2jCvKU/t3a17/kKNLCulfFB49Ji8OL7uYgYBU19B1WQ=;
        b=WVMqfbey1W7NTgnlcKk+XuEc/rE2v2hDOpszx9GyNXa/nHeouJ6QEtliJrzHAujyps
         EjpIY90fYeeS+VpA6BZVgAOrZ54LEIM3FwYeelCI2XVaabTZvdwaQViGn0ycBRf+HSGe
         TYcDyyTc7coCY2WrjKEw1wfrV3iojGO4aimXdhP/FnT4ADe+SsAaD4TUQdQ8DNJAE7uR
         varnIX1NB3bFY5sKzyD73VnJp0WZTu6esYI5oxEiMiNbqbaCrNzzJg0QpAM0XgBX+aBJ
         tGp18w5D+wJtqx4YMUf0AyttM95jcnt/pAuhC0IYkBUJQgogpQSlCHlN8Ye8VK66a4LA
         jnCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2jCvKU/t3a17/kKNLCulfFB49Ji8OL7uYgYBU19B1WQ=;
        b=FB9SB40pyFZDoBgoyZ2BvaybS0yNYr49/hSXlrhfSfWkE1BrW/3W9c82F4mwmmyi8d
         uNhD6grPcQbTWPaKv2BuPqbojSq/ILhUauj9fczfQ4AYw1wENuq6qpg4GB9Qz2bhS1of
         6/PPNpZ2o3/EH13fXXcxh/CxjoEVflowP4nR4UW5t/xjnfVS7483zTsNNmWeeyFecDOx
         q8dph+6e9hwgbrthEtAqiten2OtPUQc3xpuYQCeq7EjuYn861Oo2sEqDm34dXflnHCCC
         bH3RAlDU+whoe6e0mlvvmdFaOiZA09ZMGSBJZLU0KtpDRVoGa4iU1p77yuehhpBntlu0
         zTmA==
X-Gm-Message-State: AOAM531RG43VekL8QAxyo2HlVJ1H/CySWn142eossLR0oQ5w6R3eUEkI
        /VaMSNOarKkY9mPaIGR/kfA9HQ==
X-Google-Smtp-Source: ABdhPJz35TpiW3HoDJ8Dy1+VbBty+3B4HLLkeuDZi7Mf+Q/8xtusDC1aLQq85MMvCqI/vgJ2Xw+KBw==
X-Received: by 2002:a2e:959a:: with SMTP id w26mr12071480ljh.113.1612248734091;
        Mon, 01 Feb 2021 22:52:14 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id b26sm2535171lff.162.2021.02.01.22.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 22:52:13 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next 7/7] gtp: update rx_length_errors for abnormally short packets
Date:   Tue,  2 Feb 2021 07:51:59 +0100
Message-Id: <20210202065159.227049-8-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202065159.227049-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on work by Pravin Shelar.

Update appropriate stats when packet transmission isn't possible.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index a1bb02818977..fa8880c51101 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -189,8 +189,10 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 
 	/* Get rid of the GTP + UDP headers. */
 	if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
-				 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
-		return -1;
+			 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev)))) {
+		gtp->dev->stats.rx_length_errors++;
+		goto err;
+	}
 
 	netdev_dbg(pctx->dev, "forwarding packet from GGSN to uplink\n");
 
@@ -206,6 +208,10 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 
 	netif_rx(skb);
 	return 0;
+
+err:
+	gtp->dev->stats.rx_dropped++;
+	return -1;
 }
 
 /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated. */
-- 
2.27.0

