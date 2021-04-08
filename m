Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EE3358960
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhDHQMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:12:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:47825 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232156AbhDHQLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:55 -0400
IronPort-SDR: hNq2QB39epCWgSTeZIUKdtepEHeo3MP1Hj7PAmPBDZmA/lwVd/R8ov1aUvqhCQOBw6/NVbW+UN
 qoHZqt0Y01PQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="180707317"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="180707317"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:42 -0700
IronPort-SDR: 9eWSqWwki34WKChjfsYOEoRBySGl7P4rbx9IzoYxQcTWhIQSdomGZOzMQqpSQ5wWSg1vxinfDZ
 T2xuhQFMhNMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841436"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jeb Cramer <jeb.j.cramer@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 10/15] ice: Limit forced overrides based on FW version
Date:   Thu,  8 Apr 2021 09:13:16 -0700
Message-Id: <20210408161321.3218024-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeb Cramer <jeb.j.cramer@intel.com>

Beyond a specific version of firmware, there is no need to provide
override values to the firmware when setting PHY capabilities.  In this
case, we do not need to indicate whether we're in Strict or Lenient Link
Mode.

In the case of translating capabilities to the configuration structure,
the module compliance enforcement is already correctly set by firmware,
so the extra code block is redundant.

Signed-off-by: Jeb Cramer <jeb.j.cramer@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 8485450aff80..b13a630ea1b7 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3013,17 +3013,6 @@ ice_copy_phy_caps_to_cfg(struct ice_port_info *pi,
 	cfg->link_fec_opt = caps->link_fec_options;
 	cfg->module_compliance_enforcement =
 		caps->module_compliance_enforcement;
-
-	if (ice_fw_supports_link_override(pi->hw)) {
-		struct ice_link_default_override_tlv tlv;
-
-		if (ice_get_link_default_override(&tlv, pi))
-			return;
-
-		if (tlv.options & ICE_LINK_OVERRIDE_STRICT_MODE)
-			cfg->module_compliance_enforcement |=
-				ICE_LINK_OVERRIDE_STRICT_MODE;
-	}
 }
 
 /**
@@ -3091,7 +3080,8 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 		break;
 	}
 
-	if (fec == ICE_FEC_AUTO && ice_fw_supports_link_override(pi->hw)) {
+	if (fec == ICE_FEC_AUTO && ice_fw_supports_link_override(hw) &&
+	    !ice_fw_supports_report_dflt_cfg(hw)) {
 		struct ice_link_default_override_tlv tlv;
 
 		if (ice_get_link_default_override(&tlv, pi))
-- 
2.26.2

