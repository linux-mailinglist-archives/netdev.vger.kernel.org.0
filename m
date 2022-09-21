Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B135E5605
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiIUWF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiIUWFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:05:25 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65679E69C
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:05:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6KqPUQ7nC3Ue1WL75DsEjRLLsZT9+Z0bteEYEVwZEK8ozkpOkXSrqDXg9WAdM8wFoOHFZl1mfCEDj0bzKx44XfFH7aK9Ql8PqSPwHPPknwEtzG/1Dk3ETUnk2GzxSRHRxbCTnAzJu9oVQFcVaFvJk16ocNbQ1i4ByEJ/L6FtTKNrkynoDJa3cGAeZrfJ6G7rM+W6uQGfc7z256JDiljPLKpD+tc1RRGtZJDIQTc97+UScA7zv1otM6/NCgnsFn9n6ZKfdsDzmeKtnvdfSFvqQMdXeIk+n0xGAfx3QGRiUkFjcUWUdKVXHk+muTdpIb47S17KxMRrASzVVNYkpqesA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdYQPCzIan9tDYsP3FirQ6uOnMJVJEu6WihrqKha+fc=;
 b=C0DxufThGkJWaG0s1HW60XVdRSsmrOPYwK4Xy4BnX+F+410EuGwJ9Uj7iy+gcABz9S0t0gYz3I1kit0lxmSeu4jKle0SMrcUErgOKz37K/qzTXnRTARAp0eG47wcXJH7gtS90Dm3Yul24hmdcVjuw5rZRW97KQk7A6JnjpGBF5kKzv81GvHLMbSoanJ4dKL/1pDnUSIwmTcK2u6ENFzitJDjnkXMm4Xu84pSCFrteJTO687Jad4lCU+T37qUvHpaM8yH/HWburaIYNQifTuzrIaKaU1utBxc7KN7vBd2Ssv90WBZ6yDyb2Jj6eI6RNTkKrBUYWG69gtdkBToGNjoFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdYQPCzIan9tDYsP3FirQ6uOnMJVJEu6WihrqKha+fc=;
 b=N6/xwoFpNnLk3pCB4ekSI+w4NVG1gu6/zgaka5Zaa5EPduG3/f/gKPkF30xOS7LMcZzP4FNEfGZWwxfdy4ZhbJCopQ8XuIk/IU8P+SZieyTTtpAbu7fCV0GBdYLbminZSachF/1dl5W8JPUoNWPjxz51tDsA7zLsFJFOnp6oNxU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8379.eurprd04.prod.outlook.com (2603:10a6:10:241::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 22:05:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 22:05:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [RFC PATCH net-next] net: linkwatch: only report IF_OPER_LOWERLAYERDOWN if iflink is actually down
Date:   Thu, 22 Sep 2022 01:05:06 +0300
Message-Id: <20220921220506.1817533-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0313.eurprd06.prod.outlook.com
 (2603:10a6:20b:45b::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8379:EE_
X-MS-Office365-Filtering-Correlation-Id: 141ce7ff-d32a-49f1-d28e-08da9c1d5fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQBaUFcDrAPH7XOxnKOSgAqOy0Lkl+130dH1jZNxOfpmpadBl2W2PgO1QVuhJcvdDgTwiItlpFmSXP17xlIyRNBq/0vtQDGQVo7d1YZ3S84KlGT4V9CAR9MoKoynS/T+kDqAYlrMLY2015GFMUIb7KiGW2fMopXcJ23Ousoo804XgfF9QVWwR50fl9jlGb4xrc0m30B5WmZfMGoemyzaUGZk0d+phH9PxkC8ybe8yXBbtapheHb4oXEnRrUZGNwEOOs4CPKltqx+kAclf+OfxTD4H1DJ6CTw3AvYvfIwS0JX+z5mER3omku3604rkvwUSa29CeTT8gzsD5T9AHSS5PnCoH+P3UfL7aZewaA8ZIPWpVCkFHg3qtbBNjqRgFAiqTjFhdSA6IBC/ebU7/XD0x9f4b54F23cwLDzQ0FrumGK1xUqVIv4WCu6Ahmq3GyNwZ1KlktaeKIIKExaXv32ihqQJC+WIanvbtSCs3YemL2csQe75hT4OnVBFsnbz9m/jVGKT79RQhdUbDqZDTdl7AXYZGtrTyAtYt/0kEfZsv6rKN9mnDAVAG1IUpTvbggXw79zaGspD4DtzzKORNZGMj1OP3SSo1fYBd3yvmjJDd/4TTyioTipdYvmykifsZtm5sDG5SbcPuFhdDsPVWPAWgNbi7Hcqt8fFzvhAfnOE9n5fl7NATJ3aj2egI+2exn1qUeigUjbhRimT8gfBJhFHK0uMzhTVFcPooCxNFbPSHhr8oo7rOGJVKLc3gii46ZPs3viILJ6znv/JN0I/p8ZVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199015)(44832011)(186003)(36756003)(6916009)(8936002)(54906003)(66946007)(66556008)(66476007)(316002)(4326008)(8676002)(86362001)(5660300002)(2616005)(41300700001)(83380400001)(6486002)(6666004)(6506007)(478600001)(1076003)(38350700002)(38100700002)(6512007)(52116002)(26005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7G8lrLTHxVRjt5jt/NFgFuMwgKIGnIBQtrj61O9GJEnw/KGhwNJw08HsYkpI?=
 =?us-ascii?Q?qqtRQM9KSTKuPGb9XrYyoVJ+b3Gln1OXK/ESx/sCOFOUssoHv+cnIluBpYLy?=
 =?us-ascii?Q?7NRIvkNL/NQn0yt0L/LEafmjBqgIZZcesXevEBvopDWQkYKUqcVE1SK2U/5c?=
 =?us-ascii?Q?o+re+ZacTKtzIaXlahPgt37In5DpQbOb/mk7VmolRgZ83Yxcj9W3fgAqgInd?=
 =?us-ascii?Q?k4buSaGRh9YBo0kxPwHzjQ7rM+Jvkbm2FST9+68XWE3yencQEl4A35KdrNkJ?=
 =?us-ascii?Q?DBxCS0CBY0QdjAn2rxZUQFMLaFKNuzpRIkMMXr1RAPca2pVkOvc+hSvBa4Eg?=
 =?us-ascii?Q?B8DRJYyl3QXdq+UqOLw4v2+OljL+cpZaqMWwfznSJ3Gl2P4tpnp4EhSuY4uO?=
 =?us-ascii?Q?MnQsHvrVzzqQIS5lTMZuZbHTIw9E4yvdrvqupXci+j8x92n3wcuZWGaNnwlw?=
 =?us-ascii?Q?XIEBRHFEeMUVk7ba3tIMls2lCSnJ++HoE1j93hRG26XUhwtXDq+lHn51mTVj?=
 =?us-ascii?Q?xfXGhA3SInNYczF0vUmPP417KKWeO4xrl6kjhWCzSvJXUH5uLwatEAUDg206?=
 =?us-ascii?Q?CuPFusRdUMrvavutZVupmturSJoMBd6kh3tSgjZiLaOh4bl7kRQbWZXmiSro?=
 =?us-ascii?Q?UXiW+2ZjESh6XZ43J3nkCEqwJcHcXb68OPuy7KaOAo08kndTs5rxuPSZ2tE9?=
 =?us-ascii?Q?raYoyYgXHarZkSbd3HybsFrYvnJziSrpgwIrSkio+TerReZs7TL1Ftx+pHnc?=
 =?us-ascii?Q?HHjFGU7SJxRsK9iPi8u6Y6AmCGEEtUp0tJSRwHVESsxxeBJdL+E+sycyXZE9?=
 =?us-ascii?Q?Co0kGmcOcFgAYY2RTTMHCXz4FL9Mi7KDDz+hdHJJyyXNRGtrrzYucuF797br?=
 =?us-ascii?Q?5W62GJ+zLHwkaEYXhaPPrfMG0v44z0YQuDnIafma0aKMav9eWfMXH0jmV7y/?=
 =?us-ascii?Q?cWtMc0AUshjifvtks2lrE0wSNDjI3s1Pm836VZLDCrGrgmuoP6pKla/rJ+/X?=
 =?us-ascii?Q?JX9DEJLfFQFcJd07sNurcS08QHU6hYCeIbF/V5XChr+X88QICiWc94bBBs9N?=
 =?us-ascii?Q?oX8OqtdmF5ogbau36sg3YVaLXkdUNT6CYamGVxeC/8WpIedx3Y4C8uvY+6V7?=
 =?us-ascii?Q?9JOdv5b8SWYU1YsvYlJnMr/rOtDPfOl6uwzWDc96OBvl8bxcIMLbYB8GPVL0?=
 =?us-ascii?Q?1vy0zriZkf3NkoKW3qbmi+kczZpvQ3KGcJFb3fDa8GTPaHyOVpF0h4MwXx+s?=
 =?us-ascii?Q?cGczM6XFeTBuRcmFV2i2IKFD12gB2EY63PQiQdrm/qBsuoqOplH196SFlZwk?=
 =?us-ascii?Q?df7slxkPSiuApc+a8D234bCZyBr6eRGWQOv0NGJOiQqCMFk92rEsDsgw7qxn?=
 =?us-ascii?Q?MJX4GGlIn4UgzHnO72AHYyAccmpUqm1WhBrr8/1wQzM9YVcR9Gk/Tna8BxeH?=
 =?us-ascii?Q?HFoKQz1X8XxJwNm/5pjOe87gjZh99r6JBXscz4EIol0Bk9Nnog+VByKucnDf?=
 =?us-ascii?Q?EOOS6uHTELVY7zkhRMtnRw3OdLyoShkZ++OmkUy3Ez1VtpvpZP+2Mu8p5eg9?=
 =?us-ascii?Q?gs+h9cPCefvU0/BvWROOjKWI22Y3NgufsN0rmbMIsCBdzOjhSbd5VIiVlMdQ?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 141ce7ff-d32a-49f1-d28e-08da9c1d5fb0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 22:05:20.2410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YC7oiqFZ3iBbeVXVHQxOzj7/qCUEWptpP2tbLTEftJY7ix+kfaZWudHLOSwg/YF8HHeQ6N4WZC9Mg/hDsqobw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8379
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 2863 says:

   The lowerLayerDown state is also a refinement on the down state.
   This new state indicates that this interface runs "on top of" one or
   more other interfaces (see ifStackTable) and that this interface is
   down specifically because one or more of these lower-layer interfaces
   are down.

DSA interfaces are virtual network devices, stacked on top of the DSA
master, but they have a physical MAC, with a PHY that reports a real
link status.

But since DSA (perhaps improperly) uses an iflink to describe the
relationship to its master since commit c084080151e1 ("dsa: set ->iflink
on slave interfaces to the ifindex of the parent"), default_operstate()
will misinterpret this to mean that every time the carrier of a DSA
interface is not ok, it is because of the master being not ok.

In fact, since commit c0a8a9c27493 ("net: dsa: automatically bring user
ports down when master goes down"), DSA cannot even in theory be in the
lowerLayerDown state, because it just calls dev_close_many(), thereby
going down, when the master goes down.

We could revert the commit that creates an iflink between a DSA user
port and its master, especially since now we have an alternative
IFLA_DSA_MASTER which has less side effects. But there may be tooling in
use which relies on the iflink, which has existed since 2009.

We could also probably do something local within DSA to overwrite what
rfc2863_policy() did, in a way similar to hsr_set_operstate(), but this
seems like a hack.

What seems appropriate is to follow the iflink, and check the carrier
status of that interface as well. If that's down too, yes, keep
reporting lowerLayerDown, otherwise just down.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/link_watch.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index aa6cb1f90966..ae70786da9d2 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -38,9 +38,20 @@ static unsigned char default_operstate(const struct net_device *dev)
 	if (netif_testing(dev))
 		return IF_OPER_TESTING;
 
-	if (!netif_carrier_ok(dev))
-		return (dev->ifindex != dev_get_iflink(dev) ?
-			IF_OPER_LOWERLAYERDOWN : IF_OPER_DOWN);
+	if (!netif_carrier_ok(dev)) {
+		int iflink = dev_get_iflink(dev);
+		struct net_device *peer;
+
+		if (iflink == dev->ifindex)
+			return IF_OPER_DOWN;
+
+		peer = __dev_get_by_index(dev_net(dev), iflink);
+		if (!peer)
+			return IF_OPER_DOWN;
+
+		return netif_carrier_ok(peer) ? IF_OPER_DOWN :
+						IF_OPER_LOWERLAYERDOWN;
+	}
 
 	if (netif_dormant(dev))
 		return IF_OPER_DORMANT;
-- 
2.34.1

