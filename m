Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0808462497
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhK2WWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbhK2WUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:20:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B7DC08EAC1
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 11:58:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5BEACE13E1
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 19:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2B4C53FC7;
        Mon, 29 Nov 2021 19:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638215913;
        bh=fUccDvFjG/E8lVzp1+sX4+OkunbN8WlfxPnHID5odVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNNNFAtGlVeW+4gcfKPu2C6qGWLHgL4DXzrKmOUyMFTFWUmkzK1RHQoUNlbqIwOF7
         PkENNQ/BfrFgfVsKDLufdjY2o2jcGIt26SS0u+lyJeb8qFFTNkHYRdreDXYnR5PwR0
         rQcYDU3DFc7nFcpItLXld/ho+mqFjUp0xc3ikDESdI9ARUORWVr7tyZXNzQpD5O+H8
         RjMjwUxioGmSB/lCgc35V4yHS6KzxAZQiJad+Cw53ZDUtzm5Ggo02acdBg8BJXV6Pc
         766ANkX2u838luqAIsl+1Oh5DN1NE4rq3/5R4LTgfs2pZOALn2RgLqNtX/XPJ2TGhQ
         BP8XfthiDfmwQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 3/6] net: dsa: mv88e6xxx: Save power by disabling SerDes trasmitter and receiver
Date:   Mon, 29 Nov 2021 20:58:20 +0100
Message-Id: <20211129195823.11766-4-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211129195823.11766-1-kabel@kernel.org>
References: <20211129195823.11766-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Save power on 88E6393X by disabling SerDes receiver and transmitter
after SerDes is SerDes is disabled.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 44 ++++++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/serdes.h |  3 ++
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 3a6244596a67..0d92bd814f3a 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1271,6 +1271,28 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	}
 }
 
+static int mv88e6393x_serdes_power_lane(struct mv88e6xxx_chip *chip, int lane,
+					bool on)
+{
+	u16 reg;
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6393X_SERDES_CTRL1, &reg);
+	if (err)
+		return err;
+
+	if (on)
+		reg &= !(MV88E6393X_SERDES_CTRL1_TX_PDOWN |
+			 MV88E6393X_SERDES_CTRL1_RX_PDOWN);
+	else
+		reg |= MV88E6393X_SERDES_CTRL1_TX_PDOWN |
+		       MV88E6393X_SERDES_CTRL1_RX_PDOWN;
+
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6393X_SERDES_CTRL1, reg);
+}
+
 static int mv88e6393x_serdes_erratum_4_6(struct mv88e6xxx_chip *chip, int lane)
 {
 	u16 reg;
@@ -1297,7 +1319,11 @@ static int mv88e6393x_serdes_erratum_4_6(struct mv88e6xxx_chip *chip, int lane)
 	if (err)
 		return err;
 
-	return mv88e6390_serdes_power_sgmii(chip, lane, false);
+	err = mv88e6390_serdes_power_sgmii(chip, lane, false);
+	if (err)
+		return err;
+
+	return mv88e6393x_serdes_power_lane(chip, lane, false);
 }
 
 int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
@@ -1362,17 +1388,29 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 		err = mv88e6393x_serdes_erratum_4_8(chip, lane);
 		if (err)
 			return err;
+
+		err = mv88e6393x_serdes_power_lane(chip, lane, true);
+		if (err)
+			return err;
 	}
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		return mv88e6390_serdes_power_sgmii(chip, lane, on);
+		err = mv88e6390_serdes_power_sgmii(chip, lane, on);
+		break;
 	case MV88E6393X_PORT_STS_CMODE_5GBASER:
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
-		return mv88e6390_serdes_power_10g(chip, lane, on);
+		err = mv88e6390_serdes_power_10g(chip, lane, on);
+		break;
 	}
 
+	if (err)
+		return err;
+
+	if (!on)
+		return mv88e6393x_serdes_power_lane(chip, lane, false);
+
 	return 0;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index cbb3ba30caea..e9292c8beee4 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -93,6 +93,9 @@
 #define MV88E6393X_SERDES_POC_PCS_MASK		0x0007
 #define MV88E6393X_SERDES_POC_RESET		BIT(15)
 #define MV88E6393X_SERDES_POC_PDOWN		BIT(5)
+#define MV88E6393X_SERDES_CTRL1			0xf003
+#define MV88E6393X_SERDES_CTRL1_TX_PDOWN	BIT(9)
+#define MV88E6393X_SERDES_CTRL1_RX_PDOWN	BIT(8)
 
 #define MV88E6393X_ERRATA_4_8_REG		0xF074
 #define MV88E6393X_ERRATA_4_8_BIT		BIT(14)
-- 
2.32.0

