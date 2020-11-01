Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5442A2100
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgKATRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:25 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:47874
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726873AbgKATRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcT4zcKmhWZX7TUIgGQctIrBrBiikPpbGURkJiw7mR5GGXNgJCy9CksP/QZ2cd5oN28PcmvBhLRP+UP/4E9HgStb0vern30ACwV6pOd5hH4cLvYLhVwkb9OvbX3qi6Em/9dbZEgXATnpnpDN55swmqMpwVxTlIeYi2e/ChIZNIZYt6fjC5N3ewD9WnQ/WcFgwkW2M8NmwQjVp6routts8lNdwu9DJqhjl8IWBeo4ctrK1XhFRCxDcSSC1S3h2ZRMRL+RtYrtyB1dH7ahCPV+Qofo2oXIaxWlzKvzFPENsw9JyvMA0EKBoDNIdD4XhehxpWa+Rqh825V3OxpT9Shz/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53ikwTOkoJAQO6kguBUsngROYQBBXDh++goawHjdc8c=;
 b=aPCYjE25+4PsRU4YbnGidSVXl7AADaUcQXz2CVjjafKgdqwo9V/aTmN3eUimlVnT+U/TNr+3mhjmJ5aZ1s1CW+LWZ9ky2oe/0Ca4q7IVnLRALJ6vwpe/7TSy81HIDY4S3VR+M0PfzCbm90ZiNu11Z3LZlA4pz7UOJU/S1oBLITo0BEh3Nb8EJARp7c7ygK9zwpvCmDrH9CH8p0zfmKEA5LW9BMkjhV52EbvPLQzOufQ4YsrU2TOsy0nVcB6o2ENKwAgPEzi0bMeWQ1ghquGMj5F/+AikDTCdJcIzxkNqVeNPJTDCC3plgb79DZdj5+f4Ex1sCgK42d233CiPGr2F7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53ikwTOkoJAQO6kguBUsngROYQBBXDh++goawHjdc8c=;
 b=qXPOMEg3ee4rma/jz/54ox+usCYoinZ4eStCbLyBaLRBv09Hl2rNw+Z0dONORPG0+/yrsnMLv1x/IGndU+S2MFRZnN7IA9TdfVoM0ovMUpqMNEAIEPqBAfI9vM/l8f6zC3n4SZYyBQzvaubG0KW4qFZEWEwmViJJuTTBNnKtcog=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:56 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 07/12] net: dsa: tag_lan9303: let DSA core deal with TX reallocation
Date:   Sun,  1 Nov 2020 21:16:15 +0200
Message-Id: <20201101191620.589272-8-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 107067d7-3d0e-4810-af67-08d87e9ab311
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286116B943D8BCE2750597DAE0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q+O8kBkJXnzwaXMeQBVooIkcQn/r6jNjPISxJX//Fu/pglwLLzuJKI3mlR5TrSCz/hK93fXlQIQ3JiVO4oFFalVcs/xDmXgxivKvRr8Mrc2Gqt1r1Osg+i42JyLBRaj5ZdeFBMafhTiFje6tNitIzvYp+jgo6kFuXnS4w77Bch1TfzoiF5cAomC/2vCT+QZxom3e0dF1/FuDOK4ecU58Q8txfPz0nnrfBEXVuoYhbRP5wL+FuEjhgpyjKv/Yjrhc8u/H7rejlmLValvA2Oy3TdQCYf9/+jlzh/QNlvN7bagH7jDqZKuUtM+5EoHgVhzV/KreEkB4Jf3Qu88YjrxwJDCwyjrgTpLuCH8YgZUKhJj7UCHJz+zdnjJOoBJ6/gbN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(4744005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ji3agr65LPL00iesfQyUfTZTyuNOE98Vw7h9QuoGeJTgJ4O9oPdYhD9RxGY/oJ2eWnQjDSoYsSZ/GcIHb1pNTNVNz5rlK8jC/t4i4fiSLRdTMBMO4TsISv4qhPZziD+THQohtdiyzPjHqvGSLhCB0Mf9csKpHsGqavBMO5pySS3iQ550kYK1YZmHmy69E1gYYNnjFigmCDT+RGZvhOcYTckWvvHyL+Et1h+w9NoiranBZ2TeB9XgjY+D5J/Vw9wpvtJ1Rads1Rxm1fXDs7rTsVTQCUWWJC/U8QW6cv77VeiXQhBSw42yJo+dPpW/PnUvaC4f4Z3EfgY7lx2dDZkrbPO5Pr90qPCOqY7h7j4/XQXcRhnR+RrGLC6Wpg34+cMRgk+SE0hr5mU8s9CP2byQ8N+UckiWXFpLANhtARH6fP7Tj/UE2/pR9UXZCMoPKkoTVnaSlyMhAuA/84Sn9OKbBqacU1PDFLZ/z1HlFwhUEnCpLl8ZPii58qsxIU56vhxWjBft9Pu3VXOO3EsWjuhPfR48Qd+qeMIB45SMa2VKiGxLrZ7PMT7+6jyIB7tdxGR/DxTMNBS/7ONQCnefnJXlb17SL5YldBiFh05DQ9fjk4IQ6KNMoPn/dmKOP020UVtrrHi9F0xqsLcZsqeroIiD9A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107067d7-3d0e-4810-af67-08d87e9ab311
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:56.8978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gHLh6KAhfHig+g2AmQhvy3fNfAqkKWn5WOa0dRYjjdj7WwzNAQE/qWpEcr//GqRcgp1SVqrZkLqBcLHKYgA0Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/dsa/tag_lan9303.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index ccfb6f641bbf..aa1318dccaf0 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -58,15 +58,6 @@ static struct sk_buff *lan9303_xmit(struct sk_buff *skb, struct net_device *dev)
 	__be16 *lan9303_tag;
 	u16 tag;
 
-	/* insert a special VLAN tag between the MAC addresses
-	 * and the current ethertype field.
-	 */
-	if (skb_cow_head(skb, LAN9303_TAG_LEN) < 0) {
-		dev_dbg(&dev->dev,
-			"Cannot make room for the special tag. Dropping packet\n");
-		return NULL;
-	}
-
 	/* provide 'LAN9303_TAG_LEN' bytes additional space */
 	skb_push(skb, LAN9303_TAG_LEN);
 
-- 
2.25.1

