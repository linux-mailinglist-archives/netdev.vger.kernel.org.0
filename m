Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DB029FABF
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgJ3Btr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:47 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:30883
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgJ3Btp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fS9c7ibzV4bNH9EnxQAVcZjvix1XIJClhELC+6j3siGWKFrrkCyTaVsn+75I0MzXcv2QvbQWLBM9iF9RS53HazwEJ+2ltiY2LainZRowSXFsVUPgABhIdpcOGrKt9pSMeaVGL4RluzciLsontUnkCx4dY+39vF016fipTjuuVn7Mi1SL/j/myq+ph/GMf8mx0y4o1xqkKYxQEfGrCZtkDmGykAvSTb+9vNEriaYX1RGiraF+noFL6Trf/sMsjNIpUEl4G0ExG+1+z+LN4ljrzXrXvJXa1Tjbcibsel6OpDO8Pu5FiabX+3uqV5eqM+v0nmypc9Qx9MV2FWhEEOAPqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/mXOs0mxLNI46m404FUY63GJePK84OABIvZXygpsZs=;
 b=AyFFJy/6uWAary21uv25BphPCQvwnksvSd2vFXydf19QwYrIaqrYUUVOXXCez4J8NzAdIO+P26k/44C8f4fQbfTBicyY9hJkzBLhRw/9H5OUbYYFCX7n6LqHGVB1p5AJI42pjruEh/KOkgn8JtJ/l4YEIcX46w/Rc6cQ3z5e94sX0RmVBN1dYuTsZQj4HJKXYlWU7umTGowLVf/vnmCRPGqZw1EuyRSzKb7fmRKeEISFzelqohrbnsnoTuPKO6/WVkFePQhNNql/OtdPjrfXz7Z7u/py9ebldA9kwJ99Rez6D+7KB0RH9mllIG87Mg1j6vbiYpmu77AnAedC1/627Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/mXOs0mxLNI46m404FUY63GJePK84OABIvZXygpsZs=;
 b=lRelvhzr5dbiqipU4FvkwH9/zwOPlfQQ26Kn5oTTz8DRdPFoc4SRd+nXxpYUInHmkg9wT7s/ty52hw+iJHkppD/beSlQ2dmXg1lhijSn+Y3biY2b7zih6Kfu3KInGw/91yUbhvVDuqoqlYcra0HzBmyMMjstkUbiKzyhgF8Y8Lw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:35 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net-next 08/12] net: dsa: tag_edsa: let DSA core deal with TX reallocation
Date:   Fri, 30 Oct 2020 03:49:06 +0200
Message-Id: <20201030014910.2738809-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c186e94-2408-4725-12de-08d87c760df2
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2509E24EA8DBC2B6606DD0EDE0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3oqI0jvMnjoZXBV8EWJ8/UI/Slk+63r37e5IhXYM8pQ0k1XRtOcB3j/AMoqS/208ier3KlGPkLlioBGEY3lG/OBLnWTpV9upGj2BJ7ZzqYfEag+FwycY3YqizH0gfZ1dShd8pJaV7myJAMCfd/Yv3AM3kSQyQi9wL/TthUHLWW9oxEDKqBQmH2m9rDcmnVQdJPA0XQMdxjEI7LNJb324Rn39Tg1zf5oIhg+scs+QR7hUnWvkvoV3T/wrjNGsWbgXuQjU6m2eZTdqso6DcTjxmc+9RanATeAIDXeyzjOJZdpv6YJ6S9CFZFXTI+/eY3zJ8mmMaMfWqpdTPiJDHvqZ+7iby/ieXkMWorQSz6IPjQH1zxoR5HaE2GL7paQ/6b1h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tgTVqUz22fE6Km1eXCO9euZaf6EDaRF+PO/a75H6aJ93I7rz01EpYBBJGi0evJsjSPu/coif0PnsaizEGyXrO+3BxstQS9KV/Kkl1K+1/sqUzItDQya6PSRrhnFx/YWy57DUXqkF5P8IlhSndP1t6wZQ7oq9NkJU4k6e6gTWVjzRvs/M4OgKv1ti/cU5nl+p958eqqKgxHXLoRbeBKyzXnLZIsApg9RVRvkqheS5Q+Lo7ffI0ymDti4n+bmEzXYLVFjQQp7nmyStp+oes2l62bqX3amBgoem8MUvB8ROX3DfmtbqTjH1hUzx1orEnezb+J4QDp5H6ODhgAXH4TbMEfbsgPDo3hdWShfcDQli/ysF5GZWTmlygMGfd6jKFEnOFmQZbkweh3gQFjMOmit9X6rHJSbn8G2LTJFfC8DPedejgOX7l0eqmrKlkt78MzU38RWI5/+M38Iu3G5Tvp3eAq4bksBE9LNnI3lPmbQSNyfEM+I1ZjOtecKOqlbkR+yh6yLxdT4fmhAnhgqps5wiryAexnppNafj4HQjfjwUC2BACH7tMwWoU8Oq7X3rNPkB0gmrOZw2VIzbTPwCbCUCWwvxAjOLUfgYtq5zvrtJTU+md401ri86yLEdjj6kT/K8vNTZUgcBgZsEU7lU5UH7qA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c186e94-2408-4725-12de-08d87c760df2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:35.7337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sxig3gioz9cdVeHMOur3KMh5jDiTVVKxfZX/yWqFzi8tpzOHF8TT8TBFBsEfdx3LdGnyIl+JV1QD4w06b61agA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
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

