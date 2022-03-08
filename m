Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A694D15D8
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 12:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346363AbiCHLLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 06:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346321AbiCHLLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 06:11:34 -0500
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2509C45060;
        Tue,  8 Mar 2022 03:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=FR44s
        W/93AnOynT8YortolDQmhxdwDJugx6homStZRM=; b=OC0XVlzJrZvmckrxWWt6v
        VMkhI8LQVYi2rUmTr1nw5HXOjZ7Ag3bjbYdrjrS4mh1r6hSknOB5P6zTE5BF9vzI
        8YS9rCFwAXqRvENwZrdt+s7jK3Lsb5wHr4RaocN2bV3/QJxqA73WzuJ0WFqNIIrQ
        brqB8Q5sMZy7emoDnvXjvY=
Received: from localhost.localdomain (unknown [218.106.182.227])
        by smtp1 (Coremail) with SMTP id GdxpCgAHV3CPOSdiEZZBCg--.8441S4;
        Tue, 08 Mar 2022 19:10:17 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     davem@davemloft.net, kuba@kernel.org, caihuoqing@baidu.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] net: arc_emac: Fix use after free in arc_mdio_probe()
Date:   Tue,  8 Mar 2022 19:10:05 +0800
Message-Id: <20220308111005.4953-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgAHV3CPOSdiEZZBCg--.8441S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr43CrWxXrWrKw4UZry5urg_yoW8XrW8pa
        yDu3srC3s2vw4jgw4kAay8Z343tayrJry09FyIvw4Yq3Wavr1fCrW7KFWDuw1UKFsYkF1a
        yan7Za4rAF98Jw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR4E_iUUUUU=
X-Originating-IP: [218.106.182.227]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiPhm9jFxBqhITpQAAsF
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bus->state is equal to MDIOBUS_ALLOCATED, mdiobus_free(bus) will free
the "bus". But bus->name is still used in the next line, which will lead
to a use after free.

We can fix it by putting the bus->name in a local variable and then use
the name in the error message without referring to bus to avoid the uaf.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/ethernet/arc/emac_mdio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
index 9acf589b1178..33fd63d227ef 100644
--- a/drivers/net/ethernet/arc/emac_mdio.c
+++ b/drivers/net/ethernet/arc/emac_mdio.c
@@ -134,6 +134,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 	struct device_node *np = priv->dev->of_node;
 	struct mii_bus *bus;
 	int error;
+	const char *name = "Synopsys MII Bus";
 
 	bus = mdiobus_alloc();
 	if (!bus)
@@ -142,7 +143,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 	priv->bus = bus;
 	bus->priv = priv;
 	bus->parent = priv->dev;
-	bus->name = "Synopsys MII Bus";
+	bus->name = name;
 	bus->read = &arc_mdio_read;
 	bus->write = &arc_mdio_write;
 	bus->reset = &arc_mdio_reset;
@@ -167,7 +168,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 	if (error) {
 		mdiobus_free(bus);
 		return dev_err_probe(priv->dev, error,
-				     "cannot register MDIO bus %s\n", bus->name);
+				     "cannot register MDIO bus %s\n", name);
 	}
 
 	return 0;
-- 
2.25.1

