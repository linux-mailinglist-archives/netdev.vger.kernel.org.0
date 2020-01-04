Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD5CE130035
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgADCt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:49:57 -0500
Received: from mga12.intel.com ([192.55.52.136]:64695 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727477AbgADCt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757856"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/16] ice: Add code to keep track of current dflt_vsi
Date:   Fri,  3 Jan 2020 18:49:40 -0800
Message-Id: <20200104024953.2336731-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

We can't have more than one default VSI so prevent another VSI from
overwriting the current dflt_vsi. This was achieved by adding the
following functions:

ice_is_dflt_vsi_in_use()
- Used to check if the default VSI is already being used.

ice_is_vsi_dflt_vsi()
- Used to check if VSI passed in is in fact the default VSI.

ice_set_dflt_vsi()
- Used to set the default VSI via a switch rule

ice_clear_dflt_vsi()
- Used to clear the default VSI via a switch rule.

Also, there was no need to introduce any locking because all mailbox
events and synchronization of switch filters for the PF happen in the
service task.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c  | 118 ++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h  |   8 ++
 drivers/net/ethernet/intel/ice/ice_main.c |  43 +++++---
 4 files changed, 155 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 54b2c349c195..1376219a6c7e 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -174,6 +174,8 @@ struct ice_sw {
 	struct ice_pf *pf;
 	u16 sw_id;		/* switch ID for this switch */
 	u16 bridge_mode;	/* VEB/VEPA/Port Virtualizer */
+	struct ice_vsi *dflt_vsi;	/* default VSI for this switch */
+	u8 dflt_vsi_ena:1;	/* true if above dflt_vsi is enabled */
 };
 
 enum ice_state {
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a47241e92d0b..b5cd275606bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2742,3 +2742,121 @@ ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set)
 	ice_free_fltr_list(&vsi->back->pdev->dev, &tmp_add_list);
 	return status;
 }
+
+/**
+ * ice_is_dflt_vsi_in_use - check if the default forwarding VSI is being used
+ * @sw: switch to check if its default forwarding VSI is free
+ *
+ * Return true if the default forwarding VSI is already being used, else returns
+ * false signalling that it's available to use.
+ */
+bool ice_is_dflt_vsi_in_use(struct ice_sw *sw)
+{
+	return (sw->dflt_vsi && sw->dflt_vsi_ena);
+}
+
+/**
+ * ice_is_vsi_dflt_vsi - check if the VSI passed in is the default VSI
+ * @sw: switch for the default forwarding VSI to compare against
+ * @vsi: VSI to compare against default forwarding VSI
+ *
+ * If this VSI passed in is the default forwarding VSI then return true, else
+ * return false
+ */
+bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi)
+{
+	return (sw->dflt_vsi == vsi && sw->dflt_vsi_ena);
+}
+
+/**
+ * ice_set_dflt_vsi - set the default forwarding VSI
+ * @sw: switch used to assign the default forwarding VSI
+ * @vsi: VSI getting set as the default forwarding VSI on the switch
+ *
+ * If the VSI passed in is already the default VSI and it's enabled just return
+ * success.
+ *
+ * If there is already a default VSI on the switch and it's enabled then return
+ * -EEXIST since there can only be one default VSI per switch.
+ *
+ *  Otherwise try to set the VSI passed in as the switch's default VSI and
+ *  return the result.
+ */
+int ice_set_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi)
+{
+	enum ice_status status;
+	struct device *dev;
+
+	if (!sw || !vsi)
+		return -EINVAL;
+
+	dev = ice_pf_to_dev(vsi->back);
+
+	/* the VSI passed in is already the default VSI */
+	if (ice_is_vsi_dflt_vsi(sw, vsi)) {
+		dev_dbg(dev, "VSI %d passed in is already the default forwarding VSI, nothing to do\n",
+			vsi->vsi_num);
+		return 0;
+	}
+
+	/* another VSI is already the default VSI for this switch */
+	if (ice_is_dflt_vsi_in_use(sw)) {
+		dev_err(dev,
+			"Default forwarding VSI %d already in use, disable it and try again\n",
+			sw->dflt_vsi->vsi_num);
+		return -EEXIST;
+	}
+
+	status = ice_cfg_dflt_vsi(&vsi->back->hw, vsi->idx, true, ICE_FLTR_RX);
+	if (status) {
+		dev_err(dev,
+			"Failed to set VSI %d as the default forwarding VSI, error %d\n",
+			vsi->vsi_num, status);
+		return -EIO;
+	}
+
+	sw->dflt_vsi = vsi;
+	sw->dflt_vsi_ena = true;
+
+	return 0;
+}
+
+/**
+ * ice_clear_dflt_vsi - clear the default forwarding VSI
+ * @sw: switch used to clear the default VSI
+ *
+ * If the switch has no default VSI or it's not enabled then return error.
+ *
+ * Otherwise try to clear the default VSI and return the result.
+ */
+int ice_clear_dflt_vsi(struct ice_sw *sw)
+{
+	struct ice_vsi *dflt_vsi;
+	enum ice_status status;
+	struct device *dev;
+
+	if (!sw)
+		return -EINVAL;
+
+	dev = ice_pf_to_dev(sw->pf);
+
+	dflt_vsi = sw->dflt_vsi;
+
+	/* there is no default VSI configured */
+	if (!ice_is_dflt_vsi_in_use(sw))
+		return -ENODEV;
+
+	status = ice_cfg_dflt_vsi(&dflt_vsi->back->hw, dflt_vsi->idx, false,
+				  ICE_FLTR_RX);
+	if (status) {
+		dev_err(dev,
+			"Failed to clear the default forwarding VSI %d, error %d\n",
+			dflt_vsi->vsi_num, status);
+		return -EIO;
+	}
+
+	sw->dflt_vsi = NULL;
+	sw->dflt_vsi_ena = false;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 6e31e30aba39..68fd0d4505c2 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -103,4 +103,12 @@ enum ice_status
 ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
 bool ice_is_safe_mode(struct ice_pf *pf);
+
+bool ice_is_dflt_vsi_in_use(struct ice_sw *sw);
+
+bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
+
+int ice_set_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
+
+int ice_clear_dflt_vsi(struct ice_sw *sw);
 #endif /* !_ICE_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1fc6c350487b..639de467f120 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -379,25 +379,29 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 		clear_bit(ICE_VSI_FLAG_PROMISC_CHANGED, vsi->flags);
 		if (vsi->current_netdev_flags & IFF_PROMISC) {
 			/* Apply Rx filter rule to get traffic from wire */
-			status = ice_cfg_dflt_vsi(hw, vsi->idx, true,
-						  ICE_FLTR_RX);
-			if (status) {
-				netdev_err(netdev, "Error setting default VSI %i Rx rule\n",
-					   vsi->vsi_num);
-				vsi->current_netdev_flags &= ~IFF_PROMISC;
-				err = -EIO;
-				goto out_promisc;
+			if (!ice_is_dflt_vsi_in_use(pf->first_sw)) {
+				err = ice_set_dflt_vsi(pf->first_sw, vsi);
+				if (err && err != -EEXIST) {
+					netdev_err(netdev,
+						   "Error %d setting default VSI %i Rx rule\n",
+						   err, vsi->vsi_num);
+					vsi->current_netdev_flags &=
+						~IFF_PROMISC;
+					goto out_promisc;
+				}
 			}
 		} else {
 			/* Clear Rx filter to remove traffic from wire */
-			status = ice_cfg_dflt_vsi(hw, vsi->idx, false,
-						  ICE_FLTR_RX);
-			if (status) {
-				netdev_err(netdev, "Error clearing default VSI %i Rx rule\n",
-					   vsi->vsi_num);
-				vsi->current_netdev_flags |= IFF_PROMISC;
-				err = -EIO;
-				goto out_promisc;
+			if (ice_is_vsi_dflt_vsi(pf->first_sw, vsi)) {
+				err = ice_clear_dflt_vsi(pf->first_sw);
+				if (err) {
+					netdev_err(netdev,
+						   "Error %d clearing default VSI %i Rx rule\n",
+						   err, vsi->vsi_num);
+					vsi->current_netdev_flags |=
+						IFF_PROMISC;
+					goto out_promisc;
+				}
 			}
 		}
 	}
@@ -4671,6 +4675,13 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 		goto err_init_ctrlq;
 	}
 
+	if (pf->first_sw->dflt_vsi_ena)
+		dev_info(dev,
+			 "Clearing default VSI, re-enable after reset completes\n");
+	/* clear the default VSI configuration if it exists */
+	pf->first_sw->dflt_vsi = NULL;
+	pf->first_sw->dflt_vsi_ena = false;
+
 	ice_clear_pxe_mode(hw);
 
 	ret = ice_get_caps(hw);
-- 
2.24.1

