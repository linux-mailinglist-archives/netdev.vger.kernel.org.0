Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8CF418175
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245201AbhIYLZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245264AbhIYLZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 862F36128E;
        Sat, 25 Sep 2021 11:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569024;
        bh=PrFeKKukywHaBt62rZVuiu0/Btho0nWbpbcpWAnFbY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oa0/myPIOe/XULQJv4GvGl6mM8d548pm5n1JM2ZO4N/GjQ3/SuiSVVQurEYxdOB4t
         cZavrhNx8GlJtSu+x4nmb8Qvyu+Rk1v7w7H71NzrI9xMf/ssB9cYB9TnrGB5M2suOR
         Vat9GDPaYU2bERyJfmRXqyWB6h+dnwTtaTrkn5Q6SxLBsL5XEVF1ViKGb16wvvlRmz
         oYUHPaJKGU9BCOODfK4K/2mNPBd5BekedAnYvyI+U4XbQRpNV3I/TzHLtLg4XjXbUA
         3gb2u9jQ78tP5MnQQFI9e1+58aJKFPormH8cYFnoCewvS6S9P6VtOtPHaWiU4iR5ky
         WySvKEg7HrWMQ==
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
Subject: [PATCH net-next v1 09/21] net/mlx4: Move devlink_register to be the last initialization command
Date:   Sat, 25 Sep 2021 14:22:49 +0300
Message-Id: <486f4512a0d472b8732067018d2ec8c4f3f45763.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Refactor the code to make sure that devlink_register() is the last
command during initialization stage.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 27ed4694fbea..9541f3a920c8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4015,7 +4015,6 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&dev->persist->interface_state_mutex);
 	mutex_init(&dev->persist->pci_status_mutex);
 
-	devlink_register(devlink);
 	ret = devlink_params_register(devlink, mlx4_devlink_params,
 				      ARRAY_SIZE(mlx4_devlink_params));
 	if (ret)
@@ -4025,16 +4024,15 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto err_params_unregister;
 
-	devlink_params_publish(devlink);
-	devlink_reload_enable(devlink);
 	pci_save_state(pdev);
+	devlink_register(devlink);
+	devlink_reload_enable(devlink);
 	return 0;
 
 err_params_unregister:
 	devlink_params_unregister(devlink, mlx4_devlink_params,
 				  ARRAY_SIZE(mlx4_devlink_params));
 err_devlink_unregister:
-	devlink_unregister(devlink);
 	kfree(dev->persist);
 err_devlink_free:
 	devlink_free(devlink);
@@ -4138,6 +4136,7 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	int active_vfs = 0;
 
 	devlink_reload_disable(devlink);
+	devlink_unregister(devlink);
 
 	if (mlx4_is_slave(dev))
 		persist->interface_state |= MLX4_INTERFACE_STATE_NOWAIT;
@@ -4173,7 +4172,6 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	mlx4_pci_disable_device(dev);
 	devlink_params_unregister(devlink, mlx4_devlink_params,
 				  ARRAY_SIZE(mlx4_devlink_params));
-	devlink_unregister(devlink);
 	kfree(dev->persist);
 	devlink_free(devlink);
 }
-- 
2.31.1

