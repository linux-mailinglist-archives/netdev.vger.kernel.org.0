Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E48A42A52C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbhJLNRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233100AbhJLNRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:17:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2E2D61078;
        Tue, 12 Oct 2021 13:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634044532;
        bh=o7kakXnsPyV9ARidLcUMPXHlRDmLhaJ2814BPZpXuEI=;
        h=From:To:Cc:Subject:Date:From;
        b=Fj8zavkOFLxOGWqggzXNZbB0N7hARpQFncEPuqe1NZxppnGtHCsbQnqzSdqBSS5IQ
         ZtQlzwggE3Xk8Oxje+6cTLwL5pBOUiquX5z/VhgbCp31csY3+hz6pA3QQNHVNktZyg
         2mlJowkvz7vZCKwnNbYVSbVkrkm+6Jxrrnr8BCl8Z1ZJphgB6XBH8y7meEjTKC1PoM
         lP7+7y5LL25eOZDHmGvwPLXyh80FhRi4mqO8XhRC6KKtmvFesWhwTUGvH48aPF2K6H
         SX58/nZu22+IKrY8FM4z0Y1/YG7VywteQG8pLV8itHfUrl3A0vwPynF1FHFYZFA+BA
         GLvLHUmMc44Sw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v4 0/6] devlink reload simplification
Date:   Tue, 12 Oct 2021 16:15:20 +0300
Message-Id: <cover.1634044267.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v4:
 * Removed legacy BUG_ON() in first patch.
 * Added new patch that moves netdev_to_devlink functions to devlink.c.
 * Rewrote devlink ops patch to use feature mask.
v3: https://lore.kernel.org/all/cover.1633589385.git.leonro@nvidia.com
 * Rewrote third patch to keep static const nature of ops. This is done
   by extracting reload ops to separate ops structure.
 * Changed commit message in last patch as was suggested by Ido.
v2: https://lore.kernel.org/all/cover.1633284302.git.leonro@nvidia.com
 * Dropped const removal patch
 * Added new patch to hide struct devlink
 * Added new patch to annotate devlink API
 * Implemented copy of all callback in devlink ops
v1: https://lore.kernel.org/all/cover.1632916329.git.leonro@nvidia.com
 * Missed removal of extra WARN_ON
 * Added "ops parameter to macro as Dan suggested.
v0: https://lore.kernel.org/all/cover.1632909221.git.leonro@nvidia.com

-------------------------------------------------------------------
Hi,

Simplify devlink reload APIs.

Thanks

Leon Romanovsky (6):
  devlink: Reduce struct devlink exposure
  devlink: Move netdev_to_devlink helpers to devlink.c
  devlink: Annotate devlink API calls
  devlink: Allow control devlink ops behavior through feature mask
  net/mlx5: Set devlink reload feature bit for supported devices only
  devlink: Delete reload enable/disable interface

 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |   4 +-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |   3 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   4 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |   3 -
 .../mellanox/mlx5/core/sf/dev/driver.c        |   5 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   8 +-
 drivers/net/netdevsim/dev.c                   |   4 +-
 include/net/devlink.h                         |  79 ++-------
 include/trace/events/devlink.h                |  72 ++++----
 net/core/devlink.c                            | 164 +++++++++++++-----
 12 files changed, 181 insertions(+), 171 deletions(-)

-- 
2.31.1

