Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E7B2DEBAF
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 23:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgLRWke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 17:40:34 -0500
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:29348
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725855AbgLRWkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 17:40:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLkn+vNyffTUcrlscsDhMtqhTxWpsrPgY/cQRu4VV4YDT8JbeULxrBoGPEccXshAJf6XH2nfY12R39vxyjN+wkH8ob2Xe2nWYVWnvDuH12FXyHKsyOoLxyoJ1X5Gq99oBtxhsTtpRjAVI+48K8RMlqpaRurEC2P4mRPv6awpE/D2OppVC/5wffOZ6vUZeOhG071IPj5i+gUG2LBa74ZULsWEUbN6lRrX93Pv3DBkcP6hpHL9w/bw6TWhUA6g8CVHNQD77yt5R/oXFGteYovn4RXO+YBkXPdpTYzptwQTrPx0qVrmaECIJZxIgR6n/Q5VXQbkjMyIeLG1NRWAOzfPEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzbXj9kJHGu/s2Y2HNQxSyW3mY1FBjhLcK2ziiarX20=;
 b=n+I8PWsjFjeHsyoQwZLje8xOxwei9MidtGT9epvBdhz8iLN3+rTzGh+J9mZ0p30dyGZ7pcLwUFji2QtPZIzi/kgZFo5VgOL//EmjAYBcKhQC0NRIrjKkCpql5NLNlR9q2vTzCa3sahPz34AK4vlP76fzGIbFLRgYvroqsBAkr3PvqtRUJP6SmW7NUC7Q7HJed4I9NSR5Y4QwihsdfC3dLdAv1mAhWSjcTSnsgwd1gDm4o1yUdm/r+ZiaAQrMUfUqZBonS34kj9LlSMMzLdbhIGEvghqqGGxabxWRdxl4+ZHDpjwkGcKF5Wmy/sNdmG4egp4KVqBGvRUi5YXdRP/xfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzbXj9kJHGu/s2Y2HNQxSyW3mY1FBjhLcK2ziiarX20=;
 b=RiRYz5uZ3eRze2Qq3CvL/wcOSn9VurPrOsc3zPVyuIEWW/Q7LBGMurkDe5oYHZck3tlqay6TiS5YPoGrBorBGXX+SwKRbsIMUzFMLS3NXY6kxn+sAzt0nwgtRJJj2ZZZA6lzAvEdpw4h9q9e7FMQdWRvayugZpSz76vNYtyxvcg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 22:39:24 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 22:39:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 2/4] net: dsa: export dsa_slave_dev_check
Date:   Sat, 19 Dec 2020 00:38:50 +0200
Message-Id: <20201218223852.2717102-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by AM8P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.28 via Frontend Transport; Fri, 18 Dec 2020 22:39:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 095cccf5-091f-4959-420e-08d8a3a5c545
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2686F460A1A953C73EC92462E0C30@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aq8J5ss8IDtLh8KvyekePEnZh52l0RGFzSL3LihiJUXPbNkt7x3xZdpMLyJUtFbrMT4XmMru/FFmaichs1xIPTJtqOpmVKD53CltdVYmS8/MF6KZrU0R/n+1sMeuOXeddGZK+7z6zuE8k3FFu266q6anTXqJmJxodunZkTgOjMF6sqYk5DT02ZgJKUNuoyNy2BGTMSparQvEp382tVfJLXjFBANKfz1Eqpt3upt9hmYMjJzaxyBydzAfc8+t0awA/oiqR+fqubnDbjmBvLNfn7tv1HR2KX2BNnaQESiigE6yYkt4vBvToMM71Y6yLFifKBrbssW4JA3JJCclJC2kPwQqY5ROAaQggne3S5BJS4urwY6yhXUkSKqSKjdz61a9BYVLJ2FdXWH670Zn0pJzs0ln9BQDLpjRKAhbAm6oW7xoUd8SBzGfvTZqjUTBpHrpxdSK+PLMfKggjZRGcO/jrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(52116002)(2616005)(66476007)(66556008)(956004)(83380400001)(478600001)(8936002)(69590400008)(86362001)(44832011)(66946007)(6512007)(36756003)(316002)(5660300002)(110136005)(16526019)(186003)(8676002)(26005)(6666004)(1076003)(6486002)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nyA9Hl7VlyG5fMuzzWu77mkxTRjLBk2ZXgT4V7zK5iewyApPbj2CvEcm3DLy?=
 =?us-ascii?Q?OWf3A01OS27Vw6LbICkbHXbM3kyyy3P0gOEXXHg5qin3XVLNW4toBQAhSC7R?=
 =?us-ascii?Q?3gdDmypgFF6Z2bzqZAhdSZTvt5CjQ1kA7G+BlzPTMqVYUSbTe7RxK1/PbmAm?=
 =?us-ascii?Q?GDP/l9CI9jfTIs88DWI57n5TzgVjT9HuoOwUpbaeV0lsC/22pER5InCFrVyW?=
 =?us-ascii?Q?iZB+rUhT+/uqANejzMDq6dRczbX+6Rx43vPzIGrfE9mJK/EHx+x7khgTcrKU?=
 =?us-ascii?Q?LCDH1sbIYNgA+fG2u1jKt9Uz+aeQkpzbx8XU5Z3lbE+Cm7b6UCdQQIJeh3Bw?=
 =?us-ascii?Q?eOf/OtG8dozsyzPf8rytErw6S9pkzbPZvVqz4Fz3R7ErFEjkZqdPdwbvRNWa?=
 =?us-ascii?Q?Tj1b0JQUDHWjIkgKW7QDeQfDjl56wBluhhWkYMJmGQJQsDc+SYRN41swQGvw?=
 =?us-ascii?Q?kFXZWA5LclcefzfmF16EiDU+U3dGuPhxQIJHG3l4PnoNgavSZ0QFAXEM3EoS?=
 =?us-ascii?Q?OfA/RwJMuYr52q36qTbTJ8WAeYn1FU1cogl3eAty8kEc8Os7lqkgfAXuk+rI?=
 =?us-ascii?Q?wvGvdQE/mOPCf91VJK8X+kjx47uPlRY20tIzwa/qdbyAXq7Nj3QoEajf1Mfk?=
 =?us-ascii?Q?HQDjhNBrmfljhor6ripHYq/9mAURlOXtrCOO89wUHbYRWF2QVJXOcICNfSNE?=
 =?us-ascii?Q?oV0eT1p4henZHA9d5cdty0+APX68ZyJz3/MpEJxkFfewoFzgy0FONWyUHs+q?=
 =?us-ascii?Q?OgNjtskDMxoE61TIG6Nlvx73518uhrEhmdQ11csnyykJQQ/OzM8iA2/dYU0h?=
 =?us-ascii?Q?9rSKxQtQsJWk+XUeg9sCE1rj47CiV5c5PPjdFJfbLOxPfkIN+qbr2sUO2aVL?=
 =?us-ascii?Q?o32Yd5WWCLmKU1/AMummmLvEcYBjz00mL12J8u2FWAebTRE2Jhbj2BYQA07A?=
 =?us-ascii?Q?hcuk9KQuIx6A2lR7dBhahkSbu49xEaewMOt4sZiCQOMUJsz6a5Fzh4dUfk5c?=
 =?us-ascii?Q?7GPu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 22:39:24.6777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 095cccf5-091f-4959-420e-08d8a3a5c545
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: raQTGLN6LUv7zlMV8B1j757vbkVRM87Eqw6wiETreNimPoyHzjCM2MjLoaw1Emql/FuOefBoiStMDJAepIV/EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the NETDEV_CHANGEUPPER notifications, drivers can be aware when
they are enslaved to e.g. a bridge by calling netif_is_bridge_master().

Export this helper from DSA to get the equivalent functionality of
determining whether the upper interface of a CHANGEUPPER notifier is a
DSA switch interface or not.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  | 6 ++++++
 net/dsa/dsa_priv.h | 1 -
 net/dsa/slave.c    | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index af9a4f9ee764..5badfd6403c5 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -855,6 +855,7 @@ int register_dsa_notifier(struct notifier_block *nb);
 int unregister_dsa_notifier(struct notifier_block *nb);
 int call_dsa_notifiers(unsigned long val, struct net_device *dev,
 		       struct dsa_notifier_info *info);
+bool dsa_slave_dev_check(const struct net_device *dev);
 #else
 static inline int register_dsa_notifier(struct notifier_block *nb)
 {
@@ -871,6 +872,11 @@ static inline int call_dsa_notifiers(unsigned long val, struct net_device *dev,
 {
 	return NOTIFY_DONE;
 }
+
+static inline bool dsa_slave_dev_check(const struct net_device *dev)
+{
+	return false;
+}
 #endif
 
 netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7c96aae9062c..33c082f10bb9 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -172,7 +172,6 @@ extern const struct dsa_device_ops notag_netdev_ops;
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 int dsa_slave_create(struct dsa_port *dp);
 void dsa_slave_destroy(struct net_device *slave_dev);
-bool dsa_slave_dev_check(const struct net_device *dev);
 int dsa_slave_suspend(struct net_device *slave_dev);
 int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4a0498bf6c65..c01bc7ebeb14 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1924,6 +1924,7 @@ bool dsa_slave_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &dsa_slave_netdev_ops;
 }
+EXPORT_SYMBOL_GPL(dsa_slave_dev_check);
 
 static int dsa_slave_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
-- 
2.25.1

