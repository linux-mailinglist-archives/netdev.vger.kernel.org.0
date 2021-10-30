Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFAD440934
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 15:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhJ3OAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:00:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:30885 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhJ3OAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:00:01 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HhLMx50CJzbnB3;
        Sat, 30 Oct 2021 21:52:45 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Sat, 30 Oct 2021 21:57:26 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V11 4/8] PCI/sysfs: Add a tags sysfs file for PCIe Endpoint devices
Date:   Sat, 30 Oct 2021 21:53:44 +0800
Message-ID: <20211030135348.61364-5-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20211030135348.61364-1-liudongdong3@huawei.com>
References: <20211030135348.61364-1-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCIe spec 5.0 r1.0 section 2.2.6.2 says:

  If an Endpoint supports sending Requests to other Endpoints (as
  opposed to host memory), the Endpoint must not send 10-Bit Tag
  Requests to another given Endpoint unless an implementation-specific
  mechanism determines that the Endpoint supports 10-Bit Tag Completer
  capability.

Add a tags sysfs file, write 0 to disable 10-Bit Tag Requester
when the driver does not bind the device. The typical use case is for
p2pdma when the peer device does not support 10-Bit Tag Completer.
Write 10 to enable 10-Bit Tag Requester when RC supports 10-Bit Tag
Completer capability. The typical use case is for host memory targeted
by DMA Requests. The tags file content indicate current status of Tags
Enable.

PCIe r5.0, sec 2.2.6.2 says:

  Receivers/Completers must handle 8-bit Tag values correctly regardless
  of the setting of their Extended Tag Field Enable bit (see Section
  7.5.3.4).

Add this comment in pci_configure_extended_tags(). As all PCIe completers
are required to support 8-bit tags, so we do not use tags sysfs file
to manage 8-bit tags.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 Documentation/ABI/testing/sysfs-bus-pci | 24 ++++++-
 drivers/pci/pci-sysfs.c                 | 88 +++++++++++++++++++++++++
 drivers/pci/pci.h                       |  2 +
 drivers/pci/probe.c                     | 20 ++++++
 4 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index d4ae03296861..c16bb31486d2 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -156,7 +156,7 @@ Description:
 		binary file containing the Vital Product Data for the
 		device.  It should follow the VPD format defined in
 		PCI Specification 2.1 or 2.2, but users should consider
-		that some devices may have incorrectly formatted data.  
+		that some devices may have incorrectly formatted data.
 		If the underlying VPD has a writable section then the
 		corresponding section of this file will be writable.
 
@@ -424,3 +424,25 @@ Description:
 
 		The file is writable if the PF is bound to a driver that
 		implements ->sriov_set_msix_vec_count().
+
+What:		/sys/bus/pci/devices/.../tags
+Date:		September 2021
+Contact:	Dongdong Liu <liudongdong3@huawei.com>
+Description:
+		The file will be visible when the device supports 10-Bit Tag
+		Requester. The file is readable, the value indicate current
+		status of Tags Enable(5-Bit, 8-Bit, 10-Bit).
+
+		The file is also writable, The values accepted are:
+		* > 0 - this number will be reported as tags bit to be
+			enabled. current only 10 is accepted
+		* < 0 - not valid
+		* = 0 - disable 10-Bit Tag, use Extended Tags(8-Bit or 5-Bit)
+
+		write 0 to disable 10-Bit Tag Requester when the driver does
+		not bind the device. The typical use case is for p2pdma when
+		the peer device does not support 10-Bit Tag Completer.
+
+		Write 10 to enable 10-Bit Tag Requester when RC supports 10-Bit
+		Tag Completer capability. The typical use case is for host
+		memory targeted by DMA Requests.
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 7fb5cd17cc98..04fd9a8b9d4e 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -306,6 +306,65 @@ static ssize_t enable_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(enable);
 
+static ssize_t tags_store(struct device *dev,
+			  struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long val;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	/* 10 - enable 10-Bit Tag, 0 - disable 10-Bit Tag */
+	if (val != 10 && val != 0)
+		return -EINVAL;
+
+	if (pdev->driver)
+		return -EBUSY;
+
+	if (!pcie_rp_10bit_tag_cmp_supported(pdev))
+		return -EPERM;
+
+	if (val == 10)
+		pcie_capability_set_word(pdev, PCI_EXP_DEVCTL2,
+					 PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+	else
+		pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL2,
+					   PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+
+	return count;
+}
+
+static ssize_t tags_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u16 ctl;
+	int ret;
+
+	ret = pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &ctl);
+	if (ret)
+		return -EINVAL;
+
+	if (ctl & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN)
+		return sysfs_emit(buf, "%s\n", "10-Bit");
+
+	ret = pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &ctl);
+	if (ret)
+		return -EINVAL;
+
+	if (ctl & PCI_EXP_DEVCTL_EXT_TAG)
+		return sysfs_emit(buf, "%s\n", "8-Bit");
+
+	return sysfs_emit(buf, "%s\n", "5-Bit");
+}
+static DEVICE_ATTR_RW(tags);
+
 #ifdef CONFIG_NUMA
 static ssize_t numa_node_store(struct device *dev,
 			       struct device_attribute *attr, const char *buf,
@@ -635,6 +694,11 @@ static struct attribute *pcie_dev_attrs[] = {
 	NULL,
 };
 
+static struct attribute *pcie_dev_tags_attrs[] = {
+	&dev_attr_tags.attr,
+	NULL,
+};
+
 static struct attribute *pcibus_attrs[] = {
 	&dev_attr_bus_rescan.attr,
 	&dev_attr_cpuaffinity.attr,
@@ -1482,6 +1546,24 @@ static umode_t pcie_dev_attrs_are_visible(struct kobject *kobj,
 	return 0;
 }
 
+static umode_t pcie_dev_tags_attrs_is_visible(struct kobject *kobj,
+					      struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (pdev->is_virtfn)
+		return 0;
+
+	if (pci_pcie_type(pdev) != PCI_EXP_TYPE_ENDPOINT)
+		return 0;
+
+	if (!(pdev->devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ))
+		return 0;
+
+	return a->mode;
+}
+
 static const struct attribute_group pci_dev_group = {
 	.attrs = pci_dev_attrs,
 };
@@ -1522,6 +1604,11 @@ static const struct attribute_group pcie_dev_attr_group = {
 	.is_visible = pcie_dev_attrs_are_visible,
 };
 
+static const struct attribute_group pcie_dev_tags_attr_group = {
+	.attrs = pcie_dev_tags_attrs,
+	.is_visible = pcie_dev_tags_attrs_is_visible,
+};
+
 static const struct attribute_group *pci_dev_attr_groups[] = {
 	&pci_dev_attr_group,
 	&pci_dev_hp_attr_group,
@@ -1531,6 +1618,7 @@ static const struct attribute_group *pci_dev_attr_groups[] = {
 #endif
 	&pci_bridge_attr_group,
 	&pcie_dev_attr_group,
+	&pcie_dev_tags_attr_group,
 #ifdef CONFIG_PCIEAER
 	&aer_stats_attr_group,
 #endif
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 1cce56c2aea0..f719a41dfc7f 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -264,6 +264,8 @@ struct device *pci_get_host_bridge_device(struct pci_dev *dev);
 void pci_put_host_bridge_device(struct device *dev);
 
 int pci_configure_extended_tags(struct pci_dev *dev, void *ign);
+bool pcie_rp_10bit_tag_cmp_supported(struct pci_dev *dev);
+
 bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
 				int crs_timeout);
 bool pci_bus_generic_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 7259ad774ac8..8f5372c7c737 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2042,6 +2042,20 @@ static void pci_configure_mps(struct pci_dev *dev)
 		 p_mps, mps, mpss);
 }
 
+bool pcie_rp_10bit_tag_cmp_supported(struct pci_dev *dev)
+{
+	struct pci_dev *root;
+
+	root = pcie_find_root_port(dev);
+	if (!root)
+		return false;
+
+	if (!(root->devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP))
+		return false;
+
+	return true;
+}
+
 int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 {
 	struct pci_host_bridge *host;
@@ -2075,6 +2089,12 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 		return 0;
 	}
 
+	/*
+	 * PCIe r5.0, sec 2.2.6.2 says "Receivers/Completers must handle 8-bit
+	 * Tag values correctly regardless of the setting of their Extended Tag
+	 * Field Enable bit (see Section 7.5.3.4)", so it is safe to enable
+	 * Extented Tags.
+	 */
 	if (!(ctl & PCI_EXP_DEVCTL_EXT_TAG)) {
 		pci_info(dev, "enabling Extended Tags\n");
 		pcie_capability_set_word(dev, PCI_EXP_DEVCTL,
-- 
2.22.0

