Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94E63E3AD8
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 16:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhHHOgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 10:36:22 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:24033
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231841AbhHHOgQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 10:36:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6f1dI48O6bEP+zI8hzQ1wJ+oDYjfg/GCZltKOwErD71Hs9NXp/0R3T0Gk5GR5RRqZMRC7yM2HZmmlS5qEpYULhGsNgOs3kwgamsWqVsDI5AHX3lIDTC5Ivn7a02qmWzCZv4Tht2Me+L6kEEj/k09Ml8jQ91J3V23qMpZC7Nb4CYUsIPb4rZ8472ydnjSFyOArHfEsDsZbmsAi/we6pFSAoyStDdV2DxMbKZev9moNyaiewzdhXkz0t5rnIPmJUVyWLSu34qXbcM6Z1Pz4y7tkRugOLyAPFoS1PnxWBjSGM5NvvHxDbOo3cCVNHorSUYlC9wplWRF4nd++PWXdQuRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnOF/uCCgriJR/rH1D4T/uFiEU5ijtyHies5RzDu9c8=;
 b=LAGsD4lUtQ71C2q8CCqkpvziiuhVxNsUYdLijEmk1WF9UGk8BW4tIa6HeTLH5OosrLo0JVpt2iYtBAUxSLk+DAqPczYmcd5RrCjYs1gXd62BDXRe3apnZleVZYgWmwtrVgdBnW8oUXrLun+rLnWYT0F+hujc9OaMrzcBA1D+gZAtDbCCSj10SXHl4ftCYgfvY5ZRB6SxT0PCFCGayaDkIlAFPw9DZNGnWEubW/RlEO544N+UsQXyTtlHmWRkRV5Pm2wFMhQcAHqYGubBLjc3s1uO6eWNPB6vLy7DM5IaueVeOp4rq087cOXX0PBtQf1jOV5E8akWQCHn1wUdD35a3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnOF/uCCgriJR/rH1D4T/uFiEU5ijtyHies5RzDu9c8=;
 b=sqxCCZNpmtWHPmBE/NMoaMNERnXOE/BSh1rrqnPz9EiX+wKrjnq6h2YQW3CgXUHvBW+bht2LxAxmaQ2jGf69AwoGQ/0UskJLTgzuZn70RCouFDTfHQzd6WKtueXEOgh3sdrKdROUTv0H7ejCiSCOh7+8Zx7YXdG3Ql852/t4n2E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 14:35:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 14:35:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 4/5] net: dsa: sja1105: rely on DSA core tracking of port learning state
Date:   Sun,  8 Aug 2021 17:35:26 +0300
Message-Id: <20210808143527.4041242-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
References: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0003.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0601CA0003.eurprd06.prod.outlook.com (2603:10a6:800:1e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Sun, 8 Aug 2021 14:35:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 090849fe-701c-4329-847f-08d95a79d19f
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2301:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB230164E3AAEC76D0401523C4E0F59@VI1PR0401MB2301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBOveOH5knI39DIRPUhVgpIzWTml9IKkB4ssoBuO6Y38r5BL/eGCB/WrVgiaHTTrxd5SgNK4ItznUjT3DaOuKYyLby2JV9UUeM/j16Pl3tr3ZlMi/cNc2ROBsBUygbdS+gdA51PiIajpRXQUgc5B5lQ/G9Fd+dIr4NdkWLPbscYIIm2xNNIP+ZN/LqTxii0st1jgJS6LQoScYfDuHtG6UhHNElrYCcSevuWgNTgdevtSE/3b0OXbKFEsVrydfGXzSgCoop0Z/N4v80UGRJHeUsXxkaWlbnuEZAQzrOy+zcDvWNVo+DP23e+i1Ji1YcIgmQt4OASduuDMyu2iI+UpI6VuryppJKBk+haQPraFo41w+nW83e4/fGG7Gqp40pP/fzC7rG/3XUqP4doOgiF9vpH1hm4ARRWWgdpjP4iVqa6Or4HRWxUirVHtZHGd/RtJ6jXFiJZ+fwVIMeeBrp7zOpp8qcYQR0bmswQkqENLFRQ7Vlls1vOsSz0mhNkFOOzxmBRFQwvyUTLHcMsz1rUcjx0zkLsqji6qkj50JAFEDjOdEMV85SnL7hZjjAz5pNKQsI+aipWw60SOIWphQSD2+6M67u7ksauhnEI1EkyQAhgzflrQLdSnpzlL+j/7iZA9JVfTHWyZWYaFkQOT0sXuQVUjKyC0/a8Ka5pm6VM48uGQ41R/c5GV2G7Qnl/u/41m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(8676002)(6486002)(6512007)(956004)(2616005)(44832011)(4326008)(6506007)(186003)(2906002)(1076003)(38350700002)(38100700002)(26005)(52116002)(66556008)(66946007)(66476007)(8936002)(83380400001)(6666004)(110136005)(54906003)(5660300002)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oQsb/J6antLSpiqTAkqIjO2J4LFrrudMaFHxpkQJ2ytrlihUQgfgfFvZUwDF?=
 =?us-ascii?Q?J9JwkXTuQTjxDgnVoD5R+OlFeZG7M79lPSNXdLshbq2nSE4wv/KKJl/+i4er?=
 =?us-ascii?Q?9I9Qi65bStd2s0eL+TDOx1dkpHdNrBTNDs/8xDwELxzbSh7berhOlgbppF+v?=
 =?us-ascii?Q?QxxQ+rG9udt9/uEWDnY8vsd7ug7fYNE8fUgn9kIWc+Vznu7D9q3fC69BDuch?=
 =?us-ascii?Q?HLddLyeeO7kBYC5cXMV1h05VDY7eqImLk8k29i0vleLImzK9TgxoFfhgzr+l?=
 =?us-ascii?Q?ksgmgUnTEW1SD4hEBm6K58OcEqhoN4gPQk9FDMN29VVXZy1gh9RXnnmavVge?=
 =?us-ascii?Q?YVJVI3yj3iQ/ibElz09HEFvLVpTH9i+5lLe5UWSMGfI91eU70q5E/aS1AXOG?=
 =?us-ascii?Q?CrQB6fKG20jNFRghlPWKw4GLoF7yGkxjeAZiuKsWOQJz3Bum8ry6dHLAa2gx?=
 =?us-ascii?Q?YqR3hfmcZQtbz8V0KlLlVCiu74yWlUSR5ZBg0bUIkZWmWgDpXnBXcVfOqLvw?=
 =?us-ascii?Q?ZFG4E88Lt7N4gqsvIsnVWhREh9Aii8f0h0phUxiKCF743TgygKjSWvcHjaJZ?=
 =?us-ascii?Q?aylhoPzS5sQ2MV9/q/wGlktdxdffGNVHvfxlus0SxhizzhwRWTLjTd1ixcT9?=
 =?us-ascii?Q?AG8QhNr4DhUlw1t0G7b/juNXzaCRbgK2zz4C1euJh+5qPNENWVD2Fh2xYtbP?=
 =?us-ascii?Q?YY6b7hhUPestVsr49f29VmNK8hLTg/pIBNrvULdqMYz0ozyKO8wXtJHlkrs3?=
 =?us-ascii?Q?M64z/IldAoZ/Kh2jmAUaUIbfGx22n6HFAgwMHHLMkWeMP5RA+GENlI77dKSG?=
 =?us-ascii?Q?fXdXHns/OepiNeShiXnU/dBCKhyuqEeurb2mUUQjL4qkZ7/mb2p02w/tFLqq?=
 =?us-ascii?Q?5V1vvR8CNe4FKVKU76FtI2EpD0JXZ/9zrMn1eXdG7y6Lfy+3ca1YcqR3Rlr/?=
 =?us-ascii?Q?4n55tDSXUaYlGmaahQYIR3eowJ+5UNA4hhK3RlEdMgoOIPbhb+HAfO0IaVwI?=
 =?us-ascii?Q?eKFAmpa2RFgHLVCfIjCTwRe4GeR3aBswcXG5nAhECl6aA1is6u0EZCr0FtpL?=
 =?us-ascii?Q?Av8rTpbsGKmJre5HgHg/RV7L4K1L0T1gMHEBUMeSCps8Mt9C6Nb+mH0m0TRX?=
 =?us-ascii?Q?mZxChnljRhnOETr8op7KWfbPSnoEUQ6rrgaWLhBYBTIygm2t3j5U2O35a26E?=
 =?us-ascii?Q?SsASpfbMTcU3LnXenJMdoatjXHaKI5pbM84Y5UdCfTPGoK2ZsMoNCjTLNRKQ?=
 =?us-ascii?Q?KeIpVoSNgkdlhyN1vTJnKt1dQftD6S4AuYcCJen+Slg9jwQB8gtFCiYlzDNk?=
 =?us-ascii?Q?bIcJb4xVwWxUbm3O3H6Se6fi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 090849fe-701c-4329-847f-08d95a79d19f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 14:35:50.5300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qf89jLfj6wf+3MTeSwDd5DCoauuvf843cPDiqGGFqXOOs8KExRY0PXWkW1XPJxMFPAggPTGvCmme6H+HxBxwYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that DSA keeps track of the port learning state, it becomes
superfluous to keep an additional variable with this information in the
sja1105 driver. Remove it.

The DSA core's learning state is present in struct dsa_port *dp.
To avoid the antipattern where we iterate through a DSA switch's
ports and then call dsa_to_port to obtain the "dp" reference (which is
bad because dsa_to_port iterates through the DSA switch tree once
again), just iterate through the dst->ports and operate on those
directly.

The sja1105 had an extra use of priv->learn_ena on non-user ports. DSA
does not touch the learning state of those ports - drivers are free to
do what they wish on them. Mark that information with a comment in
struct dsa_port and let sja1105 set dp->learning for cascade ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 32 +++++++++++---------------
 include/net/dsa.h                      |  1 +
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 9cd7dbdd7db9..2e899c9f036d 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -233,7 +233,6 @@ struct sja1105_private {
 	phy_interface_t phy_mode[SJA1105_MAX_NUM_PORTS];
 	bool fixed_link[SJA1105_MAX_NUM_PORTS];
 	bool vlan_aware;
-	unsigned long learn_ena;
 	unsigned long ucast_egress_floods;
 	unsigned long bcast_egress_floods;
 	const struct sja1105_info *info;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 241fd25b0b86..87e279be89c9 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -176,7 +176,7 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 	struct sja1105_mac_config_entry *mac;
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-	int i;
+	struct dsa_port *dp;
 
 	table = &priv->static_config.tables[BLK_IDX_MAC_CONFIG];
 
@@ -195,8 +195,11 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 
 	mac = table->entries;
 
-	for (i = 0; i < ds->num_ports; i++) {
-		mac[i] = default_mac;
+	list_for_each_entry(dp, &ds->dst->ports, list) {
+		if (dp->ds != ds)
+			continue;
+
+		mac[dp->index] = default_mac;
 
 		/* Let sja1105_bridge_stp_state_set() keep address learning
 		 * enabled for the DSA ports. CPU ports use software-assisted
@@ -205,8 +208,8 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 		 * CPU ports in a cross-chip topology if multiple CPU ports
 		 * exist.
 		 */
-		if (dsa_is_dsa_port(ds, i))
-			priv->learn_ena |= BIT(i);
+		if (dsa_port_is_dsa(dp))
+			dp->learning = true;
 	}
 
 	return 0;
@@ -1899,6 +1902,7 @@ static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 					 u8 state)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_mac_config_entry *mac;
 
@@ -1924,12 +1928,12 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 	case BR_STATE_LEARNING:
 		mac[port].ingress   = true;
 		mac[port].egress    = false;
-		mac[port].dyn_learn = !!(priv->learn_ena & BIT(port));
+		mac[port].dyn_learn = dp->learning;
 		break;
 	case BR_STATE_FORWARDING:
 		mac[port].ingress   = true;
 		mac[port].egress    = true;
-		mac[port].dyn_learn = !!(priv->learn_ena & BIT(port));
+		mac[port].dyn_learn = dp->learning;
 		break;
 	default:
 		dev_err(ds->dev, "invalid STP state: %d\n", state);
@@ -2891,23 +2895,13 @@ static int sja1105_port_set_learning(struct sja1105_private *priv, int port,
 				     bool enabled)
 {
 	struct sja1105_mac_config_entry *mac;
-	int rc;
 
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
 	mac[port].dyn_learn = enabled;
 
-	rc = sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
-					  &mac[port], true);
-	if (rc)
-		return rc;
-
-	if (enabled)
-		priv->learn_ena |= BIT(port);
-	else
-		priv->learn_ena &= ~BIT(port);
-
-	return 0;
+	return sja1105_dynamic_config_write(priv, BLK_IDX_MAC_CONFIG, port,
+					    &mac[port], true);
 }
 
 static int sja1105_port_ucast_bcast_flood(struct sja1105_private *priv, int to,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 995e9d3f9cfc..0c2cba45fa79 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -254,6 +254,7 @@ struct dsa_port {
 	struct device_node	*dn;
 	unsigned int		ageing_time;
 	bool			vlan_filtering;
+	/* Managed by DSA on user ports and by drivers on CPU and DSA ports */
 	bool			learning;
 	u8			stp_state;
 	struct net_device	*bridge_dev;
-- 
2.25.1

