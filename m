Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F751AE50D
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbgDQSnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:43:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:56864 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729653AbgDQSmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 14:42:54 -0400
IronPort-SDR: WCX9ySNlkhU9td1IThx5opVrgMGcZhnPbTsVNVMt0NHBaDGGeiPnI09+Pl7BCM1ayiZXw8kU2e
 1M0FvAD3J3bA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:42:52 -0700
IronPort-SDR: upUOLruNn1vsFWOT9a397qFw7PXs3+cRvMVxOJEr5hAMvz/Lud9IRfJJ7s96ZeK03vQ58xTF3M
 q1F7JuZRY8qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="254294362"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 11:42:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andre Guedes <andre.guedes@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/14] igc: Add support for ETF offloading
Date:   Fri, 17 Apr 2020 11:42:40 -0700
Message-Id: <20200417184251.1962762-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
References: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

This adds support for ETF offloading for the i225 controller.

For i225, the LaunchTime feature is almost a subset of the Qbv
feature. The main change from the i210 is that the launchtime of each
packet is specified as an offset applied to the BASET register. BASET
is automatically incremented each cycle.

For i225, the approach chosen is to re-use most of the setup used for
taprio offloading. With a few changes:

 - The more or less obvious one is that when ETF is enabled, we should
 set add the expected launchtime to the (advanced) transmit
 descriptor;

 - The less obvious, is that when taprio offloading is not enabled, we
 add a dummy schedule (all queues are open all the time, with a cycle
 time of 1 second).

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c    | 70 +++++++++++++++++++-
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 19 +++++-
 3 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 2da5a9b012af..1b0fd2ffd08d 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -440,6 +440,7 @@
 #define IGC_TQAVCTRL_TRANSMIT_MODE_TSN	0x00000001
 #define IGC_TQAVCTRL_ENHANCED_QAV	0x00000008
 
+#define IGC_TXQCTL_QUEUE_MODE_LAUNCHT	0x00000001
 #define IGC_TXQCTL_STRICT_CYCLE		0x00000002
 #define IGC_TXQCTL_STRICT_END		0x00000004
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 12d672a6bc45..896b314035c9 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -869,6 +869,23 @@ static int igc_write_mc_addr_list(struct net_device *netdev)
 	return netdev_mc_count(netdev);
 }
 
+static __le32 igc_tx_launchtime(struct igc_adapter *adapter, ktime_t txtime)
+{
+	ktime_t cycle_time = adapter->cycle_time;
+	ktime_t base_time = adapter->base_time;
+	u32 launchtime;
+
+	/* FIXME: when using ETF together with taprio, we may have a
+	 * case where 'delta' is larger than the cycle_time, this may
+	 * cause problems if we don't read the current value of
+	 * IGC_BASET, as the value writen into the launchtime
+	 * descriptor field may be misinterpreted.
+	 */
+	div_s64_rem(ktime_sub_ns(txtime, base_time), cycle_time, &launchtime);
+
+	return cpu_to_le32(launchtime);
+}
+
 static void igc_tx_ctxtdesc(struct igc_ring *tx_ring,
 			    struct igc_tx_buffer *first,
 			    u32 vlan_macip_lens, u32 type_tucmd,
@@ -876,7 +893,6 @@ static void igc_tx_ctxtdesc(struct igc_ring *tx_ring,
 {
 	struct igc_adv_tx_context_desc *context_desc;
 	u16 i = tx_ring->next_to_use;
-	struct timespec64 ts;
 
 	context_desc = IGC_TX_CTXTDESC(tx_ring, i);
 
@@ -898,9 +914,12 @@ static void igc_tx_ctxtdesc(struct igc_ring *tx_ring,
 	 * should have been handled by the upper layers.
 	 */
 	if (tx_ring->launchtime_enable) {
-		ts = ktime_to_timespec64(first->skb->tstamp);
+		struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
+		ktime_t txtime = first->skb->tstamp;
+
 		first->skb->tstamp = ktime_set(0, 0);
-		context_desc->launch_time = cpu_to_le32(ts.tv_nsec / 32);
+		context_desc->launch_time = igc_tx_launchtime(adapter,
+							      txtime);
 	} else {
 		context_desc->launch_time = 0;
 	}
@@ -4496,6 +4515,32 @@ static int igc_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	}
 }
 
+static int igc_save_launchtime_params(struct igc_adapter *adapter, int queue,
+				      bool enable)
+{
+	struct igc_ring *ring;
+	int i;
+
+	if (queue < 0 || queue >= adapter->num_tx_queues)
+		return -EINVAL;
+
+	ring = adapter->tx_ring[queue];
+	ring->launchtime_enable = enable;
+
+	if (adapter->base_time)
+		return 0;
+
+	adapter->cycle_time = NSEC_PER_SEC;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		ring = adapter->tx_ring[i];
+		ring->start_time = 0;
+		ring->end_time = NSEC_PER_SEC;
+	}
+
+	return 0;
+}
+
 static bool validate_schedule(const struct tc_taprio_qopt_offload *qopt)
 {
 	int queue_uses[IGC_MAX_TX_QUEUES] = { };
@@ -4528,6 +4573,22 @@ static bool validate_schedule(const struct tc_taprio_qopt_offload *qopt)
 	return true;
 }
 
+static int igc_tsn_enable_launchtime(struct igc_adapter *adapter,
+				     struct tc_etf_qopt_offload *qopt)
+{
+	struct igc_hw *hw = &adapter->hw;
+	int err;
+
+	if (hw->mac.type != igc_i225)
+		return -EOPNOTSUPP;
+
+	err = igc_save_launchtime_params(adapter, qopt->queue, qopt->enable);
+	if (err)
+		return err;
+
+	return igc_tsn_offload_apply(adapter);
+}
+
 static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 				 struct tc_taprio_qopt_offload *qopt)
 {
@@ -4598,6 +4659,9 @@ static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_TAPRIO:
 		return igc_tsn_enable_qbv_scheduling(adapter, type_data);
 
+	case TC_SETUP_QDISC_ETF:
+		return igc_tsn_enable_launchtime(adapter, type_data);
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 257fe970afe8..174103c4bea6 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -4,6 +4,20 @@
 #include "igc.h"
 #include "igc_tsn.h"
 
+static bool is_any_launchtime(struct igc_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+
+		if (ring->launchtime_enable)
+			return true;
+	}
+
+	return false;
+}
+
 /* Returns the TSN specific registers to their default values after
  * TSN offloading is disabled.
  */
@@ -88,6 +102,9 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 				IGC_TXQCTL_STRICT_END;
 		}
 
+		if (ring->launchtime_enable)
+			txqctl |= IGC_TXQCTL_QUEUE_MODE_LAUNCHT;
+
 		wr32(IGC_TXQCTL(i), txqctl);
 	}
 
@@ -115,7 +132,7 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 
 int igc_tsn_offload_apply(struct igc_adapter *adapter)
 {
-	bool is_any_enabled = adapter->base_time;
+	bool is_any_enabled = adapter->base_time || is_any_launchtime(adapter);
 
 	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED) && !is_any_enabled)
 		return 0;
-- 
2.25.2

