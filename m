Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A3E4822B6
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242711AbhLaIUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237073AbhLaIUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A6DC061574
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:20:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED4461771
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D46C36AEB;
        Fri, 31 Dec 2021 08:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938843;
        bh=1jGiwXL1FxPjcRtLU1jD/GwRzGBPQa8KlCnQsGWQjhc=;
        h=From:To:Cc:Subject:Date:From;
        b=gr5VqNjTJ3EU/0DEQ8JdhFwJY7WxY1Oeyw43n5G3TH2kbDkUzIMoEqcJHi+aWKsmF
         //7Eb059CJecM5Hg3kmsdbcUtwbj5m511dooephJHuWHA59Q+CHUKznfuNE+vBeh3i
         hfzlD6Jx2EMtauVrzfZ2LFoBovwTNOChgg1mkZeHTFWI4ieDqn7oIovGFdI9m/p8Mi
         OtL4BkEfZkIi19jlWxpDr12x3cNGDDln4cRy+G4mOum5VpegGxauSUHtCD8ZYT1H14
         S31HHVB1z8crQXOC5rQzBdhBRMvOSxQrgiiUaZIUpQUEqZsp3KqOnsBRnX8GSNJJ93
         V5xQdc321f7Zw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next v2 00/16] mlx5 updates 2021-12-28
Date:   Fri, 31 Dec 2021 00:20:22 -0800
Message-Id: <20211231082038.106490-1-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

Changes in V2, Patch #7, addressed comments by Jakub:
 - Remove redundant hex buffer clearing and reduce its size
 - Use bin2hex() instead of DIY loop
 - Don't check debugfs functions return values

Most of the patches in this series are trivial and basic, the only patch
worth mentioning is the addition of debugfs entry for dumping software
steering state, as we are defaulting to SW steering in this patchset,
so we would like to be prepared for any debug, just in case.

For more information please see tag log below.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit af30f8eaa8fe4ff1987280f716309711997bd979:

  net: dsa: bcm_sf2: refactor LED regs access (2021-12-30 17:28:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-12-28

for you to fetch changes up to aa36c94853b2bcc4953e065c462deb1ade7f55be:

  net/mlx5: Set SMFS as a default steering mode if device supports it (2021-12-31 00:17:44 -0800)

----------------------------------------------------------------
mlx5-updates-2021-12-28

mlx5 Software steering, New features and optimizations

This patch series brings various SW steering features, optimizations and
debug-ability focused improvements.

 1) Expose debugfs for dumping the SW steering resources
 2) Removing unused fields
 3) support for matching on new fields
 4) steering optimization for RX/TX-only rules
 5) Make Software steering the default steering mechanism when
    available, applies only to Switchdev mode FDB

From Yevgeny Kliteynik and Muhammad Sammar:

 - Patch 1 fixes an error flow in creating matchers
 - Patch 2 fix lower case macro prefix "mlx5_" to "MLX5_"
 - Patch 3 removes unused struct member in mlx5dr_matcher
 - Patch 4 renames list field in matcher struct to list_node to reflect the
   fact that is field is for list node that is stored on another struct's lists
 - Patch 5 adds checking for valid Flex parser ID value
 - Patch 6 adds the missing reserved fields to dr_match_param and aligns it to
   the format that is defined by HW spec
 - Patch 7 adds support for dumping SW steering (SMFS) resources using debugfs
   in CSV format: domain and its tables, matchers and rules
 - Patch 8 adds support for a new destination type - UPLINK
 - Patch 9 adds WARN_ON_ONCE on refcount checks in SW steering object destructors
 - Patches 10, 11, 12 add misc5 flow table match parameters and add support for
   matching on tunnel headers 0 and 1
 - Patch 13 adds support for matching on geneve_tlv_option_0_exist field
 - Patch 14 implements performance optimization for for empty or RX/TX-only
   matchers by splitting RX and TX matchers handling: matcher connection in the
   matchers chain is split into two separate lists (RX only and TX only), which
   solves a usecase of many RX or TX only rules that create a long chain of
   RX/TX-only paths w/o the actual rules
 - Patch 15 ignores modify TTL if device doesn't support it instead of
   adding and unsupported action
 - Patch 16 sets SMFS as a default steering mode

----------------------------------------------------------------
Muhammad Sammar (5):
      net/mlx5: DR, Add missing reserved fields to dr_match_param
      net/mlx5: DR, Add support for dumping steering info
      net/mlx5: Add misc5 flow table match parameters
      net/mlx5: DR, Add misc5 to match_param structs
      net/mlx5: DR, Support matching on tunnel headers 0 and 1

Yevgeny Kliteynik (11):
      net/mlx5: DR, Fix error flow in creating matcher
      net/mlx5: DR, Fix lower case macro prefix "mlx5_" to "MLX5_"
      net/mlx5: DR, Remove unused struct member in matcher
      net/mlx5: DR, Rename list field in matcher struct to list_node
      net/mlx5: DR, Add check for flex parser ID value
      net/mlx5: DR, Add support for UPLINK destination type
      net/mlx5: DR, Warn on failure to destroy objects due to refcount
      net/mlx5: DR, Add support for matching on geneve_tlv_option_0_exist field
      net/mlx5: DR, Improve steering for empty or RX/TX-only matchers
      net/mlx5: DR, Ignore modify TTL if device doesn't support it
      net/mlx5: Set SMFS as a default steering mode if device supports it

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   2 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |  23 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |  29 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  | 649 +++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.h  |  15 +
 .../mellanox/mlx5/core/steering/dr_domain.c        |   5 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       | 250 ++++----
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  47 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  61 ++
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |   2 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |  25 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  52 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |  94 +--
 .../mellanox/mlx5/core/steering/dr_types.h         | 262 ++++++---
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  18 +-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |  16 +
 include/linux/mlx5/device.h                        |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |  35 +-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |   2 +-
 22 files changed, 1323 insertions(+), 279 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.h
