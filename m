Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964F34D70F0
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 21:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbiCLU5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 15:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiCLU5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 15:57:06 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE5B1BAF33;
        Sat, 12 Mar 2022 12:55:59 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A5C9B22239;
        Sat, 12 Mar 2022 21:55:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647118558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vMgLswBA0/NbjgyCuBu9aMBgpNZnNIEHqc7S0Jyg3rE=;
        b=ce7amQ7BEY6accaQP6fbi3KtF154KsNPlUep2oetXRO2av6Gt1tVkxnBV+ee8kCBIjYKPN
        tqrDjAifF5sfhQsRjQuaPDjh0tbXI2MO2+hGoP1BmMtJqF+MwWeZNP3g0EWJOov41viXHM
        5Zlh0D3gfr2hrmr2QGHvPvWAmdRhZWs=
From:   Michael Walle <michael@walle.cc>
To:     Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: sfp: add 2500base-X quirk for Lantech SFP module
Date:   Sat, 12 Mar 2022 21:50:14 +0100
Message-Id: <20220312205014.4154907-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Lantech 8330-262D-E module is 2500base-X capable, but it reports the
nominal bitrate as 2500MBd instead of 3125MBd. Add a quirk for the
module.

The following in an EEPROM dump of such a SFP with the serial number
redacted:

00: 03 04 07 00 00 00 01 20 40 0c 05 01 19 00 00 00    ???...? @????...
10: 1e 0f 00 00 4c 61 6e 74 65 63 68 20 20 20 20 20    ??..Lantech
20: 20 20 20 20 00 00 00 00 38 33 33 30 2d 32 36 32        ....8330-262
30: 44 2d 45 20 20 20 20 20 56 31 2e 30 03 52 00 cb    D-E     V1.0?R.?
40: 00 1a 00 00 46 43 XX XX XX XX XX XX XX XX XX XX    .?..FCXXXXXXXXXX
50: 20 20 20 20 32 32 30 32 31 34 20 20 68 b0 01 98        220214  h???
60: 45 58 54 52 45 4d 45 4c 59 20 43 4f 4d 50 41 54    EXTREMELY COMPAT
70: 49 42 4c 45 20 20 20 20 20 20 20 20 20 20 20 20    IBLE

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/sfp-bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index c1512c9925a6..15aa5ac1ff49 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -74,6 +74,12 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "HUAWEI",
 		.part = "MA5671A",
 		.modes = sfp_quirk_2500basex,
+	}, {
+		// Lantech 8330-262D-E can operate at 2500base-X, but
+		// incorrectly report 2500MBd NRZ in their EEPROM
+		.vendor = "Lantech",
+		.part = "8330-262D-E",
+		.modes = sfp_quirk_2500basex,
 	}, {
 		.vendor = "UBNT",
 		.part = "UF-INSTANT",
-- 
2.30.2

