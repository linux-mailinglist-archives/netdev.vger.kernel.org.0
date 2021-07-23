Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE7D3D3922
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbhGWK2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:28:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7049 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbhGWK1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:27:53 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GWRHH5X8WzYfNF;
        Fri, 23 Jul 2021 19:02:35 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 23 Jul 2021 19:08:25 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V6 6/8] PCI: Enable 10-Bit tag support for PCIe RP devices
Date:   Fri, 23 Jul 2021 19:06:40 +0800
Message-ID: <1627038402-114183-7-git-send-email-liudongdong3@huawei.com>
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

PCIe spec 5.0r1.0 section 2.2.6.2 implementation note, In configurations
where a Requester with 10-Bit Tag Requester capability needs to target
multiple Completers, one needs to ensure that the Requester sends 10-Bit
Tag Requests only to Completers that have 10-Bit Tag Completer capability.
So we enable 10-Bit Tag Requester for root port only when the devices
under the root port support 10-Bit Tag Completer.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 drivers/pci/pcie/portdrv_pci.c | 69 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index c7ff1ee..2382cd2 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -90,6 +90,72 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
 #define PCIE_PORTDRV_PM_OPS	NULL
 #endif /* !PM */
 
+static int pci_10bit_tag_comp_support(struct pci_dev *dev, void *data)
+{
+	bool *support = (bool *)data;
+
+	if (!pci_is_pcie(dev)) {
+		*support = false;
+		return 1;
+	}
+
+	/*
+	 * PCIe spec 5.0r1.0 section 2.2.6.2 implementation note.
+	 * For configurations where a Requester with 10-Bit Tag Requester
+	 * capability targets Completers where some do and some do not have
+	 * 10-Bit Tag Completer capability, how the Requester determines which
+	 * NPRs include 10-Bit Tags is outside the scope of this specification.
+	 * So we do not consider hotplug scenario.
+	 */
+	if (dev->is_hotplug_bridge) {
+		*support = false;
+		return 1;
+	}
+
+	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP)) {
+		*support = false;
+		return 1;
+	}
+
+	return 0;
+}
+
+static void pci_configure_rp_10bit_tag(struct pci_dev *dev)
+{
+	bool support = true;
+
+	if (dev->subordinate == NULL)
+		return;
+
+	/* If no devices under the root port, no need to enable 10-Bit Tag. */
+	if (list_empty(&dev->subordinate->devices))
+		return;
+
+	pci_10bit_tag_comp_support(dev, &support);
+	if (!support)
+		return;
+
+	/*
+	 * PCIe spec 5.0r1.0 section 2.2.6.2 implementation note.
+	 * In configurations where a Requester with 10-Bit Tag Requester
+	 * capability needs to target multiple Completers, one needs to ensure
+	 * that the Requester sends 10-Bit Tag Requests only to Completers
+	 * that have 10-Bit Tag Completer capability. So we enable 10-Bit Tag
+	 * Requester for root port only when the devices under the root port
+	 * support 10-Bit Tag Completer.
+	 */
+	pci_walk_bus(dev->subordinate, pci_10bit_tag_comp_support, &support);
+	if (!support)
+		return;
+
+	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ))
+		return;
+
+	pci_dbg(dev, "enabling 10-Bit Tag Requester\n");
+	pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
+				 PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+}
+
 /*
  * pcie_portdrv_probe - Probe PCI-Express port devices
  * @dev: PCI-Express port device being probed
@@ -111,6 +177,9 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
 	     (type != PCI_EXP_TYPE_RC_EC)))
 		return -ENODEV;
 
+	if (type == PCI_EXP_TYPE_ROOT_PORT)
+		pci_configure_rp_10bit_tag(dev);
+
 	if (type == PCI_EXP_TYPE_RC_EC)
 		pcie_link_rcec(dev);
 
-- 
2.7.4

