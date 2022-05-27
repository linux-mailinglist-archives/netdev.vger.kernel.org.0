Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35E65359D2
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344988AbiE0HGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344999AbiE0HGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:06:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EDA313B3;
        Fri, 27 May 2022 00:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653635192; x=1685171192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hJitJMQq2DlsnhcJXbwfiNSwdg4yOnq8J5j58GL8qFo=;
  b=HKDpifF+sr+VEmoaVV7sPfgqc9h03+wRFkIYfI5gjOActLY6bPcQqhqA
   es/sny/SyY6lNNWUrh+CUbSOx15hT/qG7uVgdCqX8MA1UJOiDed/Izk5D
   9STMnuUoeXonjcAu0hF/lEXnLfe5N6dG0nD7Sv7yAxHxgSMISQGMQGpSc
   4o71qCCpfBmP9YEofbHFUyItY2wC42XXpz8GDhwN5Dh4Q5yTW8NeeaaM/
   x/wM/Yn8MIoAdYH2rQjFouDDU9npE6UdGTkAUVNsCeCuwvI58aU0OO7FS
   zBc/cxRK6UFFWwlswI4O8qRWCGsgX568WvSb4PLp3/fOR6pMp58/n/Sk8
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="165953506"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 May 2022 00:06:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 27 May 2022 00:06:20 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 27 May 2022 00:06:16 -0700
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
Subject: [RFC Patch net-next 04/17] net: dsa: microchip: ksz9477: use ksz_read_phy16 & ksz_write_phy16
Date:   Fri, 27 May 2022 12:33:45 +0530
Message-ID: <20220527070358.25490-5-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527070358.25490-1-arun.ramadoss@microchip.com>
References: <20220527070358.25490-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ksz8795 and ksz9477 implementation on phy read/write hooks are
different. This patch modifies the ksz9477 implementation same as
ksz8795 by updating the ksz9477_dev_ops structure.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index ab3fbb8e15a1..4fb96e53487e 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -276,9 +276,8 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	mutex_unlock(&mib->cnt_mutex);
 }
 
-static int ksz9477_phy_read16(struct dsa_switch *ds, int addr, int reg)
+static void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 {
-	struct ksz_device *dev = ds->priv;
 	u16 val = 0xffff;
 
 	/* No real PHY after this. Simulate the PHY.
@@ -323,24 +322,20 @@ static int ksz9477_phy_read16(struct dsa_switch *ds, int addr, int reg)
 		ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
 	}
 
-	return val;
+	*data = val;
 }
 
-static int ksz9477_phy_write16(struct dsa_switch *ds, int addr, int reg,
-			       u16 val)
+static void ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 {
-	struct ksz_device *dev = ds->priv;
-
 	/* No real PHY after this. */
 	if (addr >= dev->phy_port_cnt)
-		return 0;
+		return;
 
 	/* No gigabit support.  Do not write to this register. */
 	if (!(dev->features & GBIT_SUPPORT) && reg == MII_CTRL1000)
-		return 0;
-	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
+		return;
 
-	return 0;
+	ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
 }
 
 static void ksz9477_cfg_port_member(struct ksz_device *dev, int port,
@@ -1316,8 +1311,8 @@ static int ksz9477_setup(struct dsa_switch *ds)
 static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.get_tag_protocol	= ksz_get_tag_protocol,
 	.setup			= ksz9477_setup,
-	.phy_read		= ksz9477_phy_read16,
-	.phy_write		= ksz9477_phy_write16,
+	.phy_read		= ksz_phy_read16,
+	.phy_write		= ksz_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.phylink_get_caps	= ksz9477_get_caps,
 	.port_enable		= ksz_enable_port,
@@ -1405,6 +1400,8 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.cfg_port_member = ksz9477_cfg_port_member,
 	.flush_dyn_mac_table = ksz9477_flush_dyn_mac_table,
 	.port_setup = ksz9477_port_setup,
+	.r_phy = ksz9477_r_phy,
+	.w_phy = ksz9477_w_phy,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
 	.r_mib_pkt = ksz9477_r_mib_pkt,
 	.r_mib_stat64 = ksz_r_mib_stats64,
-- 
2.36.1

