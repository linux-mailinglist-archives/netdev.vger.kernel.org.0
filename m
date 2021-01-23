Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB59301823
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbhAWUCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbhAWUAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:40 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C64C06121F
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:42 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id a8so12308205lfi.8
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7JEnFHod/CacccbC2px8f2RtPEF1uIxuwyGPq/6p3Jo=;
        b=IPdrLQAW2KuSrzRp1p0+7pjgnbPoKHTFyA5z3b1xUI3PIO1dXyWyI8XabkRJgQ6RUC
         LLrb90zg+7ltF8AfGyGM0ggzQ3s9ZsNDGFyC78wQn5J2mBCLQQ79q3M8pSTlrpLDb3jW
         A4Hhpsy1OkKc8CSp6nbWlrXIdmc1Dq3f2JzTZke9LKpmnM5Y6RY5orpssG0u6iWW/itv
         VsMODLCT1V8MbMxyCEUxkxWgvXN9TbIlSzwtmS8k71V9qa14cOHy/UwO5OEzN6EE2/9b
         RJ68MfjP9jQ6/vCp5fL3Nrz1hj52aoe5RJNCOp8woH9Wc3apIWVzi0otLcW5/ueRdofu
         T3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7JEnFHod/CacccbC2px8f2RtPEF1uIxuwyGPq/6p3Jo=;
        b=Fn49RqZA28MlVoXbhpAHlH9u02Jglf0XUz5K+Djnlwg6D0mei2jgR3N4/dfHHolWSp
         7wlK8nXxF+o9DPw3lKUgS0xC3hsGNmuOpVVTxZLoRXnWMx/O5UT2KEocktBQpZn6Dr8K
         g9dmUwE3+IKEgR5pM5la4K4OXBOSUgTnoXmYS50PdFCe/89yp5EhlK6Rcct2h9tvHApD
         WVBBhpbjg2PfYwb5S2qRqoflHfW6Ip9xycGSQzS1hf1/ehgQi2mJr7Din4I7PKZA05EH
         52vQeRb5gxN0l21UsAbb75lZGIsxFqHBI/XdXKG2FYMxaHe35tLQk5syXUmGushL8WHl
         ZNSA==
X-Gm-Message-State: AOAM530jbcpX5vTcxmzgYAI0AjP5xKSv+xTmJky1NFcayJ3Eu1bhY4yA
        HEYwO4LrMY9yyx2a0y4vi6MX7Q==
X-Google-Smtp-Source: ABdhPJwKM2V4xOYcrBFXVaY4Le6Yyt3pSg5xSnsNRq85fvBkmcfg1YWgmkoiPcMP2K/LYWlhGjCRqQ==
X-Received: by 2002:a05:6512:3253:: with SMTP id c19mr831204lfr.245.1611431980850;
        Sat, 23 Jan 2021 11:59:40 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:40 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 13/16] gtp: set skb protocol after pulling headers
Date:   Sat, 23 Jan 2021 20:59:13 +0100
Message-Id: <20210123195916.2765481-14-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on work by Pravin Shelar.

Once the GTP headers have been the removed, the SKB protocol should be
set to that of the inner packet.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 7ab8540e46d2..8aab46ec8a94 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -197,6 +197,20 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 	 * calculate the transport header.
 	 */
 	skb_reset_network_header(skb);
+	if (pskb_may_pull(skb, sizeof(struct iphdr))) {
+		struct iphdr *iph;
+
+		iph = ip_hdr(skb);
+		if (iph->version == 4) {
+			netdev_dbg(pctx->dev, "inner pkt: ipv4");
+			skb->protocol = htons(ETH_P_IP);
+		} else if (iph->version == 6) {
+			netdev_dbg(pctx->dev, "inner pkt: ipv6");
+			skb->protocol = htons(ETH_P_IPV6);
+		} else {
+			netdev_dbg(pctx->dev, "inner pkt error: Unknown type");
+		}
+	}
 
 	skb->dev = pctx->dev;
 
-- 
2.27.0

