Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D1D6E2C45
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjDNWJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjDNWJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDCB3C3B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBFC464A8E
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FE6C433D2;
        Fri, 14 Apr 2023 22:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510182;
        bh=hEEAwaqMrtPLh3Q+9hETVPYqMWYPu2M+As92GLKAGYE=;
        h=From:To:Cc:Subject:Date:From;
        b=EgKRiDhjo/9/f0mAwtPmbMxUEKpXREqPSLuMzgnzlVqUCTQXnmuvM23lXljaAD2/z
         OKkfcVM2mIYNtW8rvb7WwVgm89Wav5nSMxjMpVcGQIw4ssoOcyrP4gs7Q04TSIgk7c
         b2x0Wv0jbiq2DYMjFeF1g7A/Um3HOjmLAxV9V7k30DZy+Kyfw1nl/07HSBP80BzYcQ
         NnHWCjHb+ZpusQKDW/ZDm4y9mVYPZu+OGtN8tqa9+JFEoQdFQ4tua890eQUYgZqnfq
         n2JiosO2+far/buPQu/FBPWxaQtvLRTFDTo8bWMxU0iYE6SEA1wtG7f7z2hfMWfLrs
         QYrv9WngFvMdA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-04-14
Date:   Fri, 14 Apr 2023 15:09:24 -0700
Message-Id: <20230414220939.136865-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

SW Steering support for pattern and arguments modify_header actions
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit c11d2e718c792468e67389b506451eddf26c2dac:

  Merge branch 'msg_control-split' (2023-04-14 11:09:27 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-04-14

for you to fetch changes up to 220ae987838c893fe11e46a3e3994a549f203daa:

  net/mlx5: DR, Enable patterns and arguments for supporting devices (2023-04-14 15:06:22 -0700)

----------------------------------------------------------------
mlx5-updates-2023-04-14

Yevgeny Kliteynik Says:
=======================

SW Steering: Support pattern/args modify_header actions

The following patch series adds support for a new pattern/arguments type
of modify_header actions.

Starting with ConnectX-6 DX, we use a new design of modify_header FW object.
The current modify_header object allows for having only limited number of
these FW objects, which means that we are limited in the number of offloaded
flows that require modify_header action.

The new approach comprises of two types of objects: pattern and argument.
Pattern holds header modification templates, later used with corresponding
argument object to create complete header modification actions.
The pattern indicates which headers are modified, while the arguments
provide the specific values.
Therefore a single pattern can be used with different arguments in different
flows, enabling offloading of large number of modify_header flows.

 - Patch 1, 2: Add ICM pool for modify-header-pattern objects and implement
   patterns cache, allowing patterns reuse for different flows
 - Patch 3: Allow for chunk allocation separately for STEv0 and STEv1
 - Patch 4: Read related device capabilities
 - Patch 5: Add create/destroy functions for the new general object type
 - Patch 6: Add support for writing modify header argument to ICM
 - Patch 7, 8: Some required fixes to support pattern/arg - separate read
   buffer from the write buffer and fix QP continuous allocation
 - Patch 9: Add pool for modify header arg objects
 - Patch 10, 11, 12: Implement MODIFY_HEADER and TNL_L3_TO_L2 actions with
   the new patterns/args design
 - Patch 13: Optimization - set modify header action of size 1 directly on
   the STE instead of separate pattern/args combination
 - Patch 14: Adjust debug dump for patterns/args
 - Patch 15: Enable patterns and arguments for supporting devices

=======================

----------------------------------------------------------------
Yevgeny Kliteynik (15):
      net/mlx5: DR, Move ACTION_CACHE_LINE_SIZE macro to header
      net/mlx5: DR, Add cache for modify header pattern
      net/mlx5: DR, Split chunk allocation to HW-dependent ways
      net/mlx5: DR, Check for modify_header_argument device capabilities
      net/mlx5: DR, Add create/destroy for modify-header-argument general object
      net/mlx5: DR, Add support for writing modify header argument
      net/mlx5: DR, Read ICM memory into dedicated buffer
      net/mlx5: DR, Fix QP continuous allocation
      net/mlx5: DR, Add modify header arg pool mechanism
      net/mlx5: DR, Add modify header argument pointer to actions attributes
      net/mlx5: DR, Apply new accelerated modify action and decapl3
      net/mlx5: DR, Support decap L3 action using pattern / arg mechanism
      net/mlx5: DR, Modify header action of size 1 optimization
      net/mlx5: DR, Add support for the pattern/arg parameters in debug dump
      net/mlx5: DR, Enable patterns and arguments for supporting devices

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |  92 +++----
 .../ethernet/mellanox/mlx5/core/steering/dr_arg.c  | 273 +++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |  54 ++++
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |  30 ++-
 .../mellanox/mlx5/core/steering/dr_domain.c        |  15 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ptrn.c | 198 +++++++++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c | 210 ++++++++++++++--
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  57 +++++
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |   2 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        | 113 ++++++++-
 .../mellanox/mlx5/core/steering/dr_ste_v1.h        |   2 +
 .../mellanox/mlx5/core/steering/dr_ste_v2.c        |   2 +
 .../mellanox/mlx5/core/steering/dr_types.h         |  62 ++++-
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h        |   2 +-
 15 files changed, 1025 insertions(+), 89 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_arg.c
