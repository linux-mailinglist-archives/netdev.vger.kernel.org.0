Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F309465E9C4
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjAELYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjAELXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:23:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C154650E7E;
        Thu,  5 Jan 2023 03:23:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E16D619D6;
        Thu,  5 Jan 2023 11:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D48C433D2;
        Thu,  5 Jan 2023 11:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672917833;
        bh=J4IQeUKege6YLmfEJkNgDqcK7NVwWSrt7mDfKFJWrOk=;
        h=From:To:Cc:Subject:Date:From;
        b=U5HdJ9+PgEYpcIJXa9q9IbRIQHO9pM0JKO4mTvyfopF4V6JPt4zHAv9xgct3uYBnp
         ixLvd4YPGMTt6EzcZnHvFlnIXeu+2jUFrrPVo5ul6wLXZGQiTURbDuVGSm3lobAnER
         bIeRLICX9vhharsodTJdx+ftV2oTyTrZTMNCDI/mtC8/pGPZArwT9q6T3xVO1EiPRu
         ks3oGzA+iDcB/zNozgIFAIlX3DR/OE4hC/zhOu4Lv03MKSh2nTPlXuDZZ63XwswuaA
         hAZDqpljEaddyWj0fwmtyNUUSsu3fEvsfND21b8uMWYucoDGqLyj4wTJ0UXaP7SRix
         jN3V9bsgDLpFA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Or Har-Toov <ohartoov@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v1 0/4] Rely on firmware to get special mkeys
Date:   Thu,  5 Jan 2023 13:23:44 +0200
Message-Id: <cover.1672917578.git.leonro@nvidia.com>
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

Changelog:
v1:
 * Use already stored mkeys.terminate_scatter_list_mkey.
v0: https://lore.kernel.org/all/cover.1672819469.git.leonro@nvidia.com

-----------------------------------------------------------------------
This series from Or extends mlx5 driver to rely on firmware to get
special mkey values.

Thanks

Or Har-Toov (4):
  net/mlx5: Expose bits for querying special mkeys
  net/mlx5: Change define name for 0x100 lkey value
  net/mlx5: Use query_special_contexts for mkeys
  RDMA/mlx5: Use query_special_contexts for mkeys

 drivers/infiniband/hw/mlx5/cmd.c              | 30 +++++++------------
 drivers/infiniband/hw/mlx5/cmd.h              |  3 +-
 drivers/infiniband/hw/mlx5/main.c             | 10 +++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  8 ++++-
 drivers/infiniband/hw/mlx5/odp.c              | 29 +++++++-----------
 drivers/infiniband/hw/mlx5/srq.c              |  2 +-
 drivers/infiniband/hw/mlx5/wr.c               |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 27 +++++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 10 +++++--
 include/linux/mlx5/qp.h                       |  2 +-
 12 files changed, 75 insertions(+), 52 deletions(-)

-- 
2.38.1

