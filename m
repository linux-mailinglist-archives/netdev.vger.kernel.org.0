Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CB5350A81
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhCaXHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:62995 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhCaXHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:25 -0400
IronPort-SDR: AhK4XWd+W9haMmm73AAVw9ZYulUKvHD3/hZrs61qLKGoKtOjQ5f5zvGvK9S2AqQg2EbQgUYwhE
 sSuWPlVLVpZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587971"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587971"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:23 -0700
IronPort-SDR: NNV0TKk19LGXv8ho3Co9rrjh5+YS2HdmGyF5RQOiA9UOkliu3N03/MEY8T6sE4kPn1CpixVLCP
 ihUxm/LVZwSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680093"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 02/15] ice: Delay netdev registration
Date:   Wed, 31 Mar 2021 16:08:45 -0700
Message-Id: <20210331230858.782492-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Once a netdev is registered, the corresponding network interface can
be immediately used by userspace utilities (like say NetworkManager).
This can be problematic if the driver technically isn't fully up yet.

Move netdev registration to the end of probe, as by this time the
driver data structures and device will be initialized as expected.

However, delaying netdev registration causes a failure in the aRFS flow
where netdev->reg_state == NETREG_REGISTERED condition is checked. It's
not clear why this check was added to begin with, so remove it.
Local testing didn't indicate any issues with this change.

The state bit check in ice_open was put in as a stop-gap measure to
prevent a premature interface up operation. This is no longer needed,
so remove it.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_arfs.c |  6 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 93 +++++++++++------------
 2 files changed, 47 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
index 6560acd76c94..88d98c9e5f91 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
@@ -581,8 +581,7 @@ void ice_free_cpu_rx_rmap(struct ice_vsi *vsi)
 		return;
 
 	netdev = vsi->netdev;
-	if (!netdev || !netdev->rx_cpu_rmap ||
-	    netdev->reg_state != NETREG_REGISTERED)
+	if (!netdev || !netdev->rx_cpu_rmap)
 		return;
 
 	free_irq_cpu_rmap(netdev->rx_cpu_rmap);
@@ -604,8 +603,7 @@ int ice_set_cpu_rx_rmap(struct ice_vsi *vsi)
 
 	pf = vsi->back;
 	netdev = vsi->netdev;
-	if (!pf || !netdev || !vsi->num_q_vectors ||
-	    vsi->netdev->reg_state != NETREG_REGISTERED)
+	if (!pf || !netdev || !vsi->num_q_vectors)
 		return -EINVAL;
 
 	netdev_dbg(netdev, "Setup CPU RMAP: vsi type 0x%x, ifname %s, q_vectors %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f318d7f607e4..a881b4b6bce5 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -140,21 +140,10 @@ static int ice_init_mac_fltr(struct ice_pf *pf)
 
 	perm_addr = vsi->port_info->mac.perm_addr;
 	status = ice_fltr_add_mac_and_broadcast(vsi, perm_addr, ICE_FWD_TO_VSI);
-	if (!status)
-		return 0;
-
-	/* We aren't useful with no MAC filters, so unregister if we
-	 * had an error
-	 */
-	if (vsi->netdev->reg_state == NETREG_REGISTERED) {
-		dev_err(ice_pf_to_dev(pf), "Could not add MAC filters error %s. Unregistering device\n",
-			ice_stat_str(status));
-		unregister_netdev(vsi->netdev);
-		free_netdev(vsi->netdev);
-		vsi->netdev = NULL;
-	}
+	if (status)
+		return -EIO;
 
-	return -EIO;
+	return 0;
 }
 
 /**
@@ -2982,18 +2971,11 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	struct ice_netdev_priv *np;
 	struct net_device *netdev;
 	u8 mac_addr[ETH_ALEN];
-	int err;
-
-	err = ice_devlink_create_port(vsi);
-	if (err)
-		return err;
 
 	netdev = alloc_etherdev_mqs(sizeof(*np), vsi->alloc_txq,
 				    vsi->alloc_rxq);
-	if (!netdev) {
-		err = -ENOMEM;
-		goto err_destroy_devlink_port;
-	}
+	if (!netdev)
+		return -ENOMEM;
 
 	vsi->netdev = netdev;
 	np = netdev_priv(netdev);
@@ -3021,25 +3003,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = ICE_MAX_MTU;
 
-	err = register_netdev(vsi->netdev);
-	if (err)
-		goto err_free_netdev;
-
-	devlink_port_type_eth_set(&vsi->devlink_port, vsi->netdev);
-
-	netif_carrier_off(vsi->netdev);
-
-	/* make sure transmit queues start off as stopped */
-	netif_tx_stop_all_queues(vsi->netdev);
-
 	return 0;
-
-err_free_netdev:
-	free_netdev(vsi->netdev);
-	vsi->netdev = NULL;
-err_destroy_devlink_port:
-	ice_devlink_destroy_port(vsi);
-	return err;
 }
 
 /**
@@ -3237,8 +3201,6 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 	if (vsi) {
 		ice_napi_del(vsi);
 		if (vsi->netdev) {
-			if (vsi->netdev->reg_state == NETREG_REGISTERED)
-				unregister_netdev(vsi->netdev);
 			free_netdev(vsi->netdev);
 			vsi->netdev = NULL;
 		}
@@ -3992,6 +3954,40 @@ static void ice_print_wake_reason(struct ice_pf *pf)
 	dev_info(ice_pf_to_dev(pf), "Wake reason: %s", wake_str);
 }
 
+/**
+ * ice_register_netdev - register netdev and devlink port
+ * @pf: pointer to the PF struct
+ */
+static int ice_register_netdev(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi;
+	int err = 0;
+
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi || !vsi->netdev)
+		return -EIO;
+
+	err = register_netdev(vsi->netdev);
+	if (err)
+		goto err_register_netdev;
+
+	netif_carrier_off(vsi->netdev);
+	netif_tx_stop_all_queues(vsi->netdev);
+	err = ice_devlink_create_port(vsi);
+	if (err)
+		goto err_devlink_create;
+
+	devlink_port_type_eth_set(&vsi->devlink_port, vsi->netdev);
+
+	return 0;
+err_devlink_create:
+	unregister_netdev(vsi->netdev);
+err_register_netdev:
+	free_netdev(vsi->netdev);
+	vsi->netdev = NULL;
+	return err;
+}
+
 /**
  * ice_probe - Device initialization routine
  * @pdev: PCI device information struct
@@ -4272,10 +4268,16 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	pcie_print_link_status(pf->pdev);
 
 probe_done:
+	err = ice_register_netdev(pf);
+	if (err)
+		goto err_netdev_reg;
+
 	/* ready to go, so clear down state bit */
 	clear_bit(__ICE_DOWN, pf->state);
+
 	return 0;
 
+err_netdev_reg:
 err_send_version_unroll:
 	ice_vsi_release_all(pf);
 err_alloc_sw_unroll:
@@ -6654,11 +6656,6 @@ int ice_open(struct net_device *netdev)
 		return -EIO;
 	}
 
-	if (test_bit(__ICE_DOWN, pf->state)) {
-		netdev_err(netdev, "device is not ready yet\n");
-		return -EBUSY;
-	}
-
 	netif_carrier_off(netdev);
 
 	pi = vsi->port_info;
-- 
2.26.2

