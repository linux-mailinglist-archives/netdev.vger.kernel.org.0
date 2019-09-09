Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8697AD91C
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 14:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732334AbfIIMgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 08:36:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36892 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbfIIMgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 08:36:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id r195so14498914wme.2;
        Mon, 09 Sep 2019 05:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PYRjHANJ0MWxLPIUwtgxGbxSiQPDnOdCGXrlF6OG6sU=;
        b=WdFt362u4jzsvbk5AUtRXRenlSi38z8ZgVqz1ds4aP3mhjy5WEpFv7TiNeimtIhLiP
         Y1LyUEANor0f71srl8vyr6eU8JrbfkFqbV3Oc1p0vkq47LaOLZVySYBXKQvMRIRHnmNJ
         0eE0AHA7BJtSEYAWtIIviDSj1Y6tgnUYiAmwy5cIYpMij9TLyeimWGHaZtCYfuwF8lc5
         emrrGEVpU1xxKfPCeC/HyYhQOClhnzGpECSi5wgoJIlW/6WtWIi13qjDIUOXvSnkzGqA
         g8DsGfvXpWkNwJ0HfzWkVPaPhlhKzA7P8meuPuhmViyyOYj8gd5K9HmM8Nty9As/1Hmz
         jQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PYRjHANJ0MWxLPIUwtgxGbxSiQPDnOdCGXrlF6OG6sU=;
        b=HHsT01gQE4pbJzk7AXEiwT45JEooD3b7alHuT8/4tWhMbXp1xdBUVPkFsd3iYGm5A5
         sEm9IA1CJn16qCQjgQbzUZt5AzkEPLLYSdNRBOYGd1Omewhcedg8UMzIsoofFSgG2MMS
         T+QZUCfTVD7aFmqSbaK+8IbXhg6NbzhHoxroNyjeW3Pgdtp+mzgSd0MlKUEN7WIBT3gV
         P3P9hULTNo90E9fMCPTVvhN2cEqTarQdMkGIlJOaU4keVYH6Yu5xL41zNMTYb6sUqL6B
         8oSvYbYh/FyI+2w6W1ggjsOQPK2COPXm0FA1ml82yUCKRL0G9iqVDva41HCuEIgW5acV
         DJfA==
X-Gm-Message-State: APjAAAV43pz/vw4ggBoCX0oJcfr8klgM3OTXbd7RlJzVnX3spfqSaJTy
        9eUCRv1y1MrwM5Ey3NEVTWU=
X-Google-Smtp-Source: APXvYqyddUfFzjWkkHQPwKKSFHQvw+GSYYg7TOjO89wXzlNt2fOwfUS7oLiOGvS/XYDFjMvB5Y74ZA==
X-Received: by 2002:a1c:7c15:: with SMTP id x21mr20234513wmc.154.1568032589293;
        Mon, 09 Sep 2019 05:36:29 -0700 (PDT)
Received: from localhost (p2E5BE0B8.dip0.t-ipconnect.de. [46.91.224.184])
        by smtp.gmail.com with ESMTPSA id c74sm13808348wme.46.2019.09.09.05.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 05:36:28 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH net-next 1/2] net: stmmac: Only enable enhanced addressing mode when needed
Date:   Mon,  9 Sep 2019 14:36:26 +0200
Message-Id: <20190909123627.29928-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Enhanced addressing mode is only required when more than 32 bits need to
be addressed. Add a DMA configuration parameter to enable this mode only
when needed.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 5 ++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 6 ++++++
 include/linux/stmmac.h                             | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 64956465c030..3e00fd8befcf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -27,7 +27,10 @@ static void dwxgmac2_dma_init(void __iomem *ioaddr,
 	if (dma_cfg->aal)
 		value |= XGMAC_AAL;
 
-	writel(value | XGMAC_EAME, ioaddr + XGMAC_DMA_SYSBUS_MODE);
+	if (dma_cfg->eame)
+		value |= XGMAC_EAME;
+
+	writel(value, ioaddr + XGMAC_DMA_SYSBUS_MODE);
 }
 
 static void dwxgmac2_dma_init_chan(void __iomem *ioaddr,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 06ccd216ae90..ecd461207dbc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4497,6 +4497,12 @@ int stmmac_dvr_probe(struct device *device,
 		if (!ret) {
 			dev_info(priv->device, "Using %d bits DMA width\n",
 				 priv->dma_cap.addr64);
+
+			/*
+			 * If more than 32 bits can be addressed, make sure to
+			 * enable enhanced addressing mode.
+			 */
+			priv->plat->dma_cfg->eame = true;
 		} else {
 			ret = dma_set_mask_and_coherent(device, DMA_BIT_MASK(32));
 			if (ret) {
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 7ad7ae35cf88..d300ac907c76 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -92,6 +92,7 @@ struct stmmac_dma_cfg {
 	int fixed_burst;
 	int mixed_burst;
 	bool aal;
+	bool eame;
 };
 
 #define AXI_BLEN	7
-- 
2.23.0

