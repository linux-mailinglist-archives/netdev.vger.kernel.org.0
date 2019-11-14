Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB22AFC77A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKNNbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:31:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfKNNbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 08:31:32 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5797206DC;
        Thu, 14 Nov 2019 13:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573738291;
        bh=QF+fHe0v5Oofj+xUEKThEQAMjIFpiBA4YQCqiDR1jMo=;
        h=From:To:Cc:Subject:Date:From;
        b=rNOlX+/hzg0LJ1tVW0Lj2a5ogVCnBhfbSy7l4YVDcsR4Hn/8Qdt60bS3PIc5+S6rD
         125TXc1amK8BKXhQNCG5Kf606ty8rvKzkeLMs10KuAbwAyqLWlDSkkHnybDlWjpOlS
         haJ15V95wG2c/eZ4ZbaXvJVOnPA5Zb0PV7or35QE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 0/4] Get IB port and node GUIDs through rtnetlink
Date:   Thu, 14 Nov 2019 15:31:21 +0200
Message-Id: <20191114133126.238128-1-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series from Danit extends RTNETLINK to provide IB port and node
GUIDs, which were configured for Infiniband VFs.

The functionality to set VF GUIDs already existed for a long time, and here
we are adding the missing "get" so that netlink will be symmetric
and various cloud orchestration tools will be able to manage such
VFs more naturally.

The iproute2 was extended too to present those GUIDs.

- ip link show <device>

For example:
- ip link set ib4 vf 0 node_guid 22:44:33:00:33:11:00:33
- ip link set ib4 vf 0 port_guid 10:21:33:12:00:11:22:10
- ip link show ib4
    ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFAULT group default qlen 256
    link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
    spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10:21:33:12:00:11:22:10, link-state disable, trust off, query_rss off

Due to the fact that this series touches both net and RDMA, we assume
that it needs to be applied to our shared branch (mlx5-next) and pulled
later by Dave and Doug/Jason.

Thanks

Danit Goldberg (4):
  net/core: Add support for getting VF GUIDs
  IB/core: Add interfaces to get VF node and port GUIDs
  IB/ipoib: Add ndo operation for getting VFs GUID attributes
  IB/mlx5: Implement callbacks for getting VFs GUID attributes

 drivers/infiniband/core/device.c          |  1 +
 drivers/infiniband/core/verbs.c           | 10 ++++++++++
 drivers/infiniband/hw/mlx5/ib_virt.c      | 24 +++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c         |  1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |  3 +++
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 10 ++++++++++
 include/linux/netdevice.h                 |  4 ++++
 include/rdma/ib_verbs.h                   |  6 ++++++
 net/core/rtnetlink.c                      | 11 +++++++++++
 9 files changed, 70 insertions(+)

--
2.20.1

