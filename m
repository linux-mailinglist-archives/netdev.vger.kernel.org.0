Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9F8235340
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgHAQSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:19614 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbgHAQSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:11 -0400
IronPort-SDR: sKtRDrXNrw/8SAyE5jLXxdakLIVQemUcUQwEgbM9xXsiTTJCPV6Gk9El5RWG7Bs5Bv/f4gHcqI
 xfqTYHI/AjEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810857"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810857"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:08 -0700
IronPort-SDR: GMq2PSmU/JHCxNAzSTBA+lkNuzBqjpzw+R6XVAAnM4yvzM7pxm3VSggkBQsu+4bG2MYxKSEZI7
 AalgvrX6ASuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457719"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Surabhi Boob <surabhi.boob@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 10/14] ice: Graceful error handling in HW table calloc failure
Date:   Sat,  1 Aug 2020 09:17:58 -0700
Message-Id: <20200801161802.867645-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Surabhi Boob <surabhi.boob@intel.com>

In the ice_init_hw_tbls, if the devm_kcalloc for es->written fails, catch
that error and bail out gracefully, instead of continuing with a NULL
pointer.

Fixes: 32d63fa1e9f3 ("ice: Initialize DDP package structures")
Signed-off-by: Surabhi Boob <surabhi.boob@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index d59869b2c65e..5ceba009db16 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -3151,10 +3151,12 @@ enum ice_status ice_init_hw_tbls(struct ice_hw *hw)
 		es->ref_count = devm_kcalloc(ice_hw_to_dev(hw), es->count,
 					     sizeof(*es->ref_count),
 					     GFP_KERNEL);
+		if (!es->ref_count)
+			goto err;
 
 		es->written = devm_kcalloc(ice_hw_to_dev(hw), es->count,
 					   sizeof(*es->written), GFP_KERNEL);
-		if (!es->ref_count)
+		if (!es->written)
 			goto err;
 	}
 	return 0;
-- 
2.26.2

