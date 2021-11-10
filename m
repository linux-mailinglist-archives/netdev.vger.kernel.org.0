Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6249544BAC9
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 05:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhKJENB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 23:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230221AbhKJENB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 23:13:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64AC261175;
        Wed, 10 Nov 2021 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636517414;
        bh=lGWXUPNYIop3Kr0Hyv5xk+Yma0Bq3F+ZWD02gZT6s9M=;
        h=From:To:Cc:Subject:Date:From;
        b=rXnxQpM08iAGGY5v4FYLJVA4YeRjagf9ceTaHWNZfbodJBu4Cr16hFoP9PlaQ7B+K
         jw5rlWr68kqB+IiSaLCAogTMWMSmjuJkyt5hNULUeCigHMqUeDl4+Le+sLZbSKtCBY
         445iXeS0x3Iu+hslNNnbr4f+/3xAvfusfPXqlTWDA2OE8oPGPrsbdO/fDBwtBOu127
         IrLYAj9sZuX8DP58exQsdrqT2TxU1o9+OTUgUKlQkmzmQtvcyefzd9RJ0s4iYr5lBQ
         KrRVQiYe7k74yjGVIB2XLaUTZMXYETfmmM1bAemdHKJdhix9eEcGiVrkOrR+Dpg/Cp
         xZlBcbpiO+qag==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 1/3] net: dsa: mv88e6xxx: Fix forcing speed & duplex when changing to 2500base-x mode
Date:   Wed, 10 Nov 2021 05:10:08 +0100
Message-Id: <20211110041010.2402-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings
in mac_config") removed forcing of speed and duplex from
mv88e6xxx_mac_config(), where the link is forced down, and left it only
in mv88e6xxx_mac_link_up(), by which time link is unforced.

It seems that in 2500base-x (at least on 88E6190), if the link is not
forced down, the forcing of new settings for speed and duplex doesn't
take.

Fix this by forcing link down.

Fixes: 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings in mac_config")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f00cbf5753b9..ddb13cecb3ac 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -785,12 +785,17 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 	if ((!mv88e6xxx_phy_is_internal(ds, port) &&
 	     !mv88e6xxx_port_ppu_updates(chip, port)) ||
 	    mode == MLO_AN_FIXED) {
-		/* FIXME: for an automedia port, should we force the link
-		 * down here - what if the link comes up due to "other" media
-		 * while we're bringing the port up, how is the exclusivity
-		 * handled in the Marvell hardware? E.g. port 2 on 88E6390
-		 * shared between internal PHY and Serdes.
+		/* FIXME: we need to force the link down here, otherwise the
+		 * forcing of link speed and duplex by .port_set_speed_duplex()
+		 * doesn't work for some modes.
+		 * But what if the link comes up due to "other" media while
+		 * we're bringing the port up, how is the exclusivity handled in
+		 * the Marvell hardware? E.g. port 2 on 88E6390 shared between
+		 * internal PHY and Serdes.
 		 */
+		if (ops->port_sync_link)
+			err = ops->port_sync_link(chip, port, mode, false);
+
 		err = mv88e6xxx_serdes_pcs_link_up(chip, port, mode, speed,
 						   duplex);
 		if (err)
-- 
2.32.0

