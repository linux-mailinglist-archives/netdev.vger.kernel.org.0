Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6C95625A6
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbiF3Vwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237127AbiF3Vwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:52:46 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F2E53EEB
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 14:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656625964; x=1688161964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UzbBNc5MK9eH4cK1I04uspqtm50I2/73bFFD8cAP8uI=;
  b=LyAZ/1iEaX6ykjJgXPKiZlSRl+5cNaN+RJP3m7A+pIlE04/NpGRbf5s6
   4xh7TscQox8ZUaUMEwLZ8sPN+D0hvvf+WuDp0H88Cl3QrO2YLFhuffCZQ
   4QN1VKwJeJjw8ntRgnCUJuwxln9U1ciBkBqi8Yi0ET2s9+BlwVHwTCfUW
   xnKZgmBiJPdZDNvpd189ajNFYODpvw9ADddXwL8M1US4yTFaEiq5GOfwT
   Bv2aGtLRXzXjWB/pntAZPpM/prG7QJPQjESW+z1Gk/35EUR6Y5Y0pne9s
   vwEnZodaURMryGTOx6BRodSQ6+5yu0oa58wBBUv1bEKLpHxfwgxBe+awS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="262881759"
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="262881759"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:52:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="918221387"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jun 2022 14:52:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Lukasz Cieplicki <lukaszx.cieplicki@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 1/2] i40e: Fix dropped jumbo frames statistics
Date:   Thu, 30 Jun 2022 14:49:39 -0700
Message-Id: <20220630214940.3036250-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220630214940.3036250-1-anthony.l.nguyen@intel.com>
References: <20220630214940.3036250-1-anthony.l.nguyen@intel.com>
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

From: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>

Dropped packets caused by too large frames were not included in
dropped RX packets statistics.
Issue was caused by not reading the GL_RXERR1 register. That register
stores count of packet which was have been dropped due to too large
size.

Fix it by reading GL_RXERR1 register for each interface.

Repro steps:
Send a packet larger than the set MTU to SUT
Observe rx statists: ethtool -S <interface> | grep rx | grep -v ": 0"

Fixes: 41a9e55c89be ("i40e: add missing VSI statistics")
Signed-off-by: Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h        | 16 ++++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 73 +++++++++++++++++++
 .../net/ethernet/intel/i40e/i40e_register.h   | 13 ++++
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  1 +
 4 files changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 18558a019353..407fe8f340a0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -37,6 +37,7 @@
 #include <net/tc_act/tc_mirred.h>
 #include <net/udp_tunnel.h>
 #include <net/xdp_sock.h>
+#include <linux/bitfield.h>
 #include "i40e_type.h"
 #include "i40e_prototype.h"
 #include <linux/net/intel/i40e_client.h>
@@ -1092,6 +1093,21 @@ static inline void i40e_write_fd_input_set(struct i40e_pf *pf,
 			  (u32)(val & 0xFFFFFFFFULL));
 }
 
+/**
+ * i40e_get_pf_count - get PCI PF count.
+ * @hw: pointer to a hw.
+ *
+ * Reports the function number of the highest PCI physical
+ * function plus 1 as it is loaded from the NVM.
+ *
+ * Return: PCI PF count.
+ **/
+static inline u32 i40e_get_pf_count(struct i40e_hw *hw)
+{
+	return FIELD_GET(I40E_GLGEN_PCIFCNCNT_PCIPFCNT_MASK,
+			 rd32(hw, I40E_GLGEN_PCIFCNCNT));
+}
+
 /* needed by i40e_ethtool.c */
 int i40e_up(struct i40e_vsi *vsi);
 void i40e_down(struct i40e_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 72576bb3e94d..aa786fd55951 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -550,6 +550,47 @@ void i40e_pf_reset_stats(struct i40e_pf *pf)
 	pf->hw_csum_rx_error = 0;
 }
 
+/**
+ * i40e_compute_pci_to_hw_id - compute index form PCI function.
+ * @vsi: ptr to the VSI to read from.
+ * @hw: ptr to the hardware info.
+ **/
+static u32 i40e_compute_pci_to_hw_id(struct i40e_vsi *vsi, struct i40e_hw *hw)
+{
+	int pf_count = i40e_get_pf_count(hw);
+
+	if (vsi->type == I40E_VSI_SRIOV)
+		return (hw->port * BIT(7)) / pf_count + vsi->vf_id;
+
+	return hw->port + BIT(7);
+}
+
+/**
+ * i40e_stat_update64 - read and update a 64 bit stat from the chip.
+ * @hw: ptr to the hardware info.
+ * @hireg: the high 32 bit reg to read.
+ * @loreg: the low 32 bit reg to read.
+ * @offset_loaded: has the initial offset been loaded yet.
+ * @offset: ptr to current offset value.
+ * @stat: ptr to the stat.
+ *
+ * Since the device stats are not reset at PFReset, they will not
+ * be zeroed when the driver starts.  We'll save the first values read
+ * and use them as offsets to be subtracted from the raw values in order
+ * to report stats that count from zero.
+ **/
+static void i40e_stat_update64(struct i40e_hw *hw, u32 hireg, u32 loreg,
+			       bool offset_loaded, u64 *offset, u64 *stat)
+{
+	u64 new_data;
+
+	new_data = rd64(hw, loreg);
+
+	if (!offset_loaded || new_data < *offset)
+		*offset = new_data;
+	*stat = new_data - *offset;
+}
+
 /**
  * i40e_stat_update48 - read and update a 48 bit stat from the chip
  * @hw: ptr to the hardware info
@@ -621,6 +662,34 @@ static void i40e_stat_update_and_clear32(struct i40e_hw *hw, u32 reg, u64 *stat)
 	*stat += new_data;
 }
 
+/**
+ * i40e_stats_update_rx_discards - update rx_discards.
+ * @vsi: ptr to the VSI to be updated.
+ * @hw: ptr to the hardware info.
+ * @stat_idx: VSI's stat_counter_idx.
+ * @offset_loaded: ptr to the VSI's stat_offsets_loaded.
+ * @stat_offset: ptr to stat_offset to store first read of specific register.
+ * @stat: ptr to VSI's stat to be updated.
+ **/
+static void
+i40e_stats_update_rx_discards(struct i40e_vsi *vsi, struct i40e_hw *hw,
+			      int stat_idx, bool offset_loaded,
+			      struct i40e_eth_stats *stat_offset,
+			      struct i40e_eth_stats *stat)
+{
+	u64 rx_rdpc, rx_rxerr;
+
+	i40e_stat_update32(hw, I40E_GLV_RDPC(stat_idx), offset_loaded,
+			   &stat_offset->rx_discards, &rx_rdpc);
+	i40e_stat_update64(hw,
+			   I40E_GL_RXERR1H(i40e_compute_pci_to_hw_id(vsi, hw)),
+			   I40E_GL_RXERR1L(i40e_compute_pci_to_hw_id(vsi, hw)),
+			   offset_loaded, &stat_offset->rx_discards_other,
+			   &rx_rxerr);
+
+	stat->rx_discards = rx_rdpc + rx_rxerr;
+}
+
 /**
  * i40e_update_eth_stats - Update VSI-specific ethernet statistics counters.
  * @vsi: the VSI to be updated
@@ -680,6 +749,10 @@ void i40e_update_eth_stats(struct i40e_vsi *vsi)
 			   I40E_GLV_BPTCL(stat_idx),
 			   vsi->stat_offsets_loaded,
 			   &oes->tx_broadcast, &es->tx_broadcast);
+
+	i40e_stats_update_rx_discards(vsi, hw, stat_idx,
+				      vsi->stat_offsets_loaded, oes, es);
+
 	vsi->stat_offsets_loaded = true;
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_register.h b/drivers/net/ethernet/intel/i40e/i40e_register.h
index 1908eed4fa5e..7339003aa17c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_register.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_register.h
@@ -211,6 +211,11 @@
 #define I40E_GLGEN_MSRWD_MDIWRDATA_SHIFT 0
 #define I40E_GLGEN_MSRWD_MDIRDDATA_SHIFT 16
 #define I40E_GLGEN_MSRWD_MDIRDDATA_MASK I40E_MASK(0xFFFF, I40E_GLGEN_MSRWD_MDIRDDATA_SHIFT)
+#define I40E_GLGEN_PCIFCNCNT                0x001C0AB4 /* Reset: PCIR */
+#define I40E_GLGEN_PCIFCNCNT_PCIPFCNT_SHIFT 0
+#define I40E_GLGEN_PCIFCNCNT_PCIPFCNT_MASK  I40E_MASK(0x1F, I40E_GLGEN_PCIFCNCNT_PCIPFCNT_SHIFT)
+#define I40E_GLGEN_PCIFCNCNT_PCIVFCNT_SHIFT 16
+#define I40E_GLGEN_PCIFCNCNT_PCIVFCNT_MASK  I40E_MASK(0xFF, I40E_GLGEN_PCIFCNCNT_PCIVFCNT_SHIFT)
 #define I40E_GLGEN_RSTAT 0x000B8188 /* Reset: POR */
 #define I40E_GLGEN_RSTAT_DEVSTATE_SHIFT 0
 #define I40E_GLGEN_RSTAT_DEVSTATE_MASK I40E_MASK(0x3, I40E_GLGEN_RSTAT_DEVSTATE_SHIFT)
@@ -643,6 +648,14 @@
 #define I40E_VFQF_HKEY1_MAX_INDEX 12
 #define I40E_VFQF_HLUT1(_i, _VF) (0x00220000 + ((_i) * 1024 + (_VF) * 4)) /* _i=0...15, _VF=0...127 */ /* Reset: CORER */
 #define I40E_VFQF_HLUT1_MAX_INDEX 15
+#define I40E_GL_RXERR1H(_i)             (0x00318004 + ((_i) * 8)) /* _i=0...143 */ /* Reset: CORER */
+#define I40E_GL_RXERR1H_MAX_INDEX       143
+#define I40E_GL_RXERR1H_RXERR1H_SHIFT   0
+#define I40E_GL_RXERR1H_RXERR1H_MASK    I40E_MASK(0xFFFFFFFF, I40E_GL_RXERR1H_RXERR1H_SHIFT)
+#define I40E_GL_RXERR1L(_i)             (0x00318000 + ((_i) * 8)) /* _i=0...143 */ /* Reset: CORER */
+#define I40E_GL_RXERR1L_MAX_INDEX       143
+#define I40E_GL_RXERR1L_RXERR1L_SHIFT   0
+#define I40E_GL_RXERR1L_RXERR1L_MASK    I40E_MASK(0xFFFFFFFF, I40E_GL_RXERR1L_RXERR1L_SHIFT)
 #define I40E_GLPRT_BPRCH(_i) (0x003005E4 + ((_i) * 8)) /* _i=0...3 */ /* Reset: CORER */
 #define I40E_GLPRT_BPRCL(_i) (0x003005E0 + ((_i) * 8)) /* _i=0...3 */ /* Reset: CORER */
 #define I40E_GLPRT_BPTCH(_i) (0x00300A04 + ((_i) * 8)) /* _i=0...3 */ /* Reset: CORER */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 36a4ca1ffb1a..7b3f30beb757 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -1172,6 +1172,7 @@ struct i40e_eth_stats {
 	u64 tx_broadcast;		/* bptc */
 	u64 tx_discards;		/* tdpc */
 	u64 tx_errors;			/* tepc */
+	u64 rx_discards_other;          /* rxerr1 */
 };
 
 /* Statistics collected per VEB per TC */
-- 
2.35.1

