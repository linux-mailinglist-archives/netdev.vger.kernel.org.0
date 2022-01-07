Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55829487974
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348028AbiAGPCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:02:00 -0500
Received: from mail-am6eur05on2055.outbound.protection.outlook.com ([40.107.22.55]:43678
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347990AbiAGPBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdZfABwExnoSGj+G7zE3nrww52cgh5XYOM8VfzEury225OIcqap3aaiMt1CHicYEa2rA2X/D1ykvEzkIf0fssyhHoY7nDTEqR01GBaNep/MBIfK1EZvzxrHfF+DhAjbFDmM5LSEKZU/rXLcNLMPcZOHp9sfje7OSu37s98C8Ub30sqmJVcaGD9Pc2RLdVHtX8w/L0bI4vGwK3+iyVvJsMLbZyOjA628Hs5a+cqGoQ05tvhWkEz8aayU3GhH9D1CJpra0dNz4v4OxCDEqRBG/GgkuP2sf7l2lCJyGutVn99kBR+pZkUmcNJVtNoRtCscphdUU0d4BbTK3WzgbLcdyOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVlqftf6hTiwxxW8tNkDYUIvRM74XL05eWYbx5z+OOU=;
 b=fTEjF5lSH0lew1yEW1/nY+kZPrO/PK7YeYDh2JcTxGlQ3LdPqMeTg9lBOZnNs+YHiTwBk4BcT4iga+XRyMsLFXUMk4hSJihma2lnuFc36Mj8XGmebEj/nRLI9DEi99y0VT/SbAx1zfKo0VpQW5hiiC82sYJcz/7fQCWVk0ARQVT90+8cFel+hL8ti3EqMPu6xKo8CtT9Nq15lXE2yPf65APRll80A58UdZbt9iq2ruvNk3rri2Se9HAx1sOoImrFqU91Q2CzcGU96UScXUGbZg66oP9hzmsqDXqImwvvfl6OL6YJ/BqnStSVuMuLmp2Devn6AyLNzL+xlS1X5XszCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVlqftf6hTiwxxW8tNkDYUIvRM74XL05eWYbx5z+OOU=;
 b=DoSTt+wmMkwYXKAkthpVAiOnzMk0w8YL6PlEZg63zJrWKUNNGuJTazmQ4Jv/Eo7zLqob24zQ6o3tlyZG4S2Yhc9GX56/J4HGk0528ngBI4JUgBgTZ+pO3GGaIvWtpwM04vSuDZbQgSFl86HpKAyZzkMouJjxVye9sgWKYmeBNig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 08/12] net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
Date:   Fri,  7 Jan 2022 17:00:52 +0200
Message-Id: <20220107150056.250437-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b302738c-93bf-441b-f2e0-08d9d1ee8c67
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34088FE71B8139A8E0614F0BE04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4HYlQAIbc+O76fjY+phQfFmR09RuGaI5JVJfjcrpvAa1URWJRG6bOdx+K25jACSWnb22jWMXmbs3YIiJdiFS1kALpNSKN60WZGStmkReIA2Bvrsf9wUfiLUS5t/FAgLqBo+jWLJCr8vdidf74wP0HdNk+ohqrHZOgfN4xgi3n8qicLeJkDQYumxGhya3RdJn7Gljfm2r3OVu8TuDEu4Qbdv9m8w8ZuacpILTY/xInXJ6p9Ufsqfv4CO/WJ47iDJQNacSsmAixmJWH21rgo2TCxaLN/K9ii60LyEVMqrSA/tjDvdgq0OrcpueoXkB9x8yLfzwrXlg9n5zYx7lEZW+l/fefYUoSD5xXO4nMaRnXOIHENuCvTVGdZcrk/SpZjuGVw4tRFFtKyJtvWS+Ktzg1e30U0zszkB4SUJytflShtBArKjwQYx24oxY4JMUO8/3oGJhgbjhY6fI44k65f/1Bfo1AwoTZMHns7shEkBHbfNCbrA+crWyaF5Jn7NAThWmtEfOlUY8RE26uqfuVUP/lvCcw5KryIwkO9MCpxuXI2iseSqYZxwx8/4z72975OrPcXvHsyd+wQ1xGY4ebWWhFKgDTaiOmtlFfaskm/DovwyV/UajH7YQGJwo1/0h7fwllH8nGZ9nvohVwYxBh9kWzMcX9xn9RjOVT/X215BEmLVjMEPcURo/9n8mWFhUGsWp0NyL4kuztiv1WJbgc6urKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UWjjWnFgGwg8jSknXV8wxWZUE/iq5Wd0IH5K/DbdmKluYcRGx946LRS0qBry?=
 =?us-ascii?Q?ZV54mqMQdRUrhWCKoUeSoB8PY30qTU9fs3fjAX360AiWTYf2NT/SLf37ADQ/?=
 =?us-ascii?Q?9HpbIcwBUTzE2m3lTqmybPrCn0IXZ9EN9I8uT4MUAKK0Mt+5yXd51SQXkr9B?=
 =?us-ascii?Q?VFr3bfGBik8Z0HQM2PML9VtMu+Ww8FaOxWwEyU6wYVR7/ehaZlDYRLhIrySa?=
 =?us-ascii?Q?N1uFjSkHIfW3+3Az+7X41Qw39aVSTVHJwBqBZZhRODPBU9A7gySdv4bqLWS6?=
 =?us-ascii?Q?itAx14m0Qb/EFKayKgOS5BwwDOcydwtETTfhw+Ncq8YDTQlzeM/yanSI6oyC?=
 =?us-ascii?Q?g/aqVOrTpk/l1uHTMxMfXxc38l7LTUlZ4z58enMl7BsTCbG4KVdmO9B1DrpV?=
 =?us-ascii?Q?B0dZWl7JadJ08DbmaHCOAJsVMAw8+U7I8ovcfgE8bIbc42ovaFblFecoG3L5?=
 =?us-ascii?Q?OsK5SzVOT92En0SC4YXey9MTfW6SCXxW3V797oycFl3aDlAWjxJEJI3TfRLa?=
 =?us-ascii?Q?vrMDTlKdZJwGevtveAI4Qf6y8/1i7fkIxoc1JHM+rNO7k8yoNqpbkTjIaqsj?=
 =?us-ascii?Q?/oWnQ+oC3iFoKPgzqCWawgAjNxQxKu694juYjsVPpWYb3dfnZJsbkscvhQxb?=
 =?us-ascii?Q?SH/5e8vqEsL4c/sNEE+jugGbL5BJYXafK6OaH/mkRhOa5TCXKxv6+S5lEjUn?=
 =?us-ascii?Q?msBB9+U/wEpm9dcbAhBMUFd5kxs0qRluKbKMifBJPRQWUYLOarSZV1Dq2/BA?=
 =?us-ascii?Q?T+1Zx7qun9xdm6DL93iowXrnWc7mlXIseaDJmCpVdIpTZs9mqcMz/dA/GGVu?=
 =?us-ascii?Q?YmJqsQzO1tPKkaCwP3qOlSjp2X1sfa+S76ThwVAWahffaGlJVbNaLztX+ttp?=
 =?us-ascii?Q?11QmzhK2SeIiCJMAjVOlCZyFg6XKwbum1v3pjLG00o2e48jFb3K1GeullEH8?=
 =?us-ascii?Q?gaghkYeCpJ1ELRppsPQKcgAGtFsWdsUefV3lavRlaO9bnEDRAs2a5V0jmpLe?=
 =?us-ascii?Q?PfSl3sLhIU8Re71CVuUGEeAyK6SlfaXpjvPYVSiEj5TB7lUJjb0BFfyJ/ecl?=
 =?us-ascii?Q?r8ugcxbU0YNLaAxJUqtB7JRMyBcbYHS2i0gO+b4l8kVDbZcPk3EmkgCLCxLb?=
 =?us-ascii?Q?nwZkF47+7mAuqbiRxEMglPI/XSWeJlXBMVe2OwXq7FrApiu8caASsgRr+Nor?=
 =?us-ascii?Q?ihx5a5+26MgqCCOBwmp75Ghl37f0MyLaIDXUWLTjw+82pa+pR3l45nyoo8DO?=
 =?us-ascii?Q?E+gp/8y0AkFrE0Dg7B7m/JEUMngSWQQcCW5+iti9ZED3bsDDuT5nRI9bR842?=
 =?us-ascii?Q?csBTg1Bcu+A2vNVx4BpuvumaflPeY8p7zKBJGypPPctahzOkESf6M+EOkQdQ?=
 =?us-ascii?Q?p6v0FAPo4doy2ajMWFhzmMJ+yDnlzh7aNh87HhDvGM5PAFLAfJ8fLiBzkHlh?=
 =?us-ascii?Q?0YTX16j/xmNDowODvAflRWjJO7ir4jUd+JAIfeZ4f0zooiHlchHN/PvsAjHs?=
 =?us-ascii?Q?muH/CMn+Qoy6k2BUCueYEFpSDJvm+Nfge16pBXbLFcV/EwRFzmK/Htolo8v8?=
 =?us-ascii?Q?3o6tJLLVJ+4TQlpSLGbIeXYsWH58+RVBLrBq0EE0JCPh6Gv/VmbAJW6R806x?=
 =?us-ascii?Q?TOjuZ+DsvL2I+qSGnj7l3xo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b302738c-93bf-441b-f2e0-08d9d1ee8c67
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:13.8929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLvhD9Il6W9phEUg51Tdq5KjYkVY9XkG4LLf3RJU+NxNqMnhJDZXwhex3XI9P8jASb/niKOOXbhe+3lFT8HbKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
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
index be1b4c7cfbdc..efc692132b3a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -110,8 +110,6 @@ struct dsa_notifier_tag_8021q_vlan_info {
 };
 
 struct dsa_switchdev_event_work {
-	struct dsa_switch *ds;
-	int port;
 	struct net_device *dev;
 	struct work_struct work;
 	unsigned long event;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1d8fe70e0ce3..257298da8f83 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2379,29 +2379,25 @@ static void
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
@@ -2500,8 +2496,6 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 		   host_addr ? " as host address" : "");
 
 	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
-	switchdev_work->ds = ds;
-	switchdev_work->port = dp->index;
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
 
-- 
2.25.1

