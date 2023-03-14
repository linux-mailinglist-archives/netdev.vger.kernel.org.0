Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3E36B8BA2
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjCNHDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCNHDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:03:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CFD9609F;
        Tue, 14 Mar 2023 00:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678777389; x=1710313389;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1nWorsSGRWXWuiAoTapdH2MmuicEAxvXwC63iQcogCY=;
  b=J3K/84qx90U5KN9gAwg9yl+fQd3m+cyTMIvzhfeSTttxEFPeU/zY3FK4
   itFJxslZ0hlJnk58Gavx9ogGh00w39ocYlYju2p3goqya2Bqbpxt1HEjC
   dpxL9rOO9ykMuzYrNyd9FMfmtl6wFhoe9WwNHEk4ijkDbj3Im4Arm7g52
   aqWkZGgU2jAHmzOuTUC+ZzrdYmtYcXcNWb1+OXK0xn0dnppGfU33vE1wH
   76MDYJf9XRcHdhwddWGbhdKemqRIm3Cni/00Feo7UgdznAqCX2KTlcScg
   g2XWTq4cEd01iPFScnaStnZATKd2I50LSapGdl9jhe6OE2XpOckX1HaSj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="334828512"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="334828512"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 00:02:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="656226758"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="656226758"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2023 00:02:39 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: [PATCH net v2 2/2] net: stmmac: move fixed-link support fixup code
Date:   Tue, 14 Mar 2023 15:02:08 +0800
Message-Id: <20230314070208.3703963-3-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xpcs_an_inband value is updated in the speed_mode_2500 function
which turns on the xpcs_an_inband mode.

Moving the fixed-link fixup code to right before phylink setup to
ensure no more fixup will affect the fixed-link mode configurations.

Fixes: 72edaf39fc65 ("stmmac: intel: add phy-mode and fixed-link ACPI _DSD setting support")
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c    | 11 -----------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 7deb1f817dac..d02db2b529b9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -592,17 +592,6 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 		plat->mdio_bus_data->xpcs_an_inband = true;
 	}
 
-	/* For fixed-link setup, we clear xpcs_an_inband */
-	if (fwnode) {
-		struct fwnode_handle *fixed_node;
-
-		fixed_node = fwnode_get_named_child_node(fwnode, "fixed-link");
-		if (fixed_node)
-			plat->mdio_bus_data->xpcs_an_inband = false;
-
-		fwnode_handle_put(fixed_node);
-	}
-
 	/* Ensure mdio bus scan skips intel serdes and pcs-xpcs */
 	plat->mdio_bus_data->phy_mask = 1 << INTEL_MGBE_ADHOC_ADDR;
 	plat->mdio_bus_data->phy_mask |= 1 << INTEL_MGBE_XPCS_ADDR;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 398adcd68ee8..6560aed95036 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7064,6 +7064,7 @@ int stmmac_dvr_probe(struct device *device,
 		     struct stmmac_resources *res)
 {
 	struct net_device *ndev = NULL;
+	struct fwnode_handle *fwnode;
 	struct stmmac_priv *priv;
 	u32 rxq;
 	int i, ret = 0;
@@ -7306,6 +7307,21 @@ int stmmac_dvr_probe(struct device *device,
 			goto error_xpcs_setup;
 	}
 
+	/* For fixed-link setup, we clear xpcs_an_inband */
+	fwnode = of_fwnode_handle(priv->plat->phylink_node);
+	if (!fwnode)
+		fwnode = dev_fwnode(priv->device);
+
+	if (fwnode) {
+		struct fwnode_handle *fixed_node;
+
+		fixed_node = fwnode_get_named_child_node(fwnode, "fixed-link");
+		if (fixed_node)
+			priv->plat->mdio_bus_data->xpcs_an_inband = false;
+
+		fwnode_handle_put(fixed_node);
+	}
+
 	ret = stmmac_phy_setup(priv);
 	if (ret) {
 		netdev_err(ndev, "failed to setup phy (%d)\n", ret);
-- 
2.34.1

