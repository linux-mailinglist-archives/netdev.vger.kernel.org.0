Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687826221EC
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiKIC1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiKIC1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:27:06 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675A95E3F6;
        Tue,  8 Nov 2022 18:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667960825; x=1699496825;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jpaNDrFwzMZ2iLH1l1kbK43THTPUMBLW8XKIRWONvtQ=;
  b=IitEZemphTvLzxWmsU43KH+BpKxaJA5vQCHuwwvwKCCNktL0wEBcYgzF
   KuHoqQaMe5jukg+9EN3uP8viynRN5n33RQOdqyDhbNLoCOYcT7vnoUEQJ
   lm+MuYr8SJnTB7j3GdodJlvwi/9fyKQr9yZs+iT7blntv7y5235l4hSGW
   zScLd9IHh8SH7ZuF408c2F+2vQrbeo56VnpyXnvG9V8Y6zJVNX2QxmK4w
   DY8OkPojfqawbp/pUjonMizH/pNa8Izsvi71npWMn+JJr6BvAvhuITlrD
   Y9TCa3I2TC+bNfCTUIGkjeTXYTPIFrMW0VBCQ7zSr4qQysIlCdYOKhWFY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="310865200"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="310865200"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 18:27:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="881748275"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="881748275"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga006.fm.intel.com with ESMTP; 08 Nov 2022 18:27:02 -0800
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
Subject: [PATCH net v2 1/1] net: phy: dp83867: Fix SGMII FIFO depth for non OF devices
Date:   Wed,  9 Nov 2022 10:26:29 +0800
Message-Id: <20221109022629.615015-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
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

Fixes: 4dc08dcc9f6f ("net: phy: dp83867: introduce critical chip default init for non-of platform")
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
v1->v2:
- Add Fixes tag to commit message
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

