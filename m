Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FB3423AE9
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbhJFJyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhJFJyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3AC161058;
        Wed,  6 Oct 2021 09:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633513941;
        bh=WQ9lonj2MyHT8a8ySnd9ygRRib8ZIQLpYLmUUWJKrAg=;
        h=From:To:Cc:Subject:Date:From;
        b=gsJkdHZ3Cr2anmFMNymXxI8B8Zp4J7o1CzYlA3sHVqJXitbZq7QNyWBMraiWAtJ+N
         0BNJ+sXvESTx1kzPTW5tsulQdi+Sq8X7L5FPOTKPHh8R+OTGoZFj81x4Ms+Oi7FGO+
         saUvJ/BaOh2BUpS9hLk5os4aDQCU4nGvdjQnqtyeX4xSYnzOyL4E2C/sz2d2miT2KW
         GC8WH9Wk9DHO46Vw+IXMnLhmQTp0YAzuOi1vlQH7SSXZE1L8rnaAllPWy5y/4/YeuX
         QJkcn9O+0D6zcHHvVA3Av54HnxuGRANNGU1OylIJHi2bG1YfkdM3rkc/xWnotfS4UU
         M2vtLRzKSIJ2g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next v3 00/13] Optional counter statistics support
Date:   Wed,  6 Oct 2021 12:52:03 +0300
Message-Id: <cover.1633513239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Change Log:
v3:
 * Many cosmetic changes
 * Fixed rebase error which caused to have two same patches with
   different implementation.
 * New patch that split nldev_stat_set_doit.
v2: https://lore.kernel.org/all/cover.1632988543.git.leonro@nvidia.com
 * Add rdma_free_hw_stats_struct() helper API (with a new patch)
 * In sysfs add a WARN_ON to check if optional stats are always at the end
 * Add a new nldev command to get the counter status
 * Improve nldev_stat_set_counter_dynamic_doit() by creating a target state bitmap
v1: https://lore.kernel.org/all/cover.1631660727.git.leonro@nvidia.com
* Add a descriptor structure to replace name in struct rdma_hw_stats;
* Add a bitmap in struct rdma_hw_stats to indicate the enable/disable
  status of all counters;
* Add a "flag" field in counter descriptor and define
  IB_STAT_FLAG_OPTIONAL flag;
* add/remove_op_stat() are replaced by modify_op_stat();
* Use "set/unset" in command line and send full opcounters list through
  netlink, and send opcounter indexes instead of names;
* Patches are re-ordered.
v0: https://lore.kernel.org/all/20210818112428.209111-1-markzhang@nvidia.com

----------------------------------------------------------------------
Hi,

This series from Neta and Aharon provides an extension to the rdma
statistics tool that allows to set optional counters dynamically, using
netlink.

The idea of having optional counters is to provide to the users the
ability to get statistics of counters that hurts performance.

Once an optional counter was added, its statistics will be presented
along with all the counters, using the show command.

Binding objects to the optional counters is currently not supported,
neither in auto mode nor in manual mode.

To get the list of optional counters that are supported on this device,
use "rdma statistic mode supported". To see which counters are currently
enabled, use "rdma statistic mode".

Examples:

$ rdma statistic mode supported
link rocep8s0f0/1 supported optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts,cc_tx_cnp_pkts
link rocep8s0f1/1 supported optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts,cc_tx_cnp_pkts

$ sudo rdma statistic set link rocep8s0f0/1 optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts
$ rdma statistic mode link rocep8s0f0/1
link rocep8s0f0/1 optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts

$ rdma statistic show link rocep8s0f0/1
link rocep8s0f0/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0
out_of_sequence 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 0 implied_nak_seq_err 0
local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0 req_cqe_error 0
req_remote_invalid_request 0 req_remote_access_errors 0 resp_remote_access_errors 0
resp_cqe_flush_error 0 req_cqe_flush_error 0 roce_adp_retrans 0 roce_adp_retrans_to 0
roce_slow_restart 0 roce_slow_restart_cnps 0 roce_slow_restart_trans 0 rp_cnp_ignored 0
rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0 rx_icrc_encapsulated 0 cc_rx_ce_pkts 0
cc_rx_cnp_pkts 0

$ sudo rdma statistic set link rocep8s0f0/1 optional-counters cc_rx_ce_pkts
$ rdma statistic mode link rocep8s0f0/1
link rocep8s0f0/1 optional-counters cc_rx_ce_pkts

Thanks

Aharon Landau (12):
  net/mlx5: Add ifc bits to support optional counters
  net/mlx5: Add priorities for counters in RDMA namespaces
  RDMA/counter: Add a descriptor in struct rdma_hw_stats
  RDMA/counter: Add an is_disabled field in struct rdma_hw_stats
  RDMA/counter: Add optional counter support
  RDMA/nldev: Add support to get status of all counters
  RDMA/nldev: Split nldev_stat_set_mode_doit out of nldev_stat_set_doit
  RDMA/nldev: Allow optional-counter status configuration through RDMA
    netlink
  RDMA/mlx5: Support optional counters in hw_stats initialization
  RDMA/mlx5: Add steering support in optional flow counters
  RDMA/mlx5: Add modify_op_stat() support
  RDMA/mlx5: Add optional counter support in get_hw_stats callback

Mark Zhang (1):
  RDMA/core: Add a helper API rdma_free_hw_stats_struct

 drivers/infiniband/core/counters.c            |  40 ++-
 drivers/infiniband/core/device.c              |   1 +
 drivers/infiniband/core/nldev.c               | 235 +++++++++++++--
 drivers/infiniband/core/sysfs.c               |  52 ++--
 drivers/infiniband/core/verbs.c               |  45 +++
 drivers/infiniband/hw/bnxt_re/hw_counters.c   | 137 +++++----
 drivers/infiniband/hw/cxgb4/provider.c        |  22 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |  19 +-
 drivers/infiniband/hw/hfi1/verbs.c            |  53 ++--
 drivers/infiniband/hw/irdma/verbs.c           | 100 +++----
 drivers/infiniband/hw/mlx4/main.c             |  44 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |   2 +-
 drivers/infiniband/hw/mlx5/counters.c         | 282 +++++++++++++++---
 drivers/infiniband/hw/mlx5/fs.c               | 187 ++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  28 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.c   |  42 +--
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  54 +++-
 include/linux/mlx5/device.h                   |   2 +
 include/linux/mlx5/fs.h                       |   2 +
 include/linux/mlx5/mlx5_ifc.h                 |  22 +-
 include/rdma/ib_hdrs.h                        |   1 +
 include/rdma/ib_verbs.h                       |  58 ++--
 include/rdma/rdma_counter.h                   |   2 +
 include/uapi/rdma/rdma_netlink.h              |   5 +
 24 files changed, 1094 insertions(+), 341 deletions(-)

-- 
2.31.1

