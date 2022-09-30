Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED9B5F0FF7
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiI3Q3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiI3Q3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C84A1C3DF9
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 965F7CE2619
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8C3C433C1;
        Fri, 30 Sep 2022 16:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555365;
        bh=CtyIou0c8NkMQ+tj6MfJ03/EFtW5URsy3jxkZDzA4ZQ=;
        h=From:To:Cc:Subject:Date:From;
        b=JGyQEm0xPI0RQ+bbGCbBakGNM0P4plBK85TwlhkkGP48yidpfY3Q6U539vwxJ5JoS
         uc5Je/Lksl+AYEu7H6UqfhoRmQ7SMTTf9fwvSNWIr/X8dw22idkJpj0vm6uMeIyAPz
         fDd7+7O4h9KO7EOZ0XpTmEowNyaeyU9ABbgs8kAKmLSG8QhyUz8WZcpL1AXQRqnJB7
         dAtlJg32Njdw+naK+hrapg5Z4MMuV9p0OszAoHa5ZtzC68xZ29rZIZaA2tbYlpBzuW
         +5yhgZqEzwAH9TmhIco60xjuScNM9139nWQnUIX0Xi77C7+I5L3pNHr4CzB9Hsl3QA
         KeSRmjfBssjfg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 00/16] mlx5 xsk updates part3 2022-09-30
Date:   Fri, 30 Sep 2022 09:28:47 -0700
Message-Id: <20220930162903.62262-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

The gist of this 4 part series is in this patchset's last patch

This series contains performance optimizations. XSK starts using the
batching allocator, and XSK data path gets separated from the regular
RX, allowing to drop some branches not relevant for non-XSK use cases.
Some minor optimizations for indirect calls and need_wakeup are also
included.

Other than that, this series adds a few features to the mlx5e
implementation of XSK:

1. XDP metadata support on XSK RQs.

2. RSS contexts support for XSK RQs.

3. Some other optimizations 

4. Last but not least, change the queuing scheme, so that XSK RQs no longer
use higher indices, but replace the regular RQs.

Maxim Says:
==========

In the initial implementation of XSK in mlx5e, XSK RQs coexisted with
regular RQs in the same channel. The main idea was to allow RSS work the
same for regular traffic, without need to reconfigure RSS to exclude XSK
queues.

However, this scheme didn't prove to be beneficial, mainly because of
incompatibility with other vendors. Some tools don't properly support
using higher indices for XSK queues, some tools get confused with the
double amount of RQs exposed in sysfs. Some use cases are purely XSK,
and allocating the same amount of unused regular RQs is a waste of
resources.

This commit changes the queuing scheme to the standard one, where XSK
RQs replace regular RQs on the channels where XSK sockets are open. Two
RQs still exist in the channel to allow failsafe disable of XSK, but
only one is exposed at a time. The next commit will achieve the desired
memory save by flushing the buffers when the regular RQ is unused.

As the result of this transition:

1. It's possible to use RSS contexts over XSK RQs.

2. It's possible to dedicate all queues to XSK.

3. When XSK RQs coexist with regular RQs, the admin should make sure no
unwanted traffic goes into XSK RQs by either excluding them from RSS or
settings up the XDP program to return XDP_PASS for non-XSK traffic.

4. When using a mixed fleet of mlx5e devices and other netdevs, the same
configuration can be applied. If the application supports the fallback
to copy mode on unsupported drivers, it will work too.

==========

Part 4 will include some final xsk optimizations and minor improvements

part 1: https://lore.kernel.org/netdev/20220927203611.244301-1-saeed@kernel.org/
part 2: https://lore.kernel.org/netdev/20220929072156.93299-1-saeed@kernel.org/

Maxim Mikityanskiy (16):
  net/mlx5e: xsk: Use mlx5e_trigger_napi_icosq for XSK wakeup
  net/mlx5e: xsk: Drop the check for XSK state in mlx5e_xsk_wakeup
  net/mlx5e: Introduce wqe_index_mask for legacy RQ
  net/mlx5e: Make the wqe_index_mask calculation more exact
  net/mlx5e: Use partial batches in legacy RQ
  net/mlx5e: xsk: Use partial batches in legacy RQ with XSK
  net/mlx5e: Remove the outer loop when allocating legacy RQ WQEs
  net/mlx5e: xsk: Split out WQE allocation for legacy XSK RQ
  net/mlx5e: xsk: Use xsk_buff_alloc_batch on legacy RQ
  net/mlx5e: xsk: Use xsk_buff_alloc_batch on striding RQ
  net/mlx5e: Use non-XSK page allocator in SHAMPO
  net/mlx5e: Call mlx5e_page_release_dynamic directly where possible
  net/mlx5e: Optimize RQ page deallocation
  net/mlx5e: xsk: Support XDP metadata on XSK RQs
  net/mlx5e: Introduce the mlx5e_flush_rq function
  net/mlx5e: xsk: Use queue indices starting from 0 for XSK queues

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  10 +-
 .../ethernet/mellanox/mlx5/core/en/channels.c |  29 ++-
 .../ethernet/mellanox/mlx5/core/en/channels.h |   3 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   |  44 +++-
 .../ethernet/mellanox/mlx5/core/en/params.h   |  32 ---
 .../mellanox/mlx5/core/en/reporter_rx.c       |  23 +-
 .../ethernet/mellanox/mlx5/core/en/rx_res.c   | 118 ++--------
 .../ethernet/mellanox/mlx5/core/en/rx_res.h   |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   7 +
 .../ethernet/mellanox/mlx5/core/en/xsk/pool.c |  17 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 176 ++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   3 +
 .../mellanox/mlx5/core/en/xsk/setup.c         |   4 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  12 +-
 .../mellanox/mlx5/core/en_fs_ethtool.c        |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  52 +++--
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   3 -
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 211 +++++++-----------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |   1 -
 .../mellanox/mlx5/core/ipoib/ipoib_vlan.c     |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/wq.h  |   2 +-
 21 files changed, 385 insertions(+), 385 deletions(-)

-- 
2.37.3

