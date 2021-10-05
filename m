Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E9A422588
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhJELqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:46:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:50770 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233672AbhJELqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 07:46:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="248977238"
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="248977238"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 04:44:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="712206594"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga006.fm.intel.com with ESMTP; 05 Oct 2021 04:44:56 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id ABAC45805EE;
        Tue,  5 Oct 2021 04:44:52 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Wong Vee Khee <veekhee@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net 1/2] net: pcs: xpcs: fix incorrect steps on disable EEE
Date:   Tue,  5 Oct 2021 19:50:59 +0800
Message-Id: <20211005115100.1648170-2-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005115100.1648170-1-vee.khee.wong@linux.intel.com>
References: <20211005115100.1648170-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When Energy-Efficient Ethernet(EEE) is disable from the MAC side,
we need to clear the DW_VR_MII_EEE_TRN_LPI bit of DW_VR_MII_EEE_MCTRL1
register.

Fixes: 7617af3d1a5e ("net: pcs: Introducing support for DWC xpcs Energy Efficient Ethernet")
Cc: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/pcs/pcs-xpcs.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index fb0a83dc09ac..59ebb0c0d86f 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -666,6 +666,10 @@ int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 {
 	int ret;
 
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL0);
+	if (ret < 0)
+		return ret;
+
 	if (enable) {
 	/* Enable EEE */
 		ret = DW_VR_MII_EEE_LTX_EN | DW_VR_MII_EEE_LRX_EN |
@@ -673,9 +677,6 @@ int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 		      DW_VR_MII_EEE_TX_EN_CTRL | DW_VR_MII_EEE_RX_EN_CTRL |
 		      mult_fact_100ns << DW_VR_MII_EEE_MULT_FACT_100NS_SHIFT;
 	} else {
-		ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL0);
-		if (ret < 0)
-			return ret;
 		ret &= ~(DW_VR_MII_EEE_LTX_EN | DW_VR_MII_EEE_LRX_EN |
 		       DW_VR_MII_EEE_TX_QUIET_EN | DW_VR_MII_EEE_RX_QUIET_EN |
 		       DW_VR_MII_EEE_TX_EN_CTRL | DW_VR_MII_EEE_RX_EN_CTRL |
@@ -690,7 +691,11 @@ int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 	if (ret < 0)
 		return ret;
 
-	ret |= DW_VR_MII_EEE_TRN_LPI;
+	if (enable)
+		ret |= DW_VR_MII_EEE_TRN_LPI;
+	else
+		ret &= ~DW_VR_MII_EEE_TRN_LPI;
+
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL1, ret);
 }
 EXPORT_SYMBOL_GPL(xpcs_config_eee);
-- 
2.25.1

