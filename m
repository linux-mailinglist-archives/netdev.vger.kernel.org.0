Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9120F212F6E
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgGBWU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:20:57 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:22294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbgGBWU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:20:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYvG2GVOiWXNKASHBdSQgChPQ1kMynl7pgkS823CenukalHRXzNoT8mDd3n6jZ05HAOhu1QcOnZ6xBgOj/hPHqZn9geOx9a5q+pohlh5OL6GsTYEHxOLZBHgiie+UYJ8Ip4e5dTFVgaNxxxQXLSdOk4O8S367W8L4f2lawaAVDJjvNbGyTwZftBBsN9kTDz+mYuMcB8i3XPrQqUc3iz9K1B1sGTWhkBO5H9XZe9f61JKr+o3NhMooseeKyzUnL41JYQCVisjWrHiGz9eNC1pkQVhEfSslFuOTLve7aNDYKlcDQyIhz5pd3Ls3N+hCqVvWLuGVCUsAM+IB16reKHhpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Axd/XbeatQX7X6nx4H6LtY8n7iT33hLeFMjyJrCDZns=;
 b=kEb8o4vQuuCK86G2BEEhJyhOlq7Kz5GqrtCV4CP1ll68c4sbpwbMCBtVoqxXIkd5WSLSVxfvVQeLzq5Gc4TixCBp2Pjc/W1gGR60UNlihEgmrIlgcFxpBua67DdHICckXxeoXHa1gW2tz8TqypVUqM0c4l1+y63dK0HlmVzMzE5nAi/Zf9aoFqL/HJKITFDT5sY4dIii0kHxrIu7TPGTrbVeSNO2NdHN7m/x/IhB7ZJ/Ri3dQY9XUbeQ0MVk5WdWR856trTNifCfLLGY4sL1eKIzhJpHehI1eRVbK3WRkaQPgYZgD9Q+WYUFpcMMVtSdQxdenSXyX30UUR2KB2mjGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Axd/XbeatQX7X6nx4H6LtY8n7iT33hLeFMjyJrCDZns=;
 b=AAzFynPuLmT9ndd1EG7KC5wRI1hinoGlUaLfQDqHh0e/NoYcqc2fMGFghqMarI+Adb+s9zsGnvtLkaMaJxTiVzNMFw4SlX8WYaE+jN1zWNgNxRkqdJqrmUX3pWIEwkE2l9EdR+ue3bOXrKOnFTNVPqifEFsQEtHw4o6xftrXB/k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 22:20:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Thu, 2 Jul 2020
 22:20:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 06/11] net/mlx5e: Fix usage of rcu-protected pointer
Date:   Thu,  2 Jul 2020 15:19:18 -0700
Message-Id: <20200702221923.650779-7-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:1d0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 22:20:42 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1e60db2-e1fa-409d-2f4e-08d81ed6293d
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6109D2F554995817923980DEBE6D0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9yWs8/p+TupuvQteR9EMvTYO9dSnMejfKMAXYFM9R5R62aYZfYXuaI7oKZCTiKrVOlpcsu/b1PIBMcnaAyLFHi02d7c0hoUS39AKkyOv/WxFbIh6gQXsJIOhkIjB9bEgRYBhAZCPhHRLFma6MR2+RE/ql1qyJVTQlzpkUzlrrJhfiXV+mhvemfAQD4ChJD8mVFSWxEEdzIpFiVSI7KbJDuGCMjU6ThTZudm2wagiSXeCKhGW4d5C+TSSAgGx8Mk+HB4y/DqqglkqtRf7dnC55VT15ZR8kOU9Tv+P0wr0j/Ikff4SnP0aAbrEV5W9bjhUXe0bp8T3aamZHaGmSQj/vs4G/1bZHLJ8qhRhu+y+TZp6xV07w1SSTDNyecqrfGxD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(26005)(2616005)(316002)(956004)(6666004)(5660300002)(8936002)(86362001)(110136005)(186003)(16526019)(107886003)(83380400001)(4326008)(66946007)(54906003)(8676002)(6506007)(6486002)(1076003)(36756003)(52116002)(6512007)(66476007)(2906002)(66556008)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iwu8NP1BeZv0m7/RzwsclQL9Xq5Ju/rU9owFEx4lCIJf/ouQKtStaBrWoHzAi1ve31D1A1AdRAr/R6eforKweCcoIyxfEPw58pZKm180gORuNMKeJI1Yn+pKxp/fYFwBZb1tbXpWqJ/8EuYuxmJgs9yASLny/PZeyqRskrSsKRSFxcfOaKQS1zhseqvAOTYIhbdnjv4qDEd1jEFE7+GOUDx+lX5EcCnN7PXLDKFM6fVRkT1c2dKu00iQYMQwGhKFniUpD9EI7mnswsk/psKGucU0rBfpZgX6x60Bagbegr3p0uol2M8ZT5gSsCQ7+TdcpwJ1O685TKJEpCAQDjYqr8Yg3M9oW4qWAUlC0XiWExve4woqs/3eAnlTNs0LnGu4emeEilWUBSUexk2GYzQZiRvlEuBuh94yq7Es6n1Ss4sLPJaEus0lXKE4zUCKS+GiOtny5gwLpQAk1u6hBKHi0fT2IVBWjulfqCV5sLXSK3E=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e60db2-e1fa-409d-2f4e-08d81ed6293d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 22:20:43.8714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1rBcbmkpjIg1MarNrHqOYgyF4BEPHMHaHfq6EXC6qk2QgxuRVrODkum2Jot1u9cbG+8QBDkTUG5qlTu/Dc2hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

In mlx5e_configure_flower() flow pointer is protected by rcu read lock.
However, after cited commit the pointer is being used outside of rcu read
block. Extend the block to protect all pointer accesses.

Fixes: 553f9328385d ("net/mlx5e: Support tc block sharing for representors")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e88f98ab062f..518957d82b1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4691,13 +4691,12 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 
 	rcu_read_lock();
 	flow = rhashtable_lookup(tc_ht, &f->cookie, tc_ht_params);
-	rcu_read_unlock();
 	if (flow) {
 		/* Same flow rule offloaded to non-uplink representor sharing tc block,
 		 * just return 0.
 		 */
 		if (is_flow_rule_duplicate_allowed(dev, rpriv) && flow->orig_dev != dev)
-			goto out;
+			goto rcu_unlock;
 
 		NL_SET_ERR_MSG_MOD(extack,
 				   "flow cookie already exists, ignoring");
@@ -4705,8 +4704,12 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 				 "flow cookie %lx already exists, ignoring\n",
 				 f->cookie);
 		err = -EEXIST;
-		goto out;
+		goto rcu_unlock;
 	}
+rcu_unlock:
+	rcu_read_unlock();
+	if (flow)
+		goto out;
 
 	trace_mlx5e_configure_flower(f);
 	err = mlx5e_tc_add_flow(priv, f, flags, dev, &flow);
-- 
2.26.2

