Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73ADC418191
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343866AbhIYL0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244574AbhIYLZj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68AA66127C;
        Sat, 25 Sep 2021 11:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569045;
        bh=ghHAU3D0r/NE4ZoiVTD12PA4CEB5+DDXgtVw+z6KtRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwqFg7wTZGt5iCU3qK7f4wQnVFfowX010H/dNk0sKyf2Fpcrv5KOUcXlAIBhvhPoY
         /sJUWV49DzbUxeN8p6I3AF6ECdTN7PmNiEByCCKEnxzM+ANBeNrqDkUBsa8wvx7pjY
         l7gK1Mg98ck7OMfilfsXCN1BXu4T2LFhFzqSpS1+7D7Ik5V4yCfVtNXCTqVdBBLNgU
         RYeFsB5DtlzpqCfBNk5OFoaCcrIqNg2aZv4c8yF/fZrRpXnW24LDPNyQYqG2Q48wD7
         ygTcKaPuygBRzHa5ObPnkA9FWV/kwePaSjWQtO8VR3EO/b6nHsGW0c+0vdXzTYphjW
         eun1aIUbsGYZg==
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
Subject: [PATCH net-next v1 15/21] qed: Move devlink registration to be last devlink command
Date:   Sat, 25 Sep 2021 14:22:55 +0300
Message-Id: <01bc35bd99dc5d2dcbf55bbf4a86f0bde1c50087.1632565508.git.leonro@nvidia.com>
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
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index c51f9590fe19..6bb4e165b592 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -215,7 +215,6 @@ struct devlink *qed_devlink_register(struct qed_dev *cdev)
 	qdevlink = devlink_priv(dl);
 	qdevlink->cdev = cdev;
 
-	devlink_register(dl);
 	rc = devlink_params_register(dl, qed_devlink_params,
 				     ARRAY_SIZE(qed_devlink_params));
 	if (rc)
@@ -226,15 +225,13 @@ struct devlink *qed_devlink_register(struct qed_dev *cdev)
 					   QED_DEVLINK_PARAM_ID_IWARP_CMT,
 					   value);
 
-	devlink_params_publish(dl);
 	cdev->iwarp_cmt = false;
 
 	qed_fw_reporters_create(dl);
-
+	devlink_register(dl);
 	return dl;
 
 err_unregister:
-	devlink_unregister(dl);
 	devlink_free(dl);
 
 	return ERR_PTR(rc);
@@ -245,11 +242,11 @@ void qed_devlink_unregister(struct devlink *devlink)
 	if (!devlink)
 		return;
 
+	devlink_unregister(devlink);
 	qed_fw_reporters_destroy(devlink);
 
 	devlink_params_unregister(devlink, qed_devlink_params,
 				  ARRAY_SIZE(qed_devlink_params));
 
-	devlink_unregister(devlink);
 	devlink_free(devlink);
 }
-- 
2.31.1

