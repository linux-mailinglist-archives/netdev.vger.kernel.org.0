Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9CD5451BC
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 18:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244053AbiFIQUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 12:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244267AbiFIQUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 12:20:14 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5AB6270
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 09:20:13 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id e5so5841595wma.0
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 09:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Whjtm+NzJ64CjyHkQo9F4vQU/4mCjqkXj8LiHuhAtLs=;
        b=d2Zb4+hY+8t0KtqXJMf7D8CRfxwD+FcWcTkqE80lbnqpsCCuUVk03wT3lxUNwZEeBO
         wpzPWgJlNEx2tbYg6kBqeye1S/ySiR2RQ1QPbHAyJFfwoaYaci/p5jXDlSAJ8ktupj8r
         qXR18cnsCHVEc4UoY9hIbINkld45Qpmj14ffIpBO1lred/sHyRcd5VM9NTiOwwlBERfJ
         XCfqVjhdzEmZesBh9Xbmb5R/iY2BaYWmFyg340htrU5HcWoIWkky6nQxFD05gIwGiQWh
         pUMaOq7MCYzSmJyuP2SBRyWyfpFbz8KT0K4vpNJAG/EglaMhKspe90mC1GpFNGnst/ni
         8OkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Whjtm+NzJ64CjyHkQo9F4vQU/4mCjqkXj8LiHuhAtLs=;
        b=cCVlMss5aBY5d1D1wLD4wvd1qSZwmosG+ZNusuVPGCj1uex+UyEZrGzlJSBihUdCca
         pBnQWvpjm1g91RY91NA4rzFJBaUy2pLjBc/e/0DSQH1wrzW4POLGii8HcmABowNAG9gY
         SoTkpvaq20n6PzGM/DEWNAF6jFqr9zAu/vghMgKvGd18wCaPwt8LPZ9YluYp+btmJOTD
         GcuQi6ypw6jU1GSd2SrHuMZsr+EWGd+qfmr96+RGmChhOSubTsGQKZNKTTpz/QAkYNt3
         5kaIySF5GuJT28mkKGBrdam6+E1sVSpsXRweE3P+O/EtmDMYR+dIOCQMTnI2PnFyIHyf
         SP/A==
X-Gm-Message-State: AOAM533zcNGmjepgeWyJq0aGPEi5EM8hIXcvKKBvKhR+LPx9NuOpdgyM
        ZPhadV4NVHnlgYx3E8eeU3Nk+ORMw91Q5g==
X-Google-Smtp-Source: ABdhPJzOuYuTxxPkxpnwF17Rvlh5ov4KNd4hciotHtaciYL3jl5Jj86PsHOGic+nCVLYt7XCTZ1iWw==
X-Received: by 2002:a05:600c:3495:b0:39c:6a72:f286 with SMTP id a21-20020a05600c349500b0039c6a72f286mr4201092wmq.116.1654791611959;
        Thu, 09 Jun 2022 09:20:11 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id g20-20020a05600c4c9400b0039749b01ea7sm32222382wmp.32.2022.06.09.09.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 09:20:11 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     thomas.lendacky@amd.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     robh@kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        maz@kernel.org, netdev@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH] amd-xgbe: Use platform_irq_count()
Date:   Thu,  9 Jun 2022 17:14:59 +0100
Message-Id: <20220609161457.69614-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AMD XGbE driver currently counts the number of interrupts assigned
to the device by inspecting the pdev->resource array. Since commit
a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT
core") removed IRQs from this array, the driver now attempts to get all
interrupts from 1 to -1U and gives up probing once it reaches an invalid
interrupt index.

Obtain the number of IRQs with platform_irq_count() instead.

Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-platform.c b/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
index 4ebd2410185a..4d790a89fe77 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
@@ -338,7 +338,7 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 		 *   the PHY resources listed last
 		 */
 		phy_memnum = xgbe_resource_count(pdev, IORESOURCE_MEM) - 3;
-		phy_irqnum = xgbe_resource_count(pdev, IORESOURCE_IRQ) - 1;
+		phy_irqnum = platform_irq_count(pdev) - 1;
 		dma_irqnum = 1;
 		dma_irqend = phy_irqnum;
 	} else {
@@ -348,7 +348,7 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 		phy_memnum = 0;
 		phy_irqnum = 0;
 		dma_irqnum = 1;
-		dma_irqend = xgbe_resource_count(pdev, IORESOURCE_IRQ);
+		dma_irqend = platform_irq_count(pdev);
 	}
 
 	/* Obtain the mmio areas for the device */
-- 
2.36.1

