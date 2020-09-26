Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E27279C31
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgIZTdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:46 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:63047
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730249AbgIZTdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2MP+9MI9Ruy/bHQSQ1U2x4qFK3y5T9ju9Qv3GcecPR+WRq3bhdIg4fv4FyvhJ9xCiWBukiOafw10W/7tWn+rRxxFt10uFuofJTdxR/7qzYWhQEmJpOSjfVqMrTvKoH8A7GMMX0/PPPPLF3R0/KGaXeS2kmb79Ytzhz7/ssz9LlPaIcGxxkM7NFPZ99o9zsgSTv9Gzwt7LshDa+TqmC1qtJnYIZP3QpQ1s2/tNL9FYZl8vVphM8/ukNcbbqy1cgBgdJ9mL1aM4lndofWi7IqGf4adh0JLEu0xwQ6k/+CGcKcaiR/1NxsFcasJCEJjnHpc0R+VMCmHU4TnkveuK2KEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQ6/+vTV6+zysM2+/JoneOH0ogXQKGmbbAxK7UBdIvU=;
 b=UW8Gk7o3lGwHniywlHcfk5/Rrp6lDDey5cUQYb5dPKA6OL32KYgPYWKd48DHE++LBOf9IOb5XAMt3BhmmaR469JGxT+bGS09PtPXZrDfeBLiXIfcDbwwV2QP+gE3DEFmfVYECx2oERbTOYffVymg7l9Wateu/OJcF7HDSrMMf6/dNi+7U9ABsypEP5hSjM/N22vv4q38WZQf2mX2MTLauIHp3IYkMGBYdz8EbLIbHSPQVJY9B6EQr9WwEDsWAlsv+So2ZKjHLswBLiJcb0BKbqUvAGXEFpkIlzXa1pW80R4/ZXSE0GgSqDjVd93GQroOfL3ra90fLJPlql6JxTlCeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQ6/+vTV6+zysM2+/JoneOH0ogXQKGmbbAxK7UBdIvU=;
 b=iGWs64k4buoKg3M+ez7J653to/jyJP/3qcZ8ilB5TTQ0OY6Xt2LIZhWrWIfo3mO24N1oRJnqzmydUafe6OJLdh14HDXdWw+QLzdB+AX6KTHTZlV+Fwb2jdT/N82qO8Q9xIodPL0dZWvWxRhjD6+yKVHBe6OuY1zaNrfRiQPurg8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:13 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [PATCH v3 net-next 15/15] net: dsa: tag_rtl4_a: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 22:32:15 +0300
Message-Id: <20200926193215.1405730-16-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:12 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 419fe9a1-112b-480c-949d-08d86253027a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52953FE3B1D9B6B38009A2E2E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yrFLMBfskkFZtfHfJXIh5LdLdcQd2D8miINV9x6i7GhLLnX6i3BP6KzeucUqtITGQTbha+V4kOBdVE0XpsYKVkYaugQGbh7n8a0mi7ZqMmDoK5WpSv16RssOvfFuOXOVl2kIyfybP2Nhcw+4sgTkgxOR8BA1zSbyfXoXs1mggw/b7yMCC07B7DpaOjC2yTpJnU2r4f8TROnZd0nYyoxT36HYBTMzo2wS04gZzi84brZOVqDgzdf80RGmW1pDb+6+zIW0gMGeUHCuG8HIvS0bNbuhO/QI4vw6+4tFdDLgSxawj4yOIEW61LerGZVpkTx/0XOuPAt2xDoLgSiePA5UCiXQ5XeUSpQKKI7tn2RvBlVX3NrsO2lO4mqOJ+GzEhfyEHGyW6cY1lHFhVgZyYv987JadWoWmWc0ycuxjU/U10+SngfhUTKxIjtuPdA8YzOPMNXPyIWDO4ubCLn1mx/zsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(54906003)(4326008)(69590400008)(66946007)(316002)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CWZ5PDzYrM1ET9lJ8u9FOLhqtaS6+MjShtoEbExSE55dczDanO/Lm10rtpWKGYDsinqMFWNGNKgLmVI+jOE8v6WzYtfxG7Bqb4fG+ONs1y00WbuGvXW9/mQS0QSqHB2jTUoeAHPCrhRuxo4cvliEjqj+5bas9HBgd8kjVXQeeLYWHPp3F6vBSSycQFUuAKC4R+LfLudt4Fz1nboXi53xqz8Vv3YX6+LNucyABKS43Rr3M4Som5DUoGZGDi5li04rqvHulGVWpajHvdlzE3mtuQ439I4scBKYRYWeqNwNeczZnJrhzOTqXWyHv+jFdrTifWB9W/4qbDj5SgNh1UvzB1mGHsef0+9UrVBg1Kb3jGRYldhaGhFjl0lUOkeQOFTmVlYUlxz4XKeepMmGn6YZ3rWKJ3QRAyYJe+61iMuZ2GxnrOjJwJao6ajHjm8QiMSzL/M+DIhwTAWcsW6QumpaG4f3YHJp1E2dRleFsTHbvcalwTCNJKDYJBr/pk92XBNEK0GxOG91ZUv6T7oE92Oq5kZ3nyOp49EeDWqjvRQeNWfFCzavev/cX06pDShYC6MVapXetg+KOHGleG9K/0qkyzNX18AXqAo0TZPzP6Mx9WbCt8U3hI2nqqiblRt85OWs6xnITHUQj10h5r/cRdzVwg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 419fe9a1-112b-480c-949d-08d86253027a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:13.8459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2ivPew7IedKWBxuIvTon49crylg39qKd2AO3gPz838z4i1hQwA5dKq+u14kWrimWs+/3yp6WbTpmTAC0z42MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the .flow_dissect procedure, so the flow dissector will call the
generic variant which works for this tagging protocol.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Remove the .flow_dissect callback altogether.
Actually copy the people from cc to the patch.

 net/dsa/tag_rtl4_a.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 868980ba1fcd..2646abe5a69e 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -106,20 +106,11 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
 	return skb;
 }
 
-static void rtl4a_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				   int *offset)
-{
-	*offset = RTL4_A_HDR_LEN;
-	/* Skip past the tag and fetch the encapsulated Ethertype */
-	*proto = ((__be16 *)skb->data)[1];
-}
-
 static const struct dsa_device_ops rtl4a_netdev_ops = {
 	.name	= "rtl4a",
 	.proto	= DSA_TAG_PROTO_RTL4_A,
 	.xmit	= rtl4a_tag_xmit,
 	.rcv	= rtl4a_tag_rcv,
-	.flow_dissect = rtl4a_tag_flow_dissect,
 	.overhead = RTL4_A_HDR_LEN,
 };
 module_dsa_tag_driver(rtl4a_netdev_ops);
-- 
2.25.1

