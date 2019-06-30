Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82565B08E
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfF3QXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfF3QXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 12:23:41 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B4CB20673;
        Sun, 30 Jun 2019 16:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561911820;
        bh=GBatzlzwGiJD0iXzGqy7HGRuN4M8ynVxq0F24rRB8LI=;
        h=From:To:Cc:Subject:Date:From;
        b=YLE7NnjqIsvHFSDC/nA6kR7l402njneH7QzevkNftYS5QSbzmUAEA9Ul5XmpVPcqS
         aaEkeeJu6eE4v81TKxJe2aMYphanKiCivx9+QD3skSO4T7VoHnXLJeG8pe5HXquQhK
         +rB3MipOxzHuYPym7S+p67zaBOpmtaOvuUWb2Xn8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 00/13] DEVX asynchronous events
Date:   Sun, 30 Jun 2019 19:23:21 +0300
Message-Id: <20190630162334.22135-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
 v1 -> v2:
 * Added Saeed's ack to net patches
 * Patch #2:
  * Fix to gather user asynchronous events on top of kernel events.
 * Patch #7:
  * Fix obj_id to be 32 bits.
 * Patch #8:
  * Inline async_event_queue applicable fields into devx_async_event_file.
  * Move to use bitfields in few places rather than flags.
  * Shorten name of UAPI attribute.
 * Patch #10:
  * Use explicitly 'struct file *' instead of void *
  * Store struct devx_async_event_file * instead of uobj * on the subscription.
  * Drop 'is_obj_related' and use list_empty instead.
  * Drop the temp arrays as part of the subscription API and move to simpler logic.
  * Revise devx_cleanup_subscription() to be success oriented without
    the is_close flag.
  * Leave key level 1 in the tree upon bad flow to prevent a race with IRQ flow.
  * Fix some styling notes.
 * Patch #11:
  * Use rcu read lock also for the un-affiliated event flow.
  * Improve locking scheme as part of read events.
  * Return -EIO as soon as destroyed occurred.
  * Use a better errno as part read event failure when the buffer size
    was too small.
  * Upon hot unplug call wake_up_interruptible() unconditionally.
  * Use eqe->data for affiliated events header.
  * Fix some styling notes.
 * Patch #12:
  * Use rcu read lock also for the first XA layer.
 * Patch #13:
  * A new patch to clean up mdev usage from devx code, it can be accessed
    from ib_dev now.
 v0 -> v1:
 * Fix the unbind / hot unplug flows to work properly.
 * Fix Ref count handling on the eventfd mode in some flow.
 * Rebased to latest rdma-next

Thanks

------------------------------------------------------------------------------------
From Yishai:

This series enables RDMA applications that use the DEVX interface to
subscribe and read device asynchronous events.

The solution is designed to allow extension of events in the future
without need to perform any changes in the driver code.

To enable that few changes had been done in mlx5_core, it includes:
 * Reading device event capabilities that are user related
   (affiliated and un-affiliated) and set the matching mask upon
   creating the matching EQ.
 * Enable DEVX/mlx5_ib to register for ANY event instead of the option to
   get some hard-coded ones.
 * Enable DEVX/mlx5_ib to get the device raw data for CQ completion events.
 * Enhance mlx5_core_create/destroy CQ to enable DEVX using them so that CQ
   events will be reported as well.

In mlx5_ib layer the below changes were done:
 * A new DEVX API was introduced to allocate an event channel by using
   the uverbs FD object type.
 * Implement the FD channel operations to enable read/poo/close over it.
 * A new DEVX API was introduced to subscribe for specific events over an
   event channel.
 * Manage an internal data structure  over XA(s) to subscribe/dispatch events
   over the different event channels.
 * Use from DEVX the mlx5_core APIs to create/destroy a CQ to be able to
   get its relevant events.

Yishai

Yishai Hadas (13):
  net/mlx5: Fix mlx5_core_destroy_cq() error flow
  net/mlx5: Use event mask based on device capabilities
  net/mlx5: Expose the API to register for ANY event
  net/mlx5: mlx5_core_create_cq() enhancements
  net/mlx5: Report a CQ error event only when a handler was set
  net/mlx5: Report EQE data upon CQ completion
  net/mlx5: Expose device definitions for object events
  IB/mlx5: Introduce MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD
  IB/mlx5: Register DEVX with mlx5_core to get async events
  IB/mlx5: Enable subscription for device events over DEVX
  IB/mlx5: Implement DEVX dispatching event
  IB/mlx5: Add DEVX support for CQ events
  IB/mlx5: DEVX cleanup mdev

 drivers/infiniband/hw/mlx5/cq.c               |    5 +-
 drivers/infiniband/hw/mlx5/devx.c             | 1029 ++++++++++++++++-
 drivers/infiniband/hw/mlx5/main.c             |   10 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   12 +
 drivers/infiniband/hw/mlx5/odp.c              |    2 +-
 drivers/infiniband/hw/mlx5/qp.c               |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |   21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |    3 +-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   63 +-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |    6 +
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |    5 +-
 include/linux/mlx5/cq.h                       |    6 +-
 include/linux/mlx5/device.h                   |    6 +-
 include/linux/mlx5/driver.h                   |    2 +
 include/linux/mlx5/eq.h                       |    2 +-
 include/linux/mlx5/mlx5_ifc.h                 |   34 +-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h      |   19 +
 include/uapi/rdma/mlx5_user_ioctl_verbs.h     |    9 +
 21 files changed, 1178 insertions(+), 68 deletions(-)

--
2.20.1

