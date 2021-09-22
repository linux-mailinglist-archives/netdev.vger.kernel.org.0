Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C7D414ABC
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhIVNl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:41:28 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:16282 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhIVNlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 09:41:22 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HDzsj0qMyz8tLw;
        Wed, 22 Sep 2021 21:39:05 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 22 Sep 2021 21:39:49 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V9 1/8] PCI: Use cached devcap in more places
Date:   Wed, 22 Sep 2021 21:36:48 +0800
Message-ID: <20210922133655.51811-2-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20210922133655.51811-1-liudongdong3@huawei.com>
References: <20210922133655.51811-1-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 691392448065 ("PCI: Cache PCIe Device Capabilities register")
has already added a new member called devcap in struct pci_dev for
caching the PCIe Device Capabilities register to avoid reading
PCI_EXP_DEVCAP multiple times. Use devcap in more needed places.

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/media/pci/cobalt/cobalt-driver.c |  4 ++--
 drivers/pci/pcie/aspm.c                  | 11 ++++-------
 drivers/pci/probe.c                      |  7 +------
 drivers/pci/quirks.c                     |  3 +--
 4 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 16af58f2f93c..bc04184f1f74 100644
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
+		    pci_dev->devcap,
+		    get_payload_size(pci_dev->devcap & PCI_EXP_DEVCAP_PAYLOAD));
 	cobalt_info("PCIe device control 0x%04x: Max payload %d. Max read request %d\n",
 		    ctrl,
 		    get_payload_size((ctrl & PCI_EXP_DEVCTL_PAYLOAD) >> 5),
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 013a47f587ce..82d6234a4aa5 100644
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
+		encoding = (child->devcap & PCI_EXP_DEVCAP_L0S) >> 6;
 		acceptable->l0s = calc_l0s_acceptable(encoding);
 		/* Calculate endpoint L1 acceptable latency */
-		encoding = (reg32 & PCI_EXP_DEVCAP_L1) >> 9;
+		encoding = (child->devcap & PCI_EXP_DEVCAP_L1) >> 9;
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
+		if (!(child->devcap & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
 			pci_info(child, "disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'\n");
 			return -EINVAL;
 		}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d9fc02a71baa..96ecdf34f931 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2044,18 +2044,13 @@ static void pci_configure_mps(struct pci_dev *dev)
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
+	if (!(dev->devcap & PCI_EXP_DEVCAP_EXT_TAG))
 		return 0;
 
 	ret = pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &ctl);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4537d1ea14fd..1bd0d610f3e0 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5260,8 +5260,7 @@ static void quirk_intel_qat_vf_cap(struct pci_dev *pdev)
 		pdev->pcie_cap = pos;
 		pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
 		pdev->pcie_flags_reg = reg16;
-		pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
-		pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
+		pdev->pcie_mpss = pdev->devcap & PCI_EXP_DEVCAP_PAYLOAD;
 
 		pdev->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
 		if (pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &status) !=
-- 
2.22.0

