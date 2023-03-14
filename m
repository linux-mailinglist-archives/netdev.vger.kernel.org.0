Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477326B8B9F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCNHDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjCNHDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:03:05 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF7E22102;
        Tue, 14 Mar 2023 00:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678777383; x=1710313383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+jXWOkuHIz7opU+/4fOqwtDaqYNzAOX5btGkyFBkb6Q=;
  b=UTDPJff9j10QBP0fIL6mvJ5r2wNbpLxVl9V4cWNUItw8KPut9DuWqrp2
   XxJB56+aY3+DAUn9SM7V1IpZf5/pN39q2R5gFBjfjc8IRVnrOGiihgQPw
   ICQStGnUucMXkUVzm2DuVSmBOrdMgD/HJzzMBOFD7i1GS8E+jP8cvkGOA
   ZGJk82b3DW9wByR7/zNRgvGCqTNFyMdCEDdMoAubqdbDjiptd7K6h1J+k
   df0ZOzfci8O6aMRI8FaX+GkbsTi5jd8FCFTRp6U3oPFt5IYjR+WSgmaC0
   RJ6fuDuCZaUuuDIUYjwy1D6Ph0x7Xgp2k9QTdiEn3r3hCpOIfXA9ijTko
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="334828457"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="334828457"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 00:02:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="656226744"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="656226744"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2023 00:02:34 -0700
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
Subject: [PATCH net v2 1/2] net: stmmac: fix PHY handle parsing
Date:   Tue, 14 Mar 2023 15:02:07 +0800
Message-Id: <20230314070208.3703963-2-michael.wei.hong.sit@intel.com>
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

phylink_fwnode_phy_connect returns 0 when set to MLO_AN_INBAND.
This causes the PHY handle parsing to skip and the PHY will not be attached
to the MAC.

Add additional check for PHY handle parsing when set to MLO_AN_INBAND.

Fixes: ab21cf920928 ("net: stmmac: make mdio register skips PHY scanning for fixed-link")
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8f543c3ab5c5..398adcd68ee8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1134,6 +1134,7 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
 static int stmmac_init_phy(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	struct fwnode_handle *fixed_node;
 	struct fwnode_handle *fwnode;
 	int ret;
 
@@ -1141,13 +1142,16 @@ static int stmmac_init_phy(struct net_device *dev)
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
 
-	if (fwnode)
+	if (fwnode) {
+		fixed_node = fwnode_get_named_child_node(fwnode, "fixed-link");
+		fwnode_handle_put(fixed_node);
 		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
+	}
 
 	/* Some DT bindings do not set-up the PHY handle. Let's try to
 	 * manually parse it
 	 */
-	if (!fwnode || ret) {
+	if (!fwnode || ret || !fixed_node) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
-- 
2.34.1

