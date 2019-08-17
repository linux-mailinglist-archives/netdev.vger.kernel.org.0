Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626E1912A3
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfHQTPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:15:00 -0400
Received: from mail.nic.cz ([217.31.204.67]:41656 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfHQTPA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Aug 2019 15:15:00 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 244AB140B54;
        Sat, 17 Aug 2019 21:14:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566069298; bh=qicFrCIaUQafmC2tXbYuA0sqLyoW/+M2sqPggITw7PA=;
        h=From:To:Date;
        b=KrTbl7mm/zCI2zzcnF4DicypyLXYjNLmIpVTfZdka607PSJg8I8umdFKuARsDA0PV
         g7F7S9nmWioXCRiGHZGcZIrBHw5x1j9p1dg7GgOphYN4YetwW/yRD4fEiLJQVzls5C
         TPuPEATG0G+r3uvBjiOHSPLtG0mWW+I5gf0C+MYU=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC v2 net-next 4/4] net: dsa: mv88e6xxx: do not enable SERDESes in mv88e6xxx_setup
Date:   Sat, 17 Aug 2019 21:14:52 +0200
Message-Id: <20190817191452.16716-5-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817191452.16716-1-marek.behun@nic.cz>
References: <20190817191452.16716-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPU/DSA ports are now enabled/disabled in the .port_enable() and
.port_disable() methods. We do not need to enable SERDESes for these
ports in mv88e6xxx_setup.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ad27f2fc5c33..cca9f1e2038f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2151,16 +2151,6 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	/* Enable the SERDES interface for DSA and CPU ports. Normal
-	 * ports SERDES are enabled when the port is enabled, thus
-	 * saving a bit of power.
-	 */
-	if ((dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))) {
-		err = mv88e6xxx_serdes_power(chip, port, true);
-		if (err)
-			return err;
-	}
-
 	/* Port Control 2: don't force a good FCS, set the maximum frame size to
 	 * 10240 bytes, disable 802.1q tags checking, don't discard tagged or
 	 * untagged frames on this port, do a destination address lookup on all
-- 
2.21.0

