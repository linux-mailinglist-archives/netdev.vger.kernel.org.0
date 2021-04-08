Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222C0358959
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbhDHQMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:12:01 -0400
Received: from mga07.intel.com ([134.134.136.100]:15195 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231480AbhDHQLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:52 -0400
IronPort-SDR: WdxwF+ju6dfeusTXuXNzaFBbI3+uooCPKHCfcmkFX9Gi/To1lIdSjaFzyEMh/w79qeAxN1mjMd
 /C5n94H8a14A==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="257557987"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="257557987"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:39 -0700
IronPort-SDR: YRO1VPhAp/gZusLGkov3CwPLn7pT4EV23acSaC7Ib6YeeMzuF2aVtTWuMUqYFZ8NThCBgsqoag
 JKeGVir3qkTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841408"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:39 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 05/15] ice: Remove unnecessary checker loop
Date:   Thu,  8 Apr 2021 09:13:11 -0700
Message-Id: <20210408161321.3218024-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

The loop checking for PF VSI doesn't make any sense. The VSI type
backing the netdev passed to ice_set_link_ksettings will always be
of type ICE_PF_VSI. Remove it.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 0db31a89658a..c8a8fdac4977 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2198,8 +2198,8 @@ ice_set_link_ksettings(struct net_device *netdev,
 	struct ethtool_link_ksettings safe_ks, copy_ks;
 	struct ice_aqc_get_phy_caps_data *abilities;
 	u8 autoneg, timeout = TEST_SET_BITS_TIMEOUT;
-	u16 adv_link_speed, curr_link_speed, idx;
 	struct ice_aqc_set_phy_cfg_data config;
+	u16 adv_link_speed, curr_link_speed;
 	struct ice_pf *pf = np->vsi->back;
 	struct ice_port_info *p;
 	u8 autoneg_changed = 0;
@@ -2214,14 +2214,6 @@ ice_set_link_ksettings(struct net_device *netdev,
 	if (!p)
 		return -EOPNOTSUPP;
 
-	/* Check if this is LAN VSI */
-	ice_for_each_vsi(pf, idx)
-		if (pf->vsi[idx]->type == ICE_VSI_PF) {
-			if (np->vsi != pf->vsi[idx])
-				return -EOPNOTSUPP;
-			break;
-		}
-
 	if (p->phy.media_type != ICE_MEDIA_BASET &&
 	    p->phy.media_type != ICE_MEDIA_FIBER &&
 	    p->phy.media_type != ICE_MEDIA_BACKPLANE &&
-- 
2.26.2

