Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627B13FA0B8
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhH0UlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:41:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:60747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231346AbhH0UlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 16:41:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="197589401"
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="197589401"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 13:40:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="685587301"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 27 Aug 2021 13:40:19 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        maciej.machnikowski@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/5] ice: fix Tx queue iteration for Tx timestamp enablement
Date:   Fri, 27 Aug 2021 13:43:54 -0700
Message-Id: <20210827204358.792803-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
References: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The driver accidentally copied the ice_for_each_rxq iterator when
implementing enablement of the ptp_tx bit for the Tx rings. We still
load the Tx rings and set the ptp_tx field, but we iterate over the
count of the num_rxq.

If the number of Tx and Rx queues differ, this could either cause
a buffer overrun when accessing the tx_rings list if num_txq is greater
than num_rxq, or it could cause us to fail to enable Tx timestamps for
some rings.

This was not noticed originally as we generally have the same number of
Tx and Rx queues.

Fixes: ea9b847cda64 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 9e3ddb9b8b51..f54148fb0e21 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -22,7 +22,7 @@ static void ice_set_tx_tstamp(struct ice_pf *pf, bool on)
 		return;
 
 	/* Set the timestamp enable flag for all the Tx rings */
-	ice_for_each_rxq(vsi, i) {
+	ice_for_each_txq(vsi, i) {
 		if (!vsi->tx_rings[i])
 			continue;
 		vsi->tx_rings[i]->ptp_tx = on;
-- 
2.26.2

