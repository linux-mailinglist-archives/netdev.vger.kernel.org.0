Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4EA6837BA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjAaUpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjAaUp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:45:28 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16F734C2E;
        Tue, 31 Jan 2023 12:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675197925; x=1706733925;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KyLonIgeMIw0Drp17epaNfHBMCP0UGjUvswisVsj8Ic=;
  b=NHPe7UP7myPMDnLWpFVBp8anedej4/fsxoQuIqOHalPaaPPKpDLC6CIT
   7OU1Bs3TCAm6wRrMp/BxVIXHhkJ23rrUhllXxbTnxvBNi7B4jXjHYo9Pi
   /uG+qbXiC2XYmy4oyZTxQvvvurm1eHtdDkIPKqOroOrryun8SkiDGmbEH
   qY/JNJk/HXlyzcQnpO0bvSXQRlDTBNstlHPfNtWbaV6wuHMW6qXtZhrri
   x+V5oskSrWPKs8Mv4IBRpzvGfJ2j+Mlx4VhAlju6FerRgd4UXAryVsY3C
   69c1tBCBkCq13iFYdbPFzZQQroT3OcrnpU1vBjc8/AM+55SopfovrTBmE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167158"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167158"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:45:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595256"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595256"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:21 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 05/13] ice: inline eop check
Date:   Tue, 31 Jan 2023 21:44:58 +0100
Message-Id: <20230131204506.219292-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
References: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This might be in future used by ZC driver and might potentially yield a
minor performance boost. While at it, constify arguments that
ice_is_non_eop() takes, since they are pointers and this will help compiler
while generating asm.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 21 ------------------
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h | 22 +++++++++++++++++++
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 1139b16f57cc..b4dc80295b12 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1065,27 +1065,6 @@ ice_put_rx_buf(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf)
 	rx_buf->page = NULL;
 }
 
-/**
- * ice_is_non_eop - process handling of non-EOP buffers
- * @rx_ring: Rx ring being processed
- * @rx_desc: Rx descriptor for current buffer
- *
- * If the buffer is an EOP buffer, this function exits returning false,
- * otherwise return true indicating that this is in fact a non-EOP buffer.
- */
-static bool
-ice_is_non_eop(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc)
-{
-	/* if we are the last buffer then there is nothing else to do */
-#define ICE_RXD_EOF BIT(ICE_RX_FLEX_DESC_STATUS0_EOF_S)
-	if (likely(ice_test_staterr(rx_desc->wb.status_error0, ICE_RXD_EOF)))
-		return false;
-
-	rx_ring->ring_stats->rx_stats.non_eop_descs++;
-
-	return true;
-}
-
 /**
  * ice_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @rx_ring: Rx descriptor ring to transact packets on
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index c7d2954dc9ea..30e3cffdb2f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -21,6 +21,28 @@ ice_test_staterr(__le16 status_err_n, const u16 stat_err_bits)
 	return !!(status_err_n & cpu_to_le16(stat_err_bits));
 }
 
+/**
+ * ice_is_non_eop - process handling of non-EOP buffers
+ * @rx_ring: Rx ring being processed
+ * @rx_desc: Rx descriptor for current buffer
+ *
+ * If the buffer is an EOP buffer, this function exits returning false,
+ * otherwise return true indicating that this is in fact a non-EOP buffer.
+ */
+static inline bool
+ice_is_non_eop(const struct ice_rx_ring *rx_ring,
+	       const union ice_32b_rx_flex_desc *rx_desc)
+{
+	/* if we are the last buffer then there is nothing else to do */
+#define ICE_RXD_EOF BIT(ICE_RX_FLEX_DESC_STATUS0_EOF_S)
+	if (likely(ice_test_staterr(rx_desc->wb.status_error0, ICE_RXD_EOF)))
+		return false;
+
+	rx_ring->ring_stats->rx_stats.non_eop_descs++;
+
+	return true;
+}
+
 static inline __le64
 ice_build_ctob(u64 td_cmd, u64 td_offset, unsigned int size, u64 td_tag)
 {
-- 
2.34.1

