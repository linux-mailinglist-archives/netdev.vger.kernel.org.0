Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F76B3A8F86
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 05:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhFPDmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 23:42:47 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10081 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhFPDmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 23:42:36 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4W8s4lLLzZfNf;
        Wed, 16 Jun 2021 11:37:33 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 11:40:28 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V4 4/6] PCI: Enable 10-Bit tag support for PCIe Endpoint devices
Date:   Wed, 16 Jun 2021 11:39:24 +0800
Message-ID: <1623814766-91906-5-git-send-email-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623814766-91906-1-git-send-email-liudongdong3@huawei.com>
References: <1623814766-91906-1-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/pci/probe.c | 33 +++++++++++++++++++++++++++++++++
 include/linux/pci.h |  2 ++
 2 files changed, 35 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 0208865..33241fb 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2048,6 +2048,38 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 	return 0;
 }
 
+static void pci_configure_10bit_tags(struct pci_dev *dev)
+{
+	struct pci_dev *bridge;
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
@@ -2184,6 +2216,7 @@ static void pci_configure_device(struct pci_dev *dev)
 {
 	pci_configure_mps(dev);
 	pci_configure_extended_tags(dev, NULL);
+	pci_configure_10bit_tags(dev);
 	pci_configure_relaxed_ordering(dev);
 	pci_configure_ltr(dev);
 	pci_configure_eetlp_prefix(dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index de1fc24..445d102 100644
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

