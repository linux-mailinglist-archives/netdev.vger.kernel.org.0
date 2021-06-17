Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442FF3ABA20
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhFQRBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:01:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:63638 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231518AbhFQRBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:01:17 -0400
IronPort-SDR: VeWMbYfY1FfzV8ALffvsk5O0OlipdtDrX86GM2caH8k7E1a5AJomL9jrkoUvKylFx32+maGNdl
 YucAKwR7z/VQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="193723061"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="193723061"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 09:59:05 -0700
IronPort-SDR: vkjvFEJRbBAoIzkNPTv0AB/+CGuHf4EDQaj54pOqeyyHbTGJav5zR78QnnUVIj2vfS7Tpkhe4j
 ZgeIdDbidgHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="404706816"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 Jun 2021 09:59:04 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 8/8] ice: remove redundant continue statement in a for-loop
Date:   Thu, 17 Jun 2021 10:01:45 -0700
Message-Id: <20210617170145.4092904-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
References: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The continue statement in the for-loop is redundant. Re-work the hw_lock
check to remove it.

Addresses-Coverity: ("Continue has no effect")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 267312fad59a..3eca0e4eab0b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -410,13 +410,11 @@ bool ice_ptp_lock(struct ice_hw *hw)
 	for (i = 0; i < MAX_TRIES; i++) {
 		hw_lock = rd32(hw, PFTSYN_SEM + (PFTSYN_SEM_BYTES * hw->pf_id));
 		hw_lock = hw_lock & PFTSYN_SEM_BUSY_M;
-		if (hw_lock) {
-			/* Somebody is holding the lock */
-			usleep_range(10000, 20000);
-			continue;
-		} else {
+		if (!hw_lock)
 			break;
-		}
+
+		/* Somebody is holding the lock */
+		usleep_range(10000, 20000);
 	}
 
 	return !hw_lock;
-- 
2.26.2

