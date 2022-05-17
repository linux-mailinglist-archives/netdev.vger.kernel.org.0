Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA938529E57
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244317AbiEQJpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245115AbiEQJom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:44:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F56941F82;
        Tue, 17 May 2022 02:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652780679; x=1684316679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Frb05pp2v3DKRoYHhBX4jB5uLNVSIPanuglEZU9u9jA=;
  b=K+ied2UNvucCF4TBsRfYtAnBDqs5RkmUcmrJwxJ5vJF2rxewA4LvtO2U
   6T2to0CI8PfqOPVxOTjlzXoSyaQe2Os8V/0tvoF5BX8L6SoRdGN8NGnV4
   6wDdXzU99joN28As59o9dDyHZP+2U51s+hCCSbCNGt95iFlYwjfcpYQAs
   2Pdwsy3QFGER9tTCCbLMK19aPawJGj3vKoXAr5+HZcPq6Q/Nf2/iv+JGG
   9DEjJlOWHTjHmlCWqmvJUTFk5XahpWpJmBHGYHjujWrxcrSoPGhu14bxv
   s4clIQQOj36EbowhUUH0SF+hqA34inWjYEJ/3ocPi24yLPmkJXEGVc/9M
   A==;
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="164391186"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 May 2022 02:44:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 17 May 2022 02:44:38 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 17 May 2022 02:44:32 -0700
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
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net-next 5/9] net: dsa: microchip: move port memory allocation to ksz_common
Date:   Tue, 17 May 2022 15:13:29 +0530
Message-ID: <20220517094333.27225-6-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220517094333.27225-1-arun.ramadoss@microchip.com>
References: <20220517094333.27225-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ksz8795 and ksz9477 init function initializes the memory to dev->ports,
mib counters and assigns the ds real number of ports. Since both the
routines are same, moved the allocation of port memory to
ksz_switch_register after init.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 20 --------------------
 drivers/net/dsa/microchip/ksz9477.c    | 22 ----------------------
 drivers/net/dsa/microchip/ksz_common.c | 21 +++++++++++++++++++++
 3 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 764e16b4f24b..3490b6072641 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1494,7 +1494,6 @@ static int ksz8_switch_detect(struct ksz_device *dev)
 static int ksz8_switch_init(struct ksz_device *dev)
 {
 	struct ksz8 *ksz8 = dev->priv;
-	int i;
 
 	dev->ds->ops = &ksz8_switch_ops;
 
@@ -1513,25 +1512,6 @@ static int ksz8_switch_init(struct ksz_device *dev)
 		ksz8->shifts = ksz8795_shifts;
 	}
 
-	dev->ports = devm_kzalloc(dev->dev,
-				  dev->info->port_cnt * sizeof(struct ksz_port),
-				  GFP_KERNEL);
-	if (!dev->ports)
-		return -ENOMEM;
-	for (i = 0; i < dev->info->port_cnt; i++) {
-		mutex_init(&dev->ports[i].mib.cnt_mutex);
-		dev->ports[i].mib.counters =
-			devm_kzalloc(dev->dev,
-				     sizeof(u64) *
-				     (dev->info->mib_cnt + 1),
-				     GFP_KERNEL);
-		if (!dev->ports[i].mib.counters)
-			return -ENOMEM;
-	}
-
-	/* set the real number of ports */
-	dev->ds->num_ports = dev->info->port_cnt;
-
 	/* We rely on software untagging on the CPU port, so that we
 	 * can support both tagged and untagged VLANs
 	 */
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index f7d4a3498e5d..d4729f0dd831 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1432,32 +1432,10 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 
 static int ksz9477_switch_init(struct ksz_device *dev)
 {
-	int i;
-
 	dev->ds->ops = &ksz9477_switch_ops;
 
 	dev->port_mask = (1 << dev->info->port_cnt) - 1;
 
-	dev->ports = devm_kzalloc(dev->dev,
-				  dev->info->port_cnt * sizeof(struct ksz_port),
-				  GFP_KERNEL);
-	if (!dev->ports)
-		return -ENOMEM;
-	for (i = 0; i < dev->info->port_cnt; i++) {
-		spin_lock_init(&dev->ports[i].mib.stats64_lock);
-		mutex_init(&dev->ports[i].mib.cnt_mutex);
-		dev->ports[i].mib.counters =
-			devm_kzalloc(dev->dev,
-				     sizeof(u64) *
-				     (dev->info->mib_cnt + 1),
-				     GFP_KERNEL);
-		if (!dev->ports[i].mib.counters)
-			return -ENOMEM;
-	}
-
-	/* set the real number of ports */
-	dev->ds->num_ports = dev->info->port_cnt;
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 243032b29ff2..8f90bf29fd4c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -844,6 +844,7 @@ int ksz_switch_register(struct ksz_device *dev,
 	phy_interface_t interface;
 	unsigned int port_num;
 	int ret;
+	int i;
 
 	if (dev->pdata)
 		dev->chip_id = dev->pdata->chip_id;
@@ -885,6 +886,26 @@ int ksz_switch_register(struct ksz_device *dev,
 	if (ret)
 		return ret;
 
+	dev->ports = devm_kzalloc(dev->dev,
+				  dev->info->port_cnt * sizeof(struct ksz_port),
+				  GFP_KERNEL);
+	if (!dev->ports)
+		return -ENOMEM;
+
+	for (i = 0; i < dev->info->port_cnt; i++) {
+		spin_lock_init(&dev->ports[i].mib.stats64_lock);
+		mutex_init(&dev->ports[i].mib.cnt_mutex);
+		dev->ports[i].mib.counters =
+			devm_kzalloc(dev->dev,
+				     sizeof(u64) * (dev->info->mib_cnt + 1),
+				     GFP_KERNEL);
+		if (!dev->ports[i].mib.counters)
+			return -ENOMEM;
+	}
+
+	/* set the real number of ports */
+	dev->ds->num_ports = dev->info->port_cnt;
+
 	/* Host port interface will be self detected, or specifically set in
 	 * device tree.
 	 */
-- 
2.33.0

