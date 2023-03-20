Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68776C1EBC
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjCTR66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCTR6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:58:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2981E659A
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEEC6B81059
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CBAC4339B;
        Mon, 20 Mar 2023 17:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334706;
        bh=gaqdbwsOWGs05Ii7U9chP/AzAUvJ/mlBnQ5DazXjoFE=;
        h=From:To:Cc:Subject:Date:From;
        b=lMW1aAY4sqNxROtOr8XOpHdJ8LQjMM1F/sdKfObX66ggdcnsQ2/JOUCDrOnGELLcU
         bUVR7w47vip0b8wQFAp/Of6a+QPnj4yu27Dk5PHioawnl2s4fInsmKou1mDDA+5ETb
         On3LabuUFRKgCPVETifT+SVRsnL2m1m9JgEJ3qCnhUL75JQSeJGyTX3aIkHL6YjubT
         AZZ2pM/e8Xt87uIsnFNz6emowBJzG8Xn6ka2DdVnWnQTwC+zJhnWV09XU/k17RNlR1
         muOYGYohImsLcOR1392GK9vR6vP6RUvAwis3jxr4hjeedVzIBiP7A9Yy342+A1pmm3
         /4IqNALtGTEHQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/14] mlx5 updates 2023-03-20
Date:   Mon, 20 Mar 2023 10:51:30 -0700
Message-Id: <20230320175144.153187-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series from Eli, adds the support for dynamic msix and irq vector
allocation in mlx5, required for mlx5 vdpa posted interrupt feature [1].

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit e8d018dd0257f744ca50a729e3d042cf2ec9da65:

  Linux 6.3-rc3 (2023-03-19 13:27:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-03-20

for you to fetch changes up to fe29ef4d4e4c88194af0a6c729ade312cb0357b0:

  net/mlx5: Provide external API for allocating vectors (2023-03-20 10:39:40 -0700)

----------------------------------------------------------------
mlx5-updates-2023-03-20

mlx5 dynamic msix

This patch series adds support for dynamic msix vectors allocation in mlx5.

Eli Cohen Says:

================

The following series of patches modifies mlx5_core to work with the
dynamic MSIX API. Currently, mlx5_core allocates all the interrupt
vectors it needs and distributes them amongst the consumers. With the
introduction of dynamic MSIX support, which allows for allocation of
interrupts more than once, we now allocate vectors as we need them.
This allows other drivers running on top of mlx5_core to allocate
interrupt vectors for their own use. An example for this is mlx5_vdpa,
which uses these vectors to propagate interrupts directly from the
hardware to the vCPU [1].

As a preparation for using this series, a use after free issue is fixed
in lib/cpu_rmap.c and the allocator for rmap entries has been modified.
A complementary API for irq_cpu_rmap_add() has also been introduced.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/patch/?id=0f2bf1fcae96a83b8c5581854713c9fc3407556e

================

----------------------------------------------------------------
Eli Cohen (14):
      lib: cpu_rmap: Avoid use after free on rmap->obj array entries
      lib: cpu_rmap: Use allocator for rmap entries
      lib: cpu_rmap: Add irq_cpu_rmap_remove to complement irq_cpu_rmap_add
      net/mlx5e: Coding style fix, add empty line
      net/mlx5: Fix wrong comment
      net/mlx5: Modify struct mlx5_irq to use struct msi_map
      net/mlx5: Use newer affinity descriptor
      net/mlx5: Improve naming of pci function vectors
      net/mlx5: Refactor completion irq request/release code
      net/mlx5: Use dynamic msix vectors allocation
      net/mlx5: Move devlink registration before mlx5_load
      net/mlx5: Refactor calculation of required completion vectors
      net/mlx5: Use one completion vector if eth is disabled
      net/mlx5: Provide external API for allocating vectors

 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |  11 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       | 220 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/irq_affinity.c |  42 ++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 248 +++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h  |   4 +-
 include/linux/cpu_rmap.h                           |   5 +-
 include/linux/mlx5/driver.h                        |   6 +
 lib/cpu_rmap.c                                     |  42 +++-
 11 files changed, 389 insertions(+), 230 deletions(-)
