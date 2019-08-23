Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2576D9B8FB
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfHWXhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:37:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:14901 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfHWXhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:37:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 16:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="184354426"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2019 16:37:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/14] ice: Rename ethtool private flag for lldp
Date:   Fri, 23 Aug 2019 16:37:43 -0700
Message-Id: <20190823233750.7997-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The current flag name of "enable-fw-lldp" is a bit cumbersome.

Change priv-flag name to "fw-lldp-agent" with a value of on or
off.  This is more straight-forward in meaning.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         | 2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 4 ++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 +++---
 drivers/net/ethernet/intel/ice/ice_lib.c     | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 9f9c30d29eb5..99e0febd8e50 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -329,7 +329,7 @@ enum ice_pf_flags {
 	ICE_FLAG_DCB_ENA,
 	ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA,
 	ICE_FLAG_NO_MEDIA,
-	ICE_FLAG_ENABLE_FW_LLDP,
+	ICE_FLAG_FW_LLDP_AGENT,
 	ICE_FLAG_ETHTOOL_CTXT,		/* set when ethtool holds RTNL lock */
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 4fc9faf5bc71..734cef8eed9e 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -457,7 +457,7 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 		dev_info(&pf->pdev->dev,
 			 "FW LLDP is disabled, DCBx/LLDP in SW mode.\n");
 		port_info->is_sw_lldp = true;
-		clear_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags);
+		clear_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags);
 		err = ice_dcb_sw_dflt_cfg(pf, locked);
 		if (err) {
 			dev_err(&pf->pdev->dev,
@@ -473,7 +473,7 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 	}
 
 	port_info->is_sw_lldp = false;
-	set_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags);
+	set_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags);
 
 	/* DCBX in FW and LLDP enabled in FW */
 	pf->dcbx_cap = DCB_CAP_DCBX_LLD_MANAGED | DCB_CAP_DCBX_VER_IEEE;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 6a97ddbbda76..948a33716290 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -155,7 +155,7 @@ struct ice_priv_flag {
 
 static const struct ice_priv_flag ice_gstrings_priv_flags[] = {
 	ICE_PRIV_FLAG("link-down-on-close", ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA),
-	ICE_PRIV_FLAG("enable-fw-lldp", ICE_FLAG_ENABLE_FW_LLDP),
+	ICE_PRIV_FLAG("fw-lldp-agent", ICE_FLAG_FW_LLDP_AGENT),
 };
 
 #define ICE_PRIV_FLAG_ARRAY_SIZE	ARRAY_SIZE(ice_gstrings_priv_flags)
@@ -1201,8 +1201,8 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 
 	bitmap_xor(change_flags, pf->flags, orig_flags, ICE_PF_FLAGS_NBITS);
 
-	if (test_bit(ICE_FLAG_ENABLE_FW_LLDP, change_flags)) {
-		if (!test_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags)) {
+	if (test_bit(ICE_FLAG_FW_LLDP_AGENT, change_flags)) {
+		if (!test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags)) {
 			enum ice_status status;
 
 			/* Disable FW LLDP engine */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index c067ef6be7f4..343d0c305423 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2541,7 +2541,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		ice_cfg_sw_lldp(vsi, true, true);
 
 		/* Rx LLDP packets */
-		if (!test_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags))
+		if (!test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
 			ice_cfg_sw_lldp(vsi, false, true);
 	}
 
@@ -2888,7 +2888,7 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		/* The Rx rule will only exist to remove if the LLDP FW
 		 * engine is currently stopped
 		 */
-		if (!test_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags))
+		if (!test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
 			ice_cfg_sw_lldp(vsi, false, false);
 	}
 
-- 
2.21.0

