Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59A44ACDC5
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343770AbiBHBGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343532AbiBGXc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 18:32:57 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9360C061A73;
        Mon,  7 Feb 2022 15:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644276776; x=1675812776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TuxDAw59s9v5oDkwng61O+qiuxcnIpHptxberSPXjpo=;
  b=fGur2XU854sV/3zGsvWOpVraANJE84p+7L2XD7jYefV6BpNL49/S1hwC
   sUgYDQIxH4DvPxK/qEOJcj2mNzEv5dBwmVxjfQzTlA+YLpTrpe2BNO8Oq
   mSBIFCAsNg76MNfmY18fNfIFgEoQESGtXL8CjK4Q0UGwT45iETwWjArMl
   a6Jc+UBiWNbUg2HtSVs38A+q8dP/kEqwWQBXpm+CtYX3kc14AlT4Xrfar
   RrDLd7VuTfHBJhzvgonQu4f0Z3rmClqhzkoVjJ+qeu64NrzOPP9nxGBP3
   SaCdFPiqMksXdstsg4s/fUxOwjtbqkAzOdyufDPdsdrMj3C6g5dTAuxVa
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="335232075"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="335232075"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 15:32:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="772948627"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 07 Feb 2022 15:32:55 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Corinna Vinschen <vinschen@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 2/2] igb: refactor XDP registration
Date:   Mon,  7 Feb 2022 15:32:46 -0800
Message-Id: <20220207233246.1172958-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
References: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corinna Vinschen <vinschen@redhat.com>

On changing the RX ring parameters igb uses a hack to avoid a warning
when calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just
clears the struct xdp_rxq_info content.

Instead, change this to unregister if we're already registered.  Align
code to the igc code.

Fixes: 9cbc948b5a20c ("igb: add XDP support")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 19 +++++++++++++------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 51a2dcaf553d..2a5782063f4c 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -965,10 +965,6 @@ static int igb_set_ringparam(struct net_device *netdev,
 			memcpy(&temp_ring[i], adapter->rx_ring[i],
 			       sizeof(struct igb_ring));
 
-			/* Clear copied XDP RX-queue info */
-			memset(&temp_ring[i].xdp_rxq, 0,
-			       sizeof(temp_ring[i].xdp_rxq));
-
 			temp_ring[i].count = new_rx_count;
 			err = igb_setup_rx_resources(&temp_ring[i]);
 			if (err) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index bfa321e4003f..34b33b21e0dc 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4345,7 +4345,18 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 {
 	struct igb_adapter *adapter = netdev_priv(rx_ring->netdev);
 	struct device *dev = rx_ring->dev;
-	int size;
+	int size, res;
+
+	/* XDP RX-queue info */
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
+			       rx_ring->queue_index, 0);
+	if (res < 0) {
+		dev_err(dev, "Failed to register xdp_rxq index %u\n",
+			rx_ring->queue_index);
+		return res;
+	}
 
 	size = sizeof(struct igb_rx_buffer) * rx_ring->count;
 
@@ -4368,14 +4379,10 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 
 	rx_ring->xdp_prog = adapter->xdp_prog;
 
-	/* XDP RX-queue info */
-	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-			     rx_ring->queue_index, 0) < 0)
-		goto err;
-
 	return 0;
 
 err:
+	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	vfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
 	dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
-- 
2.31.1

