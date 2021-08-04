Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEEE3E0257
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbhHDNtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:49:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7924 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbhHDNtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 09:49:31 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GftKd0NC7z83q6;
        Wed,  4 Aug 2021 21:45:25 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 4 Aug 2021 21:49:16 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V7 4/9] PCI: Enable 10-Bit Tag support for PCIe Endpoint devices
Date:   Wed, 4 Aug 2021 21:47:03 +0800
Message-ID: <1628084828-119542-5-git-send-email-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628084828-119542-1-git-send-email-liudongdong3@huawei.com>
References: <1628084828-119542-1-git-send-email-liudongdong3@huawei.com>
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

PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
10-Bit Tag Capabilities" Implementation Note.
For platforms where the RC supports 10-Bit Tag Completer capability,
it is highly recommended for platform firmware or operating software
that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
bit automatically in Endpoints with 10-Bit Tag Requester capability. This
enables the important class of 10-Bit Tag capable adapters that send
Memory Read Requests only to host memory.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/pci/probe.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/pci.h |  2 ++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index c83245b..3da7baa 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2029,10 +2029,42 @@ static void pci_configure_mps(struct pci_dev *dev)
 		 p_mps, mps, mpss);
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
 int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 {
 	struct pci_host_bridge *host;
-	u16 ctl;
+	u16 ctl, ctl2;
 	int ret;
 
 	if (!pci_is_pcie(dev))
@@ -2045,6 +2077,10 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 	if (ret)
 		return 0;
 
+	ret = pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &ctl2);
+	if (ret)
+		return 0;
+
 	host = pci_find_host_bridge(dev->bus);
 	if (!host)
 		return 0;
@@ -2059,6 +2095,12 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 			pcie_capability_clear_word(dev, PCI_EXP_DEVCTL,
 						   PCI_EXP_DEVCTL_EXT_TAG);
 		}
+
+		if (ctl2 & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN) {
+			pci_info(dev, "disabling 10-Bit Tags\n");
+			pcie_capability_clear_word(dev, PCI_EXP_DEVCTL2,
+					PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+		}
 		return 0;
 	}
 
@@ -2067,6 +2109,9 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 		pcie_capability_set_word(dev, PCI_EXP_DEVCTL,
 					 PCI_EXP_DEVCTL_EXT_TAG);
 	}
+
+	pci_configure_10bit_tags(dev);
+
 	return 0;
 }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9aab67f..af6cb53 100644
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

