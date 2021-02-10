Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423CD3172B0
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhBJVuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:50:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37284 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhBJVud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:50:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ALhnDX097103;
        Wed, 10 Feb 2021 21:49:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=83WqnSnikDCkcTpxqBjjWCmEupWNL0G22UOpLZMlrRI=;
 b=X0leY4Eg+izsFYsdVwLJOWNl2hCPK/O3i7IqjTcOY7IS72D2FSYMsTn2YsOZr2JpONL4
 dCfbi0xJNEGV4ttXbdcoDBoUfCZrZCqxoc5wSbjPQW45jNeQF2aytw75kwqauPToo7T5
 EOG2IcbodOyQB8j8lr/eZfEhI+RvBSxBkk9mBzopJnjPSlgNXLzCfFccGb2MkKJWClKO
 MhijraipMG2TNip+fIqRGx9aLFst5TTh0ZmHnv1g8R39QBdV0nMiGqcsPNmN5la3sQVq
 elW2hmYQDrM7kFNhTcs9VUePHVyW2U4+8fv7wJYw1Qs7++d5maaUqbyd3SQelncdGzXh ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36hkrn56bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 21:49:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ALij9Z159426;
        Wed, 10 Feb 2021 21:49:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 36j4vtcj18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 21:49:46 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11ALnjvp002822;
        Wed, 10 Feb 2021 21:49:45 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Wed, 10 Feb 2021 13:48:43 -0800
MIME-Version: 1.0
Message-ID: <1612993680-29454-3-git-send-email-si-wei.liu@oracle.com>
Date:   Wed, 10 Feb 2021 13:47:59 -0800 (PST)
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: [PATCH v2 2/3] vdpa/mlx5: fix feature negotiation across device reset
References: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
In-Reply-To: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100189
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100189
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx_features denotes the capability for which
set of virtio features is supported by device. In
principle, this field needs not be cleared during
virtio device reset, as this capability is static
and does not change across reset.

In fact, the current code may have the assumption
that mlx_features can be reloaded from firmware
via the .get_features ops after device is reset
(via the .set_status ops), which is unfortunately
not true. The userspace VMM might save a copy
of backend capable features and won't call into
kernel again to get it on reset. This causes all
virtio features getting disabled on newly created
virtqs after device reset, while guest would hold
mismatched view of available features. For e.g.,
the guest may still assume tx checksum offload
is available after reset and feature negotiation,
causing frames with bogus (incomplete) checksum
transmitted on the wire.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index b8416c4..7c1f789 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1486,16 +1486,8 @@ static u64 mlx_to_vritio_features(u16 dev_features)
 static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
-	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
-	u16 dev_features;
 
-	dev_features = MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, device_features_bits_mask);
-	ndev->mvdev.mlx_features = mlx_to_vritio_features(dev_features);
-	if (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, virtio_version_1_0))
-		ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_F_VERSION_1);
-	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_F_ACCESS_PLATFORM);
-	print_features(mvdev, ndev->mvdev.mlx_features, false);
-	return ndev->mvdev.mlx_features;
+	return mvdev->mlx_features;
 }
 
 static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
@@ -1788,7 +1780,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 		clear_virtqueues(ndev);
 		mlx5_vdpa_destroy_mr(&ndev->mvdev);
 		ndev->mvdev.status = 0;
-		ndev->mvdev.mlx_features = 0;
 		++mvdev->generation;
 		return;
 	}
@@ -1907,6 +1898,19 @@ static int mlx5_get_vq_irq(struct vdpa_device *vdv, u16 idx)
 	.free = mlx5_vdpa_free,
 };
 
+static void query_virtio_features(struct mlx5_vdpa_net *ndev)
+{
+	struct mlx5_vdpa_dev *mvdev = &ndev->mvdev;
+	u16 dev_features;
+
+	dev_features = MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, device_features_bits_mask);
+	mvdev->mlx_features = mlx_to_vritio_features(dev_features);
+	if (MLX5_CAP_DEV_VDPA_EMULATION(mvdev->mdev, virtio_version_1_0))
+		mvdev->mlx_features |= BIT_ULL(VIRTIO_F_VERSION_1);
+	mvdev->mlx_features |= BIT_ULL(VIRTIO_F_ACCESS_PLATFORM);
+	print_features(mvdev, mvdev->mlx_features, false);
+}
+
 static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
 {
 	u16 hw_mtu;
@@ -2005,6 +2009,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	init_mvqs(ndev);
 	mutex_init(&ndev->reslock);
 	config = &ndev->config;
+	query_virtio_features(ndev);
 	err = query_mtu(mdev, &ndev->mtu);
 	if (err)
 		goto err_mtu;
-- 
1.8.3.1

