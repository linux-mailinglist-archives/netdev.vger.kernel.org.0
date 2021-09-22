Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047F3414ACB
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhIVNlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:41:44 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9905 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbhIVNld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 09:41:33 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HDznX3DxNz8yks;
        Wed, 22 Sep 2021 21:35:28 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 22 Sep 2021 21:40:00 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V9 7/8] PCI: Enable 10-Bit Tag support for PCIe Endpoint device
Date:   Wed, 22 Sep 2021 21:36:54 +0800
Message-ID: <20210922133655.51811-8-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20210922133655.51811-1-liudongdong3@huawei.com>
References: <20210922133655.51811-1-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
field size from 8 bits to 10 bits.

PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
10-Bit Tag Capabilities" Implementation Note:

  For platforms where the RC supports 10-Bit Tag Completer capability,
  it is highly recommended for platform firmware or operating software
  that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
  bit automatically in Endpoints with 10-Bit Tag Requester capability.
  This enables the important class of 10-Bit Tag capable adapters that
  send Memory Read Requests only to host memory.

It's safe to enable 10-bit tags for all devices below a Root Port that
supports them. Switches that lack 10-Bit Tag Completer capability are
still able to forward NPRs and Completions carrying 10-Bit Tags correctly,
since the two new Tag bits are in TLP Header bits that were formerly
Reserved.

PCIe spec 5.0 r1.0 section 2.2.6.2 says:

  If an Endpoint supports sending Requests to other Endpoints (as opposed
  to host memory), the Endpoint must not send 10-Bit Tag Requests to
  another given Endpoint unless an implementation-specific mechanism
  determines that the Endpoint supports 10-Bit Tag Completer capability.

It is not safe for P2P traffic if an Endpoint send 10-Bit Tag Requesters
to another Endpoint that does not support 10-Bit Tag Completer capability,
so we provide sysfs file to disable 10-Bit Tag Requester. Unbind the
device driver, set the sysfs file and then rebind the driver.

Add a kernel parameter pcie_tag_peer2peer that disables 10-Bit Tag
Requester for all PCIe devices. This configuration allows peer-to-peer
DMA between any pair of devices, possibly at the cost of reduced
performance.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 .../admin-guide/kernel-parameters.txt         |  5 ++
 drivers/pci/iov.c                             |  3 ++
 drivers/pci/pci-sysfs.c                       |  3 ++
 drivers/pci/pci.c                             |  4 ++
 drivers/pci/pci.h                             |  7 +++
 drivers/pci/probe.c                           | 46 ++++++++++++++++++-
 6 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 91ba391f9b32..54fddae7b2d9 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3979,6 +3979,11 @@
 				any pair of devices, possibly at the cost of
 				reduced performance.  This also guarantees
 				that hot-added devices will work.
+		pcie_tag_peer2peer	Disable 10-Bit Tag Requester for all
+				PCIe devices. This configuration allows
+				peer-to-peer DMA between any pair of devices,
+				possibly at the cost of reduced performance.
+
 		cbiosize=nn[KMG]	The fixed amount of bus space which is
 				reserved for the CardBus bridge's IO window.
 				The default value is 256 bytes.
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 7781b87a940c..4fd1fca69457 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -234,6 +234,9 @@ static ssize_t sriov_vf_10bit_tag_ctl_store(struct device *dev,
 	if (vf_dev->driver)
 		return -EBUSY;
 
+	if (pcie_tag_config == PCIE_TAG_PEER2PEER)
+		return -EPERM;
+
 	if (enable) {
 		if (!pcie_rp_10bit_tag_cmp_supported(pdev))
 			return -EPERM;
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 7be65e919d33..edb06bb9600e 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -319,6 +319,9 @@ static ssize_t pci_10bit_tag_store(struct device *dev,
 	if (pdev->driver)
 		return -EBUSY;
 
+	if (pcie_tag_config == PCIE_TAG_PEER2PEER)
+		return -EPERM;
+
 	if (enable) {
 		if (!pcie_rp_10bit_tag_cmp_supported(pdev))
 			return -EPERM;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 64138a83b0f7..46faf2e8c8ab 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -118,6 +118,8 @@ enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_PEER2PEER;
 enum pcie_bus_config_types pcie_bus_config = PCIE_BUS_DEFAULT;
 #endif
 
+enum pcie_tag_config_types pcie_tag_config = PCIE_TAG_DEFAULT;
+
 /*
  * The default CLS is used if arch didn't set CLS explicitly and not
  * all pci devices agree on the same value.  Arch can override either
@@ -6795,6 +6797,8 @@ static int __init pci_setup(char *str)
 				pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
 			} else if (!strncmp(str, "disable_acs_redir=", 18)) {
 				disable_acs_redir_param = str + 18;
+			} else if (!strncmp(str, "pcie_tag_peer2peer", 18)) {
+				pcie_tag_config = PCIE_TAG_PEER2PEER;
 			} else {
 				pr_err("PCI: Unknown option `%s'\n", str);
 			}
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index f719a41dfc7f..7846aa7b85dc 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -59,6 +59,13 @@ struct pci_cap_saved_state *pci_find_saved_cap(struct pci_dev *dev, char cap);
 struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev,
 						   u16 cap);
 
+enum pcie_tag_config_types {
+	PCIE_TAG_DEFAULT,   /* Enable 10-Bit Tag Requester for devices below
+			       Root Port that support 10-Bit Tag Completer. */
+	PCIE_TAG_PEER2PEER  /* Disable 10-Bit Tag Requester for all devices. */
+};
+extern enum pcie_tag_config_types pcie_tag_config;
+
 #define PCI_PM_D2_DELAY         200	/* usec; see PCIe r4.0, sec 5.9.1 */
 #define PCI_PM_D3HOT_WAIT       10	/* msec */
 #define PCI_PM_D3COLD_WAIT      100	/* msec */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 705dd4e85df5..ab18fac5d54d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2056,10 +2056,30 @@ bool pcie_rp_10bit_tag_cmp_supported(struct pci_dev *dev)
 	return true;
 }
 
+static void pci_configure_10bit_tags(struct pci_dev *dev)
+{
+	/*
+	 * PCIe 5.0 section 9.3.5.10 10-Bit Tag Requester Enable in Device
+	 * Control 2 Register is RsvdP for VF.
+	 */
+	if (dev->is_virtfn)
+		return;
+
+	if (!pcie_rp_10bit_tag_cmp_supported(dev))
+		return;
+
+	if (pci_pcie_type(dev) != PCI_EXP_TYPE_ENDPOINT)
+		return;
+
+	pci_dbg(dev, "enabling 10-Bit Tag Requester\n");
+	pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
+				PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+}
+
 int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 {
 	struct pci_host_bridge *host;
-	u16 ctl;
+	u16 ctl, ctl2;
 	int ret;
 
 	if (!pci_is_pcie(dev))
@@ -2072,6 +2092,10 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 	if (ret)
 		return 0;
 
+	ret = pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &ctl2);
+	if (ret)
+		return 0;
+
 	host = pci_find_host_bridge(dev->bus);
 	if (!host)
 		return 0;
@@ -2086,6 +2110,12 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
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
 
@@ -2094,6 +2124,20 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 		pcie_capability_set_word(dev, PCI_EXP_DEVCTL,
 					 PCI_EXP_DEVCTL_EXT_TAG);
 	}
+
+	if ((pcie_tag_config == PCIE_TAG_PEER2PEER) &&
+	    (ctl2 & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN)) {
+		pci_info(dev, "disabling 10-Bit Tags\n");
+		pcie_capability_clear_word(dev, PCI_EXP_DEVCTL2,
+					PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+		return 0;
+	}
+
+	if (pcie_tag_config != PCIE_TAG_DEFAULT)
+		return 0;
+
+	pci_configure_10bit_tags(dev);
+
 	return 0;
 }
 
-- 
2.22.0

