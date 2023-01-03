Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C3B65CA23
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjACXEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjACXER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:04:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCF014033
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 15:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672787056; x=1704323056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4X9gooQyBGsa/0D2H9DjLmL1UWYrTjLaE0b4qbk609c=;
  b=lMa5LTueKELgoNZUG896G54wWV58NqFG2qtCW8Jq04OSvm044v65RNYG
   39IIXwO1ecGG5B/Al2vfhBGF09QLB+1HW4GJ/jLfBzaPUnAysIUaMUy/M
   G8j+vj2tV9n0VDnsHPKXG/uWiUpxKcjaXwwpKWptrR0OOSETq0jD3wPsg
   Z4XU/MnQehkzUO3ZATWrXZmx1tDkB2JS2eDfu8Xwt6yskfIrudw4iCFDJ
   GE3pTDwIaORdLvBD125XBFJ2KCTGFLBj9XF6wjWISDodpJwYyAQxtjh7R
   xjVzri35H+49qQZuf7LcBQ2aEXoNNViXqqxQO7KCOm90559aE7KJ8Iiat
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="302152115"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="302152115"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 15:04:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="723427630"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="723427630"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga004.fm.intel.com with ESMTP; 03 Jan 2023 15:04:15 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tan Tee Min <tee.min.tan@linux.intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 2/3] igc: enable Qbv configuration for 2nd GCL
Date:   Tue,  3 Jan 2023 15:05:02 -0800
Message-Id: <20230103230503.1102426-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230103230503.1102426-1-anthony.l.nguyen@intel.com>
References: <20230103230503.1102426-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 988131d7acd7..212560f22254 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6020,7 +6020,7 @@ static int igc_tsn_enable_launchtime(struct igc_adapter *adapter,
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter);
+	return igc_tsn_offload_apply(adapter, qopt->enable);
 }
 
 static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
@@ -6044,6 +6044,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 				 struct tc_taprio_qopt_offload *qopt)
 {
 	bool queue_configured[IGC_MAX_TX_QUEUES] = { };
+	struct igc_hw *hw = &adapter->hw;
 	u32 start_time = 0, end_time = 0;
 	size_t n;
 	int i;
@@ -6056,7 +6057,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	if (qopt->base_time < 0)
 		return -ERANGE;
 
-	if (adapter->base_time)
+	if (igc_is_device_id_i225(hw) && adapter->base_time)
 		return -EALREADY;
 
 	if (!validate_schedule(adapter, qopt))
@@ -6133,7 +6134,7 @@ static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter);
+	return igc_tsn_offload_apply(adapter, qopt->enable);
 }
 
 static int igc_save_cbs_params(struct igc_adapter *adapter, int queue,
@@ -6201,7 +6202,7 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter);
+	return igc_tsn_offload_apply(adapter, qopt->enable);
 }
 
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 28325dc4fc5b..d26fc0f47640 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -225,7 +225,7 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		wr32(IGC_TXQCTL(i), txqctl);
 	}
 
-	tqavctrl = rd32(IGC_TQAVCTRL);
+	tqavctrl = rd32(IGC_TQAVCTRL) & ~IGC_TQAVCTRL_FUTSCDDIS;
 	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
 
 	cycle = adapter->cycle_time;
@@ -242,8 +242,11 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
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
 
@@ -286,11 +289,13 @@ int igc_tsn_reset(struct igc_adapter *adapter)
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
2.38.1

