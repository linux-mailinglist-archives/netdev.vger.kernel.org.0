Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDB1227E2C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbgGULHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:07:46 -0400
Received: from mail.intenta.de ([178.249.25.132]:37091 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbgGULHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 07:07:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=RXWv3n/+zVoW76R+V1N0dGmKgoJJ7z1wcx1OeZynMxo=;
        b=A6J0TFZ8MFH4j8Ws6C3Ey1jlKQSn1vOQlQMEpDE6gw0l//2zfVgAX5I5n6iAEN2X8zaiBd3jS9IcCSH974E0jqIbbhsRzUq8k2f8B/8flk5BN5gD2ZimZViu/d1k/dVLttTVxC959gcTAU1yorN5j8W5+eA5DEDJQ9y8dHHMijd04WDUx9O/SYrGquG5ZfgWTufPdjXk6kv15W8v74pTQRBCrioRdXR4gg77/1arwrI2SuFRLMP1jR+t2MJAXUc4q3n4QmNf0fl7VKatf+103gYGCCmWgHrf7gs/d9CXw8RxnW8SOpy+X0ZQDvpJvB4IBy+llu0/5OyH90rqpkJONQ==;
Date:   Tue, 21 Jul 2020 13:07:39 +0200
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
Subject: [PATCH v4] net: dsa: microchip: call phy_remove_link_mode during
 probe
Message-ID: <20200721110738.GA9008@laureti-dev>
References: <20200720204353.GO1339445@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200720204353.GO1339445@lunn.ch>
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

Therefore move the phy_remove_link_mode calls into
ksz9477_switch_register. It indirectly calls dsa_register_switch, which
creates the relevant struct phy_devices and we update the link modes
right after that. At that time dev->features is already initialized by
ksz9477_switch_detect.

Remove phy_setup from ksz_dev_ops as no users remain.

Link: https://lore.kernel.org/netdev/20200715192722.GD1256692@lunn.ch/
Fixes: 42fc6a4c613019 ("net: dsa: microchip: prepare PHY for proper advertisement")
Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
---
 drivers/net/dsa/microchip/ksz9477.c    | 42 ++++++++++++++------------
 drivers/net/dsa/microchip/ksz_common.c |  2 --
 drivers/net/dsa/microchip/ksz_common.h |  2 --
 3 files changed, 23 insertions(+), 23 deletions(-)

As Andrew Lunn indicated, my patch introduces a null pointer dereference
when PHYs are missing from the device tree. I was able to reproduce the
failure mode and this version fixes it.

Helmut

changes since v3:
 * Check dsa_is_user_port. Thanks to Andrew Lunn.
changes since v2:
 * Operate on the correct phydev. Thanks to Andrew Lunn.
changes since v1:
 * Don't change phy_remove_link_mode. Instead, call it at the right
   time. Thanks to Andrew Lunn for the detailed explanation.

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 8d15c3016024..4a9239b2c2e4 100644
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
@@ -1603,7 +1586,6 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.get_port_addr = ksz9477_get_port_addr,
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
-	.phy_setup = ksz9477_phy_setup,
 	.port_setup = ksz9477_port_setup,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
 	.r_mib_pkt = ksz9477_r_mib_pkt,
@@ -1617,7 +1599,29 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 
 int ksz9477_switch_register(struct ksz_device *dev)
 {
-	return ksz_switch_register(dev, &ksz9477_dev_ops);
+	int ret, i;
+	struct phy_device *phydev;
+
+	ret = ksz_switch_register(dev, &ksz9477_dev_ops);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < dev->phy_port_cnt; ++i) {
+		if (!dsa_is_user_port(dev->ds, i))
+			continue;
+
+		phydev = dsa_to_port(dev->ds, i)->slave->phydev;
+
+		/* The MAC actually cannot run in 1000 half-duplex mode. */
+		phy_remove_link_mode(phydev,
+				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+
+		/* PHY does not support gigabit. */
+		if (!(dev->features & GBIT_SUPPORT))
+			phy_remove_link_mode(phydev,
+					     ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
+	}
+	return ret;
 }
 EXPORT_SYMBOL(ksz9477_switch_register);
 
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

