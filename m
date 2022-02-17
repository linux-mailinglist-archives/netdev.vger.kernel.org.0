Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532C04B9A3A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbiBQH4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:56:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbiBQH4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E66657E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D90C61B41
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B7BC340E8;
        Thu, 17 Feb 2022 07:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084594;
        bh=Mz+F8KccPJgd7P1YFBWgRNtDaTDSIK09VHZ/P38dHUE=;
        h=From:To:Cc:Subject:Date:From;
        b=pJHHy4oGsb2W8buHPhhl6G4OjP2Wxlt06KNfDU66IQE2WG5CfCfyjJ+uq2aGIo5JC
         dELGkv09h+5NzxjJILf8fTROCR7+elhjYFGTL7JXYEPWSP7/SNPw67Mj1XiIhFFwDb
         +yYZHvn9ejEqTN/9ek1KguGP7thBHVknW0UfwNqnEyudbqboJy584eXLG7QSI2/+7+
         K0QqHOA9ZHdIOiS+EoVBo6EoWYPR2fTWYlnkzN8ZsNhUT0zlJHbsqTBqNh+3fNSjSy
         klRgie7QYBm5J7q9uslvA3IUIgsHKIzMonFXN3r2KKBfo5oIubCf5Lsrs02kJ50Qir
         FDeGlKDI9PW0Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-02-16
Date:   Wed, 16 Feb 2022 23:56:17 -0800
Message-Id: <20220217075632.831542-1-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides general misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 22b67d17194fa47ac06b27475e63bb9f7f65b307:

  net: rtnetlink: rtnl_stats_get(): Emit an extack for unset filter_mask (2022-02-16 20:56:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-02-16

for you to fetch changes up to b070e70381ee343dc10d2b1f0f3a6b1f940f0ae5:

  net/mlx5e: TC, Allow sample action with CT (2022-02-16 23:55:17 -0800)

----------------------------------------------------------------
mlx5-updates-2022-02-16

Misc updates for mlx5:
1) Alex Liu Adds support for using xdp->data_meta

2) Aya Levin Adds PTP counters and port time stamp mode for representors and
switchdev mode.

3) Tariq Toukan, Striding RQ simple improvements.

4) Roi Dayan (7): Create multiple attr instances per flow

Some TC actions use post actions for their implementation.
For example CT and sample actions.

Create a new flow attr instance after each multi table action and
create a post action rule for it as a generic parsing step.
Now multi table actions like CT, sample don't require to do it.

When flow has multiple attr instances, the first flow attr is being
offloaded normally and linked to the next attr (post action rule) by
setting an id on reg_c for matching.
Post action rule (rule created from second attr instance) match the
id on reg_c and does rest of the actions.

Example rule with actions CT,goto will be created with 2 attr instances
as following: attr1(CT)->attr2(goto)

----------------------------------------------------------------
Alex Liu (1):
      net/mlx5e: Add support for using xdp->data_meta

Aya Levin (2):
      net/mlx5e: E-Switch, Add PTP counters for uplink representor
      net/mlx5e: E-Switch, Add support for tx_port_ts in switchdev mode

Colin Ian King (1):
      net/mlx5e: Fix spelling mistake "supoported" -> "supported"

Paul Blakey (1):
      net/mlx5e: TC, Move flow hashtable to be per rep

Roi Dayan (7):
      net/mlx5e: Pass actions param to actions_match_supported()
      net/mlx5e: Add post act offload/unoffload API
      net/mlx5e: Create new flow attr for multi table actions
      net/mlx5e: Use multi table support for CT and sample actions
      net/mlx5e: TC, Clean redundant counter flag from tc action parsers
      net/mlx5e: TC, Make post_act parse CT and sample actions
      net/mlx5e: TC, Allow sample action with CT

Tariq Toukan (3):
      net/mlx5e: Generalize packet merge error message
      net/mlx5e: Default to Striding RQ when not conflicting with CQE compression
      net/mlx5e: RX, Restrict bulk size for small Striding RQs

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  11 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/accept.c |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |  73 ++++
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |  25 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |  20 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/drop.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   3 +-
 .../mellanox/mlx5/core/en/tc/act/mirred_nic.c      |   3 +-
 .../mlx5/core/en/tc/act/redirect_ingress.c         |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/sample.c |  29 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/sample.h |  14 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |  69 ++--
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.h   |   8 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |  71 +---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  47 +--
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   7 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  48 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  31 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 432 +++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  12 +-
 31 files changed, 714 insertions(+), 244 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.h
