Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312B16D7897
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbjDEJkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237241AbjDEJkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:40:45 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F13E45;
        Wed,  5 Apr 2023 02:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680687645; x=1712223645;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=j2wLczm2nFwPGcSlgIhpmPN4wo/22EWlYYEkPAuG1Rw=;
  b=CA7oKOayTqedHe+F6KHDRMyImZFcYd/xpcweZuzysu5AQbVr5O/iCw2n
   pmkpXsrjrVlApBzveT1MKlAV2Kihjy/6qXEZOeGDlvsfQGr5N2LqViJid
   DxDJaL01ah3Bqw5T1NXXjiXrioSfiErmrSiA/V7/BPhiA6kRsqg1bi8Xu
   ERs1Z1xAcNLT5PScNCVyNFB27XN/8MPC6ie+RXwQqb6FOyeHhPxI6Db49
   x7p9fRIaamXHJfrJXGkv9BpP3oPzTHSjWByNMGG91sLGZAyJNY4SCl3u6
   s/FzSKl+7LE0sW7bXE34LwCg4LurI2vtsJDazdIb8CYHXB70t8jwpeeLK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="326444996"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="326444996"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 02:40:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="830300798"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="830300798"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga001.fm.intel.com with ESMTP; 05 Apr 2023 02:40:37 -0700
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
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        hock.leong.kweh@intel.com
Subject: [PATCH net 1/1] net: stmmac: check fwnode for phy device before scanning for phy
Date:   Wed,  5 Apr 2023 17:39:45 +0800
Message-Id: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.8 required=5.0 tests=AC_FROM_MANY_DOTS,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some DT devices already have phy device configured in the DT/ACPI.
Current implementation scans for a phy unconditionally even though
there is a phy listed in the DT/ACPI and already attached.

We should check the fwnode if there is any phy device listed in
fwnode and decide whether to scan for a phy to attach to.y

Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY")
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d41a5f92aee7..7ca9be7bec06 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1134,22 +1134,26 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
 static int stmmac_init_phy(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	struct fwnode_handle *phy_fwnode;
 	struct fwnode_handle *fwnode;
-	bool phy_needed;
 	int ret;
 
+	if (!phylink_expects_phy(priv->phylink))
+		return 0;
+
 	fwnode = of_fwnode_handle(priv->plat->phylink_node);
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
 
 	if (fwnode)
-		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
+		phy_fwnode = fwnode_get_phy_node(fwnode);
+	else
+		phy_fwnode = NULL;
 
-	phy_needed = phylink_expects_phy(priv->phylink);
 	/* Some DT bindings do not set-up the PHY handle. Let's try to
 	 * manually parse it
 	 */
-	if (!fwnode || phy_needed || ret) {
+	if (!phy_fwnode || IS_ERR(phy_fwnode)) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
@@ -1165,6 +1169,9 @@ static int stmmac_init_phy(struct net_device *dev)
 		}
 
 		ret = phylink_connect_phy(priv->phylink, phydev);
+	} else {
+		fwnode_handle_put(phy_fwnode);
+		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
 	}
 
 	if (!priv->plat->pmt) {
-- 
2.34.1

