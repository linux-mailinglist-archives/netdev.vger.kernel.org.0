Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3257B41819E
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343626AbhIYL00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343583AbhIYLZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C0A561350;
        Sat, 25 Sep 2021 11:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569055;
        bh=7fuwMn0UcxFbiik3Z+N/XOLwJAq59/miUfWhpOwdqE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ge34eptxt6ik9tM4bBGWV+EhWY2pUsDmBrBnZIJGDR8WqRukI42+ESfMMMV9+gmyk
         NzOJ5DLBu2o6NL6oi1jrLFHILSXlbaTkjCziDiYsxegSE/Jrp/gGgvJVR7RaEimH2k
         u2KZhp8p3Q+odnSJGYZYpzbjUOdLrNqJ2GAMUiwsAT61gUQdMMmLpIZkJsjPKLDgja
         951E4DCRpAC2brIp9LRFyfkQegtVBAkmpGV+8JNtEYeEpLtKlgfwpF/3fdAikKH6yb
         0nLBFwTJ2r2zmbCo8w91OLQqyLpu05TcH/BXTltlVcbcWo+yMP4awblDvVJZGPBPj9
         feyG+jP8SLazQ==
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
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Intel Corporation <linuxwwan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Satanand Burla <sburla@marvell.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v1 18/21] net: wwan: iosm: Move devlink_register to be last devlink command
Date:   Sat, 25 Sep 2021 14:22:58 +0300
Message-Id: <6a63d8f6484a46c9120155082a396b44ce86bd1c.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This change prevents from users to access device before devlink is
fully configured. Indirectly this change fixes the commit mentioned
below where devlink_unregister() was prematurely removed.

Fixes: db4278c55fa5 ("devlink: Make devlink_register to be void")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/wwan/iosm/iosm_ipc_devlink.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_devlink.c b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
index 42dbe7fe663c..6fe56f73011b 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_devlink.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
@@ -305,7 +305,6 @@ struct iosm_devlink *ipc_devlink_init(struct iosm_imem *ipc_imem)
 	ipc_devlink->devlink_ctx = devlink_ctx;
 	ipc_devlink->pcie = ipc_imem->pcie;
 	ipc_devlink->dev = ipc_imem->dev;
-	devlink_register(devlink_ctx);
 
 	rc = devlink_params_register(devlink_ctx, iosm_devlink_params,
 				     ARRAY_SIZE(iosm_devlink_params));
@@ -315,7 +314,6 @@ struct iosm_devlink *ipc_devlink_init(struct iosm_imem *ipc_imem)
 		goto param_reg_fail;
 	}
 
-	devlink_params_publish(devlink_ctx);
 	ipc_devlink->cd_file_info = list;
 
 	rc = ipc_devlink_create_region(ipc_devlink);
@@ -334,6 +332,7 @@ struct iosm_devlink *ipc_devlink_init(struct iosm_imem *ipc_imem)
 	init_completion(&ipc_devlink->devlink_sio.read_sem);
 	skb_queue_head_init(&ipc_devlink->devlink_sio.rx_list);
 
+	devlink_register(devlink_ctx);
 	dev_dbg(ipc_devlink->dev, "iosm devlink register success");
 
 	return ipc_devlink;
@@ -341,7 +340,6 @@ struct iosm_devlink *ipc_devlink_init(struct iosm_imem *ipc_imem)
 chnl_get_fail:
 	ipc_devlink_destroy_region(ipc_devlink);
 region_create_fail:
-	devlink_params_unpublish(devlink_ctx);
 	devlink_params_unregister(devlink_ctx, iosm_devlink_params,
 				  ARRAY_SIZE(iosm_devlink_params));
 param_reg_fail:
@@ -358,8 +356,8 @@ void ipc_devlink_deinit(struct iosm_devlink *ipc_devlink)
 {
 	struct devlink *devlink_ctx = ipc_devlink->devlink_ctx;
 
+	devlink_unregister(devlink_ctx);
 	ipc_devlink_destroy_region(ipc_devlink);
-	devlink_params_unpublish(devlink_ctx);
 	devlink_params_unregister(devlink_ctx, iosm_devlink_params,
 				  ARRAY_SIZE(iosm_devlink_params));
 	if (ipc_devlink->devlink_sio.devlink_read_pend) {
@@ -370,6 +368,5 @@ void ipc_devlink_deinit(struct iosm_devlink *ipc_devlink)
 		skb_queue_purge(&ipc_devlink->devlink_sio.rx_list);
 
 	ipc_imem_sys_devlink_close(ipc_devlink);
-	devlink_unregister(devlink_ctx);
 	devlink_free(devlink_ctx);
 }
-- 
2.31.1

