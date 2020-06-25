Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BAB20A23C
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405891AbgFYPos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:44:48 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:33763 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405159AbgFYPos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:44:48 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 236D01BF203;
        Thu, 25 Jun 2020 15:44:45 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net-next 1/8] net: phy: mscc: macsec: fix sparse warnings
Date:   Thu, 25 Jun 2020 17:42:04 +0200
Message-Id: <20200625154211.606591-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625154211.606591-1-antoine.tenart@bootlin.com>
References: <20200625154211.606591-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the following sparse warnings when building MACsec
support in the MSCC PHY driver.

  mscc_macsec.c:393:42: warning: cast from restricted sci_t
  mscc_macsec.c:395:42: warning: restricted sci_t degrades to integer
  mscc_macsec.c:402:42: warning: restricted __be16 degrades to integer
  mscc_macsec.c:608:34: warning: cast from restricted sci_t
  mscc_macsec.c:610:34: warning: restricted sci_t degrades to integer

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_macsec.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index 713c62b1d1f0..77c8c2fb28de 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -385,21 +385,23 @@ static void vsc8584_macsec_flow(struct phy_device *phydev,
 	}
 
 	if (bank == MACSEC_INGR && flow->match.sci && flow->rx_sa->sc->sci) {
+		u64 sci = (__force u64)flow->rx_sa->sc->sci;
+
 		match |= MSCC_MS_SAM_MISC_MATCH_TCI(BIT(3));
 		mask |= MSCC_MS_SAM_MASK_TCI_MASK(BIT(3)) |
 			MSCC_MS_SAM_MASK_SCI_MASK;
 
 		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MATCH_SCI_LO(idx),
-					 lower_32_bits(flow->rx_sa->sc->sci));
+					 lower_32_bits(sci));
 		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MATCH_SCI_HI(idx),
-					 upper_32_bits(flow->rx_sa->sc->sci));
+					 upper_32_bits(sci));
 	}
 
 	if (flow->match.etype) {
 		mask |= MSCC_MS_SAM_MASK_MAC_ETYPE_MASK;
 
 		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MAC_SA_MATCH_HI(idx),
-					 MSCC_MS_SAM_MAC_SA_MATCH_HI_ETYPE(htons(flow->etype)));
+					 MSCC_MS_SAM_MAC_SA_MATCH_HI_ETYPE((__force u32)htons(flow->etype)));
 	}
 
 	match |= MSCC_MS_SAM_MISC_MATCH_PRIORITY(flow->priority);
@@ -545,7 +547,7 @@ static int vsc8584_macsec_transformation(struct phy_device *phydev,
 	int i, ret, index = flow->index;
 	u32 rec = 0, control = 0;
 	u8 hkey[16];
-	sci_t sci;
+	u64 sci;
 
 	ret = vsc8584_macsec_derive_key(flow->key, priv->secy->key_len, hkey);
 	if (ret)
@@ -603,7 +605,7 @@ static int vsc8584_macsec_transformation(struct phy_device *phydev,
 					 priv->secy->replay_window);
 
 	/* Set the input vectors */
-	sci = bank == MACSEC_INGR ? flow->rx_sa->sc->sci : priv->secy->sci;
+	sci = (__force u64)(bank == MACSEC_INGR ? flow->rx_sa->sc->sci : priv->secy->sci);
 	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
 				 lower_32_bits(sci));
 	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
-- 
2.26.2

