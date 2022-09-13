Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD0E5B7799
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiIMRRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiIMRRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:17:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB82285A8E;
        Tue, 13 Sep 2022 09:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663085101; x=1694621101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hRtRtW7b3JOLAOFz/CQGOMU8CKFHLjoxCorr4WNyMQM=;
  b=Al3EJSdlrdE1fybWIACyJMCuWxiERjinBxRoJIbnMdK4/LdOmLi0on7h
   6u9xs0w36SPmGwH+th801eB6kCTl+wPjJyzsexqwIhHMdf389PZjUeIn7
   gqfxnFGZPtv3/HreuZdV/XfRqidITJhcKjudzS0jiHvP//xjZFNq9k0tO
   60BfMt3KPlPQUEgk116QsqvHdGlxkPaGyJwb6zzKP951+g7Xvo5Dl+hwu
   yC7HjQStI609c+tClwUEdvJWo33tVtsEwbN5DhiK+rglII2rDNA3uzTa2
   9E5pz15ewB4CtZ7+E5XRgiQolmLuOeJ8n2mYwvut9NSi5dVNJEFYnVX1l
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="113468137"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 09:04:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 09:04:57 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 13 Sep 2022 09:04:51 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next 1/5] net: dsa: microchip: determine number of port irq based on switch type
Date:   Tue, 13 Sep 2022 21:34:23 +0530
Message-ID: <20220913160427.12749-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220913160427.12749-1-arun.ramadoss@microchip.com>
References: <20220913160427.12749-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the number of port irqs is hard coded for the lan937x switch
as 6. In order to make the generic interrupt handler for ksz switches,
number of port irq supported by the switch is added to the
ksz_chip_data. It is 4 for ksz9477, 2 for ksz9897 and 3 for ksz9567.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/microchip/ksz_common.c   | 9 +++++++++
 drivers/net/dsa/microchip/ksz_common.h   | 1 +
 drivers/net/dsa/microchip/lan937x_main.c | 4 +---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fcaa71f66322..b91089a483e7 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1168,6 +1168,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.port_nirqs = 4,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1230,6 +1231,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.port_nirqs = 2,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1259,6 +1261,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
+		.port_nirqs = 2,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1283,6 +1286,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.port_nirqs = 3,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1312,6 +1316,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
+		.port_nirqs = 6,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1335,6 +1340,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
+		.port_nirqs = 6,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1358,6 +1364,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
+		.port_nirqs = 6,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1385,6 +1392,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x38,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
+		.port_nirqs = 6,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1412,6 +1420,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
+		.port_nirqs = 6,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 6203dcd8c8f7..baa1e1bc1b7c 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -45,6 +45,7 @@ struct ksz_chip_data {
 	int num_statics;
 	int cpu_ports;
 	int port_cnt;
+	u8 port_nirqs;
 	const struct ksz_dev_ops *ops;
 	bool phy_errata_9477;
 	bool ksz87xx_eee_link_erratum;
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 9b6760b1e572..7136d9c55315 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -20,8 +20,6 @@
 #include "ksz_common.h"
 #include "lan937x.h"
 
-#define LAN937x_PNIRQS 6
-
 static int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	return regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -697,7 +695,7 @@ static int lan937x_pirq_setup(struct ksz_device *dev, u8 p)
 	int ret, irq;
 	int irq_num;
 
-	port->pirq.nirqs = LAN937x_PNIRQS;
+	port->pirq.nirqs = dev->info->port_nirqs;
 	port->pirq.domain = irq_domain_add_simple(dev->dev->of_node,
 						  port->pirq.nirqs, 0,
 						  &lan937x_pirq_domain_ops,
-- 
2.36.1

