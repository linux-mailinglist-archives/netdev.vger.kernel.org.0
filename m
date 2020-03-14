Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92FE81853BC
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgCNBQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:16:49 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:20602
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbgCNBQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:16:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NT4CnHrr5wVDs5SzCD05rkXNMtRR4oOTa7d0cf0TLyHzEVV66MJ67Zz/sKzJvUt0ip/ZW6+ieQD71SSqCu0s28sh9wB22mWaEjBybDoScJqr00eAS4G9TjivkJIQPGcTJjBlZy3B/OB5zQ/Ac2oplMZiAT8CrYMiIgU0iC0S+vDD/Xuc9YopPPSw+ZQ8C72ll3h4IjnNZoEvpC1c2Lj+Qi9kuKMuGRGGuwb+9rP/ZLSLSzPo/0sttC8S0zR2Q0tOBs5Zz7+7UVhFVleSA0Dn2TbvPOpJy6rOOMsk2Zkgw5EXdWXRwH3wZezNxgjbX3vq4ALiJbzws1iN7CCPEJ5Yew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyPNsH1AQEBR4L7zDk4XVlylfTDQsbQ4l7lWnd+xxeg=;
 b=LF9Q64n4FQ9ChYmX1reeAOj6Cr87ermTY3ODbOzPfCX+EargE2eNkvuek/t+QIidalaZnAyn0N89vYMBMvk7ZTsr4mMvt7Yx3t5Ao/sv3hfZgdMMwrLOaAwe4ieSm+uKIk8bVrWcVLncqET6XpJSi8uwOobcLhsU/m2NjzfJlyBpSnvsKuZiXLhYtomFSXEZ0ULhnsKi/DPN1/8pz5pGZG0e8BFXtWn80KtclA4T3L65rjkDQmx25MqewVStHPDVjjO4PVcTvmtLgAsHSWELAJkDflc9aRa7L76GKDF7KKze1DCVhykAE+Ag4lQW6M25ERrvcRc7xytiL8aiP+XL2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyPNsH1AQEBR4L7zDk4XVlylfTDQsbQ4l7lWnd+xxeg=;
 b=GSSaFlLdinc2KIXC33BlN5YF5D6AG+39KGoqHLCdooCTczf923qmbHtbBFzeoRHp6yjelB81OtEBkTei3FdoDNjncE2tzQ37Db/8jNDTVZJ2esV6FWinkx6BO+0vCiQiTIHJkJYwFgHZ3HzqZOlDFBzaAJhSRscl150o37VhR44=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:16:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:16:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/14] net/mlx5: E-Switch, Hold mutex when querying drop counter in legacy mode
Date:   Fri, 13 Mar 2020 18:16:10 -0700
Message-Id: <20200314011622.64939-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:16:43 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1093c747-e349-472f-eb49-08d7c7b55c8d
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB68450D662F5C17EA0F950201BEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8FOVdpvbMnQU2cwJxqoyIVLfsW0/urBC1+iqPKfFkzI1CLm0QWjKY5hwfxMdDm1Wtp0Np3eLvv1XPZLZkhbszb5VYOUgkMGJ/Rp2VlYrRgWCSB95xQvRvBHPW4LbWYPG5+Bs8CGOa1ZlVWFERJoBFs/+UzjakAMawB5rGNBNZy4chPnEmScjW19sxOLMEjqPoLXq1IN5ZLqYnVaLQ/0KSV+mDu30Mc5t/cblIlyc2MgYMjWICKLWOn3A/5aVC7qlKSNH8lGgeFmxTHEj0z98ENyJTwbxLntkC0DOOnPjaqVkO1mVI8PQE4XMM/c3D13YJPqPmhGh9te/KgDv6RgWstUQ7ak7/qQP01XbSlhYngum3LtsAfBUCHJGvF42MUoSJJZ272s1K1hR72ZAT6naxGztchlPAvStERbwScMN4k0uorX3muQumXRCDv5nH2cCqO1yQQgBUZK633EeGhogFdvKs87DFdyTEcm+a32UmvGDFImMv0hZACm/SBETjeO3LVonDrZa6UqVxz+ZjyHTCepzMRVy7OeQJYQ4A4v88Y=
X-MS-Exchange-AntiSpam-MessageData: 2E+axdRrkvRBTFB2/YNGpRWTwmBYzS/fuFW7KFL6OeBE39t4JYo1dTng5NN80M+NDST1VAKipyQVJie0dqZujpjR+yX4MBqd5qz9Pxxs41XidouSuaxr5VW+/sgD5ETLEuSqb9HGQ6LIgMp7zVo7ag==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1093c747-e349-472f-eb49-08d7c7b55c8d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:16:45.4295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QdN3n8bW4rta+jNY04RPN5Hbob2wVIza3R5DaGS50LM5qpCoHmmbDm9JasHbdLv+QHGfy2g/P8cyyTDxffhTtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

Consider scenario below, CPU 1 is at risk to query already destroyed
drop counters. Need to apply the same state mutex when disabling vport.

+-------------------------------+-------------------------------------+
| CPU 0                         | CPU 1                               |
+-------------------------------+-------------------------------------+
| mlx5_device_disable_sriov     | mlx5e_get_vf_stats                  |
| mlx5_eswitch_disable          | mlx5_eswitch_get_vport_stats        |
| esw_disable_vport             | mlx5_eswitch_query_vport_drop_stats |
| mlx5_fc_destroy(drop_counter) | mlx5_fc_query(drop_counter)         |
+-------------------------------+-------------------------------------+

Fixes: b8a0dbe3a90b ("net/mlx5e: E-switch, Add steering drop counters")
Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b123089866e2..b4b93d2322a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2620,9 +2620,13 @@ static int mlx5_eswitch_query_vport_drop_stats(struct mlx5_core_dev *dev,
 	u64 bytes = 0;
 	int err = 0;
 
-	if (!vport->enabled || esw->mode != MLX5_ESWITCH_LEGACY)
+	if (esw->mode != MLX5_ESWITCH_LEGACY)
 		return 0;
 
+	mutex_lock(&esw->state_lock);
+	if (!vport->enabled)
+		goto unlock;
+
 	if (vport->egress.legacy.drop_counter)
 		mlx5_fc_query(dev, vport->egress.legacy.drop_counter,
 			      &stats->rx_dropped, &bytes);
@@ -2633,20 +2637,22 @@ static int mlx5_eswitch_query_vport_drop_stats(struct mlx5_core_dev *dev,
 
 	if (!MLX5_CAP_GEN(dev, receive_discard_vport_down) &&
 	    !MLX5_CAP_GEN(dev, transmit_discard_vport_down))
-		return 0;
+		goto unlock;
 
 	err = mlx5_query_vport_down_stats(dev, vport->vport, 1,
 					  &rx_discard_vport_down,
 					  &tx_discard_vport_down);
 	if (err)
-		return err;
+		goto unlock;
 
 	if (MLX5_CAP_GEN(dev, receive_discard_vport_down))
 		stats->rx_dropped += rx_discard_vport_down;
 	if (MLX5_CAP_GEN(dev, transmit_discard_vport_down))
 		stats->tx_dropped += tx_discard_vport_down;
 
-	return 0;
+unlock:
+	mutex_unlock(&esw->state_lock);
+	return err;
 }
 
 int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
-- 
2.24.1

