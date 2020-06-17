Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A49A1FCE98
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 15:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgFQNge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 09:36:34 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:40511 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbgFQNg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 09:36:28 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id B890724000A;
        Wed, 17 Jun 2020 13:36:23 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net, antoine.tenart@bootlin.com
Subject: [PATCH net-next v2 4/8] net: phy: mscc: take into account the 1588 block in MACsec init
Date:   Wed, 17 Jun 2020 15:31:23 +0200
Message-Id: <20200617133127.628454-5-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617133127.628454-1-antoine.tenart@bootlin.com>
References: <20200617133127.628454-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch takes in account the use of the 1588 block in the MACsec
initialization, as a conditional configuration has to be done (when the
1588 block is used).

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_macsec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index c0eeb62cb940..713c62b1d1f0 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -285,7 +285,9 @@ static void vsc8584_macsec_mac_init(struct phy_device *phydev,
 				 MSCC_MAC_CFG_PKTINF_CFG_STRIP_PREAMBLE_ENA |
 				 MSCC_MAC_CFG_PKTINF_CFG_INSERT_PREAMBLE_ENA |
 				 (bank == HOST_MAC ?
-				  MSCC_MAC_CFG_PKTINF_CFG_ENABLE_TX_PADDING : 0));
+				  MSCC_MAC_CFG_PKTINF_CFG_ENABLE_TX_PADDING : 0) |
+				 (IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING) ?
+				  MSCC_MAC_CFG_PKTINF_CFG_MACSEC_BYPASS_NUM_PTP_STALL_CLKS(0x8) : 0));
 
 	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MAC_CFG_MODE_CFG);
 	val &= ~MSCC_MAC_CFG_MODE_CFG_DISABLE_DIC;
-- 
2.26.2

