Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BE94CDA3
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731813AbfFTMXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:23:16 -0400
Received: from mx.0dd.nl ([5.2.79.48]:53448 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731720AbfFTMXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 08:23:15 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 2B26E5FEA5;
        Thu, 20 Jun 2019 14:23:12 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="GZQTCvCo";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id D9B1C1CB7227;
        Thu, 20 Jun 2019 14:23:11 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com D9B1C1CB7227
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561033391;
        bh=sWaETIGykh20OLdc6TDZc2DkdMJJZTMSUT4mTh+FG9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZQTCvComuttNcdNwsmuknmfdxnT7xxm7MuX9DG6Dn/MRYZ9Mdd0/OSVsaDaVCC8D
         VRouGoWGVrV+KsStCOWtEMMx74nPNxxBrj/Zh0uogYsMIlmr6peSyMiPXn1livIi9z
         /x1+Ubk4iJ9nzli2tCMYxdCAkv+32/UwKy19QmbUClo1ZlPV6Q6aI2Qqp2dXDZHrHM
         GJH3Rs4DW6CnuKDTsVz5SN+Ic0A9ciYAHYdhdpUoZbNDWqkhfRSq1zZYcgY+09XG14
         sTqawHOOJpiINs0v54g2ZmZredlRtawbcswwE5H83p811Ep1g49h8KnMHvQBI7/kT1
         0CYedXS52G9aw==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     frank-w@public-files.de, sean.wang@mediatek.com,
        f.fainelli@gmail.com, davem@davemloft.net, matthias.bgg@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH v2 net-next 2/2] net: dsa: mt7530: Add MT7621 TRGMII mode support
Date:   Thu, 20 Jun 2019 14:21:55 +0200
Message-Id: <20190620122155.32078-3-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190620122155.32078-1-opensource@vdorst.com>
References: <20190620122155.32078-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support TRGMII mode for MT7621 internal MT7530 switch.
MT7621 TRGMII has only one fix speed mode of 1200MBit.

Also adding support for mt7530 25MHz and 40MHz crystal clocksource.
Values are based on Banana Pi R2 bsp [1].

Don't change MT7623 registers on a MT7621 device.

[1] https://github.com/BPI-SINOVOIP/BPI-R2-bsp/blob/master/linux-mt/drivers/net/ethernet/mediatek/gsw_mt7623.c#L769

Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/dsa/mt7530.c | 46 +++++++++++++++++++++++++++++++---------
 drivers/net/dsa/mt7530.h |  4 ++++
 2 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c7d352da5448..3181e95586d6 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -428,24 +428,48 @@ static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, int mode)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, i;
+	u32 ncpo1, ssc_delta, trgint, i, xtal;
+
+	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
+
+	if (xtal == HWTRAP_XTAL_20MHZ) {
+		dev_err(priv->dev,
+			"%s: MT7530 with a 20MHz XTAL is not supported!\n",
+			__func__);
+		return -EINVAL;
+	}
 
 	switch (mode) {
 	case PHY_INTERFACE_MODE_RGMII:
 		trgint = 0;
+		/* PLL frequency: 125MHz */
 		ncpo1 = 0x0c80;
-		ssc_delta = 0x87;
 		break;
 	case PHY_INTERFACE_MODE_TRGMII:
 		trgint = 1;
-		ncpo1 = 0x1400;
-		ssc_delta = 0x57;
+		if (priv->id == ID_MT7621) {
+			/* PLL frequency: 150MHz: 1.2GBit */
+			if (xtal == HWTRAP_XTAL_40MHZ)
+				ncpo1 = 0x0780;
+			if (xtal == HWTRAP_XTAL_25MHZ)
+				ncpo1 = 0x0a00;
+		} else { /* PLL frequency: 250MHz: 2.0Gbit */
+			if (xtal == HWTRAP_XTAL_40MHZ)
+				ncpo1 = 0x0c80;
+			if (xtal == HWTRAP_XTAL_25MHZ)
+				ncpo1 = 0x1400;
+		}
 		break;
 	default:
 		dev_err(priv->dev, "xMII mode %d not supported\n", mode);
 		return -EINVAL;
 	}
 
+	if (xtal == HWTRAP_XTAL_25MHZ)
+		ssc_delta = 0x57;
+	else
+		ssc_delta = 0x87;
+
 	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
 		   P6_INTF_MODE(trgint));
 
@@ -507,7 +531,9 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, int mode)
 			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 				   RD_TAP_MASK, RD_TAP(16));
 	else
-		mt7623_trgmii_set(priv, GSW_INTF_MODE, INTF_MODE_TRGMII);
+		if (priv->id != ID_MT7621)
+			mt7623_trgmii_set(priv, GSW_INTF_MODE,
+					  INTF_MODE_TRGMII);
 
 	return 0;
 }
@@ -613,13 +639,13 @@ static void mt7530_adjust_link(struct dsa_switch *ds, int port,
 	struct mt7530_priv *priv = ds->priv;
 
 	if (phy_is_pseudo_fixed_link(phydev)) {
-		if (priv->id == ID_MT7530) {
-			dev_dbg(priv->dev, "phy-mode for master device = %x\n",
-				phydev->interface);
+		dev_dbg(priv->dev, "phy-mode for master device = %x\n",
+			phydev->interface);
 
-			/* Setup TX circuit incluing relevant PAD and driving */
-			mt7530_pad_clk_setup(ds, phydev->interface);
+		/* Setup TX circuit incluing relevant PAD and driving */
+		mt7530_pad_clk_setup(ds, phydev->interface);
 
+		if (priv->id == ID_MT7530) {
 			/* Setup RX circuit, relevant PAD and driving on the
 			 * host which must be placed after the setup on the
 			 * device side is all finished.
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 4331429969fa..bfac90f48102 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -244,6 +244,10 @@ enum mt7530_vlan_port_attr {
 
 /* Register for hw trap status */
 #define MT7530_HWTRAP			0x7800
+#define  HWTRAP_XTAL_MASK		(BIT(10) | BIT(9))
+#define  HWTRAP_XTAL_25MHZ		(BIT(10) | BIT(9))
+#define  HWTRAP_XTAL_40MHZ		(BIT(10))
+#define  HWTRAP_XTAL_20MHZ		(BIT(9))
 
 /* Register for hw trap modification */
 #define MT7530_MHWTRAP			0x7804
-- 
2.20.1

