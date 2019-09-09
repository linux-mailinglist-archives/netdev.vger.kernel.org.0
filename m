Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4166BADC0E
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 17:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbfIIPZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 11:25:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36096 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfIIPZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 11:25:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so14340612wrd.3;
        Mon, 09 Sep 2019 08:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PYRjHANJ0MWxLPIUwtgxGbxSiQPDnOdCGXrlF6OG6sU=;
        b=Xba/LdxzCdbiBnw4o//u2wrwkAcNGGpNbu3GOwEJ2dM11KLIXM6Hk92xL17HHYhIXu
         cYqGN5fh1sKgWA+71tXOLqpSdSAYedFaVACd7fcQGVKs72kCrDAabx46D6H6pm04K7jH
         f3ToY179K8Pr85/2tLj/7A+0xV+6mxc/FIzRxJNZxBsS5hhJb7C9pbHAXBSvqPxSWGoY
         E5i9f6WUdmJH4kiPy3c6T2u+gMLhsCY/r7YsUVpZo2LjoHYsLgDE3EJ2/du8ukBnzmPj
         +c5t5FWBbyAxH+V7s6v9vDZq3yeQv4AD6dNuxyZ58kBJcu+kRyL1QbkeaU7To2RPhmwN
         a4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PYRjHANJ0MWxLPIUwtgxGbxSiQPDnOdCGXrlF6OG6sU=;
        b=tqdn+cFEZQBURqAMnWt5FD5IMPryzXi8YplctD0zypNDKeCuvDL6Tfb1Zy7x5y8zsJ
         lVheyjf8EY6929PKIF15sNX1ZUn/NDQtBxmoPCbDYmYtfAr+9wllOSUAWGvHIg3D2x12
         2rlxnDbqGlv4gJioTVrp1tOoHLP87U3uy71VOLO3qne4RdYoOJVdvVsfziF0/brk1XPm
         R4U3Ul2P5ZT3wYBpgD6FfS+NnMdHVw5syCoJBCP+jssKHsJIiSyxriFAedqKP8j12+o8
         12v2pi3jO3dpnO3iDWsFHq0s96D04sLB4Hqs0t4cAUI2LVZKzV9uEoI23wyNUOvBLvuX
         OjcA==
X-Gm-Message-State: APjAAAWJoSuHontGEpS5YQpfz3WdSK9MFxr+1vCaByun0xqXcyu7lt+S
        hDYq7Ratr9s9CdQNym9lXww=
X-Google-Smtp-Source: APXvYqzYRPmTs0f5GTR3GZSoUbSpD/6B4sqbBH9uCCkdVwBa6jhvtcmD14gGj1iHn6ASOLTM9oXmmA==
X-Received: by 2002:adf:fe07:: with SMTP id n7mr19719899wrr.90.1568042748832;
        Mon, 09 Sep 2019 08:25:48 -0700 (PDT)
Received: from localhost (p2E5BE0B8.dip0.t-ipconnect.de. [46.91.224.184])
        by smtp.gmail.com with ESMTPSA id v4sm23419801wrg.56.2019.09.09.08.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 08:25:47 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH net-next v2 1/2] net: stmmac: Only enable enhanced addressing mode when needed
Date:   Mon,  9 Sep 2019 17:25:45 +0200
Message-Id: <20190909152546.383-1-thierry.reding@gmail.com>
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

