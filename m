Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D633A4654
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhFKQTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:19:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:16328 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231164AbhFKQTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:19:37 -0400
IronPort-SDR: pimJeOOFDqJoDER8dDoi2mNcoyLab3pj8sCuW4XQ8Y+2Kgdm10K7EIy0UFvtqUdQ/fjiwf/dJ5
 CVljwXzo4rfQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="269404874"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="269404874"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 09:17:27 -0700
IronPort-SDR: ij/ERbIdctUQN7Bw1yg0+qlLLwq3aA/wIOm+FIFWPel1jkD/iCgJcpmipfO4NArONIM0e/HNLY
 NYxfB4xUebig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="620423490"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2021 09:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 6/8] ice: report the PTP clock index in ethtool .get_ts_info
Date:   Fri, 11 Jun 2021 09:19:58 -0700
Message-Id: <20210611162000.2438023-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Now that the driver registers a PTP clock device that represents the
clock hardware, it is important that the clock index is reported via the
ethtool .get_ts_info callback.

The underlying hardware resource is shared between multiple PF
functions. Only one function owns the hardware resources associated with
a timer, but multiple functions may be associated with it for the
purposes of timestamping.

To support this, the owning PF will store the clock index into the
driver shared parameters buffer in firmware. Other PFs will look up the
clock index by reading the driver shared parameter on demand when
requested via the .get_ts_info ethtool function.

In this way, all functions which are tied to the same timer are able to
report the clock index. Userspace software such as ptp4l performs
a look up on the netdev to determine the associated clock, and all
commands to control or configure the clock will be handled through the
controlling PF.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  22 +++-
 drivers/net/ethernet/intel/ice/ice_ptp.c     | 129 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp.h     |   5 +
 3 files changed, 155 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 1f30f24648d8..01466b9f29b7 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3195,6 +3195,26 @@ ice_set_rxfh(struct net_device *netdev, const u32 *indir, const u8 *key,
 	return 0;
 }
 
+static int
+ice_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(dev);
+
+	/* only report timestamping if PTP is enabled */
+	if (!test_bit(ICE_FLAG_PTP, pf->flags))
+		return ethtool_op_get_ts_info(dev, info);
+
+	info->so_timestamping = SOF_TIMESTAMPING_SOFTWARE;
+
+	info->phc_index = ice_get_ptp_clock_index(pf);
+
+	info->tx_types = BIT(HWTSTAMP_TX_OFF);
+
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
+
+	return 0;
+}
+
 /**
  * ice_get_max_txq - return the maximum number of Tx queues for in a PF
  * @pf: PF structure
@@ -3986,7 +4006,7 @@ static const struct ethtool_ops ice_ethtool_ops = {
 	.set_rxfh		= ice_set_rxfh,
 	.get_channels		= ice_get_channels,
 	.set_channels		= ice_set_channels,
-	.get_ts_info		= ethtool_op_get_ts_info,
+	.get_ts_info		= ice_get_ts_info,
 	.get_per_queue_coalesce	= ice_get_per_q_coalesce,
 	.set_per_queue_coalesce	= ice_set_per_q_coalesce,
 	.get_fecparam		= ice_get_fecparam,
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 4ec4b2352234..82be5846b42f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -4,6 +4,131 @@
 #include "ice.h"
 #include "ice_lib.h"
 
+/**
+ * ice_get_ptp_clock_index - Get the PTP clock index
+ * @pf: the PF pointer
+ *
+ * Determine the clock index of the PTP clock associated with this device. If
+ * this is the PF controlling the clock, just use the local access to the
+ * clock device pointer.
+ *
+ * Otherwise, read from the driver shared parameters to determine the clock
+ * index value.
+ *
+ * Returns: the index of the PTP clock associated with this device, or -1 if
+ * there is no associated clock.
+ */
+int ice_get_ptp_clock_index(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	enum ice_aqc_driver_params param_idx;
+	struct ice_hw *hw = &pf->hw;
+	u8 tmr_idx;
+	u32 value;
+	int err;
+
+	/* Use the ptp_clock structure if we're the main PF */
+	if (pf->ptp.clock)
+		return ptp_clock_index(pf->ptp.clock);
+
+	tmr_idx = hw->func_caps.ts_func_info.tmr_index_assoc;
+	if (!tmr_idx)
+		param_idx = ICE_AQC_DRIVER_PARAM_CLK_IDX_TMR0;
+	else
+		param_idx = ICE_AQC_DRIVER_PARAM_CLK_IDX_TMR1;
+
+	err = ice_aq_get_driver_param(hw, param_idx, &value, NULL);
+	if (err) {
+		dev_err(dev, "Failed to read PTP clock index parameter, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+		return -1;
+	}
+
+	/* The PTP clock index is an integer, and will be between 0 and
+	 * INT_MAX. The highest bit of the driver shared parameter is used to
+	 * indicate whether or not the currently stored clock index is valid.
+	 */
+	if (!(value & PTP_SHARED_CLK_IDX_VALID))
+		return -1;
+
+	return value & ~PTP_SHARED_CLK_IDX_VALID;
+}
+
+/**
+ * ice_set_ptp_clock_index - Set the PTP clock index
+ * @pf: the PF pointer
+ *
+ * Set the PTP clock index for this device into the shared driver parameters,
+ * so that other PFs associated with this device can read it.
+ *
+ * If the PF is unable to store the clock index, it will log an error, but
+ * will continue operating PTP.
+ */
+static void ice_set_ptp_clock_index(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	enum ice_aqc_driver_params param_idx;
+	struct ice_hw *hw = &pf->hw;
+	u8 tmr_idx;
+	u32 value;
+	int err;
+
+	if (!pf->ptp.clock)
+		return;
+
+	tmr_idx = hw->func_caps.ts_func_info.tmr_index_assoc;
+	if (!tmr_idx)
+		param_idx = ICE_AQC_DRIVER_PARAM_CLK_IDX_TMR0;
+	else
+		param_idx = ICE_AQC_DRIVER_PARAM_CLK_IDX_TMR1;
+
+	value = (u32)ptp_clock_index(pf->ptp.clock);
+	if (value > INT_MAX) {
+		dev_err(dev, "PTP Clock index is too large to store\n");
+		return;
+	}
+	value |= PTP_SHARED_CLK_IDX_VALID;
+
+	err = ice_aq_set_driver_param(hw, param_idx, value, NULL);
+	if (err) {
+		dev_err(dev, "Failed to set PTP clock index parameter, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+	}
+}
+
+/**
+ * ice_clear_ptp_clock_index - Clear the PTP clock index
+ * @pf: the PF pointer
+ *
+ * Clear the PTP clock index for this device. Must be called when
+ * unregistering the PTP clock, in order to ensure other PFs stop reporting
+ * a clock object that no longer exists.
+ */
+static void ice_clear_ptp_clock_index(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	enum ice_aqc_driver_params param_idx;
+	struct ice_hw *hw = &pf->hw;
+	u8 tmr_idx;
+	int err;
+
+	/* Do not clear the index if we don't own the timer */
+	if (!hw->func_caps.ts_func_info.src_tmr_owned)
+		return;
+
+	tmr_idx = hw->func_caps.ts_func_info.tmr_index_assoc;
+	if (!tmr_idx)
+		param_idx = ICE_AQC_DRIVER_PARAM_CLK_IDX_TMR0;
+	else
+		param_idx = ICE_AQC_DRIVER_PARAM_CLK_IDX_TMR1;
+
+	err = ice_aq_set_driver_param(hw, param_idx, 0, NULL);
+	if (err) {
+		dev_dbg(dev, "Failed to clear PTP clock index parameter, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+	}
+}
+
 /**
  * ice_ptp_read_src_clk_reg - Read the source clock register
  * @pf: Board private structure
@@ -377,6 +502,9 @@ static int ice_ptp_init_owner(struct ice_pf *pf)
 	if (err)
 		goto err_clk;
 
+	/* Store the PTP clock index for other PFs */
+	ice_set_ptp_clock_index(pf);
+
 	return 0;
 
 err_clk:
@@ -431,6 +559,7 @@ void ice_ptp_release(struct ice_pf *pf)
 	if (!pf->ptp.clock)
 		return;
 
+	ice_clear_ptp_clock_index(pf);
 	ptp_clock_unregister(pf->ptp.clock);
 	pf->ptp.clock = NULL;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 15f2e325bd68..01f7db05ef7d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -27,9 +27,14 @@ struct ice_ptp {
 
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
 struct ice_pf;
+int ice_get_ptp_clock_index(struct ice_pf *pf);
 void ice_ptp_init(struct ice_pf *pf);
 void ice_ptp_release(struct ice_pf *pf);
 #else /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
+static inline int ice_get_ptp_clock_index(struct ice_pf *pf)
+{
+	return -1;
+}
 static inline void ice_ptp_init(struct ice_pf *pf) { }
 static inline void ice_ptp_release(struct ice_pf *pf) { }
 #endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
-- 
2.26.2

