Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499C353E5DC
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbiFFNqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239048AbiFFNqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:46:24 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6242B1964
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 06:46:21 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x5so13810265edi.2
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 06:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+prGQaCEIgFN71c5M9SNYfoEIfjYo8Cc5lTo+wFh6BE=;
        b=Vfp0ZeSY2GtdN0TOvYIz47jTO8DJxOLRf7OllZ8h5ahSlKDxh46Nla6zo3kD5kQnkh
         Xe3okGbcXTrr06LZKofSZIlzMUhTP9FHJnKz6aVEsUTAgPWjChcl863C4YGAORDCIl82
         lW9sd+tCYou9d5VGtzutNHNpRScThOdAjewPE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+prGQaCEIgFN71c5M9SNYfoEIfjYo8Cc5lTo+wFh6BE=;
        b=DsVMbhCIxY2lS4vPGSGdLUvJYDIUvR2kMtjE8oaTDFcSU73bXiJm37rma8aXPltP5X
         Gfeevaxpl7vxjo/w7/TkUyaJs0pceWeoUyU7dTclOLt1z1jEXM5lv/5E9rljGaMujQeP
         bhahJhPtHdPgyw5KmKKN6uJ+tTjk7TR4M8wVBsPkDlFXxkrgukIhjgEKmHk2y+85vzEr
         V/Rh8hM6R3C3ed5u9NJ+T+wl6PodRb1w6kWA499M7gfsavtUjAWDBlhbh3ZxgAYcIZVU
         +xdp/ncrQ2mvd6QugljNEuyXq3n3ZPS/b67mECDhnehgpyvECe2aoCnTVck79FxlzR5D
         OHyg==
X-Gm-Message-State: AOAM530UaLpOzkpX17Z5AWMAyUIApsXdw/PYGXKqRfCAWp1dJaXSY0Vt
        lcByClFD30hTX+PxDprVzdcUyw==
X-Google-Smtp-Source: ABdhPJzzbzaRw04WEzuuxy4f1/A3haCV+AzRlq9xgxB4rRr3TTwto7u6DvgWEnes+6k3QJOOb85Xgg==
X-Received: by 2002:aa7:cc8f:0:b0:42d:f88c:9f63 with SMTP id p15-20020aa7cc8f000000b0042df88c9f63mr27535199edt.288.1654523180079;
        Mon, 06 Jun 2022 06:46:20 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id a26-20020a1709062b1a00b006f3ef214db4sm5496538ejg.26.2022.06.06.06.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 06:46:19 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     luizluca@gmail.com, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: dsa: realtek: rtl8365mb: handle PHY interface modes correctly
Date:   Mon,  6 Jun 2022 15:45:53 +0200
Message-Id: <20220606134553.2919693-6-alvin@pqrs.dk>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220606134553.2919693-1-alvin@pqrs.dk>
References: <20220606134553.2919693-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Realtek switches in the rtl8365mb family always have at least one port
with a so-called external interface, supporting PHY interface modes such
as RGMII or SGMII. The purpose of this patch is to improve the driver's
handling of these ports.

A new struct rtl8365mb_chip_info is introduced. A static instance of
this struct is added for each supported switch, which is distinguished
by its chip ID and version. Embedded in each chip_info struct is an
array of struct rtl8365mb_extint, describing the external interfaces
available. This is more specific than the old rtl8365mb_extint_port_map,
which was only valid for switches with up to 6 ports.

The struct rtl8365mb_extint also contains a bitmask of supported PHY
interface modes, which allows the driver to distinguish which ports
support RGMII. This corrects a previous mistake in the driver whereby it
was assumed that any port with an external interface supports RGMII.
This is not actually the case: for example, the RTL8367S has two
external interfaces, only the second of which supports RGMII. The first
supports only SGMII and HSGMII. This new design will make it easier to
add support for other interface modes.

Finally, rtl8365mb_phylink_get_caps() is fixed up to return supported
capabilities based on the external interface properties described above.
This allows for ports with an external interface to be treated as DSA
user ports, and for ports with an internal PHY to be treated as DSA CPU
ports.

Link: https://lore.kernel.org/netdev/20220510192301.5djdt3ghoavxulhl@bang-olufsen.dk/
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 247 +++++++++++++++++++++-------
 1 file changed, 183 insertions(+), 64 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index a3a4454f77bf..2dc0459af5a4 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -118,9 +118,6 @@
 #define RTL8365MB_MAX_NUM_PORTS		11
 #define RTL8365MB_LEARN_LIMIT_MAX	2112
 
-/* valid for all 6-port or less variants */
-static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2, -1, -1};
-
 /* Chip identification registers */
 #define RTL8365MB_CHIP_ID_REG		0x1300
 
@@ -200,7 +197,7 @@ static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2,
 /* The PHY OCP addresses of PHY registers 0~31 start here */
 #define RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE		0xA400
 
-/* EXT interface port mode values - used in DIGITAL_INTERFACE_SELECT */
+/* External interface port mode values - used in DIGITAL_INTERFACE_SELECT */
 #define RTL8365MB_EXT_PORT_MODE_DISABLE		0
 #define RTL8365MB_EXT_PORT_MODE_RGMII		1
 #define RTL8365MB_EXT_PORT_MODE_MII_MAC		2
@@ -216,19 +213,7 @@ static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2,
 #define RTL8365MB_EXT_PORT_MODE_1000X		12
 #define RTL8365MB_EXT_PORT_MODE_100FX		13
 
-/* Realtek docs and driver uses logic number as EXT_PORT0=16, EXT_PORT1=17,
- * EXT_PORT2=18, to interact with switch ports. That logic number is internally
- * converted to either a physical port number (0..9) or an external interface id (0..2),
- * depending on which function was called. The external interface id is calculated as
- * (ext_id=logic_port-15), while the logical to physical map depends on the chip id/version.
- *
- * EXT_PORT0 mentioned in datasheets and rtl8367c driver is used in this driver
- * as extid==1, EXT_PORT2, mentioned in Realtek rtl8367c driver for 10-port switches,
- * would have an ext_id of 3 (out of range for most extint macros) and ext_id 0 does
- * not seem to be used as well for this family.
- */
-
-/* EXT interface mode configuration registers 0~1 */
+/* External interface mode configuration registers 0~1 */
 #define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0		0x1305 /* EXT1 */
 #define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1		0x13C3 /* EXT2 */
 #define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extint) \
@@ -240,7 +225,7 @@ static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2,
 #define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extint) \
 		(((_extint) % 2) * 4)
 
-/* EXT interface RGMII TX/RX delay configuration registers 0~2 */
+/* External interface RGMII TX/RX delay configuration registers 0~2 */
 #define RTL8365MB_EXT_RGMXF_REG0		0x1306 /* EXT0 */
 #define RTL8365MB_EXT_RGMXF_REG1		0x1307 /* EXT1 */
 #define RTL8365MB_EXT_RGMXF_REG2		0x13C5 /* EXT2 */
@@ -257,7 +242,7 @@ static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2,
 #define RTL8365MB_PORT_SPEED_100M	1
 #define RTL8365MB_PORT_SPEED_1000M	2
 
-/* EXT interface force configuration registers 0~2 */
+/* External interface force configuration registers 0~2 */
 #define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0		0x1310 /* EXT0 */
 #define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1		0x1311 /* EXT1 */
 #define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2		0x13C4 /* EXT2 */
@@ -489,6 +474,100 @@ static const struct rtl8365mb_jam_tbl_entry rtl8365mb_init_jam_common[] = {
 	{ 0x1D32, 0x0002 },
 };
 
+enum rtl8365mb_phy_interface_mode {
+	RTL8365MB_PHY_INTERFACE_MODE_INVAL = 0, /* used as sentinel */
+	RTL8365MB_PHY_INTERFACE_MODE_INTERNAL = BIT(0),
+	RTL8365MB_PHY_INTERFACE_MODE_MII = BIT(1),
+	RTL8365MB_PHY_INTERFACE_MODE_TMII = BIT(2),
+	RTL8365MB_PHY_INTERFACE_MODE_RMII = BIT(3),
+	RTL8365MB_PHY_INTERFACE_MODE_RGMII = BIT(4),
+	RTL8365MB_PHY_INTERFACE_MODE_SGMII = BIT(5),
+	RTL8365MB_PHY_INTERFACE_MODE_HSGMII = BIT(6),
+};
+
+/**
+ * struct rtl8365mb_extint - external interface info
+ * @port: the port with an external interface
+ * @id: the external interface ID, which is either 0, 1, or 2
+ * @supported_interfaces: a bitmask of supported PHY interface modes
+ *
+ * Represents a mapping: port -> { id, supported_interfaces }. To be embedded
+ * in &struct rtl8365mb_chip_info for every port with an external interface.
+ */
+struct rtl8365mb_extint {
+	int port;
+	int id;
+	unsigned int supported_interfaces;
+};
+
+/**
+ * struct rtl8365mb_chip_info - static chip-specific info
+ * @name: human-readable chip name
+ * @chip_id: chip identifier
+ * @chip_ver: chip silicon revision
+ * @jam_table: chip-specific initialization jam table
+ * @jam_size: size of the chip's jam table
+ * @extints: external interfaces, followed by a zero sentinel
+ *
+ * These data are specific to a given chip in the family of switches supported
+ * by this driver. When adding support for another chip in the family, a new
+ * static struct of this type should be defined, and assigned in the
+ * rtl8365mb_detect() function based on chip ID/version.
+ */
+struct rtl8365mb_chip_info {
+	const char *name;
+	u32 chip_id;
+	u32 chip_ver;
+	const struct rtl8365mb_jam_tbl_entry *jam_table;
+	size_t jam_size;
+	const struct rtl8365mb_extint extints[];
+};
+
+/* Chip info for each supported switch in the family */
+#define PHY_INTF(_mode) (RTL8365MB_PHY_INTERFACE_MODE_ ## _mode)
+
+static const struct rtl8365mb_chip_info rtl8365mb_chip_info_8365mb_vc = {
+	.name = "RTL8365MB-VC",
+	.chip_id = RTL8365MB_CHIP_ID_8365MB_VC,
+	.chip_ver = RTL8365MB_CHIP_VER_8365MB_VC,
+	.extints = {
+		{ 6, 1, PHY_INTF(MII) |	PHY_INTF(TMII) | PHY_INTF(RMII) |
+			PHY_INTF(RGMII) },
+		{ /* sentinel */ }
+	},
+	.jam_table = rtl8365mb_init_jam_8365mb_vc,
+	.jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
+};
+
+static const struct rtl8365mb_chip_info rtl8365mb_chip_info_8367s = {
+	.name = "RTL8367S",
+	.chip_id = RTL8365MB_CHIP_ID_8367S,
+	.chip_ver = RTL8365MB_CHIP_VER_8367S,
+	.extints = {
+		{ 6, 1, PHY_INTF(SGMII) | PHY_INTF(HSGMII) },
+		{ 7, 2, PHY_INTF(MII) | PHY_INTF(TMII) | PHY_INTF(RMII) |
+			PHY_INTF(RGMII) },
+		{ /* sentinel */ }
+	},
+	.jam_table = rtl8365mb_init_jam_8365mb_vc,
+	.jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
+};
+
+static const struct rtl8365mb_chip_info rtl8365mb_chip_info_8367rb_vb = {
+	.name = "RTL8367RB-VB",
+	.chip_id = RTL8365MB_CHIP_ID_8367RB_VB,
+	.chip_ver = RTL8365MB_CHIP_VER_8367RB_VB,
+	.extints = {
+		{ 6, 1, PHY_INTF(MII) | PHY_INTF(TMII) | PHY_INTF(RMII) |
+			PHY_INTF(RGMII) },
+		{ 7, 2, PHY_INTF(MII) | PHY_INTF(TMII) | PHY_INTF(RMII) |
+			PHY_INTF(RGMII) },
+		{ /* sentinel */ }
+	},
+	.jam_table = rtl8365mb_init_jam_8365mb_vc,
+	.jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc),
+};
+
 enum rtl8365mb_stp_state {
 	RTL8365MB_STP_STATE_DISABLED = 0,
 	RTL8365MB_STP_STATE_BLOCKING = 1,
@@ -558,7 +637,7 @@ struct rtl8365mb_port {
 };
 
 /**
- * struct rtl8365mb - private chip-specific driver data
+ * struct rtl8365mb - driver private data
  * @priv: pointer to parent realtek_priv data
  * @irq: registered IRQ or zero
  * @chip_id: chip identifier
@@ -574,13 +653,10 @@ struct rtl8365mb_port {
 struct rtl8365mb {
 	struct realtek_priv *priv;
 	int irq;
-	u32 chip_id;
-	u32 chip_ver;
+	const struct rtl8365mb_chip_info *chip_info;
 	struct rtl8365mb_cpu cpu;
 	struct mutex mib_lock;
 	struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
-	const struct rtl8365mb_jam_tbl_entry *jam_table;
-	size_t jam_size;
 };
 
 static int rtl8365mb_phy_poll_busy(struct realtek_priv *priv)
@@ -775,6 +851,31 @@ static int rtl8365mb_dsa_phy_write(struct dsa_switch *ds, int phy, int regnum,
 	return rtl8365mb_phy_write(ds->priv, phy, regnum, val);
 }
 
+const struct rtl8365mb_extint *
+rtl8365mb_get_port_extint(struct realtek_priv *priv, int port)
+{
+	struct rtl8365mb *mb = priv->chip_data;
+	const struct rtl8365mb_extint *extint;
+	const struct rtl8365mb_chip_info *ci;
+
+	ci = mb->chip_info;
+	extint = &ci->extints[0];
+
+	/* Every external interface supports at least one mode, so at least one
+	 * bit should be set in supported_interfaces. We use 0 as a sentinel,
+	 * cf. @RTL8265MB_PHY_INTERFACE_MODE_INVAL = 0.
+	 */
+	while (extint->supported_interfaces !=
+	       RTL8365MB_PHY_INTERFACE_MODE_INVAL) {
+		if (extint->port == port)
+			return extint;
+
+		extint++;
+	}
+
+	return NULL;
+}
+
 static enum dsa_tag_protocol
 rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
 			   enum dsa_tag_protocol mp)
@@ -795,18 +896,23 @@ rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
 static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 				      phy_interface_t interface)
 {
+	const struct rtl8365mb_extint *extint =
+		rtl8365mb_get_port_extint(priv, port);
 	struct device_node *dn;
 	struct dsa_port *dp;
 	int tx_delay = 0;
 	int rx_delay = 0;
-	int ext_int;
 	u32 val;
 	int ret;
 
-	ext_int = rtl8365mb_extint_port_map[port];
+	if (!extint) {
+		dev_err(priv->dev, "port %d has no external interface\n", port);
+		return -EINVAL;
+	}
 
-	if (ext_int <= 0) {
-		dev_err(priv->dev, "Port %d is not an external interface port\n", port);
+	if (!(extint->supported_interfaces &
+	      RTL8365MB_PHY_INTERFACE_MODE_RGMII)) {
+		dev_err(priv->dev, "port %d doesn't support RGMII\n", port);
 		return -EINVAL;
 	}
 
@@ -842,7 +948,7 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 			tx_delay = val / 2;
 		else
 			dev_warn(priv->dev,
-				 "EXT interface TX delay must be 0 or 2 ns\n");
+				 "RGMII TX delay must be 0 or 2 ns\n");
 	}
 
 	if (!of_property_read_u32(dn, "rx-internal-delay-ps", &val)) {
@@ -852,11 +958,11 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 			rx_delay = val;
 		else
 			dev_warn(priv->dev,
-				 "EXT interface RX delay must be 0 to 2.1 ns\n");
+				 "RGMII RX delay must be 0 to 2.1 ns\n");
 	}
 
 	ret = regmap_update_bits(
-		priv->map, RTL8365MB_EXT_RGMXF_REG(ext_int),
+		priv->map, RTL8365MB_EXT_RGMXF_REG(extint->id),
 		RTL8365MB_EXT_RGMXF_TXDELAY_MASK |
 			RTL8365MB_EXT_RGMXF_RXDELAY_MASK,
 		FIELD_PREP(RTL8365MB_EXT_RGMXF_TXDELAY_MASK, tx_delay) |
@@ -865,11 +971,11 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 		return ret;
 
 	ret = regmap_update_bits(
-		priv->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_int),
-		RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_int),
+		priv->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(extint->id),
+		RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(extint->id),
 		RTL8365MB_EXT_PORT_MODE_RGMII
 			<< RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(
-				   ext_int));
+				   extint->id));
 	if (ret)
 		return ret;
 
@@ -880,19 +986,18 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 					  bool link, int speed, int duplex,
 					  bool tx_pause, bool rx_pause)
 {
+	const struct rtl8365mb_extint *extint =
+		rtl8365mb_get_port_extint(priv, port);
 	u32 r_tx_pause;
 	u32 r_rx_pause;
 	u32 r_duplex;
 	u32 r_speed;
 	u32 r_link;
-	int ext_int;
 	int val;
 	int ret;
 
-	ext_int = rtl8365mb_extint_port_map[port];
-
-	if (ext_int <= 0) {
-		dev_err(priv->dev, "Port %d is not an external interface port\n", port);
+	if (!extint) {
+		dev_err(priv->dev, "port %d has no external interface\n", port);
 		return -EINVAL;
 	}
 
@@ -942,7 +1047,7 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 			 r_duplex) |
 	      FIELD_PREP(RTL8365MB_DIGITAL_INTERFACE_FORCE_SPEED_MASK, r_speed);
 	ret = regmap_write(priv->map,
-			   RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(ext_int),
+			   RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(extint->id),
 			   val);
 	if (ret)
 		return ret;
@@ -974,14 +1079,31 @@ static bool rtl8365mb_phy_mode_supported(struct dsa_switch *ds, int port,
 static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
 				       struct phylink_config *config)
 {
-	if (dsa_is_user_port(ds, port))
-		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
-			  config->supported_interfaces);
-	else if (dsa_is_cpu_port(ds, port))
-		phy_interface_set_rgmii(config->supported_interfaces);
+	const struct rtl8365mb_extint *extint =
+		rtl8365mb_get_port_extint(ds->priv, port);
 
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 				   MAC_10 | MAC_100 | MAC_1000FD;
+
+	if (!extint) {
+		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
+			  config->supported_interfaces);
+
+		/* GMII is the default interface mode for phylib, so
+		 * we have to support it for ports with integrated PHY.
+		 */
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+		return;
+	}
+
+	/* Populate according to the modes supported by _this driver_,
+	 * not necessarily the modes supported by the hardware, some of
+	 * which remain unimplemented.
+	 */
+
+	if (extint->supported_interfaces & RTL8365MB_PHY_INTERFACE_MODE_RGMII)
+		phy_interface_set_rgmii(config->supported_interfaces);
 }
 
 static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int port,
@@ -1805,14 +1927,17 @@ static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds,
 static int rtl8365mb_switch_init(struct realtek_priv *priv)
 {
 	struct rtl8365mb *mb = priv->chip_data;
+	const struct rtl8365mb_chip_info *ci;
 	int ret;
 	int i;
 
+	ci = mb->chip_info;
+
 	/* Do any chip-specific init jam before getting to the common stuff */
-	if (mb->jam_table) {
-		for (i = 0; i < mb->jam_size; i++) {
-			ret = regmap_write(priv->map, mb->jam_table[i].reg,
-					   mb->jam_table[i].val);
+	if (ci->jam_table) {
+		for (i = 0; i < ci->jam_size; i++) {
+			ret = regmap_write(priv->map, ci->jam_table[i].reg,
+					   ci->jam_table[i].val);
 			if (ret)
 				return ret;
 		}
@@ -1997,33 +2122,27 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 	case RTL8365MB_CHIP_ID_8365MB_VC:
 		switch (chip_ver) {
 		case RTL8365MB_CHIP_VER_8365MB_VC:
-			dev_info(priv->dev,
-				 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
-				 chip_ver);
+			mb->chip_info = &rtl8365mb_chip_info_8365mb_vc;
 			break;
 		case RTL8365MB_CHIP_VER_8367RB_VB:
-			dev_info(priv->dev,
-				 "found an RTL8367RB-VB switch (ver=0x%04x)\n",
-				 chip_ver);
+			mb->chip_info = &rtl8365mb_chip_info_8367rb_vb;
 			break;
 		case RTL8365MB_CHIP_VER_8367S:
-			dev_info(priv->dev,
-				 "found an RTL8367S switch (ver=0x%04x)\n",
-				 chip_ver);
+			mb->chip_info = &rtl8365mb_chip_info_8367s;
 			break;
 		default:
-			dev_err(priv->dev, "unrecognized switch version (ver=0x%04x)",
-				chip_ver);
+			dev_err(priv->dev,
+				"unrecognized switch (id=0x%04x, ver=0x%04x)",
+				chip_id, chip_ver);
 			return -ENODEV;
 		}
 
+		dev_info(priv->dev, "found an %s switch\n",
+			 mb->chip_info->name);
+
 		priv->num_ports = RTL8365MB_MAX_NUM_PORTS;
 
 		mb->priv = priv;
-		mb->chip_id = chip_id;
-		mb->chip_ver = chip_ver;
-		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
-		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
 		mb->cpu.trap_port = RTL8365MB_MAX_NUM_PORTS;
 		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
-- 
2.36.0

