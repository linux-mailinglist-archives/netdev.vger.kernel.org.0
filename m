Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD36A67706E
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 17:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjAVQQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 11:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjAVQQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 11:16:24 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89A91DBB1
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 08:16:22 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 30MFUkc8022590;
        Sun, 22 Jan 2023 08:16:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=rb4sK0OGxhcsGgRhJdhcOfmRPdasjJADUmKhlombzpo=;
 b=XWkl9J5kvr4fZ4yF92NMLkodGL/qjYo+uYD/iOnSOILmNTUuyfj/M/Moda2fq4eU7EGE
 FggrVmROaiiK5x/EmxS+PiaFyH6Ko5inKZe/0JCgYVEWc5YnI+CLpPbY1y4i732sABak
 PQondbKTmclt83WBIQQSpJgu1AHTU4+Zr4PxDAeTVvZbIr6RAF43+Mgc2xSqM6w9dEgw
 dNw1ZJhSxgIHrMQWb4oiGC4rgOsSV9Wv1Vrm/gj98aFVJtljkrCIbXZOVgBJkoCZ0zrH
 BBKRkbHDmjtRR1zAQzUXxENLrv/E4l4VmZ9JWtIgMFQ3r6GAX63Tzdy1LCDwf2w+WwSu Ew== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3n8cm1e1ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 22 Jan 2023 08:16:17 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server id
 15.1.2375.34; Sun, 22 Jan 2023 08:16:14 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Vadim Fedorenko <vadfed@meta.com>, <netdev@vger.kernel.org>
Subject: [PATCH net 2/2] mlx5: fix skb leak while fifo resync
Date:   Sun, 22 Jan 2023 08:16:02 -0800
Message-ID: <20230122161602.1958577-3-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230122161602.1958577-1-vadfed@meta.com>
References: <20230122161602.1958577-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-GUID: SUzomPU7NsSSW1KZSRFQL7NdNrWLNv66
X-Proofpoint-ORIG-GUID: SUzomPU7NsSSW1KZSRFQL7NdNrWLNv66
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-22_13,2023-01-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During ptp resync operation SKBs were poped from the fifo but were never
freed neither by napi_consume nor by dev_kfree_skb_any. Add call to
napi_consume_skb to properly free SKBs.

Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 11a99e0f00c6..d60bb997c53b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -102,6 +102,7 @@ static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
 		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
 		skb_tstamp_tx(skb, &hwts);
 		ptpsq->cq_stats->resync_cqe++;
+		napi_consume_skb(skb, 1);
 		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	}
 
-- 
2.30.2

