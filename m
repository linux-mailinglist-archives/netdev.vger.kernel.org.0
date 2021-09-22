Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2E41469F
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbhIVKks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234734AbhIVKkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 06:40:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 185B061211;
        Wed, 22 Sep 2021 10:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632307151;
        bh=Zadl6Tz0FhQmg6kXGXYq+M3fminDfVp/WJYOCet7ElI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tj9MYBxm7VeBHUWsrSjtKTY1ACo/vTmq3pah33yVHDgSsaHTXvQZLAF9FRNyZoBZw
         hYGQBqyj3Mu8Ymv8QnKj4zeF3ugeEJgHW8uHlDXGYDLfiz+rcjxOZtf0AwfqVcpwMf
         ioaWatENJY+6FTfYiGJGnGKmDI1ga8oX4IS+bZrJHv3wPyb0TtNEl1/Olti5nmLPNO
         zxXRLzPIt160WFdUxeIN0lw9PwT4MeRx8kmkAMBwiA8nQ/P25m0pOIXauRP0ylMl05
         avpd15AHvVluKQEYx/pZhZep1HE59BSu+bc3YQdfNQeTv8JlFFWlfMCIw5vhhKnQbw
         lGvZhpG0XvQMg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH mlx5-next 1/7] PCI/IOV: Provide internal VF index
Date:   Wed, 22 Sep 2021 13:38:50 +0300
Message-Id: <8d5bba9a6a1067989c3291fa2929528578812334.1632305919.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632305919.git.leonro@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The PCI core uses the VF index internally, often called the vf_id,
during the setup of the VF, eg pci_iov_add_virtfn().

This index is needed for device drivers that implement live migration
for their internal operations that configure/control their VFs.

Specifically, mlx5_vfio_pci driver that is introduced in coming patches
from this series needs it and not the bus/device/function which is
exposed today.

Add pci_iov_vf_id() which computes the vf_id by reversing the math that
was used to create the bus/device/function.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/iov.c   | 14 ++++++++++++++
 include/linux/pci.h |  7 ++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index dafdc652fcd0..e7751fa3fe0b 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -33,6 +33,20 @@ int pci_iov_virtfn_devfn(struct pci_dev *dev, int vf_id)
 }
 EXPORT_SYMBOL_GPL(pci_iov_virtfn_devfn);
 
+int pci_iov_vf_id(struct pci_dev *dev)
+{
+	struct pci_dev *pf;
+
+	if (!dev->is_virtfn)
+		return -EINVAL;
+
+	pf = pci_physfn(dev);
+	return (((dev->bus->number << 8) + dev->devfn) -
+		((pf->bus->number << 8) + pf->devfn + pf->sriov->offset)) /
+	       pf->sriov->stride;
+}
+EXPORT_SYMBOL_GPL(pci_iov_vf_id);
+
 /*
  * Per SR-IOV spec sec 3.3.10 and 3.3.11, First VF Offset and VF Stride may
  * change when NumVFs changes.
diff --git a/include/linux/pci.h b/include/linux/pci.h
index cd8aa6fce204..4d6c73506e18 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2153,7 +2153,7 @@ void __iomem *pci_ioremap_wc_bar(struct pci_dev *pdev, int bar);
 #ifdef CONFIG_PCI_IOV
 int pci_iov_virtfn_bus(struct pci_dev *dev, int id);
 int pci_iov_virtfn_devfn(struct pci_dev *dev, int id);
-
+int pci_iov_vf_id(struct pci_dev *dev);
 int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn);
 void pci_disable_sriov(struct pci_dev *dev);
 
@@ -2181,6 +2181,11 @@ static inline int pci_iov_virtfn_devfn(struct pci_dev *dev, int id)
 {
 	return -ENOSYS;
 }
+static inline int pci_iov_vf_id(struct pci_dev *dev)
+{
+	return -ENOSYS;
+}
+
 static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
 { return -ENODEV; }
 
-- 
2.31.1

