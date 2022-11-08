Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAB5622079
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiKHXwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKHXwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:52:00 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AC35E9C9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 15:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667951519; x=1699487519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N8RNeCnLZLMtOgBC/bghFFIq5p4fTOreasqZWcplDBQ=;
  b=CFmFF1K6bfW6fKxPfgMzJ8ZtyivcX2cUcQcuKxIGTGoh0IXrxO/z1hsA
   3v2MF7LnxfAGgWaVbMSOUBr9pjhoMAbBwoRg/rY5a9nnZIYJFuNGOrZsO
   0CmcumdwKco7IWr7t7KgqSXQCUbUacVA/u447MqxTs+3/jDcbgd94LhVN
   s5kZg65jMU32ilZmqGx6XABVuNm2rfm1pdCkno3xNH8hsX2amCDdTJ+0m
   ynMNxIEpIfu8JPXXOdYhFlXmHf9iH8tHlR7qILfZFi9mQL2uJiZYenByh
   BoPZy+Q2Jud35LOv89RfbfF18DoMbfdkEu/pj42vHsHV7qxslfEN5N4y9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="290556985"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="290556985"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 15:51:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="667777834"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="667777834"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Nov 2022 15:51:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Norbert Zulinski <norbertx.zulinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/3] ice: Fix spurious interrupt during removal of trusted VF
Date:   Tue,  8 Nov 2022 15:51:14 -0800
Message-Id: <20221108235116.3522941-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221108235116.3522941-1-anthony.l.nguyen@intel.com>
References: <20221108235116.3522941-1-anthony.l.nguyen@intel.com>
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

From: Norbert Zulinski <norbertx.zulinski@intel.com>

Previously, during removal of trusted VF when VF is down there was
number of spurious interrupt equal to number of queues on VF.

Add check if VF already has inactive queues. If VF is disabled and
has inactive rx queues then do not disable rx queues.
Add check in ice_vsi_stop_tx_ring if it's VF's vsi and if VF is
disabled.

Fixes: efe41860008e ("ice: Fix memory corruption in VF driver")
Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c    | 25 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h    |  1 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c |  5 ++++-
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 9e36f01dfa4f..e864634d66bc 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -958,7 +958,7 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 	 * associated to the queue to schedule NAPI handler
 	 */
 	q_vector = ring->q_vector;
-	if (q_vector)
+	if (q_vector && !(vsi->vf && ice_is_vf_disabled(vsi->vf)))
 		ice_trigger_sw_intr(hw, q_vector);
 
 	status = ice_dis_vsi_txq(vsi->port_info, txq_meta->vsi_idx,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 938ba8c215cb..7276badfa19e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2239,6 +2239,31 @@ int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi)
 	return ice_vsi_stop_tx_rings(vsi, ICE_NO_RESET, 0, vsi->xdp_rings, vsi->num_xdp_txq);
 }
 
+/**
+ * ice_vsi_is_rx_queue_active
+ * @vsi: the VSI being configured
+ *
+ * Return true if at least one queue is active.
+ */
+bool ice_vsi_is_rx_queue_active(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	int i;
+
+	ice_for_each_rxq(vsi, i) {
+		u32 rx_reg;
+		int pf_q;
+
+		pf_q = vsi->rxq_map[i];
+		rx_reg = rd32(hw, QRX_CTRL(pf_q));
+		if (rx_reg & QRX_CTRL_QENA_STAT_M)
+			return true;
+	}
+
+	return false;
+}
+
 /**
  * ice_vsi_is_vlan_pruning_ena - check if VLAN pruning is enabled or not
  * @vsi: VSI to check whether or not VLAN pruning is enabled.
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index ec4bf0c89857..dcdf69a693e9 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -129,4 +129,5 @@ u16 ice_vsi_num_non_zero_vlans(struct ice_vsi *vsi);
 bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f);
 void ice_clear_feature_support(struct ice_pf *pf, enum ice_feature f);
 void ice_init_feature_support(struct ice_pf *pf);
+bool ice_vsi_is_rx_queue_active(struct ice_vsi *vsi);
 #endif /* !_ICE_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 0abeed092de1..1c51778db951 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -576,7 +576,10 @@ int ice_reset_vf(struct ice_vf *vf, u32 flags)
 			return -EINVAL;
 		}
 		ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, vf->vf_id);
-		ice_vsi_stop_all_rx_rings(vsi);
+
+		if (ice_vsi_is_rx_queue_active(vsi))
+			ice_vsi_stop_all_rx_rings(vsi);
+
 		dev_dbg(dev, "VF is already disabled, there is no need for resetting it, telling VM, all is fine %d\n",
 			vf->vf_id);
 		return 0;
-- 
2.35.1

