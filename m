Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13343F3C79
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 23:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhHUVBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 17:01:21 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:58336
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230107AbhHUVBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 17:01:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQYG93uYwJfpj435zwqkspoeTfsZ4anDx3RsPRL/Y+GKEmRxPUULHZ2Yv/kq9+NJFG2G/HpL/fnGFKHZ1vlaYhVidcy0eFqAqpiR5DmbPObppoi3yEsQFYprb1qGODD0dbhRNYK8MQ27Xb6LN20U7N8mW5Rzg5xGjb0ZkUuOnFQ42Kz1wYzC8H7C3eZfIN3Oqiwgm3VptCU3umrJq5pUJyp/mejABAcwcT9v1umGVzQX+LoyCKZCEElc9PyeRNABO4BO5Fk7HWV1IYLJ1cS0FIkjbFstgLz6bCm1lH39eBkC4FvyHCzgqxfPgIArCTMi5yqZDfl/Kcy0nDzqrqAklw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TORUjjKYrAQEwqvTmGOI2DlVVneZE51wC2QGCtKltFU=;
 b=OA47UFKq+fwGQdRadg6Hoj03fDQdHV4pq3JZUekIt1spwbOogI9tcsDmfahcfa8rPl/UmZFg2tGVH16kTT31CIwucLFZxNAHSLpyOM6c6h0YqD/Lo++9O5KTsJQRiCqLN/TsVKofJ2Wo1mH+myDNAhocy19KAk+rH3gfSgsq2HqPxs14JT9HSPL6Xf8xHLytT6m5aoTVOzRGIZEZA57I1kbMlC+aDwVk4LuONHj7sJqfsPW6wjujDS/WwHhPbi5vlPjluoUQ5QSrHIVPfmvzrBoOn4QZj1dk/oxPX6Rcy1j/6hYwEOKFuaZOx5GkqQfS+hX30ES5CKvccUahzm9ing==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TORUjjKYrAQEwqvTmGOI2DlVVneZE51wC2QGCtKltFU=;
 b=fl5A8yGrJWgwCDvmJIAC5rP0u9KISAr15ijjUTkwiJAk0ncPTO2gZ7b+1YUfDszpoQFm+fgkru7uVZiEwv6dM48xhdpFXPYQyP2EYmlhlrd3dKILY9Tt1Hl5atALUQCz/lHcWjJAqQRjp3OA7+k0rMUvJvsLfF4Hrmfoz/0ZJRk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 21 Aug
 2021 21:00:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.022; Sat, 21 Aug 2021
 21:00:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Subject: [RFC PATCH 4/4] net: dsa: sja1105: implement shared FDB dump
Date:   Sun, 22 Aug 2021 00:00:18 +0300
Message-Id: <20210821210018.1314952-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
References: <20210821210018.1314952-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0010.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0601CA0010.eurprd06.prod.outlook.com (2603:10a6:800:1e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sat, 21 Aug 2021 21:00:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3385972-5abb-43eb-43ba-08d964e6b7eb
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2687DCB94793A700FB936A2DE0C29@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hO7QlKFl1sYoboUjAL0OFf4DY+mJKHlmiZQOEf++NE1YXRR1NY9sAUuOL4tQ7ehwSywwNuge8HeejOzsES9eDbmF3rn0KCvNYB5AzsiA+wYSEJuPmRy0lsYBZtmEYOy38B4RXFpZzP2OxTPvMVnoRXjIQhbD+4jptDVLwH4dB7Deuc08AP/cminDQPIXnupa9tUs51rj8v+4E752s3SRos6j0ukQk8KFEW9uYfc7MCDlLo9py35v2kAKjnm83Ry5k57r3s8LdjHLa9Ar6C+Ork9V9tjb40EmnK+1z4JmBiuAtqH+baaQpaBaAjQWnB8SNl8wkfl2kPUNeu12xlPzy6TvYLOk6wGrONlC43mYCGy1K7Oh6I+psZ5XAQ46A3sI6cWuH1Utakvt5Ne2MUBw8llv/xf0BKf8raDXc6ldKmgdFiUT5e2jivzRG+76urANUEqzV1g9LGnXQcM+OuFWlLAp9ZK4QBEmt9mU3TLOBuoCUEaHLUjy+3NBJTYZF0D9o6GWXusmTcLnYisDwfcAoxu9qNvECp8wrNA1Yw5txaTP4SvqnjW5/yxQrk6kmpUR+pJWN1kEB2B0CFExSkCJ/qtw/34V3y6wOzBS85dTcpVNPl+gAnYSIKiIgrhBpVj1flYD53l9ki0TQs+/1an86pbHElBU+tlT3cPefczxgXKl/McQHMFQYmoQNwhB76zJc+FHfmRxJrbqQ7mRnJAV6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(346002)(376002)(136003)(6666004)(86362001)(6486002)(6506007)(6512007)(83380400001)(66946007)(66556008)(66476007)(52116002)(26005)(8936002)(478600001)(36756003)(316002)(956004)(8676002)(44832011)(5660300002)(38100700002)(2616005)(38350700002)(186003)(6916009)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i/1ZAqlaP6o+TVuNIdkY8KcHXxjinaucCXpYydEWJZOsZ5hctXOpwPnQ1hJz?=
 =?us-ascii?Q?NWyKT3Ad3LeJhOsul3Bxc4vsklG6Nfq3K8vj1FhPtV6GXnzJyBZDa51qOVaR?=
 =?us-ascii?Q?NS3q4BZGZnSngemekrCZA9xInUpjs9NPzSDxfcD5GY922H9hnJitrbSgMt08?=
 =?us-ascii?Q?eA9HOQyTxAtcSVQwQSAY5MU8KwZb5B54xJL38JCo2xjAYBf1HD3M5b5IUXq6?=
 =?us-ascii?Q?8k1HbfodnX2nBgnkJ1TWAT1EXUpkRGpFNODNEVD0NPps/5IBTA+7ya8HqB7X?=
 =?us-ascii?Q?ZEEgM7OVEEQUaJpCyH8Ut1tsZPNmlEolwrHeu2hav1x6b7S/IzSOI1O8Zgec?=
 =?us-ascii?Q?BqCyw+BivbVyrB9V1T3FW06BhYYdyKXaySo/y0RYVgCgDzPjc1dD1EzD7wXN?=
 =?us-ascii?Q?5+6E57gCMbOpOaOMx77e03xeLANBdyjc3YVT5x1Dm9VY1e80hsmEBG3E4WgI?=
 =?us-ascii?Q?RxLbZEteg4Kd9n0QOcLtSwk2/t+WkrLzlTdZpiQ0x15Wi0E1WcCiVP3pLW7p?=
 =?us-ascii?Q?RWR6YkBl0vmW+aT0G8q8T3eMmS3aYWNYgS2t39OxlPCUsw2DEZliK+YR8go2?=
 =?us-ascii?Q?NFyunZoXUFEkhzMZARbsWnEg6DHvRppA5VH6WnDO8aqKvCBN7S8+NeKA6Zx1?=
 =?us-ascii?Q?j+kGwImH85r/kDQ2kPa6EGySFYFNKVEfuEyGJYaPo41pGHMcxkED6LLIbRVh?=
 =?us-ascii?Q?fuOg7Nfp+ZV0pYx6w4A8/2b27/Fwjq3I6j8GCAwpbEV5JzQFw6P0SRVnUql4?=
 =?us-ascii?Q?KkWXQYhCrUd1YfyXoHb3kcWxEzCpGnHCLXKk9f99fqV/cyO4sh9b4vT44SvB?=
 =?us-ascii?Q?QmhqJiye0duHoxie4O94Yi7x8E4j8F9KOR2y/LQOjRX0aI9QzKfG925AOLLl?=
 =?us-ascii?Q?5TM6S3xkff2fFAF/FnlQFeobu12geR2HV9YS0NiUzFO9FR11SU/9S885Xtqx?=
 =?us-ascii?Q?15jNj754J4mGVCuH3ePEXiuRxopxo0S0VswIesdz27boZZaxoF2mI0ty/6gS?=
 =?us-ascii?Q?b6orXK8ufA6DiemBisKKgMWg2r32myoZukvxnJk2YZ/wIIAvcQo/4tPYlH+f?=
 =?us-ascii?Q?nEsL92lxw/47EkgEM30RMD+smiQE/eI7gD+MYMVL7w9gm46r/+0sOBCJrpQo?=
 =?us-ascii?Q?+oaqrkzgEAj/K30WGIt1njhNWHDSc6hbSdSorTlyx2dNVDMtWj+/D1hj5xA7?=
 =?us-ascii?Q?dHk4O56oWLqeUKotiwRBTBPGZDmtnZ4XCnWtCeS0Bn2w6MWGzKKNrsS/sEWZ?=
 =?us-ascii?Q?GIQ0iVHDq+BnTUFwM+6c/M6xaBtIVlD3RlR24kbvbpOTh1XByFX7HW7b0jrB?=
 =?us-ascii?Q?Dp7SYyHDybj/LX7omrGez/zF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3385972-5abb-43eb-43ba-08d964e6b7eb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 21:00:34.1509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hiW1wQv9/ah+28q6Fj95+FcTJOw1cxdqfXwFN87/IB6uC3I3WktjcCrVQUHWcOCByhm1TCcXLq3ca0UzGpLDGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver already walks linearly over the FDB in the .port_fdb_dump
method, so the .switch_fdb_dump can reuse the same logic, just call back
a different DSA method when it finds something.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 50 +++++++++++++++++++-------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 05ba65042b5f..e1e9e514814e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1747,14 +1747,17 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
-			    dsa_fdb_dump_cb_t *cb, void *data)
+			    dsa_fdb_dump_cb_t *port_cb,
+			    dsa_switch_fdb_dump_cb_t *switch_cb,
+			    void *data)
 {
 	struct sja1105_private *priv = ds->priv;
 	struct device *dev = ds->dev;
-	int i;
+	int i, p;
 
 	for (i = 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
 		struct sja1105_l2_lookup_entry l2_lookup = {0};
+		unsigned long destports;
 		u8 macaddr[ETH_ALEN];
 		int rc;
 
@@ -1768,13 +1771,12 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 			return rc;
 		}
 
-		/* FDB dump callback is per port. This means we have to
-		 * disregard a valid entry if it's not for this port, even if
-		 * only to revisit it later. This is inefficient because the
-		 * 1024-sized FDB table needs to be traversed 4 times through
-		 * SPI during a 'bridge fdb show' command.
+		destports = l2_lookup.destports;
+
+		/* If the FDB dump callback is per port, ignore the entries
+		 * belonging to a different one.
 		 */
-		if (!(l2_lookup.destports & BIT(port)))
+		if (port >= 0 && !(destports & BIT(port)))
 			continue;
 
 		/* We need to hide the FDB entry for unknown multicast */
@@ -1787,13 +1789,36 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		/* We need to hide the dsa_8021q VLANs from the user. */
 		if (!priv->vlan_aware)
 			l2_lookup.vlanid = 0;
-		rc = cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
-		if (rc)
-			return rc;
+
+		if (port_cb) {
+			rc = port_cb(macaddr, l2_lookup.vlanid,
+				     l2_lookup.lockeds, data);
+			if (rc)
+				return rc;
+		} else {
+			for_each_set_bit(p, &destports, ds->num_ports) {
+				rc = switch_cb(ds, p, macaddr, l2_lookup.vlanid,
+					       l2_lookup.lockeds);
+				if (rc)
+					return rc;
+			}
+		}
 	}
 	return 0;
 }
 
+static int sja1105_port_fdb_dump(struct dsa_switch *ds, int port,
+				 dsa_fdb_dump_cb_t *cb, void *data)
+{
+	return sja1105_fdb_dump(ds, port, cb, NULL, data);
+}
+
+static int sja1105_switch_fdb_dump(struct dsa_switch *ds,
+				   dsa_switch_fdb_dump_cb_t *cb)
+{
+	return sja1105_fdb_dump(ds, -1, NULL, cb, NULL);
+}
+
 static void sja1105_fast_age(struct dsa_switch *ds, int port)
 {
 	struct sja1105_private *priv = ds->priv;
@@ -3114,7 +3139,8 @@ const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_sset_count		= sja1105_get_sset_count,
 	.get_ts_info		= sja1105_get_ts_info,
 	.port_disable		= sja1105_port_disable,
-	.port_fdb_dump		= sja1105_fdb_dump,
+	.port_fdb_dump		= sja1105_port_fdb_dump,
+	.switch_fdb_dump	= sja1105_switch_fdb_dump,
 	.port_fdb_add		= sja1105_fdb_add,
 	.port_fdb_del		= sja1105_fdb_del,
 	.port_fast_age		= sja1105_fast_age,
-- 
2.25.1

