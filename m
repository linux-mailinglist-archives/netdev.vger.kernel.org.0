Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67D5662A18
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbjAIPc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237219AbjAIPbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:31:51 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4F51EC7B;
        Mon,  9 Jan 2023 07:31:07 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 92F811A11;
        Mon,  9 Jan 2023 16:30:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673278258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HNr/3z9uIVXHH/dsxG51QQYxf6cRktTO5iC8JOqbAFY=;
        b=kxst7edEMF+wOKsTqNfUehJsnE6pLdTtIL47AAXJVwXj9qedSFIe6zTWJetypt/jNnC55v
        rCutxCa487leU3NVLm5aPkrACPBbVTVU6jbxFnd13u3mnnRj6J2o64INxBKZ8U3AjRAmn3
        e+g7gMRq7fkGpuaAhfpAF47a/1l1ggmzjy24LGq9NawRole2WaD8rSsXScvmom8y4Y6GTF
        Et8W8EvgUchdQlsUYda3eEzHM9ubtkxd9MVGGsdH6dWq1zlWi1cdT3+E8QHv5ozhRPSSC8
        p7FRXd2Qycr7K40IsdclJDuwAHpZo/Pk+aaY3hyETm4k70FWjD3WTif7w9tBbQ==
From:   Michael Walle <michael@walle.cc>
Date:   Mon, 09 Jan 2023 16:30:51 +0100
Subject: [PATCH net-next v3 11/11] net: dsa: mv88e6xxx: Separate C22 and C45
 transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v3-11-ade1deb438da@walle.cc>
References: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

The global2 SMI MDIO bus driver can perform both C22 and C45
transfers. Create separate functions for each and register the C45
versions using the new API calls where appropriate. Update the SERDES
code to make use of these new accessors.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 175 ++++++++++++++++++++++++++----------
 drivers/net/dsa/mv88e6xxx/chip.h    |   7 ++
 drivers/net/dsa/mv88e6xxx/global2.c |  66 ++++++++------
 drivers/net/dsa/mv88e6xxx/global2.h |  18 ++--
 drivers/net/dsa/mv88e6xxx/phy.c     |  32 +++++++
 drivers/net/dsa/mv88e6xxx/phy.h     |   4 +
 drivers/net/dsa/mv88e6xxx/serdes.c  |   8 +-
 7 files changed, 225 insertions(+), 85 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 242b8b325504..0ff9cd0be217 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3884,6 +3884,24 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	return err ? err : val;
 }
 
+static int mv88e6xxx_mdio_read_c45(struct mii_bus *bus, int phy, int devad,
+				   int reg)
+{
+	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
+	struct mv88e6xxx_chip *chip = mdio_bus->chip;
+	u16 val;
+	int err;
+
+	if (!chip->info->ops->phy_read_c45)
+		return -EOPNOTSUPP;
+
+	mv88e6xxx_reg_lock(chip);
+	err = chip->info->ops->phy_read_c45(chip, bus, phy, devad, reg, &val);
+	mv88e6xxx_reg_unlock(chip);
+
+	return err ? err : val;
+}
+
 static int mv88e6xxx_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
@@ -3900,6 +3918,23 @@ static int mv88e6xxx_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
 	return err;
 }
 
+static int mv88e6xxx_mdio_write_c45(struct mii_bus *bus, int phy, int devad,
+				    int reg, u16 val)
+{
+	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
+	struct mv88e6xxx_chip *chip = mdio_bus->chip;
+	int err;
+
+	if (!chip->info->ops->phy_write_c45)
+		return -EOPNOTSUPP;
+
+	mv88e6xxx_reg_lock(chip);
+	err = chip->info->ops->phy_write_c45(chip, bus, phy, devad, reg, val);
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
 static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 				   struct device_node *np,
 				   bool external)
@@ -3938,6 +3973,8 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 
 	bus->read = mv88e6xxx_mdio_read;
 	bus->write = mv88e6xxx_mdio_write;
+	bus->read_c45 = mv88e6xxx_mdio_read_c45;
+	bus->write_c45 = mv88e6xxx_mdio_write_c45;
 	bus->parent = chip->dev;
 
 	if (!external) {
@@ -4149,8 +4186,10 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6185_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
@@ -4198,8 +4237,10 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
@@ -4279,8 +4320,10 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
@@ -4343,8 +4386,10 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
@@ -4426,8 +4471,10 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
@@ -4472,8 +4519,10 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom16,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom16,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
@@ -4527,8 +4576,10 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
@@ -4573,8 +4624,10 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom16,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom16,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
@@ -4673,8 +4726,10 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
@@ -4736,8 +4791,10 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
@@ -4799,8 +4856,10 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
@@ -4862,8 +4921,10 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom16,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom16,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
@@ -4925,8 +4986,10 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom16,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom16,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
@@ -4964,8 +5027,10 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
@@ -5029,8 +5094,10 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom16,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom16,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6320_port_set_rgmii_delay,
@@ -5074,8 +5141,10 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom16,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom16,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6320_port_set_rgmii_delay,
@@ -5117,8 +5186,10 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
@@ -5183,8 +5254,10 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
@@ -5227,8 +5300,10 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
@@ -5275,8 +5350,10 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom16,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom16,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
@@ -5340,8 +5417,10 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
@@ -5407,8 +5486,10 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
@@ -5473,8 +5554,10 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.get_eeprom = mv88e6xxx_g2_get_eeprom8,
 	.set_eeprom = mv88e6xxx_g2_set_eeprom8,
 	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
-	.phy_read = mv88e6xxx_g2_smi_phy_read,
-	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.phy_read = mv88e6xxx_g2_smi_phy_read_c22,
+	.phy_write = mv88e6xxx_g2_smi_phy_write_c22,
+	.phy_read_c45 = mv88e6xxx_g2_smi_phy_read_c45,
+	.phy_write_c45 = mv88e6xxx_g2_smi_phy_write_c45,
 	.port_set_link = mv88e6xxx_port_set_link,
 	.port_sync_link = mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..751bede49942 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -451,6 +451,13 @@ struct mv88e6xxx_ops {
 			 struct mii_bus *bus,
 			 int addr, int reg, u16 val);
 
+	int (*phy_read_c45)(struct mv88e6xxx_chip *chip,
+			    struct mii_bus *bus,
+			    int addr, int devad, int reg, u16 *val);
+	int (*phy_write_c45)(struct mv88e6xxx_chip *chip,
+			     struct mii_bus *bus,
+			     int addr, int devad, int reg, u16 val);
+
 	/* Priority Override Table operations */
 	int (*pot_clear)(struct mv88e6xxx_chip *chip);
 
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index fa65ecd9cb85..ed3b2f88e783 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -739,20 +739,18 @@ static int mv88e6xxx_g2_smi_phy_read_data_c45(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_g2_read(chip, MV88E6XXX_G2_SMI_PHY_DATA, data);
 }
 
-static int mv88e6xxx_g2_smi_phy_read_c45(struct mv88e6xxx_chip *chip,
-					 bool external, int port, int reg,
-					 u16 *data)
+static int _mv88e6xxx_g2_smi_phy_read_c45(struct mv88e6xxx_chip *chip,
+					  bool external, int port, int devad,
+					  int reg, u16 *data)
 {
-	int dev = (reg >> 16) & 0x1f;
-	int addr = reg & 0xffff;
 	int err;
 
-	err = mv88e6xxx_g2_smi_phy_write_addr_c45(chip, external, port, dev,
-						  addr);
+	err = mv88e6xxx_g2_smi_phy_write_addr_c45(chip, external, port, devad,
+						  reg);
 	if (err)
 		return err;
 
-	return mv88e6xxx_g2_smi_phy_read_data_c45(chip, external, port, dev,
+	return mv88e6xxx_g2_smi_phy_read_data_c45(chip, external, port, devad,
 						  data);
 }
 
@@ -771,51 +769,65 @@ static int mv88e6xxx_g2_smi_phy_write_data_c45(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_g2_smi_phy_access_c45(chip, external, op, port, dev);
 }
 
-static int mv88e6xxx_g2_smi_phy_write_c45(struct mv88e6xxx_chip *chip,
-					  bool external, int port, int reg,
-					  u16 data)
+static int _mv88e6xxx_g2_smi_phy_write_c45(struct mv88e6xxx_chip *chip,
+					   bool external, int port, int devad,
+					   int reg, u16 data)
 {
-	int dev = (reg >> 16) & 0x1f;
-	int addr = reg & 0xffff;
 	int err;
 
-	err = mv88e6xxx_g2_smi_phy_write_addr_c45(chip, external, port, dev,
-						  addr);
+	err = mv88e6xxx_g2_smi_phy_write_addr_c45(chip, external, port, devad,
+						  reg);
 	if (err)
 		return err;
 
-	return mv88e6xxx_g2_smi_phy_write_data_c45(chip, external, port, dev,
+	return mv88e6xxx_g2_smi_phy_write_data_c45(chip, external, port, devad,
 						   data);
 }
 
-int mv88e6xxx_g2_smi_phy_read(struct mv88e6xxx_chip *chip, struct mii_bus *bus,
-			      int addr, int reg, u16 *val)
+int mv88e6xxx_g2_smi_phy_read_c22(struct mv88e6xxx_chip *chip,
+				  struct mii_bus *bus,
+				  int addr, int reg, u16 *val)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
 	bool external = mdio_bus->external;
 
-	if (reg & MII_ADDR_C45)
-		return mv88e6xxx_g2_smi_phy_read_c45(chip, external, addr, reg,
-						     val);
-
 	return mv88e6xxx_g2_smi_phy_read_data_c22(chip, external, addr, reg,
 						  val);
 }
 
-int mv88e6xxx_g2_smi_phy_write(struct mv88e6xxx_chip *chip, struct mii_bus *bus,
-			       int addr, int reg, u16 val)
+int mv88e6xxx_g2_smi_phy_read_c45(struct mv88e6xxx_chip *chip,
+				  struct mii_bus *bus, int addr, int devad,
+				  int reg, u16 *val)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
 	bool external = mdio_bus->external;
 
-	if (reg & MII_ADDR_C45)
-		return mv88e6xxx_g2_smi_phy_write_c45(chip, external, addr, reg,
-						      val);
+	return _mv88e6xxx_g2_smi_phy_read_c45(chip, external, addr, devad, reg,
+					      val);
+}
+
+int mv88e6xxx_g2_smi_phy_write_c22(struct mv88e6xxx_chip *chip,
+				   struct mii_bus *bus, int addr, int reg,
+				   u16 val)
+{
+	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
+	bool external = mdio_bus->external;
 
 	return mv88e6xxx_g2_smi_phy_write_data_c22(chip, external, addr, reg,
 						   val);
 }
 
+int mv88e6xxx_g2_smi_phy_write_c45(struct mv88e6xxx_chip *chip,
+				   struct mii_bus *bus, int addr, int devad,
+				   int reg, u16 val)
+{
+	struct mv88e6xxx_mdio_bus *mdio_bus = bus->priv;
+	bool external = mdio_bus->external;
+
+	return _mv88e6xxx_g2_smi_phy_write_c45(chip, external, addr, devad, reg,
+					       val);
+}
+
 /* Offset 0x1B: Watchdog Control */
 static int mv88e6097_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 7536b8b0ad01..e973114d6890 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -314,12 +314,18 @@ int mv88e6xxx_g2_wait_bit(struct mv88e6xxx_chip *chip, int reg,
 int mv88e6352_g2_irl_init_all(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g2_irl_init_all(struct mv88e6xxx_chip *chip, int port);
 
-int mv88e6xxx_g2_smi_phy_read(struct mv88e6xxx_chip *chip,
-			      struct mii_bus *bus,
-			      int addr, int reg, u16 *val);
-int mv88e6xxx_g2_smi_phy_write(struct mv88e6xxx_chip *chip,
-			       struct mii_bus *bus,
-			       int addr, int reg, u16 val);
+int mv88e6xxx_g2_smi_phy_read_c22(struct mv88e6xxx_chip *chip,
+				  struct mii_bus *bus,
+				  int addr, int reg, u16 *val);
+int mv88e6xxx_g2_smi_phy_write_c22(struct mv88e6xxx_chip *chip,
+				   struct mii_bus *bus,
+				   int addr, int reg, u16 val);
+int mv88e6xxx_g2_smi_phy_read_c45(struct mv88e6xxx_chip *chip,
+				  struct mii_bus *bus,
+				  int addr, int devad, int reg, u16 *val);
+int mv88e6xxx_g2_smi_phy_write_c45(struct mv88e6xxx_chip *chip,
+				   struct mii_bus *bus,
+				   int addr, int devad, int reg, u16 val);
 int mv88e6xxx_g2_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr);
 
 int mv88e6xxx_g2_get_eeprom8(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/phy.c b/drivers/net/dsa/mv88e6xxx/phy.c
index 252b5b3a3efe..8bb88b3d900d 100644
--- a/drivers/net/dsa/mv88e6xxx/phy.c
+++ b/drivers/net/dsa/mv88e6xxx/phy.c
@@ -55,6 +55,38 @@ int mv88e6xxx_phy_write(struct mv88e6xxx_chip *chip, int phy, int reg, u16 val)
 	return chip->info->ops->phy_write(chip, bus, addr, reg, val);
 }
 
+int mv88e6xxx_phy_read_c45(struct mv88e6xxx_chip *chip, int phy, int devad,
+			   int reg, u16 *val)
+{
+	int addr = phy; /* PHY devices addresses start at 0x0 */
+	struct mii_bus *bus;
+
+	bus = mv88e6xxx_default_mdio_bus(chip);
+	if (!bus)
+		return -EOPNOTSUPP;
+
+	if (!chip->info->ops->phy_read_c45)
+		return -EOPNOTSUPP;
+
+	return chip->info->ops->phy_read_c45(chip, bus, addr, devad, reg, val);
+}
+
+int mv88e6xxx_phy_write_c45(struct mv88e6xxx_chip *chip, int phy, int devad,
+			    int reg, u16 val)
+{
+	int addr = phy; /* PHY devices addresses start at 0x0 */
+	struct mii_bus *bus;
+
+	bus = mv88e6xxx_default_mdio_bus(chip);
+	if (!bus)
+		return -EOPNOTSUPP;
+
+	if (!chip->info->ops->phy_write_c45)
+		return -EOPNOTSUPP;
+
+	return chip->info->ops->phy_write_c45(chip, bus, addr, devad, reg, val);
+}
+
 static int mv88e6xxx_phy_page_get(struct mv88e6xxx_chip *chip, int phy, u8 page)
 {
 	return mv88e6xxx_phy_write(chip, phy, MV88E6XXX_PHY_PAGE, page);
diff --git a/drivers/net/dsa/mv88e6xxx/phy.h b/drivers/net/dsa/mv88e6xxx/phy.h
index 05ea0d546969..5f47722364cc 100644
--- a/drivers/net/dsa/mv88e6xxx/phy.h
+++ b/drivers/net/dsa/mv88e6xxx/phy.h
@@ -28,6 +28,10 @@ int mv88e6xxx_phy_read(struct mv88e6xxx_chip *chip, int phy,
 		       int reg, u16 *val);
 int mv88e6xxx_phy_write(struct mv88e6xxx_chip *chip, int phy,
 			int reg, u16 val);
+int mv88e6xxx_phy_read_c45(struct mv88e6xxx_chip *chip, int phy, int devad,
+			   int reg, u16 *val);
+int mv88e6xxx_phy_write_c45(struct mv88e6xxx_chip *chip, int phy, int devad,
+			    int reg, u16 val);
 int mv88e6xxx_phy_page_read(struct mv88e6xxx_chip *chip, int phy,
 			    u8 page, int reg, u16 *val);
 int mv88e6xxx_phy_page_write(struct mv88e6xxx_chip *chip, int phy,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index d94150d8f3f4..72faec8f44dc 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -36,17 +36,13 @@ static int mv88e6352_serdes_write(struct mv88e6xxx_chip *chip, int reg,
 static int mv88e6390_serdes_read(struct mv88e6xxx_chip *chip,
 				 int lane, int device, int reg, u16 *val)
 {
-	int reg_c45 = MII_ADDR_C45 | device << 16 | reg;
-
-	return mv88e6xxx_phy_read(chip, lane, reg_c45, val);
+	return mv88e6xxx_phy_read_c45(chip, lane, device, reg, val);
 }
 
 static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
 				  int lane, int device, int reg, u16 val)
 {
-	int reg_c45 = MII_ADDR_C45 | device << 16 | reg;
-
-	return mv88e6xxx_phy_write(chip, lane, reg_c45, val);
+	return mv88e6xxx_phy_write_c45(chip, lane, device, reg, val);
 }
 
 static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,

-- 
2.30.2
