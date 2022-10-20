Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71223605C26
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiJTKWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiJTKVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:21:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045481DC807
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLwE4zOJ1KINoqsFYEp05Yef7gSM+gq6l8vSuMF8q0lAJ+/fVcXgY9kspBTw81W8b47K6p9FuGEO8CCrYoZ++ss0AgyVfSu7dE7OtkjfrkxjGHb7Mm6KD1QCWvDlNFPQinCSVLdSnnzkoQIP40f5zGIN+TdCUfkklX2vkJ4jDotszOTNsfiZerKxNUVIhrsyjfwhZ3OntYj3S2IL5bnyISXGno+VE5rWBoioNRGn7ueSRCc2NKZSsUydqPZvMLLSULEiVcvOsnHyxtV9N/U2Swf0fgLFY8qcQjlH/RULBoewXD4gGWqyuDZ54xtbbJ78HHhnyZZVOnRGvqZmC14ENg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhC/kGdD6nL58eOr7jzxOtxX8rn98H/u+r8FiUfQrbc=;
 b=at7u/3ENJKEZxtp6c2t0WsNTglfcSafaXkMDOgqRz1+Ghmz6PVBkakUR0a7rJPpBBYwfuZC6CyWTYBL0O1RSd20lwMywXyPKRHQWQDKjD8TyBSWoJ871jablxS3vJpIiUjFdTcAerWpNK4uVklpY7VYYtl8h7dJr6Av8dKSgCURXX1jwWeHbYHFMs+UgfYKzPEfK1vyjHsLRba2MW/xGV2o/h668i7IzCWGxy1I0PzZYE74+yId0HwL4PWWOVgHSjyyjVAGMDQn/V0CkQ4kYWtzBJX3MhiHJ/Vg8ls89sSuRPbubeZT309moBQKkJCUUKp8oD+UvfDbxvJRLxNnqMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhC/kGdD6nL58eOr7jzxOtxX8rn98H/u+r8FiUfQrbc=;
 b=Pa6s5S7zYBh40EKSvkcSOkGxVdPVCK8i4YCdZA46/snyInLxNJCJPCxsdDiVjmXfGXIszm4i7SwlTbapme8HX/gz3JK9MEHPFBrGvXIb8dmICpjko7kctRy7Zv/q4Hsf6vuqLbTytAxcA1WkoeP7qtI9pfLEUUqVmiPjR8T8onYsKG6YSROwdj4RYcPLABpKN9zoQdwGoT/oRFrlaJ5DthNxmGbb/AQ0k//ltMoHvebhLuDFSzhaw8KHC+vY5KInmbMztFYkaT/i6IDd7wyalVof0MKELeMFdfH+t64zcM2mF3gPzZuF7HT6p919hKmQiklnzaxWPm0eyXBXTAkutA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:20:32 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:20:32 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 18/23] net/mlx5e: NVMEoTCP, use KLM UMRs for buffer registration
Date:   Thu, 20 Oct 2022 13:18:33 +0300
Message-Id: <20221020101838.2712846-19-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0138.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::7) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: e5d08dea-d990-4425-e37a-08dab284b866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uzEgFtciz24rAor3FYZh07rlqI4yb57g2n1Izq8WqRw734Qo28exZu3t3pu6Ge5fOztPXopbVl9JJs7WF7Tvxh7TGD0Mi1BOmvCf3l5NDu+mNEuyAnrk+rMPkqd7lupftgEJyMhjMrz3vg/LHHUSBF4NjhkWGoI7MDX7mgWA9d2usrCo7x8bTlUNleZ62wdjoY6pXRHgytGZXGjE+d+55k7vrmZbJEjMDYmwpz98JVLMVQhEnsmAmC4hiFA52mz9QSoDfyA6/B7Kfr3RTf3QNXMtZ4/xU8sOSnq3ObVRQ7rwIQ+ww9dIGXkWNstvziSvVsKATt78xlgVH0tQMmrh2WBc7GrHbGgnysnmI38Tkf8TvivwZLnBwNJnvJevUEVkMABgOrD7OrE/g0LGN6LcvABqprqTlzTeIKlO+OW+5k3m2pe/3ZIV5Xc7CXfOChJ1x7WIfTAmdQdlujVwxqRm2ZorIhitlq8jkIq5z+A/SporCkVQ4Gl3FfQqkPL+GodbFGlfsKZt4/o8zVeLqe+CCMPWgF5N/bgf+6CoJrF+/wDCXrDhMUmqpzvJ58ClZBDj/jEJplMmLcryAxuTnErW2wCxQ1Ccntle0g2dUKFjFJ6hlTv5uZGeE8mGZfy4VzHdObCMtx+BPdb5n6/acZhoO9gehJN3ND01D5VG8USGWNEF68Cu/fgNCFL9TxB0bAgRN1wi//Jr316JQpTrSC26UhutNzqBktgjwp1Am09bBqniuQED/QY5WB26ATIm3/V5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O/Tw7u+1b1ArOSkOybyzcEn5zfNXScepEq0QeLrwUXfo92lmYWSKhMAvjLsq?=
 =?us-ascii?Q?niiDxVdwl9F7LLzI9a3/RQxkPZvzGfM5jZT6J2XLlMuUaSmdbZdWblZ/GynF?=
 =?us-ascii?Q?2iboSm4rOnzZ7rvIhqKq9xHlHBygWxfC3h/gbW3AvIhKp6qxeIUSSVQxxau3?=
 =?us-ascii?Q?bWQ7Fs1G27Wi2/Z0bkL9YpsCV5tSN7ZZufUlRgk4gR50kWzkOd++nbuxCuTJ?=
 =?us-ascii?Q?UHtT2VxSm0CGEXWcNbUmzPASRIvLVlvVqb8nXfQv5fe5ddMQwA/75JGIdFfh?=
 =?us-ascii?Q?KCVFdrQRxIdRDZj8MqtatHA9qRUWKGWXkj2N6U+63vEhLikVDUwvJFi1Nxn/?=
 =?us-ascii?Q?td063icVD4yCmAjx9FhCF1Ea9QWkOBV1rZhZmpJQdZdZ9scsF9JMh1nq/udH?=
 =?us-ascii?Q?SDlaaTVAwrq0iZg+vTz+SbUjCLFksNnGPOEgqLcS6w+urElZWnb2Ds84Gg8Z?=
 =?us-ascii?Q?6/rIWpMHfU7ty7nM/AWCCL3WkXJKDEhZWgX809XaGIkA7vhiiY5Cu08VO0zC?=
 =?us-ascii?Q?B0BZbXyK3Pwy7YktVdROHm9Yt1ei7sTQkUsE1nmF5s+eGrSSJ6KVnRTddsSJ?=
 =?us-ascii?Q?XeoP+VDwcrh0VCEvICUFIk+phXA1x73ZbfdbKHgmEmBVHa0qtQbe3X5+0NbA?=
 =?us-ascii?Q?/pHBYoADkV1G/0YhBpzwHehy9MaLO0LIvav6R65Kci63oUK8LV8Gy/6DsMYR?=
 =?us-ascii?Q?sjirdWxIYyLvSzBSWwQihPk+r+KiV1U50a5JEHgJjNqxNWJ49MqhI2WEbu0f?=
 =?us-ascii?Q?AyRFK3SaV/YMeEuChRyJrGAGteLkOKIWSy7iZvD5uFFWMcqVbsjJpAsoYA1L?=
 =?us-ascii?Q?zxFnVopbTeK1O14n9c8zS+/x3hDAbjQiyJYto+cmN6V5Xl64/3LZClc1+YRc?=
 =?us-ascii?Q?eg4XVs/nrxamBcGJXm+22rbHexnGmHx4vHgDi8SjrsERIS+CcdEvNkTML+uS?=
 =?us-ascii?Q?qiv2qJQ01NBHDnscYYz6sW47sRnUdkGalJfi2/GigGLMo0AzW08VTym40LVf?=
 =?us-ascii?Q?4938kKI3G7j5D+A9nf6Y/rkaoqe8YGA0rl1hBJsMmA+/SCES2CfpRMzMMTP+?=
 =?us-ascii?Q?MgWC0EU0ZUzxzkfjPiTvICe3Vw80iioyQdk2h2oCH5fGmpiJrPuLFj2K/sF9?=
 =?us-ascii?Q?fJTZllQZV6QLIz8WgDbmMXLfeiRAjcHJoN4rBBMhO30QFW+F1snKyoof6M3s?=
 =?us-ascii?Q?SzuUkZjsuepGKJ1FJv2eUWH8vmhzht3ajYOl+icxyF/9uHuEoGJus6FiJUSb?=
 =?us-ascii?Q?O2tnrVL5YutSveRtyTGXK2vMB927fcMzIxb52kirrBc11hJqcS4Fj1uhOLlT?=
 =?us-ascii?Q?Msg4uro+9QJ2p5FVWjQvKJkj7dILpyMBUDKzv+vwAlJgvwb/cHgsMI9WdjKm?=
 =?us-ascii?Q?UDfOxdv2BuVVywWPv0jcjen7jwX6t6dQGTIzJs4kGgZcKVYDWaculsGSqg0A?=
 =?us-ascii?Q?V7NI2qQbC0Bk89Fxodqz8ryfEiuf8iOGR5Yr6i87uIZOW6n8rqVtO4GooMXM?=
 =?us-ascii?Q?3Fj4xDNVWCnuJc8n1W4dbaFa3PeJSOgbJQAP2mrajOEqRlg/UKWR3ERWXg2o?=
 =?us-ascii?Q?e3qozYA2ngBSYCCvCMndebyAD4RTNTFqTD28seLY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d08dea-d990-4425-e37a-08dab284b866
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:20:32.6774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 225MaRG95iHi+bij0h+7N8L6bfvcWOND2q4mKhYXN2pekh/4n+1b+Gh/7je6JlpNos6btKud6/ns54h+01eO6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload uses buffer registration for ddp operation.
Every request comprises from SG list that might consist from elements
with multiple combination sizes, thus the appropriate way to perform
buffer registration is with KLM UMRs.

UMR stands for user-mode memory registration, it is a mechanism to alter
address translation properties of MKEY by posting WorkQueueElement
aka WQE on send queue.

MKEY stands for memory key, MKEY are used to describe a region in memory
that can be later used by HW.

KLM stands for {Key, Length, MemVa}, KLM_MKEY is indirect MKEY that
enables to map multiple memory spaces with different sizes in unified MKEY.
KLM UMR is a UMR that use to update a KLM_MKEY.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   3 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 123 ++++++++++++++++++
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  25 ++++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +
 4 files changed, 155 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 101b7630b046..8e437d98565a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -29,6 +29,9 @@ enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_SET_PSV_TLS,
 	MLX5E_ICOSQ_WQE_GET_PSV_TLS,
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	MLX5E_ICOSQ_WQE_UMR_NVMEOTCP,
+#endif
 };
 
 /* General */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index b00dc46c7c3c..30c0a50f5dac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/idr.h>
 #include "en_accel/nvmeotcp.h"
+#include "en_accel/nvmeotcp_utils.h"
 #include "en_accel/fs_tcp.h"
 #include "en/txrx.h"
 
@@ -19,6 +20,120 @@ static const struct rhashtable_params rhash_queues = {
 	.max_size = MAX_NUM_NVMEOTCP_QUEUES,
 };
 
+static void
+fill_nvmeotcp_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe *wqe, u16 ccid,
+		      u32 klm_entries, u16 klm_offset)
+{
+	struct scatterlist *sgl_mkey;
+	u32 lkey, i;
+
+	lkey = queue->priv->mdev->mlx5e_res.hw_objs.mkey;
+	for (i = 0; i < klm_entries; i++) {
+		sgl_mkey = &queue->ccid_table[ccid].sgl[i + klm_offset];
+		wqe->inline_klms[i].bcount = cpu_to_be32(sg_dma_len(sgl_mkey));
+		wqe->inline_klms[i].key = cpu_to_be32(lkey);
+		wqe->inline_klms[i].va = cpu_to_be64(sgl_mkey->dma_address);
+	}
+
+	for (; i < ALIGN(klm_entries, MLX5_UMR_KLM_ALIGNMENT); i++) {
+		wqe->inline_klms[i].bcount = 0;
+		wqe->inline_klms[i].key = 0;
+		wqe->inline_klms[i].va = 0;
+	}
+}
+
+static void
+build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe *wqe,
+		       u16 ccid, int klm_entries, u32 klm_offset, u32 len,
+		       enum wqe_type klm_type)
+{
+	u32 id = (klm_type == KLM_UMR) ? queue->ccid_table[ccid].klm_mkey :
+		 (mlx5e_tir_get_tirn(&queue->tir) << MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
+	u8 opc_mod = (klm_type == KLM_UMR) ? MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR :
+		MLX5_OPC_MOD_TRANSPORT_TIR_STATIC_PARAMS;
+	u32 ds_cnt = MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, MLX5_UMR_KLM_ALIGNMENT));
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
+	struct mlx5_mkey_seg *mkc = &wqe->mkc;
+	u32 sqn = queue->sq.sqn;
+	u16 pc = queue->sq.pc;
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_UMR | (opc_mod) << 24);
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) | ds_cnt);
+	cseg->general_id = cpu_to_be32(id);
+
+	if (klm_type == KLM_UMR && !klm_offset) {
+		ucseg->mkey_mask = cpu_to_be64(MLX5_MKEY_MASK_XLT_OCT_SIZE |
+					       MLX5_MKEY_MASK_LEN | MLX5_MKEY_MASK_FREE);
+		mkc->xlt_oct_size = cpu_to_be32(ALIGN(len, MLX5_UMR_KLM_ALIGNMENT));
+		mkc->len = cpu_to_be64(queue->ccid_table[ccid].size);
+	}
+
+	ucseg->flags = MLX5_UMR_INLINE | MLX5_UMR_TRANSLATION_OFFSET_EN;
+	ucseg->xlt_octowords = cpu_to_be16(ALIGN(klm_entries, MLX5_UMR_KLM_ALIGNMENT));
+	ucseg->xlt_offset = cpu_to_be16(klm_offset);
+	fill_nvmeotcp_klm_wqe(queue, wqe, ccid, klm_entries, klm_offset);
+}
+
+static void
+mlx5e_nvmeotcp_fill_wi(struct mlx5e_icosq *sq, u32 wqebbs, u16 pi)
+{
+	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
+
+	memset(wi, 0, sizeof(*wi));
+
+	wi->num_wqebbs = wqebbs;
+	wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVMEOTCP;
+}
+
+static u32
+post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+	     enum wqe_type wqe_type,
+	     u16 ccid,
+	     u32 klm_length,
+	     u32 klm_offset)
+{
+	struct mlx5e_icosq *sq = &queue->sq;
+	u32 wqebbs, cur_klm_entries;
+	struct mlx5e_umr_wqe *wqe;
+	u16 pi, wqe_sz;
+
+	cur_klm_entries = min_t(int, queue->max_klms_per_wqe, klm_length - klm_offset);
+	wqe_sz = MLX5E_KLM_UMR_WQE_SZ(ALIGN(cur_klm_entries, MLX5_UMR_KLM_ALIGNMENT));
+	wqebbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
+	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi);
+	mlx5e_nvmeotcp_fill_wi(sq, wqebbs, pi);
+	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, klm_offset,
+			       klm_length, wqe_type);
+	sq->pc += wqebbs;
+	sq->doorbell_cseg = &wqe->ctrl;
+	return cur_klm_entries;
+}
+
+static void
+mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, enum wqe_type wqe_type,
+			    u16 ccid, u32 klm_length)
+{
+	struct mlx5e_icosq *sq = &queue->sq;
+	u32 klm_offset = 0, wqes, i;
+
+	wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
+
+	spin_lock_bh(&queue->sq_lock);
+
+	for (i = 0; i < wqes; i++)
+		klm_offset += post_klm_wqe(queue, wqe_type, ccid, klm_length, klm_offset);
+
+	if (wqe_type == KLM_UMR) /* not asking for completion on ddp_setup UMRs */
+		__mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, sq->doorbell_cseg, 0);
+	else
+		mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, sq->doorbell_cseg);
+
+	spin_unlock_bh(&queue->sq_lock);
+}
+
 static int
 mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
 			      struct ulp_ddp_limits *ulp_limits)
@@ -45,6 +160,14 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 			 struct sock *sk,
 			 struct ulp_ddp_io *ddp)
 {
+	struct mlx5e_nvmeotcp_queue *queue;
+
+	queue = container_of(ulp_ddp_get_ctx(sk),
+			     struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+
+	/* Placeholder - map_sg and initializing the count */
+
+	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
new file mode 100644
index 000000000000..c7b176577167
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. */
+#ifndef __MLX5E_NVMEOTCP_UTILS_H__
+#define __MLX5E_NVMEOTCP_UTILS_H__
+
+#include "en.h"
+
+#define MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi) \
+	((struct mlx5e_umr_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_umr_wqe)))
+
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_PROGRESS_PARAMS 0x4
+
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_TIR_PARAMS 0x2
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR 0x0
+
+enum wqe_type {
+	KLM_UMR,
+	BSF_KLM_UMR,
+	SET_PSV_UMR,
+	BSF_UMR,
+	KLM_INV_UMR,
+};
+
+#endif /* __MLX5E_NVMEOTCP_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 261802579791..039eeb3b3e45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -921,6 +921,10 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
 			case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
 				mlx5e_ktls_handle_get_psv_completion(wi, sq);
 				break;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+			case MLX5E_ICOSQ_WQE_UMR_NVMEOTCP:
+				break;
 #endif
 			default:
 				netdev_WARN_ONCE(cq->netdev,
-- 
2.31.1

