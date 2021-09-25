Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E881418199
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245316AbhIYL0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245087AbhIYLZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ACD06128E;
        Sat, 25 Sep 2021 11:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569051;
        bh=hIaU3zuCJ66VCcfkvkXkjfrXrZk0nBwoxqfW+xbNAI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBZGKXwn8MuXnfyIESlBTW1o1wITt4RwTx900BqVAekSocAOEd7gZDaIl7tnVZv6M
         q3Q21JYh+9eSN/awnLVNufvGKHgKSaIWRJy5ivfUktMueUS9g5/hLo0Uv9rxmHf4Ne
         211pPeYPpZMV6Ds75i05viWIuvhchW2NqqBhX4a07FEQj6wHLw3UpJKiYkdxkk0lFm
         bSZeh9Ke9vA+QngTRqW5Hu6S/Ti3v116zfBVCHrWYNiVgXRCmPHe0DYiSJ82TIpPaL
         C4vY9albBFHKQVnNf6fAbGot8HbEqBfjq0pJUTWDackF/nuQF7xemq0NLd1sc8oYoz
         jySHQjT6V/w9w==
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
Subject: [PATCH net-next v1 20/21] staging: qlge: Move devlink registration to be last devlink command
Date:   Sat, 25 Sep 2021 14:23:00 +0300
Message-Id: <87eb1893ae465eb0ec1ed726c9ca078edc8298ac.1632565508.git.leonro@nvidia.com>
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
 drivers/staging/qlge/qlge_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 33539f6c254d..1dc849378a0f 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4614,10 +4614,9 @@ static int qlge_probe(struct pci_dev *pdev,
 		goto netdev_free;
 	}
 
-	devlink_register(devlink);
 	err = qlge_health_create_reporters(qdev);
 	if (err)
-		goto devlink_unregister;
+		goto netdev_free;
 
 	/* Start up the timer to trigger EEH if
 	 * the bus goes dead
@@ -4628,10 +4627,9 @@ static int qlge_probe(struct pci_dev *pdev,
 	qlge_display_dev_info(ndev);
 	atomic_set(&qdev->lb_count, 0);
 	cards_found++;
+	devlink_register(devlink);
 	return 0;
 
-devlink_unregister:
-	devlink_unregister(devlink);
 netdev_free:
 	free_netdev(ndev);
 devlink_free:
@@ -4656,13 +4654,13 @@ static void qlge_remove(struct pci_dev *pdev)
 	struct net_device *ndev = qdev->ndev;
 	struct devlink *devlink = priv_to_devlink(qdev);
 
+	devlink_unregister(devlink);
 	del_timer_sync(&qdev->timer);
 	qlge_cancel_all_work_sync(qdev);
 	unregister_netdev(ndev);
 	qlge_release_all(pdev);
 	pci_disable_device(pdev);
 	devlink_health_reporter_destroy(qdev->reporter);
-	devlink_unregister(devlink);
 	devlink_free(devlink);
 	free_netdev(ndev);
 }
-- 
2.31.1

