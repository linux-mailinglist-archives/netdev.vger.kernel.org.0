Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE5869295B
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbjBJVdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbjBJVdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:33:53 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2054.outbound.protection.outlook.com [40.107.22.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2647481CF6
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 13:33:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ksj4Gq6dxNXlYnNyHB53jXdC18MwjB8NTabKpaaplfKDaWkOq/JB1u92BSE9xl7CsGq1mxCeL6FQWTvlkFEE+OvPtY1yHhlQFmmFXkTcEP9d+c6l+Wh+7wLkSZQAWZucl/X6RIJZ8PB4h7CC/wUaVvQsNkLASZpg1aA3zG2kHI8sPHaOIGZRVLj1jwZIlEwfQf8GEullA7rMbEaneFZnlAwMH6JXDo0l+OZK68OJ5KROQQQ9g8HpO/cwukVYaQSL5w1qlvxvpyR1B+b749JDGc+toJht6cVuhqcr83bgAjE4PLX3DL9wintD5Khta5GH/ouk0ykKd94tU13EV3qFiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHcbjTPTauhNxpEcAIM40ZS4XOToCjT+IltAJPukQYA=;
 b=f4pmnBQup0lPqX76iq2Oc2p0xLlt5xL3Y8tUidqgBZajORKnR9KuCnpOJDcwGf+lCpxK5Ac2EqrZe2hg18YnPhTehOP095lEoJ2YWnQetNBWoh1LeXYimVH75qC9tNR3I1IAbIJpcOmBVJKd5OUzpecIarA3Rf6qrwaeh/boLmFRicbXsMQn6LkTdytP4bFmPMDW8l4VAnjctYsEyaYQemldiK9/0DGDy3OIZoGspaxdLl/Rjy2MRPsZPl+hTGz6mGa77ZiqcyRyzghoZ702m+9HPlp5FodsIfgWXZqgzICVZUgAnc231efkjLgnERcnLqgrN29RuexD6XTaZpryZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHcbjTPTauhNxpEcAIM40ZS4XOToCjT+IltAJPukQYA=;
 b=UcPl9rKRAM1OwsJ/higEKwHlAu7RFDvzucvm1FqcY+/Ovav8JSL8Bc/+1/X/I5Zq/TY6NuXj53k4sV++/YNkuuOs9e6GyIMBqNTLw7RvL6H4j8U3bou7iBQRkXk5z5TQwCbAUKZ+TqMWTf9uS1gA+nY20g+A6VtZOB/wruj/0xc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6881.eurprd04.prod.outlook.com (2603:10a6:208:18b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Fri, 10 Feb
 2023 21:33:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 21:33:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Subject: [PATCH v3 ethtool 3/4] netlink: pass the source of statistics for port stats
Date:   Fri, 10 Feb 2023 23:33:10 +0200
Message-Id: <20230210213311.218456-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210213311.218456-1-vladimir.oltean@nxp.com>
References: <20230210213311.218456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0019.eurprd04.prod.outlook.com
 (2603:10a6:208:122::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM0PR04MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fb0999b-4693-4693-de70-08db0bae7288
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wM5NJRruCK/JzOS5xoO0PLh5O04VOQjT3sd3txTwt1ezggdAwGKQmqpKUkZzFX+jJpf3aG1dOwSZCrM4xehMU4IuB6mQ9rjx+ZLBP9gdjAxfQ0Hj+reU9gOeO+Na9MwLE3L4dFQ1qMvdubqFnksWf8ZoK6Deu+teHDteuT9KwmZUrIqHy5yFmg3nDq9ObzXI4Z0JVMR0+w+Ns6EWP1r1D2bgzb6eR2huhiDxhdVgcNIi7Ax/wuO1srVs5xWLyzgMfYStj1tLKP4iopeis5mHSrh+c9O9H/zbQjMX6uVO9EGsCid+XYdAPP+y0A+DNXfkTvIuly91EN1qYEzHo3iHUFp36abtWuoL/Dkebb9XOVBfEX4+tUMFsjAjiTJbG+V4+rkxxzpF2d/NJLlwcyXmXyJPxp9jlEPkgU0NF4Tl8GHWotv1P1g1KUotT8Vk4GmhENhv7dOoYHJMlEMivlTuDi/AcLvBocc2KACDmih5pNV5lEIYX5l7lPVRVrQCn4D39krRkkSInVMKZkY+4tA+NpPE7lExOojnMfowoig8/eas+62U9kWXqXdk5qyIbgVv/oZVcqw5iPd9Le4Jtygx7Zgu3MYPa2YZ2kX/iJhWtTlcFI1xUrln+Q3GXR9taSyXCtijO4gXJh8VJ9xtqA3+VNTJnKrgq1XT8pHud8ihi9mFSp8GwjWkq5fWJxzQL3lcgPIpibKsCZVJ9nwsn76CMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199018)(186003)(66476007)(6512007)(6666004)(26005)(52116002)(2616005)(478600001)(6486002)(6506007)(66556008)(66946007)(1076003)(54906003)(316002)(8936002)(6916009)(4326008)(8676002)(41300700001)(5660300002)(44832011)(2906002)(38350700002)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fhI6eDUAzVC+xnxy69UUWHcG9sKbqSazOrWIza2QlTQyBNLuYfV2v7576/fh?=
 =?us-ascii?Q?HhbF56GJJAeUm3Xhdfd5CNrLKuxTM5gb0YfGV4/Ob0ahe8mLJaNRwjAYppvS?=
 =?us-ascii?Q?v17WMkGIvFoBhJJx+e3YFBz6xmvMCqWMMjFYDbtQInCvvtX77Ok8Zw/PhCB0?=
 =?us-ascii?Q?/XQx5FmJy+gFUq+l6YMckwOyAO0gBgpjHRgmN40yNq/7qhhkKmdc3cgWvCTb?=
 =?us-ascii?Q?AjP6A+7CoEaAt8Vc9JHnTp6CsQN0CZGrmJJ+I/IQHcUa35D0qUH8m9Vev3rf?=
 =?us-ascii?Q?XCE3piCNthNB8hgV6CGhltMLX+DpYcWyOjz7S6irevfZrsRP/0G12wl1GfPG?=
 =?us-ascii?Q?7SGQPwSs1Un53Y9ftEsmZS6uzX76FLPQ3rbLaJbIU+D9/pVuX6BubqvQFRVW?=
 =?us-ascii?Q?I0KDKSBHaTIH/kP0+yiplmbG0RQVNzH9LvS+nCLPI7EI/4TJ46SIvAglZrHt?=
 =?us-ascii?Q?kJazIJnF4Pbk7Zv9Tel7krEajAyxUsTOtZPicYWY24MEYojj+7Xek5EgXLU3?=
 =?us-ascii?Q?opnNPMjFS/I5TEZ7lNb+WwnMSmxfHO+/wwPJkK4Dgjge2Or1UhQ4f4kLOXPj?=
 =?us-ascii?Q?tVfFSNppVrM7VhROpkVicoWEOD1W7bpxiMcNg2NGtorsgEz1b6Eg2eT1OdxA?=
 =?us-ascii?Q?Ef0HvciKn7MGJqxUAK/9fkfFU1fYkDq3z55GVsPnElUrxupNtMW6xIuMNHWu?=
 =?us-ascii?Q?mNdmitzy7R/28TnW/wYcjVhOFRW7RrXhn8uvSy5HTGtMp3e1Wb6JkpzCSrIX?=
 =?us-ascii?Q?8GYAqirrBYAgTll1K+2U5k9lSW7oWPqZqMbbelrqMdETf2VAz0ZgotefmJQd?=
 =?us-ascii?Q?CUFEmB6yQcaBMmYd3FHzroMIxOZhLyE4uKy4UiCvxsZhlmzTsG5lZb+ElNA3?=
 =?us-ascii?Q?zkBw8lFXBH/7LARHSGGinhORdnhKgWhTe1GfQM5raPjPIpBx81P1H9Z5IJzY?=
 =?us-ascii?Q?gWUQEO28NKcGo+24Bdhs+V+m3ijkOEXzJxBJEqXMwi5+WHOJpQMwLNhsjabX?=
 =?us-ascii?Q?gQ+2x1qfvZwRUUl/yBefO3AamzLqkiE2QNY2Z8qhXtvoK3mUmlxN4mvl2v4B?=
 =?us-ascii?Q?ymErQ8lJ8AcBN6dpXAFsBHHPZxXIHDxjmQKyvsFZRS0l1LQUUfjtR+hD4fa5?=
 =?us-ascii?Q?K4C5eRnrtItd1MpDxgLFmrCwmjNNyrwCTSn+cG9lQFvP9hrx1VQYQwNTRAf8?=
 =?us-ascii?Q?h+kJA9Ye9LKNCeb/BysnNnE9Li+xCz89BzD5qhABbY7YJSBkfes8BMV2T/j6?=
 =?us-ascii?Q?SgPpq3U55rTfkpUQMkwVLweKUDSs0RExnXW06q5s7v9bHuC1+ZAqGpPCYo8Y?=
 =?us-ascii?Q?3XmzRMp3gw+QnIXcymap7pznT79dbPGWIrTxVrrPu6LJzl0wwcqeA6HL//5K?=
 =?us-ascii?Q?VCqDfEA2O+fXtB0udQtXBbSyCJxrFrFQdNFSPk1ENFPkUOAJP7B9dIiXWgXQ?=
 =?us-ascii?Q?OOmudj7pUrlBpplWDqTB4MmY8jo+eR80OHlEQAr87XumS3m+971dZ9X+A4gk?=
 =?us-ascii?Q?FlbyQJJCQhXxr5M7JIe8AUaYyA5wQ+I7ba/V48RlLrowvK7JE3jlU2H27+zG?=
 =?us-ascii?Q?xkJ8RYqDziSf7d1LIBw+b3/Ijp0EL7BqnuKy1g5yzPbz0kk4ggaCXfX9+v9D?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb0999b-4693-4693-de70-08db0bae7288
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 21:33:27.9032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2VXv7wE+OMSB2W0bqPp7J8Z6Vjk0Y/NseZMKxBidBdx0X0EOE/c9bx4QGqjbFWB+4ArGu7JCR/e4HRiUJuNew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6881
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the ETHTOOL_STATS_SRC_AGGREGATE attribute for the following
structured port groups, to allow looking at eMAC and pMAC counters
individually:

$ ethtool -S eno2 --groups eth-mac eth-phy eth-ctrl rmon -- --src pmac

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
---
v2->v3: none
v1->v2:
- ETHTOOL_STATS_SRC* macro names changed to ETHTOOL_MAC_STATS_SRC*

 netlink/stats.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/netlink/stats.c b/netlink/stats.c
index 9f609a4ec550..8620d8de1555 100644
--- a/netlink/stats.c
+++ b/netlink/stats.c
@@ -268,6 +268,13 @@ err_free:
 	return ret;
 }
 
+static const struct lookup_entry_u32 stats_src_values[] = {
+	{ .arg = "aggregate",	.val = ETHTOOL_MAC_STATS_SRC_AGGREGATE },
+	{ .arg = "emac",	.val = ETHTOOL_MAC_STATS_SRC_EMAC },
+	{ .arg = "pmac",	.val = ETHTOOL_MAC_STATS_SRC_PMAC },
+	{}
+};
+
 static const struct param_parser stats_params[] = {
 	{
 		.arg		= "--groups",
@@ -283,6 +290,13 @@ static const struct param_parser stats_params[] = {
 		.handler	= stats_parse_all_groups,
 		.alt_group	= 1,
 	},
+	{
+		.arg		= "--src",
+		.type		= ETHTOOL_A_STATS_SRC,
+		.handler	= nl_parse_lookup_u32,
+		.handler_data	= stats_src_values,
+		.min_argc	= 1,
+	},
 	{}
 };
 
-- 
2.34.1

