Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8375120EAE5
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgF3B2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:28:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:52168 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728565AbgF3B15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:27:57 -0400
IronPort-SDR: WxmfAI/Osl85/lT79jxuJJetZ5LMwfeO9sLY/Aw85zupnmnoXZ15ByYhPxIcottKg954QRYUTs
 aJHrUJoxqliQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="144305922"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="144305922"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:27:50 -0700
IronPort-SDR: 1uBmo99MyL570fXgm9ch5RKNs7uCA/2kcRJYxpW2NOaSuZUVQPplIbeyCoI4ntLK0uy4Yx2Ofm
 ERgBKa9ajtPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="425017695"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 18:27:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 02/13] igc: Add initial LTR support
Date:   Mon, 29 Jun 2020 18:27:37 -0700
Message-Id: <20200630012748.518705-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
References: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

The LTR message on the PCIe inform the requested latency
on which the PCIe must become active to the downstream
PCIe port of the system.
This patch provide recommended LTR parameters by i225
specification.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  27 +++++
 drivers/net/ethernet/intel/igc/igc_i225.c    | 100 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_i225.h    |   1 +
 drivers/net/ethernet/intel/igc/igc_mac.c     |   5 +
 drivers/net/ethernet/intel/igc/igc_regs.h    |   6 ++
 5 files changed, 139 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index ee7fa1c062a0..ed0e560daaae 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -521,4 +521,31 @@
 #define IGC_EEER_LPI_FC			0x00040000 /* EEER Ena on Flow Cntrl */
 #define IGC_EEE_SU_LPI_CLK_STP		0x00800000 /* EEE LPI Clock Stop */
 
+/* LTR defines */
+#define IGC_LTRC_EEEMS_EN		0x00000020 /* Enable EEE LTR max send */
+#define IGC_RXPBS_SIZE_I225_MASK	0x0000003F /* Rx packet buffer size */
+#define IGC_TW_SYSTEM_1000_MASK		0x000000FF
+/* Minimum time for 100BASE-T where no data will be transmit following move out
+ * of EEE LPI Tx state
+ */
+#define IGC_TW_SYSTEM_100_MASK		0x0000FF00
+#define IGC_TW_SYSTEM_100_SHIFT		8
+#define IGC_DMACR_DMAC_EN		0x80000000 /* Enable DMA Coalescing */
+#define IGC_DMACR_DMACTHR_MASK		0x00FF0000
+#define IGC_DMACR_DMACTHR_SHIFT		16
+/* Reg val to set scale to 1024 nsec */
+#define IGC_LTRMINV_SCALE_1024		2
+/* Reg val to set scale to 32768 nsec */
+#define IGC_LTRMINV_SCALE_32768		3
+/* Reg val to set scale to 1024 nsec */
+#define IGC_LTRMAXV_SCALE_1024		2
+/* Reg val to set scale to 32768 nsec */
+#define IGC_LTRMAXV_SCALE_32768		3
+#define IGC_LTRMINV_LTRV_MASK		0x000003FF /* LTR minimum value */
+#define IGC_LTRMAXV_LTRV_MASK		0x000003FF /* LTR maximum value */
+#define IGC_LTRMINV_LSNP_REQ		0x00008000 /* LTR Snoop Requirement */
+#define IGC_LTRMINV_SCALE_SHIFT		10
+#define IGC_LTRMAXV_LSNP_REQ		0x00008000 /* LTR Snoop Requirement */
+#define IGC_LTRMAXV_SCALE_SHIFT		10
+
 #endif /* _IGC_DEFINES_H_ */
diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index 3a4e982edb67..8b67d9b49a83 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -544,3 +544,103 @@ s32 igc_set_eee_i225(struct igc_hw *hw, bool adv2p5G, bool adv1G,
 
 	return IGC_SUCCESS;
 }
+
+/* igc_set_ltr_i225 - Set Latency Tolerance Reporting thresholds
+ * @hw: pointer to the HW structure
+ * @link: bool indicating link status
+ *
+ * Set the LTR thresholds based on the link speed (Mbps), EEE, and DMAC
+ * settings, otherwise specify that there is no LTR requirement.
+ */
+s32 igc_set_ltr_i225(struct igc_hw *hw, bool link)
+{
+	u32 tw_system, ltrc, ltrv, ltr_min, ltr_max, scale_min, scale_max;
+	u16 speed, duplex;
+	s32 size;
+
+	/* If we do not have link, LTR thresholds are zero. */
+	if (link) {
+		hw->mac.ops.get_speed_and_duplex(hw, &speed, &duplex);
+
+		/* Check if using copper interface with EEE enabled or if the
+		 * link speed is 10 Mbps.
+		 */
+		if (hw->dev_spec._base.eee_enable &&
+		    speed != SPEED_10) {
+			/* EEE enabled, so send LTRMAX threshold. */
+			ltrc = rd32(IGC_LTRC) |
+			       IGC_LTRC_EEEMS_EN;
+			wr32(IGC_LTRC, ltrc);
+
+			/* Calculate tw_system (nsec). */
+			if (speed == SPEED_100) {
+				tw_system = ((rd32(IGC_EEE_SU) &
+					     IGC_TW_SYSTEM_100_MASK) >>
+					     IGC_TW_SYSTEM_100_SHIFT) * 500;
+			} else {
+				tw_system = (rd32(IGC_EEE_SU) &
+					     IGC_TW_SYSTEM_1000_MASK) * 500;
+			}
+		} else {
+			tw_system = 0;
+		}
+
+		/* Get the Rx packet buffer size. */
+		size = rd32(IGC_RXPBS) &
+		       IGC_RXPBS_SIZE_I225_MASK;
+
+		/* Calculations vary based on DMAC settings. */
+		if (rd32(IGC_DMACR) & IGC_DMACR_DMAC_EN) {
+			size -= (rd32(IGC_DMACR) &
+				 IGC_DMACR_DMACTHR_MASK) >>
+				 IGC_DMACR_DMACTHR_SHIFT;
+			/* Convert size to bits. */
+			size *= 1024 * 8;
+		} else {
+			/* Convert size to bytes, subtract the MTU, and then
+			 * convert the size to bits.
+			 */
+			size *= 1024;
+			size *= 8;
+		}
+
+		if (size < 0) {
+			hw_dbg("Invalid effective Rx buffer size %d\n",
+			       size);
+			return -IGC_ERR_CONFIG;
+		}
+
+		/* Calculate the thresholds. Since speed is in Mbps, simplify
+		 * the calculation by multiplying size/speed by 1000 for result
+		 * to be in nsec before dividing by the scale in nsec. Set the
+		 * scale such that the LTR threshold fits in the register.
+		 */
+		ltr_min = (1000 * size) / speed;
+		ltr_max = ltr_min + tw_system;
+		scale_min = (ltr_min / 1024) < 1024 ? IGC_LTRMINV_SCALE_1024 :
+			    IGC_LTRMINV_SCALE_32768;
+		scale_max = (ltr_max / 1024) < 1024 ? IGC_LTRMAXV_SCALE_1024 :
+			    IGC_LTRMAXV_SCALE_32768;
+		ltr_min /= scale_min == IGC_LTRMINV_SCALE_1024 ? 1024 : 32768;
+		ltr_min -= 1;
+		ltr_max /= scale_max == IGC_LTRMAXV_SCALE_1024 ? 1024 : 32768;
+		ltr_max -= 1;
+
+		/* Only write the LTR thresholds if they differ from before. */
+		ltrv = rd32(IGC_LTRMINV);
+		if (ltr_min != (ltrv & IGC_LTRMINV_LTRV_MASK)) {
+			ltrv = IGC_LTRMINV_LSNP_REQ | ltr_min |
+			       (scale_min << IGC_LTRMINV_SCALE_SHIFT);
+			wr32(IGC_LTRMINV, ltrv);
+		}
+
+		ltrv = rd32(IGC_LTRMAXV);
+		if (ltr_max != (ltrv & IGC_LTRMAXV_LTRV_MASK)) {
+			ltrv = IGC_LTRMAXV_LSNP_REQ | ltr_max |
+			       (scale_min << IGC_LTRMAXV_SCALE_SHIFT);
+			wr32(IGC_LTRMAXV, ltrv);
+		}
+	}
+
+	return IGC_SUCCESS;
+}
diff --git a/drivers/net/ethernet/intel/igc/igc_i225.h b/drivers/net/ethernet/intel/igc/igc_i225.h
index 04759e076a9e..dae47e4f16b0 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.h
+++ b/drivers/net/ethernet/intel/igc/igc_i225.h
@@ -11,5 +11,6 @@ s32 igc_init_nvm_params_i225(struct igc_hw *hw);
 bool igc_get_flash_presence_i225(struct igc_hw *hw);
 s32 igc_set_eee_i225(struct igc_hw *hw, bool adv2p5G, bool adv1G,
 		     bool adv100M);
+s32 igc_set_ltr_i225(struct igc_hw *hw, bool link);
 
 #endif
diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 410aeb01de5c..bc077f230f17 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -417,6 +417,11 @@ s32 igc_check_for_copper_link(struct igc_hw *hw)
 		hw_dbg("Error configuring flow control\n");
 
 out:
+	/* Now that we are aware of our link settings, we can set the LTR
+	 * thresholds.
+	 */
+	ret_val = igc_set_ltr_i225(hw, link);
+
 	return ret_val;
 }
 
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 75e040a5d46f..97f9b928509f 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -253,6 +253,12 @@
 #define IGC_IPCNFG	0x0E38 /* Internal PHY Configuration */
 #define IGC_EEE_SU	0x0E34 /* EEE Setup */
 
+/* LTR registers */
+#define IGC_LTRC	0x01A0 /* Latency Tolerance Reporting Control */
+#define IGC_DMACR	0x02508 /* DMA Coalescing Control Register */
+#define IGC_LTRMINV	0x5BB0 /* LTR Minimum Value */
+#define IGC_LTRMAXV	0x5BB4 /* LTR Maximum Value */
+
 /* forward declaration */
 struct igc_hw;
 u32 igc_rd32(struct igc_hw *hw, u32 reg);
-- 
2.26.2

