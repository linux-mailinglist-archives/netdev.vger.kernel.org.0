Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE3658DA6
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfF0WIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:08:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26032 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726520AbfF0WIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:08:40 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RM5cHP001671
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:39 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2td0y51dd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:08:39 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Jun 2019 15:08:38 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id 8ED33240E9954; Thu, 27 Jun 2019 15:08:36 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <saeedm@mellanox.com>,
        <maximmi@mellanox.com>, <brouer@redhat.com>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH 1/6 bpf-next] Have xsk_umem_peek_addr_rq() return chunk-aligned handles.
Date:   Thu, 27 Jun 2019 15:08:31 -0700
Message-ID: <20190627220836.2572684-2-jonathan.lemon@gmail.com>
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
 mlxlogscore=968 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270254
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xkq_peek_addr() returns chunk-aligned handles, so have the rq behave
the same way.  Clean up callsites.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c          | 2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c        | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 2 +-
 include/net/xdp_sock.h                              | 2 +-
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 32bad014d76c..3b84fca1c11d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -289,8 +289,6 @@ static bool i40e_alloc_buffer_slow_zc(struct i40e_ring *rx_ring,
 		return false;
 	}
 
-	handle &= rx_ring->xsk_umem->chunk_mask;
-
 	hr = umem->headroom + XDP_PACKET_HEADROOM;
 
 	bi->dma = xdp_umem_get_dma(umem, handle);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 6b609553329f..a9cab3271ac9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -293,8 +293,6 @@ static bool ixgbe_alloc_buffer_slow_zc(struct ixgbe_ring *rx_ring,
 		return false;
 	}
 
-	handle &= rx_ring->xsk_umem->chunk_mask;
-
 	hr = umem->headroom + XDP_PACKET_HEADROOM;
 
 	bi->dma = xdp_umem_get_dma(umem, handle);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 6a55573ec8f2..85440b1c1c3f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -44,7 +44,7 @@ int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
 
 static inline void mlx5e_xsk_recycle_frame(struct mlx5e_rq *rq, u64 handle)
 {
-	xsk_umem_fq_reuse(rq->umem, handle & rq->umem->chunk_mask);
+	xsk_umem_fq_reuse(rq->umem, handle);
 }
 
 /* XSKRQ uses pages from UMEM, they must not be released. They are returned to
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 057b159ff8b9..39516d960636 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -117,7 +117,7 @@ static inline u64 *xsk_umem_peek_addr_rq(struct xdp_umem *umem, u64 *addr)
 	if (!rq->length)
 		return xsk_umem_peek_addr(umem, addr);
 
-	*addr = rq->handles[rq->length - 1];
+	*addr = rq->handles[rq->length - 1] & umem->chunk_mask;
 	return addr;
 }
 
-- 
2.17.1

