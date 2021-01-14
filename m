Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653CB2F5EC9
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbhANKcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:32:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbhANKc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 05:32:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85E9323A50;
        Thu, 14 Jan 2021 10:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610620309;
        bh=UdJk4fZTxC/iYufSYNsjhaT7jJsMkLvcYAqYQsA7WO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGvf3QQoapHuEil9LcvF+CXv6LL+Hf8J4fqjcFHlpU2b1DcmSfvQkROLeMGHOdypI
         WsPTQxK6qH7JEbQNjkVtd5ZNDMxg5qzVHvhsiLg4iPfQJL7ZIQZKCerKDB4074hrS2
         yWt8rwhF4wcGWJqHi2aZDkNIrev7AZ5jovdChkYAeUDno9dptLqykLliU7toFyO+1c
         8LkOAbr6+8pRjffyLaY+lDYjLJvWGGDz1LFWrZecjIiEfvyrp1caMs9tXChmJIcDya
         quLzWB3R0T0BBD+Qwv5skFKZ9k/ffGB8SqvOeURXILmvdo7ZNVjQNkuZ4E5rD3niFk
         bqqow7KSym5tA==
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
Subject: [PATCH mlx5-next v2 2/5] PCI: Add SR-IOV sysfs entry to read total number of dynamic MSI-X vectors
Date:   Thu, 14 Jan 2021 12:31:37 +0200
Message-Id: <20210114103140.866141-3-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114103140.866141-1-leon@kernel.org>
References: <20210114103140.866141-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Some SR-IOV capable devices provide an ability to configure specific
number of MSI-X vectors on their VF prior driver is probed on that VF.

In order to make management easy, provide new read-only sysfs file that
returns a total number of possible to configure MSI-X vectors.

cat /sys/bus/pci/devices/.../sriov_vf_total_msix
  = 0 - feature is not supported
  > 0 - total number of MSI-X vectors to consume by the VFs

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/ABI/testing/sysfs-bus-pci | 14 +++++++++++
 drivers/pci/iov.c                       | 31 +++++++++++++++++++++++++
 drivers/pci/pci.h                       |  3 +++
 include/linux/pci.h                     |  2 ++
 4 files changed, 50 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 34a8c6bcde70..530c249cc3da 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -395,3 +395,17 @@ Description:
 		The file is writable if the PF is bound to a driver that
 		set sriov_vf_total_msix > 0 and there is no driver bound
 		to the VF.
+
+What:		/sys/bus/pci/devices/.../sriov_vf_total_msix
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
+
+		If no SR-IOV VFs are enabled, this value will return 0.
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 5bc496f8ffa3..f9dc31947dbc 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -394,12 +394,22 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
 	return count;
 }

+static ssize_t sriov_vf_total_msix_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sprintf(buf, "%u\n", pdev->sriov->vf_total_msix);
+}
+
 static DEVICE_ATTR_RO(sriov_totalvfs);
 static DEVICE_ATTR_RW(sriov_numvfs);
 static DEVICE_ATTR_RO(sriov_offset);
 static DEVICE_ATTR_RO(sriov_stride);
 static DEVICE_ATTR_RO(sriov_vf_device);
 static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
+static DEVICE_ATTR_RO(sriov_vf_total_msix);

 static struct attribute *sriov_dev_attrs[] = {
 	&dev_attr_sriov_totalvfs.attr,
@@ -408,6 +418,7 @@ static struct attribute *sriov_dev_attrs[] = {
 	&dev_attr_sriov_stride.attr,
 	&dev_attr_sriov_vf_device.attr,
 	&dev_attr_sriov_drivers_autoprobe.attr,
+	&dev_attr_sriov_vf_total_msix.attr,
 	NULL,
 };

@@ -654,6 +665,7 @@ static void sriov_disable(struct pci_dev *dev)
 		sysfs_remove_link(&dev->dev.kobj, "dep_link");

 	iov->num_VFs = 0;
+	iov->vf_total_msix = 0;
 	pci_iov_set_numvfs(dev, 0);
 }

@@ -1112,6 +1124,25 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_sriov_get_totalvfs);

+/**
+ * pci_sriov_set_vf_total_msix - set total number of MSI-X vectors for the VFs
+ * @dev: the PCI PF device
+ * @count: the total number of MSI-X vector to consume by the VFs
+ *
+ * Sets the number of MSI-X vectors that is possible to consume by the VFs.
+ * This interface is complimentary part of the pci_set_msix_vec_count()
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
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index dbbfa9e73ea8..604e1f9172c2 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -327,6 +327,9 @@ struct pci_sriov {
 	u16		subsystem_device; /* VF subsystem device */
 	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
 	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
+	u32		vf_total_msix;  /* Total number of MSI-X vectors the VFs
+					 * can consume
+					 */
 };

 /**
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6be96d468eda..c950513558b8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2075,6 +2075,7 @@ int pci_sriov_get_totalvfs(struct pci_dev *dev);
 int pci_sriov_configure_simple(struct pci_dev *dev, int nr_virtfn);
 resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno);
 void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe);
+void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count);

 /* Arch may override these (weak) */
 int pcibios_sriov_enable(struct pci_dev *pdev, u16 num_vfs);
@@ -2115,6 +2116,7 @@ static inline int pci_sriov_get_totalvfs(struct pci_dev *dev)
 static inline resource_size_t pci_iov_resource_size(struct pci_dev *dev, int resno)
 { return 0; }
 static inline void pci_vf_drivers_autoprobe(struct pci_dev *dev, bool probe) { }
+static inline void pci_sriov_set_vf_total_msix(struct pci_dev *dev, u32 count) {}
 #endif

 #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)
--
2.29.2

