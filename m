Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3431D5C27
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgEOWRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:17:37 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:6026
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726226AbgEOWRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:17:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQLM3EPESDGus2hIwbgw1VdTIpr+zesMZHMqt6S7Yh2Q2lJHQFLONShAiuJ3vK/NdLtgBti25skJJSmfXu8/T6+aJYmj819v1Y4Tni1tkzGznwkI4xHMzr4oCU+l7mOv1LY8M19S3RYYMZwmY+UprdTcWaJcjVUGXdKqh9Lp5RzvjX5Vqjf+l1u1MEfKHl9Hu1d5PyT2T4+GuJfq2/p3RZqzlNqH6JWLkDABlNlRS2PfTFmvsKbTxLhbZCaapNsvN/mgU0WvYO5D7WsrvdFg3mUd3sKYCRjiBmtLhzRrIArlta3+kZ418J37dExECt7JrWkK93Ptjb8LTba5MfIdDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBq8LZoq2VsROgOM5rdC8h/zmfiXDhJZ8Ks6tCD8uGg=;
 b=LzE1ddXQQkzuAOYdumcaIOp8iT4nttEDGLpmmKkCJ3EODnTd8LSRbHWrmGKLg8ERDQljeLaFQ5i32YXhKt12rb1RSX+WktQWQELa9YjlnO0mwbDOIX6MbsXjQ9WhrjVgI7/CjTYjCTMHKKYEM7EjsKlkCNvW8Q24Tx/LbnkqU+0K5U1NaX25vzMgIpiEKlz6aq/PXmknm4RfH9TYDWuAYuaMhsbdDGesxj3iYrapMhSF29KV6as6M2Eq05T4Ncm4Rii9ERS95Bkyzh0WuySLCvBJU6Hi6ZrFjk6IujvRB0Qnbk761u5mwDBZhSHc3wpM6j4iCewjZSudOW9F9bZw/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBq8LZoq2VsROgOM5rdC8h/zmfiXDhJZ8Ks6tCD8uGg=;
 b=LkeR1oCs+pfh5WsNOnH5ZzFzDORdnUvYwYNo4N2xOqgvOFVEkkYNYXNOekemYq/cTqzlCV49H9kLWA3p9Rjicc2+LfoBqGFPdkWjMjaJJm2erusfYKL3UOvu11CLJoBEBrVDNOImeTTnnc3pSA/Q3KkYE5YPVOEM7iCWIGK89w0=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4301.eurprd05.prod.outlook.com (2603:10a6:803:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Fri, 15 May
 2020 22:17:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:17:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH mlx5-next 3/3] net/mlx5: Add support for RDMA TX FT headers modifying
Date:   Fri, 15 May 2020 15:16:54 -0700
Message-Id: <20200515221654.14224-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515221654.14224-1-saeedm@mellanox.com>
References: <20200515221654.14224-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0047.prod.exchangelabs.com (2603:10b6:a03:94::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:17:28 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc95a831-1e56-4c21-bd27-08d7f91dc1e7
X-MS-TrafficTypeDiagnostic: VI1PR05MB4301:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43018C4C7B5229D52AF41351BEBD0@VI1PR05MB4301.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ufaYoD/RzOyswvA2ugEfai0n4MSzdjKlSPt5Ae2nQcjFKX+NnL54jNGIJPi+ZhGiEw/FkkFA0sQxPjXrLhdMzOKeERhIi+ahkWK30KEnDoAwZsD/YPT8dJ/0++x8vsV4FLcT3+wCXvbLbh0j/eRrbCAm16dadwt37kQD2Dw/y2n/dEWtY3myEN5Fehq5optTl6Fw/YwF4AHTX/wnZNpLmymsOerXmi+xxECowLgiroxVpRYChI1os3GOjDUNZm5GA1uGH3ntDNxL9QN2z0hvgqgM+tF4mNFCelPdTQhz6uu8jx2M1BCaaynCo3503QCFYb5/MNQNxtKcIeOmsusXneVCiYz+kubBTrYcC0ZyntS9RM3JdEPQErVVlxs6Qz2I3g2MoQtfgK41Zmhy8GoLJtqCOhwgrLEoKmAxNaw1yr+IKXbc+wVQjHSo/IKNlp5Ehys3OLE3YnBULHVkjbqhonGoAx1yGuPysj8Nuj1nFP7JkxKaGkH2WEZsitnOKtzy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(107886003)(86362001)(6512007)(450100002)(4326008)(8676002)(5660300002)(478600001)(6486002)(6636002)(1076003)(66946007)(316002)(66556008)(66476007)(110136005)(54906003)(52116002)(6506007)(8936002)(16526019)(26005)(186003)(2616005)(36756003)(956004)(2906002)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GBtN86UnZ8gur9oooqdXnu14e4MccWwuFanP9eRXrVLTVm4RtpmEtpJN4u6ih2lsoXbhnZY2HnMuZLiPXCOivuT+RhzpoEGvuhl8IC8NZz8WyLng3YiriaQPZyJwfu0XgfSh9g3Evp382VHMVw/DJCXmgQm4BYva43veCWXSHqCo5JG04IK525IlAPj0B9b/a0ozuuUJoQjlFf/shsrJCVwo+V9b77NA7YMwgb6Slv77VrO9mNaLcB/gURuuYlUg7Cs6NniI7NWAXBMYUfyJZKm0k8JQRzg6gfuKGBQU16hH4ksm4uAzBb6FAQx8p3bJ6mrKZNdBo58BT8po9nB9TMXIeeY32qOm5fLc54h1zqwIJTjekfeMbFwni+DbYt2qk3ibyUA25VYHFSvOoyXLn5TqDLHD3cRBgg0PL93MmSffkmJE3vPLNj0N20OExYm256tNdoi5MWm40WV94IE8ilpYPiVu5b0AfhsxwOmJToQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc95a831-1e56-4c21-bd27-08d7f91dc1e7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:17:30.1240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxfrGyzjhkwW2VeXM6Xx9l0P5iom09Qf+JXCLRuwQczD4ucDEsj0CGiFhhyCVAe9J10DYnvSx73eCwiEOAjzOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4301
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Support adding header modifying actions to the RDMA TX flow table.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/flow.c                | 5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/flow.c b/drivers/infiniband/hw/mlx5/flow.c
index 69cb7e6e8955..3a0601c2052c 100644
--- a/drivers/infiniband/hw/mlx5/flow.c
+++ b/drivers/infiniband/hw/mlx5/flow.c
@@ -404,7 +404,10 @@ static bool mlx5_ib_modify_header_supported(struct mlx5_ib_dev *dev)
 {
 	return MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
 					 max_modify_header_actions) ||
-	       MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, max_modify_header_actions);
+	       MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev,
+					 max_modify_header_actions) ||
+	       MLX5_CAP_FLOWTABLE_RDMA_TX(dev->mdev,
+					 max_modify_header_actions);
 }
 
 static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_ACTION_CREATE_MODIFY_HEADER)(
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 1a8e826ac86b..465a1076a477 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -781,6 +781,10 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 		max_actions = MLX5_CAP_ESW_INGRESS_ACL(dev, max_modify_header_actions);
 		table_type = FS_FT_ESW_INGRESS_ACL;
 		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_TX:
+		max_actions = MLX5_CAP_FLOWTABLE_RDMA_TX(dev, max_modify_header_actions);
+		table_type = FS_FT_RDMA_TX;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.25.4

