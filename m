Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C337C063
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhELOjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:39:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2645 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhELOjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:39:11 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FgHP81lGFzQmVD;
        Wed, 12 May 2021 22:34:36 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 22:37:56 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <verkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V3 4/6] PCI: Enable 10-Bit tag support for PCIe Endpoint devices
Date:   Wed, 12 May 2021 22:37:35 +0800
Message-ID: <20210512143737.42352-5-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512143737.42352-1-liudongdong3@huawei.com>
References: <20210512143737.42352-1-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.21.59.169]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
field size from 8 bits to 10 bits.

For platforms where the RC supports 10-Bit Tag Completer capability,
it is highly recommended for platform firmware or operating software
that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
bit automatically in Endpoints with 10-Bit Tag Requester capability. This
enables the important class of 10-Bit Tag capable adapters that send
Memory Read Requests only to host memory.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 drivers/pci/probe.c | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b9942cc..dfcd3d2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2046,6 +2046,41 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 	return 0;
 }
 
+static void pci_configure_10bit_tags(struct pci_dev *dev)
+{
+	struct pci_dev *bridge;
+
+	if (!pci_is_pcie(dev))
+		return;
+
+	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP))
+		return;
+
+	if (pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT) {
+		dev->ext_10bit_tag = 1;
+		return;
+	}
+
+	bridge = pci_upstream_bridge(dev);
+	if (bridge && bridge->ext_10bit_tag)
+		dev->ext_10bit_tag = 1;
+
+	/*
+	 * 10-Bit Tag Requester Enable in Device Control 2 Register is RsvdP
+	 * for VF.
+	 */
+	if (dev->is_virtfn)
+		return;
+
+	if (pci_pcie_type(dev) == PCI_EXP_TYPE_ENDPOINT &&
+	    dev->ext_10bit_tag == 1 &&
+	    (dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ)) {
+		pci_dbg(dev, "enabling 10-Bit Tag Requester\n");
+		pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
+					PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+	}
+}
+
 /**
  * pcie_relaxed_ordering_enabled - Probe for PCIe relaxed ordering enable
  * @dev: PCI device to query
@@ -2182,6 +2217,7 @@ static void pci_configure_device(struct pci_dev *dev)
 {
 	pci_configure_mps(dev);
 	pci_configure_extended_tags(dev, NULL);
+	pci_configure_10bit_tags(dev);
 	pci_configure_relaxed_ordering(dev);
 	pci_configure_ltr(dev);
 	pci_configure_eetlp_prefix(dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2965620..f2b2b5b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -393,6 +393,8 @@ struct pci_dev {
 #endif
 	unsigned int	eetlp_prefix_path:1;	/* End-to-End TLP Prefix */
 
+	unsigned int	ext_10bit_tag:1; /* 10-Bit Tag Completer Supported
+					    from root to here */
 	pci_channel_state_t error_state;	/* Current connectivity state */
 	struct device	dev;			/* Generic device interface */
 
-- 
2.7.4

