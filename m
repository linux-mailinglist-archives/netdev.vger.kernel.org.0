Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3CB5088A1
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 15:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355599AbiDTNCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 09:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343572AbiDTNCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 09:02:52 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957D413E1E;
        Wed, 20 Apr 2022 06:00:05 -0700 (PDT)
Received: from localhost.localdomain (36-229-224-240.dynamic-ip.hinet.net [36.229.224.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id D00893FA47;
        Wed, 20 Apr 2022 12:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1650458492;
        bh=SKjQnef4t+NYwjHc80rBUTUJdxxhm2rF2h/H64pus8k=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=aVhDslsDfu3NINdHmfYaY9uRiLennv/4jmsXRqZgK1SAGKGJNEgdwCf6h6BNXSBZD
         G+2PcfrUYj2iywGzbxDa4CjMQDc9K308UBX9w4H2LzeMMxgey0nOLodqVOUYT2vVg/
         WwVuLU54sOAgdl/GT9DvN3V2M0XnHwtnw4fqpJRsdh1nKLsI2ATK6rrc1TPD2Ehkfl
         NCFWADZEEXI3uP2eI8fCx4kyTQ5Tp85rSN2hKQOdnxhPkRlUPzE0HWdrG3ZztMexml
         KO+XzChdIMV/zng9m06yJYOUETKIkuth8Yn0TDbxr6t1FJhVW91YWbcPiO1TJ8MAg9
         TG312LAp8n8Ow==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] net: stmmac: Use acpi_mdiobus_register() for ACPI based system
Date:   Wed, 20 Apr 2022 20:40:52 +0800
Message-Id: <20220420124053.853891-6-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220420124053.853891-1-kai.heng.feng@canonical.com>
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Child nodes of stmmac ACPI node may have additional properties that the
PHY layer can use.

To achieve that, use acpi_mdiobus_register() to find PHY nodes
references via "phy-handle", so the properties of PHY nodes can be used
by the PHY layer.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index a5d150c5f3d8c..37cebd8f2ec5c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -10,6 +10,8 @@
   Maintainer: Giuseppe Cavallaro <peppe.cavallaro@st.com>
 *******************************************************************************/
 
+#include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/gpio/consumer.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
@@ -445,6 +447,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 	struct stmmac_mdio_bus_data *mdio_bus_data = priv->plat->mdio_bus_data;
 	struct device_node *mdio_node = priv->plat->mdio_node;
 	struct device *dev = ndev->dev.parent;
+	struct fwnode_handle *fwnode = dev->fwnode;
 	int addr, found, max_addr;
 
 	if (!mdio_bus_data)
@@ -488,7 +491,10 @@ int stmmac_mdio_register(struct net_device *ndev)
 	new_bus->phy_mask = mdio_bus_data->phy_mask;
 	new_bus->parent = priv->device;
 
-	err = of_mdiobus_register(new_bus, mdio_node);
+	if (is_acpi_node(fwnode))
+		err = acpi_mdiobus_register(new_bus, fwnode);
+	else
+		err = of_mdiobus_register(new_bus, mdio_node);
 	if (err != 0) {
 		dev_err(dev, "Cannot register the MDIO bus\n");
 		goto bus_register_fail;
-- 
2.34.1

