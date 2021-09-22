Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52966414AC6
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhIVNlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:41:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:16373 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbhIVNld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 09:41:33 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HDznw5D0ZzRRZR;
        Wed, 22 Sep 2021 21:35:48 +0800 (CST)
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
Subject: [PATCH V9 5/8] PCI/IOV: Add 10-Bit Tag sysfs files for VF devices
Date:   Wed, 22 Sep 2021 21:36:52 +0800
Message-ID: <20210922133655.51811-6-liudongdong3@huawei.com>
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

PCIe spec 5.0 r1.0 section 2.2.6.2 says:

  If an Endpoint supports sending Requests to other Endpoints (as
  opposed to host memory), the Endpoint must not send 10-Bit Tag
  Requests to another given Endpoint unless an implementation-specific
  mechanism determines that the Endpoint supports 10-Bit Tag Completer
  capability.

Add sriov_vf_10bit_tag file to query the status of VF 10-Bit Tag
Requester Enable.

Add a sriov_vf_10bit_tag_ctl sysfs file, write 0 to disable the VF
10-Bit Tag Requester. The typical use case is for p2pdma when the peer
device does not support 10-Bit Tag Completer. Write 1 to enable 10-Bit
Tag Requester when RC supports 10-Bit Tag Completer capability. The
typical use case is for host memory targeted by DMA Requests.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 Documentation/ABI/testing/sysfs-bus-pci | 23 +++++++++++
 drivers/pci/iov.c                       | 53 +++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 0c26346d1069..28b1f71df620 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -440,3 +440,26 @@ Description:
 		10-Bit Tag Completer. Write 1 to enable 10-Bit Tag Requester
 		when RC supports 10-Bit Tag Completer capability. The typical
 		use case is for host memory targeted by DMA Requests.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_10bit_tag
+Date:		September 2021
+Contact:	Dongdong Liu <liudongdong3@huawei.com>
+Description:
+		This file is associated with a SR-IOV physical function (PF).
+		It is visible when the device supports VF 10-Bit Tag Requester.
+		It contains the status of VF 10-Bit Tag Requester Enable.
+		The file is read-only.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl
+Date:		September 2021
+Contact:	Dongdong Liu <liudongdong3@huawei.com>
+Description:
+		This file is associated with a SR-IOV virtual function (VF).
+		It is visible when the device supports VF 10-Bit Tag
+		Requester. The file is only writeable when the VF driver
+		does not bind to a device. Write 0 to any VF's file disables
+		10-Bit Tag Requester for all VFs. The typical use case is for
+		p2pdma when the peer device does not support 10-Bit Tag
+		Completer. Write 1 to enable 10-Bit Tag Requester for all VFs
+		when RC supports 10-Bit Tag Completer capability. The typical
+		use case is for host memory targeted by DMA Requests.
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index dafdc652fcd0..7781b87a940c 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -220,10 +220,41 @@ static ssize_t sriov_vf_msix_count_store(struct device *dev,
 static DEVICE_ATTR_WO(sriov_vf_msix_count);
 #endif
 
+static ssize_t sriov_vf_10bit_tag_ctl_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct pci_dev *vf_dev = to_pci_dev(dev);
+	struct pci_dev *pdev = pci_physfn(vf_dev);
+	bool enable;
+
+	if (kstrtobool(buf, &enable) < 0)
+		return -EINVAL;
+
+	if (vf_dev->driver)
+		return -EBUSY;
+
+	if (enable) {
+		if (!pcie_rp_10bit_tag_cmp_supported(pdev))
+			return -EPERM;
+
+		pdev->sriov->ctrl |= PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
+	} else {
+		pdev->sriov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
+	}
+
+	pci_write_config_word(pdev, pdev->sriov->pos + PCI_SRIOV_CTRL,
+				      pdev->sriov->ctrl);
+
+	return count;
+}
+static DEVICE_ATTR_WO(sriov_vf_10bit_tag_ctl);
+
 static struct attribute *sriov_vf_dev_attrs[] = {
 #ifdef CONFIG_PCI_MSI
 	&dev_attr_sriov_vf_msix_count.attr,
 #endif
+	&dev_attr_sriov_vf_10bit_tag_ctl.attr,
 	NULL,
 };
 
@@ -236,6 +267,11 @@ static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
 	if (!pdev->is_virtfn)
 		return 0;
 
+	pdev = pci_physfn(pdev);
+	if ((a == &dev_attr_sriov_vf_10bit_tag_ctl.attr) &&
+	     !(pdev->sriov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ))
+		return 0;
+
 	return a->mode;
 }
 
@@ -487,12 +523,23 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
 	return count;
 }
 
+static ssize_t sriov_vf_10bit_tag_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sysfs_emit(buf, "%u\n",
+		!!(pdev->sriov->ctrl & PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN));
+}
+
 static DEVICE_ATTR_RO(sriov_totalvfs);
 static DEVICE_ATTR_RW(sriov_numvfs);
 static DEVICE_ATTR_RO(sriov_offset);
 static DEVICE_ATTR_RO(sriov_stride);
 static DEVICE_ATTR_RO(sriov_vf_device);
 static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
+static DEVICE_ATTR_RO(sriov_vf_10bit_tag);
 
 static struct attribute *sriov_pf_dev_attrs[] = {
 	&dev_attr_sriov_totalvfs.attr,
@@ -501,6 +548,7 @@ static struct attribute *sriov_pf_dev_attrs[] = {
 	&dev_attr_sriov_stride.attr,
 	&dev_attr_sriov_vf_device.attr,
 	&dev_attr_sriov_drivers_autoprobe.attr,
+	&dev_attr_sriov_vf_10bit_tag.attr,
 #ifdef CONFIG_PCI_MSI
 	&dev_attr_sriov_vf_total_msix.attr,
 #endif
@@ -511,10 +559,15 @@ static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
 					  struct attribute *a, int n)
 {
 	struct device *dev = kobj_to_dev(kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
 
 	if (!dev_is_pf(dev))
 		return 0;
 
+	if ((a == &dev_attr_sriov_vf_10bit_tag.attr) &&
+	     !(pdev->sriov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ))
+		return 0;
+
 	return a->mode;
 }
 
-- 
2.22.0

