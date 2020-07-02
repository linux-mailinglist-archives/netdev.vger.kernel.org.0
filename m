Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08528212065
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgGBJyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:54:47 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:15418 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGBJyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:54:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593683686; x=1625219686;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9IjoSkf5FlBdrlrUXBybJL2LYBcavielxSsZqZ0vPQ4=;
  b=AwYAUuX7nB+0wrWNKfg9jmmKH+Mo4bnT9wKMteyR/XOX4bBvvV0Di2CA
   SIPR2FcqRRpYJQ3lNv9cZRXv7LGwpdatKJIOpjGzIbCAzN6bZZsYrNjXl
   AY7XPHgr8dHcN6mXpzjxJlTdB1m3Y7bH3NL4nHG3yVd2FI9GAvzXzkZab
   HSGxrtWUG0s58FVDM6yk4OSMRgtOwtCZlwnnkrnfvPGcLAtzEN0s5po27
   FUw7LoENbwiLm/CPhlOCEF0mA8geezyLEYFDCPevDL1wNz3J9wlZsxWmD
   6pBX2iMdAd7ZLMtAHq/XK/UzkTRTTMNalNkuFb4nyoSGOBkm2TZRb41no
   w==;
IronPort-SDR: jZxZUAxCPSUboRxagsqrGuCBYm9ScyElZLAYz5WefOGn4rdUAsaqmV7xyZyVeTo8O+EGXPTk9o
 1ofzar0feEsa1OiBpQ4nP6/h+LoQwxAlfFPEls67/8UBTOg8OCc7nn3B9Yl6MjyqVr6kKOpaeV
 9qiqReRv6wqLi2ZORdG/DKejPzvm/slgYREVNRIVcIGj3BuORzx30CFNVJRcigv5XrpO6cEFyi
 0VFC5ixak7h24ZDWdoOfMlCgtqzEw9bpBQPTEJlD1bORhReLMRk8/5IgarsnQHHhJZkU2C2rqI
 VR4=
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="80480922"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 02:54:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 02:54:26 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 02:54:41 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next] net: dsa: microchip: split adjust_link() in phylink_mac_link_{up|down}()
Date:   Thu, 2 Jul 2020 12:54:39 +0300
Message-ID: <20200702095439.1355119-1-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA subsystem moved to phylink and adjust_link() became deprecated in
the process. This patch removes adjust_link from the KSZ DSA switches and
adds phylink_mac_link_up() and phylink_mac_link_down().

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    |  3 ++-
 drivers/net/dsa/microchip/ksz9477.c    |  3 ++-
 drivers/net/dsa/microchip/ksz_common.c | 32 ++++++++++++++++----------
 drivers/net/dsa/microchip/ksz_common.h |  7 ++++--
 4 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 47d65b77caf7..862306a9db2c 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1111,7 +1111,8 @@ static const struct dsa_switch_ops ksz8795_switch_ops = {
 	.setup			= ksz8795_setup,
 	.phy_read		= ksz_phy_read16,
 	.phy_write		= ksz_phy_write16,
-	.adjust_link		= ksz_adjust_link,
+	.phylink_mac_link_down	= ksz_mac_link_down,
+	.phylink_mac_link_up	= ksz_mac_link_up,
 	.port_enable		= ksz_enable_port,
 	.port_disable		= ksz_disable_port,
 	.get_strings		= ksz8795_get_strings,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 9a51b8a4de5d..9e4bdd950194 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1399,7 +1399,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.setup			= ksz9477_setup,
 	.phy_read		= ksz9477_phy_read16,
 	.phy_write		= ksz9477_phy_write16,
-	.adjust_link		= ksz_adjust_link,
+	.phylink_mac_link_down	= ksz_mac_link_down,
+	.phylink_mac_link_up	= ksz_mac_link_up,
 	.port_enable		= ksz_enable_port,
 	.port_disable		= ksz_disable_port,
 	.get_strings		= ksz9477_get_strings,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fd1d6676ae4f..55ceaf00ece1 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -135,26 +135,34 @@ int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val)
 }
 EXPORT_SYMBOL_GPL(ksz_phy_write16);
 
-void ksz_adjust_link(struct dsa_switch *ds, int port,
-		     struct phy_device *phydev)
+void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+		       phy_interface_t interface)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p = &dev->ports[port];
 
 	/* Read all MIB counters when the link is going down. */
-	if (!phydev->link) {
-		p->read = true;
-		schedule_delayed_work(&dev->mib_read, 0);
-	}
+	p->read = true;
+	schedule_delayed_work(&dev->mib_read, 0);
+
+	mutex_lock(&dev->dev_mutex);
+	dev->live_ports &= ~(1 << port);
+	mutex_unlock(&dev->dev_mutex);
+}
+EXPORT_SYMBOL_GPL(ksz_mac_link_down);
+
+void ksz_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+		     phy_interface_t interface, struct phy_device *phydev,
+		     int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+	struct ksz_device *dev = ds->priv;
+
+	/* Remember which port is connected and active. */
 	mutex_lock(&dev->dev_mutex);
-	if (!phydev->link)
-		dev->live_ports &= ~(1 << port);
-	else
-		/* Remember which port is connected and active. */
-		dev->live_ports |= (1 << port) & dev->on_ports;
+	dev->live_ports |= (1 << port) & dev->on_ports;
 	mutex_unlock(&dev->dev_mutex);
 }
-EXPORT_SYMBOL_GPL(ksz_adjust_link);
+EXPORT_SYMBOL_GPL(ksz_mac_link_up);
 
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f2c9bb68fd33..c0224dd0cf8a 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -159,8 +159,11 @@ void ksz_init_mib_timer(struct ksz_device *dev);
 
 int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg);
 int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val);
-void ksz_adjust_link(struct dsa_switch *ds, int port,
-		     struct phy_device *phydev);
+void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+		       phy_interface_t interface);
+void ksz_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+		     phy_interface_t interface, struct phy_device *phydev,
+		     int speed, int duplex, bool tx_pause, bool rx_pause);
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-- 
2.25.1

