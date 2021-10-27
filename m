Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79B143BFF0
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbhJ0ChG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236588AbhJ0ChF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 053F660F0F;
        Wed, 27 Oct 2021 02:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302081;
        bh=QAD0p18+YjY3iclZzrelK32b/vLG3+YUNOL4TlomfHE=;
        h=From:To:Cc:Subject:Date:From;
        b=aeJGq4+Au/Zy+7Zj3La1jUnf/6cwOu2pnmD1x8TEvkDe/TTWEWEAWiPFMgmkfdt0y
         dQUqIlBGjWIO0JZ30p4ywS43N4VGgEx0hulm2oJkmr3H4Pf3Qle5cFKmUVwx0UKQSD
         zgPuN83xX8CGsN7WkH3DzJQy1Q9Dr/HUnKZWrvbVBFD0JlbMhvfILupQc/FTwds8/V
         G2UJ4xCdA+I+JFtbYwUwUrw80OzYEmYIbogV7cYGscm5Jr5cPQYN6v9D+lN/+Zkk7f
         9CzkJTLFH/GkwWMjHsaJCbNe9dO9WfYnN31TbdQ69k6WaSC9EdLHrwMqZFCFGas7vk
         fq/+onKD/fk+g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/14] mlx5 HW GRO 2021-10-26
Date:   Tue, 26 Oct 2021 19:33:33 -0700
Message-Id: <20211027023347.699076-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series adds HW GRO support to mlx5:

*Beside the HW GRO this series includes two trivial non-mlx5 patches:
 - net: Prevent HW-GRO and LRO features operate together
 - lib: bitmap: Introduce node-aware alloc API

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 06338ceff92510544a732380dbb2d621bd3775bf:

  net: phy: fixed warning: Function parameter not described (2021-10-26 14:09:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-10-26

for you to fetch changes up to 8ca9caee851c444810b70d9c167e7321f3ff68f8:

  net/mlx5: Lag, Make mlx5_lag_is_multipath() be static inline (2021-10-26 19:30:42 -0700)

----------------------------------------------------------------
mlx5-updates-2021-10-26

HW-GRO support in mlx5

Beside the HW GRO this series includes two trivial non-mlx5 patches:
 - net: Prevent HW-GRO and LRO features operate together
 - lib: bitmap: Introduce node-aware alloc API

Khalid Manaa Says:
==================
This series implements the HW-GRO offload using the HW feature SHAMPO.

HW-GRO: Hardware offload for the Generic Receive Offload feature.

SHAMPO: Split Headers And Merge Payload Offload.

This feature performs headers data split for each received packed and
merge the payloads of the packets of the same session.

There are new HW components for this feature:

The headers buffer:
– cyclic buffer where the packets headers will be located

Reservation buffer:
– capability to divide RQ WQEs to reservations, a definite size in
  granularity of 4KB, the reservation is used to define the largest segment
  that we can create by packets stitching.

Each reservation will have a session and the new received packet can be merged
to the session, terminate it, or open a new one according to the match criteria.

When a new packet is received the headers will be written to the headers buffer
and the data will be written to the reservation, in case the packet matches
the session the data will be written continuously otherwise it will be written
after performing an alignment.

SHAMPO RQ, WQ and CQE changes:
-----------------------------
RQ (receive queue) new params:

 -shampo_no_match_alignment_granularity: the HW alignment granularity in case
  the received packet doesn't match the current session.

 -shampo_match_criteria_type: the type of match criteria.

 -reservation_timeout: the maximum time that the HW will hold the reservation.

 -Each RQ has SKB that represents the current opened flow.

WQ (work queue) new params:

 -headers_mkey: mkey that represents the headers buffer, where the packets
  headers will be written by the HW.

 -shampo_enable: flag to verify if the WQ supports SHAMPO feature.

 -log_reservation_size: the log of the reservation size where the data of
  the packet will be written by the HW.

 -log_max_num_of_packets_per_reservation: log of the maximum number of packets
  that can be written to the same reservation.

 -log_headers_entry_size: log of the header entry size of the headers buffer.

 -log_headers_buffer_entry_num: log of the entries number of the headers buffer.

CQEs (Completion queue entry) SHAMPO fields:

 -match: in case it is set, then the current packet matches the opened session.

 -flush: in case it is set, the opened session must be flushed.

 -header_size: the size of the packet’s headers.

 -header_entry_index: the entry index in the headers buffer of the received
  packet headers.

 -data_offset: the offset of the received packet data in the WQE.

HW-GRO works as follow:
----------------------
The feature can be enabled on the interface using the ethtool command by
setting on rx-gro-hw. When the feature is on the mlx5 driver will reopen
the RQ to support the SHAMPO feature:

Will allocate the headers buffer and fill the parameters regarding the
reservation and the match criteria.

Receive packet flow:

each RQ will hold SKB that represents the current GRO opened session.

The driver has a new CQE handler mlx5e_handle_rx_cqe_mpwrq_shampo which will
use the CQE SHAMPO params to extract the location of the packet’s headers
in the headers buffer and the location of the packets data in the RQ.

Also, the CQE has two flags flush and match that indicate if the current
packet matches the current session or not and if we need to close the session.

In case there is an opened session, and we receive a matched packet then the
handler will merge the packet's payload to the current SKB, in case we receive
no match then the handler will flush the SKB and create a new one for the new packet.

In case the flash flag is set then the driver will close the session, the SKB
will be passed to the network stack.

In case the driver merges packets in the SKB, before passing the SKB to the network
stack the driver will update the checksum of the packet’s headers.

SKB build:
---------
The driver will build a new SKB in the following situations:
in case there is no current opened session.
In case the current packet doesn’t match the current session.
In case there is no place to add the packets data to the SKB that represents the
current session.

Otherwise, the driver will add the packet’s data to the SKB.

When the driver builds a new SKB, the linear area will contain only the packet headers
and the data will be added to the SKB fragments.

In case the entry size of the headers buffer is sufficient to build the SKB
it will be used, otherwise the driver will allocate new memory to build the SKB.

==================

----------------------------------------------------------------
Ben Ben-Ishay (5):
      net/mlx5e: Rename lro_timeout to packet_merge_timeout
      net/mlx5: Add SHAMPO caps, HW bits and enumerations
      net/mlx5e: Add support to klm_umr_wqe
      net/mlx5e: Add control path for SHAMPO feature
      net/mlx5e: Add data path for SHAMPO feature

Ben Ben-ishay (1):
      net: Prevent HW-GRO and LRO features operate together

Khalid Manaa (6):
      net/mlx5e: Rename TIR lro functions to TIR packet merge functions
      net/mlx5e: Add handle SHAMPO cqe support
      net/mlx5e: HW_GRO cqe handler implementation
      net/mlx5e: Add HW_GRO statistics
      net/mlx5e: Add HW-GRO offload
      net/mlx5e: Prevent HW-GRO and CQE-COMPRESS features operate together

Maor Dickman (1):
      net/mlx5: Lag, Make mlx5_lag_is_multipath() be static inline

Tariq Toukan (1):
      lib: bitmap: Introduce node-aware alloc API

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  75 ++-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    | 163 +++++-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c   |  23 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.h   |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    |  25 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.h    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c   |  32 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.h   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   6 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   9 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 285 ++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 646 ++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  15 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   6 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 include/linux/bitmap.h                             |   2 +
 include/linux/mlx5/device.h                        |  28 +-
 include/linux/mlx5/mlx5_ifc.h                      |  64 +-
 lib/bitmap.c                                       |  13 +
 net/core/dev.c                                     |   5 +
 26 files changed, 1300 insertions(+), 164 deletions(-)
