Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC8939E483
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhFGQxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:53:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:57118 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230494AbhFGQwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:47 -0400
IronPort-SDR: hdpOLum6nAfHu8OpBtVeq7L9pfe/dMSQv2ixgqxZZWPFsiSnEh1+V0bqJ1ItsP3YuTXqJNj0Z8
 mTyz0Fc4o5ug==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474563"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474563"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:55 -0700
IronPort-SDR: dA+nLeFfSHHXH7Et/A1Iz9oZsL0u/XfGUzDM/KAOBKPV8yvLpoqxKGEJIdilZPr+GKBynfmXcY
 0I5aJ2bqEh0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841267"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 12/15] ice: (re)initialize NVM fields when rebuilding
Date:   Mon,  7 Jun 2021 09:53:22 -0700
Message-Id: <20210607165325.182087-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

After performing a flash update, a device EMP reset may occur. This
reset will cause the newly downloaded firmware to be initialized. When
this happens, the driver still reports the previous NVM version
information.

This is because the NVM versions are cached within the hw structure.
This can be confusing, as the new firmware is in fact running in this
case.

Handle this by calling ice_init_nvm when rebuilding the driver state.
This will update the flash version information and ensures that the
current values are displayed when reporting the NVM versions to the
stack.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a89ca799109f..7606ded59a84 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6218,6 +6218,12 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 
 	ice_clear_pxe_mode(hw);
 
+	ret = ice_init_nvm(hw);
+	if (ret) {
+		dev_err(dev, "ice_init_nvm failed %s\n", ice_stat_str(ret));
+		goto err_init_ctrlq;
+	}
+
 	ret = ice_get_caps(hw);
 	if (ret) {
 		dev_err(dev, "ice_get_caps failed %s\n", ice_stat_str(ret));
-- 
2.26.2

