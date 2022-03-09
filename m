Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7F14D2EEB
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiCIMUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiCIMUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:20:07 -0500
Received: from mail-m972.mail.163.com (mail-m972.mail.163.com [123.126.97.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B617312F404;
        Wed,  9 Mar 2022 04:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=79aUx
        1c7CPT8LgoaiDSdBrkYa0kTdsJauFmLg37A0L0=; b=VoPwc4VTZ8G5D9wgi9/jX
        JBS9L4MPrTsSb+8aAfvIYuOaRWQY3t7wSBgCx2n7Yo3BYEeUCzPdQ6KRn2iddndf
        tJBmSaInX5oCUmZ/JC92qIahUdUPMrMvymtXuH8Y7g7av/4+YVUJtGNvMLptDPEC
        N8AcFML5UuZnbc5fMsr6Mg=
Received: from localhost.localdomain (unknown [218.106.182.227])
        by smtp2 (Coremail) with SMTP id GtxpCgDXZW4TmyhiJ7pvBA--.12980S4;
        Wed, 09 Mar 2022 20:18:35 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     davem@davemloft.net, kuba@kernel.org, caihuoqing@baidu.com,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH v2] net: arc_emac: Fix use after free in arc_mdio_probe()
Date:   Wed,  9 Mar 2022 20:18:24 +0800
Message-Id: <20220309121824.36529-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgDXZW4TmyhiJ7pvBA--.12980S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr4fXFWUKFW7KFyrCFyrCrg_yoW8Xw4xpa
        yUu3srA3s2qw1UKF4kAay0v343tayrJryj9FyIvws0qw15Zr1fGrW7KFWq9w1UKF4qkF1a
        qa1xZFyrAFZ8JwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR4E_iUUUUU=
X-Originating-IP: [218.106.182.227]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiDxu+jFUMb4IN1gAAsJ
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bus->state is equal to MDIOBUS_ALLOCATED, mdiobus_free(bus) will free
the "bus". But bus->name is still used in the next line, which will lead
to a use after free.

We can fix it by putting the name in a local variable and make the
bus->name point to the rodata section "name",then use the name in the
error message without referring to bus to avoid the uaf.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/ethernet/arc/emac_mdio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
index 9acf589b1178..87f40c2ba904 100644
--- a/drivers/net/ethernet/arc/emac_mdio.c
+++ b/drivers/net/ethernet/arc/emac_mdio.c
@@ -132,6 +132,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 {
 	struct arc_emac_mdio_bus_data *data = &priv->bus_data;
 	struct device_node *np = priv->dev->of_node;
+	const char *name = "Synopsys MII Bus";
 	struct mii_bus *bus;
 	int error;
 
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

