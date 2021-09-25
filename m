Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FA341815B
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245205AbhIYLZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244930AbhIYLZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:25:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42CC86127A;
        Sat, 25 Sep 2021 11:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632569007;
        bh=1Fnka8ps90Zylh+ydNx/A5aVv/Vtl8oI7QwGTBkxA5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/RREPSk0+dMrPt2ZhjQQE6yWhqRdBVusehpcFG2nS6PEjbiY1fkQqX5oNJSMq6l5
         yjJHliByFUAzg3jr1HOGac7gBEFipVghPyyQg9UeqRZ6xTZNalYQP1kQwNu/Z9fJku
         wz+Kh+NytJ1mpAo0fdujHFCyIeaORwISRAF3E4zwXEYSLUBkgFAZB3Pnibo5cQe+u+
         IgLybrtUtt3EoigRgqXbOnGBmFH/Y9BTAnrnZ08U/ssToKdsANp9vwBxfjjrLs0KTm
         cYvnLTAcsp65QzrliUDhNGLpg4GHwdwUF941D188Ic+EeR3yVitlX/9vcpDTRug49/
         KqJEz5/5w/lAQ==
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
Subject: [PATCH net-next v1 07/21] octeontx2: Move devlink registration to be last devlink command
Date:   Sat, 25 Sep 2021 14:22:47 +0300
Message-Id: <c711bbd0519dfdf3d28141cf9aa159d05f94aab7.1632565508.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632565508.git.leonro@nvidia.com>
References: <cover.1632565508.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This change prevents from users to access device before devlink is fully
configured. This change allows us to delete call to devlink_params_publish()
and impossible check during unregister flow.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c   | 10 ++--------
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c | 15 +++------------
 2 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index de9562acd04b..70bacd38a6d9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1510,7 +1510,6 @@ int rvu_register_dl(struct rvu *rvu)
 		return -ENOMEM;
 	}
 
-	devlink_register(dl);
 	rvu_dl = devlink_priv(dl);
 	rvu_dl->dl = dl;
 	rvu_dl->rvu = rvu;
@@ -1531,13 +1530,11 @@ int rvu_register_dl(struct rvu *rvu)
 		goto err_dl_health;
 	}
 
-	devlink_params_publish(dl);
-
+	devlink_register(dl);
 	return 0;
 
 err_dl_health:
 	rvu_health_reporters_destroy(rvu);
-	devlink_unregister(dl);
 	devlink_free(dl);
 	return err;
 }
@@ -1547,12 +1544,9 @@ void rvu_unregister_dl(struct rvu *rvu)
 	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
 	struct devlink *dl = rvu_dl->dl;
 
-	if (!dl)
-		return;
-
+	devlink_unregister(dl);
 	devlink_params_unregister(dl, rvu_af_dl_params,
 				  ARRAY_SIZE(rvu_af_dl_params));
 	rvu_health_reporters_destroy(rvu);
-	devlink_unregister(dl);
 	devlink_free(dl);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 3de18f9433ae..777a27047c8e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -108,7 +108,6 @@ int otx2_register_dl(struct otx2_nic *pfvf)
 		return -ENOMEM;
 	}
 
-	devlink_register(dl);
 	otx2_dl = devlink_priv(dl);
 	otx2_dl->dl = dl;
 	otx2_dl->pfvf = pfvf;
@@ -122,12 +121,10 @@ int otx2_register_dl(struct otx2_nic *pfvf)
 		goto err_dl;
 	}
 
-	devlink_params_publish(dl);
-
+	devlink_register(dl);
 	return 0;
 
 err_dl:
-	devlink_unregister(dl);
 	devlink_free(dl);
 	return err;
 }
@@ -135,16 +132,10 @@ int otx2_register_dl(struct otx2_nic *pfvf)
 void otx2_unregister_dl(struct otx2_nic *pfvf)
 {
 	struct otx2_devlink *otx2_dl = pfvf->dl;
-	struct devlink *dl;
-
-	if (!otx2_dl || !otx2_dl->dl)
-		return;
-
-	dl = otx2_dl->dl;
+	struct devlink *dl = otx2_dl->dl;
 
+	devlink_unregister(dl);
 	devlink_params_unregister(dl, otx2_dl_params,
 				  ARRAY_SIZE(otx2_dl_params));
-
-	devlink_unregister(dl);
 	devlink_free(dl);
 }
-- 
2.31.1

