Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D9A1B1859
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgDTVXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:23:50 -0400
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:52910
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726021AbgDTVXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:23:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCO8BM72H4UnbSo7W/OLS8PXirI7QyBUmq7ELys0Je+N/mGssSVo98dIx1dvms9RUnQWINBhWTLTpoy50Z6ko5Heyxv9v5pEA4e09/aGmRfft6uPuxSlHF1CHQfqgDvlpBNZSMtYI3JUGJHx8KsKIY80z+YY0UPk0fQbyVG6YVRKN+cB4Vc2n/Cg2GJIYUaT+e5c55i2ViSGVNHrz1G6+GWEOdLL15LCO13HDOmQ46mUNb0YMOYZ2mXQhPdMxFtdAMzsiHGCEyn5Nm/U4QrJjGVAKnjGyGDwb4o5CajfBaJrxu/CcfrPcCvSQCIfk1GeB2LemGbQk1QByWLN3V/ZJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7KPhA4IJx1s4mD3KkTVp1DJepRpoZc5sFYbRXGTq24Q=;
 b=Z/vMxnFsIDQt1mNc4GhVRJRA1eK2fZtZTAV5zn1jqSz9WGoPUesFwpIyQ7XEfv/TtorkQgf0Q5hg77/O+VZ3uzL8Siko08OH8t/8eKAjqutdksbQvf4Vwq0ari8Ki0muWcHt88jFdaT+YW0baSlqShx4qnBDNRJjVFSNqTQPRHUGfE528gB9hb4iARfxhDArBVJijk1GIeKORjlZO6CNMsSFGLfHdo+ifQ1oWtF+UhYzRJCtY90/xEzm57mN1Mzb4lsUA/25Nj4b0+Sxr1peEpq/RRfGmVhX+uXKj7pY1sm8D6sph76pcRgsQS7fv+Zf29zU4fNme2hHOR+GS3+RoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7KPhA4IJx1s4mD3KkTVp1DJepRpoZc5sFYbRXGTq24Q=;
 b=SYEHUcC1o81Ldz+mGYQ525nljarXF5NI5Ssl6XkELbB5jtepC64w6OYoVapLtfYdPogi7boYANxYhl2B3GZKGF55uwY2s6LLGbC2RQPUow3kkfcIFd8Me+S6jIpTpeQ7bGoKgF4+ohQrVz0oZMRryqAmCrKih3jTETdy4+qmhxg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6478.eurprd05.prod.outlook.com (2603:10a6:803:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:23:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:23:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/10] net/mlx5e: Set of completion request bit should not clear other adjacent bits
Date:   Mon, 20 Apr 2020 14:22:19 -0700
Message-Id: <20200420212223.41574-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420212223.41574-1-saeedm@mellanox.com>
References: <20200420212223.41574-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:23:08 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7e15c33a-7b04-417f-0cd3-08d7e57106bc
X-MS-TrafficTypeDiagnostic: VI1PR05MB6478:|VI1PR05MB6478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64780C4DD14A0D95074DDF35BED40@VI1PR05MB6478.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(107886003)(6506007)(86362001)(2906002)(186003)(16526019)(26005)(4326008)(5660300002)(36756003)(316002)(1076003)(66556008)(478600001)(956004)(6666004)(66946007)(52116002)(66476007)(6512007)(6486002)(2616005)(54906003)(8676002)(8936002)(81156014)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGu4+9MHedWE70UPcMzcGq3ruKzhi97D5kj0cZQwT/HAN70ihtFwDEf42j1wa+Ve3wKLQ/c7yPE4r5oYebe6B9m/IkasFj8nrOmHDd+oZrZyMr7XI4b7CcBSgLdzuHV0gduB1UY7c9p+TcstoX9bivx/6dhCi2PQ0WTv1FKQdfqZPPL9M3XzUeMOWV0JOPaUq66ZyC32nNRPeC3lwEaIx/MbxKX5nc/vOwBt/HNn+lg6vYOPYXZMG40Kud9JNAYAkKMZ96KJ3mAT65LIhz1q9liz8Eqg0mofluzfWjckwvPrOIFSwUi0vaIHAh2DGWPdbvVcx3Vd9XZ2ROMaoBlUpCdEchZFV1NX/D2mrbYtMwC2LizsCT0X3VCRUcMWiw8huE7FDIcqDftfCjO/D/G0qhMl+0dcmPQ4AmMS80AIpEexhHfAOQAUOsSn9cwg5KNYF3GII5vxpt/fR57KLVXQ80ejeF82p7Vn/FLfZwNLLhtyzmK/66v2OuhxRtmF9Ump
X-MS-Exchange-AntiSpam-MessageData: 8nirhYuBUcjFkMSyzQQ47dqC8DEm1vrYiRLdZ8WApfZW/KYwZmBEMAJuLTcS055xMCzntzMc+wOazZ6/e6m/P5n4rblQoDlybfq+lnaTgnfeHJRxloAlUSAPJU5HfQUFA3vytpenE3Z58aAwKjxXAg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e15c33a-7b04-417f-0cd3-08d7e57106bc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:23:10.9383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y1wHOH/taGI6Mzd0bnWpHjYdFoSKla0WHm7iUtWoiE+wxaHr48oEEzKWiTzzEq1YG7V5kUaLsqyV/qQrnPI22A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

In notify HW (ring doorbell) flow, we set the bit to request a completion
on the TX descriptor.
When doing so, we should not unset other bits in the same byte.
Currently, this does not fix a real issue, as we still don't have a flow
where both MLX5_WQE_CTRL_CQ_UPDATE and any adjacent bit are set together.

Fixes: 542578c67936 ("net/mlx5e: Move helper functions to a new txrx datapath header")
Fixes: 864b2d715300 ("net/mlx5e: Generalize tx helper functions for different SQ types")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index f07b1399744e..9f6967d76053 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -102,7 +102,7 @@ static inline void
 mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
 		struct mlx5_wqe_ctrl_seg *ctrl)
 {
-	ctrl->fm_ce_se = MLX5_WQE_CTRL_CQ_UPDATE;
+	ctrl->fm_ce_se |= MLX5_WQE_CTRL_CQ_UPDATE;
 	/* ensure wqe is visible to device before updating doorbell record */
 	dma_wmb();
 
-- 
2.25.3

