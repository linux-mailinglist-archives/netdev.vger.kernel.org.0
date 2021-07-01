Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A433B95CB
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhGASEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:04:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:63745 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233119AbhGASD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:03:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="188272884"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="188272884"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 11:01:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409018406"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 01 Jul 2021 11:01:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 03/11] igc: change default return of igc_read_phy_reg()
Date:   Thu,  1 Jul 2021 11:04:12 -0700
Message-Id: <20210701180420.346126-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
References: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Static analysis reports this problem

igc_main.c:4944:20: warning: The left operand of '&'
  is a garbage value
    if (!(phy_data & SR_1000T_REMOTE_RX_STATUS) &&
          ~~~~~~~~ ^

phy_data is set by the call to igc_read_phy_reg() only if
there is a read_reg() op, else it is unset and a 0 is
returned.  Change the return to -EOPNOTSUPP.

Fixes: 208983f099d9 ("igc: Add watchdog")
Signed-off-by: Tom Rix <trix@redhat.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 9e0bbb2e55e3..5901ed9fb545 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -578,7 +578,7 @@ static inline s32 igc_read_phy_reg(struct igc_hw *hw, u32 offset, u16 *data)
 	if (hw->phy.ops.read_reg)
 		return hw->phy.ops.read_reg(hw, offset, data);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 void igc_reinit_locked(struct igc_adapter *);
-- 
2.26.2

