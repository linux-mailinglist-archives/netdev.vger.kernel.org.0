Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62D74954FC
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 20:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377479AbiATTgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 14:36:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3582 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377469AbiATTgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 14:36:46 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20KHwXfj013618
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:36:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=btV+CUJ4/5ZGUdKet+TOfhhauxw7f4oD0ZBMYIhj8cg=;
 b=Xn8lZhO0WWjZw8sWwkRMeX2VLNCNrs+WlIye/L7c3YthponKUGG1Hz1o8k9efGefgFWy
 9ZvZjbKw9eHXYylY4f0OZ+vGWXdXz1kDswmONjD0cPnPzaPtm5HwnPzbjwwbByefiSdQ
 iMXLgwtROej4mP0Y5Fqad0QQX9SgJ7a50VY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dpyswcx8d-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:36:45 -0800
Received: from twshared3399.25.prn2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 20 Jan 2022 11:36:42 -0800
Received: by devvm5911.prn0.facebook.com (Postfix, from userid 190935)
        id 88C29C1F073; Thu, 20 Jan 2022 11:36:40 -0800 (PST)
From:   Alex Liu <liualex@fb.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
CC:     Alex Liu <liualex@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: [PATCH] net/mlx5e: Add support for using xdp->data_meta
Date:   Thu, 20 Jan 2022 11:34:59 -0800
Message-ID: <20220120193459.3027981-1-liualex@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Z56r12RH2IfwzpxnmFAiIR-fY5K8I6GX
X-Proofpoint-ORIG-GUID: Z56r12RH2IfwzpxnmFAiIR-fY5K8I6GX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_08,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for using xdp->data_meta for cross-program communication

Pass "true" to the last argument of xdp_prepare_buff().

After SKB is built, call skb_metadata_set() if metadata was pushed.

Signed-off-by: Alex Liu <liualex@fb.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_rx.c
index e86ccc22fb82..63ba4f3689f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1489,7 +1489,7 @@ static inline void mlx5e_complete_rx_cqe(struct mlx=
5e_rq *rq,
 static inline
 struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
 				       u32 frag_size, u16 headroom,
-				       u32 cqe_bcnt)
+				       u32 cqe_bcnt, u32 metasize)
 {
 	struct sk_buff *skb =3D build_skb(va, frag_size);
=20
@@ -1501,6 +1501,9 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e=
_rq *rq, void *va,
 	skb_reserve(skb, headroom);
 	skb_put(skb, cqe_bcnt);
=20
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 	return skb;
 }
=20
@@ -1508,7 +1511,7 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq=
, void *va, u16 headroom,
 				u32 len, struct xdp_buff *xdp)
 {
 	xdp_init_buff(xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
-	xdp_prepare_buff(xdp, va, headroom, len, false);
+	xdp_prepare_buff(xdp, va, headroom, len, true);
 }
=20
 static struct sk_buff *
@@ -1521,6 +1524,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, stru=
ct mlx5_cqe64 *cqe,
 	struct sk_buff *skb;
 	void *va, *data;
 	u32 frag_size;
+	u32 metasize;
=20
 	va             =3D page_address(di->page) + wi->offset;
 	data           =3D va + rx_headroom;
@@ -1537,7 +1541,8 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, stru=
ct mlx5_cqe64 *cqe,
=20
 	rx_headroom =3D xdp.data - xdp.data_hard_start;
 	frag_size =3D MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
-	skb =3D mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt=
);
+	metasize =3D xdp.data - xdp.data_meta;
+	skb =3D mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt=
, metasize);
 	if (unlikely(!skb))
 		return NULL;
=20
@@ -1836,6 +1841,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq=
, struct mlx5e_mpw_info *wi,
 	struct sk_buff *skb;
 	void *va, *data;
 	u32 frag_size;
+	u32 metasize;
=20
 	/* Check packet size. Note LRO doesn't use linear SKB */
 	if (unlikely(cqe_bcnt > rq->hw_mtu)) {
@@ -1861,7 +1867,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq=
, struct mlx5e_mpw_info *wi,
=20
 	rx_headroom =3D xdp.data - xdp.data_hard_start;
 	frag_size =3D MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt32);
-	skb =3D mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt=
32);
+	metasize =3D xdp.data - xdp.data_meta;
+	skb =3D mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt=
32, metasize);
 	if (unlikely(!skb))
 		return NULL;
=20
@@ -1892,7 +1899,7 @@ mlx5e_skb_from_cqe_shampo(struct mlx5e_rq *rq, stru=
ct mlx5e_mpw_info *wi,
 		dma_sync_single_range_for_cpu(rq->pdev, head->addr, 0, frag_size, DMA_=
FROM_DEVICE);
 		prefetchw(hdr);
 		prefetch(data);
-		skb =3D mlx5e_build_linear_skb(rq, hdr, frag_size, rx_headroom, head_s=
ize);
+		skb =3D mlx5e_build_linear_skb(rq, hdr, frag_size, rx_headroom, head_s=
ize, 0);
=20
 		if (unlikely(!skb))
 			return;
--=20
2.30.2

