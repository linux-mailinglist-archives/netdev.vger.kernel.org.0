Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BF43278B2
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 08:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhCAH41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 02:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhCAH4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 02:56:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2055C64DBA;
        Mon,  1 Mar 2021 07:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614585338;
        bh=E/NvliJ8V6rMrYNJaK+NaUXbhGkFdbsQZxuiop0zAJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouN7Ijvbg+qSJ3fXCWIP58zLQNbF2P6rdC6iYRxKxFCQKA4Z1m+KLRc3WuuGaOzKy
         bbrGlcyLVc46ZiXuPKvEnh4U28mjbmZJ2oI5IztoopoJ7lqhnLOg6iiBNqdWuUTH8k
         /+EAkMuehpxDXuRziHkjcnUcKbiYoNfB51ZQ3yGckfatBLQ64auDyqehieyPaDWoxj
         HfgGLUTOSGphoOgpdMvHL60RcJfKtBFaqnVr6QUPgKFgVWygfNGur0FyH6SYftRJDy
         NkK6CYcGJIe1P5fpvujNVeeUC6KmBggiC/CCPAffpsT/SxdAX9zIMj8LrM1H3FTvkT
         TYJgheWQutLMQ==
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
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH mlx5-next v7 1/4] PCI: Add a sysfs file to change the MSI-X table size of SR-IOV VFs
Date:   Mon,  1 Mar 2021 09:55:21 +0200
Message-Id: <20210301075524.441609-2-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301075524.441609-1-leon@kernel.org>
References: <20210301075524.441609-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

A typical cloud provider SR-IOV use case is to create many VFs for use by
guest VMs. The VFs may not be assigned to a VM until a customer requests a
VM of a certain size, e.g., number of CPUs. A VF may need MSI-X vectors
proportional to the number of CPUs in the VM, but there is no standard way
to change the number of MSI-X vectors supported by a VF.

Some Mellanox ConnectX devices support dynamic assignment of MSI-X vectors
to SR-IOV VFs. This can be done by the PF driver after VFs are enabled,
and it can be done without affecting VFs that are already in use. The
hardware supports a limited pool of MSI-X vectors that can be assigned to
the PF or to individual VFs.  This is device-specific behavior that
requires support in the PF driver.

Add a read-only "sriov_vf_total_msix" sysfs file for the PF and a writable
"sriov_vf_msix_count" file for each VF. Management software may use these
to learn how many MSI-X vectors are available and to dynamically assign
them to VFs before the VFs are passed through to a VM.

If the PF driver implements the ->sriov_get_vf_total_msix() callback,
"sriov_vf_total_msix" contains the total number of MSI-X vectors available
for distribution among VFs.

If no driver is bound to the VF, writing "N" to "sriov_vf_msix_count" uses
the PF driver ->sriov_set_msix_vec_count() callback to assign "N" MSI-X
vectors to the VF.  When a VF driver subsequently reads the MSI-X Message
Control register, it will see the new Table Size "N".

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/ABI/testing/sysfs-bus-pci |  29 +++++++
 drivers/pci/iov.c                       | 102 ++++++++++++++++++++++--
 drivers/pci/pci-sysfs.c                 |   3 +-
 drivers/pci/pci.h                       |   3 +-
 include/linux/pci.h                     |   8 ++
 5 files changed, 137 insertions(+), 8 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 25c9c39770c6..ebabd0d2ae88 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -375,3 +375,32 @@ Description:
 		The value comes from the PCI kernel device state and can be one
 		of: "unknown", "error", "D0", D1", "D2", "D3hot", "D3cold".
 		The file is read only.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_total_msix
+Date:		January 2021
+Contact:	Leon Romanovsky <leonro@nvidia.com>
+Description:
+		This file is associated with a SR-IOV PF.  It contains the
+		total number of MSI-X vectors available for assignment to
+		all VFs associated with PF.  It will zero if the device
+		doesn't support this functionality. For supported devices,
+		the value will be constant and won't be changed after MSI-X
+		vectors assignment.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_msix_count
+Date:		January 2021
+Contact:	Leon Romanovsky <leonro@nvidia.com>
+Description:
+		This file is associated with a SR-IOV VF.  It allows
+		configuration of the number of MSI-X vectors for the VF.  This
+		allows devices that have a global pool of MSI-X vectors to
+		optimally divide them between VFs based on VF usage.
+
+		The values accepted are:
+		 * > 0 - this number will be reported as the Table Size in the
+			 VF's MSI-X capability
+		 * < 0 - not valid
+		 * = 0 - will reset to the device default value
+
+		The file is writable if the PF is bound to a driver that
+		implements ->sriov_set_msix_vec_count().
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 4afd4ee4f7f0..9bf6f52ad4d8 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -31,6 +31,7 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
 	return (dev->devfn + dev->sriov->offset +
 		dev->sriov->stride * vf_id) & 0xff;
 }
+EXPORT_SYMBOL_GPL(pci_iov_virtfn_devfn);

 /*
  * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
@@ -157,6 +158,92 @@ int pci_iov_sysfs_link(struct pci_dev *dev,
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
+		 * A driver is already attached to this VF and has configured
+		 * itself based on the current MSI-X vector count. Changing
+		 * the vector size could mess up the driver, so block it.
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
+	u32 vf_total_msix = 0;
+
+	device_lock(dev);
+	if (!pdev->driver || !pdev->driver->sriov_get_vf_total_msix)
+		goto unlock;
+
+	vf_total_msix = pdev->driver->sriov_get_vf_total_msix(pdev);
+unlock:
+	device_unlock(dev);
+	return sysfs_emit(buf, "%u\n", vf_total_msix);
+}
+static DEVICE_ATTR_RO(sriov_vf_total_msix);
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
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (!pdev->is_virtfn)
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
 int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 {
 	int i;
@@ -400,18 +487,21 @@ static DEVICE_ATTR_RO(sriov_stride);
 static DEVICE_ATTR_RO(sriov_vf_device);
 static DEVICE_ATTR_RW(sriov_drivers_autoprobe);

-static struct attribute *sriov_dev_attrs[] = {
+static struct attribute *sriov_pf_dev_attrs[] = {
 	&dev_attr_sriov_totalvfs.attr,
 	&dev_attr_sriov_numvfs.attr,
 	&dev_attr_sriov_offset.attr,
 	&dev_attr_sriov_stride.attr,
 	&dev_attr_sriov_vf_device.attr,
 	&dev_attr_sriov_drivers_autoprobe.attr,
+#ifdef CONFIG_PCI_MSI
+	&dev_attr_sriov_vf_total_msix.attr,
+#endif
 	NULL,
 };

-static umode_t sriov_attrs_are_visible(struct kobject *kobj,
-				       struct attribute *a, int n)
+static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
+					  struct attribute *a, int n)
 {
 	struct device *dev = kobj_to_dev(kobj);

@@ -421,9 +511,9 @@ static umode_t sriov_attrs_are_visible(struct kobject *kobj,
 	return a->mode;
 }

-const struct attribute_group sriov_dev_attr_group = {
-	.attrs = sriov_dev_attrs,
-	.is_visible = sriov_attrs_are_visible,
+const struct attribute_group sriov_pf_dev_attr_group = {
+	.attrs = sriov_pf_dev_attrs,
+	.is_visible = sriov_pf_attrs_are_visible,
 };

 int __weak pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs)
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index f8afd54ca3e1..a6b8fbbba6d2 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1567,7 +1567,8 @@ static const struct attribute_group *pci_dev_attr_groups[] = {
 	&pci_dev_attr_group,
 	&pci_dev_hp_attr_group,
 #ifdef CONFIG_PCI_IOV
-	&sriov_dev_attr_group,
+	&sriov_pf_dev_attr_group,
+	&sriov_vf_dev_attr_group,
 #endif
 	&pci_bridge_attr_group,
 	&pcie_dev_attr_group,
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index ef7c4661314f..afb87b917f07 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -501,7 +501,8 @@ void pci_iov_update_resource(struct pci_dev *dev, int resno);
 resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
 void pci_restore_iov_state(struct pci_dev *dev);
 int pci_iov_bus_range(struct pci_bus *bus);
-extern const struct attribute_group sriov_dev_attr_group;
+extern const struct attribute_group sriov_pf_dev_attr_group;
+extern const struct attribute_group sriov_vf_dev_attr_group;
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 86c799c97b77..9b575a676888 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -856,6 +856,12 @@ struct module;
  *		e.g. drivers/net/e100.c.
  * @sriov_configure: Optional driver callback to allow configuration of
  *		number of VFs to enable via sysfs "sriov_numvfs" file.
+ * @sriov_set_msix_vec_count: PF Driver callback to change number of MSI-X
+ *              vectors on a VF. Triggered via sysfs "sriov_vf_msix_count".
+ *              This will change MSI-X Table Size in the VF Message Control
+ *              registers.
+ * @sriov_get_vf_total_msix: PF driver callback to get the total number of
+ *              MSI-X vectors available for distribution to the VFs.
  * @err_handler: See Documentation/PCI/pci-error-recovery.rst
  * @groups:	Sysfs attribute groups.
  * @driver:	Driver model structure.
@@ -871,6 +877,8 @@ struct pci_driver {
 	int  (*resume)(struct pci_dev *dev);	/* Device woken up */
 	void (*shutdown)(struct pci_dev *dev);
 	int  (*sriov_configure)(struct pci_dev *dev, int num_vfs); /* On PF */
+	int  (*sriov_set_msix_vec_count)(struct pci_dev *vf, int msix_vec_count); /* On PF */
+	u32  (*sriov_get_vf_total_msix)(struct pci_dev *pf);
 	const struct pci_error_handlers *err_handler;
 	const struct attribute_group **groups;
 	struct device_driver	driver;
--
2.29.2

