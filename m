Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4BD1E1FB9
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 12:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbgEZKdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 06:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731745AbgEZKdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 06:33:10 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A27020776;
        Tue, 26 May 2020 10:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590489189;
        bh=pq8On3WUlO+xI1ImWpqd/5ofHohCbw1G+yEvp3sHefs=;
        h=From:To:Cc:Subject:Date:From;
        b=qkE3vJD9pAkF3cpL6g/1BJ8bDOux9VE1YndQK4NqxcMh4hT2fmc40ZL5t9TsMrLkG
         qbQSJclWxYQTHsvHpBI2AXOJrwu3R5UBhsw9393Ad6ubNcE9wVhHthIvjWc46dgnlQ
         JIsvvXdejMOAtF4xzU3albNtewmk9ma1rOo0IF+Y=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        target-devel@vger.kernel.org
Subject: [PATCH rdma-next v3 0/6] Add Enhanced Connection Established (ECE)
Date:   Tue, 26 May 2020 13:32:58 +0300
Message-Id: <20200526103304.196371-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
 v3:
 * Rebased on top of ebd6e96b33a2 RDMA/ipoib: Remove can_sleep parameter from iboib_mcast_alloc
 * Updated rdma_reject patch to include newly added RTR ulp
 * Remove empty hunks added by rebase
 * Changed signature of rdma_reject so kernel users will provide reason by themselves
 * Squashed UAPI patch to other patches which add functionality
 * Removed define of the IBTA reason from UAPI
 v2: https://lore.kernel.org/linux-rdma/20200413141538.935574-1-leon@kernel.org/
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

Leon Romanovsky (6):
  RDMA/cm: Add Enhanced Connection Establishment (ECE) bits
  RDMA/ucma: Extend ucma_connect to receive ECE parameters
  RDMA/ucma: Deliver ECE parameters through UCMA events
  RDMA/cm: Send and receive ECE parameter over the wire
  RDMA/cma: Connect ECE to rdma_accept
  RDMA/cma: Provide ECE reject reason

 drivers/infiniband/core/cm.c            | 39 ++++++++++++++---
 drivers/infiniband/core/cma.c           | 57 ++++++++++++++++++++++---
 drivers/infiniband/core/cma_priv.h      |  1 +
 drivers/infiniband/core/ucma.c          | 49 +++++++++++++++++----
 drivers/infiniband/ulp/isert/ib_isert.c |  4 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c  |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c   |  3 +-
 drivers/nvme/target/rdma.c              |  3 +-
 include/rdma/ib_cm.h                    |  9 +++-
 include/rdma/ibta_vol1_c12.h            |  6 +++
 include/rdma/rdma_cm.h                  |  9 +++-
 include/uapi/rdma/rdma_user_cm.h        | 11 ++++-
 net/rds/ib_cm.c                         |  4 +-
 13 files changed, 170 insertions(+), 27 deletions(-)

--
2.26.2

