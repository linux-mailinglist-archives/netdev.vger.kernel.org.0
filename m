Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9126240BBE1
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhINXI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231559AbhINXIx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 19:08:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2E7661165;
        Tue, 14 Sep 2021 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631660855;
        bh=AvmdHBEV9K2J31gkeEwlU6AlZerrMIwB/huPokwGtJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Cj5dHOClv9iMhicqFN+mL8qB5LxUrQmghyPQLF48OTXzoZDrKAnFP7XzXL4NXiwdf
         SeGDhHSX6T/FyJktZn7qs8T4FqWGrlbooOMcgfwa1g0xpvpBRwrKlmoT20LIpgwUZU
         dPM5iATnmK7lcMZbSIrixEUuNZGvqH21P6JEJNvONbszEDMqU9xj3TbSKB8Yrdiz2U
         k5XSo/mYoeCYK6pYIXRUCxWTMPSjW9vVfL2H3oGV4JJfO+nSahweAo9WFf/tKPDH8P
         SKEzMnCrG6H6o3rmfY201I1gHufPy8AMwuZ7z6pEgK+fWwTEamGrtc/GhyKYsrFAeE
         TtIiY3qyKWu2g==
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
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next v1 00/11] Optional counter statistics support
Date:   Wed, 15 Sep 2021 02:07:19 +0300
Message-Id: <cover.1631660727.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Change Log:
v1:
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

Aharon Landau (11):
  net/mlx5: Add ifc bits to support optional counters
  net/mlx5: Add priorities for counters in RDMA namespaces
  RDMA/counter: Add a descriptor in struct rdma_hw_stats
  RDMA/counter: Add an is_disabled field in struct rdma_hw_stats
  RDMA/counter: Add optional counter support
  RDMA/nldev: Add support to get status of all counters
  RDMA/nldev: Allow optional-counter status configuration through RDMA
    netlink
  RDMA/mlx5: Support optional counters in hw_stats initialization
  RDMA/mlx5: Add steering support in optional flow counters
  RDMA/mlx5: Add modify_op_stat() support
  RDMA/mlx5: Add optional counter support in get_hw_stats callback

 drivers/infiniband/core/counters.c            |  30 +-
 drivers/infiniband/core/device.c              |   1 +
 drivers/infiniband/core/nldev.c               | 289 +++++++++++++-----
 drivers/infiniband/core/sysfs.c               |  41 ++-
 drivers/infiniband/hw/bnxt_re/hw_counters.c   | 114 +++----
 drivers/infiniband/hw/cxgb4/provider.c        |  22 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |  19 +-
 drivers/infiniband/hw/hfi1/verbs.c            |  43 +--
 drivers/infiniband/hw/irdma/verbs.c           |  98 +++---
 drivers/infiniband/hw/mlx4/main.c             |  37 +--
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |   2 +-
 drivers/infiniband/hw/mlx5/counters.c         | 280 ++++++++++++++---
 drivers/infiniband/hw/mlx5/fs.c               | 187 ++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  28 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.c   |  42 +--
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  54 +++-
 include/linux/mlx5/device.h                   |   2 +
 include/linux/mlx5/fs.h                       |   2 +
 include/linux/mlx5/mlx5_ifc.h                 |  22 +-
 include/rdma/ib_hdrs.h                        |   1 +
 include/rdma/ib_verbs.h                       |  48 ++-
 include/rdma/rdma_counter.h                   |   2 +
 include/uapi/rdma/rdma_netlink.h              |   3 +
 23 files changed, 1041 insertions(+), 326 deletions(-)

-- 
2.31.1

