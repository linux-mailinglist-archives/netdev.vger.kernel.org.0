Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F0251EEAB
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbiEHPf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234916AbiEHPfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:35:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083F9E030
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UgqcSgP5PxvrIzsK0FRPi+LB8+umNXJdTcKsQFQaqD8=; b=2v++3K81OJetItD3i/yhmgu1AA
        vWSuQoTj1MslI3SJHoVxDlpbWuBzpuTWoD08BqYpz0lEaWCHOTZ1hY+/pQv+UY2qzB7lR5q5Y37mb
        LN/zpHFwg/IfPCHMJPZpUKVm7ly8N5O7pLI41PncUBY49QtX66p29I4FniBniqGZdCRY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnisJ-001n9w-Eq; Sun, 08 May 2022 17:31:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Subject: [PATCH net-next 10/10] net: dsa: mv88e6xxx: Separate C22 and C45 transactions
Date:   Sun,  8 May 2022 17:30:49 +0200
Message-Id: <20220508153049.427227-11-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220508153049.427227-1-andrew@lunn.ch>
References: <20220508153049.427227-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The global2 SMI MDIO bus driver can perform both C22 and C45
transfers. Create separate functions for each and register the C45
versions using the new API calls where appropriate. Update the SERDES
code to make use of these new accessors.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 175 ++++++++++++++++++++--------
 drivers/net/dsa/mv88e6xxx/chip.h    |   7 ++
 drivers/net/dsa/mv88e6xxx/global2.c |  66 ++++++-----
 drivers/net/dsa/mv88e6xxx/global2.h |  18 ++-
 drivers/net/dsa/mv88e6xxx/phy.c     |  32 +++++
 drivers/net/dsa/mv88e6xxx/phy.h     |   4 +
 drivers/net/dsa/mv88e6xxx/serdes.c  |   8 +-
 7 files changed, 225 insertions(+), 85 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 53fd12e7a21c..bc6d3b891fb8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3850,6 +3850,24 @@ static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
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
@@ -3866,6 +3884,23 @@ static int mv88e6xxx_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
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
@@ -3904,6 +3939,8 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 
 	bus->read = mv88e6xxx_mdio_read;
 	bus->write = mv88e6xxx_mdio_write;
+	bus->read_c45 = mv88e6xxx_mdio_read_c45;
+	bus->write_c45 = mv88e6xxx_mdio_write_c45;
 	bus->parent = chip->dev;
 
 	if (!external) {
@@ -4113,8 +4150,10 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
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
@@ -4162,8 +4201,10 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
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
@@ -4243,8 +4284,10 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
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
@@ -4307,8 +4350,10 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
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
@@ -4389,8 +4434,10 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
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
@@ -4435,8 +4482,10 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
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
@@ -4490,8 +4539,10 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
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
@@ -4536,8 +4587,10 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
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
@@ -4636,8 +4689,10 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
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
@@ -4699,8 +4754,10 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
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
@@ -4762,8 +4819,10 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
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
@@ -4825,8 +4884,10 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
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
@@ -4888,8 +4949,10 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
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
@@ -4927,8 +4990,10 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
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
@@ -4992,8 +5057,10 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
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
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
@@ -5036,8 +5103,10 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
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
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
@@ -5078,8 +5147,10 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
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
@@ -5144,8 +5215,10 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
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
@@ -5188,8 +5261,10 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
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
@@ -5236,8 +5311,10 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
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
@@ -5301,8 +5378,10 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
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
@@ -5368,8 +5447,10 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
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
@@ -5434,8 +5515,10 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
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
index 5e03cfe50156..c8122765e930 100644
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
index 807aeaad9830..ee44b35500bd 100644
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
index 7b37d45bc9fb..efb3bf898d84 100644
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
2.36.0

