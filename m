Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E9089A1F
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfHLJoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:44:30 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:35284 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727430AbfHLJoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:44:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 80199C21DE;
        Mon, 12 Aug 2019 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565603065; bh=peW4UI5iQljYC0L2GAo9h+Jjy5CBHEqexF7wYBcojAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=bzA6yC8oajVP8aLgjV6n3nFm06KxghFQzqYthyNQMC2gamyfeMHj2DJAJQdsXBQay
         XcD0iBPU4/GqKBDflqef73iY9enm4bfwzyVUFsaxRl3XoxKyK+fXlUtNsR7Qtx7PMS
         +pD2nzsnMaUyd9mlkyY6MljhXDjfaq3s6+I+diQ07bgOSB81HHmgZEpRR7HthS8zpM
         DaPVavVLivjpz2unECJFvC2170R6BqYB1ph7Mp7U7WL2fN1dQgVTnT5/dG8j2zZ30/
         ijCGhahzM258ovsgNYfcVTyW1NBYPfVVLqOYtCTtwFDLRiSvh5IMsPByEY3+X9ubsc
         lveKytukZysNg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 2F79EA006E;
        Mon, 12 Aug 2019 09:44:23 +0000 (UTC)
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
Subject: [PATCH net-next v2 06/12] net: stmmac: dwxgmac: Add Flexible PPS support
Date:   Mon, 12 Aug 2019 11:44:05 +0200
Message-Id: <495d44a7430c096afbae4a8a67c3b3f35b7f0a1f.1565602974.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the support for Flexible PPS in XGMAC cores.

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 19 ++++++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 56 ++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 995d533b9316..dbac63972faf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -149,6 +149,25 @@
 #define XGMAC_TXTIMESTAMP_NSEC		0x00000d30
 #define XGMAC_TXTSSTSLO			GENMASK(30, 0)
 #define XGMAC_TXTIMESTAMP_SEC		0x00000d34
+#define XGMAC_PPS_CONTROL		0x00000d70
+#define XGMAC_PPS_MAXIDX(x)		((((x) + 1) * 8) - 1)
+#define XGMAC_PPS_MINIDX(x)		((x) * 8)
+#define XGMAC_PPSx_MASK(x)		\
+	GENMASK(XGMAC_PPS_MAXIDX(x), XGMAC_PPS_MINIDX(x))
+#define XGMAC_TRGTMODSELx(x, val)	\
+	GENMASK(XGMAC_PPS_MAXIDX(x) - 1, XGMAC_PPS_MAXIDX(x) - 2) & \
+	((val) << (XGMAC_PPS_MAXIDX(x) - 2))
+#define XGMAC_PPSCMDx(x, val)		\
+	GENMASK(XGMAC_PPS_MINIDX(x) + 3, XGMAC_PPS_MINIDX(x)) & \
+	((val) << XGMAC_PPS_MINIDX(x))
+#define XGMAC_PPSCMD_START		0x2
+#define XGMAC_PPSCMD_STOP		0x5
+#define XGMAC_PPSEN0			BIT(4)
+#define XGMAC_PPSx_TARGET_TIME_SEC(x)	(0x00000d80 + (x) * 0x10)
+#define XGMAC_PPSx_TARGET_TIME_NSEC(x)	(0x00000d84 + (x) * 0x10)
+#define XGMAC_TRGTBUSY0			BIT(31)
+#define XGMAC_PPSx_INTERVAL(x)		(0x00000d88 + (x) * 0x10)
+#define XGMAC_PPSx_WIDTH(x)		(0x00000d8c + (x) * 0x10)
 
 /* MTL Registers */
 #define XGMAC_MTL_OPMODE		0x00001000
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index ba5183f38f84..f843e3640f50 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -8,6 +8,7 @@
 #include <linux/crc32.h>
 #include <linux/iopoll.h>
 #include "stmmac.h"
+#include "stmmac_ptp.h"
 #include "dwxgmac2.h"
 
 static void dwxgmac2_core_init(struct mac_device_info *hw,
@@ -1011,6 +1012,60 @@ static int dwxgmac2_get_mac_tx_timestamp(struct mac_device_info *hw, u64 *ts)
 	return 0;
 }
 
+static int dwxgmac2_flex_pps_config(void __iomem *ioaddr, int index,
+				    struct stmmac_pps_cfg *cfg, bool enable,
+				    u32 sub_second_inc, u32 systime_flags)
+{
+	u32 tnsec = readl(ioaddr + XGMAC_PPSx_TARGET_TIME_NSEC(index));
+	u32 val = readl(ioaddr + XGMAC_PPS_CONTROL);
+	u64 period;
+
+	if (!cfg->available)
+		return -EINVAL;
+	if (tnsec & XGMAC_TRGTBUSY0)
+		return -EBUSY;
+	if (!sub_second_inc || !systime_flags)
+		return -EINVAL;
+
+	val &= ~XGMAC_PPSx_MASK(index);
+
+	if (!enable) {
+		val |= XGMAC_PPSCMDx(index, XGMAC_PPSCMD_STOP);
+		writel(val, ioaddr + XGMAC_PPS_CONTROL);
+		return 0;
+	}
+
+	val |= XGMAC_PPSCMDx(index, XGMAC_PPSCMD_START);
+	val |= XGMAC_TRGTMODSELx(index, XGMAC_PPSCMD_START);
+	val |= XGMAC_PPSEN0;
+
+	writel(cfg->start.tv_sec, ioaddr + XGMAC_PPSx_TARGET_TIME_SEC(index));
+
+	if (!(systime_flags & PTP_TCR_TSCTRLSSR))
+		cfg->start.tv_nsec = (cfg->start.tv_nsec * 1000) / 465;
+	writel(cfg->start.tv_nsec, ioaddr + XGMAC_PPSx_TARGET_TIME_NSEC(index));
+
+	period = cfg->period.tv_sec * 1000000000;
+	period += cfg->period.tv_nsec;
+
+	do_div(period, sub_second_inc);
+
+	if (period <= 1)
+		return -EINVAL;
+
+	writel(period - 1, ioaddr + XGMAC_PPSx_INTERVAL(index));
+
+	period >>= 1;
+	if (period <= 1)
+		return -EINVAL;
+
+	writel(period - 1, ioaddr + XGMAC_PPSx_WIDTH(index));
+
+	/* Finally, activate it */
+	writel(val, ioaddr + XGMAC_PPS_CONTROL);
+	return 0;
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -1048,6 +1103,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.update_vlan_hash = dwxgmac2_update_vlan_hash,
 	.rxp_config = dwxgmac3_rxp_config,
 	.get_mac_tx_timestamp = dwxgmac2_get_mac_tx_timestamp,
+	.flex_pps_config = dwxgmac2_flex_pps_config,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
-- 
2.7.4

