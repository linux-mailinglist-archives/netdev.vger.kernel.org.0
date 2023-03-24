Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319806C8912
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjCXXN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbjCXXNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:13:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFDD166FD
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4C5162CEC
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119A0C433D2;
        Fri, 24 Mar 2023 23:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699631;
        bh=6HmQ0MXtkq2sPgoSfoYF2hCERjTBjV2qzufVHZ29GNk=;
        h=From:To:Cc:Subject:Date:From;
        b=VGlCueoDV6BjxZoa3HagaiurojLiice4XvY0S6SFEhSgvO9+eJoDwNb5gp7j2oSkP
         zQ4zJnF1hPTsqeBP4AJMwWSjCuyHeodGQM0V/S706CN6ATsynEJnDg7TkBDZ2S1dyX
         ijmMOvxvYLhC04HYe9zq3cln2VgnyeNHabSbxoGj7otRDAPzG++suS1qDBKequqBvp
         CWTLmQrQjuZ17iWbQny/y8NfRP8EGdeWtOd3wjFO9+YCiB1wFIr26TwIfFeLvB0eqr
         zmRKzxe4ZgRmrf10/3uKsjdaep3rSqIkUYOK4mEOof2N/d+9P4j+9cu5DCYWjOiqgy
         SA8uGZBfTxRnQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [pull request][net-next V2 00/15] mlx5 updates 2023-03-20
Date:   Fri, 24 Mar 2023 16:13:26 -0700
Message-Id: <20230324231341.29808-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

v1->v2:
  1) Improved commit messages
  2) Added reviewed by Jacob Keller 
  3) handled Checkpatch errors
  4) CC Thomas
  5) Proper errno return values
  6) Avoid "glue" leakage.
  7) Removed unnecessary Fixes tag.

This series from Eli, adds the support for dynamic msix and irq vector
allocation in mlx5, required for mlx5 vdpa posted interrupt feature [1].

For more information please see tag log below.
Please pull and let me know if there is any problem.

The following changes since commit e8d018dd0257f744ca50a729e3d042cf2ec9da65:

  Linux 6.3-rc3 (2023-03-19 13:27:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-03-20

for you to fetch changes up to 2e21ab28e230fd8333ac0586901431132cc308d7:

  vdpa/mlx5: Support interrupt bypassing (2023-03-24 16:08:40 -0700)

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
Eli Cohen (15):
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
      vdpa/mlx5: Support interrupt bypassing

 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |  11 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       | 220 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/irq_affinity.c |  42 ++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 248 +++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h  |   4 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  | 139 +++++++++++-
 drivers/vdpa/mlx5/net/mlx5_vnet.h                  |  14 ++
 include/linux/cpu_rmap.h                           |   4 +-
 include/linux/mlx5/driver.h                        |   6 +
 lib/cpu_rmap.c                                     |  57 ++++-
 13 files changed, 542 insertions(+), 244 deletions(-)
