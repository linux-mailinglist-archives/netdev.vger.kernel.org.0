Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987B06B2412
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCIM0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCIM0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:26:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4232FEA01F;
        Thu,  9 Mar 2023 04:25:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5764761B46;
        Thu,  9 Mar 2023 12:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3CAC433D2;
        Thu,  9 Mar 2023 12:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678364757;
        bh=xC8SC6d1T+CjsNceu22LyGhdP405Ui+rHSffChfjnmQ=;
        h=From:To:Cc:Subject:Date:From;
        b=CPlzMiH2TgHscQHnOm0iKcGieIn6md8G9rQaJLuK6njJMlN2J8jLI1v9e/FOnMfeC
         vstdzcPh4fxnQ+D1rwmyUD6rEduUMjw92Ik5RK6RbvEWM/x5U2QAfEcADBenMiDsUM
         0z7nYLpJZEChdadYVcJIbp6PVvdZDrzokzNLPl2dqZ0Y01HrMexUaV2SluCohzd9wL
         A1v5qb0v94agpWNjKvDiNwcreUdWsOLNLOUytxa6h5x5yKeteMasbvGvojt1tSNrpt
         Q3R28S2X2aDd0RhJQoR3+CTJm8Bp5zqldo5EUiAb5Jv7nJuFINYZnk9UEgLQUr3xq8
         ferLYYH5uDXDw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: [PATCH net v2 0/8] update xdp_features flag according to NIC re-configuration
Date:   Thu,  9 Mar 2023 13:25:24 +0100
Message-Id: <cover.1678364612.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v1:
- rebase on top of net tree
- remove NETDEV_XDP_ACT_NDO_XMIT_SG support in mlx5e driver
- always enable NETDEV_XDP_ACT_NDO_XMIT support in mlx5e driver

Lorenzo Bianconi (7):
  tools: ynl: fix render-max for flags definition
  tools: ynl: fix get_mask utility routine
  xdp: add xdp_set_features_flag utility routine
  net: thunderx: take into account xdp_features setting tx/rx queues
  net: ena: take into account xdp_features setting tx/rx queues
  veth: take into account device reconfiguration for xdp_features flag
  net/mlx5e: take into account device reconfiguration for xdp_features
    flag

Matteo Croce (1):
  mvpp2: take care of xdp_features when reconfiguring queues

 Documentation/netlink/specs/netdev.yaml       |  1 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 15 +++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 ++-
 .../ethernet/cavium/thunder/nicvf_ethtool.c   | 17 +++++---
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  4 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 15 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 10 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 37 +++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 ++
 drivers/net/veth.c                            | 42 +++++++++++++++++--
 include/net/xdp.h                             | 11 +++++
 include/uapi/linux/netdev.h                   |  2 +
 net/core/xdp.c                                | 26 ++++++++----
 tools/include/uapi/linux/netdev.h             |  2 +
 tools/net/ynl/lib/nlspec.py                   |  6 +--
 tools/net/ynl/ynl-gen-c.py                    | 11 +++--
 17 files changed, 164 insertions(+), 45 deletions(-)

-- 
2.39.2

