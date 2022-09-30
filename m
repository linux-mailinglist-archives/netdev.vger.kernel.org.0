Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BD45F0D71
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiI3OW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiI3OVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DD11A40A6
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A24662345
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FA5C433D6;
        Fri, 30 Sep 2022 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547691;
        bh=dqvGVUC3xYXObjy+O8LOheHQNjMrNrcJVoWpNm6hqrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYhUj2alSPRC5TktBVJ1hxstGddzmP2ewgZXtvaU8h+uc5ZKax4llE/YOtsmAO0Am
         +2K3Yr+tWAZ56fVIG91e+AFkMiaAb+W9AhHWH0FuadvKw+7zdk/AFFz4gvmxkBgiVl
         E7f0ojGRqcmxewszD8gTJKk/LuyxhnsBJZtmP0LQJTXOlIYpFKzBpbhGbvUWvLktJZ
         mnXDncQR/6sulp9MiNsnxza4jJZVU+0klb90trnYD1Dq3y9zEP2PLkcDr5zin5kCfO
         IX0yXERNyK54W3Y3uIp/5N9iJSfEP5sB+0s+s9yD5VBejUbrHn1HoPYZjdszz4G2kR
         BaSEeLa+fHeyA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 09/12] net: sfp: Add and use macros for SFP quirks definitions
Date:   Fri, 30 Sep 2022 16:21:07 +0200
Message-Id: <20220930142110.15372-10-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930142110.15372-1-kabel@kernel.org>
References: <20220930142110.15372-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros SFP_QUIRK(), SFP_QUIRK_M() and SFP_QUIRK_F() for defining SFP
quirk table entries. Use them to deduplicate the code a little bit.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/sfp.c | 61 ++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index b150e4765819..3201e2726e61 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -350,42 +350,33 @@ static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, modes);
 }
 
+#define SFP_QUIRK(_v, _p, _m, _f) \
+	{ .vendor = _v, .part = _p, .modes = _m, .fixup = _f, }
+#define SFP_QUIRK_M(_v, _p, _m) SFP_QUIRK(_v, _p, _m, NULL)
+#define SFP_QUIRK_F(_v, _p, _f) SFP_QUIRK(_v, _p, NULL, _f)
+
 static const struct sfp_quirk sfp_quirks[] = {
-	{
-		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
-		// incorrectly report 2500MBd NRZ in their EEPROM
-		.vendor = "ALCATELLUCENT",
-		.part = "G010SP",
-		.modes = sfp_quirk_2500basex,
-	}, {
-		// Alcatel Lucent G-010S-A can operate at 2500base-X, but
-		// report 3.2GBd NRZ in their EEPROM
-		.vendor = "ALCATELLUCENT",
-		.part = "3FE46541AA",
-		.modes = sfp_quirk_2500basex,
-		.fixup = sfp_fixup_long_startup,
-	}, {
-		.vendor = "HALNy",
-		.part = "HL-GSFP",
-		.fixup = sfp_fixup_halny_gsfp,
-	}, {
-		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
-		// NRZ in their EEPROM
-		.vendor = "HUAWEI",
-		.part = "MA5671A",
-		.modes = sfp_quirk_2500basex,
-		.fixup = sfp_fixup_ignore_tx_fault,
-	}, {
-		// Lantech 8330-262D-E can operate at 2500base-X, but
-		// incorrectly report 2500MBd NRZ in their EEPROM
-		.vendor = "Lantech",
-		.part = "8330-262D-E",
-		.modes = sfp_quirk_2500basex,
-	}, {
-		.vendor = "UBNT",
-		.part = "UF-INSTANT",
-		.modes = sfp_quirk_ubnt_uf_instant,
-	}
+	// Alcatel Lucent G-010S-P can operate at 2500base-X, but incorrectly
+	// report 2500MBd NRZ in their EEPROM
+	SFP_QUIRK_M("ALCATELLUCENT", "G010SP", sfp_quirk_2500basex),
+
+	// Alcatel Lucent G-010S-A can operate at 2500base-X, but report 3.2GBd
+	// NRZ in their EEPROM
+	SFP_QUIRK("ALCATELLUCENT", "3FE46541AA", sfp_quirk_2500basex,
+		  sfp_fixup_long_startup),
+
+	SFP_QUIRK_F("HALNy", "HL-GSFP", sfp_fixup_halny_gsfp),
+
+	// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd NRZ in
+	// their EEPROM
+	SFP_QUIRK("HUAWEI", "MA5671A", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_tx_fault),
+
+	// Lantech 8330-262D-E can operate at 2500base-X, but incorrectly report
+	// 2500MBd NRZ in their EEPROM
+	SFP_QUIRK_M("Lantech", "8330-262D-E", sfp_quirk_2500basex),
+
+	SFP_QUIRK_M("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
 };
 
 static size_t sfp_strlen(const char *str, size_t maxlen)
-- 
2.35.1

