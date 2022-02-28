Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836564C6CC7
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 13:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbiB1MkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 07:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236076AbiB1MkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 07:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02074F453;
        Mon, 28 Feb 2022 04:39:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AC6DB81115;
        Mon, 28 Feb 2022 12:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7029DC340F4;
        Mon, 28 Feb 2022 12:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646051980;
        bh=CUgW3tNZSaj+TM/ZyUObZoHTBcStn4Kp7amTw5B6gOI=;
        h=From:To:Cc:Subject:Date:From;
        b=FTjDPs5PdmnQzS1SvaklSMTUYV/PbgBx9CD1cnXm0q+Jn0bDBCIgtoBf3MoiUo1+F
         IwdqIfWcBcBc0f8Jj+cMdmDmMVm30HhLMazMqFrpVeq1O8Yc/zopwk11PJJoK/DG8b
         ixyCbrEm8ERN1Zb78bakD95qp5yfU0NyV0wroot+r/+XaE9jZzI5nOa7y/Rud1M13R
         bS60nAM+JdkWh5y2Lw/GyQGFvU4ViFy3otKRfjZq1N9AsEvbrj45D8Jr8HoJwZ/V5/
         kBHbsfRIYypm15tHz4p67FC5dNeL9YDp7Xt9r6eYzwbMG3K5PSO7vaGC48xxGWepoR
         Qa9hQFiTDjmNQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     alex.williamson@redhat.com, bhelgaas@google.com, jgg@nvidia.com,
        saeedm@nvidia.com
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: [GIT PULL] Add mlx5 live migration driver and v2 migration protocol
Date:   Mon, 28 Feb 2022 14:39:34 +0200
Message-Id: <20220228123934.812807-1-leon@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi Alex,

This pull request contains the v9 version of recently submitted mlx5 live migration
driver from Yishai and Jason.

In addition to changes in VFIO, this series extended the ethernet part of mlx5 driver.
Such changes have all chances to create merge conflicts between VFIO, netdev and RDMA
subsystems, which are eliminated with this PR.

Thanks

------------------------------------------------------------------------------------

The following changes since commit cfb92440ee71adcc2105b0890bb01ac3cddb8507:

  Linux 5.17-rc5 (2022-02-20 13:07:20 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-vfio-v9

for you to fetch changes up to d18f3ba69448b8f68caf8592a9abb39e75c76e8d:

  vfio/mlx5: Use its own PCI reset_done error handler (2022-02-27 11:44:00 +0200)

----------------------------------------------------------------
Add mlx5 live migration driver and v2 migration protocol

This series adds mlx5 live migration driver for VFs that are migration
capable and includes the v2 migration protocol definition and mlx5
implementation.

The mlx5 driver uses the vfio_pci_core split to create a specific VFIO
PCI driver that matches the mlx5 virtual functions. The driver provides
the same experience as normal vfio-pci with the addition of migration
support.

In HW the migration is controlled by the PF function, using its
mlx5_core driver, and the VFIO PCI VF driver co-ordinates with the PF to
execute the migration actions.

The bulk of the v2 migration protocol is semantically the same v1,
however it has been recast into a FSM for the device_state and the
actual syscall interface uses normal ioctl(), read() and write() instead
of building a syscall interface using the region.

Several bits of infrastructure work are included here:
 - pci_iov_vf_id() to help drivers like mlx5 figure out the VF index from
   a BDF
 - pci_iov_get_pf_drvdata() to clarify the tricky locking protocol when a
   VF reaches into its PF's driver
 - mlx5_core uses the normal SRIOV lifecycle and disables SRIOV before
   driver remove, to be compatible with pci_iov_get_pf_drvdata()
 - Lifting VFIO_DEVICE_FEATURE into core VFIO code

This series comes after alot of discussion. Some major points:
- v1 ABI compatible migration defined using the same FSM approach:
   https://lore.kernel.org/all/0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com/
- Attempts to clarify how the v1 API works:
   Alex's:
     https://lore.kernel.org/kvm/163909282574.728533.7460416142511440919.stgit@omen/
   Jason's:
     https://lore.kernel.org/all/0-v3-184b374ad0a8+24c-vfio_mig_doc_jgg@nvidia.com/
- Etherpad exploring the scope and questions of general VFIO migration:
     https://lore.kernel.org/kvm/87mtm2loml.fsf@redhat.com/

NOTE: As this series touched mlx5_core parts we need to send this in a
pull request format to VFIO to avoid conflicts.

Matching qemu changes can be previewed here:
 https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2

Link: https://lore.kernel.org/all/20220224142024.147653-1-yishaih@nvidia.com
Signed-of-by: Leon Romanovsky <leonro@nvidia.com>

----------------------------------------------------------------
Jason Gunthorpe (6):
      PCI/IOV: Add pci_iov_vf_id() to get VF index
      PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata of a PF
      vfio: Have the core code decode the VFIO_DEVICE_FEATURE ioctl
      vfio: Define device migration protocol v2
      vfio: Extend the device migration protocol with RUNNING_P2P
      vfio: Remove migration protocol v1 documentation

Leon Romanovsky (1):
      net/mlx5: Reuse exported virtfn index function call

Yishai Hadas (8):
      net/mlx5: Disable SRIOV before PF removal
      net/mlx5: Expose APIs to get/put the mlx5 core device
      net/mlx5: Introduce migration bits and structures
      net/mlx5: Add migration commands definitions
      vfio/mlx5: Expose migration commands over mlx5 device
      vfio/mlx5: Implement vfio_pci driver for mlx5 devices
      vfio/pci: Expose vfio_pci_core_aer_err_detected()
      vfio/mlx5: Use its own PCI reset_done error handler

 MAINTAINERS                                        |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  45 ++
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  17 +-
 drivers/pci/iov.c                                  |  43 ++
 drivers/vfio/pci/Kconfig                           |   3 +
 drivers/vfio/pci/Makefile                          |   2 +
 drivers/vfio/pci/mlx5/Kconfig                      |  10 +
 drivers/vfio/pci/mlx5/Makefile                     |   4 +
 drivers/vfio/pci/mlx5/cmd.c                        | 259 ++++++++
 drivers/vfio/pci/mlx5/cmd.h                        |  36 ++
 drivers/vfio/pci/mlx5/main.c                       | 676 +++++++++++++++++++++
 drivers/vfio/pci/vfio_pci.c                        |   1 +
 drivers/vfio/pci/vfio_pci_core.c                   | 101 ++-
 drivers/vfio/vfio.c                                | 295 ++++++++-
 include/linux/mlx5/driver.h                        |   3 +
 include/linux/mlx5/mlx5_ifc.h                      | 147 ++++-
 include/linux/pci.h                                |  15 +-
 include/linux/vfio.h                               |  53 ++
 include/linux/vfio_pci_core.h                      |   4 +
 include/uapi/linux/vfio.h                          | 406 ++++++-------
 22 files changed, 1846 insertions(+), 291 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c
