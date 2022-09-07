Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D585B1076
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiIGXhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIGXhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54277E33B;
        Wed,  7 Sep 2022 16:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66DDF61AF2;
        Wed,  7 Sep 2022 23:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B509EC433D6;
        Wed,  7 Sep 2022 23:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593829;
        bh=fmr28kv/65U8JUTR7nL+T542LMSwkh0XA5b938laPIA=;
        h=From:To:Cc:Subject:Date:From;
        b=iXWDDgc3nSouXP1ACypdbUru4N3Os94Qx0fYPqGkykDUU8Iv+D1qBOm9S34EfGyPp
         wi9i5Byg3qdk23ptBWBuJ6BZwiE6Y7XrCxI8FXKbHFapi4hSppuHQZnQYZRQFe0wb1
         WFwvKHYVZ+fofjTUnK0OXpcOsS9KJjhBnQ1jlOitQhLlya7ZElgXP/XU1+jPvL6MYc
         fC0D8EAZrL3aBUKLQuS2zrqrIat/7rUF8BdjxtUiiXRiwYHPAQtKHZKgyPq+AhCxEU
         5dMeUtGVTqKTy1n0+K3sRLLVDhr16UrwgKn+wleT/tsJayarua+MBS0Gzf04nXs3bH
         SltJRTuMazpTQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 00/14] mlx5-next updates 2022-09-07
Date:   Wed,  7 Sep 2022 16:36:22 -0700
Message-Id: <20220907233636.388475-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series includes various mlx5 updates

1) HW definitions and support for NPPS clock settings.

2) NVMEoTCP HW capabilities and definitions 

3) crypt HW bits and definitions for upcoming ipsec and TLS improvements

4) various cleanups 

5)  Enable hash mode by default for all NICs

Liu, Changcheng Says:
=====================
When hardware lag hash mode is active, the explicit port affinity
of the QP/TIS is ignored. The steering rules inside the port-select
steering domain will determine the egress port.

To support setting explicit port affinity while using hardware lag
hash mode, a new capability of bypassing the port-select steering
domain is introduced.

The following patch series enable hash mode over NICs that support
the new capability:
5.1) Set the active port bit mask to let the firmware know which ports
   are down and which are up, so it can use this info when handling
   failover on QPs with explicit port affinity.
5.2) Remove the assignment of default port affinity by the driver as
   the user has dedicated userspace APIs to set the port affinity so
   the default configuration isn't needed anymore.
5.3) Detect and enable port-select bypass so explicit port affinity is
   honored by the firmware.
5.4) Enable hash mode by default on all NICs

When setting QP/TIS port affinity explicitly and hash mode is active
and the bypass port-select flow table capability is enabled by firmware,
firmware adds a steering rule to catch egress traffic of these QPs/TISs
and make their traffic skip the port-select steering domain. This adds
performance overhead for all QPs/TISs. The common use case is to not
set explicit port affinity(as when in hash, we don't need it). If there
is a user that does want to set port affinity, it can be done with the
dedicated userspace APIs.

Detect the bypass port-select flow table capability, set it to let
firmware know the driver supports this new capability.

=====================


Aya Levin (2):
  net/mlx5: Expose NPPS related registers
  net/mlx5: Add support for NPPS with real time mode

Ben Ben-Ishay (1):
  net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumerations

Gal Pressman (2):
  net/mlx5: Remove unused functions
  net/mlx5: Remove unused structs

Jianbo Liu (2):
  net/mlx5: Add IFC bits for general obj create param
  net/mlx5: Add IFC bits and enums for crypto key

Leon Romanovsky (1):
  net/mlx5: Remove from FPGA IFC file not-needed definitions

Liu, Changcheng (5):
  net/mlx5: add IFC bits for bypassing port select flow table
  RDMA/mlx5: Don't set tx affinity when lag is in hash mode
  net/mlx5: Lag, set active ports if support bypass port select flow
    table
  net/mlx5: Lag, enable hash mode by default for all NICs
  net/mlx5: detect and enable bypass port select flow table

Or Gerlitz (1):
  net/mlx5e: Rename from tls to transport static params

 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  12 +
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c |   6 +-
 .../mlx5/core/en_accel/common_utils.h         |  32 ++
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |   5 -
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |   6 +-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |   8 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c   |  36 +--
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 .../net/ethernet/mellanox/mlx5/core/health.c  |   7 -
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  91 +++++-
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 139 +++++++--
 .../net/ethernet/mellanox/mlx5/core/main.c    |  34 +++
 .../mellanox/mlx5/core/steering/dr_types.h    |  14 -
 .../mellanox/mlx5/core/steering/fs_dr.h       |   4 -
 include/linux/mlx5/device.h                   |  70 ++++-
 include/linux/mlx5/driver.h                   |   9 +-
 include/linux/mlx5/fs_helpers.h               |  48 ---
 include/linux/mlx5/mlx5_ifc.h                 | 280 ++++++++++++++++--
 include/linux/mlx5/mlx5_ifc_fpga.h            |  24 --
 include/linux/mlx5/qp.h                       |   1 +
 21 files changed, 629 insertions(+), 220 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/common_utils.h

-- 
2.37.2

