Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176A1191C4F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 22:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgCXVx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 17:53:26 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:6069
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728207AbgCXVxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 17:53:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yhwd8W4oilGv3sD299YztDIjxgun6kS9MkMKQT4PUneWDXEFoZ9T+Iw5L/3qdS18t9h7a5WprSNnXD2NSwZ9G5gKgL6mVYgV3lhgyN0GaRewUGAzVKmqp1icqtq18+zpGmEWJkPAQ5V37PgfenhAKGNb9RtV/8he8ghxVnVV5w6X8kSEiCSGqWF1fMar+D7KxL+jXJbsY7JpO9HdumQK30t8PP9wvziVD6YSzfJgHONN1TZ1oFEfAUNIH9Clx4AOebta9bI3WKXjMFWdzDfg+AskDsCYbdMrv086rEU8p5tCsaV7Z5X27zgBB/hYK4eYM8J7Rzupfd4rCN791cNVtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8OoDl9mMuu9xHp1xrhbqk/3auaTqCKUadzXMfflskQ=;
 b=HWlz0cnUHiOsRy5YZwE22KxIA83He3SYhaCs/7h0FWOlKli+5SzVLiYfdAmUAP0zbxu9WReA3p2i8XiEQKpznp2SeRh5HKnzLmdAywNbrue/hTSdYZcfjyEeOqJCWbZfo2GIeu7+NPyz4Ep7PDq1zqGInCZ2Yc7qVbIAZoqB87aMc6Q6OmYcx5g6nyI4iuhWjXoT8tn1YzLhV6xYuVnS59qbLmrpfZCUY4oMrKvzO82sJ2OsuTlP2MCXsW3UImbUvB/lXXJk0CK9fQqTb3Gg4jSCtC+ATufC9fsle96MCdU2a4uzwwNpqfMPKN1skd/rdSwXnxokcAms3RdPdMP6wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8OoDl9mMuu9xHp1xrhbqk/3auaTqCKUadzXMfflskQ=;
 b=oydI8/DDiB3CZ7eVq0fFfscwRhbsCHPP3vlu35Txcha2AsryPjqOI38AvRWhLvLLGpHVVzZrLAxX7C2C5JeJp4UGv91pQKQfumQ7xRRovde4MoxYr80PXxLEpxwRgjCuJxbD+cgd6eX07ci05Z8qnkKAfF3sVeSESqT9nzMaYCo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4973.eurprd05.prod.outlook.com (20.177.52.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Tue, 24 Mar 2020 21:53:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Tue, 24 Mar 2020
 21:53:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/5] net/mlx5_core: Set IB capability mask1 to fix ib_srpt connection failure
Date:   Tue, 24 Mar 2020 14:52:53 -0700
Message-Id: <20200324215257.150911-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324215257.150911-1-saeedm@mellanox.com>
References: <20200324215257.150911-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0049.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0049.namprd06.prod.outlook.com (2603:10b6:a03:14b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Tue, 24 Mar 2020 21:53:20 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f2a4e49b-ea60-4460-314a-08d7d03dc548
X-MS-TrafficTypeDiagnostic: VI1PR05MB4973:|VI1PR05MB4973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB49737AE681E79085C33C5FA3BEF10@VI1PR05MB4973.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(6666004)(107886003)(54906003)(8936002)(2616005)(16526019)(8676002)(81156014)(86362001)(956004)(36756003)(6486002)(81166006)(186003)(66946007)(6512007)(52116002)(2906002)(5660300002)(6916009)(66476007)(66556008)(316002)(26005)(6506007)(966005)(478600001)(4326008)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4973;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHezUHO1hArYx9IyB3WbOkZH/kIk7sIaK62yGD2P1ZULJSepRl4olZY31vrd+D023RfOJXpCO4Jrw951n+W/F3BOK4GTeZpvzeE/+zsH0Cl+ZFbdgSSi4AUBp1l0kV6c1XCvJ6N5eHkGlACGlvf58Op781B33HZlxkSqYLT0KfQDOVTdYm1qSiBn94gwfGiFk8M2O5q7bE5gvkP28tiI5Uhkhyw5yhYdMUXODFJK7cSLNjcoUZkWaiVk7OoYa49m+wmQHnKu217pBZ/rap6mOPibwqtbl9VT6UYo702PhfMPdUXs6RDPfg8M2VVoAsNaUlYCTcTC7eenU/odaAwQzYtllEGqFrPsP+xWiey5fTSsQowQ8zIvBjv9nM7+c0prk/Gtd2J+5tnhZdhd+kA3m+C6y2ZDzeg7h2SQzz6GqtwuVwTprMlzhsYopwPwbMkJbMJF4bFpHBLc6WxNxwcaMoWIKIp0rLQkwvNiVKzG8hZniP+G1u9aGo82xNbpLAYjKZoLgXabVK9982Ud1fzdNxuawo9CqZE7gZcbkdmYx/KYZ/8Iv+CKTIL8+UH88ksA/MJju0E6L89Nxhtbsq3dC0CzXrNeDc9ipbR9ok2Fg3E=
X-MS-Exchange-AntiSpam-MessageData: fukUTtqM75gXNj4qQGMsw5g/rh7nPlUgKfycUH1wGyzK2/C0XVyaNA/VYRRAWdt5baCoUxaNe1mHkUQJjbTvUQ2YzuEu0Tql76h1hJGT6CSYEP4FL5kvo3p4ZLHaaTeqE//zKtumHnljLuzPUr2kLw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a4e49b-ea60-4460-314a-08d7d03dc548
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 21:53:21.9448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JdejJCxrm6oU5x/rffwcWX6gHi0iXW6H7K4MiGAGt8O5bIFEqowprK/0MvAoQrNFcN3Rh+lA78O49RVI0tVztw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4973
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The cap_mask1 isn't protected by field_select and not listed among RW
fields, but it is required to be written to properly initialize ports
in IB virtualization mode.

Link: https://lore.kernel.org/linux-rdma/88bab94d2fd72f3145835b4518bc63dda587add6.camel@redhat.com
Fixes: ab118da4c10a ("net/mlx5: Don't write read-only fields in MODIFY_HCA_VPORT_CONTEXT command")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 1faac31f74d0..23f879da9104 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1071,6 +1071,9 @@ int mlx5_core_modify_hca_vport_context(struct mlx5_core_dev *dev,
 		MLX5_SET64(hca_vport_context, ctx, port_guid, req->port_guid);
 	if (req->field_select & MLX5_HCA_VPORT_SEL_NODE_GUID)
 		MLX5_SET64(hca_vport_context, ctx, node_guid, req->node_guid);
+	MLX5_SET(hca_vport_context, ctx, cap_mask1, req->cap_mask1);
+	MLX5_SET(hca_vport_context, ctx, cap_mask1_field_select,
+		 req->cap_mask1_perm);
 	err = mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
 ex:
 	kfree(in);
-- 
2.25.1

