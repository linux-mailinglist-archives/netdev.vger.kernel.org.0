Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282CB5B00C9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiIGJoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIGJoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:44:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B46AB4EBA;
        Wed,  7 Sep 2022 02:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C0D0B81BFB;
        Wed,  7 Sep 2022 09:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5D6C4347C;
        Wed,  7 Sep 2022 09:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662543840;
        bh=Hq4Wpfhb8NuSFGbKHRLB5ZUQLGciFoasORcXz4ePunk=;
        h=From:To:Cc:Subject:Date:From;
        b=VLZ3LNTB7UmwNuaAi9LySOF3/t7Hn6cTfK6Ifvm3Yudng0rafPqTKqDCHW7l7RLv0
         VcyiDWP4gc9kb2Ihndc0doQzofs7l8RqihT+Tkg9fGI1E8iBq4i38mJJ67bXI1gZxY
         S7eQRlyvWvnYmXXXofgwxPfwCLmUCJtBfRJzRrdt/t+94y5Obh4/LkUE6b5r2kXqQD
         FLgP81m5zqEiFCesL0+xZO+RMRcdRKuVc6pjg9tyyKJSGgNd0/lxdEXwjYOaiqTw0a
         TubBzTDj3E/TRnVvejYMM7aUQqycbC5JIl2LnVsZIr3bQ8iiz9/heYqmkNmwUGadVq
         DRIyWJOJWkdjw==
From:   Leon Romanovsky <leon@kernel.org>
To:     alex.williamson@redhat.com
Cc:     saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
        leonro@nvidia.com, yishaih@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com
Subject: [GIT PULL] Please pull mlx5 vfio changes 
Date:   Wed,  7 Sep 2022 12:43:44 +0300
Message-Id: <20220907094344.381661-1-leon@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

This series is based on clean 6.0-rc4 as such it causes to two small merge
conficts whis vfio-next. One is in thrird patch where you should take whole
chunk for include/uapi/linux/vfio.h as is. Another is in vfio_main.c around
header includes, which you should take too.

----------------------------------------------------------------
The following changes since commit 7e18e42e4b280c85b76967a9106a13ca61c16179:

  Linux 6.0-rc4 (2022-09-04 13:10:01 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-dma-logging

for you to fetch changes up to 7f5dc74155a9de8bf6adc86d84e26c5a1e762431:

  vfio/mlx5: Set the driver DMA logging callbacks (2022-09-07 12:11:22 +0300)

----------------------------------------------------------------
Add device DMA logging support for mlx5 driver

From Yishai:

This series adds device DMA logging uAPIs and their implementation as
part of mlx5 driver.

DMA logging allows a device to internally record what DMAs the device is
initiating and report them back to userspace. It is part of the VFIO
migration infrastructure that allows implementing dirty page tracking
during the pre copy phase of live migration. Only DMA WRITEs are logged,
and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.

The uAPIs are based on the FEATURE ioctl as were introduced earlier by
the below RFC [1] and follows the notes that were discussed in the
mailing list.

It includes:
- A PROBE option to detect if the device supports DMA logging.
- A SET option to start device DMA logging in given IOVAs ranges.
- A GET option to read back and clear the device DMA log.
- A SET option to stop device DMA logging that was previously started.

Extra details exist as part of relevant patches in the series.

In addition, the series adds some infrastructure support for managing an
IOVA bitmap done by Joao Martins.

It abstracts how an IOVA range is represented in a bitmap that is
granulated by a given page_size. So it translates all the lifting of
dealing with user pointers into its corresponding kernel addresses.
This new functionality abstracts the complexity of user/kernel bitmap
pointer usage and finally enables an API to set some bits.

This functionality will be used as part of IOMMUFD series for the system
IOMMU tracking.

Finally, we come with mlx5 implementation based on its device
specification for the DMA logging APIs.

The matching qemu changes can be previewed here [2].
They come on top of the v2 migration protocol patches that were sent
already to the mailing list.

Note:
- As this series touched mlx5_core parts we may need to send the
  net/mlx5 patches as a pull request format to VFIO to avoid conflicts
  before acceptance.

[1] https://lore.kernel.org/all/20220501123301.127279-1-yishaih@nvidia.com/T/
[2] https://github.com/avihai1122/qemu/commits/device_dirty_tracking

Link: https://lore.kernel.org/all/20220905105852.26398-1-yishaih@nvidia.com/
Signed-of-by: Leon Romanovsky <leon@kernel.org>

----------------------------------------------------------------
Joao Martins (1):
      vfio: Add an IOVA bitmap support

Yishai Hadas (9):
      net/mlx5: Introduce ifc bits for page tracker
      net/mlx5: Query ADV_VIRTUALIZATION capabilities
      vfio: Introduce DMA logging uAPIs
      vfio: Introduce the DMA logging feature support
      vfio/mlx5: Init QP based resources for dirty tracking
      vfio/mlx5: Create and destroy page tracker object
      vfio/mlx5: Report dirty pages from tracker
      vfio/mlx5: Manage error scenarios on tracker
      vfio/mlx5: Set the driver DMA logging callbacks

 drivers/net/ethernet/mellanox/mlx5/core/fw.c   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c |   1 +
 drivers/vfio/Kconfig                           |   1 +
 drivers/vfio/Makefile                          |   6 +-
 drivers/vfio/iova_bitmap.c                     | 422 +++++++++++
 drivers/vfio/pci/mlx5/cmd.c                    | 995 ++++++++++++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h                    |  63 +-
 drivers/vfio/pci/mlx5/main.c                   |   9 +-
 drivers/vfio/pci/vfio_pci_core.c               |   5 +
 drivers/vfio/vfio_main.c                       | 175 +++++
 include/linux/iova_bitmap.h                    |  26 +
 include/linux/mlx5/device.h                    |   9 +
 include/linux/mlx5/mlx5_ifc.h                  |  83 ++-
 include/linux/vfio.h                           |  28 +-
 include/uapi/linux/vfio.h                      |  86 +++
 15 files changed, 1895 insertions(+), 20 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 create mode 100644 include/linux/iova_bitmap.h
