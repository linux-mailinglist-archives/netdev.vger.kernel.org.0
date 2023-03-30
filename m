Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A6E6CFEA4
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjC3Il2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjC3IlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:41:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDA66A58;
        Thu, 30 Mar 2023 01:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680165668; x=1711701668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=huOgNrOBcSC1/tjpitYzPeEN/HeYkrzn2WanLt9fM1M=;
  b=f6d55c35nedygYhOp9iyerUVYnL1y6vSUEWdV0WX16vLrwkw/rM7HgPT
   q8WxtGcARVvpqTBM66v9chp5HJjM2EbxfH+JkFilR2YGXzROm5QHN2/Gi
   AlCp37KO07oROpOSWAUjPhqIDh7DgJfKwkIgLRCeNn5bt+/5ZLYG8pEMl
   moa6XaAT9ng810UL6Tnzhi3pm1ZL0dmq/Tgw0SPg+G9gGrhMoVtFHTvY3
   meOffZBmPs7PyYBE6lyC4NMJAz1+4ZBRsrAXqSEOxNZE0xizZM4l8umc3
   efOf/URu/Mc+yykatC0X6WDfU3bPqJLL0rBiEu2UL5hEujb3Oo6eQbYSu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="343559508"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="343559508"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 01:41:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="684618854"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="684618854"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga002.jf.intel.com with ESMTP; 30 Mar 2023 01:41:02 -0700
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
Subject: [PATCH net v4 3/3] net: stmmac: remove redundant fixup to support fixed-link mode
Date:   Thu, 30 Mar 2023 16:40:00 +0800
Message-Id: <20230330084000.3292487-4-michael.wei.hong.sit@intel.com>
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

