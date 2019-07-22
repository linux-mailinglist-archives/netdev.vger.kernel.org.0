Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBE702F8
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 17:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfGVPCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 11:02:17 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:33839 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbfGVPCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 11:02:16 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N62mG-1iVD5437Oa-016OS8; Mon, 22 Jul 2019 17:02:06 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Erez Alfasi <ereza@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Eli Cohen <eli@mellanox.co.il>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH net-next] [net-next] mlx4: avoid large stack usage in mlx4_init_hca()
Date:   Mon, 22 Jul 2019 17:01:55 +0200
Message-Id: <20190722150204.1157315-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6RlucjjmypJnt310jjgPEHPw68PZk7JE9z3FBrybaR+ep+3Cv2d
 TBKM7TP/YWkndjanU7YKLhR2TifdwV0foLbZ5UlTUO+hGYkMRh+C93ObXysjdI7QxSFPI2F
 pBJrTNZ7/Gm0SQFN5C4zfqhGJPUwg3M/RMwcAzAxb+UmuOcoA/EYDqk03djOZqCCEVHSmpX
 GFmCeJX+SdJ6/lH09y44g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QNMfdsxYVMU=:W+Eq/wKucjnDuLN9OlFSmC
 Cr6G9LVL6ma0mHIDCeKMSLOmtyhEJvZ0TLZ5vNuRgB/KwlCwWcxqNqEIGD1qgUSEv5xwWBD7Q
 kHRZmP3nZ/1zHDI2rHudA88kOuwoIJ6oGMsvhQf2mNZV4kimzFVvhGYhWyNVLL6hVGlduO/0b
 CFBl3ptJbN1h1ya5W3sLhi5O4Hhss0c5KUg/tETZRsET9SOCb54epamEHnIQT+Z7O2OdcN/Lb
 vbXZwqMLV7z8Z01+9Y17FSHs5fVr28upA4miQF+m7ccD+SQ3nIoX5DHusi1KyHsYL3Rvyk8ic
 gJSOppGWRwYjA96l3myhSAmRLhoUCjTY+vMzlA1yPtnYXwFJNiRmZxs0JXf8CmtVtM6vl0OjE
 g7vHpW/rfGWiayZXD9/YWIPgsr2Wtl72OrAtHrAGqeTctQIGYVlVSo/VB4hmzqjpPqoA/zyD+
 W4GdznEkaIYju5TeydC+hoDMzE277BoGkBZhKv08N3P/FN7VgfQFRQL8IX8fMQlRh92pC/C24
 QHhOx2uJFSvNLaLT1qBUlPs8xA3J9PideNF9lVbtCqqx+VAfzetGgirzxuEVcF+IQ6E3x2k5/
 C3AbsZT3jHSdFWLITSwbUO93WZbMtWhjUxKO4tPMtNqi1U2nbruv9l2azJDUA80xwGVMMqZ20
 mzfJDMvJd8UBG22Wp/htbIEzdtML913YzLPaOQVYk1F+A93zmLU1d/E35GI9xgZpriP1Tcfd6
 tQPwnb95MmkRSje2xZwCoujHY5E8Zem2gNcKOw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx4_dev_cap and mlx4_init_hca_param are really too large
to be put on the kernel stack, as shown by this clang warning:

drivers/net/ethernet/mellanox/mlx4/main.c:3304:12: error: stack frame size of 1088 bytes in function 'mlx4_load_one' [-Werror,-Wframe-larger-than=]

With gcc, the problem is the same, but it does not warn because
it does not inline this function, and therefore stays just below
the warning limit, while clang is just above it.

Use kzalloc for dynamic allocation instead of putting them
on stack. This gets the combined stack frame down to 424 bytes.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 66 +++++++++++++----------
 1 file changed, 39 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 1f6e16d5ea6b..07c204bd3fc4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2292,23 +2292,31 @@ static int mlx4_init_fw(struct mlx4_dev *dev)
 static int mlx4_init_hca(struct mlx4_dev *dev)
 {
 	struct mlx4_priv	  *priv = mlx4_priv(dev);
+	struct mlx4_init_hca_param *init_hca = NULL;
+	struct mlx4_dev_cap	  *dev_cap = NULL;
 	struct mlx4_adapter	   adapter;
-	struct mlx4_dev_cap	   dev_cap;
 	struct mlx4_profile	   profile;
-	struct mlx4_init_hca_param init_hca;
 	u64 icm_size;
 	struct mlx4_config_dev_params params;
 	int err;
 
 	if (!mlx4_is_slave(dev)) {
-		err = mlx4_dev_cap(dev, &dev_cap);
+		dev_cap = kzalloc(sizeof(*dev_cap), GFP_KERNEL);
+		init_hca = kzalloc(sizeof(*init_hca), GFP_KERNEL);
+
+		if (!dev_cap || !init_hca) {
+			err = -ENOMEM;
+			goto out_free;
+		}
+
+		err = mlx4_dev_cap(dev, dev_cap);
 		if (err) {
 			mlx4_err(dev, "QUERY_DEV_CAP command failed, aborting\n");
-			return err;
+			goto out_free;
 		}
 
-		choose_steering_mode(dev, &dev_cap);
-		choose_tunnel_offload_mode(dev, &dev_cap);
+		choose_steering_mode(dev, dev_cap);
+		choose_tunnel_offload_mode(dev, dev_cap);
 
 		if (dev->caps.dmfs_high_steer_mode == MLX4_STEERING_DMFS_A0_STATIC &&
 		    mlx4_is_master(dev))
@@ -2331,48 +2339,48 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 		    MLX4_STEERING_MODE_DEVICE_MANAGED)
 			profile.num_mcg = MLX4_FS_NUM_MCG;
 
-		icm_size = mlx4_make_profile(dev, &profile, &dev_cap,
-					     &init_hca);
+		icm_size = mlx4_make_profile(dev, &profile, dev_cap,
+					     init_hca);
 		if ((long long) icm_size < 0) {
 			err = icm_size;
-			return err;
+			goto out_free;
 		}
 
 		dev->caps.max_fmr_maps = (1 << (32 - ilog2(dev->caps.num_mpts))) - 1;
 
 		if (enable_4k_uar || !dev->persist->num_vfs) {
-			init_hca.log_uar_sz = ilog2(dev->caps.num_uars) +
+			init_hca->log_uar_sz = ilog2(dev->caps.num_uars) +
 						    PAGE_SHIFT - DEFAULT_UAR_PAGE_SHIFT;
-			init_hca.uar_page_sz = DEFAULT_UAR_PAGE_SHIFT - 12;
+			init_hca->uar_page_sz = DEFAULT_UAR_PAGE_SHIFT - 12;
 		} else {
-			init_hca.log_uar_sz = ilog2(dev->caps.num_uars);
-			init_hca.uar_page_sz = PAGE_SHIFT - 12;
+			init_hca->log_uar_sz = ilog2(dev->caps.num_uars);
+			init_hca->uar_page_sz = PAGE_SHIFT - 12;
 		}
 
-		init_hca.mw_enabled = 0;
+		init_hca->mw_enabled = 0;
 		if (dev->caps.flags & MLX4_DEV_CAP_FLAG_MEM_WINDOW ||
 		    dev->caps.bmme_flags & MLX4_BMME_FLAG_TYPE_2_WIN)
-			init_hca.mw_enabled = INIT_HCA_TPT_MW_ENABLE;
+			init_hca->mw_enabled = INIT_HCA_TPT_MW_ENABLE;
 
-		err = mlx4_init_icm(dev, &dev_cap, &init_hca, icm_size);
+		err = mlx4_init_icm(dev, dev_cap, init_hca, icm_size);
 		if (err)
-			return err;
+			goto out_free;
 
-		err = mlx4_INIT_HCA(dev, &init_hca);
+		err = mlx4_INIT_HCA(dev, init_hca);
 		if (err) {
 			mlx4_err(dev, "INIT_HCA command failed, aborting\n");
 			goto err_free_icm;
 		}
 
-		if (dev_cap.flags2 & MLX4_DEV_CAP_FLAG2_SYS_EQS) {
-			err = mlx4_query_func(dev, &dev_cap);
+		if (dev_cap->flags2 & MLX4_DEV_CAP_FLAG2_SYS_EQS) {
+			err = mlx4_query_func(dev, dev_cap);
 			if (err < 0) {
 				mlx4_err(dev, "QUERY_FUNC command failed, aborting.\n");
 				goto err_close;
 			} else if (err & MLX4_QUERY_FUNC_NUM_SYS_EQS) {
-				dev->caps.num_eqs = dev_cap.max_eqs;
-				dev->caps.reserved_eqs = dev_cap.reserved_eqs;
-				dev->caps.reserved_uars = dev_cap.reserved_uars;
+				dev->caps.num_eqs = dev_cap->max_eqs;
+				dev->caps.reserved_eqs = dev_cap->reserved_eqs;
+				dev->caps.reserved_uars = dev_cap->reserved_uars;
 			}
 		}
 
@@ -2381,14 +2389,13 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 		 * read HCA frequency by QUERY_HCA command
 		 */
 		if (dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_TS) {
-			memset(&init_hca, 0, sizeof(init_hca));
-			err = mlx4_QUERY_HCA(dev, &init_hca);
+			err = mlx4_QUERY_HCA(dev, init_hca);
 			if (err) {
 				mlx4_err(dev, "QUERY_HCA command failed, disable timestamp\n");
 				dev->caps.flags2 &= ~MLX4_DEV_CAP_FLAG2_TS;
 			} else {
 				dev->caps.hca_core_clock =
-					init_hca.hca_core_clock;
+					init_hca->hca_core_clock;
 			}
 
 			/* In case we got HCA frequency 0 - disable timestamping
@@ -2464,7 +2471,8 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 	priv->eq_table.inta_pin = adapter.inta_pin;
 	memcpy(dev->board_id, adapter.board_id, sizeof(dev->board_id));
 
-	return 0;
+	err = 0;
+	goto out_free;
 
 unmap_bf:
 	unmap_internal_clock(dev);
@@ -2483,6 +2491,10 @@ static int mlx4_init_hca(struct mlx4_dev *dev)
 	if (!mlx4_is_slave(dev))
 		mlx4_free_icms(dev);
 
+out_free:
+	kfree(dev_cap);
+	kfree(init_hca);
+
 	return err;
 }
 
-- 
2.20.0

