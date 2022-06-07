Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D775853FA2E
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbiFGJs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240047AbiFGJsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:48:22 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6783D02BD
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 02:48:20 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id p10so23341002wrg.12
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 02:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=flkxolnPRJ/fuZI8sau+S8LRxDQCGOpfvcgrJTeckZE=;
        b=Iqu6UNp7gSNd70V5LQt4JGyekjdaLPSRtvVkcjkxJM3ev6IH4ZfqyXfFTsVVCEBCRo
         n/D5xOUWT9XepBqui6E3cPm5nvsR7cM9ZQunaiDCPtdQaj92yIRIteiETA79F7+rLe5a
         GYEy0bqoYg9i+vpD7i+37FTf55tOoE21SrcRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=flkxolnPRJ/fuZI8sau+S8LRxDQCGOpfvcgrJTeckZE=;
        b=5CaYGLsOcj2QlY8Q3CByZ6jY788Uqv6fGYhDlYTUNoZmjkrNntIJ/NAkCAW7ZRZap5
         scdnA3OH9LOL7mbQwaFy/R366GcB7U0DgJX0MJ8CqIeogNPT1JEzPkS9gxhDClpBKnRd
         tNL/bA0vHkjW9XDj9e9jOKv636lJUFZnXmBu/xRN4nhDp9Trc0dQWVtGu6c1SaIQKaX9
         7gGnXeAophIBB9Z0G5PMIH5uktEHHXy662tiVr1u8Utubd7VUuFlHJQtyRq2SDTKay8X
         rubJbMPuy/hHBmrUSuX67JyjlDgQ8Vg1JAL2ZCscnLwbHXca7S2jcbaNGQyLzxYWd1yx
         RgMQ==
X-Gm-Message-State: AOAM533SpzF1Wa3T2UzqLHEO/vxiS45CEyGf5A8NXm8JDe7iwzgvgZzU
        wspJZV+TYqWACxtLrXRLs318Tg==
X-Google-Smtp-Source: ABdhPJzHbCnZaZHUa2S03DdkpuF1cqiLPhaMOJ7rxFM4D3lWaRojBPoOkqBBLoCUhUp5W0HBSPROwg==
X-Received: by 2002:a05:6000:186b:b0:20f:e2e5:f95f with SMTP id d11-20020a056000186b00b0020fe2e5f95fmr27169097wri.76.1654595299453;
        Tue, 07 Jun 2022 02:48:19 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.pdxnet.pdxeng.ch (mob-5-90-137-51.net.vodafone.it. [5.90.137.51])
        by smtp.gmail.com with ESMTPSA id o4-20020a05600c510400b0039748be12dbsm23200547wms.47.2022.06.07.02.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:48:18 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 05/13] can: slcan: simplify the device de-allocation
Date:   Tue,  7 Jun 2022 11:47:44 +0200
Message-Id: <20220607094752.1029295-6-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since slcan_devs array contains the addresses of the created devices, I
think it is more natural to use its address to remove it from the list.
It is not necessary to store the index of the array that points to the
device in the driver's private data.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

 drivers/net/can/slcan.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 956b47bd40a7..4df0455e11a2 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -428,11 +428,17 @@ static int slc_open(struct net_device *dev)
 
 static void slc_dealloc(struct slcan *sl)
 {
-	int i = sl->dev->base_addr;
+	unsigned int i;
 
-	free_candev(sl->dev);
-	if (slcan_devs)
-		slcan_devs[i] = NULL;
+	for (i = 0; i < maxdev; i++) {
+		if (sl->dev == slcan_devs[i]) {
+			free_candev(sl->dev);
+			slcan_devs[i] = NULL;
+			return;
+		}
+	}
+
+	pr_err("slcan: can't free %s resources\n",  sl->dev->name);
 }
 
 static int slcan_change_mtu(struct net_device *dev, int new_mtu)
@@ -529,7 +535,6 @@ static struct slcan *slc_alloc(void)
 
 	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
 	dev->netdev_ops = &slc_netdev_ops;
-	dev->base_addr  = i;
 	sl = netdev_priv(dev);
 
 	/* Initialize channel control data */
-- 
2.32.0

