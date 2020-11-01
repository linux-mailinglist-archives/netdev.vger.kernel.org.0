Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8F52A20FC
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgKATRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:16 -0500
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:31354
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727122AbgKATRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAlDWEcuX3hWVM5z/Ulcb2P04+PuNQje97tWW1g14EJAGoC/Yx2YJoqbSce3kk2phQ4b34FNuqXrBYqoRheO1kbRGpdaMqfr2y5szctXSTyUZFp1FhU0EVQJ3I7LtzHZpYxAMyUU131KP76pJlZYryU3tdrdaWi0lfsqI2StHGjCROY5ebmQso71tVWd9sHGDyz7xjlX2JGkvIjRuvh8Dlf3NEgqOQ25t4eDX0dYe1aovdoO/6TP0nII996OQ+26TYRk49wUb88P7z81CSGAvctvi1BbdeGZCrmJxTh1m79OVH4HCCUMtR6kHqFm+ey7n3PX5aR1DTsKHGErE5emKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qQIoxg5hGG2+wN4AQkHdfQVPeMMmIIneiWkK+8CqBI=;
 b=WIxiJfoKZBsrjZlNc596WvbZSJyPk/Q78rMYw7VQ59TfeiV+Wc//N6A1uGvYMujLwG+XdunbFepxvMSOv/YLLJx6UKo5OQY7zK0QP83FZAGKkmzCq+uvD4jUyBVKRsDkNWkcRPbhBg0JArIJJW8OV8hPtX8oxR7ilZd35P1COfTBKQMfnmDV1IfHNHNbkbsNf1iD+YCj286yzqxsv7NMuD/Yw58XVF4mt4Gj2l+kQy9bZxAQy9ryc7Y15tvcZDFv172gePzAAnTCEQJeUvtvwMiJa3yu9s6BCYLbjVlYqhoWegooO9SYqgeqQIMDbq12yPajWxJUa+en9ELTpI/3hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qQIoxg5hGG2+wN4AQkHdfQVPeMMmIIneiWkK+8CqBI=;
 b=cHVTITNiFHUeRyUT7gefOB97fhkeCpl9Vh+qIxYMNHd9CPqh+si7ptjwkyVkxFVsriF1Xmhovx9mjcQM7DoU8ez9G00kKIH6dxwGtIlJm/rHD0UqKqkBX+QeuGYTGm8Hq6AMv8ZJaCnHhkQ/D2OE5gp6Jbb4PG6Zod+ydbpBvKA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:57 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 08/12] net: dsa: tag_edsa: let DSA core deal with TX reallocation
Date:   Sun,  1 Nov 2020 21:16:16 +0200
Message-Id: <20201101191620.589272-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201101191620.589272-1-vladimir.oltean@nxp.com>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0401CA0001.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::11) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80008fe4-62d0-496e-bf2d-08d87e9ab36a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2861A5241BC02CE91DF62DE5E0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yWopS4vRpz4mZ0VfmZuQbY5jro6ru3T6G8/tRJ6SOXVRwSCiAj95yEG0QCEwrirQVlaQt0LexoY9VKudOKZpSdcn5CJ95xxo2CPgNUMzqYIfyr1qNKCJfQXgJUnVZWCQ2baAmi7k4AyG88P89OfXaSpnTJ6mRuI8H95o5UQmHkipGsBHFGPKwI0DGMP+tir3O+8ZmM54SuDedjQZTzxq+BwEYyGxCev5X7CSPWw4ogTrgoeiQHRuG4kC4Febba8C2zKqStfwjInVHGXxgn4+FPaEHyMJ6ScLMV9kz4eFPmqE1qobq/bt65gPrnlPN/J/uZ0iKSB1v6FWvahnYtZA9/sybdEU7ympAzIogxqMEFNpM5Unz9DfIK/YX8rB32+Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AHofs/gNuBt0EqMIOF4izFSuslmd4IY938YhRwwVlR+cHNFpWoOQcdQCmxG1zPRJRtZUhik+OeeL7CO/V3bPNL9wUvh3VySfIDXciHxfKFSko7PuRH97Z5JjIIcpBU17oSs3qJwxLkKfouVe+lVykXn2QzL46+ox60l4jos2KMm0GLiKgYzFVwNG/3ZsRtzFM6SNYwYa/89f3JpA36zvkMkjCrYlmrnn3hVzWWDD21EGnc4nk8ZxfJzjUTvhfaxnU2EhdC9jdUrkTafT8+VP7hVAVKjyval919qh8lpJf4g82ej1AW3jfZYO9vETznYFggakRu8JNE00Rg1ATnPMnQTSLT6sjSJ96uiU0ZGfM7ebNviOSGnni5nkAQk0qO94NJVfnKXEXDlEivYDXOpgDDqe9rQ9nSfchGdYIl48nzWSgRIyt34ZPiC2tM/Y9uGxi4ZYZonLngnwQ1yC6T4lq7GfTn7Fwq1cZoYl38Gbtmg8otPQrbY9w2vspkTZlxc/n7I2vf9uOka3Hy7ffFqsOFTCO4grvcC5+Uex6Plyc86uuufYZJaPIVHA+z0K0wO0blZ0pRWAqPWdefEKQI51MomLFTGiid1hpBYKhEORLFS9w5alSOlvR/RbBow9DMbutbW03l5nVeb6TuCEEmUBnw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80008fe4-62d0-496e-bf2d-08d87e9ab36a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:57.4755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iRAGyDpfr2AUtTkgRYo0rh6g5HddAUeq9Zm3Mvv1tgOGXkTYg9LfmjJZxywNQZ+GJB9L7OUi2iLAhQ7LAYErA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
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
Changes in v3:
None.

Changes in v2:
None.

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

