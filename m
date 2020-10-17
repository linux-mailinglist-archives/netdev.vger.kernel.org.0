Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D912914C6
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439531AbgJQVg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:36:58 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:7653
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439673AbgJQVgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ce1B7YMMCRyIcu1lGk+u4VtOrryRZf/qWq8tfmzHrh705xSevffTvHZgV4S4Cgy1G0mloIK19DBvsZyjg4mPPTQBbAUhfPBqCaSGACq7XnrhARCHa8+nBszQUPCI/2ArM7dkBiDcarxCJcvJaYdOv3YXmFUey90wPh3hvE//QYyPlf02lkHqWCYFac71Z8F0QCxjodRYBtmFYGEGoCYoeNNaT37ACQksiOFRlGhYI7QWp4jHjtJ+PKzgY4y0pP9af5t/pbfY2vTAlaBI1f6fjCtOm4f2EqQc4GIGB0ZoONEDVZRbITE55BZyzye6Ean0cE0mP58H4vqQSn8jzlcHSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+Xs+0P+b/FPDk9Gwzj3P8pnlppZWKeoyDRiIRknqgg=;
 b=PU2NpukvuogBg35GBU0gaZotTpRr4fVyCifnrQBFMnh/BguD2/JkQe69y2cQjLnZXVruSbMGeeMJ5NfRvAGEeSqtqvgsn0ZzE0Aa/6xUX9XRQmAxlBEPs6k1Qq/o/E/ylFJ6LYGCJhGoEWuNzB/OIUuDB0w3EkyReuH06S6l29ZS6F9Gu76Qbc/yKYgqtbm7TJlbVKaCE1h7Xv3HlaPnpiT1ywW872EafdnWTobrhfnJUn2X1MGvGcCIB7mts9MAcq2XyaykqF9wKntR/RCESH1Cf+5DyoP+gLQPnJFS55Y+wnNRAMds16w9rgo2Pn/NbYHGuAbWs0G/7qLCkqGTcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+Xs+0P+b/FPDk9Gwzj3P8pnlppZWKeoyDRiIRknqgg=;
 b=niWA7SjIgATOdMMfX4eZCSSaZGn9yek2Iw8NNom9ubrvzQwTvGD5V6KvJ3t5xIhxxuThtuDfYcB/Z+88Yjw0NA42k0xUym59uc5XaMbzxBGl1tlr80gOo7XHJtZlJhlcNFKhk9X5hAAUOPXI0f8vCcc8idQXfV/eeaYB23Xk8Gs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 09/13] net: dsa: tag_edsa: let DSA core deal with TX reallocation
Date:   Sun, 18 Oct 2020 00:36:07 +0300
Message-Id: <20201017213611.2557565-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15254530-0b0b-4431-f7e7-08d872e4bb8a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5854AB2A602B1D48FF9B785BE0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CLMD6n4+59IsgMGLMReu/KQ7BXfoy2jOIfj2vTavVvFX9NixZcDAyU7XKFY23oUZKkpDbdJJV+UxTChKc+SwuYoopc+bCij6MRbSYPW62yLunQaxxT63bUYlbZDQEx6XIqnYGtLy88kvHRXv7aoqorg9IJHBXkX71J31g6mm0N6KhlRF457RfU6JDW8lV68gWiE9bJou+gTwecNGARsdOrfwBv18DTuV7yhQGu+grBcNovUe/DVe4EK+465XZCEzKjxndiGB6J8lF+pDSvsbSORjnmFzZ8CAufM65xcExp/3YTW1m7F9JRln6cxjXWB/getzA9T87hNeHj2rCD2YFZ1zF2BIWi7Ae/aYDQaQhpMltMxF5xLtfs3GmEAKpiS5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: io5NyKbNupZOQogiPssYPVcsbKtNAG56Zr1Ej2HXcVAVqihQUzUvM0zOfVRUAL1RYNcGfLU5wjttELx3KpdrkFeKySkD5onqOkqH0HALYBbBbIwrZy1Fl8FNLxpmI5TpLFoLNBTfOx7cVI4gK/8AXNI+Txu5v6ami+gvLYuH2255iphSko7I9kJVZO64L75Nd4XU5jguQJCwdmsJay+HNfYxwYd8ZYbSc2ZaaKpS4myIGoAHZJ8oNnRNT6AKE2t0ZtaeP4PaX1EiUagEooABr3aVEt1/vS0Uqqapd6Rf3zgoAtMa113CC+OATxUvanAXZyUq2RRoZuRIkJlem8wcaJoIXo90irNiLw5Jx/J6q2CztjLfeR10cbMdPZlk5vzDjC2BxP0qpELxPPTNozpgOLjNtrLovPmh+hEhHljQXmBMBX959DyRS3SMuPun8yq881TcY+wHWcCLGMl6IcW6TznnkHW0qzFNC4NsjS+FBT1C1r6s1suS4hvSo9ZtKYt+CkrqRWdd2wUfE2hq/avEI/bcVHThXLvD+PGbSweS8ElYX3FP+DX+UeZsFmcsKwpLKLPixZclN5eHTdQ+JT5v5i4ms2w3z7Ul3hNz8AGNiaVED+r582N2JAl9BOcepKtSW4ZRuV6jWU6IaZfTWYT7pA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15254530-0b0b-4431-f7e7-08d872e4bb8a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:40.0450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9uhBWDcBorDxP/8ObSI6ZfHyTB8iBz34gibdrlayG3dDPE4DWoWM2EkuFkexzX5KBd/9lsrjtw6axGZgKmhgTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Note that the VLAN code path needs a smaller extra headroom than the
regular EtherType DSA path. That isn't a problem, because this tagger
declares the larger tag length (8 bytes vs 4) as the protocol overhead,
so we are covered in both cases.

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_edsa.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index 120614240319..abf70a29deb4 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -35,8 +35,6 @@ static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * current ethertype field if the packet is untagged.
 	 */
 	if (skb->protocol == htons(ETH_P_8021Q)) {
-		if (skb_cow_head(skb, DSA_HLEN) < 0)
-			return NULL;
 		skb_push(skb, DSA_HLEN);
 
 		memmove(skb->data, skb->data + DSA_HLEN, 2 * ETH_ALEN);
@@ -60,8 +58,6 @@ static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 			edsa_header[6] &= ~0x10;
 		}
 	} else {
-		if (skb_cow_head(skb, EDSA_HLEN) < 0)
-			return NULL;
 		skb_push(skb, EDSA_HLEN);
 
 		memmove(skb->data, skb->data + EDSA_HLEN, 2 * ETH_ALEN);
-- 
2.25.1

