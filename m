Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511EF23135E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgG1UAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:35 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:56865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729136AbgG1UAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTTA8ac/o/2oH4OSFEGOrvLWNZySUG3mnUgiC0pnMINWPPFigvcs0BS9ur8LYj8vDijU9mxo9TdG9rYYoafSvzSxJ5U2p+MsEtbR85STQnnCDd4CWMjYqsjYz1cYTWzTy4JYHHbXOUwmsp5h6ThAyJuRXtiK+/Dpqx1uOK3ultMgMM+TI6zxJgZ+0yWK6K4Nn2SppINTXGkzM4vZU7Xgpb5XZIORT2K2Guysfa9pe1YPPSOgpSqAP06zzlHTF1pbeShPdEpRUkKhfTmt3AwvfLkaX/vGtJ3noymbWkWTwipThOT+AIuDw5+mF6Z3uZzSumBMHLy57HTcHcp1+hiSrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACZeNjH8ov6MHwGPLpRS4RHYgUTvmLXBdaweiNEDfX4=;
 b=DO1cKENKJPQRLSGHCMDOhmEXaAHzw78NjTATGmSf478fcSULHnjHHXjNfaNRhlDS2KuT+z19IVCVhyuedH+XM1OitK2sV9uaAcw0nAl0s0MTV183PVxgzioZF5C2vQNGQ2aXfBC2J0RFqhnmjGoqrxTHYHMHuBtDw7ckejKM7dp50LZTAwRgLF3/bfi50YO0QY78CzshJpjf5pKr+lFJQ4KP4Tpi2socm7SCJ2KGyImKeJPLVnrYMTLdDD7ywk3V63nFBvp9GRmvLdQEuYtI0i6ef7XPTrXWw6a84QWOFQEOBcAnFkbcZZ+2Po/an+80NkCymzcTBaKcqVB1WIISlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACZeNjH8ov6MHwGPLpRS4RHYgUTvmLXBdaweiNEDfX4=;
 b=a0br2zeAqSoGce9Bm8YGiaYINXxIPY0DsEXTuPLsnVFOBQNmcCigZvVgqhAgFDeSgomvpWLp9JkNYYQWAJrCJdGQLOhnQ1kpPtIE+jTtYwbPC+MR14TLHKQqwjSBKhdeU+M62x8lw2gjcWsvVOktqKS+3zyHTD5QWly9ZTKnxQM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:29 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 05/11] net/mlx5e: Fix missing cleanup of ethtool steering during rep rx cleanup
Date:   Tue, 28 Jul 2020 12:59:29 -0700
Message-Id: <20200728195935.155604-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728195935.155604-1-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:26 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 66950c8c-b6ca-4fcb-3396-08d83330dfee
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2592D5C6211C5F66FEB0C703BE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:196;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHpJmD/Ip23jIy0e8HJd2ACGIoencGdexwWIgBM7L0+1PGWTOsrkTAYH0Z4jP7vy+fZVZrXN664PnbgIScBgZ2SF32pKo3PpUIEF02qEUm5Z+12K3CsqYPUSzDGA9mCfOuh79TqhIQOFFXXDZ7CxO5NVix2qDel8PYIoet049fTxGU/Zggf5VHudMGuQgVTfz2FpOrI0bX2dnTNWSoI8rXuG4cf0r4BPPuK2c+bqYaFaktPP3sIddySFy01JkLSrgiKL6ePIl9wMS68qjzGunKyQJJBYWe2Y66XWXOkqzl5GG3VVcK+Es+kqPc2W0Qi8JEN2FXghqdaDmVTy0h9q8qWjvG5mIj7v3DcajAXgXSod7e9n9J8wT0BXcHkP9+TO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zf81MW3spAk9CNUTT0An1Gsmk0u9z/877gO5ae3hjHPafHmdV/903ShK2Y4zJ5XkEMR0ID0xnOPPuAsmgpQ6NbdxuaGMlWtytubrrIT7CI0Rtugp5xa6dUNZ6U+4aAgzJNvagm7RTsVB21anin9B2R5BbGoyD2e6UgDj3iKKGgVFgKVq+hMDn2svyNzNvWC3IyXalk94ewqGfQNCDCaSyI0ZrUoPi/Zwq3lVYY1zT/LibIIazW2s6p93EIUmz5wzv7joC99JNiFDVbKOsenLdp02+BMVWsaHuJn1RBzMCdHYUssHfQ51oCHHIcBnNITDBfmIH0MKijLMD+dgC+UVS13S78ijorb6Pqe75aNCzQjsQGgOMQDsgdPK/hQ8qsEM3Zp1YZ3zcfRu+9rvbhWBkOO7/dokHBca6Y0zRE2WXbkJGkN8MnNoH1Ka0xjI/YkG439L95I/Zj5C3xWdkjeQqPLPsaWGTkKD+1smMLcZJO0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66950c8c-b6ca-4fcb-3396-08d83330dfee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:28.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Qb2mZDL5MZdKDgQrqURtA7+f3ctHmJBzXCLkfpePyS3fn6+RTpZHciOJ7c3iGfX3MroM7S6N30qf78YKnrYBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@mellanox.com>

The cited commit add initialization of ethtool steering during
representor rx initializations without cleaning it up in representor
rx cleanup, this may cause for stale ethtool flows to remain after
moving back from switchdev mode to legacy mode.

Fixed by calling ethtool steering cleanup during rep rx cleanup.

Fixes: 6783e8b29f63 ("net/mlx5e: Init ethtool steering for representors")
Signed-off-by: Maor Dickman <maord@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 006807e04eda3..8c294ab43f908 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -936,6 +936,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 {
+	mlx5e_ethtool_cleanup_steering(priv);
 	rep_vport_rx_rule_destroy(priv);
 	mlx5e_destroy_rep_root_ft(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-- 
2.26.2

