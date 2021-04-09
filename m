Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC01035A3A2
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhDIQmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:42:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:9788 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234166AbhDIQm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:42:27 -0400
IronPort-SDR: AtF/oqi0MJa5bOhSEZG8D4nRVvD5uKEmen5p+TZ/0dI7jejUIG2BKs7/2TjgIn1v32ul3zbpSd
 X5whO7kT29gw==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="214235095"
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="214235095"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 09:42:13 -0700
IronPort-SDR: yvwKRk/cDHuyVta8F6nsv8YH0VpFqHIjZdqGEPtszbRkh/9vEdOdnczn9tGFVMEhuhRNiXluUr
 GlKs/201NOuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="531055066"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 09 Apr 2021 09:42:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 4/9] igc: Refactor XDP rxq info registration
Date:   Fri,  9 Apr 2021 09:43:46 -0700
Message-Id: <20210409164351.188953-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
References: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

Refactor XDP rxq info registration code, preparing the driver for AF_XDP
zero-copy support which is added by upcoming patches.

Currently, xdp_rxq and memory model are both registered during RX
resource setup time by igc_xdp_register_rxq_info() helper. With AF_XDP,
we want to register the memory model later on while configuring the ring
because we will know which memory model type to register
(MEM_TYPE_PAGE_SHARED or MEM_TYPE_XSK_BUFF_POOL).

The helpers igc_xdp_register_rxq_info() and igc_xdp_unregister_rxq_
info() are not useful anymore so they are removed.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 16 ++++++++++----
 drivers/net/ethernet/intel/igc/igc_xdp.c  | 27 -----------------------
 drivers/net/ethernet/intel/igc/igc_xdp.h  |  3 ---
 3 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f715b69805fa..cd192517946b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -419,7 +419,7 @@ void igc_free_rx_resources(struct igc_ring *rx_ring)
 {
 	igc_clean_rx_ring(rx_ring);
 
-	igc_xdp_unregister_rxq_info(rx_ring);
+	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 
 	vfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
@@ -458,11 +458,16 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
 {
 	struct net_device *ndev = rx_ring->netdev;
 	struct device *dev = rx_ring->dev;
+	u8 index = rx_ring->queue_index;
 	int size, desc_len, res;
 
-	res = igc_xdp_register_rxq_info(rx_ring);
-	if (res < 0)
+	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
+			       rx_ring->q_vector->napi.napi_id);
+	if (res < 0) {
+		netdev_err(ndev, "Failed to register xdp_rxq index %u\n",
+			   index);
 		return res;
+	}
 
 	size = sizeof(struct igc_rx_buffer) * rx_ring->count;
 	rx_ring->rx_buffer_info = vzalloc(size);
@@ -488,7 +493,7 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
 	return 0;
 
 err:
-	igc_xdp_unregister_rxq_info(rx_ring);
+	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	vfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
 	netdev_err(ndev, "Unable to allocate memory for Rx descriptor ring\n");
@@ -536,6 +541,9 @@ static void igc_configure_rx_ring(struct igc_adapter *adapter,
 	u32 srrctl = 0, rxdctl = 0;
 	u64 rdba = ring->dma;
 
+	WARN_ON(xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
+					   MEM_TYPE_PAGE_SHARED, NULL));
+
 	if (igc_xdp_is_enabled(adapter))
 		set_ring_uses_large_buffer(ring);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_xdp.c b/drivers/net/ethernet/intel/igc/igc_xdp.c
index 11133c4619bb..27c886a254f1 100644
--- a/drivers/net/ethernet/intel/igc/igc_xdp.c
+++ b/drivers/net/ethernet/intel/igc/igc_xdp.c
@@ -31,30 +31,3 @@ int igc_xdp_set_prog(struct igc_adapter *adapter, struct bpf_prog *prog,
 
 	return 0;
 }
-
-int igc_xdp_register_rxq_info(struct igc_ring *ring)
-{
-	struct net_device *dev = ring->netdev;
-	int err;
-
-	err = xdp_rxq_info_reg(&ring->xdp_rxq, dev, ring->queue_index, 0);
-	if (err) {
-		netdev_err(dev, "Failed to register xdp rxq info\n");
-		return err;
-	}
-
-	err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq, MEM_TYPE_PAGE_SHARED,
-					 NULL);
-	if (err) {
-		netdev_err(dev, "Failed to register xdp rxq mem model\n");
-		xdp_rxq_info_unreg(&ring->xdp_rxq);
-		return err;
-	}
-
-	return 0;
-}
-
-void igc_xdp_unregister_rxq_info(struct igc_ring *ring)
-{
-	xdp_rxq_info_unreg(&ring->xdp_rxq);
-}
diff --git a/drivers/net/ethernet/intel/igc/igc_xdp.h b/drivers/net/ethernet/intel/igc/igc_xdp.h
index 412aa369e6ba..cdaa2c39b03a 100644
--- a/drivers/net/ethernet/intel/igc/igc_xdp.h
+++ b/drivers/net/ethernet/intel/igc/igc_xdp.h
@@ -7,9 +7,6 @@
 int igc_xdp_set_prog(struct igc_adapter *adapter, struct bpf_prog *prog,
 		     struct netlink_ext_ack *extack);
 
-int igc_xdp_register_rxq_info(struct igc_ring *ring);
-void igc_xdp_unregister_rxq_info(struct igc_ring *ring);
-
 static inline bool igc_xdp_is_enabled(struct igc_adapter *adapter)
 {
 	return !!adapter->xdp_prog;
-- 
2.26.2

