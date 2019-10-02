Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0F4C8C19
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfJBOxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:53:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37336 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfJBOxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:53:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id f22so7321022wmc.2;
        Wed, 02 Oct 2019 07:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uOeMC9QJIgmJhWdw1hsRV5m6zhZBnDGlsT9nxsYcYJk=;
        b=pMgw2egXlzrLRfNFrUyfhT7jsxzZI7o8OKtq+Q/3dJOl0qS5MV5jmngfJa/rJDFDXc
         QcgASrbA43oudaxaVpB0qHwu+vcRkpPc2nlp/0Bt/5B8Vp44sGp8s0N8R6nT8Z05w5R7
         EZZD1VYXezqauOjFptj2v5oebfwdvUqCB90x+OiuXb/Z972gf5Si3auCpJkCz6IjoA1K
         9is/+aVTnr9qHNIguhVJOMXutU7dFjHeUTEtQN/GqKYklQIxDBUftOVJ2TwZZvvBx/U+
         +5KbyjkZ1LQvGWEnMHdjE4DXwHKiE0AA0rbM+veIMJT2s5JMQ4IwJoCVU+zP74G4G1h6
         v0TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uOeMC9QJIgmJhWdw1hsRV5m6zhZBnDGlsT9nxsYcYJk=;
        b=VmGt9WhJAmx3IzNrWVsOdQkSNZOfRPLByzd+9el31I2FZJArYz56QSvY9YmcdEPXZW
         xTDg1WQQWIh7+KhmhyvjI3Vs5IkNIrJijc3gg2FDGMUxGPSGKITVLelInbT04VkXfK0c
         7ujvIXFntS4hrn4/KDS+4mK3rfvYRJbgNmFje6pDUv7RMzdnznOI1aSblQIoa4+JBcdg
         0N1yHvY3VrqxMwWOwS99WlkFw9VKV1MOZG7SJKgk4k8EEIeoAFANiFrp95i1Gfm/kRp/
         ssOeGNibQkm5lemErfGGauBjacA4bbpnzW1X4/j++9L6DPmgzC4XI0r0KAezMIzb3XkO
         VZ/A==
X-Gm-Message-State: APjAAAXwZa0XgqHh2Fr1gWb13fT0fQFXmdeo8UcOHMRRHT+xB0LSD1GB
        Hkd5JhEBl+lRHaBVUVv4Brc=
X-Google-Smtp-Source: APXvYqwrriSwRm56050U2yAevLz1JguR/SlQ20I3rFbvPtrmoOEXZWSMK+qhly90EExj1lAw85bXTg==
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr3137029wmc.167.1570027986301;
        Wed, 02 Oct 2019 07:53:06 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id d4sm20998554wrq.22.2019.10.02.07.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 07:53:04 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH net-next v4 2/2] net: stmmac: Support enhanced addressing mode for DWMAC 4.10
Date:   Wed,  2 Oct 2019 16:52:58 +0200
Message-Id: <20191002145258.178745-3-thierry.reding@gmail.com>
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

The address width of the controller can be read from hardware feature
registers much like on XGMAC. Add support for parsing the ADDR64 field
so that the DMA mask can be set accordingly.

This avoids getting swiotlb involved for DMA on Tegra186 and later.

Also make sure that the upper 32 bits of the DMA address are written to
the DMA descriptors when enhanced addressing mode is used. Similarily,
for each channel, the upper 32 bits of the DMA descriptor ring's base
address also need to be programmed to make sure the correct memory can
be fetched when the DMA descriptor ring is located beyond the 32-bit
boundary.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v4:
- only write upper 32 bits when necessary

Changes in v3:
- unconditionally write upper 32 bits

Changes in v2:
- also program the upper 32 bits of the DMA descriptor base address for
  each channel

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  1 +
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  4 +--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 28 +++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  3 ++
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 89a3420eba42..2fe45fa3c482 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -205,6 +205,7 @@ enum power_event {
 #define GMAC_HW_HASH_TB_SZ		GENMASK(25, 24)
 #define GMAC_HW_FEAT_AVSEL		BIT(20)
 #define GMAC_HW_TSOEN			BIT(18)
+#define GMAC_HW_ADDR64			GENMASK(15, 14)
 #define GMAC_HW_TXFIFOSIZE		GENMASK(10, 6)
 #define GMAC_HW_RXFIFOSIZE		GENMASK(4, 0)
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index 15eb1abba91d..707ab5eba8da 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -431,8 +431,8 @@ static void dwmac4_get_addr(struct dma_desc *p, unsigned int *addr)
 
 static void dwmac4_set_addr(struct dma_desc *p, dma_addr_t addr)
 {
-	p->des0 = cpu_to_le32(addr);
-	p->des1 = 0;
+	p->des0 = cpu_to_le32(lower_32_bits(addr));
+	p->des1 = cpu_to_le32(upper_32_bits(addr));
 }
 
 static void dwmac4_clear(struct dma_desc *p)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 68c157979b94..229059cef949 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -79,6 +79,10 @@ static void dwmac4_dma_init_rx_chan(void __iomem *ioaddr,
 	value = value | (rxpbl << DMA_BUS_MODE_RPBL_SHIFT);
 	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
 
+	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) && likely(dma_cfg->eame))
+		writel(upper_32_bits(dma_rx_phy),
+		       ioaddr + DMA_CHAN_RX_BASE_ADDR_HI(chan));
+
 	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_CHAN_RX_BASE_ADDR(chan));
 }
 
@@ -97,6 +101,10 @@ static void dwmac4_dma_init_tx_chan(void __iomem *ioaddr,
 
 	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
 
+	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) && likely(dma_cfg->eame))
+		writel(upper_32_bits(dma_tx_phy),
+		       ioaddr + DMA_CHAN_TX_BASE_ADDR_HI(chan));
+
 	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_CHAN_TX_BASE_ADDR(chan));
 }
 
@@ -132,6 +140,9 @@ static void dwmac4_dma_init(void __iomem *ioaddr,
 	if (dma_cfg->aal)
 		value |= DMA_SYS_BUS_AAL;
 
+	if (dma_cfg->eame)
+		value |= DMA_SYS_BUS_EAME;
+
 	writel(value, ioaddr + DMA_SYS_BUS_MODE);
 }
 
@@ -356,6 +367,23 @@ static void dwmac4_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->hash_tb_sz = (hw_cap & GMAC_HW_HASH_TB_SZ) >> 24;
 	dma_cap->av = (hw_cap & GMAC_HW_FEAT_AVSEL) >> 20;
 	dma_cap->tsoen = (hw_cap & GMAC_HW_TSOEN) >> 18;
+
+	dma_cap->addr64 = (hw_cap & GMAC_HW_ADDR64) >> 14;
+	switch (dma_cap->addr64) {
+	case 0:
+		dma_cap->addr64 = 32;
+		break;
+	case 1:
+		dma_cap->addr64 = 40;
+		break;
+	case 2:
+		dma_cap->addr64 = 48;
+		break;
+	default:
+		dma_cap->addr64 = 32;
+		break;
+	}
+
 	/* RX and TX FIFO sizes are encoded as log2(n / 128). Undo that by
 	 * shifting and store the sizes in bytes.
 	 */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index b66da0237d2a..5299fa1001a3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -65,6 +65,7 @@
 #define DMA_SYS_BUS_MB			BIT(14)
 #define DMA_AXI_1KBBE			BIT(13)
 #define DMA_SYS_BUS_AAL			BIT(12)
+#define DMA_SYS_BUS_EAME		BIT(11)
 #define DMA_AXI_BLEN256			BIT(7)
 #define DMA_AXI_BLEN128			BIT(6)
 #define DMA_AXI_BLEN64			BIT(5)
@@ -91,7 +92,9 @@
 #define DMA_CHAN_CONTROL(x)		DMA_CHANX_BASE_ADDR(x)
 #define DMA_CHAN_TX_CONTROL(x)		(DMA_CHANX_BASE_ADDR(x) + 0x4)
 #define DMA_CHAN_RX_CONTROL(x)		(DMA_CHANX_BASE_ADDR(x) + 0x8)
+#define DMA_CHAN_TX_BASE_ADDR_HI(x)	(DMA_CHANX_BASE_ADDR(x) + 0x10)
 #define DMA_CHAN_TX_BASE_ADDR(x)	(DMA_CHANX_BASE_ADDR(x) + 0x14)
+#define DMA_CHAN_RX_BASE_ADDR_HI(x)	(DMA_CHANX_BASE_ADDR(x) + 0x18)
 #define DMA_CHAN_RX_BASE_ADDR(x)	(DMA_CHANX_BASE_ADDR(x) + 0x1c)
 #define DMA_CHAN_TX_END_ADDR(x)		(DMA_CHANX_BASE_ADDR(x) + 0x20)
 #define DMA_CHAN_RX_END_ADDR(x)		(DMA_CHANX_BASE_ADDR(x) + 0x28)
-- 
2.23.0

