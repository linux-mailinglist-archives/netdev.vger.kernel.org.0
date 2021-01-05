Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723062EAFCB
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 17:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbhAEQMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 11:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbhAEQMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 11:12:33 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6583EC061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 08:11:53 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D9HYz6dvFz1rvRr;
        Tue,  5 Jan 2021 17:11:50 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D9HYy50V3z1sFWD;
        Tue,  5 Jan 2021 17:11:50 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id qlTinmemI8aA; Tue,  5 Jan 2021 17:11:49 +0100 (CET)
X-Auth-Info: xHYG12thx9rTYmIxZ3h4eYy6YlUyIW6A/70qDYk2dM8=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  5 Jan 2021 17:11:49 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] net: phy: Trigger link_change_notify on PHY_HALTED
Date:   Tue,  5 Jan 2021 17:11:36 +0100
Message-Id: <20210105161136.250631-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the PHY transitions to PHY_HALTED state in phy_stop(), the
link_change_notify callback is not triggered. That's because the
phydev->state = PHY_HALTED in phy_stop() is assigned first, and
phy_state_machine() is called afterward. For phy_state_machine(),
no state transition happens, because old_state = PHY_HALTED and
phy_dev->state = PHY_HALTED.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 45f75533c47c..fca8c3eebc5d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1004,6 +1004,7 @@ EXPORT_SYMBOL(phy_free_interrupt);
 void phy_stop(struct phy_device *phydev)
 {
 	struct net_device *dev = phydev->attached_dev;
+	enum phy_state old_state;
 
 	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
 		WARN(1, "called from state %s\n",
@@ -1021,8 +1022,17 @@ void phy_stop(struct phy_device *phydev)
 	if (phydev->sfp_bus)
 		sfp_upstream_stop(phydev->sfp_bus);
 
+	old_state = phydev->state;
 	phydev->state = PHY_HALTED;
 
+	if (old_state != phydev->state) {
+		phydev_err(phydev, "PHY state change %s -> %s\n",
+			   phy_state_to_str(old_state),
+			   phy_state_to_str(phydev->state));
+		if (phydev->drv && phydev->drv->link_change_notify)
+			phydev->drv->link_change_notify(phydev);
+	}
+
 	mutex_unlock(&phydev->lock);
 
 	phy_state_machine(&phydev->state_queue.work);
-- 
2.29.2

