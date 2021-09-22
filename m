Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D21414FFB
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbhIVSil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:38:41 -0400
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:61921
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229459AbhIVSij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:38:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8pqJ/axsyPSxqbDdTIswLOM4PHh6YIwX1YoeIliS1Hr1I08OY4+I9YUHn8IaeN06ZAsbD8r7Dsndhcx+jpl5xBCYLFG4s3eAl8HJbZOiZIDVxpkSGID6auGHomAo2ERstGbOd18geXsaq9kqReJOyiuVCMqaS8LkHNXujOogGYN7tdDgR43KVr77VNuxMDf+WwuwiExGthLMY7NxLTxUuiBh6rql66ly9PzXuWI6LlHL82bVh9MUlw6gV6smm3ST4KoHRPT8l5f2ICe/y+LEljlV2pRPoSFCKqtp4hon602aFBrH11fB/X3LdeTjWrrLZ6uTxp+fkVZLn1DY1mJlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=M3i4kDH7jMgx0Etr4g/OZTu4tI061d014PORGJKwqgM=;
 b=hpfj2sHyEOYtJhc7ETP1nPrSYneiV2ZJNKPXiQIYBmAlQhX2NOjhp48AuSf19MtjZNN1vxXpNjbtfpFR3JIK3f1MqH6xLBGcLwV9luJTWX1aWZTJ7/tzOIAfm6lLrnUSHheycYAPy9i4pjoozxf5MY01z1KPBxn3q8JnOcLvzy3pU8TrGZTiQ42f7UFq/vmWNAIFSBY/5Tw/y7+ZL80X1ciDHilCqscssXxll56YiXyggRwy8MWW2wS6/Yh4H4mRlpH9CTHmWjaY2+uPrv42v9IDKs6Z3uuvTMQ4DP6tl0SKOFBMl14cQ6m67U4Z8CCHXqZLC/cNdSyufyS5Fa/Qig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3i4kDH7jMgx0Etr4g/OZTu4tI061d014PORGJKwqgM=;
 b=e2PRQjQm8lIgjVQNMGTzKV9GvyecnPF5dZQCt7iiCu+zyoFT9f4dlyAzf+/0xgpSviVATRYSgpRwiSK/tgNwbkoxnarj5ViAl49ZBz+SXQcLkLcFSbrd7IyUHhsMmDYbJOlAT05Yae/I/dh7uT4LxJ5Lwt+G7mmMXlaBb3ZfdA4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 18:37:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 18:37:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 net-next] net: dsa: sja1105: stop using priv->vlan_aware
Date:   Wed, 22 Sep 2021 21:36:55 +0300
Message-Id: <20210922183655.2680551-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P251CA0028.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:b5::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by PR3P251CA0028.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:b5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 18:37:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4ebf002-b025-42bd-40cb-08d97df7fa96
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28617A10372D14EBF08CE18EE0A29@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uEx++2YXC2/4NeDFSxZl+XFiO/SDtR5Q5bqSV7HsEmoXDttsr7TAc4rFoBjPVB8L0L+C186AibE6/QBR7y1+am7fAOBmb1DdoygQ19UqC4aiZaKcZJxWewiE+NZMjBen5R3Az1K6Ea+wC3a0ZRf/mt1SEueVxt24aDd5xypZZybz7kdWdd4zfGvll7zy6DKzDULupR6CDETEjNrXMmIRMgz1owHtKvFETy3DMNYMzuoa6cTKlYMhzBNhMOcLEq3SU1fnveTBUFyqgL5vpzzFQUsd5w9c9qCPvzo2dwc8EOzSaM3Wivv/QDLERoc/r2wJq9YKV+JAwoI7vCmJmh8JKZj6916sGdB2WZBhdvWfYtRLIUrq3PmzNs59c3rJ6Qcp2wSrfuv9ufgODt86LR22rLS2CCOKo3ybWxha4YrdsEvZFs+B0KSzJ3c21zblzfFKUT2fMk7rt7fdP7CNOyi6r3XYrwdjSlT8xjN9F8a1qq+WcWHVp4ii1/87diryU7zVSDR8VDbItwVqD1i6Rm7mLK9VxlTZG0Qg595+xZ/yi5ThwDVGmiReAkwOj0Q0nzPmxK5FD/K9J0cpJvVn/1zkkvDTR59x6E4P8rmKVIQiCW8Wjjh6RyEtCVqJl1UDOwciZacAnX2IQQ2r2vXTrSUNjQRNFoPnpfRmwH6mW8uBsDgvVjt34/biWyeeGjO6lu4WopWT9f3j5sRwWQrkyDfpfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(5660300002)(956004)(26005)(4326008)(2616005)(38100700002)(6506007)(36756003)(44832011)(6666004)(66476007)(6512007)(316002)(6486002)(8936002)(66946007)(8676002)(6916009)(52116002)(83380400001)(38350700002)(186003)(66556008)(508600001)(86362001)(2906002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6T5M5KnHjKlHV227Y+sX92ILPMzNshY6kH6tgxEuKSZqgnS1IPwuR3UvhVzo?=
 =?us-ascii?Q?yrjyLW07Wa1fvr6j31DKBkdiA+GFv1boKdAEH+YwB+SBEooBEVtMKR0ehxhc?=
 =?us-ascii?Q?lVw5Ya//G2rD3DCn+DVQMi9SldgiarXuue0dJGAeXrCcPHYXxbHMkK/0EIWK?=
 =?us-ascii?Q?93Zoy8AZEaTAYkKECaoLPyFzHnQOrINN67sDPd1/FaxPvXmFMW0SfH8OlTps?=
 =?us-ascii?Q?uPQjzMy4WTn38yFOxABip8Q4jucto4Qlr0vkVvS9iFSic0BgkkGUawPmBkJb?=
 =?us-ascii?Q?i7qEZgYNldIYm+eD/DsHVagWtcU+hLYPI/f3IQHReQ1curLKX/gma+LpNw5V?=
 =?us-ascii?Q?tht6JFif36zI085XyjGmGLwm1yb+HBjUHb8fSV76egza+UmYfp04z2qQlDSB?=
 =?us-ascii?Q?hwZLgQPniY0l43Uxz8cHp++Etl1Mroxiddul+FgQIdC27BAtClKSeFirmkNF?=
 =?us-ascii?Q?/hgmNXYK58w9syJhuyiFSJ2q3mdyfHd5NotwYvLpWUNcj9vx1ksRpfkSDaW8?=
 =?us-ascii?Q?zgcq8y17FsLulWCvI8bW2+lcM8gtgo4Q4lhmp3Uc2mlFdT5oepvriZzDTca6?=
 =?us-ascii?Q?Nl5snkoTpLX9NnZwKFSmX7ZJ9W/eax+jqbYhWsOQHDojSpXB8KIPWy18O1NK?=
 =?us-ascii?Q?cOybnB7vEDV9pv0ztqViFLiOmJzw9oufQfSKnHajh01okIyRxfdxNS5QxRAS?=
 =?us-ascii?Q?181aLl16WQ+264dp1et6DSUHEVgalF1sL5sHb4JPb5UrlSWdvztbUKrYL9Ez?=
 =?us-ascii?Q?Ha8ExW+Tom3eYISrds/kL3jHrv8+CD1zLAx1U6YBDVqaTiVG5k/Xl5fHEgum?=
 =?us-ascii?Q?RglIjmkqB0dECk2whiE9Weh32eLsQXy/VMSTrnXWENxTCPDUi9BogmkbSoG8?=
 =?us-ascii?Q?xKbZvMv0mlQ3vdRjoiIUu15x4nfxLnf+NHE3+8HOG572Du2cBdMq3zOGxSSo?=
 =?us-ascii?Q?TtRsni181KS4cMYAv3BRL++qg489bM8HR1nu3n87InuIE3Vt0wNYfOgYv6LI?=
 =?us-ascii?Q?/VXgsFZ1K7ZGi7DTDBFdHWmjj0HQcxrwTWrKXmp9UZ5xio3s2zfj/ER/UXRt?=
 =?us-ascii?Q?ITqkn1kDv0a/ytiz/UGPYbzF21D8dVz8zQAjsY9uG/HI+BgeCabvuNUJ40ih?=
 =?us-ascii?Q?JsLIS0/E7U86ezYjPO7acNwTx6HtYrCdP+J/Yf+5JBQHX8vsGf00swR1PTzO?=
 =?us-ascii?Q?UrD/X0qwW5IwqE/E0OD2yh2MbcX/tFrjEZsT4qGFBLOAnRspnPP+Y7e21AL6?=
 =?us-ascii?Q?Z3M2mxhtscBFQQ+2rt5Krmtkn0zTUgHugxLH2Otrg+6uoU+dXBdrI8tYgVUb?=
 =?us-ascii?Q?qcH8qJ7u2Q5AbsKxKwCFXAo/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ebf002-b025-42bd-40cb-08d97df7fa96
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 18:37:06.6219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zp+150aONO9tkrsM8wv5iKGAQEUWfCuzp7OqebAWIxBOZeNmPEdKFugyFDXwNGCLXH+T0eZIbGUZadUF62o59A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the sja1105 driver is finally sane enough again to stop having
a ternary VLAN awareness state, we can remove priv->vlan_aware and query
DSA for the ds->vlan_filtering value (for SJA1105, VLAN filtering is a
global property).

Also drop the paranoid checking that DSA calls ->port_vlan_filtering
multiple times without the VLAN awareness state changing. It doesn't,
the same check is present inside dsa_port_vlan_filtering too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: send the patch that was originally intended, which calls
        dsa_port_is_vlan_filtering by its correct prototype and
        therefore compiles properly.

 drivers/net/dsa/sja1105/sja1105.h      |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 10 +++-------
 drivers/net/dsa/sja1105/sja1105_vl.c   | 12 ++++++++----
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 5e5d24e7c02b..b83a5114348c 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -226,7 +226,6 @@ struct sja1105_private {
 	bool rgmii_tx_delay[SJA1105_MAX_NUM_PORTS];
 	phy_interface_t phy_mode[SJA1105_MAX_NUM_PORTS];
 	bool fixed_link[SJA1105_MAX_NUM_PORTS];
-	bool vlan_aware;
 	unsigned long ucast_egress_floods;
 	unsigned long bcast_egress_floods;
 	const struct sja1105_info *info;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 181d814bd4e7..f191359304a0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1766,6 +1766,7 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 			    dsa_fdb_dump_cb_t *cb, void *data)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct sja1105_private *priv = ds->priv;
 	struct device *dev = ds->dev;
 	int i;
@@ -1802,7 +1803,7 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
 		/* We need to hide the dsa_8021q VLANs from the user. */
-		if (!priv->vlan_aware)
+		if (!dsa_port_is_vlan_filtering(dp))
 			l2_lookup.vlanid = 0;
 		rc = cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
 		if (rc)
@@ -2295,11 +2296,6 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 		tpid2 = ETH_P_SJA1105;
 	}
 
-	if (priv->vlan_aware == enabled)
-		return 0;
-
-	priv->vlan_aware = enabled;
-
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
 	/* EtherType used to identify inner tagged (C-tag) VLAN traffic */
@@ -2332,7 +2328,7 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	 */
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
 	l2_lookup_params = table->entries;
-	l2_lookup_params->shared_learn = !priv->vlan_aware;
+	l2_lookup_params->shared_learn = !enabled;
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_is_unused_port(ds, port))
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index ec7b65daec20..061a1e0235ad 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -494,13 +494,15 @@ int sja1105_vl_redirect(struct sja1105_private *priv, int port,
 			bool append)
 {
 	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
+	struct dsa_port *dp = dsa_to_port(priv->ds, port);
+	bool vlan_aware = dsa_port_is_vlan_filtering(dp);
 	int rc;
 
-	if (!priv->vlan_aware && key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+	if (!vlan_aware && key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only redirect based on DMAC");
 		return -EOPNOTSUPP;
-	} else if (priv->vlan_aware && key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+	} else if (vlan_aware && key->type != SJA1105_KEY_VLAN_AWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only redirect based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
@@ -568,6 +570,8 @@ int sja1105_vl_gate(struct sja1105_private *priv, int port,
 		    u32 num_entries, struct action_gate_entry *entries)
 {
 	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
+	struct dsa_port *dp = dsa_to_port(priv->ds, port);
+	bool vlan_aware = dsa_port_is_vlan_filtering(dp);
 	int ipv = -1;
 	int i, rc;
 	s32 rem;
@@ -592,11 +596,11 @@ int sja1105_vl_gate(struct sja1105_private *priv, int port,
 		return -ERANGE;
 	}
 
-	if (!priv->vlan_aware && key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+	if (!vlan_aware && key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only gate based on DMAC");
 		return -EOPNOTSUPP;
-	} else if (priv->vlan_aware && key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+	} else if (vlan_aware && key->type != SJA1105_KEY_VLAN_AWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can only gate based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
-- 
2.25.1

