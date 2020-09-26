Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC5B279C30
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgIZTdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:38 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:17545
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730239AbgIZTdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avzq4h/tkitxMDy1wcwI0VRHJRj9VZq2nt4YTDE2yXLk3/u1iJFoiaq0N55jb9/L3Achu00NTTCJ7zP/gF+z0j+tqVvr2/da3O7TJ9IkdQhMmV+9MvSXAgyjqplRiLWi8bGDC9jASOt0E88/LdnCirpddgK5iCMMSUzEtAGNYyFruedjTO+idE8nf3mPBzDXyUzAw/10pbt9GEg5x+xCNtu/66WbrFvV0Q7nQrdlVbSLijWWoAXuNGE/WGioBzRWo9jyXOpbmbzEbTXniIUrj1QbPfVSFVa40SGF+e5xca/L2bkkGh1gOcEHQ7+VMWmB3rRQrqjIL4/hNi+TiJxJVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QcH7AW9M+6xsndaZc9erWiR3kuY7jz/Okq2hqqh0Mk=;
 b=Q6a03dpdGeFmtjcQn9SdI/rT7kvkFhr4Q7mXS9cSYlMVlf6GHNYnLUmNymm8MTl6WkiYU2wLo6fTJtGxqF7Rhn8FCBHhSdwnjX0gY/1CvVUp3F1288/WWAEOp2FV45L+lKzlrvFYSIDWmCU8kY5bu0PG+WvYuaADtSewMfCPWbmtbhdwzXcJiBBTrBnT67AMdvDizjuSqCcRthu61R4rk1C5UVTAr+mhieMYwrbF4UAYN4u53yl1LnZmEtLehOn6R9fB/fk+5NGoUU719CbswJa7pMt3bgvY2jIIhzUC6V1sGMyl5Ci/KL54nBkJTde+gZsOWfdS4INYTNNVvO4gxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QcH7AW9M+6xsndaZc9erWiR3kuY7jz/Okq2hqqh0Mk=;
 b=e1UnTZDPqEUiclfTDrBEPXW9zQYCPRPskpVfDWJEG9JeQyWQTecsHrPu6wqRz0StVSohJPfbYiydsp0g09HG9SqGJcwvF1fr8rckJd89wx5MWX4KRB2NiABi4M4NYK6hbM76qJAv7RoTkRtgO8wWZ5kyBIs2i74/Rr8BjPcujvk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:10 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>
Subject: [PATCH v3 net-next 12/15] net: dsa: tag_mtk: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 22:32:12 +0300
Message-Id: <20200926193215.1405730-13-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:09 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aae52fdd-39c4-4d1b-422a-08d862530079
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52958970886372893643A3ABE0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BFl33KH635+q36m7/VvQJ5TpX4otM91pa1V0mTsdW0PjYnmA8hhSNRzLlswpORUuXXnBvusp5bUc+1T4XRp+qLvtk0skmY4ddMU2Y1CidXha/6A1qw2NoCPIi9u4xOkGV9/bJsUNMy+CUP6JlWNtSeQckUqBtMF3Fvlb+AvOcLbZZUbG6TKvnoOthmyzo8utNM8YGnAfjJuz4vID7NWgsAtwXpArGY5wFUYDUJUC5HJkDFxaM84RsTZ1WeYiZQ1ynPCpO387xpXcZTjjtdyGur+5SoGMknecylf2Gtd8eRpVW5Uqm7Cua2HXN4DeuDn09l1Der9Rr5tJN1lesmE7nfWA+uFBemJSF3fxHXCeIPIhIajSJNt6BJbDkwZ1uUj3pOW6JC2CkxgIWvkkrkwwrhQZ1oW1uvCw44wuPcazXf3libaZiBubIEglIvD6IFN8IAB3PlaWzWLgq7En3B04Rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(54906003)(4326008)(69590400008)(66946007)(6666004)(316002)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OrLlx3DBDb3jrlUlYZJJMUiI2aHVXoCj64OigK6hVMkg0BdWHHLhwK/Fz8XzqFxQGCZym76aaMRD9PE08kDIrOZUsVqm9vH06enysrHSSpOHWr6KK7VtLshOquw65oeqHIS++Z6x33QpqOvHI32e3hYm8cNQrmGMoU4JKbCGMbHAh4hokhvT0Nt22vafIupsArwINXoxHQx8P69kGwXqmBIZPP+63iLBqs2Ttyabcrqi3Hg31gpzloqDu8+UnYUXFPU7ViVpnBm3oT78r8Lp6FFjaXw5SEVrG3Zzhsb+WU8Bp0siVXgPdC5bOcHbzfOZKwkRAS2XBct5kFmu6S6kRg1s76q3Rvi8FItH73HIcQmNfMioL+Zd6gEqOxhuEY58CC/R/GdW8P6ePqumeRQkDnp0czBJ9CFeoAXph7mELxMYnZlRtNFvfea48EadYRdTRTVFXpH5QSLjVgK6w4xD/qXTYLCdYtYtAKzGsRvNIidQ66SsGuTU5Bsxawbkp0zU2Inei3b1EKVLAFnQWBXEv7NO8ObGP4foi8glfiz9LEcNbaoTtYwi/02yThpi4ICDNkETAp9F7UBqrVj0EfJILY8p1l4RXO1EFqYMtUf8WXpcU7tLlTmCz+Jlr0fY/8bt6jQzX3vRIMEHYXMlhNo7nA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae52fdd-39c4-4d1b-422a-08d862530079
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:10.4728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N2YArcIhQwk+zKJsa55pURGHtxMwE6qZ001SRfDAwOAw8e8zlMEqVfgEigjtuzjVoDWBUybZeKOHnR9HrqkFEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the .flow_dissect procedure, so the flow dissector will call the
generic variant which works for this tagging protocol.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: John Crispin <john@phrozen.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Remove the .flow_dissect callback altogether.
Actually copy the people from cc to the patch.

 net/dsa/tag_mtk.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 2aba17b43e69..4cdd9cf428fb 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -105,19 +105,11 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static void mtk_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				 int *offset)
-{
-	*offset = 4;
-	*proto = ((__be16 *)skb->data)[1];
-}
-
 static const struct dsa_device_ops mtk_netdev_ops = {
 	.name		= "mtk",
 	.proto		= DSA_TAG_PROTO_MTK,
 	.xmit		= mtk_tag_xmit,
 	.rcv		= mtk_tag_rcv,
-	.flow_dissect	= mtk_tag_flow_dissect,
 	.overhead	= MTK_HDR_LEN,
 };
 
-- 
2.25.1

