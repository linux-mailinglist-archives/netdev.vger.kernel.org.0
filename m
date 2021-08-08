Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5A33E39EE
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 13:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhHHLRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 07:17:13 -0400
Received: from mail-vi1eur05on2067.outbound.protection.outlook.com ([40.107.21.67]:37893
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229473AbhHHLRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 07:17:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7XbkCADtK3JCueb5UkmiL8a7gxflreOMC4vRrfKXvf7BvfIR+U+9jHP/SN5Rq9xEGWWfjwFaE3CHiTkTCNmgmsb94TW/TgNOMOMEwmaJ485uQ0pplqcjpKZyLpzhKmhaye+porN2hFAQpk7OVFMQNfL26B8ZdI15XmTuqin24CDog3b0adE2xWITGetH/TmZyjzd6SK8P8mM6DyBimh+0eDJqaaqSTG6OFoTgK19BB60DaIo4l7fuuCqGnfAs5EBAYkFV1a75bLhZzSIwh/jC7hV9bI47V7ADMKhNarlIYvDoYv5bTDOGHqlhzEygYbm9+IAVCqVosTZsipaWOUBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N93P283FExNl5NKqEzP45fmw3zPdHiS5NUcUjP52+Us=;
 b=i025+lvVVvk2tMijaVdfpcauAauqF6ZRl36aHYVNeN0cupazMVwHgsY+h71ZqY5ASZ+9xEotlF32CI0qxoldaQj6WA39iUy9x7cWxLYdf91Hj9u8BkDAy3+CjtHEI5WKna+cCN5cAAToo+Kdi9iO73B9oZXuW0dlBWIutKvJUnmrJ+Udg7WDncpFs0+NFCOXA0jgA8nvNXsLy9qad8lhuimXol04qxTI/nUarXilJ18yqs4qklO90cSK4ik9WqhtXnmiu8M8yhnoascUMZ3PZUjOI1obzj9DkTcltffESHMLUEzrOZPjQYbM4pMaXtZtuBbMQuUW/pQrPkIGcSpFYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N93P283FExNl5NKqEzP45fmw3zPdHiS5NUcUjP52+Us=;
 b=Oqc19N5cZWo3n2KVfQ/XiyP6rUuK4JXqHVvDZRCmaXKqBhBCJx2Ncui+L3Ip+ohfFA65vtgeMY47lNEJMOntmnELxSOriFnT4Olge0fK7pMeqPX0L9D0cCdN3sqIl8g29ASaCiGQgHcBHZcsQChBBNVy5annShL2mbvt1xiv7zQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4687.eurprd04.prod.outlook.com (2603:10a6:803:72::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 11:16:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 11:16:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: don't fast age standalone ports
Date:   Sun,  8 Aug 2021 14:16:37 +0300
Message-Id: <20210808111637.3819465-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0021.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0602CA0021.eurprd06.prod.outlook.com (2603:10a6:800:bc::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 11:16:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37ea6876-c787-467e-6c15-08d95a5e04dc
X-MS-TrafficTypeDiagnostic: VI1PR04MB4687:
X-Microsoft-Antispam-PRVS: <VI1PR04MB468763B2A410617B497E2774E0F59@VI1PR04MB4687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yn8iE2PZyaM12VN9kmW+8MzLck2RFYuD0dQ3yIiizO0COIETUrgZ+mYh4A8gsqTa4g+pJonHMzjCvh7wZ+KlPf61cYaPQY5tB+lX0jScjiZtBBeH3Xk8MOylwkAc+5ErD9yHZ9YSHgksEVPSZRnzQNBeRmoe/TV5tgtz2HrzDQKONHWuZaxgHDrktU7rzy4dkymB5C7UpRoPQ4j8IXQFzhrlUmWfD6fnSBaBiZtzX9Tskv0wKg09fe5cUve1J83Grc1bzgyNSWT6T7WcNg2Zw98jTcYoPunZSwLqyauPWaboiVMifMwSDP+6uFI87idtnE2Let5CrzzcBK0PLtBP4s+eAHcC55tT+4UbTrRrNl2+ZX6W55r+CCjATuinvvI27JBpz0ZTtzyt0WVv8yBtrmklFYuCz6J/j4kEKMarRIUyg22igLCUZgGgKYIN+QpC6jHHsr5OpgPVz2At4sr2PsZkbfpj+snTVUUZpY/gsLlIzgZo2FbB+6ak6mK0AuE0dER4SmAPzWSeeUHA6R9LcvZ/XU6h3vOvFugx9rJ+AFw5zz9e28+ADZmfC6BlHDib/KKRwFRUk9pn3cQlSlIxwE16LEf8XTLtCwof0wHLDZO/wEjQLQUHIpXV2k9ttV8lLPVkOKpkp/geBPBnbGmjQgE+xZIo7FyscdmRGSS6TrS3tkUxwkOrR5Su+WhtONGGJFuvBM6NAIFNqTJ9EIxU6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(376002)(396003)(136003)(366004)(956004)(2906002)(2616005)(36756003)(44832011)(8676002)(66476007)(66946007)(83380400001)(6486002)(86362001)(66556008)(38350700002)(8936002)(5660300002)(38100700002)(54906003)(1076003)(6506007)(316002)(6512007)(52116002)(110136005)(6666004)(26005)(478600001)(4326008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+MJJ2CGbgpKELK8FhXdsce1eHGiWJlQwaQa8FZk3bhCXeNhzQ/B9HlDnPT07?=
 =?us-ascii?Q?KYhBuj5i3uJS7j+UDdoFArXPif7RZyJiRK/2iEBw2vJLbhENQZZK/wp5pNT+?=
 =?us-ascii?Q?o/TyUGavCrDSbfy27rRUoI4HZiGraqkilfyUDR3Pwep34QVvxAKbpasxQNk/?=
 =?us-ascii?Q?jsBVrUW6Xrwz4/fbFphi1Umy1f/2spbEr4vKE3ZbSo4Uwzi/lcMbiukMNRqD?=
 =?us-ascii?Q?16lZq5HZm2id0Pnbwy6+Quw/OZuv3V9U2/CsH45yPrOPqFK2IujE+YI7wT3+?=
 =?us-ascii?Q?51L9wgSIoWoMGnBjyGp66/ZqjvweK7Cy6jwMnecYEzwR8Jq7hiBXXSFCD0jM?=
 =?us-ascii?Q?o0ydZJSplT8BlstOp2jJyP1OAl9pRtM0R7R9G9uhpYLJYAQJJagWpEepofnP?=
 =?us-ascii?Q?gkcCfKidLvKdh57Sj85lkytHRlLJlRUt1l02PtlVjf+TnvGuyVS44iaF3Dm/?=
 =?us-ascii?Q?M1ah/609So9OVwDoYXVoIBrI/ipjM1zUg1c5vSCj8qc7q2zgLPczu6WqQB3c?=
 =?us-ascii?Q?N9hXdr7vFZOt7yzn7iOhDFiIArqOCmQPqBNV6IFj0UaJLRwhOHBXD0Pilggu?=
 =?us-ascii?Q?NdizOiJ07peJZi6BRIyf4gQFR1sywrdo0fqgoobF7RkU/wmNICU2kI5gvq5U?=
 =?us-ascii?Q?5xU3hQlGAqanq/PSN3TduN//F2HVGCv5sCPXQkUXXx2SufIYtUbegwYFmgwN?=
 =?us-ascii?Q?Of8VaSAEel6Yh19U1VHtvBwTCgJtu54pQC/i0qd+HZu/U19bgfcp6Aun1kcH?=
 =?us-ascii?Q?I5s8N1Ki6BmFBHEONm5OWbdkVNvNbXkO1PhC8cMd/F+UXyekFZxIrVntM6Wt?=
 =?us-ascii?Q?NdaU6Lcd0HD2ORAHuQuZVN444Cna7NQ4DDN9h8lGQtJJ1Hh3fC/njkbua9vA?=
 =?us-ascii?Q?7oaEX3JRqPUIW/FF3yf2X1nbDO/jXYsTk3Mk/7twtxObKjcqTnefz18ML5cZ?=
 =?us-ascii?Q?NRIpABPOVjucfq96Dcyk9J+z6LJJNsD2p+0/IbBnS2jbacnvhC2nOYAJFkA4?=
 =?us-ascii?Q?MEnv7PgsFST0Y9zYLeGi5xDtW0sg2QLTL7I3oLN4mIemZ4naYo9PCHjm956q?=
 =?us-ascii?Q?dRySCS0sZFud1W+IqXyeVg6MBNZkiO1zLpSEwejgcXv/GBCOwRepgSUq/JFg?=
 =?us-ascii?Q?vwx58SmfC+NxYT8i94nXtHBfNv4kqRG5jFrmHs8bAS3yc40yLU83v/dpbxY8?=
 =?us-ascii?Q?cZ2P+/zHwYTkAVDRbhy1YEKTNnCUzbDAVQB8z0bCHvMiLI5hUfQou6Zcmc+k?=
 =?us-ascii?Q?f7aM+A8w+8iQM/B1yuI+D7u8kxy1b01hiYdwwtmpXPIzRpDhxjD4MjUC3WPy?=
 =?us-ascii?Q?x/ZmhPeAgNbNDBRDX+8wqa13?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ea6876-c787-467e-6c15-08d95a5e04dc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 11:16:50.7064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gN9HOjnXeh5CgyC8W43pcyZ9DpAhhYP4iHTssCSjE9OTlpmbOQJgkWuEsWYjqUdLS+IGklcMBJFswmQ7RiWEjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA drives the procedure to flush dynamic FDB entries from a port based
on the change of STP state: whenever we go from a state where address
learning is enabled (LEARNING, FORWARDING) to a state where it isn't
(LISTENING, BLOCKING, DISABLED), we need to flush the existing dynamic
entries.

However, there are cases when this is not needed. Internally, when a
DSA switch interface is not under a bridge, DSA still keeps it in the
"FORWARDING" STP state. And when that interface joins a bridge, the
bridge will meticulously iterate that port through all STP states,
starting with BLOCKING and ending with FORWARDING. Because there is a
state transition from the standalone version of FORWARDING into the
temporary BLOCKING bridge port state, DSA calls the fast age procedure.

Since commit 5e38c15856e9 ("net: dsa: configure better brport flags when
ports leave the bridge"), DSA asks standalone ports to disable address
learning. Therefore, there can be no dynamic FDB entries on a standalone
port. Therefore, it does not make sense to flush dynamic FDB entries on
one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  2 +-
 net/dsa/port.c     | 20 ++++++++++++--------
 net/dsa/slave.c    |  2 +-
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7841b3957516..8dad40b2cf5c 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -199,7 +199,7 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 /* port.c */
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
-int dsa_port_set_state(struct dsa_port *dp, u8 state);
+int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
 int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
 void dsa_port_disable_rt(struct dsa_port *dp);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 797a3269a964..ef5e08b09bb7 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -30,7 +30,7 @@ static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
 	return dsa_tree_notify(dp->ds->dst, e, v);
 }
 
-int dsa_port_set_state(struct dsa_port *dp, u8 state)
+int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
@@ -40,10 +40,13 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state)
 
 	ds->ops->port_stp_state_set(ds, port, state);
 
-	if (ds->ops->port_fast_age) {
+	if (do_fast_age && ds->ops->port_fast_age) {
 		/* Fast age FDB entries or flush appropriate forwarding database
 		 * for the given port, if we are moving it from Learning or
 		 * Forwarding state, to Disabled or Blocking or Listening state.
+		 * Ports that were standalone before the STP state change don't
+		 * need to fast age the FDB, since address learning is off in
+		 * standalone mode.
 		 */
 
 		if ((dp->stp_state == BR_STATE_LEARNING ||
@@ -59,11 +62,12 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state)
 	return 0;
 }
 
-static void dsa_port_set_state_now(struct dsa_port *dp, u8 state)
+static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
+				   bool do_fast_age)
 {
 	int err;
 
-	err = dsa_port_set_state(dp, state);
+	err = dsa_port_set_state(dp, state, do_fast_age);
 	if (err)
 		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
 }
@@ -81,7 +85,7 @@ int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy)
 	}
 
 	if (!dp->bridge_dev)
-		dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
+		dsa_port_set_state_now(dp, BR_STATE_FORWARDING, false);
 
 	if (dp->pl)
 		phylink_start(dp->pl);
@@ -109,7 +113,7 @@ void dsa_port_disable_rt(struct dsa_port *dp)
 		phylink_stop(dp->pl);
 
 	if (!dp->bridge_dev)
-		dsa_port_set_state_now(dp, BR_STATE_DISABLED);
+		dsa_port_set_state_now(dp, BR_STATE_DISABLED, false);
 
 	if (ds->ops->port_disable)
 		ds->ops->port_disable(ds, port);
@@ -178,7 +182,7 @@ static int dsa_port_switchdev_sync_attrs(struct dsa_port *dp,
 	if (err)
 		return err;
 
-	err = dsa_port_set_state(dp, br_port_get_stp_state(brport_dev));
+	err = dsa_port_set_state(dp, br_port_get_stp_state(brport_dev), false);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -211,7 +215,7 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
 	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
 	 */
-	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
+	dsa_port_set_state_now(dp, BR_STATE_FORWARDING, true);
 
 	/* VLAN filtering is handled by dsa_switch_bridge_leave */
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 022174635bc1..acf73db5cafc 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -286,7 +286,7 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
 			return -EOPNOTSUPP;
 
-		ret = dsa_port_set_state(dp, attr->u.stp_state);
+		ret = dsa_port_set_state(dp, attr->u.stp_state, true);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
 		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
-- 
2.25.1

