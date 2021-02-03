Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D749D30D3E7
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhBCHJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhBCHJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:09:35 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D7EC06178B
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 23:08:15 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id e18so27058505lja.12
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 23:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pZGVcxEVCheiG0wA/Yq7OXQtrC7VpDVqrb8lgaXPAlI=;
        b=CJNkmrlxCA31zUIsKLsM306hmb13GPfZlnxgG+g/SAyjuw6A6KxnNXFhmKYNSkkFtP
         FRput2SQdyeubp5rFRcoICgCST7RfknowFFmjfTO0q4pAgO3qIPr/X6fpaF5xuwPeGKD
         uLGHtz0Ahle/Iy6n8xLGNm+mxdx66EsxeNO0OfYVI8nJUCZtvbpgNX3PsinDG2FQXm8n
         6ushkqWIhp3kRzv3uBcvbnlNg2dXnKTbmDiDxTtRpeUlk9GcEZjA6zD+Q9nwBQ/5rIDK
         QcDQGiHeBRloeJ34EGeywYUQzKrBDAPVUqnNkHWKstHkYka2qmb7fPDgvpJKpv8E/I8U
         RApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pZGVcxEVCheiG0wA/Yq7OXQtrC7VpDVqrb8lgaXPAlI=;
        b=t0XY72ztIDxitLI9sWl2VKzdVx3WbwSRzRPwLnq2n1i6XfaR3Ntp+8XINK/ioP1QxD
         SzdH3u7kdD4+BfIopx7SMKy/6NgOcv19hcaobW2J9de0vQU2JGWEueiDHZ2Yz1UHVoXN
         f3yTnx2ns1V0Xcooz+ECMiyJXhU7/5p0h20rs8s1gnxcZGhbNcBBAekADBdsX6Q8T1sl
         BYA0Nk/4XqijbBvpv69KTq/lR/rDMrnpmvRHql50M4C87mDRfjMjCfmbMxEircTeYuK4
         A+k0aO2CBtPOWnuatztzCXFmSH9I1OrkLbVrLIn6EM5OBisM7x9a7yUDE4FZT5RcB7X1
         Jdbw==
X-Gm-Message-State: AOAM532ps5g2XzsC2cb9aMu/6ICDcDXswnLUc/ktvkbZzRuFhq8U3leP
        aN09BAhHgJ3W87IlmxFzP1yLw1zDpDW5nA==
X-Google-Smtp-Source: ABdhPJzu0HWiD0XoBkisDW4TuItdQssRfnHATxF8DhqstVLDpZik13MZ+7Kw0gjDbkHONSBZ3aOhcg==
X-Received: by 2002:a2e:3a18:: with SMTP id h24mr958225lja.170.1612336093800;
        Tue, 02 Feb 2021 23:08:13 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id d3sm147367lfg.122.2021.02.02.23.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 23:08:13 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 7/7] gtp: update rx_length_errors for abnormally short packets
Date:   Wed,  3 Feb 2021 08:08:05 +0100
Message-Id: <20210203070805.281321-8-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210203070805.281321-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
 <20210203070805.281321-1-jonas@norrbonn.se>
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
index a1bb02818977..9a70f05baf6e 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -189,8 +189,10 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 
 	/* Get rid of the GTP + UDP headers. */
 	if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
-				 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
-		return -1;
+			 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev)))) {
+		pctx->dev->stats.rx_length_errors++;
+		goto err;
+	}
 
 	netdev_dbg(pctx->dev, "forwarding packet from GGSN to uplink\n");
 
@@ -206,6 +208,10 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 
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

