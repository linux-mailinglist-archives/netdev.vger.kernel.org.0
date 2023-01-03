Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4578F65CA24
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbjACXEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjACXER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:04:17 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE68314085
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 15:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672787056; x=1704323056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vCDCwcdKBVqQzSvyjApZAfrjnCDedzH5t1g20MBnlcA=;
  b=ZH+63kvmWczOFz+meyq6YbUcWyk5ccs81L7qOITEvLwFjLv1/e7bPMev
   9utbLNy7+JuQO5Ncji3I1H74LkyyZY+e5yO8EZ2fHiYYkp1tn94P7R7lN
   KOjbQkSqxtpR4mGeoIMsJ1u+UuNVqte9/RGMkCvmM/SPDpYTzdpb0w3NI
   qjrOOYrYLNDtq9dS/PKW+QG/B03EIcZNJhzqnXcJQoqdhPmRxKM1xMJay
   Ru857sZSC79A4N6mZRTsABxRpxUG2fGrnof+z2P+pJk3nUeXV0IxT1Qbt
   e6a8nPwIZTEqMQOkGv8fMWVb1aJBxSZvc7TE0xcxgTUmrqTUSdzuwDGhi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="302152122"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="302152122"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 15:04:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="723427633"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="723427633"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga004.fm.intel.com with ESMTP; 03 Jan 2023 15:04:16 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 3/3] igc: Remove reset adapter task for i226 during disable tsn config
Date:   Tue,  3 Jan 2023 15:05:03 -0800
Message-Id: <20230103230503.1102426-4-anthony.l.nguyen@intel.com>
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

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

I225 have limitation when programming the BaseTime register which required
a power cycle of the controller. This limitation already lifted in I226.
This patch removes the restriction so that when user configure/remove any
TSN mode, it would not go into power cycle reset adapter.

How to test:

Schedule any gate control list configuration or delete it.

Example:

1)

BASE_TIME=$(date +%s%N)
tc qdisc replace dev $interface_name parent root handle 100 taprio \
    num_tc 4 \
    map 3 1 0 2 3 3 3 3 3 3 3 3 3 3 3 3 \
    queues 1@0 1@1 1@2 1@3 \
    base-time $BASE_TIME \
    sched-entry S 0F 1000000 \
    flags 0x2

2) tc qdisc del dev $intername_name root

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c |  6 +++---
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 11 +++--------
 drivers/net/ethernet/intel/igc/igc_tsn.h  |  2 +-
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 212560f22254..e86b15efaeb8 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6020,7 +6020,7 @@ static int igc_tsn_enable_launchtime(struct igc_adapter *adapter,
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter, qopt->enable);
+	return igc_tsn_offload_apply(adapter);
 }
 
 static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
@@ -6134,7 +6134,7 @@ static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter, qopt->enable);
+	return igc_tsn_offload_apply(adapter);
 }
 
 static int igc_save_cbs_params(struct igc_adapter *adapter, int queue,
@@ -6202,7 +6202,7 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
 	if (err)
 		return err;
 
-	return igc_tsn_offload_apply(adapter, qopt->enable);
+	return igc_tsn_offload_apply(adapter);
 }
 
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index d26fc0f47640..a386c8d61dbf 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -289,21 +289,16 @@ int igc_tsn_reset(struct igc_adapter *adapter)
 	return err;
 }
 
-int igc_tsn_offload_apply(struct igc_adapter *adapter, bool enable)
+int igc_tsn_offload_apply(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
-	int err;
 
-	if (netif_running(adapter->netdev) &&
-	    (igc_is_device_id_i225(hw) || !enable)) {
+	if (netif_running(adapter->netdev) && igc_is_device_id_i225(hw)) {
 		schedule_work(&adapter->reset_task);
 		return 0;
 	}
 
-	err = igc_tsn_enable_offload(adapter);
-	if (err < 0)
-		return err;
+	igc_tsn_reset(adapter);
 
-	adapter->flags = igc_tsn_new_flags(adapter);
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.h b/drivers/net/ethernet/intel/igc/igc_tsn.h
index 631222bb6eb5..b53e6af560b7 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.h
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.h
@@ -4,7 +4,7 @@
 #ifndef _IGC_TSN_H_
 #define _IGC_TSN_H_
 
-int igc_tsn_offload_apply(struct igc_adapter *adapter, bool enable);
+int igc_tsn_offload_apply(struct igc_adapter *adapter);
 int igc_tsn_reset(struct igc_adapter *adapter);
 void igc_tsn_adjust_txtime_offset(struct igc_adapter *adapter);
 
-- 
2.38.1

