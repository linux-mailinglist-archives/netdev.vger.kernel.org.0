Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE7913E3A3
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388590AbgAPRDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:03:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388549AbgAPRDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:03:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E656124684;
        Thu, 16 Jan 2020 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194187;
        bh=h6uK8wo0qtyjOiISqKhtgbl/70dLIpaqIJZqKBaqWVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XnViwBo1BUK+lRH+9P86vY3hn6cmUg/T1BuCGFE0xTwovCTgJpvVG31OxG4BU7aAt
         w1MrIuO1tQnIApipWzvJI5hakvNwRornWUybmGA6y7uZQMLH6apbdHm9v26L02X3RZ
         fdMrRS1MZAimW921dbCTZFFccp7U4OPs2p0J71KM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Phil Reid <preid@electromag.com.au>,
        liweihang <liweihang@hisilicon.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 260/671] net: phy: don't clear BMCR in genphy_soft_reset
Date:   Thu, 16 Jan 2020 11:52:49 -0500
Message-Id: <20200116165940.10720-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit d29f5aa0bc0c321e1b9e4658a2a7e08e885da52a ]

So far we effectively clear the BMCR register. Some PHY's can deal
with this (e.g. because they reset BMCR to a default as part of a
soft-reset) whilst on others this causes issues because e.g. the
autoneg bit is cleared. Marvell is an example, see also thread [0].
So let's be a little bit more gentle and leave all bits we're not
interested in as-is. This change is needed for PHY drivers to
properly deal with the original patch.

[0] https://marc.info/?t=155264050700001&r=1&w=2

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Tested-by: Phil Reid <preid@electromag.com.au>
Tested-by: liweihang <liweihang@hisilicon.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9c7e51443f6b..ae40d8137fd2 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1657,7 +1657,7 @@ int genphy_soft_reset(struct phy_device *phydev)
 {
 	int ret;
 
-	ret = phy_write(phydev, MII_BMCR, BMCR_RESET);
+	ret = phy_set_bits(phydev, MII_BMCR, BMCR_RESET);
 	if (ret < 0)
 		return ret;
 
-- 
2.20.1

