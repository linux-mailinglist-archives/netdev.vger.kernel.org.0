Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16D95E5BEE
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiIVHL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiIVHLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:11:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEB098D01;
        Thu, 22 Sep 2022 00:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663830679; x=1695366679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z6drwkiNKSTxNDHHsfni7TRkFmfthnqCo5CpfJ5fSvg=;
  b=kGDC3JCV0WESxp5i1VlNWV1KXzcQQvsll2/Gu6jHwvTXIAFjuxLhyDpi
   fJ29OZzSUDufU71LGrQXK9KBxxaYnDTZTVQUiazryg+WqcAAt/UD9qCuO
   reo8NzHGHCyTQLBGmeG6jur/NRqoLIU/WjpWJuWqUYitBOvirfy6aECE9
   +rynp9qjtJRzvaLzEncwKKiBYvEMN+QeGRGXNw0JfVVap6SATdq5awcqJ
   d3O+fZVwCILIEl/9AD383GjW+gWrJ+SBFMmFyAldNY9rZ/UkpdjOp2CbO
   /O693kOX7vowzQUyvxKXRuHNOdebYpEsXXbzFO3VR940ERYvj/3Y8fUco
   A==;
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="181581839"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2022 00:11:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 22 Sep 2022 00:11:14 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 22 Sep 2022 00:11:07 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <arun.ramadoss@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: [Patch net-next v4 1/6] net: dsa: microchip: determine number of port irq based on switch type
Date:   Thu, 22 Sep 2022 12:40:23 +0530
Message-ID: <20220922071028.18012-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220922071028.18012-1-arun.ramadoss@microchip.com>
References: <20220922071028.18012-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/dsa/microchip/ksz_common.c   | 10 ++++++++++
 drivers/net/dsa/microchip/ksz_common.h   |  1 +
 drivers/net/dsa/microchip/lan937x_main.c |  4 +---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fcaa71f66322..07283279c578 100644
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
@@ -1199,6 +1200,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x3F,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
+		.port_nirqs = 2,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1230,6 +1232,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.port_nirqs = 2,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1259,6 +1262,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
+		.port_nirqs = 2,
 		.ops = &ksz9477_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1283,6 +1287,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.port_nirqs = 3,
 		.ops = &ksz9477_dev_ops,
 		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
@@ -1312,6 +1317,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
+		.port_nirqs = 6,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1335,6 +1341,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
+		.port_nirqs = 6,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1358,6 +1365,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
+		.port_nirqs = 6,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1385,6 +1393,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.num_statics = 256,
 		.cpu_ports = 0x38,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
+		.port_nirqs = 6,
 		.ops = &lan937x_dev_ops,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
@@ -1412,6 +1421,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
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
index 3e83f8ca0f09..a606d78c057e 100644
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
@@ -699,7 +697,7 @@ static int lan937x_pirq_setup(struct ksz_device *dev, u8 p)
 	int ret, irq;
 	int irq_num;
 
-	port->pirq.nirqs = LAN937x_PNIRQS;
+	port->pirq.nirqs = dev->info->port_nirqs;
 	port->pirq.domain = irq_domain_add_simple(dev->dev->of_node,
 						  port->pirq.nirqs, 0,
 						  &lan937x_pirq_domain_ops,
-- 
2.36.1

