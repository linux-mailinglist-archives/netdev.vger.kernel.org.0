Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6618F41C285
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245531AbhI2KSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245475AbhI2KSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96C3A6135E;
        Wed, 29 Sep 2021 10:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632910621;
        bh=lXfh5WGrONF4SJ4gvPOiSDik2vUfqacZzHc0ckI9xmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsyKu2BnDHy4iS9k1fHzU0z8EZzQMPAA8eu/JdF1SJn/5mhvNoSUY3Dic/RyLrBUA
         6Yw2Iln+5FbHhSzRe0prPx3P7XWIsuARbd6pZ1zoUp6eJuDd9OOliX2J87LBZ3KvKQ
         rkljvN6tfBUB7aR4R358ExU9rcUK0CGO1wpUhodeBFSLJMN75s0M/+mEehs7yNGvDC
         mKIXVQ7mxP9gBjWUq5WSSHxkIuFIK/38CZpkBwjjzVuAHrPxLKntuoloh8fGkOoo3L
         vaklhaBR72HkLW+u5jkJpLJ1PqOc3sX3RRpQQah0ocIAcCOfk+QDmNJfF2H6ivw9u/
         7baOCUE2lVn1Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Shay Drory <shayd@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next 4/5] net/mlx5: Register separate reload devlink ops for multiport device
Date:   Wed, 29 Sep 2021 13:16:38 +0300
Message-Id: <b76a027ca34978cb302eea24f6beaf519f5221c7.1632909221.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632909221.git.leonro@nvidia.com>
References: <cover.1632909221.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Mulitport slave device doesn't support devlink reload, so instead of
complicating initialization flow with devlink_reload_enable() which
will be removed in next patch, set specialized devlink ops callbacks
for reload operations.

This fixes an error when reload counters exposed (and equal zero) for
the mode that is not supported at all.

Fixes: d89ddaae1766 ("net/mlx5: Disable devlink reload for multi port slave device")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 47c9f7f5bb79..e85eca6976a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -309,14 +309,17 @@ static struct devlink_ops mlx5_devlink_ops = {
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
+	.trap_init = mlx5_devlink_trap_init,
+	.trap_fini = mlx5_devlink_trap_fini,
+	.trap_action_set = mlx5_devlink_trap_action_set,
+};
+
+static struct devlink_ops mlx5_devlink_reload = {
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_limits = BIT(DEVLINK_RELOAD_LIMIT_NO_RESET),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
-	.trap_init = mlx5_devlink_trap_init,
-	.trap_fini = mlx5_devlink_trap_fini,
-	.trap_action_set = mlx5_devlink_trap_action_set,
 };
 
 void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, struct sk_buff *skb,
@@ -791,6 +794,7 @@ static void mlx5_devlink_traps_unregister(struct devlink *devlink)
 
 int mlx5_devlink_register(struct devlink *devlink)
 {
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
 
 	err = devlink_params_register(devlink, mlx5_devlink_params,
@@ -808,6 +812,9 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
+	if (!mlx5_core_is_mp_slave(dev))
+		devlink_set_ops(devlink, &mlx5_devlink_reload);
+
 	return 0;
 
 traps_reg_err:
-- 
2.31.1

