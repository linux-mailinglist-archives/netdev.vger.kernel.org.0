Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD711DE03F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgEVG4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:18662 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728322AbgEVG4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:13 -0400
IronPort-SDR: Icim8NY9pHraF1srYq2XSLPQQAZW0ytqgxCLs3mC8XL0yCOF9TZE0uctuXuXt1ivgEvvym0uOX
 egB2njAK0K5Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:10 -0700
IronPort-SDR: zKAE8V7fg/lNK33pv6XI677NEcMpIqgpfmnMErq4ETNCgM0lWAcDw6cRPNZQXc/2I1OYsDzLpt
 VsC5Shztluuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017754"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:09 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/17] ice: Fix probe/open race condition
Date:   Thu, 21 May 2020 23:55:57 -0700
Message-Id: <20200522065607.1680050-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

As soon as the driver registers the PF netdev, userspace utilities
like NetworkManager try to bring up the associated interface. When
this happens, the driver may not have finished initializing fully,
resulting in a bunch of errors in the interface up flow.

The driver already has a mechanism to indicate if it's not up yet;
by setting the __ICE_DOWN bit in pf->state, but this bit gets
cleared too early in the current flow. So clear this bit only when
the driver is fully up. Also check for the same bit in the ice_open
flow, and return -EBUSY if the bit is set.

Also in ice_open, replace references of vsi->back with a local
variable.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 24 +++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8c792ecc6550..de81d9049b97 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2137,10 +2137,8 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 	}
 	ret = IRQ_HANDLED;
 
-	if (!test_bit(__ICE_DOWN, pf->state)) {
-		ice_service_task_schedule(pf);
-		ice_irq_dynamic_ena(hw, NULL, NULL);
-	}
+	ice_service_task_schedule(pf);
+	ice_irq_dynamic_ena(hw, NULL, NULL);
 
 	return ret;
 }
@@ -3312,9 +3310,6 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_init_interrupt_unroll;
 	}
 
-	/* Driver is mostly up */
-	clear_bit(__ICE_DOWN, pf->state);
-
 	/* In case of MSIX we are going to setup the misc vector right here
 	 * to handle admin queue events etc. In case of legacy and MSI
 	 * the misc functionality and queue processing is combined in
@@ -3370,9 +3365,9 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	ice_verify_cacheline_size(pf);
 
-	/* If no DDP driven features have to be setup, return here */
+	/* If no DDP driven features have to be setup, we are done with probe */
 	if (ice_is_safe_mode(pf))
-		return 0;
+		goto probe_done;
 
 	/* initialize DDP driven features */
 
@@ -3387,6 +3382,9 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	/* print PCI link speed and width */
 	pcie_print_link_status(pf->pdev);
 
+probe_done:
+	/* ready to go, so clear down state bit */
+	clear_bit(__ICE_DOWN, pf->state);
 	return 0;
 
 err_alloc_sw_unroll:
@@ -5261,14 +5259,20 @@ int ice_open(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
 	struct ice_port_info *pi;
 	int err;
 
-	if (test_bit(__ICE_NEEDS_RESTART, vsi->back->state)) {
+	if (test_bit(__ICE_NEEDS_RESTART, pf->state)) {
 		netdev_err(netdev, "driver needs to be unloaded and reloaded\n");
 		return -EIO;
 	}
 
+	if (test_bit(__ICE_DOWN, pf->state)) {
+		netdev_err(netdev, "device is not ready yet\n");
+		return -EBUSY;
+	}
+
 	netif_carrier_off(netdev);
 
 	pi = vsi->port_info;
-- 
2.26.2

