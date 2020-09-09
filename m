Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABC12626D4
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 07:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgIIFnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 01:43:21 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:47059 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725772AbgIIFnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 01:43:20 -0400
X-IronPort-AV: E=Sophos;i="5.76,408,1592838000"; 
   d="scan'208";a="56534769"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 09 Sep 2020 14:43:19 +0900
Received: from localhost.localdomain (unknown [10.166.252.89])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 6E15C41D1D2F;
        Wed,  9 Sep 2020 14:43:19 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, Jisheng.Zhang@synaptics.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v2 RESEND] net: phy: call phy_disable_interrupts() in phy_attach_direct() instead
Date:   Wed,  9 Sep 2020 14:43:14 +0900
Message-Id: <1599630194-3052-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the micrel phy driver calls phy_init_hw() as a workaround,
the commit 9886a4dbd2aa ("net: phy: call phy_disable_interrupts()
in phy_init_hw()") disables the interrupt unexpectedly. So,
call phy_disable_interrupts() in phy_attach_direct() instead.
Otherwise, the phy cannot link up after the ethernet cable was
disconnected.

Note that other drivers (like at803x.c) also calls phy_init_hw().
So, perhaps, the driver caused a similar issue too.

Fixes: 9886a4dbd2aa ("net: phy: call phy_disable_interrupts() in phy_init_hw()")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 Changes from v1:
 - Fix build failure. I used two PCs: PC 1) for testing, PC 2) for
   submitting patches. I tested on the PC 1. But, after that, I wrote
   a patch on the PC2 again, and it seemed I didn't do a compile...
   Today, I got some emails from kernel test bot. So, I realized
   I had submitted an awful patch. To avoid such failure, I'll use
   one PC only from now on.

 drivers/net/phy/phy_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8adfbad..b93b40c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1143,10 +1143,6 @@ int phy_init_hw(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	ret = phy_disable_interrupts(phydev);
-	if (ret)
-		return ret;
-
 	if (phydev->drv->config_init)
 		ret = phydev->drv->config_init(phydev);
 
@@ -1423,6 +1419,10 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	if (err)
 		goto error;
 
+	err = phy_disable_interrupts(phydev);
+	if (err)
+		return err;
+
 	phy_resume(phydev);
 	phy_led_triggers_register(phydev);
 
-- 
2.7.4

