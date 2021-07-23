Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C049D3D3924
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbhGWK2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:28:09 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12291 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbhGWK1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:27:53 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GWRJg1TrWz7xKp;
        Fri, 23 Jul 2021 19:03:47 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 23 Jul 2021 19:08:25 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V6 7/8] PCI: Add "pci=disable_10bit_tag=" parameter for peer-to-peer support
Date:   Fri, 23 Jul 2021 19:06:41 +0800
Message-ID: <1627038402-114183-8-git-send-email-liudongdong3@huawei.com>
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

PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
sending Requests to other Endpoints (as opposed to host memory), the
Endpoint must not send 10-Bit Tag Requests to another given Endpoint
unless an implementation-specific mechanism determines that the Endpoint
supports 10-Bit Tag Completer capability. Add "pci=disable_10bit_tag="
parameter to disable 10-Bit Tag Requester if the peer device does not
support the 10-Bit Tag Completer. This will make P2P traffic safe.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  7 ++++
 drivers/pci/pci.c                               | 56 +++++++++++++++++++++++++
 drivers/pci/pci.h                               |  1 +
 drivers/pci/pcie/portdrv_pci.c                  | 13 +++---
 drivers/pci/probe.c                             |  9 ++--
 5 files changed, 78 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index bdb2200..c2c4585 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4019,6 +4019,13 @@
 				bridges without forcing it upstream. Note:
 				this removes isolation between devices and
 				may put more devices in an IOMMU group.
+		disable_10bit_tag=<pci_dev>[; ...]
+				  Specify one or more PCI devices (in the format
+				  specified above) separated by semicolons.
+				  Disable 10-Bit Tag Requester if the peer
+				  device does not support the 10-Bit Tag
+				  Completer.This will make P2P traffic safe.
+
 		force_floating	[S390] Force usage of floating interrupts.
 		nomio		[S390] Do not use MIO instructions.
 		norid		[S390] ignore the RID field and force use of
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d14c573..8494e4f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6568,6 +6568,59 @@ int pci_bus_find_domain_nr(struct pci_bus *bus, struct device *parent)
 }
 #endif
 
+static const char *disable_10bit_tag_param;
+
+void pci_disable_10bit_tag(struct pci_dev *dev)
+{
+	int ret = 0;
+	const char *p;
+#ifdef CONFIG_PCI_IOV
+	struct pci_sriov *iov;
+#endif
+
+	if (!disable_10bit_tag_param)
+		return;
+
+	p = disable_10bit_tag_param;
+	while (*p) {
+		ret = pci_dev_str_match(dev, p, &p);
+		if (ret < 0) {
+			pr_info_once("PCI: Can't parse disable_10bit_tag parameter: %s\n",
+				     disable_10bit_tag_param);
+
+			break;
+		} else if (ret == 1) {
+			/* Found a match */
+			break;
+		}
+
+		if (*p != ';' && *p != ',') {
+			/* End of param or invalid format */
+			break;
+		}
+		p++;
+	}
+
+	if (ret != 1)
+		return;
+
+#ifdef CONFIG_PCI_IOV
+	if (dev->is_virtfn) {
+		iov = dev->physfn->sriov;
+		iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
+		pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL,
+				      iov->ctrl);
+		pci_info(dev, "disabled PF SRIOV 10-Bit Tag Requester\n");
+		return;
+#endif
+	}
+
+	pcie_capability_clear_word(dev, PCI_EXP_DEVCTL2,
+				   PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+
+	pci_info(dev, "disabled 10-Bit Tag Requester\n");
+}
+
 /**
  * pci_ext_cfg_avail - can we access extended PCI config space?
  *
@@ -6643,6 +6696,8 @@ static int __init pci_setup(char *str)
 				pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
 			} else if (!strncmp(str, "disable_acs_redir=", 18)) {
 				disable_acs_redir_param = str + 18;
+			} else if (!strncmp(str, "disable_10bit_tag=", 18)) {
+				disable_10bit_tag_param = str + 18;
 			} else {
 				pr_err("PCI: Unknown option `%s'\n", str);
 			}
@@ -6667,6 +6722,7 @@ static int __init pci_realloc_setup_params(void)
 	resource_alignment_param = kstrdup(resource_alignment_param,
 					   GFP_KERNEL);
 	disable_acs_redir_param = kstrdup(disable_acs_redir_param, GFP_KERNEL);
+	disable_10bit_tag_param = kstrdup(disable_10bit_tag_param, GFP_KERNEL);
 
 	return 0;
 }
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 93dcdd4..87c8187 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -16,6 +16,7 @@ extern bool pci_early_dump;
 
 bool pcie_cap_has_lnkctl(const struct pci_dev *dev);
 bool pcie_cap_has_rtctl(const struct pci_dev *dev);
+void pci_disable_10bit_tag(struct pci_dev *dev);
 
 /* Functions internal to the PCI core code */
 
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 2382cd2..747728e 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -125,15 +125,15 @@ static void pci_configure_rp_10bit_tag(struct pci_dev *dev)
 	bool support = true;
 
 	if (dev->subordinate == NULL)
-		return;
+		goto disable_10bit_tag_req;
 
 	/* If no devices under the root port, no need to enable 10-Bit Tag. */
 	if (list_empty(&dev->subordinate->devices))
-		return;
+		goto disable_10bit_tag_req;
 
 	pci_10bit_tag_comp_support(dev, &support);
 	if (!support)
-		return;
+		goto disable_10bit_tag_req;
 
 	/*
 	 * PCIe spec 5.0r1.0 section 2.2.6.2 implementation note.
@@ -146,14 +146,17 @@ static void pci_configure_rp_10bit_tag(struct pci_dev *dev)
 	 */
 	pci_walk_bus(dev->subordinate, pci_10bit_tag_comp_support, &support);
 	if (!support)
-		return;
+		goto disable_10bit_tag_req;
 
 	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ))
-		return;
+		goto disable_10bit_tag_req;
 
 	pci_dbg(dev, "enabling 10-Bit Tag Requester\n");
 	pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
 				 PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+
+disable_10bit_tag_req:
+	pci_disable_10bit_tag(dev);
 }
 
 /*
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3da7baa..0b7b053 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2034,11 +2034,11 @@ static void pci_configure_10bit_tags(struct pci_dev *dev)
 	struct pci_dev *bridge;
 
 	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP))
-		return;
+		goto disable_10bit_tag_req;
 
 	if (pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT) {
 		dev->ext_10bit_tag = 1;
-		return;
+		goto disable_10bit_tag_req;
 	}
 
 	bridge = pci_upstream_bridge(dev);
@@ -2050,7 +2050,7 @@ static void pci_configure_10bit_tags(struct pci_dev *dev)
 	 * for VF.
 	 */
 	if (dev->is_virtfn)
-		return;
+		goto disable_10bit_tag_req;
 
 	if (pci_pcie_type(dev) == PCI_EXP_TYPE_ENDPOINT &&
 	    dev->ext_10bit_tag == 1 &&
@@ -2059,6 +2059,9 @@ static void pci_configure_10bit_tags(struct pci_dev *dev)
 		pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
 					PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
 	}
+
+disable_10bit_tag_req:
+	 pci_disable_10bit_tag(dev);
 }
 
 int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
-- 
2.7.4

