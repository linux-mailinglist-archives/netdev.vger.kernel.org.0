Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF342F07CC
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbhAJPIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbhAJPIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 10:08:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0436F22AAE;
        Sun, 10 Jan 2021 15:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610291255;
        bh=/KQr93Nb3+WkS9tFMAKpr8ZV8pJbjLYVfQXkHGtQ+YI=;
        h=From:To:Cc:Subject:Date:From;
        b=IQJRvgztB7F4MGsqrF0FghjP/pJ/YpFO+s5veuGgEto0t2iLr3/dzako6ijctkonG
         OmiXXiZ+2hYPe4DNKukdr0/WcF/p/whOlkdqJz2T5iDEZ2F1K/auZt6BrjAG8kL73U
         ym3O/zVIMAAzG4mbjLZbBuGIaKyvAppieGryW/nDL64uovJU9/14Cc4brrF+ECZq5t
         mxdXDllJMB7k1s5QHBjLvL4nH2NURe5l+SjnAy4Pv4JlLuRMerJN0DLPlEC9fM1S6i
         c+vFxbC3rIjydLaKDbpta9gYlYA8Ur/t87crjUqb3upk9txFCfUgnpmp6CHn7yVTAd
         /NYRfNURI5aWA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH mlx5-next v1 0/5] Dynamically assign MSI-X vectors count
Date:   Sun, 10 Jan 2021 17:07:22 +0200
Message-Id: <20210110150727.1965295-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog
v1:
 * Improved wording and commit messages of first PCI patch
 * Added extra PCI patch to provide total number of MSI-X vectors
 * Prohibited read of vf_msix_vec sysfs file if driver doesn't support write
 * Removed extra function definition in pci.h
v0: https://lore.kernel.org/linux-pci/20210103082440.34994-1-leon@kernel.org

--------------------------------------------------------------------
Hi,

The number of MSI-X vectors is PCI property visible through lspci, that
field is read-only and configured by the device.

The static assignment of an amount of MSI-X vectors doesn't allow utilize
the newly created VF because it is not known to the device the future load
and configuration where that VF will be used.

The VFs are created on the hypervisor and forwarded to the VMs that have
different properties (for example number of CPUs).

To overcome the inefficiency in the spread of such MSI-X vectors, we
allow the kernel to instruct the device with the needed number of such
vectors, before VF is initialized and bounded to the driver.

Before this series:
[root@server ~]# lspci -vs 0000:08:00.2
08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
....
        Capabilities: [9c] MSI-X: Enable- Count=12 Masked-

Configuration script:
1. Start fresh
echo 0 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_numvfs
modprobe -q -r mlx5_ib mlx5_core
2. Ensure that driver doesn't run and it is safe to change MSI-X
echo 0 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_drivers_autoprobe
3. Load driver for the PF
modprobe mlx5_core
4. Configure one of the VFs with new number
echo 2 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_numvfs
echo 21 > /sys/bus/pci/devices/0000\:08\:00.2/vf_msix_vec

After this series:
[root@server ~]# lspci -vs 0000:08:00.2
08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
....
        Capabilities: [9c] MSI-X: Enable- Count=21 Masked-


Thanks

Leon Romanovsky (5):
  PCI: Add sysfs callback to allow MSI-X table size change of SR-IOV VFs
  PCI: Add SR-IOV sysfs entry to read number of MSI-X vectors
  net/mlx5: Add dynamic MSI-X capabilities bits
  net/mlx5: Dynamically assign MSI-X vectors count
  net/mlx5: Allow to the users to configure number of MSI-X vectors

 Documentation/ABI/testing/sysfs-bus-pci       | 34 +++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  5 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  6 ++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 62 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 52 ++++++++++-
 drivers/pci/iov.c                             | 93 +++++++++++++++++++
 drivers/pci/msi.c                             | 29 ++++++
 drivers/pci/pci-sysfs.c                       |  1 +
 drivers/pci/pci.h                             |  5 +
 include/linux/mlx5/mlx5_ifc.h                 | 11 ++-
 include/linux/pci.h                           | 10 +-
 11 files changed, 304 insertions(+), 4 deletions(-)

--
2.29.2

