Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A7CDDD9
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbfD2IfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbfD2IfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:00 -0400
Received: from localhost (unknown [77.138.135.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DE78214AF;
        Mon, 29 Apr 2019 08:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556526900;
        bh=g53n92kjY0DZyrDpRqur0LAr8PIVTHeUKHPGUguSS+k=;
        h=From:To:Cc:Subject:Date:From;
        b=he/Egha4V3GeSM9tBzJz21X9hC1RN/Fxj7wGAEMy7kkoef8HN/egFX570kcjFNj2d
         vKtB1EhkbXWHYQ0mmLFEwJWeozkJp/tVCJea2mpzlKmMk+2K/EtNhjHzB8u78203iW
         CcYNZ8q3ly6gPfZC6AfaHSowat3a1Z7NMk7b1bew=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 00/17] Statistics counter support
Date:   Mon, 29 Apr 2019 11:34:36 +0300
Message-Id: <20190429083453.16654-1-leon@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
 v1 -> v2:
 * Rebased to latest rdma-next
 v0 -> v1:
 * Changed wording of counter comment
 * Removed unneeded assignments
 * Added extra patch to present global counters

 * I didn't change QP type from int to be enum ib_qp_type,
   because it caused to cyclic dependency between ib_verbs.h and
   rdma_counter.h.

----------------------------------------------------

Hi,

This series from Mark provides dynamic statistics infrastructure.
He uses netlink interface to configure and retrieve those counters.

This infrastructure allows to users monitor various objects by binding
to them counters. As the beginning, we used QP object as target for
those counters, but future patches will include ODP MR information too.

Two binding modes are supported:
 - Auto: This allows a user to build automatic set of objects to a counter
   according to common criteria. For example in a per-type scheme, where in
   one process all QPs with same QP type are bound automatically to a single
   counter.
 - Manual: This allows a user to manually bind objects on a counter.

Those two modes are mutual-exclusive with separation between processes,
objects created by different processes cannot be bound to a same counter.

For objects which don't support counter binding, we will return
pre-allocated counters.

$ rdma statistic qp set link mlx5_2/1 auto type on
$ rdma statistic qp set link mlx5_2/1 auto off
$ rdma statistic qp bind link mlx5_2/1 lqpn 178
$ rdma statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178
$ rdma statistic show
$ rdma statistic qp mode

Thanks


Mark Zhang (17):
  net/mlx5: Add rts2rts_qp_counters_set_id field in hca cap
  RDMA/restrack: Introduce statistic counter
  RDMA/restrack: Add an API to attach a task to a resource
  RDMA/restrack: Make is_visible_in_pid_ns() as an API
  RDMA/counter: Add set/clear per-port auto mode support
  RDMA/counter: Add "auto" configuration mode support
  IB/mlx5: Support set qp counter
  IB/mlx5: Add counter set id as a parameter for
    mlx5_ib_query_q_counters()
  IB/mlx5: Support statistic q counter configuration
  RDMA/nldev: Allow counter auto mode configration through RDMA netlink
  RDMA/netlink: Implement counter dumpit calback
  IB/mlx5: Add counter_alloc_stats() and counter_update_stats() support
  RDMA/core: Get sum value of all counters when perform a sysfs stat
    read
  RDMA/counter: Allow manual mode configuration support
  RDMA/nldev: Allow counter manual mode configration through RDMA
    netlink
  RDMA/nldev: Allow get counter mode through RDMA netlink
  RDMA/nldev: Allow get default counter statistics through RDMA netlink

 drivers/infiniband/core/Makefile     |   2 +-
 drivers/infiniband/core/counters.c   | 653 +++++++++++++++++++++++++++
 drivers/infiniband/core/device.c     |  14 +
 drivers/infiniband/core/nldev.c      | 524 ++++++++++++++++++++-
 drivers/infiniband/core/restrack.c   |  49 +-
 drivers/infiniband/core/restrack.h   |   3 +
 drivers/infiniband/core/sysfs.c      |  10 +-
 drivers/infiniband/core/verbs.c      |   9 +
 drivers/infiniband/hw/mlx5/main.c    |  88 +++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   6 +
 drivers/infiniband/hw/mlx5/qp.c      |  76 +++-
 include/linux/mlx5/mlx5_ifc.h        |   4 +-
 include/linux/mlx5/qp.h              |   1 +
 include/rdma/ib_verbs.h              |  30 ++
 include/rdma/rdma_counter.h          |  64 +++
 include/rdma/restrack.h              |   4 +
 include/uapi/rdma/rdma_netlink.h     |  52 ++-
 17 files changed, 1558 insertions(+), 31 deletions(-)
 create mode 100644 drivers/infiniband/core/counters.c
 create mode 100644 include/rdma/rdma_counter.h

--
2.20.1

