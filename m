Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF5B491BBF
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346537AbiARDI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352970AbiARDAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:00:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F26BC08E87C;
        Mon, 17 Jan 2022 18:46:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25AAEB81233;
        Tue, 18 Jan 2022 02:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B82C36AEF;
        Tue, 18 Jan 2022 02:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474011;
        bh=P4LRLYfBnppbrKJ1scYlXS9vu/+G92DlHEynEYWCRLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9IRoXZqqRwQd9eQg/+Pf3CopvfEo58xFSLemqKua1KtjIeR3raBngd6vVz3a+iBu
         fnlRANDTL3ZCnEZRQbtAHqtKcUm3mFYBlap1R+fRtlX+6ATRmaw/0obPCWq04sST+M
         6m73Hdmhmm8rmXLBvpFpXapieuclcx7jvbwBSqgiV0UqtXRVJNHforX02vJXgygenq
         eSmbOZt+PQVauUlOBOZWJWDH2TzlZcrWiGw1n7cjbeY9WitRlRongmrHmot29+Mmv1
         1xEVskvShoVxLINKMv4Ob1GfHkyPN57f0lARMowjJpH7Bz66qb1lUFgcJmY/+ehYIe
         OPkTv6EnoKX4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ulli.kroll@googlemail.com,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 68/73] net: gemini: allow any RGMII interface mode
Date:   Mon, 17 Jan 2022 21:44:27 -0500
Message-Id: <20220118024432.1952028-68-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

[ Upstream commit 4e4f325a0a55907b14f579e6b1a38c53755e3de2 ]

The four RGMII interface modes take care of the required RGMII delay
configuration at the PHY and should not be limited by the network MAC
driver. Sadly, gemini was only permitting RGMII mode with no delays,
which would require the required delay to be inserted via PCB tracking
or by the MAC.

However, there are designs that require the PHY to add the delay, which
is impossible without Gemini permitting the other three PHY interface
modes. Fix the driver to allow these.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Link: https://lore.kernel.org/r/E1n4mpT-002PLd-Ha@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index c9fb1ec625d8b..a8a8b77c1611e 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -304,21 +304,21 @@ static void gmac_speed_set(struct net_device *netdev)
 	switch (phydev->speed) {
 	case 1000:
 		status.bits.speed = GMAC_SPEED_1000;
-		if (phydev->interface == PHY_INTERFACE_MODE_RGMII)
+		if (phy_interface_mode_is_rgmii(phydev->interface))
 			status.bits.mii_rmii = GMAC_PHY_RGMII_1000;
 		netdev_dbg(netdev, "connect %s to RGMII @ 1Gbit\n",
 			   phydev_name(phydev));
 		break;
 	case 100:
 		status.bits.speed = GMAC_SPEED_100;
-		if (phydev->interface == PHY_INTERFACE_MODE_RGMII)
+		if (phy_interface_mode_is_rgmii(phydev->interface))
 			status.bits.mii_rmii = GMAC_PHY_RGMII_100_10;
 		netdev_dbg(netdev, "connect %s to RGMII @ 100 Mbit\n",
 			   phydev_name(phydev));
 		break;
 	case 10:
 		status.bits.speed = GMAC_SPEED_10;
-		if (phydev->interface == PHY_INTERFACE_MODE_RGMII)
+		if (phy_interface_mode_is_rgmii(phydev->interface))
 			status.bits.mii_rmii = GMAC_PHY_RGMII_100_10;
 		netdev_dbg(netdev, "connect %s to RGMII @ 10 Mbit\n",
 			   phydev_name(phydev));
@@ -388,6 +388,9 @@ static int gmac_setup_phy(struct net_device *netdev)
 		status.bits.mii_rmii = GMAC_PHY_GMII;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
 		netdev_dbg(netdev,
 			   "RGMII: set GMAC0 and GMAC1 to MII/RGMII mode\n");
 		status.bits.mii_rmii = GMAC_PHY_RGMII_100_10;
-- 
2.34.1

