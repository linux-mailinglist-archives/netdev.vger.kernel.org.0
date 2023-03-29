Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480916CDB04
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjC2Nim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC2Nil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:38:41 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2040.outbound.protection.outlook.com [40.107.21.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C648126
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 06:38:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeBVvXRMCZsuiqBnxq+JJ8iJU73ysdCTNNnCcV9qs+xcexgtPqFbWTLRfnjScOv4/sc4G2gHFQol0U3ztl+jwY3DLA8SDIT/5dZO8diFPtc6hDibBiPLOKVn3VCK7mzisDoBVH2qKcMbfpsLy9rdcrLjQEKuhM7o792YSKvL8NyOzuoyWqVa1Konm5DB6xXskOKZS5znjYV5pCIEjL6UjJfAB6cMWKrWQlLmcf2QA/sTDhEhJdOEq2Z+2F0LL6uoWsIng2gRVckgllyRVcZSSAQp7GQlO6Kyok/VaWzQ3v3js3k3tGaGGfrm6Gix6Fn6ax7iWzLheDAYAzLFSVH5uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hkr5N3w9HDOdKxxpCg0guLJFxtyzJTGrGY+b2E7L56I=;
 b=c0mM3+kuo2uA/HXh99Lywd0oX3dLrXQy7q8zUOBG1KdiEh9/Cs/5Vej3cPrdb4LFOZojM2FS3K/V4WrCI1ztS0r9cxUaFNBH7+ucef5wKwWOMI19fu3jPzrga/Br2g8oiq9RNas68zQvqOqqSe9ndqUYrzBwPBzSPIqKzqZ2oohOepiQYmAMeHHV0JJrsJm0fOub0A0EPngH59JJNbpAswQ51L1Il1G65UiDlIsA2Gl696umWyk0Jxvau4FWcmjA/d6xENZO+x3B5qfXOZNxGKHkKs1aUc8Oe864+Kz8FRzA6nzlQEsQhdkAdueu0vdq5BSfRNphythn5THPS0uaBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hkr5N3w9HDOdKxxpCg0guLJFxtyzJTGrGY+b2E7L56I=;
 b=ImZiK00fedIgVwCqVq9C+CdJfLJVAqFyrsIPPVE+FfGPdYlnPVKFqOBUkN6+KDsRealES4GVUT7Tc90HYkd23qHdcjI3OE9xCrd3fxlIGvxxYtZE54OfSAd6/mhDOE1hMpmafrs3UjQ/tn+mJQfBtpsDMxb4EjgZnR3Kewelu7U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8809.eurprd04.prod.outlook.com (2603:10a6:20b:408::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 13:38:36 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 13:38:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next] net: dsa: fix db type confusion in host fdb/mdb add/del
Date:   Wed, 29 Mar 2023 16:38:19 +0300
Message-Id: <20230329133819.697642-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0048.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8809:EE_
X-MS-Office365-Filtering-Correlation-Id: c967ac17-7d9c-433d-a845-08db305ae5c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DmLbRP6ucQLpt9nopBXM39RMVBtiM29taelhqgEz98ylzQtO2egaAymJVjyMPcznuwXUFPaSpKKbxGfhwREdpYJPN8H/W8u30sf2QPvydqW6fX+cC4pHF3pSJadc3d0VppnR8s2DNeC1o7A+qGHWK4vCKDc3yJxcnBDk0prs/t5XqtRhjhySk7+50TMjDb9/pJ8KYtnerH8M0rZQ5PnRCU/FOYJDiinSEOt+DeXFNoO1hNx2NtoBLqY6k/DVjFPHDZQQ5+7okGKrIvKHlM1Ks/tgwRiQSieyCUDeGGoV+v4JSFpu6HgNCor++YHgbEPGtuAFH7Na1oEbdFzV4l4G4/fFrayIWvXwoH0gKrrCUcRH3xbpmqR4e4K9xp+QY1rK5jE6ZTjtJTQ4+2QZaFSo+xkqr8cptJ+dj9EwO+yCL9SXZAun1EE1iiQoVKp6MNv8/oekSMGyWekv4H5f0E1w2ekfJmmjuk8nDU+AJ2eOhhm7qYDQJJKFlvwSQc6H6KkytPvplwoSfLZjVCi1GN3SouNtvNiKGwaB+Wvb3THFuq16VYbIy7HXo/nBNEewso/QSHGmKhxIQJYXMPjEOf7Ms1jU1csX4x+99hwXDc/R7xT/Kr1Xkn8MbxKKCzqFirFm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199021)(83380400001)(6666004)(1076003)(26005)(52116002)(54906003)(316002)(6506007)(36756003)(8676002)(66476007)(66946007)(66556008)(86362001)(6916009)(41300700001)(6512007)(4326008)(2616005)(478600001)(6486002)(38100700002)(38350700002)(44832011)(5660300002)(8936002)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?atSajYpzfzhzS8OloVapQpGIl3LVDnb+FpvHraZ5rTtCDcOuB6adw3HxbBED?=
 =?us-ascii?Q?DlPPMF3tagBjdlETdZPGUJZ0JGa4EK0wPkUEz7QS+c/wnJz5RJmyntK8YymI?=
 =?us-ascii?Q?PwXjYUKsQnWGLPvl2z0/Jf75oTRUBWaSEu6A+w6+icnNpd7omTVfwmh49HwD?=
 =?us-ascii?Q?lxB0unkKhwf1Q7V5IzkCD4Iusy7U5sSEPPXzES/OKMJaJX/tbUNJna1pt6Cn?=
 =?us-ascii?Q?vPo5oAhMxnDPVdKTguf+OF1z1m4GvOWXcR4sU+lOH6pMFTLm75KeDjvNHRhF?=
 =?us-ascii?Q?13jWayIFDmhEikZV9b8KG96rYKfY1NADqcB3CQMWpLnhDycNF8BKhf4y3qE1?=
 =?us-ascii?Q?V6uPGac0AVNX6Ff5Tl5x8CfNqO0yiN7I8B6EACePomc7OWf3muCdMkeWgYVC?=
 =?us-ascii?Q?zvDMXGnpdO6s1ECnVnnC8HJIDKK9HE5/EGmzaevxZhrQJXqPr5IyZV6GBG5F?=
 =?us-ascii?Q?rb+EQF6YKlfOVeO2y/oydyeVJtHfDCgUvXGPxq/ONdX8DaoQMMYfeOLMhO9+?=
 =?us-ascii?Q?M4w2PHdeSkJA0EnT0M5S4H7mHd3i7FRGkx/C80WflLz1lqxxZYGNhMrwtyPi?=
 =?us-ascii?Q?eS/vWDx0UFT2PdDGU/flyg15EIfey74nIO1fN/GeF8tHOcDbO/FT0CqZDCcp?=
 =?us-ascii?Q?yVSeAxeCGXzGXPn7QahCE8E2Vx97DJsuUXIIzruPMu50/eHhyaYqW4WgAkQ3?=
 =?us-ascii?Q?ndBxrv75l+bazBfjvpHbigKvXZOd54gUZ7opqktm5tev6cQXNx4nYgUDB3vy?=
 =?us-ascii?Q?EaboWT7wsM6EUAvsGcjL93W0NHkEqOp+At67Oqj47lUjXPK3xox+zqzjDF1A?=
 =?us-ascii?Q?kUvcM3RdYzBZny9i39NtxsplFHniA0ynriS29Og6kP2peFm36v9nM8dFKUKX?=
 =?us-ascii?Q?78sxNV5MMFNZOlatOcqqWHkpqP3TcFYLZLKxrhJzSg04vDYF8L54js2LVBWx?=
 =?us-ascii?Q?rsuryCIrYQerdkeffn1EZK4NFfKrGx96EEhBEDU8/QjBXmaFHa09e2ZY5r5M?=
 =?us-ascii?Q?BXZKKF4r9RIcFWCoqWuLcZXtQVzlv2JftlT9ZGYa4Xcqy8sT5Ho7P3mFgc2I?=
 =?us-ascii?Q?WFLJ18tL5ucote/5h5vkIDip62bo27RSJg2A7dH9FVhQr5hbz9UMTFqjmBwl?=
 =?us-ascii?Q?wtTozl/BE2U4hNkCSe4veoAz+5xOK+coH4AjLQXTcbC66lJC0SmwJIvpSLbZ?=
 =?us-ascii?Q?yDs/SRfDJzMYJZSRx+agZBMab6ZfAIc2+WBJhO++sTKUUcxIgS3em2Oiho3r?=
 =?us-ascii?Q?QjrAbDCzEjZxldfojiqTZskt7M6rX4qlHF7NM1qCbVdORAmyWIyVyVbu40fK?=
 =?us-ascii?Q?QvQirxuH4zISmpPQ0yGuD4wBF+niCICixAJP/vmk8uxea1AVHxDYpaQKavcC?=
 =?us-ascii?Q?N1yzmlwDHwziX2MX69mZvh7cYbwYkrShJW1DW/9iLKNKDKen2M52ooqciCdC?=
 =?us-ascii?Q?lAA95XTj8+z9xYE2qJm+gkAVOdbV8mgBqMxNwr/jHbu2K5a8VRQAjJRVdPZU?=
 =?us-ascii?Q?GYPHaanrMwQBwv3w71GkH6PzLLvCHBenfiOLn92mly4z6zZEbw/kobztOwom?=
 =?us-ascii?Q?iFQlXMsDUE41wwX31t3Hg5adc2ZwWHUzCpk9ZXBlngGKBBPc8D2VPgj/orAE?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c967ac17-7d9c-433d-a845-08db305ae5c0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 13:38:36.5095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FOJqGXnABulv6iZaMt3D9pAZiPPibfzaFt14QZ6tU73FpwBRxdO50KSHXIg1AiPoU7tdFGCgDzWKK+hDYKFUFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8809
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have the following code paths:

Host FDB (unicast RX filtering):

dsa_port_standalone_host_fdb_add()   dsa_port_bridge_host_fdb_add()
               |                                     |
               +--------------+         +------------+
                              |         |
                              v         v
                         dsa_port_host_fdb_add()

dsa_port_standalone_host_fdb_del()   dsa_port_bridge_host_fdb_del()
               |                                     |
               +--------------+         +------------+
                              |         |
                              v         v
                         dsa_port_host_fdb_del()

Host MDB (multicast RX filtering):

dsa_port_standalone_host_mdb_add()   dsa_port_bridge_host_mdb_add()
               |                                     |
               +--------------+         +------------+
                              |         |
                              v         v
                         dsa_port_host_mdb_add()

dsa_port_standalone_host_mdb_del()   dsa_port_bridge_host_mdb_del()
               |                                     |
               +--------------+         +------------+
                              |         |
                              v         v
                         dsa_port_host_mdb_del()

The logic added by commit 5e8a1e03aa4d ("net: dsa: install secondary
unicast and multicast addresses as host FDB/MDB") zeroes out
db.bridge.num if the switch doesn't support ds->fdb_isolation
(the majority doesn't). This is done for a reason explained in commit
c26933639b54 ("net: dsa: request drivers to perform FDB isolation").

Taking a single code path as example - dsa_port_host_fdb_add() - the
others are similar - the problem is that this function handles:
- DSA_DB_PORT databases, when called from
  dsa_port_standalone_host_fdb_add()
- DSA_DB_BRIDGE databases, when called from
  dsa_port_bridge_host_fdb_add()

So, if dsa_port_host_fdb_add() were to make any change on the
"bridge.num" attribute of the database, this would only be correct for a
DSA_DB_BRIDGE, and a type confusion for a DSA_DB_PORT bridge.

However, this bug is without consequences, for 2 reasons:

- dsa_port_standalone_host_fdb_add() is only called from code which is
  (in)directly guarded by dsa_switch_supports_uc_filtering(ds), and that
  function only returns true if ds->fdb_isolation is set. So, the code
  only executed for DSA_DB_BRIDGE databases.

- Even if the code was not dead for DSA_DB_PORT, we have the following
  memory layout:

struct dsa_bridge {
	struct net_device *dev;
	unsigned int num;
	bool tx_fwd_offload;
	refcount_t refcount;
};

struct dsa_db {
	enum dsa_db_type type;

	union {
		const struct dsa_port *dp; // DSA_DB_PORT
		struct dsa_lag lag;
		struct dsa_bridge bridge; // DSA_DB_BRIDGE
	};
};

So, the zeroization of dsa_db :: bridge :: num on a dsa_db structure of
type DSA_DB_PORT would access memory which is unused, because we only
use dsa_db :: dp for DSA_DB_PORT, and this is mapped at the same address
with dsa_db :: dev for DSA_DB_BRIDGE, thanks to the union definition.

It is correct to fix up dsa_db :: bridge :: num only from code paths
that come from the bridge / switchdev, so move these there.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 67ad1adec2a2..15cee17769e9 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1028,9 +1028,6 @@ static int dsa_port_host_fdb_add(struct dsa_port *dp,
 		.db = db,
 	};
 
-	if (!dp->ds->fdb_isolation)
-		info.db.bridge.num = 0;
-
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
 }
 
@@ -1055,6 +1052,9 @@ int dsa_port_bridge_host_fdb_add(struct dsa_port *dp,
 	};
 	int err;
 
+	if (!dp->ds->fdb_isolation)
+		db.bridge.num = 0;
+
 	/* Avoid a call to __dev_set_promiscuity() on the master, which
 	 * requires rtnl_lock(), since we can't guarantee that is held here,
 	 * and we can't take it either.
@@ -1079,9 +1079,6 @@ static int dsa_port_host_fdb_del(struct dsa_port *dp,
 		.db = db,
 	};
 
-	if (!dp->ds->fdb_isolation)
-		info.db.bridge.num = 0;
-
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
 }
 
@@ -1106,6 +1103,9 @@ int dsa_port_bridge_host_fdb_del(struct dsa_port *dp,
 	};
 	int err;
 
+	if (!dp->ds->fdb_isolation)
+		db.bridge.num = 0;
+
 	if (master->priv_flags & IFF_UNICAST_FLT) {
 		err = dev_uc_del(master, addr);
 		if (err)
@@ -1210,9 +1210,6 @@ static int dsa_port_host_mdb_add(const struct dsa_port *dp,
 		.db = db,
 	};
 
-	if (!dp->ds->fdb_isolation)
-		info.db.bridge.num = 0;
-
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
 }
 
@@ -1237,6 +1234,9 @@ int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
 	};
 	int err;
 
+	if (!dp->ds->fdb_isolation)
+		db.bridge.num = 0;
+
 	err = dev_mc_add(master, mdb->addr);
 	if (err)
 		return err;
@@ -1254,9 +1254,6 @@ static int dsa_port_host_mdb_del(const struct dsa_port *dp,
 		.db = db,
 	};
 
-	if (!dp->ds->fdb_isolation)
-		info.db.bridge.num = 0;
-
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
 }
 
@@ -1281,6 +1278,9 @@ int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
 	};
 	int err;
 
+	if (!dp->ds->fdb_isolation)
+		db.bridge.num = 0;
+
 	err = dev_mc_del(master, mdb->addr);
 	if (err)
 		return err;
-- 
2.34.1

