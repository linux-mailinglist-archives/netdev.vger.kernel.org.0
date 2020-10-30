Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F8729FAC2
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgJ3Bty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:54 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:30883
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbgJ3Bts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JT7dfv2wvbTXa/N06GMxRUxGY9/+oZlCLskuGZYT8K2RH8ehGG80IUXJrD8DwBhdyIvxNnUVmuNo+ujTnZ7ve9VJPHy9EigpcaH0k2fbvJidEiv0sSRL1u5S8ZMB0jpmnOV/IfNdC0oLnqd0F743hQ5Ol7h88xeBw4LVe6CV6cxD3ZDw/GNQauGhwJpMS1O75WJYFGbhQFriqjq6AQnI+cxyp1ZHfU88BOwe24NvVCUUjOGciJbGTotatoz3Lr7d5Kj70eyvwWxFXvehrqoWAnV6axF3zCbjhSh7QOzMl3qcE9Vwp38Iu3V1gI/E2/iGnpgILJL20aV6PmNZnHwXLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RG2zHUI+o++jrKpKLID7uzAyKVs2ITTp0Mn/fZ9PHHk=;
 b=C0/a4NvN8JAqN2sIazNHRZq5etryevpEyBBqjhQp6mcTlC/7yeufrHoE2jl1LeykemMaonClDDFKql2+900+W8CkcFbvozWO6ZgtoT6rgUvNzmZmtiMWhMG9vTuTFibCnO5sCsKlIX0nAa06wNagkNpA77S77Ugw8JJ7J3cnE3oyRWhv3Xswo547OD55Np4mWMtXWTLzeu9MvWU8M8Aa6I51zZfAGhnpoZ24vSdlwPew54Uw0J2e1rxI4hHv09YE1n4lsaxifCjb/ts++pbdPDoWeFlmEY11tCND0GC/x8mhdgK8L0Hsx0e2y9RWlo+AQuB7uUKjkngSkIM6gsmCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RG2zHUI+o++jrKpKLID7uzAyKVs2ITTp0Mn/fZ9PHHk=;
 b=eYRvoLbzQ9kRuleCh9Wi9C6U+Ne2fZ7vgJITMiovqUPIsTSUBsxHataxPHQ3FuI4HXKFMiyKucp11hJjosj5OVgxLi3KgCwtYc/HV7rgcpl+kf2UWCQ1LvD3P8K8zGkacPYor1pEiq7R98TDV6R8Y3mmQZACDI9/p/deOesHVtQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:38 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 net-next 11/12] net: dsa: tag_gswip: let DSA core deal with TX reallocation
Date:   Fri, 30 Oct 2020 03:49:09 +0200
Message-Id: <20201030014910.2738809-12-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4612e883-7160-409f-919f-08d87c760fb2
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25094B7791DCD7FAEE90D469E0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 35o1Xkp9x0UHr6MReI9e1Ym4IND2j2u9+JpX03fOC2jee7LOPzT++jGaTA7v5X47Mu+yInoRHhZQ2wZkWB73shGce4c2O+o7VxERAeOcWraf+p8lXsrma/j9zXgfvYDP5a3haJcKE9wUHVGqhlWa0K7ITYoELerH/nDnLfEVj6+dIZ1DwAdAudIhlRBYxi6gqlkaQT0VKHAGLL6ylLyUkEy+8GbmYlaUs6CHm98YVqY22tG1BuAxZzYmCQ1ZpcNPDgczCDuVM81mVg5Ob1AmnTSO1x1iPQtMHghxgkJa2hxSlKqGwh7EG9BVtBee/NqxDfHLSk9JqN69cCit24JsYlmadniCGKXG3cFkzcuA0t942UrpnVC91xCwQ30IeATE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wE8VaFH4HBEG8EOvVaVNi7rlhVJDxlcDxKAd2uCFARwclnAf0Yp+eOt0kc++H/lHnbkC4Ne5zszRbOOXwmQUN2xIphSeql43uuiGdxAvR7eoQlk1M1gxYJuarY2Itq16Fr9lk6dlNEFLhSm/XRzc6lUOxAQAQyUX95QFwDjIwPrNxiqKySibjkLzSRx6+u36HK2f5+Ypv5MXRWmUTjq6cXDxZhJSr489zthntZMDGJcZhEjsSJZ1Cswt/x8vinHizvw3Z8hQP5rZn7XZk5Rl8lst0qEK4hZLgZlFhZloeohPYcptJE9cp7vy1U43msYUHRJyzHce3KHUorlo7Rcn2BldpjC0sWGJlMYkJuMq8V7DpyQiEy8koen+STqGh2yMjLC6Xn0ZCHmvYZ/53tBQUP3cdaWrSaG9LWcH5PGHxuGeemq6bjHkV2P3VJPsaB1FAsgBza0kqBqO71LUlw5N5kMD+ZfTglvJ7u53NHKvQAsozSQe7nZpGo3FR9N76gIblWILvKrPceU2aKQg3oOuIinTZxOhBdIesxfHRGoCpG2q+hl4KpQL6bcsAmueNm9mHrpiy5MLqGt3AxFkAsOe3micsw7DkiPj8I65mZ1QdzaFcKo3Dx27DHjQfdN+H/O6RAy4gqp7EWPgLWJNYSZvXg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4612e883-7160-409f-919f-08d87c760fb2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:38.5970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xD0jDXfzTMF54whsTkSto71I1nA7uxN/yfLpFcmjVwYFHXCI1zuMNFM56xJ5iEeVzuGyuySgJP0UuTBr92291g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

This one is interesting, the DSA tag is 8 bytes on RX and 4 bytes on TX.
Because DSA is unaware of asymmetrical tag lengths, the overhead/needed
headroom is declared as 8 bytes and therefore 4 bytes larger than it
needs to be. If this becomes a problem, and the GSWIP driver can't be
converted to a uniform header length, we might need to make DSA aware of
separate RX/TX overhead values.

Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_gswip.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index 408d4af390a0..2f5bd5e338ab 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -60,13 +60,8 @@ static struct sk_buff *gswip_tag_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	int err;
 	u8 *gswip_tag;
 
-	err = skb_cow_head(skb, GSWIP_TX_HEADER_LEN);
-	if (err)
-		return NULL;
-
 	skb_push(skb, GSWIP_TX_HEADER_LEN);
 
 	gswip_tag = skb->data;
-- 
2.25.1

