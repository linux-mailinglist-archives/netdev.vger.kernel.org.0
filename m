Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD907367B92
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 09:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhDVH4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 03:56:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:8505 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235199AbhDVH4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 03:56:17 -0400
IronPort-SDR: IWQTsdUBrYA6/ki/gn5aJzgS3H7+R0qNn6RiAYXMQTQwlvbSHpf84zpYZR02SGnogWDfIGvqVj
 olI3QptfVNyw==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="195956901"
X-IronPort-AV: E=Sophos;i="5.82,241,1613462400"; 
   d="scan'208";a="195956901"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 00:55:26 -0700
IronPort-SDR: 3yacpQxB6L/NSiXSXupZf+23nvxDoTzQMn3FoyJZZGun3pgzQW53tfxRS+IK+NkcG9RcrkxDH6
 NYhxm/Uu61NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="421282393"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.82])
  by fmsmga008.fm.intel.com with ESMTP; 22 Apr 2021 00:55:22 -0700
From:   mohammad.athari.ismail@intel.com
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Chuah@vger.kernel.org, Kim Tatt <kim.tatt.chuah@intel.com>
Cc:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net-next 1/2] net: stmmac: Add HW descriptor prefetch setting for DWMAC Core 5.20 onwards
Date:   Thu, 22 Apr 2021 15:55:00 +0800
Message-Id: <20210422075501.20207-2-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210422075501.20207-1-mohammad.athari.ismail@intel.com>
References: <20210422075501.20207-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

DWMAC Core 5.20 onwards supports HW descriptor prefetching.
Additionally, it also depends on platform specific RTL configuration.
This capability could be enabled by setting DMA_Mode bit-19 (DCHE).

So, to enable this cability, platform must set plat->dma_cfg->dche = true
and the DWMAC core version must be 5.20 onwards. Else, this capability
wouldn`t be configured

Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 10 ++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  5 +++++
 include/linux/stmmac.h                            |  1 +
 5 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index c54a56b732b3..619e3c0760d6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -33,6 +33,7 @@
 #define DWMAC_CORE_4_10		0x41
 #define DWMAC_CORE_5_00		0x50
 #define DWMAC_CORE_5_10		0x51
+#define DWMAC_CORE_5_20		0x52
 #define DWXGMAC_CORE_2_10	0x21
 #define DWXLGMAC_CORE_2_00	0x20
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index cb17f6c35e54..a602d16b9e53 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -162,12 +162,18 @@ static void dwmac4_dma_init(void __iomem *ioaddr,
 
 	writel(value, ioaddr + DMA_SYS_BUS_MODE);
 
+	value = readl(ioaddr + DMA_BUS_MODE);
+
 	if (dma_cfg->multi_msi_en) {
-		value = readl(ioaddr + DMA_BUS_MODE);
 		value &= ~DMA_BUS_MODE_INTM_MASK;
 		value |= (DMA_BUS_MODE_INTM_MODE1 << DMA_BUS_MODE_INTM_SHIFT);
-		writel(value, ioaddr + DMA_BUS_MODE);
 	}
+
+	if (dma_cfg->dche)
+		value |= DMA_BUS_MODE_DCHE;
+
+	writel(value, ioaddr + DMA_BUS_MODE);
+
 }
 
 static void _dwmac4_dump_dma_regs(void __iomem *ioaddr, u32 channel,
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index 05481eb13ba6..9321879b599c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -25,6 +25,7 @@
 #define DMA_TBS_CTRL			0x00001050
 
 /* DMA Bus Mode bitmap */
+#define DMA_BUS_MODE_DCHE		BIT(19)
 #define DMA_BUS_MODE_INTM_MASK		GENMASK(17, 16)
 #define DMA_BUS_MODE_INTM_SHIFT		16
 #define DMA_BUS_MODE_INTM_MODE1		0x1
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d1ca07c846e6..372090e8ee6f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6849,6 +6849,11 @@ int stmmac_dvr_probe(struct device *device,
 	if (ret)
 		goto error_hw_init;
 
+	/* Only DWMAC core version 5.20 onwards supports HW descriptor prefetch.
+	 */
+	if (priv->synopsys_id < DWMAC_CORE_5_20)
+		priv->plat->dma_cfg->dche = false;
+
 	stmmac_check_ether_addr(priv);
 
 	ndev->netdev_ops = &stmmac_netdev_ops;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 97edb31d6310..0db36360ef21 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -97,6 +97,7 @@ struct stmmac_dma_cfg {
 	bool aal;
 	bool eame;
 	bool multi_msi_en;
+	bool dche;
 };
 
 #define AXI_BLEN	7
-- 
2.17.1

