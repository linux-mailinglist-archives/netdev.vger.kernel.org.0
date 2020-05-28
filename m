Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588801E5889
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgE1HZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:25:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:14682 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbgE1HZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:48 -0400
IronPort-SDR: Hh9bQJUZIG56wJe25XzELJ94ZCaK7j9PZJfKw/mH09K/n9iD21uAqkk/TTulU0tYgHHyPfZmKX
 MGMv62QxwgXA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:44 -0700
IronPort-SDR: Y//feqY12XUZGHjJQsLPZxGrrxQXds6zMSEvYeX5pr3Mw4DnVjyOJYJoQ2QZ9Xp6Ov4lbNBk9w
 scoZhjWn81+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831142"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] ice: avoid undefined behavior
Date:   Thu, 28 May 2020 00:25:36 -0700
Message-Id: <20200528072538.1621790-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

When writing the driver's struct ice_tlan_ctx structure, do not write the
8-bit element int_q_state with the associated internal-to-hardware field
which is 122-bits, otherwise the helper function ice_write_byte() will use
undefined behavior when setting the mask used for that write.  This should
not cause any functional change and will avoid use of undefined behavior.
Also, update a comment to highlight this structure element is not written.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c      |  5 +++--
 drivers/net/ethernet/intel/ice/ice_common.c    | 12 ++++++++++--
 drivers/net/ethernet/intel/ice/ice_common.h    |  3 ++-
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h |  2 +-
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 9452c0eb70b0..18076e0d12d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -638,6 +638,7 @@ ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
 	struct ice_aqc_add_txqs_perq *txq;
 	struct ice_pf *pf = vsi->back;
 	u8 buf_len = sizeof(*qg_buf);
+	struct ice_hw *hw = &pf->hw;
 	enum ice_status status;
 	u16 pf_q;
 	u8 tc;
@@ -646,13 +647,13 @@ ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
 	ice_setup_tx_ctx(ring, &tlan_ctx, pf_q);
 	/* copy context contents into the qg_buf */
 	qg_buf->txqs[0].txq_id = cpu_to_le16(pf_q);
-	ice_set_ctx((u8 *)&tlan_ctx, qg_buf->txqs[0].txq_ctx,
+	ice_set_ctx(hw, (u8 *)&tlan_ctx, qg_buf->txqs[0].txq_ctx,
 		    ice_tlan_ctx_info);
 
 	/* init queue specific tail reg. It is referred as
 	 * transmit comm scheduler queue doorbell.
 	 */
-	ring->tail = pf->hw.hw_addr + QTX_COMM_DBELL(pf_q);
+	ring->tail = hw->hw_addr + QTX_COMM_DBELL(pf_q);
 
 	if (IS_ENABLED(CONFIG_DCB))
 		tc = ring->dcb_tc;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index ee62cfa3a69e..8c73e161829d 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1098,7 +1098,7 @@ ice_write_rxq_ctx(struct ice_hw *hw, struct ice_rlan_ctx *rlan_ctx,
 
 	rlan_ctx->prefena = 1;
 
-	ice_set_ctx((u8 *)rlan_ctx, ctx_buf, ice_rlan_ctx_info);
+	ice_set_ctx(hw, (u8 *)rlan_ctx, ctx_buf, ice_rlan_ctx_info);
 	return ice_copy_rxq_ctx_to_hw(hw, ctx_buf, rxq_index);
 }
 
@@ -3199,12 +3199,14 @@ ice_write_qword(u8 *src_ctx, u8 *dest_ctx, const struct ice_ctx_ele *ce_info)
 
 /**
  * ice_set_ctx - set context bits in packed structure
+ * @hw: pointer to the hardware structure
  * @src_ctx:  pointer to a generic non-packed context structure
  * @dest_ctx: pointer to memory for the packed structure
  * @ce_info:  a description of the structure to be transformed
  */
 enum ice_status
-ice_set_ctx(u8 *src_ctx, u8 *dest_ctx, const struct ice_ctx_ele *ce_info)
+ice_set_ctx(struct ice_hw *hw, u8 *src_ctx, u8 *dest_ctx,
+	    const struct ice_ctx_ele *ce_info)
 {
 	int f;
 
@@ -3213,6 +3215,12 @@ ice_set_ctx(u8 *src_ctx, u8 *dest_ctx, const struct ice_ctx_ele *ce_info)
 		 * using the correct size so that we are correct regardless
 		 * of the endianness of the machine.
 		 */
+		if (ce_info[f].width > (ce_info[f].size_of * BITS_PER_BYTE)) {
+			ice_debug(hw, ICE_DBG_QCTX,
+				  "Field %d width of %d bits larger than size of %d byte(s) ... skipping write\n",
+				  f, ce_info[f].width, ce_info[f].size_of);
+			continue;
+		}
 		switch (ce_info[f].size_of) {
 		case sizeof(u8):
 			ice_write_byte(src_ctx, dest_ctx, &ce_info[f]);
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index bea755a658eb..9b9e50d2398b 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -70,7 +70,8 @@ enum ice_status ice_aq_q_shutdown(struct ice_hw *hw, bool unloading);
 void ice_fill_dflt_direct_cmd_desc(struct ice_aq_desc *desc, u16 opcode);
 extern const struct ice_ctx_ele ice_tlan_ctx_info[];
 enum ice_status
-ice_set_ctx(u8 *src_ctx, u8 *dest_ctx, const struct ice_ctx_ele *ce_info);
+ice_set_ctx(struct ice_hw *hw, u8 *src_ctx, u8 *dest_ctx,
+	    const struct ice_ctx_ele *ce_info);
 
 extern struct mutex ice_global_cfg_lock_sw;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index bd2cd3435768..14dfbbc1b2cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -581,7 +581,7 @@ struct ice_tlan_ctx {
 	u8 drop_ena;
 	u8 cache_prof_idx;
 	u8 pkt_shaper_prof_idx;
-	u8 int_q_state;	/* width not needed - internal do not write */
+	u8 int_q_state;	/* width not needed - internal - DO NOT WRITE!!! */
 };
 
 /* macro to make the table lines short */
-- 
2.26.2

