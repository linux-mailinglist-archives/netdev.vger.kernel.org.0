Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83924A79EA
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfIDEfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:26532 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728236AbfIDEfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804404"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/15] ice: update driver unloading field for Queue Shutdown AQ command
Date:   Tue,  3 Sep 2019 21:35:03 -0700
Message-Id: <20190904043512.28066-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
References: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

According to recent specification versions, the field in the Queue Shutdown
AdminQ command consisting of the "driver unloading" indication is not a 4
byte field (it is byte.bit 16.0).  Change it to a byte and remove the
unnecessary endian conversion.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 4 ++--
 drivers/net/ethernet/intel/ice/ice_common.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index bf9aa533a7c6..8ebc695171b6 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -35,9 +35,9 @@ struct ice_aqc_get_ver {
 
 /* Queue Shutdown (direct 0x0003) */
 struct ice_aqc_q_shutdown {
-	__le32 driver_unloading;
+	u8 driver_unloading;
 #define ICE_AQC_DRIVER_UNLOADING	BIT(0)
-	u8 reserved[12];
+	u8 reserved[15];
 };
 
 /* Request resource ownership (direct 0x0008)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 302ad981129c..6c0abb284c10 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1275,7 +1275,7 @@ enum ice_status ice_aq_q_shutdown(struct ice_hw *hw, bool unloading)
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_q_shutdown);
 
 	if (unloading)
-		cmd->driver_unloading = cpu_to_le32(ICE_AQC_DRIVER_UNLOADING);
+		cmd->driver_unloading = ICE_AQC_DRIVER_UNLOADING;
 
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
 }
-- 
2.21.0

