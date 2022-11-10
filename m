Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B640623B7A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 06:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiKJFub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 00:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKJFu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 00:50:29 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A152186D7;
        Wed,  9 Nov 2022 21:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668059429; x=1699595429;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jpaNDrFwzMZ2iLH1l1kbK43THTPUMBLW8XKIRWONvtQ=;
  b=iLg5nbLJ/uy01SpvOJ7gNLcVP2YPxfdnZQbYI2u5qhMyZ2tuRrs7C45w
   jOBVjk7jWZ3tiTfbaGrdnNNI4stxZKzOnd+U3XM4TXw3XmfyzbxPaSuyB
   hRaTk5Df9Jd2Ma6ajBF7cRSGpZznXo7ED3AjSoafqBpCXKCrnJYsS2QB3
   /pLoDt7hHXkQ4ghM10Y0g5gczPRrUY1w0kNhurPSSYwPoi7ZmiMcaYvVH
   qUVGodAAULxhjmuhHtuJ2ZA5JzbVL8hdbadOzhvuOuCsbttij11//jwof
   hiOivzTddM6X8s48jM5p542WIrZJSGsXyAgG3tIgZxfMa74vIQkvKRekL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="298713473"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="298713473"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 21:50:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="631529192"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="631529192"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga007.jf.intel.com with ESMTP; 09 Nov 2022 21:50:23 -0800
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tan Tee Min <tee.min.tan@intel.com>
Cc:     Lay Kuan Loon <kuan.loon.lay@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Gan Yi Fang <yi.fang.gan@intel.com>
Subject: [PATCH net v2 RESEND 1/1] net: phy: dp83867: Fix SGMII FIFO depth for non OF devices
Date:   Thu, 10 Nov 2022 13:49:38 +0800
Message-Id: <20221110054938.925347-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

