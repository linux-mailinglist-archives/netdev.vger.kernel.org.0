Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816653D391D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhGWK2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:28:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7048 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhGWK1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:27:53 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GWRHH0pLyzYf2w;
        Fri, 23 Jul 2021 19:02:35 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 23 Jul 2021 19:08:24 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V6 2/8] PCI: Use cached Device Capabilities 2 Register
Date:   Fri, 23 Jul 2021 19:06:36 +0800
Message-ID: <1627038402-114183-3-git-send-email-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
References: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will make sense to store the pcie_devcap2 value in the pci_dev
structure instead of reading Device Capabilities 2 Register multiple
times. Get the pcie_devcap2 value set_pcie_port_type(), then use
cached pcie_devcap2 in the needed place.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  4 +---
 drivers/pci/pci.c                               |  9 ++++-----
 drivers/pci/probe.c                             | 10 ++++------
 include/linux/pci.h                             |  2 ++
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index dbf9a0e..a8e1e22 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6304,7 +6304,6 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
 		struct pci_dev *pbridge;
 		struct port_info *pi;
 		char name[IFNAMSIZ];
-		u32 devcap2;
 		u16 flags;
 
 		/* If we want to instantiate Virtual Functions, then our
@@ -6314,10 +6313,9 @@ static int cxgb4_iov_configure(struct pci_dev *pdev, int num_vfs)
 		 */
 		pbridge = pdev->bus->self;
 		pcie_capability_read_word(pbridge, PCI_EXP_FLAGS, &flags);
-		pcie_capability_read_dword(pbridge, PCI_EXP_DEVCAP2, &devcap2);
 
 		if ((flags & PCI_EXP_FLAGS_VERS) < 2 ||
-		    !(devcap2 & PCI_EXP_DEVCAP2_ARI)) {
+		    !(pbridge->pcie_devcap2 & PCI_EXP_DEVCAP2_ARI)) {
 			/* Our parent bridge does not support ARI so issue a
 			 * warning and skip instantiating the VFs.  They
 			 * won't be reachable.
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index dc3bfb2..d14c573 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3700,7 +3700,7 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
 {
 	struct pci_bus *bus = dev->bus;
 	struct pci_dev *bridge;
-	u32 cap, ctl2;
+	u32 ctl2;
 
 	if (!pci_is_pcie(dev))
 		return -EINVAL;
@@ -3724,19 +3724,18 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
 	while (bus->parent) {
 		bridge = bus->self;
 
-		pcie_capability_read_dword(bridge, PCI_EXP_DEVCAP2, &cap);
-
 		switch (pci_pcie_type(bridge)) {
 		/* Ensure switch ports support AtomicOp routing */
 		case PCI_EXP_TYPE_UPSTREAM:
 		case PCI_EXP_TYPE_DOWNSTREAM:
-			if (!(cap & PCI_EXP_DEVCAP2_ATOMIC_ROUTE))
+			if (!(bridge->pcie_devcap2 &
+			      PCI_EXP_DEVCAP2_ATOMIC_ROUTE))
 				return -EINVAL;
 			break;
 
 		/* Ensure root port supports all the sizes we care about */
 		case PCI_EXP_TYPE_ROOT_PORT:
-			if ((cap & cap_mask) != cap_mask)
+			if ((bridge->pcie_devcap2 & cap_mask) != cap_mask)
 				return -EINVAL;
 			break;
 		}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cc700f6..c83245b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1500,6 +1500,7 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	pdev->pcie_flags_reg = reg16;
 	pci_read_config_dword(pdev, pos + PCI_EXP_DEVCAP, &pdev->pcie_devcap);
 	pdev->pcie_mpss = pdev->pcie_devcap & PCI_EXP_DEVCAP_PAYLOAD;
+	pci_read_config_dword(pdev, pos + PCI_EXP_DEVCAP2, &pdev->pcie_devcap2);
 
 	parent = pci_upstream_bridge(pdev);
 	if (!parent)
@@ -2116,7 +2117,7 @@ static void pci_configure_ltr(struct pci_dev *dev)
 #ifdef CONFIG_PCIEASPM
 	struct pci_host_bridge *host = pci_find_host_bridge(dev->bus);
 	struct pci_dev *bridge;
-	u32 cap, ctl;
+	u32 ctl;
 
 	if (!pci_is_pcie(dev))
 		return;
@@ -2124,8 +2125,7 @@ static void pci_configure_ltr(struct pci_dev *dev)
 	/* Read L1 PM substate capabilities */
 	dev->l1ss = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_L1SS);
 
-	pcie_capability_read_dword(dev, PCI_EXP_DEVCAP2, &cap);
-	if (!(cap & PCI_EXP_DEVCAP2_LTR))
+	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_LTR))
 		return;
 
 	pcie_capability_read_dword(dev, PCI_EXP_DEVCTL2, &ctl);
@@ -2165,13 +2165,11 @@ static void pci_configure_eetlp_prefix(struct pci_dev *dev)
 #ifdef CONFIG_PCI_PASID
 	struct pci_dev *bridge;
 	int pcie_type;
-	u32 cap;
 
 	if (!pci_is_pcie(dev))
 		return;
 
-	pcie_capability_read_dword(dev, PCI_EXP_DEVCAP2, &cap);
-	if (!(cap & PCI_EXP_DEVCAP2_EE_PREFIX))
+	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_EE_PREFIX))
 		return;
 
 	pcie_type = pci_pcie_type(dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index aee7c85..9aab67f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -341,6 +341,8 @@ struct pci_dev {
 	u8		pin;		/* Interrupt pin this device uses */
 	u16		pcie_flags_reg;	/* Cached PCIe Capabilities Register */
 	u32		pcie_devcap;	/* Cached Device Capabilities Register */
+	u32		pcie_devcap2;	/* Cached Device Capabilities 2
+					   Register */
 	unsigned long	*dma_alias_mask;/* Mask of enabled devfn aliases */
 
 	struct pci_driver *driver;	/* Driver bound to this device */
-- 
2.7.4

