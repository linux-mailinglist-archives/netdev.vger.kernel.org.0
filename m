Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9F31F8B1
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 12:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhBSL4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 06:56:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhBSL4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 06:56:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JBt3fg150949;
        Fri, 19 Feb 2021 11:55:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=Y7tWXDWYYFR8Goj5RqfddTZC74cyNyev2Htnfv1H/PY=;
 b=0g8IYVYtvGxxgN78prXyP73bNWJvWYX+eBmIu3AWwVTSu3PAbifwMdrNc7CyQV15tIUu
 dEVpeAFPY3Uc6Hy1cJIvZSPnbpGpCMO4mGbVVRR3nlxYZAlcUnkjqBEGiAjoilc2stsM
 /m325wYL9CPMggAEtMBHgWok/FFoQC++dGDRL4JB1oO1N4mDlErM6OsUVei3T1wG/xMa
 s6PnqOl5hGUTdHRMRzUopNtBncbRP/hPcwMv8I4MHen0LmBYwkNUm3AXAiwlOTjfPnPQ
 X4U6tYarFrsbLik0w4UdyU8pGt1akwuCXmnokCqHR5ySBbKkVAMvJRVDb+kxlKR0owOM 0g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36p66r98vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 11:55:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JBoL47016403;
        Fri, 19 Feb 2021 11:55:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 36prp2ttd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 11:55:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 11JBtndr011179;
        Fri, 19 Feb 2021 11:55:49 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Feb 2021 03:55:49 -0800
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Date:   Fri, 19 Feb 2021 06:54:58 -0500
Message-Id: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190096
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9899 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102190097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
for legacy") made an exception for legacy guests to reset
features to 0, when config space is accessed before features
are set. We should relieve the verify_min_features() check
and allow features reset to 0 for this case.

It's worth noting that not just legacy guests could access
config space before features are set. For instance, when
feature VIRTIO_NET_F_MTU is advertised some modern driver
will try to access and validate the MTU present in the config
space before virtio features are set. Rejecting reset to 0
prematurely causes correct MTU and link status unable to load
for the very first config space access, rendering issues like
guest showing inaccurate MTU value, or failure to reject
out-of-range MTU.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 7c1f789..540dd67 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
 	return mvdev->mlx_features;
 }
 
-static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
-{
-	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
-		return -EOPNOTSUPP;
-
-	return 0;
-}
-
 static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
 {
 	int err;
@@ -1558,18 +1550,13 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
-	int err;
 
 	print_features(mvdev, features, true);
 
-	err = verify_min_features(mvdev, features);
-	if (err)
-		return err;
-
 	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
 	ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
 	ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
-	return err;
+	return 0;
 }
 
 static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callback *cb)
-- 
1.8.3.1

