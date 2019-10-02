Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF68BC8C17
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfJBOxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:53:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46641 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfJBOxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:53:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so19981741wrv.13;
        Wed, 02 Oct 2019 07:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PYXzXb3OB7jSZRuNVFj0gMlw+CgNdBWs0kruPSOz3YU=;
        b=Y42LNP0XJQuHhLOObBXx50wVAVYVAqA4jT5EERcF98mMSZcEyfi4nWX66O78ecHVa/
         X/aHwLin9XQG0LxUFaajZBRTFXPZls45G4bxyfsY1Im6amFPOPZaoI+7+IWcbfhdrSTo
         9WJB5p8qJo4Nzog7Do0MXeXPMCfSMK3MOdIQtdMqbSYwQiikzc2jeih5FLt/qErOirkv
         FMUmMP2H595ZkrDZH3XorUd3f7Aqc2yXw8FRkkP+2rG0io/j6WZNLGy4ERxv5/OzVQ82
         Mp1m6jLs8NxULkyCLMWOudkKDvgwy++f0EQMqs/pxii2lIYPNedpsWUyOqKH5gXrAqny
         wuRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PYXzXb3OB7jSZRuNVFj0gMlw+CgNdBWs0kruPSOz3YU=;
        b=h/o39HMEbqxO8RqJEpZr9GwhVb019i1/YbfjhvtehqCERVLR2oab3vQsQUFmyYfYCO
         OJMz/X0zDDTobB5UqWYrm/0KPqzWrDE3O4OV9hFRKJctDEdue3LSyI9VHzpBlQ3OZY/P
         L51wWJ+rOf8wY2q84Gp84Yn2E5WMsJ2DfIY49a7wKsNFd+3DfGZ8BPqwyOjkXE7RFjXU
         qrgNLfG188klSoRBiSvUGR/P+XpD/PBekhrECRR6OcA3brSiLVrF4LQB4x7XKvmQ8hv7
         /V/o+yQiYMg+HPMTA0LImMqGmIIvGOpz32RXp8tATDO5SPcNNr6sa8ljaj6bC7JVycXV
         CutQ==
X-Gm-Message-State: APjAAAXZRnwUoFjP1O490vPa9h1crrEqBsbjnxn5miICxKrUiMUkmQgd
        ieTUi74rWO4QBXqgJLdGrmU=
X-Google-Smtp-Source: APXvYqzuhOs5vzF/CINZB2NMdU92KduN02xM2AGJ2sH5fWCMdQaPvFWCrCKD48ey6OVJBBLYH8ELLQ==
X-Received: by 2002:a5d:4ecf:: with SMTP id s15mr2968739wrv.234.1570027983243;
        Wed, 02 Oct 2019 07:53:03 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id f8sm4307736wmb.37.2019.10.02.07.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 07:53:02 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH net-next v4 1/2] net: stmmac: Only enable enhanced addressing mode when needed
Date:   Wed,  2 Oct 2019 16:52:57 +0200
Message-Id: <20191002145258.178745-2-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002145258.178745-1-thierry.reding@gmail.com>
References: <20191002145258.178745-1-thierry.reding@gmail.com>
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
Changes in v4:
- enable EAME only if DMA addresses can be larger than 32 bits

 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 5 ++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 7 +++++++
 include/linux/stmmac.h                             | 1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 965cbe3e6f51..7cc331996cd8 100644
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
index c76a1336a451..b8ac1744950e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4515,6 +4515,13 @@ int stmmac_dvr_probe(struct device *device,
 		if (!ret) {
 			dev_info(priv->device, "Using %d bits DMA width\n",
 				 priv->dma_cap.addr64);
+
+			/*
+			 * If more than 32 bits can be addressed, make sure to
+			 * enable enhanced addressing mode.
+			 */
+			if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
+				priv->plat->dma_cfg->eame = true;
 		} else {
 			ret = dma_set_mask_and_coherent(device, DMA_BIT_MASK(32));
 			if (ret) {
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index dc60d03c4b60..86f9464c3f5d 100644
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

