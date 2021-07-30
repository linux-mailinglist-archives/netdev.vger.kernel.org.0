Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974033DBD95
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhG3RS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:18:57 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:45569
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230243AbhG3RSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:18:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRvNcGGKHNRq20GMU6r+3hTLslBzMylTwOsbgMYlPSfqhRjHYnspXQMSchpaXiBL33TZXHCJzfxJZI5bGr0Nes8ObUmUFHYqUA5goNsxy+h76FrffyqNY23VEiJx0EzsgPIjgUyzpnwJdmWT33ba4qYkXA9eeQvQb7VnsYxH/SuoujCHSy0Qsh7NbobOqkKA+WC4vnV6cG0Ylz/UAUMexa8TvxafDBXq3WoOVIZ13UQxhyGvTgXEV7yI14hzeIOs6FhIsOWIQSzAsDr2PE2/7i8CouNYp+d51U2Gx3VGim3+IRhdRsthEVgt+kL0uNcu9q004ZHRt1bk4+08nDVtLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VR3tDTEB9iaZH5XIeEn4AS7nC8P1BseRw8Cxaey5QGM=;
 b=cQr8C6hptUNbHylJZ+5HNG6LdlO1S5/d5epAKzKigVOL+qIQ/Rc4lcqHQ9PetUZioVjhErGKmDD4TEpNEtkqgJR/xZNwLnR/jNDRo30QdQme1JlQJGq66PWPtOipKfWnY6Wp82v72LkUwGEKATwZ0hr1afjwG6N+TkURo49FX3/cYwkuflMV9U4K4oDmq7Bfp6hV5zEmooMxlMLHR1I6BjlGF5htMLcV8YTFhtQAoSwqukbZrn9nJfN1b3kWl/CQHpBE8v3CxI1E106FAyoGtlui7CdeRAlDGZnHH5sxoo/NFPHRh1vlTT8mP2y629Pm3a4ZYlDNp5JgtIj7gZi3CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VR3tDTEB9iaZH5XIeEn4AS7nC8P1BseRw8Cxaey5QGM=;
 b=iDwxrQcU36zWrA+cV6VCGAQnqOJBav8tvB0qq5YXeseFhK/tbWec+6c5hyrlVeXDjzn9hqk7jc+Cwks0NoPW9K9wsr7vZswvxPSwS1AFOKq8vv1CiWgBklzT6xtMzdQEU4elsVUOwrcJdOib1prrSnVizy1raXLvarx8sRXpX24=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Fri, 30 Jul
 2021 17:18:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 17:18:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net 4/6] net: dsa: sja1105: ignore the FDB entry for unknown multicast when adding a new address
Date:   Fri, 30 Jul 2021 20:18:13 +0300
Message-Id: <20210730171815.1773287-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM4PR0202CA0008.eurprd02.prod.outlook.com (2603:10a6:200:89::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 30 Jul 2021 17:18:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 767371ee-3534-4716-a6e1-08d9537e1558
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39677AE8FCE8728847B78BEFE0EC9@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a61XsyFSfh8CM7JFyceHhKJ74PPYdOxQW4bH38pTDhlsZoK1PHMsgM3LXNcSI0NHKStdzalYwjK43VRltAZR9hcCIKUxMXTNNcBA+IU/RPaUHFB46k5eca6E2rCfZQRtOXYw9qymI0HhY9p3Qp/F/GaUVI253iSjze+eW1qqHCp5js2LnXt9dJ3oYbKGPXe+MHwaKQAzYxiJYkHXBl3+Og98DjntAdl5zRofQS0DZ5NCLdJime5gmgf+drjQRM1JVMMM281C5+tmsgoOrG25odnU2qY6iiDc0SakARC0Asxy6bulSUSoMkX3YgAdi9Zk67OSH7iND/gd72zYlH593ItNIutCGjP4O4Gb8zUORq1L9m7K1GJA5fy8llzBFaGOfy9OqMnFwkCzPUzafnUOilS21moVqcay+4vYzccKk9mBaLwTR1pXDOY9YWDGmVou/sqQY34mtqoZGJqfeGKW5/lo/UIazEdHw/WbqA0oy2va0WkTcBVmdgQ8T5BVT8I3cT3YPkKCE0iq6sMYo+LqeOr3nx674Ov+b3fZORIinq12TFYm9uR4aBHbw6NSVS4Xauq2IalVkXwtXBJDbOl1CXaytcFT0+Sec31Vdzr0zaRg3/2Tc9G7HjaXH62GaObeoRIK4LuVRMd/CnNWO+b9dfgPVNPyw7OFamP3l7nMdJR9nBE2cf5PuVmZL0sRAR7VmAdNB0YsTzS+Su87Qjx4cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39850400004)(366004)(2906002)(86362001)(6512007)(6506007)(478600001)(956004)(83380400001)(2616005)(316002)(38100700002)(36756003)(6666004)(38350700002)(6486002)(44832011)(52116002)(186003)(4326008)(26005)(66476007)(8936002)(66556008)(5660300002)(110136005)(1076003)(8676002)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tyRaqm6t4gPczoYUasP4OBgdQf23yop1Vjk2Vj8Mcy7WSsejuupDmqCLvepG?=
 =?us-ascii?Q?Pqyhv0IeA83hnbUsT3dzjzhKMnTSd+DZrqynS5ysRh7vVrAgvn3axzve1Ekf?=
 =?us-ascii?Q?/7N7i2Q/JAZOGPU4KRhLMnx/tJeLIubdfuVlq4FCgdUQtQAYCLPD2TgVAa+9?=
 =?us-ascii?Q?p4hv30qMLl907VXGoIKvZPB6As9YUGKokvX74Hmx1KPKqVtHuFqCOGYpPuBL?=
 =?us-ascii?Q?YYHhNLm9J5sABJa0ALP3VWlKLPQbwy+UCIRSmkPOzsri+8LFE0HjfnSnyCmO?=
 =?us-ascii?Q?4r2BYvFGLPK9a5T+0WpWJJGRh9QCfWN6G+q7G+yYpqZ1EMZcmIOTnvBinXvK?=
 =?us-ascii?Q?GWoRAguniKk8wYYVIUkKdpc041MIycBOgi09nzOQO1EiBYZiaxUIZ1FjIKvn?=
 =?us-ascii?Q?tl6N+XaVQObQDwFsss1xiifgPwj3ME2rz+B2Wrm4mIki1ELR1w7zHIJ76B6w?=
 =?us-ascii?Q?TDcgOsusi+EiaZAxKegfX63iW0MRJc2vhWqKIb0Jis7i7FnoadeoxFXczcOG?=
 =?us-ascii?Q?AT3ecymkbAWNyQuIuKEixSOYSTGYZttlGcNCCVpNHaP35/48OfL5EuVhshTw?=
 =?us-ascii?Q?zTC9iZJMTwnexht0hvpSSvnmqZbyFlINeYXeDSOM9XnZ9S6kxhHfeYw0YQCw?=
 =?us-ascii?Q?2QBdQGt8qT9QEayn4z1n8FZF0Ccx7bBS3ECp/sNF+Jn53l5fewG1mApl1lkn?=
 =?us-ascii?Q?y6nogD0By+rn8g+hXEreUhoPH3KeJIhtobL4GDaFBfDcdlXKrK3Ru6iQUtut?=
 =?us-ascii?Q?wzZlvZI+NsWXj23fmJyuCSe37sXqTZIv0jq6/+s4BwvmnrsNWdD/uAQvyhKe?=
 =?us-ascii?Q?/VXBYmSCDzECESHOyCTcsOhM7Nm1haOcoPyS9frzl9Km8aSINTxTKVxXRJDu?=
 =?us-ascii?Q?4aR02GITlptEc1UveVIQn6zvzzzK95zu1UmqrSHrvfAD6WqSsMxoDemZPRvF?=
 =?us-ascii?Q?dvtftfUFOBwRzmkae4eBop6qDGetyDYfe8DmFalAP6ghZNEso2AhH8bpCJQn?=
 =?us-ascii?Q?2jjAElPtTuX6Vt2gsbDyNtBBFi0+CxG0FUPTg0a5lA25p0I1zbqIVCVSvxOW?=
 =?us-ascii?Q?FNr9TqjnbcVM7VsWnu1xK4h6X28Riw3NbqZ4AVUSaocJ1EV64byERI/c71q+?=
 =?us-ascii?Q?y3FmurARerpVUL+5g/Filpvl8RhiQFUs3UrKdxjSXrEeqOXZO3hp75gS3XYU?=
 =?us-ascii?Q?e3UplTmCNFRZ5pyZ1qFw7PBbQcGDh+ANJRUcDZnU0lDpXV2G2+oPXQKR4rBb?=
 =?us-ascii?Q?Q6Q2F3EwdQAjhTGEX8+lxZAFNFfXxnVfj3VTG5efgx4uBnjvBXGNTIn9Ned6?=
 =?us-ascii?Q?Z6CcfpF9nq3Is+YbGe94kJiO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 767371ee-3534-4716-a6e1-08d9537e1558
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 17:18:44.0071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FPszIo0Xj/uaKROOA5e+WZf0XfnmmCbt81mFQfh92ReflCtqwyGZZg/zm6G4PVEA/vYhh4oX7KEChMR6rG+wVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when sja1105pqrs_fdb_add() is called for a host-joined IPv6
MDB entry such as 33:33:00:00:00:6a, the search for that address will
return the FDB entry for SJA1105_UNKNOWN_MULTICAST, which has a
destination MAC of 01:00:00:00:00:00 and a mask of 01:00:00:00:00:00.
It returns that entry because, well, it matches, in the sense that
unknown multicast is supposed by design to match it...

But the issue is that we then proceed to overwrite this entry with the
one for our precise host-joined multicast address, and the unknown
multicast entry is no longer there - unknown multicast is now flooded to
the same group of ports as broadcast, which does not look up the FDB.

To solve this problem, we should ignore searches that return the unknown
multicast address as the match, and treat them as "no match" which will
result in the entry being installed to hardware.

For this to work properly, we need to put the result of the FDB search
in a temporary variable in order to avoid overwriting the l2_lookup
entry we want to program. The l2_lookup entry returned by the search
might not have the same set of DESTPORTS and not even the same MACADDR
as the entry we're trying to add.

Fixes: 4d9423549501 ("net: dsa: sja1105: offload bridge port flags to device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5a4c7789ca43..5d8739b30d8c 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1456,14 +1456,19 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	}
 	l2_lookup.destports = BIT(port);
 
+	tmp = l2_lookup;
+
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
-					 SJA1105_SEARCH, &l2_lookup);
-	if (rc == 0) {
+					 SJA1105_SEARCH, &tmp);
+	if (rc == 0 && tmp.index != SJA1105_MAX_L2_LOOKUP_COUNT - 1) {
 		/* Found a static entry and this port is already in the entry's
 		 * port mask => job done
 		 */
-		if ((l2_lookup.destports & BIT(port)) && l2_lookup.lockeds)
+		if ((tmp.destports & BIT(port)) && tmp.lockeds)
 			return 0;
+
+		l2_lookup = tmp;
+
 		/* l2_lookup.index is populated by the switch in case it
 		 * found something.
 		 */
-- 
2.25.1

