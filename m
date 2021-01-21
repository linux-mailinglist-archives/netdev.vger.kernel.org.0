Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDF32FEAB3
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731545AbhAUMwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:52:36 -0500
Received: from m12-15.163.com ([220.181.12.15]:36174 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728332AbhAUMwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 07:52:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=k0xtZ6KWJQKNnQtTXI
        Ng0tImZtiZSxgzjqVJ/M6+hwk=; b=SNZCOtny3FQKWC68uujycw4IgdoRAqkXCU
        1o0oROas9GrBRT1tqG0J8+Stlgg9VR9/lffUVjGfQ226z809EBAV3iNaUhWzhr+K
        Kqf5asnOoDi4r7BvBQTYwVH4Gllagdpa74cbhboUUIdtelprCNm9xyiIWjB2z3XK
        Mq5pUsmRI=
Received: from localhost.localdomain (unknown [119.3.119.20])
        by smtp11 (Coremail) with SMTP id D8CowAA3va+qdAlga8giAg--.20707S4;
        Thu, 21 Jan 2021 20:33:50 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] net: dsa: bcm_sf2: put device node before return
Date:   Thu, 21 Jan 2021 04:33:43 -0800
Message-Id: <20210121123343.26330-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: D8CowAA3va+qdAlga8giAg--.20707S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFyfCFWxGrykAF47Kw1Dtrb_yoWkZrb_KF
        93XFWrXr4xGFn0kw43Zr4furyvya4xurs3uF4aqas8Ka13try7Xrs8Xr15XrWUu393uF9F
        vr4DtFnaq348CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU52Nt7UUUUU==
X-Originating-IP: [119.3.119.20]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiNgIhclWBlu2ABgABsP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put the device node dn before return error code on failure path.

Fixes: 461cd1b03e32 ("net: dsa: bcm_sf2: Register our slave MDIO bus")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/net/dsa/bcm_sf2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 1e9a0adda2d6..445226720ff2 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -509,15 +509,19 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	/* Find our integrated MDIO bus node */
 	dn = of_find_compatible_node(NULL, NULL, "brcm,unimac-mdio");
 	priv->master_mii_bus = of_mdio_find_bus(dn);
-	if (!priv->master_mii_bus)
+	if (!priv->master_mii_bus) {
+		of_node_put(dn);
 		return -EPROBE_DEFER;
+	}
 
 	get_device(&priv->master_mii_bus->dev);
 	priv->master_mii_dn = dn;
 
 	priv->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
-	if (!priv->slave_mii_bus)
+	if (!priv->slave_mii_bus) {
+		of_node_put(dn);
 		return -ENOMEM;
+	}
 
 	priv->slave_mii_bus->priv = priv;
 	priv->slave_mii_bus->name = "sf2 slave mii";
-- 
2.17.1


