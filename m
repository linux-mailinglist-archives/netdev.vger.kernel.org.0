Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC09125E09
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 10:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfLSJs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 04:48:29 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36919 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbfLSJs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 04:48:29 -0500
Received: from sapphire.lan (unknown [192.168.100.188])
        by mx.tkos.co.il (Postfix) with ESMTP id 8C2D0440044;
        Thu, 19 Dec 2019 11:48:27 +0200 (IST)
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Denis Odintsov <d.odintsov@traviangames.com>
Subject: [PATCH] net: dsa: mv88e6xxx: force cmode write on 6141/6341
Date:   Thu, 19 Dec 2019 11:48:22 +0200
Message-Id: <dd029665fdacef34a17f4fb8c5db4584211eacf6.1576748902.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mv88e6xxx_port_set_cmode() relies on cmode stored in struct
mv88e6xxx_port to skip cmode update when the requested value matches the
cached value. It turns out that mv88e6xxx_port_hidden_write() might
change the port cmode setting as a side effect, so we can't rely on the
cached value to determine that cmode update in not necessary.

Force cmode update in mv88e6341_port_set_cmode(), to make
serdes configuration work again. Other mv88e6xxx_port_set_cmode()
callers keep the current behaviour.

This fixes serdes configuration of the 6141 switch on SolidRun Clearfog
GT-8K.

Fixes: 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz family")
Reported-by: Denis Odintsov <d.odintsov@traviangames.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/net/dsa/mv88e6xxx/port.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 7fe256c5739d..0b43c650e100 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -393,7 +393,7 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int port)
 }
 
 static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
-				    phy_interface_t mode)
+				    phy_interface_t mode, bool force)
 {
 	u8 lane;
 	u16 cmode;
@@ -427,8 +427,8 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		cmode = 0;
 	}
 
-	/* cmode doesn't change, nothing to do for us */
-	if (cmode == chip->ports[port].cmode)
+	/* cmode doesn't change, nothing to do for us unless forced */
+	if (cmode == chip->ports[port].cmode && !force)
 		return 0;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
@@ -484,7 +484,7 @@ int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	if (port != 9 && port != 10)
 		return -EOPNOTSUPP;
 
-	return mv88e6xxx_port_set_cmode(chip, port, mode);
+	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
 }
 
 int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
@@ -504,7 +504,7 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		break;
 	}
 
-	return mv88e6xxx_port_set_cmode(chip, port, mode);
+	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
 }
 
 static int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip,
@@ -555,7 +555,7 @@ int mv88e6341_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	if (err)
 		return err;
 
-	return mv88e6xxx_port_set_cmode(chip, port, mode);
+	return mv88e6xxx_port_set_cmode(chip, port, mode, true);
 }
 
 int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode)
-- 
2.24.0

