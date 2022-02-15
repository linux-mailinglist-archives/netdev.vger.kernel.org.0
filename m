Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0115A4B781D
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242121AbiBORDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:03:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242099AbiBORCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:50 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10077.outbound.protection.outlook.com [40.107.1.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2CC119F55
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXTg/dhoPr+j0tRAarM1YNW+m4xVie8j3M0ZtJMeyVMEEjgoYhHrLGpgGMufFvpgOO7djiPf5c+e7K/nR9gzz1k0ku8GmmLs8WwXVLgjbNmGy4adMnQNGxuvUho1TdWukWUKczCxVXQlDysVhJGZY6kpRVfxQGDjJP9ZSpnKRODn7VlhpZ4P1bGB//02cQqhQVTAWe+nmoZN6yjAONlFrQ2miY4RLyt37TZXIPZ0xz4byGolK0OBqXu/UfmlBVzWmdKFhMAA4VFlXVHLhJ8f0IjchMzbLlpFjwPK6HteBBOLg8oP4flShn9WTO4D9oDJmaRTjE4FcM0h9KWfu1hgRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ETVLKo9HBlw3Wj3VnacRUGK0ZcyeQ20XHMawA6Q0m0=;
 b=OgGzCr1oJpY8QgrvC9/Nk41R87Sr8L10SAKBqOCsPlXJL0qycNLIwHiV0eLZhP0LbcOWt3lSRvjqgjSWMRnqvyebbA2wxbeSiwfDnBCyNOZ4ZXFinBsRdk+eBZ56ct/Z+dJ0OAo53xrjGCHvVbBuaIEgsH6RJ+1lSey7G63X5O/NNl3nqCM9fxrOPpdKBNnYx/rklHq3Bz4hI8Sq+hREQtJCmPkSbHCBiGH3tkUohf/c87vQGJJ3YiXrjddcFdWEgS9h3qJiysNiOHHbF9tMu13SPOmnWC0SfBRSAFkXPi4JEkOS0Ii3eyRUvOnhL7QZFNAiavn+S55HaqyoUdg52g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ETVLKo9HBlw3Wj3VnacRUGK0ZcyeQ20XHMawA6Q0m0=;
 b=NbNY8Zxxyi6a6eZPEI2ZQZoRgqAsyAm8/ERva9ZQwXp0KNZc58lbbG0aj5ETC+enzxsN8E32/A+e+V8/8Sw9JV0+C4E/orbKAPMcMNle2R04hjBDh4BEdu7Ag+f8Svc517JCWYdlKEx1n9reaNyzeXUWoX2csZsFBZXqqxyNpK0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:34 +0000
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
Subject: [PATCH v3 net-next 11/11] net: dsa: offload bridge port VLANs on foreign interfaces
Date:   Tue, 15 Feb 2022 19:02:18 +0200
Message-Id: <20220215170218.2032432-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b24bcc1b-194b-4919-0232-08d9f0a4f5d5
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5342329405CD3C7C43E5EA16E0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PNZfTY5bC2xk0zYj4ayKO/7KaWmgafbflWxSuEJ+S/9QAMSlkBwrp1eCWSx5a2EFoQwWVq9zaiNjWlQMpE8rqFKuGaUf3lh3pMeyK1RwH3l9khRXAzfgteoeEQMfCBowNcbFkz6cs/qM7y0VKF1EeJcZ+aJKJao8a5OSn9lB4RuNx0PEMqIfu9asQkg+g/A61oqU0u2A5QVU5/+WnkWY246MBvhhMuCGt1q2SlZ5mNzMXA7FU4Qg634t8YBTgxNbCsCUpm3gScZHYo3rSZjtOSrl1+AAotDB7xHNL4FnCDfTHKVMvR9UK5xhpGAkcWQHDRN6n46XJbm37kzWIyONCtWbt4OjVkfAOK7ZsKfckq8wgfUrGLMgQpGmiEn9elRi/SgDwCtXzPZiid1nUpIz3CUmDAgFP1ILtglCI9yfYoIMAzpTRjpGO/BED+sl81OMtaVBGKbwSE2eP7fBdQxcZSEjwghaPPdVBYd7OpqdAYqlL3/81q01Qdwz0uKspR5yImBW9X7bzNRctP6EuWK1oJCmxGx0NqE/gVdNT0FoiGrMekzm0gTfomLsuqgIPnIub2OUnjG7tWuXkn+jJXvmIC+ksgZ9wWptjtZqrKwOxOOKOiDK8QvKojS9zkU0O1IvNK8rHDYEszTvEEqvh1BGXKRqnOj8L9gj7ZmLJpqNaEt9Q14A4QsUkOSnmgi7IsJxEQ53GLUqVhZsNnruz1/iw93RPCiUBr0Ef4J+/cUF8riSnkOwK77wtHpt5iMaMtS91ygjaiOOEt2SxDnLYUBTKCvcDKX0KlyWBKrvge/ro+8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(966005)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rGmNf+NiIgrwArfyDq+piUY0H75CSMnrSCE7ogC8ovOrODVs0wlHzGZlLBRx?=
 =?us-ascii?Q?tHDr6UBCQzIKctsB14dkpwbMXz12Y3jhTOvdPELhSLpwqt6YmtasbGeopnR9?=
 =?us-ascii?Q?9wv7Tr/9uTo4LwNs6kvcQfz3/uHgpRj+pi9oj5Ent1bhgNytMDhnEpdBbpG8?=
 =?us-ascii?Q?rx0BRVIuZQXis5Rex4AzY5NSgp4oPty8PcOdhNZJ/nISWbtwVXV0v3/HATzI?=
 =?us-ascii?Q?tHg4bDLQbgjmRCcvHbOQ5IXkNoyn/U+VB+nvcNKpFma3wwTJ4QJV/UpJVD8M?=
 =?us-ascii?Q?GkPzQFPAfKFGMB0h3tLdLGDSuDzZQy2grAqHA3CXM/hf873UJSS7u5E4n8zs?=
 =?us-ascii?Q?MZvdqvK14m67Yuem2seQApgFORrEILwIJh3DCyuy8+9459daRLwYWiYF+5d0?=
 =?us-ascii?Q?/bkGbtmoSAkynydn9DeGJEn8L8k9brU5p48Fx2NiCgXSFfy2NklvotAT1dXc?=
 =?us-ascii?Q?7kwox01w6O42pcLcKLJsx+oJX9EOkPNHV6FsFQCviZBSkS3YB6bS/72FtGJR?=
 =?us-ascii?Q?2bun6zbfJonjj1+OQA5w8hnneJ/lNJjvHgx1QwyakYpXjSlk0sJayhkqFE8Z?=
 =?us-ascii?Q?NjcABfwHyQGYV1rL6saD+Kaw6gab6iJ13Z5Rnwhc/u8oRH0+eygosJP+UEEb?=
 =?us-ascii?Q?ZU3dowCWtguL9r+nwtNJmvbX1Ttg4Bi56rND0WSMVLsUYV9K+zfnLg0k6e22?=
 =?us-ascii?Q?pORs9JHxysQdyUHhcduzKoPoUF2oqqg13H+EiLm6BQ982P4JBDkJvkj7GPKU?=
 =?us-ascii?Q?JNvCAsDZ/KEzUSwBaiKMD00vb4AdYyi5jLm/fDrj+5F+4PvLlSeVXSSJZmdI?=
 =?us-ascii?Q?PLoizVZM+6gQ+FuEWeZjJMoDz5Zxm61e6uhRmAApGkAuarFMkFgHQuvRtrbc?=
 =?us-ascii?Q?UYl3SqWiUfPfH8RKNZk9ummbYVu66qJfv5ZTxPhudWnRwTPYdsqY3cXquWja?=
 =?us-ascii?Q?ZMmU+1dg0VgPEhdewYMdzCjkuWv0HRQEohojNBmdlt3eEjyqbFdUS+of1IBx?=
 =?us-ascii?Q?KeK9LZi2nL7Imaq8cyxysbzlyruOpQOaEdNzIu5jsqYMBz3EUePBlWFh2lyR?=
 =?us-ascii?Q?AJVqxSHPT9jpnRlbfWA5zxpmb3/pIyKA7jmn9hlbxjtSyxO3VuMj1wdL8ELy?=
 =?us-ascii?Q?F8anIuqOSjbF/PL3iJKVJ1hKyl6STbCIXp4PwVO0TmA/Avm51uZwawuoiHld?=
 =?us-ascii?Q?pVwvvnMksOrnxBhccZaPBbxzAeUWq5Urz9jahCDrFWsfaDskFZkBpGYGfrLs?=
 =?us-ascii?Q?96fd8TM3FXd/wv/tZYPiiXC+onKgSyPKLUt947MR8oMsa8j3/sNybv+DgSaD?=
 =?us-ascii?Q?VWX/xkIsrFcaJ3h1vM3Yzu1RL3iIbdF1QPPPR24OYd1Aq4iNUCoMDxNW6i9o?=
 =?us-ascii?Q?MSLJuot0xvQSnIBtn4gFBfV7CQc3Bsdn2T9wUuH1PW9SKBIxe/gOufrKU/YF?=
 =?us-ascii?Q?HyblVE3g1o3MTumBrrBUvMOze3eWJH9fUGZuqf/uwresFgYUzd5k8cxatSuE?=
 =?us-ascii?Q?z6rlBkoe8soEd/AJD7S+IxPgmSy4v7HZQJJsCf/JPo5QitffbZC7YNZWDgCf?=
 =?us-ascii?Q?LagJ5AZurGM6NOQk32whtSVeZ8I+4h+RjA2xv2G8+94LmW1WfQN5vzMH/VCm?=
 =?us-ascii?Q?dqKHDKTtUhJH1xkIZ+UMb6Y=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b24bcc1b-194b-4919-0232-08d9f0a4f5d5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:34.0566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtUp7Ic1OiWO9McBoZ8PQOobYVrCpSr6eynyeGIQli7Ff1iIjTNfnpMc1iBLPm43y746MEBWjh2niPtro9gVBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
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
v2->v3:
- merge dsa_slave_host_vlan_{add,del}() with
  dsa_slave_foreign_vlan_{add,del}(), since now they do the same thing,
  because the host_vlan functions no longer need to mangle the vlan
  BRENTRY flags and bool changed.
v1->v2:
- patch is new

 net/dsa/dsa2.c  |  6 ++++++
 net/dsa/slave.c | 51 ++++++++++++++++++++++++-------------------------
 2 files changed, 31 insertions(+), 26 deletions(-)

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
index 734c381f89ca..f61e6b72ffbb 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -376,6 +376,9 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	return dsa_port_vlan_add(dp, vlan, extack);
 }
 
+/* Offload a VLAN installed on the bridge or on a foreign interface by
+ * installing it as a VLAN towards the CPU port.
+ */
 static int dsa_slave_host_vlan_add(struct net_device *dev,
 				   const struct switchdev_obj *obj,
 				   struct netlink_ext_ack *extack)
@@ -383,6 +386,10 @@ static int dsa_slave_host_vlan_add(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan;
 
+	/* Do nothing if this is a software bridge */
+	if (!dp->bridge)
+		return -EOPNOTSUPP;
+
 	if (dsa_port_skip_vlan_configuration(dp)) {
 		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
 		return 0;
@@ -422,17 +429,10 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 		err = dsa_port_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		if (netif_is_bridge_master(obj->orig_dev)) {
-			if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
-				return -EOPNOTSUPP;
-
-			err = dsa_slave_host_vlan_add(dev, obj, extack);
-		} else {
-			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-				return -EOPNOTSUPP;
-
+		if (dsa_port_offloads_bridge_port(dp, obj->orig_dev))
 			err = dsa_slave_vlan_add(dev, obj, extack);
-		}
+		else
+			err = dsa_slave_host_vlan_add(dev, obj, extack);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
@@ -475,6 +475,10 @@ static int dsa_slave_host_vlan_del(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan *vlan;
 
+	/* Do nothing if this is a software bridge */
+	if (!dp->bridge)
+		return -EOPNOTSUPP;
+
 	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
@@ -506,17 +510,10 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		err = dsa_port_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		if (netif_is_bridge_master(obj->orig_dev)) {
-			if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
-				return -EOPNOTSUPP;
-
-			err = dsa_slave_host_vlan_del(dev, obj);
-		} else {
-			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-				return -EOPNOTSUPP;
-
+		if (dsa_port_offloads_bridge_port(dp, obj->orig_dev))
 			err = dsa_slave_vlan_del(dev, obj);
-		}
+		else
+			err = dsa_slave_host_vlan_del(dev, obj);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
@@ -2547,14 +2544,16 @@ static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
 
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

