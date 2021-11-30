Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EC1463C6C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244579AbhK3RFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244551AbhK3RF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:05:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BDCC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 09:02:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C6799CE1759
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 17:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57010C58319;
        Tue, 30 Nov 2021 17:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638291723;
        bh=11R7z60OgBBh7+0bL/S7VSNH1IMZv46T+ddjZGjYLwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSXxf83JUDeFna7omZwUuMkVFd0JCJcCZ12/Yp1nsjH3F61lz5JJdbBhoOvCKUAQ8
         k7Sb7vV1N8uGGNvteknBVg19zUO9xA/ERsv725Ix/6fpQnR4yBfAi3+IiC+XJRs4To
         UzSrL54nK+4g5/1TpfP6KIvYDRRw+iWgoxdRvrwbgUOt+JeXg3PeL3/yYlf9aPrZ1z
         Tbsz73jb1CRI9DiFYA439SgHa07eGG02nS12fhGQLnjxOlUnYcD7wjJ27hiPKgGOPL
         AwPJ9mOKN2ccOWAR53HrR1EK6PkymssKthCXxl2PaJupm5/pMVPE/06DAJ5EK5MoB7
         zQw3LV6XRa9Sg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 3/6] net: dsa: mv88e6xxx: Save power by disabling SerDes trasmitter and receiver
Date:   Tue, 30 Nov 2021 18:01:48 +0100
Message-Id: <20211130170151.7741-4-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211130170151.7741-1-kabel@kernel.org>
References: <20211130170151.7741-1-kabel@kernel.org>
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
 drivers/net/dsa/mv88e6xxx/serdes.c | 46 +++++++++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h |  3 ++
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 3a6244596a67..ceb63d7f1f97 100644
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
+		reg &= ~(MV88E6393X_SERDES_CTRL1_TX_PDOWN |
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
 
-	return 0;
+	if (err)
+		return err;
+
+	if (!on)
+		err = mv88e6393x_serdes_power_lane(chip, lane, false);
+
+	return err;
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

