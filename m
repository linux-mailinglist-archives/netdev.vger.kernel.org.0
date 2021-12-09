Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AEE46F23A
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242360AbhLIRnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:43:21 -0500
Received: from mail-eopbgr140049.outbound.protection.outlook.com ([40.107.14.49]:14725
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234299AbhLIRnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:43:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R119o3TL27tFr6epPznIzdq+OangR17ibGvsFqCsYTmuE7nHroAtpQsGsrwR7ZneF9bVdq8qBn6f4o23J8uqQ5Os6EpDlOGDad5wMbD1yhVmjIMAGd2zAfOfyVsWw9sUABFkPndhg4xHyC1rfDR0xi6V2NlJSrXHMKub6JPXryHGtgZH+b+8KHktCeXaZfJZf9Kv5rzu6rjVqzs40GvxJjI19r0L+irf1JlGrNkBv7jA/aDXSwNF2VzHubeWMUZVL7yb5AYdUPT9TXwskk30wU+RkMZOz2fcyHsbI/l3vTTT0BG73ZTCi4Tq2jrn8jsnxmLzMzD9WP/RY862f4ORjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uetAPhmtLg+eyptP9D/XJBEy48fwVTjJFUIdfRPsvHo=;
 b=OrCV6ldUPQJSOWK14x2+ZJf+vmQ/qEv41QicB2yxhYvrWAKELdhPOla5hxDAJZqqD0Unh+vRQxXitXtII2LZzW4YCYEs82GjezXI6HlB4x6+dINpon+LRj727fohZR7Vlh2hdVaaSO6KsHZqi8nMOt2ZOyhHYqtHU6MZUXafh3rMO94969V+8EzBodRBbHxpIkAwp7tkX1o+Seg9NTxmZgalJLqynDGENU9x5+Yn8ZaypiK3OKxJ75UIOrabW2IHNyn/jX74TjC82xsVD8xgufSN72UZysKHgJUYekljujW7wC0SCeSeS9jvyUu/4sLoupcjXAibge70EyupzLL5uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uetAPhmtLg+eyptP9D/XJBEy48fwVTjJFUIdfRPsvHo=;
 b=TehDCxZDE8hAv1tjZF268uSmFIzEKjkRw3R2zSjgPOnBniXBsksqp8pixsmCM6qj6sQgcVX88r3W8AUW3PMtkK7w4h8TlDq9wygXZ0zqaFU3T2I2rOzmq4jvKzzSeN/LGuq7HBJmDCIbodmZYtMu34tWkF5KPlXr2bQRJ+mK9O0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 17:39:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 17:39:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v2 net-next 1/4] net: dsa: provide switch operations for tracking the master state
Date:   Thu,  9 Dec 2021 19:39:24 +0200
Message-Id: <20211209173927.4179375-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0059.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by VI1P195CA0059.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 17:39:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4d38b71-1bb0-4cf8-5d90-08d9bb3ae31b
X-MS-TrafficTypeDiagnostic: VE1PR04MB7216:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB7216F752325ECB5F43B1454CE0709@VE1PR04MB7216.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JGKhI4+DVZfzvBQ/vq1DymJ7Gwq7dPeuJnCY6KJU4Rir4u+B1E0CV6ExPX/CJGDlqMd6ll6nMR7qHjnu++6MfVMrW8lImoBM5C1CtvCp3Ym7+xPWxF43usGPIvkIL8+6Mm6jtWBQP0rPO5wOCHnNCPL969i/9FfLorA8zbkWnyzt5bjhi3C/TexQFRYzJ/LHyi0zKrRKt2M+I2PuEeD6POqMQXGQQj3SfeIF5DN2NmpUhXmP9r0y8SwgKaf0o0j45eddBcvzwgNG77iDqULfZ6H8b1S1dTlvA2ilTIsZ90Cy5Y13xTOfmEgdj8mVswfNcxF+H7y8Gw2+lUHjOFBp/ksZwUYfAagflyeQqL1PLvV1nf40LlaHtSP8gdU2FMzJ4ae7vhGSM7oCjlDo2G5XLbF5ySO2x0OLAbfeE7YE1wLlXLVgtCzWCKs+KjZs3U2WvbkR/E1IJ9VuY1p35gf+L/xSpOk/r/mehGHcUl/bubHg/rHpYglwXkwmoefbsX+PINu659rVHHvmFLkteLqjW5hhxIKi1IwZIKmfmbK3M1Nc6fDojSEjnYs4tMEDmioQ6cLUQGuBNzQT48djcAex6L0nezgviHI8Se2S1vSm8gzekC0btfjOZkjwgxIu3zXNFTYI7k+iSSIutEqQDpwX0tVRmz9W7O7S5Dx0ZTz/H7/JH2jvWNCzO1a5xSRMzQiuibxW0zzo6VIoJULUfDyARw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6666004)(5660300002)(1076003)(44832011)(508600001)(6916009)(8936002)(956004)(8676002)(66946007)(4326008)(66476007)(66556008)(86362001)(2616005)(6486002)(26005)(186003)(83380400001)(6512007)(54906003)(38100700002)(38350700002)(2906002)(36756003)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HRCSJvDrLkmA5FAYvyHOR3oepBI7a0phsBL9H+QxnxPbqV2zG0kDa1cKwGjh?=
 =?us-ascii?Q?EPglW6OlVdmvDDscNXt8oVvdBtxRyw7nfNj3iJx7zwsLfVZy/H5KBJo3QRoP?=
 =?us-ascii?Q?07mGLwxIc0ehRjUiGQgBzDDLDNURqdpGfax3HBWIxcm89ZbKEJZYBKMe6VZW?=
 =?us-ascii?Q?FZSHn3bR6/8K3byAL+lARdfowQMKMyHec7w82HjpXsvW13jDmzcy5+fQq4rk?=
 =?us-ascii?Q?x5kTpTOLoEPd/vkN9tjeLLL6W8WXE9fav1IXxe5ngDtuA2US8eT1NNe2yDNW?=
 =?us-ascii?Q?2hpBSq1wpgprDrZXjpgGPcV23EESyE7vrkOaCqjBnv86R6ezOiIMNxX3k0gU?=
 =?us-ascii?Q?VTV5gV3Km7WlCX4+JskHWGGbylZCpq5FWb5YpSRpCeCCFPDcJYV8Zr2RLD0/?=
 =?us-ascii?Q?zG139PFTUT35oHc35TmKU8ZZHdCk9zNZLJUD16T8IWcJNX237oIgIwJKVOSe?=
 =?us-ascii?Q?WJc99KhE+egQtl+d1RkG1y6wLcETlYlQ8hpoKhUIXqEyfkr7tMYlbapLiDqM?=
 =?us-ascii?Q?UWz6AwqgY7ACrnItO5KD9I2sC7daYyxJ3accURrzusvIIWmwpX1zih33m8x8?=
 =?us-ascii?Q?x8ouC2/+Lebcg2IFQJgQKBz0X9xchmqeLATLep9PSX5UUgWKm38a8Pn5h9hv?=
 =?us-ascii?Q?x+zdYyyls7jpJCuT4HoVGmQM/JP8mSzuirFLryspwYsxZwfJzVr9y4CzASJP?=
 =?us-ascii?Q?UBRfY+qQe4VluhirTVd2mKRnEDiY43eIcLSbQY5/evLybWsNKmxfTjJOQ4Bl?=
 =?us-ascii?Q?ACimJj4k1U5MpJWrD92rQQ8YoKMn0xyvammSdpIc6yuForNUGZV6sr6BZtZS?=
 =?us-ascii?Q?gGGgQ7TsJJYD0KqyVYt8XbiFYtN2YLozjmYB+tZStUBhQA07it88rtSylYxh?=
 =?us-ascii?Q?GfBWA39fbo+hkkSZ49ppAbvQsO3jOcX5UZCLHP++WZySSEO+V++mXepZjL99?=
 =?us-ascii?Q?m+3lmnLJs1aIIl3V0Gw0CeXrzuC3Ewj3rXo0Mg7/fV+fxqlMLCinYO4t3eMz?=
 =?us-ascii?Q?vltnE2hpOk5a8SQEi0/7bQnS/cTAHBp+UeQcIkh+maD7uzqyHaKoFoZ0GCFa?=
 =?us-ascii?Q?ZSBf3CXFjMcBbYtxEOe2E5aVxEhsuu8nnDen2HzYlkRO3zu0f+p8y1B53/W2?=
 =?us-ascii?Q?4EzVxdPvLeGjtHZfm64DcaIZrnj2Sz5t9QZcEh0Tw7hRL8QUnGea/NFbDdwB?=
 =?us-ascii?Q?hFXkA0ipIVAErSyPfde6UMFes3CfJelyBiJ9dpCmd+39UAj5Dkmg6ZfoHokh?=
 =?us-ascii?Q?tRXl3GdNvWpyIqJUO/8zdtYG6BXZfLdPPXBDreVW0OvMyvgerInF69iL+yst?=
 =?us-ascii?Q?66MxesY+sXB6BokDy4M602+WYdssKntp7mYGWdwpgUXr1BrhsHvWL1PPeOXI?=
 =?us-ascii?Q?PFn5FL0cIxBgUYktXd/YRqq4iIsoUDv1iPc+9e4xP4jqxo1cAET/Zxhb15RA?=
 =?us-ascii?Q?y6kXTsJkHkEtj1LPcsP6C0Eppm6zz3chryFMnnsNm96NORHtpLN9XuUqyh5t?=
 =?us-ascii?Q?qRhTs/TfVB7golXUdYRtbs3M90j1yKtEECRQYv9sL+LpAtD0AdaYL9Pzpwno?=
 =?us-ascii?Q?3lKnzOMCcgHekfgkuPG1RaUqtcLPpzFu0ZXjiu3aqyrFJOfosdJnTfjROeLD?=
 =?us-ascii?Q?4NBiz3aJ0bVosxJUfiUWCA8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4d38b71-1bb0-4cf8-5d90-08d9bb3ae31b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 17:39:44.3760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RcIosjnDUrUwK6mADAkYuestEXUyXq33Nz96kkskc5yhiM+kLNyD9usY7Cex041f2dn5EuqKlyswaH3gsb8gJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain drivers may need to send management traffic to the switch for
things like register access, FDB dump, etc, to accelerate what their
slow bus (SPI, I2C, MDIO) can already do.

Ethernet is faster (especially in bulk transactions) but is also more
unreliable, since the user may decide to bring the DSA master down (or
not bring it up), therefore severing the link between the host and the
attached switch.

Drivers needing Ethernet-based register access already should have
fallback logic to the slow bus if the Ethernet method fails, but that
fallback may be based on a timeout, and the I/O to the switch may slow
down to a halt if the master is down, because every Ethernet packet will
have to time out. The driver also doesn't have the option to turn off
Ethernet-based I/O momentarily, because it wouldn't know when to turn it
back on.

Which is where this change comes in. By tracking NETDEV_CHANGE,
NETDEV_UP and NETDEV_GOING_DOWN events on the DSA master, we should know
the exact interval of time during which this interface is reliably
available for traffic. Provide this information to switches so they can
use it as they wish.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  | 11 +++++++++++
 net/dsa/dsa2.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h | 13 +++++++++++++
 net/dsa/slave.c    | 27 +++++++++++++++++++++++++++
 net/dsa/switch.c   | 15 +++++++++++++++
 5 files changed, 112 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index bdf308a5c55e..8690b9c6d674 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -296,6 +296,10 @@ struct dsa_port {
 	struct list_head	fdbs;
 	struct list_head	mdbs;
 
+	/* Master state bits, valid only on CPU ports */
+	u8 master_admin_up:1,
+	   master_oper_up:1;
+
 	bool setup;
 };
 
@@ -1011,6 +1015,13 @@ struct dsa_switch_ops {
 	int	(*tag_8021q_vlan_add)(struct dsa_switch *ds, int port, u16 vid,
 				      u16 flags);
 	int	(*tag_8021q_vlan_del)(struct dsa_switch *ds, int port, u16 vid);
+
+	/*
+	 * DSA master tracking operations
+	 */
+	void	(*master_state_change)(struct dsa_switch *ds,
+				       const struct net_device *master,
+				       bool operational);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 8814fa0e44c8..a6cb3470face 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1187,6 +1187,52 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	return err;
 }
 
+static void dsa_tree_master_state_change(struct dsa_switch_tree *dst,
+					 struct net_device *master)
+{
+	struct dsa_notifier_master_state_info info;
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+
+	info.master = master;
+	info.operational = cpu_dp->master_admin_up && cpu_dp->master_oper_up;
+
+	dsa_tree_notify(dst, DSA_NOTIFIER_MASTER_STATE_CHANGE, &info);
+}
+
+void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
+					struct net_device *master,
+					bool up)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	bool notify = false;
+
+	if ((cpu_dp->master_admin_up && cpu_dp->master_oper_up) !=
+	    (up && cpu_dp->master_oper_up))
+		notify = true;
+
+	cpu_dp->master_admin_up = up;
+
+	if (notify)
+		dsa_tree_master_state_change(dst, master);
+}
+
+void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
+				       struct net_device *master,
+				       bool up)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	bool notify = false;
+
+	if ((cpu_dp->master_admin_up && cpu_dp->master_oper_up) !=
+	    (cpu_dp->master_admin_up && up))
+		notify = true;
+
+	cpu_dp->master_oper_up = up;
+
+	if (notify)
+		dsa_tree_master_state_change(dst, master);
+}
+
 static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
 {
 	struct dsa_switch_tree *dst = ds->dst;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 38ce5129a33d..c47864446adc 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -43,6 +43,7 @@ enum {
 	DSA_NOTIFIER_MRP_DEL_RING_ROLE,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
+	DSA_NOTIFIER_MASTER_STATE_CHANGE,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -126,6 +127,12 @@ struct dsa_notifier_tag_8021q_vlan_info {
 	u16 vid;
 };
 
+/* DSA_NOTIFIER_MASTER_STATE_CHANGE */
+struct dsa_notifier_master_state_info {
+	const struct net_device *master;
+	bool operational;
+};
+
 struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
@@ -506,6 +513,12 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
+void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
+					struct net_device *master,
+					bool up);
+void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
+				       struct net_device *master,
+				       bool up);
 unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
 void dsa_bridge_num_put(const struct net_device *bridge_dev,
 			unsigned int bridge_num);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2b153b366118..9f3b25c08c13 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2349,6 +2349,31 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		err = dsa_port_lag_change(dp, info->lower_state_info);
 		return notifier_from_errno(err);
 	}
+	case NETDEV_CHANGE: {
+		if (netdev_uses_dsa(dev)) {
+			struct dsa_port *cpu_dp = dev->dsa_ptr;
+			struct dsa_switch_tree *dst = cpu_dp->ds->dst;
+
+			dsa_tree_master_oper_state_change(dst, dev,
+							  netif_oper_up(dev));
+
+			return NOTIFY_OK;
+		}
+
+		return NOTIFY_DONE;
+	}
+	case NETDEV_UP: {
+		if (netdev_uses_dsa(dev)) {
+			struct dsa_port *cpu_dp = dev->dsa_ptr;
+			struct dsa_switch_tree *dst = cpu_dp->ds->dst;
+
+			dsa_tree_master_admin_state_change(dst, dev, true);
+
+			return NOTIFY_OK;
+		}
+
+		return NOTIFY_DONE;
+	}
 	case NETDEV_GOING_DOWN: {
 		struct dsa_port *dp, *cpu_dp;
 		struct dsa_switch_tree *dst;
@@ -2360,6 +2385,8 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		cpu_dp = dev->dsa_ptr;
 		dst = cpu_dp->ds->dst;
 
+		dsa_tree_master_admin_state_change(dst, dev, false);
+
 		list_for_each_entry(dp, &dst->ports, list) {
 			if (!dsa_port_is_user(dp))
 				continue;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 9c92edd96961..78816a6805c8 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -699,6 +699,18 @@ dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
 	return 0;
 }
 
+static int
+dsa_switch_master_state_change(struct dsa_switch *ds,
+			       struct dsa_notifier_master_state_info *info)
+{
+	if (!ds->ops->master_state_change)
+		return 0;
+
+	ds->ops->master_state_change(ds, info->master, info->operational);
+
+	return 0;
+}
+
 static int dsa_switch_event(struct notifier_block *nb,
 			    unsigned long event, void *info)
 {
@@ -784,6 +796,9 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_TAG_8021Q_VLAN_DEL:
 		err = dsa_switch_tag_8021q_vlan_del(ds, info);
 		break;
+	case DSA_NOTIFIER_MASTER_STATE_CHANGE:
+		err = dsa_switch_master_state_change(ds, info);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.25.1

