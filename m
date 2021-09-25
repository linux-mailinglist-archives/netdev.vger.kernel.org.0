Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E2C41814F
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244762AbhIYLZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244666AbhIYLYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:24:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B42A61283;
        Sat, 25 Sep 2021 11:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569000;
        bh=xRgZ3AWYE+cjw+AzmeqCWdR+bIHtvensmJ8uaJBAUps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aymRkgQYkTzDBhqqTP79folPWNi8X49mHO2L2tqiqUk9wXUzZ0Di8bsa3ZfzLMbvC
         20CfstwEKU6FWZb2AL+7WZrvdgnkYyVG5xwv0JRAUCRnSchtrfU6SOBVeT0UU6dT8q
         AQSjWadd2bAEwdBC9j0iREfJ68uz9ce089/dDgLJag5I3c0/MQIHKZqVTSDDPSoLGq
         XJox5pp0mYvE261+05t8Gbg0v0NBQmbQa1XuS/MNhD8Zzaqbvnwk7Nc467F0ItXvao
         x7uUtwyzZoX4fJ2DL/t5c8uRX3UDaevYHaNGFK7uHak0Xh/vTGov1R5n1xA4TFKgsd
         doi+Oq+vIj9Rw==
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
Subject: [PATCH net-next v1 05/21] net: hinic: Open device for the user access when it is ready
Date:   Sat, 25 Sep 2021 14:22:45 +0300
Message-Id: <9956e9af5948084d725c547e307eb13656d569fc.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Move devlink registration to be the last command in device activation,
so it opens the driver to accept such devlink commands from the user
when it is fully initialized.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index b2ece3adbc72..657a15447bd0 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -754,11 +754,9 @@ static int init_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 		return err;
 	}
 
-	hinic_devlink_register(hwdev->devlink_dev);
 	err = hinic_func_to_func_init(hwdev);
 	if (err) {
 		dev_err(&hwif->pdev->dev, "Failed to init mailbox\n");
-		hinic_devlink_unregister(hwdev->devlink_dev);
 		hinic_pf_to_mgmt_free(&pfhwdev->pf_to_mgmt);
 		return err;
 	}
@@ -781,7 +779,7 @@ static int init_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 	}
 
 	hinic_set_pf_action(hwif, HINIC_PF_MGMT_ACTIVE);
-
+	hinic_devlink_register(hwdev->devlink_dev);
 	return 0;
 }
 
@@ -793,6 +791,7 @@ static void free_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 {
 	struct hinic_hwdev *hwdev = &pfhwdev->hwdev;
 
+	hinic_devlink_unregister(hwdev->devlink_dev);
 	hinic_set_pf_action(hwdev->hwif, HINIC_PF_MGMT_INIT);
 
 	if (!HINIC_IS_VF(hwdev->hwif)) {
@@ -810,8 +809,6 @@ static void free_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 
 	hinic_func_to_func_free(hwdev);
 
-	hinic_devlink_unregister(hwdev->devlink_dev);
-
 	hinic_pf_to_mgmt_free(&pfhwdev->pf_to_mgmt);
 }
 
-- 
2.31.1

