Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A44B5A6132
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiH3Kxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiH3Kxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:53:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CF7E1AB5;
        Tue, 30 Aug 2022 03:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661856822; x=1693392822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i+NhalCfka2N+uo3jTS84TDOu0zWQkP5sMNEBtCTXuc=;
  b=w0/J5B+bk8x2l1EPr8I0sEoiMee9KN0rIvxziKvq6e8kE9FgjjG7yUOP
   rxxzu6jwqDN8JLIgLbWLW4/YTJXCqs5PKRsm50wsU/NDOLxrVZsAkf/Ar
   cMWacoDZAHbj+Xj0rBc5BYhfyoP5zfneNb2r+krNTDuVcNXM4zG/VrL/R
   TbaUEGZXie8bkJYYX28k8prhbfBG3gGT5DqVGCaoxgcLRyo5SIzCVFB/z
   bCB9CLYkjcC7w+hX4UTX4OAO9g9/4GZEYYofj+ZOSzDFSeD+Xo7x6I4Uo
   zEh8ExOJU4REfxrjpvcqx1dlPXwxNHNiWzhQ1gD4PC580kOP2AciLpZlH
   A==;
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="171569490"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Aug 2022 03:53:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 30 Aug 2022 03:53:37 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 30 Aug 2022 03:53:32 -0700
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
Subject: [RFC Patch net-next v3 2/3] net: dsa: microchip: add reference to ksz_device inside the ksz_port
Date:   Tue, 30 Aug 2022 16:23:02 +0530
Message-ID: <20220830105303.22067-3-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220830105303.22067-1-arun.ramadoss@microchip.com>
References: <20220830105303.22067-1-arun.ramadoss@microchip.com>
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
---
 drivers/net/dsa/microchip/ksz_common.c | 3 +++
 drivers/net/dsa/microchip/ksz_common.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index da9bdf753f7a..8714a20da0e7 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1917,6 +1917,9 @@ int ksz_switch_register(struct ksz_device *dev)
 				     GFP_KERNEL);
 		if (!dev->ports[i].mib.counters)
 			return -ENOMEM;
+
+		dev->ports[i].ksz_dev = dev;
+		dev->ports[i].num = i;
 	}
 
 	/* set the real number of ports */
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 0d9520dc6d2d..c675a58ef298 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -16,6 +16,8 @@
 
 #define KSZ_MAX_NUM_PORTS 8
 
+struct ksz_device;
+
 struct vlan_table {
 	u32 table[3];
 };
@@ -82,6 +84,8 @@ struct ksz_port {
 	u16 max_frame;
 	u32 rgmii_tx_val;
 	u32 rgmii_rx_val;
+	struct ksz_device *ksz_dev;
+	u8 num;
 };
 
 struct ksz_device {
-- 
2.36.1

