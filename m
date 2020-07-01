Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EAC21111D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732572AbgGAQvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:51:36 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:59557 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732514AbgGAQvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593622295; x=1625158295;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XKMbsXqy97UiYqdVQKPNtIxaciqrXC9S2rGEsOOT1gw=;
  b=IZbai1sObFKWFsO7kSPs0isTazrHLAnan0+JFi7EQDU5RrMoSge8yJh4
   hBD7FMi++J/gQ2yV4lWmrPGcUDjSrGBMeBx997kB7MdVowIGZOdelbLJ3
   VYtgebtwmHEOXHkJ0dAIqdSThsHXaZaEE0wwJjnPiYNz+L+aD+Mkq4j8t
   AIkawe7W/LuA6ukWy35YxHO6EkBSsRn3FWMfwgGy470HQf8SZ+ZrixDrM
   IIXneCWNcF5uKZbRQ1svS6NenXXAKfz/rWx9h+w89pfM1aWh/GhxIxk6n
   VhApYpJyyTqxks2Si8P3AfvM7HLFHu49uV09xFZYOo6/5fp5q7nLPC/44
   A==;
IronPort-SDR: h0bI9J+xanlQiFJuT9JdnzaveqFWFAUJJbvC60mr2rASdBEgaW4AHjs6VHjXRTxR6LcLI/Hnqo
 1vrZOtPnL6U5M0ERgx1EuRcf0eq53egKNvI1PCyvvo+mPkV/yqHElO+q1nZq3Eov9bGwvkWG7W
 +9Rpi7g2MstPwb/rePm1dr7bfjts9uZad+uMNy4cwvTKl4svV7XXXknyT8KTSTcQjC2UmyOsV5
 T62+bEVle2gtr+viexNNuENtnAOdX9+3LTXZlcXFzzWMuS5JFgdMihFEpSpgS42EvSAIShdq6X
 EFQ=
X-IronPort-AV: E=Sophos;i="5.75,301,1589266800"; 
   d="scan'208";a="82247335"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2020 09:51:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 09:51:15 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 1 Jul 2020 09:51:10 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <nicolas.ferre@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Subject: [PATCH 1/2] net: dsa: microchip: set the correct number of ports in dsa_switch
Date:   Wed, 1 Jul 2020 19:51:27 +0300
Message-ID: <20200701165128.1213447-1-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of ports is incorrectly set to the maximum available for a DSA
switch. Even if the extra ports are not used, this causes some functions
to be called later, like port_disable() and port_stp_state_set(). If the
driver doesn't check the port index, it will end up modifying unknown
registers.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    |  7 +++++--
 drivers/net/dsa/microchip/ksz9477.c    |  7 +++++--
 drivers/net/dsa/microchip/ksz_common.c | 26 ++++++++++++++++----------
 drivers/net/dsa/microchip/ksz_common.h |  1 +
 4 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 47d65b77caf7..b0227b0e31e6 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1225,8 +1225,6 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 {
 	int i;
 
-	dev->ds->ops = &ksz8795_switch_ops;
-
 	for (i = 0; i < ARRAY_SIZE(ksz8795_switch_chips); i++) {
 		const struct ksz_chip_data *chip = &ksz8795_switch_chips[i];
 
@@ -1268,6 +1266,11 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 			return -ENOMEM;
 	}
 
+	dev->ds = ksz_dsa_switch_alloc(dev);
+	if (!dev->ds)
+		return -ENOMEM;
+	dev->ds->ops = &ksz8795_switch_ops;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 9a51b8a4de5d..833cf3763000 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1545,8 +1545,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 {
 	int i;
 
-	dev->ds->ops = &ksz9477_switch_ops;
-
 	for (i = 0; i < ARRAY_SIZE(ksz9477_switch_chips); i++) {
 		const struct ksz_chip_data *chip = &ksz9477_switch_chips[i];
 
@@ -1588,6 +1586,11 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 			return -ENOMEM;
 	}
 
+	dev->ds = ksz_dsa_switch_alloc(dev);
+	if (!dev->ds)
+		return -ENOMEM;
+	dev->ds->ops = &ksz9477_switch_ops;
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fd1d6676ae4f..4a41f0c7dbbc 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -387,30 +387,36 @@ EXPORT_SYMBOL_GPL(ksz_disable_port);
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
-	struct dsa_switch *ds;
 	struct ksz_device *swdev;
 
-	ds = devm_kzalloc(base, sizeof(*ds), GFP_KERNEL);
-	if (!ds)
-		return NULL;
-
-	ds->dev = base;
-	ds->num_ports = DSA_MAX_PORTS;
-
 	swdev = devm_kzalloc(base, sizeof(*swdev), GFP_KERNEL);
 	if (!swdev)
 		return NULL;
 
-	ds->priv = swdev;
 	swdev->dev = base;
 
-	swdev->ds = ds;
 	swdev->priv = priv;
 
 	return swdev;
 }
 EXPORT_SYMBOL(ksz_switch_alloc);
 
+struct dsa_switch *ksz_dsa_switch_alloc(struct ksz_device *swdev)
+{
+	struct dsa_switch *ds;
+
+	ds = devm_kzalloc(swdev->dev, sizeof(*ds), GFP_KERNEL);
+	if (!ds)
+		return NULL;
+
+	ds->dev = swdev->dev;
+	ds->num_ports = swdev->port_cnt;
+	ds->priv = swdev;
+
+	return ds;
+}
+EXPORT_SYMBOL(ksz_dsa_switch_alloc);
+
 int ksz_switch_register(struct ksz_device *dev,
 			const struct ksz_dev_ops *ops)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f2c9bb68fd33..785702514a46 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -145,6 +145,7 @@ struct ksz_dev_ops {
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
+struct dsa_switch *ksz_dsa_switch_alloc(struct ksz_device *swdev);
 int ksz_switch_register(struct ksz_device *dev,
 			const struct ksz_dev_ops *ops);
 void ksz_switch_remove(struct ksz_device *dev);
-- 
2.25.1

