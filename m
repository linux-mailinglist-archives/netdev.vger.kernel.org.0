Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59C1414455
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbhIVI7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234051AbhIVI7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 04:59:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1203C6135F;
        Wed, 22 Sep 2021 08:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632301089;
        bh=vzUjT5m35p9Bxpwx7VjcoSd9wMpHa9hNJTxqXQ2vFfw=;
        h=From:To:Cc:Subject:Date:From;
        b=N8TQNbl9iaOjL4Vgox+YdKVR2n5zA/0fIHWjG5Vk7gXB2E+H79GoxC0xKa4SL2h/G
         CRlaQTL/MRc82d5bbcHQtTsYlJM/Uleoe87dPbfaPTyBr4gXLMvLm89q6wRDyuJUOi
         kyhdQrSphWBbyfgm8JfAM/OYOLuM3mjjwo1UWcpxiPyKBPjQJVZEjO7vQOigQA4uCe
         85BxXVSxUJfdBY5WFmwyroDjv1OECvjqNrUEYy2JDbWn+5eQrjH+yKAvA4JMk2uy6Y
         RXb13+yJmBTNOcs5fNnwFMWZ7YycDxFwpHoLqYQii3KczlZuDMP6rI7k6n1eZij6rT
         uurTsRh2bSw2g==
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
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: [PATCH net-next v1] devlink: Make devlink_register to be void
Date:   Wed, 22 Sep 2021 11:58:03 +0300
Message-Id: <311a6c7e74ad612474446890a12c9d310b9507ed.1632300324.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

devlink_register() can't fail and always returns success, but all drivers
are obligated to check returned status anyway. This adds a lot of boilerplate
code to handle impossible flow.

Make devlink_register() void and simplify the drivers that use that
API call.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
v1:
 * Converted iosm too
v0: https://lore.kernel.org/all/2e089a45e03db31bf451d768fc588c02a2f781e8.1632148852.git.leonro@nvidia.com
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 11 ++---------
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  8 +-------
 .../ethernet/freescale/dpaa2/dpaa2-eth-devlink.c   | 13 +------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c | 14 +-------------
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c        | 14 +-------------
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c  |  4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_devlink.h  |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |  8 +-------
 drivers/net/ethernet/intel/ice/ice_devlink.c       | 12 ++----------
 drivers/net/ethernet/intel/ice/ice_devlink.h       |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  6 +-----
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |  8 +-------
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  |  8 +-------
 .../ethernet/marvell/prestera/prestera_devlink.c   |  6 +-----
 drivers/net/ethernet/mellanox/mlx4/main.c          |  5 +----
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  5 +----
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  8 ++------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |  6 +-----
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  |  6 +-----
 .../net/ethernet/pensando/ionic/ionic_devlink.c    |  7 +------
 drivers/net/ethernet/qlogic/qed/qed_devlink.c      |  7 +------
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  9 +--------
 drivers/net/ethernet/ti/cpsw_new.c                 |  8 +-------
 drivers/net/netdevsim/dev.c                        |  6 +-----
 drivers/net/wwan/iosm/iosm_ipc_devlink.c           |  8 +-------
 drivers/ptp/ptp_ocp.c                              |  7 +------
 drivers/staging/qlge/qlge_main.c                   |  6 +-----
 include/net/devlink.h                              |  2 +-
 net/core/devlink.c                                 |  3 +--
 net/dsa/dsa2.c                                     |  7 +------
 30 files changed, 34 insertions(+), 182 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 9576547df4ab..bf7d3c17049b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -802,12 +802,7 @@ int bnxt_dl_register(struct bnxt *bp)
 	    bp->hwrm_spec_code > 0x10803)
 		bp->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 
-	rc = devlink_register(dl);
-	if (rc) {
-		netdev_warn(bp->dev, "devlink_register failed. rc=%d\n", rc);
-		goto err_dl_free;
-	}
-
+	devlink_register(dl);
 	if (!BNXT_PF(bp))
 		return 0;
 
@@ -819,7 +814,7 @@ int bnxt_dl_register(struct bnxt *bp)
 	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
 	if (rc) {
 		netdev_err(bp->dev, "devlink_port_register failed\n");
-		goto err_dl_unreg;
+		goto err_dl_free;
 	}
 
 	rc = bnxt_dl_params_register(bp);
@@ -830,8 +825,6 @@ int bnxt_dl_register(struct bnxt *bp)
 
 err_dl_port_unreg:
 	devlink_port_unregister(&bp->dl_port);
-err_dl_unreg:
-	devlink_unregister(dl);
 err_dl_free:
 	bnxt_link_bp_to_dl(bp, NULL);
 	devlink_free(dl);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 2907e13b9df6..a34b3bb2dd4f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3760,13 +3760,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 	lio_devlink = devlink_priv(devlink);
 	lio_devlink->oct = octeon_dev;
 
-	if (devlink_register(devlink)) {
-		devlink_free(devlink);
-		dev_err(&octeon_dev->pci_dev->dev,
-			"devlink registration failed\n");
-		goto setup_nic_dev_free;
-	}
-
+	devlink_register(devlink);
 	octeon_dev->devlink = devlink;
 	octeon_dev->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
index 605a39f892b9..426926fb6fc6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
@@ -194,7 +194,6 @@ int dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv)
 	struct net_device *net_dev = priv->net_dev;
 	struct device *dev = net_dev->dev.parent;
 	struct dpaa2_eth_devlink_priv *dl_priv;
-	int err;
 
 	priv->devlink =
 		devlink_alloc(&dpaa2_eth_devlink_ops, sizeof(*dl_priv), dev);
@@ -205,18 +204,8 @@ int dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv)
 	dl_priv = devlink_priv(priv->devlink);
 	dl_priv->dpaa2_priv = priv;
 
-	err = devlink_register(priv->devlink);
-	if (err) {
-		dev_err(dev, "devlink_register() = %d\n", err);
-		goto devlink_free;
-	}
-
+	devlink_register(priv->devlink);
 	return 0;
-
-devlink_free:
-	devlink_free(priv->devlink);
-
-	return err;
 }
 
 void dpaa2_eth_dl_unregister(struct dpaa2_eth_priv *priv)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index e4aad695abcc..59b0ae7d59e0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -109,7 +109,6 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	struct pci_dev *pdev = hdev->pdev;
 	struct hclge_devlink_priv *priv;
 	struct devlink *devlink;
-	int ret;
 
 	devlink = devlink_alloc(&hclge_devlink_ops,
 				sizeof(struct hclge_devlink_priv), &pdev->dev);
@@ -120,20 +119,9 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
-	ret = devlink_register(devlink);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register devlink, ret = %d\n",
-			ret);
-		goto out_reg_fail;
-	}
-
+	devlink_register(devlink);
 	devlink_reload_enable(devlink);
-
 	return 0;
-
-out_reg_fail:
-	devlink_free(devlink);
-	return ret;
 }
 
 void hclge_devlink_uninit(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index f478770299c6..d60cc9426f70 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -110,7 +110,6 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 	struct pci_dev *pdev = hdev->pdev;
 	struct hclgevf_devlink_priv *priv;
 	struct devlink *devlink;
-	int ret;
 
 	devlink =
 		devlink_alloc(&hclgevf_devlink_ops,
@@ -122,20 +121,9 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 	priv->hdev = hdev;
 	hdev->devlink = devlink;
 
-	ret = devlink_register(devlink);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register devlink, ret = %d\n",
-			ret);
-		goto out_reg_fail;
-	}
-
+	devlink_register(devlink);
 	devlink_reload_enable(devlink);
-
 	return 0;
-
-out_reg_fail:
-	devlink_free(devlink);
-	return ret;
 }
 
 void hclgevf_devlink_uninit(struct hclgevf_dev *hdev)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index 6e11ee339f12..60ae8bfc5f69 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -303,11 +303,11 @@ void hinic_devlink_free(struct devlink *devlink)
 	devlink_free(devlink);
 }
 
-int hinic_devlink_register(struct hinic_devlink_priv *priv)
+void hinic_devlink_register(struct hinic_devlink_priv *priv)
 {
 	struct devlink *devlink = priv_to_devlink(priv);
 
-	return devlink_register(devlink);
+	devlink_register(devlink);
 }
 
 void hinic_devlink_unregister(struct hinic_devlink_priv *priv)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
index 9e315011015c..46760d607b9b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
@@ -110,7 +110,7 @@ struct host_image_st {
 
 struct devlink *hinic_devlink_alloc(struct device *dev);
 void hinic_devlink_free(struct devlink *devlink);
-int hinic_devlink_register(struct hinic_devlink_priv *priv);
+void hinic_devlink_register(struct hinic_devlink_priv *priv);
 void hinic_devlink_unregister(struct hinic_devlink_priv *priv);
 
 int hinic_health_reporters_create(struct hinic_devlink_priv *priv);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 56b6b04e209b..b2ece3adbc72 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -754,13 +754,7 @@ static int init_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 		return err;
 	}
 
-	err = hinic_devlink_register(hwdev->devlink_dev);
-	if (err) {
-		dev_err(&hwif->pdev->dev, "Failed to register devlink\n");
-		hinic_pf_to_mgmt_free(&pfhwdev->pf_to_mgmt);
-		return err;
-	}
-
+	hinic_devlink_register(hwdev->devlink_dev);
 	err = hinic_func_to_func_init(hwdev);
 	if (err) {
 		dev_err(&hwif->pdev->dev, "Failed to init mailbox\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 14afce82ef63..ab3d876fa624 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -498,19 +498,11 @@ struct ice_pf *ice_allocate_pf(struct device *dev)
  *
  * Return: zero on success or an error code on failure.
  */
-int ice_devlink_register(struct ice_pf *pf)
+void ice_devlink_register(struct ice_pf *pf)
 {
 	struct devlink *devlink = priv_to_devlink(pf);
-	struct device *dev = ice_pf_to_dev(pf);
-	int err;
 
-	err = devlink_register(devlink);
-	if (err) {
-		dev_err(dev, "devlink registration failed: %d\n", err);
-		return err;
-	}
-
-	return 0;
+	devlink_register(devlink);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.h b/drivers/net/ethernet/intel/ice/ice_devlink.h
index e07e74426bde..e721d7b0d627 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.h
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
@@ -6,7 +6,7 @@
 
 struct ice_pf *ice_allocate_pf(struct device *dev);
 
-int ice_devlink_register(struct ice_pf *pf);
+void ice_devlink_register(struct ice_pf *pf);
 void ice_devlink_unregister(struct ice_pf *pf);
 int ice_devlink_create_port(struct ice_vsi *vsi);
 void ice_devlink_destroy_port(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0d6c143f6653..34e64533026a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4258,11 +4258,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	pf->msg_enable = netif_msg_init(debug, ICE_DFLT_NETIF_M);
 
-	err = ice_devlink_register(pf);
-	if (err) {
-		dev_err(dev, "ice_devlink_register failed: %d\n", err);
-		goto err_exit_unroll;
-	}
+	ice_devlink_register(pf);
 
 #ifndef CONFIG_DYNAMIC_DEBUG
 	if (debug < -1)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 274d3abe30eb..de9562acd04b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1510,13 +1510,7 @@ int rvu_register_dl(struct rvu *rvu)
 		return -ENOMEM;
 	}
 
-	err = devlink_register(dl);
-	if (err) {
-		dev_err(rvu->dev, "devlink register failed with error %d\n", err);
-		devlink_free(dl);
-		return err;
-	}
-
+	devlink_register(dl);
 	rvu_dl = devlink_priv(dl);
 	rvu_dl->dl = dl;
 	rvu_dl->rvu = rvu;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 7ac3ef2fa06a..3de18f9433ae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -108,13 +108,7 @@ int otx2_register_dl(struct otx2_nic *pfvf)
 		return -ENOMEM;
 	}
 
-	err = devlink_register(dl);
-	if (err) {
-		dev_err(pfvf->dev, "devlink register failed with error %d\n", err);
-		devlink_free(dl);
-		return err;
-	}
-
+	devlink_register(dl);
 	otx2_dl = devlink_priv(dl);
 	otx2_dl->dl = dl;
 	otx2_dl->pfvf = pfvf;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index 68b442eb6d69..5cca007a3e17 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -412,11 +412,7 @@ int prestera_devlink_register(struct prestera_switch *sw)
 	struct devlink *dl = priv_to_devlink(sw);
 	int err;
 
-	err = devlink_register(dl);
-	if (err) {
-		dev_err(prestera_dev(sw), "devlink_register failed: %d\n", err);
-		return err;
-	}
+	devlink_register(dl);
 
 	err = prestera_devlink_traps_register(sw);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 5a6b0fcaf7f8..27ed4694fbea 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4015,9 +4015,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&dev->persist->interface_state_mutex);
 	mutex_init(&dev->persist->pci_status_mutex);
 
-	ret = devlink_register(devlink);
-	if (ret)
-		goto err_persist_free;
+	devlink_register(devlink);
 	ret = devlink_params_register(devlink, mlx4_devlink_params,
 				      ARRAY_SIZE(mlx4_devlink_params));
 	if (ret)
@@ -4037,7 +4035,6 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 				  ARRAY_SIZE(mlx4_devlink_params));
 err_devlink_unregister:
 	devlink_unregister(devlink);
-err_persist_free:
 	kfree(dev->persist);
 err_devlink_free:
 	devlink_free(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 7d56a927081d..b36f721625e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -793,10 +793,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 {
 	int err;
 
-	err = devlink_register(devlink);
-	if (err)
-		return err;
-
+	devlink_register(devlink);
 	err = devlink_params_register(devlink, mlx5_devlink_params,
 				      ARRAY_SIZE(mlx5_devlink_params));
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 8c634976ca77..9a570fa167b6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1973,11 +1973,8 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_emad_init;
 
-	if (!reload) {
-		err = devlink_register(devlink);
-		if (err)
-			goto err_devlink_register;
-	}
+	if (!reload)
+		devlink_register(devlink);
 
 	if (!reload) {
 		err = mlxsw_core_params_register(mlxsw_core);
@@ -2035,7 +2032,6 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 err_register_params:
 	if (!reload)
 		devlink_unregister(devlink);
-err_devlink_register:
 	mlxsw_emad_fini(mlxsw_core);
 err_emad_init:
 	kfree(mlxsw_core->lag.mapping);
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 291ae6817c26..2b8ea48d2fc4 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1134,10 +1134,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_put_ports;
 
-	err = devlink_register(devlink);
-	if (err)
-		goto out_ocelot_deinit;
-
+	devlink_register(devlink);
 	err = mscc_ocelot_init_ports(pdev, ports);
 	if (err)
 		goto out_ocelot_devlink_unregister;
@@ -1170,7 +1167,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	mscc_ocelot_teardown_devlink_ports(ocelot);
 out_ocelot_devlink_unregister:
 	devlink_unregister(devlink);
-out_ocelot_deinit:
 	ocelot_deinit(ocelot);
 out_put_ports:
 	of_node_put(ports);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index d10a93801344..616872928ada 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -701,10 +701,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	if (err)
 		goto err_unmap;
 
-	err = devlink_register(devlink);
-	if (err)
-		goto err_app_clean;
-
+	devlink_register(devlink);
 	err = nfp_shared_buf_register(pf);
 	if (err)
 		goto err_devlink_unreg;
@@ -752,7 +749,6 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 err_devlink_unreg:
 	cancel_work_sync(&pf->port_refresh_work);
 	devlink_unregister(devlink);
-err_app_clean:
 	nfp_net_pf_app_clean(pf);
 err_unmap:
 	nfp_net_pci_unmap_mem(pf);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index c7d0e195d176..93282394d332 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -82,12 +82,7 @@ int ionic_devlink_register(struct ionic *ionic)
 	struct devlink_port_attrs attrs = {};
 	int err;
 
-	err = devlink_register(dl);
-	if (err) {
-		dev_warn(ionic->dev, "devlink_register failed: %d\n", err);
-		return err;
-	}
-
+	devlink_register(dl);
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	devlink_port_attrs_set(&ionic->dl_port, &attrs);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index 78070682f2df..c51f9590fe19 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -215,10 +215,7 @@ struct devlink *qed_devlink_register(struct qed_dev *cdev)
 	qdevlink = devlink_priv(dl);
 	qdevlink->cdev = cdev;
 
-	rc = devlink_register(dl);
-	if (rc)
-		goto err_free;
-
+	devlink_register(dl);
 	rc = devlink_params_register(dl, qed_devlink_params,
 				     ARRAY_SIZE(qed_devlink_params));
 	if (rc)
@@ -238,8 +235,6 @@ struct devlink *qed_devlink_register(struct qed_dev *cdev)
 
 err_unregister:
 	devlink_unregister(dl);
-
-err_free:
 	devlink_free(dl);
 
 	return ERR_PTR(rc);
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 130346f74ee8..c2ea53ca92b6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2429,12 +2429,7 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 	dl_priv = devlink_priv(common->devlink);
 	dl_priv->common = common;
 
-	ret = devlink_register(common->devlink);
-	if (ret) {
-		dev_err(dev, "devlink reg fail ret:%d\n", ret);
-		goto dl_free;
-	}
-
+	devlink_register(common->devlink);
 	/* Provide devlink hook to switch mode when multiple external ports
 	 * are present NUSS switchdev driver is enabled.
 	 */
@@ -2480,9 +2475,7 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 	}
 dl_unreg:
 	devlink_unregister(common->devlink);
-dl_free:
 	devlink_free(common->devlink);
-
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 7968f24d99c8..204b4826303c 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1810,12 +1810,7 @@ static int cpsw_register_devlink(struct cpsw_common *cpsw)
 	dl_priv = devlink_priv(cpsw->devlink);
 	dl_priv->cpsw = cpsw;
 
-	ret = devlink_register(cpsw->devlink);
-	if (ret) {
-		dev_err(dev, "DL reg fail ret:%d\n", ret);
-		goto dl_free;
-	}
-
+	devlink_register(cpsw->devlink);
 	ret = devlink_params_register(cpsw->devlink, cpsw_devlink_params,
 				      ARRAY_SIZE(cpsw_devlink_params));
 	if (ret) {
@@ -1828,7 +1823,6 @@ static int cpsw_register_devlink(struct cpsw_common *cpsw)
 
 dl_unreg:
 	devlink_unregister(cpsw->devlink);
-dl_free:
 	devlink_free(cpsw->devlink);
 	return ret;
 }
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 54313bd57797..b2214bc9efe2 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1470,10 +1470,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_devlink_free;
 
-	err = devlink_register(devlink);
-	if (err)
-		goto err_resources_unregister;
-
+	devlink_register(devlink);
 	err = devlink_params_register(devlink, nsim_devlink_params,
 				      ARRAY_SIZE(nsim_devlink_params));
 	if (err)
@@ -1538,7 +1535,6 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
 	devlink_unregister(devlink);
-err_resources_unregister:
 	devlink_resources_unregister(devlink, NULL);
 err_devlink_free:
 	devlink_free(devlink);
diff --git a/drivers/net/wwan/iosm/iosm_ipc_devlink.c b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
index 7fd7956cc61e..aa1c8c6276dc 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_devlink.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
@@ -290,11 +290,7 @@ struct iosm_devlink *ipc_devlink_init(struct iosm_imem *ipc_imem)
 	ipc_devlink->devlink_ctx = devlink_ctx;
 	ipc_devlink->pcie = ipc_imem->pcie;
 	ipc_devlink->dev = ipc_imem->dev;
-	rc = devlink_register(devlink_ctx);
-	if (rc) {
-		dev_err(ipc_devlink->dev, "devlink_register failed rc %d", rc);
-		goto free_dl;
-	}
+	devlink_register(devlink_ctx);
 
 	rc = devlink_params_register(devlink_ctx, iosm_devlink_params,
 				     ARRAY_SIZE(iosm_devlink_params));
@@ -334,8 +330,6 @@ struct iosm_devlink *ipc_devlink_init(struct iosm_imem *ipc_imem)
 	devlink_params_unregister(devlink_ctx, iosm_devlink_params,
 				  ARRAY_SIZE(iosm_devlink_params));
 param_reg_fail:
-	devlink_unregister(devlink_ctx);
-free_dl:
 	devlink_free(devlink_ctx);
 devlink_alloc_fail:
 	return NULL;
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index c26708f486cf..4c25467198e3 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -2455,10 +2455,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 	}
 
-	err = devlink_register(devlink);
-	if (err)
-		goto out_free;
-
+	devlink_register(devlink);
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pci_enable_device\n");
@@ -2510,9 +2507,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_disable_device(pdev);
 out_unregister:
 	devlink_unregister(devlink);
-out_free:
 	devlink_free(devlink);
-
 	return err;
 }
 
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 8fcdf89da8aa..33539f6c254d 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4614,12 +4614,8 @@ static int qlge_probe(struct pci_dev *pdev,
 		goto netdev_free;
 	}
 
-	err = devlink_register(devlink);
-	if (err)
-		goto netdev_free;
-
+	devlink_register(devlink);
 	err = qlge_health_create_reporters(qdev);
-
 	if (err)
 		goto devlink_unregister;
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 0e06b3dbbec6..c902e8e5f012 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1566,7 +1566,7 @@ static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
 {
 	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
 }
-int devlink_register(struct devlink *devlink);
+void devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_reload_enable(struct devlink *devlink);
 void devlink_reload_disable(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0f1663453ca0..7d975057c2a9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8960,13 +8960,12 @@ EXPORT_SYMBOL_GPL(devlink_alloc_ns);
  *
  *	@devlink: devlink
  */
-int devlink_register(struct devlink *devlink)
+void devlink_register(struct devlink *devlink)
 {
 	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	mutex_unlock(&devlink_mutex);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_register);
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index eef13cd20f19..96f211f52ac3 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -804,10 +804,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	dl_priv = devlink_priv(ds->devlink);
 	dl_priv->ds = ds;
 
-	err = devlink_register(ds->devlink);
-	if (err)
-		goto free_devlink;
-
+	devlink_register(ds->devlink);
 	/* Setup devlink port instances now, so that the switch
 	 * setup() can register regions etc, against the ports
 	 */
@@ -863,10 +860,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 		if (dp->ds == ds)
 			dsa_port_devlink_teardown(dp);
 	devlink_unregister(ds->devlink);
-free_devlink:
 	devlink_free(ds->devlink);
 	ds->devlink = NULL;
-
 	return err;
 }
 
-- 
2.31.1

