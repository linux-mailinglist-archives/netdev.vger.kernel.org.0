Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFCA6D5BA4
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjDDJP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbjDDJP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:15:56 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1D41A7;
        Tue,  4 Apr 2023 02:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680599755; x=1712135755;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=c3TWM/U7ae/+krBKWKZnTGu8xrMC3rbZUK6++vwlxtY=;
  b=b7yuJDj6TtQ6TcoPe/S0KVJYushwCH4iX8SyI7bepbqf4yQMXCljYqVi
   qn9Byf2j5hcTEPZG6jCKsJ8YTW3H1NWuPyHoOd0mPdIOMi65jnnbqCApg
   CkNdt9LQZOhRr8nzqhFYyDf+o+NAH9AOjlPoopH8OkZfwon8tRJVCJfS2
   +1631Pydg8DGa9btbzHCTu4A8e47YOYbgH/OCVns2TNtHx2EJxZ9Py8Kk
   l82qLfoqKLTDRJz7s5GR0NeIS3sysBWoWmyxKF1XVZU5hbVbT5IBaHYWB
   1RPnzqr8REwgfnKapyxTBsD4D4exejeYZ84A49tq+Se5FpHyt4sywEp6I
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="404893346"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="404893346"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 02:15:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="663513778"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="663513778"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga006.jf.intel.com with ESMTP; 04 Apr 2023 02:15:46 -0700
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
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        hock.leong.kweh@intel.com
Subject: [RFC net 1/1] net: stmmac: skip PHY scanning when PHY already attached in DT mode
Date:   Tue,  4 Apr 2023 17:14:42 +0800
Message-Id: <20230404091442.3540092-1-michael.wei.hong.sit@intel.com>
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

If PHY is successfully attached during phylink_fwnode_phy_connect()
in DT mode. MAC should not need to scan for PHY again.

Adding a logic to check if ovr_an_inband is set before scanning for
a PHY, since phylink_fwnode_phy_connect() returns 0 when

	phy_fwnode = fwnode_get_phy_node(fwnode);
	if (IS_ERR(phy_fwnode)) {
		if (pl->cfg_link_an_mode == MLO_AN_PHY)
			return -ENODEV;
		return 0;
	}

Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY")
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d41a5f92aee7..4b8d3d975678 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1149,7 +1149,7 @@ static int stmmac_init_phy(struct net_device *dev)
 	/* Some DT bindings do not set-up the PHY handle. Let's try to
 	 * manually parse it
 	 */
-	if (!fwnode || phy_needed || ret) {
+	if (!fwnode || (phy_needed && priv->phylink_config.ovr_an_inband) || ret) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
-- 
2.34.1

