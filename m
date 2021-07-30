Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585AF3DBD94
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhG3RSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:18:54 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:45569
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229761AbhG3RSv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:18:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDSuvDded4nJt5vfY0CKXEtjfzRDGslIMbuf+vG+Pm7AkLyNpO2RbdZt3aBQRfVf4H6Io2wYW1v61gYeKCEuqlzvP0ufwWOJHMWFgTAO/kDEsAnxfoKOujn20PyTxh+MF7OVs8phvPzBUZDgrpc/JzQ5+QCXON3N+f/rQgigAzCE0uvgjf5y8fyyyzwPMOzqunvBZbl6TDUclq4rQaUjz+iQ0veg3rKOkxO18/Hh+P+gFW+EglU3scZoQ2FwU16RmQhK5kDLFSrCQOSGD9RvmiXY+dR5wOU7foHOTl3kvJp21sZyX5xH5QXopo3Eit8gKQzOU25ZA0jcouo4eSF7Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlWVyvOVctK6KeUfwFS+qG9gh4EftCTAR9+egeAgAxw=;
 b=V1l+X1dwK7rIWdqcSbuDiiu6xX5dJqdnp1IoHK6qx6RhbQtq+tmtKg2CCCtI8mSp5oNcfSluds6oZB0X/rbFzRu9PhheBwNsYYltw+ujUak14xq6MlZaOScwWY7eXE8Q2Kbwyjy7WpIEBtm1XDQdbkOQyJpZX9fdxDDS0iFIxx96zP6ufUw3ectrrh40OddXLWR7wRQ5/Y/EJzb3z19A0u5sh238nRfiD/oIsB/CvyxP9l9UIi1OYA/GpwFqgaCzAXl4mCsaFkILQ1dTnsakfnHfSIwqUifAW+NGEC5WKsVMvx/FxXwrCkS1fBQbczpRhFimb1dLrAomZsB0+5pvrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlWVyvOVctK6KeUfwFS+qG9gh4EftCTAR9+egeAgAxw=;
 b=BA/acnwb5OxGX9kwaHf3ZK+ZSOFoDZ28gkVEQYGUwu4NrBqkzPO7RqFeKIr0Js8uE35Guh+gZEZfae6W3ngdrTH6hlOAfHm+788mLWjPl8DKT7i+6W26ZOt8ZLRubRX4B/GGxGbqnG9HjDxNLA+9KYg8S8b13Ax6qP27dC7ZFsc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Fri, 30 Jul
 2021 17:18:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 17:18:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net 3/6] net: dsa: sja1105: invalidate dynamic FDB entries learned concurrently with statically added ones
Date:   Fri, 30 Jul 2021 20:18:12 +0300
Message-Id: <20210730171815.1773287-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
References: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0008.eurprd02.prod.outlook.com
 (2603:10a6:200:89::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0202CA0008.eurprd02.prod.outlook.com (2603:10a6:200:89::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 30 Jul 2021 17:18:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff093ee9-2d85-4645-0bfd-08d9537e14cc
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3967701ACCA8DC26C6D6AFAFE0EC9@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIUuTNtWj7TRYCR7+434te1HeER30VbAXQRDI6nowI08uz6UhJoQoZvknU/n8upBS7YP3kyYwJGDgk3Mgvj/dU4QRp/d1p2gnEPTt49IxWO7Ek6FHUY2Rap3xtpxbc6ZasBTQEqZoQBJfBXyWaypxbb3nUWGIvxEKxKAOMSgMce0F1sjLSlBBsVq8XW8pg8778kgCc5qmYIpIwK2u+k8zA6MDFMPLeZuvJrOKwRMJFBGY3ZrbNN5KmtCOaBX+ynyZ5B1MnsMFQUNZw0+kwkWkkjhDc1qGN/I5gaZFs2rn7G0/c+isNckFhJesNRgMQlTX4IY9DSdFEAk1lg62wuVp5arBGW1fgOFgvfHu4wxzcbDL5qGnrAZGm+Z7y8uJCLkH2rdTlS1Ec+xT6KBrcVZQz5HTIoxi6uc74zNYc2XKcEWshEUpBlu5u0wUsbYivefB6p+RXBIKLvk58PQHxctyqJRpfSf0W8mWhJQqQecomz9KXIhYw9d7zUSs+HSKiD3mwCBDfnDDbZC2q8fbgU9RkN50AD8+o21fjhMNDEaomwEHOQw+ShX2EtM9hC9c7rkgIYR+ydH6fMtKMGdOye3YBKVVUKKsnjDrbbl4f8kAch78JGbpKwX1FQy+omBzq0QWgVg50FXyImcqmldQuLM0fV53IBjrZh+FXX6WuJ0HeqJpZ8Vj4yzXXqVCZEL40jRKo3RWUMXrQeG00ZAyopkjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39850400004)(366004)(2906002)(86362001)(6512007)(6506007)(478600001)(956004)(83380400001)(2616005)(316002)(38100700002)(36756003)(6666004)(38350700002)(6486002)(44832011)(52116002)(186003)(4326008)(26005)(66476007)(8936002)(66556008)(5660300002)(110136005)(1076003)(8676002)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4S3ByDeqBGQlN1JKfyHgFskfFwg/kn/gaL5THYTOVwWaRHyiq8RLRVyF0I8J?=
 =?us-ascii?Q?l33eFXk8N4/qlos2m4kky8ybZN3izlPgdUN5Ah3BTqaMxVReuMYusnS75Ojs?=
 =?us-ascii?Q?x8bKgxdGKt6m1+fg6ckJCBBIvK33uO5A9xJt+v4RYpYYJn0e5ur8SiFP8mRp?=
 =?us-ascii?Q?9ADYC90TpDXaIpAcfOkk/K1P/DU6LLREOS+xQltKjk4IeOKU/hRjlYxncCY1?=
 =?us-ascii?Q?RKfaT4C3/IEsA7eF3GcslTwsgP3QuGuUTKDHadT7m1pmHjUhs90VHfCq82iH?=
 =?us-ascii?Q?ibzpweQqxMZSoWi1PAve78oOOBuB/2zMb/raxj/d87PPNJcY+oMAzLamK5Y6?=
 =?us-ascii?Q?hlhAGYMlAbIYZ8cCGqH0y4fKHyWPH0UBC8zbOJ0rM2gINzJXuWkH5+2hrdbk?=
 =?us-ascii?Q?TNpF4hZKrPNemTrylOANd7yuKcEJ2KmKUhpUe1jKkhhHxlRhIAT8lkqjJ1VE?=
 =?us-ascii?Q?4ic0w/NgfcCwT2RyeJUFA64Sh8xWPUbdX/hE9tfkGw21XVqakol59NQMqJjQ?=
 =?us-ascii?Q?vgmiJD1t1Y+1LS6UspZF7IZaJH/2fCBFNncIEw3mK0f9BgRZetQm/gMuKQBQ?=
 =?us-ascii?Q?qALFqGMvBZ1BlpCb/vtrHgskeAsLKQ4LPO1nthqz30bDw7u+bzC3hyfAKyZQ?=
 =?us-ascii?Q?WzSTdspk1HsJh0yyDjVPrc5bzgR+uoPQzmyVSFONFFv0PC5gRf72By2thi9s?=
 =?us-ascii?Q?7j9vPuX9cDKRhAajW5tVo8PCzTeRGT7Rt0HmOOSVx0/cJ3vWKqQ0MA17Ut/U?=
 =?us-ascii?Q?/e+wjoCHTkGrcQzyQXSO68CiPrz05w+sDrP+JPbPbnsC7ROGcv82jZhZIBjm?=
 =?us-ascii?Q?en5xqBvbaXARCi70A6cPo4lNh+24RjSl7MwOeTW2tEUVMpEK8n9+1uRuyn7g?=
 =?us-ascii?Q?zsjgvrtM5mlUr2hyXtol89XbnaasPuVFFsUQ7pb+AfpBMIyZb0qWuwQ+btlr?=
 =?us-ascii?Q?WB2ngx5diDJvgwJwmTlRrksSLAPyHAqj+NTxo4pqDkLG+rV6fTEBKKXKXFjo?=
 =?us-ascii?Q?LjsEWI/QkBt0sAOIT3rZloBO67zirPWj0FleQ92Vr6eI43OFiAMzPHz02MOq?=
 =?us-ascii?Q?KQBqkBw/egbRJbbQriYQyxSfsqfN3eDAnL7+kmGQZxDKkeGzE1mqxJz/kKcX?=
 =?us-ascii?Q?FvAdbCPNv8ayd8SNNueHN3WuYLVkUDUi8MxxtHkbI5M/g0OfvUs7USujId8X?=
 =?us-ascii?Q?+9892Vd6ABUiUDTfWFJjynJ+Cyn5xs1oV5CcUPUA6fiy1xPlVaG1em0pauYu?=
 =?us-ascii?Q?bI5LExCxCVnHPC6nBUzbm8LETjY6GRKHuBPMCKRmy7gHBM/zsSrEEcfdvZ6O?=
 =?us-ascii?Q?EIe81Eoby+Nkjuo+fwvUa9gp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff093ee9-2d85-4645-0bfd-08d9537e14cc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 17:18:43.1046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J4tmQlQ3hl6IYGHp/2zOherBoB8WHWLuR48W11J02+PN6qlmSrbVpLuNTk55fwzXrXSj1EVerd0wck3hu+t9KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The procedure to add a static FDB entry in sja1105 is concurrent with
dynamic learning performed on all bridge ports and the CPU port.

The switch looks up the FDB from left to right, and also learns
dynamically from left to right, so it is possible that between the
moment when we pick up a free slot to install an FDB entry, another slot
to the left of that one becomes free due to an address ageing out, and
that other slot is then immediately used by the switch to learn
dynamically the same address as we're trying to add statically.

The result is that we succeeded to add our static FDB entry, but it is
being shadowed by a dynamic FDB entry to its left, and the switch will
behave as if our static FDB entry did not exist.

We cannot really prevent this from happening unless we make the entire
process to add a static FDB entry a huge critical section where address
learning is temporarily disabled on _all_ ports, and then re-enabled
according to the configuration done by sja1105_port_set_learning.
However, that is kind of disruptive for the operation of the network.

What we can do alternatively is to simply read back the FDB for dynamic
entries located before our newly added static one, and delete them.
This will guarantee that our static FDB entry is now operational. It
will still not guarantee that there aren't dynamic FDB entries to the
_right_ of that static FDB entry, but at least those entries will age
out by themselves since they aren't hit, and won't bother anyone.

Fixes: 291d1e72b756 ("net: dsa: sja1105: Add support for FDB and MDB management")
Fixes: 1da73821343c ("net: dsa: sja1105: Add FDB operations for P/Q/R/S series")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 57 +++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index cc4a22ee1474..5a4c7789ca43 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1318,10 +1318,11 @@ static int sja1105et_is_fdb_entry_in_bin(struct sja1105_private *priv, int bin,
 int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 		      const unsigned char *addr, u16 vid)
 {
-	struct sja1105_l2_lookup_entry l2_lookup = {0};
+	struct sja1105_l2_lookup_entry l2_lookup = {0}, tmp;
 	struct sja1105_private *priv = ds->priv;
 	struct device *dev = ds->dev;
 	int last_unused = -1;
+	int start, end, i;
 	int bin, way, rc;
 
 	bin = sja1105et_fdb_hash(priv, addr, vid);
@@ -1373,6 +1374,29 @@ int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 	if (rc < 0)
 		return rc;
 
+	/* Invalidate a dynamically learned entry if that exists */
+	start = sja1105et_fdb_index(bin, 0);
+	end = sja1105et_fdb_index(bin, way);
+
+	for (i = start; i < end; i++) {
+		rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
+						 i, &tmp);
+		if (rc == -ENOENT)
+			continue;
+		if (rc)
+			return rc;
+
+		if (tmp.macaddr != ether_addr_to_u64(addr) || tmp.vlanid != vid)
+			continue;
+
+		rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+						  i, NULL, false);
+		if (rc)
+			return rc;
+
+		break;
+	}
+
 	return sja1105_static_fdb_change(priv, port, &l2_lookup, true);
 }
 
@@ -1414,7 +1438,7 @@ int sja1105et_fdb_del(struct dsa_switch *ds, int port,
 int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 			const unsigned char *addr, u16 vid)
 {
-	struct sja1105_l2_lookup_entry l2_lookup = {0};
+	struct sja1105_l2_lookup_entry l2_lookup = {0}, tmp;
 	struct sja1105_private *priv = ds->priv;
 	int rc, i;
 
@@ -1472,6 +1496,35 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	if (rc < 0)
 		return rc;
 
+	/* The switch learns dynamic entries and looks up the FDB left to
+	 * right. It is possible that our addition was concurrent with the
+	 * dynamic learning of the same address, so now that the static entry
+	 * has been installed, we are certain that address learning for this
+	 * particular address has been turned off, so the dynamic entry either
+	 * is in the FDB at an index smaller than the static one, or isn't (it
+	 * can also be at a larger index, but in that case it is inactive
+	 * because the static FDB entry will match first, and the dynamic one
+	 * will eventually age out). Search for a dynamically learned address
+	 * prior to our static one and invalidate it.
+	 */
+	tmp = l2_lookup;
+
+	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
+					 SJA1105_SEARCH, &tmp);
+	if (rc < 0) {
+		dev_err(ds->dev,
+			"port %d failed to read back entry for %pM vid %d: %pe\n",
+			port, addr, vid, ERR_PTR(rc));
+		return rc;
+	}
+
+	if (tmp.index < l2_lookup.index) {
+		rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+						  tmp.index, NULL, false);
+		if (rc < 0)
+			return rc;
+	}
+
 	return sja1105_static_fdb_change(priv, port, &l2_lookup, true);
 }
 
-- 
2.25.1

