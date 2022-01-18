Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC593491BA4
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348426AbiARDID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346616AbiARCzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:55:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368F1C02B874;
        Mon, 17 Jan 2022 18:44:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F2B561294;
        Tue, 18 Jan 2022 02:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0A0C36AEF;
        Tue, 18 Jan 2022 02:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473852;
        bh=ol2K/mFxM9zFHaDlvcurMAIeCl5NIAM2EEHN/rnoa8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thoRvxvnQWRwdiY/sAu5RTTfVfILUJmVEJl7BRUN8FhOG+TJ+16DyTSA6uQhk46Dg
         tqBZtpMF4PKHssxKzHoWY0JFs4daxjZonNC4MRxR6vuGZcdjw/s0PyiGnv4jju/Gxu
         MbRcXOpT9WyGynHkPM2iGNXRQ/Pn/YoQ6Jwh6vibX1h3Aq/f8m+XlL53eSBgimnfAe
         jtwuBQGYNCDp1v6XMCCAU9KaztlBIQKXeK+WS4+G5Qb3glfvtXuC6MSV65mkPsdn1y
         OX9if3d7KtG+uFFLmWcJM583fV6LtfWpnLU0wQ0cz1lijrrIw5z8bancbcnjQlKfq6
         OfERYPa5JT4bQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 106/116] net: phy: marvell: configure RGMII delays for 88E1118
Date:   Mon, 17 Jan 2022 21:39:57 -0500
Message-Id: <20220118024007.1950576-106-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

[ Upstream commit f22725c95ececb703c3f741e8f946d23705630b7 ]

Corentin Labbe reports that the SSI 1328 does not work when allowing
the PHY to operate at gigabit speeds, but does work with the generic
PHY driver.

This appears to be because m88e1118_config_init() writes a fixed value
to the MSCR register, claiming that this is to enable 1G speeds.
However, this always sets bits 4 and 5, enabling RGMII transmit and
receive delays. The suspicion is that the original board this was
added for required the delays to make 1G speeds work.

Add the necessary configuration for RGMII delays for the 88E1118 to
bring this into line with the requirements for RGMII support, and thus
make the SSI 1328 work.

Corentin Labbe has tested this on gemini-ssi1328 and gemini-ns2502.

Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 91616182c311f..4dda2ab19c265 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1090,6 +1090,12 @@ static int m88e1118_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	if (phy_interface_is_rgmii(phydev)) {
+		err = m88e1121_config_aneg_rgmii_delays(phydev);
+		if (err < 0)
+			return err;
+	}
+
 	/* Adjust LED Control */
 	if (phydev->dev_flags & MARVELL_PHY_M1118_DNS323_LEDS)
 		err = phy_write(phydev, 0x10, 0x1100);
-- 
2.34.1

