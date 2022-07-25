Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880EA58034E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 19:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbiGYRH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 13:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiGYRHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 13:07:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB52A1D0CE
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 10:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658768874; x=1690304874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TVBwNVwosE28YBErKxtlCO5i2g0RTkJYsYYyRvi8lH8=;
  b=a3WZ4G/m/h1CTwFVrLlV/wQwZcVpt/q/FUDz78UATUSOKTSPVKRTVhNs
   PtVyeG5ZUk55I8ipjDue505Jwwqe7Ay1V7bmXQrvPRkqzG1yW4fx1Y88L
   YewiaJdefmqG8+Eegs6CDRRLgkfAbw932/S4UV8Gi8JGnO1LiWV0+K+kv
   Jwo66MZbqdwTFrHlUHnvGSXuLkIJJ8sqoLqBeUXkgDCheg1tH5M6Nmn9k
   On6Q3MyWP39Ak6rjppaqU9+VAXyw2ErV691DHE7HjeojchozujOdk+cA1
   0C2HcUSBk9wFSBGo0ZmyFsvEuBmX2gI2lWuQrLI9KY5UYc7326EJ6DIqV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="270785656"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="270785656"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 10:07:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="845577975"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jul 2022 10:07:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jun Zhang <xuejun.zhang@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net 1/3] iavf: Fix max_rate limiting
Date:   Mon, 25 Jul 2022 10:04:50 -0700
Message-Id: <20220725170452.920964-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
References: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Fix max_rate option in TC, check for proper quanta boundaries.
Check for minimum value provided and if it fits expected 50Mbps
quanta.

Without this patch, iavf could send settings for max_rate limiting
that would be accepted from by PF even the max_rate option is less
than expected 50Mbps quanta. It results in no rate limiting
on traffic as rate limiting will be floored to 0.

Example:
tc qdisc add dev $vf root mqprio num_tc 3 map 0 2 1 queues \
2@0 2@2 2@4 hw 1 mode channel shaper bw_rlimit \
max_rate 50Mbps 500Mbps 500Mbps

Should limit TC0 to circa 50 Mbps

tc qdisc add dev $vf root mqprio num_tc 3 map 0 2 1 queues \
2@0 2@2 2@4 hw 1 mode channel shaper bw_rlimit \
max_rate 0Mbps 100Kbit 500Mbps

Should return error

Fixes: d5b33d024496 ("i40evf: add ndo_setup_tc callback to i40evf")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jun Zhang <xuejun.zhang@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c | 25 +++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 0ea0361cd86b..c241fbc30f93 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -92,6 +92,7 @@ struct iavf_vsi {
 #define IAVF_HKEY_ARRAY_SIZE ((IAVF_VFQF_HKEY_MAX_INDEX + 1) * 4)
 #define IAVF_HLUT_ARRAY_SIZE ((IAVF_VFQF_HLUT_MAX_INDEX + 1) * 4)
 #define IAVF_MBPS_DIVISOR	125000 /* divisor to convert to Mbps */
+#define IAVF_MBPS_QUANTA	50
 
 #define IAVF_VIRTCHNL_VF_RESOURCE_SIZE (sizeof(struct virtchnl_vf_resource) + \
 					(IAVF_MAX_VF_VSI * \
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2e2c153ce46a..51ae10eb348c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3322,6 +3322,7 @@ static int iavf_validate_ch_config(struct iavf_adapter *adapter,
 				   struct tc_mqprio_qopt_offload *mqprio_qopt)
 {
 	u64 total_max_rate = 0;
+	u32 tx_rate_rem = 0;
 	int i, num_qps = 0;
 	u64 tx_rate = 0;
 	int ret = 0;
@@ -3336,12 +3337,32 @@ static int iavf_validate_ch_config(struct iavf_adapter *adapter,
 			return -EINVAL;
 		if (mqprio_qopt->min_rate[i]) {
 			dev_err(&adapter->pdev->dev,
-				"Invalid min tx rate (greater than 0) specified\n");
+				"Invalid min tx rate (greater than 0) specified for TC%d\n",
+				i);
 			return -EINVAL;
 		}
-		/*convert to Mbps */
+
+		/* convert to Mbps */
 		tx_rate = div_u64(mqprio_qopt->max_rate[i],
 				  IAVF_MBPS_DIVISOR);
+
+		if (mqprio_qopt->max_rate[i] &&
+		    tx_rate < IAVF_MBPS_QUANTA) {
+			dev_err(&adapter->pdev->dev,
+				"Invalid max tx rate for TC%d, minimum %dMbps\n",
+				i, IAVF_MBPS_QUANTA);
+			return -EINVAL;
+		}
+
+		(void)div_u64_rem(tx_rate, IAVF_MBPS_QUANTA, &tx_rate_rem);
+
+		if (tx_rate_rem != 0) {
+			dev_err(&adapter->pdev->dev,
+				"Invalid max tx rate for TC%d, not divisible by %d\n",
+				i, IAVF_MBPS_QUANTA);
+			return -EINVAL;
+		}
+
 		total_max_rate += tx_rate;
 		num_qps += mqprio_qopt->qopt.count[i];
 	}
-- 
2.35.1

