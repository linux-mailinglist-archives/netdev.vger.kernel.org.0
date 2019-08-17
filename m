Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED075912A2
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfHQTPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:15:00 -0400
Received: from mail.nic.cz ([217.31.204.67]:41650 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfHQTO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Aug 2019 15:14:59 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 03ABD140B53;
        Sat, 17 Aug 2019 21:14:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566069298; bh=gwiHlu1/e5gUceR70Z1eXl8Fjfy+Wc1wI65HN+bkQiU=;
        h=From:To:Date;
        b=g6o6lspXYZNWy5hK4P0ksqiLzHso6nGRE71EL1eqA1lFbCvJKapJ22jOpjl8PhqEW
         Pg+tSY6Ks9rgEFyLgH6xJlJDHmtm1iGo1e6fMj26ZPtNIBP33HbHC32ZEsVsw49z54
         xr+oQxuZpnYLt8RisbpJJIJi5FzlTztJcyTHiNFU=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC v2 net-next 3/4] net: dsa: mv88e6xxx: check for port type in port_disable
Date:   Sat, 17 Aug 2019 21:14:51 +0200
Message-Id: <20190817191452.16716-4-marek.behun@nic.cz>
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

The mv88e6xxx_port_disable method calls mv88e6xxx_port_set_state, which
should be called only for user ports.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9b3ad22a5b98..ad27f2fc5c33 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2285,8 +2285,9 @@ static void mv88e6xxx_port_disable(struct dsa_switch *ds, int port)
 
 	mv88e6xxx_reg_lock(chip);
 
-	if (mv88e6xxx_port_set_state(chip, port, BR_STATE_DISABLED))
-		dev_err(chip->dev, "failed to disable port\n");
+	if (dsa_is_user_port(ds, port))
+		if (mv88e6xxx_port_set_state(chip, port, BR_STATE_DISABLED))
+			dev_err(chip->dev, "failed to disable port\n");
 
 	if (chip->info->ops->serdes_irq_free)
 		chip->info->ops->serdes_irq_free(chip, port);
-- 
2.21.0

