Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5110013E27C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733223AbgAPQ4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbgAPQ4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BB6E24656;
        Thu, 16 Jan 2020 16:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193779;
        bh=Zp7hJQHNlxB0lEeVCZjAhIkUtvA5aJ58o8NvYuc8Nt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F8tse3r3P+m6FgLnoHr7YpbFKKj85NZ7u2PcB+niqAQ0dV1kW8/zQ35AIeZWLVvZe
         bFC6YK7uVx7ASMRKTPhfEg1vR2qmFMRtofk3hkX9ouJuSsnxG13QG90BELmyfOh3IV
         Ojh0WfdmbzD9Kc8aXZTcPN1l5r7xaSuy8s/g0FWQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 059/671] net: phy: Fix not to call phy_resume() if PHY is not attached
Date:   Thu, 16 Jan 2020 11:44:50 -0500
Message-Id: <20200116165502.8838-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit ef1b5bf506b1f0ee3edc98533e1f3ecb105eb46a ]

This patch fixes an issue that mdio_bus_phy_resume() doesn't call
phy_resume() if the PHY is not attached.

Fixes: 803dd9c77ac3 ("net: phy: avoid suspending twice a PHY")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 43c4f358eeb8..9c7e51443f6b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -76,7 +76,7 @@ static LIST_HEAD(phy_fixup_list);
 static DEFINE_MUTEX(phy_fixup_lock);
 
 #ifdef CONFIG_PM
-static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
+static bool mdio_bus_phy_may_suspend(struct phy_device *phydev, bool suspend)
 {
 	struct device_driver *drv = phydev->mdio.dev.driver;
 	struct phy_driver *phydrv = to_phy_driver(drv);
@@ -88,10 +88,11 @@ static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 	/* PHY not attached? May suspend if the PHY has not already been
 	 * suspended as part of a prior call to phy_disconnect() ->
 	 * phy_detach() -> phy_suspend() because the parent netdev might be the
-	 * MDIO bus driver and clock gated at this point.
+	 * MDIO bus driver and clock gated at this point. Also may resume if
+	 * PHY is not attached.
 	 */
 	if (!netdev)
-		return !phydev->suspended;
+		return suspend ? !phydev->suspended : phydev->suspended;
 
 	if (netdev->wol_enabled)
 		return false;
@@ -126,7 +127,7 @@ static int mdio_bus_phy_suspend(struct device *dev)
 	if (phydev->attached_dev && phydev->adjust_link)
 		phy_stop_machine(phydev);
 
-	if (!mdio_bus_phy_may_suspend(phydev))
+	if (!mdio_bus_phy_may_suspend(phydev, true))
 		return 0;
 
 	return phy_suspend(phydev);
@@ -137,7 +138,7 @@ static int mdio_bus_phy_resume(struct device *dev)
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
 
-	if (!mdio_bus_phy_may_suspend(phydev))
+	if (!mdio_bus_phy_may_suspend(phydev, false))
 		goto no_resume;
 
 	ret = phy_resume(phydev);
-- 
2.20.1

