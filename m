Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 238D4B01FE
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbfIKQt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:49:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:31944 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbfIKQt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:49:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 09:49:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="179078816"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 11 Sep 2019 09:49:57 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        stable@vger.kernel.org,
        Gregg Leventhal <gleventhal@janestreet.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 1/2] ixgbe: Prevent u8 wrapping of ITR value to something less than 10us
Date:   Wed, 11 Sep 2019 09:49:54 -0700
Message-Id: <20190911164955.10644-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911164955.10644-1-jeffrey.t.kirsher@intel.com>
References: <20190911164955.10644-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

There were a couple cases where the ITR value generated via the adaptive
ITR scheme could exceed 126. This resulted in the value becoming either 0
or something less than 10. Switching back and forth between a value less
than 10 and a value greater than 10 can cause issues as certain hardware
features such as RSC to not function well when the ITR value has dropped
that low.

CC: stable@vger.kernel.org
Fixes: b4ded8327fea ("ixgbe: Update adaptive ITR algorithm")
Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7882148abb43..77ca9005dc41 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2621,7 +2621,7 @@ static void ixgbe_update_itr(struct ixgbe_q_vector *q_vector,
 		/* 16K ints/sec to 9.2K ints/sec */
 		avg_wire_size *= 15;
 		avg_wire_size += 11452;
-	} else if (avg_wire_size <= 1980) {
+	} else if (avg_wire_size < 1968) {
 		/* 9.2K ints/sec to 8K ints/sec */
 		avg_wire_size *= 5;
 		avg_wire_size += 22420;
@@ -2654,6 +2654,8 @@ static void ixgbe_update_itr(struct ixgbe_q_vector *q_vector,
 	case IXGBE_LINK_SPEED_2_5GB_FULL:
 	case IXGBE_LINK_SPEED_1GB_FULL:
 	case IXGBE_LINK_SPEED_10_FULL:
+		if (avg_wire_size > 8064)
+			avg_wire_size = 8064;
 		itr += DIV_ROUND_UP(avg_wire_size,
 				    IXGBE_ITR_ADAPTIVE_MIN_INC * 64) *
 		       IXGBE_ITR_ADAPTIVE_MIN_INC;
-- 
2.21.0

