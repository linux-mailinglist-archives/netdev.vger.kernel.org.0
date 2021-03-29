Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E73534D8EB
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhC2UR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:17:59 -0400
Received: from mga18.intel.com ([134.134.136.126]:19968 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230458AbhC2UR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:17:27 -0400
IronPort-SDR: pz9greP9XrVeQ9uf2ZufRS1jKzAAhri4EB9H2URyxvddHd5q7IIb4i3XlSuNM/G7UEC9Etmcwh
 TN0MrcP0IAdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179160818"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="179160818"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 13:17:26 -0700
IronPort-SDR: uD1QpCofrXGlzLAnltQHFvE9AnS8RoNHn7zGpGh236h4X3gV4VzOuZUhrs/3F5iJLuKWwExjM8
 cKNDhIr3Km5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="454700543"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2021 13:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Krzysztof Goreczny <krzysztof.goreczny@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 4/9] ice: prevent ice_open and ice_stop during reset
Date:   Mon, 29 Mar 2021 13:18:52 -0700
Message-Id: <20210329201857.3509461-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
References: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Goreczny <krzysztof.goreczny@intel.com>

There is a possibility of race between ice_open or ice_stop calls
performed by OS and reset handling routine both trying to modify VSI
resources. Observed scenarios:
- reset handler deallocates memory in ice_vsi_free_arrays and ice_open
  tries to access it in ice_vsi_cfg_txq leading to driver crash
- reset handler deallocates memory in ice_vsi_free_arrays and ice_close
  tries to access it in ice_down leading to driver crash
- reset handler clears port scheduler topology and sets port state to
  ICE_SCHED_PORT_STATE_INIT leading to ice_ena_vsi_txq fail in ice_open

To prevent this additional checks in ice_open and ice_stop are
introduced to make sure that OS is not allowed to alter VSI config while
reset is in progress.

Fixes: cdedef59deb0 ("ice: Configure VSIs for Tx/Rx")
Signed-off-by: Krzysztof Goreczny <krzysztof.goreczny@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_lib.c  |  4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c | 28 +++++++++++++++++++++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 357706444dd5..1d4518638215 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -642,6 +642,7 @@ int ice_fdir_create_dflt_rules(struct ice_pf *pf);
 int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
 			  struct ice_rq_event_info *event);
 int ice_open(struct net_device *netdev);
+int ice_open_internal(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8d4e2ad4328d..7ac2beaed95c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2620,7 +2620,7 @@ int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
 			if (!locked)
 				rtnl_lock();
 
-			err = ice_open(vsi->netdev);
+			err = ice_open_internal(vsi->netdev);
 
 			if (!locked)
 				rtnl_unlock();
@@ -2649,7 +2649,7 @@ void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
 			if (!locked)
 				rtnl_lock();
 
-			ice_stop(vsi->netdev);
+			ice_vsi_close(vsi);
 
 			if (!locked)
 				rtnl_unlock();
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 53e053c997eb..255a07c1e33a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6632,6 +6632,28 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
  * Returns 0 on success, negative value on failure
  */
 int ice_open(struct net_device *netdev)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_pf *pf = np->vsi->back;
+
+	if (ice_is_reset_in_progress(pf->state)) {
+		netdev_err(netdev, "can't open net device while reset is in progress");
+		return -EBUSY;
+	}
+
+	return ice_open_internal(netdev);
+}
+
+/**
+ * ice_open_internal - Called when a network interface becomes active
+ * @netdev: network interface device structure
+ *
+ * Internal ice_open implementation. Should not be used directly except for ice_open and reset
+ * handling routine
+ *
+ * Returns 0 on success, negative value on failure
+ */
+int ice_open_internal(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
@@ -6712,6 +6734,12 @@ int ice_stop(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+
+	if (ice_is_reset_in_progress(pf->state)) {
+		netdev_err(netdev, "can't stop net device while reset is in progress");
+		return -EBUSY;
+	}
 
 	ice_vsi_close(vsi);
 
-- 
2.26.2

