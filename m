Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0B114E5D3
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgA3W7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:51511 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbgA3W7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187802"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:22 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 09/15] ice: enable initial devlink support
Date:   Thu, 30 Jan 2020 14:59:04 -0800
Message-Id: <20200130225913.1671982-10-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Begin implementing support for the devlink interface with the ice
driver. Use devlinkm_alloc to allocate the devlink memory. The PF
private data structure is now allocated as part of the devlink instead
of as a standalone allocation.

The ice hardware is a multi-function PCIe device. Thus, each physical
function will get its own devlink instance. This means that each
function will be treated independently, with its own parameters and
configuration. This is done because the ice driver loads a separate
instance for each function.

That means that this implementation does not enable devlink to manage
device-wide resources or configuration, as each physical function will
be treated independently. This is done for simplicity, as managing
a devlink instance across multiple driver instances would significantly
increase the complexity for minimal gain.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/Kconfig           |  1 +
 drivers/net/ethernet/intel/ice/Makefile      |  1 +
 drivers/net/ethernet/intel/ice/ice.h         |  4 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 88 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h | 14 ++++
 drivers/net/ethernet/intel/ice/ice_main.c    | 26 +++++-
 6 files changed, 132 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_devlink.h

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 154e2e818ec6..ad34e4335df2 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -294,6 +294,7 @@ config ICE
 	tristate "Intel(R) Ethernet Connection E800 Series Support"
 	default n
 	depends on PCI_MSI
+	select NET_DEVLINK
 	---help---
 	  This driver supports Intel(R) Ethernet Connection E800 Series of
 	  devices.  For more information on how to identify your adapter, go
diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 59544b0fc086..e2502ff3229d 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -19,6 +19,7 @@ ice-y := ice_main.o	\
 	 ice_txrx.o	\
 	 ice_flex_pipe.o \
 	 ice_flow.o	\
+	 ice_devlink.o \
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index cb10abb14e11..a195135f840f 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -36,6 +36,7 @@
 #include <linux/avf/virtchnl.h>
 #include <net/ipv6.h>
 #include <net/xdp_sock.h>
+#include <net/devlink.h>
 #include "ice_devids.h"
 #include "ice_type.h"
 #include "ice_txrx.h"
@@ -346,6 +347,9 @@ enum ice_pf_flags {
 struct ice_pf {
 	struct pci_dev *pdev;
 
+	/* devlink port data */
+	struct devlink_port devlink_port;
+
 	/* OS reserved IRQ details */
 	struct msix_entry *msix_entries;
 	struct ice_res_tracker *irq_tracker;
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
new file mode 100644
index 000000000000..0b0f936122de
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Intel Corporation. */
+
+#include "ice.h"
+#include "ice_devlink.h"
+
+const struct devlink_ops ice_devlink_ops = {
+};
+
+/**
+ * ice_devlink_register - Register devlink interface for this PF
+ * @pf: the PF to register the devlink for.
+ *
+ * Register the devlink instance associated with this physical function.
+ *
+ * @returns zero on success or an error code on failure.
+ */
+int ice_devlink_register(struct ice_pf *pf)
+{
+	struct devlink *devlink = priv_to_devlink(pf);
+	struct device *dev = ice_pf_to_dev(pf);
+	int err;
+
+	err = devlink_register(devlink, dev);
+	if (err) {
+		dev_err(dev, "devlink registration failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_devlink_unregister - Unregister devlink resources for this pf.
+ * @pf: the PF structure to cleanup
+ *
+ * Releases resources used by devlink and cleans up associated memory.
+ */
+void ice_devlink_unregister(struct ice_pf *pf)
+{
+	devlink_unregister(priv_to_devlink(pf));
+}
+
+/**
+ * ice_devlink_create_port - Create a devlink port for this PF
+ * @pf: the PF to create a port for
+ *
+ * Create and register a devlink_port for this PF. Note that although each
+ * physical function connected to a separate devlink instance, the port will
+ * still be numbered according to the physical function id.
+ *
+ * @returns zero on success or an error code on failure.
+ */
+int ice_devlink_create_port(struct ice_pf *pf)
+{
+	struct devlink *devlink = priv_to_devlink(pf);
+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
+	struct device *dev = ice_pf_to_dev(pf);
+	int err;
+
+	if (!vsi) {
+		dev_warn(dev, "%s: unable to find main VSI\n", __func__);
+		return -EIO;
+	}
+
+	devlink_port_attrs_set(&pf->devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
+			       pf->hw.pf_id, false, 0, NULL, 0);
+	err = devlink_port_register(devlink, &pf->devlink_port, pf->hw.pf_id);
+	if (err) {
+		dev_err(dev, "devlink_port_register failed: %d\n", err);
+		return err;
+	}
+	devlink_port_type_eth_set(&pf->devlink_port, vsi->netdev);
+
+	return 0;
+}
+
+/**
+ * ice_devlink_destroy_port - Destroy the devlink_port for this PF
+ * @pf: the PF to cleanup
+ *
+ * Unregisters the devlink_port structure associated with this PF.
+ */
+void ice_devlink_destroy_port(struct ice_pf *pf)
+{
+	devlink_port_type_clear(&pf->devlink_port);
+	devlink_port_unregister(&pf->devlink_port);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.h b/drivers/net/ethernet/intel/ice/ice_devlink.h
new file mode 100644
index 000000000000..5e34f6e1b57e
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_DEVLINK_H_
+#define _ICE_DEVLINK_H_
+
+extern const struct devlink_ops ice_devlink_ops;
+
+int ice_devlink_register(struct ice_pf *pf);
+void ice_devlink_unregister(struct ice_pf *pf);
+int ice_devlink_create_port(struct ice_pf *pf);
+void ice_devlink_destroy_port(struct ice_pf *pf);
+
+#endif /* _ICE_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5ae671609f98..a1aa4a1b6870 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -10,6 +10,7 @@
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 #include "ice_dcb_nl.h"
+#include "ice_devlink.h"
 
 #define DRV_VERSION_MAJOR 0
 #define DRV_VERSION_MINOR 8
@@ -2553,6 +2554,11 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 		status = -ENODEV;
 		goto unroll_vsi_setup;
 	}
+
+	status = ice_devlink_create_port(pf);
+	if (status)
+		goto unroll_vsi_setup;
+
 	/* netdev has to be configured before setting frame size */
 	ice_vsi_cfg_frame_size(vsi);
 
@@ -2582,6 +2588,8 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 		}
 	}
 
+	ice_devlink_destroy_port(pf);
+
 unroll_vsi_setup:
 	if (vsi) {
 		ice_vsi_free_q_vectors(vsi);
@@ -3180,6 +3188,7 @@ static int
 ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 {
 	struct device *dev = &pdev->dev;
+	struct devlink *devlink;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
 	int err;
@@ -3195,9 +3204,11 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		return err;
 	}
 
-	pf = devm_kzalloc(dev, sizeof(*pf), GFP_KERNEL);
-	if (!pf)
+	devlink = devlinkm_alloc(dev, &ice_devlink_ops, sizeof(*pf));
+	if (!devlink) {
+		dev_err(dev, "devlink allocation failed\n");
 		return -ENOMEM;
+	}
 
 	/* set up for high or low DMA */
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
@@ -3211,6 +3222,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	pci_enable_pcie_error_reporting(pdev);
 	pci_set_master(pdev);
 
+	pf = devlink_priv(devlink);
 	pf->pdev = pdev;
 	pci_set_drvdata(pdev, pf);
 	set_bit(__ICE_DOWN, pf->state);
@@ -3233,6 +3245,12 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	pf->msg_enable = netif_msg_init(debug, ICE_DFLT_NETIF_M);
 
+	err = ice_devlink_register(pf);
+	if (err) {
+		dev_err(dev, "ice_devlink_register failed: %d\n", err);
+		goto err_exit_unroll;
+	}
+
 #ifndef CONFIG_DYNAMIC_DEBUG
 	if (debug < -1)
 		hw->debug_mask = debug;
@@ -3384,6 +3402,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	ice_deinit_pf(pf);
 	ice_deinit_hw(hw);
 err_exit_unroll:
+	ice_devlink_unregister(pf);
 	pci_disable_pcie_error_reporting(pdev);
 	return err;
 }
@@ -3411,6 +3430,7 @@ static void ice_remove(struct pci_dev *pdev)
 
 	if (test_bit(ICE_FLAG_SRIOV_ENA, pf->flags))
 		ice_free_vfs(pf);
+	ice_devlink_destroy_port(pf);
 	ice_vsi_release_all(pf);
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
@@ -3420,6 +3440,8 @@ static void ice_remove(struct pci_dev *pdev)
 	}
 	ice_deinit_pf(pf);
 	ice_deinit_hw(&pf->hw);
+	ice_devlink_unregister(pf);
+
 	/* Issue a PFR as part of the prescribed driver unload flow.  Do not
 	 * do it via ice_schedule_reset() since there is no need to rebuild
 	 * and the service task is already stopped.
-- 
2.25.0.rc1

