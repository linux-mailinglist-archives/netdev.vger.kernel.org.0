Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC394F1468
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbiDDMKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbiDDMKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C343DA53;
        Mon,  4 Apr 2022 05:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D5416100D;
        Mon,  4 Apr 2022 12:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E72DC340EE;
        Mon,  4 Apr 2022 12:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649074104;
        bh=sX8/cZqAL44/bta/9jcW0etlM58KH8MfGrd7sNqm/5Y=;
        h=From:To:Cc:Subject:Date:From;
        b=q/wXMXVieoTtN4GpAAfbsFtRZN7OoT5mFWNfKhjuQdjkiY3tLyc17lJgjv5PVDIiU
         veHzD6nL6pMR4zyIZpds5jhDzDAQPZ4VmxY1dCN67mJj9oL4/NvfaaWJDFe8vew7z9
         B+ob3uqTvFF2+BihYhZv+OUsH7pQFtccc/JK64X7N5olbJGm7bAKi9HiA4wJVzzRTb
         ztW/NScQzmzHfElfYPW/pbiOwYLnpqJ+dpiMNwa67TQDlpTIiwC4J0zh3c5OvhimLk
         xoqJU2BERou3ep70DaMt9R7yyRBZYPr9winNjburLrie+PXjjyI4PKfpLbWmEjkqU4
         ezEWFkgMs8XfQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH mlx5-next 0/5] Drop Mellanox FPGA TLS support from the kernel
Date:   Mon,  4 Apr 2022 15:08:14 +0300
Message-Id: <cover.1649073691.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
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

From: Leon Romanovsky <leonro@nvidia.com>

Mellanox INNOVA TLS cards are EOL in May, 2018 [1]. As such, the code
is unmaintained, untested and not in-use by any upstream/distro oriented
customers. In order to reduce code complexity, drop the kernel code,
clean build config options and delete useless kTLS vs. TLS separation.
    
[1] https://network.nvidia.com/related-docs/eol/LCR-000286.pdf
    
Thanks

BTW, the target of this series is mlx5-next, as other series removes
FPGA IPsec together with relevant cleanup in RDMA side.

Leon Romanovsky (5):
  net/mlx5_fpga: Drop INNOVA TLS support
  net/mlx5: Reliably return TLS device capabilities
  net/mlx5: Remove indirection in TLS build
  net/mlx5: Remove tls vs. ktls separation as it is the same
  net/mlx5: Cleanup kTLS function names and their exposure

 .../net/ethernet/mellanox/mlx5/core/Kconfig   |  25 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   5 +-
 .../ethernet/mellanox/mlx5/core/accel/tls.c   | 125 ----
 .../ethernet/mellanox/mlx5/core/accel/tls.h   | 156 -----
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 -
 .../ethernet/mellanox/mlx5/core/en/params.c   |   6 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  11 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |  71 +-
 .../mellanox/mlx5/core/en_accel/ktls.h        |  86 ++-
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |   2 +-
 .../en_accel/{tls_stats.c => ktls_stats.c}    |  51 +-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  20 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |  28 +-
 .../mellanox/mlx5/core/en_accel/ktls_utils.h  |   1 -
 .../mellanox/mlx5/core/en_accel/tls.c         | 247 -------
 .../mellanox/mlx5/core/en_accel/tls.h         | 132 ----
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    | 390 -----------
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    |  91 ---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   5 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   8 +-
 .../ethernet/mellanox/mlx5/core/fpga/core.h   |   1 -
 .../ethernet/mellanox/mlx5/core/fpga/tls.c    | 622 ------------------
 .../ethernet/mellanox/mlx5/core/fpga/tls.h    |  74 ---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  10 -
 include/linux/mlx5/mlx5_ifc_fpga.h            |  63 --
 27 files changed, 221 insertions(+), 2025 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
 rename drivers/net/ethernet/mellanox/mlx5/core/en_accel/{tls_stats.c => ktls_stats.c} (63%)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h

-- 
2.35.1

