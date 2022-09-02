Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8B95AAC71
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbiIBKcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbiIBKce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:32:34 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA84EB07D1;
        Fri,  2 Sep 2022 03:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662114751; x=1693650751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QTCs0BKJ8AZF5dsnIBAu9d9AC7NCckejdUsulm1LMWE=;
  b=IUm4vx3Bx+DivTCaF9Zh72gLPkesJj+Vz9+DGqZFgPuNd/l1tjCM6xjH
   OorDN+zcwodb9t4sUDChnjqnUkVuB0e37uP4daDdZL5cMSifez+JEbIeo
   3wAq1zk5/wvJPGxb3Gs/ciWZT58+iQXl7qyA5I5R1FsyZX0QMztZjipMp
   YXFsX3MnnNFp8Duqg9rOYR0V8Vc3qdK/Z3cKuS93g6dyfkCvQUT0AoSl1
   gQvEcWArSOT2ICkBFyYXbwRAwqnzjQFf5Velje9V1QvQQ2SKGl0faoLBm
   CR8NYHts+vGEAbMxCDNnUc7AWMQdsVh45LzbV4AQZf0c/tcQc5jWTe4IT
   g==;
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="178772910"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 03:32:30 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 03:32:29 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Sep 2022 03:32:24 -0700
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
        "Russell King" <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: [Patch net-next 1/3] net: dsa: microchip: add reference to ksz_device inside the ksz_port
Date:   Fri, 2 Sep 2022 16:02:08 +0530
Message-ID: <20220902103210.10743-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220902103210.10743-1-arun.ramadoss@microchip.com>
References: <20220902103210.10743-1-arun.ramadoss@microchip.com>
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

struct ksz_port doesn't have reference to ksz_device as of now. In order
to find out from which port interrupt has triggered, we need to pass the
struct ksz_port as a host data. When the interrupt is triggered, we can
get the port from which interrupt triggered, but to identify it is phy
interrupt we have to read status register. The regmap structure for
accessing the device register is present in the ksz_device struct. To
access the ksz_device from the ksz_port, the reference is added to it
with port number as well.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/microchip/ksz_common.c | 3 +++
 drivers/net/dsa/microchip/ksz_common.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 37fb5ba2cd7a..63b9faa89393 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2357,6 +2357,9 @@ int ksz_switch_register(struct ksz_device *dev)
 				     GFP_KERNEL);
 		if (!dev->ports[i].mib.counters)
 			return -ENOMEM;
+
+		dev->ports[i].ksz_dev = dev;
+		dev->ports[i].num = i;
 	}
 
 	/* set the real number of ports */
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c01989c04d4e..3fa3e4731d58 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -16,6 +16,8 @@
 
 #define KSZ_MAX_NUM_PORTS 8
 
+struct ksz_device;
+
 struct vlan_table {
 	u32 table[3];
 };
@@ -83,6 +85,8 @@ struct ksz_port {
 	u16 max_frame;
 	u32 rgmii_tx_val;
 	u32 rgmii_rx_val;
+	struct ksz_device *ksz_dev;
+	u8 num;
 };
 
 struct ksz_device {
-- 
2.36.1

