Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40BA1A672B
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 15:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbgDMNhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 09:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbgDMNhK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 09:37:10 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 282C72073E;
        Mon, 13 Apr 2020 13:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586785029;
        bh=F8aJn+N+qn2g5uQhQDxXFwESJ03YwiK3YRVavkAoQIc=;
        h=From:To:Cc:Subject:Date:From;
        b=KjHGOxqJ5ce1c7nUhb9IBokDcNfmLHzgxdkQuplPmJaHI4ZlbKKPs0Y1FVtBw4qBV
         ebzQFg25B47iGChjrcErARx4HXJ/yJUsXD5xCeTfxF+XZ5nfC3EZTaMB5HUGCFlgQq
         A3/GqmnZFAvAtBJoFG6waHT643Xlo2IxDfUs+mWM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next v2 0/6] Set flow_label and RoCEv2 UDP source port for datagram QP
Date:   Mon, 13 Apr 2020 16:36:57 +0300
Message-Id: <20200413133703.932731-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
 v2: Dropped patch "RDMA/cm: Set flow label of recv_wc based on primary
 flow label", because it violates IBTA 13.5.4.3/13.5.4.4 sections.
 v1: Added extra patch to reduce amount of kzalloc/kfree calls in
 the HCA set capability flow.
 https://lore.kernel.org/lkml/20200322093031.918447-1-leon@kernel.org
 v0: https://lore.kernel.org/linux-rdma/20200318095300.45574-1-leon@kernel.org
--------------------------------

From Mark:

This series provide flow label and UDP source port definition in RoCE v2.
Those fields are used to create entropy for network routes (ECMP), load
balancers and 802.3ad link aggregation switching that are not aware of
RoCE headers.

Thanks.

Leon Romanovsky (1):
  net/mlx5: Refactor HCA capability set flow

Mark Zhang (5):
  net/mlx5: Enable SW-defined RoCEv2 UDP source port
  RDMA/core: Add hash functions to calculate RoCEv2 flowlabel and UDP
    source port
  RDMA/mlx5: Define RoCEv2 udp source port when set path
  RDMA/cma: Initialize the flow label of CM's route path record
  RDMA/mlx5: Set UDP source port based on the grh.flow_label

 drivers/infiniband/core/cma.c                 | 23 +++++
 drivers/infiniband/hw/mlx5/ah.c               | 21 +++-
 drivers/infiniband/hw/mlx5/main.c             |  4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  4 +-
 drivers/infiniband/hw/mlx5/qp.c               | 30 ++++--
 .../net/ethernet/mellanox/mlx5/core/main.c    | 96 +++++++++++--------
 include/linux/mlx5/mlx5_ifc.h                 |  5 +-
 include/rdma/ib_verbs.h                       | 44 +++++++++
 8 files changed, 173 insertions(+), 54 deletions(-)

--
2.25.2

