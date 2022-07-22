Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2ED57E616
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiGVR42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiGVR4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:56:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A2F5B7A2
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658512578; x=1690048578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RSn2GoDODEWkV5pgjoK9fWfI0mjp4b7iPWQW/8eUHec=;
  b=WKp3DDK9hdFWphHiYJceBxoBS/56GNWR5VorCxmCMyp0Rzlr0OicAzis
   hPSMXtsYtGUNgAQb7RE6BT6KSxl+uBmHh6v2JgjCbNbi2j1Z5J//pHmKx
   CburGOnpMEUFq/8Bju3+MatLvMSrM8uxAC8WCPn62MsIQNp9ZFcJPsWgB
   jV6h43/G6rYUk2RJxnas/zQbREmXLf5M5YukXGg5ByBDR/RPg2YV22rOR
   vaeW+GKuQJA6QgmltktXn43ftDjIfdJvoSa0bhoQDEeEDA+jnuhfhPoCn
   YNG5DL3wUBivi7HPTHFCrecHScA1M3rVrLuYX65ElcPyIdbki4JVm2NbR
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="267769830"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="267769830"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 10:56:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="596042569"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 22 Jul 2022 10:56:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net-next 1/2] i40e: Refactor tc mqprio checks
Date:   Fri, 22 Jul 2022 10:53:12 -0700
Message-Id: <20220722175313.112518-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220722175313.112518-1-anthony.l.nguyen@intel.com>
References: <20220722175313.112518-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Refactor bitwise checks for whether TC MQPRIO is enabled
into one single method for improved readability.

Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h        | 14 +++++++++++++
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 20 +++++++++----------
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 97c574a33ba0..d86b6d349ea9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1292,4 +1292,18 @@ int i40e_add_del_cloud_filter(struct i40e_vsi *vsi,
 int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 				      struct i40e_cloud_filter *filter,
 				      bool add);
+
+/**
+ * i40e_is_tc_mqprio_enabled - check if TC MQPRIO is enabled on PF
+ * @pf: pointer to a pf.
+ *
+ * Check and return value of flag I40E_FLAG_TC_MQPRIO.
+ *
+ * Return: I40E_FLAG_TC_MQPRIO set state.
+ **/
+static inline u32 i40e_is_tc_mqprio_enabled(struct i40e_pf *pf)
+{
+	return pf->flags & I40E_FLAG_TC_MQPRIO;
+}
+
 #endif /* _I40E_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index d9a934ca3eba..156e92c43780 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5021,7 +5021,7 @@ static int i40e_set_channels(struct net_device *dev,
 	/* We do not support setting channels via ethtool when TCs are
 	 * configured through mqprio
 	 */
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return -EINVAL;
 
 	/* verify they are not requesting separate vectors */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index fe6f25537110..fb9f476fb33c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5456,7 +5456,7 @@ static u8 i40e_pf_get_num_tc(struct i40e_pf *pf)
 	u8 num_tc = 0;
 	struct i40e_dcbx_config *dcbcfg = &hw->local_dcbx_config;
 
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return pf->vsi[pf->lan_vsi]->mqprio_qopt.qopt.num_tc;
 
 	/* If neither MQPRIO nor DCB is enabled, then always use single TC */
@@ -5488,7 +5488,7 @@ static u8 i40e_pf_get_num_tc(struct i40e_pf *pf)
  **/
 static u8 i40e_pf_get_tc_map(struct i40e_pf *pf)
 {
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return i40e_mqprio_get_enabled_tc(pf);
 
 	/* If neither MQPRIO nor DCB is enabled for this PF then just return
@@ -5585,7 +5585,7 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 	int i;
 
 	/* There is no need to reset BW when mqprio mode is on.  */
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return 0;
 	if (!vsi->mqprio_qopt.qopt.hw && !(pf->flags & I40E_FLAG_DCB_ENABLED)) {
 		ret = i40e_set_bw_limit(vsi, vsi->seid, 0);
@@ -5657,7 +5657,7 @@ static void i40e_vsi_config_netdev_tc(struct i40e_vsi *vsi, u8 enabled_tc)
 					vsi->tc_config.tc_info[i].qoffset);
 	}
 
-	if (pf->flags & I40E_FLAG_TC_MQPRIO)
+	if (i40e_is_tc_mqprio_enabled(pf))
 		return;
 
 	/* Assign UP2TC map for the VSI */
@@ -5818,7 +5818,7 @@ static int i40e_vsi_config_tc(struct i40e_vsi *vsi, u8 enabled_tc)
 	ctxt.vf_num = 0;
 	ctxt.uplink_seid = vsi->uplink_seid;
 	ctxt.info = vsi->info;
-	if (vsi->back->flags & I40E_FLAG_TC_MQPRIO) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		ret = i40e_vsi_setup_queue_map_mqprio(vsi, &ctxt, enabled_tc);
 		if (ret)
 			goto out;
@@ -6542,7 +6542,7 @@ int i40e_create_queue_channel(struct i40e_vsi *vsi,
 		pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
 
 		if (vsi->type == I40E_VSI_MAIN) {
-			if (pf->flags & I40E_FLAG_TC_MQPRIO)
+			if (i40e_is_tc_mqprio_enabled(pf))
 				i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
 			else
 				i40e_do_reset_safe(pf, I40E_PF_RESET_FLAG);
@@ -7936,7 +7936,7 @@ static void *i40e_fwd_add(struct net_device *netdev, struct net_device *vdev)
 		netdev_info(netdev, "Macvlans are not supported when DCB is enabled\n");
 		return ERR_PTR(-EINVAL);
 	}
-	if ((pf->flags & I40E_FLAG_TC_MQPRIO)) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		netdev_info(netdev, "Macvlans are not supported when HW TC offload is on\n");
 		return ERR_PTR(-EINVAL);
 	}
@@ -8189,7 +8189,7 @@ static int i40e_setup_tc(struct net_device *netdev, void *type_data)
 	/* Quiesce VSI queues */
 	i40e_quiesce_vsi(vsi);
 
-	if (!hw && !(pf->flags & I40E_FLAG_TC_MQPRIO))
+	if (!hw && !i40e_is_tc_mqprio_enabled(pf))
 		i40e_remove_queue_channels(vsi);
 
 	/* Configure VSI for enabled TCs */
@@ -8213,7 +8213,7 @@ static int i40e_setup_tc(struct net_device *netdev, void *type_data)
 		 "Setup channel (id:%u) utilizing num_queues %d\n",
 		 vsi->seid, vsi->tc_config.tc_info[0].qcount);
 
-	if (pf->flags & I40E_FLAG_TC_MQPRIO) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		if (vsi->mqprio_qopt.max_rate[0]) {
 			u64 max_tx_rate = vsi->mqprio_qopt.max_rate[0];
 
@@ -10867,7 +10867,7 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	 * unless I40E_FLAG_TC_MQPRIO was enabled or DCB
 	 * is not supported with new link speed
 	 */
-	if (pf->flags & I40E_FLAG_TC_MQPRIO) {
+	if (i40e_is_tc_mqprio_enabled(pf)) {
 		i40e_aq_set_dcb_parameters(hw, false, NULL);
 	} else {
 		if (I40E_IS_X710TL_DEVICE(hw->device_id) &&
-- 
2.35.1

