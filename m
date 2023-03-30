Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8865C6CFE9D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjC3IlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjC3IlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:41:04 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515895B8E;
        Thu, 30 Mar 2023 01:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680165661; x=1711701661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h7HA31Ype249VhePLWHGaLt81vSRMT92v7O/eTwjq3g=;
  b=VAWJm/ZL8ZPWgg5xkolKEarQn99rpgzVtU2agtiEfdlnRGbU0jgfGXDL
   bMZAWs9HUc933/CaZueJDssflpNEvogifOHwKz0kIzrqO15Lfkdewb6hs
   yK27b3k5auieHuiediUxR7flBkLSo7sWwNvKrTKhRy8rcxyUtjxXjL+aO
   y0MVQXOrTFtP/2OCI6QkAS8bzscQ1G0Psv9q3GuFGlawy5IY3uqKCqKYf
   Rkos5F+8uLDXPC+UBlvpW6TdL7oxvUXxwZgfNn/6shJ/YcasovMMwscJI
   CO5mvnfp3RRE6J0VXYz2u4d41qzmV+f8kdTI562G9NPr4tlNq3k/MbnMk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="343559450"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="343559450"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 01:41:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="684618839"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="684618839"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga002.jf.intel.com with ESMTP; 30 Mar 2023 01:40:57 -0700
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
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: [PATCH net v4 2/3] net: stmmac: check if MAC needs to attach to a PHY
Date:   Thu, 30 Mar 2023 16:39:59 +0800
Message-Id: <20230330084000.3292487-3-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330084000.3292487-1-michael.wei.hong.sit@intel.com>
References: <20230330084000.3292487-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the introduction of the fixed-link support, the MAC driver
no longer attempt to scan for a PHY to attach to. This causes the
non fixed-link setups to stop working.

Using the phylink_expects_phy() to check and determine if the MAC
should expect and attach a PHY.

Fixes: ab21cf920928 ("net: stmmac: make mdio register skips PHY scanning for fixed-link")
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8f543c3ab5c5..41f0f3b74933 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1135,6 +1135,7 @@ static int stmmac_init_phy(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct fwnode_handle *fwnode;
+	bool phy_needed;
 	int ret;
 
 	fwnode = of_fwnode_handle(priv->plat->phylink_node);
@@ -1144,10 +1145,11 @@ static int stmmac_init_phy(struct net_device *dev)
 	if (fwnode)
 		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
 
+	phy_needed = phylink_expects_phy(priv->phylink);
 	/* Some DT bindings do not set-up the PHY handle. Let's try to
 	 * manually parse it
 	 */
-	if (!fwnode || ret) {
+	if (!fwnode || phy_needed || ret) {
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
-- 
2.34.1

