Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D71B49EC8C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344057AbiA0UkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344053AbiA0UkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:40:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C798C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 12:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5CD3B8238E
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 20:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B101C340E4;
        Thu, 27 Jan 2022 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643316010;
        bh=a4sMtZ8BGrjVnwDQdpSsnAllo53X1VXEKiwC5bcB8y8=;
        h=From:To:Cc:Subject:Date:From;
        b=LVkwK4cuF1tP4my2GCw27CLXQZjJyGPPKw4S21zgg0SklZ42ExwGCIlFjyPIO2jGe
         vs3TEeBBQRQdQWemwd8wDD6mIKU8/obeYZkLDIjeKDJF6LXt5tWE6DWRgLqtvuXk7c
         /EZzdGQCVN774d+UHnQX/B1ISa925WBHCqGnqnr29o/UhdeyEKwbjeGzAeD811EaTp
         l0EHDmCLyM9GMPrCTgCehT8jyqfDkBGqYzt7fXk/zjkLFJ6r27mDaPf7+/IM4tmuAd
         QR0jVRzmQI2Ut9I5eyXhOM7k3yhkHAgzWUJmOvJkI/VTb6LF39vud3jS16sAQ/O0LX
         vjZapiLFGROvg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next RESEND 00/17] mlx5 updates 2022-01-27
Date:   Thu, 27 Jan 2022 12:39:50 -0800
Message-Id: <20220127204007.146300-1-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series is mostly refactoring and code improvements in mlx5.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit e2cf07654efb0fd7bbcb475c6f74be7b5755a8fd:

  ptp: replace snprintf with sysfs_emit (2022-01-27 14:05:35 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-01-27

for you to fetch changes up to 60dc0ef674ecbc944e2c236c8a71ce26440cb1a9:

  net/mlx5: VLAN push on RX, pop on TX (2022-01-27 12:37:36 -0800)

----------------------------------------------------------------
mlx5-updates-2022-01-27

1) Dima, adds an internal mlx5 steering callback per steering provider
   (FW vs SW steering), to advertise steering capabilities implemented by
   each module, this helps upper modules in mlx5 to know what is
   supported and what's not without the need to tell what is the underlying
   steering mode.
   2nd patch is the usecase where this interface is used to implement
   Vlan Push/pop for uplink with SW steering, where in FW mode it's not
   supported yet.

2) Roi Dayan improves code readability and maintainability
   as preparation step for multi attribute instance per flow
   in mlx5 TC module

   Currently the mlx5_flow object contains a single mlx5_attr instance.
   However, multi table actions (e.g. CT) instantiate multiple attr instances.

   This is a refactoring series in a preparation to support multiple
   attribute instances per flow.
   The commits prepare functions to get attr instance instead of using
   flow->attr and also using attr->flags if the flag is more relevant
   to be attr flag and not a flow flag considering there will be multiple
   attr instances. i.e. CT and SAMPLE flags.

----------------------------------------------------------------
Dima Chumak (2):
      net/mlx5: Introduce software defined steering capabilities
      net/mlx5: VLAN push on RX, pop on TX

Roi Dayan (14):
      net/mlx5e: Move code chunk setting encap dests into its own function
      net/mlx5e: Pass attr arg for attaching/detaching encaps
      net/mlx5e: Move counter creation call to alloc_flow_attr_counter()
      net/mlx5e: TC, Move pedit_headers_action to parse_attr
      net/mlx5e: TC, Split pedit offloads verify from alloc_tc_pedit_action()
      net/mlx5e: TC, Pass attr to tc_act can_offload()
      net/mlx5e: TC, Refactor mlx5e_tc_add_flow_mod_hdr() to get flow attr
      net/mlx5e: TC, Reject rules with multiple CT actions
      net/mlx5e: TC, Hold sample_attr on stack instead of pointer
      net/mlx5e: CT, Don't set flow flag CT for ct clear flow
      net/mlx5e: Refactor eswitch attr flags to just attr flags
      net/mlx5e: Test CT and SAMPLE on flow attr
      net/mlx5e: TC, Store mapped tunnel id on flow attr
      net/mlx5e: CT, Remove redundant flow args from tc ct calls

Tariq Toukan (1):
      net/mlx5: Remove unused TIR modify bitmask enums

 .../ethernet/mellanox/mlx5/core/en/tc/act/accept.c |   5 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |   5 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/csum.c   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |  17 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/drop.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |  12 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mark.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   7 +-
 .../mellanox/mlx5/core/en/tc/act/mirred_nic.c      |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mpls.c   |   9 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.c  |  11 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.h  |   1 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/ptype.c  |   3 +-
 .../mlx5/core/en/tc/act/redirect_ingress.c         |   8 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/sample.c |  11 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   |   5 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/tun.c    |   6 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.c   |  13 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.h   |   1 -
 .../mellanox/mlx5/core/en/tc/act/vlan_mangle.c     |   9 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |  18 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.h |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  87 +----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   4 -
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  13 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  17 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.h  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 368 +++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  27 +-
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  16 -
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  33 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  14 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  16 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   7 +
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  11 +
 include/linux/mlx5/mlx5_ifc.h                      |   7 -
 40 files changed, 440 insertions(+), 359 deletions(-)
