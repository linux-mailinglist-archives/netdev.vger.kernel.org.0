Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8B2640EF8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiLBUPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLBUPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29072191
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DE1F62231
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2231CC433C1;
        Fri,  2 Dec 2022 20:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012109;
        bh=dezJKiwmMwZyhR5sxb4TQfFMoqqGedvjxjDY3wteiHI=;
        h=From:To:Cc:Subject:Date:From;
        b=nD2SQTRti/WXyMPD2YHRtucin4JSXRcZ1fAJlbT/I0Q7Q+idfvleOwAF/4XVK5vkG
         lpXQoEJ8dEK/aNimbQtaoLQ9D0NeAYZJmcx//l6Y2g5GsGAff+GnOekVHUc3lydK0S
         2m4iFDvId1re6oKLDeUE42xc0ZqXQQMgqNmZK1P5SYlW3n8RvzSaqWj2jtsgM+F6Tp
         EVLxG/2DxbTJMdI697DFeXc3t/rpvjgkrU3XdhQ5xVkY9JqI/GT4fG5T7V0VCZbpkQ
         2dF/MPKWNY+Vih4hfuEJN4tafEy5JuQ51+wtEjM9d5zQEoJ6gw+8dLhANmTrRH0ger
         IEVuKpt5mrroA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next 00/13] mlx5 IPsec packet offload support (Part I)
Date:   Fri,  2 Dec 2022 22:14:44 +0200
Message-Id: <cover.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This is second part with implementation of packet offload.

Thanks

Leon Romanovsky (12):
  net/mlx5e: Create IPsec policy offload tables
  net/mlx5e: Add XFRM policy offload logic
  net/mlx5e: Use same coding pattern for Rx and Tx flows
  net/mlx5e: Configure IPsec packet offload flow steering
  net/mlx5e: Improve IPsec flow steering autogroup
  net/mlx5e: Skip IPsec encryption for TX path without matching policy
  net/mlx5e: Provide intermediate pointer to access IPsec struct
  net/mlx5e: Store all XFRM SAs in Xarray
  net/mlx5e: Update IPsec soft and hard limits
  net/mlx5e: Handle hardware IPsec limits events
  net/mlx5e: Handle ESN update events
  net/mlx5e: Open mlx5 driver to accept IPsec packet offload

Raed Salem (1):
  net/mlx5e: Add statistics for Rx/Tx IPsec offloaded flows

 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   3 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 312 +++++++++---
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  84 ++-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 482 +++++++++++++++++-
 .../mlx5/core/en_accel/ipsec_offload.c        | 196 +++++++
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  |  22 +-
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c |  52 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   1 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   5 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   6 +-
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h |   1 +
 12 files changed, 1047 insertions(+), 118 deletions(-)

-- 
2.38.1

