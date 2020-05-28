Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928891E5890
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgE1H0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:26:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:14682 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgE1HZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:43 -0400
IronPort-SDR: CeUsagxLyV7qs6Toz+ofHetg50wLbKNxQrxvArZBzmlMk2RWnyoDEQ2B0MxL6HbBWWxur3xhRp
 XVYkND6S+uBA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:42 -0700
IronPort-SDR: 6BtxsrULGgmPkC6rhVUbkdtxJiIfUStjxr/yslznz3DxMhSAj060moh01eVDfVc9jyF5W7di1A
 MGP8MVuhsWsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831115"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:41 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Surabhi Boob <surabhi.boob@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] ice: Fix memory leak
Date:   Thu, 28 May 2020 00:25:28 -0700
Message-Id: <20200528072538.1621790-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Surabhi Boob <surabhi.boob@intel.com>

Handle memory leak on filter management initialization failure.

Signed-off-by: Surabhi Boob <surabhi.boob@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 5da369ae33e0..ee62cfa3a69e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -387,6 +387,7 @@ ice_aq_set_mac_cfg(struct ice_hw *hw, u16 max_frame_size, struct ice_sq_cd *cd)
 static enum ice_status ice_init_fltr_mgmt_struct(struct ice_hw *hw)
 {
 	struct ice_switch_info *sw;
+	enum ice_status status;
 
 	hw->switch_info = devm_kzalloc(ice_hw_to_dev(hw),
 				       sizeof(*hw->switch_info), GFP_KERNEL);
@@ -397,7 +398,12 @@ static enum ice_status ice_init_fltr_mgmt_struct(struct ice_hw *hw)
 
 	INIT_LIST_HEAD(&sw->vsi_list_map_head);
 
-	return ice_init_def_sw_recp(hw);
+	status = ice_init_def_sw_recp(hw);
+	if (status) {
+		devm_kfree(ice_hw_to_dev(hw), hw->switch_info);
+		return status;
+	}
+	return 0;
 }
 
 /**
-- 
2.26.2

