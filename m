Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA494CF77
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbfFTNrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:47:53 -0400
Received: from vps.xff.cz ([195.181.215.36]:36104 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfFTNrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 09:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1561038471; bh=m7Sy/4DzZNajn4t/pyAlTRZlWZO1B2wUdtC3i/m0PqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2jHhF8llhegj+YumzfHweNU4AcFBuYyNw3C2NpBPQlL75yxe4x21HWZsnVT/VE5F
         SsJ5b92WqsVrB/XW43pLVv/+I99QHesL6vv+3DbT6kssivKlPj8pZ0vFT0qDaCHtYZ
         OEQUEKts2joi/pC0HrSob7vsKCEQ3Ktv7FzkesLc=
From:   megous@megous.com
To:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Jernej=20=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc:     Icenowy Zheng <icenowy@aosc.io>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        Ondrej Jirman <megous@megous.com>
Subject: [PATCH v7 1/6] net: stmmac: sun8i: add support for Allwinner H6 EMAC
Date:   Thu, 20 Jun 2019 15:47:43 +0200
Message-Id: <20190620134748.17866-2-megous@megous.com>
In-Reply-To: <20190620134748.17866-1-megous@megous.com>
References: <20190620134748.17866-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

The EMAC on Allwinner H6 is just like the one on A64. The "internal PHY" on
H6 is on a co-packaged AC200 chip, and it's not really internal (it's
connected via RMII at PA GPIO bank).

Add support for the Allwinner H6 EMAC in the dwmac-sun8i driver.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Ondrej Jirman <megous@megous.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c    | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index b15c6d5dbd38..c3e94104474f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -138,6 +138,20 @@ static const struct emac_variant emac_variant_a64 = {
 	.tx_delay_max = 7,
 };
 
+static const struct emac_variant emac_variant_h6 = {
+	.default_syscon_value = 0x50000,
+	.syscon_field = &sun8i_syscon_reg_field,
+	/* The "Internal PHY" of H6 is not on the die. It's on the
+	 * co-packaged AC200 chip instead.
+	 */
+	.soc_has_internal_phy = false,
+	.support_mii = true,
+	.support_rmii = true,
+	.support_rgmii = true,
+	.rx_delay_max = 31,
+	.tx_delay_max = 7,
+};
+
 #define EMAC_BASIC_CTL0 0x00
 #define EMAC_BASIC_CTL1 0x04
 #define EMAC_INT_STA    0x08
@@ -1216,6 +1230,8 @@ static const struct of_device_id sun8i_dwmac_match[] = {
 		.data = &emac_variant_r40 },
 	{ .compatible = "allwinner,sun50i-a64-emac",
 		.data = &emac_variant_a64 },
+	{ .compatible = "allwinner,sun50i-h6-emac",
+		.data = &emac_variant_h6 },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, sun8i_dwmac_match);
-- 
2.22.0

