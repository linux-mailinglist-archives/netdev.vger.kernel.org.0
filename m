Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AEE4322BA
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 17:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbhJRPYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 11:24:17 -0400
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:12514
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232248AbhJRPYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 11:24:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jr4nvdCRmkf9qYf3hz0iDXlegEIUjtMPaH6vLkkNB1+LDJconQQY/OixYO2vLPwcMyjcg12/GqtNXfhEr7XziIU233HSZKDSGUiQLKlkCylALSrdNHDrVMgX913DR+lGeWRwANW6e++LltenEXmmT7vm1S6eLJYYzlZBc/p9F0O5sJQ5x7/cmw3T3co3ysA7MJWWf7M/75TQRTIiSXvkvQbU6o18Az6ZrQD4uO/r/mUdB8XRQZzcTt3KoXnoUfqeFTceIJmjE43n6E/jD0aBUh9h58p/wCFQBav76/Tzf4CPMRt8ihOmVa+5WYxPjoaIWIGHC2dzyBPRbqfVri3bRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8T+yq7Un08h0MMx1gbh5oZh96ocl307ar9HJWjMXDo=;
 b=hPQa1m/KVJkgaRoPNMVl5eSpmA0TSVgQ1Xad3HiIC2SEMqUuIRN1hCeEFjP48y1CfwJllUCJ5zUPiGpaKWXa5V0glHtuJHU7NdXwF8r2c2XOxUBB0UwYRJy3KIQyabK4LmSXo/VR0ldq2Jdfj7VzsBfGKNmRwRllXlRnI+bbENUIoFeS/ypqPZg6UPBKHVH0vZqwG5yclEOooq9bFTO9kmtwv6uOfcBeblSgEcJmU+/PqRE7sJVA7eGUY9edibEh2ii1k9i29ALRHNwmxxUIChl76dL4LdPuIJkF87IQA6DpERhjU8pGwL2q3+WEQGGX2jPSuTDOmEviv+UqoXIP5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8T+yq7Un08h0MMx1gbh5oZh96ocl307ar9HJWjMXDo=;
 b=dbTd8I2WL3Z7CVcBijgy+WlJr4A23lv6WgLtINwPVozlcpwLh5d0pVnsxCXHbRveZW4DbFDv9I4d/rdBKb9w0Iaus+dZ7NOhRb1weaqvrXmUurCGwBnwAgIbRziP7XKqJLcNa0WUt///G6yIAjqthBslxMkmXa1D2b55q8NiGLY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2799.eurprd04.prod.outlook.com (2603:10a6:800:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 15:22:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 15:22:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 7/7] net: dsa: tag_8021q: make dsa_8021q_{rx,tx}_vid take dp as argument
Date:   Mon, 18 Oct 2021 18:21:36 +0300
Message-Id: <20211018152136.2595220-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
References: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 15:21:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 064693be-be35-4945-fd0a-08d9924b07b1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2799:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB27997517B19F6A86467C4896E0BC9@VI1PR0402MB2799.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mPgUf60k8RNuUmTaB0OEInzK7JekANq2x1qpFL8B2CorTjghMbU/iUbPmnu8MigxZjHtczPaLwcuTidESkPwzJqL5nOtIyZoq5Le6y8fBsh/zV7BRQIRrq44znkNOhb+vruTuHmiSQPmrDdZQcVp3CLIYrUIMzaB/Q3iloDzG+Mbpw058vt9R/WjpT6yS+27DWcE/WdhhIu25R9tNYgRQnYIQpRQxxrrUyQ80jxZJKT/edUdsqC20sqrmb5cQ2B0l+RbvezsAhEnue3RZ/6/79cbedS2CryvhWCtQ5OL/e3pS7R4/ARYAL8iIhuij5vSaNSIYYQGrGHIXm2ZApSlSTXW4tfNWe0mNJqC/KrqzIL5Es+ghIrrzDD6RzLkgeMGJaAuVULF2T0g81YKHhDeVd/KNKz5oc/85swk+Sd8L9jnJvQCwkxOn+9/2WX79p8d2jhoivqVHM/FxQEVV1fHH51qrLppvoPSb5j97VTP5jG7m/duHMrt4TJ/1QaURGDRzxP6o/xB/pOuSQJd3Bf1CwqQpL4vxgLC220IqJoeXECODICuSGXwPEaxNABHoJUzO6aE6apkzPAtWTADP1SMzhQCnzdKyPgWsIE9SaknZ9t5CAOaDjl+sjHAgjavgQOKoxgUl4SSYXFNFP1PzZkBuIXeYNa+Y77de3jKMo3+euzoR0gjGskyAJSJQ7FwxTwEdamDevlCtu0xCkA/bL6UjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6512007)(186003)(6486002)(54906003)(8936002)(26005)(83380400001)(38350700002)(38100700002)(1076003)(2616005)(8676002)(2906002)(110136005)(86362001)(956004)(4326008)(6506007)(508600001)(66476007)(66556008)(66946007)(36756003)(5660300002)(316002)(44832011)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Amg2EnZwkaZ1r2vQidjpajeAJ6739VrYL+cZVGH2WaCpYa6sRbYkZKG3LToq?=
 =?us-ascii?Q?Ib/Rk2jiOleKRzMqjs6pH21PJion1HCW0IqGuM5ZFos2TztpHpj7/FiSNYvV?=
 =?us-ascii?Q?VRRymbsCBG/sG+VxOuuMuWp5sDNS/1e83RGIY0L8ejcmg3Xtc7H4HTpsXvFL?=
 =?us-ascii?Q?dyoLCkIn5n0krkMDGGL548bC23o12QE9WJx6WOeGZC0JGZ1cD9VCEiVWcOKx?=
 =?us-ascii?Q?SVJfw2dbJFFfB3sjV76BDgmxzRRJtLtiGonjmJLp2QFAP6dpvEmgf4CbtSqU?=
 =?us-ascii?Q?siZ/sWVMoOtmxDfxuNNxZQPNLIg0GKaXvyXBd2H87ucvQ4u3/LVe7LDdQqwY?=
 =?us-ascii?Q?5ZhNQ9eNo16Ta+d9Mgx1Qvc3NR34VKy+vrJ3Zhynw8rmkwa2qAzUiOyThJYD?=
 =?us-ascii?Q?iaPthahmYwEf1mafUZb/bs2FaXEOD0PLZ99kCtmKSVmWdvRh3P0tYDN/BugP?=
 =?us-ascii?Q?1nzzuDk5TUuxa3vZJJ43R5Xu05nQwIMRSyNaJJef2eP/jIWcFJTvJI91A/Uo?=
 =?us-ascii?Q?s1z1p9XskqaypwozxZRuECTkBl70DoQUgTgtpEygEy7CFQ5HaeI542VrVnDf?=
 =?us-ascii?Q?Ns1fWPTaWTlQLz67fMb+X4CbJyPzgnrDALuSroBxL0e7znWii85BNuvOViit?=
 =?us-ascii?Q?7oeOL6L2Xae4xpYACRny1yNxa+0pOgJZfiBdjFyvPHMVMxTdJVnESmtfXp1r?=
 =?us-ascii?Q?OromZD41CoQGKW5opueQSsZRHQhopYnSOVD4v9dm6I1fy6pEAnUW4q1HTzil?=
 =?us-ascii?Q?GuediJzEtIE7N12B3UTiTiFDCfCKyTYpZZpgj4oPV7/xqnJ1XKxVV9yacHO+?=
 =?us-ascii?Q?hjgD0/qk4aZNujuj+g0vKnxKFNBdkSjTx2pENeiTWRdA4QP74yZ4jewfeesy?=
 =?us-ascii?Q?5dTib4XRkNVi0K3Aqca3mTnuTPozLx9cU6C0+QKIni4ssIpWlIEIyHNaq5fA?=
 =?us-ascii?Q?fjvqbDby1kYwwzQujkis6juRSvvfLpIP2XTr7VtUpos95NFru9AblGdi2Jfu?=
 =?us-ascii?Q?HHhlSvAu/kOdP+YNkWJ1JI+chbgsbqgosr/Xb486odTRPrPN2PpU6FDt/7zq?=
 =?us-ascii?Q?bx2bKFMKdRUXsfuDWSV81jZRc3HtM3b2LXmCHz11IQKhOTtwaiq3wJ0lMY3w?=
 =?us-ascii?Q?VsZlKilg8GHT6olZMFRUoBDueAa5rsUP/yC32MAwTG175PMHBm3j4UAYRvSu?=
 =?us-ascii?Q?tr1QN1wGJLeBiP0kZ9zlTHjWMRQt0cmc2IQ+6UGIZ6u6tHdSZuxdTGnBET1h?=
 =?us-ascii?Q?CevU8pxPczHHbgcf9CElaj5yxwXOkEAJssXKkR8BaoQosVoPoL6F9O0t3NxV?=
 =?us-ascii?Q?weYEX8mjBYu2dH7Jyb23XI5f?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 064693be-be35-4945-fd0a-08d9924b07b1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 15:22:00.0332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O10U2IgMbNKpGZyCitoM1Q5x94k2f1IIKGwLfTZajbRMX5nzJpiKGsGwwsGua8kz8mzOQgdwtorGqDKhChuJIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2799
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a single argument to dsa_8021q_rx_vid and dsa_8021q_tx_vid that
contains the necessary information from the two arguments that are
currently provided: the switch and the port number.

Also rename those functions so that they have a dsa_port_* prefix, since
they operate on a struct dsa_port *.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c |  3 ++-
 include/linux/dsa/8021q.h            |  5 +++--
 net/dsa/tag_8021q.c                  | 32 ++++++++++++++--------------
 net/dsa/tag_ocelot_8021q.c           |  2 +-
 net/dsa/tag_sja1105.c                |  4 ++--
 5 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index d55572994e1f..f5dca6a9b0f9 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -394,7 +394,8 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 				vl_lookup[k].vlanid = rule->key.vl.vid;
 				vl_lookup[k].vlanprior = rule->key.vl.pcp;
 			} else {
-				u16 vid = dsa_8021q_rx_vid(priv->ds, port);
+				struct dsa_port *dp = dsa_to_port(priv->ds, port);
+				u16 vid = dsa_tag_8021q_rx_vid(dp);
 
 				vl_lookup[k].vlanid = vid;
 				vl_lookup[k].vlanprior = 0;
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index c7fa4a3498fe..254b165f2b44 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 
 struct dsa_switch;
+struct dsa_port;
 struct sk_buff;
 struct net_device;
 
@@ -45,9 +46,9 @@ void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
 
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num);
 
-u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
+u16 dsa_tag_8021q_tx_vid(const struct dsa_port *dp);
 
-u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
+u16 dsa_tag_8021q_rx_vid(const struct dsa_port *dp);
 
 int dsa_8021q_rx_switch_id(u16 vid);
 
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8f4e0af2f74f..72cac2c0af7b 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -77,22 +77,22 @@ EXPORT_SYMBOL_GPL(dsa_8021q_bridge_tx_fwd_offload_vid);
 /* Returns the VID to be inserted into the frame from xmit for switch steering
  * instructions on egress. Encodes switch ID and port ID.
  */
-u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port)
+u16 dsa_tag_8021q_tx_vid(const struct dsa_port *dp)
 {
-	return DSA_8021Q_DIR_TX | DSA_8021Q_SWITCH_ID(ds->index) |
-	       DSA_8021Q_PORT(port);
+	return DSA_8021Q_DIR_TX | DSA_8021Q_SWITCH_ID(dp->ds->index) |
+	       DSA_8021Q_PORT(dp->index);
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_tx_vid);
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_tx_vid);
 
 /* Returns the VID that will be installed as pvid for this switch port, sent as
  * tagged egress towards the CPU port and decoded by the rcv function.
  */
-u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
+u16 dsa_tag_8021q_rx_vid(const struct dsa_port *dp)
 {
-	return DSA_8021Q_DIR_RX | DSA_8021Q_SWITCH_ID(ds->index) |
-	       DSA_8021Q_PORT(port);
+	return DSA_8021Q_DIR_RX | DSA_8021Q_SWITCH_ID(dp->ds->index) |
+	       DSA_8021Q_PORT(dp->index);
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid);
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_rx_vid);
 
 /* Returns the decoded switch ID from the RX VID. */
 int dsa_8021q_rx_switch_id(u16 vid)
@@ -354,10 +354,10 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 
 	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
 	targeted_dp = dsa_to_port(targeted_ds, info->port);
-	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
+	targeted_rx_vid = dsa_tag_8021q_rx_vid(targeted_dp);
 
 	dsa_switch_for_each_port(dp, ds) {
-		u16 rx_vid = dsa_8021q_rx_vid(ds, dp->index);
+		u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
 
 		if (!dsa_port_tag_8021q_bridge_match(dp, info))
 			continue;
@@ -389,10 +389,10 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 
 	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
 	targeted_dp = dsa_to_port(targeted_ds, info->port);
-	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
+	targeted_rx_vid = dsa_tag_8021q_rx_vid(targeted_dp);
 
 	dsa_switch_for_each_port(dp, ds) {
-		u16 rx_vid = dsa_8021q_rx_vid(ds, dp->index);
+		u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
 
 		if (!dsa_port_tag_8021q_bridge_match(dp, info))
 			continue;
@@ -433,8 +433,8 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_port *dp = dsa_to_port(ds, port);
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
-	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
+	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
 	struct net_device *master;
 	int err;
 
@@ -478,8 +478,8 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_port *dp = dsa_to_port(ds, port);
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
-	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
+	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
 	struct net_device *master;
 
 	/* The CPU port is implicitly configured by
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 3412051981d7..a1919ea5e828 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -39,9 +39,9 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
 	struct ethhdr *hdr = eth_hdr(skb);
 
 	if (ocelot_ptp_rew_op(skb) || is_link_local_ether_addr(hdr->h_dest))
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 8b2d458f72b3..262c8833a910 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -235,9 +235,9 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
 
 	if (skb->offload_fwd_mark)
 		return sja1105_imprecise_xmit(skb, netdev);
@@ -263,9 +263,9 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 {
 	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
 	__be32 *tx_trailer;
 	__be16 *tx_header;
 	int trailer_pos;
-- 
2.25.1

