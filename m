Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4E03044C4
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388499AbhAZRLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730161AbhAZI77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 03:59:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A39E23101;
        Tue, 26 Jan 2021 08:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611651469;
        bh=g9sHWbQQ95H7CJXLXFImGddq3+ka9V2ACNnRea4gVvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lgmf9NJhvy55uJTXlk7uci0ksm3o6ApT5dvtxyYM4y75ZkbDRckItVW35/TgHg50b
         R61jV9Hot5DChs8xBPq1S3qMZ5pTlprmW1F4QZ/107MCrvz1oB9l2vBzcaLPbejc41
         Bki/064vaO8nwauiwLOY0S0AQiiXSSbTrSonZ9Y2pfIFBY+Cbr2Xg5S0FyCuCpiJf7
         mOJUzxXPy0/j3QvFoQhj6cM1LoYLDl2Vhz22nuLJvYm3AtZG5PMNpttGzwFR+bYrAF
         7/uZ/NhGoLDCcdGEL+kHD1Au1dZLqX65JKU5lAwB3OvgJF1KjsL3/vvogM+43P20xA
         LtbfCj8EcOv/A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH mlx5-next v5 1/4] PCI: Add sysfs callback to allow MSI-X table size change of SR-IOV VFs
Date:   Tue, 26 Jan 2021 10:57:27 +0200
Message-Id: <20210126085730.1165673-2-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126085730.1165673-1-leon@kernel.org>
References: <20210126085730.1165673-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Extend PCI sysfs interface with a new callback that allows configure
the number of MSI-X vectors for specific SR-IO VF. This is needed
to optimize the performance of newly bound devices by allocating
the number of vectors based on the administrator knowledge of targeted VM.

This function is applicable for SR-IOV VF because such devices allocate
their MSI-X table before they will run on the VMs and HW can't guess the
right number of vectors, so the HW allocates them statically and equally.

1) The newly added /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_msix_count
file will be seen for the VFs and it is writable as long as a driver is not
bounded to the VF.

The values accepted are:
 * > 0 - this will be number reported by the VF's MSI-X capability
 * < 0 - not valid
 * = 0 - will reset to the device default value

2) In order to make management easy, provide new read-only sysfs file that
returns a total number of possible to configure MSI-X vectors.

cat /sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
  = 0 - feature is not supported
  > 0 - total number of MSI-X vectors to consume by the VFs

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/ABI/testing/sysfs-bus-pci |  32 +++++
 drivers/pci/iov.c                       | 180 ++++++++++++++++++++++++
 drivers/pci/msi.c                       |  47 +++++++
 drivers/pci/pci.h                       |   4 +
 include/linux/pci.h                     |  10 ++
 5 files changed, 273 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 25c9c39770c6..4d206ade5331 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -375,3 +375,35 @@ Description:
 		The value comes from the PCI kernel device state and can be one
 		of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
 		The file is read only.
+
+What:		/sys/bus/pci/devices/.../vfs_overlay/sriov_vf_msix_count
+Date:		January 2021
+Contact:	Leon Romanovsky <leonro@nvidia.com>
+Description:
+		This file is associated with the SR-IOV VFs.
+		It allows configuration of the number of MSI-X vectors for
+		the VF. This is needed to optimize performance of newly bound
+		devices by allocating the number of vectors based on the
+		administrator knowledge of targeted VM.
+
+		The values accepted are:
+		 * > 0 - this will be number reported by the VF's MSI-X
+			 capability
+		 * < 0 - not valid
+		 * = 0 - will reset to the device default value
+
+		The file is writable if the PF is bound to a driver that
+		set sriov_vf_total_msix > 0 and there is no driver bound
+		to the VF.
+
+What:		/sys/bus/pci/devices/.../vfs_overlay/sriov_vf_total_msix
+Date:		January 2021
+Contact:	Leon Romanovsky <leonro@nvidia.com>
+Description:
+		This file is associated with the SR-IOV PFs.
+		It returns a total number of possible to configure MSI-X
+		vectors on the enabled VFs.
+
+		The values returned are:
+		 * > 0 - this will be total number possible to consume by VFs,
+		 * = 0 - feature is not supported
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 4afd4ee4f7f0..3e95f835eba5 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
 	return (dev->devfn + dev->sriov->offset +
 		dev->sriov->stride * vf_id) & 0xff;
 }
+EXPORT_SYMBOL_GPL(pci_iov_virtfn_devfn);

 /*
  * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
@@ -157,6 +158,166 @@ int pci_iov_sysfs_link(struct pci_dev *dev,
 	return rc;
 }

+#ifdef CONFIG_PCI_MSI
+static ssize_t sriov_vf_msix_count_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	int count = pci_msix_vec_count(pdev);
+
+	if (count < 0)
+		return count;
+
+	return sysfs_emit(buf, "%d\n", count);
+}
+
+static ssize_t sriov_vf_msix_count_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct pci_dev *vf_dev = to_pci_dev(dev);
+	int val, ret;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	ret = pci_vf_set_msix_vec_count(vf_dev, val);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR_RW(sriov_vf_msix_count);
+
+static ssize_t sriov_vf_total_msix_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sysfs_emit(buf, "%u\n", pdev->sriov->vf_total_msix);
+}
+static DEVICE_ATTR_RO(sriov_vf_total_msix);
+#endif
+
+static struct attribute *sriov_pf_dev_attrs[] = {
+#ifdef CONFIG_PCI_MSI
+	&dev_attr_sriov_vf_total_msix.attr,
+#endif
+	NULL,
+};
+
+static struct attribute *sriov_vf_dev_attrs[] = {
+#ifdef CONFIG_PCI_MSI
+	&dev_attr_sriov_vf_msix_count.attr,
+#endif
+	NULL,
+};
+
+static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
+					  struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (!pdev->msix_cap || !dev_is_pf(dev))
+		return 0;
+
+	return a->mode;
+}
+
+static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
+					  struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (!pdev->msix_cap || dev_is_pf(dev))
+		return 0;
+
+	return a->mode;
+}
+
+static const struct attribute_group sriov_pf_dev_attr_group = {
+	.attrs = sriov_pf_dev_attrs,
+	.is_visible = sriov_pf_attrs_are_visible,
+	.name = "vfs_overlay",
+};
+
+static const struct attribute_group sriov_vf_dev_attr_group = {
+	.attrs = sriov_vf_dev_attrs,
+	.is_visible = sriov_vf_attrs_are_visible,
+	.name = "vfs_overlay",
+};
+
+int pci_enable_vfs_overlay(struct pci_dev *dev)
+{
+	struct pci_dev *virtfn;
+	int id, ret;
+
+	if (!dev->is_physfn || !dev->sriov->num_VFs)
+		return 0;
+
+	ret = sysfs_create_group(&dev->dev.kobj, &sriov_pf_dev_attr_group);
+	if (ret)
+		return ret;
+
+	for (id = 0; id < dev->sriov->num_VFs; id++) {
+		virtfn = pci_get_domain_bus_and_slot(
+			pci_domain_nr(dev->bus), pci_iov_virtfn_bus(dev, id),
+			pci_iov_virtfn_devfn(dev, id));
+
+		if (!virtfn)
+			continue;
+
+		ret = sysfs_create_group(&virtfn->dev.kobj,
+					 &sriov_vf_dev_attr_group);
+		if (ret)
+			goto out;
+	}
+	return 0;
+
+out:
+	while (id--) {
+		virtfn = pci_get_domain_bus_and_slot(
+			pci_domain_nr(dev->bus), pci_iov_virtfn_bus(dev, id),
+			pci_iov_virtfn_devfn(dev, id));
+
+		if (!virtfn)
+			continue;
+
+		sysfs_remove_group(&virtfn->dev.kobj, &sriov_vf_dev_attr_group);
+	}
+	sysfs_remove_group(&dev->dev.kobj, &sriov_pf_dev_attr_group);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pci_enable_vfs_overlay);
+
+void pci_disable_vfs_overlay(struct pci_dev *dev)
+{
+	struct pci_dev *virtfn;
+	int id;
+
+	if (!dev->is_physfn || !dev->sriov->num_VFs)
+		return;
+
+	id = dev->sriov->num_VFs;
+	while (id--) {
+		virtfn = pci_get_domain_bus_and_slot(
+			pci_domain_nr(dev->bus), pci_iov_virtfn_bus(dev, id),
+			pci_iov_virtfn_devfn(dev, id));
+
+		if (!virtfn)
+			continue;
+
+		sysfs_remove_group(&virtfn->dev.kobj, &sriov_vf_dev_attr_group);
+	}
+	sysfs_remove_group(&dev->dev.kobj, &sriov_pf_dev_attr_group);
+}
+EXPORT_SYMBOL_GPL(pci_disable_vfs_overlay);
+
 int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 {
 	int i;
@@ -596,6 +757,7 @@ static void sriov_disable(struct pci_dev *dev)
 		sysfs_remove_link(&dev->dev.kobj, "dep_link");

 	iov->num_VFs = 0;
+	iov->vf_total_msix = 0;
 	pci_iov_set_numvfs(dev, 0);
 }

@@ -1054,6 +1216,24 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);

+/**
+ * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
+ * @dev: the PCI PF device
+ * @count: the total number of MSI-X vector to consume by the VFs
+ *
+ * Sets the number of MSI-X vectors that is possible to consume by the VFs.
+ * This interface is complimentary part of the pci_vf_set_msix_vec_count()
+ * that will be used to configure the required number on the VF.
+ */
+void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count)
+{
+	if (!dev->is_physfn)
+		return;
+
+	dev->sriov->vf_total_msix = count;
+}
+EXPORT_SYMBOL_GPL(pci_sriov_set_vf_total_msix);
+
 /**
  * pci_sriov_configure_simple - helper to configure SR-IOV
  * @dev: the PCI device
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 3162f88fe940..1022fe9e6efd 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -991,6 +991,53 @@ int pci_msix_vec_count(struct pci_dev *dev)
 }
 EXPORT_SYMBOL(pci_msix_vec_count);

+/**
+ * pci_vf_set_msix_vec_count - change the reported number of MSI-X vectors
+ * This function is applicable for SR-IOV VF because such devices allocate
+ * their MSI-X table before they will run on the VMs and HW can't guess the
+ * right number of vectors, so the HW allocates them statically and equally.
+ * @dev: VF device that is going to be changed
+ * @count: amount of MSI-X vectors
+ **/
+int pci_vf_set_msix_vec_count(struct pci_dev *dev, int count)
+{
+	struct pci_dev *pdev = pci_physfn(dev);
+	int ret;
+
+	if (count < 0)
+		/*
+		 * We don't support negative numbers for now,
+		 * but maybe in the future it will make sense.
+		 */
+		return -EINVAL;
+
+	device_lock(&pdev->dev);
+	if (!pdev->driver) {
+		ret = -EOPNOTSUPP;
+		goto err_pdev;
+	}
+
+	device_lock(&dev->dev);
+	if (dev->driver) {
+		/*
+		 * Driver already probed this VF and configured itself
+		 * based on previously configured (or default) MSI-X vector
+		 * count. It is too late to change this field for this
+		 * specific VF.
+		 */
+		ret = -EBUSY;
+		goto err_dev;
+	}
+
+	ret = pdev->driver->sriov_set_msix_vec_count(dev, count);
+
+err_dev:
+	device_unlock(&dev->dev);
+err_pdev:
+	device_unlock(&pdev->dev);
+	return ret;
+}
+
 static int __pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries,
 			     int nvec, struct irq_affinity *affd, int flags)
 {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 5c59365092fa..2bd6560d91e2 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -183,6 +183,7 @@ extern unsigned int pci_pm_d3hot_delay;

 #ifdef CONFIG_PCI_MSI
 void pci_no_msi(void);
+int pci_vf_set_msix_vec_count(struct pci_dev *dev, int count);
 #else
 static inline void pci_no_msi(void) { }
 #endif
@@ -326,6 +327,9 @@ struct pci_sriov {
 	u16		subsystem_device; /* VF subsystem device */
 	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
 	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
+	u32		vf_total_msix;  /* Total number of MSI-X vectors the VFs
+					 * can consume
+					 */
 };

 /**
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b32126d26997..24d118ad6e7b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -856,6 +856,8 @@ struct module;
  *		e.g. drivers/net/e100.c.
  * @sriov_configure: Optional driver callback to allow configuration of
  *		number of VFs to enable via sysfs "sriov_numvfs" file.
+ * @sriov_set_msix_vec_count: Driver callback to change number of MSI-X vectors
+ *              exposed by the sysfs "vf_msix_vec" entry.
  * @err_handler: See Documentation/PCI/pci-error-recovery.rst
  * @groups:	Sysfs attribute groups.
  * @driver:	Driver model structure.
@@ -871,6 +873,7 @@ struct pci_driver {
 	int  (*resume)(struct pci_dev *dev);	/* Device woken up */
 	void (*shutdown)(struct pci_dev *dev);
 	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
+	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
 	const struct pci_error_handlers *err_handler;
 	const struct attribute_group **groups;
 	struct device_driver	driver;
@@ -2059,6 +2062,9 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
 int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
 int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);

+int pci_enable_vfs_overlay(struct pci_dev *dev);
+void pci_disable_vfs_overlay(struct pci_dev *dev);
+
 int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
 void pci_disable_sriov(struct pci_dev *dev);

@@ -2072,6 +2078,7 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev);
 int pci_sriov_configure_simple(struct pci_dev *dev, int nr_virtfn);
 resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno);
 void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe);
+void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count);

 /* Arch may override these (weak) */
 int pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs);
@@ -2100,6 +2107,8 @@ static inline int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 }
 static inline void pci_iov_remove_virtfn(struct pci_dev *dev,
 					 int id) { }
+static inline int pci_enable_vfs_overlay(struct pci_dev *dev) { return 0; }
+static inline void pci_disable_vfs_overlay(struct pci_dev *dev) {}
 static inline void pci_disable_sriov(struct pci_dev *dev) { }
 static inline int pci_num_vf(struct pci_dev *dev) { return 0; }
 static inline int pci_vfs_assigned(struct pci_dev *dev)
@@ -2112,6 +2121,7 @@ static inline int pci_sriov_get_totalvfs(struct pci_dev *dev)
 static inline resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno)
 { return 0; }
 static inline void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe) { }
+static inline void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count) {}
 #endif

 #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)
--
2.29.2

