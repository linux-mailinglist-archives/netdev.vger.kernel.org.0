Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0106A485C27
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245326AbiAEXLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:11:39 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:32794
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245322AbiAEXLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 18:11:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btcfZclCAuAz1v5BCIPK6/C4QeXIO9I+WuypLDONIhBrN90V5tBx0p7GBVvjga/PwLF9TjSLQJx7o6lJp2g0BNqv7C3i08v3Rt4STaJVGSpfawTigJbqG9iOKagFyJKdqN6JZXIUTk9yyeMCaquc5t8B2QuMApp5gEJZAmmoQlzxxMWvGk61CNvBh09HMWJrA0RRMKVnlACA4iCnvHLceVrp0/fNveuWOx1rX3TTKZKqgDpDNC3m4LEzovcGMUpfE8g68W4QB/ng9fLYuImcClnG+GeiEdT5WVOmuXgagJXi+2blIBsyXWaGGMvhR4CTdQsZKN9M2XefQd3rvDuorg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWbE/KHnl5jiZw6mXHQUz5y9TP5cdKiXhmEZFCqR+uQ=;
 b=PapPRqBQwPpZ3Sl08KWHAlKSgy/Po94OlqmAf3gOW/GEpPrv/uvN9WT1FJQ3kBi4Gqb0rv1rMkmVQH7h7XU9i5geXG8UTqAtzgccbmKsSw7ZchZruoKmWbfdVW5uOFl6WSGwloqSc8bxHTXw4FH4WDm/1duywof6JrRTYNlyjUOfDW7RuXa/8xJQjfIIWcuT2Oyh4knWKhcCPqbRJ6JGOAYCpRcXmGhCaQiPzMiLheHqPtqnVolCaOZ+zBriAENSnpg2zG7sdA4BAK1F52Pc36B/RxHho+tT2YNJ+tPc/5JaXkisgnqXnO9EaA8cPUSQKAplpjS6jhfi8UGEvOb3HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWbE/KHnl5jiZw6mXHQUz5y9TP5cdKiXhmEZFCqR+uQ=;
 b=bxbmF7+zu1iHBbvJ0l7o1yRsAjFL4R5K/ctSVXLyjNbzlpDvggTfGZjLepDCG0G25jenDpacmrQors/tCZY0Wa7ISTJH6ayW+akmSwWr/M9RW+7KMIEiD4/etEA5ZCbJrWu1JeGSawbw0kF1f2Pgg3HMQGNli492946RfbG2qKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 23:11:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 23:11:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 3/6] net: dsa: stop updating master MTU from master.c
Date:   Thu,  6 Jan 2022 01:11:14 +0200
Message-Id: <20220105231117.3219039-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7579efa4-bd9d-41be-22e0-08d9d0a0b669
X-MS-TrafficTypeDiagnostic: VI1PR04MB3069:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB3069D179ADEC081100B1B487E04B9@VI1PR04MB3069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ySA6vfd8VWIhcPF9c2z6Tc/oIeH/Z/EyNbC/kt6Dj33KDgdca66Jq2kjgUusIV8vwQhAqhKEy8yXnAq2QakPnn3sPNH2RadUu0mq8J8Si6kGMD2EkUQ/2YZ1jaG4dRZ7NIndc4XGLu9BRT3m2YZs8/+Igul+G5F8ZXO5Dly3rGVqqJ5iTzSKRfISSO64xnd+nzH9aGpxFsT/CrUjQNjILEObOz4gc6fDkJsXii23y2ilnUrE4gX7Zywj0INcU+BwzINsUCt8j8ThwrLTLdxXmsM1Eg6QicSnzPhI70DZFjXDKXHm8ZmVrq0vVRXB0kgKQhuGS/u+3GEZH6gEwnbP0QBekn/FNbKhmSikzg+KKfV+s181vlyXcPp9HbQHsJ29zjPUYTQ7U6B7HA/qnTA9dw6FwHxKT+sKpn0O/vqL6+5N2osUesVy3884EPelBLINmRaZqzl+42v4o71gWum09+NTc8ewd4a+HghAHP0d2C/MRs5XdcFRD0RFyrs/karYizmRNPU23T7ZqTNy8mkA8Vk4YeqRiBhnhZUEQk2+H8aItIyUGdDgVJ29FPaaIcYFkVbPvDdBM+rZ2tVm70K140s1+PGrCtGPhyq9AG5W95a8gnGLQniqbWFqfw/EcLqNeWs2XI5g/FNC5AWE5X/lQpzynYI2+TlAGabdzyWBmjlr8+qD7ozEquOrQ98i+p5tZKsqg/csXv5NnOQQY4CWIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(66476007)(66556008)(66946007)(36756003)(1076003)(38350700002)(38100700002)(54906003)(508600001)(6486002)(6916009)(8676002)(4326008)(6512007)(316002)(2616005)(2906002)(6666004)(44832011)(6506007)(52116002)(8936002)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ebOq8cMZlO8vOzHNMXExWh0KprJW05zUyW7iArfkyQGD8MROBPIWDeaY8qC?=
 =?us-ascii?Q?aNJ6UPgmqPGfJGBvquPwjfBWX0Y6oHVNEDep66+G9KHQstkdb04DuRNVq5eD?=
 =?us-ascii?Q?/MSfIybchFS29GdaZEBS1D7pE9GQw154kjfjZgUdO9BfYTb8tADSZRGaQNbT?=
 =?us-ascii?Q?xDOPtDTsX0zgn+PsooQiD9QEpxBG9XoKuB8WanL2fHNIc8WFmPl9vrpSixX7?=
 =?us-ascii?Q?JIb64ugcUTpL43pHxlUbxbhkLLaan0klhEpIqrpvuxxg847H1rGfR6kI9tmP?=
 =?us-ascii?Q?KImV+fmL14PeIdP5vm/N8mcjvT6xHT6dc+7mBMXQhJS5rvLte0aNRP2yMalo?=
 =?us-ascii?Q?QhndE7YBsVVCz1L5I0BRHVjzAjKY1rs3Fqup3wmNywbQBzPV3hGIWLOir6BF?=
 =?us-ascii?Q?IilZUzyKvCve2TV88DQ0IyO0QF8JbBuEPqoFaHxylSiusMnHzPreJMNeYreD?=
 =?us-ascii?Q?IRJVmuAhbJu8mPjvK3QUqbsNT4Na9iq3I57BRcqsM5JCxY/ZDrOHylUCBpYS?=
 =?us-ascii?Q?xNC79njH0VqZUVfKgH9PfkuJbx1U1N2ry9PxCnUVMU87erjHRXTYGZViIi9/?=
 =?us-ascii?Q?1uHmgPwlmfqfbv3EiRIZdXSU0zAKzH73Io7UF5sf0KJsh8hXjZroXkyzX2c6?=
 =?us-ascii?Q?k82V9BP5vZvNNR+Uo+hmpMKKbq0SWeEkE9xPNd28/cemKAbwCwAfKQXEc6Tx?=
 =?us-ascii?Q?5WbsGAkoKptYkcRM65NAbi+4PK/1C6SNroCOx75+DsSmyLnQOuFyc3p2OdKG?=
 =?us-ascii?Q?U2eYGKZlgT6CxY2yDdgmahsgdFFshrAaiCcMMR3ux7NAg30qz+1aabF1+Zrf?=
 =?us-ascii?Q?diUWI9ij2Hx4zUiejxsZIuVxjd8XrbN6l6dN8vRKe2ab+7VSbpPCnfHkSC0e?=
 =?us-ascii?Q?o83HIlURKVOdk6NoUNoy+qgo5YToyDociLQgjD8ckbgG2h5BP6na+FGXThr0?=
 =?us-ascii?Q?w9zWKM526fuSSp2pEVzZeeSKRRcXetdpLpnypSmf7cA9/EEIS9kFYgRAQwyg?=
 =?us-ascii?Q?cUXL8RYiEYx8P2sPbmt10UO5uf1ftI7b7he/PWE/74dVrj1WZXfycNZDOWRw?=
 =?us-ascii?Q?RFSYTmXhElmgV+tSoaiSzTaUrhriGOSG9Djz5KEw4CQ1zqdfdhYSXWNW54VM?=
 =?us-ascii?Q?9ehjBAN1sPHktjk5OJbGmRG+/kg4xoxlWw2DwudYl899OJOx0B0+hnUNOp27?=
 =?us-ascii?Q?gkstLsQotuECwaM8OYr2ddTqo/mJ7nhDX/lujpAf5HD7eUZbiOp1njxH5bm+?=
 =?us-ascii?Q?i+eR+6iCkCO98PQ1CE4WdUbzpu6xIoDo+cD40lrCDThebzEjjkdrzAw/SCV3?=
 =?us-ascii?Q?DBgdfDAVm/idXQ7vcnGfWa1+zfVSbKeRxUOd5im7g1NDi9yU2nHa8BqJklgQ?=
 =?us-ascii?Q?JCE1tkf0XtVrrQq0Q39F6/qxnrFu+p6KbsG8YpvTUKTICJ/GftG98bJ/LW3U?=
 =?us-ascii?Q?PyChRjtAHmTYwqnJ03BeJ8uI+yojIQpgaPCab8IHlmuZWfIDu2B5YJ2Dl01W?=
 =?us-ascii?Q?mkPmkAl/BXwx3a6mANVcGv4HsTYOlPiBYvKrPEK69O5P4sGcnB/D5YfFTYK/?=
 =?us-ascii?Q?2tXRdUoXwnwtR/blpyZpNkwtU4urVlfZ4nssLqVbKeZAMdz4SaaJHe+cFenZ?=
 =?us-ascii?Q?eovMwkTkgZp2KdKCHnmkPbE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7579efa4-bd9d-41be-22e0-08d9d0a0b669
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 23:11:32.4886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4AR4uXJ8HDk5+5srnRQIr2KNmpETdzQrPiQ8c3EaxIB9NzsrDr9zbIBIdRDdtA8i66UP9ArG0qXQaT7idWYQvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present there are two paths for changing the MTU of the DSA master.

The first is:

dsa_tree_setup
-> dsa_tree_setup_ports
   -> dsa_port_setup
      -> dsa_slave_create
         -> dsa_slave_change_mtu
            -> dev_set_mtu(master)

The second is:

dsa_tree_setup
-> dsa_tree_setup_master
   -> dsa_master_setup
      -> dev_set_mtu(dev)

So the dev_set_mtu() call from dsa_master_setup() has been effectively
superseded by the dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN) that is
done from dsa_slave_create() for each user port. The later function also
updates the master MTU according to the largest user port MTU from the
tree. Therefore, updating the master MTU through a separate code path
isn't needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

