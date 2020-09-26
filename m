Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63141279C2D
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbgIZTdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:31 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:17545
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730046AbgIZTd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuDAqPmXUZ458NYvepueLmysI754h/ccUv1GxxCRDqU3Vs4d6hYdwyYYMtwhOCK/e0qQ9wqYwthfBE5l+l5gm+YU5vquxVxEHbjK640xVYGniNO2C63nNF2hEmrtphcviFks57lQlWc1+7rVUnpPSZESibdfjsc/TUUIL4Vo4Sbu3Aep5gkNaBjsCIfPVBfab/8zOKmc2BN9acM3cRGh8OPW9+f1JyNWgRK0iDjWjGmTERUWK2AJ70YsVZgUYIgUnb+LG8RQW8Okw+bJPkqlcFORQbUHJAxnLI8nugeIMCrgJh7dXZ2XiGl0atXeVW+OwaYGgPQC+5MWbZo6dXOhYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytUzIwREFY2NerL5lKbB+haA4NC+6oyyeYc0dAtK3es=;
 b=iozs0LG8Yqlc9cOlL7n3lkpomP1OlM/i0M7tEDAFsbYyskyOfyjo4+jldgNRmjHRSMPS6zNHsH7lOmu4aNJZzaaJ8Orz0/1JibSItQ0etXj52YEjZqS4KDzwXsaSulCkkejVP6R3xlIYBuCLZaV4aPTwVtrdSnxvfKHn8MuhUqjllpQ6Y/0V4+gV4/3nmQgrdIWhSu4V8xkMfKXWHtBL0lNxEi2CuEBwnJqS7FsSCz+8jZvLladDYtO/bHrPR9j6yP1QkRyyBPcwAa8R4xckgp+SIpJzQ4UmL4L/aoTvdm9f6S6V0MchYmuiZk5A+7qDoELp9fYhhlMZiSJsOnfdbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytUzIwREFY2NerL5lKbB+haA4NC+6oyyeYc0dAtK3es=;
 b=IxuJNrIhpg+Lu/fF8sBSECRQpd6zRMmKiwDCm/cR42bMIwNQFx4/Zzf3imbkWpdzu49Dxvk6pJId++AdpT3MupcxJD0W1jTTf46rtrXLTH2gNZkU0vfQBnUmL7ffP3dOdJJt+G+Sodi07UG+G5J+pviealxDJYLYJZN2Bh5L1Zs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 10/15] net: dsa: tag_dsa: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 22:32:10 +0300
Message-Id: <20200926193215.1405730-11-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:07 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1bbecafa-e679-4b1a-b042-08d86252ff1f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52956A7B374471C3442AF994E0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ymFWAHEyxLBGJ79BuGadMouo2cmxqmz0cYigvuDJ8Eg9YGhm5Ia1ufeDGM68M+/pwttUkGuvm5ci12rjq8O8usDkEpOrvIg45fSffgpqCeEB80Euf0IQ3H/4y4gPlX4ETtaKystuM9Pd4tA1VXThFTVQO60kr8h8aziGMzU/rhNsxU9Kj3EYfFDXMFbRK1AR+yPTbvYAPLWjcHTO6L/xQX8IbH/Prvi+xIcWuUmSqn5h8gbeJAmQDTYFMMQ24BM0jWoOHwkIaGmh/fDY08WRiGN5QCgbYbPxsqArNCxDVpO0jcCs9QJqedVIA4dcqGYVNFX5ucaazO/JtskBRZ6+OtT/JCAs+KYtCTZmI7k3kncAYC/IgYb3oFWZFnvbo5iRx0iJnrEETlJOrJYjq0NMEdFUqx3/W3YQu5BeaSeuOJRCB25sjwRPWT66Vku/Rwz4+AZAMnBHF55vbqhsFSZkZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(4744005)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(4326008)(69590400008)(66946007)(6666004)(316002)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: piVVZKMKFFhiy7y8kK2GVp67l5tWLRC+LzxwKjeq1CeH9x0bP1aB3K1f/jV3OHepS9eebE5YZwGYdpT3C/3ianYpKUxeCKRMo++S/DEX8PkxVYZc2ATchW2wY7PauVurDtJ4FTRyqdtQKcI0GezjWvAryzMF7zAlIvKDViqS4CkmUF/SFfcohf4NAJQm04TOAcz8fnDeqkY1JnEVfFumHU+iIcIfOzxPvTj4coWVm7TeQBN8KVWy/38rI1fHfmj8eG157RMRAhTScnH35pp5AJNKzvTdcNMt3VEZiICjG4gY2/IIHRJHDX96pRFdApep3vtG65nMewxyof5cD0q1jftjaZ6pMvWqo92EcDbE/lwQ6NEnSk9QUAPcGpaMUuiYX1xKDQfWN2BwC+2VUIU2ezswWnvvZe5tTz/z88S3y2IkxzW5UhHkcYE9Mk6S8qx3ITUEVHkd+qS1v2thWCSq1/6jmwegJeqSuGiLbq8p0H54882gwyspeWfF976uW2WSkUJ3UU9WkC6YDZCRNaWmVzIgQrWiwuo37TXhQp0Q9Z6tmMNKTr8GU2bGvu6rvn2l0/hwmwPFFcEdVsYmiHGH78Plaas5wLFhxUkKsVRt5sc96Qmt3at9P2x6opbLMGDC1RRcHTICrtajzgV3eMJtTg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bbecafa-e679-4b1a-b042-08d86252ff1f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:08.2171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZ5A27TSdEbj436vuR4sLpCjbPN4pyAtHhyKKIlfIPYPydeq61HJH4BUuTqBM3l0CrJGUfwNRH2NPpthBo+gUw==
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

 net/dsa/tag_dsa.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index ef15aee58dfc..0b756fae68a5 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -142,19 +142,11 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static void dsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				 int *offset)
-{
-	*offset = 4;
-	*proto = ((__be16 *)skb->data)[1];
-}
-
 static const struct dsa_device_ops dsa_netdev_ops = {
 	.name	= "dsa",
 	.proto	= DSA_TAG_PROTO_DSA,
 	.xmit	= dsa_xmit,
 	.rcv	= dsa_rcv,
-	.flow_dissect   = dsa_tag_flow_dissect,
 	.overhead = DSA_HLEN,
 };
 
-- 
2.25.1

