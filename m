Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B5640C7F5
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbhIOPOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:14:50 -0400
Received: from mx24.baidu.com ([111.206.215.185]:40624 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237745AbhIOPOs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:14:48 -0400
Received: from BJHW-Mail-Ex06.internal.baidu.com (unknown [10.127.64.16])
        by Forcepoint Email with ESMTPS id 3692354165B91482BE76;
        Wed, 15 Sep 2021 22:57:47 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex06.internal.baidu.com (10.127.64.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:57:47 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:57:46 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: arc_emac: Make use of the helper function dev_err_probe()
Date:   Wed, 15 Sep 2021 22:57:41 +0800
Message-ID: <20210915145741.7198-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex06_2021-09-15 22:57:47:213
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When possible use dev_err_probe help to properly deal with the
PROBE_DEFER error, the benefit is that DEFER issue will be logged
in the devices_deferred debugfs file.
And using dev_err_probe() can reduce code size, and simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/arc/emac_mdio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
index 54cdafdd067d..9acf589b1178 100644
--- a/drivers/net/ethernet/arc/emac_mdio.c
+++ b/drivers/net/ethernet/arc/emac_mdio.c
@@ -151,10 +151,9 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 	data->reset_gpio = devm_gpiod_get_optional(priv->dev, "phy-reset",
 						   GPIOD_OUT_LOW);
 	if (IS_ERR(data->reset_gpio)) {
-		error = PTR_ERR(data->reset_gpio);
-		dev_err(priv->dev, "Failed to request gpio: %d\n", error);
 		mdiobus_free(bus);
-		return error;
+		return dev_err_probe(priv->dev, PTR_ERR(data->reset_gpio),
+				     "Failed to request gpio\n");
 	}
 
 	of_property_read_u32(np, "phy-reset-duration", &data->msec);
@@ -166,9 +165,9 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 
 	error = of_mdiobus_register(bus, priv->dev->of_node);
 	if (error) {
-		dev_err(priv->dev, "cannot register MDIO bus %s\n", bus->name);
 		mdiobus_free(bus);
-		return error;
+		return dev_err_probe(priv->dev, error,
+				     "cannot register MDIO bus %s\n", bus->name);
 	}
 
 	return 0;
-- 
2.25.1

