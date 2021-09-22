Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADFD414690
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhIVKkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234734AbhIVKkb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 06:40:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C14CF61215;
        Wed, 22 Sep 2021 10:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632307141;
        bh=V4GF0nAj0v2eTQCwITPWL26u6zIOuflM776Qsk3ZCGk=;
        h=From:To:Cc:Subject:Date:From;
        b=ci/ZAlTRBCsUreVxw+bq9fvZPLziyWvfEpX4JTfC/5VxKWMpy6zrAMC7cZ++KZC9u
         /5UPZ/XxyI2yM3liEvX5Lwdeza1wWahvemoLmEhXMxavOPHwioWsvrO74Bhi1OFzk4
         aJEl3m4pPBfL0VFsq98XgHAKfl2/EYbATUVKs1hL+kFKkRKKOYddsLT9fHsaM0IK46
         E4uzFjLAmkiYck4JTtTpIbBdG5nUqclTTcJs3e5FVh1XIfFp4BlQFbWMAmzCh4P2I4
         41tnuE+3E2MAhAj5oKQtmxCUiC3t7sW7ZhEQ8y/wv3MyBy8EoVO4QTZ1PXimu7Qo8c
         Ypf6IO2GhJU0Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Max Gurtovoy <maxg@nvidia.com>
Subject: [PATCH mlx5-next 0/7] Add mlx5 live migration driver
Date:   Wed, 22 Sep 2021 13:38:49 +0300
Message-Id: <cover.1632305919.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

From Yishai:

This series adds mlx5 live migration driver for VFs that are migrated
capable.

It uses vfio_pci_core to register to the VFIO subsystem and then
implements the mlx5 specific logic in the migration area.

The migration implementation follows the definition from uapi/vfio.h and
uses the mlx5 VF->PF command channel to achieve it.

The series adds an API in the vfio core layer to check migration state
transition validity as part of a migration flow. This ensures that all
migration implementations follow a consistent migration state machine.

As part of the migration process the VF doesn't ride on mlx5_core, the
device is driving *two* different PCI devices, the PF owned by mlx5_core
and the VF owned by the mlx5 vfio driver.

The mlx5_core of the PF is accessed only during the narrow window of the
VF's ioctl that requires its services.

The series also exposes from the PCI sub system an API named
pci_iov_vf_id() to get the index of the VF. The PCI core uses this index
internally, often called the vf_id, during the setup of the VF, eg
pci_iov_add_virtfn().

The returned VF index is needed by the mlx5 vfio driver for its internal
operations to configure/control its VFs as part of the migration
process.

With the above functionality in place the driver implements the
suspend/resume flows to work over QEMU.

Thanks

-----------------------------------------------------
Alex,

This series touches our ethernet and RDMA drivers, so we will need to
route the patches through separate shared branch (mlx5-next) in order
to eliminate the chances of merge conflicts between different subsystems.

Thanks

Jason Gunthorpe (1):
  PCI/IOV: Provide internal VF index

Yishai Hadas (6):
  vfio: Add an API to check migration state transition validity
  vfio/pci_core: Make the region->release() function optional
  net/mlx5: Introduce migration bits and structures
  net/mlx5: Expose APIs to get/put the mlx5 core device
  mlx5_vfio_pci: Expose migration commands over mlx5 device
  mlx5_vfio_pci: Implement vfio_pci driver for mlx5 devices

 .../net/ethernet/mellanox/mlx5/core/main.c    |  43 +
 drivers/pci/iov.c                             |  14 +
 drivers/vfio/pci/Kconfig                      |  11 +
 drivers/vfio/pci/Makefile                     |   3 +
 drivers/vfio/pci/mlx5_vfio_pci.c              | 736 ++++++++++++++++++
 drivers/vfio/pci/mlx5_vfio_pci_cmd.c          | 358 +++++++++
 drivers/vfio/pci/mlx5_vfio_pci_cmd.h          |  43 +
 drivers/vfio/pci/vfio_pci_core.c              |   3 +-
 drivers/vfio/vfio.c                           |  41 +
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 145 +++-
 include/linux/pci.h                           |   7 +-
 include/linux/vfio.h                          |   1 +
 13 files changed, 1405 insertions(+), 3 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci.c
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci_cmd.c
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci_cmd.h

-- 
2.31.1

