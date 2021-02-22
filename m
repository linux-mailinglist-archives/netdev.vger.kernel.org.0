Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1C83222D9
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 00:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhBVX54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 18:57:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:20936 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231833AbhBVX5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 18:57:54 -0500
IronPort-SDR: R6LzPEmFG/PTjnmMmM4TROtrb7EMf2pGzGGqnE7F6y7/zxit/mF5jo/Mr2yF5hX24pVYK7n8Q9
 +j5L6zeU4cIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="184751841"
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="184751841"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 15:57:13 -0800
IronPort-SDR: OPthffd98w8v/1VkvFy74UFGaRwgP5h7BUSykcAEUPgAOtl2nELrrGoajZQCQ4zF4VOnDX1H/i
 srabZcQz2rMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="592882898"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 22 Feb 2021 15:57:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 1/5] ice: report correct max number of TCs
Date:   Mon, 22 Feb 2021 15:58:10 -0800
Message-Id: <20210222235814.834282-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
References: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

In the driver currently, we are reporting max number of TCs
to the DCBNL callback as a kernel define set to 8.  This is
preventing userspace applications performing DCBx to correctly
down map the TCs from requested to actual values.

Report the actual max TC value to userspace from the capability
struct.

Fixes: b94b013eb626 ("ice: Implement DCBNL support")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index fcfefad00d1c..299bf7edbf82 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -134,7 +134,7 @@ ice_dcbnl_getnumtcs(struct net_device *dev, int __always_unused tcid, u8 *num)
 	if (!test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags))
 		return -EINVAL;
 
-	*num = IEEE_8021QAZ_MAX_TCS;
+	*num = pf->hw.func_caps.common_cap.maxtc;
 	return 0;
 }
 
-- 
2.26.2

