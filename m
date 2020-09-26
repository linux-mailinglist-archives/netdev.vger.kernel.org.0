Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD85279C2E
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgIZTdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:31 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:63047
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730184AbgIZTd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/tJNwOLtKOqKGc6HLlMeBarJ49q4hvmE34hosLmtFak7nDAb7RalmS5sSiPuR8+5KDazqI6wljLjbqy8onai+CKIPfI8O/hn4kfgr0dNwdFeFV03E1SCtz5GZJVzSDyZFrijkhIUWL75O1s+QowxP532QaohXIvEtb6Baox//H86fd3taPm05xNRe7KDZxqcrKcbE++EoP42SgshKKYxvFtn4xcoV7nUvd465cuiY7BReE/BSD2D0pBwwTOrr0q8Zc3pFm6gmgSOwZdPvaBBav1BCyMQaBbkYUPYbLCOx/XrmlMJwZXDbnzyxCM2b3e28SRg56eWC9Bbkjbdl7hBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARy5f9ajkhX72g3q+TbIuNHHZtIzwrgH5/sTXOlOFWY=;
 b=ODV2WAdoofAOpVVPrBKiRmHwT4OulYK+5ysw06DXDvVC9iGVzWi6SWPpaGuF++FJ51Dy9TzpqLsjJuNHJLCNt2ucgMmuKubGJV98Zq4II/DxrP2+vp2+QJybfcxuFQMRv7puN+3My7WKgrUdIK+I2iH05UWrXbeqzvl58u/FSmn2AtYHMj7zvQzb4I5aFtcZ0AWAy1dA8ip31vySu13+whbNP5zoDECLd2vUaHHA8dXpcpTaCqbsjywRHnVSUTA9aYjM/13/UB/xZlL9kszrQ7uqEaJK7PttDpOiiW4WeXA04th1R0C5I5HJVrRm7Zl8WXWxSrQYv1naIBQi9zfrAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARy5f9ajkhX72g3q+TbIuNHHZtIzwrgH5/sTXOlOFWY=;
 b=pwR6Np+5KUuhG/TPRNC2amdjwFzHQT38pwnLx/SSll17PGrkUuVr0MC5etahWAE+sZSCR8P7uVoURs8yEnyXtgNfpZuiZ0cwzpqK183JErMajORC9BjIQHF9Q/TpegRtFEnVTLOwNcl+Tv2TnW+SYy62Q3mSv13IaHkvYanEclw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 11/15] net: dsa: tag_edsa: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 22:32:11 +0300
Message-Id: <20200926193215.1405730-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:08 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 136d0659-0a40-4710-a174-08d86252ffba
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52957A711F041562D56A2B46E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ji/DLqu3c/Ym6V7buS9phaBu+Waui5djIaykLtKEWIwv0WYCi60wNiC93SlzPuUXsQRRM/xqIumZ0JgupzaIF1YC6Nu1J8zbngTPhrdsCbYG0XvpeihO99YgxWNgC6ZZCqOPuE63pirPvsCdTB5iUDAOVkLD7lIiLQI5LdzmSxdL6kSVhVHSXDLnLObMc315x8X8fDnkRSU3I5UlgUDdQXdv+4sCozs30trFFvkopM3mO2H5en0tmTj/5FAYTz3/NiuGPFR4aIHb6g1f4JsPVtIZd1Uz8/pZtDMrdpprAvxzhLqytTqisUgDvpuIsIlC0hO7Re4z9gPjoeqUq75dj5wURFz2ZEAJC+rm8rp9aDqf2DaPydtnXT4fnmH3UIKKYTzmry/lGhL1atxFY1zGS6Cb+S/SHqEBDIdIz1U/3uLghieZIFoqUH9CPHphf80qEFEAbJh9XGXzGsUOGIxyYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(4326008)(69590400008)(66946007)(6666004)(316002)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZrMCe+FywT316V+sCNILtYYmpDaW4sMYSyNGSVga/UcWKElVYdkY1Ys7hAjhRanNFv0UiaPMCDHykOrk5YPJvg7eBe5hvy36dB+K62NFWLeeMoPzx0AZvjru40hcfLUjpK+1u0dk9SbiLRd2gaPO6Y9zipgtDSVeLOCxeUsKox1+Wwx/+roHPJ8GwU02Fysn7QjndrVbr5Mah+ebNP5kfM74/LbiqixbwycEWeh/ug35GLfuxBayj/H2MllG7nzcC2bBBdhArGX9dKNE4n7bxETbMkjvg/tZ9kaG5J7PrYUBmLxDk6vtyDWE76PBYDpAoGgxbkRFKgZHO4s4iC1z+t3fwl6ZbVZVtBl04KCQysSdiSAmb7uxIPybh+8J1rdJ4J97y/LDpxCi5vFxvrihOPCUMMiAQy133/GvZeOqKNM1YTJ3ASTtnpugPh5qjicCYH/7xnVev8Ixx54RKK8w2RX37IWB8+Dp4Yy+aeWFgqANzoGDnALv00mPhoIxMJ+tXwoBVbcJskLWqI93Ccq8RHJF1nILcO3BzUY8sFL0x9slsR8eD55JEbfqbWd45E6wbEqg5RxP3eDdKQevQmKsIJUvjvGFW6H8Dj5EPw9QQ4uWrYicQjdzHwTVg+KxsvEFHHRUuL5iiTtpfUX72WfifA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 136d0659-0a40-4710-a174-08d86252ffba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:09.2455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eS8HXb2txdUJn3E7v3dIZBBnmpn7tE8Ndo/o0wy3CwmLrAG+g8kW64ay2leOfAJIOeUzKaV1yYxlGQnERGm6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the .flow_dissect procedure, so the flow dissector will call the
generic variant which works for this tagging protocol.

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Remove the .flow_dissect callback altogether.
Actually copy the people from cc to the patch.

 net/dsa/tag_edsa.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index 275e7d931b1a..120614240319 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -192,19 +192,11 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static void edsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				  int *offset)
-{
-	*offset = 8;
-	*proto = ((__be16 *)skb->data)[3];
-}
-
 static const struct dsa_device_ops edsa_netdev_ops = {
 	.name	= "edsa",
 	.proto	= DSA_TAG_PROTO_EDSA,
 	.xmit	= edsa_xmit,
 	.rcv	= edsa_rcv,
-	.flow_dissect   = edsa_tag_flow_dissect,
 	.overhead = EDSA_HLEN,
 };
 
-- 
2.25.1

