Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08203107A10
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKVVpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:45:11 -0500
Received: from mars.blocktrron.ovh ([51.254.112.43]:41108 "EHLO
        mail.blocktrron.ovh" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVVpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 16:45:11 -0500
Received: from dbauer-t470.home.david-bauer.net (p200300E53F0C9D00853DC40395BBEF91.dip0.t-ipconnect.de [IPv6:2003:e5:3f0c:9d00:853d:c403:95bb:ef91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.blocktrron.ovh (Postfix) with ESMTPSA id 1DBBC1FA94;
        Fri, 22 Nov 2019 22:45:08 +0100 (CET)
From:   David Bauer <mail@david-bauer.net>
To:     netdev@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] mdio_bus: don't use managed reset-controller
Date:   Fri, 22 Nov 2019 22:44:51 +0100
Message-Id: <20191122214451.240431-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven reported that using devm_reset_controller_get leads
to a WARNING when probing a reset-controlled PHY. This is because the
device devm_reset_controller_get gets supplied is not actually the
one being probed.

Acquire an unmanaged reset-control as well as free the reset_control on
unregister to fix this.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/phy/mdio_bus.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index dbacb0031877..229e480179ff 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -62,8 +62,8 @@ static int mdiobus_register_reset(struct mdio_device *mdiodev)
 	struct reset_control *reset = NULL;
 
 	if (mdiodev->dev.of_node)
-		reset = devm_reset_control_get_exclusive(&mdiodev->dev,
-							 "phy");
+		reset = of_reset_control_get_exclusive(mdiodev->dev.of_node,
+						       "phy");
 	if (IS_ERR(reset)) {
 		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOTSUPP)
 			reset = NULL;
@@ -107,6 +107,8 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev)
 	if (mdiodev->bus->mdio_map[mdiodev->addr] != mdiodev)
 		return -EINVAL;
 
+	reset_control_put(mdiodev->reset_ctrl);
+
 	mdiodev->bus->mdio_map[mdiodev->addr] = NULL;
 
 	return 0;
-- 
2.24.0

