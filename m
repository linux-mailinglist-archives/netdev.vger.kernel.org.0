Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F96C6D37DF
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjDBMic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjDBMiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:38:20 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE349746
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:38:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReblW3N9It9gol1ykJIlcfioZqASJmTmdRHIqi+rRxhszSf5Y8y1dl6MD1Wzox2htQoyXPvkGXdVjFdg7u0nQWT30ieswdwHtgqOBKK3KQO6A7pGBTunCaBH8UMuK4C2FXKBPBZXR3SILiB6W98YU2Iy05QbB4F1sEDeN0GvgBDQmaGkULTh+OWnpAzCQpXUmleiAjfXRqJqEz0bwKQfVVvT1an5MibJvxHTO9E+i/FbehNvlGwVw8B1k+ZqwyD4u5Vv+2rWnVI790YPmVama8h2R7OWpFTOcphWYgWZk+1GFlze8Eg9E5AlB4jMlaHIULQByHA9YMLPjJcZr3CUlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5i/joyYfYMmMLyMkHQ4rTnE3tBMEr+HaCBiNSVlW5I=;
 b=I7NeertU4RURbrC+YI2U2dQbRDwZBbqTLlS1lEWOAY4+JOxJg3TGGPhb8yadEf+7yNw4xZ7eh2DMAIjX4LMlMgMqm4Nw/6KJH4tbVXaV1F+b09cNdOJTMQmlKVzq9kLCjMjLAItdTe+sndaSdEdZVXDN/WECyAH1gypDHeIIDZ2FmuH/S94nTvwdOeMLhEqoAyZjaAdHqoH5cQbwFk7u/tVV/C6HwFtEb+8PDFQjXl8C+ysRf1Hsdrt4WMJ0IH8leczdAP9Y3nKc94KCQvCgCspKiXqyAz/v2XwQFMCMk8+ecwJz0Xg6swX9tRNCTvA/F/y7JJ3X0qTthk86T+3Spg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5i/joyYfYMmMLyMkHQ4rTnE3tBMEr+HaCBiNSVlW5I=;
 b=k6YqQFZaOWoHe1D/XpXF/t5FH5wUhau/7pkeiIwRNndug6lIeBwleKSRxHyqLHKTnb9ApraZzIdGQ+hWx+2Vrw4B2LQFQVqSkpuNfmw1xPZQnIN11coJEWG9hSLaIdzGXTM2ORuGsVprYKdX2DrpcxloYUCYgyK8QAvhzav4YLo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB10052.eurprd04.prod.outlook.com (2603:10a6:800:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sun, 2 Apr
 2023 12:38:13 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 12:38:13 +0000
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
Subject: [PATCH net-next 3/7] net: promote SIOCSHWTSTAMP and SIOCGHWTSTAMP ioctls to dedicated handlers
Date:   Sun,  2 Apr 2023 15:37:51 +0300
Message-Id: <20230402123755.2592507-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f4d2afba-717c-4f12-bf8d-08db33771edc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGTYVZ288te2qJJSmMaGzsXXnFxDZhgHHJc6iTqKYUm/GStsF1cGYGP4Ob0CFf7OqsEYZa8AdmyWDv0sg1NLMdEtXHUYdBLZNeSdsZeJk0AbIJdtcrv3+Vex5hR4cYNy3YLZxY5qUfToEVyId3YWl1zUXy46r0y8X4+ptGoS7mF52ZIDNFUNQpPcqgxIcV4LhH3viKd67OVlbHZFQuDtvE7Ouq8ghcuMN8M6ct5NNYXXtO2dilkrsMgVGZG6524QcEjEZKEqkS4MfvLsA6Lw9V34ABfuKmrdsqkXnSmUvHpr8LqviQ61yidHEj9GTgkYjmLw5/pJ2DA08M5c3Mwjep02ZHtsiA6ltFrIwThSh4aDlqilOMDqX9jcw81O9isDmL0U6GAZP59c0CcQvLav4zwiP7iOZzdZ6SK9vvbFcFCIIUDy+kQjf4thdXbk5FSXOM5vj12Aqlzmb9PuU/i+K/gOwwWSpEbzLaF+TbJjBlKipOkZfeS8yEfadNMF+v/VLtTBecVNSWGgW4Ggd5m+CDV99vcJRX7/Fx3v1Zork19XDTh9Gf0YAPNC2uWchdE+U+aNkJBSuN1vVIXG+i8SC575OetX0HGOUWxJQQum4I7voj+WMHGoNFVn6sxfhyg9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(451199021)(66476007)(86362001)(36756003)(83380400001)(52116002)(41300700001)(316002)(66946007)(54906003)(6486002)(4326008)(66556008)(6916009)(8676002)(478600001)(7416002)(5660300002)(44832011)(2906002)(38100700002)(38350700002)(186003)(6506007)(6666004)(1076003)(26005)(6512007)(2616005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OvvP4lBtmD3Pal/+Q2s92XMTeQxgbEshREZw9BGB49rT4ZbkbQLLG2a5C5gk?=
 =?us-ascii?Q?mjIJiFgEfbykqPvopekLM/FDz2x6uq8bV8F22c3BwR8ERCU06rKEOxQtWO/9?=
 =?us-ascii?Q?4zCLH3gluJ95TQUxaWtSy1MHvtVnxUbVo3fXZ3TTTdaBt2PuZsV78YWrwbhZ?=
 =?us-ascii?Q?5be2FxM4f9GXjLuzDjpET92LHHYLDvSjvsNc0owYx6RqstvXlOShK+ssz0pW?=
 =?us-ascii?Q?JnKM7+umEuiWHMevvHgdk26WUHKbQIDaycYhbV8WbcQb0jehojnuAjkgY4cF?=
 =?us-ascii?Q?t9w2RtrsqlvW8BpnKa8N/fgx1VCe5uIKv6I9JoVgNIAjFTLmHyBR/baBIm2u?=
 =?us-ascii?Q?T3xwfA6KEv8/uA62I4CYZhOXxZKmJomBHXavivJID6f2D7CqudBeK4QGatFz?=
 =?us-ascii?Q?GTRBHfa/9jAxtrfFjr27SRTwePLLNAT3Px7mU2e5Fuip4+XpAEEukrI85lb+?=
 =?us-ascii?Q?RA/BpNR3ELmPzWhqUZzWWT0S2oXO4qEGEqRHN/JOYZkQhv2qGHRqTJFEOa92?=
 =?us-ascii?Q?MEwvBQeqrBkzaZ4uShM78lnPjAigMgqenXZz3ZJG851SSCe0pJRJ54m9CfPl?=
 =?us-ascii?Q?8bt18pvHsitWB4hZ+ClfpTWPbi8KGiiDPjDfE4keypYSYfkOJ0MU4IpLvcXc?=
 =?us-ascii?Q?73udQBidWEB2jrDuF8v4+jknXkIc2imU0Wq0aFsQBV1J8c+sLA4E/+y2ntWF?=
 =?us-ascii?Q?SWqgbXld3JpInJVOLFS+CZdmMZJxKx6Rglvip9SICxYlYNwwJhdhD4J85y+3?=
 =?us-ascii?Q?H8PUyrDRvbL5MPxeLUFXYiQoF1BIBw5ckv8PSINEWviOoNitK1gfhOAxe7YI?=
 =?us-ascii?Q?WJ291i8bQoH+0DOLLm7/GHLXEdPUOtW4y3jWBzc47gbO9+wMiruB70vm66+A?=
 =?us-ascii?Q?WOEDVb+EoXUdsdwa4xGjfsnwDexIHsWHpcOdql1dugPts4tmTThkIUJIhYnS?=
 =?us-ascii?Q?HTd8rYVZnXBSmRNNBCZ2eiqpdDJiNoQ0HP42mSIymxTJpK1FM0bUCjJXydBW?=
 =?us-ascii?Q?tzA0AsUISdUj73xSAOqN1Vmc7RO3JFZhoSHNuemGVJJ+SCbfUP+bQ/Np0zIS?=
 =?us-ascii?Q?pGcG7Z7FWZgEOPWrFTGQdC0pdkO9A9B85zqnkARKL5hAriCbjeHVjugIU32U?=
 =?us-ascii?Q?WmR8PSJhmCZ+r/XVrlWggI61FnqcYWiNWo2cmDMP9vl8i0gyqpdCYkZwwxOs?=
 =?us-ascii?Q?a6cC805rFxAlh0/SCsxChM+SyQTdQhLzReGaqQ69JO2GCEg2pJj4YuO2eByz?=
 =?us-ascii?Q?/eZo6bAR9O3Aopqd9fEBy2nDWiVkVdT5Y6DE6ZwL7N1Su1Jc2Jy1oZqzrWUu?=
 =?us-ascii?Q?SAFJUbnmhTIUXTTF5JI46hPKbALpMmitXYEQ9eCDVJGyNzTOZ/P7Epu6ZkAS?=
 =?us-ascii?Q?uiz5WHQCdnevweMG5BUob23dyup1k6Ql2Mzwh4tiaJM5LdFVGJU8gwk3mu5k?=
 =?us-ascii?Q?o4HguqcM8Q5FQja81iC5sueOPEalcQxjZ/mWThNlin7+mHurMALi6xeqtTWg?=
 =?us-ascii?Q?lJxxznwKBRAqwAy0TPO8RwYPJfX9oBnXguF1LgtWtQCs2PBaODfH2S5GiF2A?=
 =?us-ascii?Q?Uvovw/aDpEwAiyqOPmCAQuCvMLciZTnELuzBDyjdg0Lwqm0tqjKhTsIBAFUu?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4d2afba-717c-4f12-bf8d-08db33771edc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 12:38:11.6870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLW7lDE4Lwt3Z+ToWvzDXfOHnlW01R8RtIwDUqQ+ZqhG6IpcvSCXsttlj6apyzkOSZQkVVELbyaP1Qv0t6JvCg==
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

DSA does not want to intercept all ioctls handled by dev_eth_ioctl(),
only SIOCSHWTSTAMP. This can be seen from commit f685e609a301 ("net:
dsa: Deny PTP on master if switch supports it"). However, the way in
which the dsa_ndo_eth_ioctl() is called would suggest otherwise.

Split the handling of SIOCSHWTSTAMP and SIOCGHWTSTAMP ioctls into
separate case statements of dev_ifsioc(), and make each one call its own
sub-function. This also removes the dsa_ndo_eth_ioctl() call from
dev_eth_ioctl(), which from now on exclusively handles PHY ioctls.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/dev_ioctl.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index b299fb23fcfa..3b1402f6897c 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -246,20 +246,34 @@ static int dev_eth_ioctl(struct net_device *dev,
 			 struct ifreq *ifr, unsigned int cmd)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (!ops->ndo_eth_ioctl)
+		return -EOPNOTSUPP;
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	return ops->ndo_eth_ioctl(dev, ifr, cmd);
+}
+
+static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
+{
+	return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
+}
+
+static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
+{
 	int err;
 
-	err = dsa_ndo_eth_ioctl(dev, ifr, cmd);
-	if (err != -EOPNOTSUPP)
+	err = net_hwtstamp_validate(ifr);
+	if (err)
 		return err;
 
-	if (ops->ndo_eth_ioctl) {
-		if (netif_device_present(dev))
-			err = ops->ndo_eth_ioctl(dev, ifr, cmd);
-		else
-			err = -ENODEV;
-	}
+	err = dsa_ndo_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
+	if (err != -EOPNOTSUPP)
+		return err;
 
-	return err;
+	return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
 }
 
 static int dev_siocbond(struct net_device *dev,
@@ -395,12 +409,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		return dev_siocdevprivate(dev, ifr, data, cmd);
 
 	case SIOCSHWTSTAMP:
-		err = net_hwtstamp_validate(ifr);
-		if (err)
-			return err;
-		fallthrough;
+		return dev_set_hwtstamp(dev, ifr);
 
 	case SIOCGHWTSTAMP:
+		return dev_get_hwtstamp(dev, ifr);
+
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
-- 
2.34.1

