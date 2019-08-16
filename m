Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1DE59045E
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 17:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfHPPIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 11:08:40 -0400
Received: from mail.nic.cz ([217.31.204.67]:32854 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727324AbfHPPIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 11:08:40 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id B23C2140CB0;
        Fri, 16 Aug 2019 17:08:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565968118; bh=8DF58wQ/NBbU8KWt+7T6HG9zZof54j8WmIdUCzlFNjY=;
        h=From:To:Date;
        b=qXvo9Xh0DyMl5feyDnEZxq0hxPbOrqIypEnj7zJUrjLt5t0LfJg1lGEdEjxO5FCpE
         ov+4qg6pqLtNFTReWG6mzxjM2TIwu2syExp4L1N/crW0TeI7O5oif9J8723rum0CF5
         btqlb4uqkfqKI+w8VTwOffwwiW4trxe6NZar6sQk=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC net-next 1/3] net: dsa: mv88e6xxx: support 2500base-x in SGMII IRQ handler
Date:   Fri, 16 Aug 2019 17:08:32 +0200
Message-Id: <20190816150834.26939-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816150834.26939-1-marek.behun@nic.cz>
References: <20190816150834.26939-1-marek.behun@nic.cz>
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

The mv88e6390_serdes_irq_link_sgmii IRQ handler reads the SERDES PHY
status register to determine speed, among other things. If cmode of the
port is set to 2500base-x, though, the PHY still reports 1000 Mbps (the
PHY register itself does not differentiate between 1000 Mbps and 2500
Mbps - it thinks it is running at 1000 Mbps, although clock is 2.5x
faster).
Look at the cmode and set SPEED_2500 if cmode is set to 2500base-x.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 20c526c2a9ee..17bb4a705d44 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -506,6 +506,7 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 					    int port, int lane)
 {
 	struct dsa_switch *ds = chip->ds;
+	u8 cmode = chip->ports[port].cmode;
 	int duplex = DUPLEX_UNKNOWN;
 	int speed = SPEED_UNKNOWN;
 	int link, err;
@@ -527,7 +528,10 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 
 		switch (status & MV88E6390_SGMII_PHY_STATUS_SPEED_MASK) {
 		case MV88E6390_SGMII_PHY_STATUS_SPEED_1000:
-			speed = SPEED_1000;
+			if (cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
+				speed = SPEED_2500;
+			else
+				speed = SPEED_1000;
 			break;
 		case MV88E6390_SGMII_PHY_STATUS_SPEED_100:
 			speed = SPEED_100;
-- 
2.21.0

