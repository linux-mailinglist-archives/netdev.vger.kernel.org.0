Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAC7256CD5
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 10:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgH3Iev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 04:34:51 -0400
Received: from inva021.nxp.com ([92.121.34.21]:43738 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbgH3Ieh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 04:34:37 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 48C6B200385;
        Sun, 30 Aug 2020 10:34:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3C0E92001D4;
        Sun, 30 Aug 2020 10:34:35 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D26C920305;
        Sun, 30 Aug 2020 10:34:34 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        andrew@lunn.ch, linux@armlinux.org.uk, f.fainelli@gmail.com,
        olteanv@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 1/5] net: phylink: add helper function to decode USXGMII word
Date:   Sun, 30 Aug 2020 11:33:58 +0300
Message-Id: <20200830083402.11047-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200830083402.11047-1-ioana.ciornei@nxp.com>
References: <20200830083402.11047-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the new addition of the USXGMII link partner ability constants we
can now introduce a phylink helper that decodes the USXGMII word and
populates the appropriate fields in the phylink_link_state structure
based on them.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
---
Changes in v5:
- none

 drivers/net/phy/phylink.c | 43 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 32b4bd6a5b55..d7810c908bb3 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2318,6 +2318,49 @@ static void phylink_decode_sgmii_word(struct phylink_link_state *state,
 		state->duplex = DUPLEX_HALF;
 }
 
+/**
+ * phylink_decode_usxgmii_word() - decode the USXGMII word from a MAC PCS
+ * @state: a pointer to a struct phylink_link_state.
+ * @lpa: a 16 bit value which stores the USXGMII auto-negotiation word
+ *
+ * Helper for MAC PCS supporting the USXGMII protocol and the auto-negotiation
+ * code word.  Decode the USXGMII code word and populate the corresponding fields
+ * (speed, duplex) into the phylink_link_state structure.
+ */
+void phylink_decode_usxgmii_word(struct phylink_link_state *state,
+				 uint16_t lpa)
+{
+	switch (lpa & MDIO_USXGMII_SPD_MASK) {
+	case MDIO_USXGMII_10:
+		state->speed = SPEED_10;
+		break;
+	case MDIO_USXGMII_100:
+		state->speed = SPEED_100;
+		break;
+	case MDIO_USXGMII_1000:
+		state->speed = SPEED_1000;
+		break;
+	case MDIO_USXGMII_2500:
+		state->speed = SPEED_2500;
+		break;
+	case MDIO_USXGMII_5000:
+		state->speed = SPEED_5000;
+		break;
+	case MDIO_USXGMII_10G:
+		state->speed = SPEED_10000;
+		break;
+	default:
+		state->link = false;
+		return;
+	}
+
+	if (lpa & MDIO_USXGMII_FULL_DUPLEX)
+		state->duplex = DUPLEX_FULL;
+	else
+		state->duplex = DUPLEX_HALF;
+}
+EXPORT_SYMBOL_GPL(phylink_decode_usxgmii_word);
+
 /**
  * phylink_mii_c22_pcs_get_state() - read the MAC PCS state
  * @pcs: a pointer to a &struct mdio_device.
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index c36fb41a7d90..d81a714cfbbd 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -490,4 +490,7 @@ void phylink_mii_c22_pcs_an_restart(struct mdio_device *pcs);
 
 void phylink_mii_c45_pcs_get_state(struct mdio_device *pcs,
 				   struct phylink_link_state *state);
+
+void phylink_decode_usxgmii_word(struct phylink_link_state *state,
+				 uint16_t lpa);
 #endif
-- 
2.25.1

