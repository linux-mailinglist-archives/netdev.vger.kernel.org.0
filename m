Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7049B21111E
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732584AbgGAQvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:51:41 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:59557 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732578AbgGAQvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593622299; x=1625158299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KtFvv4njZRd4RUyqHqCrtp8f+r4C5L+zEXOcmypW9aY=;
  b=hjQlQBiXXwe6X91Juq0GhrCpk9/OWtCqC8k1eT64+BtfnIZ7uC6F4vb/
   CW26FoWQBL6Fgpf0m+qEr1HvEZQee+sLeaq5acDBX8tovhaBn2e/2JbOd
   tk2MrPEknDHAghvPjB3xE+D+agn3yC3LRvOUpLonmNGpddyc2Ez+skUDw
   CoFwarinbNWD2WuFAld5js6vt04BRE8HwqalHLnUqWZOWpI8hCRLAH7GB
   2YBZs5XW/eL0llAoaBS4gSPHYEdHUCjXr9xdU+HN7mLT6mQPPUdAjnvss
   LcRFJQa05dvxFImWZxqPXbi3EjG0IA7AMgE5mNPcFw3j/xvhaQHmqiyMv
   w==;
IronPort-SDR: 8RLMovVziAW+boUG/RB7ra2K2nTbM7GMGiexCzt67DidZVnC4U6A5RbOaWQfbIWpjXEHHD7cyo
 r9TkqjwUaiT6PPnBObeoAsYN8MSxT40QB2BB0AbkEXzuG8v8qQggD6PkoxWTu+OOm9vvJhiOMz
 rJAwiuQko8zGGT0oRqbrH2zFHDs20WMxLmBbkAF5C7ZG5jRzqJDwSrce/KMOVj4WY5OFKyIFyB
 WNCb/xKdgC4obd1uZoDNLwo0ZsMFuip0YA2UKp0rhRet3CjdMIDRDTRWYB8S91tio2RHFDGyWN
 dAM=
X-IronPort-AV: E=Sophos;i="5.75,301,1589266800"; 
   d="scan'208";a="82247352"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2020 09:51:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 09:51:19 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 1 Jul 2020 09:51:15 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <nicolas.ferre@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Subject: [PATCH 2/2] net: dsa: microchip: split adjust_link() in phylink_mac_link_{up|down}()
Date:   Wed, 1 Jul 2020 19:51:28 +0300
Message-ID: <20200701165128.1213447-2-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200701165128.1213447-1-codrin.ciubotariu@microchip.com>
References: <20200701165128.1213447-1-codrin.ciubotariu@microchip.com>
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
index b0227b0e31e6..d07231d1def5 100644
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
index 833cf3763000..162f2bd84774 100644
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
index 4a41f0c7dbbc..a35d6ba8dd8a 100644
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
index 785702514a46..b1c468713609 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -160,8 +160,11 @@ void ksz_init_mib_timer(struct ksz_device *dev);
 
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

