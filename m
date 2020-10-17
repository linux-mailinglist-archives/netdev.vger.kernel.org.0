Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98E72914C1
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439624AbgJQVgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:36:47 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:7653
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439610AbgJQVgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fu+uDslonra4EiRNK0xETKqkN0QLDgFrtPLh/OHvx3fjRfp835fekQV4hCoDgbCmOG+LMYO8BeZMnit5axJwwUZITcZoIwhD1hGapC2D+z9YrbZZsPlN4wDvE5FW+hWUyuvnuWAkie5SJv+4jxpeKxQQ3++7O2n1bA1EGkXLa6bHF5I6n0qfqOEhdffAHXGDvYuFdhgrqFj1h6e0a2R6LA9LtHBSKUStN3wGNEYhy6rnBAbhz6CVlzhXtn2Yp0vKhLZAf+G78UA4aBhSoXJ28plVTHTLpGcEugDyNrzSP2ubvC/Th/f3HIlmE6LAy5UNgrub7lVdNZj/blcHwl4VmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7Z6qh0OvbSNaqX7X1zLwUcrDbPu3g2VKepi90Mdlw4=;
 b=KiWE2UUYTesFRey+UdDHVQLdvy1zrQbwDSJf0KB8LquHPaICgqxZFgGxDYrh77m57S6JRqz0f3GlJAyWiT+kO2+tXenPPBRxzcseccGs/g8cCCXApWE/jreVsnZ8FZ8WXw2Sr44jekidCCjpMW8P4uhW6WZ5BMs3O3wTjdvLQGjXWp08wuUPKNK8lruQkncnKaNw0qqhSkxOZyOCM6xVcHaYi19+VUwfPx3jbzWspj9js1obuztP5KwsgsWI5WorayMkO4Cqf8Hm9vJ9k3wCBPRYtHXi2059G7+bulz3XYkn7usBaqdc0nnX03V1lopQE1JUNNRqJssGfJ9uDpCUGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7Z6qh0OvbSNaqX7X1zLwUcrDbPu3g2VKepi90Mdlw4=;
 b=PNf3nhZVgG30r2qwycum86RUx0Uf7JLS+F5CW63k4l5GBB6L6zUlsFVM0hjs5jW9X08KVa+KVHEpCqKOTDHnPVhpNoz08G9XsKehqXCxOvo1gL5zdiCj/PtujY0wCDjbGNWuW14qy1Ej9byK+PGdEQLPNr+m36aFx90b6WLKOKM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:36 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 04/13] net: dsa: trailer: don't allocate additional memory for padding/tagging
Date:   Sun, 18 Oct 2020 00:36:02 +0300
Message-Id: <20201017213611.2557565-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: VI1P195CA0091.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d1955bc5-0138-4500-9f94-08d872e4b969
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB585453C958FDEEF9DDDA263BE0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YLhEmx+IgWXOsKowZ9R7vfrdU3CTrAPKLVdGb2RjUyCB0Q37oVRHZe0XQChr7RHJDVDACLOJgvvuEfbr05Pyn+orQ3gekXknINUk0mTvW8pwmhJYG40z5+kYIQKQW6Fu5+Gc2xFr5vGiCJQjwhxWxt1HYOxtqCLWkyr3RKrVn5m3Jvta4khQZJcg0ISqBQ1wZfKBLrw7qCw0aVZt4QV1WMeY/WQGjdnI4I3TZdSI46nrCaFstuIxZB0/chgi2csp1Vm79OgqsWRidTg21UfoKP5bA3LpM7yHL7F5Ws5gzSP7C3m13GIen4sZUZ19Zz4F6n0+qB/c7Sz8ljria+XQWGeEoR8Ax53v9eX+v2PMsLoqWRQhyo+289FaWUWA5I4y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DMTmchopb3eurwVWR67zEyZ4k8PlT3tBbxiatytvH4+Fju+BHgC3bfPnppwMTpyz6s37xSvMYVvh3F/6zk1ElKmsnNKp9fZXAobgEqvkb1mX7aDqWKfNHoW/7XQyZA+SFVOe0VC4ue0OBCFIni8KBIjSZ2zri4uWjz/T6Wq7XwxF69n9yHB7wEQfeFsqgX8v9M5bZXwK275S7JoJJNdqmw4STGxjqilNxmZoRyUeLcziTPsJfUiarLXg2RAq7s59yceHajeuyULhYW5o1O9qjF/sGf4GAweygZlKlYOIVnrB3lLupt+6GHNrN7NO5GYEXWgKlND3h7fQCICfi5b6cBcIt0jzHI0+MpGYCP+1BaACwRdDzDuIYOeFttZJi7Dw6lUHIrLlOHMvfX7gi1ocVwuaJg28CGXqsyLrWrjCm3cn097h859OuZ+7Ni5lWAUlhTnUzN4nLDn8Yd6W41gis7EPqurN+RCxyruazFgnzEboM2yT9wR+Bo54b+WQ6qXDzrY7xuXOp9D3dMmUDI3U2WF4G68r+7XtMkg5c1LZVm/PITvlaHUjv4jyZUr+vYSjUJEASJC9MtOVjHvucNSRB5H1Gu6ksF08ipAd543K1ws/SNVwhtSrWQaDnoI1evAsPw5TzPNAQOtSnknuyaQ33g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1955bc5-0138-4500-9f94-08d872e4b969
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:36.4150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J7rUqqeQQgackPHS8HQSfTp0fkzKtHuXYEYXoBtA4wDsJUuymitgoIeID85iPrWqufJMEwvNkl36hxh8bsfCWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

The caller (dsa_slave_xmit) guarantees that the frame length is at least
ETH_ZLEN and that enough memory for tail tagging is available.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

