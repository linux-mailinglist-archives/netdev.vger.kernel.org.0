Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9714D22FC6D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgG0WpU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:45:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33782 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727823AbgG0Wox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:44:53 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMiFWP002014
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:52 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4qrxtfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:44:52 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:50 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 0247F3FAB6F7D; Mon, 27 Jul 2020 15:44:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 18/21] mlx5e: add netgpu entries to mlx5 structures
Date:   Mon, 27 Jul 2020 15:44:41 -0700
Message-ID: <20200727224444.2987641-19-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=855 suspectscore=1 malwarescore=0
 clxscore=1034 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Modify mlx5e structures in order to add support for netgpu, which
shares some of the same structures as AF_XDP.  Add logic to make sure
they are not both in use.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         | 12 ++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c    |  3 +++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h    |  3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  3 ++-
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 24d88e8952ed..ae555c6be847 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -365,6 +365,7 @@ struct mlx5e_dma_info {
 		struct page *page;
 		struct xdp_buff *xsk;
 	};
+	bool netgpu_source;
 };
 
 /* XDP packets can be transmitted in different ways. On completion, we need to
@@ -553,6 +554,7 @@ struct mlx5e_rq_frags_info {
 	u8 wqe_bulk;
 };
 
+struct netgpu_ifq;
 struct mlx5e_rq {
 	/* data path */
 	union {
@@ -608,8 +610,9 @@ struct mlx5e_rq {
 	DECLARE_BITMAP(flags, 8);
 	struct page_pool      *page_pool;
 
-	/* AF_XDP zero-copy */
+	/* AF_XDP or NETGPU zero-copy */
 	struct xdp_umem       *umem;
+	struct netgpu_ifq     *netgpu;
 
 	struct work_struct     recover_work;
 
@@ -627,6 +630,7 @@ struct mlx5e_rq {
 
 enum mlx5e_channel_state {
 	MLX5E_CHANNEL_STATE_XSK,
+	MLX5E_CHANNEL_STATE_NETGPU,
 	MLX5E_CHANNEL_NUM_STATES
 };
 
@@ -737,9 +741,13 @@ struct mlx5e_xsk {
 	 * but it doesn't distinguish between zero-copy and non-zero-copy UMEMs,
 	 * so rely on our mechanism.
 	 */
-	struct xdp_umem **umems;
+	union {
+		struct xdp_umem **umems;
+		struct netgpu_ifq **ifq_tbl;
+	};
 	u16 refcnt;
 	bool ever_used;
+	bool is_umem;
 };
 
 /* Temporary storage for variables that are allocated when struct mlx5e_priv is
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
index 8ecfbcc3c826..1fad8dbbf59d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
@@ -27,7 +27,10 @@ static int mlx5e_xsk_get_umems(struct mlx5e_xsk *xsk)
 				     sizeof(*xsk->umems), GFP_KERNEL);
 		if (unlikely(!xsk->umems))
 			return -ENOMEM;
+		xsk->is_umem = true;
 	}
+	if (!xsk->is_umem)
+		return -EINVAL;
 
 	xsk->refcnt++;
 	xsk->ever_used = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
index bada94973586..13ef03446571 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
@@ -15,6 +15,9 @@ static inline struct xdp_umem *mlx5e_xsk_get_umem(struct mlx5e_params *params,
 	if (unlikely(ix >= params->num_channels))
 		return NULL;
 
+	if (unlikely(!xsk->is_umem))
+		return NULL;
+
 	return xsk->umems[ix];
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5a0b181f92f7..d75f22471357 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -62,7 +62,6 @@
 #include "en/xsk/setup.h"
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
-#include "en/netgpu/setup.h"
 #include "en/hv_vhca_stats.h"
 #include "en/devlink.h"
 #include "lib/mlx5.h"
@@ -324,6 +323,8 @@ static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 				if (prev)
 					prev->last_in_page = true;
 			}
+			next_frag.di->netgpu_source =
+						!!frag_info[f].frag_source;
 			*frag = next_frag;
 
 			/* prepare next */
-- 
2.24.1

