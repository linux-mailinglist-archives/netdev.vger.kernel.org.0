Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E179F18DEA5
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 09:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgCUIKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 04:10:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:33281 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbgCUIKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 04:10:34 -0400
IronPort-SDR: 2ZgrwbmycilVKmpQXt/W0uhSN1u4QZIXysGyVICYDPO90JXKvWLXtd/CPdJa4ePAykdfFsw0m5
 8pEix/+4wFPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 01:10:31 -0700
IronPort-SDR: w/4aVR9cnsSnTMyQN5fEtiodKjRF22J8MSlB0IdehEqhVVjE7quIdtvtxEUHo8wlPUssfCZ6Aw
 6rOrW1zZQoWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,287,1580803200"; 
   d="scan'208";a="234737965"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2020 01:10:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 6/9] ice: enable initial devlink support
Date:   Sat, 21 Mar 2020 01:10:25 -0700
Message-Id: <20200321081028.2763550-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
References: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Begin implementing support for the devlink interface with the ice
driver.

The pf structure is currently memory managed through devres, via
a devm_alloc. To mimic this behavior, after allocating the devlink
pointer, use devm_add_action to add a teardown action for releasing the
devlink memory on exit.

The ice hardware is a multi-function PCIe device. Thus, each physical
function will get its own devlink instance. This means that each
function will be treated independently, with its own parameters and
configuration. This is done because the ice driver loads a separate
instance for each function.

Due to this, the implementation does not enable devlink to manage
device-wide resources or configuration, as each physical function will
be treated independently. This is done for simplicity, as managing
a devlink instance across multiple driver instances would significantly
increase the complexity for minimal gain.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/Kconfig           |   1 +
 drivers/net/ethernet/intel/ice/Makefile      |   1 +
 drivers/net/ethernet/intel/ice/ice.h         |   4 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 117 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.h |  14 +++
 drivers/net/ethernet/intel/ice/ice_main.c    |  33 +++++-
 6 files changed, 166 insertions(+), 4 deletions(-)
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
index 59544b0fc086..29c6c6743450 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -19,6 +19,7 @@ ice-y := ice_main.o	\
 	 ice_txrx.o	\
 	 ice_flex_pipe.o \
 	 ice_flow.o	\
+	 ice_devlink.o	\
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index ce73a6a96aac..8ce3afcfeca0 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -34,6 +34,7 @@
 #include <linux/ctype.h>
 #include <linux/bpf.h>
 #include <linux/avf/virtchnl.h>
+#include <net/devlink.h>
 #include <net/ipv6.h>
 #include <net/xdp_sock.h>
 #include "ice_devids.h"
@@ -347,6 +348,9 @@ enum ice_pf_flags {
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
index 000000000000..cedd9d02299e
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Intel Corporation. */
+
+#include "ice.h"
+#include "ice_devlink.h"
+
+static const struct devlink_ops ice_devlink_ops = {
+};
+
+static void ice_devlink_free(void *devlink_ptr)
+{
+	devlink_free((struct devlink *)devlink_ptr);
+}
+
+/**
+ * ice_allocate_pf - Allocate devlink and return PF structure pointer
+ * @dev: the device to allocate for
+ *
+ * Allocate a devlink instance for this device and return the private area as
+ * the PF structure. The devlink memory is kept track of through devres by
+ * adding an action to remove it when unwinding.
+ */
+struct ice_pf *ice_allocate_pf(struct device *dev)
+{
+	struct devlink *devlink;
+
+	devlink = devlink_alloc(&ice_devlink_ops, sizeof(struct ice_pf));
+	if (!devlink)
+		return NULL;
+
+	/* Add an action to teardown the devlink when unwinding the driver */
+	if (devm_add_action(dev, ice_devlink_free, devlink)) {
+		devlink_free(devlink);
+		return NULL;
+	}
+
+	return devlink_priv(devlink);
+}
+
+/**
+ * ice_devlink_register - Register devlink interface for this PF
+ * @pf: the PF to register the devlink for.
+ *
+ * Register the devlink instance associated with this physical function.
+ *
+ * Return: zero on success or an error code on failure.
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
+ * ice_devlink_unregister - Unregister devlink resources for this PF.
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
+ * physical function is connected to a separate devlink instance, the port
+ * will still be numbered according to the physical function id.
+ *
+ * Return: zero on success or an error code on failure.
+ */
+int ice_devlink_create_port(struct ice_pf *pf)
+{
+	struct devlink *devlink = priv_to_devlink(pf);
+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
+	struct device *dev = ice_pf_to_dev(pf);
+	int err;
+
+	if (!vsi) {
+		dev_err(dev, "%s: unable to find main VSI\n", __func__);
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
index 000000000000..f94dc93c24c5
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_DEVLINK_H_
+#define _ICE_DEVLINK_H_
+
+struct ice_pf *ice_allocate_pf(struct device *dev);
+
+int ice_devlink_register(struct ice_pf *pf);
+void ice_devlink_unregister(struct ice_pf *pf);
+int ice_devlink_create_port(struct ice_pf *pf);
+void ice_devlink_destroy_port(struct ice_pf *pf);
+
+#endif /* _ICE_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 89c090d32bb2..359ff8544773 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -10,6 +10,7 @@
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 #include "ice_dcb_nl.h"
+#include "ice_devlink.h"
 
 #define DRV_VERSION_MAJOR 0
 #define DRV_VERSION_MINOR 8
@@ -2371,10 +2372,16 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	u8 mac_addr[ETH_ALEN];
 	int err;
 
+	err = ice_devlink_create_port(pf);
+	if (err)
+		return err;
+
 	netdev = alloc_etherdev_mqs(sizeof(*np), vsi->alloc_txq,
 				    vsi->alloc_rxq);
-	if (!netdev)
-		return -ENOMEM;
+	if (!netdev) {
+		err = -ENOMEM;
+		goto err_destroy_devlink_port;
+	}
 
 	vsi->netdev = netdev;
 	np = netdev_priv(netdev);
@@ -2404,7 +2411,9 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 
 	err = register_netdev(vsi->netdev);
 	if (err)
-		return err;
+		goto err_destroy_devlink_port;
+
+	devlink_port_type_eth_set(&pf->devlink_port, vsi->netdev);
 
 	netif_carrier_off(vsi->netdev);
 
@@ -2412,6 +2421,11 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	netif_tx_stop_all_queues(vsi->netdev);
 
 	return 0;
+
+err_destroy_devlink_port:
+	ice_devlink_destroy_port(pf);
+
+	return err;
 }
 
 /**
@@ -3184,7 +3198,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		return err;
 	}
 
-	pf = devm_kzalloc(dev, sizeof(*pf), GFP_KERNEL);
+	pf = ice_allocate_pf(dev);
 	if (!pf)
 		return -ENOMEM;
 
@@ -3222,6 +3236,12 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
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
@@ -3354,6 +3374,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	return 0;
 
 err_alloc_sw_unroll:
+	ice_devlink_destroy_port(pf);
 	set_bit(__ICE_SERVICE_DIS, pf->state);
 	set_bit(__ICE_DOWN, pf->state);
 	devm_kfree(dev, pf->first_sw);
@@ -3366,6 +3387,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	ice_deinit_pf(pf);
 	ice_deinit_hw(hw);
 err_exit_unroll:
+	ice_devlink_unregister(pf);
 	pci_disable_pcie_error_reporting(pdev);
 	return err;
 }
@@ -3396,6 +3418,7 @@ static void ice_remove(struct pci_dev *pdev)
 	set_bit(__ICE_DOWN, pf->state);
 	ice_service_task_stop(pf);
 
+	ice_devlink_destroy_port(pf);
 	ice_vsi_release_all(pf);
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
@@ -3405,6 +3428,8 @@ static void ice_remove(struct pci_dev *pdev)
 	}
 	ice_deinit_pf(pf);
 	ice_deinit_hw(&pf->hw);
+	ice_devlink_unregister(pf);
+
 	/* Issue a PFR as part of the prescribed driver unload flow.  Do not
 	 * do it via ice_schedule_reset() since there is no need to rebuild
 	 * and the service task is already stopped.
-- 
2.25.1

