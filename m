Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FD7441F99
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhKARzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:55:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:15544 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhKARzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 13:55:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="294530075"
X-IronPort-AV: E=Sophos;i="5.87,200,1631602800"; 
   d="scan'208";a="294530075"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 10:52:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,200,1631602800"; 
   d="scan'208";a="500138952"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 01 Nov 2021 10:52:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates 2021-11-01
Date:   Mon,  1 Nov 2021 10:50:55 -0700
Message-Id: <20211101175100.216963-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Brett fixes issues with promiscuous mode settings not being properly
enabled and removes setting of VF antispoof along with promiscuous
mode. He also ensures that VF Tx queues are always disabled and resolves
a race between virtchnl handling and VF related ndo ops.

Sylwester fixes an issue where a VF MAC could not be set to its primary
MAC if the address is already present.
---
The will conflict when merging with net-next. Conflicts should be resolved
as follows:

--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@@ -162,16 -139,10 +162,13 @@@
  #define ice_for_each_q_vector(vsi, i) \
        for ((i) = 0; (i) < (vsi)->num_q_vectors; (i)++)

 +#define ice_for_each_chnl_tc(i)       \
 +      for ((i) = ICE_CHNL_START_TC; (i) < ICE_CHNL_MAX_TC; (i)++)
 +
- #define ICE_UCAST_PROMISC_BITS (ICE_PROMISC_UCAST_TX | ICE_PROMISC_MCAST_TX | \
-                               ICE_PROMISC_UCAST_RX | ICE_PROMISC_MCAST_RX)
+ #define ICE_UCAST_PROMISC_BITS (ICE_PROMISC_UCAST_TX | ICE_PROMISC_UCAST_RX)

--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@@ -1947,7 -1895,7 +1947,9 @@@ static void ice_set_dflt_settings_vfs(s
                ice_vf_ctrl_invalidate_vsi(vf);
                ice_vf_fdir_init(vf);

 +              ice_vc_set_dflt_vf_ops(&vf->vc_ops);
++
+               mutex_init(&vf->cfg_lock);
        }
  }

@@@ -3054,28 -2998,7 +3057,10 @@@ static int ice_vc_cfg_promiscuous_mode_
        rm_promisc = !allmulti && !alluni;

        if (vsi->num_vlan || vf->port_vlan_info) {
-               struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
-               struct net_device *pf_netdev;
-
-               if (!pf_vsi) {
-                       v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-                       goto error_param;
-               }
-
-               pf_netdev = pf_vsi->netdev;
-
-               ret = ice_set_vf_spoofchk(pf_netdev, vf->vf_id, rm_promisc);
-               if (ret) {
-                       dev_err(dev, "Failed to update spoofchk to %s for VF %d VSI %d when setting promiscuous mode\n",
-                               rm_promisc ? "ON" : "OFF", vf->vf_id,
-                               vsi->vsi_num);
-                       v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-               }
-
 -              ret = ice_cfg_vlan_pruning(vsi, true, !rm_promisc);
 +              if (rm_promisc)
 +                      ret = ice_cfg_vlan_pruning(vsi, true);
 +              else
 +                      ret = ice_cfg_vlan_pruning(vsi, false);
                if (ret) {
                        dev_err(dev, "Failed to configure VLAN pruning in promiscuous mode\n");
                        v_ret = VIRTCHNL_STATUS_ERR_PARAM;

The following are changes since commit 6b278c0cb378079f3c0c61ae4a369c09ff1a4188:
  ibmvnic: delay complete()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Brett Creeley (4):
  ice: Fix VF true promiscuous mode
  ice: Remove toggling of antispoof for VF trusted promiscuous mode
  ice: Fix not stopping Tx queues for VFs
  ice: Fix race conditions between virtchnl handling and VF ndo ops

Sylwester Dziedziuch (1):
  ice: Fix replacing VF hardware MAC to existing MAC filter

 drivers/net/ethernet/intel/ice/ice.h          |   5 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |   2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 141 ++++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   5 +
 4 files changed, 82 insertions(+), 71 deletions(-)

-- 
2.31.1

