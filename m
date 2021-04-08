Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298F735895F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhDHQMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:12:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:47829 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232144AbhDHQLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:55 -0400
IronPort-SDR: Dx5qKIhK57p2Gqw5l8SIWPeWuoFxf5V+DbAKzMFIzKCFH+35BVSDsAj9R81/5l94JacPjhobS+
 a0oRD1sifRFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="180707321"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="180707321"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:42 -0700
IronPort-SDR: Gc70kQnkb5Yb+UsxS7mX5qKbZ8hDShg6pmfUKRSnJCXxi3DdexVcqovlkEPy7FDUAfj95qDUoK
 CzdGqhp16aNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841442"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 11/15] ice: Remove unnecessary variable
Date:   Thu,  8 Apr 2021 09:13:17 -0700
Message-Id: <20210408161321.3218024-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

In ice_init_phy_user_cfg, vsi is used only to get to hw. Remove this
and just use pi->hw

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6bc2215b674d..c81eb27e83a6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1791,16 +1791,11 @@ static int ice_init_phy_user_cfg(struct ice_port_info *pi)
 	struct ice_phy_info *phy = &pi->phy;
 	struct ice_pf *pf = pi->hw->back;
 	enum ice_status status;
-	struct ice_vsi *vsi;
 	int err = 0;
 
 	if (!(phy->link_info.link_info & ICE_AQ_MEDIA_AVAILABLE))
 		return -EIO;
 
-	vsi = ice_get_main_vsi(pf);
-	if (!vsi)
-		return -EINVAL;
-
 	pcaps = kzalloc(sizeof(*pcaps), GFP_KERNEL);
 	if (!pcaps)
 		return -ENOMEM;
@@ -1820,7 +1815,7 @@ static int ice_init_phy_user_cfg(struct ice_port_info *pi)
 	ice_copy_phy_caps_to_cfg(pi, pcaps, &pi->phy.curr_user_phy_cfg);
 
 	/* check if lenient mode is supported and enabled */
-	if (ice_fw_supports_link_override(&vsi->back->hw) &&
+	if (ice_fw_supports_link_override(pi->hw) &&
 	    !(pcaps->module_compliance_enforcement &
 	      ICE_AQC_MOD_ENFORCE_STRICT_MODE)) {
 		set_bit(ICE_FLAG_LINK_LENIENT_MODE_ENA, pf->flags);
-- 
2.26.2

