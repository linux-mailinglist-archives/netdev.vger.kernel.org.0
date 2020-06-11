Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010381F7093
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgFKWry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:47:54 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgFKWrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:47:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8PoOvk+hgzRq6yi+v3aHSAIYRW0AnZldljnvjV+I5hNhWiG4jFZCP+Ns1jOWsFJyrxZtkRUEyCs/R0+hFCGrPcMYcfMGwXp52Jm5JcqJsvjkn2xde/3bRqJJXeaQQv5sojLkRpDhzpIg6El/pFGmHaC5R0DS0LizgpeE8wzVZigOJQbYwXOhw7rWVzoLaZoKzf4gsTUsodw4wtrRH8djWUEOZJieXyS0aQrB2HAWGGDBdF14/HOKzwuj2/0C7M/25QC7GIDPWIguN02t0tMtegKofvOQ6Wpa/UXKf6ft9pO8eT8esTK7QfqzMpZo7JmQ9TyRVyN4HyXX4foStfnPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bULl49/UVYC/uigU/w+DDBvTmsFkIWTwm3lHO7C0jzo=;
 b=K/HJxoDTkRvCzYzSyMKYVY/BoC7tcLhTAppHXMZt0lPeA4vFdZtLHIDrZebfqv50xk135D7cypI2E71uspurm2PXZbD+RkWafNcVHKkbSjl+D7ov7Yp9tT2WJEXZm4rR6JI/g4XlMMK3zyeNMdbfo0VKNOumL0qIXDQvJ/ab4FwuzE0/vuYTwJ9Hqh4pGD/jWJKiH11uUTu1RQGXLY+Rwk2MKJkHaZIxlPA+7h7m+wBEutpb0aekifziPQQslnD3nF8rNlLQmH5Q1apGQH/zQDmghhAmt2zSFLK+jAyc3IMxxF97mBYCNy4Z7rTc3w6JLBv/DFrh0NUTp6bgzlAGxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bULl49/UVYC/uigU/w+DDBvTmsFkIWTwm3lHO7C0jzo=;
 b=Lrwy/uQsbcXh5GOZlBxsAuRuUc/B/t9Ma4cAuyTG5LN4QuozbitZUaHDotJR2nJWBV8mQCh0y0a22eTrnxguaS7AvsXoShkLhjKjjbw19Erh63EfUOIPph36B9GPZ9RgnsVYrrEB22xSf/MNWj854ga/2qhts1gfB5NUihbp7nY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:47:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:47:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 04/10] net/mlx5e: Fix repeated XSK usage on one channel
Date:   Thu, 11 Jun 2020 15:47:02 -0700
Message-Id: <20200611224708.235014-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611224708.235014-1-saeedm@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b505aea2-5379-4f96-102a-08d80e5975ae
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB446452CAF05A7F158446ED53BE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNSjR1Czk7OwS6GIMt5XUTX1JCiv24HjMHIdfIYL6G8EyOqdrmyu2cJPLaFRRIitri8d5PBqBwCsThtWgict0mLW8vT2QJTxtKhNGLjs3eQK04ZUBBD/u3LRY1+wjZDCojMbfQyHDpDDxK2rfXMhGC0oHRn7tAHgpWot6s9Cr9FnqpmhTkuo82p5XmaAepFHfE7nep4bfk02gaVP71WJ8gNn0VPi0tfGsGXQ00Yuw/yiVmJunLam3LxLOfvfefuB6L3njlGtgdjS9D5VxX5x+nkRk0O109uQ0i9AhR1zcW0yZnzVMSddcN102fRmeYzLZ4s1TtcwZCZsuSfZAOcqPb2yrJPxh1TT7e3kMiQG4g4XywxD44oL+ojGNCWJm9qE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(54906003)(1076003)(6506007)(36756003)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tlimI/7kDeAZ+QPDBIxpfmPuEJr3eZ9Qkup7pVdi8S2iioTe4cwAgGesCdKGdDn6W9G8CRumXNr+YJHNd6+bZ+rGILRaNO1a7dR76F7Z+7Y8KzbvpBvi658HxVVYnPsuXwX17Cq2HQT/CsOvvcAzOXenQjfl/cWpxON1eQSANcYWajx9smWBmLPXQcGCd0pH1uQGLo1xTIkewv1LihEo9S42B1vqnqBG2lXgsR1RtJ0aFOx7XB1/QsFEVlsWHEB2bw8GEEgsofdj6MGMc9+oC9BYBE08MYkt4gSUCi5RLUktVsjMWgWAw5cL4ge/ss+JI5mBe9G7b161hmeaOFY5R/nQqQHEtfeOke25iBBMqIL24ViWdkFVJDr8Jq9hrcV92Cg7BDAd7TsDggneGbhNPyMo/xS2KOa9ji7R3EOIphnvdYrBPqhuF2JbkuNQMg8wQ8KTqhKMnavDWP//hDWWmcWqx6MmkS9YKGKdID7q5Qw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b505aea2-5379-4f96-102a-08d80e5975ae
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:47:46.6252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8WFtwhZmAiLDkipE4NYLgwYleeXZTDUy1up+udGnyNbfrurtgNJkOQA+Cswmbaz8sbtxGyJS3KPHGg4uCgSiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

After an XSK is closed, the relevant structures in the channel are not
zeroed. If an XSK is opened the second time on the same channel without
recreating channels, the stray values in the structures will lead to
incorrect operation of queues, which causes CQE errors, and the new
socket doesn't work at all.

This patch fixes the issue by explicitly zeroing XSK-related structs in
the channel on XSK close. Note that those structs are zeroed on channel
creation, and usually a configuration change (XDP program is set)
happens on XSK open, which leads to recreating channels, so typical XSK
usecases don't suffer from this issue. However, if XSKs are opened and
closed on the same channel without removing the XDP program, this bug
reproduces.

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index c28cbae423310..2c80205dc939d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -152,6 +152,10 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
 	mlx5e_close_cq(&c->xskicosq.cq);
 	mlx5e_close_xdpsq(&c->xsksq);
 	mlx5e_close_cq(&c->xsksq.cq);
+
+	memset(&c->xskrq, 0, sizeof(c->xskrq));
+	memset(&c->xsksq, 0, sizeof(c->xsksq));
+	memset(&c->xskicosq, 0, sizeof(c->xskicosq));
 }
 
 void mlx5e_activate_xsk(struct mlx5e_channel *c)
-- 
2.26.2

