Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A065026B01
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbfEVTXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730031AbfEVTXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:23:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796652184E;
        Wed, 22 May 2019 19:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553003;
        bh=71QAfk99M4sfT3rVXD7gj5hEQZsBkP3Vcnj/0ePOejU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZzR7YT7nnDY28GLMKZanOzBpKh81+N2G6H2EaQ6BxmzwCe5OECvRGP/IUy30/VMT
         2SZGloHMqwAi4TEMFfYzgR+aQdKy+3RE0kFn+jZgg26R1OHFql8WtGpuhk3XumMfMt
         DwCTBcjOJZnaubzoZ0PeeLajuLsFbDd7sXglnFE8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 071/375] net: phy: improve genphy_soft_reset
Date:   Wed, 22 May 2019 15:16:11 -0400
Message-Id: <20190522192115.22666-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 8c90b795e90f7753d23c18e8b95dd71b4a18c5d9 ]

PHY's behave differently when being reset. Some reset registers to
defaults, some don't. Some trigger an autoneg restart, some don't.

So let's also set the autoneg restart bit when resetting. Then PHY
behavior should be more consistent. Clearing BMCR_ISOLATE serves the
same purpose and is borrowed from genphy_restart_aneg.

BMCR holds the speed / duplex settings in fixed mode. Therefore
we may have an issue if a soft reset resets BMCR to its default.
So better call genphy_setup_forced() afterwards in fixed mode.
We've seen no related complaint in the last >10 yrs, so let's
treat it as an improvement.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cd5966b0db571..f6a6cc5bf118d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1829,13 +1829,25 @@ EXPORT_SYMBOL(genphy_read_status);
  */
 int genphy_soft_reset(struct phy_device *phydev)
 {
+	u16 res = BMCR_RESET;
 	int ret;
 
-	ret = phy_set_bits(phydev, MII_BMCR, BMCR_RESET);
+	if (phydev->autoneg == AUTONEG_ENABLE)
+		res |= BMCR_ANRESTART;
+
+	ret = phy_modify(phydev, MII_BMCR, BMCR_ISOLATE, res);
 	if (ret < 0)
 		return ret;
 
-	return phy_poll_reset(phydev);
+	ret = phy_poll_reset(phydev);
+	if (ret)
+		return ret;
+
+	/* BMCR may be reset to defaults */
+	if (phydev->autoneg == AUTONEG_DISABLE)
+		ret = genphy_setup_forced(phydev);
+
+	return ret;
 }
 EXPORT_SYMBOL(genphy_soft_reset);
 
-- 
2.20.1

