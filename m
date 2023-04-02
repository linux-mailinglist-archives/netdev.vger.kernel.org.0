Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E9C6D37DB
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjDBMiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDBMiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:38:17 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6640086B8
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:38:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMIyynHcK0D563kiCT6n/mESpn4eJjOelU2kov7Bmb0/gZKXrOw1fsg6FGaOxSs17kUme+/j8OOVBQatGc5mySvH2JcCQ21UnYMm+aRtxMPbgYhVKx5iTozfaWiQKKsyPtYSWQWijvkN3g1N1k2owiEz8A3KmI2KloON/4wn0tDfkCWLEl9Eq1uWx5nP7dSbxLTWcClwo+uiY+g4oe/JPIamAB7k9ZzBHvTE0BhGCqRGlKbFIw6gSHbTggFNF3x+Vv4hocxQ4faF0MNFA3U2b9xoUPw9idl2RYahwMfCz83CkvM34iFiierpI3zCUJXzPnpD16YmyefpKLiosf0EEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoRCkb0kid4Kj6peG5F9uhXdZtDhjurvqFoezPM0DU4=;
 b=CaowlHR24hHHuIXyXFrA5xO33A63roT1hFbw0A0IZxxTomlTqQE/0maRN9LRJ1C225L2Xgp7QaNKNEg5v+Pwl2hzpWPu13QHCO3phqGp/iak3nImau25GCrOG5Gxw49U/inyD+5nyFQn86piHZiVbLSSUuTMbPzjqflh6TROCo2LkOswv3xOdSEoQzirKdaCFu9tOKkDlUq+D0xndnjKEBJXO2Voif9m/zahB+FR9vcXlXVGOqfaBvG6oE7kMa94psAV5XccAUDxxzRkP7ZW536GVMEND4NSsC+X9C1T8mXQbhCj1q73arJkrNjBXypun9Rfcxl/XZY6LWOnli/O9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoRCkb0kid4Kj6peG5F9uhXdZtDhjurvqFoezPM0DU4=;
 b=Q4YRU+cPpDSTXJVu9hQ379JeJJ9akbV1JMq7gXuOnEL1pl8hPoM758HYoc8siecv22H5x2y8UxrPmPNwTvsrrU7eMI1qtGuWz5bRuV83pbrmlgNjfc5WktpQMo7YeSeCz5AncXokk1ERUzDuMW8ehPJvl7QFxXh34gYAf/IMWbU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB10052.eurprd04.prod.outlook.com (2603:10a6:800:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sun, 2 Apr
 2023 12:38:12 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 12:38:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net-next 1/7] net: don't abuse "default" case for unknown ioctl in dev_ifsioc()
Date:   Sun,  2 Apr 2023 15:37:49 +0300
Message-Id: <20230402123755.2592507-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB10052:EE_
X-MS-Office365-Filtering-Correlation-Id: 283b73e8-8c9c-4204-941b-08db33771dca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QbkmKZDBU4NHY6E2VC6jXzmFHeK9vWJMSaYsHa8EWV5k8maU5r7+ir6erQATEQZ5t1KV50zSewwwQsLLZqbgHRxpPFatLZkVXeQ5xAzkk/sSrfOMkzO39yZ4czbELKHSBFIAhmX+WgII74S5FGV69GPVO1RuFEJpg5p4A2Sb6xT8Et4xqBW8sielt/MF5/VLtqIPR5Ku7TanA9ZX94o8w8wEjGr3lgKRfFGnBa/RE4gKGkjzK0NmAMeFRZOEYMGsMD1nbJn0fq4aymdGcwgIlTlmWi66rKdTVGFqi11GINPkpfmDBCsQRnYXDFGTsxrBqkHaJFPPjlAUOQ0iIDF46KTDNE5YYAuxAAJ92rvvTbKOoEksXKBhCzNju3+cGR888eh02MrE69X9DVNQzdm94gB2MeQxDVNjGPlE7jeDsFS02VrLfSKn+wxBuk07EiaPuRX8WbS+uDcb7ip0oCfRgTX5Y5mevQbQyDRP/Qs4jaZzyIaRTn4SojkaIAIvP3tvAeI9pDh1Jwsre/DWDm0cYeMK4YZQ2bGV8nnKdGYUu9/FMI38antjybv9BiPOrq5ng2wDC5Tb8n3c7zVN7Tq7NKoCkBvpeDgCaE+XXoLQUfxKgQchRGcy0Y276GGZlQQG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(451199021)(66476007)(86362001)(36756003)(83380400001)(52116002)(41300700001)(316002)(66946007)(54906003)(6486002)(4326008)(66556008)(6916009)(8676002)(478600001)(7416002)(5660300002)(44832011)(2906002)(38100700002)(38350700002)(186003)(6506007)(6666004)(1076003)(26005)(6512007)(2616005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SKxrg+93DfWK3dK3jnfPgOfoNmTJkBPBZDDhvsP309wto6g0ZY+zz+dg73jU?=
 =?us-ascii?Q?x/6lYrGSiuGTFdxz351rbJ9p7N832lVoI9Z53odFYVwNcQk/TS0ym2IpDY0Z?=
 =?us-ascii?Q?GnR4UCGjT7m/3FG2D4uvV1bNe6jlUTadDkCt+6j9Ku6j0DkL7uLmpb8ATlNR?=
 =?us-ascii?Q?4I4YcGSrO/7nEgHPxHLcR73HJ4EGc1L+Qou/rjXQ74Ci6JvQ5MhCEhj/wFUi?=
 =?us-ascii?Q?TJajL+l51aeTjGWc2k31ix6VAgLJb4MHJggj4Fyw+2Ns19trmSb/aGwmxJxQ?=
 =?us-ascii?Q?XAoIorgF4UZEoOcc3VPB2ak3qxPmpzTZM3+b8VY9wfWxAlDcpHNL1AWzPXvv?=
 =?us-ascii?Q?QjAnzaG18Dw6fYfY91uDDnvCOrLMpKjuE1gAmaRcPltqHJ6rXuVdCnn1vM8I?=
 =?us-ascii?Q?V0zQEiUwkHua1TGV/AFY0VbwF/JiCF7RQ6W8+s7HFtqkSHud6at8WvAhYjoB?=
 =?us-ascii?Q?nyIshfcj2h+ZjntfbtsdbZLXpvWZpn5NXPyYi8sk4FWpJZ4fJUqFEUY1ONZC?=
 =?us-ascii?Q?AtHMEBsnF0/zt+Ph0A8CXSOKZiEPhKo1IUG/fQvu139+CYqkBdxQyxHvUJqq?=
 =?us-ascii?Q?VqBv3AiiLEi6YpNuLr62b/5NR8VuvjkS9U30FQB3LKM11nrJGU+rT/waE/gJ?=
 =?us-ascii?Q?t5PXxHqDr2Q7H1KzCNcHGU1rCNBLYxhJgwOndLmvnB8lYi+j8HWWBAUBP9rM?=
 =?us-ascii?Q?Ek7qKK4jMbDPdD7WbYkGgj8rx49aIIlLVzKToGDh3iqR3+H8npn3ThPEMQF0?=
 =?us-ascii?Q?Hr9TvZUDdY+cxxbRrXJb5zNXGeeKlV8dVL623Cu+sZuPEV8d7b5FnsX8clna?=
 =?us-ascii?Q?RYdtUzQZNuGUgNwbXsaUAmz/MCBvCYLHjQdGFFSqIqgVQtd4ftmPrJvxVBlw?=
 =?us-ascii?Q?01nXdOSdoN2NwiuTBY7JgSC2poTM5ybFTHT/hb9ntGrrVhucIbTVJLDfD5ps?=
 =?us-ascii?Q?CCpkVdtnn5zkqwdHY9enpUmxuHz74jCf4KFHi1cjWHaOHugDX8Kn8wMNwd3S?=
 =?us-ascii?Q?N5dEfGUghY3fhu0krqzTHAy9Vkjlq0xl2sWfZUKwdRjBizpgRccCKqIiTNFP?=
 =?us-ascii?Q?4HB8ZSQjMNUs+8f8jJX4JrsPyvoLWnY/ES390O1OYT6soB6Y5vSjrf01Q3ig?=
 =?us-ascii?Q?G1PhN/9ixZ/l7Err0NkJScl1sK7YZWGNKQqu0LQbgDWFLYuV6+aHndbwRTVc?=
 =?us-ascii?Q?I+yJXft+U5mUGb7NRbHFzst6G7m2URSibsXvZLLH5sb/1AgUO7wtUTN3rUBp?=
 =?us-ascii?Q?KP9VcHLU0vuPYt5Vz7jQMMWZGl7rDYLsPttoAXycicAKZyS9NnFkWjA1MT/H?=
 =?us-ascii?Q?bEVLIAE+qYmiVQwTASLndl4ofXXYOZDg/BRVvfRsJgVR/xM+ARd5Xu3dudzk?=
 =?us-ascii?Q?LgdAnwwZ5wPOccaUPRQRH40OzX4TsQdB0VDG5qAu2XGp9bg86q6dFYKqKeOb?=
 =?us-ascii?Q?Q21cWW7ndPsaxq0JBLvi3hxsmiSlzO5KOnvCG3L3zdLNrY1npbFvqBD0SBGA?=
 =?us-ascii?Q?mlPGkkCh6Bd1AggrqWA6RIBPozNT+YLkW13g+Em3ruvMfOsZhZnCQhdsMQuT?=
 =?us-ascii?Q?u3Dz5oLyBuLsjG3TV4HxRLVjeZxmjenn1ZC6UKXDrrftePKTBIv794/bPOfP?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 283b73e8-8c9c-4204-941b-08db33771dca
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 12:38:09.8966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kx0H86PQRu7EHIU5s9tv4PyUKPgPQ9tdbi1SJJsqNI74guZzgx+kMzM06ehtQaO87t7szMwDQHPwRNJIVn3pcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB10052
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "switch (cmd)" block from dev_ifsioc() gained a bit too much
unnecessary manual handling of "cmd" in the "default" case, starting
with the private ioctls.

Clean that up by using the "ellipsis" gcc extension, adding separate
cases for the rest of the ioctls, and letting the default case only
return -EINVAL.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/dev_ioctl.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 846669426236..1c0256ea522f 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -391,36 +391,32 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		rtnl_lock();
 		return err;
 
+	case SIOCDEVPRIVATE ... SIOCDEVPRIVATE + 15:
+		return dev_siocdevprivate(dev, ifr, data, cmd);
+
 	case SIOCSHWTSTAMP:
 		err = net_hwtstamp_validate(ifr);
 		if (err)
 			return err;
 		fallthrough;
 
-	/*
-	 *	Unknown or private ioctl
-	 */
-	default:
-		if (cmd >= SIOCDEVPRIVATE &&
-		    cmd <= SIOCDEVPRIVATE + 15)
-			return dev_siocdevprivate(dev, ifr, data, cmd);
-
-		if (cmd == SIOCGMIIPHY ||
-		    cmd == SIOCGMIIREG ||
-		    cmd == SIOCSMIIREG ||
-		    cmd == SIOCSHWTSTAMP ||
-		    cmd == SIOCGHWTSTAMP) {
-			err = dev_eth_ioctl(dev, ifr, cmd);
-		} else if (cmd == SIOCBONDENSLAVE ||
-		    cmd == SIOCBONDRELEASE ||
-		    cmd == SIOCBONDSETHWADDR ||
-		    cmd == SIOCBONDSLAVEINFOQUERY ||
-		    cmd == SIOCBONDINFOQUERY ||
-		    cmd == SIOCBONDCHANGEACTIVE) {
-			err = dev_siocbond(dev, ifr, cmd);
-		} else
-			err = -EINVAL;
+	case SIOCGHWTSTAMP:
+	case SIOCGMIIPHY:
+	case SIOCGMIIREG:
+	case SIOCSMIIREG:
+		return dev_eth_ioctl(dev, ifr, cmd);
+
+	case SIOCBONDENSLAVE:
+	case SIOCBONDRELEASE:
+	case SIOCBONDSETHWADDR:
+	case SIOCBONDSLAVEINFOQUERY:
+	case SIOCBONDINFOQUERY:
+	case SIOCBONDCHANGEACTIVE:
+		return dev_siocbond(dev, ifr, cmd);
 
+	/* Unknown ioctl */
+	default:
+		err = -EINVAL;
 	}
 	return err;
 }
-- 
2.34.1

