Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B7C6DC70E
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 15:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjDJNIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 09:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjDJNIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 09:08:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AB0212F;
        Mon, 10 Apr 2023 06:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32DC260F55;
        Mon, 10 Apr 2023 13:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110A5C433D2;
        Mon, 10 Apr 2023 13:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681132078;
        bh=3aM8xzi3Ejc9lw0KWj0iPFmTjjhZiJ/W+M8ER7GMoLE=;
        h=From:To:Cc:Subject:Date:From;
        b=uYs88a7cywe+vk7/CcSmdMTe1aljB6GFFqTWSGvZ7drx6m8BpaW+9afYDCXMw/sxq
         usn7CgaZBdEEhTpIePVtUo67enAq/bKpz5yahqfo8M9rDwHtdmWiqkk3mydBRr1jKw
         Nk9EqgZdK4Qqwcahzpx0PTeCG4ggpFbg2EW4/UAV4IBS8XhGk5NY8zGrGL5rr8T7pi
         i66sDu5JEYVjY/l4j6UL1U/foOZouVfGYMuXmAtrTqqVeVT8CPLw/kdEz3uIyG4QeE
         Gno4vrMOn3spYcZ4uFK/d9lSe2EiMtUgMzNRxOdGdSXAWXtBj9lHQw0KqH7CPygwz6
         iA/Pi1NHHzU8w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH rdma-next 0/4] Allow relaxed ordering read in VFs and VMs
Date:   Mon, 10 Apr 2023 16:07:49 +0300
Message-Id: <cover.1681131553.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

From Avihai,

Currently, Relaxed Ordering (RO) can't be used in VFs directly and in
VFs assigned to QEMU, even if the PF supports RO. This is due to issues
in reporting/emulation of PCI config space RO bit and due to current
HCA capability behavior.

This series fixes it by using a new HCA capability and by relying on FW
to do the "right thing" according to the PF's PCI config space RO value.

Allowing RO in VFs and VMs is valuable since it can greatly improve
performance on some setups. For example, testing throughput of a VF on
an AMD EPYC 7763 and ConnectX-6 Dx setup showed roughly 60% performance
improvement.

Thanks

Avihai Horon (4):
  RDMA/mlx5: Remove pcie_relaxed_ordering_enabled() check for RO write
  RDMA/mlx5: Check pcie_relaxed_ordering_enabled() in UMR
  net/mlx5: Update relaxed ordering read HCA capabilities
  RDMA/mlx5: Allow relaxed ordering read in VFs and VMs

 drivers/infiniband/hw/mlx5/mr.c                     | 12 ++++++++----
 drivers/infiniband/hw/mlx5/umr.c                    |  7 +++++--
 drivers/infiniband/hw/mlx5/umr.h                    |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c |  9 +++++----
 include/linux/mlx5/mlx5_ifc.h                       |  5 +++--
 6 files changed, 24 insertions(+), 15 deletions(-)

-- 
2.39.2

