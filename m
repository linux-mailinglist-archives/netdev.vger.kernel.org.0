Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE0C1C03CB
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgD3RVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:21:23 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgD3RVV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:21:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwI0dc7w2x+njAxVkPKmaLguBg5qFfuTyG4aWEdG2A61OY6wYHl6WSVXSL6izjmkzaaFCgj9U8QKo+gGkrZxerASm6VR9UBfuQk3CR9zVbTW7jmW/jl32K2+/RGMbj1RHvCsy/JgKN8fvkodO0Nm4ffxD+j1GuejLjnFOI7YBJu2Qb3+6rDS65c6X1kSuF23RD4BM86N/WqnWZqX6m77GRVnGS60lhJhBz+Wkh5W0JQVF/BBwMXGQmsf+PD6fo8P0KAj2f2eWxSDAWEBm/ao8fMvzvMEix5TfXrt4NcvqTo5E9OgfXaO65rZwjIQXWhQsckgTPI0zSj9G0TlktRsyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjcbVXsiOGdAoF/LPxqkkn126veB53sZvBezn9nxx/0=;
 b=cIs/Su8xU4MLHJQykT6OeCHAhaxJv+KJ1CU6xlx5UjopCyJn8WYKiiZcE9fvrPCksWrRfLiaI5nGWVMFKxeVF+F2SuqWC+E9t2zaAtXQGYT9S9hOpVZLWjwx6A88grq3yjuXjkA8+JllUCqrqCnp/D9hfGom0FiuJK70FlvDJ5SahMv2GASXmnn0ZtNLhY8V7UNHRDLjPM+cr8mCR3GRHMeIfrRHB43evf8v7yFa159M9oAt4GlUtWY8hloX2dVws2dF8cIn93cfJdjoKhHdo5gziJATIPRGy50/xP3lva7T5LBKn0B4UcTVGsyLhF3rkARenGIyq1AJaJTvFW2CwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjcbVXsiOGdAoF/LPxqkkn126veB53sZvBezn9nxx/0=;
 b=fOJxjXVZgh6mlT5Jc+pzATvaudcmaau402dVnlZfCXowxvvB76hzSImqjCUyzq9VTM9WIkLl7pE16XTqlAPQEp/w+95TZ/Fo864ehlE8vUO41DFXXQF1LM8u3yNN1wa+i1UZC3UQ4nUHGhi4S6uHrnnFuC2Qd1kXtcVKtpTDkR4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/15] net/mlx5: Rate limit page not found error messages
Date:   Thu, 30 Apr 2020 10:18:28 -0700
Message-Id: <20200430171835.20812-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:12 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ef699242-44b1-4c88-434e-08d7ed2ae21f
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3296B2497AD1636CF6291A78BEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbXIttonpBsCkv7GuH0D9sasOVwf36V6f9rB7ajv4YOmP3+zGvCMRNVH+9Y2+U3ax88pYycWMMTrRCWMYGcitMkbVEeEl+q0FlgtT6TcX4T4pVL/RKEUlC++K63thze7NF9QyaTfUWIrub0QPgTjb/YQwemviGvyx0hMnyN6ssesnDpipcG/kER1LrN1cEYMcW+cXBzPJ1475lxLlzxydTaU98QtqdqAtBp6JNy+uMTkDJv0NDlN0UBfkMfBojvkRm2kA1hX+md3AS9rJELQ8KU/VL5Hj9ZM91amhAOEPOYyibeTO2N1fv/Vi3ngW7KHKReDg3WNObxmCS83q4er1MmqnIGh+tGXoWAhci3ZULlobyPa2BYvG15VqsQjcsRHZgmMECpLCEZFgJqwnJrS+B1xTZw/BipTL6UudugKsfQv1mjNa25P2MDB1g2I0GihammierheS+qKrcOlMNqy6rWnBVq98e61xSxQVvlnyrYuX+paGiNTctRtv6ntrdi3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(15650500001)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 83f3io+89uzHT//qWbKPW9c/LqU0fZWOEcgY3SnT0QBpXB+t/C5eIzWWBB/d1Ak3yLDZsTz+OP+E5oYkaYte2y/pwOmN1cKE0G47h0JBjXobTRE1HBXXN4TOwFwDhH3l4wtkv5PXRPzvdVC5IlwfnghLT0+WZbjr3j3D5bjb++4g8gCWXmnWecqgvP/OdBbyzMgKchJ6UWI6iJwPgSiUotQe5SCjmiZBwK4u0Ja7+5VqTxeW39YbHgfOZlE3cO4RpkPEbBfUdLAkVJcQbvCTaNh186ximBTNHp0i2pKiC4fZC827PM+cxAdsv+VaxZHS1Gc5YayRvTmD7x9irFXSWAvW5hQ+1YxWl5BS8lv7TjATw9H5aLjKT9YTPAvQsqWz6DIH0+x8z+COx7680bdkOYdACne6CSGytVuhG+rmSkW8NHiasPVgn5zKh+T6raBrWzCdZfC/I3qSRwIyWxlA3u4+KObH9p7tbxtRsOcWjn8i7tNQbkNYkb1ekg4WMMcPpnR/dsu7hNurvaKwtMuNiu+s/mPEUhPxOYbGuZyzvci/fnHV8FRXYvd+MJbi70H7cdzviiSHi/I4GTB+3x5HBFzBpXx5DxJydlcSq8OQpi7+GkMhZyWziwMpBpTD+s0UxOonpFnBQq0uq4ZkfQGCd8HisNbLV/Dq8rmqPmigKVNEN8vNMOv00CrFctuPR9WBoqTkJpIcSUPvKqcngmDRDZybvi9MhrcB5/xvBbsdnSot809jUbpElPjTCkEfHkOCwNzesA+x8nck7ePlRyK6cy0nM10FpyXIPK+M21OlaFc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef699242-44b1-4c88-434e-08d7ed2ae21f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:14.1909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvTxOifumw/ejI6mdeyFP0IdI3BRGbsKYhcBFYwXWyfc/s8qRtMcEJl6XcknuepRNa0furje8P71Knisj1J/Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Thousands of pages are released with free_addr() function. In case of
buggy sync between FW and driver on released address, the log will be
flooded with error messages. Use mlx5_core_warn_rl() to limit it.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index c39907c641a0..c790d6e3d204 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -206,7 +206,7 @@ static void free_addr(struct mlx5_core_dev *dev, u64 addr)
 
 	fwp = find_fw_page(dev, addr & MLX5_U64_4K_PAGE_MASK);
 	if (!fwp) {
-		mlx5_core_warn(dev, "page not found\n");
+		mlx5_core_warn_rl(dev, "page not found\n");
 		return;
 	}
 	free_fwp(dev, fwp);
-- 
2.25.4

