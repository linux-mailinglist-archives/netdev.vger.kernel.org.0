Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EA21F7564
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 10:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgFLIi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 04:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgFLIi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 04:38:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995F8C03E96F
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 01:38:56 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jjfDD-0001VK-4z; Fri, 12 Jun 2020 10:38:55 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jjfDC-0007nf-8W; Fri, 12 Jun 2020 10:38:54 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2] net: mvneta: Fix Serdes configuration for 2.5Gbps modes
Date:   Fri, 12 Jun 2020 10:38:47 +0200
Message-Id: <20200612083847.29942-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell MVNETA Ethernet controller supports a 2.5Gbps SGMII mode
called DRSGMII. Depending on the Port MAC Control Register0 PortType
setting this seems to be either an overclocked SGMII mode or 2500BaseX.

This patch adds the necessary Serdes Configuration setting for the
2.5Gbps modes. There is no phy interface mode define for overclocked
SGMII, so only 2500BaseX is handled for now.

As phy_interface_mode_is_8023z() returns true for both
PHY_INTERFACE_MODE_1000BASEX and PHY_INTERFACE_MODE_2500BASEX we
explicitly test for 1000BaseX instead of using
phy_interface_mode_is_8023z() to differentiate the different
possibilities.

Fixes: da58a931f248f ("net: mvneta: Add support for 2500Mbps SGMII")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Changes since v1:
  - Add Fixes: tag

 drivers/net/ethernet/marvell/mvneta.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 51889770958d8..3b13048931412 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -109,6 +109,7 @@
 #define MVNETA_SERDES_CFG			 0x24A0
 #define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
 #define      MVNETA_QSGMII_SERDES_PROTO		 0x0667
+#define      MVNETA_DRSGMII_SERDES_PROTO	 0x1107
 #define MVNETA_TYPE_PRIO                         0x24bc
 #define      MVNETA_FORCE_UNI                    BIT(21)
 #define MVNETA_TXQ_CMD_1                         0x24e4
@@ -4966,8 +4967,10 @@ static int mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
 	if (phy_mode == PHY_INTERFACE_MODE_QSGMII)
 		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_QSGMII_SERDES_PROTO);
 	else if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
-		 phy_interface_mode_is_8023z(phy_mode))
+		 phy_mode == PHY_INTERFACE_MODE_1000BASEX)
 		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);
+	else if (phy_mode == PHY_INTERFACE_MODE_2500BASEX)
+		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_DRSGMII_SERDES_PROTO);
 	else if (!phy_interface_mode_is_rgmii(phy_mode))
 		return -EINVAL;
 
-- 
2.27.0

