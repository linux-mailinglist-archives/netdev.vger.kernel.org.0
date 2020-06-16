Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31201FAE5D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgFPKp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgFPKp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 06:45:56 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51A1220734;
        Tue, 16 Jun 2020 10:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592304356;
        bh=MkqNImEBkOf3vylu3xXjuGjzWuW3rKF+OCfhYabCcx4=;
        h=From:To:Cc:Subject:Date:From;
        b=fIflkps4M4pU5wDHn3B+sqKi2Bl25ozKgW1YGJqJPQoMbBTLOmwXDLX7xI/RKpZWj
         sJVqtdkvwXm0da4GWLxK2r0+gudhLo0WH8QS/TitWL/saprGIMgCF69Fh9Uixcg7bE
         1BW2qmaUGiO2eTRZojFGFNSWOaRb3QXxnGNj+y/4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>
Subject: [PATCH rdma-next v2 00/11] RAW format dumps through RDMAtool
Date:   Tue, 16 Jun 2020 13:39:55 +0300
Message-Id: <20200616104006.2425549-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v2:
 * Converted to specific nldev ops for RAW.
 * Rebased on top of v5.8-rc1.
v1: https://lore.kernel.org/linux-rdma/20200527135408.480878-1-leon@kernel.org
 * Maor dropped controversial change to dummy interface.
v0:
https://lore.kernel.org/linux-rdma/20200513095034.208385-1-leon@kernel.org

------------------------------------------------------------------------------

Hi,

The following series adds support to get the RDMA resource data in RAW
format. The main motivation for doing this is to enable vendors to return
the entire QP/CQ/MR data without a need from the vendor to set each
field separately.

Thanks

Maor Gottlieb (11):
  net/mlx5: Export resource dump interface
  net/mlx5: Add support in query QP, CQ and MKEY segments
  RDMA/core: Don't call fill_res_entry for PD
  RDMA: Add dedicated MR resource tracker function
  RDMA: Add a dedicated CQ resource tracker function
  RDMA: Add dedicated QP resource tracker function
  RDMA: Add dedicated CM_ID resource tracker function
  RDMA: Add support to dump resource tracker in RAW format
  RDMA/mlx5: Add support to get QP resource in RAW format
  RDMA/mlx5: Add support to get CQ resource in RAW format
  RDMA/mlx5: Add support to get MR resource in RAW format

 drivers/infiniband/core/device.c              |  10 +-
 drivers/infiniband/core/nldev.c               | 176 +++++++++++-------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |   7 +-
 drivers/infiniband/hw/cxgb4/provider.c        |  11 +-
 drivers/infiniband/hw/cxgb4/restrack.c        |  24 +--
 drivers/infiniband/hw/hns/hns_roce_device.h   |   4 +-
 drivers/infiniband/hw/hns/hns_roce_main.c     |   2 +-
 drivers/infiniband/hw/hns/hns_roce_restrack.c |  14 +-
 drivers/infiniband/hw/mlx5/main.c             |   7 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   9 +-
 drivers/infiniband/hw/mlx5/restrack.c         | 105 +++++++++--
 .../mellanox/mlx5/core/diag/rsc_dump.c        |   6 +
 .../mellanox/mlx5/core/diag/rsc_dump.h        |  33 +---
 .../diag => include/linux/mlx5}/rsc_dump.h    |  25 +--
 include/rdma/ib_verbs.h                       |  13 +-
 include/uapi/rdma/rdma_netlink.h              |   8 +
 16 files changed, 264 insertions(+), 190 deletions(-)
 copy {drivers/net/ethernet/mellanox/mlx5/core/diag => include/linux/mlx5}/rsc_dump.h (68%)

--
2.26.2

