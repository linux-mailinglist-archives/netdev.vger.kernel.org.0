Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF71758DAA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF0WIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:08:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726557AbfF0WIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:08:41 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5RM7uMR014948
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:40 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tcc49wgng-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:40 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 15:08:38 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 9F9DD240E995C; Thu, 27 Jun 2019 15:08:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <saeedm@mellanox.com>,
        <maximmi@mellanox.com>, <brouer@redhat.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 5/6 bpf-next] Remove use of umem _rq variants from Mellanox driver.
Date:   Thu, 27 Jun 2019 15:08:35 -0700
Message-ID: <20190627220836.2572684-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=862 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270254
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 8d24eaa660a8..e116b1fde797 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -12,7 +12,7 @@ bool mlx5e_xsk_pages_enough_umem(struct mlx5e_rq *rq, int count)
 	/* Check in advance that we have enough frames, instead of allocating
 	 * one-by-one, failing and moving frames to the Reuse Ring.
 	 */
-	return xsk_umem_has_addrs_rq(rq->umem, count);
+	return xsk_umem_has_addrs(rq->umem, count);
 }
 
 int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
@@ -21,7 +21,7 @@ int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
 	struct xdp_umem *umem = rq->umem;
 	u64 handle;
 
-	if (!xsk_umem_peek_addr_rq(umem, &handle))
+	if (!xsk_umem_peek_addr(umem, &handle))
 		return -ENOMEM;
 
 	dma_info->xsk.handle = handle + rq->buff.umem_headroom;
@@ -34,7 +34,7 @@ int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
 	 */
 	dma_info->addr = xdp_umem_get_dma(umem, handle);
 
-	xsk_umem_discard_addr_rq(umem);
+	xsk_umem_discard_addr(umem);
 
 	dma_sync_single_for_device(rq->pdev, dma_info->addr, PAGE_SIZE,
 				   DMA_BIDIRECTIONAL);
-- 
2.17.1

