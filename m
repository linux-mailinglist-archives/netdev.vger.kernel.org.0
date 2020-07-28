Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53343231354
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgG1UAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:19 -0400
Received: from mail-eopbgr00069.outbound.protection.outlook.com ([40.107.0.69]:51166
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728527AbgG1UAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dvg8l2tHLlhynYRxPeJecECRz4VRETbzXUaLxGUS3YtDWztjTP0Ldl3WTQC5wIwZ60wuhpQ9QLk/Zrwd2iCMJWqpwGiUCevOkZZ5UynwTKNoVtrs14RU+SfxpJ7CCk9Z9mgIeOEyz/w9ztALCHb3Gu5JSoUv/5qlvIc4AiU/3whLg4jPe3D5yV+NKWHGgip2gyF2UdICjlg4sYSGR46pFeca8mO7SLIru7tJOPropKW8Rp6XBDcax1vwqoGGMuqpljDMtS6lO98Qkvsr7NkYDL8RBm/h2dt+QUktJ7zHLcwB7H4NiEdKijbBzYSgZrL3zIlQBP0gmmSq43ghn9Ztug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXrl47i8PA3EGMT5i4vfMZ74q6UW+TArcbHtIexVBKE=;
 b=N+lKLpCW9Sxhj62xOFfWFxD2BSEo9X0KPNlrDK+k87/PYG/qtrhTNUWWEX8bh2ID7mIkzPLCfxdzEA5pQG8+73jBprxmlv33PmYQYE7s3e4AED5ErOcAsGsoba8uqQi0w6zNNmMalBwtGlwAyHJ9IgP2kl45eye/UdyJjLZhfBwARAmLqrv2lwSYDUgK/OaqgodA/e43GX/f2JwfksxxNftgmwM5/PExoKtq/9fLCapwCjQiNXQByiov2jM0ln+2cHCxYP6rKe3MC/hlT6MSHqZzGcw8UH/oOPtalwpSxVazrajRVfyqLof+Z9oDjksE6TT8fu9qN+0I3PJyBoES6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXrl47i8PA3EGMT5i4vfMZ74q6UW+TArcbHtIexVBKE=;
 b=Ro53VOfuKVQ1dqgWhAuaBjJVrqjbUcdDX22yHkW67VmzCtyJGWCYI0KC7Gs7pyNAtuzf7OxYVrd8oEnGIvUcIcTGjZ7nFU+JUl9tg/zlTatGp2gLrvkXM1SNuBKm17/tqATotJic82zjzuuKRzmb+WxBB/K90PsJ8CSAg47FUHU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 02/11] net/mlx5: E-switch, Destroy TSAR after reload interface
Date:   Tue, 28 Jul 2020 12:59:26 -0700
Message-Id: <20200728195935.155604-3-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:10 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc86fc73-91fa-4c07-c509-08d83330d690
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB25925E08225C9B7A7122165EBE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A9ZGzD2d76IVL4F5uW98AWNjhhOTN/EWYEs8uvLHPzJ52OzkzlOZ0btAklvIkFcc9oBUtqiyU9gfmk5TpOYZKNqhxx9mCm2EQq9LKWx1TNGvVGloZtSAh2oCFANNudoR6r2rD9V3q3KsS7Eoi2+B+gk2div+gAlgQoqLBgcyfh115g4dd7XWkJDsrgH17Mhwhd5x6f6+cN77m3+3bEbkxeUTcjrxE6m3Y3EAESzBax7BlVdrWE1FJqSzBo9XwWwp4nBrG7AYIw6GLvsS7Y8zpYjLKE+HXhbaOS+N7/OaTa9CX0N93xjsSS7Pv+7lC8UItmD6S/uIcYmAdsSp1+DFHclPPBIFsOWW1JipdBwHwCTr2GbZqgRsp+Y3L224Z65E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(6666004)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mgPxZoWMJRuav88qqZ2yrBbV2N7BkkAfCGIwZ/Wkw4kYJjH7PmoQIw+MaU1CXb+7WRsxPGntBSV5C8+SwkkNNFCwTHDH0Z+PQ1AwL8RMkCAu1sw1R/W37mIrTovPOzCWCSRgxpFpHxnAiiYxEKWOOOC9oH8VZhKIDywKn5h4ri6qwzJvzaM/cvJUtPP+6nGDV7onkDHxFril9N02iqUT70K8J2eNrTOhgmH+tYEnRE2n/cSr312ulBrQLhoQnGcgwYYO//gbfw3cKEDuJT5/zwPKak9AwiOv/T+96xT6j8/P73JxsenhhG6y+e5vViz80Q+jd/5fcIb/Ic7Y9/LYa6PfArMZme6IuSB4r9BtM57wT7WWS1OW5FMx81aoJOuoVF9Lkl8jgnniQpW482swG/36AhtLV6u5Z23+te8Lsgi30gKPSkopjoHDHwh5S9ZrrNbqrt3wlQZyQqJqx5NWynMaF3AVmVRP3EBLGVSFHHs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc86fc73-91fa-4c07-c509-08d83330d690
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:13.7174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KbhcwngeR1JSG6fBhlLMC2WRPW+s33njq6z1nxUKFfjV4+XJLCiRbatSC6+DSDKSWQcRPtTRBO4i7XID3uIONw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

When eswitch offloads is enabled, TSAR is created before reloading
the interfaces.
However when eswitch offloads mode is disabled, TSAR is disabled before
reloading the interfaces.

To keep the eswitch enable/disable sequence as mirror, destroy TSAR
after reloading the interfaces.

Fixes: 1bd27b11c1df ("net/mlx5: Introduce E-switch QoS management")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9701f0f8be50b..d9376627584e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1653,8 +1653,6 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 	else if (esw->mode == MLX5_ESWITCH_OFFLOADS)
 		esw_offloads_disable(esw);
 
-	esw_destroy_tsar(esw);
-
 	old_mode = esw->mode;
 	esw->mode = MLX5_ESWITCH_NONE;
 
@@ -1664,6 +1662,8 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_ETH);
 	}
+	esw_destroy_tsar(esw);
+
 	if (clear_vf)
 		mlx5_eswitch_clear_vf_vports_info(esw);
 }
-- 
2.26.2

