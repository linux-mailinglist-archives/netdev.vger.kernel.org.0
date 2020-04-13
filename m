Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A685D1A67A7
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbgDMOPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730417AbgDMOPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:15:43 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 417A92073E;
        Mon, 13 Apr 2020 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787342;
        bh=p4H0mbNsqUXCc+rVKfiFXeEwB+ggGqgRm+g9Z3fEcEY=;
        h=From:To:Cc:Subject:Date:From;
        b=Cc2GAdH6dnHe8KR4lpmbGMf5sORxwT0GEUnUKFd8hZi3eGW5HejVhjHLQKnx3hrkQ
         N8IFris9OuI3EAyBxcks0qgFRnqc1Vi+1oYi7SScdH6CD1/6DU0YCBtHWoawpVE5UX
         t3k8dWDqrsJV4BbxHVbO3BkqmcK/PWt1HfJPSvhw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        target-devel@vger.kernel.org
Subject: [PATCH rdma-next v2 0/7] Add Enhanced Connection Established (ECE)
Date:   Mon, 13 Apr 2020 17:15:31 +0300
Message-Id: <20200413141538.935574-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
 v2:
 * Rebased on latest rdma-next and removed already accepted patches.
 * Updated all rdma_reject in-kernel users to provide reject reason.
 v1: Dropped field_avail patch in favor of mass conversion to use function
     which already exists in the kernel code.
 https://lore.kernel.org/lkml/20200310091438.248429-1-leon@kernel.org
 v0: https://lore.kernel.org/lkml/20200305150105.207959-1-leon@kernel.org

Enhanced Connection Established or ECE is new negotiation scheme
introduced in IBTA v1.4 to exchange extra information about nodes
capabilities and later negotiate them at the connection establishment
phase.

The RDMA-CM messages (REQ, REP, SIDR_REQ and SIDR_REP) were extended
to carry two fields, one new and another gained new functionality:
 * VendorID is a new field that indicates that common subset of vendor
   option bits are supported as indicated by that VendorID.
 * AttributeModifier already exists, but overloaded to indicate which
   vendor options are supported by this VendorID.

This is kernel part of such functionality which is responsible to get data
from librdmacm and properly create and handle RDMA-CM messages.

Thanks

Leon Romanovsky (7):
  RDMA/cm: Add Enhanced Connection Establishment (ECE) bits
  RDMA/uapi: Add ECE definitions to UCMA
  RDMA/ucma: Extend ucma_connect to receive ECE parameters
  RDMA/ucma: Deliver ECE parameters through UCMA events
  RDMA/cm: Send and receive ECE parameter over the wire
  RDMA/cma: Connect ECE to rdma_accept
  RDMA/cma: Provide ECE reject reason

 drivers/infiniband/core/cm.c            | 41 ++++++++++++++++---
 drivers/infiniband/core/cma.c           | 52 ++++++++++++++++++++++---
 drivers/infiniband/core/cma_priv.h      |  1 +
 drivers/infiniband/core/ucma.c          | 40 +++++++++++++++----
 drivers/infiniband/ulp/isert/ib_isert.c |  4 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c   |  2 +-
 drivers/nvme/target/rdma.c              |  2 +-
 include/rdma/ib_cm.h                    | 10 ++++-
 include/rdma/ibta_vol1_c12.h            |  6 +++
 include/rdma/rdma_cm.h                  | 18 ++++++++-
 include/uapi/rdma/rdma_user_cm.h        | 15 ++++++-
 net/rds/ib_cm.c                         |  2 +-
 12 files changed, 167 insertions(+), 26 deletions(-)

--
2.25.2

