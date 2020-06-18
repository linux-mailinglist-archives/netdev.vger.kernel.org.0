Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB12D1FF8C8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731901AbgFRQJx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:09:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729080AbgFRQJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:51 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG9jMv029920
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:50 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31q644n0w3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:50 -0700
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:45 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 422063D44E13C; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 07/21] mlx5: remove the umem parameter from mlx5e_open_channel
Date:   Thu, 18 Jun 2020 09:09:27 -0700
Message-ID: <20200618160941.879717-8-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 clxscore=1034 bulkscore=0
 cotscore=-2147483648 suspectscore=1 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of obtaining the umem parameter from the channel parameters
and passing it to the function, push this down into the function itself.

Move xsk open logic into its own function, in preparation for the
upcoming netgpu commit.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 35 +++++++++++++------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cc8d30aa8a33..01d234369df6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1935,15 +1935,33 @@ static u8 mlx5e_enumerate_lag_port(struct mlx5_core_dev *mdev, int ix)
 	return (ix + port_aff_bias) % mlx5e_get_num_lag_ports(mdev);
 }
 
+static int
+mlx5e_xsk_optional_open(struct mlx5e_priv *priv, int ix,
+			struct mlx5e_params *params,
+			struct mlx5e_channel_param *cparam,
+			struct mlx5e_channel *c)
+{
+	struct mlx5e_xsk_param xsk;
+	struct xdp_umem *umem;
+	int err = 0;
+
+	umem = mlx5e_xsk_get_umem(params, params->xsk, ix);
+
+	if (umem) {
+		mlx5e_build_xsk_param(umem, &xsk);
+		err = mlx5e_open_xsk(priv, params, &xsk, umem, c);
+	}
+
+	return err;
+}
+
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
-			      struct xdp_umem *umem,
 			      struct mlx5e_channel **cp)
 {
 	int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix));
 	struct net_device *netdev = priv->netdev;
-	struct mlx5e_xsk_param xsk;
 	struct mlx5e_channel *c;
 	unsigned int irq;
 	int err;
@@ -1977,9 +1995,9 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	if (unlikely(err))
 		goto err_napi_del;
 
-	if (umem) {
-		mlx5e_build_xsk_param(umem, &xsk);
-		err = mlx5e_open_xsk(priv, params, &xsk, umem, c);
+	/* This opens a second set of shadow queues for xsk */
+	if (params->xdp_prog) {
+		err = mlx5e_xsk_optional_open(priv, ix, params, cparam, c);
 		if (unlikely(err))
 			goto err_close_queues;
 	}
@@ -2345,12 +2363,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 
 	mlx5e_build_channel_param(priv, &chs->params, cparam);
 	for (i = 0; i < chs->num; i++) {
-		struct xdp_umem *umem = NULL;
-
-		if (chs->params.xdp_prog)
-			umem = mlx5e_xsk_get_umem(&chs->params, chs->params.xsk, i);
-
-		err = mlx5e_open_channel(priv, i, &chs->params, cparam, umem, &chs->c[i]);
+		err = mlx5e_open_channel(priv, i, &chs->params, cparam, &chs->c[i]);
 		if (err)
 			goto err_close_channels;
 	}
-- 
2.24.1

