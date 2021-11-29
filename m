Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6053A462498
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhK2WW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbhK2WUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:20:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C70FC08EAC2
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 11:58:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0CBBCE13C4
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 19:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5946FC53FAD;
        Mon, 29 Nov 2021 19:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638215915;
        bh=SWbLfwOErx2yyDaBZPvSH2DuZYOdy/HZQveT9LMAIFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvmLtGJ4h5tdiPV5YXKkp1N2cGZ2XPt6HUU/qPoML7/BwULByZStkWn9Dr4eY66uj
         gmM2gq4V4Ar/KZJBpOemhWrkESqfSVYMyTeGtdsKQenPf2W7KSwaTNFcKyaX+aLyC+
         m0MaSFSwM6fkN4SWOhIs6EzPVuLk6Qs4zKHL3GCcM7UDIEznTa2mFcGWJARulBkeG2
         79oFlxt8nlyRp5XWLileusVTjmLZ8pEjiRtXlcYMwqLWnjWA7RZzXgg3zzQXkeqwRt
         rjMjyjgijq6G7V+cr3IETYjTuSyoyt06NL1uQtsQbOI8vT9LzqKVSZGn8PZ7GcVeQR
         r2nGwfEV1ukPg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 4/6] net: dsa: mv88e6xxx: Add fix for erratum 5.2 of 88E6393X family
Date:   Mon, 29 Nov 2021 20:58:21 +0100
Message-Id: <20211129195823.11766-5-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211129195823.11766-1-kabel@kernel.org>
References: <20211129195823.11766-1-kabel@kernel.org>
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
index 0d92bd814f3a..9901219780e6 100644
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

