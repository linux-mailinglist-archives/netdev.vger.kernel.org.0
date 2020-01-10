Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F23D136C73
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgAJLyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:54:33 -0500
Received: from foss.arm.com ([217.140.110.172]:43150 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbgAJLyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 06:54:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B75DB13A1;
        Fri, 10 Jan 2020 03:54:32 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97D9A3F534;
        Fri, 10 Jan 2020 03:54:31 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] net: axienet: Fix SGMII support
Date:   Fri, 10 Jan 2020 11:54:08 +0000
Message-Id: <20200110115415.75683-8-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110115415.75683-1-andre.przywara@arm.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With SGMII, the MAC and the PHY can negotiate the link speed between
themselves, without the host needing to mediate between them.
Linux recognises this, and will call phylink's mac_config with the speed
member set to SPEED_UNKNOWN (-1).
Currently the axienet driver will bail out and complain about an
unsupported link speed.

Teach axienet's mac_config callback to leave the MAC's speed setting
alone if the requested speed is SPEED_UNKNOWN.

This fixes axienet operation when the hardware is using SGMII.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 8d2b67cbecf9..e83c7b005f50 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1512,20 +1512,21 @@ static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct axienet_local *lp = netdev_priv(ndev);
-	u32 emmc_reg, fcc_reg;
+	u32 fcc_reg, speed_reg = ~0;
 
-	emmc_reg = axienet_ior(lp, XAE_EMMC_OFFSET);
-	emmc_reg &= ~XAE_EMMC_LINKSPEED_MASK;
 
 	switch (state->speed) {
+	case SPEED_UNKNOWN:
+		/* Keep the current MAC speed setting. Used for SGMII. */
+		break;
 	case SPEED_1000:
-		emmc_reg |= XAE_EMMC_LINKSPD_1000;
+		speed_reg = XAE_EMMC_LINKSPD_1000;
 		break;
 	case SPEED_100:
-		emmc_reg |= XAE_EMMC_LINKSPD_100;
+		speed_reg = XAE_EMMC_LINKSPD_100;
 		break;
 	case SPEED_10:
-		emmc_reg |= XAE_EMMC_LINKSPD_10;
+		speed_reg = XAE_EMMC_LINKSPD_10;
 		break;
 	default:
 		dev_err(&ndev->dev,
@@ -1533,7 +1534,13 @@ static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
 		break;
 	}
 
-	axienet_iow(lp, XAE_EMMC_OFFSET, emmc_reg);
+	if (speed_reg != ~0) {
+		u32 emmc_reg = axienet_ior(lp, XAE_EMMC_OFFSET);
+
+		emmc_reg &= ~XAE_EMMC_LINKSPEED_MASK;
+		emmc_reg |= speed_reg;
+		axienet_iow(lp, XAE_EMMC_OFFSET, emmc_reg);
+	}
 
 	fcc_reg = axienet_ior(lp, XAE_FCC_OFFSET);
 	if (state->pause & MLO_PAUSE_TX)
-- 
2.17.1

