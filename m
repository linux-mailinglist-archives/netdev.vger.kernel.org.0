Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF1D62830F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 15:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbiKNOoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 09:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbiKNOoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 09:44:09 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60043.outbound.protection.outlook.com [40.107.6.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862F52EF20
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 06:43:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdPvcyAaYP6KXHWsPXNiFvHy03AfH+y5wMPnuKUIbc383nDz2BBKN0ogfVwH+XMeWt0bohwl4/ccXisU3Acjxn4daZ7WM1L0xHDQrWJleDuKJy1voT5CtrvyuQ330tNdtrHq7aCW+2NfDdIb9kLDYpMOjQdjv7o10ffp2Oq2yHekZD7Oy4StffD4UXIwx5V5nLZNL1LZ/n4Eiw3Qio21rMBByGZKjl2fZRvoH4iKJMGoUfy6E1o2RJM128N+tK5r7db64RmMUT82YLaFljeeER8biMi7UADRGfxjYgc4ExzYIqPrhN9+OqptrPpbOURI9+y2qaM5RAevCFCxjhMBVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COMTb3XXlvKwu444yJgjGMLiu9W8oP7EzQ02gHw4yPs=;
 b=ZMD/LW6zteiLvMav0Tvb2JYGiJlkCV9iCZUwWlz5IeYtAuGXMJLX8PBCJBoqwZ4NDJTJ0GANoj3EpyCiv5i6DWdoB8LkV+9mArBo5HaZPasv8lnTgwWxNYN+ixXAKrdL1fRZEN9tKAOHPD/cF/s3Iy7u/ittal1JW2FvNsMApr1b9fqwJKLYhjkHJtKobjzty9R/df5BY4Xs3w+1JwWvy6A1uQOIcblcAsGn0fBz40gsJY6E7qiHYOni4gxppVQdl/3AgkmrZ4zbbgGCfmO/ERGEh238+tcdJTso/Dd8g9JaApQaDsIgIuz6JK1P58e96COfH2GFlThjgVi2XgD8qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COMTb3XXlvKwu444yJgjGMLiu9W8oP7EzQ02gHw4yPs=;
 b=bpUAIyylsNL38cMork2T9UQIMGCSEeD6k5Z8D3wDeQIvJPih1sxQDWTxKp/0qXccjlgdJ7mFlDG32mg+XZ9hiC0WhJ4QZHIhL2IlHQK3nUlTRkaCr9ZtWdSo6+QL0MncvaMk0dHfGBNcIClym8CxdWvdff6tSAur4yDtLpicUTs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8720.eurprd04.prod.outlook.com (2603:10a6:102:21f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 14 Nov
 2022 14:43:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 14:43:08 +0000
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
Subject: [PATCH v2 net-next] net: linkwatch: only report IF_OPER_LOWERLAYERDOWN if iflink is actually down
Date:   Mon, 14 Nov 2022 16:42:56 +0200
Message-Id: <20221114144256.1908806-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0021.eurprd05.prod.outlook.com (2603:10a6:205::34)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8720:EE_
X-MS-Office365-Filtering-Correlation-Id: d0136b9b-1d04-459d-2321-08dac64e8bce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y5CuR0nbtVBVSpPKQwk20WbmnkbGncYViZs0ITMBMt+rdyhduA8+pqjfHw15Htrhj6eu0xBWvz+xL1eFTgW9w2cJcmxtTlEgQ4OWoTCDvzxThk2NEua4hC4N7Orh1pc/fBYejqCXtGoDu3A/OoGJUdJIdkwSAdyEV1Dj9Ca1ePIJlb6xGt2k2zollWF9Bd1iMIYXtcOm8rdV3XsDHyjiTDIOuhr2QGiIbgsEQMXX8IPNHYup6UTetDoCSYyUGlN8Q5qLrx8vXcAX9g8gEtwlp9fJ8wnoWndLPkFIpe74cd8gDMEAMbBkjjyKdW0I896q6oFIUEu0vM6ryrLu3qGCMJWPnciDfIFLsePXzr1FaEcWSt3/KbX37Vakz9Z/7FgxM/wd7q1xzIr93eSmAMwi9ay65IOL5WQQxiFbnKOBvZFB/E9tNkaUW/lr85afyAPI/mE3BaDo+9uAspRX2IV2vzxDQ8xWOJOhb069Fsyt3wlSRrAw7eQZFE1SUiLJ6WgGo2lr7O1iMW3dvkgRqom3N8+gggifm/gGhPNsPoQ4lsid7yLkIGnamP1pUn6eoU9hw1jADUpcF31tm+q+RTL1mKFrzUwWYT8SXbP9d2donCyURp6plmw0EIgAKB+HZIURp2W2ZfZR0SWX0RMhExA/svutkZCLuJnoCK/B/a44jTSYQ7w5zQDfS9F5LAoGxJRoeTiDLfBZY0LuuUL2vFk7IW38VvCuIReMZVrr6APikAq2bzUh4m6pfa/z3TToWC7gQqvRWY9W2cooeqtlb3QF7RRxISRNIfkeuJSiPXZOk6E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199015)(2906002)(8676002)(36756003)(66556008)(66946007)(86362001)(6916009)(316002)(54906003)(83380400001)(478600001)(966005)(6486002)(44832011)(5660300002)(41300700001)(8936002)(38100700002)(6512007)(52116002)(2616005)(1076003)(186003)(6506007)(26005)(4326008)(38350700002)(6666004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0VRmtXYrX0YwGoevPks43fW4gKpt6lZv82UHrLdGHLyvrGnPP49am+HM9uRE?=
 =?us-ascii?Q?af6OmZ3gR3NgeR0osA+cB8C9GDMTo8jLZfwiah4eHVFoE1fSCxwk9kCkTyKl?=
 =?us-ascii?Q?GzM9c6dN7mjgG/XQGbeTIgwLhEntACWft9SuxL+TwYq7Dvh2/NredpU3kKFZ?=
 =?us-ascii?Q?D+UhrbZebFYqMz6dk34ldzg7GZB8Y5wBUHam0stGGJu8UwOScahxH8FKbbnE?=
 =?us-ascii?Q?/U+4aF9aM52MhLZIifYFDSVhh8hwiwbauVMs9kHqL9YUMhyjjQTgmW3vdoL+?=
 =?us-ascii?Q?2s8IJG1WiLdEIh7kPt1WTAkBdF9dxGP3R3D9n/PCOJbG73jqka95QtiXOBm8?=
 =?us-ascii?Q?CIC7YKbY3JApOBA3KrwV4kfi4LMUnWM2f7HGnvQAShLb9hnxw132HLvJpnDA?=
 =?us-ascii?Q?NNSiIdMj5NzyCDomusB/hNppGK4Y50xBBUW8s8KzgB56vNBCW6MB3pyHPkzq?=
 =?us-ascii?Q?yKAmsj/syJJq6KZgfBXjgMLfsR0DNK1+oJsfqooJOW4+25KN88XHvlR9dQXu?=
 =?us-ascii?Q?PdWQWeG/c9xslSfoP7yH9P8t9FdZ4+hxyGWHYEoa55ROX+UFmvoZydBgmuMf?=
 =?us-ascii?Q?kJAQkHCwTKRhBXmfZ96j3Qq5D0Q0p97Xyo8q9dipu1OAcnCSsMQ17gs3LklP?=
 =?us-ascii?Q?bf1Nhcp8chQqO9Oacghs9Rgr7G/nqIeRbne5CvVcfKrTHgq/8Hlx1JsOwYFT?=
 =?us-ascii?Q?iGfrSAtJDrNJ+Jwy4N9QttkRB+bMY3vPbkO3HeJBK3mcR/3vYMsegcn0HApO?=
 =?us-ascii?Q?1imBfkhMMcVEfquEJHg7ijlGK7SLQzElJivcVUJJszSL2JPEr4q6sXU2tyny?=
 =?us-ascii?Q?vVhXLoEU7DfiFpuCO+RfnJyfQTffQCG3eeotk72Slijc5o5ZWANIpBDFj6a4?=
 =?us-ascii?Q?fL79m4GtzzGW0xSHVWFGAOqTK/GhhnX8Kkj+zNIhIfrBAL1pv2gikSkV/p0y?=
 =?us-ascii?Q?hGK5x2dtcGQqt+CdIlvJ7YF8vFaLAd5KO4eDvQkCNYhP0uyT0U+aHak9RXjl?=
 =?us-ascii?Q?hcq+Fk5rutkguvWie4z8/DSCmZhthLPAOzz/xXBvEVDmqSKvY330r5cdXINY?=
 =?us-ascii?Q?AGtVOMZFYNOryygBw7WCzkFmW6K1i253XVmaGkrDmHMsxox3XOr5V7hOiANX?=
 =?us-ascii?Q?TWD9ZCIdHF3tbVYektOvIslReTiWKeJods0HZvkeBDY8FIME/CHl5VDIDmPH?=
 =?us-ascii?Q?pqOXyMLl2NK3c4vbTWF7fi9qw9qtksmrSBYjm1LVv18xMOKw6uGBfXonoaUR?=
 =?us-ascii?Q?IL2XVtEhNHo3xYVy/JWU4jl6WldygkxPt1SFJeOf0qRHOSTGFzSszZsfEvqn?=
 =?us-ascii?Q?97y7UdomE7yTUU3IZyj6pAcmnl7DGbQzlqzafNKXBGYWizHrZR59fXqkJyYS?=
 =?us-ascii?Q?SGhxxDSv4IS7uZTjI6H771L8UqJSSRa7vqDKQOUYe/VoiMz6yqNM64gHixwH?=
 =?us-ascii?Q?SJFDx5jYot3Nd2a6UVAhaCn0XybvqAzabZUZ/CmmC3yEbjhDhRpkea1sOjlj?=
 =?us-ascii?Q?HJSVGRl/WtnU1rU4XUVgifN/5r0LPr5yscBhdEQor6wMNTYkDhbN0/iZKEOF?=
 =?us-ascii?Q?TirMoMxcuXa5TmFcCMsbNDFJ8vYiizSvoEwxpKbwg8/N1gYdjKJF/XAU5a/2?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0136b9b-1d04-459d-2321-08dac64e8bce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 14:43:08.3200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M79+4Zu/nfzYW1RjSnH7Yv70mf2Ne/NniBD+QTga0eJ5eilYV1Ki/GZ8m4KlP7E0UtrzGPsozqRsONa2pOEdew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8720
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
v1->v2: add comment according to Jakub's suggestion

v1 at:
https://lore.kernel.org/netdev/20220921220506.1817533-1-vladimir.oltean@nxp.com/T/#u

 net/core/link_watch.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index aa6cb1f90966..c469d1c4db5d 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -38,9 +38,23 @@ static unsigned char default_operstate(const struct net_device *dev)
 	if (netif_testing(dev))
 		return IF_OPER_TESTING;
 
-	if (!netif_carrier_ok(dev))
-		return (dev->ifindex != dev_get_iflink(dev) ?
-			IF_OPER_LOWERLAYERDOWN : IF_OPER_DOWN);
+	/* Some uppers (DSA) have additional sources for being down, so
+	 * first check whether lower is indeed the source of its down state.
+	 */
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

