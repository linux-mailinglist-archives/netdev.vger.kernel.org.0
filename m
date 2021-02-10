Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DAB3172B5
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhBJVvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:51:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37330 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbhBJVuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:50:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ALhoDj097415;
        Wed, 10 Feb 2021 21:49:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=W8qxF4ivMJ5uxDC1sN10rOApRZe5xw4lh7TifLkmdb4=;
 b=NiZi0j1A3abC5X/0Q8WdtPgONRGaP/PSWg8nN0+vrwDzar1h0kBIzoKKe0N8vhwC+NwO
 TPDQaB3CuqY74S5oaYKr9Hola/lVKq55koxCEZERCp6n/Mtzc/6WvZhSw7hDeM0eLKxG
 NjBNxrO/w3cRbJY9/0PW26Tw2XMWzE4wCDCQWUdwGDmZCSmpA+oXRk+dCrsE5ecAMU1C
 a80HCf27J1+7cCYXnfWwTz9QnYYwEFLmTShviObyi8EZFOyuGcToWOlKkywcrh1hTT5U
 d8wn+NM3GZbE5UfN0UJx7s5LpzzZT8JS97pr18RTPdBvM2Frn5k+oZkTK2h5WYhqxkbm rA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36hkrn56bp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 21:49:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ALjxev103948;
        Wed, 10 Feb 2021 21:49:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 36j4pqpxrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 21:49:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 11ALnj4c016906;
        Wed, 10 Feb 2021 21:49:45 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Wed, 10 Feb 2021 13:48:43 -0800
MIME-Version: 1.0
Message-ID: <1612993680-29454-2-git-send-email-si-wei.liu@oracle.com>
Date:   Wed, 10 Feb 2021 13:47:58 -0800 (PST)
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: [PATCH v2 1/3] vdpa/mlx5: should exclude header length and fcs from
 mtu
References: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
In-Reply-To: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

When feature VIRTIO_NET_F_MTU is negotiated on mlx5_vdpa,
22 extra bytes worth of MTU length is shown in guest.
This is because the mlx5_query_port_max_mtu API returns
the "hardware" MTU value, which does not just contain the
 Ethernet payload, but includes extra lengths starting
from the Ethernet header up to the FCS altogether.

Fix the MTU so packets won't get dropped silently.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eli Cohen <elic@nvidia.com>
---
 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 15 ++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 08f742f..b6cc53b 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -4,9 +4,13 @@
 #ifndef __MLX5_VDPA_H__
 #define __MLX5_VDPA_H__
 
+#include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/vdpa.h>
 #include <linux/mlx5/driver.h>
 
+#define MLX5V_ETH_HARD_MTU (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN)
+
 struct mlx5_vdpa_direct_mr {
 	u64 start;
 	u64 end;
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index dc88559..b8416c4 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1907,6 +1907,19 @@ static int mlx5_get_vq_irq(struct vdpa_device *vdv, u16 idx)
 	.free = mlx5_vdpa_free,
 };
 
+static int query_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
+{
+	u16 hw_mtu;
+	int err;
+
+	err = mlx5_query_nic_vport_mtu(mdev, &hw_mtu);
+	if (err)
+		return err;
+
+	*mtu = hw_mtu - MLX5V_ETH_HARD_MTU;
+	return 0;
+}
+
 static int alloc_resources(struct mlx5_vdpa_net *ndev)
 {
 	struct mlx5_vdpa_net_resources *res = &ndev->res;
@@ -1992,7 +2005,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
 	init_mvqs(ndev);
 	mutex_init(&ndev->reslock);
 	config = &ndev->config;
-	err = mlx5_query_nic_vport_mtu(mdev, &ndev->mtu);
+	err = query_mtu(mdev, &ndev->mtu);
 	if (err)
 		goto err_mtu;
 
-- 
1.8.3.1

