Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A485ADEE0
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiIFFVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiIFFVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF326CF64
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B843961296
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0925AC433C1;
        Tue,  6 Sep 2022 05:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441699;
        bh=qt2i5IG1Uzx7t2o2Q0jqx7l3kbl7Sseww51m8AhVhgQ=;
        h=From:To:Cc:Subject:Date:From;
        b=oBv0/iheoenZdCCGz+qppsL0SaeA8AZWLq0i7HWu/GncK1h6InBpm7lBm66rLo8LY
         d/yaf/NG4AtOjIpZ75c2hhYdPzCWTXFqixBT1UOAHjWnjcuLo1tpUzNbxbFBdg8Ryd
         c3Tyffk4F7UA16d03zd5UAFYN259zCbuIHLWKmq4HZ/sWOp+pQtlH6MkydWT2OWkzd
         qBFgvHKAy4t2g9nlwJYuV2sT/UyQfT1sjgJtJdZfcwGiCos35YORIPArRHrAgpKwJ+
         a9ju1R+bYLPwP2sBVfezORmszd2Ti4wae6mnqULugb/CV0j5Sp6X272P49MYwv4Zp3
         zVPci1zSLtytw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 00/17] Introduce MACsec skb_metadata_dst and mlx5 macsec offload
Date:   Mon,  5 Sep 2022 22:21:12 -0700
Message-Id: <20220906052129.104507-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

v1->v2:
   - attach mlx5 implementation patches.  

This patchset introduces MACsec skb_metadata_dst to lay the ground
for MACsec HW offload.

MACsec is an IEEE standard (IEEE 802.1AE) for MAC security.
It defines a way to establish a protocol independent connection
between two hosts with data confidentiality, authenticity and/or
integrity, using GCM-AES. MACsec operates on the Ethernet layer and
as such is a layer 2 protocol, which means it’s designed to secure
traffic within a layer 2 network, including DHCP or ARP requests.

Linux has a software implementation of the MACsec standard and
HW offloading support.
The offloading is re-using the logic, netlink API and data
structures of the existing MACsec software implementation.

For Tx:
In the current MACsec offload implementation, MACsec interfaces shares
the same MAC address by default.
Therefore, HW can't distinguish from which MACsec interface the traffic
originated from.

MACsec stack will use skb_metadata_dst to store the SCI value, which is
unique per MACsec interface, skb_metadat_dst will be used later by the
offloading device driver to associate the SKB with the corresponding
offloaded interface (SCI) to facilitate HW MACsec offload.

For Rx:
Like in the Tx changes, if there are more than one MACsec device with
the same MAC address as in the packet's destination MAC, the packet will
be forward only to one of the devices and not neccessarly to the desired one.

Offloading device driver sets the MACsec skb_metadata_dst sci
field with the appropriaate Rx SCI for each SKB so the MACsec rx handler
will know to which port to divert those skbs, instead of wrongly solely
relaying on dst MAC address comparison.

1) patch 1,2, Add support to skb_metadata_dst in MACsec code:
net/macsec: Add MACsec skb_metadata_dst Tx Data path support
net/macsec: Add MACsec skb_metadata_dst Rx Data path support

2) patch 3, Move some MACsec driver code for sharing with various
drivers that implements offload:
net/macsec: Move some code for sharing with various drivers that
implements offload

3) The rest of the patches introduce mlx5 implementation for macsec
offloads TX and RX via steering tables.
  a) TX, intercept skbs with macsec offlad mark in skb_metadata_dst and mark
the descriptor for offload.
  b) RX, intercept offloaded frames and prepare the proper
skb_metadata_dst to mark offloaded rx frames.

Lior Nahmanson (17):
  net/macsec: Add MACsec skb_metadata_dst Tx Data path support
  net/macsec: Add MACsec skb_metadata_dst Rx Data path support
  net/macsec: Move some code for sharing with various drivers that
    implements offload
  net/mlx5: Removed esp_id from struct mlx5_flow_act
  net/mlx5: Generalize Flow Context for new crypto fields
  net/mlx5: Introduce MACsec Connect-X offload hardware bits and
    structures
  net/mlx5: Add MACsec offload Tx command support
  net/mlx5: Add MACsec Tx tables support to fs_core
  net/mlx5e: Add MACsec TX steering rules
  net/mlx5e: Implement MACsec Tx data path using MACsec skb_metadata_dst
  net/mlx5e: Add MACsec offload Rx command support
  net/mlx5: Add MACsec Rx tables support to fs_core
  net/mlx5e: Add MACsec RX steering rules
  net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst
  net/mlx5e: Add MACsec offload SecY support
  net/mlx5e: Add MACsec stats support for Rx/Tx flows
  net/mlx5e: Add support to configure more than one macsec offload
    device

 .../net/ethernet/mellanox/mlx5/core/Kconfig   |    8 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |    3 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   15 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |    9 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |    4 +-
 .../mellanox/mlx5/core/en_accel/macsec.c      | 1332 ++++++++++++++++
 .../mellanox/mlx5/core/en_accel/macsec.h      |   72 +
 .../mellanox/mlx5/core/en_accel/macsec_fs.c   | 1384 +++++++++++++++++
 .../mellanox/mlx5/core/en_accel/macsec_fs.h   |   47 +
 .../mlx5/core/en_accel/macsec_stats.c         |   72 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |    7 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |    4 +
 .../ethernet/mellanox/mlx5/core/en_stats.c    |    3 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |    1 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |    3 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |    9 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   31 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |    7 +
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |    1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |    1 +
 drivers/net/macsec.c                          |   54 +-
 include/linux/mlx5/device.h                   |    4 +
 include/linux/mlx5/fs.h                       |   12 +-
 include/linux/mlx5/mlx5_ifc.h                 |  111 +-
 include/linux/mlx5/qp.h                       |    1 +
 include/net/dst_metadata.h                    |   10 +
 include/net/macsec.h                          |   25 +
 28 files changed, 3180 insertions(+), 53 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_stats.c

-- 
2.37.2

