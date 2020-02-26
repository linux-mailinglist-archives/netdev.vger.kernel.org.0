Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF70F16F4E3
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgBZBNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:35 -0500
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:6175
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729945AbgBZBNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmE785mFrWx9dR1/ih/53Iuo91gif7+B2xfT0xDnYj/vRsVSjfeJzEEadpLFFtxrw/FkFO53sCvVDJeZvHOO7nIlgwXDDzcL5pglMDBdXEcTNw1e052yWMWPhbTpDrwzZd88dSVX3towcCDa+4c/uBPZ49e4ksjMkPlXZGbD7gDhUGF67DHFtWor+h1OMz9+npJHCnNwWc/r4vHxR3epV5WHpuRRWuGapK8/gE9XmZpv5vmelnJsWgIhDbyzRdz18NXtYa35E1MkZCXsYsimo7t7LnKgtYdlvPXLxZpAnK9QgXgiYA9cR79JV5CyrKBbl4vsGK0rZqhmxlX6VldtFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAtoh5xKgyyNe1U9v0sGRIruikbJFdK4+wyfvv2w6n8=;
 b=B+Ho3VDy+LoHnJsl8dW02Fa+D48NRYPfGFhT+xc3Be1ZM0JjaePEOJzCtvLmO3dNAjXmy6fZwUbLOqMY7ju+x4Q7v1h+HqNd6P/DwLbriOxitT5tbOCq7aAGHUG9ZFtsaGAnjSmuf1lVjYSRjh/BBJbQ92z8RvwWpc8WQWLLXjVOx/rHbEvMnwMViODaYKntF4WW3SzcAmwJAtUOjilCXcT1OtRQdLSuofEnoMFpv2s/9grFaRacN67xBMFLK+n0CXYPojLS3wkqOqx6uJiEiOJ3H+Ss9C0LAmf0E82uBLo3q630RJkIVKO3ODEFikYy2L4v9BiPtpZMk0lG76tUVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAtoh5xKgyyNe1U9v0sGRIruikbJFdK4+wyfvv2w6n8=;
 b=Yv2n4944E9LaMGH9jTi+5G8Vfy3v9zoEcuwQIfCp6k9TknV0kJc1ZAWr2NseoMboxLo3GVbiEmUYXcyiCq94dtS7sX2hmd8+MgvjdZLIZdbXYTZ1PDzKucbfAmdxHz0wL0AoIxGFIdlXDHP7/PWFOp0LnhjfaH++4+7RmIIkNzw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB7038.eurprd05.prod.outlook.com (10.141.234.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 01:13:29 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/16] net/mlx5e: Allow mlx5e_switch_priv_channels to fail and recover
Date:   Tue, 25 Feb 2020 17:12:38 -0800
Message-Id: <20200226011246.70129-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:27 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 12d30e40-e84e-4620-94e2-08d7ba591696
X-MS-TrafficTypeDiagnostic: VI1PR05MB7038:|VI1PR05MB7038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7038392A62C6A09EB2586A7BBEEA0@VI1PR05MB7038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(81156014)(66556008)(6666004)(4326008)(36756003)(66946007)(1076003)(5660300002)(66476007)(16526019)(6486002)(186003)(8676002)(81166006)(8936002)(54906003)(6512007)(2906002)(2616005)(86362001)(956004)(26005)(52116002)(498600001)(107886003)(6506007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7038;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cdVb5c3sFVj6ArDLYdYtljZiUpLG/vvSNOJGkXK9Gjg81r2EytltjuscJyPLBVQQ1I1FmNTB1YP00png3tx256IYxfhUA670qwNo2UQAjr+9eKjt4IGFq2dm2CP+hb1Z4WRCHdkyCTmayFk+mUPYBVftBAVeh5kOd28OOdcyUgfh5u5/G/eU/wiK8mb7tWMMDxVVldfIy+r00hdKBYN0jkp6+9/PGzZyUkWm+2wsAgIikHhxlLxEf04kRaiHK99wQFI5INBgB7sb++R9W/BUs+VleWH3IUTbDlGP+6lcE921GYzhTlql11bA5/XVjvYzr5E8aM4LwZlD76d9VG1W+C+slmrNA+U8S2/R37fXS30tnr7Zt6p9zVkFpNl8aRhPYsK5+NYYlOYBNB9zkFvB737Fw6e8W8v3VnZ6vZGVJSOis0iWEYQzrcACI6MMmnbA2WT3duZoJKuFu7o19NxFk0EzUK0okDoFQltbdW3BbczyMiGyhutM5pTNVGOzR6DSDW8ZYjlDejhvM3RXb25qh+2XhFSZhCvcuEuaN1hzXw=
X-MS-Exchange-AntiSpam-MessageData: 3y0yZdWg40qJgQaYpd9kHNhuQ97200U51FvKvmyOMQgLSal9dmYN4RNZ2hXxTpmZxpAfoqv7ouYAY3GYrV4rrJXSJf3k0ZFCCUQatvWB4qrqjTJEQEkIaWB3z0l8vIhjLnw22zWQOJfJtJ1s/0r3EQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d30e40-e84e-4620-94e2-08d7ba591696
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:29.2366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFCKZLchFtiHZwuc0gGSnxzjdHxtkRTG1xJkpFbkYpPnnfnH9VeZnXebRDmpH5A17WicRoQMWv2QU3YvFAXOJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Currently mlx5e_switch_priv_channels expects that the preactivate hook
doesn't fail, however, it can fail, because it may set hardware
parameters. This commit addresses this issue and provides a way to
recover from failures of the preactivate hook: the old channels are not
closed until the point where nothing can fail anymore, so in case
preactivate fails, the driver can roll back the old channels and
activate them again.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 34 +++++++++++++++----
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ceeb9faad9ef..0a71fe85d21e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2937,33 +2937,45 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 	mlx5e_deactivate_channels(&priv->channels);
 }
 
-static void mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
-				       struct mlx5e_channels *new_chs,
-				       mlx5e_fp_preactivate preactivate)
+static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
+				      struct mlx5e_channels *new_chs,
+				      mlx5e_fp_preactivate preactivate)
 {
 	struct net_device *netdev = priv->netdev;
+	struct mlx5e_channels old_chs;
 	int carrier_ok;
+	int err = 0;
 
 	carrier_ok = netif_carrier_ok(netdev);
 	netif_carrier_off(netdev);
 
 	mlx5e_deactivate_priv_channels(priv);
-	mlx5e_close_channels(&priv->channels);
 
+	old_chs = priv->channels;
 	priv->channels = *new_chs;
 
 	/* New channels are ready to roll, call the preactivate hook if needed
 	 * to modify HW settings or update kernel parameters.
 	 */
-	if (preactivate)
-		preactivate(priv);
+	if (preactivate) {
+		err = preactivate(priv);
+		if (err) {
+			priv->channels = old_chs;
+			goto out;
+		}
+	}
 
+	mlx5e_close_channels(&old_chs);
 	priv->profile->update_rx(priv);
+
+out:
 	mlx5e_activate_priv_channels(priv);
 
 	/* return carrier back if needed */
 	if (carrier_ok)
 		netif_carrier_on(netdev);
+
+	return err;
 }
 
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
@@ -2976,8 +2988,16 @@ int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	mlx5e_switch_priv_channels(priv, new_chs, preactivate);
+	err = mlx5e_switch_priv_channels(priv, new_chs, preactivate);
+	if (err)
+		goto err_close;
+
 	return 0;
+
+err_close:
+	mlx5e_close_channels(new_chs);
+
+	return err;
 }
 
 int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv)
-- 
2.24.1

