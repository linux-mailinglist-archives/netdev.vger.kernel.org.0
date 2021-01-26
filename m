Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8B4304735
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 19:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390426AbhAZRIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:08:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:53676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390537AbhAZI6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 03:58:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2FF3230FC;
        Tue, 26 Jan 2021 08:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611651455;
        bh=JAkZWzoFVc/4aeT+y5JDmRQyFWQ/0bllo+5oGyiqzEg=;
        h=From:To:Cc:Subject:Date:From;
        b=WDHNyT96TtepU0zetviXWikwpqssSGufbRJTDIquQKujtXkjSAcSPyNGEMJr6x4CA
         wRmF81QEcdpufg0POGWTPKHfEiVXJCC4j6BT7GvEFES+QsG8f1HCt7atza/HIT9N9Q
         QRUn6Uc0amo2etDApPt/cERCOobb8V+QMy4DJ/5Q1uoqcYQWeP2tD+mNiTXprZ+FsD
         mSUoJe8oukhGD9VVgCSjEFkRYNTH7nayeVcdaIqdCMJo0vTfPvRSIBLh/k9asyeTTI
         dsbGUGpq1dROy7wPUNIDIBbAX0x1P1O6MmxQwv9BBEXAYFQUNi95IqOzTWSgHtiPVC
         Eu0IDWOxc4mKw==
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
Subject: [PATCH mlx5-next v5 0/4] Dynamically assign MSI-X vectors count
Date:   Tue, 26 Jan 2021 10:57:26 +0200
Message-Id: <20210126085730.1165673-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog
v5:
 * Patch 1:
  * Added forgotten "inline" keyword when declaring empty functions.
v4: https://lore.kernel.org/linux-pci/20210124131119.558563-1-leon@kernel.org
 * Used sysfs_emit() instead of sprintf() in new sysfs entries.
 * Changed EXPORT_SYMBOL to be EXPORT_SYMBOL_GPL for pci_iov_virtfn_devfn().
 * Rewrote sysfs registration code to be driven by PF that wants to enable VF
   overlay instead of creating to all SR-IOV devices.
 * Grouped all such functionality under new "vfs_overlay" folder.
 * Combined two PCI patches into one.
v3: https://lore.kernel.org/linux-pci/20210117081548.1278992-1-leon@kernel.org
 * Renamed pci_set_msix_vec_count to be pci_vf_set_msix_vec_count.
 * Added VF msix_cap check to hide sysfs entry if device doesn't support msix.
 * Changed "-" to be ":" in the mlx5 patch to silence CI warnings about missing
   kdoc description.
 * Split differently error print in mlx5 driver to avoid checkpatch warning.
v2: https://lore.kernel.org/linux-pci/20210114103140.866141-1-leon@kernel.org
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
  * Changed vf_total_msix from int to be u32 and updated function signatures
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
echo 21 > /sys/bus/pci/devices/0000\:08\:00.2/vfs_overlay/sriov_vf_msix_count

After this series:
[root@server ~]# lspci -vs 0000:08:00.2
08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
....
        Capabilities: [9c] MSI-X: Enable- Count=21 Masked-

Thanks

Leon Romanovsky (4):
  PCI: Add sysfs callback to allow MSI-X table size change of SR-IOV VFs
  net/mlx5: Add dynamic MSI-X capabilities bits
  net/mlx5: Dynamically assign MSI-X vectors count
  net/mlx5: Allow to the users to configure number of MSI-X vectors

 Documentation/ABI/testing/sysfs-bus-pci       |  32 ++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  16 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   6 +
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  72 +++++++
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  59 +++++-
 drivers/pci/iov.c                             | 180 ++++++++++++++++++
 drivers/pci/msi.c                             |  47 +++++
 drivers/pci/pci.h                             |   4 +
 include/linux/mlx5/mlx5_ifc.h                 |  11 +-
 include/linux/pci.h                           |  10 +
 10 files changed, 434 insertions(+), 3 deletions(-)

--
2.29.2

