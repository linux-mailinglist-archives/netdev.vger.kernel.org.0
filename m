Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D335C2C0C31
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbgKWNvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:51:54 -0500
Received: from mga14.intel.com ([192.55.52.115]:1467 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbgKWNvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:51:53 -0500
IronPort-SDR: DNV/O+dacxfVXFtBhTypuZZ1qGSirHlmxyayXqlVdzpOKHiMSQ+XWy2S/+nRh5E9+tOJx8om7H
 IqZ1D0cwnhJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981407"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981407"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:51:51 -0800
IronPort-SDR: 6R/arSM1xk9KjzqkScJj1/HlOW0e9tUsc211CLAi5WNWBZT8d3IQDjm9/m5z3LWunuA8ru/N7I
 DU/c5b96Da+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035464"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:51:49 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 01/18] net: iosm: entry point
Date:   Mon, 23 Nov 2020 19:21:06 +0530
Message-Id: <20201123135123.48892-2-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20201123135123.48892-1-m.chetan.kumar@intel.com>
References: <20201123135123.48892-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Register IOSM driver with kernel to manage Intel WWAN PCIe
   device(PCI_VENDOR_ID_INTEL, INTEL_CP_DEVICE_7560_ID).
2) Exposes the EP PCIe device capability to Host PCIe core.
3) Initializes PCIe EP configuration and defines PCIe driver probe, remove
   and power management OPS.
4) Allocate and map(dma) skb memory for data communication from device to
   kernel and vice versa.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 494 ++++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_pcie.h | 205 ++++++++++++++
 2 files changed, 699 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pcie.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pcie.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
new file mode 100644
index 000000000000..9457e889695a
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -0,0 +1,494 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/module.h>
+
+#include "iosm_ipc_imem.h"
+#include "iosm_ipc_pcie.h"
+
+#define DRV_AUTHOR "Intel Corporation <linuxwwan@intel.com>"
+
+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION("IOSM Driver");
+MODULE_LICENSE("GPL v2");
+
+static void ipc_pcie_resources_release(struct iosm_pcie *ipc_pcie)
+{
+	/* Free the MSI resources. */
+	ipc_release_irq(ipc_pcie);
+
+	/* Free mapped doorbell scratchpad bus memory into CPU space. */
+	iounmap(ipc_pcie->scratchpad);
+	ipc_pcie->scratchpad = NULL;
+
+	/* Free mapped IPC_REGS bus memory into CPU space. */
+	iounmap(ipc_pcie->ipc_regs);
+	ipc_pcie->ipc_regs = NULL;
+
+	/* Releases all PCI I/O and memory resources previously reserved by a
+	 * successful call to pci_request_regions.  Call this function only
+	 * after all use of the PCI regions has ceased.
+	 */
+	pci_release_regions(ipc_pcie->pci);
+}
+
+static void ipc_cleanup(struct iosm_pcie *ipc_pcie)
+{
+	struct pci_dev *pci;
+
+	pci = ipc_pcie->pci;
+
+	/* Free the shared memory resources. */
+	ipc_imem_cleanup(ipc_pcie->imem);
+
+	ipc_pcie_resources_release(ipc_pcie);
+
+	/* Signal to the system that the PCI device is not in use. */
+	if (ipc_pcie->pci)
+		pci_disable_device(pci);
+
+	/*dbg cleanup*/
+	ipc_pcie->dev = NULL;
+}
+
+static void ipc_pcie_deinit(struct iosm_pcie *ipc_pcie)
+{
+	if (ipc_pcie) {
+		kfree(ipc_pcie->imem);
+		kfree(ipc_pcie);
+	}
+}
+
+static void iosm_ipc_remove(struct pci_dev *pci)
+{
+	struct iosm_pcie *ipc_pcie = pci_get_drvdata(pci);
+
+	ipc_cleanup(ipc_pcie);
+
+	ipc_pcie_deinit(ipc_pcie);
+}
+
+static int ipc_pcie_resources_request(struct iosm_pcie *ipc_pcie)
+{
+	struct pci_dev *pci = ipc_pcie->pci;
+	u32 cap;
+	u32 ret;
+
+	/* Reserved PCI I/O and memory resources.
+	 * Mark all PCI regions associated with PCI device pci as
+	 * being reserved by owner IOSM_IPC.
+	 */
+	ret = pci_request_regions(pci, "IOSM_IPC");
+	if (ret) {
+		dev_err(ipc_pcie->dev, "failed pci request regions");
+		goto pci_request_region_fail;
+	}
+
+	/* Reserve the doorbell IPC REGS memory resources.
+	 * Remap the memory into CPU space. Arrange for the physical address
+	 * (BAR) to be visible from this driver.
+	 * pci_ioremap_bar() ensures that the memory is marked uncachable.
+	 */
+	ipc_pcie->ipc_regs = pci_ioremap_bar(pci, ipc_pcie->ipc_regs_bar_nr);
+
+	if (!ipc_pcie->ipc_regs) {
+		dev_err(ipc_pcie->dev, "IPC REGS ioremap error");
+		ret = -EBUSY;
+		goto ipc_regs_remap_fail;
+	}
+
+	/* Reserve the MMIO scratchpad memory resources.
+	 * Remap the memory into CPU space. Arrange for the physical address
+	 * (BAR) to be visible from this driver.
+	 * pci_ioremap_bar() ensures that the memory is marked uncachable.
+	 */
+	ipc_pcie->scratchpad =
+		pci_ioremap_bar(pci, ipc_pcie->scratchpad_bar_nr);
+
+	if (!ipc_pcie->scratchpad) {
+		dev_err(ipc_pcie->dev, "doorbell scratchpad ioremap error");
+		ret = -EBUSY;
+		goto scratch_remap_fail;
+	}
+
+	/* Install the irq handler triggered by CP. */
+	ret = ipc_acquire_irq(ipc_pcie);
+	if (ret) {
+		dev_err(ipc_pcie->dev, "acquiring MSI irq failed!");
+		goto irq_acquire_fail;
+	}
+
+	/* Enable bus-mastering for the IOSM IPC device. */
+	pci_set_master(pci);
+
+	/* Enable LTR if possible
+	 * This is needed for L1.2!
+	 */
+	pcie_capability_read_dword(ipc_pcie->pci, PCI_EXP_DEVCAP2, &cap);
+	if (cap & PCI_EXP_DEVCAP2_LTR)
+		pcie_capability_set_word(ipc_pcie->pci, PCI_EXP_DEVCTL2,
+					 PCI_EXP_DEVCTL2_LTR_EN);
+
+	dev_dbg(ipc_pcie->dev, "link between AP and CP is fully on");
+
+	return ret;
+
+irq_acquire_fail:
+	iounmap(ipc_pcie->scratchpad);
+	ipc_pcie->scratchpad = NULL;
+scratch_remap_fail:
+	iounmap(ipc_pcie->ipc_regs);
+	ipc_pcie->ipc_regs = NULL;
+ipc_regs_remap_fail:
+	pci_release_regions(pci);
+pci_request_region_fail:
+	return ret;
+}
+
+bool ipc_pcie_check_aspm_enabled(struct iosm_pcie *ipc_pcie,
+				 struct pci_dev *pdev)
+{
+	u32 enabled = 0;
+	u16 value = 0;
+
+	if (!ipc_pcie || !pdev)
+		return false;
+
+	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &value);
+	enabled = value & PCI_EXP_LNKCTL_ASPMC;
+	dev_dbg(ipc_pcie->dev, "ASPM L1: 0x%04X 0x%03X", pdev->device, value);
+
+	return (enabled == PCI_EXP_LNKCTL_ASPM_L1 ||
+		enabled == PCI_EXP_LNKCTL_ASPMC);
+}
+
+bool ipc_pcie_check_data_link_active(struct iosm_pcie *ipc_pcie)
+{
+	struct pci_dev *parent;
+	u16 link_status = 0;
+
+	if (!ipc_pcie || !ipc_pcie->pci) {
+		dev_dbg(ipc_pcie->dev, "device not found");
+		return false;
+	}
+
+	if (!ipc_pcie->pci->bus || !ipc_pcie->pci->bus->self) {
+		dev_err(ipc_pcie->dev, "root port not found");
+		return false;
+	}
+
+	parent = ipc_pcie->pci->bus->self;
+
+	pcie_capability_read_word(parent, PCI_EXP_LNKSTA, &link_status);
+	dev_dbg(ipc_pcie->dev, "Link status: 0x%04X", link_status);
+
+	return link_status & PCI_EXP_LNKSTA_DLLLA;
+}
+
+static bool ipc_pcie_check_aspm_supported(struct iosm_pcie *ipc_pcie,
+					  struct pci_dev *pdev)
+{
+	u32 support = 0;
+	u32 cap = 0;
+
+	pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &cap);
+	support = u32_get_bits(cap, PCI_EXP_LNKCAP_ASPMS);
+	if (support < PCI_EXP_LNKCTL_ASPM_L1) {
+		dev_dbg(ipc_pcie->dev, "ASPM L1 not supported: 0x%04X",
+			pdev->device);
+		return false;
+	}
+	return true;
+}
+
+void ipc_pcie_config_aspm(struct iosm_pcie *ipc_pcie, struct pci_dev *pdev)
+{
+	bool parent_aspm_enabled, dev_aspm_enabled;
+	struct pci_dev *parent;
+
+	if (!pci_is_pcie(pdev)) {
+		dev_err(ipc_pcie->dev, "not a PCIe device");
+		return;
+	}
+
+	parent = pdev->bus->self;
+
+	/* check if both root port and child supports ASPM L1 */
+	if (!ipc_pcie_check_aspm_supported(ipc_pcie, parent) ||
+	    !ipc_pcie_check_aspm_supported(ipc_pcie, pdev))
+		return;
+
+	parent_aspm_enabled = ipc_pcie_check_aspm_enabled(ipc_pcie, parent);
+	dev_aspm_enabled = ipc_pcie_check_aspm_enabled(ipc_pcie, pdev);
+
+	dev_dbg(ipc_pcie->dev, "ASPM parent: %s device: %s",
+		parent_aspm_enabled ? "Enabled" : "Disabled",
+		dev_aspm_enabled ? "Enabled" : "Disabled");
+}
+
+/* Function initializes PCIe endpoint configuration */
+static void ipc_pcie_config_init(struct iosm_pcie *ipc_pcie)
+{
+	/* BAR0 is used for doorbell */
+	ipc_pcie->ipc_regs_bar_nr = IPC_DOORBELL_BAR0;
+
+	/* update HW configuration */
+	ipc_pcie->scratchpad_bar_nr = IPC_SCRATCHPAD_BAR2;
+	ipc_pcie->doorbell_reg_offset = IPC_DOORBELL_CH_OFFSET;
+	ipc_pcie->doorbell_write = IPC_WRITE_PTR_REG_0;
+	ipc_pcie->doorbell_capture = IPC_CAPTURE_PTR_REG_0;
+}
+
+/* The PCI bus has recognized the IOSM IPC device and invokes
+ * iosm_ipc_probe with the assigned resources. pci_id contains
+ * the identification, which need not be verified.
+ */
+static int iosm_ipc_probe(struct pci_dev *pci,
+			  const struct pci_device_id *pci_id)
+{
+	struct iosm_pcie *ipc_pcie;
+
+	pr_debug("Probing device 0x%X from the vendor 0x%X", pci_id->device,
+		 pci_id->vendor);
+
+	ipc_pcie = kzalloc(sizeof(*ipc_pcie), GFP_KERNEL);
+	if (!ipc_pcie)
+		goto ret_fail;
+
+	/* Initialize ipc dbg component for the PCIe device */
+	ipc_pcie->dev = &pci->dev;
+
+	/* Set the driver specific data. */
+	pci_set_drvdata(pci, ipc_pcie);
+
+	/* Save the address of the PCI device configuration. */
+	ipc_pcie->pci = pci;
+
+	/* Update platform configuration */
+	ipc_pcie_config_init(ipc_pcie);
+
+	/* Initialize the device before it is used. Ask low-level code
+	 * to enable I/O and memory. Wake up the device if it was suspended.
+	 */
+	if (pci_enable_device(pci)) {
+		dev_err(ipc_pcie->dev, "failed to enable the AP PCIe device");
+		/* If enable of PCIe device has failed then calling ipc_cleanup
+		 * will panic the system. More over ipc_cleanup() is required to
+		 * be called after ipc_imem_mount()
+		 */
+		goto pci_enable_fail;
+	}
+
+	ipc_pcie_config_aspm(ipc_pcie, pci);
+	dev_dbg(ipc_pcie->dev, "PCIe device enabled.");
+
+	if (ipc_pcie_resources_request(ipc_pcie))
+		goto resources_req_fail;
+
+	/* Establish the link to the imem layer. */
+	ipc_pcie->imem = ipc_imem_init(ipc_pcie, pci->device,
+				       ipc_pcie->scratchpad, ipc_pcie->dev);
+	if (!ipc_pcie->imem) {
+		dev_err(ipc_pcie->dev, "failed to init imem");
+		goto imem_init_fail;
+	}
+
+	clear_bit(IPC_SUSPENDED, &ipc_pcie->pm_flags);
+
+	return 0;
+
+imem_init_fail:
+	ipc_pcie_resources_release(ipc_pcie);
+resources_req_fail:
+	pci_disable_device(pci);
+pci_enable_fail:
+	ipc_pcie_deinit(ipc_pcie);
+ret_fail:
+	return -EIO;
+}
+
+static const struct pci_device_id iosm_ipc_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, INTEL_CP_DEVICE_7560_ID) },
+	{}
+};
+
+int __maybe_unused iosm_ipc_suspend(struct device *dev)
+{
+	struct iosm_pcie *ipc_pcie;
+	struct pci_dev *pdev;
+	int ret;
+
+	pdev = to_pci_dev(dev);
+
+	ipc_pcie = pci_get_drvdata(pdev);
+
+	/* Execute D3 one time. */
+	if (pdev->current_state != PCI_D0) {
+		dev_dbg(ipc_pcie->dev, "done for PM=%d", pdev->current_state);
+		return 0;
+	}
+
+	/* The HAL shall ask the shared memory layer whether D3 is allowed. */
+	ipc_imem_pm_suspend(ipc_pcie->imem);
+
+	/* Save the PCI configuration space of a device before suspending. */
+	ret = pci_save_state(pdev);
+
+	if (ret) {
+		dev_err(ipc_pcie->dev, "pci_save_state error=%d", ret);
+		return ret;
+	}
+
+	/* Set the power state of a PCI device.
+	 * Transition a device to a new power state, using the device's PCI PM
+	 * registers.
+	 */
+	ret = pci_set_power_state(pdev, PCI_D3cold);
+
+	if (ret) {
+		dev_err(ipc_pcie->dev, "pci_set_power_state error=%d", ret);
+		return ret;
+	}
+
+	set_bit(IPC_SUSPENDED, &ipc_pcie->pm_flags);
+
+	dev_dbg(ipc_pcie->dev, "SUSPEND done");
+	return 0;
+}
+
+int __maybe_unused iosm_ipc_resume(struct device *dev)
+{
+	struct iosm_pcie *ipc_pcie;
+	struct pci_dev *pdev;
+	int ret;
+
+	pdev = to_pci_dev(dev);
+
+	ipc_pcie = pci_get_drvdata(pdev);
+
+	/* Set the power state of a PCI device.
+	 * Transition a device to a new power state, using the device's PCI PM
+	 * registers.
+	 */
+	ret = pci_set_power_state(pdev, PCI_D0);
+
+	if (ret) {
+		dev_err(ipc_pcie->dev, "pci_set_power_state error=%d", ret);
+		return ret;
+	}
+
+	pci_restore_state(pdev);
+
+	clear_bit(IPC_SUSPENDED, &ipc_pcie->pm_flags);
+
+	/* The HAL shall inform the shared memory layer that the device is
+	 * active.
+	 */
+	ipc_imem_pm_resume(ipc_pcie->imem);
+
+	dev_dbg(ipc_pcie->dev, "RESUME done");
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(iosm_ipc_pm, iosm_ipc_suspend, iosm_ipc_resume);
+
+static struct pci_driver iosm_ipc_driver = {
+	.name = KBUILD_MODNAME,
+	.probe = iosm_ipc_probe,
+	.remove = iosm_ipc_remove,
+	.driver = {
+		.pm = &iosm_ipc_pm,
+	},
+	.id_table = iosm_ipc_ids,
+};
+
+module_pci_driver(iosm_ipc_driver);
+
+int ipc_pcie_addr_map(struct iosm_pcie *ipc_pcie, void *mem, size_t size,
+		      dma_addr_t *mapping, int direction)
+{
+	if (!ipc_pcie || !mapping)
+		return -EINVAL;
+
+	if (ipc_pcie->pci) {
+		*mapping = dma_map_single(&ipc_pcie->pci->dev, mem, size,
+					  direction);
+		if (dma_mapping_error(&ipc_pcie->pci->dev, *mapping)) {
+			dev_err(ipc_pcie->dev, "dma mapping failed");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+void ipc_pcie_addr_unmap(struct iosm_pcie *ipc_pcie, size_t size,
+			 dma_addr_t mapping, int direction)
+{
+	if (!ipc_pcie || !mapping)
+		return;
+
+	if (ipc_pcie->pci)
+		dma_unmap_single(&ipc_pcie->pci->dev, mapping, size, direction);
+}
+
+struct sk_buff *ipc_pcie_alloc_local_skb(struct iosm_pcie *ipc_pcie,
+					 gfp_t flags, size_t size)
+{
+	struct sk_buff *skb;
+
+	if (!ipc_pcie || !size) {
+		dev_err(ipc_pcie->dev, "invalid pcie object or size");
+		return NULL;
+	}
+
+	skb = __netdev_alloc_skb(NULL, size, flags);
+	if (!skb)
+		return NULL;
+
+	IPC_CB(skb)->op_type = (u8)UL_DEFAULT;
+	IPC_CB(skb)->mapping = 0;
+
+	return skb;
+}
+
+struct sk_buff *ipc_pcie_alloc_skb(struct iosm_pcie *ipc_pcie, size_t size,
+				   gfp_t flags, dma_addr_t *mapping,
+				   int direction, size_t headroom)
+{
+	struct sk_buff *skb =
+		ipc_pcie_alloc_local_skb(ipc_pcie, flags, size + headroom);
+
+	if (!skb)
+		return NULL;
+
+	if (headroom)
+		skb_reserve(skb, headroom);
+
+	if (ipc_pcie_addr_map(ipc_pcie, skb->data, size, mapping, direction)) {
+		dev_kfree_skb(skb);
+		return NULL;
+	}
+
+	BUILD_BUG_ON(sizeof(*IPC_CB(skb)) > sizeof(skb->cb));
+
+	/* Store the mapping address in skb scratch pad for later usage */
+	IPC_CB(skb)->mapping = *mapping;
+	IPC_CB(skb)->direction = direction;
+	IPC_CB(skb)->len = size;
+
+	return skb;
+}
+
+void ipc_pcie_kfree_skb(struct iosm_pcie *ipc_pcie, struct sk_buff *skb)
+{
+	if (!skb)
+		return;
+
+	ipc_pcie_addr_unmap(ipc_pcie, IPC_CB(skb)->len, IPC_CB(skb)->mapping,
+			    IPC_CB(skb)->direction);
+	IPC_CB(skb)->mapping = 0;
+	dev_kfree_skb(skb);
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.h b/drivers/net/wwan/iosm/iosm_ipc_pcie.h
new file mode 100644
index 000000000000..916c049291cc
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.h
@@ -0,0 +1,205 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_PCIE_H
+#define IOSM_IPC_PCIE_H
+
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/skbuff.h>
+
+#include "iosm_ipc_irq.h"
+
+/* Device ID */
+#define INTEL_CP_DEVICE_7560_ID 0x7560
+
+/* Define for BAR area usage */
+#define IPC_DOORBELL_BAR0 0
+#define IPC_SCRATCHPAD_BAR2 2
+
+/* Defines for DOORBELL registers information */
+#define IPC_DOORBELL_CH_OFFSET BIT(5)
+#define IPC_WRITE_PTR_REG_0 BIT(4)
+#define IPC_CAPTURE_PTR_REG_0 BIT(3)
+#define IPC_SUSPENDED BIT(0)
+
+/* Number of MSI used for IPC */
+#define IPC_MSI_VECTORS 1
+
+/* Total number of Maximum IPC IRQ vectors used for IPC */
+#define IPC_IRQ_VECTORS IPC_MSI_VECTORS
+
+/**
+ * struct iosm_pcie - IPC_PCIE struct.
+ * @pci:			Address of the device description
+ * @dev:			Pointer to generic device structure
+ * @ipc_regs:			Remapped CP doorbell address of the irq register
+ *				set, to fire the doorbell irq.
+ * @scratchpad:			Remapped CP scratchpad address, to send the
+ *				configuration. tuple and the IPC descriptors
+ *				to CP in the ROM phase. The config tuple
+ *				information are saved on the MSI scratchpad.
+ * @imem:			Pointer to imem data struct
+ * @ipc_regs_bar_nr:		BAR number to be used for IPC doorbell
+ * @scratchpad_bar_nr:		BAR number to be used for Scratchpad
+ * @nvec:			number of requested irq vectors
+ * @doorbell_reg_offset:	doorbell_reg_offset
+ * @doorbell_write:		doorbell write register
+ * @doorbell_capture:		doorbell capture resgister
+ * @pm_flags:			flags for the Power Management
+ */
+struct iosm_pcie {
+	struct pci_dev *pci;
+	struct device *dev;
+	void __iomem *ipc_regs;
+	void __iomem *scratchpad;
+	struct iosm_imem *imem;
+	int ipc_regs_bar_nr;
+	int scratchpad_bar_nr;
+	int nvec;
+	u32 doorbell_reg_offset;
+	u32 doorbell_write;
+	u32 doorbell_capture;
+	unsigned long pm_flags;
+};
+
+/**
+ * struct ipc_skb_cb - State definition of the socket buffer which is mapped to
+ *		       the cb field of sbk
+ * @mapping:	Store physical or IOVA mapped address of skb virtual add.
+ * @direction:	DMA direction
+ * @len:	Length of the DMA mapped region
+ * @op_type:    Expected values are defined about enum ipc_ul_usr_op.
+ */
+struct ipc_skb_cb {
+	dma_addr_t mapping;
+	int direction;
+	int len;
+	u8 op_type;
+};
+
+/**
+ * enum ipc_ul_usr_op - Control information to execute the right operation on
+ *			the user interface.
+ * @UL_USR_OP_BLOCKED:	The uplink app was blocked until CP confirms that the
+ *			uplink buffer was consumed triggered by the IRQ.
+ * @UL_MUX_OP_ADB:	In MUX mode the UL ADB shall be addedd to the free list.
+ * @UL_DEFAULT:		SKB in non muxing mode
+ */
+enum ipc_ul_usr_op {
+	UL_USR_OP_BLOCKED,
+	UL_MUX_OP_ADB,
+	UL_DEFAULT,
+};
+
+/**
+ * ipc_pcie_addr_map - Maps the kernel's virtual address to either IOVA
+ *		       address space or Physical address space, the mapping is
+ *		       stored in the skb's cb.
+ * @ipc_pcie:	Pointer to struct iosm_pcie
+ * @mem:	Skb mem containing data
+ * @size:	Data size
+ * @mapping:	Dma mapping address
+ * @direction:	Data direction
+ *
+ * Returns: 0 on success else error code
+ */
+int ipc_pcie_addr_map(struct iosm_pcie *ipc_pcie, void *mem, size_t size,
+		      dma_addr_t *mapping, int direction);
+
+/**
+ * ipc_pcie_addr_unmap - Unmaps the skb memory region from IOVA address space
+ * @ipc_pcie:	Pointer to struct iosm_pcie
+ * @size:	Data size
+ * @mapping:	Dma mapping address
+ * @direction:	Data direction
+ *
+ * Returns: 0 on success else error code
+ */
+void ipc_pcie_addr_unmap(struct iosm_pcie *ipc_pcie, size_t size,
+			 dma_addr_t mapping, int direction);
+
+/**
+ * ipc_pcie_alloc_skb - Allocate an uplink SKB for the given size.
+ *			This also re-calculates the Start and End addresses
+ *			if PCIe Address Range Check (PARC) is supported.
+ * @ipc_pcie:	Pointer to struct iosm_pcie
+ * @size:	Size of the SKB required.
+ * @flags:	Allocation flags
+ * @mapping:	Copies either mapped IOVA add. or converted Phy address
+ * @direction:	DMA data direction
+ * @headroom:	Header data offset
+ * Returns: Pointer to ipc_skb on Success, NULL on failure.
+ */
+struct sk_buff *ipc_pcie_alloc_skb(struct iosm_pcie *ipc_pcie, size_t size,
+				   gfp_t flags, dma_addr_t *mapping,
+				   int direction, size_t headroom);
+
+/**
+ * ipc_pcie_alloc_local_skb - Allocate a local SKB for the given size.
+ * @ipc_pcie:	Pointer to struct iosm_pcie
+ * @flags:	Allocation flags
+ * @size:	Size of the SKB required.
+ *
+ * Returns: Pointer to ipc_skb on Success, NULL on failure.
+ */
+struct sk_buff *ipc_pcie_alloc_local_skb(struct iosm_pcie *ipc_pcie,
+					 gfp_t flags, size_t size);
+
+/**
+ * ipc_pcie_kfree_skb - Free skb allocated by ipc_pcie_alloc_*_skb().
+ *			Using ipc_pcie_kfree_skb() could cause potential
+ *			Kernel panic if used on skb not allocated by
+ *			ipc_util_alloc_skb() function.
+ * @ipc_pcie:	Pointer to struct iosm_pcie
+ * @skb:	Pointer to the skb
+ */
+void ipc_pcie_kfree_skb(struct iosm_pcie *ipc_pcie, struct sk_buff *skb);
+
+/**
+ * ipc_pcie_check_data_link_active - Check Data Link Layer Active
+ * @ipc_pcie:	Pointer to struct iosm_pcie
+ *
+ * Returns: true if active, otherwise false
+ */
+bool ipc_pcie_check_data_link_active(struct iosm_pcie *ipc_pcie);
+
+/**
+ * iosm_ipc_suspend - Callback invoked by pm_runtime_suspend. It decrements
+ *		     the device's usage count then, carry out a suspend,
+ *		     either synchronous or asynchronous.
+ * @dev:	Pointer to struct device
+ *
+ * Returns: 0 on success else error code
+ */
+int iosm_ipc_suspend(struct device *dev);
+
+/**
+ * iosm_ipc_resume - Callback invoked by pm_runtime_resume. It increments
+ *		    the device's usage count then, carry out a suspend,
+ *		    either synchronous or asynchronous.
+ * @dev:	Pointer to struct device
+ *
+ * Returns: 0 on success else error code
+ */
+int iosm_ipc_resume(struct device *dev);
+
+/**
+ * ipc_pcie_check_aspm_enabled - Check if ASPM L1 is already enabled
+ * @ipc_pcie:			 Pointer to struct iosm_pcie
+ * @pdev:	Pointer to struct pci_dev
+ *
+ * Returns: true if ASPM is already enabled else false
+ */
+bool ipc_pcie_check_aspm_enabled(struct iosm_pcie *ipc_pcie,
+				 struct pci_dev *pdev);
+/**
+ * ipc_pcie_config_aspm - Configure ASPM L1
+ * @ipc_pcie:	Pointer to struct iosm_pcie
+ * @pdev:	Pointer to struct pci_dev
+ */
+void ipc_pcie_config_aspm(struct iosm_pcie *ipc_pcie, struct pci_dev *pdev);
+
+#endif
-- 
2.12.3

