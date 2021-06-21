Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C372F3AE65D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 11:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFUJs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 05:48:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:3858 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230332AbhFUJsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 05:48:22 -0400
IronPort-SDR: 3mML0K9elmusekbyW7XbPPoH+uXZwXM079Pm4o+ggfVDqY1D+zRnD3eYEwIOzVIe/v5x/BdfEU
 9Qq1/ilOf8Tw==
X-IronPort-AV: E=McAfee;i="6200,9189,10021"; a="194122128"
X-IronPort-AV: E=Sophos;i="5.83,289,1616482800"; 
   d="scan'208";a="194122128"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 02:46:08 -0700
IronPort-SDR: 70Om74wC96WXY6QQq1oNOcC15HXQ8DTOvYgVhomis9iwl7xy2CbKm5/do2wcd0Si3LN/kHX9wu
 uNvofljvB6jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,289,1616482800"; 
   d="scan'208";a="638720304"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jun 2021 02:46:04 -0700
From:   Ling Pei Lee <pei.lee.ling@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     pei.lee.ling@intel.com
Subject: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL settings in stmmac_resume()
Date:   Mon, 21 Jun 2021 17:45:35 +0800
Message-Id: <20210621094536.387442-4-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621094536.387442-1-pei.lee.ling@intel.com>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

After PHY received a magic packet, the PHY WOL event will be
triggered then PHY WOL event interrupt will be disarmed.
Ethtool settings will remain with WOL enabled after a S3/S4
suspend resume cycle as expected. Hence,the driver should
reconfigure the PHY settings to reenable/disable WOL
depending on the ethtool WOL settings in the resume flow.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Co-developed-by: Ling Pei Lee <pei.lee.ling@intel.com>
Signed-off-by: Ling Pei Lee <pei.lee.ling@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a3b79ddcf08e..cd96e4d7a22e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7246,6 +7246,16 @@ int stmmac_resume(struct device *dev)
 		phylink_start(priv->phylink);
 		/* We may have called phylink_speed_down before */
 		phylink_speed_up(priv->phylink);
+		/* Reconfigure PHY WOL if the WOL is enabled in ethtool,
+		 * so that subsequent WOL still can be triggered.
+		 */
+		if (!priv->plat->pmt) {
+			struct ethtool_wolinfo phy_wol = { .cmd = ETHTOOL_GWOL };
+
+			phylink_ethtool_get_wol(priv->phylink, &phy_wol);
+			if (phy_wol.wolopts)
+				phylink_ethtool_set_wol(priv->phylink, &phy_wol);
+		}
 		rtnl_unlock();
 	}
 
-- 
2.25.1

