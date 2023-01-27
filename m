Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A3767E833
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjA0O0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbjA0O0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:26:32 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80F9BA5F7;
        Fri, 27 Jan 2023 06:26:26 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,251,1669042800"; 
   d="scan'208";a="147645291"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 27 Jan 2023 23:26:25 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id B8FAF433ACC5;
        Fri, 27 Jan 2023 23:26:25 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v4 1/4] net: phylink: Set host_interfaces for a non-sfp PHY
Date:   Fri, 27 Jan 2023 23:26:18 +0900
Message-Id: <20230127142621.1761278-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a new flag (ovr_host_interfaces) in the phylink_config is set,
overwrite the host_interfaces in the phy_device by link_interface.

Note that an ethernet PHY driver like marvell10g will check
PHY_INTERFACE_MODE_SGMII in the host_interfaces whther the host
controller supports a rate matching interface mode or not. So, set
PHY_INTERFACE_MODE_SGMII to the host_interfaces if it is set in
the supported_interfaces.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/phy/phylink.c | 11 +++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 319790221d7f..dee64b4a1175 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1814,6 +1814,17 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 		pl->link_config.interface = pl->link_interface;
 	}
 
+	if (pl->config->ovr_host_interfaces) {
+		__set_bit(pl->link_interface, phy_dev->host_interfaces);
+
+		/* An ethernet PHY driver will check PHY_INTERFACE_MODE_SGMII
+		 * in the host_interfaces whether the host controller supports
+		 * a rate matching interface mode or not.
+		 */
+		if (test_bit(PHY_INTERFACE_MODE_SGMII, pl->config->supported_interfaces))
+			__set_bit(PHY_INTERFACE_MODE_SGMII, phy_dev->host_interfaces);
+	}
+
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
 	if (ret) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index c492c26202b5..c8dd53b1e857 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -124,6 +124,8 @@ enum phylink_op_type {
  *		      if MAC link is at %MLO_AN_FIXED mode.
  * @mac_managed_pm: if true, indicate the MAC driver is responsible for PHY PM.
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
+ * @ovr_host_interfaces: if true, override host_interfaces of phy_device from
+ *			 link_interface.
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
  * @supported_interfaces: bitmap describing which PHY_INTERFACE_MODE_xxx
@@ -137,6 +139,7 @@ struct phylink_config {
 	bool poll_fixed_state;
 	bool mac_managed_pm;
 	bool ovr_an_inband;
+	bool ovr_host_interfaces;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
 	DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
-- 
2.25.1

