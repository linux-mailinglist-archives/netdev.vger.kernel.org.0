Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D6A22FC6F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgG0WpX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:45:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20536 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727826AbgG0Wox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:53 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMfda3010751
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:52 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h50vprn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:52 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id EE6693FAB6F79; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 16/21] mlx5: remove the umem parameter from mlx5e_open_channel
Date:   Mon, 27 Jul 2020 15:44:39 -0700
Message-ID: <20200727224444.2987641-17-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Instead of obtaining the umem parameter from the channel parameters
and passing it to the function, push this down into the function itself.

Move xsk open logic into its own function, in preparation for the
upcoming netgpu commit.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 37 +++++++++++++------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 9d5d8b28bcd8..3762d4527afe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -393,7 +393,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->xdpsq   = &c->rq_xdpsq;
 	rq->umem    = umem;
 
-	if (rq->umem)
+	if (xsk)
 		rq->stats = &c->priv->channel_stats[c->ix].xskrq;
 	else
 		rq->stats = &c->priv->channel_stats[c->ix].rq;
@@ -1946,15 +1946,33 @@ static u8 mlx5e_enumerate_lag_port(struct mlx5_core_dev *mdev, int ix)
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
@@ -1988,9 +2006,9 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
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
@@ -2351,12 +2369,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 
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

