Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21064623C2D
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 07:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiKJG4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 01:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKJG4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 01:56:41 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C681570B;
        Wed,  9 Nov 2022 22:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668063400; x=1699599400;
  h=from:to:cc:subject:date:message-id;
  bh=Mwsy1axZV+PTNKiw6w+BLcbXyV1HVAU1m3qtT1Ss6a8=;
  b=Cm0+HXoqkqYmKZ1uEeSxEj4e/0WNl1V4+NOmhADuQDn0ylRfLeB8W+6v
   oLt0WMAL6XD6yZs/+H5NYz+U778Q6BKsuI55JT9rNRmNuapPOTz+uF1r3
   kucBfQPqur6xtjwBqhBxottYYn/SwM/wgBc9nUUHRFq8/Zrsv3jgt4reR
   jZOWdYg7MFf5JViwLzYBIMtCeCO8SARrVbBIg4f0tswr+daEmYFXn7kj+
   tEQN+REkhOVtexaWstbzg13F318uvmBBssU+PupCRxET/sEYLB+Xq4/Aq
   NHYLIHy8uMj2OrJsJD8Za49jqpdL1VGPtyUVAOjynVBlorPHbWjFalSWj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="290950751"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="290950751"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 22:56:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="588061142"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="588061142"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 09 Nov 2022 22:56:39 -0800
Received: from noorazur1-iLBPG12.png.intel.com (noorazur1-iLBPG12.png.intel.com [10.88.229.87])
        by linux.intel.com (Postfix) with ESMTP id 6417A580C99;
        Wed,  9 Nov 2022 22:56:35 -0800 (PST)
From:   Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Song Yoong Siang <yoong.siang.song@intel.com>,
        Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>
Subject: [PATCH net 1/1] net: stmmac: ensure tx function is not running in stmmac_xdp_release()
Date:   Thu, 10 Nov 2022 14:45:52 +0800
Message-Id: <20221110064552.22504-1-noor.azura.ahmad.tarmizi@linux.intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>

When stmmac_xdp_release() is called, there is a possibility that tx
function is still running on other queues which will lead to tx queue
timed out and reset adapter.

This commit ensure that tx function is not running xdp before release
flow continue to run.

Fixes: ac746c8520d9 ("net: stmmac: enhance XDP ZC driver level switching performance")
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>
Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8273e6a175c8..6b43da78cdf0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6548,6 +6548,9 @@ void stmmac_xdp_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	/* Ensure tx function is not running */
+	netif_tx_disable(dev);
+
 	/* Disable NAPI process */
 	stmmac_disable_all_queues(priv);
 
-- 
2.17.1

