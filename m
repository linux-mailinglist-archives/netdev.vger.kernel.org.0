Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D782B8713
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgKRWEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgKRWEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:04:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A6FC061A4D
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:04:14 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYg-000590-E0; Wed, 18 Nov 2020 23:04:10 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYe-0000yx-Dt; Wed, 18 Nov 2020 23:04:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH 09/11] net: dsa: microchip: remove usage of mib_port_count
Date:   Wed, 18 Nov 2020 23:03:55 +0100
Message-Id: <20201118220357.22292-10-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable mib_port_cnt has the same meaning as port_cnt.
This driver removes the extra variable and is using port_cnt
everywhere instead.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c    | 11 +++++------
 drivers/net/dsa/microchip/ksz9477.c    | 12 +++++-------
 drivers/net/dsa/microchip/ksz_common.c |  4 ++--
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 4 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 10c9b301833dd59..9ea5ec61513023f 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -760,7 +760,7 @@ static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	} else {
 		/* Flush all ports. */
 		first = 0;
-		cnt = dev->mib_port_cnt;
+		cnt = dev->port_cnt;
 	}
 	for (index = first; index < cnt; index++) {
 		p = &dev->ports[index];
@@ -1236,18 +1236,17 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	dev->reg_mib_cnt = KSZ8795_COUNTER_NUM;
 	dev->mib_cnt = ARRAY_SIZE(mib_names);
 
-	dev->mib_port_cnt = TOTAL_PORT_NUM;
 	dev->phy_port_cnt = dev->port_cnt - 1;
 
-	dev->cpu_port = dev->mib_port_cnt - 1;
+	dev->cpu_port = dev->port_cnt - 1;
 	dev->host_mask = BIT(dev->cpu_port);
 
-	i = dev->mib_port_cnt;
-	dev->ports = devm_kzalloc(dev->dev, sizeof(struct ksz_port) * i,
+	dev->ports = devm_kzalloc(dev->dev,
+				  dev->port_cnt * sizeof(struct ksz_port),
 				  GFP_KERNEL);
 	if (!dev->ports)
 		return -ENOMEM;
-	for (i = 0; i < dev->mib_port_cnt; i++) {
+	for (i = 0; i < dev->port_cnt; i++) {
 		mutex_init(&dev->ports[i].mib.cnt_mutex);
 		dev->ports[i].mib.counters =
 			devm_kzalloc(dev->dev,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 2119965da10ae1e..42e647b67abd500 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -478,7 +478,7 @@ static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 			   SW_FLUSH_OPTION_M << SW_FLUSH_OPTION_S,
 			   SW_FLUSH_OPTION_DYN_MAC << SW_FLUSH_OPTION_S);
 
-	if (port < dev->mib_port_cnt) {
+	if (port < dev->port_cnt) {
 		/* flush individual port */
 		ksz_pread8(dev, port, P_STP_CTRL, &data);
 		if (!(data & PORT_LEARN_DISABLE))
@@ -1317,7 +1317,7 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 
 	dev->member = dev->host_mask;
 
-	for (i = 0; i < dev->mib_port_cnt; i++) {
+	for (i = 0; i < dev->port_cnt; i++) {
 		if (i == dev->cpu_port)
 			continue;
 		p = &dev->ports[i];
@@ -1444,7 +1444,6 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 		return ret;
 
 	/* Number of ports can be reduced depending on chip. */
-	dev->mib_port_cnt = TOTAL_PORT_NUM;
 	dev->phy_port_cnt = 5;
 
 	/* Default capability is gigabit capable. */
@@ -1461,7 +1460,6 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 		/* Chip does not support gigabit. */
 		if (data8 & SW_QW_ABLE)
 			dev->features &= ~GBIT_SUPPORT;
-		dev->mib_port_cnt = 3;
 		dev->phy_port_cnt = 2;
 	} else {
 		dev_info(dev->dev, "Found KSZ9477 or compatible\n");
@@ -1564,12 +1562,12 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
 	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
 
-	i = dev->mib_port_cnt;
-	dev->ports = devm_kzalloc(dev->dev, sizeof(struct ksz_port) * i,
+	dev->ports = devm_kzalloc(dev->dev,
+				  dev->port_cnt * sizeof(struct ksz_port),
 				  GFP_KERNEL);
 	if (!dev->ports)
 		return -ENOMEM;
-	for (i = 0; i < dev->mib_port_cnt; i++) {
+	for (i = 0; i < dev->port_cnt; i++) {
 		mutex_init(&dev->ports[i].mib.cnt_mutex);
 		dev->ports[i].mib.counters =
 			devm_kzalloc(dev->dev,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 0ef854911f215fa..566edfe1323ee69 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -72,7 +72,7 @@ static void ksz_mib_read_work(struct work_struct *work)
 	struct ksz_port *p;
 	int i;
 
-	for (i = 0; i < dev->mib_port_cnt; i++) {
+	for (i = 0; i < dev->port_cnt; i++) {
 		if (dsa_is_unused_port(dev->ds, i))
 			continue;
 
@@ -103,7 +103,7 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 
 	INIT_DELAYED_WORK(&dev->mib_read, ksz_mib_read_work);
 
-	for (i = 0; i < dev->mib_port_cnt; i++)
+	for (i = 0; i < dev->port_cnt; i++)
 		dev->dev_ops->port_init_cnt(dev, i);
 }
 EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 629700a63702435..720f22275c84448 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -71,7 +71,6 @@ struct ksz_device {
 	int port_cnt;
 	int reg_mib_cnt;
 	int mib_cnt;
-	int mib_port_cnt;
 	phy_interface_t compat_interface;
 	u32 regs_size;
 	bool phy_errata_9477;
-- 
2.29.2

