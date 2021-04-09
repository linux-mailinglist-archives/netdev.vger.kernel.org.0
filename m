Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372F635A3A1
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhDIQmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:42:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:9785 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234164AbhDIQm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:42:26 -0400
IronPort-SDR: dyUh4ct7HM69jiIJGaP5HOCPHp5ErxVvEuaopgSIVikkGIIFZ6p4Qj3dF3w0eSYXQ5+5DOxEvA
 2QB28CZRruxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="214235093"
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="214235093"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 09:42:13 -0700
IronPort-SDR: qXdl/82WjJSi6txWoT6XlCCPwtCQxHQs1k0ackb3ORGoG/+KEOzg6fmct7kYgvEXGRdtarJwm+
 dMVF8hQ/K94A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="531055063"
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
Subject: [PATCH net-next 3/9] igc: Refactor igc_clean_rx_ring()
Date:   Fri,  9 Apr 2021 09:43:45 -0700
Message-Id: <20210409164351.188953-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
References: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
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
index 86ec04972a64..f715b69805fa 100644
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

