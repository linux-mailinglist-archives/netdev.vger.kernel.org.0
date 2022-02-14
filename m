Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04114B5E4B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiBNXc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:32:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiBNXcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:32:25 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB451133E6
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:32:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxaCe5ErPt55gUfBO1TsQtw1Z0BnQA8eIwPNnzRb1QSpOULLTRqsBFp02LoEbPel2cRgN0+A9t2Qd95hDYx5n3r2770qInhZv6EtRjYfDkUU8uFev6UTH3YpDNxaAUoXPKYTyLu/62IQn13GRMukUIh45l3nR1k8yMBl1JCbdBUnu4glBY0eTFqKumSBljHCH8LzUQWFp/zWyy9AJStSSgTiTB4yNkY+JojlLxw+5Gj3qbkI0T3EfGmWJLX256K4Ky1A/ZG6N53JXK3odA3pZXaOEoSAV2jpWReJv4jOIxNPkTTucY+MY0Hu2XxF2Z3n1ZMYuuTPGn5ULUhTNz9HDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1Vnbyjpq3vspLpiosFWOCsAl32MGXSuyBRD6bm3Q8c=;
 b=Nq8gMZZPawn4SWP7QmcObpXZLcFyd7BU3m0omniop10eHyq54NPuwmaMOBzB8hRrLYEcwtwNz/bdyOvxEIq1UkLKVAJ7Pt5+5eJnWJ0stvUDRv28ZAcDTAZ3oBg7hdvNlhQZDoOF1oS4weNjnbVYhX5N4bOnMRKZ6WY0HZOj32d93xQVq5DNNKjo48o9aI/xQA40lEskQ+HTCqriC32Fmf8tR1ADHXzIbRnsfvL99lCsn5OPSMeHxQVWMsYZVHiKx0u9jjTqWt9pdEFjbT3h4sirZdBfTHAo7yneWq5WapbdIQz6gPXGNiPqlzTIo9Dag5LNAtLxRaYYhl/t/O/+Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1Vnbyjpq3vspLpiosFWOCsAl32MGXSuyBRD6bm3Q8c=;
 b=W0khtEDCum6/v3cbTlMON57g/i0s0NXCtd0MVeLUM5k0U3FaKIwBJzuyEds+yLfIPQWaAWt6tZgvEms+T4vzecXgE8K0fsLzAFhVMS939D6F+UsiC0FsrAh76DlECl/onycKSXydaxTdry8p0Np/XaWY1hnyf+Sjd98wl7EUcl4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 23:32:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:32:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 8/8] net: dsa: offload bridge port VLANs on foreign interfaces
Date:   Tue, 15 Feb 2022 01:31:11 +0200
Message-Id: <20220214233111.1586715-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0377.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b77ff8f3-59ef-4846-46b1-08d9f0123a8c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504AE511BDA4E0D8AA7B878E0339@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mdPdLWtVYiITwK0ea/Up6cEFy+UbhJmfgSPFQuzo6l0MQA38k7fUYRQYb+st/d/O6pD7e8U3J5DIAXnhcLgh/ZwFSeLZhYahou0qJGI9Y0OQStP1CZe0C01F4skGUPJi3f+X66rmYwmH9jirkJsPqcg2bMmvAFJp7hlYnthU795pcfvEHgMPkChbmAHWAzmVp0xPTmOwJKu9HFkli9eTq2SxEakHCGr6XvrOEqnF9zg8URnHX13xEXPEL2L5FvPPSaUEZnjeo3iuDUkZ/XhjWwgfffOVzXRJwaZdN3EptO9Nr6iBxLv078cqZUUJvnf5FyJ+BnZT8YtR1rMWLcWz9l+JGeTM8IQo301Pr/19CiE92df/ym7JYztbupGxmRfYYvgv0cqPpcOk6/w0vEEKn3+BAcZZScbNpwk58Pln0HtMFXxJJVC/jiWLTiO28oqJW8o9LEb8RIOH5/ExnNLHsYTKiSAKAK9/BcttQQcljYR7Slz//cX8xcZlsPjpNhnXC0PnmBH0AxKL4RaJVs35QmfGj8H4Arp9c19qdx6zqObckE0P5a34QSdPTR3g47cdiNyoJPFt5IBBtMggHnKoJieZU9LxLoKA4ueRAn1pV+6klUOk/vVHmgoiqol2rCbNLF9P9ln3JKiiMaLhDfANg8I8UTNOSmAP0cpNfJYnS4y44w+7gLnvNHsFFfM2Tft7OXPPtr16pENa/0RASEaHBFDicuM6pd1vLJP2FRObVZAKCSB0UdQg7zBnouTa/0TT80iYPiqUxdcyndwnlAdlXWxew6Yw90i9uujp/byXg4A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(66556008)(6512007)(2616005)(54906003)(508600001)(6506007)(52116002)(966005)(6486002)(8676002)(6916009)(2906002)(4326008)(44832011)(36756003)(83380400001)(316002)(26005)(186003)(1076003)(66476007)(86362001)(38350700002)(38100700002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nFQQtidmOwxaPot2NmUHrhe48P88Mv3Iy5VG7DheolWTfSo29a/8GE3FYZ6/?=
 =?us-ascii?Q?4jUbMbXqx6oqQm066AV2L7+v6GRJa1NumV6VCmbijFVLrM9dODCFGrZ6/3Ce?=
 =?us-ascii?Q?SiX9LYdvN7T4z6heASjedveNbcP/0JyHzJ7LqhwHEUsub6zNskjUCuOdNNjk?=
 =?us-ascii?Q?hnZ1xChj8qZPMp2in0Z1xWIMKwLZd3OKr3VFqlsbsY9Q7oNzVikBz3bJrRUx?=
 =?us-ascii?Q?2k8RTk7SGjmZjTy3tFSgfTB2gDM2Mdakw77MSP3bb83gQAx0OXGJIGD0W/0E?=
 =?us-ascii?Q?2tvBt53X9E1vRyY2FWUkfxhIAAP6wO339LdAfCDtI2aY5BaZkJUvXOLPOg50?=
 =?us-ascii?Q?kpnfOJkf5INv6YXSoN5T82KcEhFmcz2qby9fbicKlxHfTX3igIBR52rM1BzX?=
 =?us-ascii?Q?u8qmeJRI2ZIj+o2HhNyxG28Xjw7d44fRuHbexm1gt5liniQ2Y2W3tAEa4GXT?=
 =?us-ascii?Q?rTWhhooo1RrRhhAw7evpZP2Q3u5IKUtIBoLVXCkBJ6b+OTJLInxCmbkKjJwL?=
 =?us-ascii?Q?d5Hb17R91IhCEIFa6NwNSA7xl4WjSGUARiiAMx1jI+m24Kp9McEM4MTvhMY/?=
 =?us-ascii?Q?xHd8vBVZPKlUt/q+GukZ9eJWh/f7GWW9UQAcPezNiDAjoIM4u2Y4AJ0vTJ0v?=
 =?us-ascii?Q?luy51RYDqnpYqG+2rain7iIWWfeRuPGFDUOczTVQ76yNTfJ7qpuniPMHNgtH?=
 =?us-ascii?Q?q8XiBnl8ks2dhYwjavKzsNZYpyc+0NvbNDCIQ8P1KLXc3gcV5iUzaPPMxKTH?=
 =?us-ascii?Q?QHbwqLCcJdcVP1UpsH0yLciPonubM+0XVUUL5VWXFIPoqi7dpd9c7A1cRr01?=
 =?us-ascii?Q?v1t5yRpRBTswAtDF4gjRWm76zlMR9PI/aBZRWlS5e6k63Jua0Qabr4lAW5P+?=
 =?us-ascii?Q?kYShsRBEB7sGZrS0wg8kSg74gA2kgsNglZcpc9jcEME1O9bnUO4Fzn7JM8dg?=
 =?us-ascii?Q?shH/qbx6ZoLDImdJuZvQp8aNZS5hAky5CauhP2RStPdDrzrPwkXFf48joo0h?=
 =?us-ascii?Q?bKxu3DAggi7+KpK9PQvCM6ASEfjZRPcHLAVxsWCynVvxdn4W39ChSNz+tuqp?=
 =?us-ascii?Q?bl9rhMTuSR1H8Z8VctkwAxS/HQYeRq5vYKZmSSOqbgVRB3mFSif3Js4/UpYj?=
 =?us-ascii?Q?KjDdbLrdDl977k13KnNQetJoEQB473wr+cf+QEQIwGPI0yxqrjzi1vXT+tYI?=
 =?us-ascii?Q?4tHGndUCV1Y7KwE6rQmyL3SckH3zFczsaeOPdHJhoEkGE+0oe6wrii6E7PMS?=
 =?us-ascii?Q?zXO/f6oRjPgL4cayBl7sPWgxP/s/AH2MWHyYfQcLl7DVUeitv5KxmgC7ZkZB?=
 =?us-ascii?Q?eWLUSNfg4bA5OhcrBEviiuB1BBXPZoUcyudBCKjI1+SZUwm78UPwa5EVs0ko?=
 =?us-ascii?Q?NfIil4N8lpm/Selpv6NaO8lIo+vpjK04jv0LItiqp+PusYhU0vJtZkq29mxk?=
 =?us-ascii?Q?Czj3LS60gAOU1rJ43nhkl4tHpCcW0FzYJl2m4DdUyiQnXOgwIbjw7C2y7dIk?=
 =?us-ascii?Q?h9q+idjcTv2cQ3mf7HgchgPZwr+oad4hkioQ3j40BnZlU8j1FZAGkWrCAzxU?=
 =?us-ascii?Q?KQVFGpI2ymC/z95Ub4/9X4BLoPiNxFDa19BIr+kfSr5AWQv3x7d2yX9cAbi4?=
 =?us-ascii?Q?FkWBAEotTWMpyCnW07IXVt0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b77ff8f3-59ef-4846-46b1-08d9f0123a8c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:32:13.3703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7JxkkDVEPLbWbwFEQtWicpMp3iEOqaK4sP0SDVCc1xrQXeZaJX7nPavZNyAlahDtHndnDZQrggJtVel9MHehg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA now explicitly handles VLANs installed with the 'self' flag on the
bridge as host VLANs, instead of just replicating every bridge port VLAN
also on the CPU port and never deleting it, which is what it did before.

However, this leaves a corner case uncovered, as explained by
Tobias Waldekranz:
https://patchwork.kernel.org/project/netdevbpf/patch/20220209213044.2353153-6-vladimir.oltean@nxp.com/#24735260

Forwarding towards a bridge port VLAN installed on a bridge port foreign
to DSA (separate NIC, Wi-Fi AP) used to work by virtue of the fact that
DSA itself needed to have at least one port in that VLAN (therefore, it
also had the CPU port in said VLAN). However, now that the CPU port may
not be member of all VLANs that user ports are members of, we need to
ensure this isn't the case if software forwarding to a foreign interface
is required.

The solution is to treat bridge port VLANs on standalone interfaces in
the exact same way as host VLANs. From DSA's perspective, there is no
difference between local termination and software forwarding; packets in
that VLAN must reach the CPU in both cases.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/dsa/dsa2.c  |  6 +++++
 net/dsa/slave.c | 70 +++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 62 insertions(+), 14 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 1df8c2356463..408b79a28cd4 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -565,6 +565,7 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a, *tmp;
 	struct net_device *slave;
+	struct dsa_vlan *v, *n;
 
 	if (!dp->setup)
 		return;
@@ -605,6 +606,11 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		kfree(a);
 	}
 
+	list_for_each_entry_safe(v, n, &dp->vlans, list) {
+		list_del(&v->list);
+		kfree(v);
+	}
+
 	dp->setup = false;
 }
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 314628c34084..9ca38654b61b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -413,6 +413,31 @@ static int dsa_slave_host_vlan_add(struct net_device *dev,
 	return dsa_port_host_vlan_add(dp, &vlan, extack);
 }
 
+/* For DSA ports that offload a bridge port, also offload bridge port VLANs on
+ * foreign interfaces the same way as host VLANs.
+ */
+static int dsa_slave_foreign_vlan_add(struct net_device *dev,
+				      const struct switchdev_obj *obj,
+				      struct netlink_ext_ack *extack)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan vlan;
+
+	if (!dp->bridge)
+		return -EOPNOTSUPP;
+
+	if (dsa_port_skip_vlan_configuration(dp)) {
+		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
+		return 0;
+	}
+
+	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
+
+	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
+
+	return dsa_port_host_vlan_add(dp, &vlan, extack);
+}
+
 static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 				  const struct switchdev_obj *obj,
 				  struct netlink_ext_ack *extack)
@@ -442,11 +467,10 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 				return -EOPNOTSUPP;
 
 			err = dsa_slave_host_vlan_add(dev, obj, extack);
-		} else {
-			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-				return -EOPNOTSUPP;
-
+		} else if (dsa_port_offloads_bridge_port(dp, obj->orig_dev)) {
 			err = dsa_slave_vlan_add(dev, obj, extack);
+		} else {
+			err = dsa_slave_foreign_vlan_add(dev, obj, extack);
 		}
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
@@ -498,6 +522,23 @@ static int dsa_slave_host_vlan_del(struct net_device *dev,
 	return dsa_port_host_vlan_del(dp, vlan);
 }
 
+static int dsa_slave_foreign_vlan_del(struct net_device *dev,
+				      const struct switchdev_obj *obj)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan *vlan;
+
+	if (!dp->bridge)
+		return -EOPNOTSUPP;
+
+	if (dsa_port_skip_vlan_configuration(dp))
+		return 0;
+
+	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+
+	return dsa_port_host_vlan_del(dp, vlan);
+}
+
 static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 				  const struct switchdev_obj *obj)
 {
@@ -526,11 +567,10 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 				return -EOPNOTSUPP;
 
 			err = dsa_slave_host_vlan_del(dev, obj);
-		} else {
-			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-				return -EOPNOTSUPP;
-
+		} else if (dsa_port_offloads_bridge_port(dp, obj->orig_dev)) {
 			err = dsa_slave_vlan_del(dev, obj);
+		} else {
+			err = dsa_slave_foreign_vlan_del(dev, obj);
 		}
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
@@ -2562,14 +2602,16 @@ static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
 
 	switch (event) {
 	case SWITCHDEV_PORT_OBJ_ADD:
-		err = switchdev_handle_port_obj_add(dev, ptr,
-						    dsa_slave_dev_check,
-						    dsa_slave_port_obj_add);
+		err = switchdev_handle_port_obj_add_foreign(dev, ptr,
+							    dsa_slave_dev_check,
+							    dsa_foreign_dev_check,
+							    dsa_slave_port_obj_add);
 		return notifier_from_errno(err);
 	case SWITCHDEV_PORT_OBJ_DEL:
-		err = switchdev_handle_port_obj_del(dev, ptr,
-						    dsa_slave_dev_check,
-						    dsa_slave_port_obj_del);
+		err = switchdev_handle_port_obj_del_foreign(dev, ptr,
+							    dsa_slave_dev_check,
+							    dsa_foreign_dev_check,
+							    dsa_slave_port_obj_del);
 		return notifier_from_errno(err);
 	case SWITCHDEV_PORT_ATTR_SET:
 		err = switchdev_handle_port_attr_set(dev, ptr,
-- 
2.25.1

