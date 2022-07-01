Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0D5563699
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiGAPHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiGAPHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:07:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156F5167C5;
        Fri,  1 Jul 2022 08:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656688058; x=1688224058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MicE8fGK5svKumXmAptj8sQUzXdu2+kFAZVOBmDFZw8=;
  b=Rw3RqVuzUgzlorcJs4PTlMzY82MdASHi2SkY7ezLRX/DyBDHuxxW4ZEj
   344vMtOg7D+65ye49WScK01IHB9vxvS07VZAl7g2d4rCVLe5LFcJtozAg
   /Of+c3R2t/15odgLNohJ0UxNDSB8tmONm/M0ARHLaBanil0mEPaDLIUkx
   QSeJXs4aOyh+d6pmCE36nEiAe4qB7w1W4jauOwfj8jTdxKYljJRrXegdb
   W+XOaya2mSysON20IxAnQSsGs2z9f02gX5mNT9VK8iy533R/D8z1RYp0f
   wQEZb1s9JgO6UCk9kDmz/9iTGewF97KrxqUr0rFkHlg5ugOVJGk9vdY3h
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="166025164"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 08:07:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 08:07:36 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 08:07:15 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [Patch net-next v15 08/13] net: dsa: microchip: lan937x: register mdio-bus
Date:   Fri, 1 Jul 2022 20:37:09 +0530
Message-ID: <20220701150709.27270-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701144652.10526-1-arun.ramadoss@microchip.com>
References: <20220701144652.10526-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch register mdio-bus for the lan937x series switch. mdio read
and write uses the vphy for accessing the phy register.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 74 ++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 5a2e14fe3cf3..7090947cf52c 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -7,6 +7,7 @@
 #include <linux/iopoll.h>
 #include <linux/phy.h>
 #include <linux/of_net.h>
+#include <linux/of_mdio.h>
 #include <linux/if_bridge.h>
 #include <linux/math.h>
 #include <net/dsa.h>
@@ -136,6 +137,73 @@ void lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 	lan937x_internal_phy_write(dev, addr, reg, val);
 }
 
+static int lan937x_sw_mdio_read(struct mii_bus *bus, int addr, int regnum)
+{
+	struct ksz_device *dev = bus->priv;
+	u16 val;
+	int ret;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	ret = lan937x_internal_phy_read(dev, addr, regnum, &val);
+	if (ret < 0)
+		return ret;
+
+	return val;
+}
+
+static int lan937x_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,
+				 u16 val)
+{
+	struct ksz_device *dev = bus->priv;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
+	return lan937x_internal_phy_write(dev, addr, regnum, val);
+}
+
+static int lan937x_mdio_register(struct ksz_device *dev)
+{
+	struct dsa_switch *ds = dev->ds;
+	struct device_node *mdio_np;
+	struct mii_bus *bus;
+	int ret;
+
+	mdio_np = of_get_child_by_name(dev->dev->of_node, "mdio");
+	if (!mdio_np) {
+		dev_err(ds->dev, "no MDIO bus node\n");
+		return -ENODEV;
+	}
+
+	bus = devm_mdiobus_alloc(ds->dev);
+	if (!bus) {
+		of_node_put(mdio_np);
+		return -ENOMEM;
+	}
+
+	bus->priv = dev;
+	bus->read = lan937x_sw_mdio_read;
+	bus->write = lan937x_sw_mdio_write;
+	bus->name = "lan937x slave smi";
+	snprintf(bus->id, MII_BUS_ID_SIZE, "SMI-%d", ds->index);
+	bus->parent = ds->dev;
+	bus->phy_mask = ~ds->phys_mii_mask;
+
+	ds->slave_mii_bus = bus;
+
+	ret = devm_of_mdiobus_register(ds->dev, bus, mdio_np);
+	if (ret) {
+		dev_err(ds->dev, "unable to register MDIO bus %s\n",
+			bus->id);
+	}
+
+	of_node_put(mdio_np);
+
+	return ret;
+}
+
 int lan937x_reset_switch(struct ksz_device *dev)
 {
 	u32 data32;
@@ -228,6 +296,12 @@ int lan937x_setup(struct dsa_switch *ds)
 		return ret;
 	}
 
+	ret = lan937x_mdio_register(dev);
+	if (ret < 0) {
+		dev_err(dev->dev, "failed to register the mdio");
+		return ret;
+	}
+
 	/* The VLAN aware is a global setting. Mixed vlan
 	 * filterings are not supported.
 	 */
-- 
2.36.1

