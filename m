Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B595165221
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgBSWHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:07:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:62539 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbgBSWHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:07:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824818"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/13] ice: SW DCB, report correct max TC value
Date:   Wed, 19 Feb 2020 14:06:46 -0800
Message-Id: <20200219220652.2255171-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

lldpad is using the value reported in the DCB config for
max_tc as the max allowed number of TCs, not the current
max.  ICE driver was reporting it as current maximum TC.

Change DCB_NL function to report maximum TC allowed by
this device.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 589b820a6b5b..c4c12414083a 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -100,14 +100,7 @@ static int ice_dcbnl_setets(struct net_device *netdev, struct ieee_ets *ets)
 		goto ets_out;
 	}
 
-	/* max_tc is a 1-8 value count of number of TC's, not a 0-7 value
-	 * for the TC's index number.  Add one to value if not zero, and
-	 * for zero set it to the FW's default value
-	 */
-	if (max_tc)
-		max_tc++;
-	else
-		max_tc = IEEE_8021QAZ_MAX_TCS;
+	max_tc = pf->hw.func_caps.common_cap.maxtc;
 
 	new_cfg->etscfg.maxtcs = max_tc;
 
-- 
2.24.1

