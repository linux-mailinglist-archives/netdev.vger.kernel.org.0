Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3417C206B5F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388811AbgFXErg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:47:36 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:19185
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728681AbgFXErd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 00:47:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=er4q2aH0ihCwIV1e0ydhOw1QBnvJokFHIB7FFSm08i4eoy77+5D77smuFJejrXL0WZNGFEIbyYzkgxDKHh7dkefmwcaB3N/63zWJCCWgQzcD3G6QRSXZ1uJtB6Ucpyn5xkzm4Xjzhp1qv2HeUBGKDg8lGc+uSTQgoNifpGgQa8rvYpjkuhgHu4zpmlUoHnmTreYWrCO+1kswgTGuLzOU+Jw3ZDeYaKrV3LBGVzum31w+FbNjKik5bdBv6xcaIuNowFdNnY7/aE/OAF9TLWZ67icWCdfM3ixkng71L9637ek1g2+WqfNH2dMbiUNeLSz1tLP/U4u/uh4tWKM6F9ZUxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W82R3JwDr63XBYx27xkhfsSVDRTqeAmVCk6V1UVVc68=;
 b=BgrIWRPYdcmK7l0yNoESK0bry0fK8imPxOqCZv2YQXC8IjUnNODaNToCFnduzEHZr0/ptYYQGjF+LSWqP+vmsSsrn88BNh0EkD110JYlWCa/SnPbY63+zxuhhdib7x9zYje7LbHk619FuW+V+sfbqOtNul2XJfCqAEkmDa6qq6oo/jNTZX+mX4UWBfZiKK8+G6qN1UyU6Uv2ruLG6CXL7FhkwQMP70Y82x0N+l50nGITaeOtz8EZtZpFsUlCSGagzFmaWZRH9fVHIi9WR9VvTu+YaYNZM0E1IunX+jqFj0GHFyJ83vutY/4PFAmySPfpTGQsn5BIZD2EvSYuHPCu7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W82R3JwDr63XBYx27xkhfsSVDRTqeAmVCk6V1UVVc68=;
 b=ahro0neNC/bNm0sAxrZQk8QxTzCyS/NjXaYRVabjTbuX1riPL875wVqCTC0LNBNs51/vHHhCL4M6ZRjjVWO63Fj0riMWT+Ju/pgCW60ts3yTreRl/54nxTqLMgJKCc7KF93vTzqVUDgtQEuTvWpXL6/rgwtwPUet6A7dwzs/1YQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5135.eurprd05.prod.outlook.com (2603:10a6:803:af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Wed, 24 Jun
 2020 04:47:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 04:47:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 3/9] net/mlx5: Use kfree(ft->g) in arfs_create_groups()
Date:   Tue, 23 Jun 2020 21:46:09 -0700
Message-Id: <20200624044615.64553-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624044615.64553-1-saeedm@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (216.228.112.22) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 24 Jun 2020 04:47:21 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [216.228.112.22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: edf7dd9d-cd68-436f-416c-08d817f9af88
X-MS-TrafficTypeDiagnostic: VI1PR05MB5135:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5135CB87FB8AA6102DE041E7BE950@VI1PR05MB5135.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQ301AilYpRzyLrvjFYl/Etq8Vj1erfz0WunBi8PPMYyRDNIHSfiNTREKCQEWg7wXkANJHaIMMOAwWdjd2EG9AN4cK52zK2QWSB4RUlCyAIxQUtk3cyZNg6XQKvLnFhK4S9sHbSe2zXLWACguqCOg7WVO2a0T/Ay+ugQ41xQwGdn1uVdQBREpXoubeqCHqTbOS/NqvLIunEAZpExmSj2g1oeoEANoIqjqujy2BzoktYZDax9cYt5bIhV5xGyX5bR7rdEu1CbGFY8JFkF6KR6W6WBDuMfBFdjP862iRym+ydVXCjhJM+DfYbrCFiS/yx273EfKnpYN0OoT3GcHEcPv9KXyYW/UQNOLM3CIODE7c2vMqhaHuGB8hixOzY3DXny
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(376002)(366004)(396003)(136003)(107886003)(52116002)(86362001)(8676002)(8936002)(478600001)(26005)(83380400001)(5660300002)(6512007)(2906002)(54906003)(4326008)(956004)(186003)(6666004)(16526019)(316002)(2616005)(6506007)(66556008)(4744005)(66476007)(6486002)(1076003)(66946007)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: g6K2lwqRGqG89T7ZiNfn6Nj4eibKJXrVI7AXvT2Nh2DvqiYFHs71HKmQeSWiddBAzkVGaIIYzx3yQCDcpKRmlYegwcQteYR/YezP0JpWcMV7SRs3GY/sHuNIq621E2+Qlzcj5058i10mbI45ycYgRFzytjS7ateeWz2VxtqgA05ppgiAn+eM52+4X+0J2U+Ytrd3NoGZKVJ84oAV7h/OCBoIw3LUYxHkyNcC5GLJ/oGqURMQby9BzDYqawpnAoh5eOCfPK3zAvCIFk4NBDdE/jyMH0+UwinFJcvzMyTHEmGid/8lGYrDodwp7ONtNOAkm5HBpRvi8D4I5TsXicqOfBAJOoyqulQmtVhMrDLt5PfcuLyIkBpxKF9gXvChWEl5BcQu/2PvJD4csJWDIygpCeARFGv8++p0WOHRgx0Pup+oI+AzAsuz1BLL1RrzL/o61E8GnIKC7EfkR5duIWGk3CeaJNsIflancP5GdAb5g+vAwgzkV6aKjkfv3Fdwt0ce
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf7dd9d-cd68-436f-416c-08d817f9af88
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 04:47:23.6560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bj65vMdIINQYk0ECnKx6WCkSu0cJpgVRvHr8G7yuNiia64IW8DpdiBI1O5ZeQaR0oGJ5YAWJ1eucNtetL2WBPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

Use kfree() instead of kvfree() on ft->g in arfs_create_groups() because
the memory is allocated with kcalloc().

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 014639ea06e34..c4c9d6cda7e62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -220,7 +220,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 			sizeof(*ft->g), GFP_KERNEL);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
-		kvfree(ft->g);
+		kfree(ft->g);
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.26.2

