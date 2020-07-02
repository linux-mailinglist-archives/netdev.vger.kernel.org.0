Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6EA212F70
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgGBWVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:21:01 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:28862
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726443AbgGBWVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:21:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhGzMmWtnP8r/cKi5DmdT9thZmegyEmXngDEPNDowkufHNbvwU/pakQOkzWkg09LEbPnEIIrLHCG6DTaJZrF65nJJBYdOUEW6q/+V3qzYah9Ax9tX7dCyYxrBOo52G1LSeloejMh4vT2sMR/OeZx8JfZJTugs8z+ksdB2yTfv1bbkwSLjrpMcjmWAFXvdKU+M8JWFNxImeZ7khvVLP/+BBafq5zwLpQjOn3m520UNqjRBzZM1+cmZvl7z7CzJhH6QzUTwp46pvVc/AZ3ZHo1PQ8i++JUH8pJ7cXsCldpY26t5DQq7N32RSf2g9jO2NPyPzgJlZ9zWbmeoQUWSffs/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM25lvVcxA1hEKjncD28gHN/pFQAxu02hJYlIvh6Q2Q=;
 b=K6iftwtlNDvVU6/MLOoFwVzbZZ4OB/XYFLdFsCWN+Z8bsSfLMH9y4+CKBKArNL8Z6KY3iWydLJdKf1R3NRusd6yGspNyedAEKVf/3KiybVoqoceB4/fKeedwjOM0OsoeIyS0YLoDnrpWBbC0EcjIAbs0fA+hTtGcIOwELKbXD8rtPbs5P7W+bXBKoFiKx5n9xnXkF1nsKkTCSZoV8Sjwlk/n1P9g/otMqotrbfyb/g3WTvtANmvlu++G0wK+Q+PC0ST8EiMZybybQf3JFkrcoOAIxt2ov5k0kDAbt7zfh7IZ4Qy968JLC8c2LBLzgtK0nHhuzQW13WNf6L/ZS/w0Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GM25lvVcxA1hEKjncD28gHN/pFQAxu02hJYlIvh6Q2Q=;
 b=aGfE4qDmfT+Inxoq8xtI8lakLzueH75W1hrTiAShexbhv//MoSTzAjCnCXak0CXTNu3N7sE3gVVB5dm2lE5htV2NBTB1/2alTg4Mxs41CRW6y8kkdIdNKWVkDfC21vnYB961V8OV8NdtEtgpdLA8FmY3+8VdpVu3x5YDixw6P5o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 22:20:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Thu, 2 Jul 2020
 22:20:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 07/11] net/mlx5e: Fix VXLAN configuration restore after function reload
Date:   Thu,  2 Jul 2020 15:19:19 -0700
Message-Id: <20200702221923.650779-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702221923.650779-1-saeedm@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:1d0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 22:20:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b699428-ac44-43d2-b9b0-08d81ed62a88
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB610982A9FA2D3521F41D2F44BE6D0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:207;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KC9We6UODKQRQqX2GQJH4ArViE684GD+6W3J/Qc/CTE/nsfgaU+jlqL9ioljLLpYF4sMgI6Wja+a1DiNhNIN8Ih+No7TL2gBUxTuAbIcLMzGNujlQKgUYUTDke1/3dq07G0dQ2Zwz0COdVOuoD3cRZjmDx53fIfgPdgitt73FIlFD/6yb+xs1KSCbjBZJYH6kR4gGH7uW6dQeA6Xbgon7Wm4lQnzulv+KtspopW02mttAwd7HjDP/qFtF8uC9mttbNIPDoHHm6wWPZd+RXh6S6dWZ3xRP+0tzg5hlDz12yTIcsIkFRPm5bWkfd5sxAmvCUU+atRpkmRVMAjnyrx/aFlcedZ6talywRGnjhU9/uZuXFinQBccU/1afLKB158v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(26005)(2616005)(316002)(956004)(6666004)(5660300002)(8936002)(86362001)(110136005)(186003)(16526019)(107886003)(83380400001)(4326008)(66946007)(54906003)(8676002)(6506007)(6486002)(1076003)(36756003)(52116002)(6512007)(66476007)(2906002)(66556008)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: StRjVWKuzfYYjsr3thQ+tXfYnmmCJkJVooVZOteUBNGBeQx0rrLsS0r7VHOrcsIRBXYLhdKmLV89o2ROKdmCHz3ThAhzeebct0YQhTcBNqmuYgW4U+XyRXZF9UYlyYznozECYIGh6efJE8O+52K9cDmJLm9QzfE+McON3eZeoh9el3RmePTavbMXu1/2tMX3cRmlTZRzLbedBcJGC6A8DacFC9G7ax3sZzyoL65h6ML+Qp38A6wdwnhpyUEsoLn2OWJDEQlof8J+admLr13jAoGhdvbAOEK0lI/54wmSjeQgsBvd16iA8TU/x4zSUXFWjlPgSHYjzzIp/ISGt9tYYNQ1WR5iEevQyU/P2nvokRl/NT8lwRJeZGAZUqEAJ2jiSyMJqUTqZ9wigMxqyKB+wJA0Vjj8bq90Hfv0IlmAx65R2jKa4j0MZPMw70RE9ynf91k4Oe996Qyyiu6SLo4d3cBDJsF+O0o/ZXltO+Qyels=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b699428-ac44-43d2-b9b0-08d81ed62a88
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 22:20:46.0532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXWcZKMAf7IWNoYKNR2WIohX34xHNCRlv27mYijIerORwpPMiqX2a77xCi+1IR0xDp5WYZa8Zbl+1wmIRzT4/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When detaching netdev, remove vxlan port configuration using
udp_tunnel_drop_rx_info. During function reload, configuration will be
restored using udp_tunnel_get_rx_info. This ensures sync between
firmware and driver. Use udp_tunnel_get_rx_info even if its physical
interface is down.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ee4cc723d225..3193b0e50d2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3104,9 +3104,6 @@ int mlx5e_open(struct net_device *netdev)
 		mlx5_set_port_admin_status(priv->mdev, MLX5_PORT_UP);
 	mutex_unlock(&priv->state_lock);
 
-	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
-		udp_tunnel_get_rx_info(netdev);
-
 	return err;
 }
 
@@ -5196,6 +5193,8 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(netdev))
 		mlx5e_open(netdev);
+	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
+		udp_tunnel_get_rx_info(netdev);
 	netif_device_attach(netdev);
 	rtnl_unlock();
 }
@@ -5210,6 +5209,8 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(priv->netdev))
 		mlx5e_close(priv->netdev);
+	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
+		udp_tunnel_drop_rx_info(priv->netdev);
 	netif_device_detach(priv->netdev);
 	rtnl_unlock();
 
-- 
2.26.2

