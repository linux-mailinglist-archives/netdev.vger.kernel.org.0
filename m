Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B57351B67
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbhDASIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:08:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:1677 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234536AbhDASEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 14:04:11 -0400
IronPort-SDR: wcoWYTFasKTPTDpedpOs8WXRE750betHwyGZO7l9Wbhlon1hN4k/6prdOjImmTEPyLLmlGpYFC
 RJrcIQ00/8JQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="256275599"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="256275599"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 10:19:30 -0700
IronPort-SDR: E9PZSs7VViRF8udTMD82knQaQQdLlFW3gVNVoGsPEbFlCfevzTzwn/LkMMTRtvo+lrJTTkpCrx
 VXNkAHSo+Q5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="439290157"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 01 Apr 2021 10:19:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Sreedevi Joshi <sreedevi.joshi@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 2/3] i40e: fix receiving of single packets in xsk zero-copy mode
Date:   Thu,  1 Apr 2021 10:21:06 -0700
Message-Id: <20210401172107.1191618-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210401172107.1191618-1-anthony.l.nguyen@intel.com>
References: <20210401172107.1191618-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix so that single packets are received immediately instead of in
batches of 8. If you sent 1 pps to a system, you received 8 packets
every 8 seconds instead of 1 packet every second. The problem behind
this was that the work_done reporting from the Tx part of the driver
was broken. The work_done reporting in i40e controls not only the
reporting back to the napi logic but also the setting of the interrupt
throttling logic. When Tx or Rx reports that it has more to do,
interrupts are throttled or coalesced and when they both report that
they are done, interrupts are armed right away. If the wrong work_done
value is returned, the logic will start to throttle interrupts in a
situation where it should have just enabled them. This leads to the
undesired batching behavior seen in user-space.

Fix this by returning the correct boolean value from the Tx xsk
zero-copy path. Return true if there is nothing to do or if we got
fewer packets to process than we asked for. Return false if we got as
many packets as the budget since there might be more packets we can
process.

Fixes: 3106c580fb7c ("i40e: Use batched xsk Tx interfaces to increase performance")
Reported-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index fc32c5019b0f..12ca84113587 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -471,7 +471,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 
 	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, descs, budget);
 	if (!nb_pkts)
-		return false;
+		return true;
 
 	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
 		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
@@ -488,7 +488,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 
 	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
 
-	return true;
+	return nb_pkts < budget;
 }
 
 /**
-- 
2.26.2

