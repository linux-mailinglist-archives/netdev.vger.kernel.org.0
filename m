Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D969374121
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbhEEQgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234162AbhEEQeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:34:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 021B561423;
        Wed,  5 May 2021 16:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232356;
        bh=SZH2iEu/9UXu1MA/l2N2zkqcul96f+NDS4x1UCqNgog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVH/HugtYcZmn2mAOmcRAsTmr7pjqRUcBdTOdcGe4u7sl+afokM4lU98pEKPtMHnB
         t2KEO8ZI9LEcxdJpOwaMVRP/3ukVeH6bxGoohj7DNuVEFN8y2gbcKjK/SYRn1naAp6
         uNcJ98Ku6dI7RZ/pgpxaqi+ptUgE5C/QLILU568Xiroi43ne7lQW3PuqQMK3VjOqWY
         xpY78JUdHcEjy15OzpXo072qIY9dxzD42/Xoa+5Shn+NvvFrYqlfPjhXMXR1Oc5ZfA
         u7ul8mOcxR9V3SF8VW+CR/zZzJdJ2CsdS4roQXbApf9EbryTdkeXrTOF5/eiJScxsU
         Rl3EibUwaEfpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 052/116] net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM
Date:   Wed,  5 May 2021 12:30:20 -0400
Message-Id: <20210505163125.3460440-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit fba863b816049b03f3fbb07b10ebdcfe5c4141f7 ]

Resume callback of the PHY driver is called after the one for the MAC
driver. The PHY driver resume callback calls phy_init_hw(), and this is
potentially problematic if the MAC driver calls phy_start() in its resume
callback. One issue was reported with the fec driver and a KSZ8081 PHY
which seems to become unstable if a soft reset is triggered during aneg.

The new flag allows MAC drivers to indicate that they take care of
suspending/resuming the PHY. Then the MAC PM callbacks can handle
any dependency between MAC and PHY PM.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 include/linux/phy.h          | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index cc38e326405a..af2e1759b523 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -273,6 +273,9 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
+	if (phydev->mac_managed_pm)
+		return 0;
+
 	/* We must stop the state machine manually, otherwise it stops out of
 	 * control, possibly with the phydev->lock held. Upon resume, netdev
 	 * may call phy routines that try to grab the same lock, and that may
@@ -294,6 +297,9 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
 
+	if (phydev->mac_managed_pm)
+		return 0;
+
 	if (!phydev->suspended_by_mdio_bus)
 		goto no_resume;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1a12e4436b5b..8644b097dea3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -493,6 +493,7 @@ struct macsec_ops;
  * @loopback_enabled: Set true if this PHY has been loopbacked successfully.
  * @downshifted_rate: Set true if link speed has been downshifted.
  * @is_on_sfp_module: Set true if PHY is located on an SFP module.
+ * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming PHY
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
  * @irq: IRQ number of the PHY's interrupt (-1 if none)
@@ -567,6 +568,7 @@ struct phy_device {
 	unsigned loopback_enabled:1;
 	unsigned downshifted_rate:1;
 	unsigned is_on_sfp_module:1;
+	unsigned mac_managed_pm:1;
 
 	unsigned autoneg:1;
 	/* The most recently read link state */
-- 
2.30.2

