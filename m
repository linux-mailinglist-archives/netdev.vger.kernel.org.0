Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58ABC6436CD
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiLEVZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbiLEVYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:24:34 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E402CC9B
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 13:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670275472; x=1701811472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KrbsVa8eUOxbJHkSUXxkG6BZ9Kz0dfFGFSeLDcSumXw=;
  b=d4EMD50fNebIvBcNcjjPWVv0u6x7tjYoHuVqHs4HKxqP1Mu/5WxWOYdP
   SY/abRDKUbN3ekOan+A70E/erBbXdMlyjuokMWFknyp1+99lT6nuv9rIO
   4U0+bShY49z4k/E5dbS1ljuZqbhNV4IDPEd4FEQUhInmzDWoio5WYOWFd
   7yIickJR2TAlCqL6Sx0jzZPJScfC8FXAhbqSOxxQEIcz95d0WJAgTBw1n
   a9IWWShyM8xqN3wSaqnppunGs6jo+ch3an8bqL6fVr7fUCLgS6NISrmlE
   uf3mcqwC73SRSWRV5CqHA/UT2YWSAdgXalxrP9XzQhrM6cgZdCebg/IG3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="296157820"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="296157820"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 13:24:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734744966"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="734744966"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Dec 2022 13:24:29 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tan Tee Min <tee.min.tan@linux.intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 5/8] igc: enable Qbv configuration for 2nd GCL
Date:   Mon,  5 Dec 2022 13:24:11 -0800
Message-Id: <20221205212414.3197525-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
References: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tan Tee Min <tee.min.tan@linux.intel.com>

Make reset task only executes for i225 and Qbv disabling to allow
i226 configure for 2nd GCL without resetting the adapter.

In i226, Tx won't hang if there is a GCL is already running, so in
this case we don't need to set FutScdDis bit.

Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c |  9 +++++----
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 13 +++++++++----
 drivers/net/ethernet/intel/igc/igc_tsn.h  |  2 +-
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 5aa72eac2a35..480b814dc18c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5902,7 +5902,7 @@ static int igc_tsn_enable_launchtime(struct igc_adapter *adapter,
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter);
+	return igc_tsn_offload_apply(adapter, qopt->enable);
 }
 
 static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
@@ -5926,6 +5926,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 				 struct tc_taprio_qopt_offload *qopt)
 {
 	bool queue_configured[IGC_MAX_TX_QUEUES] = { };
+	struct igc_hw *hw = &adapter->hw;
 	u32 start_time = 0, end_time = 0;
 	size_t n;
 
@@ -5937,7 +5938,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	if (qopt->base_time < 0)
 		return -ERANGE;
 
-	if (adapter->base_time)
+	if (igc_is_device_id_i225(hw) && adapter->base_time)
 		return -EALREADY;
 
 	if (!validate_schedule(adapter, qopt))
@@ -6003,7 +6004,7 @@ static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter);
+	return igc_tsn_offload_apply(adapter, qopt->enable);
 }
 
 static int igc_save_cbs_params(struct igc_adapter *adapter, int queue,
@@ -6071,7 +6072,7 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter);
+	return igc_tsn_offload_apply(adapter, qopt->enable);
 }
 
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index d7832cf1bc5b..5d351c873c41 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -232,7 +232,7 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		wr32(IGC_TXQCTL(i), txqctl);
 	}
 
-	tqavctrl = rd32(IGC_TQAVCTRL);
+	tqavctrl = rd32(IGC_TQAVCTRL) & ~IGC_TQAVCTRL_FUTSCDDIS;
 	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
 
 	cycle = adapter->cycle_time;
@@ -249,8 +249,11 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	} else {
 		/* According to datasheet section 7.5.2.9.3.3, FutScdDis bit
 		 * has to be configured before the cycle time and base time.
+		 * Tx won't hang if there is a GCL is already running,
+		 * so in this case we don't need to set FutScdDis.
 		 */
-		if (igc_is_device_id_i226(hw))
+		if (igc_is_device_id_i226(hw) &&
+		    !(rd32(IGC_BASET_H) || rd32(IGC_BASET_L)))
 			tqavctrl |= IGC_TQAVCTRL_FUTSCDDIS;
 	}
 
@@ -293,11 +296,13 @@ int igc_tsn_reset(struct igc_adapter *adapter)
 	return err;
 }
 
-int igc_tsn_offload_apply(struct igc_adapter *adapter)
+int igc_tsn_offload_apply(struct igc_adapter *adapter, bool enable)
 {
+	struct igc_hw *hw = &adapter->hw;
 	int err;
 
-	if (netif_running(adapter->netdev)) {
+	if (netif_running(adapter->netdev) &&
+	    (igc_is_device_id_i225(hw) || !enable)) {
 		schedule_work(&adapter->reset_task);
 		return 0;
 	}
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.h b/drivers/net/ethernet/intel/igc/igc_tsn.h
index b53e6af560b7..631222bb6eb5 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.h
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.h
@@ -4,7 +4,7 @@
 #ifndef _IGC_TSN_H_
 #define _IGC_TSN_H_
 
-int igc_tsn_offload_apply(struct igc_adapter *adapter);
+int igc_tsn_offload_apply(struct igc_adapter *adapter, bool enable);
 int igc_tsn_reset(struct igc_adapter *adapter);
 void igc_tsn_adjust_txtime_offset(struct igc_adapter *adapter);
 
-- 
2.35.1

