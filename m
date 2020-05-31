Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A874C1E979E
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgEaMgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:12466 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbgEaMg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:27 -0400
IronPort-SDR: heEiN1Yx3L08hhPvylrNRVBs7dT/Np0wpXYr/zJrDlMXU8aoAlgaruHkcU17A5LMeg7Qv9r1k2
 tIdt6FvcemCg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:25 -0700
IronPort-SDR: aEdldv1HdYR+nzA5nRbFGUREP4DJXQlvU3oMFoab0IwM7BW1yDmxyLvq3cNtnxIIxM4CKCZeO1
 riAtqKGDUxiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345457"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Chinh T Cao <chinh.t.cao@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/14] ice: Ignore EMODE when setting PHY config
Date:   Sun, 31 May 2020 05:36:19 -0700
Message-Id: <20200531123619.2887469-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chinh T Cao <chinh.t.cao@intel.com>

When setting the PHY cfg (CQ cmd 0x0601), if the firmware responds
with an EMODE error, software will ignore the error as it simply
means that manageability (ex: BMC) is in control of the link and that
the new setting may not be applied.

Signed-off-by: Chinh T Cao <chinh.t.cao@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 1 +
 drivers/net/ethernet/intel/ice/ice_common.c     | 7 ++++++-
 drivers/net/ethernet/intel/ice/ice_main.c       | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 50040c5c55ec..92f82f2a8af4 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1826,6 +1826,7 @@ enum ice_aq_err {
 	ICE_AQ_RC_EINVAL	= 14, /* Invalid argument */
 	ICE_AQ_RC_ENOSPC	= 16, /* No space left or allocation failure */
 	ICE_AQ_RC_ENOSYS	= 17, /* Function not implemented */
+	ICE_AQ_RC_EMODE		= 21, /* Op not allowed in current dev mode */
 	ICE_AQ_RC_ENOSEC	= 24, /* Missing security manifest */
 	ICE_AQ_RC_EBADSIG	= 25, /* Bad RSA signature */
 	ICE_AQ_RC_ESVN		= 26, /* SVN number prohibits this package */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index d4a31c734326..bce0e1281168 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2232,6 +2232,7 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, u8 lport,
 		   struct ice_aqc_set_phy_cfg_data *cfg, struct ice_sq_cd *cd)
 {
 	struct ice_aq_desc desc;
+	enum ice_status status;
 
 	if (!cfg)
 		return ICE_ERR_PARAM;
@@ -2260,7 +2261,11 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, u8 lport,
 	ice_debug(hw, ICE_DBG_LINK, "eeer_value = 0x%x\n", cfg->eeer_value);
 	ice_debug(hw, ICE_DBG_LINK, "link_fec_opt = 0x%x\n", cfg->link_fec_opt);
 
-	return ice_aq_send_cmd(hw, &desc, cfg, sizeof(*cfg), cd);
+	status = ice_aq_send_cmd(hw, &desc, cfg, sizeof(*cfg), cd);
+	if (hw->adminq.sq_last_status == ICE_AQ_RC_EMODE)
+		status = 0;
+
+	return status;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index cb72ff32a29b..082825e3cb39 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5159,6 +5159,8 @@ const char *ice_aq_str(enum ice_aq_err aq_err)
 		return "ICE_AQ_RC_ENOSPC";
 	case ICE_AQ_RC_ENOSYS:
 		return "ICE_AQ_RC_ENOSYS";
+	case ICE_AQ_RC_EMODE:
+		return "ICE_AQ_RC_EMODE";
 	case ICE_AQ_RC_ENOSEC:
 		return "ICE_AQ_RC_ENOSEC";
 	case ICE_AQ_RC_EBADSIG:
-- 
2.26.2

