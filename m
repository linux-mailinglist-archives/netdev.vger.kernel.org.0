Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B160D620CF5
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbiKHKNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbiKHKNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:13:14 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BECF2CDE9;
        Tue,  8 Nov 2022 02:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667902391; x=1699438391;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Q+z4Oczh9hybhrEfvobDCOfiNnJPSLx3QrNRxzi8Isk=;
  b=XLlEYi/WA9Nlvsn+91rXrpUdgPnf/JNXTQy5wChCcOlh/R/p2ctRTYt1
   MfVv5uKCzkmkFN+4Brr91FrLq4+HjW9hPCerbetUJPtfOy9KO6ASqAJiM
   QPQPDI5BeyZOKNQGWNQlCeOpsht5KC58rmJHR7ad4Sv7qv6EjqhTniUYU
   27dksRwQj6nj/942/lyDSBvDlheRm13qDsgGar27IJpioDOLef6/XU0zQ
   +kx/0uBPBNnZHmhgwa6rxqxn8zOoLsU6WA7tVHaO5zADc9RfQEhAV9c6L
   vGAtqeDbveNdHbRA8blRh0X3GoGL30wbIYohnRAHfYAIP0mc+zkbRQGhq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="372801825"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="372801825"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 02:13:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="881463548"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="881463548"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga006.fm.intel.com with ESMTP; 08 Nov 2022 02:13:07 -0800
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Gan Yi Fang <yi.fang.gan@intel.com>
Subject: [PATCH net 1/1] net: phy: dp83867: Fix SGMII FIFO depth for non OF devices
Date:   Tue,  8 Nov 2022 18:12:18 +0800
Message-Id: <20221108101218.612499-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current driver code will read device tree node information,
and set default values if there is no info provided.

This is not done in non-OF devices leading to SGMII fifo depths being
set to the smallest size.

This patch sets the value to the default value of the PHY as stated in the
PHY datasheet.

Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/phy/dp83867.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 6939563d3b7c..fb7df4baaf6f 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -682,6 +682,13 @@ static int dp83867_of_init(struct phy_device *phydev)
 	 */
 	dp83867->io_impedance = DP83867_IO_MUX_CFG_IO_IMPEDANCE_MIN / 2;
 
+	/* For non-OF device, the RX and TX FIFO depths are taken from
+	 * default value. So, we init RX & TX FIFO depths here
+	 * so that it is configured correctly later in dp83867_config_init();
+	 */
+	dp83867->tx_fifo_depth = DP83867_PHYCR_FIFO_DEPTH_4_B_NIB;
+	dp83867->rx_fifo_depth = DP83867_PHYCR_FIFO_DEPTH_4_B_NIB;
+
 	return 0;
 }
 #endif /* CONFIG_OF_MDIO */
-- 
2.34.1

