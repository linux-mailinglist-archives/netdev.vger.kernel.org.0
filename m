Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBED3CD623
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 15:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbhGSNM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:12:56 -0400
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:65094
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240769AbhGSNMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 09:12:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cb2xD4MnWx0CmzKnmex7LI/bJm6eoJBGwmBBeicDkNtrsGRGvVSaJosZ3cDTTHcj3AK5mVLNH7afPWjfrFnV2qBWAr8M0yrDw/kEIAizOZWq08WJQZ2Nq5WX7S66HniEZXs8YEMxb+lkexRlw3GAUX4aEzZCcVeOdsKZ7YzT03JxHoHMqHtL8fcolo05wshpHZz2A5vmV+/91xoUvvuV9Qob5xwOCdrs/LQGpTt8C11vlQixI0CGpcv0HoF6Ara3cLy4nTLC/oMVLH50OeJVy3ADKf9vY/vrBLy4WYXDzaBJE2y/akszyZ7/M7i3ji8zbrRui9dC7m3YpiULgrarjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+wlcFQmlttP1MyZSwz0f2uvGjTh91BntK9D0CsW3mk=;
 b=RoU6EcJOQnQ4Xoc9IV40a0bgoMB5LM+fd0m1yp1fPxtGDC0+hN/LwGkL+nCQ4RM+tt1BiP6JM0BWH/5JtdztDQPAvQHcKvT6o74AlRElooS82Ji2k6ghj8MJsGi0HDunbtvIs3wY0sD4CNSgFEvVQzMi3rUYHfiNA2a++YS5IMkIbXJft72tWYe1vB9gLhTZAIvLeECS1GbtMn88BGDPphwEdnYwNLOQJegmhFwWi7B2f+MbDY1iqF/BWO1Eapk2XS2/xXp4/DWOa9vNR9i03Bkhk/hsUznlostPSfK+x0tLg5VStFW8EyFgSkM051lzfP3xeb+4Q30xUAJ4ZgNiUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+wlcFQmlttP1MyZSwz0f2uvGjTh91BntK9D0CsW3mk=;
 b=aQuHUCSKrboL8uyuzfSn8llHui/B5s9XMoi9zOl88bBfrdcbgd0G9piKg0mjtyxpViAe0GzI5VUuWjj/oZPJBK/rpD4HnjBmagiwAMioT4wc0h+Vl+G5bPqdOPN7EJkVU17a3utMJvgGDf4okPcKJpmE076VNLF7e5KLwiFFt4I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 13:52:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 13:52:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: use switchdev_handle_fdb_{add,del}_to_device
Date:   Mon, 19 Jul 2021 16:51:40 +0300
Message-Id: <20210719135140.278938-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719135140.278938-1-vladimir.oltean@nxp.com>
References: <20210719135140.278938-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PAYP264CA0013.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:11e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PAYP264CA0013.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:11e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 13:52:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2980f87-e222-4fc6-a03a-08d94abc63ab
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471BA7C639A130EBE697FA6E0E19@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X26vn3YKjMroe6pWhAD1QgrTBCLalq0xbknMBvPEBG6gmYVmiWSp06OnskKlYAJpgFFd1wYB8FZUkpK2lAKoC3DIFAUeFW6s3KAcZBwKdYeQrIb2eNAVvBRcXLGwcWQzGKU/6hEVM1cs9qt/+k8XStL4kzfKPbQMlxJrvs6m+Owfx4OsHuoGq2NcQSIF/Uge9hjUSTKqILlexnvPVb5FBm68UcYvrNJuXWMCIlhrG6uvqxAGx455s0O3bERW9M9D4DW9KvLWtalAWafRrVnb4zSl3GogwPtviWS2OdjeniS0Nlzto3yrI9ZQodfDRXUY3EbnDzEx07j31tem8681Q1x/1Z6Z0jYOrICGu4NwPdgEzPWqE5HY5vAfqnuBEnKUMr3p2i0dfkEFBy1P/CIQAqlN/ODy5Vo/bRp/IxMCUuCPe3wPqdUJLlkoeu6pOWXWgjFZ2qRApq6iom62ZcJer8YCVj83F11a3BLyFyZjSVCwm+cF3dGCnxdxCDqNCZYLKWTKwPhyTFULTPMilZqEX8Fv5IYYPSSmqvXLEZ59DvaxcppD2Ng5LpfQsvLF6arg2fffiumabtBw19rWoZLKeK6veBLS52yaxrW7tgYO59VdyDi6qRcqEZej4D+WCO2PH3EDmpGAflAL2E5l6c5XVbmqBvQacDSLK9l+WoUGiNgI0voACQd54cgmoMOUCa4s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(6506007)(8676002)(7416002)(1076003)(44832011)(5660300002)(52116002)(110136005)(316002)(54906003)(8936002)(6486002)(66556008)(6666004)(4326008)(6512007)(36756003)(478600001)(83380400001)(186003)(86362001)(2906002)(38100700002)(66476007)(26005)(66946007)(956004)(2616005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TpBn/rykDctPxbX9PLwcUUf8RE9QyRq8dAYgLcJcRgvUBnpB4JqORap0ryet?=
 =?us-ascii?Q?Zr45wxVuefpZO6oeDW1F2eJSRlUSzpop4maAOyblPeLnwCQQHPrADyYw5fxa?=
 =?us-ascii?Q?nemcwYe8GtJVJ/MSCy65zd+hwutwCQ1Bte61VDJXhbtB2/OmSbj21zUFvRAj?=
 =?us-ascii?Q?qh5KKPKnrGeq6uoAl/nEwqL9af7WDwcNnuopTkWOmWI4fBzB36EZ2z8Yw4Rx?=
 =?us-ascii?Q?U+S/j4J6w44C2G/4ySilHWhpNeucI4S/IoepabC7CBD15UGv4fKPhgCxAc62?=
 =?us-ascii?Q?bgPYJS4I/gB0xdFzvTZDx87ZiLN/6UYG3CJVHmVLmeKXqhW5qrH3wPGstLyj?=
 =?us-ascii?Q?zslYthpluLICB0vZUXcPEMQJWyKzzA750sm00UqstrraWhpnfSlGyFW456+v?=
 =?us-ascii?Q?GyPgDzDnMwMINCiOJCYRLO8XcS9h1erri1FcaOyBVW3el9WI6re+93Kr37NG?=
 =?us-ascii?Q?oZC3PWZVbIu6uZbwv/qmHz7px48m3GVFzhzVL8F/LfBbtqpnNeeASr6uSVij?=
 =?us-ascii?Q?ohZ9eholaxM4YYJ+RfzlV4pA0Yv1CWNgramL7BiR2XFdLB1mxelr8WWRUJvf?=
 =?us-ascii?Q?knXm1Q0rIV0P4XfH6/srXaKSzAJ14shCCAIzSFg7Fq7ZUXs6IMjXOdg28M42?=
 =?us-ascii?Q?eiIu18L3oyuzmY3CxoQ3UKpI3fRC2occ+WKCBgNPkURfLA/udbq5cKwnPfHu?=
 =?us-ascii?Q?toANBbjLcqR5/mOgljkn1nk1x6s9dtvJfz4pKI2BIOLoJ3F0geAb0Do6djBL?=
 =?us-ascii?Q?mS9h/k7gFjW5SalUY3Y86kmiW4dtoTzOw48K2YGeTWYf+tln6KX12sZVEdfx?=
 =?us-ascii?Q?1QD7Dzi3EoVVWg6h0UtZgZLdiqexUEhDa3j4gHP7ADNWCdjyAzX3ALsAXLdY?=
 =?us-ascii?Q?7k5I1aKXo4trPoKL1itFnPSp7G78e4ShYi0NwnHciIE1+v50+RdHa27a438D?=
 =?us-ascii?Q?dj7+G5Btj7CsOI8Eo3Y+Mxwts3bTJDvj4v3W7pjX9F3Nw0mIM+mgM0hHRgpm?=
 =?us-ascii?Q?XOt7JrRJlcwecClVkrRY9PP+Yz/ff/d+6A52QIMQTF0tJFaCbLnuYvAYgVIl?=
 =?us-ascii?Q?ed/EwKTa4O14YcmUcCdjs9N+hXustdxKpXe9ksGw4fVFa/T+52PehsimZr37?=
 =?us-ascii?Q?EcjiPuw4eTgrSTUTQgraz0+obhMdXQRG/sx54gmrC8UNou3F7OxlQhOSiQ/9?=
 =?us-ascii?Q?lDubHw/4BixY1Z086xG1kNUlDVgIVei5C+kA+7yZliugDO1UP6JOPBCF04OA?=
 =?us-ascii?Q?afHFTcREeVuIay8cxeykW54u4/m2IL1QZ68/v9bYl5OU602yhynoPEewhq3E?=
 =?us-ascii?Q?TfANp/UhubvAvms/ejsbvJsV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2980f87-e222-4fc6-a03a-08d94abc63ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 13:52:05.0796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Js1asAqjqoBXFDXVC5LWGELrgaUI2pVLOE5VtLHeTT6SmZY0XihhGomeOd5kvs3m1Ickew6M3GBhVKvUCPWb5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the new fan-out helper for FDB entries installed on the software
bridge, we can install host addresses with the proper refcount on the
CPU port, such that this case:

ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp2 master br0
ip link set swp3 master br0
ip link set br0 address 00:01:02:03:04:05
ip link set swp3 nomaster

works properly and the br0 address remains installed as a host entry
with refcount 3 instead of getting deleted.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  19 ++++-
 net/dsa/slave.c    | 199 ++++++++++++++++++++++-----------------------
 2 files changed, 113 insertions(+), 105 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f201c33980bf..e4b2e9f2a020 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -256,13 +256,13 @@ void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
 
 static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
-						 struct net_device *dev)
+						 const struct net_device *dev)
 {
 	return dsa_port_to_bridge_port(dp) == dev;
 }
 
 static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
-					    struct net_device *bridge_dev)
+					    const struct net_device *bridge_dev)
 {
 	/* DSA ports connected to a bridge, and event was emitted
 	 * for the bridge.
@@ -272,7 +272,7 @@ static inline bool dsa_port_offloads_bridge(struct dsa_port *dp,
 
 /* Returns true if any port of this tree offloads the given net_device */
 static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
-						 struct net_device *dev)
+						 const struct net_device *dev)
 {
 	struct dsa_port *dp;
 
@@ -283,6 +283,19 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
 	return false;
 }
 
+/* Returns true if any port of this tree offloads the given bridge */
+static inline bool dsa_tree_offloads_bridge(struct dsa_switch_tree *dst,
+					    const struct net_device *bridge_dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_offloads_bridge(dp, bridge_dev))
+			return true;
+
+	return false;
+}
+
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
 extern struct notifier_block dsa_slave_switchdev_notifier;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index feb64f58faed..22ce11cd770e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2353,26 +2353,98 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	kfree(switchdev_work);
 }
 
-static int dsa_lower_dev_walk(struct net_device *lower_dev,
-			      struct netdev_nested_priv *priv)
+static bool dsa_foreign_dev_check(const struct net_device *dev,
+				  const struct net_device *foreign_dev)
 {
-	if (dsa_slave_dev_check(lower_dev)) {
-		priv->data = (void *)netdev_priv(lower_dev);
-		return 1;
-	}
+	const struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch_tree *dst = dp->ds->dst;
 
-	return 0;
+	if (netif_is_bridge_master(foreign_dev))
+		return !dsa_tree_offloads_bridge(dst, foreign_dev);
+
+	if (netif_is_bridge_port(foreign_dev))
+		return !dsa_tree_offloads_bridge_port(dst, foreign_dev);
+
+	/* Everything else is foreign */
+	return true;
 }
 
-static struct dsa_slave_priv *dsa_slave_dev_lower_find(struct net_device *dev)
+static int dsa_slave_fdb_event(struct net_device *dev,
+			       const struct net_device *orig_dev,
+			       const void *ctx,
+			       const struct switchdev_notifier_fdb_info *fdb_info,
+			       unsigned long event)
 {
-	struct netdev_nested_priv priv = {
-		.data = NULL,
-	};
+	struct dsa_switchdev_event_work *switchdev_work;
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	bool host_addr = fdb_info->is_local;
+	struct dsa_switch *ds = dp->ds;
+
+	if (ctx && ctx != dp)
+		return 0;
+
+	if (!ds->ops->port_fdb_add || !ds->ops->port_fdb_del)
+		return -EOPNOTSUPP;
+
+	if (dsa_slave_dev_check(orig_dev) &&
+	    switchdev_fdb_is_dynamically_learned(fdb_info))
+		return 0;
+
+	/* FDB entries learned by the software bridge should be installed as
+	 * host addresses only if the driver requests assisted learning.
+	 */
+	if (switchdev_fdb_is_dynamically_learned(fdb_info) &&
+	    !ds->assisted_learning_on_cpu_port)
+		return 0;
+
+	/* Also treat FDB entries on foreign interfaces bridged with us as host
+	 * addresses.
+	 */
+	if (dsa_foreign_dev_check(dev, orig_dev))
+		host_addr = true;
+
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (!switchdev_work)
+		return -ENOMEM;
+
+	netdev_dbg(dev, "%s FDB entry towards %s, addr %pM vid %d%s\n",
+		   event == SWITCHDEV_FDB_ADD_TO_DEVICE ? "Adding" : "Deleting",
+		   orig_dev->name, fdb_info->addr, fdb_info->vid,
+		   host_addr ? " as host address" : "");
 
-	netdev_walk_all_lower_dev_rcu(dev, dsa_lower_dev_walk, &priv);
+	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
+	switchdev_work->ds = ds;
+	switchdev_work->port = dp->index;
+	switchdev_work->event = event;
+	switchdev_work->dev = dev;
 
-	return (struct dsa_slave_priv *)priv.data;
+	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
+	switchdev_work->vid = fdb_info->vid;
+	switchdev_work->host_addr = host_addr;
+
+	/* Hold a reference for dsa_fdb_offload_notify */
+	dev_hold(dev);
+	dsa_schedule_work(&switchdev_work->work);
+
+	return 0;
+}
+
+static int
+dsa_slave_fdb_add_to_device(struct net_device *dev,
+			    const struct net_device *orig_dev, const void *ctx,
+			    const struct switchdev_notifier_fdb_info *fdb_info)
+{
+	return dsa_slave_fdb_event(dev, orig_dev, ctx, fdb_info,
+				   SWITCHDEV_FDB_ADD_TO_DEVICE);
+}
+
+static int
+dsa_slave_fdb_del_to_device(struct net_device *dev,
+			    const struct net_device *orig_dev, const void *ctx,
+			    const struct switchdev_notifier_fdb_info *fdb_info)
+{
+	return dsa_slave_fdb_event(dev, orig_dev, ctx, fdb_info,
+				   SWITCHDEV_FDB_DEL_TO_DEVICE);
 }
 
 /* Called under rcu_read_lock() */
@@ -2380,10 +2452,6 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-	const struct switchdev_notifier_fdb_info *fdb_info;
-	struct dsa_switchdev_event_work *switchdev_work;
-	bool host_addr = false;
-	struct dsa_port *dp;
 	int err;
 
 	switch (event) {
@@ -2393,92 +2461,19 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		err = switchdev_handle_fdb_add_to_device(dev, ptr,
+							 dsa_slave_dev_check,
+							 dsa_foreign_dev_check,
+							 dsa_slave_fdb_add_to_device,
+							 NULL);
+		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		fdb_info = ptr;
-
-		if (dsa_slave_dev_check(dev)) {
-			dp = dsa_slave_to_port(dev);
-
-			if (fdb_info->is_local)
-				host_addr = true;
-			else if (!fdb_info->added_by_user)
-				return NOTIFY_OK;
-		} else {
-			/* Snoop addresses added to foreign interfaces
-			 * bridged with us, or the bridge
-			 * itself. Dynamically learned addresses can
-			 * also be added for switches that don't
-			 * automatically learn SA from CPU-injected
-			 * traffic.
-			 */
-			struct net_device *br_dev;
-			struct dsa_slave_priv *p;
-
-			if (netif_is_bridge_master(dev))
-				br_dev = dev;
-			else
-				br_dev = netdev_master_upper_dev_get_rcu(dev);
-
-			if (!br_dev)
-				return NOTIFY_DONE;
-
-			if (!netif_is_bridge_master(br_dev))
-				return NOTIFY_DONE;
-
-			p = dsa_slave_dev_lower_find(br_dev);
-			if (!p)
-				return NOTIFY_DONE;
-
-			dp = p->dp;
-			host_addr = fdb_info->is_local;
-
-			/* FDB entries learned by the software bridge should
-			 * be installed as host addresses only if the driver
-			 * requests assisted learning.
-			 * On the other hand, FDB entries for local termination
-			 * should always be installed.
-			 */
-			if (switchdev_fdb_is_dynamically_learned(fdb_info) &&
-			    !dp->ds->assisted_learning_on_cpu_port)
-				return NOTIFY_DONE;
-
-			/* When the bridge learns an address on an offloaded
-			 * LAG we don't want to send traffic to the CPU, the
-			 * other ports bridged with the LAG should be able to
-			 * autonomously forward towards it.
-			 * On the other hand, if the address is local
-			 * (therefore not learned) then we want to trap it to
-			 * the CPU regardless of whether the interface it
-			 * belongs to is offloaded or not.
-			 */
-			if (dsa_tree_offloads_bridge_port(dp->ds->dst, dev) &&
-			    !fdb_info->is_local)
-				return NOTIFY_DONE;
-		}
-
-		if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
-			return NOTIFY_DONE;
-
-		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-		if (!switchdev_work)
-			return NOTIFY_BAD;
-
-		INIT_WORK(&switchdev_work->work,
-			  dsa_slave_switchdev_event_work);
-		switchdev_work->ds = dp->ds;
-		switchdev_work->port = dp->index;
-		switchdev_work->event = event;
-		switchdev_work->dev = dev;
-
-		ether_addr_copy(switchdev_work->addr,
-				fdb_info->addr);
-		switchdev_work->vid = fdb_info->vid;
-		switchdev_work->host_addr = host_addr;
-
-		/* Hold a reference for dsa_fdb_offload_notify */
-		dev_hold(dev);
-		dsa_schedule_work(&switchdev_work->work);
-		break;
+		err = switchdev_handle_fdb_del_to_device(dev, ptr,
+							 dsa_slave_dev_check,
+							 dsa_foreign_dev_check,
+							 dsa_slave_fdb_del_to_device,
+							 NULL);
+		return notifier_from_errno(err);
 	default:
 		return NOTIFY_DONE;
 	}
-- 
2.25.1

