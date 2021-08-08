Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3013E3C4C
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 20:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhHHS6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 14:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhHHS6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 14:58:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C858B60462;
        Sun,  8 Aug 2021 18:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628449069;
        bh=Y+2JLGlyvbJqMvyEVMqEGlnHMHMJDeHF/UAdVmGp5iY=;
        h=From:To:Cc:Subject:Date:From;
        b=XG56aCwn4CpAXHXSzKBjkpX5S27rTfpCgdPSjWTAlA7IvcMaVzm4rdGIf3kehr12+
         ppT4fCAqRu/E0LXmilY+ZQJROk/p/Hv5mj7N5/CwUs1pVcbTlPFMjEHkVggpPCtJls
         HcoXeakCxHBMuKXkKAoJEDYNz3eOYt6pEW/+VQk8DjVaqfakVnk8Y+ljk6iZYvRoh4
         JyKaxXD6aXdzmi75jcnutl1Jj5Il3HKbH6I5IXqdRX3TLK3MOvfXFz7V66oo3d6+3M
         vGjJ0AF1MZwOdh11+S2koCiem4SMQ3SHvXqvLHoZUGH+DiirqDQw5L0N029LDrQ0du
         Q1rItDc+//yow==
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
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-staging@lists.linux.dev, Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
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
Subject: [PATCH net-next] devlink: Set device as early as possible
Date:   Sun,  8 Aug 2021 21:57:43 +0300
Message-Id: <6859503f7e3e6cd706bf01ef06f1cae8c0b0970b.1628449004.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

All kernel devlink implementations call to devlink_alloc() during
initialization routine for specific device which is used later as
a parent device for devlink_register().

Such late device assignment causes to the situation which requires us to
call to device_register() before setting other parameters, but that call
opens devlink to the world and makes accessible for the netlink users.

Any attempt to move devlink_register() to be the last call generates the
following error due to access to the devlink->dev pointer.

[    8.758862]  devlink_nl_param_fill+0x2e8/0xe50
[    8.760305]  devlink_param_notify+0x6d/0x180
[    8.760435]  __devlink_params_register+0x2f1/0x670
[    8.760558]  devlink_params_register+0x1e/0x20

The simple change of API to set devlink device in the devlink_alloc()
instead of devlink_register() fixes all this above and ensures that
prior to call to devlink_register() everything already set.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  9 ++++---
 .../net/ethernet/cavium/liquidio/lio_main.c   |  5 ++--
 .../freescale/dpaa2/dpaa2-eth-devlink.c       |  5 ++--
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  4 +--
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  7 ++---
 .../net/ethernet/huawei/hinic/hinic_devlink.c |  8 +++---
 .../net/ethernet/huawei/hinic/hinic_devlink.h |  4 +--
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  2 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  4 +--
 .../marvell/octeontx2/af/rvu_devlink.c        |  5 ++--
 .../marvell/prestera/prestera_devlink.c       |  7 ++---
 .../marvell/prestera/prestera_devlink.h       |  2 +-
 .../ethernet/marvell/prestera/prestera_main.c |  2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |  4 +--
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  9 ++++---
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  4 +--
 .../net/ethernet/mellanox/mlx5/core/main.c    |  4 +--
 .../mellanox/mlx5/core/sf/dev/driver.c        |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  5 ++--
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  5 ++--
 drivers/net/ethernet/netronome/nfp/nfp_main.c |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |  2 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |  4 +--
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |  5 ++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  4 +--
 drivers/net/ethernet/ti/cpsw_new.c            |  4 +--
 drivers/net/netdevsim/dev.c                   |  4 +--
 drivers/ptp/ptp_ocp.c                         | 26 +++----------------
 drivers/staging/qlge/qlge_main.c              |  5 ++--
 include/net/devlink.h                         | 10 ++++---
 net/core/devlink.c                            | 15 +++++------
 net/dsa/dsa2.c                                |  5 ++--
 33 files changed, 91 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 64381be935a8..2cd8bb37e641 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -743,14 +743,17 @@ static void bnxt_dl_params_unregister(struct bnxt *bp)
 
 int bnxt_dl_register(struct bnxt *bp)
 {
+	const struct devlink_ops *devlink_ops;
 	struct devlink_port_attrs attrs = {};
 	struct devlink *dl;
 	int rc;
 
 	if (BNXT_PF(bp))
-		dl = devlink_alloc(&bnxt_dl_ops, sizeof(struct bnxt_dl));
+		devlink_ops = &bnxt_dl_ops;
 	else
-		dl = devlink_alloc(&bnxt_vf_dl_ops, sizeof(struct bnxt_dl));
+		devlink_ops = &bnxt_vf_dl_ops;
+
+	dl = devlink_alloc(devlink_ops, sizeof(struct bnxt_dl), &bp->pdev->dev);
 	if (!dl) {
 		netdev_warn(bp->dev, "devlink_alloc failed\n");
 		return -ENOMEM;
@@ -763,7 +766,7 @@ int bnxt_dl_register(struct bnxt *bp)
 	    bp->hwrm_spec_code > 0x10803)
 		bp->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 
-	rc = devlink_register(dl, &bp->pdev->dev);
+	rc = devlink_register(dl);
 	if (rc) {
 		netdev_warn(bp->dev, "devlink_register failed. rc=%d\n", rc);
 		goto err_dl_free;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index af116ef83bad..2907e13b9df6 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3750,7 +3750,8 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 	}
 
 	devlink = devlink_alloc(&liquidio_devlink_ops,
-				sizeof(struct lio_devlink_priv));
+				sizeof(struct lio_devlink_priv),
+				&octeon_dev->pci_dev->dev);
 	if (!devlink) {
 		dev_err(&octeon_dev->pci_dev->dev, "devlink alloc failed\n");
 		goto setup_nic_dev_free;
@@ -3759,7 +3760,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 	lio_devlink = devlink_priv(devlink);
 	lio_devlink->oct = octeon_dev;
 
-	if (devlink_register(devlink, &octeon_dev->pci_dev->dev)) {
+	if (devlink_register(devlink)) {
 		devlink_free(devlink);
 		dev_err(&octeon_dev->pci_dev->dev,
 			"devlink registration failed\n");
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
index 8e09f65ea295..605a39f892b9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
@@ -196,7 +196,8 @@ int dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv)
 	struct dpaa2_eth_devlink_priv *dl_priv;
 	int err;
 
-	priv->devlink = devlink_alloc(&dpaa2_eth_devlink_ops, sizeof(*dl_priv));
+	priv->devlink =
+		devlink_alloc(&dpaa2_eth_devlink_ops, sizeof(*dl_priv), dev);
 	if (!priv->devlink) {
 		dev_err(dev, "devlink_alloc failed\n");
 		return -ENOMEM;
@@ -204,7 +205,7 @@ int dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv)
 	dl_priv = devlink_priv(priv->devlink);
 	dl_priv->dpaa2_priv = priv;
 
-	err = devlink_register(priv->devlink, dev);
+	err = devlink_register(priv->devlink);
 	if (err) {
 		dev_err(dev, "devlink_register() = %d\n", err);
 		goto devlink_free;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 06d29945d4e1..448f29aa4e6b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -112,14 +112,14 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	int ret;
 
 	devlink = devlink_alloc(&hclge_devlink_ops,
-				sizeof(struct hclge_devlink_priv));
+				sizeof(struct hclge_devlink_priv), &pdev->dev);
 	if (!devlink)
 		return -ENOMEM;
 
 	priv = devlink_priv(devlink);
 	priv->hdev = hdev;
 
-	ret = devlink_register(devlink, &pdev->dev);
+	ret = devlink_register(devlink);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register devlink, ret = %d\n",
 			ret);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index 21a45279fd99..1e6061fb8ed4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -112,15 +112,16 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 	struct devlink *devlink;
 	int ret;
 
-	devlink = devlink_alloc(&hclgevf_devlink_ops,
-				sizeof(struct hclgevf_devlink_priv));
+	devlink =
+		devlink_alloc(&hclgevf_devlink_ops,
+			      sizeof(struct hclgevf_devlink_priv), &pdev->dev);
 	if (!devlink)
 		return -ENOMEM;
 
 	priv = devlink_priv(devlink);
 	priv->hdev = hdev;
 
-	ret = devlink_register(devlink, &pdev->dev);
+	ret = devlink_register(devlink);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register devlink, ret = %d\n",
 			ret);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index 58d5646444b0..6e11ee339f12 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -293,9 +293,9 @@ static const struct devlink_ops hinic_devlink_ops = {
 	.flash_update = hinic_devlink_flash_update,
 };
 
-struct devlink *hinic_devlink_alloc(void)
+struct devlink *hinic_devlink_alloc(struct device *dev)
 {
-	return devlink_alloc(&hinic_devlink_ops, sizeof(struct hinic_dev));
+	return devlink_alloc(&hinic_devlink_ops, sizeof(struct hinic_dev), dev);
 }
 
 void hinic_devlink_free(struct devlink *devlink)
@@ -303,11 +303,11 @@ void hinic_devlink_free(struct devlink *devlink)
 	devlink_free(devlink);
 }
 
-int hinic_devlink_register(struct hinic_devlink_priv *priv, struct device *dev)
+int hinic_devlink_register(struct hinic_devlink_priv *priv)
 {
 	struct devlink *devlink = priv_to_devlink(priv);
 
-	return devlink_register(devlink, dev);
+	return devlink_register(devlink);
 }
 
 void hinic_devlink_unregister(struct hinic_devlink_priv *priv)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
index a090ebcfaabb..9e315011015c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
@@ -108,9 +108,9 @@ struct host_image_st {
 	u32 device_id;
 };
 
-struct devlink *hinic_devlink_alloc(void);
+struct devlink *hinic_devlink_alloc(struct device *dev);
 void hinic_devlink_free(struct devlink *devlink);
-int hinic_devlink_register(struct hinic_devlink_priv *priv, struct device *dev);
+int hinic_devlink_register(struct hinic_devlink_priv *priv);
 void hinic_devlink_unregister(struct hinic_devlink_priv *priv);
 
 int hinic_health_reporters_create(struct hinic_devlink_priv *priv);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 428108eb10d2..56b6b04e209b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -754,7 +754,7 @@ static int init_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 		return err;
 	}
 
-	err = hinic_devlink_register(hwdev->devlink_dev, &pdev->dev);
+	err = hinic_devlink_register(hwdev->devlink_dev);
 	if (err) {
 		dev_err(&hwif->pdev->dev, "Failed to register devlink\n");
 		hinic_pf_to_mgmt_free(&pfhwdev->pf_to_mgmt);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 405ee4d2d2b1..881d0b247561 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1183,7 +1183,7 @@ static int nic_dev_init(struct pci_dev *pdev)
 	struct devlink *devlink;
 	int err, num_qps;
 
-	devlink = hinic_devlink_alloc();
+	devlink = hinic_devlink_alloc(&pdev->dev);
 	if (!devlink) {
 		dev_err(&pdev->dev, "Hinic devlink alloc failed\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 91b545ab8b8f..8c863d64930b 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -475,7 +475,7 @@ struct ice_pf *ice_allocate_pf(struct device *dev)
 {
 	struct devlink *devlink;
 
-	devlink = devlink_alloc(&ice_devlink_ops, sizeof(struct ice_pf));
+	devlink = devlink_alloc(&ice_devlink_ops, sizeof(struct ice_pf), dev);
 	if (!devlink)
 		return NULL;
 
@@ -502,7 +502,7 @@ int ice_devlink_register(struct ice_pf *pf)
 	struct device *dev = ice_pf_to_dev(pf);
 	int err;
 
-	err = devlink_register(devlink, dev);
+	err = devlink_register(devlink);
 	if (err) {
 		dev_err(dev, "devlink registration failed: %d\n", err);
 		return err;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 6f963b2f54a7..a55b46ad162d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1503,13 +1503,14 @@ int rvu_register_dl(struct rvu *rvu)
 	struct devlink *dl;
 	int err;
 
-	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink));
+	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink),
+			   rvu->dev);
 	if (!dl) {
 		dev_warn(rvu->dev, "devlink_alloc failed\n");
 		return -ENOMEM;
 	}
 
-	err = devlink_register(dl, rvu->dev);
+	err = devlink_register(dl);
 	if (err) {
 		dev_err(rvu->dev, "devlink register failed with error %d\n", err);
 		devlink_free(dl);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
index fa7a0682ad1e..68b442eb6d69 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.c
@@ -390,11 +390,12 @@ static const struct devlink_ops prestera_dl_ops = {
 	.trap_drop_counter_get = prestera_drop_counter_get,
 };
 
-struct prestera_switch *prestera_devlink_alloc(void)
+struct prestera_switch *prestera_devlink_alloc(struct prestera_device *dev)
 {
 	struct devlink *dl;
 
-	dl = devlink_alloc(&prestera_dl_ops, sizeof(struct prestera_switch));
+	dl = devlink_alloc(&prestera_dl_ops, sizeof(struct prestera_switch),
+			   dev->dev);
 
 	return devlink_priv(dl);
 }
@@ -411,7 +412,7 @@ int prestera_devlink_register(struct prestera_switch *sw)
 	struct devlink *dl = priv_to_devlink(sw);
 	int err;
 
-	err = devlink_register(dl, sw->dev->dev);
+	err = devlink_register(dl);
 	if (err) {
 		dev_err(prestera_dev(sw), "devlink_register failed: %d\n", err);
 		return err;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
index 5d73aa9db897..cc34c3db13a2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_devlink.h
@@ -6,7 +6,7 @@
 
 #include "prestera.h"
 
-struct prestera_switch *prestera_devlink_alloc(void);
+struct prestera_switch *prestera_devlink_alloc(struct prestera_device *dev);
 void prestera_devlink_free(struct prestera_switch *sw);
 
 int prestera_devlink_register(struct prestera_switch *sw);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 7c569c1abefc..44c670807fb3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -905,7 +905,7 @@ int prestera_device_register(struct prestera_device *dev)
 	struct prestera_switch *sw;
 	int err;
 
-	sw = prestera_devlink_alloc();
+	sw = prestera_devlink_alloc(dev);
 	if (!sw)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 28ac4693da3c..7267c6c6d2e2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4005,7 +4005,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	printk_once(KERN_INFO "%s", mlx4_version);
 
-	devlink = devlink_alloc(&mlx4_devlink_ops, sizeof(*priv));
+	devlink = devlink_alloc(&mlx4_devlink_ops, sizeof(*priv), &pdev->dev);
 	if (!devlink)
 		return -ENOMEM;
 	priv = devlink_priv(devlink);
@@ -4024,7 +4024,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&dev->persist->interface_state_mutex);
 	mutex_init(&dev->persist->pci_status_mutex);
 
-	ret = devlink_register(devlink, &pdev->dev);
+	ret = devlink_register(devlink);
 	if (ret)
 		goto err_persist_free;
 	ret = devlink_params_register(devlink, mlx4_devlink_params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d791d351b489..f38553ff538b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -359,9 +359,10 @@ int mlx5_devlink_traps_get_action(struct mlx5_core_dev *dev, int trap_id,
 	return 0;
 }
 
-struct devlink *mlx5_devlink_alloc(void)
+struct devlink *mlx5_devlink_alloc(struct device *dev)
 {
-	return devlink_alloc(&mlx5_devlink_ops, sizeof(struct mlx5_core_dev));
+	return devlink_alloc(&mlx5_devlink_ops, sizeof(struct mlx5_core_dev),
+			     dev);
 }
 
 void mlx5_devlink_free(struct devlink *devlink)
@@ -638,11 +639,11 @@ static void mlx5_devlink_traps_unregister(struct devlink *devlink)
 				       ARRAY_SIZE(mlx5_trap_groups_arr));
 }
 
-int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
+int mlx5_devlink_register(struct devlink *devlink)
 {
 	int err;
 
-	err = devlink_register(devlink, dev);
+	err = devlink_register(devlink);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index 7318d44b774b..30bf4882779b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -31,9 +31,9 @@ int mlx5_devlink_trap_get_num_active(struct mlx5_core_dev *dev);
 int mlx5_devlink_traps_get_action(struct mlx5_core_dev *dev, int trap_id,
 				  enum devlink_trap_action *action);
 
-struct devlink *mlx5_devlink_alloc(void);
+struct devlink *mlx5_devlink_alloc(struct device *dev);
 void mlx5_devlink_free(struct devlink *devlink);
-int mlx5_devlink_register(struct devlink *devlink, struct device *dev);
+int mlx5_devlink_register(struct devlink *devlink);
 void mlx5_devlink_unregister(struct devlink *devlink);
 
 #endif /* __MLX5_DEVLINK_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index eb1b316560a8..a8efd9f1af4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1271,7 +1271,7 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 
 	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 
-	err = mlx5_devlink_register(priv_to_devlink(dev), dev->device);
+	err = mlx5_devlink_register(priv_to_devlink(dev));
 	if (err)
 		goto err_devlink_reg;
 
@@ -1452,7 +1452,7 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct devlink *devlink;
 	int err;
 
-	devlink = mlx5_devlink_alloc();
+	devlink = mlx5_devlink_alloc(&pdev->dev);
 	if (!devlink) {
 		dev_err(&pdev->dev, "devlink alloc failed\n");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 42c8ee03fe3e..052f48068dc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -14,7 +14,7 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 	struct devlink *devlink;
 	int err;
 
-	devlink = mlx5_devlink_alloc();
+	devlink = mlx5_devlink_alloc(&adev->dev);
 	if (!devlink)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e775f08fb464..f080fab3de2b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1927,7 +1927,8 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 
 	if (!reload) {
 		alloc_size = sizeof(*mlxsw_core) + mlxsw_driver->priv_size;
-		devlink = devlink_alloc(&mlxsw_devlink_ops, alloc_size);
+		devlink = devlink_alloc(&mlxsw_devlink_ops, alloc_size,
+					mlxsw_bus_info->dev);
 		if (!devlink) {
 			err = -ENOMEM;
 			goto err_devlink_alloc;
@@ -1974,7 +1975,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 		goto err_emad_init;
 
 	if (!reload) {
-		err = devlink_register(devlink, mlxsw_bus_info->dev);
+		err = devlink_register(devlink);
 		if (err)
 			goto err_devlink_register;
 	}
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4bd7e9d9ec61..aa41c9cde643 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1103,7 +1103,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (!np && !pdev->dev.platform_data)
 		return -ENODEV;
 
-	devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*ocelot));
+	devlink =
+		devlink_alloc(&ocelot_devlink_ops, sizeof(*ocelot), &pdev->dev);
 	if (!devlink)
 		return -ENOMEM;
 
@@ -1187,7 +1188,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	if (err)
 		goto out_put_ports;
 
-	err = devlink_register(devlink, ocelot->dev);
+	err = devlink_register(devlink);
 	if (err)
 		goto out_ocelot_deinit;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 742a420152b3..bb3b8a7f6c5d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -692,7 +692,7 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 		goto err_pci_disable;
 	}
 
-	devlink = devlink_alloc(&nfp_devlink_ops, sizeof(*pf));
+	devlink = devlink_alloc(&nfp_devlink_ops, sizeof(*pf), &pdev->dev);
 	if (!devlink) {
 		err = -ENOMEM;
 		goto err_rel_regions;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 921db40047d7..d10a93801344 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -701,7 +701,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	if (err)
 		goto err_unmap;
 
-	err = devlink_register(devlink, &pf->pdev->dev);
+	err = devlink_register(devlink);
 	if (err)
 		goto err_app_clean;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index cd520e4c5522..c7d0e195d176 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -64,7 +64,7 @@ struct ionic *ionic_devlink_alloc(struct device *dev)
 {
 	struct devlink *dl;
 
-	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic));
+	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic), dev);
 
 	return devlink_priv(dl);
 }
@@ -82,7 +82,7 @@ int ionic_devlink_register(struct ionic *ionic)
 	struct devlink_port_attrs attrs = {};
 	int err;
 
-	err = devlink_register(dl, ionic->dev);
+	err = devlink_register(dl);
 	if (err) {
 		dev_warn(ionic->dev, "devlink_register failed: %d\n", err);
 		return err;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index cf7f4da68e69..4c7501b9c284 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -207,14 +207,15 @@ struct devlink *qed_devlink_register(struct qed_dev *cdev)
 	struct devlink *dl;
 	int rc;
 
-	dl = devlink_alloc(&qed_dl_ops, sizeof(struct qed_devlink));
+	dl = devlink_alloc(&qed_dl_ops, sizeof(struct qed_devlink),
+			   &cdev->pdev->dev);
 	if (!dl)
 		return ERR_PTR(-ENOMEM);
 
 	qdevlink = devlink_priv(dl);
 	qdevlink->cdev = cdev;
 
-	rc = devlink_register(dl, &cdev->pdev->dev);
+	rc = devlink_register(dl);
 	if (rc)
 		goto err_free;
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 588e7df0b1cc..130346f74ee8 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2422,14 +2422,14 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 	int i;
 
 	common->devlink =
-		devlink_alloc(&am65_cpsw_devlink_ops, sizeof(*dl_priv));
+		devlink_alloc(&am65_cpsw_devlink_ops, sizeof(*dl_priv), dev);
 	if (!common->devlink)
 		return -ENOMEM;
 
 	dl_priv = devlink_priv(common->devlink);
 	dl_priv->common = common;
 
-	ret = devlink_register(common->devlink, dev);
+	ret = devlink_register(common->devlink);
 	if (ret) {
 		dev_err(dev, "devlink reg fail ret:%d\n", ret);
 		goto dl_free;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index ae167223e87f..192394fe4c1c 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1800,14 +1800,14 @@ static int cpsw_register_devlink(struct cpsw_common *cpsw)
 	struct cpsw_devlink *dl_priv;
 	int ret = 0;
 
-	cpsw->devlink = devlink_alloc(&cpsw_devlink_ops, sizeof(*dl_priv));
+	cpsw->devlink = devlink_alloc(&cpsw_devlink_ops, sizeof(*dl_priv), dev);
 	if (!cpsw->devlink)
 		return -ENOMEM;
 
 	dl_priv = devlink_priv(cpsw->devlink);
 	dl_priv->cpsw = cpsw;
 
-	ret = devlink_register(cpsw->devlink, dev);
+	ret = devlink_register(cpsw->devlink);
 	if (ret) {
 		dev_err(dev, "DL reg fail ret:%d\n", ret);
 		goto dl_free;
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 53068e184c90..54313bd57797 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1449,7 +1449,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	int err;
 
 	devlink = devlink_alloc_ns(&nsim_dev_devlink_ops, sizeof(*nsim_dev),
-				   nsim_bus_dev->initial_net);
+				 nsim_bus_dev->initial_net, &nsim_bus_dev->dev);
 	if (!devlink)
 		return -ENOMEM;
 	nsim_dev = devlink_priv(devlink);
@@ -1470,7 +1470,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_devlink_free;
 
-	err = devlink_register(devlink, &nsim_bus_dev->dev);
+	err = devlink_register(devlink);
 	if (err)
 		goto err_resources_unregister;
 
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 6b9c14586987..92edf772feed 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -735,24 +735,6 @@ ptp_ocp_info(struct ptp_ocp *bp)
 	ptp_ocp_tod_info(bp);
 }
 
-static int
-ptp_ocp_devlink_register(struct devlink *devlink, struct device *dev)
-{
-	int err;
-
-	err = devlink_register(devlink, dev);
-	if (err)
-		return err;
-
-	return 0;
-}
-
-static void
-ptp_ocp_devlink_unregister(struct devlink *devlink)
-{
-	devlink_unregister(devlink);
-}
-
 static struct device *
 ptp_ocp_find_flash(struct ptp_ocp *bp)
 {
@@ -1437,13 +1419,13 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct ptp_ocp *bp;
 	int err;
 
-	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp));
+	devlink = devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp), &pdev->dev);
 	if (!devlink) {
 		dev_err(&pdev->dev, "devlink_alloc failed\n");
 		return -ENOMEM;
 	}
 
-	err = ptp_ocp_devlink_register(devlink, &pdev->dev);
+	err = devlink_register(devlink);
 	if (err)
 		goto out_free;
 
@@ -1497,7 +1479,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 out_unregister:
-	ptp_ocp_devlink_unregister(devlink);
+	devlink_unregister(devlink);
 out_free:
 	devlink_free(devlink);
 
@@ -1514,7 +1496,7 @@ ptp_ocp_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 
-	ptp_ocp_devlink_unregister(devlink);
+	devlink_unregister(devlink);
 	devlink_free(devlink);
 }
 
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 19a02e958865..8fcdf89da8aa 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4547,7 +4547,8 @@ static int qlge_probe(struct pci_dev *pdev,
 	static int cards_found;
 	int err;
 
-	devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_adapter));
+	devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_adapter),
+				&pdev->dev);
 	if (!devlink)
 		return -ENOMEM;
 
@@ -4613,7 +4614,7 @@ static int qlge_probe(struct pci_dev *pdev,
 		goto netdev_free;
 	}
 
-	err = devlink_register(devlink, &pdev->dev);
+	err = devlink_register(devlink);
 	if (err)
 		goto netdev_free;
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ccbfb3a844aa..0236c77f2fd0 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1544,13 +1544,15 @@ struct net *devlink_net(const struct devlink *devlink);
  * Drivers that operate on real HW must use devlink_alloc() instead.
  */
 struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
-				 size_t priv_size, struct net *net);
+				 size_t priv_size, struct net *net,
+				 struct device *dev);
 static inline struct devlink *devlink_alloc(const struct devlink_ops *ops,
-					    size_t priv_size)
+					    size_t priv_size,
+					    struct device *dev)
 {
-	return devlink_alloc_ns(ops, priv_size, &init_net);
+	return devlink_alloc_ns(ops, priv_size, &init_net, dev);
 }
-int devlink_register(struct devlink *devlink, struct device *dev);
+int devlink_register(struct devlink *devlink);
 void devlink_unregister(struct devlink *devlink);
 void devlink_reload_enable(struct devlink *devlink);
 void devlink_reload_disable(struct devlink *devlink);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee95eee8d0ed..d3b16dd9f64e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8768,24 +8768,26 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
  *	@ops: ops
  *	@priv_size: size of user private data
  *	@net: net namespace
+ *	@dev: parent device
  *
  *	Allocate new devlink instance resources, including devlink index
  *	and name.
  */
 struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
-				 size_t priv_size, struct net *net)
+				 size_t priv_size, struct net *net,
+				 struct device *dev)
 {
 	struct devlink *devlink;
 
-	if (WARN_ON(!ops))
-		return NULL;
-
+	WARN_ON(!ops || !dev);
 	if (!devlink_reload_actions_valid(ops))
 		return NULL;
 
 	devlink = kzalloc(sizeof(*devlink) + priv_size, GFP_KERNEL);
 	if (!devlink)
 		return NULL;
+
+	devlink->dev = dev;
 	devlink->ops = ops;
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	write_pnet(&devlink->_net, net);
@@ -8810,12 +8812,9 @@ EXPORT_SYMBOL_GPL(devlink_alloc_ns);
  *	devlink_register - Register devlink instance
  *
  *	@devlink: devlink
- *	@dev: parent device
  */
-int devlink_register(struct devlink *devlink, struct device *dev)
+int devlink_register(struct devlink *devlink)
 {
-	WARN_ON(devlink->dev);
-	devlink->dev = dev;
 	mutex_lock(&devlink_mutex);
 	list_add_tail(&devlink->list, &devlink_list);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index a4c525f1cb17..8150e16aaa55 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -746,13 +746,14 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	/* Add the switch to devlink before calling setup, so that setup can
 	 * add dpipe tables
 	 */
-	ds->devlink = devlink_alloc(&dsa_devlink_ops, sizeof(*dl_priv));
+	ds->devlink =
+		devlink_alloc(&dsa_devlink_ops, sizeof(*dl_priv), ds->dev);
 	if (!ds->devlink)
 		return -ENOMEM;
 	dl_priv = devlink_priv(ds->devlink);
 	dl_priv->ds = ds;
 
-	err = devlink_register(ds->devlink, ds->dev);
+	err = devlink_register(ds->devlink);
 	if (err)
 		goto free_devlink;
 
-- 
2.31.1

