Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB81225AC0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 11:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgGTJEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 05:04:23 -0400
Received: from mail.intenta.de ([178.249.25.132]:33123 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgGTJEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 05:04:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=ycCNQg06vjohcFdPdPMsQrPyMiY2v4ZEa75YpIy6dYo=;
        b=GjRLiTzT9vAMQm6ZslnY5lMfueOFwykIpWs3eheHjf86Hy1JX/rAi3bB2vujj8U8gczkGEWbPfVkjB3X5+qxtrPUH1SXlnxZqglPvpN0dr5KveDUQ5/3A73te0CEk0nBp7Bxmu+KQsiXOGcpQ2Ej34g3sy+N8k9IJVANK4VAeU/zsDWULKGejnJwTuVvRrJ36HFWthL6UWcr5rDTojLg7lblf4uibyQMfp/pYJVT7AgWQF1KSQB+lTxkyc7CkUP1ONtmBlylTPlYPieqc3K1aICNgLXhYVQ7bwDdr/WzZ0L6vdVsZnYsDs3JZRJdIbzPVxLUCTqQMrQCfdUST1R1KA==;
Date:   Mon, 20 Jul 2020 11:04:18 +0200
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
Subject: [PATCH v3] net: dsa: microchip: call phy_remove_link_mode during
 probe
Message-ID: <20200720090416.GA7307@laureti-dev>
References: <20200717131814.GA1336433@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200717131814.GA1336433@lunn.ch>
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
 drivers/net/dsa/microchip/ksz9477.c    | 39 +++++++++++++-------------
 drivers/net/dsa/microchip/ksz_common.c |  2 --
 drivers/net/dsa/microchip/ksz_common.h |  2 --
 3 files changed, 20 insertions(+), 23 deletions(-)

On Fri, Jul 17, 2020 at 03:18:14PM +0200, Andrew Lunn wrote:
> I'm not questioning the ordering. I'm questioning which phydev
> structure is being manipulated.
...
> Is slave_dev->phydev == &dev->ports[i].phydev ?

You are spot on. I mistakenly assumed this to be the case, but it really
is not. Thank you. Your detailed explanations are much appreciated. This
slipped my testing, because I only checked whether the 1Gbit HDX mode
was correctly removed. It seems like something else does that already,
so I didn't notice that I was operating on the wrong phy_device.

The dev->ports[i].phydev is not actually exposed beyond the driver. The
driver sets the phydev.speed in a few places and even reads it back in
one place. It also sets phydev.duplex, but never reads it back. It
queries phydev.link, which is statically 0 due to using devm_kzalloc.

I think the use of this ksz_port.phydev is very misleading, but I'm
unsure how to fix this. It is not clear to me whether all those updates
should be performed on the connected phydev instead or whether this is
just internal state tracking.

That leaves the question of when to remove the link modes. ksz9477_setup
is called before dsa_register_switch. At the time it runs, the port's
slave device is a NULL pointer. The actual phydev is not linked up and
we cannot access it. The phydev only gets initialized during
dsa_register_switch when dsa_slave_phy_connect is called. Since there is
no suitable hook there, we cannot change the link modes before
phylink_connect_phy is called.

As far as I understand your previous mails, it is not necessary to
remove the link modes before phylink_connect_phy. So the next place
after dsa_register_switch seems to be inside ksz9477_switch_register (as
dsa_register_switch is the final call in ksz_switch_register). I'm
unsure whether this poses a race condition with user space, but on the
system under test, the race is reliably won if there is any.

Beyond resolving the phydev mess, I wish that we could agree on the
order of verbs and nouns in symbols in some way. dsa_register_switch vs.
ksz_switch_register became confusing at a time. I see where either is
coming from, but I think that consistency would be better here.

Helmut

changes since v2:
 * Operate on the correct phydev. Thanks to Andrew Lunn.
changes since v1:
 * Don't change phy_remove_link_mode. Instead, call it at the right
   time. Thanks to Andrew Lunn for the detailed explanation.

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 8d15c3016024..368964b09aae 100644
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
@@ -1617,7 +1599,26 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 
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

