Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB45B2D33EB
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgLHU1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:27:38 -0500
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:1601
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726703AbgLHU1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:27:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTzWMDqNiguwm5DczavtZSTg5PKfVYN4oGqUDue/qJguqHBAJ8abdPJXO22SXEQk1/dwRQwlSKTcLr3xVn7QbTsTPXNfbYTtb/Y/7sNxnAsqejTf1Qs3uhRl7/7+Bkvls3uIgt3fxNusko/pHA4TDbgsbcEmRtqSsAzs6kOJFAa+e4SF8/xkTTZtwbmUSbb7tvETkF6EgVIyOCkDsZATqzaQBj0EFGkl9mMatLrsXkGMV7gZ8DQCdET6Zp7yEjBMs4MZ+B/getLjTxvmn68SUrxMYgpH+ZOvqj8YTgfuM3dQ8nP4wUQnYNSPTDwSSHHs5kvxoLw/XVdKa18/ll+1Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Jlh9hGex2MdTf1zUGGW22pdIrtQvjKN/P6PW5Jgxq4=;
 b=HNsI851hIEIGVmZN4uK5CfwZfuDZd4aQsk2q6ldWsLNAnTJrN6AWYhmSHdTjtZyC/xV3Z+yg1TErhz3VXP0+A9nC7aMA2uD5Xi1pcOTNJe1hKMMxhtRds69SH5AMH5cHUkwDjQSMWFxf7NejcpFhH4zJMJ8qIlCr84KXhfcBc3iXIeMhHPMQUgdFS/lD8B96kEK32zGTvdI+CHb+xQkH69D2SPWu4YgDaE7c6KAfOXrMMnDJUMUdmXUdEcnonGnc+TqwtRztByozcFgi3OjrkX5cMPVs8A0ZNeyZGok5Q2JtGT9l83PyqZb5s5b9Jl/yAuw/yO0E6ozA5NKSBxPQwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Jlh9hGex2MdTf1zUGGW22pdIrtQvjKN/P6PW5Jgxq4=;
 b=BIGDuqAOFoG1y4QKYD+7EfTPhteLXYkmU41f8YfbUNnMdg2AXuOZzar7JmAL1kZ9N89aHL9gnStMFk2aUEwjApxnnm1jt4hHGw0kuiSZNhMs7AdDXAtX+Obq3Xc8RNqHJSK/meOrg+LeVB1RNcgJo9duBoia/axIEn7OZCJNJNw=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4909.eurprd04.prod.outlook.com (2603:10a6:803:52::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 19:40:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 19:40:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH rdma-next] RDMA/mlx4: remove bogus dev_base_lock usage
Date:   Tue,  8 Dec 2020 21:39:28 +0200
Message-Id: <20201208193928.1500893-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM0PR02CA0004.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::17) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM0PR02CA0004.eurprd02.prod.outlook.com (2603:10a6:208:3e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 19:40:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8dc83516-cfdb-4fff-5369-08d89bb111ba
X-MS-TrafficTypeDiagnostic: VI1PR04MB4909:
X-Microsoft-Antispam-PRVS: <VI1PR04MB49094A31B3EE3A4881491726E0CD0@VI1PR04MB4909.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cu5NMY+l1eWjT7es/YXZItqGxp56C6yYd3YzWFkrvyTVUPcxfzCozeLb3C8AMmpy6/9IhEusdGdQ+LoK522VTLtkAt4gsbZnObIgZjav7HTM/+lEBUcvKzBAL4iAY00pO9k9/OXBJ1dum3k4OG3+ZHov0GVQcpHR9M1Zk/Qnxydy0JdXxtu/FbvgDUm8TSKbeYcaEexkYVjiHxYaUBc1gtY67ad3CcSR2IejJEBkas+8LQkwUeCSP/tcqGta8KLy8cxQuAqSr01A91fSRCReX6btEJlW2Dvrq0ttRMXCXbgzeLEc8vKtQuhbuiDetVVQpFJ71yZd48PKiXn3Zwiv2DvCKZSGqkJflT08vuku0H7Xd98EzVBWdzihwrelGErdeedpi1j7BUXajz9Gz5Dl3ot+6ZnGvrobLTZWeJQva1Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(44832011)(6506007)(956004)(52116002)(36756003)(83380400001)(4326008)(6666004)(86362001)(69590400008)(508600001)(6512007)(5660300002)(110136005)(26005)(2616005)(66946007)(1076003)(8936002)(8676002)(16526019)(186003)(34490700003)(66476007)(2906002)(66556008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r6mxvquJGNchTSs46G2EO5HDTZ/6g6UX4l7Sysz2YaOxabEIEZH+3L0R+965?=
 =?us-ascii?Q?lvGlME2Bx/xuXghavyrJk6nIPVYLSsSN1IVM+VU0riimzOd8/BbhOy28s36N?=
 =?us-ascii?Q?G1WXL+0j9cx5q11G7O+v7HOxHGdW7tIsgmN6Osa4mBxCbaLWvt7bpygevua7?=
 =?us-ascii?Q?gyuKcJDUpy8bZxolNAy9sAw4WHHC0oBOA37d0ll24p6YeFetTXkpkj1aa0ts?=
 =?us-ascii?Q?9E5vUFJ7vn2BmSsJTndyhjjvyuoYN3gQkxaRXXg1Ffq3GRb0zeFBHNXwld/f?=
 =?us-ascii?Q?HNVkQ60FbEna8pNSQr+TDWMlzmYgGIANvRIx4uzgHSLG9QeMYE0BgeFFuiAe?=
 =?us-ascii?Q?putBSmDJW95oSHlMOxOY3clu/ZM+5+CStvhAUh55+DanDcV4V7FpKpW3+suk?=
 =?us-ascii?Q?JeZAjOk1r8orxgEt5SJvpdkOiRrI5heDEr44+v2n/vaKdhP+Y1W+dV6uNVhm?=
 =?us-ascii?Q?S175I4j/PsKBzRQAx7yMz3ewSj16aExt7yAqN7q71atBZRckNmPk79VaiemD?=
 =?us-ascii?Q?rO3cufXCsI9jryZdbFTipJQzh8cAU1fWI7O9mA5cMPvQVbjpDmDAywh6tobq?=
 =?us-ascii?Q?tG450ZdzjwCOKexR1uLcr9zDs5UvRNo/kcXqtvGNbIKLlP6BiUfTOLgVhKm1?=
 =?us-ascii?Q?t5WrQ5EZch+pJTlzv075uvqQPg1jDkRH7/sY6E2bxiTAxI3rAl+Y5zt8vMPh?=
 =?us-ascii?Q?y/1PdSDjaXfvxPeu6mvOsJ02HGte2U72ZGZum6xc00hJd98RXVpVkbLtCJVx?=
 =?us-ascii?Q?X1dYxgHTAgXiB5fNDITnTwKc0FqoxECz/P2LQ+v2zLSx0VDh4XtmYKFe+IA9?=
 =?us-ascii?Q?hSBw5ofYSDXQ7xzo6ZnBNixZ1B72NrIEiF2sXnsJn3dnXzxAJ7XKhk3ukbcT?=
 =?us-ascii?Q?2EpNdgQFk25kc1phpfBAPWTPkHptSIOIXo5tdMs1kpANiKfbEX674EAy7zdZ?=
 =?us-ascii?Q?RDuBNC+c7H8SM7oWEG6yJw4xQuDGrzPQLQjTh7vZdovD1MZUOKsU0OujfO+L?=
 =?us-ascii?Q?o31v?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 19:40:08.1145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc83516-cfdb-4fff-5369-08d89bb111ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7ARIbTRxDhr61ZDv+YNIGjSIb4ilAM5Foh9y5JwZ3W1uvDksAlyWfmPYjQhJU5+b4n1/EAHNJlbAzCHgXf8DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4909
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not clear what this lock protects. If the authors wanted to ensure
that "dev" does not disappear, that is impossible, given the following
code path:

mlx4_ib_netdev_event (under RTNL mutex)
-> mlx4_ib_scan_netdevs
   -> mlx4_ib_update_qps

Also, the dev_base_lock does not protect dev->dev_addr either.

So it serves no purpose here. Remove it.

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/infiniband/hw/mlx4/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index f0864f40ea1a..e3cd402c079a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2265,10 +2265,7 @@ static void mlx4_ib_update_qps(struct mlx4_ib_dev *ibdev,
 	u64 release_mac = MLX4_IB_INVALID_MAC;
 	struct mlx4_ib_qp *qp;
 
-	read_lock(&dev_base_lock);
 	new_smac = mlx4_mac_to_u64(dev->dev_addr);
-	read_unlock(&dev_base_lock);
-
 	atomic64_set(&ibdev->iboe.mac[port - 1], new_smac);
 
 	/* no need for update QP1 and mac registration in non-SRIOV */
-- 
2.25.1

