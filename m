Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C205230D4
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbiEKKjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240385AbiEKKi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:38:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993339C2DC;
        Wed, 11 May 2022 03:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652265515; x=1683801515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+oiKEsNFDqNZlBmz9it4VRVYr4WcGbAWKL+xBelUDHs=;
  b=sGzJ5oZ1CyBqrm9vtqr3GquYonmg3003kgteMbUX17acTEUztHdHEsoV
   9DmVI1wPftEQVxhdZ07/MbaBoh6OJdr3y8m781zaqN82Euxrcc6px/jB7
   qH+btfgNFn7gFqbPINt1u14smQDDD2btfdzjfwVzmRNIIj7SzC4wogJNy
   xUaeWrm/RWeC62wpSdYJK9EO36HK8h4fAt9lBfxCjau68mdv8hhitigKl
   GN0NIBYyrrTdeahqkanGcGwely7M+9wX7fYzSSzP1L9UdF1IVkRhCUS/X
   JULFGMrM446Y2kN4ntzEMmyLaEbqrNRwu1evjDTRGa6RU1YVGZcybeMnG
   w==;
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="155586476"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 May 2022 03:38:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 11 May 2022 03:38:34 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 11 May 2022 03:38:28 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [RFC Patch net-next 2/9] net: dsa: microchip: move ksz_chip_data to ksz_common
Date:   Wed, 11 May 2022 16:07:48 +0530
Message-ID: <20220511103755.12553-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220511103755.12553-1-arun.ramadoss@microchip.com>
References: <20220511103755.12553-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the ksz_chip_data in ksz8795 and ksz9477 to ksz_common.
At present, the dev->chip_id is iterated with the ksz_chip_data and then
copy its value to the ksz_dev structure. These values are declared as
constant.
Instead of copying the values and referencing it, this patch update the
dev->info to the ksz_chip_data based on the chip_id in the init
function. And also update the ksz_chip_data values for the LAN937x based
switches.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 114 ++-------------
 drivers/net/dsa/microchip/ksz9477.c    | 108 +++-----------
 drivers/net/dsa/microchip/ksz_common.c | 190 +++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.h |  37 ++++-
 4 files changed, 243 insertions(+), 206 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 83bcabf2dc54..b6032b65afc2 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1036,13 +1036,13 @@ static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	int first, index, cnt;
 	struct ksz_port *p;
 
-	if ((uint)port < dev->port_cnt) {
+	if ((uint)port < dev->info->port_cnt) {
 		first = port;
 		cnt = port + 1;
 	} else {
 		/* Flush all ports. */
 		first = 0;
-		cnt = dev->port_cnt;
+		cnt = dev->info->port_cnt;
 	}
 	for (index = first; index < cnt; index++) {
 		p = &dev->ports[index];
@@ -1118,7 +1118,7 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 		 * Remove Tag flag to be changed, unless there are no
 		 * other VLANs currently configured.
 		 */
-		for (vid = 1; vid < dev->num_vlans; ++vid) {
+		for (vid = 1; vid < dev->info->num_vlans; ++vid) {
 			/* Skip the VID we are going to add or reconfigure */
 			if (vid == vlan->vid)
 				continue;
@@ -1389,7 +1389,7 @@ static int ksz8_handle_global_errata(struct dsa_switch *ds)
 	 *   KSZ879x/KSZ877x/KSZ876x and some EEE link partners may result in
 	 *   the link dropping.
 	 */
-	if (dev->ksz87xx_eee_link_erratum)
+	if (dev->info->ksz87xx_eee_link_erratum)
 		ret = ksz8_ind_write8(dev, TABLE_EEE, REG_IND_EEE_GLOB2_HI, 0);
 
 	return ret;
@@ -1402,7 +1402,7 @@ static int ksz8_setup(struct dsa_switch *ds)
 	int i, ret = 0;
 
 	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
-				       dev->num_vlans, GFP_KERNEL);
+				       dev->info->num_vlans, GFP_KERNEL);
 	if (!dev->vlan_cache)
 		return -ENOMEM;
 
@@ -1446,7 +1446,7 @@ static int ksz8_setup(struct dsa_switch *ds)
 			   (BROADCAST_STORM_VALUE *
 			   BROADCAST_STORM_PROT_RATE) / 100);
 
-	for (i = 0; i < (dev->num_vlans / 4); i++)
+	for (i = 0; i < (dev->info->num_vlans / 4); i++)
 		ksz8_r_vlan_entries(dev, i);
 
 	/* Setup STP address for STP operation. */
@@ -1571,74 +1571,6 @@ static int ksz8_switch_detect(struct ksz_device *dev)
 	return 0;
 }
 
-struct ksz_chip_data {
-	u16 chip_id;
-	const char *dev_name;
-	int num_vlans;
-	int num_alus;
-	int num_statics;
-	int cpu_ports;
-	int port_cnt;
-	bool ksz87xx_eee_link_erratum;
-};
-
-static const struct ksz_chip_data ksz8_switch_chips[] = {
-	{
-		.chip_id = 0x8795,
-		.dev_name = "KSZ8795",
-		.num_vlans = 4096,
-		.num_alus = 0,
-		.num_statics = 8,
-		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 5,		/* total cpu and user ports */
-		.ksz87xx_eee_link_erratum = true,
-	},
-	{
-		/*
-		 * WARNING
-		 * =======
-		 * KSZ8794 is similar to KSZ8795, except the port map
-		 * contains a gap between external and CPU ports, the
-		 * port map is NOT continuous. The per-port register
-		 * map is shifted accordingly too, i.e. registers at
-		 * offset 0x40 are NOT used on KSZ8794 and they ARE
-		 * used on KSZ8795 for external port 3.
-		 *           external  cpu
-		 * KSZ8794   0,1,2      4
-		 * KSZ8795   0,1,2,3    4
-		 * KSZ8765   0,1,2,3    4
-		 * port_cnt is configured as 5, even though it is 4
-		 */
-		.chip_id = 0x8794,
-		.dev_name = "KSZ8794",
-		.num_vlans = 4096,
-		.num_alus = 0,
-		.num_statics = 8,
-		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 5,		/* total cpu and user ports */
-		.ksz87xx_eee_link_erratum = true,
-	},
-	{
-		.chip_id = 0x8765,
-		.dev_name = "KSZ8765",
-		.num_vlans = 4096,
-		.num_alus = 0,
-		.num_statics = 8,
-		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 5,		/* total cpu and user ports */
-		.ksz87xx_eee_link_erratum = true,
-	},
-	{
-		.chip_id = 0x8830,
-		.dev_name = "KSZ8863/KSZ8873",
-		.num_vlans = 16,
-		.num_alus = 0,
-		.num_statics = 8,
-		.cpu_ports = 0x4,	/* can be configured as cpu port */
-		.port_cnt = 3,
-	},
-};
-
 static int ksz8_switch_init(struct ksz_device *dev)
 {
 	struct ksz8 *ksz8 = dev->priv;
@@ -1646,30 +1578,10 @@ static int ksz8_switch_init(struct ksz_device *dev)
 
 	dev->ds->ops = &ksz8_switch_ops;
 
-	for (i = 0; i < ARRAY_SIZE(ksz8_switch_chips); i++) {
-		const struct ksz_chip_data *chip = &ksz8_switch_chips[i];
-
-		if (dev->chip_id == chip->chip_id) {
-			dev->name = chip->dev_name;
-			dev->num_vlans = chip->num_vlans;
-			dev->num_alus = chip->num_alus;
-			dev->num_statics = chip->num_statics;
-			dev->port_cnt = chip->port_cnt;
-			dev->cpu_port = fls(chip->cpu_ports) - 1;
-			dev->phy_port_cnt = dev->port_cnt - 1;
-			dev->cpu_ports = chip->cpu_ports;
-			dev->host_mask = chip->cpu_ports;
-			dev->port_mask = (BIT(dev->phy_port_cnt) - 1) |
-					 chip->cpu_ports;
-			dev->ksz87xx_eee_link_erratum =
-				chip->ksz87xx_eee_link_erratum;
-			break;
-		}
-	}
-
-	/* no switch found */
-	if (!dev->cpu_ports)
-		return -ENODEV;
+	dev->cpu_port = fls(dev->info->cpu_ports) - 1;
+	dev->host_mask = dev->info->cpu_ports;
+	dev->phy_port_cnt = dev->info->port_cnt - 1;
+	dev->port_mask = (BIT(dev->phy_port_cnt) - 1) | dev->info->cpu_ports;
 
 	if (ksz_is_ksz88x3(dev)) {
 		ksz8->regs = ksz8863_regs;
@@ -1688,11 +1600,11 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	dev->reg_mib_cnt = MIB_COUNTER_NUM;
 
 	dev->ports = devm_kzalloc(dev->dev,
-				  dev->port_cnt * sizeof(struct ksz_port),
+				  dev->info->port_cnt * sizeof(struct ksz_port),
 				  GFP_KERNEL);
 	if (!dev->ports)
 		return -ENOMEM;
-	for (i = 0; i < dev->port_cnt; i++) {
+	for (i = 0; i < dev->info->port_cnt; i++) {
 		mutex_init(&dev->ports[i].mib.cnt_mutex);
 		dev->ports[i].mib.counters =
 			devm_kzalloc(dev->dev,
@@ -1704,7 +1616,7 @@ static int ksz8_switch_init(struct ksz_device *dev)
 	}
 
 	/* set the real number of ports */
-	dev->ds->num_ports = dev->port_cnt;
+	dev->ds->num_ports = dev->info->port_cnt;
 
 	/* We rely on software untagging on the CPU port, so that we
 	 * can support both tagged and untagged VLANs
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 61dd0fa97748..c712a0011367 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -100,7 +100,7 @@ static int ksz9477_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	/* Cache the per-port MTU setting */
 	dev->ports[port].max_frame = frame_size;
 
-	for (i = 0; i < dev->port_cnt; i++)
+	for (i = 0; i < dev->info->port_cnt; i++)
 		max_frame = max(max_frame, dev->ports[i].max_frame);
 
 	return regmap_update_bits(dev->regmap[1], REG_SW_MTU__2,
@@ -434,7 +434,7 @@ static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 			   SW_FLUSH_OPTION_M << SW_FLUSH_OPTION_S,
 			   SW_FLUSH_OPTION_DYN_MAC << SW_FLUSH_OPTION_S);
 
-	if (port < dev->port_cnt) {
+	if (port < dev->info->port_cnt) {
 		/* flush individual port */
 		ksz_pread8(dev, port, P_STP_CTRL, &data);
 		if (!(data & PORT_LEARN_DISABLE))
@@ -756,7 +756,7 @@ static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 
 	mutex_lock(&dev->alu_mutex);
 
-	for (index = 0; index < dev->num_statics; index++) {
+	for (index = 0; index < dev->info->num_statics; index++) {
 		/* find empty slot first */
 		data = (index << ALU_STAT_INDEX_S) |
 			ALU_STAT_READ | ALU_STAT_START;
@@ -787,7 +787,7 @@ static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 	}
 
 	/* no available entry */
-	if (index == dev->num_statics) {
+	if (index == dev->info->num_statics) {
 		err = -ENOSPC;
 		goto exit;
 	}
@@ -832,7 +832,7 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 
 	mutex_lock(&dev->alu_mutex);
 
-	for (index = 0; index < dev->num_statics; index++) {
+	for (index = 0; index < dev->info->num_statics; index++) {
 		/* find empty slot first */
 		data = (index << ALU_STAT_INDEX_S) |
 			ALU_STAT_READ | ALU_STAT_START;
@@ -861,7 +861,7 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 	}
 
 	/* no available entry */
-	if (index == dev->num_statics)
+	if (index == dev->info->num_statics)
 		goto exit;
 
 	/* clear port */
@@ -903,7 +903,7 @@ static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
 	 * Check if any of the port is already set for sniffing
 	 * If yes, instruct the user to remove the previous entry & exit
 	 */
-	for (p = 0; p < dev->port_cnt; p++) {
+	for (p = 0; p < dev->info->port_cnt; p++) {
 		/* Skip the current sniffing port */
 		if (p == mirror->to_local_port)
 			continue;
@@ -946,7 +946,7 @@ static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
 
 
 	/* Check if any of the port is still referring to sniffer port */
-	for (p = 0; p < dev->port_cnt; p++) {
+	for (p = 0; p < dev->info->port_cnt; p++) {
 		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
 
 		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
@@ -1194,7 +1194,7 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 			     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
 			     false);
 
-		if (dev->phy_errata_9477)
+		if (dev->info->phy_errata_9477)
 			ksz9477_phy_errata_setup(dev, port);
 	} else {
 		/* force flow control */
@@ -1259,8 +1259,9 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 	struct ksz_port *p;
 	int i;
 
-	for (i = 0; i < dev->port_cnt; i++) {
-		if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 << i))) {
+	for (i = 0; i < dev->info->port_cnt; i++) {
+		if (dsa_is_cpu_port(ds, i) &&
+		    (dev->info->cpu_ports & (1 << i))) {
 			phy_interface_t interface;
 			const char *prev_msg;
 			const char *prev_mode;
@@ -1304,7 +1305,7 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 		}
 	}
 
-	for (i = 0; i < dev->port_cnt; i++) {
+	for (i = 0; i < dev->info->port_cnt; i++) {
 		if (i == dev->cpu_port)
 			continue;
 		p = &dev->ports[i];
@@ -1328,7 +1329,7 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	int ret = 0;
 
 	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
-				       dev->num_vlans, GFP_KERNEL);
+				       dev->info->num_vlans, GFP_KERNEL);
 	if (!dev->vlan_cache)
 		return -ENOMEM;
 
@@ -1470,96 +1471,23 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 	return 0;
 }
 
-struct ksz_chip_data {
-	u32 chip_id;
-	const char *dev_name;
-	int num_vlans;
-	int num_alus;
-	int num_statics;
-	int cpu_ports;
-	int port_cnt;
-	bool phy_errata_9477;
-};
-
-static const struct ksz_chip_data ksz9477_switch_chips[] = {
-	{
-		.chip_id = 0x00947700,
-		.dev_name = "KSZ9477",
-		.num_vlans = 4096,
-		.num_alus = 4096,
-		.num_statics = 16,
-		.cpu_ports = 0x7F,	/* can be configured as cpu port */
-		.port_cnt = 7,		/* total physical port count */
-		.phy_errata_9477 = true,
-	},
-	{
-		.chip_id = 0x00989700,
-		.dev_name = "KSZ9897",
-		.num_vlans = 4096,
-		.num_alus = 4096,
-		.num_statics = 16,
-		.cpu_ports = 0x7F,	/* can be configured as cpu port */
-		.port_cnt = 7,		/* total physical port count */
-		.phy_errata_9477 = true,
-	},
-	{
-		.chip_id = 0x00989300,
-		.dev_name = "KSZ9893",
-		.num_vlans = 4096,
-		.num_alus = 4096,
-		.num_statics = 16,
-		.cpu_ports = 0x07,	/* can be configured as cpu port */
-		.port_cnt = 3,		/* total port count */
-	},
-	{
-		.chip_id = 0x00956700,
-		.dev_name = "KSZ9567",
-		.num_vlans = 4096,
-		.num_alus = 4096,
-		.num_statics = 16,
-		.cpu_ports = 0x7F,	/* can be configured as cpu port */
-		.port_cnt = 7,		/* total physical port count */
-		.phy_errata_9477 = true,
-	},
-};
-
 static int ksz9477_switch_init(struct ksz_device *dev)
 {
 	int i;
 
 	dev->ds->ops = &ksz9477_switch_ops;
 
-	for (i = 0; i < ARRAY_SIZE(ksz9477_switch_chips); i++) {
-		const struct ksz_chip_data *chip = &ksz9477_switch_chips[i];
-
-		if (dev->chip_id == chip->chip_id) {
-			dev->name = chip->dev_name;
-			dev->num_vlans = chip->num_vlans;
-			dev->num_alus = chip->num_alus;
-			dev->num_statics = chip->num_statics;
-			dev->port_cnt = chip->port_cnt;
-			dev->cpu_ports = chip->cpu_ports;
-			dev->phy_errata_9477 = chip->phy_errata_9477;
-
-			break;
-		}
-	}
-
-	/* no switch found */
-	if (!dev->port_cnt)
-		return -ENODEV;
-
-	dev->port_mask = (1 << dev->port_cnt) - 1;
+	dev->port_mask = (1 << dev->info->port_cnt) - 1;
 
 	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
 	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
 
 	dev->ports = devm_kzalloc(dev->dev,
-				  dev->port_cnt * sizeof(struct ksz_port),
+				  dev->info->port_cnt * sizeof(struct ksz_port),
 				  GFP_KERNEL);
 	if (!dev->ports)
 		return -ENOMEM;
-	for (i = 0; i < dev->port_cnt; i++) {
+	for (i = 0; i < dev->info->port_cnt; i++) {
 		spin_lock_init(&dev->ports[i].mib.stats64_lock);
 		mutex_init(&dev->ports[i].mib.cnt_mutex);
 		dev->ports[i].mib.counters =
@@ -1572,7 +1500,7 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 	}
 
 	/* set the real number of ports */
-	dev->ds->num_ports = dev->port_cnt;
+	dev->ds->num_ports = dev->info->port_cnt;
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 10f127b09e58..4e1bed4759f2 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -59,6 +59,172 @@ struct ksz_stats_raw {
 	u64 tx_discards;
 };
 
+const struct ksz_chip_data ksz_switch_chips[] = {
+	[KSZ8795] = {
+		.chip_id = 0x8795,
+		.dev_name = "KSZ8795",
+		.num_vlans = 4096,
+		.num_alus = 0,
+		.num_statics = 8,
+		.cpu_ports = 0x10,	/* can be configured as cpu port */
+		.port_cnt = 5,		/* total cpu and user ports */
+		.ksz87xx_eee_link_erratum = true,
+	},
+
+	[KSZ8794] = {
+		/* WARNING
+		 * =======
+		 * KSZ8794 is similar to KSZ8795, except the port map
+		 * contains a gap between external and CPU ports, the
+		 * port map is NOT continuous. The per-port register
+		 * map is shifted accordingly too, i.e. registers at
+		 * offset 0x40 are NOT used on KSZ8794 and they ARE
+		 * used on KSZ8795 for external port 3.
+		 *           external  cpu
+		 * KSZ8794   0,1,2      4
+		 * KSZ8795   0,1,2,3    4
+		 * KSZ8765   0,1,2,3    4
+		 * port_cnt is configured as 5, even though it is 4
+		 */
+		.chip_id = 0x8794,
+		.dev_name = "KSZ8794",
+		.num_vlans = 4096,
+		.num_alus = 0,
+		.num_statics = 8,
+		.cpu_ports = 0x10,	/* can be configured as cpu port */
+		.port_cnt = 5,		/* total cpu and user ports */
+		.ksz87xx_eee_link_erratum = true,
+	},
+
+	[KSZ8765] = {
+		.chip_id = 0x8765,
+		.dev_name = "KSZ8765",
+		.num_vlans = 4096,
+		.num_alus = 0,
+		.num_statics = 8,
+		.cpu_ports = 0x10,	/* can be configured as cpu port */
+		.port_cnt = 5,		/* total cpu and user ports */
+		.ksz87xx_eee_link_erratum = true,
+	},
+
+	[KSZ8830] = {
+		.chip_id = 0x8830,
+		.dev_name = "KSZ8863/KSZ8873",
+		.num_vlans = 16,
+		.num_alus = 0,
+		.num_statics = 8,
+		.cpu_ports = 0x4,	/* can be configured as cpu port */
+		.port_cnt = 3,
+	},
+
+	[KSZ9477] = {
+		.chip_id = 0x00947700,
+		.dev_name = "KSZ9477",
+		.num_vlans = 4096,
+		.num_alus = 4096,
+		.num_statics = 16,
+		.cpu_ports = 0x7F,	/* can be configured as cpu port */
+		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
+	},
+
+	[KSZ9897] = {
+		.chip_id = 0x00989700,
+		.dev_name = "KSZ9897",
+		.num_vlans = 4096,
+		.num_alus = 4096,
+		.num_statics = 16,
+		.cpu_ports = 0x7F,	/* can be configured as cpu port */
+		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
+	},
+
+	[KSZ9893] = {
+		.chip_id = 0x00989300,
+		.dev_name = "KSZ9893",
+		.num_vlans = 4096,
+		.num_alus = 4096,
+		.num_statics = 16,
+		.cpu_ports = 0x07,	/* can be configured as cpu port */
+		.port_cnt = 3,		/* total port count */
+	},
+
+	[KSZ9567] = {
+		.chip_id = 0x00956700,
+		.dev_name = "KSZ9567",
+		.num_vlans = 4096,
+		.num_alus = 4096,
+		.num_statics = 16,
+		.cpu_ports = 0x7F,	/* can be configured as cpu port */
+		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
+	},
+
+	[LAN9370] = {
+		.chip_id = 0x00937010,
+		.dev_name = "LAN9370",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		.cpu_ports = 0x10,	/* can be configured as cpu port */
+		.port_cnt = 5,		/* total physical port count */
+	},
+
+	[LAN9371] = {
+		.chip_id = 0x00937110,
+		.dev_name = "LAN9371",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		.cpu_ports = 0x30,	/* can be configured as cpu port */
+		.port_cnt = 6,		/* total physical port count */
+	},
+
+	[LAN9372] = {
+		.chip_id = 0x00937210,
+		.dev_name = "LAN9372",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		.cpu_ports = 0x30,	/* can be configured as cpu port */
+		.port_cnt = 8,		/* total physical port count */
+	},
+
+	[LAN9373] = {
+		.chip_id = 0x00937310,
+		.dev_name = "LAN9373",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		.cpu_ports = 0x38,	/* can be configured as cpu port */
+		.port_cnt = 5,		/* total physical port count */
+	},
+
+	[LAN9374] = {
+		.chip_id = 0x00937410,
+		.dev_name = "LAN9374",
+		.num_vlans = 4096,
+		.num_alus = 1024,
+		.num_statics = 256,
+		.cpu_ports = 0x30,	/* can be configured as cpu port */
+		.port_cnt = 8,		/* total physical port count */
+	},
+};
+
+static const struct ksz_chip_data *ksz_lookup_info(unsigned int prod_num)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ksz_switch_chips); i++) {
+		const struct ksz_chip_data *chip = &ksz_switch_chips[i];
+
+		if (chip->chip_id == prod_num)
+			return chip;
+	}
+
+	return NULL;
+}
+
 void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 {
 	struct rtnl_link_stats64 *stats;
@@ -207,7 +373,7 @@ static void ksz_mib_read_work(struct work_struct *work)
 	struct ksz_port *p;
 	int i;
 
-	for (i = 0; i < dev->port_cnt; i++) {
+	for (i = 0; i < dev->info->port_cnt; i++) {
 		if (dsa_is_unused_port(dev->ds, i))
 			continue;
 
@@ -242,7 +408,7 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 
 	INIT_DELAYED_WORK(&dev->mib_read, ksz_mib_read_work);
 
-	for (i = 0; i < dev->port_cnt; i++)
+	for (i = 0; i < dev->info->port_cnt; i++)
 		dev->dev_ops->port_init_cnt(dev, i);
 }
 EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
@@ -382,7 +548,7 @@ int ksz_port_mdb_add(struct dsa_switch *ds, int port,
 	int empty = 0;
 
 	alu.port_forward = 0;
-	for (index = 0; index < dev->num_statics; index++) {
+	for (index = 0; index < dev->info->num_statics; index++) {
 		if (!dev->dev_ops->r_sta_mac_table(dev, index, &alu)) {
 			/* Found one already in static MAC table. */
 			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
@@ -395,11 +561,11 @@ int ksz_port_mdb_add(struct dsa_switch *ds, int port,
 	}
 
 	/* no available entry */
-	if (index == dev->num_statics && !empty)
+	if (index == dev->info->num_statics && !empty)
 		return -ENOSPC;
 
 	/* add entry */
-	if (index == dev->num_statics) {
+	if (index == dev->info->num_statics) {
 		index = empty - 1;
 		memset(&alu, 0, sizeof(alu));
 		memcpy(alu.mac, mdb->addr, ETH_ALEN);
@@ -426,7 +592,7 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 	struct alu_struct alu;
 	int index;
 
-	for (index = 0; index < dev->num_statics; index++) {
+	for (index = 0; index < dev->info->num_statics; index++) {
 		if (!dev->dev_ops->r_sta_mac_table(dev, index, &alu)) {
 			/* Found one already in static MAC table. */
 			if (!memcmp(alu.mac, mdb->addr, ETH_ALEN) &&
@@ -436,7 +602,7 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 	}
 
 	/* no available entry */
-	if (index == dev->num_statics)
+	if (index == dev->info->num_statics)
 		goto exit;
 
 	/* clear port */
@@ -537,6 +703,7 @@ EXPORT_SYMBOL(ksz_switch_alloc);
 int ksz_switch_register(struct ksz_device *dev,
 			const struct ksz_dev_ops *ops)
 {
+	const struct ksz_chip_data *info;
 	struct device_node *port, *ports;
 	phy_interface_t interface;
 	unsigned int port_num;
@@ -567,6 +734,13 @@ int ksz_switch_register(struct ksz_device *dev,
 	if (dev->dev_ops->detect(dev))
 		return -EINVAL;
 
+	info = ksz_lookup_info(dev->chip_id);
+	if (!info)
+		return -ENODEV;
+
+	/* Update the compatible info with the probed one */
+	dev->info = info;
+
 	ret = dev->dev_ops->init(dev);
 	if (ret)
 		return ret;
@@ -574,7 +748,7 @@ int ksz_switch_register(struct ksz_device *dev,
 	/* Host port interface will be self detected, or specifically set in
 	 * device tree.
 	 */
-	for (port_num = 0; port_num < dev->port_cnt; ++port_num)
+	for (port_num = 0; port_num < dev->info->port_cnt; ++port_num)
 		dev->ports[port_num].interface = PHY_INTERFACE_MODE_NA;
 	if (dev->dev->of_node) {
 		ret = of_get_phy_mode(dev->dev->of_node, &interface);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 28cda79b090f..7d87738329de 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -26,6 +26,18 @@ struct ksz_port_mib {
 	struct spinlock stats64_lock;
 };
 
+struct ksz_chip_data {
+	u32 chip_id;
+	const char *dev_name;
+	int num_vlans;
+	int num_alus;
+	int num_statics;
+	int cpu_ports;
+	int port_cnt;
+	bool phy_errata_9477;
+	bool ksz87xx_eee_link_erratum;
+};
+
 struct ksz_port {
 	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
 	int stp_state;
@@ -48,6 +60,7 @@ struct ksz_device {
 	struct dsa_switch *ds;
 	struct ksz_platform_data *pdata;
 	const char *name;
+	const struct ksz_chip_data *info;
 
 	struct mutex dev_mutex;		/* device access */
 	struct mutex regmap_mutex;	/* regmap access */
@@ -64,20 +77,13 @@ struct ksz_device {
 
 	/* chip specific data */
 	u32 chip_id;
-	int num_vlans;
-	int num_alus;
-	int num_statics;
 	int cpu_port;			/* port connected to CPU */
-	int cpu_ports;			/* port bitmap can be cpu port */
 	int phy_port_cnt;
-	int port_cnt;
 	u8 reg_mib_cnt;
 	int mib_cnt;
 	const struct mib_names *mib_names;
 	phy_interface_t compat_interface;
 	u32 regs_size;
-	bool phy_errata_9477;
-	bool ksz87xx_eee_link_erratum;
 	bool synclko_125;
 	bool synclko_disable;
 
@@ -94,6 +100,23 @@ struct ksz_device {
 	u16 port_mask;
 };
 
+/* List of supported models */
+enum ksz_model {
+	KSZ8795,
+	KSZ8794,
+	KSZ8765,
+	KSZ8830,
+	KSZ9477,
+	KSZ9897,
+	KSZ9893,
+	KSZ9567,
+	LAN9370,
+	LAN9371,
+	LAN9372,
+	LAN9373,
+	LAN9374,
+};
+
 struct alu_struct {
 	/* entry 1 */
 	u8	is_static:1;
-- 
2.33.0

