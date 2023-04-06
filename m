Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351486D8DA7
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbjDFCtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbjDFCth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:49:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C69AD3A;
        Wed,  5 Apr 2023 19:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680749204; x=1712285204;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OYFGzpPYLI2q69hmtLhmRnE7jbvoO6JpkJESOEl3xDA=;
  b=CyabcphvFd/lpg25lY7l0vdTe4qDlNWr2NqJjYhNyMdp4070WZnEJ2Rw
   rrVj/N/ZsYajjterDP9gY2bt/6giOUng89fsgt1I/U9OHJmP1+X6Ja8Ec
   9mDHFYOlLApILSUgZG5XfzzHkeJGthMvQ1ztrWuTdOhmDQvEzJ0sUUwL6
   Z5OAxlicBe9RtBDLeM0H8cizw5/9v4/3kYhcG3EDWSmlzsNUFPfnFCROY
   9/MEPrkQnTtZSUbriwMXvn0SbLRn/FdwRpoZXHc60xLMVJnVetu/B1jPc
   BWZNrfvo4uvshgjlP+CPOqPQYdsC4y/AfQldSj3EDggYOugpGwSSyA5tl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="345217309"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="345217309"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 19:46:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="810830733"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="810830733"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga004.jf.intel.com with ESMTP; 05 Apr 2023 19:46:37 -0700
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
Subject: [RESEND PATCH net 1/1] net: stmmac: check fwnode for phy device before scanning for phy
Date:   Thu,  6 Apr 2023 10:45:41 +0800
Message-Id: <20230406024541.3556305-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=AC_FROM_MANY_DOTS,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some DT devices already have phy device configured in the DT/ACPI.
Current implementation scans for a phy unconditionally even though
there is a phy listed in the DT/ACPI and already attached.

We should check the fwnode if there is any phy device listed in
fwnode and decide whether to scan for a phy to attach to.

Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY")
Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/lkml/20230403212434.296975-1-martin.blumenstingl@googlemail.com/
Tested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Shahab Vahedi <shahab@synopsys.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
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

