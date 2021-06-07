Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1401639E47F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFGQwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:52:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:57113 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhFGQwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:46 -0400
IronPort-SDR: Ynvr2TDwap+xa/cb9qZzYPRtMa8z3qzhtsVQTmfSqzdNdkaqHw/wQmOhkX2+9QAHRkIuCQKk35
 Nkv7yCwPeNnA==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474558"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474558"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:54 -0700
IronPort-SDR: zPDaodkTOJJ2X4UrtAFvB/eT1jBIdkOHgUGYe0Ge95TpHQ6DV7FRnYcMfKWetR3VRXWMN3kPlL
 Q54XFskvxhjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841251"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 09/15] ice: add extack when unable to read device caps
Date:   Mon,  7 Jun 2021 09:53:19 -0700
Message-Id: <20210607165325.182087-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When filling out information for the DEVLINK_CMD_INFO_GET, the driver
needs to read some device capabilities. Add an extack message to
properly inform the caller of the failure, as we do for other failures
in this function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index cf685eeea198..2923591d01ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -283,6 +283,9 @@ static int ice_devlink_info_get(struct devlink *devlink,
 	/* discover capabilities first */
 	status = ice_discover_dev_caps(hw, &ctx->dev_caps);
 	if (status) {
+		dev_dbg(dev, "Failed to discover device capabilities, status %s aq_err %s\n",
+			ice_stat_str(status), ice_aq_str(hw->adminq.sq_last_status));
+		NL_SET_ERR_MSG_MOD(extack, "Unable to discover device capabilities");
 		err = -EIO;
 		goto out_free_ctx;
 	}
-- 
2.26.2

