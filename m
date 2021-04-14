Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1A735F8DD
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352675AbhDNQTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:19:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:61890 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352655AbhDNQTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 12:19:10 -0400
IronPort-SDR: AiHmlLtwVsyE5HHbghSflEqq19YTp+1NcS6Nq6lBfeoSRVMqaDcF2rWMiNs6nXv5X/cBE+f7L4
 L9xSRF91p1IA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="182179982"
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="182179982"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 09:18:47 -0700
IronPort-SDR: IWeGUfARr0oioBbrzIyqJdUpsVf9Q+2WFTBIByWzLeXRqfWsSggEUMOv5BWEoqWE1BrPZGHg4N
 hKEBybR066JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="452520782"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 14 Apr 2021 09:18:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Alexander Duyck <alexanderduyck@fb.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 1/3] ixgbe: Fix NULL pointer dereference in ethtool loopback test
Date:   Wed, 14 Apr 2021 09:20:30 -0700
Message-Id: <20210414162032.3846384-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
References: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

The ixgbe driver currently generates a NULL pointer dereference when
performing the ethtool loopback test. This is due to the fact that there
isn't a q_vector associated with the test ring when it is setup as
interrupts are not normally added to the test rings.

To address this I have added code that will check for a q_vector before
returning a napi_id value. If a q_vector is not present it will return a
value of 0.

Fixes: b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 03d9aad516d4..45d2c8f37c01 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6536,6 +6536,13 @@ static int ixgbe_setup_all_tx_resources(struct ixgbe_adapter *adapter)
 	return err;
 }
 
+static int ixgbe_rx_napi_id(struct ixgbe_ring *rx_ring)
+{
+	struct ixgbe_q_vector *q_vector = rx_ring->q_vector;
+
+	return q_vector ? q_vector->napi.napi_id : 0;
+}
+
 /**
  * ixgbe_setup_rx_resources - allocate Rx resources (Descriptors)
  * @adapter: pointer to ixgbe_adapter
@@ -6583,7 +6590,7 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 
 	/* XDP RX-queue info */
 	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
-			     rx_ring->queue_index, rx_ring->q_vector->napi.napi_id) < 0)
+			     rx_ring->queue_index, ixgbe_rx_napi_id(rx_ring)) < 0)
 		goto err;
 
 	rx_ring->xdp_prog = adapter->xdp_prog;
-- 
2.26.2

