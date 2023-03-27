Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355FB6CAB6A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjC0REC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjC0RDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:03:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D5F4698
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UZW++6lliiJDeVPyj8RjV2Zj4/l6mP6SYQw/l0WCZl8=; b=HwxZxKyXwi8LqDAEScGrwbGj/9
        yYZzbUMRuV8o19p2X8u5qGz9amxrsFt98MG6UP63Qwe8UPXQwRRydQW4sddug/RgBWBLcBTuvuNrA
        NgGgGfIkMDo3ggwV8gCrGFgf80hDs6a4hvcA3rvP98ZhKilKJ13Sr37TUDpvfXOcgo7g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEU-008XqQ-G2; Mon, 27 Mar 2023 19:02:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 02/23] net: phylink: Plumb eee_active in mac_link_up call
Date:   Mon, 27 Mar 2023 19:01:40 +0200
Message-Id: <20230327170201.2036708-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327170201.2036708-1-andrew@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAC drivers need to know the result of the auto negotiation of Energy
Efficient Ethernet. This is a simple boolean, it should be active or
not in the MAC. Extend the mac_link_up call to pass this.

Currently the correct value should be passed, however no MAC drivers
have been modified to actually use it. Yet.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/b53/b53_common.c              |  3 ++-
 drivers/net/dsa/b53/b53_priv.h                |  3 ++-
 drivers/net/dsa/bcm_sf2.c                     |  3 ++-
 drivers/net/dsa/lan9303-core.c                |  2 +-
 drivers/net/dsa/lantiq_gswip.c                |  3 ++-
 drivers/net/dsa/microchip/ksz_common.c        | 10 +++++----
 drivers/net/dsa/microchip/ksz_common.h        |  3 ++-
 drivers/net/dsa/mt7530.c                      |  6 ++++--
 drivers/net/dsa/mv88e6xxx/chip.c              |  3 ++-
 drivers/net/dsa/ocelot/felix.c                |  3 ++-
 drivers/net/dsa/qca/ar9331.c                  |  3 ++-
 drivers/net/dsa/qca/qca8k-8xxx.c              |  3 ++-
 drivers/net/dsa/realtek/rtl8365mb.c           |  2 +-
 drivers/net/dsa/realtek/rtl8366rb.c           |  3 ++-
 drivers/net/dsa/rzn1_a5psw.c                  |  3 ++-
 drivers/net/dsa/sja1105/sja1105_main.c        |  3 ++-
 drivers/net/dsa/xrs700x/xrs700x.c             |  3 ++-
 drivers/net/ethernet/altera/altera_tse_main.c |  3 ++-
 drivers/net/ethernet/atheros/ag71xx.c         |  3 ++-
 drivers/net/ethernet/cadence/macb_main.c      |  3 ++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  3 ++-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  3 ++-
 .../net/ethernet/freescale/fman/fman_dtsec.c  |  3 ++-
 .../net/ethernet/freescale/fman/fman_memac.c  |  3 ++-
 .../net/ethernet/freescale/fman/fman_tgec.c   |  3 ++-
 drivers/net/ethernet/marvell/mvneta.c         |  3 ++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  5 +++--
 .../ethernet/marvell/prestera/prestera_main.c |  3 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  3 ++-
 .../microchip/lan966x/lan966x_phylink.c       |  3 ++-
 .../microchip/sparx5/sparx5_phylink.c         |  3 ++-
 drivers/net/ethernet/mscc/ocelot_net.c        |  3 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  3 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  3 ++-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  3 ++-
 drivers/net/phy/phy-core.c                    | 11 ++++++++++
 drivers/net/phy/phylink.c                     | 16 +++++++++++---
 drivers/net/usb/asix_devices.c                |  2 +-
 include/linux/phy.h                           |  1 +
 include/linux/phylink.h                       | 21 +++++++++++--------
 include/net/dsa.h                             |  3 ++-
 net/dsa/port.c                                |  6 ++++--
 42 files changed, 119 insertions(+), 56 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3464ce5e7470..aa3fd3c1b15e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1445,7 +1445,8 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			     phy_interface_t interface,
 			     struct phy_device *phydev,
 			     int speed, int duplex,
-			     bool tx_pause, bool rx_pause)
+			     bool tx_pause, bool rx_pause,
+			     bool eee_active)
 {
 	struct b53_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index fdcfd5081c28..ed7d695de3ac 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -363,7 +363,8 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			     phy_interface_t interface,
 			     struct phy_device *phydev,
 			     int speed, int duplex,
-			     bool tx_pause, bool rx_pause);
+			     bool tx_pause, bool rx_pause,
+			     bool eee_active);
 int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 		       struct netlink_ext_ack *extack);
 int b53_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index cde253d27bd0..72be649d4bc9 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -828,7 +828,8 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 				   phy_interface_t interface,
 				   struct phy_device *phydev,
 				   int speed, int duplex,
-				   bool tx_pause, bool rx_pause)
+				   bool tx_pause, bool rx_pause,
+				   bool eee_active)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->dev->ports[port].eee;
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index cbe831875347..e112a423f1a9 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1307,7 +1307,7 @@ static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
 					phy_interface_t interface,
 					struct phy_device *phydev, int speed,
 					int duplex, bool tx_pause,
-					bool rx_pause)
+					bool rx_pause, bool eee_active)
 {
 	struct lan9303 *chip = ds->priv;
 	u32 ctl;
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 3c76a1a14aee..9bd9b5f23280 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1736,7 +1736,8 @@ static void gswip_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				      phy_interface_t interface,
 				      struct phy_device *phydev,
 				      int speed, int duplex,
-				      bool tx_pause, bool rx_pause)
+				      bool tx_pause, bool rx_pause,
+				      bool eee_active)
 {
 	struct gswip_priv *priv = ds->priv;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 50fd548c72d8..3886b53f77d5 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -221,7 +221,7 @@ static void ksz9477_phylink_mac_link_up(struct ksz_device *dev, int port,
 					phy_interface_t interface,
 					struct phy_device *phydev, int speed,
 					int duplex, bool tx_pause,
-					bool rx_pause);
+					bool rx_pause, bool eee_active);
 
 static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.setup = ksz9477_setup,
@@ -2950,7 +2950,7 @@ static void ksz9477_phylink_mac_link_up(struct ksz_device *dev, int port,
 					phy_interface_t interface,
 					struct phy_device *phydev, int speed,
 					int duplex, bool tx_pause,
-					bool rx_pause)
+					bool rx_pause, bool eee_active)
 {
 	struct ksz_port *p;
 
@@ -2971,14 +2971,16 @@ static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				    unsigned int mode,
 				    phy_interface_t interface,
 				    struct phy_device *phydev, int speed,
-				    int duplex, bool tx_pause, bool rx_pause)
+				    int duplex, bool tx_pause, bool rx_pause,
+				    bool eee_active)
 {
 	struct ksz_device *dev = ds->priv;
 
 	if (dev->dev_ops->phylink_mac_link_up)
 		dev->dev_ops->phylink_mac_link_up(dev, port, mode, interface,
 						  phydev, speed, duplex,
-						  tx_pause, rx_pause);
+						  tx_pause, rx_pause,
+						  eee_active);
 }
 
 static int ksz_switch_detect(struct ksz_device *dev)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8abecaf6089e..f190716264db 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -354,7 +354,8 @@ struct ksz_dev_ops {
 				    unsigned int mode,
 				    phy_interface_t interface,
 				    struct phy_device *phydev, int speed,
-				    int duplex, bool tx_pause, bool rx_pause);
+				    int duplex, bool tx_pause, bool rx_pause,
+				    bool eee_active);
 	void (*setup_rgmii_delay)(struct ksz_device *dev, int port);
 	int (*tc_cbs_set_cinc)(struct ksz_device *dev, int port, u32 val);
 	void (*config_cpu_port)(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a0d99af897ac..6c89026ec966 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2721,7 +2721,8 @@ static void mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				       phy_interface_t interface,
 				       struct phy_device *phydev,
 				       int speed, int duplex,
-				       bool tx_pause, bool rx_pause)
+				       bool tx_pause, bool rx_pause,
+				       bool eee_active)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 mcr;
@@ -2806,7 +2807,8 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	mt753x_phylink_pcs_link_up(&priv->pcs[port].pcs, MLO_AN_FIXED,
 				   interface, speed, DUPLEX_FULL);
 	mt753x_phylink_mac_link_up(ds, port, MLO_AN_FIXED, interface, NULL,
-				   speed, DUPLEX_FULL, true, true);
+				   speed, DUPLEX_FULL, true, true,
+				   false);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b73d1d6747b7..7591f33b5993 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -932,7 +932,8 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 				  unsigned int mode, phy_interface_t interface,
 				  struct phy_device *phydev,
 				  int speed, int duplex,
-				  bool tx_pause, bool rx_pause)
+				  bool tx_pause, bool rx_pause,
+				  bool eee_active)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	const struct mv88e6xxx_ops *ops;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6dcebcfd71e7..63cd8ea4c22f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1099,7 +1099,8 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				      phy_interface_t interface,
 				      struct phy_device *phydev,
 				      int speed, int duplex,
-				      bool tx_pause, bool rx_pause)
+				      bool tx_pause, bool rx_pause,
+				      bool eee_active)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index e7b98b864fa1..c3f831a6b9a7 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -560,7 +560,8 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
 					  phy_interface_t interface,
 					  struct phy_device *phydev,
 					  int speed, int duplex,
-					  bool tx_pause, bool rx_pause)
+					  bool tx_pause, bool rx_pause,
+					  bool eee_active)
 {
 	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
 	struct ar9331_sw_port *p = &priv->port[port];
diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 62810903f1b3..a7f9fcbf896d 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1424,7 +1424,8 @@ qca8k_phylink_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 static void
 qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
 			  phy_interface_t interface, struct phy_device *phydev,
-			  int speed, int duplex, bool tx_pause, bool rx_pause)
+			  int speed, int duplex, bool tx_pause, bool rx_pause,
+			  bool eee_active)
 {
 	struct qca8k_priv *priv = ds->priv;
 	u32 reg;
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 41ea3b5a42b1..34b5bbfe60bb 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1113,7 +1113,7 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
 					  phy_interface_t interface,
 					  struct phy_device *phydev, int speed,
 					  int duplex, bool tx_pause,
-					  bool rx_pause)
+					  bool rx_pause, bool eee_active)
 {
 	struct realtek_priv *priv = ds->priv;
 	struct rtl8365mb_port *p;
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index 25f88022b9e4..3d1982bc8748 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1052,7 +1052,8 @@ static enum dsa_tag_protocol rtl8366_get_tag_protocol(struct dsa_switch *ds,
 static void
 rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
 		      phy_interface_t interface, struct phy_device *phydev,
-		      int speed, int duplex, bool tx_pause, bool rx_pause)
+		      int speed, int duplex, bool tx_pause, bool rx_pause,
+		      bool eee_active)
 {
 	struct realtek_priv *priv = ds->priv;
 	int ret;
diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 919027cf2012..d9d35258b9a5 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -251,7 +251,8 @@ static void a5psw_phylink_mac_link_up(struct dsa_switch *ds, int port,
 				      unsigned int mode,
 				      phy_interface_t interface,
 				      struct phy_device *phydev, int speed,
-				      int duplex, bool tx_pause, bool rx_pause)
+				      int duplex, bool tx_pause, bool rx_pause,
+				      bool eee_active)
 {
 	u32 cmd_cfg = A5PSW_CMD_CFG_RX_ENA | A5PSW_CMD_CFG_TX_ENA |
 		      A5PSW_CMD_CFG_TX_CRC_APPEND;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b70dcf32a26d..5475e81a4f4c 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1380,7 +1380,8 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 				phy_interface_t interface,
 				struct phy_device *phydev,
 				int speed, int duplex,
-				bool tx_pause, bool rx_pause)
+				bool tx_pause, bool rx_pause,
+				bool eee_active)
 {
 	struct sja1105_private *priv = ds->priv;
 
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index fa622639d640..f6ca6360b517 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -470,7 +470,8 @@ static void xrs700x_mac_link_up(struct dsa_switch *ds, int port,
 				unsigned int mode, phy_interface_t interface,
 				struct phy_device *phydev,
 				int speed, int duplex,
-				bool tx_pause, bool rx_pause)
+				bool tx_pause, bool rx_pause,
+				bool eee_active)
 {
 	struct xrs700x *priv = ds->priv;
 	unsigned int val;
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 66e3af73ec41..cbd8c067163a 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1060,7 +1060,8 @@ static void alt_tse_mac_link_down(struct phylink_config *config,
 static void alt_tse_mac_link_up(struct phylink_config *config,
 				struct phy_device *phy, unsigned int mode,
 				phy_interface_t interface, int speed,
-				int duplex, bool tx_pause, bool rx_pause)
+				int duplex, bool tx_pause, bool rx_pause,
+				bool eee_active)
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct altera_tse_private *priv = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index ff1a5edf8df1..0e077342dc0e 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1036,7 +1036,8 @@ static void ag71xx_mac_link_up(struct phylink_config *config,
 			       struct phy_device *phy,
 			       unsigned int mode, phy_interface_t interface,
 			       int speed, int duplex,
-			       bool tx_pause, bool rx_pause)
+			       bool tx_pause, bool rx_pause,
+			       bool eee_active)
 {
 	struct ag71xx *ag = netdev_priv(to_net_dev(config->dev));
 	u32 cfg1, cfg2;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index f77bd1223c8f..26e53125fb78 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -719,7 +719,8 @@ static void macb_mac_link_up(struct phylink_config *config,
 			     struct phy_device *phy,
 			     unsigned int mode, phy_interface_t interface,
 			     int speed, int duplex,
-			     bool tx_pause, bool rx_pause)
+			     bool tx_pause, bool rx_pause,
+			     bool eee_active)
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct macb *bp = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index b1871e6c4006..8451fa6fb011 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -189,7 +189,8 @@ static void dpaa2_mac_link_up(struct phylink_config *config,
 			      struct phy_device *phy,
 			      unsigned int mode, phy_interface_t interface,
 			      int speed, int duplex,
-			      bool tx_pause, bool rx_pause)
+			      bool tx_pause, bool rx_pause,
+			      bool eee_active)
 {
 	struct dpaa2_mac *mac = phylink_to_dpaa2_mac(config);
 	struct dpmac_link_state *dpmac_state = &mac->state;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 7cd22d370caa..7defd16c84dc 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1017,7 +1017,8 @@ static void enetc_force_rgmii_mac(struct enetc_si *si, int speed, int duplex)
 static void enetc_pl_mac_link_up(struct phylink_config *config,
 				 struct phy_device *phy, unsigned int mode,
 				 phy_interface_t interface, int speed,
-				 int duplex, bool tx_pause, bool rx_pause)
+				 int duplex, bool tx_pause, bool rx_pause,
+				 bool eee_active)
 {
 	struct enetc_pf *pf = phylink_to_enetc_pf(config);
 	u32 pause_off_thresh = 0, pause_on_thresh = 0;
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index d528ca681b6f..89510aed4aad 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -928,7 +928,8 @@ static void dtsec_mac_config(struct phylink_config *config, unsigned int mode,
 
 static void dtsec_link_up(struct phylink_config *config, struct phy_device *phy,
 			  unsigned int mode, phy_interface_t interface,
-			  int speed, int duplex, bool tx_pause, bool rx_pause)
+			  int speed, int duplex, bool tx_pause, bool rx_pause,
+			  bool eee_active)
 {
 	struct mac_device *mac_dev = fman_config_to_mac(config);
 	struct fman_mac *dtsec = mac_dev->fman_mac;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 625c79d5636f..f247d205da4f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -712,7 +712,8 @@ static void memac_mac_config(struct phylink_config *config, unsigned int mode,
 
 static void memac_link_up(struct phylink_config *config, struct phy_device *phy,
 			  unsigned int mode, phy_interface_t interface,
-			  int speed, int duplex, bool tx_pause, bool rx_pause)
+			  int speed, int duplex, bool tx_pause, bool rx_pause,
+			  bool eee_active)
 {
 	struct mac_device *mac_dev = fman_config_to_mac(config);
 	struct fman_mac *memac = mac_dev->fman_mac;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index c2261d26db5b..a8655d155382 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -438,7 +438,8 @@ static void tgec_mac_config(struct phylink_config *config, unsigned int mode,
 
 static void tgec_link_up(struct phylink_config *config, struct phy_device *phy,
 			 unsigned int mode, phy_interface_t interface,
-			 int speed, int duplex, bool tx_pause, bool rx_pause)
+			 int speed, int duplex, bool tx_pause, bool rx_pause,
+			 bool eee_active)
 {
 	struct mac_device *mac_dev = fman_config_to_mac(config);
 	struct fman_mac *tgec = mac_dev->fman_mac;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0e39d199ff06..cebd3848a228 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4178,7 +4178,8 @@ static void mvneta_mac_link_up(struct phylink_config *config,
 			       struct phy_device *phy,
 			       unsigned int mode, phy_interface_t interface,
 			       int speed, int duplex,
-			       bool tx_pause, bool rx_pause)
+			       bool tx_pause, bool rx_pause,
+			       bool eee_active)
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct mvneta_port *pp = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index adc953611913..860f43e8c4e4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6517,7 +6517,8 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
 			      struct phy_device *phy,
 			      unsigned int mode, phy_interface_t interface,
 			      int speed, int duplex,
-			      bool tx_pause, bool rx_pause)
+			      bool tx_pause, bool rx_pause,
+			      bool eee_active)
 {
 	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 	u32 val;
@@ -6655,7 +6656,7 @@ static void mvpp2_acpi_start(struct mvpp2_port *port)
 			 port->phy_interface);
 	mvpp2_mac_link_up(&port->phylink_config, NULL,
 			  MLO_AN_INBAND, port->phy_interface,
-			  SPEED_UNKNOWN, DUPLEX_UNKNOWN, false, false);
+			  SPEED_UNKNOWN, DUPLEX_UNKNOWN, false, false, false);
 }
 
 /* In order to ensure backward compatibility for ACPI, check if the port
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 9d504142e51a..5f5bc3bac4c7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -265,7 +265,8 @@ static void prestera_mac_link_up(struct phylink_config *config,
 				 struct phy_device *phy,
 				 unsigned int mode, phy_interface_t interface,
 				 int speed, int duplex,
-				 bool tx_pause, bool rx_pause)
+				 bool tx_pause, bool rx_pause,
+				 bool eee_active)
 {
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 4403d3bbfd4d..9f25aac84703 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -717,7 +717,8 @@ static void mtk_set_queue_speed(struct mtk_eth *eth, unsigned int idx,
 static void mtk_mac_link_up(struct phylink_config *config,
 			    struct phy_device *phy,
 			    unsigned int mode, phy_interface_t interface,
-			    int speed, int duplex, bool tx_pause, bool rx_pause)
+			    int speed, int duplex, bool tx_pause, bool rx_pause,
+			    bool eee_active)
 {
 	struct mtk_mac *mac = container_of(config, struct mtk_mac,
 					   phylink_config);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
index c5f9803e6e63..01188b6870f8 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
@@ -48,7 +48,8 @@ static void lan966x_phylink_mac_link_up(struct phylink_config *config,
 					unsigned int mode,
 					phy_interface_t interface,
 					int speed, int duplex,
-					bool tx_pause, bool rx_pause)
+					bool tx_pause, bool rx_pause,
+					bool eee_active)
 {
 	struct lan966x_port *port = netdev_priv(to_net_dev(config->dev));
 	struct lan966x_port_config *port_config = &port->config;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
index bb97d27a1da4..e5895be3d722 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
@@ -47,7 +47,8 @@ static void sparx5_phylink_mac_link_up(struct phylink_config *config,
 				       unsigned int mode,
 				       phy_interface_t interface,
 				       int speed, int duplex,
-				       bool tx_pause, bool rx_pause)
+				       bool tx_pause, bool rx_pause,
+				       bool eee_active)
 {
 	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
 	struct sparx5_port_config conf;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 21a87a3fc556..574c147009b1 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1699,7 +1699,8 @@ static void vsc7514_phylink_mac_link_up(struct phylink_config *config,
 					unsigned int link_an_mode,
 					phy_interface_t interface,
 					int speed, int duplex,
-					bool tx_pause, bool rx_pause)
+					bool tx_pause, bool rx_pause,
+					bool eee_active)
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct ocelot_port_private *priv = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 17310ade88dd..c76160b0e635 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -983,7 +983,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 			       struct phy_device *phy,
 			       unsigned int mode, phy_interface_t interface,
 			       int speed, int duplex,
-			       bool tx_pause, bool rx_pause)
+			       bool tx_pause, bool rx_pause,
+			       bool eee_active)
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 	u32 old_ctrl, ctrl;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 9ddb79776c88..f154bbed7af6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1534,7 +1534,8 @@ static void am65_cpsw_nuss_mac_link_down(struct phylink_config *config, unsigned
 
 static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy_device *phy,
 				       unsigned int mode, phy_interface_t interface, int speed,
-				       int duplex, bool tx_pause, bool rx_pause)
+				       int duplex, bool tx_pause, bool rx_pause,
+				       bool eee_active)
 {
 	struct am65_cpsw_slave_data *slave = container_of(config, struct am65_cpsw_slave_data,
 							  phylink_config);
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3e310b55bce2..59e4d70f53d1 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1696,7 +1696,8 @@ static void axienet_mac_link_up(struct phylink_config *config,
 				struct phy_device *phy,
 				unsigned int mode, phy_interface_t interface,
 				int speed, int duplex,
-				bool tx_pause, bool rx_pause)
+				bool tx_pause, bool rx_pause,
+				bool eee_active)
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct axienet_local *lp = netdev_priv(ndev);
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index a64186dc53f8..3680f845e43e 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -76,6 +76,17 @@ const char *phy_duplex_to_str(unsigned int duplex)
 }
 EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 
+/**
+ * phy_eee_active_to_str - Return string describing eee_active
+ *
+ * @eee_active: EEE active setting to describe
+ */
+const char *phy_eee_active_to_str(bool eee_active)
+{
+	return (eee_active ? "EEE Active" : "EEE Inactive");
+}
+EXPORT_SYMBOL_GPL(phy_eee_active_to_str);
+
 /**
  * phy_rate_matching_to_str - Return a string describing the rate matching
  *
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f7da96f0c75b..2d1e1cda9f42 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1142,6 +1142,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 		state->speed = SPEED_UNKNOWN;
 		state->duplex = DUPLEX_UNKNOWN;
 		state->pause = MLO_PAUSE_NONE;
+		state->eee_active = false;
 	} else {
 		state->speed =  pl->link_config.speed;
 		state->duplex = pl->link_config.duplex;
@@ -1223,10 +1224,12 @@ static void phylink_link_up(struct phylink *pl,
 	struct net_device *ndev = pl->netdev;
 	int speed, duplex;
 	bool rx_pause;
+	bool eee_active;
 
 	speed = link_state.speed;
 	duplex = link_state.duplex;
 	rx_pause = !!(link_state.pause & MLO_PAUSE_RX);
+	eee_active = link_state.eee_active;
 
 	switch (link_state.rate_matching) {
 	case RATE_MATCH_PAUSE:
@@ -1257,7 +1260,8 @@ static void phylink_link_up(struct phylink *pl,
 
 	pl->mac_ops->mac_link_up(pl->config, pl->phydev, pl->cur_link_an_mode,
 				 pl->cur_interface, speed, duplex,
-				 !!(link_state.pause & MLO_PAUSE_TX), rx_pause);
+				 !!(link_state.pause & MLO_PAUSE_TX), rx_pause,
+				 eee_active);
 
 	if (ndev)
 		netif_carrier_on(ndev);
@@ -1529,6 +1533,7 @@ struct phylink *phylink_create(struct phylink_config *config,
 	pl->link_config.pause = MLO_PAUSE_AN;
 	pl->link_config.speed = SPEED_UNKNOWN;
 	pl->link_config.duplex = DUPLEX_UNKNOWN;
+	pl->link_config.eee_active = false;
 	pl->mac_ops = mac_ops;
 	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
 	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
@@ -1593,6 +1598,7 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 	mutex_lock(&pl->state_mutex);
 	pl->phy_state.speed = phydev->speed;
 	pl->phy_state.duplex = phydev->duplex;
+	pl->phy_state.eee_active = phydev->eee_active;
 	pl->phy_state.rate_matching = phydev->rate_matching;
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	if (tx_pause)
@@ -1605,12 +1611,13 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
 
 	phylink_run_resolve(pl);
 
-	phylink_dbg(pl, "phy link %s %s/%s/%s/%s/%s\n", up ? "up" : "down",
+	phylink_dbg(pl, "phy link %s %s/%s/%s/%s/%s/%s\n", up ? "up" : "down",
 		    phy_modes(phydev->interface),
 		    phy_speed_to_str(phydev->speed),
 		    phy_duplex_to_str(phydev->duplex),
 		    phy_rate_matching_to_str(phydev->rate_matching),
-		    phylink_pause_to_str(pl->phy_state.pause));
+		    phylink_pause_to_str(pl->phy_state.pause),
+		    phy_eee_active_to_str(phydev->eee_active));
 }
 
 static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
@@ -1684,6 +1691,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	pl->phy_state.pause = MLO_PAUSE_NONE;
 	pl->phy_state.speed = SPEED_UNKNOWN;
 	pl->phy_state.duplex = DUPLEX_UNKNOWN;
+	pl->phy_state.eee_active = false;
 	pl->phy_state.rate_matching = RATE_MATCH_NONE;
 	linkmode_copy(pl->supported, supported);
 	linkmode_copy(pl->link_config.advertising, config.advertising);
@@ -2929,6 +2937,7 @@ static int phylink_sfp_config_phy(struct phylink *pl, u8 mode,
 	config.interface = PHY_INTERFACE_MODE_NA;
 	config.speed = SPEED_UNKNOWN;
 	config.duplex = DUPLEX_UNKNOWN;
+	config.eee_active = false;
 	config.pause = MLO_PAUSE_AN;
 
 	/* Ignore errors if we're expecting a PHY to attach later */
@@ -2997,6 +3006,7 @@ static int phylink_sfp_config_optical(struct phylink *pl)
 	linkmode_copy(config.advertising, pl->sfp_support);
 	config.speed = SPEED_UNKNOWN;
 	config.duplex = DUPLEX_UNKNOWN;
+	config.eee_active = false;
 	config.pause = MLO_PAUSE_AN;
 
 	/* For all the interfaces that are supported, reduce the sfp_support
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index f7cff58fe044..0c1e54c41f3a 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -759,7 +759,7 @@ static void ax88772_mac_link_up(struct phylink_config *config,
 			       struct phy_device *phy,
 			       unsigned int mode, phy_interface_t interface,
 			       int speed, int duplex,
-			       bool tx_pause, bool rx_pause)
+			       bool tx_pause, bool rx_pause, bool eee_active)
 {
 	struct usbnet *dev = netdev_priv(to_net_dev(config->dev));
 	u16 m = AX_MEDIUM_AC | AX_MEDIUM_RE;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5cc2dcb17eb0..2508f1d99777 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1080,6 +1080,7 @@ struct phy_fixup {
 
 const char *phy_speed_to_str(int speed);
 const char *phy_duplex_to_str(unsigned int duplex);
+const char *phy_eee_active_to_str(bool eee_active);
 const char *phy_rate_matching_to_str(int rate_matching);
 
 int phy_interface_num_ports(phy_interface_t interface);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 9ff56b050584..ef09b3b7e471 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -88,6 +88,7 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
  * @speed: link speed, one of the SPEED_* constants.
  * @duplex: link duplex mode, one of DUPLEX_* constants.
  * @pause: link pause state, described by MLO_PAUSE_* constants.
+ * @eee_active: true if EEE should be active
  * @rate_matching: rate matching being performed, one of the RATE_MATCH_*
  *   constants. If rate matching is taking place, then the speed/duplex of
  *   the medium link mode (@speed and @duplex) and the speed/duplex of the phy
@@ -105,6 +106,7 @@ struct phylink_link_state {
 	int rate_matching;
 	unsigned int link:1;
 	unsigned int an_complete:1;
+	unsigned int eee_active:1;
 };
 
 enum phylink_op_type {
@@ -175,7 +177,7 @@ struct phylink_mac_ops {
 	void (*mac_link_up)(struct phylink_config *config,
 			    struct phy_device *phy, unsigned int mode,
 			    phy_interface_t interface, int speed, int duplex,
-			    bool tx_pause, bool rx_pause);
+			    bool tx_pause, bool rx_pause, bool eee_active);
 };
 
 #if 0 /* For kernel-doc purposes only. */
@@ -408,27 +410,28 @@ void mac_link_down(struct phylink_config *config, unsigned int mode,
  * @duplex: link duplex
  * @tx_pause: link transmit pause enablement status
  * @rx_pause: link receive pause enablement status
+ * @eee_active: EEE should be enabled
  *
  * Configure the MAC for an established link.
  *
- * @speed, @duplex, @tx_pause and @rx_pause indicate the finalised link
- * settings, and should be used to configure the MAC block appropriately
- * where these settings are not automatically conveyed from the PCS block,
- * or if in-band negotiation (as defined by phylink_autoneg_inband(@mode))
- * is disabled.
+ * @speed, @duplex, @tx_pause, @rx_pause and @eee_active indicate the
+ * finalised link settings, and should be used to configure the MAC block
+ * appropriately where these settings are not automatically conveyed from
+ * the PCS block, or if in-band negotiation (as defined by
+ * phylink_autoneg_inband(@mode)) is disabled.
  *
  * Note that when 802.3z in-band negotiation is in use, it is possible
  * that the user wishes to override the pause settings, and this should
  * be allowed when considering the implementation of this method.
  *
  * If in-band negotiation mode is disabled, allow the link to come up. If
- * @phy is non-%NULL, configure Energy Efficient Ethernet by calling
- * phy_init_eee() and perform appropriate MAC configuration for EEE.
+ * eee_active is true enable the LPI timer for Energy Efficient Ethernet.
  * Interface type selection must be done in mac_config().
  */
 void mac_link_up(struct phylink_config *config, struct phy_device *phy,
 		 unsigned int mode, phy_interface_t interface,
-		 int speed, int duplex, bool tx_pause, bool rx_pause);
+		 int speed, int duplex, bool tx_pause, bool rx_pause,
+	         bool eee_active);
 #endif
 
 struct phylink_pcs_ops;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index a15f17a38eca..a680ecb66ad9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -894,7 +894,8 @@ struct dsa_switch_ops {
 				       phy_interface_t interface,
 				       struct phy_device *phydev,
 				       int speed, int duplex,
-				       bool tx_pause, bool rx_pause);
+				       bool tx_pause, bool rx_pause,
+				       bool eee_active);
 	void	(*phylink_fixed_state)(struct dsa_switch *ds, int port,
 				       struct phylink_link_state *state);
 	/*
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 67ad1adec2a2..44c923b568ed 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1650,7 +1650,8 @@ static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
 					 unsigned int mode,
 					 phy_interface_t interface,
 					 int speed, int duplex,
-					 bool tx_pause, bool rx_pause)
+					 bool tx_pause, bool rx_pause,
+					 bool eee_active)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
@@ -1662,7 +1663,8 @@ static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
 	}
 
 	ds->ops->phylink_mac_link_up(ds, dp->index, mode, interface, phydev,
-				     speed, duplex, tx_pause, rx_pause);
+				     speed, duplex, tx_pause, rx_pause,
+				     eee_active);
 }
 
 static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
-- 
2.39.2

