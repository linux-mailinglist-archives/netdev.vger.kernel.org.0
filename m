Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804A266DE73
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbjAQNPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236670AbjAQNPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:15:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF04360A3;
        Tue, 17 Jan 2023 05:15:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCD6CB81604;
        Tue, 17 Jan 2023 13:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D6DC433D2;
        Tue, 17 Jan 2023 13:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673961297;
        bh=dA4fFjIL32TTACzQB1F7F/hI+QCc4oJ0YrivxdHZYYU=;
        h=From:To:Cc:Subject:Date:From;
        b=lM5yT+s9rljVP3Vgy/0qKfw8sr53iTsynzL7yNPShDYI1ObXxN8ANdzghBLSw7/eg
         gG1F5EteenbB58TfZDmDEdrC9HGl+oAmdyvB+mjDzvWCobtuKEtV2rBgzPyfsbCYXO
         a4tZfDQJUh16JommnoAs5nATMj+uvamJOynBKT1ZpxS89d+PiLi/9YzwNAqlvQK7oj
         wa886rSApGHeOq7U/ooITO/JJnciN8PTPc1dBBabZRqnfFzjDxpiigOsxug7CpzQ45
         rc7wEJgxEAy1GnK94e6RTwFZ0Mxs4Kk7Me3/dWN4sSc0svSYxuD4tDc2phDBh5Uno9
         uo1xMfx6yLP/Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Or Har-Toov <ohartoov@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v2 0/4] Rely on firmware to get special mkeys
Date:   Tue, 17 Jan 2023 15:14:48 +0200
Message-Id: <cover.1673960981.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
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

Changelog:
v2:
 * Took a liberty and rewrote net/mlx5 patches
 * change logic around terminate_scatter_list_mkey
 * Added capability checks to be before executing command
v1: https://lore.kernel.org/all/cover.1672917578.git.leonro@nvidia.com
 * Use already stored mkeys.terminate_scatter_list_mkey.
v0: https://lore.kernel.org/all/cover.1672819469.git.leonro@nvidia.com

-----------------------------------------------------------------------
This series from Or extends mlx5 driver to rely on firmware to get
special mkey values.

Thanks

Or Har-Toov (4):
  net/mlx5: Expose bits for querying special mkeys
  net/mlx5: Change define name for 0x100 lkey value
  net/mlx5e: Use query_special_contexts for mkeys
  RDMA/mlx5: Use query_special_contexts for mkeys

 drivers/infiniband/hw/mlx5/cmd.c              | 45 +++++++++++--------
 drivers/infiniband/hw/mlx5/cmd.h              |  3 +-
 drivers/infiniband/hw/mlx5/main.c             | 10 ++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  9 +++-
 drivers/infiniband/hw/mlx5/odp.c              | 27 ++++-------
 drivers/infiniband/hw/mlx5/srq.c              |  2 +-
 drivers/infiniband/hw/mlx5/wr.c               |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 22 ++++++++-
 include/linux/mlx5/mlx5_ifc.h                 | 10 ++++-
 include/linux/mlx5/qp.h                       |  2 +-
 10 files changed, 81 insertions(+), 51 deletions(-)

-- 
2.39.0

