Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C9F42B809
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238126AbhJMGzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:55:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:41478 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231495AbhJMGzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 02:55:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="224801994"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="224801994"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 23:53:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="626229936"
Received: from glass.png.intel.com ([10.158.65.69])
  by fmsmga001.fm.intel.com with ESMTP; 12 Oct 2021 23:53:31 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lay Kuan Loon <kuan.loon.lay@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>
Subject: [PATCH net-next v2 1/1] net: phy: dp83867: introduce critical chip default init for non-of platform
Date:   Wed, 13 Oct 2021 14:59:41 +0800
Message-Id: <20211013065941.2124858-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013065941.2124858-1-boon.leong.ong@intel.com>
References: <20211013065941.2124858-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Lay, Kuan Loon" <kuan.loon.lay@intel.com>

PHY driver dp83867 has rich supports for OF-platform to fine-tune the PHY
chip during phy configuration. However, for non-OF platform, certain PHY
tunable parameters such as IO impedance and RX & TX internal delays are
critical and should be initialized to its default during PHY driver probe.

Tested-by: Clement <clement@intel.com>
Signed-off-by: Lay, Kuan Loon <kuan.loon.lay@intel.com>
Co-developed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/phy/dp83867.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 6bbc81ad295f..914619f3f0e3 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -619,6 +619,25 @@ static int dp83867_of_init(struct phy_device *phydev)
 #else
 static int dp83867_of_init(struct phy_device *phydev)
 {
+	struct dp83867_private *dp83867 = phydev->priv;
+	u16 delay;
+
+	/* For non-OF device, the RX and TX ID values are either strapped
+	 * or take from default value. So, we init RX & TX ID values here
+	 * so that the RGMIIDCTL is configured correctly later in
+	 * dp83867_config_init();
+	 */
+	delay = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RGMIIDCTL);
+	dp83867->rx_id_delay = delay & DP83867_RGMII_RX_CLK_DELAY_MAX;
+	dp83867->tx_id_delay = (delay >> DP83867_RGMII_TX_CLK_DELAY_SHIFT) &
+			       DP83867_RGMII_TX_CLK_DELAY_MAX;
+
+	/* Per datasheet, IO impedance is default to 50-ohm, so we set the
+	 * same here or else the default '0' means highest IO impedance
+	 * which is wrong.
+	 */
+	dp83867->io_impedance = DP83867_IO_MUX_CFG_IO_IMPEDANCE_MIN / 2;
+
 	return 0;
 }
 #endif /* CONFIG_OF_MDIO */
-- 
2.25.1

