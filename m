Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747AB1A9DE1
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 13:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897643AbgDOLr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409338AbgDOLq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:46:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1987521582;
        Wed, 15 Apr 2020 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951215;
        bh=2I6y3vuOUo/PyL/oaOcUw3u8Ki9kFdjaK/cLRcZ80SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPhnuhqDxLJQ7jVSD9/0jbJ66aoYhLi+RdQjjmufZwslO5XPiB6ocTafHzKll+gnH
         PZknVEL0OqgGzr0ZWunl0t0sm68R7vfSHnb2O0/ZQEGCUI4lxmuxTOihA9P9cb5CRB
         JiFzMqrvWCOmMxBZvYq2O6UR2ToB+/B7ZdcH6KLk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 27/40] net: phy: micrel: kszphy_resume(): add delay after genphy_resume() before accessing PHY registers
Date:   Wed, 15 Apr 2020 07:46:10 -0400
Message-Id: <20200415114623.14972-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114623.14972-1-sashal@kernel.org>
References: <20200415114623.14972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 6110dff776f7fa65c35850ef65b41d3b39e2fac2 ]

After the power-down bit is cleared, the chip internally triggers a
global reset. According to the KSZ9031 documentation, we have to wait at
least 1ms for the reset to finish.

If the chip is accessed during reset, read will return 0xffff, while
write will be ignored. Depending on the system performance and MDIO bus
speed, we may or may not run in to this issue.

This bug was discovered on an iMX6QP system with KSZ9031 PHY and
attached PHY interrupt line. If IRQ was used, the link status update was
lost. In polling mode, the link status update was always correct.

The investigation showed, that during a read-modify-write access, the
read returned 0xffff (while the chip was still in reset) and
corresponding write hit the chip _after_ reset and triggered (due to the
0xffff) another reset in an undocumented bit (register 0x1f, bit 1),
resulting in the next write being lost due to the new reset cycle.

This patch fixes the issue by adding a 1...2 ms sleep after the
genphy_resume().

Fixes: 836384d2501d ("net: phy: micrel: Add specific suspend")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index b4c67c3a928b5..55caaaf969da5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -29,6 +29,7 @@
 #include <linux/micrel_phy.h>
 #include <linux/of.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 
 /* Operation Mode Strap Override */
 #define MII_KSZPHY_OMSO				0x16
@@ -738,6 +739,12 @@ static int kszphy_resume(struct phy_device *phydev)
 
 	genphy_resume(phydev);
 
+	/* After switching from power-down to normal mode, an internal global
+	 * reset is automatically generated. Wait a minimum of 1 ms before
+	 * read/write access to the PHY registers.
+	 */
+	usleep_range(1000, 2000);
+
 	ret = kszphy_config_reset(phydev);
 	if (ret)
 		return ret;
-- 
2.20.1

