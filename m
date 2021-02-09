Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5ED331505B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhBINf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230208AbhBINfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 08:35:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC1C564EDA;
        Tue,  9 Feb 2021 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612877704;
        bh=JBhprM4DIDADxeTeqD6MW59O69WywX5uOcYWV/jADd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V80fYHx/7+xncRsX3aBxC0HO69IxgnZq/34phC6vPKqXjm/D1blfRpwEtDd11fsHl
         kmwMooMYbNuyxcPc19n3rVQmCLlLhv49koepXgCt8uKUiiBwMjDkPkojFSqfpnm6OL
         eji/gn1C6MhRMFyC4W5PYcvocHHNmS0D53mkIH28D+KIJlOVoO/wbIRdXltJlFK5Jk
         9LWFbBAy4cxmQCGkb5iAk3Irt/5peUqog/an+RuQlbx772XuId8uLywyH78/BSg06y
         4ImlLL/6dKDOBJOLV4QalXYBRjzbu3GQRneF2tZUsMWjnD0rVPAYf5JMyJi/ImzNq7
         1Qc+VMRGo46EQ==
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
Subject: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X table size change of SR-IOV VFs
Date:   Tue,  9 Feb 2021 15:34:42 +0200
Message-Id: <20210209133445.700225-2-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209133445.700225-1-leon@kernel.org>
References: <20210209133445.700225-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Extend PCI sysfs interface with a new callback that allows configuration
of the number of MSI-X vectors for specific SR-IOV VF. This is needed
to optimize the performance of VFs devices by allocating the number of
vectors based on the administrator knowledge of the intended use of the VF.

This function is applicable for SR-IOV VF because such devices allocate
their MSI-X table before they will run on the VMs and HW can't guess the
right number of vectors, so some devices allocate them statically and equally.

1) The newly added /sys/bus/pci/devices/.../sriov_vf_msix_count
file will be seen for the VFs and it is writable as long as a driver is not
bound to the VF.

The values accepted are:
 * > 0 - this will be number reported by the Table Size in the VF's MSI-X Message
         Control register
 * < 0 - not valid
 * = 0 - will reset to the device default value

2) In order to make management easy, provide new read-only sysfs file that
returns a total number of possible to configure MSI-X vectors.

cat /sys/bus/pci/devices/.../sriov_vf_total_msix
  = 0 - feature is not supported
  > 0 - total number of MSI-X vectors available for distribution among the VFs

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/ABI/testing/sysfs-bus-pci |  28 +++++
 drivers/pci/iov.c                       | 153 ++++++++++++++++++++++++
 include/linux/pci.h                     |  12 ++
 3 files changed, 193 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 25c9c39770c6..7dadc3610959 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -375,3 +375,31 @@ Description:
 		The value comes from the PCI kernel device state and can be one
 		of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
 		The file is read only.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_total_msix
+Date:		January 2021
+Contact:	Leon Romanovsky <leonro@nvidia.com>
+Description:
+		This file is associated with the SR-IOV PFs.
+		It contains the total number of MSI-X vectors available for
+		assignment to all VFs associated with this PF. It may be zero
+		if the device doesn't support this functionality.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_msix_count
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
+		implements ->sriov_set_msix_vec_count().
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 4afd4ee4f7f0..c0554aa6b90a 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
 	return (dev->devfn + dev->sriov->offset +
 		dev->sriov->stride * vf_id) & 0xff;
 }
+EXPORT_SYMBOL_GPL(pci_iov_virtfn_devfn);

 /*
  * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
@@ -157,6 +158,158 @@ int pci_iov_sysfs_link(struct pci_dev *dev,
 	return rc;
 }

+#ifdef CONFIG_PCI_MSI
+static ssize_t sriov_vf_msix_count_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct pci_dev *vf_dev = to_pci_dev(dev);
+	struct pci_dev *pdev = pci_physfn(vf_dev);
+	int val, ret;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val < 0)
+		return -EINVAL;
+
+	device_lock(&pdev->dev);
+	if (!pdev->driver || !pdev->driver->sriov_set_msix_vec_count) {
+		ret = -EOPNOTSUPP;
+		goto err_pdev;
+	}
+
+	device_lock(&vf_dev->dev);
+	if (vf_dev->driver) {
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
+	ret = pdev->driver->sriov_set_msix_vec_count(vf_dev, val);
+
+err_dev:
+	device_unlock(&vf_dev->dev);
+err_pdev:
+	device_unlock(&pdev->dev);
+	return ret ? : count;
+}
+static DEVICE_ATTR_WO(sriov_vf_msix_count);
+
+static ssize_t sriov_vf_total_msix_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u32 vf_total_msix;
+
+	device_lock(dev);
+	if (!pdev->driver || !pdev->driver->sriov_get_vf_total_msix) {
+		device_unlock(dev);
+		return -EOPNOTSUPP;
+	}
+	vf_total_msix = pdev->driver->sriov_get_vf_total_msix(pdev);
+	device_unlock(dev);
+
+	return sysfs_emit(buf, "%u\n", vf_total_msix);
+}
+static DEVICE_ATTR_RO(sriov_vf_total_msix);
+#endif
+
+static const struct attribute *sriov_pf_dev_attrs[] = {
+#ifdef CONFIG_PCI_MSI
+	&dev_attr_sriov_vf_total_msix.attr,
+#endif
+	NULL,
+};
+
+static const struct attribute *sriov_vf_dev_attrs[] = {
+#ifdef CONFIG_PCI_MSI
+	&dev_attr_sriov_vf_msix_count.attr,
+#endif
+	NULL,
+};
+
+/*
+ * The PF can change the specific properties of associated VFs. Such
+ * functionality is usually known after PF probed and PCI sysfs files
+ * were already created.
+ *
+ * The function below is driven by such PF. It adds sysfs files to already
+ * existing PF/VF sysfs device hierarchies.
+ */
+int pci_enable_vf_overlay(struct pci_dev *dev)
+{
+	struct pci_dev *virtfn;
+	int id, ret;
+
+	if (!dev->is_physfn || !dev->sriov->num_VFs)
+		return 0;
+
+	ret = sysfs_create_files(&dev->dev.kobj, sriov_pf_dev_attrs);
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
+		ret = sysfs_create_files(&virtfn->dev.kobj,
+					 sriov_vf_dev_attrs);
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
+		sysfs_remove_files(&virtfn->dev.kobj, sriov_vf_dev_attrs);
+	}
+	sysfs_remove_files(&dev->dev.kobj, sriov_pf_dev_attrs);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pci_enable_vf_overlay);
+
+void pci_disable_vf_overlay(struct pci_dev *dev)
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
+		sysfs_remove_files(&virtfn->dev.kobj, sriov_vf_dev_attrs);
+	}
+	sysfs_remove_files(&dev->dev.kobj, sriov_pf_dev_attrs);
+}
+EXPORT_SYMBOL_GPL(pci_disable_vf_overlay);
+
 int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 {
 	int i;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b32126d26997..732611937574 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -856,6 +856,11 @@ struct module;
  *		e.g. drivers/net/e100.c.
  * @sriov_configure: Optional driver callback to allow configuration of
  *		number of VFs to enable via sysfs "sriov_numvfs" file.
+ * @sriov_set_msix_vec_count: Driver callback to change number of MSI-X vectors
+ *              to configure via sysfs "sriov_vf_msix_count" entry. This will
+ *              change MSI-X Table Size in their Message Control registers.
+ * @sriov_get_vf_total_msix: Total number of MSI-X veectors to distribute
+ *              to the VFs
  * @err_handler: See Documentation/PCI/pci-error-recovery.rst
  * @groups:	Sysfs attribute groups.
  * @driver:	Driver model structure.
@@ -871,6 +876,8 @@ struct pci_driver {
 	int  (*resume)(struct pci_dev *dev);	/* Device woken up */
 	void (*shutdown)(struct pci_dev *dev);
 	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
+	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
+	u32  (*sriov_get_vf_total_msix)(struct pci_dev *pf);
 	const struct pci_error_handlers *err_handler;
 	const struct attribute_group **groups;
 	struct device_driver	driver;
@@ -2059,6 +2066,9 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
 int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
 int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);

+int pci_enable_vf_overlay(struct pci_dev *dev);
+void pci_disable_vf_overlay(struct pci_dev *dev);
+
 int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
 void pci_disable_sriov(struct pci_dev *dev);

@@ -2100,6 +2110,8 @@ static inline int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 }
 static inline void pci_iov_remove_virtfn(struct pci_dev *dev,
 					 int id) { }
+static inline int pci_enable_vf_overlay(struct pci_dev *dev) { return 0; }
+static inline void pci_disable_vf_overlay(struct pci_dev *dev) { }
 static inline void pci_disable_sriov(struct pci_dev *dev) { }
 static inline int pci_num_vf(struct pci_dev *dev) { return 0; }
 static inline int pci_vfs_assigned(struct pci_dev *dev)
--
2.29.2

