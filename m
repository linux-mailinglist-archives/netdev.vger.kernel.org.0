Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9AA2F915E
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbhAQIas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 03:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbhAQISo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Jan 2021 03:18:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3B8E23117;
        Sun, 17 Jan 2021 08:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610871373;
        bh=Lqh0arX0NEl7b5m4Rupx4QpA8Brpze8+gpRhWSqpqic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QObouvgM3AAcDDZ/Bru8T9qsoVpWSuGXZBGVy8u09OZR7B1juBISadmLBsPPpu6Zp
         Rx+RfHFt7+TE2voQs2aq4V+6nOEezwhA3Mnmjk1i9G0glHPYMMyVQiplJsBNa9uXqD
         xD4jS5UqLPf4UoYJ/MN/vrlr7fhcKhZPwveoJ2MCRnPat6uF6t2IOoPoWEGRCYC9DD
         AMGvNfCI+8Nxw10aFGq/R4C8zJuS/BFC4ORTVikZfZAUt49NdmE3mI/PT5GXdJr9ca
         oTHhzMWMyIAcXXD4Deux4gMk9JreG9WZNqT9BWCqGAFYic265NUCrj1858beoTH3yz
         V2PNXQABHHw7g==
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
Subject: [PATCH mlx5-next v3 2/5] PCI: Add SR-IOV sysfs entry to read total number of dynamic MSI-X vectors
Date:   Sun, 17 Jan 2021 10:15:45 +0200
Message-Id: <20210117081548.1278992-3-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117081548.1278992-1-leon@kernel.org>
References: <20210117081548.1278992-1-leon@kernel.org>
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
 Documentation/ABI/testing/sysfs-bus-pci | 14 ++++++++++++++
 drivers/pci/iov.c                       | 12 ++++++++++++
 drivers/pci/pci.h                       |  3 +++
 include/linux/pci.h                     |  2 ++
 4 files changed, 31 insertions(+)

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
index b8d7a3b26f87..6660632b7a14 100644
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

@@ -659,6 +670,7 @@ static void sriov_disable(struct pci_dev *dev)
 		sysfs_remove_link(&dev->dev.kobj, "dep_link");

 	iov->num_VFs = 0;
+	iov->vf_total_msix = 0;
 	pci_iov_set_numvfs(dev, 0);
 }

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index a275018beb2f..444e03ce9c97 100644
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

