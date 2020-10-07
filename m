Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E03286B5D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 01:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgJGXLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 19:11:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:53903 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728176AbgJGXLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 19:11:06 -0400
IronPort-SDR: +quzSAWgEw4lvnw5lYWkaqu073dXDS4SxaWEkuRs4jhhFlWr/XXBTmHCvX/Y8mRtvoTNiO8Nfs
 DhplOGwNOp2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="249880369"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="249880369"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 16:11:05 -0700
IronPort-SDR: 8SykSE9ZVD4u/c6oU9yzknFzcZmyPaHkaRv1oo3kWvyKjpaobuBD8RLjvUz9tzX2P9jB6Nh0Ei
 xSw2h44jdlMQ==
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="461557638"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 16:11:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 3/3] e1000: remove unused and incorrect code
Date:   Wed,  7 Oct 2020 16:10:50 -0700
Message-Id: <20201007231050.1438704-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The e1000_clear_vfta function was triggering a warning in kbuild-bot
testing. It's actually a bug but has no functional impact.

drivers/net/ethernet/intel/e1000/e1000_hw.c:4415:58: warning: Same expression in both branches of ternary operator. [duplicateExpressionTernary]

Fix this warning by removing the offending code and simplifying
the routine to do exactly what it did before, no functional
change.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_hw.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index fb5af23880c3..4c0c9433bd60 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -4401,17 +4401,9 @@ void e1000_write_vfta(struct e1000_hw *hw, u32 offset, u32 value)
 static void e1000_clear_vfta(struct e1000_hw *hw)
 {
 	u32 offset;
-	u32 vfta_value = 0;
-	u32 vfta_offset = 0;
-	u32 vfta_bit_in_reg = 0;
 
 	for (offset = 0; offset < E1000_VLAN_FILTER_TBL_SIZE; offset++) {
-		/* If the offset we want to clear is the same offset of the
-		 * manageability VLAN ID, then clear all bits except that of the
-		 * manageability unit
-		 */
-		vfta_value = (offset == vfta_offset) ? vfta_bit_in_reg : 0;
-		E1000_WRITE_REG_ARRAY(hw, VFTA, offset, vfta_value);
+		E1000_WRITE_REG_ARRAY(hw, VFTA, offset, 0);
 		E1000_WRITE_FLUSH();
 	}
 }
-- 
2.26.2

