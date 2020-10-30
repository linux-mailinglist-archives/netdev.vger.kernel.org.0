Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C2829FABB
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgJ3Btl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:41 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:30883
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbgJ3Btk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBRHIgKBV5lDg27Hu1LgqJyEHTFTKr4EFgigCttGooCvGlKcJKMhoy2AcU2/jyA+WgGujp7Wj1Uoyowfhzins2czhmHEe8yBwgetUwqrnwcWsj6LNRGLxbnqpl4At/j2HGDkJV4a3bJss/E6gCa7QpxkdjXuXzdJMsdx8G8WiUGzCtDR3h2v6gYAF2qfiBYGMippiYq/ojG0vWSD6++5/fY5q2PbchfC+C0Hb9i22ZWDIqbCtYxnkjNMlotqg3WfzXnuRBKPspggW544CagjQBAYFPvX+kWD1PPG76iOQeKQamQhVRRyammecgENUxztZlBGGwBBQpqvUKZLM9OsZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8Ow8XlFewIzp1wLogHbDgcFyd7uWurfpykhcxpZjJY=;
 b=hEwPQoBKGYILEDrbbGGPTxV+MSZ+NOkpo/h3N1QnEGEmSIGvxmLFD7q5vk/tRaEaGyA82bwYGqhnTwZ9ZpHt2ABh3NEK3CuE9JBmWPubgNsxmkkuDm/ko37MrWXliWOfRP7uESGsD/X8S5E+hCLT01+8AitNu3Zcam3mzsPCnfppYm7rQqI4O3mWBHpER7UbkqndwZF3nyzwLj9ER3/vjYn9kT0v2a7dsn3y6Q2i/YRvy2DI7MmsaX0Kp9L8WCMhOIMM1gv+UBNUEB7FmXEidk5beT2zfhS7f9JcEJEwfUzOktE2dWxtU2kB1JU/xDQpk2RcFm32eoWgkJkrQVUCLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8Ow8XlFewIzp1wLogHbDgcFyd7uWurfpykhcxpZjJY=;
 b=RTtOdV1rEwsnJ/dAXghhadc4A/VhzLt9GHnFnofeUyQxGrRNXiL0zahnKqzTXV8pumK7B4etuo0UHoVHFE6hXkX/IDJghP6Z6vrxYiQvSX4MQtdJvC2PfYU2Nq8YYXfcCDWQOy1nADGLLFQNid3KUvCKxOSV8b212Fcm1J+0XHM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:30 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net-next 03/12] net: dsa: trailer: don't allocate additional memory for padding/tagging
Date:   Fri, 30 Oct 2020 03:49:01 +0200
Message-Id: <20201030014910.2738809-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9edd79c9-a707-4c6a-3088-08d87c760ad6
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25090880618531C8A6C15117E0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IhTBl0tyioqUt1O118NhWDgQR+XEibVMqwtZR6ceEmh6abjBrBI0wnXeea+ZfUefEpZhK82uIMeo+SP9w966n7nJk8ljaAh5sIgY0+/qlc95WdlCYwuThy3z4T6E1SCyUU7GtjZc5V6VDUFeFZf17hbbKjMwKuhPSgSGxgLn0icC+eqaGGGxw/f8VAa0NO09vgLXIxGiyfwlEhMeWuOhcA9WNhlv+RZkAJr1/X16t6rTv9iwMtWtUT392/hkdfK14JWtmT9eMp1zwS6bfZNw5UQsC0ve4xgD+ttRN98BaFMNBCXBbN1PPOabTpD1UlTd701jvr+bRKx0sWFYhN+eSmuKrrSe8Ztpcd+FTwj7DI9tYxKaBf0V5g7nb7LCBpDD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Cg/HlTMEn1hQz1tJ2XtE62OOsOs/HLJoRLhNEwxAE55StXK/zeo5cUbe5g2S+ZNFyY7ox70TsTMdBSh1IjxGW6gait5Vf1PU4XS4bLek1wkVXjnrbtVdlJeXEWyMV6xBCJTYEDV8pLPWKJ1ylvt7bJTThVBVCnrT8odTZCWme/pyNsDmZ2qWG7Gx+eQ6fvj8I49b3ueznzhEowyEQMjoTGoPIvp1oMbRwhCVlTrCumuENKN4nzJCEdGNEyTaT9BkYMxSGGyXuOYI+fGX5hxpfzEgRkAY4THKqBUqaCqlH16GSKSrEzoj1XHuVuMWYc74ovfsKiJpuqaYGHwePXim/9klU6fB030qnveWynziRklJsXPXQdGSFbo107/R6yx96PKMojY2JqebGo0P8lCATVtmreNwfkdX8urYURf0aKpp1NYAfnO7fTWQRjnUkzfdSa6DYlyEhL3nWT6wZFwMOjigSppLQVnzHA37rInU2ba6qhGNjCO3PzkirfUn2joxHo0HxheZnXIBAtrW+zNjTzevLUC6qtQ1NnRe+y/jtzMA6J8hYNlSqglZWwhoI3RNiFWb91b8FcphDlxsbsgFglQnCry7ZuesR9Oa/uFX+O/kQ9vh9tfT4Z0taUWy6Rv4JhjItT3fibXKZ46jttyERQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9edd79c9-a707-4c6a-3088-08d87c760ad6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:30.4638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+b4jV76Q7n40uiBzP2NE/vWb4MbqX+oGyrWlRIQP7V8ka9yB277eB76WyuEdhI6bYiKhLdHxV7j/8Jx/8tt2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

The caller (dsa_slave_xmit) guarantees that the frame length is at least
ETH_ZLEN and that enough memory for tail tagging is available.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_trailer.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
index 3a1cc24a4f0a..5b97ede56a0f 100644
--- a/net/dsa/tag_trailer.c
+++ b/net/dsa/tag_trailer.c
@@ -13,42 +13,15 @@
 static struct sk_buff *trailer_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct sk_buff *nskb;
-	int padlen;
 	u8 *trailer;
 
-	/*
-	 * We have to make sure that the trailer ends up as the very
-	 * last 4 bytes of the packet.  This means that we have to pad
-	 * the packet to the minimum ethernet frame size, if necessary,
-	 * before adding the trailer.
-	 */
-	padlen = 0;
-	if (skb->len < 60)
-		padlen = 60 - skb->len;
-
-	nskb = alloc_skb(NET_IP_ALIGN + skb->len + padlen + 4, GFP_ATOMIC);
-	if (!nskb)
-		return NULL;
-	skb_reserve(nskb, NET_IP_ALIGN);
-
-	skb_reset_mac_header(nskb);
-	skb_set_network_header(nskb, skb_network_header(skb) - skb->head);
-	skb_set_transport_header(nskb, skb_transport_header(skb) - skb->head);
-	skb_copy_and_csum_dev(skb, skb_put(nskb, skb->len));
-	consume_skb(skb);
-
-	if (padlen) {
-		skb_put_zero(nskb, padlen);
-	}
-
-	trailer = skb_put(nskb, 4);
+	trailer = skb_put(skb, 4);
 	trailer[0] = 0x80;
 	trailer[1] = 1 << dp->index;
 	trailer[2] = 0x10;
 	trailer[3] = 0x00;
 
-	return nskb;
+	return skb;
 }
 
 static struct sk_buff *trailer_rcv(struct sk_buff *skb, struct net_device *dev,
-- 
2.25.1

