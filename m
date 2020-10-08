Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BBB287BE0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 20:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgJHSpk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Oct 2020 14:45:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13252 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729235AbgJHSpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 14:45:39 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 098IXJIa021767
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 11:45:38 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34140921rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 11:45:38 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 8 Oct 2020 11:45:36 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 59042247B681; Thu,  8 Oct 2020 11:45:26 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>
CC:     <kernel-team@fb.com>
Subject: [PATCH net-next] mlx4: handle non-napi callers to napi_poll
Date:   Thu, 8 Oct 2020 11:45:26 -0700
Message-ID: <20201008184526.3196768-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-08_12:2020-10-08,2020-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=469 impostorscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 spamscore=0 clxscore=1034 priorityscore=1501 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

netcons calls napi_poll with a budget of 0 to transmit packets.
Handle this by:
 - skipping RX processing
 - do not try to recycle TX packets to the RX cache

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 3 +++
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 99d7737e8ad6..502d1b97855c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -943,6 +943,9 @@ int mlx4_en_poll_rx_cq(struct napi_struct *napi, int budget)
 	bool clean_complete = true;
 	int done;
 
+	if (!budget)
+		return 0;
+
 	if (priv->tx_ring_num[TX_XDP]) {
 		xdp_tx_cq = priv->tx_cq[TX_XDP][cq->ring];
 		if (xdp_tx_cq->xdp_busy) {
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 45869b29368f..3ddb7268e415 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -350,7 +350,7 @@ u32 mlx4_en_recycle_tx_desc(struct mlx4_en_priv *priv,
 		.dma = tx_info->map0_dma,
 	};
 
-	if (!mlx4_en_rx_recycle(ring->recycle_ring, &frame)) {
+	if (!napi_mode || !mlx4_en_rx_recycle(ring->recycle_ring, &frame)) {
 		dma_unmap_page(priv->ddev, tx_info->map0_dma,
 			       PAGE_SIZE, priv->dma_dir);
 		put_page(tx_info->page);
-- 
2.24.1

