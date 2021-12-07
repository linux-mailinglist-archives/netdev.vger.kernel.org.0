Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B54046C76D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhLGWaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:30:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:6596 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242159AbhLGWaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 17:30:18 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237508433"
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="237508433"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 14:26:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="605889082"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Dec 2021 14:26:46 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 4/7] ice: ignore dropped packets during init
Date:   Tue,  7 Dec 2021 14:25:41 -0800
Message-Id: <20211207222544.977843-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
References: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

If the hardware is constantly receiving unicast or broadcast packets
during driver load, the device previously counted many GLV_RDPC (VSI
dropped packets) events during init. This causes confusing dropped
packet statistics during driver load. The dropped packets counter
incrementing does stop once the driver finishes loading.

Avoid this problem by baselining our statistics at the end of driver
open instead of the end of probe.

Fixes: cdedef59deb0 ("ice: Configure VSIs for Tx/Rx")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Testing Hints: pktgen or ping flood the DUT, while reloading the driver
and bringing up the interface (in a script or with networkmanager) and
note dropped packets with ip -s -s link or ifconfig, after this patch
there should be none.

 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4d1fc48c9744..c6d6ce52e2ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5881,6 +5881,9 @@ static int ice_up_complete(struct ice_vsi *vsi)
 		netif_carrier_on(vsi->netdev);
 	}
 
+	/* clear this now, and the first stats read will be used as baseline */
+	vsi->stat_offsets_loaded = false;
+
 	ice_service_task_schedule(pf);
 
 	return 0;
-- 
2.31.1

