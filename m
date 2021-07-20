Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B753D053C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhGTWj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:39:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:50224 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233731AbhGTWhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:37:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211341485"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211341485"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:17:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="415407159"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2021 16:17:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 12/12] igc: Increase timeout value for Speed 100/1000/2500
Date:   Tue, 20 Jul 2021 16:21:01 -0700
Message-Id: <20210720232101.3087589-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

As the cycle time is set to maximum of 1s, the TX Hang timeout need to
be increase to avoid possible TX Hang.

There is no dedicated number specific in data sheet for the timeout factor.
Timeout factor was determined during the debugging to solve the "Tx Hang"
issues that happen in some cases mainly during ETF(Earliest TxTime First).

This can be test by using TSN Schedule Tx Tools udp_tai sample application.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 31e489ed3f8d..5c95bf82eaf7 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5312,7 +5312,9 @@ static void igc_watchdog_task(struct work_struct *work)
 				adapter->tx_timeout_factor = 14;
 				break;
 			case SPEED_100:
-				/* maybe add some timeout factor ? */
+			case SPEED_1000:
+			case SPEED_2500:
+				adapter->tx_timeout_factor = 7;
 				break;
 			}
 
-- 
2.26.2

