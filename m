Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2667035FEDD
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhDOA3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:27426 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231244AbhDOA2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:49 -0400
IronPort-SDR: IfYIhKJrEmgqPflrZl34UvDN1MDE3/+t/5eHZZCODQjsKXngaLqhR2v9fIy/GM8zgDjhS6NYsC
 HknnKP31zSJQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262234"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262234"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:26 -0700
IronPort-SDR: GEoH21r2JDp6vI6TDdtjAImDdxSPvsBpwYbPoEio2vHG353i8eoo4Xhq8nwuJCrigi/eLEmS68
 hpjN8NFyHUCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379494"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 01/15] ice: use kernel definitions for IANA protocol ports and ether-types
Date:   Wed, 14 Apr 2021 17:29:59 -0700
Message-Id: <20210415003013.19717-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

The well-known IANA protocol port 3260 (iscsi-target 0x0cbc) and the
ether-types 0x8906 (ETH_P_FCOE) and 0x8914 (ETH_P_FIP) are already defined
in kernel header files.  Use those definitions instead of open-coding the
same.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         | 3 +++
 drivers/net/ethernet/intel/ice/ice_dcb.c     | 8 ++++----
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 2 +-
 drivers/net/ethernet/intel/ice/ice_type.h    | 3 ---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 07777ac4f098..dd2e75d15558 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -44,6 +44,9 @@
 #include <net/gre.h>
 #include <net/udp_tunnel.h>
 #include <net/vxlan.h>
+#if IS_ENABLED(CONFIG_DCB)
+#include <scsi/iscsi_proto.h>
+#endif /* CONFIG_DCB */
 #include "ice_devids.h"
 #include "ice_type.h"
 #include "ice_txrx.h"
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 43c6af42de8a..34c1aba050b8 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -804,7 +804,7 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 			ice_aqc_cee_app_mask = ICE_AQC_CEE_APP_FCOE_M;
 			ice_aqc_cee_app_shift = ICE_AQC_CEE_APP_FCOE_S;
 			ice_app_sel_type = ICE_APP_SEL_ETHTYPE;
-			ice_app_prot_id_type = ICE_APP_PROT_ID_FCOE;
+			ice_app_prot_id_type = ETH_P_FCOE;
 		} else if (i == 1) {
 			/* iSCSI APP */
 			ice_aqc_cee_status_mask = ICE_AQC_CEE_ISCSI_STATUS_M;
@@ -812,14 +812,14 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 			ice_aqc_cee_app_mask = ICE_AQC_CEE_APP_ISCSI_M;
 			ice_aqc_cee_app_shift = ICE_AQC_CEE_APP_ISCSI_S;
 			ice_app_sel_type = ICE_APP_SEL_TCPIP;
-			ice_app_prot_id_type = ICE_APP_PROT_ID_ISCSI;
+			ice_app_prot_id_type = ISCSI_LISTEN_PORT;
 
 			for (j = 0; j < cmp_dcbcfg->numapps; j++) {
 				u16 prot_id = cmp_dcbcfg->app[j].prot_id;
 				u8 sel = cmp_dcbcfg->app[j].selector;
 
 				if  (sel == ICE_APP_SEL_TCPIP &&
-				     (prot_id == ICE_APP_PROT_ID_ISCSI ||
+				     (prot_id == ISCSI_LISTEN_PORT ||
 				      prot_id == ICE_APP_PROT_ID_ISCSI_860)) {
 					ice_app_prot_id_type = prot_id;
 					break;
@@ -832,7 +832,7 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 			ice_aqc_cee_app_mask = ICE_AQC_CEE_APP_FIP_M;
 			ice_aqc_cee_app_shift = ICE_AQC_CEE_APP_FIP_S;
 			ice_app_sel_type = ICE_APP_SEL_ETHTYPE;
-			ice_app_prot_id_type = ICE_APP_PROT_ID_FIP;
+			ice_app_prot_id_type = ETH_P_FIP;
 		}
 
 		status = (tlv_status & ice_aqc_cee_status_mask) >>
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 1e8f71ffc8ce..df02cffdf209 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -563,7 +563,7 @@ static int ice_dcb_sw_dflt_cfg(struct ice_pf *pf, bool ets_willing, bool locked)
 	dcbcfg->numapps = 1;
 	dcbcfg->app[0].selector = ICE_APP_SEL_ETHTYPE;
 	dcbcfg->app[0].priority = 3;
-	dcbcfg->app[0].prot_id = ICE_APP_PROT_ID_FCOE;
+	dcbcfg->app[0].prot_id = ETH_P_FCOE;
 
 	ret = ice_pf_dcb_cfg(pf, dcbcfg, locked);
 	kfree(dcbcfg);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 7ead1c13f16f..9b80962ff92f 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -551,10 +551,7 @@ struct ice_dcb_app_priority_table {
 #define ICE_TLV_STATUS_OPER	0x1
 #define ICE_TLV_STATUS_SYNC	0x2
 #define ICE_TLV_STATUS_ERR	0x4
-#define ICE_APP_PROT_ID_FCOE	0x8906
-#define ICE_APP_PROT_ID_ISCSI	0x0cbc
 #define ICE_APP_PROT_ID_ISCSI_860 0x035c
-#define ICE_APP_PROT_ID_FIP	0x8914
 #define ICE_APP_SEL_ETHTYPE	0x1
 #define ICE_APP_SEL_TCPIP	0x2
 #define ICE_CEE_APP_SEL_ETHTYPE	0x0
-- 
2.26.2

