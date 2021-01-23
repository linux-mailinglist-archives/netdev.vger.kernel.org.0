Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D7630182C
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbhAWUFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbhAWUAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:15 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B2EC06121E
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:41 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id a8so12308149lfi.8
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xqyGdbaS6LmomEk16hB8uNnXJFM5N97xCzDYtkMA9Rg=;
        b=KLAmp9h9yQlypWi6TuTMPfrmMUdpsT7NHO1yzs7JL6UGQCxOFHTXU4DfMLs5tCvuQP
         MLES0VcY5GBu4pCUQmSQQTCdyZAksT8K5IO/suMhNBXNtZnGZMOtpMy7ITqf4/O+IzhF
         igJAM7FQ0gDBD3eI4Gj2XtYwX/yIU3WFBkbYeXseF5b0TogNpUVicyi3IWFnEjVJJem0
         Y/2fhc1w+yaz27o+mdBoBFxCa6CMdBnlcBABXGi9dlzWCIecNFBMf4FoODLfHKAYCKF3
         KWxOHv/OAqrID4zLKiridcZ8TA84G/6W0eTorSI9bGEUm1JvK07b69vylmvHy/bWl2zf
         DGhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xqyGdbaS6LmomEk16hB8uNnXJFM5N97xCzDYtkMA9Rg=;
        b=RLWu+ZL6EweKjkwpCtOjrp9INJLe5dvrNcbGvE4WGdRT4TccARg6+ieswKX08KPmqS
         x9PihaLCOUk5qJHICrZbiBCxiM147Jh2TLzexzmdhMHPsAy965w2Sk4qIhUOpQykqzgr
         aWHffmvjzTM3u/rlDn42mUxcLS+Rl2xSN+l2QRZmhcgLoDcrpyFkU753c2c0dCUxlNHa
         ToLXul+BF6qanjR5FhTeUrUNrvOatGrsiPiiS8eRi7ScQFvtp92MnncQD3ODiM68B2Of
         Ci/CFFlcj4Kb3j2xZjYeNbPTR/yi4qbUj7D0MuKpcy1eoJgK70g8eKFu52ViypFF0lAK
         zbiw==
X-Gm-Message-State: AOAM531tjDpuB0HGgK+2T5K3h/mFdiKtcVcHluiGjqcpzeq8dETKTw9L
        96ogPz9dlqEfv936Le28hOhy9SUhp5yUKw==
X-Google-Smtp-Source: ABdhPJwYniqzOAOYAAenGS65Eqv7GMPJY+hmQfHyrmV7ojMrw4N7WzR4zJ9nLasof91xK6K+eyorQw==
X-Received: by 2002:a05:6512:228a:: with SMTP id f10mr890373lfu.412.1611431980114;
        Sat, 23 Jan 2021 11:59:40 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:39 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 12/16] gtp: update rx_length_errors for abnormally short packets
Date:   Sat, 23 Jan 2021 20:59:12 +0100
Message-Id: <20210123195916.2765481-13-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on work by Pravin Shelar.

Update appropriate stats when packet transmission isn't possible.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
---
 drivers/net/gtp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 023d38b1098d..7ab8540e46d2 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -185,8 +185,10 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 {
 	/* Get rid of the GTP + UDP headers. */
 	if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
-				 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
-		return -1;
+			 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev)))) {
+		pctx->dev->stats.rx_length_errors++;
+		goto err;
+	}
 
 	netdev_dbg(pctx->dev, "forwarding packet from GGSN to uplink\n");
 
@@ -202,6 +204,10 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 
 	netif_rx(skb);
 	return 0;
+
+err:
+	pctx->dev->stats.rx_dropped++;
+	return -1;
 }
 
 /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated. */
-- 
2.27.0

