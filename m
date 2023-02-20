Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E374F69C538
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjBTGRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjBTGQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:16:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32407CA36
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:16:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C109760C03
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 06:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9FFC433D2;
        Mon, 20 Feb 2023 06:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676873813;
        bh=byoLfQT6jHcCR3tCESrBlrHEiHjcqBPPHgkYd3BTzN8=;
        h=From:To:Cc:Subject:Date:From;
        b=hSJ8x2zAwBolRwrpOC4pNur6xIZSC4lMQPNcOJgmix20IKLo3+WwYiDGy7dZ5Qrwh
         egeUJhr6kOzwfqxf0IpoK8krKBEleptX3dcwACom49KCtqa6e08nOgXwnia6S3FKKi
         pgOX9LrRSo7KEZfDw3yU8XaoftTVZE/17ZpFoy13qNIo05yvZoYDZ63lsNaX8R7nWk
         QaehvQF/3HrlDCX+9Y2ZACuLXQg2RskL84v9QGDCZQ3O/qdbHh/bc6l0ne9herOkhz
         FYjFG3jpSC0v20Gmy4pyZrBjZwJe0xBB85hHiF11mq3RWdhzv5MyPJGihjCK+vczc0
         fCdF1W3ITyzZA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 00/14] mlx5 dynamic msix
Date:   Sun, 19 Feb 2023 22:14:28 -0800
Message-Id: <20230220061442.403092-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
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

From: Saeed Mahameed <saeedm@nvidia.com>

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

 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  14 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  11 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 220 +++++++++-------
 .../mellanox/mlx5/core/irq_affinity.c         |  42 ++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  17 +-
 .../ethernet/mellanox/mlx5/core/mlx5_irq.h    |  10 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 248 ++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/pci_irq.h |   4 +-
 include/linux/cpu_rmap.h                      |   5 +-
 include/linux/mlx5/driver.h                   |   6 +
 lib/cpu_rmap.c                                |  39 ++-
 11 files changed, 387 insertions(+), 229 deletions(-)

-- 
2.39.1

