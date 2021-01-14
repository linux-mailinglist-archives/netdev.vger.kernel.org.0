Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B02C2F5EC7
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbhANKc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbhANKc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 05:32:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFE0223A40;
        Thu, 14 Jan 2021 10:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610620305;
        bh=JgQMe5VQW8Sc0fkd5NJhBQda6O3r+0lLU6OD5uVEKG4=;
        h=From:To:Cc:Subject:Date:From;
        b=RxxySrGPl7SB79DNlTCkWb6Z7U2TNwOgx/GZC4Id83x/TAdvaj6WJpfoZeeyOo9WG
         FSRFIH2aEa5oUrf0RMwHYt5W/ESHuBM6k5HidxsxzekuRIzXcxE4ZnL4YRps9/KFMa
         BYFsWbTGQoOC1bV6hj1wIcwoeRusCTa64vWc8EsvI0SScN34/sK7PCFqZNlTDcbtgX
         5ntThtMmzd02S4AUHKRCsQtCnZLEuKfGILXNRWkqv3+SlRUyAYvVBqGbPJoC0RCCAh
         eaXEG0Y97C2u4uCYY/h1k9lEypnX6COlrEf7Zt75zORBATb6bAA9/4QdDNPMr+pC8c
         dKKuoRQSau6dQ==
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
Subject: [PATCH mlx5-next v2 0/5] Dynamically assign MSI-X vectors count
Date:   Thu, 14 Jan 2021 12:31:35 +0200
Message-Id: <20210114103140.866141-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog
v2:
 * Patch 1:
  * Renamed vf_msix_vec sysfs knob to be sriov_vf_msix_count
  * Added PF and VF device locks during set MSI-X call to protect from parallel
    driver bind/unbind operations.
  * Removed extra checks when reading sriov_vf_msix, because users will
    be able to distinguish between supported/not supported by looking on
    sriov_vf_total_msix count.
  * Changed all occurrences of "numb" to be "count"
  * Changed returned error from EOPNOTSUPP to be EBUSY if user tries to set
    MSI-X count after driver already bound to the VF.
  * Added extra comment in pci_set_msix_vec_count() to emphasize that driver
    should not be bound.
 * Patch 2:
  * Chaged vf_total_msix from int to be u32 and updated function signatures
    accordingly.
  * Improved patch title
v1: https://lore.kernel.org/linux-pci/20210110150727.1965295-1-leon@kernel.org
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
echo 21 > /sys/bus/pci/devices/0000\:08\:00.2/sriov_vf_msix_count

After this series:
[root@server ~]# lspci -vs 0000:08:00.2
08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
....
        Capabilities: [9c] MSI-X: Enable- Count=21 Masked-

Thanks

Leon Romanovsky (5):
  PCI: Add sysfs callback to allow MSI-X table size change of SR-IOV VFs
  PCI: Add SR-IOV sysfs entry to read total number of dynamic MSI-X
    vectors
  net/mlx5: Add dynamic MSI-X capabilities bits
  net/mlx5: Dynamically assign MSI-X vectors count
  net/mlx5: Allow to the users to configure number of MSI-X vectors

 Documentation/ABI/testing/sysfs-bus-pci       | 34 +++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  5 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  6 ++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 62 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 52 ++++++++++-
 drivers/pci/iov.c                             | 89 +++++++++++++++++++
 drivers/pci/msi.c                             | 47 ++++++++++
 drivers/pci/pci-sysfs.c                       |  1 +
 drivers/pci/pci.h                             |  5 ++
 include/linux/mlx5/mlx5_ifc.h                 | 11 ++-
 include/linux/pci.h                           |  5 ++
 11 files changed, 314 insertions(+), 3 deletions(-)

--
2.29.2

