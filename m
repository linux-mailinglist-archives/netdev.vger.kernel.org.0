Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9C5440452
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhJ2Uty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:49:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:9541 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhJ2Uts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:49:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="291587513"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="291587513"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 13:47:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="448483292"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 29 Oct 2021 13:47:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 2/7] ice: Clear synchronized addrs when adding VFs in switchdev mode
Date:   Fri, 29 Oct 2021 13:45:35 -0700
Message-Id: <20211029204540.3390007-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
References: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@linux.intel.com>

When spawning VFs in switchdev mode, internal filter list of VSIs is
cleared, which includes MAC rules. However MAC entries stay on netdev's
multicast list, which causes error message when bringing link up after
spawning VFs ("Failed to delete MAC filters"). __dev_mc_sync() is
called and tries to unsync addresses that were already removed
internally when adding VFs.

This can be reproduced with:
1) Load ice driver
2) Change PF to switchdev mode
3) Bring PF link up
4) Bring PF link down
5) Create a VF on PF
6) Bring PF link up

Added clearing of netdev's multicast (and also unicast) list when
spawning VFs in switchdev mode, so the state of internal rule list and
netdev's MAC list is consistent.

Fixes: 1a1c40df2e80 ("ice: set and release switchdev environment")
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 6cb50653b18d..d1d7389b0bff 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -19,6 +19,7 @@
 static int ice_eswitch_setup_env(struct ice_pf *pf)
 {
 	struct ice_vsi *uplink_vsi = pf->switchdev.uplink_vsi;
+	struct net_device *uplink_netdev = uplink_vsi->netdev;
 	struct ice_vsi *ctrl_vsi = pf->switchdev.control_vsi;
 	struct ice_port_info *pi = pf->hw.port_info;
 	bool rule_added = false;
@@ -27,6 +28,11 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
 
 	ice_remove_vsi_fltr(&pf->hw, uplink_vsi->idx);
 
+	netif_addr_lock_bh(uplink_netdev);
+	__dev_uc_unsync(uplink_netdev, NULL);
+	__dev_mc_unsync(uplink_netdev, NULL);
+	netif_addr_unlock_bh(uplink_netdev);
+
 	if (ice_vsi_add_vlan(uplink_vsi, 0, ICE_FWD_TO_VSI))
 		goto err_def_rx;
 
-- 
2.31.1

