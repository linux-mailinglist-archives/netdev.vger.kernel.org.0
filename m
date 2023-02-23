Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC5D6A0848
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 13:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbjBWMMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 07:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbjBWMMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 07:12:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0FF72E75;
        Thu, 23 Feb 2023 04:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72498CE1F4A;
        Thu, 23 Feb 2023 12:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A142C433EF;
        Thu, 23 Feb 2023 12:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677154306;
        bh=4pDXCjmlvHUT5yEPL00HJ/SacpAVtuu5rPi9d+IclyQ=;
        h=From:To:Cc:Subject:Date:From;
        b=VL7i/eSXSoov/MmvVUNRBNp1t8PGSvLb06glES6FPNLIu+CBqpNdBXv8YOCAQHmgB
         sUeZUHmJhDYH0JMdNe2WPugBG2T/ojdx8nb8+o48MaXLu7O7EFC48bCz3kRXMYBr8e
         gw0uLtY9Q+YnnQB6tdKykBL/nVwy0rtz0fRBWlYPwUSBGVQVwti0KjHGKJhfsxWwz1
         po3bpYuzHBGcUJZwHKJauhicrFndCv85s47IqC2JF2QcTBZHbyJYBWB6vRzT4PZBvg
         yFbX7YfuCoBSLQISNpWNM3DbE19IRQGTtZKO65tJSR4+fAvWBvdqxXh4xG1avEH25r
         hwbPSbGGBop2Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [RFC net-next 0/6] update xdp_features flag according to NIC re-configuration
Date:   Thu, 23 Feb 2023 13:11:32 +0100
Message-Id: <cover.1677153730.git.lorenzo@kernel.org>
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

Take into account possible NIC configuration changes (e.g. LRO or tx/rx queues
reconfiguration) setting device xdp_features flag.
Introduce xdp_set_features_flag utility routine.

Lorenzo Bianconi (6):
  tools: ynl: fix render-max for flags definition
  xdp: add xdp_set_features_flag utility routine
  net: thunderx: take into account xdp_features setting tx/rx queues
  net: ena: take into account xdp_features setting tx/rx queues
  veth: take into account device reconfiguration for xdp_features flag
  net/mlx5e: take into account device reconfiguration for xdp_features
    flag

 Documentation/netlink/specs/netdev.yaml       |  1 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 15 +++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 ++-
 .../ethernet/cavium/thunder/nicvf_ethtool.c   | 17 ++++---
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 10 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 45 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  3 ++
 drivers/net/veth.c                            | 42 +++++++++++++++--
 include/net/xdp.h                             | 11 +++++
 include/uapi/linux/netdev.h                   |  2 +
 net/core/xdp.c                                | 26 ++++++++---
 tools/include/uapi/linux/netdev.h             |  2 +
 tools/net/ynl/ynl-gen-c.py                    | 11 +++--
 15 files changed, 162 insertions(+), 34 deletions(-)

-- 
2.39.2

