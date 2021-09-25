Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B049418189
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343776AbhIYL0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245514AbhIYLZd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90E1461283;
        Sat, 25 Sep 2021 11:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569038;
        bh=jJTdFkVIbFrNcti+vSAvnsUyuqLnAsTFH1czjUjL+4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPWtcrmfDyDMddu/oC/QnkpL4YXGkCgVKNf3L07H+kjGHXs6Chmk67nPjUN2TMJYc
         Y9kmkd1dw01fVgTD+LUXZlcZ3cg5+8TF1hIIkMUJ4X/ZApnmufzf6TAJ5x76nwkVGT
         39XuQ3/cKiPEhvAeAvluRwX/2k6/3qKwkZnOmrrXSdGNSptpGR2ZjNtLp2BV5aBgCH
         O7dxVzOWEOsE10/q7niHhLSdvaOjOhSiRQVT26AgVpzP+XKdVRwGrt31w+yq2whnTX
         jhfG5XJRtdzNemLyEOPxruOxcTh87Sovqe4PVHjmzMpcIbDWBa9VDvcW77pxSJNqC4
         0r0M29pUOynaQ==
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
Subject: [PATCH net-next v1 16/21] net: ethernet: ti: Move devlink registration to be last devlink command
Date:   Sat, 25 Sep 2021 14:22:56 +0300
Message-Id: <080c8889f80e48971dd9a1dadb4107882d83998d.1632565508.git.leonro@nvidia.com>
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
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 15 ++++++---------
 drivers/net/ethernet/ti/cpsw_new.c       |  7 ++-----
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index c2ea53ca92b6..0de5f4a4fe08 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2429,7 +2429,6 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 	dl_priv = devlink_priv(common->devlink);
 	dl_priv->common = common;
 
-	devlink_register(common->devlink);
 	/* Provide devlink hook to switch mode when multiple external ports
 	 * are present NUSS switchdev driver is enabled.
 	 */
@@ -2442,7 +2441,6 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 			dev_err(dev, "devlink params reg fail ret:%d\n", ret);
 			goto dl_unreg;
 		}
-		devlink_params_publish(common->devlink);
 	}
 
 	for (i = 1; i <= common->port_num; i++) {
@@ -2463,7 +2461,7 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 		}
 		devlink_port_type_eth_set(dl_port, port->ndev);
 	}
-
+	devlink_register(common->devlink);
 	return ret;
 
 dl_port_unreg:
@@ -2474,7 +2472,6 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 		devlink_port_unregister(dl_port);
 	}
 dl_unreg:
-	devlink_unregister(common->devlink);
 	devlink_free(common->devlink);
 	return ret;
 }
@@ -2485,6 +2482,8 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 	struct am65_cpsw_port *port;
 	int i;
 
+	devlink_unregister(common->devlink);
+
 	for (i = 1; i <= common->port_num; i++) {
 		port = am65_common_get_port(common, i);
 		dl_port = &port->devlink_port;
@@ -2493,13 +2492,11 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 	}
 
 	if (!AM65_CPSW_IS_CPSW2G(common) &&
-	    IS_ENABLED(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV)) {
-		devlink_params_unpublish(common->devlink);
-		devlink_params_unregister(common->devlink, am65_cpsw_devlink_params,
+	    IS_ENABLED(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV))
+		devlink_params_unregister(common->devlink,
+					  am65_cpsw_devlink_params,
 					  ARRAY_SIZE(am65_cpsw_devlink_params));
-	}
 
-	devlink_unregister(common->devlink);
 	devlink_free(common->devlink);
 }
 
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 204b4826303c..1530532748a8 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1810,7 +1810,6 @@ static int cpsw_register_devlink(struct cpsw_common *cpsw)
 	dl_priv = devlink_priv(cpsw->devlink);
 	dl_priv->cpsw = cpsw;
 
-	devlink_register(cpsw->devlink);
 	ret = devlink_params_register(cpsw->devlink, cpsw_devlink_params,
 				      ARRAY_SIZE(cpsw_devlink_params));
 	if (ret) {
@@ -1818,21 +1817,19 @@ static int cpsw_register_devlink(struct cpsw_common *cpsw)
 		goto dl_unreg;
 	}
 
-	devlink_params_publish(cpsw->devlink);
+	devlink_register(cpsw->devlink);
 	return ret;
 
 dl_unreg:
-	devlink_unregister(cpsw->devlink);
 	devlink_free(cpsw->devlink);
 	return ret;
 }
 
 static void cpsw_unregister_devlink(struct cpsw_common *cpsw)
 {
-	devlink_params_unpublish(cpsw->devlink);
+	devlink_unregister(cpsw->devlink);
 	devlink_params_unregister(cpsw->devlink, cpsw_devlink_params,
 				  ARRAY_SIZE(cpsw_devlink_params));
-	devlink_unregister(cpsw->devlink);
 	devlink_free(cpsw->devlink);
 }
 
-- 
2.31.1

