Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E895FD084E
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 09:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbfJIHbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 03:31:52 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:31182 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725776AbfJIHbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 03:31:51 -0400
X-UUID: fc0c3191f177453c81ef62b7eb8b4885-20191009
X-UUID: fc0c3191f177453c81ef62b7eb8b4885-20191009
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 415846299; Wed, 09 Oct 2019 15:31:43 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 9 Oct 2019 15:31:38 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 9 Oct 2019 15:31:37 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jose Abreu <joabreu@synopsys.com>,
        <andrew@lunn.ch>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>,
        <boon.leong.ong@intel.com>
Subject: [PATCH] net: stmmac: dwmac-mediatek: fix wrong delay value issue when resume back
Date:   Wed, 9 Oct 2019 15:31:29 +0800
Message-ID: <20191009073129.5439-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: B285750855EC341362F90DB9DFAED3B70120BD807D577E25220679B16259FE2E2000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mac_delay value will be divided by 550/170 in mt2712_delay_stage2ps(),
which is invoked at the beginning of mt2712_set_delay(), and the value
should be restored at the end of mt2712_set_delay().
Or, mac_delay will be divided again when invoking mt2712_set_delay()
when resume back.
So, add mt2712_delay_ps2stage() to mt2712_set_delay() to recovery the
original mac_delay value.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 79f2ee37afed..cea7a0c7ce68 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -130,6 +130,31 @@ static void mt2712_delay_ps2stage(struct mediatek_dwmac_plat_data *plat)
 	}
 }
 
+static void mt2712_delay_stage2ps(struct mediatek_dwmac_plat_data *plat)
+{
+	struct mac_delay_struct *mac_delay = &plat->mac_delay;
+
+	switch (plat->phy_mode) {
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_RMII:
+		/* 550ps per stage for MII/RMII */
+		mac_delay->tx_delay *= 550;
+		mac_delay->rx_delay *= 550;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		/* 170ps per stage for RGMII */
+		mac_delay->tx_delay *= 170;
+		mac_delay->rx_delay *= 170;
+		break;
+	default:
+		dev_err(plat->dev, "phy interface not supported\n");
+		break;
+	}
+}
+
 static int mt2712_set_delay(struct mediatek_dwmac_plat_data *plat)
 {
 	struct mac_delay_struct *mac_delay = &plat->mac_delay;
@@ -199,6 +224,8 @@ static int mt2712_set_delay(struct mediatek_dwmac_plat_data *plat)
 	regmap_write(plat->peri_regmap, PERI_ETH_DLY, delay_val);
 	regmap_write(plat->peri_regmap, PERI_ETH_DLY_FINE, fine_val);
 
+	mt2712_delay_stage2ps(plat);
+
 	return 0;
 }
 
-- 
2.18.0

