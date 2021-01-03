Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140C92E8B60
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 09:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbhACIZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 03:25:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbhACIZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 03:25:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC6612080D;
        Sun,  3 Jan 2021 08:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609662286;
        bh=SCUPa5CjLPZTftht/C8AD6ge/LKIqPYJxn5ORp7KbYM=;
        h=From:To:Cc:Subject:Date:From;
        b=hXppJJJb8oMO/IU/WbBnrDq+9iZTjEBUB8OoVfwF80I5BrUXdo4gjDCAGu+mIr8tq
         r2l5LRbCyqmS3qAr8DP+0J2rThaZ0FvTNox1z7kAm5nX698yd+EQ2GGK8pxqZqCAr9
         5gwzzHX+KImA5tf3qv8bTs7Ouc8nbBY8ObXRZicTUg6fTno53zAqMTyZUPOigFvpQi
         LmeawltxWlipUyLHUCHz0YRbrwNRtlp+r9uVyzeewJ1o97JXmUVyOuG8oGtkaLthSF
         OdFAHwmE6S9OpBefWTwUjT3iz/K6u+s/LnKSz/fteL7BdYZ11GL18gLNnxfvjoMecI
         SOrhdjmnLbWvw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH mlx5-next 0/4] Dynamically assign MSI-X vectors count
Date:   Sun,  3 Jan 2021 10:24:36 +0200
Message-Id: <20210103082440.34994-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

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

Leon Romanovsky (4):
  PCI: Configure number of MSI-X vectors for SR-IOV VFs
  net/mlx5: Add dynamic MSI-X capabilities bits
  net/mlx5: Dynamically assign MSI-X vectors count
  net/mlx5: Allow to the users to configure number of MSI-X vectors

 Documentation/ABI/testing/sysfs-bus-pci       | 16 +++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  5 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  6 ++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 62 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 49 ++++++++++++++-
 drivers/pci/iov.c                             | 57 +++++++++++++++++
 drivers/pci/msi.c                             | 30 +++++++++
 drivers/pci/pci-sysfs.c                       |  1 +
 drivers/pci/pci.h                             |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 11 +++-
 include/linux/pci.h                           |  8 +++
 11 files changed, 243 insertions(+), 3 deletions(-)

--
2.29.2

