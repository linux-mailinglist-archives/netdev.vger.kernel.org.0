Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0ED3EEEC9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 16:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237964AbhHQOxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 10:53:46 -0400
Received: from mail-eopbgr10089.outbound.protection.outlook.com ([40.107.1.89]:48038
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236592AbhHQOxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 10:53:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWKfpMgAlZMyFkRg7g023XgyRkapDYglTfGC2Qio99VdzNG6cHwkOL3FGCKyX+I0JrgAjQ8X6rk+PKDunKaVoHwI+MyIRuaF4Xm8q8+7FaqD9OWAXv8/GT81ms1/FjO3L7BswPXiToAoecTIiZ6hefTBocU78sWxAKbjXKBSKP7UlW4pLRxBKDQq0OTx8dItaLI4PjNMDJMWtc8ye6QqhIRhw22AMmvw9W+MKgwT/46mSNZbvCAQwAMiCPU9k1aUlb0SMHn4kXOWhJ7MJzwlpBRmRzxohSwDTYOAN/EOkd/+L3L73qsIQtLh5DhhaDE57HNuUNOZSDiV3AquRd+7IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KOC5Vz53Dd3dhTdeQzKWBVVtGpwyqGpKJzbCnLb7s0=;
 b=FN/KZ6fmVCmZQlz1kP5kyHGh6gSdwk1vI+XpofmLh0qO6SUq1WD3ib2u++qZbV7xFRHztguSOujdU2iviq3Ign6Sbu/5ZWPUJQqLFbKQHANSORUdVl6ynfG0snwXcZ396UNoLD/DmENubgE3Nh8dYQ7FwLcoFvbA3ZMajjqEUFnOn1WSGORGDmn2EsBgRl7NapsyZ3RBcdp3k7lhqVR4P+AJZBNriqSEMnnTarlsDcM3SCLwvxpo39tyAnlSPYV8Jh7IWThsquhSjTYeTIhB2yrKQvPbltwBp3SiLD+Tl4kgqeRK15Qv/Q7grRPcIUfGLUUAXn4lfUOWePpVvp7AWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KOC5Vz53Dd3dhTdeQzKWBVVtGpwyqGpKJzbCnLb7s0=;
 b=LU/wdRbDYBBZMGp8wsjWqdkbANFMuIgtq70gVhn/XqQuSEcz7UmlB8E/szAi4MWnrjFzEyeGpAPkG5YrXujhlCmc3X5zZ9iYbffwkMA1wbXeux0WHC0ude3SzE5sPnONR8AQHekNGqo6Eq9FYXdtaQYR6WXVw7qvfwAfHS1Vsbo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 14:53:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 14:53:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net] net: dsa: sja1105: fix use-after-free after calling of_find_compatible_node, or worse
Date:   Tue, 17 Aug 2021 17:52:45 +0300
Message-Id: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0002.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0401CA0002.eurprd04.prod.outlook.com (2603:10a6:800:4a::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Tue, 17 Aug 2021 14:53:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1a7c9e8-7daa-4654-4a51-08d9618eba48
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39678EEF41FCF8CD6A0C48FCE0FE9@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rsppcZuT3LlXFtjfWPJiyUqJiC2ToL+xVmhVsPQJ2BMsvRu3dHry2wLhHAf6z+UvLBtdcmA23o00A9oOgMwVbhXRGWzYUUhCn/P4tm7/QA8duAFG26J5Un8GfhwgTK8pLuRcmsudRgbLXSbebDzXrc+v/cQ74HnyE61UerrItDhdFJGlzdv6JQtkKRJevWzPj+ad+wZvJHzcp9rUARFNn2eSsoVxz+nt1bWmH7phyboxuK5e2wA+cAR11J+XmQHpLm7m9MvqyEqcTYRaa4FuqrAQ+9eQTJ2wDYwlGg22Rftunnjo1bdvViSLQsAv3qbrGV0xuPZTu92izO4Wde3V6t+xXu/HneDw+2YvvTLYiKV5Ao9RPyPSg1iO/j5CSZAk5+RoXfVWXn5DH8vJZjKo27umAXl4zI5kSZrHvyw3u1WRHiwBThv1blajbMEW+sSU+lXH+OkhxsaXPmO9SLQSyRpSbnbVdHy5cCvH1lhIcDBEz4/nkVXWHNu90E1iCs27O7AKTrPqmI3g1X7pxY2cYyQcwGsljFBn6tx7fVP4rxcVKSaHA9cfG6YC/ufqw4YanMpA9TfywwXm8Usz2DOZKwAzuhaN5DIEd8w9hmnvS3+CjLT3P+vPxfk3Wh0d/5zLugblPAj9JoWJw5tzWoix8Piqzkyp5IrJaXbbcton07NmZPF5zrWA2/dFA3ZxQ/1lpNcwgETilx599FtfLiCwawhEw+4myaOmk4VqczJLLyZj1cDbD0gv0bMtze5Pp4c+s/QuL2l1vO3n/e++Ie66Ogf5gdpsxTfgf1BN8h/WKhU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(366004)(39840400004)(6666004)(6486002)(44832011)(83380400001)(6512007)(38100700002)(38350700002)(86362001)(6506007)(2616005)(66556008)(66476007)(66946007)(186003)(26005)(956004)(36756003)(8936002)(2906002)(8676002)(54906003)(1076003)(316002)(110136005)(52116002)(5660300002)(478600001)(4326008)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L6yWI90/RjQSZ0TZmuFpiOnX+/yLn0nfBQx7rY2+MM6U5QTgmDJdtZVoE88t?=
 =?us-ascii?Q?Xp7PM3SEYPVREtWmgvmgT3qJKJN3wRXm/0EpMIS0RZRvMc+RfDOi1DO3d6SB?=
 =?us-ascii?Q?T9pux/Z88tpVccsITyiI+DUvm21nV/X/y6ZAlC1NRaasd4Z9vWn4NKJX5w9x?=
 =?us-ascii?Q?VY88f12+Yu+mN1q7Bkf1mh0Wb6Oe9YFpsqk4QJecn5qq6xr8UxuaI12tg1b+?=
 =?us-ascii?Q?fsdxHs0gQj9UEyYiyyCCIJ5H0p81Y4zzdEIFOtR24lRe2w9egIIUFo5SX0Jk?=
 =?us-ascii?Q?wloEOOATgPDtQslsjhBQ/WevkLB3Lc6tx+yIqg/CCx9vIIt+juJz52l/in5W?=
 =?us-ascii?Q?g2oe6fvWV1JI1j09OvlEM9dg1Yr3UtnC1PypGzjUjXLIO5EIU9zymdCNHn8P?=
 =?us-ascii?Q?EydlPzcgj2eZ1D9Q89a0Ek+Z+J2kFl9zfbJ/0naQ/QyVh7h4PzrcLUkezMPi?=
 =?us-ascii?Q?2ZkY5iULstGApU/BOTRNngkldhW8Gj9Z4+VrjHDWizS3FdF9SSXE8G8n/XJo?=
 =?us-ascii?Q?TOftgfujQjAaCKK2kmgpcbHnn5cZxsc/8M6ZHft1F9oyXsHBjigcLLuzq4fU?=
 =?us-ascii?Q?0K8avkJPDbsacsCjMxgh+0U49yqAARNroiTdIoJrrBVnzWNvxP4fkbICKmfp?=
 =?us-ascii?Q?v9kYhOmVL31fnAyIP0hoAv3/2oFp4uzl3Z1dKIXT/MnLO4sUGCnSMkoS3uni?=
 =?us-ascii?Q?y3lTgozoDmsiS1U0IIx4adkp5PMVDhXtJwtO8MLX+KOTF12jn6o1uPzZjZJ0?=
 =?us-ascii?Q?QtjctrPxLOzGOwgBFUR43GXu3TfHBlNZxoMQjTW77nF01v5rb1aJwJXzsJlU?=
 =?us-ascii?Q?IXgesmOpTN6H87P9+5sNzAzwUysH/1W/ctYWyOFhb+RBCtlCGsIuR1CiWwNo?=
 =?us-ascii?Q?cE0cz2Hwu3yrzs92QxLSWrQ5rjE8vnUAusZayysH+MKa7Nkp11ubGkdHaqWA?=
 =?us-ascii?Q?GdR+JsMreyv8Go177nkpoC2HEwaQpSYXoC8DB6a8T62zOIiY58uMdfOb1z5o?=
 =?us-ascii?Q?p++HBYEB+pzdcElZwh2OsajQOmB8urcGpuh3RQfhT/O+gMvHIJG3/Uf0LNUq?=
 =?us-ascii?Q?9KDCQA+eB/2VLA97Uaylo1isZhkkXWnl9WU1JbOIfUXzW0BqL+QtqTv8eyzU?=
 =?us-ascii?Q?USzXDz0AnUQRrbveQ+bvJDtTnj+dGLocjhEJb9GsnpmNsTngkZ2ij8PYb7AV?=
 =?us-ascii?Q?whY0vNTiDYXKfVnvZa61zqMoent8X/Y4jSvyHPANNme8NjEo0UEnOHn3Kanh?=
 =?us-ascii?Q?HIuN4DUrlwZY64APOgrwccgy/6Z3iBlFFw5bFkrcSRL2TVNJPJ7GuAfBWlNC?=
 =?us-ascii?Q?Sip4hLTruyW4Dn/miCAhD5pH?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a7c9e8-7daa-4654-4a51-08d9618eba48
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 14:53:08.9954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VVi2Q2slMip9YAGoIawM09VotLpDMgJvt1vu6z2QVpnQWQszn0l16jgAFf4yTxebrSyvb7TRW9SouQ6SExHMMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that of_find_compatible_node has a weird calling convention in
which it calls of_node_put() on the "from" node argument, instead of
leaving that up to the caller. This comes from the fact that
of_find_compatible_node with a non-NULL "from" argument it only supposed
to be used as the iterator function of for_each_compatible_node(). OF
iterator functions call of_node_get on the next OF node and of_node_put()
on the previous one.

When of_find_compatible_node calls of_node_put, it actually never
expects the refcount to drop to zero, because the call is done under the
atomic devtree_lock context, and when the refcount drops to zero it
triggers a kobject and a sysfs file deletion, which assume blocking
context.

So any driver call to of_find_compatible_node is probably buggy because
an unexpected of_node_put() takes place.

What should be done is to use the of_get_compatible_child() function.

Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
Link: https://lore.kernel.org/netdev/20210814010139.kzryimmp4rizlznt@skbuf/
Suggested-by: Frank Rowand <frowand.list@gmail.com>
Suggested-by: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_mdio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 19aea8fb76f6..705d3900e43a 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -284,8 +284,7 @@ static int sja1105_mdiobus_base_tx_register(struct sja1105_private *priv,
 	struct mii_bus *bus;
 	int rc = 0;
 
-	np = of_find_compatible_node(mdio_node, NULL,
-				     "nxp,sja1110-base-tx-mdio");
+	np = of_get_compatible_child(mdio_node, "nxp,sja1110-base-tx-mdio");
 	if (!np)
 		return 0;
 
@@ -339,8 +338,7 @@ static int sja1105_mdiobus_base_t1_register(struct sja1105_private *priv,
 	struct mii_bus *bus;
 	int rc = 0;
 
-	np = of_find_compatible_node(mdio_node, NULL,
-				     "nxp,sja1110-base-t1-mdio");
+	np = of_get_compatible_child(mdio_node, "nxp,sja1110-base-t1-mdio");
 	if (!np)
 		return 0;
 
-- 
2.25.1

