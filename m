Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14DF396DFA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhFAHfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:35:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2814 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbhFAHfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 03:35:24 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvP0r0wXfzWnXX;
        Tue,  1 Jun 2021 15:29:00 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 15:33:40 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <jdmason@kudzu.us>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: vxge: Declare the function vxge_reset_all_vpaths as void
Date:   Tue, 1 Jun 2021 15:47:19 +0800
Message-ID: <20210601074719.4079093-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

variable 'status' is unneeded and it's noneed to check the
return value of function vxge_reset_all_vpaths,so declare
it as void.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 .../net/ethernet/neterion/vxge/vxge-main.c    | 26 +++++--------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 87892bd992b1..21bc4d6662e4 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -87,7 +87,7 @@ static unsigned int bw_percentage[VXGE_HW_MAX_VIRTUAL_PATHS] =
 module_param_array(bw_percentage, uint, NULL, 0);
 
 static struct vxge_drv_config *driver_config;
-static enum vxge_hw_status vxge_reset_all_vpaths(struct vxgedev *vdev);
+static void vxge_reset_all_vpaths(struct vxgedev *vdev);
 
 static inline int is_vxge_card_up(struct vxgedev *vdev)
 {
@@ -1709,14 +1709,7 @@ static int do_vxge_reset(struct vxgedev *vdev, int event)
 		netif_tx_stop_all_queues(vdev->ndev);
 
 	if (event == VXGE_LL_FULL_RESET) {
-		status = vxge_reset_all_vpaths(vdev);
-		if (status != VXGE_HW_OK) {
-			vxge_debug_init(VXGE_ERR,
-				"fatal: %s: can not reset vpaths",
-				vdev->ndev->name);
-			ret = -EPERM;
-			goto out;
-		}
+		vxge_reset_all_vpaths(vdev);
 	}
 
 	if (event == VXGE_LL_COMPL_RESET) {
@@ -1969,9 +1962,8 @@ static enum vxge_hw_status vxge_rth_configure(struct vxgedev *vdev)
 }
 
 /* reset vpaths */
-static enum vxge_hw_status vxge_reset_all_vpaths(struct vxgedev *vdev)
+static void vxge_reset_all_vpaths(struct vxgedev *vdev)
 {
-	enum vxge_hw_status status = VXGE_HW_OK;
 	struct vxge_vpath *vpath;
 	int i;
 
@@ -1986,18 +1978,16 @@ static enum vxge_hw_status vxge_reset_all_vpaths(struct vxgedev *vdev)
 						"vxge_hw_vpath_recover_"
 						"from_reset failed for vpath: "
 						"%d", i);
-					return status;
+					return;
 				}
 			} else {
 				vxge_debug_init(VXGE_ERR,
 					"vxge_hw_vpath_reset failed for "
 					"vpath:%d", i);
-				return status;
+				return;
 			}
 		}
 	}
-
-	return status;
 }
 
 /* close vpaths */
@@ -2676,11 +2666,7 @@ static int vxge_set_features(struct net_device *dev, netdev_features_t features)
 	/* !netif_running() ensured by vxge_fix_features() */
 
 	vdev->devh->config.rth_en = !!(features & NETIF_F_RXHASH);
-	if (vxge_reset_all_vpaths(vdev) != VXGE_HW_OK) {
-		dev->features = features ^ NETIF_F_RXHASH;
-		vdev->devh->config.rth_en = !!(dev->features & NETIF_F_RXHASH);
-		return -EIO;
-	}
+	vxge_reset_all_vpaths(vdev);
 
 	return 0;
 }
-- 
2.25.1

