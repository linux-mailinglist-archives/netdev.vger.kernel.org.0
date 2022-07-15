Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34020576128
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiGOMQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGOMQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:16:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0532F64A;
        Fri, 15 Jul 2022 05:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657887401; x=1689423401;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7orHDdnehrqRlxB1JS1kp4d9GAAR3NEIVdEeTd0qlyU=;
  b=FBCKb+lKdXa1G9mLXcrxiHjcCL4UsQ1NWWWnixyR5PM/4QPH9v4ML5Xs
   BCZ2hOUnYOnaCrHq6dPakjfSqZUJIA0Xk2eMy/V/o1JSVJg2vOyy58t/+
   ujZ2HMUxQfAOBWmSK4raEdY8QzkMrAm7cPPnlxn7rVQGMT9SbRrjyCbHR
   9mYupIVoLkzavOUokpFN5kQv+Nl2aNe4a/cC+tUNfyF4NVblPuDzWc1rw
   Arpc5GmaENFpREXwnnVFY6qZvEe6h55M6bVKpMg4ABC+/iTpGx1vPRdRJ
   6i392/PnRWQ27XDc7QmmnJWQqFBOAGZy9+lDrlWstbwQcG36E7B7wBR+m
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="285804401"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="285804401"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 05:16:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="723065193"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 15 Jul 2022 05:16:40 -0700
Received: from P12HL01TMIN.png.intel.com (P12HL01TMIN.png.intel.com [10.158.65.216])
        by linux.intel.com (Postfix) with ESMTP id DAE87580970;
        Fri, 15 Jul 2022 05:16:37 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>
Subject: [PATCH net 1/1] net: stmmac: remove redunctant disable xPCS EEE call
Date:   Fri, 15 Jul 2022 20:24:02 +0800
Message-Id: <20220715122402.1017470-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable is done in stmmac_init_eee() on the event of MAC link down.
Since setting enable/disable EEE via ethtool will eventually trigger
a MAC down, removing this redunctant call in stmmac_ethtool.c to avoid
calling xpcs_config_eee() twice.

Fixes: d4aeaed80b0e ("net: stmmac: trigger PCS to turn off on link down")
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index abfb3cd5958d..9c3055ee2608 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -803,14 +803,6 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 		netdev_warn(priv->dev,
 			    "Setting EEE tx-lpi is not supported\n");
 
-	if (priv->hw->xpcs) {
-		ret = xpcs_config_eee(priv->hw->xpcs,
-				      priv->plat->mult_fact_100ns,
-				      edata->eee_enabled);
-		if (ret)
-			return ret;
-	}
-
 	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
 
-- 
2.25.1

