Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46554C93B2
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbiCATAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbiCATAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:00:09 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B50662FC
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646161168; x=1677697168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GQYgFBcNq7S+/CvbxPpMKKg0QR959bTPdayS87t6Vjw=;
  b=XbVlp+6y4SZfvz7ytkOlieSuiVCJk3KfPA+yTX+kYQzW7X7C/fM4WTxN
   8lNXtU0/UNfTh4tPc5BRX/fiNPYjgwMYAaHXi5yfVSXwcC1FQeOo1g5dS
   XEGaUQQL5oU4ElctMZE8bmetv7DWphB8WSrgEZZsf5QeWpMENL8n4e0O/
   41YkPeDpOeOZtFyZuIkNBireFzK4ILPAooUftS2jU4ZLLpAq0zhBUZ5ZP
   U4Meei/K+rt48iG5GX53wlgmJYtLV7p+giNBvkCxWhIPGsuh2pM1uN4iE
   eMChLg17A8AqDcyE/Y5xgrBZj0NilCKn2FblbhTrVBuQ363DwnOUQksiO
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="252042315"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252042315"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 10:59:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="507908255"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 10:59:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Brett Creeley <brett.creeley@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 1/7] iavf: Add support for 50G/100G in AIM algorithm
Date:   Tue,  1 Mar 2022 10:59:33 -0800
Message-Id: <20220301185939.3005116-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
References: <20220301185939.3005116-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Advanced link speed support was added long back, but adding AIM support was
missed. This patch adds AIM support for advanced link speed support, which
allows the algorithm to take into account 50G/100G link speeds. Also, other
previous speeds are taken into consideration when advanced link speeds are
supported.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 62 ++++++++++++++++-----
 1 file changed, 47 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 8cbe7ad1347c..978f651c6b09 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -374,29 +374,60 @@ static inline bool iavf_container_is_rx(struct iavf_q_vector *q_vector,
 	return &q_vector->rx == rc;
 }
 
-static inline unsigned int iavf_itr_divisor(struct iavf_q_vector *q_vector)
+#define IAVF_AIM_MULTIPLIER_100G	2560
+#define IAVF_AIM_MULTIPLIER_50G		1280
+#define IAVF_AIM_MULTIPLIER_40G		1024
+#define IAVF_AIM_MULTIPLIER_20G		512
+#define IAVF_AIM_MULTIPLIER_10G		256
+#define IAVF_AIM_MULTIPLIER_1G		32
+
+static unsigned int iavf_mbps_itr_multiplier(u32 speed_mbps)
 {
-	unsigned int divisor;
+	switch (speed_mbps) {
+	case SPEED_100000:
+		return IAVF_AIM_MULTIPLIER_100G;
+	case SPEED_50000:
+		return IAVF_AIM_MULTIPLIER_50G;
+	case SPEED_40000:
+		return IAVF_AIM_MULTIPLIER_40G;
+	case SPEED_25000:
+	case SPEED_20000:
+		return IAVF_AIM_MULTIPLIER_20G;
+	case SPEED_10000:
+	default:
+		return IAVF_AIM_MULTIPLIER_10G;
+	case SPEED_1000:
+	case SPEED_100:
+		return IAVF_AIM_MULTIPLIER_1G;
+	}
+}
 
-	switch (q_vector->adapter->link_speed) {
+static unsigned int
+iavf_virtchnl_itr_multiplier(enum virtchnl_link_speed speed_virtchnl)
+{
+	switch (speed_virtchnl) {
 	case VIRTCHNL_LINK_SPEED_40GB:
-		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 1024;
-		break;
+		return IAVF_AIM_MULTIPLIER_40G;
 	case VIRTCHNL_LINK_SPEED_25GB:
 	case VIRTCHNL_LINK_SPEED_20GB:
-		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 512;
-		break;
-	default:
+		return IAVF_AIM_MULTIPLIER_20G;
 	case VIRTCHNL_LINK_SPEED_10GB:
-		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 256;
-		break;
+	default:
+		return IAVF_AIM_MULTIPLIER_10G;
 	case VIRTCHNL_LINK_SPEED_1GB:
 	case VIRTCHNL_LINK_SPEED_100MB:
-		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 32;
-		break;
+		return IAVF_AIM_MULTIPLIER_1G;
 	}
+}
 
-	return divisor;
+static unsigned int iavf_itr_divisor(struct iavf_adapter *adapter)
+{
+	if (ADV_LINK_SUPPORT(adapter))
+		return IAVF_ITR_ADAPTIVE_MIN_INC *
+			iavf_mbps_itr_multiplier(adapter->link_speed_mbps);
+	else
+		return IAVF_ITR_ADAPTIVE_MIN_INC *
+			iavf_virtchnl_itr_multiplier(adapter->link_speed);
 }
 
 /**
@@ -586,8 +617,9 @@ static void iavf_update_itr(struct iavf_q_vector *q_vector,
 	 * Use addition as we have already recorded the new latency flag
 	 * for the ITR value.
 	 */
-	itr += DIV_ROUND_UP(avg_wire_size, iavf_itr_divisor(q_vector)) *
-	       IAVF_ITR_ADAPTIVE_MIN_INC;
+	itr += DIV_ROUND_UP(avg_wire_size,
+			    iavf_itr_divisor(q_vector->adapter)) *
+		IAVF_ITR_ADAPTIVE_MIN_INC;
 
 	if ((itr & IAVF_ITR_MASK) > IAVF_ITR_ADAPTIVE_MAX_USECS) {
 		itr &= IAVF_ITR_ADAPTIVE_LATENCY;
-- 
2.31.1

