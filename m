Return-Path: <netdev+bounces-9447-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB8FB729227
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:04:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 208111C210D2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93D6FA940;
	Fri,  9 Jun 2023 08:03:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89272A93E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:03:41 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A5349ED;
	Fri,  9 Jun 2023 01:03:23 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686297791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xqzfFr7NFXB0y0mQeicw6jY8bkfZtTdsIOq61oO/O+I=;
	b=hLuGGuY9Ac4PeFKCg9fKcmN9TaPbtvYLiSRfEO3AVccxKFkh8KcprOE7S1EEnNgtiQ1F97
	YWV33SbSSfmjxNoKyjX2SKDfUor7bF5OU+svDskKIvf1m7RAtA3gXGzy9kFOpXT08AeXfP
	3YsR7zFSzol0KzAwodZwwfny8A5lJ4QfLZd7JjliGXS75Pzcu7T2UBIV8ePo0WxilHqyha
	C+0VSNJXYumnVgXTCCo1qVzPKCvbe0WpQ54sZT0tBVc7ToDEEjgyGRtlwc88Ae9Je61jDO
	9MKnBeu6gV+KG1v0FbCrjvVhA2W3RqMuImS7iyMZaCMXiTktI7pSCkKV/n8rlQ==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id AB357C000A;
	Fri,  9 Jun 2023 08:03:10 +0000 (UTC)
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Horatiu.Vultur@microchip.com,
	Allan.Nielsen@microchip.com,
	UNGLinuxDriver@microchip.com,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net v2 2/2] net: phylink: use a dedicated helper to parse usgmii control word
Date: Fri,  9 Jun 2023 10:03:05 +0200
Message-Id: <20230609080305.546028-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609080305.546028-1-maxime.chevallier@bootlin.com>
References: <20230609080305.546028-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Q-USGMII is a derivative of USGMII, that uses a specific formatting for
the control word. The layout is close to the USXGMII control word, but
doesn't support speeds over 1Gbps. Use a dedicated decoding logic for
the USGMII control word, re-using USXGMII definitions but only considering
10/100/1000Mbps speeds

Fixes: 5e61fe157a27 ("net: phy: Introduce QUSGMII PHY mode")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V1->V2: - Fix the decoding logic, by dropping the custom, wrong, speed mask
	- Fix a typo in the function doc ("expect" -> "except")
	- Slightly reword the commit log

 drivers/net/phy/phylink.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 590469261b98..b82d66e8dda2 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3359,6 +3359,41 @@ void phylink_decode_usxgmii_word(struct phylink_link_state *state,
 }
 EXPORT_SYMBOL_GPL(phylink_decode_usxgmii_word);
 
+/**
+ * phylink_decode_usgmii_word() - decode the USGMII word from a MAC PCS
+ * @state: a pointer to a struct phylink_link_state.
+ * @lpa: a 16 bit value which stores the USGMII auto-negotiation word
+ *
+ * Helper for MAC PCS supporting the USGMII protocol and the auto-negotiation
+ * code word.  Decode the USGMII code word and populate the corresponding fields
+ * (speed, duplex) into the phylink_link_state structure. The structure for this
+ * word is the same as the USXGMII word, except it only supports speeds up to
+ * 1Gbps.
+ */
+static void phylink_decode_usgmii_word(struct phylink_link_state *state,
+				       uint16_t lpa)
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
+
 /**
  * phylink_mii_c22_pcs_decode_state() - Decode MAC PCS state from MII registers
  * @state: a pointer to a &struct phylink_link_state.
@@ -3396,9 +3431,11 @@ void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
 
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
-	case PHY_INTERFACE_MODE_QUSGMII:
 		phylink_decode_sgmii_word(state, lpa);
 		break;
+	case PHY_INTERFACE_MODE_QUSGMII:
+		phylink_decode_usgmii_word(state, lpa);
+		break;
 
 	default:
 		state->link = false;
-- 
2.40.1


