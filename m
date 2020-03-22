Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E063518E7D4
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 10:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgCVJaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 05:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbgCVJai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 05:30:38 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68A1120753;
        Sun, 22 Mar 2020 09:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584869436;
        bh=ga/q2v/q+cO7hdszaTExGq+aTJ8PetY9ImofYkuHsW0=;
        h=From:To:Cc:Subject:Date:From;
        b=zDSsz+BZzPKGvlgjfTtnt2yxbMMh9cJCPlA7hYqk1wlvD7bp04vVra/cGKpw51wXU
         aYShd4RvfOMGkeYF1jdXWcSH7XsVXVMuhaj2a4nHVJIqiKw6R7avjDd0d/ZjjLmpEZ
         QXe4XE9kbZXOubuaf2F5xXsRc2IHEVyqflbQakMc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next v1 0/7] Set flow_label and RoCEv2 UDP source port for datagram QP
Date:   Sun, 22 Mar 2020 11:30:24 +0200
Message-Id: <20200322093031.918447-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
 v1: Added extra patch to reduce amount of kzalloc/kfree calls in
 the HCA set capability flow.
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

Mark Zhang (6):
  net/mlx5: Enable SW-defined RoCEv2 UDP source port
  RDMA/core: Add hash functions to calculate RoCEv2 flowlabel and UDP
    source port
  RDMA/mlx5: Define RoCEv2 udp source port when set path
  RDMA/cma: Initialize the flow label of CM's route path record
  RDMA/cm: Set flow label of recv_wc based on primary flow label
  RDMA/mlx5: Set UDP source port based on the grh.flow_label

 drivers/infiniband/core/cm.c                  |  7 ++
 drivers/infiniband/core/cma.c                 | 23 +++++
 drivers/infiniband/hw/mlx5/ah.c               | 21 +++-
 drivers/infiniband/hw/mlx5/main.c             |  4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  4 +-
 drivers/infiniband/hw/mlx5/qp.c               | 30 ++++--
 .../net/ethernet/mellanox/mlx5/core/main.c    | 96 +++++++++++--------
 include/linux/mlx5/mlx5_ifc.h                 |  5 +-
 include/rdma/ib_verbs.h                       | 44 +++++++++
 9 files changed, 180 insertions(+), 54 deletions(-)

--
2.24.1

