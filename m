Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E21D7822FF
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 18:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbfHEQro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 12:47:44 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:52246 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728686AbfHEQp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 12:45:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 611F5C019D;
        Mon,  5 Aug 2019 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565023529; bh=tthu8/fp8GpRXte4MRp2he8tdZQzqOI7QhvLyCTgfTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Xf9U3/FVHSSf8kL0RtxitOhJZRq+qTi4spuPpNYxCVOQZc/InU5D9FRX2SvMw4/+j
         cyCnRjmVTzqWVrsarXaSczV3rs+f61vjBNBs0l0Xoe5qpqXaQSxmVDMY0fy+fdHORL
         KIe0HL66RGM4ApgqJmWvMDqjdFcyCBOiHg5nkw3vwyMZLEoPLZI4sOidlRY9wJRs6n
         r0/IxvhbChTU9GEctslglHV4lhW88VwdEvi+9xKrMyA+o1CMkPydkvm58s5nT/Q/H4
         RMh9chkvO2c4MqsWPJD3HdcrE/TQBMWmsxS2nG7Ka9FYk/LrNt3TUf8nlFFwHaZQGj
         JyGj7BSIyiwoQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id DFF33A0061;
        Mon,  5 Aug 2019 16:45:26 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/26] net: stmmac: xgmac: Fix XGMAC selftests
Date:   Mon,  5 Aug 2019 18:44:28 +0200
Message-Id: <0e73454463a671a633c205e546807ca7ca8ed569.1565022597.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixup the XGMAC selftests by correctly finishing the implementation of
set_filter callback.

Result:
$ ethtool -t enp4s0
The test result is PASS
The test extra info:
 1. MAC Loopback         	 0
 2. PHY Loopback         	 -95
 3. MMC Counters         	 -95
 4. EEE                  	 -95
 5. Hash Filter MC       	 0
 6. Perfect Filter UC    	 0
 7. MC Filter            	 0
 8. UC Filter            	 0
 9. Flow Control         	 0

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  7 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 83 +++++++++++++++++++---
 2 files changed, 79 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 7f86dffb264d..3174b701aa90 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -44,11 +44,13 @@
 #define XGMAC_CORE_INIT_RX		0
 #define XGMAC_PACKET_FILTER		0x00000008
 #define XGMAC_FILTER_RA			BIT(31)
+#define XGMAC_FILTER_HPF		BIT(10)
 #define XGMAC_FILTER_PCF		BIT(7)
 #define XGMAC_FILTER_PM			BIT(4)
 #define XGMAC_FILTER_HMC		BIT(2)
 #define XGMAC_FILTER_PR			BIT(0)
 #define XGMAC_HASH_TABLE(x)		(0x00000010 + (x) * 4)
+#define XGMAC_MAX_HASH_TABLE		8
 #define XGMAC_RXQ_CTRL0			0x000000a0
 #define XGMAC_RXQEN(x)			GENMASK((x) * 2 + 1, (x) * 2)
 #define XGMAC_RXQEN_SHIFT(x)		((x) * 2)
@@ -99,11 +101,12 @@
 #define XGMAC_MDIO_ADDR			0x00000200
 #define XGMAC_MDIO_DATA			0x00000204
 #define XGMAC_MDIO_C22P			0x00000220
-#define XGMAC_ADDR0_HIGH		0x00000300
+#define XGMAC_ADDRx_HIGH(x)		(0x00000300 + (x) * 0x8)
+#define XGMAC_ADDR_MAX			32
 #define XGMAC_AE			BIT(31)
 #define XGMAC_DCS			GENMASK(19, 16)
 #define XGMAC_DCS_SHIFT			16
-#define XGMAC_ADDR0_LOW			0x00000304
+#define XGMAC_ADDRx_LOW(x)		(0x00000304 + (x) * 0x8)
 #define XGMAC_ARP_ADDR			0x00000c10
 #define XGMAC_TIMESTAMP_STATUS		0x00000d20
 #define XGMAC_TXTSC			BIT(15)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 0a32c96a7854..03a6a59650ca 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -4,6 +4,8 @@
  * stmmac XGMAC support.
  */
 
+#include <linux/bitrev.h>
+#include <linux/crc32.h>
 #include "stmmac.h"
 #include "dwxgmac2.h"
 
@@ -278,10 +280,10 @@ static void dwxgmac2_set_umac_addr(struct mac_device_info *hw,
 	u32 value;
 
 	value = (addr[5] << 8) | addr[4];
-	writel(value | XGMAC_AE, ioaddr + XGMAC_ADDR0_HIGH);
+	writel(value | XGMAC_AE, ioaddr + XGMAC_ADDRx_HIGH(reg_n));
 
 	value = (addr[3] << 24) | (addr[2] << 16) | (addr[1] << 8) | addr[0];
-	writel(value, ioaddr + XGMAC_ADDR0_LOW);
+	writel(value, ioaddr + XGMAC_ADDRx_LOW(reg_n));
 }
 
 static void dwxgmac2_get_umac_addr(struct mac_device_info *hw,
@@ -291,8 +293,8 @@ static void dwxgmac2_get_umac_addr(struct mac_device_info *hw,
 	u32 hi_addr, lo_addr;
 
 	/* Read the MAC address from the hardware */
-	hi_addr = readl(ioaddr + XGMAC_ADDR0_HIGH);
-	lo_addr = readl(ioaddr + XGMAC_ADDR0_LOW);
+	hi_addr = readl(ioaddr + XGMAC_ADDRx_HIGH(reg_n));
+	lo_addr = readl(ioaddr + XGMAC_ADDRx_LOW(reg_n));
 
 	/* Extract the MAC address from the high and low words */
 	addr[0] = lo_addr & 0xff;
@@ -303,19 +305,82 @@ static void dwxgmac2_get_umac_addr(struct mac_device_info *hw,
 	addr[5] = (hi_addr >> 8) & 0xff;
 }
 
+static void dwxgmac2_set_mchash(void __iomem *ioaddr, u32 *mcfilterbits,
+				int mcbitslog2)
+{
+	int numhashregs, regs;
+
+	switch (mcbitslog2) {
+	case 6:
+		numhashregs = 2;
+		break;
+	case 7:
+		numhashregs = 4;
+		break;
+	case 8:
+		numhashregs = 8;
+		break;
+	default:
+		return;
+	}
+
+	for (regs = 0; regs < numhashregs; regs++)
+		writel(mcfilterbits[regs], ioaddr + XGMAC_HASH_TABLE(regs));
+}
+
 static void dwxgmac2_set_filter(struct mac_device_info *hw,
 				struct net_device *dev)
 {
 	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
-	u32 value = XGMAC_FILTER_RA;
+	u32 value = readl(ioaddr + XGMAC_PACKET_FILTER);
+	int mcbitslog2 = hw->mcast_bits_log2;
+	u32 mc_filter[8];
+	int i;
+
+	value &= ~(XGMAC_FILTER_PR | XGMAC_FILTER_HMC | XGMAC_FILTER_PM);
+	value |= XGMAC_FILTER_HPF;
+
+	memset(mc_filter, 0, sizeof(mc_filter));
 
 	if (dev->flags & IFF_PROMISC) {
-		value |= XGMAC_FILTER_PR | XGMAC_FILTER_PCF;
+		value |= XGMAC_FILTER_PR;
+		value |= XGMAC_FILTER_PCF;
 	} else if ((dev->flags & IFF_ALLMULTI) ||
-		   (netdev_mc_count(dev) > HASH_TABLE_SIZE)) {
+		   (netdev_mc_count(dev) > hw->multicast_filter_bins)) {
 		value |= XGMAC_FILTER_PM;
-		writel(~0x0, ioaddr + XGMAC_HASH_TABLE(0));
-		writel(~0x0, ioaddr + XGMAC_HASH_TABLE(1));
+
+		for (i = 0; i < XGMAC_MAX_HASH_TABLE; i++)
+			writel(~0x0, ioaddr + XGMAC_HASH_TABLE(i));
+	} else if (!netdev_mc_empty(dev)) {
+		struct netdev_hw_addr *ha;
+
+		value |= XGMAC_FILTER_HMC;
+
+		netdev_for_each_mc_addr(ha, dev) {
+			int nr = (bitrev32(~crc32_le(~0, ha->addr, 6)) >>
+					(32 - mcbitslog2));
+			mc_filter[nr >> 5] |= (1 << (nr & 0x1F));
+		}
+	}
+
+	dwxgmac2_set_mchash(ioaddr, mc_filter, mcbitslog2);
+
+	/* Handle multiple unicast addresses */
+	if (netdev_uc_count(dev) > XGMAC_ADDR_MAX) {
+		value |= XGMAC_FILTER_PR;
+	} else {
+		struct netdev_hw_addr *ha;
+		int reg = 1;
+
+		netdev_for_each_uc_addr(ha, dev) {
+			dwxgmac2_set_umac_addr(hw, ha->addr, reg);
+			reg++;
+		}
+
+		for ( ; reg < XGMAC_ADDR_MAX; reg++) {
+			writel(0, ioaddr + XGMAC_ADDRx_HIGH(reg));
+			writel(0, ioaddr + XGMAC_ADDRx_LOW(reg));
+		}
 	}
 
 	writel(value, ioaddr + XGMAC_PACKET_FILTER);
-- 
2.7.4

