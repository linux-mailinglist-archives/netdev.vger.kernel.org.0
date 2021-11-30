Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7792E463C69
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244533AbhK3RFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:05:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47966 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244529AbhK3RFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:05:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02DC4B81A8F
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 17:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BF6C53FD1;
        Tue, 30 Nov 2021 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638291718;
        bh=/8iZcp0F1D9bcrtGapFLOUAM0jt3fgL3i565y2g4YJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EArIZXCPrw1bI9HcM5StnvEFMJ3DSZ1vAee45eybpd8TaJ6ERbd5KK4W3NXEib14z
         R68Jo9v7oKV6+7iMsUtoHZq4wTQp07/bLYk9+u9VtVF7XlEGu5iV+Mt2cSJzVSvrkN
         gliujZrTmWMh8KNsEgX2O/zPAYkecCGq+ZRn8r9EyvlVZEQjslA+0QdygflyRUUay+
         hySJtJvbus5onB6GHlWWp/y5GC8VPSH7pqOferfKFCNUmAgqk6F63TLZLMsHtVWAie
         pCdiO1QOpL19k/0pdj1GuE6XAH50wu2TVTG2Y01PkIfRUFu2rRpp0Ln9bQVby83645
         z83eTvx0U7MMA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 1/6] net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X
Date:   Tue, 30 Nov 2021 18:01:46 +0100
Message-Id: <20211130170151.7741-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211130170151.7741-1-kabel@kernel.org>
References: <20211130170151.7741-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to SERDES scripts for 88E6393X, erratum 4.8 has to be applied
every time before SerDes is powered on.

Split the code for erratum 4.8 into separate function and call it in
mv88e6393x_serdes_power().

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 53 +++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 6ea003678798..0658ee3b014c 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1271,9 +1271,9 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	}
 }
 
-static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
+static int mv88e6393x_serdes_erratum_4_6(struct mv88e6xxx_chip *chip, int lane)
 {
-	u16 reg, pcs;
+	u16 reg;
 	int err;
 
 	/* mv88e6393x family errata 4.6:
@@ -1300,11 +1300,32 @@ static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
 		if (err)
 			return err;
 
-		err = mv88e6390_serdes_power_sgmii(chip, lane, false);
-		if (err)
-			return err;
+		return mv88e6390_serdes_power_sgmii(chip, lane, false);
 	}
 
+	return 0;
+}
+
+int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
+{
+	int err;
+
+	err = mv88e6393x_serdes_erratum_4_6(chip, MV88E6393X_PORT0_LANE);
+	if (err)
+		return err;
+
+	err = mv88e6393x_serdes_erratum_4_6(chip, MV88E6393X_PORT9_LANE);
+	if (err)
+		return err;
+
+	return mv88e6393x_serdes_erratum_4_6(chip, MV88E6393X_PORT10_LANE);
+}
+
+static int mv88e6393x_serdes_erratum_4_8(struct mv88e6xxx_chip *chip, int lane)
+{
+	u16 reg, pcs;
+	int err;
+
 	/* mv88e6393x family errata 4.8:
 	 * When a SERDES port is operating in 1000BASE-X or SGMII mode link may
 	 * not come up after hardware reset or software reset of SERDES core.
@@ -1334,29 +1355,21 @@ static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
 				      MV88E6393X_ERRATA_4_8_REG, reg);
 }
 
-int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
-{
-	int err;
-
-	err = mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT0_LANE);
-	if (err)
-		return err;
-
-	err = mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT9_LANE);
-	if (err)
-		return err;
-
-	return mv88e6393x_serdes_port_errata(chip, MV88E6393X_PORT10_LANE);
-}
-
 int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			    bool on)
 {
 	u8 cmode = chip->ports[port].cmode;
+	int err;
 
 	if (port != 0 && port != 9 && port != 10)
 		return -EOPNOTSUPP;
 
+	if (on) {
+		err = mv88e6393x_serdes_erratum_4_8(chip, lane);
+		if (err)
+			return err;
+	}
+
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-- 
2.32.0

