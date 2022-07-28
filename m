Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A01584243
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 16:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiG1OxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 10:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiG1OxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 10:53:06 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFBF60685;
        Thu, 28 Jul 2022 07:53:04 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3A2176000F;
        Thu, 28 Jul 2022 14:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1659019983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L+CWF+J4cRRiFmB2flx5GMZW1XQc4zExLZaoJy9LT40=;
        b=nvnqr8FJJAKaVF9DjobusWmfb6RjhfF2qCqrbTic3X8f0y7lXv6DCC8s24jPupB5ei0/Qy
        uJqRPmMJLlHY2k03f2YnDYqr0QntRh439QR2uwefIN7V3nr546StvArfHJZG/Tp/odjaZd
        W2aIY3SvZDW4sceKBKMEIstlC8ZslddL2V+lW9RGzop26PkCcqA3y+0AI9Fk2o87DJX09K
        47YEoWT94LL3Ym0SD5YHgCqUji4jDAWw2UgUdiayTpAzT9hnRuAcePAI3bpMs/4BXN0B2U
        6edNuWvbfJNkSsrMJHCwrGWU0sY9bTobACUqzRTXU6VZZ2zPC48JMMq4RmKedA==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
        Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 3/4] net: phy: Add helper to derive the number of ports from a phy mode
Date:   Thu, 28 Jul 2022 16:52:51 +0200
Message-Id: <20220728145252.439201-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728145252.439201-1-maxime.chevallier@bootlin.com>
References: <20220728145252.439201-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some phy modes such as QSGMII multiplex several MAC<->PHY links on one
single physical interface. QSGMII used to be the only one supported, but
other modes such as QUSGMII also carry multiple links.

This helper allows getting the number of links that are multiplexed
on a given interface.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V1->V2 : New patch

 drivers/net/phy/phy-core.c | 52 ++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h        |  2 ++
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 1f2531a1a876..6029583f367d 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -74,6 +74,58 @@ const char *phy_duplex_to_str(unsigned int duplex)
 }
 EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 
+/**
+ * phy_interface_num_ports - Return the number of links that can be carried by
+ *			     a given MAC-PHY physical link. Returns 0 if this is
+ *			     unknown, the number of links else.
+ *
+ * @interface: The interface mode we want to get the number of ports
+ */
+int phy_interface_num_ports(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_INTERNAL:
+		return 0;
+
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_TBI:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_REVRMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RTBI:
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_XLGMII:
+	case PHY_INTERFACE_MODE_MOCA:
+	case PHY_INTERFACE_MODE_TRGMII:
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_SMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+	case PHY_INTERFACE_MODE_5GBASER:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_25GBASER:
+	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_100BASEX:
+	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_XAUI:
+		return 1;
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
+		return 4;
+
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(phy_interface_num_ports);
+
 /* A mapping of all SUPPORTED settings to speed/duplex.  This table
  * must be grouped by speed and sorted in descending match priority
  * - iow, descending speed.
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 6b96b810a4d8..77e4b60bb9ab 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -967,6 +967,8 @@ struct phy_fixup {
 const char *phy_speed_to_str(int speed);
 const char *phy_duplex_to_str(unsigned int duplex);
 
+int phy_interface_num_ports(phy_interface_t interface);
+
 /* A structure for mapping a particular speed and duplex
  * combination to a particular SUPPORTED and ADVERTISED value
  */
-- 
2.37.1

