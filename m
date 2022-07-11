Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF00570DD8
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 01:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiGKXFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 19:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiGKXFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 19:05:48 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD717823B6
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 16:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657580748; x=1689116748;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hX1WxvjWVGEmDGeWQk2is677CT7hksSL5XZv1y641eQ=;
  b=LPkxwf7/bxKrNDG+xIKj6M8bFQaf7GvFbiLxraEWnTzJhrC49Id0yLXd
   yBQDmkfB/91jMhA1jXiz53y/v/aDjBj6PkATxLQc03Jyeh+LuLQiir0pM
   MDGmor08NVMdj7K/Ddw6McT14a/eUJe3EEd+I24OyEvAM2FFJQcvItxAs
   M3vhcO5W+HBGucDoFWkLMc7/nJTbgIuTqsHRal4PLle/eliO5gbWy3NqP
   mV0YS/Mr0UQ2ArDK97agb2h6t38AlRV+tnDpX/7TpkK1JiZt/tYsEAFSE
   lNLBlT8kRvS3iuJeAr41gCKeg7sL62sqjrfNY/u6lfuqyhE1/qSHAvmVM
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="346473370"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="346473370"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 16:05:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="599189370"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2022 16:05:46 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jun Zhang <xuejun.zhang@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net 2/7] iavf: Disallow changing rx/tx-frames and rx/tx-frames-irq
Date:   Mon, 11 Jul 2022 16:02:38 -0700
Message-Id: <20220711230243.3123667-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220711230243.3123667-1-anthony.l.nguyen@intel.com>
References: <20220711230243.3123667-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Remove from supported_coalesce_params ETHTOOL_COALESCE_MAX_FRAMES
and ETHTOOL_COALESCE_MAX_FRAMES_IRQ. As tx-frames-irq allowed
user to change budget for iavf_clean_tx_irq, remove work_limit
and use define for budget.

Without this patch there would be possibility to change rx/tx-frames
and rx/tx-frames-irq, which for rx/tx-frames did nothing, while for
rx/tx-frames-irq it changed rx/tx-frames and only changed budget
for cleaning NAPI poll.

Fixes: fbb7ddfef253 ("i40evf: core ethtool functionality")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jun Zhang <xuejun.zhang@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h         |  1 -
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 10 ----------
 drivers/net/ethernet/intel/iavf/iavf_main.c    |  1 -
 drivers/net/ethernet/intel/iavf/iavf_txrx.c    |  2 +-
 4 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 86bc61c300a7..2a7b3c085aa9 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -64,7 +64,6 @@ struct iavf_vsi {
 	u16 id;
 	DECLARE_BITMAP(state, __IAVF_VSI_STATE_SIZE__);
 	int base_vector;
-	u16 work_limit;
 	u16 qs_handle;
 	void *priv;     /* client driver data reference. */
 };
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 3bb56714beb0..e535d4c3da49 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -692,12 +692,8 @@ static int __iavf_get_coalesce(struct net_device *netdev,
 			       struct ethtool_coalesce *ec, int queue)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
-	struct iavf_vsi *vsi = &adapter->vsi;
 	struct iavf_ring *rx_ring, *tx_ring;
 
-	ec->tx_max_coalesced_frames = vsi->work_limit;
-	ec->rx_max_coalesced_frames = vsi->work_limit;
-
 	/* Rx and Tx usecs per queue value. If user doesn't specify the
 	 * queue, return queue 0's value to represent.
 	 */
@@ -825,12 +821,8 @@ static int __iavf_set_coalesce(struct net_device *netdev,
 			       struct ethtool_coalesce *ec, int queue)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
-	struct iavf_vsi *vsi = &adapter->vsi;
 	int i;
 
-	if (ec->tx_max_coalesced_frames_irq || ec->rx_max_coalesced_frames_irq)
-		vsi->work_limit = ec->tx_max_coalesced_frames_irq;
-
 	if (ec->rx_coalesce_usecs == 0) {
 		if (ec->use_adaptive_rx_coalesce)
 			netif_info(adapter, drv, netdev, "rx-usecs=0, need to disable adaptive-rx for a complete disable\n");
@@ -1969,8 +1961,6 @@ static int iavf_set_rxfh(struct net_device *netdev, const u32 *indir,
 
 static const struct ethtool_ops iavf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
-				     ETHTOOL_COALESCE_MAX_FRAMES |
-				     ETHTOOL_COALESCE_MAX_FRAMES_IRQ |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo		= iavf_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2a8643e66331..2e2c153ce46a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2240,7 +2240,6 @@ int iavf_parse_vf_resource_msg(struct iavf_adapter *adapter)
 
 	adapter->vsi.back = adapter;
 	adapter->vsi.base_vector = 1;
-	adapter->vsi.work_limit = IAVF_DEFAULT_IRQ_WORK;
 	vsi->netdev = adapter->netdev;
 	vsi->qs_handle = adapter->vsi_res->qset_handle;
 	if (adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_RSS_PF) {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 978f651c6b09..7bf8c25dc824 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -194,7 +194,7 @@ static bool iavf_clean_tx_irq(struct iavf_vsi *vsi,
 	struct iavf_tx_buffer *tx_buf;
 	struct iavf_tx_desc *tx_desc;
 	unsigned int total_bytes = 0, total_packets = 0;
-	unsigned int budget = vsi->work_limit;
+	unsigned int budget = IAVF_DEFAULT_IRQ_WORK;
 
 	tx_buf = &tx_ring->tx_bi[i];
 	tx_desc = IAVF_TX_DESC(tx_ring, i);
-- 
2.35.1

