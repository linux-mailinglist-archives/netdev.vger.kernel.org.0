Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9408B687E14
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjBBM64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjBBM6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:58:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD8F59249;
        Thu,  2 Feb 2023 04:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675342729; x=1706878729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1djmTQ6/cbT1raftQ9vms3W0+SE59JVgpFBKfe2ifxw=;
  b=pJbzyPe0Ya98QA+mWbkyrswAoFl2lWZIABcC44XkfYVzEh0Hyd/edAka
   MAGkBh37c2Naw7VLaPpxrvpWvde1PTndjSgWCuISH29LltqSKlo3KIbBx
   HgYiXnXxJkT1nzETBA9QoQHVMvnz/nNLnG+zsKGvGN9nSrEJJT/U22SBe
   LEYda//vmFBU1mTm4i8hUa9/56A4MXyM5nDAeTxUJctod0Rb5Sw/tQOBa
   laP1GKEAePY1cl9xr8C+dBT/RvClNoa4NO7eEWe0HH4mHJ7iTVUs8e38f
   EeYoP22tEMWcx9ceOMQn23RMZOCOwPoGZHN/nmqprrvR0hHvgdn4PX2cg
   w==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="135251584"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 05:58:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 05:58:38 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 05:58:34 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: [RFC PATCH net-next 02/11] net: dsa: microchip: lan937x: update SMI index
Date:   Thu, 2 Feb 2023 18:29:21 +0530
Message-ID: <20230202125930.271740-3-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current DSA driver register mdio interface for a port in the
format of SMI-switch_index:port_number, switch_index is derived
using variable ds->index. For a single switch ds->index will be
always zero, and for cascaded switch, ds->index should be one.
But it is found that ds->index is getting updated only after
mdio_register stage. Update mdio_register to use variable directly
from device tree using "dsa,member" identifier.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 6 +++++-
 drivers/net/dsa/microchip/ksz_common.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 46becc0382d6..d2ec5acd7b17 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1882,7 +1882,7 @@ static int ksz_mdio_register(struct ksz_device *dev)
 	bus->read = ksz_sw_mdio_read;
 	bus->write = ksz_sw_mdio_write;
 	bus->name = "ksz slave smi";
-	snprintf(bus->id, MII_BUS_ID_SIZE, "SMI-%d", ds->index);
+	snprintf(bus->id, MII_BUS_ID_SIZE, "SMI-%d", dev->smi_index);
 	bus->parent = ds->dev;
 	bus->phy_mask = ~ds->phys_mii_mask;
 
@@ -3136,6 +3136,7 @@ struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
 	struct dsa_switch *ds;
 	struct ksz_device *swdev;
+	u32 sw_idx[2];
 
 	ds = devm_kzalloc(base, sizeof(*ds), GFP_KERNEL);
 	if (!ds)
@@ -3155,6 +3156,9 @@ struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 	swdev->ds = ds;
 	swdev->priv = priv;
 
+	of_property_read_variable_u32_array(base->of_node, "dsa,member", sw_idx, 2, 2);
+	swdev->smi_index = sw_idx[1];
+
 	return swdev;
 }
 EXPORT_SYMBOL(ksz_switch_alloc);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d2d5761d58e9..aab60f2587bf 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -147,6 +147,7 @@ struct ksz_device {
 	u32 chip_id;
 	u8 chip_rev;
 	int cpu_port;			/* port connected to CPU */
+	u32 smi_index;
 	int phy_port_cnt;
 	phy_interface_t compat_interface;
 	bool synclko_125;
-- 
2.34.1

