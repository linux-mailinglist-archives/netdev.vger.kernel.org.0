Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EE82322A1
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgG2QYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:42161 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbgG2QYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:15 -0400
IronPort-SDR: DQZVszpa688/ebaxkmg5BI6/7iUYd1Y/rnaWqTlp7yMuJcDhqDauRcUgWWjW7ZXnSXBoBMzBsS
 M/6WtrLaswlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982326"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982326"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:13 -0700
IronPort-SDR: t0ee1Lgwiepwr2wmgB7+e1A1hc64EERN79mMA3CQKsin9+5czrOKY+R2F6l/5tOfjNqHAMa77U
 F7IEB/ebUALA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087559"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Nick Nunley <nicholas.d.nunley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 04/15] ice: restore VF MSI-X state during PCI reset
Date:   Wed, 29 Jul 2020 09:23:54 -0700
Message-Id: <20200729162405.1596435-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Nunley <nicholas.d.nunley@intel.com>

During a PCI FLR the MSI-X Enable flag in the VF PCI MSI-X capability
register will be cleared. This can lead to issues when a VF is
assigned to a VM because in these cases the VF driver receives no
indication of the PF PCI error/reset and additionally it is incapable
of restoring the cleared flag in the hypervisor configuration space
without fully reinitializing the driver interrupt functionality.

Since the VF driver is unable to easily resolve this condition on its own,
restore the VF MSI-X flag during the PF PCI reset handling.

Signed-off-by: Nick Nunley <nicholas.d.nunley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 ++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 30 +++++++++++++++++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  2 ++
 3 files changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e441cafaf23b..9b9e30a7d690 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4623,6 +4623,8 @@ static void ice_pci_err_resume(struct pci_dev *pdev)
 		return;
 	}
 
+	ice_restore_all_vfs_msi_state(pdev);
+
 	ice_do_reset(pf, ICE_RESET_PFR);
 	ice_service_task_restart(pf);
 	mod_timer(&pf->serv_tmr, round_jiffies(jiffies + pf->serv_tmr_period));
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 9df5ceb26ab9..7061730f0f37 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -4071,3 +4071,33 @@ void ice_print_vfs_mdd_events(struct ice_pf *pf)
 		}
 	}
 }
+
+/**
+ * ice_restore_all_vfs_msi_state - restore VF MSI state after PF FLR
+ * @pdev: pointer to a pci_dev structure
+ *
+ * Called when recovering from a PF FLR to restore interrupt capability to
+ * the VFs.
+ */
+void ice_restore_all_vfs_msi_state(struct pci_dev *pdev)
+{
+	struct pci_dev *vfdev;
+	u16 vf_id;
+	int pos;
+
+	if (!pci_num_vf(pdev))
+		return;
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_SRIOV);
+	if (pos) {
+		pci_read_config_word(pdev, pos + PCI_SRIOV_VF_DID,
+				     &vf_id);
+		vfdev = pci_get_device(pdev->vendor, vf_id, NULL);
+		while (vfdev) {
+			if (vfdev->is_virtfn && vfdev->physfn == pdev)
+				pci_restore_msi_state(vfdev);
+			vfdev = pci_get_device(pdev->vendor, vf_id,
+					       vfdev);
+		}
+	}
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 67aa9110fdd1..049e0b583383 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -114,6 +114,7 @@ void ice_vc_notify_link_state(struct ice_pf *pf);
 void ice_vc_notify_reset(struct ice_pf *pf);
 bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr);
 bool ice_reset_vf(struct ice_vf *vf, bool is_vflr);
+void ice_restore_all_vfs_msi_state(struct pci_dev *pdev);
 
 int
 ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
@@ -146,6 +147,7 @@ void ice_print_vf_rx_mdd_event(struct ice_vf *vf);
 #define ice_vf_lan_overflow_event(pf, event) do {} while (0)
 #define ice_print_vfs_mdd_events(pf) do {} while (0)
 #define ice_print_vf_rx_mdd_event(vf) do {} while (0)
+#define ice_restore_all_vfs_msi_state(pdev) do {} while (0)
 
 static inline bool
 ice_reset_all_vfs(struct ice_pf __always_unused *pf,
-- 
2.26.2

