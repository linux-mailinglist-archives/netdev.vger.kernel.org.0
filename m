Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8147763C21E
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbiK2OOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbiK2ONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:36 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2045.outbound.protection.outlook.com [40.107.14.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0D362E90;
        Tue, 29 Nov 2022 06:13:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQfCg052Fpy1gQmSyjWQW6JTI/ncWQQCKtizF+LTqQBUc5XE9Evmn//b1nxfDKOrPHXvRqyv5UqMGyxpkAKVl6PNHBm/RyQ4x4bjtofKxUvc7vMhm70rXotdRLQ8j6sKi2jg0HiTfoHMvYy6IznRDblbSDtf7Ln0weqvlRp9+wEIPpNlxWfb+iCTDfgM5kRmer6CUcwuStZY2TtSilv3AAblOrOp9rsg4O7ah9pPVU5RyuAuEUCkd9mDU5VSrvd7C2sKdc0SOP86pp2ips0HsW+I4V2d0+yHKcFuyiABURWCXfwTMae9dQnNXoyrTBfbrkxEjjmUQcCKqtpNzPKbVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgBNFRD0uInGu3S7+UlK0n5Nx04PgX4ka+VdUIF0XgA=;
 b=jPvjZRUXjIDLUyo+Z/ijURhhULbEbmeMqCW8IL2jyalP4Qf6DZZzjyEFbPdkun3iRt8ZbywDF3mQh3aaS7YlR0WB6VSNoepcFW9K/xFxoLYwWOh+XyAKa/Jwd6Iu6N2XXub02BZqdD3hcQx8yMXAOOFL8hrwGuPUv9IlkRZvTXknL1GzwQ7yXQyiP9AFBArkWslbevUl+gfJwClVu+aAwSkOVE9vD2AAd3gXaIpNIIefcb3v3lEhwbNOsEju0ejylRSXh5wTr478RZq7XTb838SW9dDgPfdbQfUtBHOl1shok49DYM3W+bepuA+7WxoDdnFL9yHDQ5huTdt22wwsIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgBNFRD0uInGu3S7+UlK0n5Nx04PgX4ka+VdUIF0XgA=;
 b=sZn4IicyjFGqix72QeKaIlxbvxAp0JVoo8k+zW/o8VXCLILVTk8f5hBz4PhEKnSujt990jyHc+mQ8dz2JGfDkCfnwo9Tw1JUKm4DBQk+pd54r/9MpFiSDyw0DpO5PBZOV9CsdP/DvxHEtKVOJGIhCPVIxGl4sFMOhWPcYvltRyA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/12] net: dpaa2: publish MAC stringset to ethtool -S even if MAC is missing
Date:   Tue, 29 Nov 2022 16:12:16 +0200
Message-Id: <20221129141221.872653-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 95de62ab-bdf7-41ac-f97e-08dad213c578
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TI/PN2v5j/+g1tu6wlnMkETuFUwNPnyB8hX4FMjtiyfLGIR5YRhKfa96fkB9Xxqn77PsweXlHmyN+2tfO/zCCvGOwTRJ/YG9kKskFAEr17YHauJ5UWJcoADnGC9qxRbih54pCb8OdSiiOAK/TKCtxe/M6k3aiCx3EFMcHoKp6qFKkD6vVJEcapIUxJErt6RVqF5tGMf1ycXutDBEuEHhKLfXWGYx9vkh+jsV6X6u6MHtTxrBjQXY24hCe+s9V1kycxDYafCqs4lFEasqHNwofIysVm7wPosPP24eoXgrfnz1ZZ/kbSLzwkAjX9mhYl9r3q1EmLa8e3HLw231KSk3eqNJt1/X3gz4OSNVUzkgclCQk//JxSjUk2qbA0qF1n9g7Y5F5/aXVWK0Lm8Gx8IyeJgdLe5LkN2wrWbXTuoXLq9FV8yNUL3GnA730QKb+X7oYw6BzU8RWyfoghpA9U7DnqegDC8RxftXBfQjmSzcSgYeJCYVZby87HwUJUHUtCmSWjnQCbEj3RYroe8te1PxY80MF1sTDLvUD3CHs5sowM0jKq7X6wdmtx/Ag+JhmDu7RFc37gO19fVenWii+JlSswUE2hFl6IDCBflx27kWyDZBnTwmX0wH39rjXXPCtIGS9qYBlpnHp7TPzZ5CYO1yIvxJHJwt746YRM4UjsjlcwmIunFg768GElafCCC7Awlv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OXFvv0FKD3fZAwa5gWYVwKbzkgohl2PDdsbaJuZOv3lkpFi+WfCxcIYIW+aP?=
 =?us-ascii?Q?aI+Dr9bthNYyZIAPSvm6o9P+lpg9LmeytlmjdxCFyEbCJMl+uZ3TpN6Dz8N7?=
 =?us-ascii?Q?XYEWJKebNyAbHIbqosah8KNdFNNLd6ZTAdP6Ew0rZtR/OvjpLSB16LdACIp3?=
 =?us-ascii?Q?BeyKD8cb7f4ER0Y7T2+xTjcZtxRCWFPvQot2AlZ9Wo9kRGGI3aC8/SgFs1vW?=
 =?us-ascii?Q?z47jqbctsu30Sz1aCytsmJnHGgIRaRPRO7OAY0a5xugS1zFyPa2IZAT1M67U?=
 =?us-ascii?Q?V78Q1BgiL4l0LHjxHdq0caiIkciDXaGSLqoNCvexv4TdCBelKY7BbfVntXAx?=
 =?us-ascii?Q?higitHdw6VZ4Lfi/CDGVCMxmu/wxBaZ6asG6ZCWKsXMz13yHbWuYxNjscq0v?=
 =?us-ascii?Q?2yXn+bOl8HtkgS2smMdycW9Pt4UbGXFlgtD/67sQtOquEqrLk/9AFzzXyioY?=
 =?us-ascii?Q?NAVdNpEwkqm7+JZp+CfvSU+B77ouqgYifdGtsz+ixxusIjjSv2V1wGyCdBz8?=
 =?us-ascii?Q?X5rp2f1zJqmRTAr7oxHe5Au85aPx1xLnJ8gqWz3ioSYp5CY/DMi+LOXJwLc5?=
 =?us-ascii?Q?DhE9Zso0PoM1fHgufalSCw7OntcA+E9paN8n9M/TpIhJOvtlaQIfLJXDLItA?=
 =?us-ascii?Q?jX8imCyvaRTJBQbmkRWqO3pMMls4UOrfBehkOnz0tcldeui7k+1lm2HBuStH?=
 =?us-ascii?Q?FuKb32Q7+HXUGvfQbiQ0jESqZMBIcNsUtGdapKmmc96RCdj/sLFFN2so3o9t?=
 =?us-ascii?Q?yR+L/3rvWWQWGqtsigjXjFXjgKcHtqDaWV7txcPOa7xzB2BDqLCScbCKorbK?=
 =?us-ascii?Q?0h/ObPM0PskkbF+JQo2rNaT87YBQJl4bOL8fb7KHQ6DcphZS4p7MI1ZBEKLx?=
 =?us-ascii?Q?uFVaBhmRzFCB6XdtfYQ5L+DefDf1AbKNKeiicpfRKm2HgS+Ab9H6cKfOeH5c?=
 =?us-ascii?Q?VRLekG3P/inFfySkzbNfartZZ0E9kCO1Dxi0F4wB+n2k0V3ftnUAD1f236Ic?=
 =?us-ascii?Q?tiq/c9gxN9VKW07O3uwaO/I5E6EnDpQxtg0QjAuE4Ng1QKLB7GwDRU528cYe?=
 =?us-ascii?Q?00W6U6Q2UqO7dZPvnGefPyghiWcHsFitKLt2HfeDQ0vghtP5Du44WCUN3drJ?=
 =?us-ascii?Q?Oi1Iqn1vlrD1rTZjdrv4j45W+6zBEky3RoIxwlzx/FhS0M2KBP4Q8mCare4d?=
 =?us-ascii?Q?qaY+ds754pSv/w1NGh3G9y8rMRM5YgVaLhLEoxAgdCIlsMdnuTtug0afgQVY?=
 =?us-ascii?Q?DCzVgTmAhU4E96cBRV61fUwLbsaxTURcqF59fY1SqXhd2iauUKTYEL6ZGibT?=
 =?us-ascii?Q?JIXKQf8n88y9567K+fbFE2bkjn2EqINtxqFZLWFQQbytlz2WFFj3xdvuTNKg?=
 =?us-ascii?Q?lPYd7XI/mCiR+wQwxqeQuSh4yRQl7XLn5UzIaqVvloNjZYkCfnYHfF8YyQUy?=
 =?us-ascii?Q?PTPTfbLdDUpsnE/YFOoNbW2Z2eTImwWEllAhgB2U+k/YuHltSnqRv+f9eL/8?=
 =?us-ascii?Q?oG2VT5iO1C9DO2bFs8SdJwR7r6/mIsKtHd3WnDwLt7btafeAJd3Z/suL82lM?=
 =?us-ascii?Q?UFaNGQKJ0t5jlpp+yxtw7B76INKBQ1jqklfxlmuLlkF4X29MvsTrA40NAySt?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95de62ab-bdf7-41ac-f97e-08dad213c578
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:38.7628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAems8mHZ7/uxL61ckyvlgE+D7pzIouzLPoFVWR4Z+y7lVQFNSpRhCgjeeFfVfB26VhSFh05JfeQrOEvPAPqsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPNIs and DPSW objects can connect and disconnect at runtime from DPMAC
objects on the same fsl-mc bus. The DPMAC object also holds "ethtool -S"
unstructured counters. Those counters are only shown for the entity
owning the netdev (DPNI, DPSW) if it's connected to a DPMAC.

The ethtool stringset code path is split into multiple callbacks, but
currently, connecting and disconnecting the DPMAC takes the rtnl_lock().
This blocks the entire ethtool code path from running, see
ethnl_default_doit() -> rtnl_lock() -> ops->prepare_data() ->
strset_prepare_data().

This is going to be a problem if we are going to no longer require
rtnl_lock() when connecting/disconnecting the DPMAC, because the DPMAC
could appear between ops->get_sset_count() and ops->get_strings().
If it appears out of the blue, we will provide a stringset into an array
that was dimensioned thinking the DPMAC wouldn't be there => array
accessed out of bounds.

There isn't really a good way to work around that, and I don't want to
put too much pressure on the ethtool framework by playing locking games.
Just make the DPMAC counters be always available. They'll be zeroes if
the DPNI or DPSW isn't connected to a DPMAC.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 12 +++---------
 .../ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c  | 11 ++---------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index ac3a7f2897be..bd87aa9ef686 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -185,7 +185,6 @@ static int dpaa2_eth_set_pauseparam(struct net_device *net_dev,
 static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 				  u8 *data)
 {
-	struct dpaa2_eth_priv *priv = netdev_priv(netdev);
 	u8 *p = data;
 	int i;
 
@@ -199,22 +198,17 @@ static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 			strscpy(p, dpaa2_ethtool_extras[i], ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
-		if (dpaa2_eth_has_mac(priv))
-			dpaa2_mac_get_strings(p);
+		dpaa2_mac_get_strings(p);
 		break;
 	}
 }
 
 static int dpaa2_eth_get_sset_count(struct net_device *net_dev, int sset)
 {
-	int num_ss_stats = DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS;
-	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-
 	switch (sset) {
 	case ETH_SS_STATS: /* ethtool_get_stats(), ethtool_get_drvinfo() */
-		if (dpaa2_eth_has_mac(priv))
-			num_ss_stats += dpaa2_mac_get_sset_count();
-		return num_ss_stats;
+		return DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS +
+		       dpaa2_mac_get_sset_count();
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
index 720c9230cab5..40ee57ef55be 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
@@ -145,14 +145,9 @@ dpaa2_switch_set_link_ksettings(struct net_device *netdev,
 static int
 dpaa2_switch_ethtool_get_sset_count(struct net_device *netdev, int sset)
 {
-	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
-	int num_ss_stats = DPAA2_SWITCH_NUM_COUNTERS;
-
 	switch (sset) {
 	case ETH_SS_STATS:
-		if (port_priv->mac)
-			num_ss_stats += dpaa2_mac_get_sset_count();
-		return num_ss_stats;
+		return DPAA2_SWITCH_NUM_COUNTERS + dpaa2_mac_get_sset_count();
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -161,7 +156,6 @@ dpaa2_switch_ethtool_get_sset_count(struct net_device *netdev, int sset)
 static void dpaa2_switch_ethtool_get_strings(struct net_device *netdev,
 					     u32 stringset, u8 *data)
 {
-	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	u8 *p = data;
 	int i;
 
@@ -172,8 +166,7 @@ static void dpaa2_switch_ethtool_get_strings(struct net_device *netdev,
 			       ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
-		if (port_priv->mac)
-			dpaa2_mac_get_strings(p);
+		dpaa2_mac_get_strings(p);
 		break;
 	}
 }
-- 
2.34.1

