Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCA331504F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBINfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:35:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229754AbhBINfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 08:35:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E032364ECC;
        Tue,  9 Feb 2021 13:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612877690;
        bh=fXqWep+KN2b7Xc3+f00vVLhERkWSLlkL3KBQF0E6Vnc=;
        h=From:To:Cc:Subject:Date:From;
        b=mwLmX9w4rWb9Ru7Ff7ZhbmOGl4CLd8TM27NFg9V4NdaAIFxhn+ptpnLfd94Hzaplb
         XSIK7Mk4YVtUlZkZgUAi3SQo8Iwc6hUNfUry4PDHna/oEARBeZjQXSr2Pl778142s6
         2EhIzWxtcGHqrU1GrrOEqvqc7XRZr0XzagE4gHZQcAkJEKRqe3LNk4Yc3/N1+4WzT0
         nxo19pnNW8qAO3D/2xTyDUajOsGOyKbCvaVP9BOA6pSqeCpCmB5VmCvmgLcKlHIViC
         01IV5YaOeL/LuPpEVidR5uS/tQFrHrHwOoGzsH03MgVvlsZVfb1iM5Tmhi8mp4v5IN
         cv4MpcgePExoQ==
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
Subject: [PATCH mlx5-next v6 0/4] Dynamically assign MSI-X vectors count
Date:   Tue,  9 Feb 2021 15:34:41 +0200
Message-Id: <20210209133445.700225-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog
v6:
 * Patch 1:
   * English fixes
   * Moved pci_vf_set_msix_vec_count() from msi.c to iov.c
   * Embedded pci_vf_set_msix_vec_count() into sriov_vf_msix_count_store
   * Deleted sriov_vf_msix_count_show
   * Deleted vfs_overlay folder
   * Renamed functions *_vfs_overlay_* to be *_vf_overlay_*
   * Deleted is_supported and attribute_group because it confused people more than
     it gave advantage.
   * Changed vf_total_msix to be callback
 * Patch 3:
   * Fixed english as suggested by Bjorn
   * Added more explanations to the commit message
 * Patch 4:
   * Protected enable/disable with capability check
v5: https://lore.kernel.org/linux-pci/20210126085730.1165673-1-leon@kernel.org
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
echo 21 > /sys/bus/pci/devices/0000\:08\:00.2/sriov_vf_msix_count

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

 Documentation/ABI/testing/sysfs-bus-pci       |  28 ++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  17 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  27 ++++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  72 +++++++++
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  58 ++++++-
 drivers/pci/iov.c                             | 153 ++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                 |  11 +-
 include/linux/pci.h                           |  12 ++
 8 files changed, 375 insertions(+), 3 deletions(-)

--
2.29.2

