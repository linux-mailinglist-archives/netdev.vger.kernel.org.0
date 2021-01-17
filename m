Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201022F916D
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbhAQIhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 03:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbhAQIR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Jan 2021 03:17:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFEC622AAF;
        Sun, 17 Jan 2021 08:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610871355;
        bh=Y3jtDDuewMie3zEHgesnQv7tVoan2GlS4OV7/EzIYT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofm9QITPytBS2LV94SIhGFtfx5t58XfBL70ahxFn69YF0BDw0pFsIuDE9sjczOYf1
         buSKh6UJQnckZGTQBUEMp9QDixeMcFWYVBHmbpfX6YNX/dtKl4dZBmhN1Pf6W2jnT+
         44k/fARCrsc4ACBnPx/BcCDT4h2gH0o9gcGMqcZ30owqtXWOi96WSMTAh8UsePWFU0
         8KYLIxTXiq/AUfTsauq7hEK7XcCHp1i2eacnTJXfFlzA/fDI8VFGmS7lDQunh5JOQX
         sL6KGIdUjdy/wRkScTplhBRkfaAtOs1V904jjR/Dk+PDABQqN5/EYgP6txNnq4GZVh
         BlNSAh9Zuo+RQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH mlx5-next v3 1/5] PCI: Add sysfs callback to allow MSI-X table size change of SR-IOV VFs
Date:   Sun, 17 Jan 2021 10:15:44 +0200
Message-Id: <20210117081548.1278992-2-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117081548.1278992-1-leon@kernel.org>
References: <20210117081548.1278992-1-leon@kernel.org>
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

The newly added /sys/bus/pci/devices/.../sriov_vf_msix_count file will be seen
for the VFs and it is writable as long as a driver is not bounded to the VF.

The values accepted are:
 * > 0 - this will be number reported by the VF's MSI-X capability
 * < 0 - not valid
 * = 0 - will reset to the device default value

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/ABI/testing/sysfs-bus-pci | 20 ++++++
 drivers/pci/iov.c                       | 82 +++++++++++++++++++++++++
 drivers/pci/msi.c                       | 47 ++++++++++++++
 drivers/pci/pci-sysfs.c                 |  1 +
 drivers/pci/pci.h                       |  2 +
 include/linux/pci.h                     |  3 +
 6 files changed, 155 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 25c9c39770c6..34a8c6bcde70 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -375,3 +375,23 @@ Description:
 		The value comes from the PCI kernel device state and can be one
 		of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
 		The file is read only.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_msix_count
+Date:		December 2020
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
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 4afd4ee4f7f0..b8d7a3b26f87 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
 	return (dev->devfn + dev->sriov->offset +
 		dev->sriov->stride * vf_id) & 0xff;
 }
+EXPORT_SYMBOL(pci_iov_virtfn_devfn);

 /*
  * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
@@ -426,6 +427,68 @@ const struct attribute_group sriov_dev_attr_group = {
 	.is_visible = sriov_attrs_are_visible,
 };

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
+	return sprintf(buf, "%d\n", count);
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
+#endif
+
+static struct attribute *sriov_vf_dev_attrs[] = {
+#ifdef CONFIG_PCI_MSI
+	&dev_attr_sriov_vf_msix_count.attr,
+#endif
+	NULL,
+};
+
+static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
+					  struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct pci_dev *vf_dev;
+
+	if (dev_is_pf(dev))
+		return 0;
+
+	vf_dev = to_pci_dev(dev);
+	if (!vf_dev->msix_cap)
+		return 0;
+
+	return a->mode;
+}
+
+const struct attribute_group sriov_vf_dev_attr_group = {
+	.attrs = sriov_vf_dev_attrs,
+	.is_visible = sriov_vf_attrs_are_visible,
+};
+
 int __weak pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs)
 {
 	return 0;
@@ -1054,6 +1117,25 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
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
+	if (!dev->is_physfn || !dev->driver ||
+	    !dev->driver->sriov_set_msix_vec_count)
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
index 3162f88fe940..05a9dfc3397b 100644
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
+ * @count amount of MSI-X vectors
+ **/
+int pci_vf_set_msix_vec_count(struct pci_dev *dev, int count)
+{
+	struct pci_dev *pdev = pci_physfn(dev);
+	int ret;
+
+	if (!dev->msix_cap || !pdev->msix_cap || count < 0)
+		/*
+		 * We don't support negative numbers for now,
+		 * but maybe in the future it will make sense.
+		 */
+		return -EINVAL;
+
+	device_lock(&pdev->dev);
+	if (!pdev->driver || !pdev->driver->sriov_set_msix_vec_count) {
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
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index fb072f4b3176..0af2222643c2 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1557,6 +1557,7 @@ static const struct attribute_group *pci_dev_attr_groups[] = {
 	&pci_dev_hp_attr_group,
 #ifdef CONFIG_PCI_IOV
 	&sriov_dev_attr_group,
+	&sriov_vf_dev_attr_group,
 #endif
 	&pci_bridge_attr_group,
 	&pcie_dev_attr_group,
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 5c59365092fa..a275018beb2f 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -183,6 +183,7 @@ extern unsigned int pci_pm_d3hot_delay;

 #ifdef CONFIG_PCI_MSI
 void pci_no_msi(void);
+int pci_vf_set_msix_vec_count(struct pci_dev *dev, int count);
 #else
 static inline void pci_no_msi(void) { }
 #endif
@@ -502,6 +503,7 @@ resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
 void pci_restore_iov_state(struct pci_dev *dev);
 int pci_iov_bus_range(struct pci_bus *bus);
 extern const struct attribute_group sriov_dev_attr_group;
+extern const struct attribute_group sriov_vf_dev_attr_group;
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b32126d26997..6be96d468eda 100644
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
--
2.29.2

