Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9D14FACB1
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbiDJIax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiDJIax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:30:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA1158E4F;
        Sun, 10 Apr 2022 01:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8310CB80AF9;
        Sun, 10 Apr 2022 08:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB84BC385A1;
        Sun, 10 Apr 2022 08:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579321;
        bh=qRMzgtc1bD92Knvz5GKXTTnhJa0dZOVMt7Cm9r5shd8=;
        h=From:To:Cc:Subject:Date:From;
        b=aU4TnU6jH/PA2nEGDVlkkD/Dr9BipOqn81b3C4Hpc3dFuI4GMrQ9rLHza9DboeEN/
         cGg+O1vPMTU2Rcug0uLrwQbCal1cazGSzjSrdRsoBwNs7Gb6Y790Ezw3o0Z2XqB6s6
         TQAumO/ucMpNM3fiZD3x7irF45y4QMexKC/WMU2R4eOq+W6BWw1pSFg6lTN/KFf+uF
         rW/u/6uKEeKnvllHU6uAaf6U5FHwwSGdHBD4XgtUcCY1U4uOMav1KCQlZScnOSBg/2
         mE2prxpnQ/Dk+FtvmgTAEH64xkWhvEvabID0vWGR0OMNf5B4YAZH1AGy9p7F5C9TvI
         xh8kCOFwb1Y4w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 00/17] Extra IPsec cleanup
Date:   Sun, 10 Apr 2022 11:28:18 +0300
Message-Id: <cover.1649578827.git.leonro@nvidia.com>
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

After FPGA IPsec removal, we can go further and make sure that flow
steering logic is aligned to mlx5_core standard together with deep
cleaning of whole IPsec path.

Thanks

Leon Romanovsky (17):
  net/mlx5: Simplify IPsec flow steering init/cleanup functions
  net/mlx5: Check IPsec TX flow steering namespace in advance
  net/mlx5: Don't hide fallback to software IPsec in FS code
  net/mlx5: Reduce useless indirection in IPsec FS add/delete flows
  net/mlx5: Store IPsec ESN update work in XFRM state
  net/mlx5: Remove useless validity check
  net/mlx5: Merge various control path IPsec headers into one file
  net/mlx5: Remove accel notations and indirections from esp functions
  net/mlx5: Simplify HW context interfaces by using SA entry
  net/mlx5: Clean IPsec FS add/delete rules
  net/mlx5: Make sure that no dangling IPsec FS pointers exist
  net/mlx5: Don't advertise IPsec netdev support for non-IPsec device
  net/mlx5: Simplify IPsec capabilities logic
  net/mlx5: Remove not-supported ICV length
  net/mlx5: Cleanup XFRM attributes struct
  net/mlx5: Allow future addition of IPsec object modifiers
  net/mlx5: Don't perform lookup after already known sec_path

 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 -
 .../ethernet/mellanox/mlx5/core/en/params.c   |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 172 +++------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  85 +++-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 362 ++++++------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |  21 -
 .../mlx5/core/en_accel/ipsec_offload.c        | 332 +++-------------
 .../mlx5/core/en_accel/ipsec_offload.h        |  14 -
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  |   6 +-
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 -
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   2 +-
 include/linux/mlx5/accel.h                    | 153 --------
 include/linux/mlx5/mlx5_ifc.h                 |   2 -
 15 files changed, 320 insertions(+), 839 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
 delete mode 100644 include/linux/mlx5/accel.h

-- 
2.35.1

