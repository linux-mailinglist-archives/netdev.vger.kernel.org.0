Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546DC3B95CC
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhGASEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:04:02 -0400
Received: from mga12.intel.com ([192.55.52.136]:63747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233059AbhGASD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:03:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="188272883"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="188272883"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 11:01:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409018401"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 01 Jul 2021 11:01:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Erez Geva <erez.geva.ext@siemens.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 02/11] igb: Fix use-after-free error during reset
Date:   Thu,  1 Jul 2021 11:04:11 -0700
Message-Id: <20210701180420.346126-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
References: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Cleans the next descriptor to watch (next_to_watch) when cleaning the
TX ring.

Failure to do so can cause invalid memory accesses. If igb_poll() runs
while the controller is reset this can lead to the driver try to free
a skb that was already freed.

(The crash is harder to reproduce with the igb driver, but the same
potential problem exists as the code is identical to igc)

Fixes: 7cc6fd4c60f2 ("igb: Don't bother clearing Tx buffer_info in igb_clean_tx_ring")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reported-by: Erez Geva <erez.geva.ext@siemens.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 7e6435dc7e80..a61e2e5e95c0 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4835,6 +4835,8 @@ static void igb_clean_tx_ring(struct igb_ring *tx_ring)
 					       DMA_TO_DEVICE);
 		}
 
+		tx_buffer->next_to_watch = NULL;
+
 		/* move us one more past the eop_desc for start of next pkt */
 		tx_buffer++;
 		i++;
-- 
2.26.2

