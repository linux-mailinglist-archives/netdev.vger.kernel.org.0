Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EDC2DEBB1
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 23:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgLRWk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 17:40:56 -0500
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:29348
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbgLRWkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 17:40:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkHzXajJn9yxKShLqTkvanj9E5EbGBUsYy+TX84JZrvrnc1i4MMq8lPbAVP9g2mQSAHcu59qSUfgBX9Hhw2WsnUkh0lu1o7go5g4QI2FVeLnF3VVQf+IADc9YvbIJpje1qj6opes/kbdexqfDznWXRoJ3Xz38wsAyYw77OKwjoFZM5iI11QEuDs5K9wmUfeCiFEzy4vLPjQy+faUSuD7ZPhJgccwHq/ee0N6VIln+lJLq+xEILORh4aVcOSbHDFrdhLCpDCDJbw46NlsQJPrsd+stkBijHdJEUIffCEL0yx8K676GO+1+TwRkc/OEhkXcjvi7dCzMyWTHo76sJT9Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xp1Z1uQmY0JJ3dyZXwIayuBCFZ4eQChuVTsNVG78siM=;
 b=UUe8dc+/VyHCdUImauQWEW6VEy/R79M+XBmoisRJDPLzhAoCr7ykHDKNmWxE+0L7xAQeZd759pUj244XqVCshh81CYvivVo5kyFQIzwuU+PKo8KTwR4lTlS9IqHk+XYIvCmVLy5PI/EgDxs8t23VcnQkdIOzJE40UsBJW5orbdFadN6Op1NVuvK++MiFky2ue8NN/plA5DmdbMtYpfkCdhsClr3muCboxkt1A1LYwCVW5+ALLnCE6U41Ui5Llq+kqElMbqevY18WFHElnqOioWMyUmWxpQWFG/eeKd9diO+zlsoAxt0/oTcgxG+TQvTP24JWJr0OSt09KGrhS7FSTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xp1Z1uQmY0JJ3dyZXwIayuBCFZ4eQChuVTsNVG78siM=;
 b=U9RaYijUvUJkBDm+sVoQMXWb3R8PRFHg2B6Jo3B7knf0LAxs+xNHRkrf4dh0S3bdk4tlyaTxzuS0ZmVJe+3UpntIUmp+ZDsvJ8YZHuUH7Iat2E5gS20gPK65wNyweJhgRcl4V4Oe8L/RVsiDpF7C/VEuhtjpB/b/wutsKvslEcg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 22:39:25 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 22:39:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice notifier to detect DSA presence
Date:   Sat, 19 Dec 2020 00:38:51 +0200
Message-Id: <20201218223852.2717102-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM8P191CA0030.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::35) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM8P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.28 via Frontend Transport; Fri, 18 Dec 2020 22:39:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ea9c7929-75f8-4d0c-4407-08d8a3a5c5e1
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2686800101D232F01802A87DE0C30@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: woVed9+UV4v/ElmhKHcuoDrbMgMsZ40rCgZOCcTw7MHMDcXbiVtH/MOC7lZJllBaDmKBGIiXBMG0OLPsHPb4J6CpQV1zBWcI3nCk8DuNtE6kVd/mhnjdof2D98BflIkc7QdoWdCaowg/X12+n2ON+cZnTkFlycM4oVisB72xJbpXSJajV+IHVSFo7yewLPLXaSVQermbwInn/I9hfC8D7G/ALgRNMkzgKpXnMRlDnZGCFRp4PBiykvobMzA90MkJLdQdLOnNhOffRAOtp41xIX5mlQzXWpHknQ2tGTdOhO+TaB0ftJhKUsl6ljY6egF2F/gmlfZ90ZkfIclMoKrnmNjxQIMAwnnxXzW2ke+S7NzgGQnSRtclLaHD1XSD18KBaUvB4NG1SnTf/iS3tS7R+9u8nUjH++sU8OPSBAECEt4mqsYLhc/upFIQDp0YwQ1h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(52116002)(2616005)(66476007)(66556008)(956004)(83380400001)(478600001)(8936002)(69590400008)(86362001)(44832011)(66946007)(6512007)(36756003)(316002)(5660300002)(110136005)(16526019)(186003)(8676002)(26005)(6666004)(1076003)(6486002)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r9/xKNBEQXk7g7xcMYGdi3vIz9yH99lXbdeiTYPa2tHlVUIRPqD6by64y767?=
 =?us-ascii?Q?lbzYunYcl785a3+aSHybmrSPWWutu49WaJdMWQunnFIP6vuch8Z5hseAhjKf?=
 =?us-ascii?Q?t46GRbEPQi57eihSFqOHt43P7z00L4IFNkKFjCMn3anhdtBvF/NqQhAFNmHL?=
 =?us-ascii?Q?DoSdUW4tvtWfYfzf+ZhvHRpuiVm3V6S8tRAcTGSz0JUWA0DaiH83Ax7DMd+I?=
 =?us-ascii?Q?EU98i+UKudT3NtgKA081JfxZ3PtxcOte8D6LUKbNbd33sq9+GfTkyohWctUg?=
 =?us-ascii?Q?xedmaJh5P5a9s7ZwuzLDqRpe5A8DXFPOiS6qYgzPi9xUwNQKwndsidHD6d2e?=
 =?us-ascii?Q?aSs/04dy5Ml7m0P9LahVbaVj8zuRZBZ00A8QQl7oiVhlRYVvdkTv2nd711Bb?=
 =?us-ascii?Q?+5W96NHCoGO5+X6laR1mt7t0WdfaYYXbehevDlzkflhcZgJu/3x3TnvD6Ky2?=
 =?us-ascii?Q?x7fkrBaJ8U/dMkTzKxq+heZcfWfFu3VBBLmmT1VM99aU5sormu1bRewSAkph?=
 =?us-ascii?Q?gmsCZySDxCn1npZXigduMz86rDoRxocnZ9HPCL8nefffpqWg5X8LcMMyAuUd?=
 =?us-ascii?Q?yQEfNKLfywBSTiSAH+XMWRLNy+33qb4frKxSyknOPbZPkD6RSZG8nMvajiH/?=
 =?us-ascii?Q?O090azqPjwsSb6RzkTIEswJQT0wA1oxXjnzViijGdM7j8HeC7LmrhmZsHJu1?=
 =?us-ascii?Q?nX3PHA3/TPxu08khvcPTEGeyIPwCGEf8yZsAxe6Autdj5BkkULWJtuPwHh8I?=
 =?us-ascii?Q?pilubVaCLR5JaOxAAGmQP1BxzoSNdDpQmVo/ZtCCM6JWZ+ulMcBFAXEEFyPd?=
 =?us-ascii?Q?c4GiJXfa1pugAy0lHylZaMbNPHPpK/RmT4yBz7n0yjFQXnMW8E3ZnI0JzfqV?=
 =?us-ascii?Q?V5kOn4QIUxuuUHZIEA/4BuS7j7O50ucTgK8tS4w7h8nK0RsY9XcVNAf/1tWb?=
 =?us-ascii?Q?PpzUhJ+2/JKpir3p2STPULHtjqUA9TQq548XLR9rTuhBD5WubmBAD6eIj/hp?=
 =?us-ascii?Q?Fhwg?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 22:39:25.6921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9c7929-75f8-4d0c-4407-08d8a3a5c5e1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3iMucK26hSFgIDL4SCQ70P1zLt2BY7RoRcfeqfENlyPh2EdvudrxtNc5/yxx9w5dgGcAxKQDjOMzsipnJb+YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SYSTEMPORT driver maps each port of the embedded Broadcom DSA switch
port to a certain queue of the master Ethernet controller. For that it
currently uses a dedicated notifier infrastructure which was added in
commit 60724d4bae14 ("net: dsa: Add support for DSA specific notifiers").

However, since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the
DSA master to get rid of lockdep warnings"), DSA is actually an upper of
the Broadcom SYSTEMPORT as far as the netdevice adjacency lists are
concerned. So naturally, the plain NETDEV_CHANGEUPPER net device notifiers
are emitted. It looks like there is enough API exposed by DSA to the
outside world already to make the call_dsa_notifiers API redundant. So
let's convert its only user to plain netdev notifiers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 76 +++++++++-------------
 drivers/net/ethernet/broadcom/bcmsysport.h |  2 +-
 2 files changed, 32 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 82541352b1eb..c5df235975e7 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2311,33 +2311,22 @@ static const struct net_device_ops bcm_sysport_netdev_ops = {
 	.ndo_select_queue	= bcm_sysport_select_queue,
 };
 
-static int bcm_sysport_map_queues(struct notifier_block *nb,
-				  struct dsa_notifier_register_info *info)
+static int bcm_sysport_map_queues(struct net_device *dev,
+				  struct net_device *slave_dev)
 {
+	struct dsa_port *dp = dsa_port_from_netdev(slave_dev);
+	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	struct bcm_sysport_tx_ring *ring;
-	struct bcm_sysport_priv *priv;
-	struct net_device *slave_dev;
 	unsigned int num_tx_queues;
 	unsigned int q, qp, port;
-	struct net_device *dev;
-
-	priv = container_of(nb, struct bcm_sysport_priv, dsa_notifier);
-	if (priv->netdev != info->master)
-		return 0;
-
-	dev = info->master;
 
 	/* We can't be setting up queue inspection for non directly attached
 	 * switches
 	 */
-	if (info->switch_number)
+	if (dp->ds->index)
 		return 0;
 
-	if (dev->netdev_ops != &bcm_sysport_netdev_ops)
-		return 0;
-
-	port = info->port_number;
-	slave_dev = info->info.dev;
+	port = dp->index;
 
 	/* On SYSTEMPORT Lite we have twice as less queues, so we cannot do a
 	 * 1:1 mapping, we can only do a 2:1 mapping. By reducing the number of
@@ -2377,27 +2366,16 @@ static int bcm_sysport_map_queues(struct notifier_block *nb,
 	return 0;
 }
 
-static int bcm_sysport_unmap_queues(struct notifier_block *nb,
-				    struct dsa_notifier_register_info *info)
+static int bcm_sysport_unmap_queues(struct net_device *dev,
+				    struct net_device *slave_dev)
 {
+	struct dsa_port *dp = dsa_port_from_netdev(slave_dev);
+	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	struct bcm_sysport_tx_ring *ring;
-	struct bcm_sysport_priv *priv;
-	struct net_device *slave_dev;
 	unsigned int num_tx_queues;
-	struct net_device *dev;
 	unsigned int q, qp, port;
 
-	priv = container_of(nb, struct bcm_sysport_priv, dsa_notifier);
-	if (priv->netdev != info->master)
-		return 0;
-
-	dev = info->master;
-
-	if (dev->netdev_ops != &bcm_sysport_netdev_ops)
-		return 0;
-
-	port = info->port_number;
-	slave_dev = info->info.dev;
+	port = dp->index;
 
 	num_tx_queues = slave_dev->real_num_tx_queues;
 
@@ -2418,17 +2396,25 @@ static int bcm_sysport_unmap_queues(struct notifier_block *nb,
 	return 0;
 }
 
-static int bcm_sysport_dsa_notifier(struct notifier_block *nb,
-				    unsigned long event, void *ptr)
+static int bcm_sysport_netdevice_event(struct notifier_block *nb,
+				       unsigned long event, void *ptr)
 {
-	int ret = NOTIFY_DONE;
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info = ptr;
+	int ret = 0;
 
 	switch (event) {
-	case DSA_PORT_REGISTER:
-		ret = bcm_sysport_map_queues(nb, ptr);
-		break;
-	case DSA_PORT_UNREGISTER:
-		ret = bcm_sysport_unmap_queues(nb, ptr);
+	case NETDEV_CHANGEUPPER:
+		if (dev->netdev_ops != &bcm_sysport_netdev_ops)
+			return NOTIFY_DONE;
+
+		if (!dsa_slave_dev_check(info->upper_dev))
+			return NOTIFY_DONE;
+
+		if (info->linking)
+			ret = bcm_sysport_map_queues(dev, info->upper_dev);
+		else
+			ret = bcm_sysport_unmap_queues(dev, info->upper_dev);
 		break;
 	}
 
@@ -2600,9 +2586,9 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	priv->rx_max_coalesced_frames = 1;
 	u64_stats_init(&priv->syncp);
 
-	priv->dsa_notifier.notifier_call = bcm_sysport_dsa_notifier;
+	priv->netdev_notifier.notifier_call = bcm_sysport_netdevice_event;
 
-	ret = register_dsa_notifier(&priv->dsa_notifier);
+	ret = register_netdevice_notifier(&priv->netdev_notifier);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register DSA notifier\n");
 		goto err_deregister_fixed_link;
@@ -2629,7 +2615,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	return 0;
 
 err_deregister_notifier:
-	unregister_dsa_notifier(&priv->dsa_notifier);
+	unregister_netdevice_notifier(&priv->netdev_notifier);
 err_deregister_fixed_link:
 	if (of_phy_is_fixed_link(dn))
 		of_phy_deregister_fixed_link(dn);
@@ -2647,7 +2633,7 @@ static int bcm_sysport_remove(struct platform_device *pdev)
 	/* Not much to do, ndo_close has been called
 	 * and we use managed allocations
 	 */
-	unregister_dsa_notifier(&priv->dsa_notifier);
+	unregister_netdevice_notifier(&priv->netdev_notifier);
 	unregister_netdev(dev);
 	if (of_phy_is_fixed_link(dn))
 		of_phy_deregister_fixed_link(dn);
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 3a5cb6f128f5..fefd3ccf0379 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -787,7 +787,7 @@ struct bcm_sysport_priv {
 	struct u64_stats_sync	syncp;
 
 	/* map information between switch port queues and local queues */
-	struct notifier_block	dsa_notifier;
+	struct notifier_block	netdev_notifier;
 	unsigned int		per_port_num_tx_queues;
 	struct bcm_sysport_tx_ring *ring_map[DSA_MAX_PORTS * 8];
 
-- 
2.25.1

