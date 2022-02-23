Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B433C4C14F9
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbiBWOCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241339AbiBWOCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:02:00 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30086.outbound.protection.outlook.com [40.107.3.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A722B0E8D
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXvdFtUaFVBuhvi6qy1JQoHk8kQJ/FMLyMeDu4gdr9Dip9KLXEJlKnzmPy32VN+1iwna/5EqSAZHRiBeSa0mLrOAMF3A2TdbKNhTw10yUdb0b8dmc+6/09nZUtrtoQrneN9vdilOJikzdKcn/gfWdWbgFhEHKWDRB3NOno2VAbGHt2mHaQsZ5IW/46DXELfSzsydJCnhPM3iIA0wB4CO891MKfaCOeT1SOpgDrBB7ttIC0qUVFWyThtys7xCYOs2uIXEShpEiOKCrSCFDId1yJcj1ZfLIT+eCe88p07F3G1nR/ZGhYwxEBbmOY8Ards9xWKALMFWvQYthhyBYU4M2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iW00AayaLTXKU9a1aVyvfvqnRfbYVwI2wPlg3AfVk0=;
 b=U8xIUbyh/IA4uG+g2mhNnojIZmYHRcgw1Z4uE1xOzHLEVmJZg0wGr9r4gOgxtm9E7vzQj+s0oHoq+2fLOkxSzIikQHBhZoVMK+G8cMCxy3Ad2dSq8wFnKjXB4Noe54kF/iLujLYXlUC3XyBiLyq6z/cuuNpUHcJhqaksMh4UVH/9akZUuLQGrtkt6zP3TGB0o7EPdSQG3OOAKdflHeYLal+0dEcWpCJh6WUboBfPXMHTuF/shhDCnjiw4PdU8noaU2NDWR7eNllXDjDGVCzCKmniBJkj2KwRPlYjPR846C0nkIGoczVDvtibx6snL57A2f4YYAtHF5aUMX/Kuo1g8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iW00AayaLTXKU9a1aVyvfvqnRfbYVwI2wPlg3AfVk0=;
 b=gc+wcUVMKEx7ZyV+x3JNVXEM/06OZJBxHjryWP26FdJaClyADTo1kvVNIETluHwIr8WOOjqLnlpBOoTgolvFqnjbFAAvv/cg5uEcctA7k7+TMhqwKqkpIVO4ooGlTjr9qwqUGnv5xRsvOevokySVsiUJxB37PYUgfGm95yXLbAU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5164.eurprd04.prod.outlook.com (2603:10a6:10:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v5 net-next 08/11] net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
Date:   Wed, 23 Feb 2022 16:00:51 +0200
Message-Id: <20220223140054.3379617-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a956217-645e-4676-4c0a-08d9f6d4f568
X-MS-TrafficTypeDiagnostic: DB7PR04MB5164:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB5164D4D8810704BFBA522C5BE03C9@DB7PR04MB5164.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TcfShGZQlTN30rbOQQSXHgWiMBX/kxAKF4W+HGNdXvB+kVzo0oZWPytKiiNa32PPpK2ufuxAb+mBhjSP5VwBzYF/kLIZg1GH+cqUr56O6/b2FUSyLAhDdX140EMvgsu7uoBkBJFPkJhsN7Bgatt+0EoDHKVhvfwmEnFxhzCofqUVAh0wSI01etfCNtqpbT5OvbQxym4XFmNpccbWOS2IfdJwF8X05OrT+TO3qK6D5s88tXFUqFwusk/QTLDiCP6/Rzreu+hSe7XQ3CfcBFSE08TwSsVImiyKd4mVijJEeyDq6+4OXphG7+6k6+HYViLdIlhoSZa3qsl+4gezSChrMzD80HEHBbc/zgteD+U6R1TjhsUCbrvicDMFYlW4TFLBa0/Qj26ep9C//V2sZ71bBuEiZOzih9ZRpinec/mWVPZ726P4M2KupLp1X7+N21z1wg7YklEyPfs797LEbIGnNV78xE5Ux0ha8ANnbSVPmIxiCWc7lJvSVURH7FoemsFR+FEoCCQWkKnpH2irmU+4BwmvU7v3mjSdt10iycXk0ndEftqgbMevl0MVNuM8IX/CGFzev+y2hYEhtnIXa8F6eEQlQ/+z81IK0ZtruMLNAJ26ZNYGRn9bFcd2RGBsSJNYEGoMSwk8DVwHabogRLLyNCKqY4aWM2/9u59Myc1VLORdRPl6SyWd7112bLmVdTFbDP35CHTtfyPARpyOMpOx1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(38100700002)(66556008)(316002)(6916009)(66946007)(66476007)(508600001)(54906003)(6486002)(36756003)(86362001)(38350700002)(4326008)(1076003)(186003)(26005)(83380400001)(6666004)(7416002)(6512007)(6506007)(2616005)(44832011)(5660300002)(8936002)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cyzkRUPWTkY1aez8DEDW8qjSnOM7MWU0Jznzl0o1SzfDhSeVzKrH2KMzHvZ4?=
 =?us-ascii?Q?3AQSkksIqm5yuTQQdTc/1/wHRkBIUMwKQybl7rtdFGiOLdgY3DarOuya/fZd?=
 =?us-ascii?Q?XGI/z70o344j58ztrCzFFKrEBGsz0hzbo6ZIY/mQwtVs+2d6qNbjczqn4xck?=
 =?us-ascii?Q?/O0Dm5t2xTz//dqnHKSZ1ka0sy0RMoUaCLLy8pHAaXQNLCrHfB25cimwIKLL?=
 =?us-ascii?Q?MZDQtiVQV4WBJ9xMzptLqisvI8lr3xCQssxB9+4rLxBhDhjsj/cVhBRqEPhU?=
 =?us-ascii?Q?cXEIRMZuN04rZbVzCbqq/XjG5qQK3EZmNBafkB+DvCIiGA/hii1gmtWbxZ7M?=
 =?us-ascii?Q?0BjM5cTBd/Qewor6qbmZjam6sTn0SwNi33ey1xrw89+5YZiyCe7b7FJ0eRSg?=
 =?us-ascii?Q?tL7WOI1y9B/sBUGg8gNZIEW4U+StqaAsn0fpm1AYfdQijJ79OXGZiXETTgtY?=
 =?us-ascii?Q?AO4ysWEy+tQxS60W27OL+5MGA8ggNApEsMq3UR7xrYiQ3TjuICR0tJqish+D?=
 =?us-ascii?Q?XRU17FgrRMiSlaQgu6kdKBMWBjxlxGaJ8aSWdl7KkRBi7CQwwQ1AGM9vfm6G?=
 =?us-ascii?Q?8DNL7fnoedzifjFAa8slUeLRz0QNRKWF++GC1ZlkEW4ZGIMS9clKwiPsBRGw?=
 =?us-ascii?Q?QY5vd2uSvcP0a5Js9pzDtsU833QcD10gU9jvmFOC6JPpONkkI8JG/Xy6A0LF?=
 =?us-ascii?Q?DUeUDNjXN451XjH6Rg0i3luI3e9sqZG/3ZornZau1DDcRE1hcw4K05bcYIdk?=
 =?us-ascii?Q?NLu3PbjnAZ0wIMm9DCTVjv4kPOdrLgIVraBP99BjAKHLxYEWkvj4pY95gNWG?=
 =?us-ascii?Q?ZJczbacTb69CEKoJqAI4LU8jTWD8hB8tG3PjyVBlpl4r6ZHHCFd4BaR8RF9F?=
 =?us-ascii?Q?wwSayLZBAAyXcT7YLsQ7PQQFamTm85sblHM+cEuans2utsXq5zrPQPI64Qum?=
 =?us-ascii?Q?dYySEv/cU6a5HVIVM+go5PRg6xmdzyzyWMmMirEWu9TE2kw7UGzL/P3WBqZT?=
 =?us-ascii?Q?iro5AMjXiNu7iEZoqHY154MZ6wAKgIjkHi6f4pWJAD57EGLG7ZDOCXt5Xffy?=
 =?us-ascii?Q?AUqFLbKC4zEUoo4CuamndaiaGx6kOdispK4SaTwiAj1D2Fh5AX5euvpg5/4v?=
 =?us-ascii?Q?kel4fLIYUuJdGgUR45QWE3O/Ic/udAKVzuGwPLYdyQhrLCpt71odgQQJ275m?=
 =?us-ascii?Q?twkCjt10oZ0nLyUU/XpDYnikzQ6GMsb9lzHFbW3TB5uBUyN49S5QtzEo247g?=
 =?us-ascii?Q?SCYdfh3Sf6ZCkh50m6adseC3hPa7Z8Fw5NV4aQJ1+uIn6cWNK/K3PMM/VF5d?=
 =?us-ascii?Q?KAyizrsv0YsVVnBzEht6YGiX81EOUBPlrtPxKsmdfHc2jp7fHhLZps6GvsBG?=
 =?us-ascii?Q?7VpgSp5EwEUptinP17b8r4BCAT30xxLc6n7C8reFtiDqo8uSCdlNpcO2LZ3N?=
 =?us-ascii?Q?DzT1zASbVG0gVDuRfdOin1SP1nzhyJV2qyh/0LgGGHmu0OkaTJdgkwu/gB4S?=
 =?us-ascii?Q?FFsDadhawE3KdY86zcTXAbAaGT9uYhTrVJHUQPdg+a4KzSazS3iiMKQOJ0qb?=
 =?us-ascii?Q?BHApK0ja50wak5lm7TRtXi4Z/VnrX3k2s2ZVaEe6hJzyADXN2FYvfpyZDzIf?=
 =?us-ascii?Q?t9XjVjV1z8gYIBxVJQENUF4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a956217-645e-4676-4c0a-08d9f6d4f568
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:16.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jiy8ebgrnRm0T3SK6pm4no9MYtAu34ZElnYx03Bropi1Uzv38tuG4dQqd18qS2zBsaEFCucBKeBPYWx025FUzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5164
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By construction, the struct net_device *dev passed to
dsa_slave_switchdev_event_work() via struct dsa_switchdev_event_work
is always a DSA slave device.

Therefore, it is redundant to pass struct dsa_switch and int port
information in the deferred work structure. This can be retrieved at all
times from the provided struct net_device via dsa_slave_to_port().

For the same reason, we can drop the dsa_is_user_port() check in
dsa_fdb_offload_notify().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v5: none

 net/dsa/dsa_priv.h |  2 --
 net/dsa/slave.c    | 16 +++++-----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8612ff8ea7fe..f35b7a1496e1 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -119,8 +119,6 @@ struct dsa_notifier_master_state_info {
 };
 
 struct dsa_switchdev_event_work {
-	struct dsa_switch *ds;
-	int port;
 	struct net_device *dev;
 	struct work_struct work;
 	unsigned long event;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4ea6e0fd4b99..7eb972691ce9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2373,29 +2373,25 @@ static void
 dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 {
 	struct switchdev_notifier_fdb_info info = {};
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct dsa_port *dp;
-
-	if (!dsa_is_user_port(ds, switchdev_work->port))
-		return;
 
 	info.addr = switchdev_work->addr;
 	info.vid = switchdev_work->vid;
 	info.offloaded = true;
-	dp = dsa_to_port(ds, switchdev_work->port);
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 dp->slave, &info.info, NULL);
+				 switchdev_work->dev, &info.info, NULL);
 }
 
 static void dsa_slave_switchdev_event_work(struct work_struct *work)
 {
 	struct dsa_switchdev_event_work *switchdev_work =
 		container_of(work, struct dsa_switchdev_event_work, work);
-	struct dsa_switch *ds = switchdev_work->ds;
+	struct net_device *dev = switchdev_work->dev;
+	struct dsa_switch *ds;
 	struct dsa_port *dp;
 	int err;
 
-	dp = dsa_to_port(ds, switchdev_work->port);
+	dp = dsa_slave_to_port(dev);
+	ds = dp->ds;
 
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
@@ -2497,8 +2493,6 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 		   host_addr ? " as host address" : "");
 
 	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
-	switchdev_work->ds = ds;
-	switchdev_work->port = dp->index;
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
 
-- 
2.25.1

