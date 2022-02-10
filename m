Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F454B0DED
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbiBJMwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241755AbiBJMwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:33 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE553264D
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5scKtpxXyLsJ9WWe+S5+toPP4XNf7ik+eudnK0WXN5QumlVWhzV57jEayaVUlKECPA0ROgTc737PuKq902p8SHndHaWtlfyqELHo4ElHuO9PKLTzCLyThaZj6f8tg5LY5jxwI48Vo8PihZhZzSHCt42kudThwTDuNANumIIINDWNlGfI1xEzluRnreX6CXUYgSN5+TB5s36U3fyYbWpXU1w/Z9BTnSNKTgZeMdMLjM1UQj3shrx+vU5MwL+iBsbhjPuRt28zSW/WfBwlH2U7pfAuSJ522e2Sj6YZ3X2AfiQrQh1pvzMfei9ThCb5lJWUAXvg70vgiw8zNrDx/sqzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSOciY85t9Q9XRnVCFphWhjxZykdoQnrwjCrvk5J3/0=;
 b=nsHF83sNav8AbUW4ySzqEOv7XoO+d2PoMLhGOK8PJ3qnu9Op7tX7VD+1WzFd1qT4qkPtzYolyjx0X6zlsNc+27y0phrC4v80NGXiIB/m5MbQUNhp0xK/v4miQWKYpFHRZdzWOsjQCQdMHCOv0EDMxSyaeTn5Upm7fdwkdsoiCwP1mlMg2XR0mVMPQyS2Sw87wTsqQnKv4TkfDHJ1aTeEJf2mJVi8/gdB5fxdX0nWatGUQ1NAN61/ARQEpZ0RVbFx5VEwgmPUFAsJCItMrLE0MZVtTr0LoUvfyc9puet8DjDi5KaKj42S+JrlhxFFCtYqsw7MkpAgNQJfu68PVlO6gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSOciY85t9Q9XRnVCFphWhjxZykdoQnrwjCrvk5J3/0=;
 b=Htpx9ZnpJ6rV9S8XsoPxse4n6VQjVQUgG3nqNFVRBxa9ZRRvLet8KXdkgVSa9KI8HTzpfzd4K60//JaNudwkAYGaAGDW9hl+BjzJf+6+hFDFhKpAYuTSYnMZAS/mue7X1RsRmjzlmx7cZnf/ZlcXii6s5IesBaSLyIhlg6GJ7HI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8806.eurprd04.prod.outlook.com (2603:10a6:10:2e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13; Thu, 10 Feb
 2022 12:52:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 08/12] net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
Date:   Thu, 10 Feb 2022 14:51:57 +0200
Message-Id: <20220210125201.2859463-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 698292d1-f9a2-4f73-561a-08d9ec942feb
X-MS-TrafficTypeDiagnostic: DU2PR04MB8806:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8806D0D8978FCE37E0E47ED7E02F9@DU2PR04MB8806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AgXXewAqeVwuGQ7g8dQ+k8fV6O+M/H2sU/B1fOtlT1vztgP1qU3xCjA87cUDgta6H/PnEVjIV/nqJtJJQN7jWqdrM4XqC6naZ2X+FW99pr9U5ElzJYbH0gPqzdjAs6e3lHWn+CPhUTVBp0/nluFXylmOSaLIVRjF3y5MJzXIZZut6KGpnq1xLMYW/q1Ynz0ISnARyD9hHYIUz9qspVjrahVdEIF3g1xsOKlxTf9yfXsgKQ/PS9HwZlDM29UOl1qyhVwpkaDV9u1u43w15zzAE7ala+A7UknJvxnPPbjR9hRXT5LVr/LRvxdyhJBi2wroQxlCWf3bCC7qflFhhdcy1bj4RKGvZMIgDxFMRvIjJ9szwJvr5vBj0ZQR1bolBgi68cVG80EVVKH8/9yn4OZ8/b8cZw6naP3reAhfiF90NM71in+Iba2owBs4TvIfU4JrZw/MvnR07ojCFjB6fXTHLIg5pn6GLyzBmpgELuOlJk1tZXYQiOrQAQQdN9s8arlqDkrh2UsSXptmjUWRIR299NBsY6GACm4Zkq1DZGj1FQO1ZDRqslS9MBL67gsEKUsYbYn+DpK/ng/WY3XAZ7RSjMZESVFmPkBny0Y01y57loMTgphSEQ9fm99xpnlxMYj41A1+m6zZfKy8D2MsPI+OXU8Jy2BVqLL19DjuVPd+IxTWw8BE9NtwsLQWkvCqB49gF+VN5JCy4tnVQLyNrRsGxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(38100700002)(38350700002)(66946007)(6506007)(6666004)(6916009)(54906003)(8936002)(36756003)(6486002)(5660300002)(8676002)(66556008)(66476007)(4326008)(7416002)(52116002)(86362001)(2906002)(6512007)(44832011)(83380400001)(2616005)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MjWLxVRxZA5v8EtY20EZxSOOKjd9+q5JIL4A+kXSiIu1K4UTcZV0U6w14Bp6?=
 =?us-ascii?Q?BHKMMfZgQdrAJCfHFnxNZA9k/Js8RdzvT2m/90bF6YkI00Od8dBskQy2EEos?=
 =?us-ascii?Q?1fvcC82rxLFPdCeRPC8pHXR1JKZoEZ5jiAaZMRsitdcq58hAt74DU+i362RT?=
 =?us-ascii?Q?TxYzwpgh+me3zsXCD2scF4p92Fc4rEjWB9fN6TnSsTsbzZqMXGGWnQTRMmfL?=
 =?us-ascii?Q?8mHeCObWiYkvV5L8gi3Qq9kUeDB8kLWAr1pA0thjuv4G+ZAUuMA7vdx3DYXQ?=
 =?us-ascii?Q?7jp6DAk7+hligMEovOE+Ma8N671+QPS97gLd3iX+hbSl4uQuxhrxtpk2LkiP?=
 =?us-ascii?Q?/SdMe7BFoXx7bPx5eCyKN4wt4FBM2jVTuqftVmL6sA6gcGoUQTL2TPwTLshu?=
 =?us-ascii?Q?TLc5nJQ8jRmsDgaTL8aJoL28mNzNKVr/WbkQDuzDetZwIrrDWm+8G3y5UPDj?=
 =?us-ascii?Q?E30HQqasG9VkP/sQc/K9wve3VCt21g0m1EreU8rqgG/yq1ewgsUxctVxsLYP?=
 =?us-ascii?Q?7hj1Bo8rxtYIVAdDtIirNgAvhJkNMlmOR1RZnu3qIlEcV3QDy1duMS7asyll?=
 =?us-ascii?Q?Stzr0MSTvEmx5orlLskCK4GdoJhHFJZP6F72elBgsUujYQyeYafnpoJeMWVN?=
 =?us-ascii?Q?crzcu1Pdobgbe0g8PEfX0BASv6wMKfHFSVkSU3IH+ispzwk4nt3th3jxS6R+?=
 =?us-ascii?Q?6VMLc63bQaMb2zcuTNqbiHEO/ZILV3gulHa/aTNkgAti+r7CyPmpnJTct7Zn?=
 =?us-ascii?Q?XEQ5C/PRlJ/CONn3kdQMuLRKBelEIzzvtE8eVhOKRuECyFvxZJqKQctRGgZd?=
 =?us-ascii?Q?BAVqk8v3r4Ax9yT830XbnPL5uvfwuudxpF2Kf0eh7CbcNjEcFR9QdWG4N4C9?=
 =?us-ascii?Q?5CWuyvZQ81O1EeDIJvy+ToO7l5m+LERVE+yULjO2WlojtnmX3ccLlhW5xjqq?=
 =?us-ascii?Q?wLw/j05leEru018td+EcYeis0rbfsmdzScXFXrGeV7d+yTAfC4ywUXRQnJMD?=
 =?us-ascii?Q?0DZNuOvI0jJJ+XQzRRERgyTbg4e1JwtFH3u8rkrexkThhqzOgr0pZxmcHuDb?=
 =?us-ascii?Q?ERvZ0SK5REcoUDETRu7f5ftwq/Z2aYjLtQBS9pQeit8kZYY1AiJPq4OVopvd?=
 =?us-ascii?Q?7aHW2IDQUMJj8J1PU7CKzw7YMzBZiDBP28nOPud90/fGF7dbw+W1rd+sgwN2?=
 =?us-ascii?Q?0pDr1oRYjdmmMT157vzZXPUGvEEqcfFv5VgYdq9VYSdZLszsTHei6thiWX79?=
 =?us-ascii?Q?2h5G8Nqf1I5Nwouxc4xQUAm7NwxIU4DmRyKbYxS8WeZrLAWvWdPVJcH4ZSYy?=
 =?us-ascii?Q?SODGOQaFP35BTHr6G0X/3RUHuHN7K5lbHp0muSyZqKo0h77S/PwJFb9QPxck?=
 =?us-ascii?Q?fp8BvXICChqieO+r+RnV46AVAYsNM5FuGj1Daipe+7BmpXuqG0V/gY+F25JT?=
 =?us-ascii?Q?uUGVgjfLi7H4p7N7lY8c8kO82/7bdQDX9DsS+QeRsgzz8k343dOff2InSD5e?=
 =?us-ascii?Q?RqPsIzvMh+tCrIL7Kyq74BMXs8QkbJapzJ2PLnrCs6ISqg3yKQdxi+uXBsvC?=
 =?us-ascii?Q?ueYtIURSwMbBlaiohAo9Ksfjr8CVtwFutQw1Wd7xkOQTg62DLXz32xhuCyAU?=
 =?us-ascii?Q?nL8REPNBIPY4QSSdJX9GdJs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 698292d1-f9a2-4f73-561a-08d9ec942feb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:25.4465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PdoAgTrUtIRBQsrhCDuUWwM52kya8WwpiiQW4iC03a5bUvAzEPfJ9yFvyowL7XxmWTm3dPbfIjRYD5s3wcr9/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8806
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
is always a DSA slave device (so far; there are plans to accept LAG
interfaces too).

Therefore, it is redundant to pass struct dsa_switch and int port
information in the deferred work structure. This can be retrieved at all
times from the provided struct net_device via dsa_slave_to_port().

For the same reason, we can drop the dsa_is_user_port() check in
dsa_fdb_offload_notify(). Even if it wasn't a DSA user port but a LAG
interface, nothing would need to change and we would still notify the
FDB offload in the same way.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  2 --
 net/dsa/slave.c    | 16 +++++-----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 0853eed44fc9..885cc8df0c4e 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -117,8 +117,6 @@ struct dsa_notifier_master_state_info {
 };
 
 struct dsa_switchdev_event_work {
-	struct dsa_switch *ds;
-	int port;
 	struct net_device *dev;
 	struct work_struct work;
 	unsigned long event;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 974dc9f025e1..34bb20647bed 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2411,29 +2411,25 @@ static void
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
@@ -2532,8 +2528,6 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 		   host_addr ? " as host address" : "");
 
 	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
-	switchdev_work->ds = ds;
-	switchdev_work->port = dp->index;
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
 
-- 
2.25.1

