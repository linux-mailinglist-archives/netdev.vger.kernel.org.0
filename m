Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB7E35FEDA
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhDOA2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:28:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:27420 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231419AbhDOA2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:48 -0400
IronPort-SDR: jT6cnwwXVGBwAMU2Jzcx8XC55/UbWT0/NzCMUzqptA3MP92sK1LCc1Hrp6z/ZqYPXHtymWZ5KA
 Z1SfavAetyjw==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262225"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262225"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:26 -0700
IronPort-SDR: t/C3J4ZO2i7EZMG2B8smG4Nl0qDv/kGsgNbneCs5cZEsXbRsa4L0AnsyN+ZBqmwu95G+uU63iM
 1ewkwzmI0yqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379503"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 03/15] ice: Add new VSI states to track netdev alloc/registration
Date:   Wed, 14 Apr 2021 17:30:01 -0700
Message-Id: <20210415003013.19717-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Add two new VSI states, one to track if a netdev for the VSI has been
allocated and the other to track if the netdev has been registered.
Call unregister_netdev/free_netdev only when the corresponding state
bits are set.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  2 ++
 drivers/net/ethernet/intel/ice/ice_lib.c  | 21 +++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_main.c |  5 +++++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 2cb09af3148c..5e1a680e8a8e 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -241,6 +241,8 @@ enum ice_pf_state {
 enum ice_vsi_state {
 	ICE_VSI_DOWN,
 	ICE_VSI_NEEDS_RESTART,
+	ICE_VSI_NETDEV_ALLOCD,
+	ICE_VSI_NETDEV_REGISTERED,
 	ICE_VSI_UMAC_FLTR_CHANGED,
 	ICE_VSI_MMAC_FLTR_CHANGED,
 	ICE_VSI_VLAN_FLTR_CHANGED,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 162f01b42147..40a9b034d73b 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2752,11 +2752,14 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	 * PF that is running the work queue items currently. This is done to
 	 * avoid check_flush_dependency() warning on this wq
 	 */
-	if (vsi->netdev && !ice_is_reset_in_progress(pf->state)) {
+	if (vsi->netdev && !ice_is_reset_in_progress(pf->state) &&
+	    (test_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state))) {
 		unregister_netdev(vsi->netdev);
-		ice_devlink_destroy_port(vsi);
+		clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 	}
 
+	ice_devlink_destroy_port(vsi);
+
 	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
 		ice_rss_clean(vsi);
 
@@ -2811,10 +2814,16 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	ice_vsi_delete(vsi);
 	ice_vsi_free_q_vectors(vsi);
 
-	/* make sure unregister_netdev() was called by checking ICE_DOWN */
-	if (vsi->netdev && test_bit(ICE_VSI_DOWN, vsi->state)) {
-		free_netdev(vsi->netdev);
-		vsi->netdev = NULL;
+	if (vsi->netdev) {
+		if (test_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state)) {
+			unregister_netdev(vsi->netdev);
+			clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
+		}
+		if (test_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state)) {
+			free_netdev(vsi->netdev);
+			vsi->netdev = NULL;
+			clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
+		}
 	}
 
 	if (vsi->type == ICE_VSI_VF &&
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 032101680e09..035c593bce61 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2977,6 +2977,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	if (!netdev)
 		return -ENOMEM;
 
+	set_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
 	vsi->netdev = netdev;
 	np = netdev_priv(netdev);
 	np->vsi = vsi;
@@ -3189,6 +3190,7 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 	if (vsi) {
 		ice_napi_del(vsi);
 		if (vsi->netdev) {
+			clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
 			free_netdev(vsi->netdev);
 			vsi->netdev = NULL;
 		}
@@ -3958,6 +3960,7 @@ static int ice_register_netdev(struct ice_pf *pf)
 	if (err)
 		goto err_register_netdev;
 
+	set_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 	netif_carrier_off(vsi->netdev);
 	netif_tx_stop_all_queues(vsi->netdev);
 	err = ice_devlink_create_port(vsi);
@@ -3969,9 +3972,11 @@ static int ice_register_netdev(struct ice_pf *pf)
 	return 0;
 err_devlink_create:
 	unregister_netdev(vsi->netdev);
+	clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 err_register_netdev:
 	free_netdev(vsi->netdev);
 	vsi->netdev = NULL;
+	clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
 	return err;
 }
 
-- 
2.26.2

