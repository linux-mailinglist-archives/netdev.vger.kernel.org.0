Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6072B134A18
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgAHSGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:06:07 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45033 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728686AbgAHSGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:06:06 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yishaih@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jan 2020 20:06:04 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [10.7.2.17])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 008I64r0029990;
        Wed, 8 Jan 2020 20:06:04 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [127.0.0.1])
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8) with ESMTP id 008I64sR022314;
        Wed, 8 Jan 2020 20:06:04 +0200
Received: (from yishaih@localhost)
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8/Submit) id 008I64Xv022313;
        Wed, 8 Jan 2020 20:06:04 +0200
From:   Yishai Hadas <yishaih@mellanox.com>
To:     linux-rdma@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com
Cc:     saeedm@mellanox.com, yishaih@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH rdma-next 00/10] Relaxed ordering memory regions 
Date:   Wed,  8 Jan 2020 20:05:30 +0200
Message-Id: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
X-Mailer: git-send-email 1.8.2.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds an ioctl command to allocate an async event file followed by a
new ioctl command to get a device context.

The get device context command enables reading some core generic capabilities
such as supporting an optional MR access flags by IB core and its related
drivers.

Once the above is enabled, a new optional MR access flag named
IB_UVERBS_ACCESS_RELAXED_ORDERING is added and is used by mlx5 driver.

This optional flag allows creation of relaxed ordering memory regions.  Access
through such MRs can improve performance by allowing the system to reorder
certain accesses.

As relaxed ordering is an optimization, drivers that do not support it can
simply ignore it.

Note: This series relies on the 'Refactoring FD usage' series [1] that was sent
to rdma-next.
[1] https://patchwork.kernel.org/project/linux-rdma/list/?series=225541

Yishai

Jason Gunthorpe (3):
  RDMA/core: Add UVERBS_METHOD_ASYNC_EVENT_ALLOC
  RDMA/core: Remove ucontext_lock from the uverbs_destry_ufile_hw() path
  RDMA/uverbs: Add ioctl command to get a device context

Michael Guralnik (7):
  net/mlx5: Expose relaxed ordering bits
  RDMA/uverbs: Verify MR access flags
  RDMA/core: Add optional access flags range
  RDMA/efa: Allow passing of optional access flags for MR registration
  RDMA/uverbs: Add new relaxed ordering memory region access flag
  RDMA/core: Add the core support field to METHOD_GET_CONTEXT
  RDMA/mlx5: Set relaxed ordering when requested

 drivers/infiniband/core/rdma_core.c                |  21 +---
 drivers/infiniband/core/uverbs.h                   |   3 +
 drivers/infiniband/core/uverbs_cmd.c               | 133 ++++++++++++---------
 drivers/infiniband/core/uverbs_main.c              |  11 +-
 .../infiniband/core/uverbs_std_types_async_fd.c    |  21 +++-
 drivers/infiniband/core/uverbs_std_types_device.c  |  38 ++++++
 drivers/infiniband/hw/efa/efa_verbs.c              |   1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   5 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  19 ++-
 drivers/infiniband/hw/mlx5/odp.c                   |   2 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   2 +-
 include/linux/mlx5/mlx5_ifc.h                      |   7 +-
 include/rdma/ib_verbs.h                            |   8 +-
 include/uapi/rdma/ib_user_ioctl_cmds.h             |  14 +++
 include/uapi/rdma/ib_user_ioctl_verbs.h            |  12 ++
 15 files changed, 209 insertions(+), 88 deletions(-)

-- 
1.8.3.1

