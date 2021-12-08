Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDC446DE6B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbhLHWgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:36:31 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:31041
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237412AbhLHWgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:36:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bx1rsQZclt31pLa+8+pOwrGcx6F8yB0HnL8GQg2lXQkS9CjRBZQXPRxtMNjCiAXI3Nk/VAEhgI2pQvvQ1QlnxkX5JjU8p14nDOzGPOV/ktLLp1Taskwt8LcFDRzLQFV/Gnb8QmgrTGuB8btmmRsYAJFtUB6XgG+LPc5tfl7yKMHRRqoE+WG3Lzoe/bZ6vcHBob+kTs062Z8ToHjlar3wep5pWoFfCwqPtxyRg1a/SPSIVQ/ykUR4hpKwV1lk4lLzlaoLo3OS4URyiUmH3sI+tYeUTlA9mgWbYCYrDykhVer+Y8Xn1ac9yBg0XX561ZJzEvx6P38iIl2EvahvNVSxyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATWTn5wP6qF6pbtLsK56+/G5laPJmXVELt7Ey13mD9k=;
 b=g6a/P4WdqirGeIYSxUSu8ylOYC+JhspeptGAw6eNyIyqYLFyOaI4iBqQrVnSVTLOY9x28GeA5A6m11GwY/R0nAF6vQ5YHZjUYytj1ObhsGFnbuV0rzrVUfvOqR1g3kR+pJewnzCEO694jyA/ZNNYtkNcplVHUFh/OPchmFtZuvzvhXU+o1jtKTZCcLtxpNQ+nNpt25GDW8hwboiUK0bcbid4s+4Ewe5LC3JQ6wotiU7JQsTGCk2ilKxeVEGu+AObd4wOST2ScMwisWQBxF509z2VNigEean86QL+RANdbBwtwopZB5U1o+bh6YAoRyVn71+FkiCepCn8m5gE/Bv6dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATWTn5wP6qF6pbtLsK56+/G5laPJmXVELt7Ey13mD9k=;
 b=R/t5qxz5o7mgCN97owZgi7BpIGcHJKRr2wa25vATM2WlZjJ4gWEpO7rF42xg9UVixWolbbB9RwfVtmhbvfy3redBC0Ro0f6vEs8ymXXOACYwCYDtNDjwRWrQFiJ7RurerV2L/n3a0ZPsGQC4w+JOgwzsqzcR9jSgNUYnee+cUEI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 22:32:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 22:32:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next 5/7] net: dsa: stop updating master MTU from master.c
Date:   Thu,  9 Dec 2021 00:32:28 +0200
Message-Id: <20211208223230.3324822-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:207:2::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM3PR05CA0129.eurprd05.prod.outlook.com (2603:10a6:207:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 22:32:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3641b158-4b33-477e-52ac-08d9ba9aaa3d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34086CBABB12B439D3D28A15E06F9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 57pmOskmeFuOAqrIsq74j3f+Ni95iiKxl5JN+mUiN65aGNkozxnQCAhRkId4xnwmRwb2ZNpU6VvrOhMWI3eXbHI1NQeXZTu3wxGRj0AGRHl8y8GWZn0qAKj11v4TwfsI5zHDeSVers6L4QgXE2/HYdnMxKX9mugNG9Ut/ouZX7zCZ/pA6TAedxFkkvsurxkmTkYxFfNT/bGKiCaQebM6nVn6Pm9+/ZJ7OcC/h+nOWIZr/rUYDwJtNh8l7D9oAgVipwXlSE+4tm+7p7F/AD0TKkfoumHvsDWt/+dz+715rkskgoMoTmvYyI727+nSffIdvL35AmBrvJQPv0hPccMrnVinbi7C8g4vqbD2k6JJqJl68xevtWUQ6dqepXS2ECGB/ezlK4g3dS9ahfg3Uzp2XsUAZQH8FrbfFhKYl2kEVeuQnSzce7+LLebltRJmGlP7nWL8dxzw8c8am/l/45Fri7sZZmveSQt40My5PAsS77uyQ/XbiNad3fYfa3nbKkQhy9Sovj/LaWKhfOSkSM4tsNDpnR3vXi0m1/frAji6cq0qHQpUbFPSzx8KF59ie/S+P4n9k9vB3BA8+t4xgIcMj8pvdPqt5dqMbqdiub2kK+TOxoGD7XM8uq//Va79HKyEPPypi4CoRFfS0DqZilpfp2Ytlj6KV6FSe8XF6QjjOMUQO3wxsPvRA8p4goWpIG4a+q7/R+KwrrHyIKU4d02r0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(66946007)(83380400001)(86362001)(66476007)(1076003)(44832011)(956004)(2616005)(36756003)(6666004)(38350700002)(6486002)(66556008)(6916009)(26005)(5660300002)(186003)(38100700002)(8676002)(4326008)(8936002)(52116002)(54906003)(6506007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IgZwIL17tom83FGutuxizYeP3xZ5GIQDiy9TwIerKPsiHCyPSfsZMBMinzvX?=
 =?us-ascii?Q?eAYphVNMvXg808s9Hwy/XiNv0DO6mv6CQIC35uIaLqzJcSk42/3OveVmtHcV?=
 =?us-ascii?Q?CM4vFs2TjeRsHhNx3IoduJKWdMfS43lurRb8/GvLtWW19KhesL9fcx3L2c9v?=
 =?us-ascii?Q?X51cSgPEvdLAyXRsZSjm3IyHWNhuCqr3wdfvLZmNjmbYlsDaRr51XPU9W4rL?=
 =?us-ascii?Q?CjqThIoUDh0c3gXMeRiB6Rxu0JxnDJgc8NcxagRPAPAnt9f6RhtKoOPQ6Jst?=
 =?us-ascii?Q?jYcristCY6sMWoUkxiJWfQHvFMd0MMS2f5L5h+Xzm5ZNJ6ARY9U/y4NACt/2?=
 =?us-ascii?Q?ahhdmW5PkC/s3Z4Bg4HNZmIO6Wx03wkk8luHCJgpiWgSpzqABaZX59L7xNcg?=
 =?us-ascii?Q?5QMQrBzAF82c6xVWwZlKUlt11Y2CrUBO0uybPBnSbzIbF4v65SmPyJI3p6vD?=
 =?us-ascii?Q?2UHBz2lQ2ANRaLmXYNBjm+1FtG27h78KdaurdfYMBibacIEVmT1fOCWvnfRS?=
 =?us-ascii?Q?tmhVXNGovhY2JclkQJjLCYkqMQ6Y2FF+XswO5O2qxnE0Zjpxguw+CxAcoc18?=
 =?us-ascii?Q?rltWMo5+EQx1nNeBigh8+mm65gUrzykGT72XwtILqo43HiHORaRuWDnk21hC?=
 =?us-ascii?Q?s0I0wlpanDC4d8mXWzeFY0KLNz+AZBo0hOzzsjzqLua5jwrQvmSSUYCebSF7?=
 =?us-ascii?Q?av9oWD1uuuc3jmprvaQmfmqPbcT05Og3hAVoN5uLapAY4g9Ehbotye97ojWZ?=
 =?us-ascii?Q?tvk2qHVjiGodVP2vrF9o1jrDWnbjvBkkE1x7n+UueAOUxrv9UbteWbXjh9kA?=
 =?us-ascii?Q?Vs4qIKADDhpQmijfp37f604iuNTdvVH7XC2cU6MLjRkALazMNNhl9avlGGKl?=
 =?us-ascii?Q?dqdAwAOwr9s7QS/dW1BsIzbs1ciMFvD6XwxP1nbtAqL7vNR/sNmWjwKN797e?=
 =?us-ascii?Q?Ql/Ab3CFEt85B4GxWdczbqNtQ0W8Jq3rcf0poMxdJxQNBOgEMlSt5Z+5M3C0?=
 =?us-ascii?Q?wzC+sFX3vMU/4XSq4HPTHd3AKJlaIsku+SO48YDkWTMB5eExHA7C5JzBDBhG?=
 =?us-ascii?Q?3gniEel1xoNaf7M5oZZlqb+zrNnhEKiGvA3NydY1Qxz5tqdrk2dz5oW7LqLO?=
 =?us-ascii?Q?fI92YGy2caJHqGDd6eZtedECCZPDY5KdHPct7N2omFoIQwZvM8SbDOx1EmGf?=
 =?us-ascii?Q?nWjZVjwy10Q+SLkIA1qwjE47Y2D6CjKP5LvVO/UsjyryNFC4BuuCVYKOL1H4?=
 =?us-ascii?Q?toNGwnwj2ImHf8YzoWprg9ErWgD5UXnA6UB/5mvEycj0CXXZac5kqUDkYx5H?=
 =?us-ascii?Q?2o//OT3T1Mt2+ULsIFNR5/Tq3bd2GUAfVMJ+Av8UeA6yE3oz4FG2jzTujcx+?=
 =?us-ascii?Q?NRR0LXk1KPor2NoaRcTERyu0lh+BzJ8SNSpacwdwq/+8ybiRkKurgKJLu4tS?=
 =?us-ascii?Q?Y7Ma9sSl5L2RXvnZ42SIqub9gokKHMRsrt//v2i4MNzD63/1Qq5W8VvNMZ78?=
 =?us-ascii?Q?YNkAYIVh0ka1R6Ddsy+zDCri1TK1knZ0QjXZh0IlEx98w7ODwcvVFh+2gUqL?=
 =?us-ascii?Q?55ALZp+ik1NRNS0tLc74B+RMwpZ3r5nmYRCh2D3wb568m0PdbReXloAKwwQ0?=
 =?us-ascii?Q?HBFt5OsSwN6Om0SUxiRypSE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3641b158-4b33-477e-52ac-08d9ba9aaa3d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 22:32:49.5073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghg4JBM2tz8iCDSHTXZVAMAhyXohOgawUrSq3iZnlV+97vvT9YrMCNy3m9o1Nt8M/xB4xBYZJ/yRS87RjtbZIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_set_mtu() call from dsa_master_setup() has been effectively
superseded by the dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN) that is
done from dsa_slave_create() for each user port. This function also
updates the master MTU according to the largest user port MTU from the
tree. Therefore, updating the master MTU through a separate code path
isn't needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index e8e19857621b..f4efb244f91d 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -330,28 +330,13 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
-static void dsa_master_reset_mtu(struct net_device *dev)
-{
-	int err;
-
-	rtnl_lock();
-	err = dev_set_mtu(dev, ETH_DATA_LEN);
-	if (err)
-		netdev_dbg(dev,
-			   "Unable to reset MTU to exclude DSA overheads\n");
-	rtnl_unlock();
-}
-
 static struct lock_class_key dsa_master_addr_list_lock_key;
 
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
-	const struct dsa_device_ops *tag_ops = cpu_dp->tag_ops;
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct device_link *consumer_link;
-	int mtu, ret;
-
-	mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
+	int ret;
 
 	/* The DSA master must use SET_NETDEV_DEV for this to work. */
 	consumer_link = device_link_add(ds->dev, dev->dev.parent,
@@ -361,13 +346,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 			   "Failed to create a device link to DSA switch %s\n",
 			   dev_name(ds->dev));
 
-	rtnl_lock();
-	ret = dev_set_mtu(dev, mtu);
-	rtnl_unlock();
-	if (ret)
-		netdev_warn(dev, "error %d setting MTU to %d to include DSA overhead\n",
-			    ret, mtu);
-
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
 	 * sent to the tag format's receive function.
@@ -405,7 +383,6 @@ void dsa_master_teardown(struct net_device *dev)
 	sysfs_remove_group(&dev->dev.kobj, &dsa_group);
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
-	dsa_master_reset_mtu(dev);
 	dsa_master_set_promiscuity(dev, -1);
 
 	dev->dsa_ptr = NULL;
-- 
2.25.1

