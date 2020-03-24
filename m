Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB6C190567
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 07:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgCXGBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 02:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgCXGBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 02:01:54 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED59720719;
        Tue, 24 Mar 2020 06:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585029713;
        bh=IaQ5lL3AQrcl/tpvdz/uiV7NrQJNLLTAmfDDeS8zk4o=;
        h=From:To:Cc:Subject:Date:From;
        b=Oktg7l2bzKo/3u8/Fabw91jjgUxBThucMqaGhJ6EmZXcaoIdfd48zs9xL1SGaW1sd
         pjtBNcsRSBkSjI9UR7LZ03bFEhaIz62t9eY5vLILZ3Wkyq1Z+frccKLXKXWkKoMD6f
         DOXo9Eq3WbSrS9h/8vRa1ckunaQ29o3tYyYFQKsY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next v1 0/5] Introduce dynamic UAR allocation mode
Date:   Tue, 24 Mar 2020 08:01:38 +0200
Message-Id: <20200324060143.1569116-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v1: * Added patch that moved mlx5_bfreg_info from global header to the mlx5_ib.h
    * No other changes.
v0: * https://lore.kernel.org/linux-rdma/20200318124329.52111-1-leon@kernel.org

----------------------------------------------------------------------------------

From Yishai,

This series exposes API to enable a dynamic allocation and management of a
UAR which now becomes to be a regular uobject.

Moving to that mode enables allocating a UAR only upon demand and drop the
redundant static allocation of UARs upon context creation.

In addition, it allows master and secondary processes that own the same command
FD to allocate and manage UARs according to their needs, this can’t be achieved
today.

As part of this option, QP & CQ creation flows were adapted to support this
dynamic UAR mode once asked by user space.

Once this mode is asked by mlx5 user space driver on a given context, it will
be mutual exclusive, means both the static and legacy dynamic modes for using
UARs will be blocked.

The legacy modes are supported for backward compatible reasons, looking
forward we expect this new mode to be the default.

Thanks

Leon Romanovsky (1):
  IB/mlx5: Limit the scope of struct mlx5_bfreg_info to mlx5_ib

Yishai Hadas (4):
  IB/mlx5: Expose UAR object and its alloc/destroy commands
  IB/mlx5: Extend CQ creation to get uar page index from user space
  IB/mlx5: Extend QP creation to get uar page index from user space
  IB/mlx5: Move to fully dynamic UAR mode once user space supports it

 drivers/infiniband/hw/mlx5/cq.c           |  21 ++-
 drivers/infiniband/hw/mlx5/main.c         | 185 ++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |  20 +++
 drivers/infiniband/hw/mlx5/qp.c           |  33 ++--
 include/linux/mlx5/driver.h               |  17 --
 include/rdma/uverbs_ioctl.h               |   2 +-
 include/uapi/rdma/mlx5-abi.h              |   6 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  18 +++
 include/uapi/rdma/mlx5_user_ioctl_verbs.h |   5 +
 9 files changed, 263 insertions(+), 44 deletions(-)

--
2.24.1

