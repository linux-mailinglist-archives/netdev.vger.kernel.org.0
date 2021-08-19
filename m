Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185073F231D
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbhHSWb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:31:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:11767 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229532AbhHSWbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 18:31:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="213541917"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="213541917"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 15:31:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="489916277"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 19 Aug 2021 15:31:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net v2 1/1] ice: do not abort devlink info if board identifier can't be found
Date:   Thu, 19 Aug 2021 15:34:51 -0700
Message-Id: <20210819223451.245613-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The devlink dev info command reports version information about the
device and firmware running on the board. This includes the "board.id"
field which is supposed to represent an identifier of the board design.
The ice driver uses the Product Board Assembly identifier for this.

In some cases, the PBA is not present in the NVM. If this happens,
devlink dev info will fail with an error. Instead, modify the
ice_info_pba function to just exit without filling in the context
buffer. This will cause the board.id field to be skipped. Log a dev_dbg
message in case someone wants to confirm why board.id is not showing up
for them.

Fixes: e961b679fb0b ("ice: add board identifier info to devlink .info_get")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
v2:
- Removed refactors - to be submitted later as separate patch through net-next
- Changed 'PBA' to 'board identifier' in title

 drivers/net/ethernet/intel/ice/ice_devlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 91b545ab8b8f..7fe6e8ea39f0 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -42,7 +42,9 @@ static int ice_info_pba(struct ice_pf *pf, struct ice_info_ctx *ctx)
 
 	status = ice_read_pba_string(hw, (u8 *)ctx->buf, sizeof(ctx->buf));
 	if (status)
-		return -EIO;
+		/* We failed to locate the PBA, so just skip this entry */
+		dev_dbg(ice_pf_to_dev(pf), "Failed to read Product Board Assembly string, status %s\n",
+			ice_stat_str(status));
 
 	return 0;
 }
-- 
2.26.2

