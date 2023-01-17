Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3DF66E271
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjAQPkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbjAQPic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:38:32 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C832343458
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:37:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSgrTVa3Pe1XewSllbRABk5ul50gBIxM0WlfLT9BSURw5LppO55umeTj2+cMn7NW6uPzdnnKYzaay7rDXSP/rjS83gMkPM+nqdbl58ZenxSyfXkqRRZ8Yn5OA4tdTv0cnXPmCo5ZfajZC3ne2gHxp/Ujv1iDJlkpU3KhKZ2mGw8U2GAU/kT7obecdYRz6+CIY1qudMCr/FM76b5LyG7jMOXrdd4cZqGLc5s0YnG9TJg9ouyltQI7IAinpaEaBFd/Y2bf01X9nx+y5uLALq4dnK/ZHVirdaa874uSA3S3h2+hHuXRUVG54if2VPlCo6DjgFmQJ1fY8gimjv2CPVPjDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzHGuklrol7s3+JBvut22Mhwr3AvA8YrfT5UAUgnXRk=;
 b=dF9j9WIeOP0l/KuSIxr/lKY/YvStIpWub12+rI9O5FwW5V1bD1Pw+6DDx8yRG//Q6M1AaPIpWO3ukFpmQ9P7xAAMQB3b+ZSH6rIqG5cD9dtgmAgPmkcbVYkyFa981mRsybmsySha2ZfcOF39pLBpdjIEdy20GE3K9pOBSo+HSxtZvoCmWVPCo6//rIABecdCVKMKfiktfLBQjlO5uP0Pp11nP40Sdl8dLWzFWK4+UA3DPxhXAPE/5cHM5er8BtU/GBSQubdqfTU/x/ItgqcyweyzM1UBQdfEWj+F1j5jut/t6H4uaV3xrnrRci8P3SLwU6xrBWmqhLA5X3+KnX18PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzHGuklrol7s3+JBvut22Mhwr3AvA8YrfT5UAUgnXRk=;
 b=TXkWkCPFxaT/I0GdKPDquhIsEijfT5UiPgmekdsavURyaTKETbrEaBC0vx0Mdd8sfNL5MFGTiCZgsCSaY4Pz+db6RWvU0JwOwEw9y3o3VKaaJ6R0WCOCHEmXokUSACGVx6Hpx7/ATjiSZEj4S7T/hteRFvp7Uw6hX5DQTGaThDjZXR/jE8eLfQceNE+k+BE+k0qOzgJY8dqwXBcMSHUp3PsBp0g2tobfo7eRGaYnKYECTqHfEBTvg7TnkXWtGM8H89NtUzd7GlDynaEPG5D5TK7y94FBnM1CLiRh+MMU9cg8mI/Rwbcp9J8dC1usuyVGpUZX0dWHl1gu92ueA2F+QQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MN0PR12MB5930.namprd12.prod.outlook.com (2603:10b6:208:37d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Tue, 17 Jan
 2023 15:37:41 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:37:40 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Or Gerlitz <ogerlitz@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, yorayz@nvidia.com,
        borisp@nvidia.com
Subject: [PATCH v9 16/25] net/mlx5e: Refactor doorbell function to allow avoiding a completion
Date:   Tue, 17 Jan 2023 17:35:26 +0200
Message-Id: <20230117153535.1945554-17-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0171.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::17) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MN0PR12MB5930:EE_
X-MS-Office365-Filtering-Correlation-Id: f6428fe5-8b00-4b8a-b089-08daf8a0c4cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iNrLYgl+YsZXv6GsaTa5N8HgAXWPwhsZzxsLCNrJELl+uTwzYplm9b2dGSF07mlJ+fqqmAzhnO6frDq/+yHf7VNmzXIw0Y0djJfwdcgce/1EcpxUJAWRBYZz7kG3nnTBKOwnAaU6BzW128a02jHJ+Zl7Iaqem8O+k5N8LclEoA3MEelzvsaJAC6SmaUjNGmY1fNa5PwkqVFtGMnpgIhp6Qoob5383a9UYFm89hcHC660vOViIln8xIKdbBv0qruyAV10lwcgskNRvOtzsAvrLdNlkyxE7M3nFLcDiRO2+nvAn8Fu0kRtT0KWZUIJLgwQ8pClhMMXqXIRFEisfpQk3ewb1mceuFFKZEhQI90knrXglxf+K3i+oO2zmTLGrxeJ3LgLsjpIkRn90HQS15KgH1SQqZfl3784TKbTD4td1L8WM0Ylpnw87PTGdTEZ1b5tOnpMLAzdS6zx53tHZBqP1CSs5fOYzfno7rRvLroq/YOCPNKisFicmu2rLpWWRMMhIqsmr5763w0Pq2iHWMsRigDXFuIV6z5FDSR9gQz5sp645TL1JPnHjPVp9/xKT3Rv4dG5VfP+wXAyVSLmgEWml/n50+MHpFlXEa9jHX3oEeokcWv2aZr3SX3UBHnsZYpxF9nctxH/vt5E/MTsBwWQag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199015)(83380400001)(2906002)(38100700002)(5660300002)(6506007)(7416002)(8936002)(36756003)(1076003)(2616005)(4326008)(66946007)(41300700001)(8676002)(66476007)(66556008)(478600001)(6486002)(107886003)(86362001)(186003)(26005)(6512007)(6666004)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LwNtb18p+ap7xk68/tZa77q9hpHEQZnkA6O7tYzvdJ8j670iZU+jRLto0CYD?=
 =?us-ascii?Q?4yG3uDL+rnD04a74HD7UhDpW4TepMR5LiRgWTFKZeF0yOAlvJ7ToSTp9LZ59?=
 =?us-ascii?Q?WLegptYegLn3cjhljXr5NGdnXYv/Q7INKbPFcP/AgDEzk8xnwKbP+Wwp6dXS?=
 =?us-ascii?Q?FgKTSkXLtwiXm90tlZ3LomPWLNlKrdW5Faq7Ufj/U2Aa/i8AGojV/0yJLYb4?=
 =?us-ascii?Q?fRIWbh3po+8TKDn3BcEvLsNpy5NIjNsf6r3Ki0Lxh2Mfdr1CbmlfDRrsmuOB?=
 =?us-ascii?Q?T0zZ5ODQ4D6zfslA4NBj8tAsxJbarQ3NFwFMn93CZ+F9USJuj3Sfyfess+Jd?=
 =?us-ascii?Q?PsW5F5IlMPG8Q5n3Learmzy2IMi9YE42F4CI8TZJfdg9tSYExN4YFytwewTj?=
 =?us-ascii?Q?qcvzhMHJDbctqVXq4uH6Tnv65hbJcexMeGrw86+Mq90xB4tDBgVbudKwXF7g?=
 =?us-ascii?Q?BKzVzZmYOUY0HtWVStxh4ufKz46nO+QYUwUGZzrGc5sQlS/Zx70xhnbDblFJ?=
 =?us-ascii?Q?LXmQsrPaFHPzpl5y4YIx8v/D4BX9n36iUsAJKRcfM6zzAkc9+cr3RDT0v61N?=
 =?us-ascii?Q?+V47YjtJkhXsXQLAzsS/uDpe6ZCY3/+7EXVg8dbRwA8vOfUjG/0ivH/lVPRT?=
 =?us-ascii?Q?X7mOV2CEOj94SoZHAiurSfs9XCSVB4yksEqvY4dHVmEtY72pBmrHTiH3BwP6?=
 =?us-ascii?Q?bEBfL8IFcZ+R7+TzRUFfvvnzsITAzIsaF3sEUHEpDKc2VYXBa5vSSntiVZDM?=
 =?us-ascii?Q?IOm2aFRDrrjlcYPJ0kLMCPnyTysS3TU2JoQyLlj8EnLw/yU8NxXW/5VgMZBa?=
 =?us-ascii?Q?K895TklEGSNcdkd9vDDGQp3m2IwCJKsY6BlBsltg+hvA2uDOMJe9/P5z3WUe?=
 =?us-ascii?Q?IqnfYi4eqekPSYE+3fi5kJ6YxV6VBgpDUrUx3vhmrnVmz0pl6nAUVffC8CJd?=
 =?us-ascii?Q?5iOS61lT0mN81SDKM6kvaDSwhXzthSanOAhjVbriEpddCGFOgEImVeeJNNNC?=
 =?us-ascii?Q?6kU4DhXNYIjZ0CX4kLk2vTaMaXFJnxUAAXe9zglRuxs2FSL5Ap6g02FyewOR?=
 =?us-ascii?Q?5dXfOagDYopLvOHz4mH3wiL5Amk64h/8ZmEVufXn8QLGOwd/D7a1zeX5XWj6?=
 =?us-ascii?Q?yyV3ZwwVEdZCp2/KEooCZRM1oTv9zh3q1pqC1TofqoKSog9TXpOkaPfzrcBh?=
 =?us-ascii?Q?56F+CoyICiSb9N4nGyYxgohps07Ie6OeSjXpFPLTzWky4TyBZebm4bry5OAS?=
 =?us-ascii?Q?0TMg2pB5TYr6rSxKLyfK7iTrWwUlhbiLuEKJaBu3o5ch8dmHaqzq5RWpR05R?=
 =?us-ascii?Q?QK0+mXcWtCeO8cqrTU2LmTD+on1yttaDpTLbmMtVYiKow1+kcWRXhZFRc8WX?=
 =?us-ascii?Q?197MOjNWA/+q/o8ZPjSJv3Ff1LIsn79IlmLDE9UeXWIDMtYLWfhJtW40wYMR?=
 =?us-ascii?Q?qiuZwLCvbM3RPzSpsKT+Tt/SxYojpnfaB4/Gh477TFicmcadTXumaT5FrFj/?=
 =?us-ascii?Q?M/EEF3rJynApYYks4AgQeM6c3LLrHOenQgJT7X+kGydZx1ipwxHNvdzq12Tt?=
 =?us-ascii?Q?OLFImLFkAWZCgVH+sdpluPEDXFSjXS0Kb1Da/7vF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6428fe5-8b00-4b8a-b089-08daf8a0c4cc
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:37:40.8113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ax+DZpWGdmgZk6O/Af2i7AeXzg2dkmHeG3CG+mZmsP30Q+Y8nX1uUjSQYGdf7YUhbCdm/1R+7uWewBgEBdLvIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5930
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@nvidia.com>

Currently the doorbell function always asks for completion to be generated.

Refactor things such that all existing call sites are untouched and no
branching is added. This is done using inner function which can be invoked
directly in cases completion is not desired (as done in downstream patch).

No functional change here.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index a7799cee9918..a690a90a4c9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -238,10 +238,10 @@ static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e_icosq *sq, u16 size)
 }
 
 static inline void
-mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
-		struct mlx5_wqe_ctrl_seg *ctrl)
+__mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
+		  struct mlx5_wqe_ctrl_seg *ctrl, u8 cq_update)
 {
-	ctrl->fm_ce_se |= MLX5_WQE_CTRL_CQ_UPDATE;
+	ctrl->fm_ce_se |= cq_update;
 	/* ensure wqe is visible to device before updating doorbell record */
 	dma_wmb();
 
@@ -255,6 +255,13 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
 	mlx5_write64((__be32 *)ctrl, uar_map);
 }
 
+static inline void
+mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
+		struct mlx5_wqe_ctrl_seg *ctrl)
+{
+	__mlx5e_notify_hw(wq, pc, uar_map, ctrl, MLX5_WQE_CTRL_CQ_UPDATE);
+}
+
 static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
 {
 	struct mlx5_core_cq *mcq;
-- 
2.31.1

