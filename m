Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EAE6E4781
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjDQMVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjDQMVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:21:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C3C7296
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mso4E8VMgf0BRNSkv0w9VNTTbPrBQ8+naopTLAB87KIjTvx9cIs7BJ0tEdw308ilRKZHhqCjNj2DTlYKdVT77nQPRxwrpJ0bkoYDYmn6NViSOg1jKqW9ZpSxTeUT64Gjya+gBS4ETxcb6DvT1grQZkZPJ+cMZIbEo4xp9mEsmFNAKUKE/FiNUYZfdQoIPxq6WUuUqB6uECVd/ZyvE7I99lZeteC1T04xN1hYzkJFUszr9I2HtLY4KIBkcbDPNQmnMVg3zyHPEjCRR+1zDEL04Uupfp7VBzhklZvQJVgtEwWHQFUMHsihJe+9nvt41jFhkxh1WzWq4R5oJm0gKdsuhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46N5RQSX6XSpSsxEhLu4uWtIlFMmJWvWri0P8BIvxQ0=;
 b=UAgb3HPbmsUiXksQuR7/eCxxEHu85l06sd3Jta7udkksvaMhc+NLIRZXzDm+23UlntP9SGU/TDH+KMKYPNUVG2AIK8Esbw0JHi7X4M4SSrf0ubSBVumjNL58F0Fx6tdC5qBcix7mdydWLc829jxssqQ9ajGMNCiANEjgLfSMbk9ryQqqj/hOdEibPhB68ud+pxsWdX6goq78PGY8YB34pgIa/M4InmTq4R5CejSsSPNjZziKaBd9yn9m3lPFXym5lbuBdlrAhHOAv83FiJR7fLXRvHB7JFoky53jMjUhkUBXW7q38X/l6MprrqPQ3epzQnjeMhl4m/34QMsPkQsDTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46N5RQSX6XSpSsxEhLu4uWtIlFMmJWvWri0P8BIvxQ0=;
 b=NiHltqXxww60dl8OAPGM0mR3HEAU2GW/EeiVB5D0j6lnb0NJTwFtXwEDEll1a4aYQO2xFjFFmwqlL0ak/1SJnEoh8dzuacWVtscQCVzlNt4W8YP+E322US97T0WCM9VHQ3BZEwDk9tVYyQd6EAdzUIZfSeX/fwIVVE5VpFyaxOGRXPWvOVHDs7VtQ3idFw6gSV2QK9767/eEGOqqiixaXj936oXkQLS6x/KKlwguox/CrpcxCJGLmgMQTHRjdwkFh2HrFKAU7dDQlOXdMzYIrJNHk5Al2EYh/6+sPftgOx7QZrFWUNWml5q0gw2Zfr8n1AgE7brE00e77P6XLD69mQ==
Received: from BN0PR07CA0027.namprd07.prod.outlook.com (2603:10b6:408:141::29)
 by MN0PR12MB6055.namprd12.prod.outlook.com (2603:10b6:208:3cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:20:32 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::73) by BN0PR07CA0027.outlook.office365.com
 (2603:10b6:408:141::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.17 via Frontend Transport; Mon, 17 Apr 2023 12:20:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:13 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:13 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:10 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 07/15] net/mlx5e: XDP, Improve Striding RQ check with XDP
Date:   Mon, 17 Apr 2023 15:18:55 +0300
Message-ID: <20230417121903.46218-8-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT008:EE_|MN0PR12MB6055:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ec7ca7c-ee0f-4e74-de92-08db3f3e2364
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WTTDHhMoi+y0owf42ppsqAOgUQ2UooDJgeyA0XDuPUTGB7Im2l4FO10avfpj5GrXC2uELxkQUoPorrOJ+J7IDU/PcmgxFS7ZEmxdNywNTxfFftUA05I2b85fiuqww3/XvfPrV67kxu2H+vZUIWEqbKQ7NY2RccvmMaWoavNTNbA7vX6p9PPrEPL8VfdFLH+NMVBNAFx7uFmDRJHK4DgLw4L1mQwGZI2M9CBa3QX/5lrCnKl95bP6L/oygXf2eZIfWt1LT4RIzH1R/yzev4vN3m40fzHzVc7/fSYEphmfwzcuJc1dyyn1BwcNAt+L6MwXaxUTbW7fDBlorJ+rDZOO39IfKLy9shJ1Seq2v8S2HmyDSynt6aM0HbouIUsZJkAcx1RX4i2z0IPhoOM8F1P5F0ziDIvklcX7Qoq1VgQZiqYShVovPHvsCkMCCPJdjor/NGQk1WK5c2fsNqpZRcfNIEUX1hasjwVQwIu4lXz9osg3TR792dU3WQuwKi1VGdKY8co6ptE5Dz/JzYpSL33eiPdlf6u9tajHRWNBaevTKuIwGh7CrvnabPBUAPKQx1irBYRWOzAv8gbaXhGSj0znzQ7pRC4CYGEpqBjhxIRVfr4U05pyGSQmjrrjNeWLsVkwQHu9xdHPnjLWFQvi+oxOb6h412YTI+tmQHhs0c8emP8O2jxjrvpnQSSJnYWGNTdnXUJrNsNOGuRpOl024UWNsj0kYKCP8ndr4uCGzAlsgz5QyMqbroiPuSnbaR+HOf6n
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199021)(46966006)(36840700001)(478600001)(6666004)(34020700004)(8936002)(8676002)(316002)(41300700001)(82740400003)(4326008)(70586007)(40480700001)(70206006)(54906003)(7636003)(110136005)(356005)(186003)(107886003)(2906002)(36756003)(1076003)(26005)(426003)(336012)(86362001)(83380400001)(47076005)(82310400005)(2616005)(36860700001)(5660300002)(7696005)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:31.5361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec7ca7c-ee0f-4e74-de92-08db3f3e2364
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6055
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Non-linear mem scheme of Striding RQ does not yet support XDP at this
point. Take the check where it belongs, inside the params validation
function mlx5e_params_validate_xdp().

Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 23 ++++++++-----------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ccf7bb136f50..faae443770bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4261,8 +4261,16 @@ static bool mlx5e_params_validate_xdp(struct net_device *netdev,
 	/* No XSK params: AF_XDP can't be enabled yet at the point of setting
 	 * the XDP program.
 	 */
-	is_linear = mlx5e_rx_is_linear_skb(mdev, params, NULL);
+	is_linear = params->rq_wq_type == MLX5_WQ_TYPE_CYCLIC ?
+		mlx5e_rx_is_linear_skb(mdev, params, NULL) :
+		mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL);
 
+	/* XDP affects striding RQ parameters. Block XDP if striding RQ won't be
+	 * supported with the new parameters: if PAGE_SIZE is bigger than
+	 * MLX5_MPWQE_LOG_STRIDE_SZ_MAX, striding RQ can't be used, even though
+	 * the MTU is small enough for the linear mode, because XDP uses strides
+	 * of PAGE_SIZE on regular RQs.
+	 */
 	if (!is_linear && params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
 		netdev_warn(netdev, "XDP is not allowed with striding RQ and MTU(%d) > %d\n",
 			    params->sw_mtu,
@@ -4817,19 +4825,6 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	new_params = priv->channels.params;
 	new_params.xdp_prog = prog;
 
-	/* XDP affects striding RQ parameters. Block XDP if striding RQ won't be
-	 * supported with the new parameters: if PAGE_SIZE is bigger than
-	 * MLX5_MPWQE_LOG_STRIDE_SZ_MAX, striding RQ can't be used, even though
-	 * the MTU is small enough for the linear mode, because XDP uses strides
-	 * of PAGE_SIZE on regular RQs.
-	 */
-	if (reset && MLX5E_GET_PFLAG(&new_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
-		/* Checking for regular RQs here; XSK RQs were checked on XSK bind. */
-		err = mlx5e_mpwrq_validate_regular(priv->mdev, &new_params);
-		if (err)
-			goto unlock;
-	}
-
 	old_prog = priv->channels.params.xdp_prog;
 
 	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, reset);
-- 
2.34.1

