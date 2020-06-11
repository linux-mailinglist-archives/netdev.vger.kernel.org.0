Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F2E1F709A
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgFKWsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:48:12 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgFKWsK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:48:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkJsot+HDJ6kA8KCXhZ6XgCzi5zI7ZtTToEnOtBPiCzNVEKkeE3D9/JaWGDsmzAlFqPSTtsbxKgeWMvHxzn1AY6r985X+f018JWrRnSyG4MgmYifMHGw4Yq8FN/9lcIzAEh3Kyu8GTNatiRl/zUEUzlrrmdGQSS3XWyYWjR1/r5sZrd1BLeA3z/gutTebTdp6G28NJO74GoDwjs5NpaNKYb4SHD7abAdn0JhAYthiUuByKqAg9sP4uARlwC7Egk+3l+2Z23IPPP7UmIb5IvRdLMvLbwnJk9bk2xlwCwQHWnKG5oM83fPD6RBbupIP0nzpOJ1VyWM970ROzXyaQZ93w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIq0W/PnAZIi869tPmDsIxtj5H8MskytOaz/voqSNAc=;
 b=kzGRNoPUhKywnCjyrVuEDh9Iho1ubCWlj679QHAjIL0XTdyDLaZGqPMO7eNLzj+M1F/WA3f0mSiDtxf69Zs93xno7Nlkz/eN0FmLVMlMSdl6LRigpdeF9uwCsRgO4aLtK+hDrXzp4xbgdeRR26U9piWypfP2KvxrCaqLnHruTh4fghgAt4+rTZoVR9JUl6p1jGudFgixI355veu5j9dVheLE2+IXtyMZmDZt/m3Oa22DK/kBAchaZJ1PTadP1uSMahdWH7ZL6QqistYgxROCsHqP8UHNk14+HRgKielnO/7TAj5Kz1x0Qk/52TgYqCnOg5GFMz1B6CWotmDaBrv54w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIq0W/PnAZIi869tPmDsIxtj5H8MskytOaz/voqSNAc=;
 b=r108NiydnkmfMFUpDJ/LOWV8TPr6PPoHQUFaty327iaNN9v2OSECYsdiBHJPBWkJtYIT7a9PIzOpRAJOJzgSQodNoGo6k8J7LbulhmIkjMVHMSTgXxMRTDnzXOc+0lXoxIgF/v6+LQEiZGnYuJ8R5gz9CnVfEgFGPukrlyJkBWQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:48:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:48:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 10/10] net/mlx5: E-Switch, Fix some error pointer dereferences
Date:   Thu, 11 Jun 2020 15:47:08 -0700
Message-Id: <20200611224708.235014-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611224708.235014-1-saeedm@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2616f3ba-6844-41b5-d8f5-08d80e597d92
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4464AA19F227C4EDC1F336D3BE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQ3o9lYDFcsIFDWzDJ4KIK40znIfB8fqwKyYuCqW2LFQyb4rbFvBFtZnEGzCeqAFobYH3kqKLxRpXM0CiK2nB299dRhC4vf/klEMEC3uFzMZvkrBTs8WNNarEVW13BOIBquBP1fMbnp8wtcAVzD3g6FVP+h19zTUIMwc8rls64PFN+BDEiYAbpT8kjg+doMNV+udjWGgtnuxRpnmqPosFlTmseHWXRNcQAYOFC6psE0ctJeORcf4RqQKGgVGPQh6cu+J9CuayImizNCPcH0K1pdGzsaSrjQAKjjqFlfFG0y9Q6BF//EH+wuXIgoOcK8DlozwaauKpToEq97u8Xpgz0AobSp8WT2gZOaGS+RpyvgZ/28rRkGv5+lOOoCMaL2q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(54906003)(1076003)(6506007)(36756003)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lhtF4NtBb5rEbyr7UN2O8fwbWKfhQX3xON1wBWvgG7Gxnlflxpsv/p+Xw7/6vY4topwKjzBiUBwd9+ULhdEliy0JchdgpZis5R9hq4V2YOMeD5Qru39rTLCO4VwrUSHsBn3dXA+PBJ8YN0bRITOaVKSUszV5m2r8IEvpJGKKTVHfBaSQdLLXLMRmdG5gLoCpcdOsfS/NLlH/gSffrXuwjfcAgZQ1Xz31Do/xZuGbxi0Iug4RSzFA3DInXyEXJjyoWhYmhpJ4XavQgvorruS90ShBrm9tL0xl/TFdQiuJ2dSLQ1Z0Uu+eO5Jvgte7G4o8LGKieTSqSKZ/rnP/BQNUHKNNEKP37PAf8DwDerU6e+aQh3GqLyUIzjPQSUccEYq8HihC66cQ17bsmRhdtwcz/E9ouoXSfYnwP0gcdvEenYOetb7G8lbfhLyENznLWyvX35A0BYQQp0pXVJSoVapPVNHHQY0ltWugtuAbYwR7gcI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2616f3ba-6844-41b5-d8f5-08d80e597d92
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:48:00.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YvlZcRnFZkfviQBwEe+y3/XTksQ25Aqh2e02p/fBKDgHtPuk5F5qEwdcqmWp/ofdIpraU8XyYma+hs307fdtFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

We can't leave "counter" set to an error pointer.  Otherwise either it
will lead to an error pointer dereference later in the function or it
leads to an error pointer dereference when we call mlx5_fc_destroy().

Fixes: 07bab9502641d ("net/mlx5: E-Switch, Refactor eswitch ingress acl codes")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c  | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index 9bda4fe2eafa7..5dc335e621c57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -162,10 +162,12 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 
 	if (MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
 		counter = mlx5_fc_create(esw->dev, false);
-		if (IS_ERR(counter))
+		if (IS_ERR(counter)) {
 			esw_warn(esw->dev,
 				 "vport[%d] configure ingress drop rule counter failed\n",
 				 vport->vport);
+			counter = NULL;
+		}
 		vport->ingress.legacy.drop_counter = counter;
 	}
 
@@ -272,7 +274,7 @@ void esw_acl_ingress_lgcy_cleanup(struct mlx5_eswitch *esw,
 	esw_acl_ingress_table_destroy(vport);
 
 clean_drop_counter:
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.drop_counter)) {
+	if (vport->ingress.legacy.drop_counter) {
 		mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
 		vport->ingress.legacy.drop_counter = NULL;
 	}
-- 
2.26.2

