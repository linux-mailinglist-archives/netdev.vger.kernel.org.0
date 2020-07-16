Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E038D222320
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 14:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgGPM5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 08:57:32 -0400
Received: from mail.intenta.de ([178.249.25.132]:25402 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbgGPM5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 08:57:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=gudRPqr44+yWiceu3720gjTJW9r40JZdwXJJJsQgkYI=;
        b=u7MuXtIFS3AygaKkSSliNwDsHCKQRSQqqpMtGRFeEMe5+1ILpQuRLI0rwuNaq4kfyP1JXkmzuQhYbgsoJTDTO5e8TsDqwKpEHs1dJhLJHrJXnje9kJ6K0/lV0CMetsxxN7igqojADmADn2xaL9af9e8XOFOnf0xztytBOcxjc15OsDD/Y7DxsN1jbJuwPpbHIHEB1eMRXT2nZ5N0FPU5wHy7XltNKo3yRJSoL6zKhEawUe73VCnKaiK483DHJ0kxjBr7asGpN7l5TveB4PpDLOyG0yLYr/7p+9H10kAchnUBEyNneiVa2AYiE/pQ4Lu71rZmg0NTnDYIPyGj4kMzwA==;
Date:   Thu, 16 Jul 2020 14:57:24 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: [PATCH v2] net: dsa: microchip: call phy_remove_link_mode during
 probe
Message-ID: <20200716125723.GA19500@laureti-dev>
References: <20200715192722.GD1256692@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200715192722.GD1256692@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing "ip link set dev ... up" for a ksz9477 backed link,
ksz9477_phy_setup is called and it calls phy_remove_link_mode to remove
1000baseT HDX. During phy_remove_link_mode, phy_advertise_supported is
called. Doing so reverts any previous change to advertised link modes
e.g. using a udevd .link file.

phy_remove_link_mode is not meant to be used while opening a link and
should be called during phy probe when the link is not yet available to
userspace.

Therefore move the phy_remove_link_mode calls into ksz9477_setup. This
is called during dsa_switch_register and thus comes after
ksz9477_switch_detect, which initializes dev->features.

Remove phy_setup from ksz_dev_ops as no users remain.

Link: https://lore.kernel.org/netdev/20200715192722.GD1256692@lunn.ch/
Fixes: 42fc6a4c613019 ("net: dsa: microchip: prepare PHY for proper advertisement")
Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
---
 drivers/net/dsa/microchip/ksz9477.c    | 31 ++++++++++----------------
 drivers/net/dsa/microchip/ksz_common.c |  2 --
 drivers/net/dsa/microchip/ksz_common.h |  2 --
 3 files changed, 12 insertions(+), 23 deletions(-)

changes since v1:
 * Don't change phy_remove_link_mode. Instead, call it at the right
   time. Thanks to Andrew Lunn for the detailed explanation.

Helmut

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 8d15c3016024..d0023916e1e8 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -974,23 +974,6 @@ static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
 			     PORT_MIRROR_SNIFFER, false);
 }
 
-static void ksz9477_phy_setup(struct ksz_device *dev, int port,
-			      struct phy_device *phy)
-{
-	/* Only apply to port with PHY. */
-	if (port >= dev->phy_port_cnt)
-		return;
-
-	/* The MAC actually cannot run in 1000 half-duplex mode. */
-	phy_remove_link_mode(phy,
-			     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-
-	/* PHY does not support gigabit. */
-	if (!(dev->features & GBIT_SUPPORT))
-		phy_remove_link_mode(phy,
-				     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
-}
-
 static bool ksz9477_get_gbit(struct ksz_device *dev, u8 data)
 {
 	bool gbit;
@@ -1353,7 +1336,7 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 static int ksz9477_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-	int ret = 0;
+	int ret = 0, i;
 
 	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
 				       dev->num_vlans, GFP_KERNEL);
@@ -1391,6 +1374,17 @@ static int ksz9477_setup(struct dsa_switch *ds)
 
 	ksz_init_mib_timer(dev);
 
+	for (i = 0; i < dev->phy_port_cnt; ++i) {
+		/* The MAC actually cannot run in 1000 half-duplex mode. */
+		phy_remove_link_mode(&dev->ports[i].phydev,
+				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+
+		/* PHY does not support gigabit. */
+		if (!(dev->features & GBIT_SUPPORT))
+			phy_remove_link_mode(&dev->ports[i].phydev,
+					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
+	}
+
 	return 0;
 }
 
@@ -1603,7 +1597,6 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.get_port_addr = ksz9477_get_port_addr,
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
-	.phy_setup = ksz9477_phy_setup,
 	.port_setup = ksz9477_port_setup,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
 	.r_mib_pkt = ksz9477_r_mib_pkt,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fd1d6676ae4f..7b6c0dce7536 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -358,8 +358,6 @@ int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 
 	/* setup slave port */
 	dev->dev_ops->port_setup(dev, port, false);
-	if (dev->dev_ops->phy_setup)
-		dev->dev_ops->phy_setup(dev, port, phy);
 
 	/* port_stp_state_set() will be called after to enable the port so
 	 * there is no need to do anything.
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f2c9bb68fd33..7d11dd32ec0d 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -119,8 +119,6 @@ struct ksz_dev_ops {
 	u32 (*get_port_addr)(int port, int offset);
 	void (*cfg_port_member)(struct ksz_device *dev, int port, u8 member);
 	void (*flush_dyn_mac_table)(struct ksz_device *dev, int port);
-	void (*phy_setup)(struct ksz_device *dev, int port,
-			  struct phy_device *phy);
 	void (*port_cleanup)(struct ksz_device *dev, int port);
 	void (*port_setup)(struct ksz_device *dev, int port, bool cpu_port);
 	void (*r_phy)(struct ksz_device *dev, u16 phy, u16 reg, u16 *val);
-- 
2.20.1

