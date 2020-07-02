Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256BF212F6D
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgGBWUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:20:54 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:22294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgGBWUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:20:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2WNrO9AoGWtU/uY806AZ12MlEb/inUi0XJma9PiQBws6AhSwP/soNWj0h/3RufsTrIhCsElo1JEgbM9QB4IJfx5bLUWUZDcjBkmvzH1my9JvznAtMMFi7Ooqw8qUHFOPnGL+qz0XlguZyGasZzsLDwOIV9P0mC7IPTlAL5quah7OW21wkK/lIg7T2Ey88yIAsMK2XsO6E0KKu5jCxv+U53tOYaatvE4pwI0S2/r1dfE5JuyEqPvw9WBlGUl4HSI9pk+DSmf1YxTYswRGtAfsvZrDJIvu3Xd0vVXgWE0s21r+tNNPxGvrR3kKDSrs+dskPCx1xS9w57Pskxi3eydGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWvBm+yK4HGL3zp4ZaoaWyTZp3I0aCRAejPtQBpJIkI=;
 b=JJ4NzyUWbobW53Z5C26dAHSKo1prLBVmsDtunUnxwjcRteAUCNloamuTPheuI6bhfk8nMVSOTnTr0GYeGPMuDPiAfI172WwOGJbTpluFGy2ur7tYdHKjgfhBD3YsHRg1qJ5jmirA4+dncTYoCc8Vfy5m64rhQZMKKuw8JwUPcix/UqBdjRVhjO7bDHHvVLEsjjButui8QgcDhNm0w9bFfedeiZfaoJDGkGJ/8U6RxnoDQwprL5jMNo5gEue7wEL9KqKNbE3KzV52itfkUQZkvmFbCMFGen+xr8SDSaRxejgnlw0YcB6/gEL82Y7HtspjVV2RKJIG/6RcFBQID8YVkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWvBm+yK4HGL3zp4ZaoaWyTZp3I0aCRAejPtQBpJIkI=;
 b=j3Efb3qD6qJNahFAfbsLJLagaD11H+U15/s8Ij5xKbXzQ5n11eUtrMjGCzEXb5RI9BEs/nK0f21CS5vTBGZy6pIrJwkXWhOnyfh5YGGnhLgEU2K5o6CZ/jwUNe1HVoMi77CplZddP3uxnvB+WXbwXRW5jYPNbaAA9ErOmpW26FA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 22:20:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Thu, 2 Jul 2020
 22:20:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 05/11] net/mlx5e: Hold reference on mirred devices while accessing them
Date:   Thu,  2 Jul 2020 15:19:17 -0700
Message-Id: <20200702221923.650779-6-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:1d0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 22:20:40 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cbc915c8-31fd-428d-6b67-08d81ed62802
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB61091FB876934CF6E32B6A38BE6D0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5sI7r3lBxaiRWQPj+OlYnQNByzRy0f1LlP/DBWUSBc9kfnvq5lJl0dD98lqO4NZeHUPCCahHX+OP09zsvVuzluEHauWePJgAEXaCgizOmRqw42n+4QyocSuMp6Yk+6y86AVoUvCnHLTBXzz23/j4pCVYrcJ1Vd0H/6n/JoicGbMF2Z5S/w1+d7UCterx5TiTW/7WUbUT0ZUXCTWtFcJTW0kiRpdMbNKw6MkrQ16KJg1KTSrLlzDipDG1eIi2XQ5AumDvc/87xtALkf6kp3cX20dSSk9rJnL3tXAcOvTAwa7Tqp4KLYC+llRbJsZJ1dA9VH1m09GC9uhqRDMlJLTdXG+l/WdYJk3rm1m8bB9csidYI3sP7AjlfOOOXaAQmFl3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(26005)(2616005)(316002)(956004)(6666004)(5660300002)(8936002)(86362001)(110136005)(186003)(16526019)(107886003)(83380400001)(4326008)(66946007)(54906003)(8676002)(6506007)(6486002)(1076003)(36756003)(52116002)(6512007)(66476007)(2906002)(66556008)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C776ugeWTEdKUpCHkQX6As10YqAVmhXFJh8ynhySvyMyoJMPWhy9unW7TxRrFSVips8gLcXplHsbin7VzaDc9k6OYEIQYZ8fiYOKdGtXKV+ZD32yYlDBbM0+lmThDX7mrRewOTD/tMp4k4XkczE/g8W6Wgr3ABGeiPu2Wke/twS7MOqZ5Fg5vVlYOdSR5FVfQ6UdK7jntcbh2gG13BF6s4U9nZQsMR+fgbW5fX8IYZRAQPECEySUgjltCUAi9ezIeI+Wy0nuUVIoYa206TtljSYVv3FLglYJkbHLwRIWXUHMHlHlnMnrwWnkXXl1Kat1z9a2sRgZwIJCu21435yFqEF2N0/aeIhmElEfvnT8GzLDEPvUk2qqbPhzAvezGo/L0L+t1gKIGwf0Ovyk2U6Wa/5b4nsIKHCjfKqV1zqEz0OvFn2ZVJvDtpd5DHGshAalb0qTJWnQ3OQeKQKqALU9iiS6vPG1edfudHNmiVcM9hI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc915c8-31fd-428d-6b67-08d81ed62802
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 22:20:41.8325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g1DnK9A8rd8a2/utPw75Q8VaDIUG1MGloldOFEUaaalzVzHgNYuX+oyXEf+aoMjC6LCcR5eo6yPAAJ4HkwLfNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Net devices might be removed. For example, a vxlan device could be
deleted and its ifnidex would become invalid. Use dev_get_by_index()
instead of __dev_get_by_index() to hold reference on the device while
accessing it and release after done.

Fixes: 3c37745ec614 ("net/mlx5e: Properly deal with encap flows add/del under neigh update")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 75f169aef1cf..e88f98ab062f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1327,10 +1327,14 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 			continue;
 
 		mirred_ifindex = parse_attr->mirred_ifindex[out_index];
-		out_dev = __dev_get_by_index(dev_net(priv->netdev),
-					     mirred_ifindex);
+		out_dev = dev_get_by_index(dev_net(priv->netdev),
+					   mirred_ifindex);
+		if (!out_dev)
+			return -ENODEV;
+
 		err = mlx5e_attach_encap(priv, flow, out_dev, out_index,
 					 extack, &encap_dev, &encap_valid);
+		dev_put(out_dev);
 		if (err)
 			return err;
 
-- 
2.26.2

