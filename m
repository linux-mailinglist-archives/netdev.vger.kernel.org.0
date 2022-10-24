Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9E3609C71
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJXI0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 04:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiJXI0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:26:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB3232EE4;
        Mon, 24 Oct 2022 01:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666599930; x=1698135930;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mDe9Q7k79S6Q9R+BiEkd+D2DsEFr7ii9SBW6+CPVZoo=;
  b=pm79kDD4ISH+FQApgzWgS4iAQ2xr2W3SpkoUYgE57M84f7/9jwBgRWSR
   PKOzfO1yV2Q8FB09OjHjWuhDlBv+vbaAQNgUk/z+kfStsBfJe8WAutIne
   6K8S4CHjUDVVI5phwBVF4Dal4p4fdi1WXdrBo34jeukGRW52+ozzAGOuD
   IAWQgnsNE89PRck7oE1WARhqTfffupzaadiOVKlBekKM7JEbIXVi4JQ7r
   ri3U8IiD50DRBnorDHBR04+tF/W8ZpJvqr/JIprbk+0nO9h/eZpU6Dw10
   WSje5EbUB41K1C4liO5PRTEmWK9akI7FK7txNTphPaLPA5Q3Ff0LrHENW
   w==;
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="180199102"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Oct 2022 01:25:29 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 24 Oct 2022 01:25:28 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 24 Oct 2022 01:25:24 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 1/2] net: lan743x: Add support for get_pauseparam and set_pauseparam
Date:   Mon, 24 Oct 2022 13:55:15 +0530
Message-ID: <20221024082516.661199-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221024082516.661199-1-Raju.Lakkaraju@microchip.com>
References: <20221024082516.661199-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pause get and set functions

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
Change List:
============
V0 -> V1:
 - Change the phy_set_asym_pause() to an else clause

 .../net/ethernet/microchip/lan743x_ethtool.c  | 46 +++++++++++++++++++
 drivers/net/ethernet/microchip/lan743x_main.c |  4 +-
 drivers/net/ethernet/microchip/lan743x_main.h |  2 +
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index c739d60ee17d..88f9484cc2a7 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -1233,6 +1233,50 @@ static void lan743x_get_regs(struct net_device *dev,
 	lan743x_common_regs(dev, regs, p);
 }
 
+static void lan743x_get_pauseparam(struct net_device *dev,
+				   struct ethtool_pauseparam *pause)
+{
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+	struct lan743x_phy *phy = &adapter->phy;
+
+	if (phy->fc_request_control & FLOW_CTRL_TX)
+		pause->tx_pause = 1;
+	if (phy->fc_request_control & FLOW_CTRL_RX)
+		pause->rx_pause = 1;
+	pause->autoneg = phy->fc_autoneg;
+}
+
+static int lan743x_set_pauseparam(struct net_device *dev,
+				  struct ethtool_pauseparam *pause)
+{
+	struct lan743x_adapter *adapter = netdev_priv(dev);
+	struct phy_device *phydev = dev->phydev;
+	struct lan743x_phy *phy = &adapter->phy;
+
+	if (!phydev)
+		return -ENODEV;
+
+	if (!phy_validate_pause(phydev, pause))
+		return -EINVAL;
+
+	phy->fc_request_control = 0;
+	if (pause->rx_pause)
+		phy->fc_request_control |= FLOW_CTRL_RX;
+
+	if (pause->tx_pause)
+		phy->fc_request_control |= FLOW_CTRL_TX;
+
+	phy->fc_autoneg = pause->autoneg;
+
+	if (pause->autoneg == AUTONEG_DISABLE)
+		lan743x_mac_flow_ctrl_set_enables(adapter, pause->tx_pause,
+						  pause->rx_pause);
+	else
+		phy_set_asym_pause(phydev, pause->rx_pause,  pause->tx_pause);
+
+	return 0;
+}
+
 const struct ethtool_ops lan743x_ethtool_ops = {
 	.get_drvinfo = lan743x_ethtool_get_drvinfo,
 	.get_msglevel = lan743x_ethtool_get_msglevel,
@@ -1259,6 +1303,8 @@ const struct ethtool_ops lan743x_ethtool_ops = {
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 	.get_regs_len = lan743x_get_regs_len,
 	.get_regs = lan743x_get_regs,
+	.get_pauseparam = lan743x_get_pauseparam,
+	.set_pauseparam = lan743x_set_pauseparam,
 #ifdef CONFIG_PM
 	.get_wol = lan743x_ethtool_get_wol,
 	.set_wol = lan743x_ethtool_set_wol,
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 50eeecba1f18..c0f8ba601c01 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1326,8 +1326,8 @@ static void lan743x_mac_close(struct lan743x_adapter *adapter)
 				 1, 1000, 20000, 100);
 }
 
-static void lan743x_mac_flow_ctrl_set_enables(struct lan743x_adapter *adapter,
-					      bool tx_enable, bool rx_enable)
+void lan743x_mac_flow_ctrl_set_enables(struct lan743x_adapter *adapter,
+				       bool tx_enable, bool rx_enable)
 {
 	u32 flow_setting = 0;
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 67877d3b6dd9..bc5eea4c7b40 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -1159,5 +1159,7 @@ u32 lan743x_csr_read(struct lan743x_adapter *adapter, int offset);
 void lan743x_csr_write(struct lan743x_adapter *adapter, int offset, u32 data);
 int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter, u16 timeout);
 void lan743x_hs_syslock_release(struct lan743x_adapter *adapter);
+void lan743x_mac_flow_ctrl_set_enables(struct lan743x_adapter *adapter,
+				       bool tx_enable, bool rx_enable);
 
 #endif /* _LAN743X_H */
-- 
2.25.1

