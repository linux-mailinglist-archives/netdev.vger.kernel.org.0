Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19039537941
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiE3Knd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbiE3Knb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:43:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DCD7092E;
        Mon, 30 May 2022 03:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653907409; x=1685443409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2+QyWHgpSaoljkbhS4MTjXOzmzlkFw8dFsY984H5Rqw=;
  b=tAwY1A3ip8XtGTpM+QZis61/Zy5wPac0pzafNvA2VVmprI2ItORCw2WF
   HBjRN5zEGG84nK9NZKFqipo0wjsNda+hEkhU6Xh9kYOQFtKlmbKtUQJBl
   L66LCzKIz05WKVTAnfSltNCgEN96W2wYyemdNu3Wn5qXGor4SbuzlOXD3
   j/Tze93gcgIQTPR70AH12zUsq4EwIKOrJx9AGKsT27l1vxC7AvWu3y1gV
   zlEMNzZgriJAnX6AOi8XGfcu7HVSXvB8P+u9p16Je8gfzrjUy4ZZaaVng
   Do4jkVrQMlmXEwNV2NgUebgD6Phz2He0fe6NJXHdmueJv7tL1MDDD60TG
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="175662972"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 May 2022 03:43:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 30 May 2022 03:43:25 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 30 May 2022 03:43:21 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [RFC Patch net-next v2 01/15] net: dsa: microchip: ksz9477: cleanup the ksz9477_switch_detect
Date:   Mon, 30 May 2022 16:12:43 +0530
Message-ID: <20220530104257.21485-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220530104257.21485-1-arun.ramadoss@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ksz9477_switch_detect performs the detecting the chip id from the
location 0x00 and also check gigabit compatibility check & number of
ports based on the register global_options0. To prepare the common ksz
switch detect function, routine other than chip id read is moved to
ksz9477_switch_init.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 48 +++++++++++++----------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index ab40b700cf1a..7afc06681c02 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1362,12 +1362,30 @@ static u32 ksz9477_get_port_addr(int port, int offset)
 
 static int ksz9477_switch_detect(struct ksz_device *dev)
 {
-	u8 data8;
-	u8 id_hi;
-	u8 id_lo;
 	u32 id32;
 	int ret;
 
+	/* read chip id */
+	ret = ksz_read32(dev, REG_CHIP_ID0__1, &id32);
+	if (ret)
+		return ret;
+
+	dev_dbg(dev->dev, "Switch detect: ID=%08x\n", id32);
+
+	dev->chip_id = id32 & 0x00FFFF00;
+
+	return 0;
+}
+
+static int ksz9477_switch_init(struct ksz_device *dev)
+{
+	u8 data8;
+	int ret;
+
+	dev->ds->ops = &ksz9477_switch_ops;
+
+	dev->port_mask = (1 << dev->info->port_cnt) - 1;
+
 	/* turn off SPI DO Edge select */
 	ret = ksz_read8(dev, REG_SW_GLOBAL_SERIAL_CTRL_0, &data8);
 	if (ret)
@@ -1378,10 +1396,6 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 	if (ret)
 		return ret;
 
-	/* read chip id */
-	ret = ksz_read32(dev, REG_CHIP_ID0__1, &id32);
-	if (ret)
-		return ret;
 	ret = ksz_read8(dev, REG_GLOBAL_OPTIONS, &data8);
 	if (ret)
 		return ret;
@@ -1392,10 +1406,7 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 	/* Default capability is gigabit capable. */
 	dev->features = GBIT_SUPPORT;
 
-	dev_dbg(dev->dev, "Switch detect: ID=%08x%02x\n", id32, data8);
-	id_hi = (u8)(id32 >> 16);
-	id_lo = (u8)(id32 >> 8);
-	if ((id_lo & 0xf) == 3) {
+	if (dev->chip_id == KSZ9893_CHIP_ID) {
 		/* Chip is from KSZ9893 design. */
 		dev_info(dev->dev, "Found KSZ9893\n");
 		dev->features |= IS_9893;
@@ -1413,21 +1424,6 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 		if (!(data8 & SW_GIGABIT_ABLE))
 			dev->features &= ~GBIT_SUPPORT;
 	}
-
-	/* Change chip id to known ones so it can be matched against them. */
-	id32 = (id_hi << 16) | (id_lo << 8);
-
-	dev->chip_id = id32;
-
-	return 0;
-}
-
-static int ksz9477_switch_init(struct ksz_device *dev)
-{
-	dev->ds->ops = &ksz9477_switch_ops;
-
-	dev->port_mask = (1 << dev->info->port_cnt) - 1;
-
 	return 0;
 }
 
-- 
2.36.1

