Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66773A5757
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 11:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhFMJc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 05:32:26 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6465 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbhFMJcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 05:32:19 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G2q3t0PR8zZgjx;
        Sun, 13 Jun 2021 17:27:22 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 13 Jun 2021 17:30:14 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [RESEND PATCH V3 1/6] PCI: Use cached Device Capabilities Register
Date:   Sun, 13 Jun 2021 17:29:10 +0800
Message-ID: <1623576555-40338-2-git-send-email-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will make sense to store the pcie_devcap value in the pci_dev
structure instead of reading Device Capabilities Register multiple
times. The fisrt place to use pcie_devcap is in set_pcie_port_type(),
get the pcie_devcap value here, then use cached pcie_devcap in the
needed place.

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 drivers/media/pci/cobalt/cobalt-driver.c |  4 ++--
 drivers/pci/pci.c                        |  5 +----
 drivers/pci/pcie/aspm.c                  | 11 ++++-------
 drivers/pci/probe.c                      | 11 +++--------
 drivers/pci/quirks.c                     |  3 +--
 include/linux/pci.h                      |  1 +
 6 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 839503e..04e735f 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -193,11 +193,11 @@ void cobalt_pcie_status_show(struct cobalt *cobalt)
 		return;
 
 	/* Device */
-	pcie_capability_read_dword(pci_dev, PCI_EXP_DEVCAP, &capa);
 	pcie_capability_read_word(pci_dev, PCI_EXP_DEVCTL, &ctrl);
 	pcie_capability_read_word(pci_dev, PCI_EXP_DEVSTA, &stat);
 	cobalt_info("PCIe device capability 0x%08x: Max payload %d\n",
-		    capa, get_payload_size(capa & PCI_EXP_DEVCAP_PAYLOAD));
+		    capa,
+		    get_payload_size(pci_dev->pcie_devcap & PCI_EXP_DEVCAP_PAYLOAD));
 	cobalt_info("PCIe device control 0x%04x: Max payload %d. Max read request %d\n",
 		    ctrl,
 		    get_payload_size((ctrl & PCI_EXP_DEVCTL_PAYLOAD) >> 5),
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b717680..68ccd77 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4620,13 +4620,10 @@ EXPORT_SYMBOL(pci_wait_for_pending_transaction);
  */
 bool pcie_has_flr(struct pci_dev *dev)
 {
-	u32 cap;
-
 	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
 		return false;
 
-	pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
-	return cap & PCI_EXP_DEVCAP_FLR;
+	return dev->pcie_devcap & PCI_EXP_DEVCAP_FLR;
 }
 EXPORT_SYMBOL_GPL(pcie_has_flr);
 
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index ac0557a..d637564 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -660,7 +660,7 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 
 	/* Get and check endpoint acceptable latencies */
 	list_for_each_entry(child, &linkbus->devices, bus_list) {
-		u32 reg32, encoding;
+		u32 encoding;
 		struct aspm_latency *acceptable =
 			&link->acceptable[PCI_FUNC(child->devfn)];
 
@@ -668,12 +668,11 @@ static void pcie_aspm_cap_init(struct pcie_link_state *link, int blacklist)
 		    pci_pcie_type(child) != PCI_EXP_TYPE_LEG_END)
 			continue;
 
-		pcie_capability_read_dword(child, PCI_EXP_DEVCAP, &reg32);
 		/* Calculate endpoint L0s acceptable latency */
-		encoding = (reg32 & PCI_EXP_DEVCAP_L0S) >> 6;
+		encoding = (child->pcie_devcap & PCI_EXP_DEVCAP_L0S) >> 6;
 		acceptable->l0s = calc_l0s_acceptable(encoding);
 		/* Calculate endpoint L1 acceptable latency */
-		encoding = (reg32 & PCI_EXP_DEVCAP_L1) >> 9;
+		encoding = (child->pcie_devcap & PCI_EXP_DEVCAP_L1) >> 9;
 		acceptable->l1 = calc_l1_acceptable(encoding);
 
 		pcie_aspm_check_latency(child);
@@ -808,7 +807,6 @@ static void free_link_state(struct pcie_link_state *link)
 static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 {
 	struct pci_dev *child;
-	u32 reg32;
 
 	/*
 	 * Some functions in a slot might not all be PCIe functions,
@@ -831,8 +829,7 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
 		 * RBER bit to determine if a function is 1.1 version device
 		 */
-		pcie_capability_read_dword(child, PCI_EXP_DEVCAP, &reg32);
-		if (!(reg32 & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
+		if (!(child->pcie_devcap & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
 			pci_info(child, "disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'\n");
 			return -EINVAL;
 		}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3a62d09..7963ab2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1497,8 +1497,8 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	pdev->pcie_cap = pos;
 	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
 	pdev->pcie_flags_reg = reg16;
-	pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
-	pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
+	pci_read_config_dword(pdev, pos + PCI_EXP_DEVCAP, &pdev->pcie_devcap);
+	pdev->pcie_mpss = pdev->pcie_devcap & PCI_EXP_DEVCAP_PAYLOAD;
 
 	parent = pci_upstream_bridge(pdev);
 	if (!parent)
@@ -2008,18 +2008,13 @@ static void pci_configure_mps(struct pci_dev *dev)
 int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 {
 	struct pci_host_bridge *host;
-	u32 cap;
 	u16 ctl;
 	int ret;
 
 	if (!pci_is_pcie(dev))
 		return 0;
 
-	ret = pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
-	if (ret)
-		return 0;
-
-	if (!(cap & PCI_EXP_DEVCAP_EXT_TAG))
+	if (!(dev->pcie_devcap & PCI_EXP_DEVCAP_EXT_TAG))
 		return 0;
 
 	ret = pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &ctl);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index dcb229d..b89b438 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5073,8 +5073,7 @@ static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
 		pdev->pcie_cap = pos;
 		pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
 		pdev->pcie_flags_reg = reg16;
-		pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
-		pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
+		pdev->pcie_mpss = pdev->pcie_devcap & PCI_EXP_DEVCAP_PAYLOAD;
 
 		pdev->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
 		if (pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &status) !=
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c20211e..555a3ac 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -340,6 +340,7 @@ struct pci_dev {
 	u8		rom_base_reg;	/* Config register controlling ROM */
 	u8		pin;		/* Interrupt pin this device uses */
 	u16		pcie_flags_reg;	/* Cached PCIe Capabilities Register */
+	u32		pcie_devcap;	/* Cached Device Capabilities Register */
 	unsigned long	*dma_alias_mask;/* Mask of enabled devfn aliases */
 
 	struct pci_driver *driver;	/* Driver bound to this device */
-- 
2.7.4

