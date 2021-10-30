Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C1844094A
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 15:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhJ3OAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:00:10 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26216 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbhJ3OAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:00:08 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HhLRp3gVHz8tVn;
        Sat, 30 Oct 2021 21:56:06 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Sat, 30 Oct 2021 21:57:31 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V11 5/8] PCI/IOV: Add tags sysfs files for VF devices
Date:   Sat, 30 Oct 2021 21:53:45 +0800
Message-ID: <20211030135348.61364-6-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20211030135348.61364-1-liudongdong3@huawei.com>
References: <20211030135348.61364-1-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

Add sriov_vf_tags file to query the status of VF 10-Bit Tag
Requester Enable.

Add a sriov_vf_tags_ctl sysfs file, write 0 to disable the VF
10-Bit Tag Requester. The typical use case is for p2pdma when the peer
device does not support 10-Bit Tag Completer. Write 10 to enable 10-Bit
Tag Requester when RC supports 10-Bit Tag Completer capability. The
typical use case is for host memory targeted by DMA Requests.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 Documentation/ABI/testing/sysfs-bus-pci | 32 +++++++++++
 drivers/pci/iov.c                       | 70 +++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index c16bb31486d2..9343941969b6 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -446,3 +446,35 @@ Description:
 		Write 10 to enable 10-Bit Tag Requester when RC supports 10-Bit
 		Tag Completer capability. The typical use case is for host
 		memory targeted by DMA Requests.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_tags
+Date:		September 2021
+Contact:	Dongdong Liu <liudongdong3@huawei.com>
+Description:
+		This file is associated with a SR-IOV physical function (PF).
+		It is visible when the device supports VF 10-Bit Tag
+		Requester. It contains the status of VF Tags Enable.
+		The file is read-only.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_tags_ctl
+Date:		September 2021
+Contact:	Dongdong Liu <liudongdong3@huawei.com>
+Description:
+		This file is associated with a SR-IOV virtual function (VF).
+		It is visible when the device supports VF 10-Bit Tag
+		Requester. The file is only writeable when the VF driver
+		does not bind to a device.
+
+		The values accepted are:
+		* > 0 - this number will be reported as tags bit to be
+			enabled. current only 10 is accepted
+		* < 0 - not valid
+		* = 0 - disable 10-Bit Tag, use Extended Tags(8-Bit or 5-Bit)
+
+		Write 0 to any VF's file disables 10-Bit Tag Requester for all
+		VFs. The typical use case is for p2pdma when the peer device
+		does not support 10-Bit Tag Completer.
+
+		Write 10 to enable 10-Bit Tag Requester for all VFs when RC
+		supports 10-Bit Tag Completer capability. The typical use case
+		is for host memory targeted by DMA Requests.
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index dafdc652fcd0..3627e495d7af 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -220,10 +220,47 @@ static ssize_t sriov_vf_msix_count_store(struct device *dev,
 static DEVICE_ATTR_WO(sriov_vf_msix_count);
 #endif
 
+static ssize_t sriov_vf_tags_ctl_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct pci_dev *vf_dev = to_pci_dev(dev);
+	struct pci_dev *pdev = pci_physfn(vf_dev);
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
+	if (vf_dev->driver)
+		return -EBUSY;
+
+	if (!pcie_rp_10bit_tag_cmp_supported(pdev))
+		return -EPERM;
+
+	if (val == 10)
+		pdev->sriov->ctrl |= PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
+	else
+		pdev->sriov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
+
+	pci_write_config_word(pdev, pdev->sriov->pos + PCI_SRIOV_CTRL,
+			      pdev->sriov->ctrl);
+
+	return count;
+}
+static DEVICE_ATTR_WO(sriov_vf_tags_ctl);
+
 static struct attribute *sriov_vf_dev_attrs[] = {
 #ifdef CONFIG_PCI_MSI
 	&dev_attr_sriov_vf_msix_count.attr,
 #endif
+	&dev_attr_sriov_vf_tags_ctl.attr,
 	NULL,
 };
 
@@ -236,6 +273,11 @@ static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
 	if (!pdev->is_virtfn)
 		return 0;
 
+	pdev = pci_physfn(pdev);
+	if ((a == &dev_attr_sriov_vf_tags_ctl.attr) &&
+	     !(pdev->sriov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ))
+		return 0;
+
 	return a->mode;
 }
 
@@ -487,12 +529,34 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
 	return count;
 }
 
+static ssize_t sriov_vf_tags_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u16 ctl;
+	int ret;
+
+	if (pdev->sriov->ctrl & PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN)
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
+
 static DEVICE_ATTR_RO(sriov_totalvfs);
 static DEVICE_ATTR_RW(sriov_numvfs);
 static DEVICE_ATTR_RO(sriov_offset);
 static DEVICE_ATTR_RO(sriov_stride);
 static DEVICE_ATTR_RO(sriov_vf_device);
 static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
+static DEVICE_ATTR_RO(sriov_vf_tags);
 
 static struct attribute *sriov_pf_dev_attrs[] = {
 	&dev_attr_sriov_totalvfs.attr,
@@ -501,6 +565,7 @@ static struct attribute *sriov_pf_dev_attrs[] = {
 	&dev_attr_sriov_stride.attr,
 	&dev_attr_sriov_vf_device.attr,
 	&dev_attr_sriov_drivers_autoprobe.attr,
+	&dev_attr_sriov_vf_tags.attr,
 #ifdef CONFIG_PCI_MSI
 	&dev_attr_sriov_vf_total_msix.attr,
 #endif
@@ -511,10 +576,15 @@ static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
 					  struct attribute *a, int n)
 {
 	struct device *dev = kobj_to_dev(kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
 
 	if (!dev_is_pf(dev))
 		return 0;
 
+	if ((a == &dev_attr_sriov_vf_tags.attr) &&
+	     !(pdev->sriov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ))
+		return 0;
+
 	return a->mode;
 }
 
-- 
2.22.0

