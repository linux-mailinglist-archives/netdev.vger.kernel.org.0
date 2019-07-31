Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2697CEF0
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbfGaUlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:41:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:16005 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfGaUlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901007"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/16] ice: track hardware stat registers past rollover
Date:   Wed, 31 Jul 2019 13:41:33 -0700
Message-Id: <20190731204147.8582-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Currently, ice_stat_update32 and ice_stat_update40 will limit the
value of the software statistic to 32 or 40 bits wide, depending on
which register is being read.

This means that if a driver is running for a long time, the displayed
software register values will roll over to zero at 40 bits or 32 bits.

This occurs because the functions directly assign the difference between
the previous value and current value of the hardware statistic.

Instead, add this value to the current software statistic, and then
update the previous value.

In this way, each time ice_stat_update40 or ice_stat_update32 are
called, they will increment the software tracking value by the
difference of the hardware register from its last read. The software
tracking value will correctly count up until it overflows a u64.

The only requirement is that the ice_stat_update functions be called at
least once each time the hardware register overflows.

While we're fixing ice_stat_update40, modify it to use rd64 instead of
two calls to rd32. Additionally, drop the now unnecessary hireg
function parameter.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 57 +++++++-----
 drivers/net/ethernet/intel/ice/ice_common.h   |  4 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   | 30 -------
 drivers/net/ethernet/intel/ice/ice_lib.c      | 40 ++++-----
 drivers/net/ethernet/intel/ice/ice_main.c     | 90 ++++++++-----------
 5 files changed, 91 insertions(+), 130 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2e0731c1e1a3..4be3559de207 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3240,40 +3240,44 @@ void ice_replay_post(struct ice_hw *hw)
 /**
  * ice_stat_update40 - read 40 bit stat from the chip and update stat values
  * @hw: ptr to the hardware info
- * @hireg: high 32 bit HW register to read from
- * @loreg: low 32 bit HW register to read from
+ * @reg: offset of 64 bit HW register to read from
  * @prev_stat_loaded: bool to specify if previous stats are loaded
  * @prev_stat: ptr to previous loaded stat value
  * @cur_stat: ptr to current stat value
  */
 void
-ice_stat_update40(struct ice_hw *hw, u32 hireg, u32 loreg,
-		  bool prev_stat_loaded, u64 *prev_stat, u64 *cur_stat)
+ice_stat_update40(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
+		  u64 *prev_stat, u64 *cur_stat)
 {
-	u64 new_data;
-
-	new_data = rd32(hw, loreg);
-	new_data |= ((u64)(rd32(hw, hireg) & 0xFFFF)) << 32;
+	u64 new_data = rd64(hw, reg) & (BIT_ULL(40) - 1);
 
 	/* device stats are not reset at PFR, they likely will not be zeroed
-	 * when the driver starts. So save the first values read and use them as
-	 * offsets to be subtracted from the raw values in order to report stats
-	 * that count from zero.
+	 * when the driver starts. Thus, save the value from the first read
+	 * without adding to the statistic value so that we report stats which
+	 * count up from zero.
 	 */
-	if (!prev_stat_loaded)
+	if (!prev_stat_loaded) {
 		*prev_stat = new_data;
+		return;
+	}
+
+	/* Calculate the difference between the new and old values, and then
+	 * add it to the software stat value.
+	 */
 	if (new_data >= *prev_stat)
-		*cur_stat = new_data - *prev_stat;
+		*cur_stat += new_data - *prev_stat;
 	else
 		/* to manage the potential roll-over */
-		*cur_stat = (new_data + BIT_ULL(40)) - *prev_stat;
-	*cur_stat &= 0xFFFFFFFFFFULL;
+		*cur_stat += (new_data + BIT_ULL(40)) - *prev_stat;
+
+	/* Update the previously stored value to prepare for next read */
+	*prev_stat = new_data;
 }
 
 /**
  * ice_stat_update32 - read 32 bit stat from the chip and update stat values
  * @hw: ptr to the hardware info
- * @reg: HW register to read from
+ * @reg: offset of HW register to read from
  * @prev_stat_loaded: bool to specify if previous stats are loaded
  * @prev_stat: ptr to previous loaded stat value
  * @cur_stat: ptr to current stat value
@@ -3287,17 +3291,26 @@ ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 	new_data = rd32(hw, reg);
 
 	/* device stats are not reset at PFR, they likely will not be zeroed
-	 * when the driver starts. So save the first values read and use them as
-	 * offsets to be subtracted from the raw values in order to report stats
-	 * that count from zero.
+	 * when the driver starts. Thus, save the value from the first read
+	 * without adding to the statistic value so that we report stats which
+	 * count up from zero.
 	 */
-	if (!prev_stat_loaded)
+	if (!prev_stat_loaded) {
 		*prev_stat = new_data;
+		return;
+	}
+
+	/* Calculate the difference between the new and old values, and then
+	 * add it to the software stat value.
+	 */
 	if (new_data >= *prev_stat)
-		*cur_stat = new_data - *prev_stat;
+		*cur_stat += new_data - *prev_stat;
 	else
 		/* to manage the potential roll-over */
-		*cur_stat = (new_data + BIT_ULL(32)) - *prev_stat;
+		*cur_stat += (new_data + BIT_ULL(32)) - *prev_stat;
+
+	/* Update the previously stored value to prepare for next read */
+	*prev_stat = new_data;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index d1f8353fe6bb..68218e63afc2 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -123,8 +123,8 @@ enum ice_status ice_replay_vsi(struct ice_hw *hw, u16 vsi_handle);
 void ice_replay_post(struct ice_hw *hw);
 void ice_output_fw_log(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf);
 void
-ice_stat_update40(struct ice_hw *hw, u32 hireg, u32 loreg,
-		  bool prev_stat_loaded, u64 *prev_stat, u64 *cur_stat);
+ice_stat_update40(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
+		  u64 *prev_stat, u64 *cur_stat);
 void
 ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 6c5ce05742b1..3250dfc00002 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -281,14 +281,10 @@
 #define GL_PWR_MODE_CTL				0x000B820C
 #define GL_PWR_MODE_CTL_CAR_MAX_BW_S		30
 #define GL_PWR_MODE_CTL_CAR_MAX_BW_M		ICE_M(0x3, 30)
-#define GLPRT_BPRCH(_i)				(0x00381384 + ((_i) * 8))
 #define GLPRT_BPRCL(_i)				(0x00381380 + ((_i) * 8))
-#define GLPRT_BPTCH(_i)				(0x00381244 + ((_i) * 8))
 #define GLPRT_BPTCL(_i)				(0x00381240 + ((_i) * 8))
 #define GLPRT_CRCERRS(_i)			(0x00380100 + ((_i) * 8))
-#define GLPRT_GORCH(_i)				(0x00380004 + ((_i) * 8))
 #define GLPRT_GORCL(_i)				(0x00380000 + ((_i) * 8))
-#define GLPRT_GOTCH(_i)				(0x00380B44 + ((_i) * 8))
 #define GLPRT_GOTCL(_i)				(0x00380B40 + ((_i) * 8))
 #define GLPRT_ILLERRC(_i)			(0x003801C0 + ((_i) * 8))
 #define GLPRT_LXOFFRXC(_i)			(0x003802C0 + ((_i) * 8))
@@ -296,38 +292,22 @@
 #define GLPRT_LXONRXC(_i)			(0x00380280 + ((_i) * 8))
 #define GLPRT_LXONTXC(_i)			(0x00381140 + ((_i) * 8))
 #define GLPRT_MLFC(_i)				(0x00380040 + ((_i) * 8))
-#define GLPRT_MPRCH(_i)				(0x00381344 + ((_i) * 8))
 #define GLPRT_MPRCL(_i)				(0x00381340 + ((_i) * 8))
-#define GLPRT_MPTCH(_i)				(0x00381204 + ((_i) * 8))
 #define GLPRT_MPTCL(_i)				(0x00381200 + ((_i) * 8))
 #define GLPRT_MRFC(_i)				(0x00380080 + ((_i) * 8))
-#define GLPRT_PRC1023H(_i)			(0x00380A04 + ((_i) * 8))
 #define GLPRT_PRC1023L(_i)			(0x00380A00 + ((_i) * 8))
-#define GLPRT_PRC127H(_i)			(0x00380944 + ((_i) * 8))
 #define GLPRT_PRC127L(_i)			(0x00380940 + ((_i) * 8))
-#define GLPRT_PRC1522H(_i)			(0x00380A44 + ((_i) * 8))
 #define GLPRT_PRC1522L(_i)			(0x00380A40 + ((_i) * 8))
-#define GLPRT_PRC255H(_i)			(0x00380984 + ((_i) * 8))
 #define GLPRT_PRC255L(_i)			(0x00380980 + ((_i) * 8))
-#define GLPRT_PRC511H(_i)			(0x003809C4 + ((_i) * 8))
 #define GLPRT_PRC511L(_i)			(0x003809C0 + ((_i) * 8))
-#define GLPRT_PRC64H(_i)			(0x00380904 + ((_i) * 8))
 #define GLPRT_PRC64L(_i)			(0x00380900 + ((_i) * 8))
-#define GLPRT_PRC9522H(_i)			(0x00380A84 + ((_i) * 8))
 #define GLPRT_PRC9522L(_i)			(0x00380A80 + ((_i) * 8))
-#define GLPRT_PTC1023H(_i)			(0x00380C84 + ((_i) * 8))
 #define GLPRT_PTC1023L(_i)			(0x00380C80 + ((_i) * 8))
-#define GLPRT_PTC127H(_i)			(0x00380BC4 + ((_i) * 8))
 #define GLPRT_PTC127L(_i)			(0x00380BC0 + ((_i) * 8))
-#define GLPRT_PTC1522H(_i)			(0x00380CC4 + ((_i) * 8))
 #define GLPRT_PTC1522L(_i)			(0x00380CC0 + ((_i) * 8))
-#define GLPRT_PTC255H(_i)			(0x00380C04 + ((_i) * 8))
 #define GLPRT_PTC255L(_i)			(0x00380C00 + ((_i) * 8))
-#define GLPRT_PTC511H(_i)			(0x00380C44 + ((_i) * 8))
 #define GLPRT_PTC511L(_i)			(0x00380C40 + ((_i) * 8))
-#define GLPRT_PTC64H(_i)			(0x00380B84 + ((_i) * 8))
 #define GLPRT_PTC64L(_i)			(0x00380B80 + ((_i) * 8))
-#define GLPRT_PTC9522H(_i)			(0x00380D04 + ((_i) * 8))
 #define GLPRT_PTC9522L(_i)			(0x00380D00 + ((_i) * 8))
 #define GLPRT_PXOFFRXC(_i, _j)			(0x00380500 + ((_i) * 8 + (_j) * 64))
 #define GLPRT_PXOFFTXC(_i, _j)			(0x00380F40 + ((_i) * 8 + (_j) * 64))
@@ -340,27 +320,17 @@
 #define GLPRT_RUC(_i)				(0x00380200 + ((_i) * 8))
 #define GLPRT_RXON2OFFCNT(_i, _j)		(0x00380700 + ((_i) * 8 + (_j) * 64))
 #define GLPRT_TDOLD(_i)				(0x00381280 + ((_i) * 8))
-#define GLPRT_UPRCH(_i)				(0x00381304 + ((_i) * 8))
 #define GLPRT_UPRCL(_i)				(0x00381300 + ((_i) * 8))
-#define GLPRT_UPTCH(_i)				(0x003811C4 + ((_i) * 8))
 #define GLPRT_UPTCL(_i)				(0x003811C0 + ((_i) * 8))
-#define GLV_BPRCH(_i)				(0x003B6004 + ((_i) * 8))
 #define GLV_BPRCL(_i)				(0x003B6000 + ((_i) * 8))
-#define GLV_BPTCH(_i)				(0x0030E004 + ((_i) * 8))
 #define GLV_BPTCL(_i)				(0x0030E000 + ((_i) * 8))
-#define GLV_GORCH(_i)				(0x003B0004 + ((_i) * 8))
 #define GLV_GORCL(_i)				(0x003B0000 + ((_i) * 8))
-#define GLV_GOTCH(_i)				(0x00300004 + ((_i) * 8))
 #define GLV_GOTCL(_i)				(0x00300000 + ((_i) * 8))
-#define GLV_MPRCH(_i)				(0x003B4004 + ((_i) * 8))
 #define GLV_MPRCL(_i)				(0x003B4000 + ((_i) * 8))
-#define GLV_MPTCH(_i)				(0x0030C004 + ((_i) * 8))
 #define GLV_MPTCL(_i)				(0x0030C000 + ((_i) * 8))
 #define GLV_RDPC(_i)				(0x00294C04 + ((_i) * 4))
 #define GLV_TEPC(_VSI)				(0x00312000 + ((_VSI) * 4))
-#define GLV_UPRCH(_i)				(0x003B2004 + ((_i) * 8))
 #define GLV_UPRCL(_i)				(0x003B2000 + ((_i) * 8))
-#define GLV_UPTCH(_i)				(0x0030A004 + ((_i) * 8))
 #define GLV_UPTCL(_i)				(0x0030A000 + ((_i) * 8))
 #define PF_VT_PFALLOC_HIF			0x0009DD80
 #define VSIQF_HKEY_MAX_INDEX			12
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a19f5920733b..e9e8340b1ab7 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1477,40 +1477,32 @@ void ice_update_eth_stats(struct ice_vsi *vsi)
 	prev_es = &vsi->eth_stats_prev;
 	cur_es = &vsi->eth_stats;
 
-	ice_stat_update40(hw, GLV_GORCH(vsi_num), GLV_GORCL(vsi_num),
-			  vsi->stat_offsets_loaded, &prev_es->rx_bytes,
-			  &cur_es->rx_bytes);
+	ice_stat_update40(hw, GLV_GORCL(vsi_num), vsi->stat_offsets_loaded,
+			  &prev_es->rx_bytes, &cur_es->rx_bytes);
 
-	ice_stat_update40(hw, GLV_UPRCH(vsi_num), GLV_UPRCL(vsi_num),
-			  vsi->stat_offsets_loaded, &prev_es->rx_unicast,
-			  &cur_es->rx_unicast);
+	ice_stat_update40(hw, GLV_UPRCL(vsi_num), vsi->stat_offsets_loaded,
+			  &prev_es->rx_unicast, &cur_es->rx_unicast);
 
-	ice_stat_update40(hw, GLV_MPRCH(vsi_num), GLV_MPRCL(vsi_num),
-			  vsi->stat_offsets_loaded, &prev_es->rx_multicast,
-			  &cur_es->rx_multicast);
+	ice_stat_update40(hw, GLV_MPRCL(vsi_num), vsi->stat_offsets_loaded,
+			  &prev_es->rx_multicast, &cur_es->rx_multicast);
 
-	ice_stat_update40(hw, GLV_BPRCH(vsi_num), GLV_BPRCL(vsi_num),
-			  vsi->stat_offsets_loaded, &prev_es->rx_broadcast,
-			  &cur_es->rx_broadcast);
+	ice_stat_update40(hw, GLV_BPRCL(vsi_num), vsi->stat_offsets_loaded,
+			  &prev_es->rx_broadcast, &cur_es->rx_broadcast);
 
 	ice_stat_update32(hw, GLV_RDPC(vsi_num), vsi->stat_offsets_loaded,
 			  &prev_es->rx_discards, &cur_es->rx_discards);
 
-	ice_stat_update40(hw, GLV_GOTCH(vsi_num), GLV_GOTCL(vsi_num),
-			  vsi->stat_offsets_loaded, &prev_es->tx_bytes,
-			  &cur_es->tx_bytes);
+	ice_stat_update40(hw, GLV_GOTCL(vsi_num), vsi->stat_offsets_loaded,
+			  &prev_es->tx_bytes, &cur_es->tx_bytes);
 
-	ice_stat_update40(hw, GLV_UPTCH(vsi_num), GLV_UPTCL(vsi_num),
-			  vsi->stat_offsets_loaded, &prev_es->tx_unicast,
-			  &cur_es->tx_unicast);
+	ice_stat_update40(hw, GLV_UPTCL(vsi_num), vsi->stat_offsets_loaded,
+			  &prev_es->tx_unicast, &cur_es->tx_unicast);
 
-	ice_stat_update40(hw, GLV_MPTCH(vsi_num), GLV_MPTCL(vsi_num),
-			  vsi->stat_offsets_loaded, &prev_es->tx_multicast,
-			  &cur_es->tx_multicast);
+	ice_stat_update40(hw, GLV_MPTCL(vsi_num), vsi->stat_offsets_loaded,
+			  &prev_es->tx_multicast, &cur_es->tx_multicast);
 
-	ice_stat_update40(hw, GLV_BPTCH(vsi_num), GLV_BPTCL(vsi_num),
-			  vsi->stat_offsets_loaded, &prev_es->tx_broadcast,
-			  &cur_es->tx_broadcast);
+	ice_stat_update40(hw, GLV_BPTCL(vsi_num), vsi->stat_offsets_loaded,
+			  &prev_es->tx_broadcast, &cur_es->tx_broadcast);
 
 	ice_stat_update32(hw, GLV_TEPC(vsi_num), vsi->stat_offsets_loaded,
 			  &prev_es->tx_errors, &cur_es->tx_errors);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 63db08d9bafa..f490e65c64bc 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3176,96 +3176,82 @@ static void ice_update_pf_stats(struct ice_pf *pf)
 	cur_ps = &pf->stats;
 	pf_id = hw->pf_id;
 
-	ice_stat_update40(hw, GLPRT_GORCH(pf_id), GLPRT_GORCL(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->eth.rx_bytes,
+	ice_stat_update40(hw, GLPRT_GORCL(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->eth.rx_bytes,
 			  &cur_ps->eth.rx_bytes);
 
-	ice_stat_update40(hw, GLPRT_UPRCH(pf_id), GLPRT_UPRCL(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->eth.rx_unicast,
+	ice_stat_update40(hw, GLPRT_UPRCL(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->eth.rx_unicast,
 			  &cur_ps->eth.rx_unicast);
 
-	ice_stat_update40(hw, GLPRT_MPRCH(pf_id), GLPRT_MPRCL(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->eth.rx_multicast,
+	ice_stat_update40(hw, GLPRT_MPRCL(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->eth.rx_multicast,
 			  &cur_ps->eth.rx_multicast);
 
-	ice_stat_update40(hw, GLPRT_BPRCH(pf_id), GLPRT_BPRCL(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->eth.rx_broadcast,
+	ice_stat_update40(hw, GLPRT_BPRCL(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->eth.rx_broadcast,
 			  &cur_ps->eth.rx_broadcast);
 
-	ice_stat_update40(hw, GLPRT_GOTCH(pf_id), GLPRT_GOTCL(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->eth.tx_bytes,
+	ice_stat_update40(hw, GLPRT_GOTCL(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->eth.tx_bytes,
 			  &cur_ps->eth.tx_bytes);
 
-	ice_stat_update40(hw, GLPRT_UPTCH(pf_id), GLPRT_UPTCL(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->eth.tx_unicast,
+	ice_stat_update40(hw, GLPRT_UPTCL(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->eth.tx_unicast,
 			  &cur_ps->eth.tx_unicast);
 
-	ice_stat_update40(hw, GLPRT_MPTCH(pf_id), GLPRT_MPTCL(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->eth.tx_multicast,
+	ice_stat_update40(hw, GLPRT_MPTCL(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->eth.tx_multicast,
 			  &cur_ps->eth.tx_multicast);
 
-	ice_stat_update40(hw, GLPRT_BPTCH(pf_id), GLPRT_BPTCL(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->eth.tx_broadcast,
+	ice_stat_update40(hw, GLPRT_BPTCL(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->eth.tx_broadcast,
 			  &cur_ps->eth.tx_broadcast);
 
 	ice_stat_update32(hw, GLPRT_TDOLD(pf_id), pf->stat_prev_loaded,
 			  &prev_ps->tx_dropped_link_down,
 			  &cur_ps->tx_dropped_link_down);
 
-	ice_stat_update40(hw, GLPRT_PRC64H(pf_id), GLPRT_PRC64L(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->rx_size_64,
-			  &cur_ps->rx_size_64);
+	ice_stat_update40(hw, GLPRT_PRC64L(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->rx_size_64, &cur_ps->rx_size_64);
 
-	ice_stat_update40(hw, GLPRT_PRC127H(pf_id), GLPRT_PRC127L(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->rx_size_127,
-			  &cur_ps->rx_size_127);
+	ice_stat_update40(hw, GLPRT_PRC127L(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->rx_size_127, &cur_ps->rx_size_127);
 
-	ice_stat_update40(hw, GLPRT_PRC255H(pf_id), GLPRT_PRC255L(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->rx_size_255,
-			  &cur_ps->rx_size_255);
+	ice_stat_update40(hw, GLPRT_PRC255L(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->rx_size_255, &cur_ps->rx_size_255);
 
-	ice_stat_update40(hw, GLPRT_PRC511H(pf_id), GLPRT_PRC511L(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->rx_size_511,
-			  &cur_ps->rx_size_511);
+	ice_stat_update40(hw, GLPRT_PRC511L(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->rx_size_511, &cur_ps->rx_size_511);
 
-	ice_stat_update40(hw, GLPRT_PRC1023H(pf_id),
-			  GLPRT_PRC1023L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PRC1023L(pf_id), pf->stat_prev_loaded,
 			  &prev_ps->rx_size_1023, &cur_ps->rx_size_1023);
 
-	ice_stat_update40(hw, GLPRT_PRC1522H(pf_id),
-			  GLPRT_PRC1522L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PRC1522L(pf_id), pf->stat_prev_loaded,
 			  &prev_ps->rx_size_1522, &cur_ps->rx_size_1522);
 
-	ice_stat_update40(hw, GLPRT_PRC9522H(pf_id),
-			  GLPRT_PRC9522L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PRC9522L(pf_id), pf->stat_prev_loaded,
 			  &prev_ps->rx_size_big, &cur_ps->rx_size_big);
 
-	ice_stat_update40(hw, GLPRT_PTC64H(pf_id), GLPRT_PTC64L(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->tx_size_64,
-			  &cur_ps->tx_size_64);
+	ice_stat_update40(hw, GLPRT_PTC64L(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->tx_size_64, &cur_ps->tx_size_64);
 
-	ice_stat_update40(hw, GLPRT_PTC127H(pf_id), GLPRT_PTC127L(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->tx_size_127,
-			  &cur_ps->tx_size_127);
+	ice_stat_update40(hw, GLPRT_PTC127L(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->tx_size_127, &cur_ps->tx_size_127);
 
-	ice_stat_update40(hw, GLPRT_PTC255H(pf_id), GLPRT_PTC255L(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->tx_size_255,
-			  &cur_ps->tx_size_255);
+	ice_stat_update40(hw, GLPRT_PTC255L(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->tx_size_255, &cur_ps->tx_size_255);
 
-	ice_stat_update40(hw, GLPRT_PTC511H(pf_id), GLPRT_PTC511L(pf_id),
-			  pf->stat_prev_loaded, &prev_ps->tx_size_511,
-			  &cur_ps->tx_size_511);
+	ice_stat_update40(hw, GLPRT_PTC511L(pf_id), pf->stat_prev_loaded,
+			  &prev_ps->tx_size_511, &cur_ps->tx_size_511);
 
-	ice_stat_update40(hw, GLPRT_PTC1023H(pf_id),
-			  GLPRT_PTC1023L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PTC1023L(pf_id), pf->stat_prev_loaded,
 			  &prev_ps->tx_size_1023, &cur_ps->tx_size_1023);
 
-	ice_stat_update40(hw, GLPRT_PTC1522H(pf_id),
-			  GLPRT_PTC1522L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PTC1522L(pf_id), pf->stat_prev_loaded,
 			  &prev_ps->tx_size_1522, &cur_ps->tx_size_1522);
 
-	ice_stat_update40(hw, GLPRT_PTC9522H(pf_id),
-			  GLPRT_PTC9522L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PTC9522L(pf_id), pf->stat_prev_loaded,
 			  &prev_ps->tx_size_big, &cur_ps->tx_size_big);
 
 	ice_stat_update32(hw, GLPRT_LXONRXC(pf_id), pf->stat_prev_loaded,
-- 
2.21.0

