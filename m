Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0622F30D3E2
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhBCHJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhBCHIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:08:51 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0E8C0613D6
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 23:08:11 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id i187so31792600lfd.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 23:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Axi2g6I6F47I8bzDu1p5LN7RII40A/s6odd4OB1z8JY=;
        b=PRJkzgszSPpSal7lG0hQCVC6EvhDr0dotAYPYUduntwNeUL/6ksIHgRuNxlxdpopzq
         jhMXKo6KeylJAusUNFihrRxAiSlP5QMKKbg5oeCpO5w2epwmLizsOBdHhtYGYvb+sHER
         OZLXFvZdZ5kioqHsxky6VE7lwyZifOfZpEaAEAOxYJytSa1+1SiGcBETXfLAXklRKatW
         Fe4kWtmip6MSroIZXYYCyqBJmCEsiKr0m5wvmhwo0QB/sGOjS92WoSkJOQPoh8SdFBS8
         wsW1bVHj15wjvSr4GAuVBeXl0W+mSmLTQxkru/MTHl1w+eyyP3qxlS5AMSl9g6hRCea1
         j1DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Axi2g6I6F47I8bzDu1p5LN7RII40A/s6odd4OB1z8JY=;
        b=g+vFNEATjZoqmHuzTQRWFC6noas0U5kq1gvIDvfP6pRnnpAodYby9LZU02/yjIx5sV
         OvMRU1c3YHgMBXLuBkKBYQvHsJrh2DvddJPtWRGhC7Ei0I/4C/W0lfhKTlave+f5duV5
         ruXO8K1NFfWaZEpWFpvNovCMlLFR/ejKEHFVqlBa+TP1a9Ju59I1N32HCAdL8v0r/Ck+
         cxT2yn549P/2uICyRF4oIJGHuX/oazR/wFTBIQApmIaQ8XqNsRIlGP/SpukvfP1JyHFO
         nfMkxR0z4QL2dpEFQaKSkX0zZOmSPHINyaBgkdUFqc3xehTL8w0nKVCK5qJTx3ahWT9S
         +geg==
X-Gm-Message-State: AOAM532c+rPivr5pqJCQOUYEjKAJ8bMPeZRMLbfsUOpP444QXrNiE0az
        49cR8+epew8KUh/ws0CgZF3pog==
X-Google-Smtp-Source: ABdhPJyePV3Wi4Ej9ZkKm6ASV9ekVh7KdknMQ+ziOG0eTO4u/2LtsWpz7MQR8Lcx40+7PtFz5/xDvg==
X-Received: by 2002:a19:4f4f:: with SMTP id a15mr1003458lfk.309.1612336089831;
        Tue, 02 Feb 2021 23:08:09 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id d3sm147367lfg.122.2021.02.02.23.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 23:08:09 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, kuba@kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Cc:     Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 2/7] gtp: set initial MTU
Date:   Wed,  3 Feb 2021 08:08:00 +0100
Message-Id: <20210203070805.281321-3-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210203070805.281321-1-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
 <20210203070805.281321-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GTP link is brought up with a default MTU of zero.  This can lead to
some rather unexpected behaviour for users who are more accustomed to
interfaces coming online with reasonable defaults.

This patch sets an initial MTU for the GTP link of 1500 less worst-case
tunnel overhead.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 4c04e271f184..5a048f050a9c 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -612,11 +612,16 @@ static const struct net_device_ops gtp_netdev_ops = {
 
 static void gtp_link_setup(struct net_device *dev)
 {
+	unsigned int max_gtp_header_len = sizeof(struct iphdr) +
+					  sizeof(struct udphdr) +
+					  sizeof(struct gtp0_header);
+
 	dev->netdev_ops		= &gtp_netdev_ops;
 	dev->needs_free_netdev	= true;
 
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
+	dev->mtu = ETH_DATA_LEN - max_gtp_header_len;
 
 	/* Zero header length. */
 	dev->type = ARPHRD_NONE;
@@ -626,11 +631,7 @@ static void gtp_link_setup(struct net_device *dev)
 	dev->features	|= NETIF_F_LLTX;
 	netif_keep_dst(dev);
 
-	/* Assume largest header, ie. GTPv0. */
-	dev->needed_headroom	= LL_MAX_HEADER +
-				  sizeof(struct iphdr) +
-				  sizeof(struct udphdr) +
-				  sizeof(struct gtp0_header);
+	dev->needed_headroom	= LL_MAX_HEADER + max_gtp_header_len;
 }
 
 static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize);
-- 
2.27.0

