Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D624445D1
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhKCQXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:23:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:20327 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232488AbhKCQXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:23:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="230256986"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="230256986"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 09:21:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="497645565"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 03 Nov 2021 09:21:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net v2 4/5] ice: Fix not stopping Tx queues for VFs
Date:   Wed,  3 Nov 2021 09:19:34 -0700
Message-Id: <20211103161935.2997369-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
References: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

When a VF is removed and/or reset its Tx queues need to be
stopped from the PF. This is done by calling the ice_dis_vf_qs()
function, which calls ice_vsi_stop_lan_tx_rings(). Currently
ice_dis_vf_qs() is protected by the VF state bit ICE_VF_STATE_QS_ENA.
Unfortunately, this is causing the Tx queues to not be disabled in some
cases and when the VF tries to re-enable/reconfigure its Tx queues over
virtchnl the op is failing. This is because a VF can be reset and/or
removed before the ICE_VF_STATE_QS_ENA bit is set, but the Tx queues
were already configured via ice_vsi_cfg_single_txq() in the
VIRTCHNL_OP_CONFIG_VSI_QUEUES op. However, the ICE_VF_STATE_QS_ENA bit
is set on a successful VIRTCHNL_OP_ENABLE_QUEUES, which will always
happen after the VIRTCHNL_OP_CONFIG_VSI_QUEUES op.

This was causing the following error message when loading the ice
driver, creating VFs, and modifying VF trust in an endless loop:

[35274.192484] ice 0000:88:00.0: Failed to set LAN Tx queue context, error: ICE_ERR_PARAM
[35274.193074] ice 0000:88:00.0: VF 0 failed opcode 6, retval: -5
[35274.193640] iavf 0000:88:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our request 6

Fix this by always calling ice_dis_vf_qs() and silencing the error
message in ice_vsi_stop_tx_ring() since the calling code ignores the
return anyway. Also, all other places that call ice_vsi_stop_tx_ring()
catch the error, so this doesn't affect those flows since there was no
change to the values the function returns.

Other solutions were considered (i.e. tracking which VF queues had been
"started/configured" in VIRTCHNL_OP_CONFIG_VSI_QUEUES, but it seemed
more complicated than it was worth. This solution also brings in the
chance for other unexpected conditions due to invalid state bit checks.
So, the proposed solution seemed like the best option since there is no
harm in failing to stop Tx queues that were never started.

This issue can be seen using the following commands:

for i in {0..50}; do
        rmmod ice
        modprobe ice

        sleep 1

        echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs

        ip link set ens785f1 vf 0 trust on
        ip link set ens785f0 vf 0 trust on

        sleep 2

        echo 0 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 0 > /sys/class/net/ens785f1/device/sriov_numvfs
        sleep 1
        echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs

        ip link set ens785f1 vf 0 trust on
        ip link set ens785f0 vf 0 trust on
done

Fixes: 77ca27c41705 ("ice: add support for virtchnl_queue_select.[tx|rx]_queues bitmap")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c        | 2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index fa6cd63cbf1f..1efc635cc0f5 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -962,7 +962,7 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 	} else if (status == ICE_ERR_DOES_NOT_EXIST) {
 		dev_dbg(ice_pf_to_dev(vsi->back), "LAN Tx queues do not exist, nothing to disable\n");
 	} else if (status) {
-		dev_err(ice_pf_to_dev(vsi->back), "Failed to disable LAN Tx queues, error: %s\n",
+		dev_dbg(ice_pf_to_dev(vsi->back), "Failed to disable LAN Tx queues, error: %s\n",
 			ice_stat_str(status));
 		return -ENODEV;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 650ad7f56829..3f727df3b6fb 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -638,8 +638,7 @@ void ice_free_vfs(struct ice_pf *pf)
 
 	/* Avoid wait time by stopping all VFs at the same time */
 	ice_for_each_vf(pf, i)
-		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[i].vf_states))
-			ice_dis_vf_qs(&pf->vf[i]);
+		ice_dis_vf_qs(&pf->vf[i]);
 
 	tmp = pf->num_alloc_vfs;
 	pf->num_qps_per_vf = 0;
@@ -1695,8 +1694,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 
 	vsi = ice_get_vf_vsi(vf);
 
-	if (test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states))
-		ice_dis_vf_qs(vf);
+	ice_dis_vf_qs(vf);
 
 	/* Call Disable LAN Tx queue AQ whether or not queues are
 	 * enabled. This is needed for successful completion of VFR.
-- 
2.31.1

