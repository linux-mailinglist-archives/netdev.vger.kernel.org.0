Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695FF6CFF94
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjC3JPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjC3JPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:15:11 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D181725;
        Thu, 30 Mar 2023 02:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680167711; x=1711703711;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=huOgNrOBcSC1/tjpitYzPeEN/HeYkrzn2WanLt9fM1M=;
  b=IpTEKYwGsNCmDfvRJ4l+2fKVPpam/IbzdwD9tH+xoWfO11WzLcfoc0DK
   3scx2rSn7TnxxYHaOrACjqBdBJMyksUccWfmx6fehFP5V0Rj9DdEVGtBr
   LeP1JNuPnAOxRPMWoo7QW2H3UIX/m1j42gd0/VGcK2whMEkDg1OjImL0D
   6f1J13trAZeEIO1HH2/IDb1RcphzBkFrPq8hVbLLjbGxUrotCLw/ilGbk
   wuFqPxRvDa7rGavcqi1rjANQBXEEXvUXoLLMXHXsXlAkIx6yMQ88xvmaG
   oNEzth/eZtGQbYg3JqXSoao+Ip3hQDl1pNKVB+gc67uwSbXtIH6DPLQvx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="325038919"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="325038919"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 02:15:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="678125447"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="678125447"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga007.jf.intel.com with ESMTP; 30 Mar 2023 02:15:04 -0700
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
Subject: [PATCH net v5 3/3] net: stmmac: remove redundant fixup to support fixed-link mode
Date:   Thu, 30 Mar 2023 17:14:04 +0800
Message-Id: <20230330091404.3293431-4-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330091404.3293431-1-michael.wei.hong.sit@intel.com>
References: <20230330091404.3293431-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, intel_speed_mode_2500() will fix-up xpcs_an_inband
to 1 if the underlying controller has a max speed of 1000Mbps.
The value has been initialized and modified if it is
a fixed-linked setup earlier.

This patch removes the fix-up to allow for fixed-linked setup
support. In stmmac_phy_setup(), ovr_an_inband is set based on
the value of xpcs_an_inband. Which in turn will return an
error in phylink_parse_mode() where MLO_AN_FIXED and
ovr_an_inband are both set.

Fixes: c82386310d95 ("stmmac: intel: prepare to support 1000BASE-X phy interface setting")
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 7deb1f817dac..6db87184bf75 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -251,7 +251,6 @@ static void intel_speed_mode_2500(struct net_device *ndev, void *intel_data)
 		priv->plat->mdio_bus_data->xpcs_an_inband = false;
 	} else {
 		priv->plat->max_speed = 1000;
-		priv->plat->mdio_bus_data->xpcs_an_inband = true;
 	}
 }
 
-- 
2.34.1

