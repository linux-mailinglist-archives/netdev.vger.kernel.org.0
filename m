Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E943165225
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgBSWHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:07:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:62543 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgBSWHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:07:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 14:06:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="239824815"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga006.jf.intel.com with ESMTP; 19 Feb 2020 14:06:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Avinash Dayanand <avinash.dayanand@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Scott Register <scottx.register@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/13] ice: Report correct DCB mode
Date:   Wed, 19 Feb 2020 14:06:45 -0800
Message-Id: <20200219220652.2255171-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
References: <20200219220652.2255171-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avinash Dayanand <avinash.dayanand@intel.com>

Add code to detect if DCB is in IEEE or CEE mode. Without this the code
will always report as IEEE mode which is incorrect and confuses the
user.

Signed-off-by: Avinash Dayanand <avinash.dayanand@intel.com>
Signed-off-by: Scott Register <scottx.register@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 27 +++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 1c118e7bab88..16656b6c3d09 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -62,6 +62,26 @@ u8 ice_dcb_get_ena_tc(struct ice_dcbx_cfg *dcbcfg)
 	return ena_tc;
 }
 
+/**
+ * ice_dcb_get_mode - gets the DCB mode
+ * @port_info: pointer to port info structure
+ * @host: if set it's HOST if not it's MANAGED
+ */
+static u8 ice_dcb_get_mode(struct ice_port_info *port_info, bool host)
+{
+	u8 mode;
+
+	if (host)
+		mode = DCB_CAP_DCBX_HOST;
+	else
+		mode = DCB_CAP_DCBX_LLD_MANAGED;
+
+	if (port_info->local_dcbx_cfg.dcbx_mode & ICE_DCBX_MODE_CEE)
+		return (mode | DCB_CAP_DCBX_VER_CEE);
+	else
+		return (mode | DCB_CAP_DCBX_VER_IEEE);
+}
+
 /**
  * ice_dcb_get_num_tc - Get the number of TCs from DCBX config
  * @dcbcfg: config to retrieve number of TCs from
@@ -645,14 +665,14 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 
 		ice_cfg_sw_lldp(pf_vsi, false, true);
 
-		pf->dcbx_cap = DCB_CAP_DCBX_HOST | DCB_CAP_DCBX_VER_IEEE;
+		pf->dcbx_cap = ice_dcb_get_mode(port_info, true);
 		return 0;
 	}
 
 	set_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags);
 
-	/* DCBX in FW and LLDP enabled in FW */
-	pf->dcbx_cap = DCB_CAP_DCBX_LLD_MANAGED | DCB_CAP_DCBX_VER_IEEE;
+	/* DCBX/LLDP enabled in FW, set DCBNL mode advertisement */
+	pf->dcbx_cap = ice_dcb_get_mode(port_info, false);
 
 	err = ice_dcb_init_cfg(pf, locked);
 	if (err)
@@ -812,6 +832,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	/* No change detected in DCBX configs */
 	if (!memcmp(&tmp_dcbx_cfg, &pi->local_dcbx_cfg, sizeof(tmp_dcbx_cfg))) {
 		dev_dbg(dev, "No change detected in DCBX configuration.\n");
+		pf->dcbx_cap = ice_dcb_get_mode(pi, false);
 		goto out;
 	}
 
-- 
2.24.1

