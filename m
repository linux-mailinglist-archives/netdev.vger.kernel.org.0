Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F00A396E8F
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhFAILM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:11:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2927 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhFAILJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:11:09 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvPr60rRtz68Yw;
        Tue,  1 Jun 2021 16:06:30 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 16:09:25 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <jdmason@kudzu.us>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 net-next] net: vxge: Declare the function vxge_reset_all_vpaths as void
Date:   Tue, 1 Jun 2021 16:23:04 +0800
Message-ID: <20210601082304.4093866-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 .../net/ethernet/neterion/vxge/vxge-main.c    | 27 +++++--------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 87892bd992b1..297bce5f635f 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -87,7 +87,7 @@ static unsigned int bw_percentage[VXGE_HW_MAX_VIRTUAL_PATHS] =
 module_param_array(bw_percentage, uint, NULL, 0);
 
 static struct vxge_drv_config *driver_config;
-static enum vxge_hw_status vxge_reset_all_vpaths(struct vxgedev *vdev);
+static void vxge_reset_all_vpaths(struct vxgedev *vdev);
 
 static inline int is_vxge_card_up(struct vxgedev *vdev)
 {
@@ -1606,7 +1606,6 @@ static void vxge_config_ci_for_tti_rti(struct vxgedev *vdev)
 
 static int do_vxge_reset(struct vxgedev *vdev, int event)
 {
-	enum vxge_hw_status status;
 	int ret = 0, vp_id, i;
 
 	vxge_debug_entryexit(VXGE_TRACE, "%s:%d", __func__, __LINE__);
@@ -1709,14 +1708,7 @@ static int do_vxge_reset(struct vxgedev *vdev, int event)
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
@@ -1969,9 +1961,8 @@ static enum vxge_hw_status vxge_rth_configure(struct vxgedev *vdev)
 }
 
 /* reset vpaths */
-static enum vxge_hw_status vxge_reset_all_vpaths(struct vxgedev *vdev)
+static void vxge_reset_all_vpaths(struct vxgedev *vdev)
 {
-	enum vxge_hw_status status = VXGE_HW_OK;
 	struct vxge_vpath *vpath;
 	int i;
 
@@ -1986,18 +1977,16 @@ static enum vxge_hw_status vxge_reset_all_vpaths(struct vxgedev *vdev)
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
@@ -2676,11 +2665,7 @@ static int vxge_set_features(struct net_device *dev, netdev_features_t features)
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

