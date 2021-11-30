Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAE0463C6D
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244535AbhK3RFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:05:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45564 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244559AbhK3RF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:05:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E3ADBCE186C
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 17:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CA8C53FCF;
        Tue, 30 Nov 2021 17:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638291725;
        bh=4zp+GQeJrJLq3o3CUHkrxkW8sYrbZ8kTyi967TAK/WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRD31bMFjX6adZTdYdfUwTOcx6ecA4R6UI+wZATJD631G5IcBbuWMAiAa4hxBm4Ky
         kx7LyffhidOvoJWO4YrR9po0SX+yu7XXAelkK1U/XnRVZJczv8lVkz/h1o7ZM9aZqY
         HsXMMmXm3j+DREZTwSgb2GA+VB36Mk7IoE48p87qTEqRYEIppy6O1voH5FsoVvOSZh
         +LDW+Mz7YiMNrwah7NgD9B5BEddGSRj1LcePRhaXjEJVQPF+D5rrWZ/k337BSJyLhA
         TMfBoc+w46KLihepx6MptrkUv5Mo38ckBoYjJ2w4QvkqtF86kkPRWzIPyDbMZhQeMw
         nHcMy9rCeJvLA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 4/6] net: dsa: mv88e6xxx: Add fix for erratum 5.2 of 88E6393X family
Date:   Tue, 30 Nov 2021 18:01:49 +0100
Message-Id: <20211130170151.7741-5-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211130170151.7741-1-kabel@kernel.org>
References: <20211130170151.7741-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add fix for erratum 5.2 of the 88E6393X (Amethyst) family: for 10gbase-r
mode, some undocumented registers need to be written some special
values.

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 48 ++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index ceb63d7f1f97..9e4f18a4adc2 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1375,6 +1375,50 @@ static int mv88e6393x_serdes_erratum_4_8(struct mv88e6xxx_chip *chip, int lane)
 				      MV88E6393X_ERRATA_4_8_REG, reg);
 }
 
+static int mv88e6393x_serdes_erratum_5_2(struct mv88e6xxx_chip *chip, int lane,
+					 u8 cmode)
+{
+	static const struct {
+		u16 dev, reg, val, mask;
+	} fixes[] = {
+		{ MDIO_MMD_VEND1, 0x8093, 0xcb5a, 0xffff },
+		{ MDIO_MMD_VEND1, 0x8171, 0x7088, 0xffff },
+		{ MDIO_MMD_VEND1, 0x80c9, 0x311a, 0xffff },
+		{ MDIO_MMD_VEND1, 0x80a2, 0x8000, 0xff7f },
+		{ MDIO_MMD_VEND1, 0x80a9, 0x0000, 0xfff0 },
+		{ MDIO_MMD_VEND1, 0x80a3, 0x0000, 0xf8ff },
+		{ MDIO_MMD_PHYXS, MV88E6393X_SERDES_POC,
+		  MV88E6393X_SERDES_POC_RESET, MV88E6393X_SERDES_POC_RESET },
+	};
+	int err, i;
+	u16 reg;
+
+	/* mv88e6393x family errata 5.2:
+	 * For optimal signal integrity the following sequence should be applied
+	 * to SERDES operating in 10G mode. These registers only apply to 10G
+	 * operation and have no effect on other speeds.
+	 */
+	if (cmode != MV88E6393X_PORT_STS_CMODE_10GBASER)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(fixes); ++i) {
+		err = mv88e6390_serdes_read(chip, lane, fixes[i].dev,
+					    fixes[i].reg, &reg);
+		if (err)
+			return err;
+
+		reg &= ~fixes[i].mask;
+		reg |= fixes[i].val;
+
+		err = mv88e6390_serdes_write(chip, lane, fixes[i].dev,
+					     fixes[i].reg, reg);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			    bool on)
 {
@@ -1389,6 +1433,10 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 		if (err)
 			return err;
 
+		err = mv88e6393x_serdes_erratum_5_2(chip, lane, cmode);
+		if (err)
+			return err;
+
 		err = mv88e6393x_serdes_power_lane(chip, lane, true);
 		if (err)
 			return err;
-- 
2.32.0

