Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CBF38B5D4
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhETSQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:16:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:9099 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232700AbhETSQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 14:16:53 -0400
IronPort-SDR: uf4yxbdn2+Dp8xL4JKnYFLhUpR5VDqn01xSZN1ilyQIV6eMPRL3kOTK1qbOfOG5uwqLNcZhQdd
 q1S4i3b/WmPw==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="181579456"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="181579456"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 11:15:31 -0700
IronPort-SDR: pxdahysLKdhKMR9G2nJCBE0it82GQVrWcUihKehgtZQ4a9SFgOUFB5JJw9LPFqlHcl1gkVZBg3
 p9PLnnnMdEZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440670741"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 20 May 2021 11:15:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next v2 3/9] igc: Refactor igc_clean_rx_ring()
Date:   Thu, 20 May 2021 11:17:38 -0700
Message-Id: <20210520181744.2217191-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
References: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

Refactor igc_clean_rx_ring() helper, preparing the code for AF_XDP
zero-copy support which is added by upcoming patches.

The refactor consists of encapsulating page-shared specific code into
its own helper, leaving common code that will be shared by both
page-shared and xsk pool in igc_clean_rx_ring().

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1961cc667c3b..5024f8dc98f9 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -346,11 +346,7 @@ static int igc_setup_all_tx_resources(struct igc_adapter *adapter)
 	return err;
 }
 
-/**
- * igc_clean_rx_ring - Free Rx Buffers per Queue
- * @rx_ring: ring to free buffers from
- */
-static void igc_clean_rx_ring(struct igc_ring *rx_ring)
+static void igc_clean_rx_ring_page_shared(struct igc_ring *rx_ring)
 {
 	u16 i = rx_ring->next_to_clean;
 
@@ -383,12 +379,21 @@ static void igc_clean_rx_ring(struct igc_ring *rx_ring)
 		if (i == rx_ring->count)
 			i = 0;
 	}
+}
+
+/**
+ * igc_clean_rx_ring - Free Rx Buffers per Queue
+ * @ring: ring to free buffers from
+ */
+static void igc_clean_rx_ring(struct igc_ring *ring)
+{
+	igc_clean_rx_ring_page_shared(ring);
 
-	clear_ring_uses_large_buffer(rx_ring);
+	clear_ring_uses_large_buffer(ring);
 
-	rx_ring->next_to_alloc = 0;
-	rx_ring->next_to_clean = 0;
-	rx_ring->next_to_use = 0;
+	ring->next_to_alloc = 0;
+	ring->next_to_clean = 0;
+	ring->next_to_use = 0;
 }
 
 /**
-- 
2.26.2

