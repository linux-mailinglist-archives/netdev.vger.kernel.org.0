Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5747A100B3B
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 19:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfKRSPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 13:15:10 -0500
Received: from mail.nic.cz ([217.31.204.67]:45742 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfKRSPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 13:15:10 -0500
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 44C10140E2A;
        Mon, 18 Nov 2019 19:15:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1574100908; bh=v6bWYIyj074NmdDlsGtesUb2BMXwLYHbDWo662pPLbw=;
        h=From:To:Date;
        b=kWAPiINj5khDJ63iBe7RhgsNofMV1hCkEXS/Ec3e1yTLW0vMepuyU0R11a86krJ2u
         uZC+PbBCI1iZDxFJMvl4Ik4UexKqd2xAEiJKHHbxWNyEvAU+IQxVpZoVLInmood1+t
         yBNDeSgwzlbtS0zgNCkuTh8wrRsf8/eKE11lhAf8=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH net 1/1] mdio_bus: fix mdio_register_device when RESET_CONTROLLER is disabled
Date:   Mon, 18 Nov 2019 19:15:05 +0100
Message-Id: <20191118181505.32298-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_RESET_CONTROLLER is disabled, the
devm_reset_control_get_exclusive function returns -ENOTSUPP. This is not
handled in subsequent check and then the mdio device fails to probe.

When CONFIG_RESET_CONTROLLER is enabled, its code checks in OF for reset
device, and since it is not present, returns -ENOENT. -ENOENT is handled.
Add -ENOTSUPP also.

This happened to me when upgrading kernel on Turris Omnia. You either
have to enable CONFIG_RESET_CONTROLLER or use this patch.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Fixes: 71dd6c0dff51b ("net: phy: add support for reset-controller")
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/phy/mdio_bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 35876562e32a..c87cb8c0dac8 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -65,7 +65,8 @@ static int mdiobus_register_reset(struct mdio_device *mdiodev)
 		reset = devm_reset_control_get_exclusive(&mdiodev->dev,
 							 "phy");
 	if (IS_ERR(reset)) {
-		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOSYS)
+		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOSYS ||
+		    PTR_ERR(reset) == -ENOTSUPP)
 			reset = NULL;
 		else
 			return PTR_ERR(reset);
-- 
2.23.0

