Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB0B3E0267
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhHDNtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:49:52 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16043 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238406AbhHDNtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 09:49:31 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GftKz1gBpzZwdc;
        Wed,  4 Aug 2021 21:45:43 +0800 (CST)
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
Subject: [PATCH V7 8/9] PCI/IOV: Add 10-Bit Tag sysfs files for VF devices
Date:   Wed, 4 Aug 2021 21:47:07 +0800
Message-ID: <1628084828-119542-9-git-send-email-liudongdong3@huawei.com>
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

PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
sending Requests to other Endpoints (as opposed to host memory), the
Endpoint must not send 10-Bit Tag Requests to another given Endpoint
unless an implementation-specific mechanism determines that the
Endpoint supports 10-Bit Tag Completer capability.
Add sriov_vf_10bit_tag file to query the status of VF 10-Bit Tag
Requester Enable. Add sriov_vf_10bit_tag_ctl file to disable the VF
10-Bit Tag Requester. The typical use case is for p2pdma when the peer
device does not support 10-BIT Tag Completer.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 Documentation/ABI/testing/sysfs-bus-pci | 20 +++++++++++++
 drivers/pci/iov.c                       | 50 +++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 0e0c97d..8fdbfae 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -421,3 +421,23 @@ Description:
 		to disable 10-Bit Tag Requester when the driver does not bind
 		the deivce. The typical use case is for p2pdma when the peer
 		device does not support 10-BIT Tag Completer.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_10bit_tag
+Date:		August 2021
+Contact:	Dongdong Liu <liudongdong3@huawei.com>
+Description:
+		This file is associated with a SR-IOV physical function (PF).
+		It is visible when the device has VF 10-Bit Tag Requester
+		Supported. It contains the status of VF 10-Bit Tag Requester
+		Enable. The file is only readable.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl
+Date:		August 2021
+Contact:	Dongdong Liu <liudongdong3@huawei.com>
+Description:
+		This file is associated with a SR-IOV virtual function (VF).
+		It is visible when the device has VF 10-Bit Tag Requester
+		Supported. It only allows to write 0 to disable VF 10-Bit
+		Tag Requester. The file is only writeable when the vf driver
+		does not bind to a dirver. The typical use case is for p2pdma
+		when the peer device does not support 10-BIT Tag Completer.
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 0d0bed1..04c1298 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -220,10 +220,38 @@ static ssize_t sriov_vf_msix_count_store(struct device *dev,
 static DEVICE_ATTR_WO(sriov_vf_msix_count);
 #endif
 
+static ssize_t sriov_vf_10bit_tag_ctl_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct pci_dev *vf_dev = to_pci_dev(dev);
+	struct pci_dev *pdev = pci_physfn(vf_dev);
+	struct pci_sriov *iov;
+	bool enable;
+
+	if (kstrtobool(buf, &enable) < 0)
+		return -EINVAL;
+
+	if (enable != false)
+		return -EINVAL;
+
+	if (vf_dev->driver)
+		return -EBUSY;
+
+	iov = pdev->sriov;
+	iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
+	pci_write_config_word(pdev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+	pci_info(pdev, "disabled SRIOV 10-Bit Tag Requester\n");
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
 
@@ -236,6 +264,11 @@ static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
 	if (!pdev->is_virtfn)
 		return 0;
 
+	pdev = pci_physfn(pdev);
+	if ((a == &dev_attr_sriov_vf_10bit_tag_ctl.attr) &&
+	     !(pdev->sriov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ))
+		return 0;
+
 	return a->mode;
 }
 
@@ -487,12 +520,23 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
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
@@ -501,6 +545,7 @@ static struct attribute *sriov_pf_dev_attrs[] = {
 	&dev_attr_sriov_stride.attr,
 	&dev_attr_sriov_vf_device.attr,
 	&dev_attr_sriov_drivers_autoprobe.attr,
+	&dev_attr_sriov_vf_10bit_tag.attr,
 #ifdef CONFIG_PCI_MSI
 	&dev_attr_sriov_vf_total_msix.attr,
 #endif
@@ -511,10 +556,15 @@ static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
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
2.7.4

