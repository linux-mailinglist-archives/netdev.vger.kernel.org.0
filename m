Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1203A4655
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFKQTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:19:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:16322 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230470AbhFKQTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:19:37 -0400
IronPort-SDR: uqB5xJeGK2u4h9QIfXDVdcw41PTqbdDJ6OaxBzF3qRHhVSewhRE9PB+gOKdTYpGdYG32Il5+91
 WItERoP64+Sw==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="269404875"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="269404875"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 09:17:27 -0700
IronPort-SDR: okU2vcgQ7ymxQV0tFuW59eB9+mfFzsHS6NW9vMi9hPsN6I9EPdrHJlLOT7ScPKLoxafZsHbffl
 AFW3FWaC1r4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="620423493"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2021 09:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 7/8] ice: enable receive hardware timestamping
Date:   Fri, 11 Jun 2021 09:19:59 -0700
Message-Id: <20210611162000.2438023-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Add SIOCGHWTSTAMP and SIOCSHWTSTAMP ioctl handlers to respond to
requests to enable timestamping support. If the request is for enabling
Rx timestamps, set a bit in the Rx descriptors to indicate that receive
timestamps should be reported.

Hardware captures receive timestamps in the PHY which only captures part
of the timer, and reports only 40 bits into the Rx descriptor. The upper
32 bits represent the contents of GLTSYN_TIME_L at the point of packet
reception, while the lower 8 bits represent the upper 8 bits of
GLTSYN_TIME_0.

The networking and PTP stack expect 64 bit timestamps in nanoseconds. To
support this, implement some logic to extend the timestamps by using the
full PHC time.

If the Rx timestamp was captured prior to the PHC time, then the real
timestamp is

  PHC - (lower_32_bits(PHC) - timestamp)

If the Rx timestamp was captured after the PHC time, then the real
timestamp is

  PHC + (timestamp - lower_32_bits(PHC))

These calculations are correct as long as neither the PHC timestamp nor
the Rx timestamps are more than 2^32-1 nanseconds old. Further, we can
detect when the Rx timestamp is before or after the PHC as long as the
PHC timestamp is no more than 2^31-1 nanoseconds old.

In that case, we calculate the delta between the lower 32 bits of the
PHC and the Rx timestamp. If it's larger than 2^31-1 then the Rx
timestamp must have been captured in the past. If it's smaller, then the
Rx timestamp must have been captured after PHC time.

Add an ice_ptp_extend_32b_ts function that relies on a cached copy of
the PHC time and implements this algorithm to calculate the proper upper
32bits of the Rx timestamps.

Cache the PHC time periodically in all of the Rx rings. This enables
each Rx ring to simply call the extension function with a recent copy of
the PHC time. By ensuring that the PHC time is kept up to date
periodically, we ensure this algorithm doesn't use stale data and
produce incorrect results.

To cache the time, introduce a kworker and a kwork item to periodically
store the Rx time. It might seem like we should use the .do_aux_work
interface of the PTP clock. This doesn't work because all PFs must cache
this time, but only one PF owns the PTP clock device.

Thus, the ice driver will manage its own kthread instead of relying on
the PTP do_aux_work handler.

With this change, the driver can now report Rx timestamps on all
incoming packets.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c     |   5 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   7 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |   8 +-
 drivers/net/ethernet/intel/ice/ice_lib.h      |   3 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  22 ++
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 337 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp.h      |  29 ++
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   2 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   3 +
 9 files changed, 410 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 142d660010c6..0b44baf0dcff 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -393,9 +393,10 @@ static int ice_setup_rx_ctx(struct ice_ring *ring)
 	 * of same priority
 	 */
 	if (vsi->type != ICE_VSI_VF)
-		ice_write_qrxflxp_cntxt(hw, pf_q, rxdid, 0x3);
+		ice_write_qrxflxp_cntxt(hw, pf_q, rxdid, 0x3, true);
 	else
-		ice_write_qrxflxp_cntxt(hw, pf_q, ICE_RXDID_LEGACY_1, 0x3);
+		ice_write_qrxflxp_cntxt(hw, pf_q, ICE_RXDID_LEGACY_1, 0x3,
+					false);
 
 	/* Absolute queue number out of 2K needs to be passed */
 	err = ice_write_rxq_ctx(hw, &rlan_ctx, pf_q);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 01466b9f29b7..38d784742bf3 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3204,13 +3204,16 @@ ice_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	if (!test_bit(ICE_FLAG_PTP, pf->flags))
 		return ethtool_op_get_ts_info(dev, info);
 
-	info->so_timestamping = SOF_TIMESTAMPING_SOFTWARE;
+	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
 
 	info->phc_index = ice_get_ptp_clock_index(pf);
 
 	info->tx_types = BIT(HWTSTAMP_TX_OFF);
 
-	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index db36ce9c0b1c..7bb10fa032e1 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1675,9 +1675,11 @@ void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
  * @pf_q: index of the Rx queue in the PF's queue space
  * @rxdid: flexible descriptor RXDID
  * @prio: priority for the RXDID for this queue
+ * @ena_ts: true to enable timestamp and false to disable timestamp
  */
 void
-ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio)
+ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio,
+			bool ena_ts)
 {
 	int regval = rd32(hw, QRXFLXP_CNTXT(pf_q));
 
@@ -1692,6 +1694,10 @@ ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio)
 	regval |= (prio << QRXFLXP_CNTXT_RXDID_PRIO_S) &
 		QRXFLXP_CNTXT_RXDID_PRIO_M;
 
+	if (ena_ts)
+		/* Enable TimeSync on this queue */
+		regval |= QRXFLXP_CNTXT_TS_M;
+
 	wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 6e2b8c2c8aa0..d5a28bf0fc2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -80,7 +80,8 @@ bool ice_is_reset_in_progress(unsigned long *state);
 int ice_wait_for_reset(struct ice_pf *pf, unsigned long timeout);
 
 void
-ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio);
+ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio,
+			bool ena_ts);
 
 void ice_vsi_dis_irq(struct ice_vsi *vsi);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 611f111daa8f..082e704472be 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6519,6 +6519,27 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	return err;
 }
 
+/**
+ * ice_do_ioctl - Access the hwtstamp interface
+ * @netdev: network interface device structure
+ * @ifr: interface request data
+ * @cmd: ioctl command
+ */
+static int ice_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_pf *pf = np->vsi->back;
+
+	switch (cmd) {
+	case SIOCGHWTSTAMP:
+		return ice_ptp_get_ts_config(pf, ifr);
+	case SIOCSHWTSTAMP:
+		return ice_ptp_set_ts_config(pf, ifr);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 /**
  * ice_aq_str - convert AQ err code to a string
  * @aq_err: the AQ error code to convert
@@ -7169,6 +7190,7 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_change_mtu = ice_change_mtu,
 	.ndo_get_stats64 = ice_get_stats64,
 	.ndo_set_tx_maxrate = ice_set_tx_maxrate,
+	.ndo_do_ioctl = ice_do_ioctl,
 	.ndo_set_vf_spoofchk = ice_set_vf_spoofchk,
 	.ndo_set_vf_mac = ice_set_vf_mac,
 	.ndo_get_vf_config = ice_get_vf_cfg,
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 82be5846b42f..b22b7a93f6ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -4,6 +4,46 @@
 #include "ice.h"
 #include "ice_lib.h"
 
+/**
+ * ice_set_rx_tstamp - Enable or disable Rx timestamping
+ * @pf: The PF pointer to search in
+ * @on: bool value for whether timestamps are enabled or disabled
+ */
+static void ice_set_rx_tstamp(struct ice_pf *pf, bool on)
+{
+	struct ice_vsi *vsi;
+	u16 i;
+
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi)
+		return;
+
+	/* Set the timestamp flag for all the Rx rings */
+	ice_for_each_rxq(vsi, i) {
+		if (!vsi->rx_rings[i])
+			continue;
+		vsi->rx_rings[i]->ptp_rx = on;
+	}
+}
+
+/**
+ * ice_ptp_cfg_timestamp - Configure timestamp for init/deinit
+ * @pf: Board private structure
+ * @ena: bool value to enable or disable time stamp
+ *
+ * This function will configure timestamping during PTP initialization
+ * and deinitialization
+ */
+static void ice_ptp_cfg_timestamp(struct ice_pf *pf, bool ena)
+{
+	ice_set_rx_tstamp(pf, ena);
+
+	if (ena)
+		pf->ptp.tstamp_config.rx_filter = HWTSTAMP_FILTER_ALL;
+	else
+		pf->ptp.tstamp_config.rx_filter = HWTSTAMP_FILTER_NONE;
+}
+
 /**
  * ice_get_ptp_clock_index - Get the PTP clock index
  * @pf: the PF pointer
@@ -171,6 +211,113 @@ ice_ptp_read_src_clk_reg(struct ice_pf *pf, struct ptp_system_timestamp *sts)
 	return ((u64)hi << 32) | lo;
 }
 
+/**
+ * ice_ptp_update_cached_phctime - Update the cached PHC time values
+ * @pf: Board specific private structure
+ *
+ * This function updates the system time values which are cached in the PF
+ * structure and the Rx rings.
+ *
+ * This function must be called periodically to ensure that the cached value
+ * is never more than 2 seconds old. It must also be called whenever the PHC
+ * time has been changed.
+ */
+static void ice_ptp_update_cached_phctime(struct ice_pf *pf)
+{
+	u64 systime;
+	int i;
+
+	/* Read the current PHC time */
+	systime = ice_ptp_read_src_clk_reg(pf, NULL);
+
+	/* Update the cached PHC time stored in the PF structure */
+	WRITE_ONCE(pf->ptp.cached_phc_time, systime);
+
+	ice_for_each_vsi(pf, i) {
+		struct ice_vsi *vsi = pf->vsi[i];
+		int j;
+
+		if (!vsi)
+			continue;
+
+		if (vsi->type != ICE_VSI_PF)
+			continue;
+
+		ice_for_each_rxq(vsi, j) {
+			if (!vsi->rx_rings[j])
+				continue;
+			WRITE_ONCE(vsi->rx_rings[j]->cached_phctime, systime);
+		}
+	}
+}
+
+/**
+ * ice_ptp_extend_32b_ts - Convert a 32b nanoseconds timestamp to 64b
+ * @cached_phc_time: recently cached copy of PHC time
+ * @in_tstamp: Ingress/egress 32b nanoseconds timestamp value
+ *
+ * Hardware captures timestamps which contain only 32 bits of nominal
+ * nanoseconds, as opposed to the 64bit timestamps that the stack expects.
+ * Note that the captured timestamp values may be 40 bits, but the lower
+ * 8 bits are sub-nanoseconds and generally discarded.
+ *
+ * Extend the 32bit nanosecond timestamp using the following algorithm and
+ * assumptions:
+ *
+ * 1) have a recently cached copy of the PHC time
+ * 2) assume that the in_tstamp was captured 2^31 nanoseconds (~2.1
+ *    seconds) before or after the PHC time was captured.
+ * 3) calculate the delta between the cached time and the timestamp
+ * 4) if the delta is smaller than 2^31 nanoseconds, then the timestamp was
+ *    captured after the PHC time. In this case, the full timestamp is just
+ *    the cached PHC time plus the delta.
+ * 5) otherwise, if the delta is larger than 2^31 nanoseconds, then the
+ *    timestamp was captured *before* the PHC time, i.e. because the PHC
+ *    cache was updated after the timestamp was captured by hardware. In this
+ *    case, the full timestamp is the cached time minus the inverse delta.
+ *
+ * This algorithm works even if the PHC time was updated after a Tx timestamp
+ * was requested, but before the Tx timestamp event was reported from
+ * hardware.
+ *
+ * This calculation primarily relies on keeping the cached PHC time up to
+ * date. If the timestamp was captured more than 2^31 nanoseconds after the
+ * PHC time, it is possible that the lower 32bits of PHC time have
+ * overflowed more than once, and we might generate an incorrect timestamp.
+ *
+ * This is prevented by (a) periodically updating the cached PHC time once
+ * a second, and (b) discarding any Tx timestamp packet if it has waited for
+ * a timestamp for more than one second.
+ */
+static u64 ice_ptp_extend_32b_ts(u64 cached_phc_time, u32 in_tstamp)
+{
+	u32 delta, phc_time_lo;
+	u64 ns;
+
+	/* Extract the lower 32 bits of the PHC time */
+	phc_time_lo = (u32)cached_phc_time;
+
+	/* Calculate the delta between the lower 32bits of the cached PHC
+	 * time and the in_tstamp value
+	 */
+	delta = (in_tstamp - phc_time_lo);
+
+	/* Do not assume that the in_tstamp is always more recent than the
+	 * cached PHC time. If the delta is large, it indicates that the
+	 * in_tstamp was taken in the past, and should be converted
+	 * forward.
+	 */
+	if (delta > (U32_MAX / 2)) {
+		/* reverse the delta calculation here */
+		delta = (phc_time_lo - in_tstamp);
+		ns = cached_phc_time - delta;
+	} else {
+		ns = cached_phc_time + delta;
+	}
+
+	return ns;
+}
+
 /**
  * ice_ptp_read_time - Read the time from the device
  * @pf: Board private structure
@@ -323,6 +470,9 @@ ice_ptp_settime64(struct ptp_clock_info *info, const struct timespec64 *ts)
 	err = ice_ptp_write_init(pf, &ts64);
 	ice_ptp_unlock(hw);
 
+	if (!err)
+		ice_ptp_update_cached_phctime(pf);
+
 exit:
 	if (err) {
 		dev_err(ice_pf_to_dev(pf), "PTP failed to set time %d\n", err);
@@ -385,9 +535,142 @@ static int ice_ptp_adjtime(struct ptp_clock_info *info, s64 delta)
 		return err;
 	}
 
+	ice_ptp_update_cached_phctime(pf);
+
+	return 0;
+}
+
+/**
+ * ice_ptp_get_ts_config - ioctl interface to read the timestamping config
+ * @pf: Board private structure
+ * @ifr: ioctl data
+ *
+ * Copy the timestamping config to user buffer
+ */
+int ice_ptp_get_ts_config(struct ice_pf *pf, struct ifreq *ifr)
+{
+	struct hwtstamp_config *config;
+
+	if (!test_bit(ICE_FLAG_PTP, pf->flags))
+		return -EIO;
+
+	config = &pf->ptp.tstamp_config;
+
+	return copy_to_user(ifr->ifr_data, config, sizeof(*config)) ?
+		-EFAULT : 0;
+}
+
+/**
+ * ice_ptp_set_timestamp_mode - Setup driver for requested timestamp mode
+ * @pf: Board private structure
+ * @config: hwtstamp settings requested or saved
+ */
+static int
+ice_ptp_set_timestamp_mode(struct ice_pf *pf, struct hwtstamp_config *config)
+{
+	/* Reserved for future extensions. */
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_OFF:
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		ice_set_rx_tstamp(pf, false);
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_NTP_ALL:
+	case HWTSTAMP_FILTER_ALL:
+		config->rx_filter = HWTSTAMP_FILTER_ALL;
+		ice_set_rx_tstamp(pf, true);
+		break;
+	default:
+		return -ERANGE;
+	}
+
 	return 0;
 }
 
+/**
+ * ice_ptp_set_ts_config - ioctl interface to control the timestamping
+ * @pf: Board private structure
+ * @ifr: ioctl data
+ *
+ * Get the user config and store it
+ */
+int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr)
+{
+	struct hwtstamp_config config;
+	int err;
+
+	if (!test_bit(ICE_FLAG_PTP, pf->flags))
+		return -EAGAIN;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	err = ice_ptp_set_timestamp_mode(pf, &config);
+	if (err)
+		return err;
+
+	/* Save these settings for future reference */
+	pf->ptp.tstamp_config = config;
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
+/**
+ * ice_ptp_rx_hwtstamp - Check for an Rx timestamp
+ * @rx_ring: Ring to get the VSI info
+ * @rx_desc: Receive descriptor
+ * @skb: Particular skb to send timestamp with
+ *
+ * The driver receives a notification in the receive descriptor with timestamp.
+ * The timestamp is in ns, so we must convert the result first.
+ */
+void
+ice_ptp_rx_hwtstamp(struct ice_ring *rx_ring,
+		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb)
+{
+	u32 ts_high;
+	u64 ts_ns;
+
+	/* Populate timesync data into skb */
+	if (rx_desc->wb.time_stamp_low & ICE_PTP_TS_VALID) {
+		struct skb_shared_hwtstamps *hwtstamps;
+
+		/* Use ice_ptp_extend_32b_ts directly, using the ring-specific
+		 * cached PHC value, rather than accessing the PF. This also
+		 * allows us to simply pass the upper 32bits of nanoseconds
+		 * directly. Calling ice_ptp_extend_40b_ts is unnecessary as
+		 * it would just discard these bits itself.
+		 */
+		ts_high = le32_to_cpu(rx_desc->wb.flex_ts.ts_high);
+		ts_ns = ice_ptp_extend_32b_ts(rx_ring->cached_phctime, ts_high);
+
+		hwtstamps = skb_hwtstamps(skb);
+		memset(hwtstamps, 0, sizeof(*hwtstamps));
+		hwtstamps->hwtstamp = ns_to_ktime(ts_ns);
+	}
+}
+
 /**
  * ice_ptp_set_caps - Set PTP capabilities
  * @pf: Board private structure
@@ -441,6 +724,21 @@ static long ice_ptp_create_clock(struct ice_pf *pf)
 	return 0;
 }
 
+static void ice_ptp_periodic_work(struct kthread_work *work)
+{
+	struct ice_ptp *ptp = container_of(work, struct ice_ptp, work.work);
+	struct ice_pf *pf = container_of(ptp, struct ice_pf, ptp);
+
+	if (!test_bit(ICE_FLAG_PTP, pf->flags))
+		return;
+
+	ice_ptp_update_cached_phctime(pf);
+
+	/* Run twice a second */
+	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
+				   msecs_to_jiffies(500));
+}
+
 /**
  * ice_ptp_init_owner - Initialize PTP_1588_CLOCK device
  * @pf: Board private structure
@@ -526,6 +824,7 @@ static int ice_ptp_init_owner(struct ice_pf *pf)
 void ice_ptp_init(struct ice_pf *pf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
+	struct kthread_worker *kworker;
 	struct ice_hw *hw = &pf->hw;
 	int err;
 
@@ -540,9 +839,37 @@ void ice_ptp_init(struct ice_pf *pf)
 			return;
 	}
 
+	/* Disable timestamping for both Tx and Rx */
+	ice_ptp_cfg_timestamp(pf, false);
+
+	/* Initialize work functions */
+	kthread_init_delayed_work(&pf->ptp.work, ice_ptp_periodic_work);
+
+	/* Allocate a kworker for handling work required for the ports
+	 * connected to the PTP hardware clock.
+	 */
+	kworker = kthread_create_worker(0, "ice-ptp-%s", dev_name(dev));
+	if (IS_ERR(kworker)) {
+		err = PTR_ERR(kworker);
+		goto err_kworker;
+	}
+	pf->ptp.kworker = kworker;
+
 	set_bit(ICE_FLAG_PTP, pf->flags);
 
+	/* Start periodic work going */
+	kthread_queue_delayed_work(pf->ptp.kworker, &pf->ptp.work, 0);
+
 	dev_info(dev, "PTP init successful\n");
+	return;
+
+err_kworker:
+	/* If we registered a PTP clock, release it */
+	if (pf->ptp.clock) {
+		ptp_clock_unregister(pf->ptp.clock);
+		pf->ptp.clock = NULL;
+	}
+	dev_err(dev, "PTP failed %d\n", err);
 }
 
 /**
@@ -554,8 +881,18 @@ void ice_ptp_init(struct ice_pf *pf)
  */
 void ice_ptp_release(struct ice_pf *pf)
 {
+	/* Disable timestamping for both Tx and Rx */
+	ice_ptp_cfg_timestamp(pf, false);
+
 	clear_bit(ICE_FLAG_PTP, pf->flags);
 
+	kthread_cancel_delayed_work_sync(&pf->ptp.work);
+
+	if (pf->ptp.kworker) {
+		kthread_destroy_worker(pf->ptp.kworker);
+		pf->ptp.kworker = NULL;
+	}
+
 	if (!pf->ptp.clock)
 		return;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 01f7db05ef7d..48850391ab28 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -5,17 +5,26 @@
 #define _ICE_PTP_H_
 
 #include <linux/ptp_clock_kernel.h>
+#include <linux/kthread.h>
 
 #include "ice_ptp_hw.h"
 
 /**
  * struct ice_ptp - data used for integrating with CONFIG_PTP_1588_CLOCK
+ * @work: delayed work function for periodic tasks
+ * @cached_phc_time: a cached copy of the PHC time for timestamp extension
+ * @kworker: kwork thread for handling periodic work
  * @info: structure defining PTP hardware capabilities
  * @clock: pointer to registered PTP clock device
+ * @tstamp_config: hardware timestamping configuration
  */
 struct ice_ptp {
+	struct kthread_delayed_work work;
+	u64 cached_phc_time;
+	struct kthread_worker *kworker;
 	struct ptp_clock_info info;
 	struct ptp_clock *clock;
+	struct hwtstamp_config tstamp_config;
 };
 
 #define __ptp_info_to_ptp(i) \
@@ -24,17 +33,37 @@ struct ice_ptp {
 	container_of(__ptp_info_to_ptp((i)), struct ice_pf, ptp)
 
 #define PTP_SHARED_CLK_IDX_VALID	BIT(31)
+#define ICE_PTP_TS_VALID		BIT(0)
 
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
 struct ice_pf;
+int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr);
+int ice_ptp_get_ts_config(struct ice_pf *pf, struct ifreq *ifr);
 int ice_get_ptp_clock_index(struct ice_pf *pf);
+void
+ice_ptp_rx_hwtstamp(struct ice_ring *rx_ring,
+		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb);
 void ice_ptp_init(struct ice_pf *pf);
 void ice_ptp_release(struct ice_pf *pf);
 #else /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
+static inline int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ice_ptp_get_ts_config(struct ice_pf *pf, struct ifreq *ifr)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int ice_get_ptp_clock_index(struct ice_pf *pf)
 {
 	return -1;
 }
+
+static inline void
+ice_ptp_rx_hwtstamp(struct ice_ring *rx_ring,
+		    union ice_32b_rx_flex_desc *rx_desc, struct sk_buff *skb) { }
 static inline void ice_ptp_init(struct ice_pf *pf) { }
 static inline void ice_ptp_release(struct ice_pf *pf) { }
 #endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index c5a92ac787d6..1069f3a9b6cb 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -311,6 +311,8 @@ struct ice_ring {
 	u32 txq_teid;			/* Added Tx queue TEID */
 	u16 rx_buf_len;
 	u8 dcb_tc;			/* Traffic class of ring */
+	u64 cached_phctime;
+	u8 ptp_rx:1;
 } ____cacheline_internodealigned_in_smp;
 
 static inline bool ice_ring_uses_build_skb(struct ice_ring *ring)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 207f6ee3a7f6..166cf25d1139 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -175,6 +175,9 @@ ice_process_skb_fields(struct ice_ring *rx_ring,
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
 
 	ice_rx_csum(rx_ring, skb, rx_desc, ptype);
+
+	if (rx_ring->ptp_rx)
+		ice_ptp_rx_hwtstamp(rx_ring, rx_desc, skb);
 }
 
 /**
-- 
2.26.2

