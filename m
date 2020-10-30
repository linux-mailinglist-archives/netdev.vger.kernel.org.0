Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5533C29FAC3
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgJ3Btz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:55 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:45367
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726242AbgJ3Bts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEekqgNQttQcsW1+CM9RPjOxg7pzLex4Dapwe5KuTQ5St/PVKB0S4A6Tl/tTUYHa+SRhrwwBYq6IXPEBppFoTzeJos6ejl+HTvZD3AnDubduy/2Q5FdXeNkhtRb9ehoalc9P9IJtarlJxvsRsjfydQ0/jz3yMjyaQPuO2cj5Q6xk4hDJABzB0MZSDzwYTwNCUprGxecTyIv3vqbSe8CgJgag+LSVYXukGMzRijInMlIfZzaAzFAb4e1gLQj7sIJCnDWOBHQDMOhUrxTv24jHliDtZfy5+HGBbiGoCXzmY783kufD/gW+81wXLTf+gEEYna98QAwEBIYg9LisK7lnLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IVXjCw9L2tJ1NXFaDmtYENM4MK274hrmlyMCaAk7fI=;
 b=IWAk5l3vTBTRmMJy9cJcu/mRkF+psDzpV0mN0MOl4WZaiYwPO9skyBmSxncecqR5DjZvSbG8CWpl63qEoZrHYnywgffuM14/10kyWhNhZ94COiEp1uUg1Qr4toYi38Ur9cV1HGDC4GqJBYizYZGPDSuJ2Igpyl+/3jvF4bDJWvbCTiIGDrHkGscovrcZ4AHM3Pip0f9MXQ7t6nrUxtdtHD3D2Jd5ZAigCNUUsEF7hRR2n/V/8EddDn9VqHXT+3kB+4QkWN61n9n1aTeZBW1GQbfpVV7heXS2aTfXM2ueW7KQh/rHrtWNZ1aeNkyOZtajOupPPHEJervBMRmD/aU0EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IVXjCw9L2tJ1NXFaDmtYENM4MK274hrmlyMCaAk7fI=;
 b=aPCxNg7N0BYufDFE7GkBe8cdNtBOz70S5n4416Qu2i9JCcNDuqcOhMsJbQj7f6MQ77zGF2Gy/P8WjwCEHg33gqsiGQdiuX+mLX2An+vEvLwPJ4YOdxBwxJhjZBg3MgWR90hp/m6F6U1WFIEVOhNCSCY1fhg9eLvFby2kWt4oh7M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:37 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net-next 10/12] net: dsa: tag_dsa: let DSA core deal with TX reallocation
Date:   Fri, 30 Oct 2020 03:49:08 +0200
Message-Id: <20201030014910.2738809-11-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eff3ef42-8dce-4834-bfb1-08d87c760f1b
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB250915DC10EBBF51249A2F7DE0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k18vLpctPQxRfzYu/W8Z/ZW9GfpTj5emIFkDYHIUvb6H6R2fZoT3J83G+LY0n1pjvW+ywpfuB5G2zJZwt7DS060GDFmeQBiuMNpnHLU2jPHFXSaqfdf92MJb0YLTDjb76wwOTGZWWexTqI/ax1gpJLbRCdoaWvF1PNU8qcqCLzUEhROZqaNLvRM4UZbEMUxvPQzup1THy5fLH8lB3S04fKEeuKbaa/RkPirDXpw7A9zWhRU2laDVyirfj1YtRGexkgyoAtBZorN9PSbzn8Tuqd1uzwzlzQ6BMNpTAT6QZR3HJ8tT90eZlMiaFJj+R1tgxmZQShVhYAm0SXxsnvl4SJcB5xDblWf0gY6D/anUhNubk+OWOiHaA8BsMQrT8ygB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tSe86Hox/AytdEzVZA5/jmvLo8Qf0D9UO2JdKiOtkGXcY8hAlFJ/k7Yf3NxYcwOrmvfmzS/AmQZyqHRKOdZ9/ycZcun6eqwUUcbD374ZcsEmXtsXzkVkjoijhTf3WVO0pblEdMuxSaO6pjhY/jXzMF8gpcEIYsn1eV0pA0SFYkFM8osDVVRHQynDzB5+pVc1uKbe3IgxQMF9kORdw2cObZMuyaty0ToYwOFXplhWepdDfXTTrV/5Y8yTJX1ustjkiLmEWqyC5lSD2O2+x2wZax0Sefos2mFE7LoeTHOq287lLpCb7yw0PorsB8b7ANEJ0x+22DmVHTY3dEn0Zlhzz2fQj8LUjA9d34YK8Hp6vaf3ILLnYHlgOYM5lHglf1kOb7w2+lTwYL6GVLwmB4w+XCHNzQvwRchr3fXIqG+WpVUfdmdGMS8hSrCP9i5pU9mkMkzBewrqgyxubnvYNaap/9DRnTtzDGlyi2s0mcT9gx2mFqQyZ7V07mU6KjWOXZdMu7wXrUqt+Qnwv700/ut2maq4bhVi7WHZS29MWvWhO/1y2eT84V1y+YM1jVQ8fI0dbjZ/aRCIxE07ugwfOi0uxQMaWlVFZEVtPqEeiPqMNeEfZ/aVKeYbhiDJEYSoCq/3lLPDgaWdD+SzPCl24R6Lsg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff3ef42-8dce-4834-bfb1-08d87c760f1b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:37.6076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c5q4mAsXxyD4/oxyRr1fRnMe2/N3V/d+SvxVvuepUBO3jlogrQSJ0zYznxb3zEQfCJs8J5yDX0cV1h/7hjbDeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Similar to the EtherType DSA tagger, the old Marvell tagger can
transform an 802.1Q header if present into a DSA tag, so there is no
headroom required in that case. But we are ensuring that it exists,
regardless (practically speaking, the headroom must be 4 bytes larger
than it needs to be).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_dsa.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 0b756fae68a5..63d690a0fca6 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -23,9 +23,6 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * the ethertype field for untagged packets.
 	 */
 	if (skb->protocol == htons(ETH_P_8021Q)) {
-		if (skb_cow_head(skb, 0) < 0)
-			return NULL;
-
 		/*
 		 * Construct tagged FROM_CPU DSA tag from 802.1q tag.
 		 */
@@ -41,8 +38,6 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 			dsa_header[2] &= ~0x10;
 		}
 	} else {
-		if (skb_cow_head(skb, DSA_HLEN) < 0)
-			return NULL;
 		skb_push(skb, DSA_HLEN);
 
 		memmove(skb->data, skb->data + DSA_HLEN, 2 * ETH_ALEN);
-- 
2.25.1

