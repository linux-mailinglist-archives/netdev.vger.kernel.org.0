Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8C1418186
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343732AbhIYL0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:26:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245431AbhIYLZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 291B1610F7;
        Sat, 25 Sep 2021 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569035;
        bh=8KdGOHxpJSC+PZ1rdlS7MYCY0+1MQwiYwEoCEiKpnEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CK0GxpGxVjLr6RMM+yLXjKxbrpzgr1NnmO2ZnSXdEbzjFggId6zMbRa/xFtmvhjFN
         mHKRHmRMWTn5ChvHLRZTYU+N7Q7pLuOMUtwQ6zn+pKMvS8zUMFcJGA2UcdEV1Fi8wM
         +c4uZH2zSGoVvfTMbgqPCMGxTnbFCubhs5kpa1HJVcrcL7pJP3UkPHw4dGdT6rOHzZ
         vWEjzOs1we9xOVQARO7alLjH6+/uytOgF3T8gLYPv/+La5k7Rs8Jacrqio9f7L7JMT
         bxer9M0yfSRvZLSv+yTlkpTRGW7BuRn3qYcG2CV5E719HbqtOGSCHbvHuDasNw5RTr
         DWyTQ/DNs4W6Q==
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
Subject: [PATCH net-next v1 12/21] net: mscc: ocelot: delay devlink registration to the end
Date:   Sat, 25 Sep 2021 14:22:52 +0300
Message-Id: <6c20043398a8543fb69795be5ab1e200613fb881.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Open access to the devlink interface when the driver fully initialized.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 2b8ea48d2fc4..5d01993f6be0 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1134,7 +1134,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_put_ports;
 
-	devlink_register(devlink);
 	err = mscc_ocelot_init_ports(pdev, ports);
 	if (err)
 		goto out_ocelot_devlink_unregister;
@@ -1157,6 +1156,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 
 	of_node_put(ports);
+	devlink_register(devlink);
 
 	dev_info(&pdev->dev, "Ocelot switch probed\n");
 
@@ -1166,7 +1166,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	mscc_ocelot_release_ports(ocelot);
 	mscc_ocelot_teardown_devlink_ports(ocelot);
 out_ocelot_devlink_unregister:
-	devlink_unregister(devlink);
 	ocelot_deinit(ocelot);
 out_put_ports:
 	of_node_put(ports);
@@ -1179,11 +1178,11 @@ static int mscc_ocelot_remove(struct platform_device *pdev)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
 
+	devlink_unregister(ocelot->devlink);
 	ocelot_deinit_timestamp(ocelot);
 	ocelot_devlink_sb_unregister(ocelot);
 	mscc_ocelot_release_ports(ocelot);
 	mscc_ocelot_teardown_devlink_ports(ocelot);
-	devlink_unregister(ocelot->devlink);
 	ocelot_deinit(ocelot);
 	unregister_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 	unregister_switchdev_notifier(&ocelot_switchdev_nb);
-- 
2.31.1

