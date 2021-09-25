Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FD941818D
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245174AbhIYL0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245428AbhIYLZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 002256128A;
        Sat, 25 Sep 2021 11:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569041;
        bh=Cl3NV1NYQWAcpVSM6GygwU59q/PE56ay+2A5k8m+/J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFN1GH5Yf1Hsh8UTT6arSQ8EKwmk0uMdcSCGgM/dgkyj3ocPsN9Vib6wa5dZd1Vwz
         u8rLDRoYW6di1kveNeOMohk6xPKcEvcce/XHpWBXbVjOIlFhpzFhJHHK+3QOzz2Zr9
         UPBq95GV2ADYPAzc6L51cg9xLwD9Le8xe4Vc4UqonE/62LqGC9UUMf9agd++VJIEnk
         1BjNKGV/rp1lfPh2q4rxGAM52rDVmF/gwCAivI1rzyB7FhJa0oKEDBVXsd+6pTJ0ZD
         KPsnfCNXWwdH+x7un/bTHw9zKjbfqAmmcjpTdlnAKXgf/Elqbq1UnyzIKCBdF0jyOH
         RvSInpbsT4LUg==
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
Subject: [PATCH net-next v1 17/21] netdevsim: Move devlink registration to be last devlink command
Date:   Sat, 25 Sep 2021 14:22:57 +0300
Message-Id: <87822c7b4f20182c37758a2c0b9bb84a0a3edaf8.1632565508.git.leonro@nvidia.com>
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
fully configured.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b2214bc9efe2..cb6645012a30 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1470,7 +1470,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_devlink_free;
 
-	devlink_register(devlink);
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
 	if (err)
@@ -1511,9 +1510,9 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_psample_exit;
 
-	devlink_params_publish(devlink);
-	devlink_reload_enable(devlink);
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
+	devlink_register(devlink);
+	devlink_reload_enable(devlink);
 	return 0;
 
 err_psample_exit:
@@ -1534,7 +1533,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
-	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
 err_devlink_free:
 	devlink_free(devlink);
@@ -1569,6 +1567,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
 	devlink_reload_disable(devlink);
+	devlink_unregister(devlink);
 
 	nsim_dev_reload_destroy(nsim_dev);
 
@@ -1576,7 +1575,6 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev_debugfs_exit(nsim_dev);
 	devlink_params_unregister(devlink, nsim_devlink_params,
 				  ARRAY_SIZE(nsim_devlink_params));
-	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
 	devlink_free(devlink);
 }
-- 
2.31.1

