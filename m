Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D998921F
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 17:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfHKPIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 11:08:15 -0400
Received: from mail.nic.cz ([217.31.204.67]:50426 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfHKPIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 11:08:15 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 2C852140AF8;
        Sun, 11 Aug 2019 17:08:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565536093; bh=63hpz9X1d4h8UOFdTkL0pziBy+mG6P1Hxi1huXlX5dA=;
        h=From:To:Date;
        b=CVcanJRqbnXgmildjgYa9szymQXfqRdc/WqqmiK5gyIyceaaQcmx6zLxHl86bVHzM
         LUWJKzbHzqHj+RsfSpu7/KHGBkJdlElSv2BeA/x9+Fj5LMAeToVIIE8F2PhYUheYPK
         dNvDplO5ggqxpiIFnh2Ia/S6duVMX0mW8ZnImP1E=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next 2/2] net: fixed_phy: set is_gigabit_capable member when needed
Date:   Sun, 11 Aug 2019 17:08:12 +0200
Message-Id: <20190811150812.6780-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190811150812.6780-1-marek.behun@nic.cz>
References: <20190811150812.6780-1-marek.behun@nic.cz>
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

The fixed_phy driver does not set the phydev->is_gigabit_capable member
when the fixed_phy is gigabit capable. This in turn causes
phy_device.c:genphy_read_status function to return unknown phy
parameters (SPEED_UNKNOWN, DUPLEX_UNKNOWN, ...), if the fixed_phy is
created with SPEED_1000.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/phy/fixed_phy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 3ffe46df249e..424b02ad7b7b 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -286,6 +286,7 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 				 phy->supported);
 		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
 				 phy->supported);
+		phy->is_gigabit_capable = 1;
 		/* fall through */
 	case SPEED_100:
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
-- 
2.21.0

