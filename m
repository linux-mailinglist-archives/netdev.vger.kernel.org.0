Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A10C485C28
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245322AbiAEXLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:11:42 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:32794
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245315AbiAEXLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 18:11:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgcZ7FYpTVgwaqe5CV8pClNPiDgzMqsNUeMALQjfGKRk6wcchDrbbBcD1d//xXRJhTYOclKGTDag38bAVY0JWl9ABuGJla3nEeMZ22D+HAGjtLGYPBTyf3F4vJ+S+w8EfvLXb2JTKV6oWAaiIV72ai7xEBizIBY8kcOlFZSvrH+msHvWf+RdZz2Xh8As1N3SCZcokls90XM/Ss6sq8mNERMbZmBh+N47wWM496y/KhduLcvCoeblAdAl81zGNndilfql5jUFAAijXg8OgfErYwn6dbK/TqlwwX8sWqXwpplmGnOLVHbRTyhp+Mpq6LTlsNKVVxG5z33IgR5MUc+YeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNtblGp7p4wBCGgGNQfnEr2TzUFeBCZiDJ7VuC3n6YI=;
 b=gqil9qgf4pWdZ8Yexfcld+3qKB5sU7vXwhAr7putk/a8z59sKw6Bg3ZmAgvNXfvomLmut8vAxaIe9vAfCOJ3ExaRzLOMNR2YUAQKNS8DEquPiVknT4EWyoU2NuYKxCdx9CPaLah2F9bJllysxnDfCu5Wx73dvl30/+qIyDuvhNOD+778qlVlTzvTbrwGJ7tyTBBLU6yksqcIlJyJ1eYPvJjKVw5a4K89vXaAIxnl6B124zvH6WvrFZlkavSMtOF8PQm2XFi/4b/3KO8V8lrUB0gzzR4k4InhwOyTL8UrPWjQ6Qf+jD22iSO75sw3PcfpqdJCuYcXykd0qjGJC3K03w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNtblGp7p4wBCGgGNQfnEr2TzUFeBCZiDJ7VuC3n6YI=;
 b=Ocug9cjtf0NUUNNIvP7zug8J4xLg+ggeNUYsTvyHbaLR2Gtf71ivcwUeJo5EL2ncarbl5QQgWemkyVEBMP7tWyyUbS2pdTFaojy5lYl7JJ9zERugph7lS1JoMRLDb3KhIqHCwiEAb6lZ/gc2y/ApJBqUNZAcwQqzeyEqAvOICJM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 23:11:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 23:11:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 4/6] net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
Date:   Thu,  6 Jan 2022 01:11:15 +0200
Message-Id: <20220105231117.3219039-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
References: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0081.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7700fb0b-a45c-4008-a428-08d9d0a0b6ee
X-MS-TrafficTypeDiagnostic: VI1PR04MB3069:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB306947EF6023C6E5AAAD97F0E04B9@VI1PR04MB3069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6sYPE23eAui7YT2I7N+mRaYWfghOcU/YYtZki23el8M0QmIrmwv0C0ZfLCC6TswXBH6RXqGxkLXaniG8fSgx2EsBWQ10S70fFipWvThYLzNcT6h3EyV5RY2p14jiitaypX8dMriMnH65ReLu3g+JasUDm7+xXSjGHoENk/gJ0QsjcZH5rqo/SRKfVLXMMbRlV2crr1mbwZsA2BJhRnkOuTWMXXHPVke0g92i93LuBXXLtYdth+DLnhxO0domxy1DY+If7ijDOlWbmukOo1A28156NVsSINFnV8RBJ4sHVE1WibiechrgrA6rTgDI+m+zE6LDtO2C2Len0AOGY0TtC8ywKYkvWYAjpFZHM7aJ+EJHv1/IZVbgyqE6yzeDDZbTPaz4no+KHqav8zKow3hlL9xMnnsnhcWCGVCS6brICkYk54mEKpV2j3xPnKG92XWhDBBC1ycshNv8JdFf5gZKFGqOGo0bGhGHO2ASQOtv22d3u66PbXT3cAbUyfY+hnGa2ojbsyg8GsrPwgo+YA47aj0stmbL0KeBEEFrKWyNIvD8zpgVkoDtVJHhkelcFwBexcVINLP8BVmfilFZtMJzQGexvezMxZzB5mMc2IXzIZtIpvo00Dck7o3R2NdVSPL3+/clvhIGciP+IL0fG+k/EZhuSw+V1WgKopjIyEMNdmcAb4YzXV0guRMq+3iEQaVvTfOrDnFIEdQs7lEQscx9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(66476007)(66556008)(66946007)(36756003)(1076003)(38350700002)(38100700002)(54906003)(508600001)(6486002)(6916009)(8676002)(4326008)(6512007)(316002)(2616005)(2906002)(6666004)(44832011)(6506007)(52116002)(8936002)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RaWIp6I/XRJjXBS9uGPRIta+lCTrI2G6Q27MTb5BqA+XhiBnTuSTYk0VUsJX?=
 =?us-ascii?Q?8GhmcbN6e/7hiz3QVyQ4oWabkPpitKOXDlklWhV09W7UqW+Y8zEP2KLWQLA6?=
 =?us-ascii?Q?qRSkgjbg8CgiU+cOi9+pZLmbOiq+iCvDcMK50QYFtRfKel9mI9K3/K0bP1zo?=
 =?us-ascii?Q?QNq/5CdXJJztDESlYIYO9bPPe1Z7bM4qE5nJBEv5r8Ksl/BqDQ/YeuovEXLl?=
 =?us-ascii?Q?8GnRNKuhRpUTeMRlP9HeTkTRLGpCJ8pg2ygdms4nvtKYODNDw9BgY8VD0v9X?=
 =?us-ascii?Q?z0dG/lngt6r241rE/NI4r1SDpzygwtEIkV2br0oz/7JO/ByCutoXo1DDivyt?=
 =?us-ascii?Q?j6BrF4J9KINmTH1R+K8SizvTQoN7ErPUFFw7LGLvNEAbm1sYtdoVi5RQxR2X?=
 =?us-ascii?Q?wEYrNh3HozYKaXCwA3Y7gdmgorYIUDQYZAomQITN2fKouCFcvL5j+hPjhSws?=
 =?us-ascii?Q?Donk+ftlZgMgg74FdM+CRlSB6NlsBVCmiKo2orLi3bh/tsTJpyCR+U/Hfxeo?=
 =?us-ascii?Q?lNNyI5aI1WVxZJTktLvkVVeYGmF3I9XvTB9AO3ZO+W2ESa1mZjfK0UDvtz0c?=
 =?us-ascii?Q?KK+ElL0Am8SUkm17gSHmDGGFVPpi+yRQNPB6NviNJBsQOkZdmex1dqSmrJLk?=
 =?us-ascii?Q?uYk+wQmD3/lmNMsQA/Q/calkrp2ZK1V/KySnifRkcUP3R4yQp0DVmdy5TD5p?=
 =?us-ascii?Q?/b1O2zad+w2HCyObGyCUjjB880vU3TTwhhwlNU2grAoHg+QKPyu8DZAbqKBh?=
 =?us-ascii?Q?OVzFv+VHDR0A4SVtiqspLx+dSmUGhjOfm4IBYkF0zEnxAnQJH2zB2gG/zZ5v?=
 =?us-ascii?Q?pt5HPEVnaogVW5yHV7Wlfz2q83u77mTcaJjP5CX7rH3k5e0fXa+IMjanl6br?=
 =?us-ascii?Q?efRGpwNi5hzljaledITf2EPp8udZLtFMS7yVJ13+P45gKzfRXC2NBInkKePy?=
 =?us-ascii?Q?qCdtImSMn3W6R6iDrH+QfJZzFx1gHGK15zXvivT4Y1v1C+dQTf8HEihHrIbk?=
 =?us-ascii?Q?DNAKgPmaq/+IVjQSSMdh2IymwIjk7zDS2mqEJlhnGDG+91/ICc5Fx7EyISdH?=
 =?us-ascii?Q?dcdDdpduzHCjbbhLu7iDzhlK0K7qpuEm2zR7WDF2RGWOP8ECPa0HtLLujTbL?=
 =?us-ascii?Q?e31lz67DKRNYEjY++niTZlh9GEglZw/3MDn/e2QpB5lETFVDTevZUFuAuyfb?=
 =?us-ascii?Q?no10RVShUsNBKvcZwv75hO2p7jNjET0KZrUdY3u3aKyMkjJrpPYLwWnqxIFL?=
 =?us-ascii?Q?/7sI6EmGPl4HPnR4MsEmtVxJ97rPPi8OCUnvNq6yl0oe8Ab+isTaLjJ2vPyF?=
 =?us-ascii?Q?BUBR8y9eODBuUhqlJbIlYKq/ZM5zTxXGTZm6iNGDz4JH6UPX9DYpy8VU/wx7?=
 =?us-ascii?Q?V1Q8yjK1DKwXn0IDen34BOqDkd9aYFqs86TuIVluIq81XnZRk2nlagt7BS1u?=
 =?us-ascii?Q?RgMLoonSs2slVC1ZVfrCwHIAeZN8N40y5t8VpOx7an2JdnbtqfJvHGZNzluC?=
 =?us-ascii?Q?DuH8wwWRP7ZJerNBJsXyNb1DhM+FKIx1mfj2GjD7Elt/NBiGuo3fOr+g77+a?=
 =?us-ascii?Q?qK2m8SQ+YTaD1CKwSKM9hm8pSVAhoG7bSvWflJ39K3sF9PfBB7Ualv1eesnD?=
 =?us-ascii?Q?B89KBiSTs8XzBWMajfAwgZM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7700fb0b-a45c-4008-a428-08d9d0a0b6ee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 23:11:33.3792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1kTT76P8CgV4SUYXf5/T2yPlrYiWMU6AZGAXBO6o6ij8uJg2R/AW9zoSg7IUayfzsKBW+8fkykdxd6/tZyOYhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA needs to simulate master tracking events when a binding is first
with a DSA master established and torn down, in order to give drivers
the simplifying guarantee that ->master_state_change calls are made
only when the master's readiness state to pass traffic changes.
master_state_change() provide a operational bool that DSA driver can use
to understand if DSA master is operational or not.
To avoid races, we need to block the reception of
NETDEV_UP/NETDEV_CHANGE/NETDEV_GOING_DOWN events in the netdev notifier
chain while we are changing the master's dev->dsa_ptr (this changes what
netdev_uses_dsa(dev) reports).

The dsa_master_setup() and dsa_master_teardown() functions optionally
require the rtnl_mutex to be held, if the tagger needs the master to be
promiscuous, these functions call dev_set_promiscuity(). Move the
rtnl_lock() from that function and make it top-level.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa2.c   | 8 ++++++++
 net/dsa/master.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index a0d84f9f864f..52fb1958b535 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1038,6 +1038,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 	struct dsa_port *dp;
 	int err;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
 			err = dsa_master_setup(dp->master, dp);
@@ -1046,6 +1048,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 		}
 	}
 
+	rtnl_unlock();
+
 	return 0;
 }
 
@@ -1053,9 +1057,13 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list)
 		if (dsa_port_is_cpu(dp))
 			dsa_master_teardown(dp->master);
+
+	rtnl_unlock();
 }
 
 static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index f4efb244f91d..2199104ca7df 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -267,9 +267,9 @@ static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
 	if (!ops->promisc_on_master)
 		return;
 
-	rtnl_lock();
+	ASSERT_RTNL();
+
 	dev_set_promiscuity(dev, inc);
-	rtnl_unlock();
 }
 
 static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
-- 
2.25.1

