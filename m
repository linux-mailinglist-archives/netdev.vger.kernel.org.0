Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2333531C1
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 02:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbhDCAZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 20:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234161AbhDCAZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 20:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5916C61185;
        Sat,  3 Apr 2021 00:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617409506;
        bh=nyVl1XWL5jdEwBH69HaHGBNx9VaqoAohN+AdM6vbWT4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ZPXuajVHaswNB2u6SWm0ca7crgkrqKzbWCNlFS6VDg6axrVZWMca3B2yfYdEWN4Jv
         bqFFZCNc9VGEBM/ZmChteUfdZGwxX5yqalTUQgnm5N63tmibSHK8ZAhfqbbr0ZfUtI
         qx/5+tmGXWto18fbu4xWivkFgWPnwq/z6mv1ieT1T1n//TFszeDfLCb9etOKj1OpfT
         l6DLxYlvfkZ+SNPfGhx0feaPTs5YwUEnQ8SGfaY9t+nS3gKIw8dJH58izF9OsWc8rS
         T0vL1/KWhUlqROgNKG7OMSrE/FAHYTGpVVxniU55dTsqccDfi0a8klQUB3usrgE+d7
         tDraSZM1TLgWA==
Date:   Fri, 2 Apr 2021 19:25:04 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v8 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210403002504.GA1560634@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314124256.70253-1-leon@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 02:42:52PM +0200, Leon Romanovsky wrote:
> ---------------------------------------------------------------------------------
> Changelog
> v8:
>  * Added "physical/virtual function" words near PF and VF acronyms.
> v7: https://lore.kernel.org/linux-pci/20210301075524.441609-1-leon@kernel.org
>  * Rebase on top v5.12-rc1
>  * More english fixes
>  * Returned to static sysfs creation model as was implemented in v0/v1.
> v6: https://lore.kernel.org/linux-pci/20210209133445.700225-1-leon@kernel.org
>  * Patch 1:
>    * English fixes
>    * Moved pci_vf_set_msix_vec_count() from msi.c to iov.c
>    * Embedded pci_vf_set_msix_vec_count() into sriov_vf_msix_count_store
>    * Deleted sriov_vf_msix_count_show
>    * Deleted vfs_overlay folder
>    * Renamed functions *_vfs_overlay_* to be *_vf_overlay_*
>    * Deleted is_supported and attribute_group because it confused people more than
>      it gave advantage.
>    * Changed vf_total_msix to be callback
>  * Patch 3:
>    * Fixed english as suggested by Bjorn
>    * Added more explanations to the commit message
>  * Patch 4:
>    * Protected enable/disable with capability check
> v5: https://lore.kernel.org/linux-pci/20210126085730.1165673-1-leon@kernel.org
>  * Patch 1:
>   * Added forgotten "inline" keyword when declaring empty functions.
> v4: https://lore.kernel.org/linux-pci/20210124131119.558563-1-leon@kernel.org
>  * Used sysfs_emit() instead of sprintf() in new sysfs entries.
>  * Changed EXPORT_SYMBOL to be EXPORT_SYMBOL_GPL for pci_iov_virtfn_devfn().
>  * Rewrote sysfs registration code to be driven by PF that wants to enable VF
>    overlay instead of creating to all SR-IOV devices.
>  * Grouped all such functionality under new "vfs_overlay" folder.
>  * Combined two PCI patches into one.
> v3: https://lore.kernel.org/linux-pci/20210117081548.1278992-1-leon@kernel.org
>  * Renamed pci_set_msix_vec_count to be pci_vf_set_msix_vec_count.
>  * Added VF msix_cap check to hide sysfs entry if device doesn't support msix.
>  * Changed "-" to be ":" in the mlx5 patch to silence CI warnings about missing
>    kdoc description.
>  * Split differently error print in mlx5 driver to avoid checkpatch warning.
> v2: https://lore.kernel.org/linux-pci/20210114103140.866141-1-leon@kernel.org
>  * Patch 1:
>   * Renamed vf_msix_vec sysfs knob to be sriov_vf_msix_count
>   * Added PF and VF device locks during set MSI-X call to protect from parallel
>     driver bind/unbind operations.
>   * Removed extra checks when reading sriov_vf_msix, because users will
>     be able to distinguish between supported/not supported by looking on
>     sriov_vf_total_msix count.
>   * Changed all occurrences of "numb" to be "count"
>   * Changed returned error from EOPNOTSUPP to be EBUSY if user tries to set
>     MSI-X count after driver already bound to the VF.
>   * Added extra comment in pci_set_msix_vec_count() to emphasize that driver
>     should not be bound.
>  * Patch 2:
>   * Changed vf_total_msix from int to be u32 and updated function signatures
>     accordingly.
>   * Improved patch title
> v1: https://lore.kernel.org/linux-pci/20210110150727.1965295-1-leon@kernel.org
>  * Improved wording and commit messages of first PCI patch
>  * Added extra PCI patch to provide total number of MSI-X vectors
>  * Prohibited read of vf_msix_vec sysfs file if driver doesn't support write
>  * Removed extra function definition in pci.h
> v0: https://lore.kernel.org/linux-pci/20210103082440.34994-1-leon@kernel.org
> 
> --------------------------------------------------------------------
> Hi,
> 
> The number of MSI-X vectors is PCI property visible through lspci, that
> field is read-only and configured by the device.
> 
> The static assignment of an amount of MSI-X vectors doesn't allow utilize
> the newly created VF because it is not known to the device the future load
> and configuration where that VF will be used.
> 
> The VFs are created on the hypervisor and forwarded to the VMs that have
> different properties (for example number of CPUs).
> 
> To overcome the inefficiency in the spread of such MSI-X vectors, we
> allow the kernel to instruct the device with the needed number of such
> vectors, before VF is initialized and bounded to the driver.
> 
> Before this series:
> [root@server ~]# lspci -vs 0000:08:00.2
> 08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
> ....
>         Capabilities: [9c] MSI-X: Enable- Count=12 Masked-
> 
> Configuration script:
> 1. Start fresh
> echo 0 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_numvfs
> modprobe -q -r mlx5_ib mlx5_core
> 2. Ensure that driver doesn't run and it is safe to change MSI-X
> echo 0 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_drivers_autoprobe
> 3. Load driver for the PF
> modprobe mlx5_core
> 4. Configure one of the VFs with new number
> echo 2 > /sys/bus/pci/devices/0000\:08\:00.0/sriov_numvfs
> echo 21 > /sys/bus/pci/devices/0000\:08\:00.2/sriov_vf_msix_count
> 
> After this series:
> [root@server ~]# lspci -vs 0000:08:00.2
> 08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
> ....
>         Capabilities: [9c] MSI-X: Enable- Count=21 Masked-
> 
> Thanks
> 
> Leon Romanovsky (4):
>   PCI: Add a sysfs file to change the MSI-X table size of SR-IOV VFs
>   net/mlx5: Add dynamic MSI-X capabilities bits
>   net/mlx5: Dynamically assign MSI-X vectors count
>   net/mlx5: Implement sriov_get_vf_total_msix/count() callbacks
> 
>  Documentation/ABI/testing/sysfs-bus-pci       |  29 +++++
>  .../net/ethernet/mellanox/mlx5/core/main.c    |   6 ++
>  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  12 +++
>  .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  73 +++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/sriov.c   |  48 ++++++++-
>  drivers/pci/iov.c                             | 102 ++++++++++++++++--
>  drivers/pci/pci-sysfs.c                       |   3 +-
>  drivers/pci/pci.h                             |   3 +-
>  include/linux/mlx5/mlx5_ifc.h                 |  11 +-
>  include/linux/pci.h                           |   8 ++
>  10 files changed, 284 insertions(+), 11 deletions(-)

Looks good to me, thanks for persevering with this.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Minor comments on 1/4, not critical.

