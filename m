Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959173E5BD6
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241574AbhHJNiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239995AbhHJNiC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:38:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B1A760EE7;
        Tue, 10 Aug 2021 13:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628602660;
        bh=HWvZTnnrllbHGHUXGdqF6NSoDHL8HLBiKeeVTy8+v34=;
        h=From:To:Cc:Subject:Date:From;
        b=uAJa/yG49KKMj3g9dPc1nCVeL1+ngogqOjicad0oEhTpte9d+L7mdXfoJ4XSMfWeb
         kuIukZm1aM5cz8TDJB8+Nahr7xXQW9+X/Jo74R09CWGWGYjkr3nqZRZ0dFVkgp0oO4
         pgenQ5Y/UXiCVZAnyHMAEs+KWU/dIGox7kFsmUAJ2ICQFLXkSM9U8AExqDrkxrnA8D
         UXyy8nF+sfZcOaiiZVB7Gx3nGxDPyXBTYY7vK/uhgtvKAVdMsCqgz5BDQhf21XiOHI
         XT7u9K60wRGE/cfVI5j05iRlARxJF7vNHFWULPj64diwhswkvhZQWYbP/lGIbku+ja
         4gBW72s1lPmsA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 0/5] Move devlink_register to be near devlink_reload_enable
Date:   Tue, 10 Aug 2021 16:37:30 +0300
Message-Id: <cover.1628599239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi Dave and Jakub,

This series prepares code to remove devlink_reload_enable/_disable API
and in order to do, we move all devlink_register() calls to be right
before devlink_reload_enable().

The best place for such a call should be right before exiting from
the probe().

This is done because devlink_register() opens devlink netlink to the
users and gives them a venue to issue commands before initialization
is finished.

1. Some drivers were aware of such "functionality" and tried to protect
themselves with extra locks, state machines and devlink_reload_enable().
Let's assume that it worked for them, but I'm personally skeptical about
it.

2. Some drivers copied that pattern, but without locks and state
machines. That protected them from reload flows, but not from any _set_
routines.

3. And all other drivers simply didn't understand the implications of early
devlink_register() and can be seen as "broken".

In this series, we focus on items #1 and #2.

Please share your opinion if I should change ALL other drivers to make
sure that devlink_register() is the last command or leave them in an
as-is state.

Thanks

Leon Romanovsky (5):
  net: hns3: remove always exist devlink pointer check
  net/mlx4: Move devlink_register to be the last initialization command
  mlxsw: core: Refactor code to publish devlink ops when device is ready
  net/mlx5: Accept devlink user input after driver initialization
    complete
  netdevsim: Delay user access till probe is finished

 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  8 +---
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  8 +---
 drivers/net/ethernet/mellanox/mlx4/main.c     | 38 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 10 +----
 .../net/ethernet/mellanox/mlx5/core/main.c    | 13 ++++++-
 .../mellanox/mlx5/core/sf/dev/driver.c        | 12 +++++-
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 27 +++++++------
 drivers/net/netdevsim/dev.c                   | 19 +++++-----
 8 files changed, 76 insertions(+), 59 deletions(-)

-- 
2.31.1

