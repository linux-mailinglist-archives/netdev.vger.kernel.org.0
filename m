Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C626F2306C2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgG1Jow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:44:52 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:30084
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728197AbgG1Jov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:44:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9kdh7YR4476g+H9Vx8kCyXDJzh3gXNTqyYXoEtxfqQRKWQqcYi+UQ/4Xi2RzvCfdJfBiENKkNchVYQ66nt3e121EK8hCN4IfwKV8F9mhB9NZt5LOWG2sYC059v2Bt6UjQitwJg1TIlu+DxLgGhMXcTPykxbU80SMu9LPxBmqqK70AA0D+MW/SUhtX/qugH1mc2lLdv9QBlFfO6BuwysP2GXRaKKK9Al6HKqx167NWzp8iRB4S9rXsAWxUCzypUVXUBEE8bgI1WVz1xuBgpWeEA+M6g/Q6JzQp47rEtdlJq7VgX+K+/Oiz5LVtVIXxBb1qVnb+W/UlGe2inE3OhUwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGFiD3UraB/Zk0dzzL/l/QwgNr/sF6jLAiXxoUrYoXk=;
 b=Pyyiq6QKIw8JlydWWT5bB2a3JTew8Sjn1Hz5j/o4QHd3u0HOsS9JQQZUJJ2XB+gJUHIodt4TZ2jwAjTOjxBIsZKG6qHj+3Ac/jviFPEIic9opTKZgarS/uUMHmbNcK5mJwh85Eurug9fMGGD6umQ+w1HtDUQRVJvQ279/zlk8RSiJ++EgkeK8zSRdQtJx523LoZyfhjy2d40Ht0H7IZXk0IKjv+GCWWhvFQYGoxuKA354FrlEl0xE2iEm0opsnvxZkJLuGGWgHNv6v71PpYkfbeDL/n7iD6OCheN2fZPLeqgvQpeVrGtQjB+L75n8UKksWbw9iFeMNmlG2YZ/yDjRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGFiD3UraB/Zk0dzzL/l/QwgNr/sF6jLAiXxoUrYoXk=;
 b=B6Z+ePm50sZX42S2KSNjpiwV/FGlt8Rb14L2oToSrl2gPYrHlPNEesN06z3zyuBB3S2dylIZ7w/1LPilOE97RPJ09cvKVtB4yIlPf7Viwj6tIJHACW8WYfjkxde2X+XBZYc2sxEbR2JxncPHZamUdE0BndpmgSanlMcR5x1TL3I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/13] net/mlx5: E-switch, Use eswitch total_vports
Date:   Tue, 28 Jul 2020 02:44:03 -0700
Message-Id: <20200728094411.116386-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:41 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1b2dff3-5dde-4e1f-1fe0-08d832dadada
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7117ABC007B5E7B41FBACE61BE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1UYf2Z8nmEcWhJGYlBnuATM++sg8Wz1v+L5Zqvxu9J4sWZPBhtbf7PYIfm3LpAXnNi7swjOuoSJd9hp6Frb1IwSkWFbJhQasrofAhaWR/3mwWWPGozwNw5FXERdB8mYyNnn2HzF9/nVnFXKcQZju2rijCGk4gQiRDzYmF+a/2JLdqdcXxnMkrFpdIlWnQoYrhWrj+owNS+F08WQqBZPzdS5mRZQ5h6lTTD3q3MzYdC6EBNB0AeKJpn9/+PD+wFMwN2is2yn3Wrp4DCtvMxeU2kM4mDu1E8HXWu9z3SvG4LbKNQK62fLiYwEfLQ6P1MBUNXMhj1EOXUjX7wxxRbeqtEI4ZHUp4GuHLYwwRrSmiIEALHrmVIbnv5tW5L0kK3mF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EFJWTcB4sc/P1tqEzWpGiqv21ntOYuepKUTB84fYZzruSZdoSnlNW22urALvHZwvFseeVl5kPXuRtgBiSHobmtGzb8R8yJv56GxOoiRp4xOR/poA+b+XeE6ZP+D9wcX4hRvehYhMG7L0iMnlrxXj3fbAWkh/Xq9YUFqpSr5O/aTfO0zGcJxU4t+P9/0OvNSLLpX4+pSAHfHTZeoEDH4x3nhucLmy9SVP7LZ/dY5iEYSPsxrRPMbYe6floHIbEU8A3c7lyey9T9dNhPUGd/3gJ+xV2WOGoS4eJ/8V1xKVERvW87ALJS4XS4We0EWq+2MFHHy1uXPWvjzht6O54wZC7NaO9Sadyttgg23UC3y0/WKZNj6qvy1B+YE21+ZVczbavLymV5yRM2JoN9i+Si0Y6LdrbfisFcsCwWTj2qqiGXfNe6WNB/RIdmmYMygvuw+OxyLxsGzYiWCfCHZeTEIIsSS7JqyiHQcKTkq+yiYYyiQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b2dff3-5dde-4e1f-1fe0-08d832dadada
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:44.1553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BosBDxu1QKTC8OMumux2qb4MPI5x7sCrEaLIKGsJpZcqdY9qd/pp4yJzn1jToSTSKT9q5tpQmVTuWrGOUUMtOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Currently steering table and rx group initialization helper
routines works on the total_vports passed as input parameter.

Both eswitch helpers work on the mlx5_eswitch and thereby have access
to esw->total_vports. Hence use it directly instead of passing it
via function input arguments.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 6097f9aac938f..54de53daf1c02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1310,7 +1310,7 @@ static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 				     MLX5_FLOW_STEERING_MODE_DMFS);
 }
 
-static int esw_create_offloads_table(struct mlx5_eswitch *esw, int nvports)
+static int esw_create_offloads_table(struct mlx5_eswitch *esw)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_core_dev *dev = esw->dev;
@@ -1324,7 +1324,7 @@ static int esw_create_offloads_table(struct mlx5_eswitch *esw, int nvports)
 		return -EOPNOTSUPP;
 	}
 
-	ft_attr.max_fte = nvports + MLX5_ESW_MISS_FLOWS;
+	ft_attr.max_fte = esw->total_vports + MLX5_ESW_MISS_FLOWS;
 	ft_attr.prio = 1;
 
 	ft_offloads = mlx5_create_flow_table(ns, &ft_attr);
@@ -1345,14 +1345,15 @@ static void esw_destroy_offloads_table(struct mlx5_eswitch *esw)
 	mlx5_destroy_flow_table(offloads->ft_offloads);
 }
 
-static int esw_create_vport_rx_group(struct mlx5_eswitch *esw, int nvports)
+static int esw_create_vport_rx_group(struct mlx5_eswitch *esw)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *g;
 	u32 *flow_group_in;
+	int nvports;
 	int err = 0;
 
-	nvports = nvports + MLX5_ESW_MISS_FLOWS;
+	nvports = esw->total_vports + MLX5_ESW_MISS_FLOWS;
 	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
 	if (!flow_group_in)
 		return -ENOMEM;
@@ -1985,7 +1986,6 @@ static void esw_destroy_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 
 static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 {
-	int total_vports = esw->total_vports;
 	int err;
 
 	memset(&esw->fdb_table.offloads, 0, sizeof(struct offloads_fdb));
@@ -1996,7 +1996,7 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	if (err)
 		goto create_acl_err;
 
-	err = esw_create_offloads_table(esw, total_vports);
+	err = esw_create_offloads_table(esw);
 	if (err)
 		goto create_offloads_err;
 
@@ -2008,7 +2008,7 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	if (err)
 		goto create_fdb_err;
 
-	err = esw_create_vport_rx_group(esw, total_vports);
+	err = esw_create_vport_rx_group(esw);
 	if (err)
 		goto create_fg_err;
 
-- 
2.26.2

