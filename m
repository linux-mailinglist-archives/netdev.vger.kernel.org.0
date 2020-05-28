Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE011E57A7
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 08:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgE1GjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 02:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgE1GjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 02:39:11 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FBBC05BD1E;
        Wed, 27 May 2020 23:39:11 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0AE4B22F2D;
        Thu, 28 May 2020 08:39:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590647946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TcSDnB+Fbe6GBxPMYdKLSnl0KzcLZPnoPN7AAEh0TW8=;
        b=l3Ii8A5yQE69p9HKM9Gz0MEANP5p9oyrfG1juibpxMxWlLvaWqDn+FJp280x9fgKEXGSVn
        Aji+CEc3N0wPEmO4v9XauWvc3p24TidWURPWrlKuxJlD5mlcYEnASl9cLs1v22gbGr/c3D
        9TyNEou2CfeS78o8LC6VjbWMexKcTq0=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH net-next v3 1/3] net: dsa: felix: move USXGMII defines to common place
Date:   Thu, 28 May 2020 08:38:45 +0200
Message-Id: <20200528063847.27704-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200528063847.27704-1-michael@walle.cc>
References: <20200528063847.27704-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ENETC has the same PCS PHY and thus needs the same definitions. Move
them into the common enetc_mdio.h header which has already the macros
for the SGMII PCS.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 21 ---------------------
 include/linux/fsl/enetc_mdio.h         | 19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1dd9e348152d..986d4d26aa3c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -16,29 +16,8 @@
 #define VSC9959_VCAP_IS2_CNT		1024
 #define VSC9959_VCAP_IS2_ENTRY_WIDTH	376
 #define VSC9959_VCAP_PORT_CNT		6
-
-/* TODO: should find a better place for these */
-#define USXGMII_BMCR_RESET		BIT(15)
-#define USXGMII_BMCR_AN_EN		BIT(12)
-#define USXGMII_BMCR_RST_AN		BIT(9)
-#define USXGMII_BMSR_LNKS(status)	(((status) & GENMASK(2, 2)) >> 2)
-#define USXGMII_BMSR_AN_CMPL(status)	(((status) & GENMASK(5, 5)) >> 5)
-#define USXGMII_ADVERTISE_LNKS(x)	(((x) << 15) & BIT(15))
-#define USXGMII_ADVERTISE_FDX		BIT(12)
-#define USXGMII_ADVERTISE_SPEED(x)	(((x) << 9) & GENMASK(11, 9))
-#define USXGMII_LPA_LNKS(lpa)		((lpa) >> 15)
-#define USXGMII_LPA_DUPLEX(lpa)		(((lpa) & GENMASK(12, 12)) >> 12)
-#define USXGMII_LPA_SPEED(lpa)		(((lpa) & GENMASK(11, 9)) >> 9)
-
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
 
-enum usxgmii_speed {
-	USXGMII_SPEED_10	= 0,
-	USXGMII_SPEED_100	= 1,
-	USXGMII_SPEED_1000	= 2,
-	USXGMII_SPEED_2500	= 4,
-};
-
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
 	REG(ANA_VLANMASK,			0x0089a4),
diff --git a/include/linux/fsl/enetc_mdio.h b/include/linux/fsl/enetc_mdio.h
index 4875dd38af7e..0129366fa47a 100644
--- a/include/linux/fsl/enetc_mdio.h
+++ b/include/linux/fsl/enetc_mdio.h
@@ -27,6 +27,25 @@ enum enetc_pcs_speed {
 	ENETC_PCS_SPEED_2500	= 2,
 };
 
+#define USXGMII_BMCR_RESET		BIT(15)
+#define USXGMII_BMCR_AN_EN		BIT(12)
+#define USXGMII_BMCR_RST_AN		BIT(9)
+#define USXGMII_BMSR_LNKS(status)	(((status) & GENMASK(2, 2)) >> 2)
+#define USXGMII_BMSR_AN_CMPL(status)	(((status) & GENMASK(5, 5)) >> 5)
+#define USXGMII_ADVERTISE_LNKS(x)	(((x) << 15) & BIT(15))
+#define USXGMII_ADVERTISE_FDX		BIT(12)
+#define USXGMII_ADVERTISE_SPEED(x)	(((x) << 9) & GENMASK(11, 9))
+#define USXGMII_LPA_LNKS(lpa)		((lpa) >> 15)
+#define USXGMII_LPA_DUPLEX(lpa)		(((lpa) & GENMASK(12, 12)) >> 12)
+#define USXGMII_LPA_SPEED(lpa)		(((lpa) & GENMASK(11, 9)) >> 9)
+
+enum usxgmii_speed {
+	USXGMII_SPEED_10	= 0,
+	USXGMII_SPEED_100	= 1,
+	USXGMII_SPEED_1000	= 2,
+	USXGMII_SPEED_2500	= 4,
+};
+
 struct enetc_hw;
 
 struct enetc_mdio_priv {
-- 
2.20.1

