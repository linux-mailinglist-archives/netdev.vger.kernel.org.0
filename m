Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB60C606FB8
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJUF5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiJUF5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:57:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1182D1EEF25;
        Thu, 20 Oct 2022 22:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666331825; x=1697867825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xiOMvkgMSVV2l1xLp70m3sIVhMwsGVmwEzz/klMT5DQ=;
  b=SC0POtKfL2r374hje0cM4opwvNycrhMyNnaj/TbxAvAtvWbCFw+SOtbD
   Bl+qzU066KF3uW0jIRWItP1bLOYpotgdDPD/5SIoIJ94eNnngrXR5bP11
   0RSnKb+bDKSs8PcWR/RWp+PS1ZHNcHnfnYFDF1txhmFx/WxXDVICtnWoQ
   CbqxZdjvC1phg1ZwSP6p8pGbi40K+RZtt5xhU91OzgUehkSTqJJoGZhNG
   w12WaBGXYgfed/BPWPjBhogd9Ccm8ShkQ/G5q7a1vgap2BvPxaVY89AQV
   8fYDlw64IEEik9dsboVlOXqOPK0can26ih5KgcXzt6RpVfLW5HmsD+2QV
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="183277544"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Oct 2022 22:57:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 20 Oct 2022 22:57:04 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 20 Oct 2022 22:57:00 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 1/2] net: lan743x: Add support for get_pauseparam and set_pauseparam
Date:   Fri, 21 Oct 2022 11:26:41 +0530
Message-ID: <20221021055642.255413-2-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021055642.255413-1-Raju.Lakkaraju@microchip.com>
References: <20221021055642.255413-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pause get and set functions

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 .../net/ethernet/microchip/lan743x_ethtool.c  | 46 +++++++++++++++++++
 drivers/net/ethernet/microchip/lan743x_main.c |  4 +-
 drivers/net/ethernet/microchip/lan743x_main.h |  2 +
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index c739d60ee17d..44c98715eb17 100644
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
+	phy_set_asym_pause(phydev, pause->rx_pause,  pause->tx_pause);
+
+	if (pause->autoneg == AUTONEG_DISABLE)
+		lan743x_mac_flow_ctrl_set_enables(adapter, pause->tx_pause,
+						  pause->rx_pause);
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

