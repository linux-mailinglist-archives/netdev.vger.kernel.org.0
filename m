Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A09279B68
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgIZRbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:47 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:61761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729870AbgIZRbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ir34VFFYgT9tm2d38RmmgYiWwj+GH3sccUq7ZnUE4LuStUdkwLcufKPI1TROZ6AzvTq+4WelBC+UR/pSYBmZeGKiV71uvlDkEhnpTA+JN3UUnVj/PFZlBNdVZVXGiCmKBxvf7aNuxziKHW6JqbWQF+Ker7tI/yvpKBLTgccyxRN32fzc5dkhawWKLM1530GVTsriBeMaGrTbovrGkwd4H8bmzyZwv9y4hOiKtC/lAYIfWI/NG7c8xJ/DAMkvPnovA603PjMANdrCf1HoT8upzxXHMEiBYNCXw0y7jeoFGAfKtElRdXdeS7SzGMyV4oBMZIUiZg8e9FHCY8r9/FZIlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gWpfewtdKqnyq450tMQVdcXbEQ6HboohPrvib/qlkc=;
 b=jdYpemxOypdRJ73glK2l8TndNzbO64Bkd7d/p6FVHXHj0s8NodyfW+Shn2ySYTMl121ZxkdfljqneZt/Mt6hcrMnndq3GsWwjU6634NGAPQUqVmJeOMMEdD/+Y/+26g55ycTjBsDKBTWLRo17DR2XkLe2DNvyFrIdo/0IpflmJIFeMqd6Bpi1vG6IycjBMLg6ND7zZey407r/+Y/+/XZV9ASf5xVCTHi1duDpOq3+EgDEWIGmq/bHbUgxjsaYG2jHgSFxHDeFlWtADlcHHzxTAnMvBuR3Wc/zxQFLTaXcX/bnLHDUPaQnhbCmR0fZG33l8/8t4Qhz8DYP95l6Dcx1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gWpfewtdKqnyq450tMQVdcXbEQ6HboohPrvib/qlkc=;
 b=EDV8YQLW/DRup6EyEJuZMWDz1OqSBrWxeOAiiqM9RSu9U+u3xupZpP8lZQhnq7OVhjfn8dzvphstYo0S81B4PMsJ2XjswtNUHDjcfpV+Rc/sohb5gueTjvSFnrHQp+CapX9yxsG7dgLeEzYXvZapAp4+MiQRlbYwV5PKLYszFuU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:32 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 12/16] net: dsa: tag_mtk: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 20:31:04 +0300
Message-Id: <20200926173108.1230014-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:31 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc8d80cb-c206-449d-a747-08d86242026f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4813684BB4D53BC2B43DF53FE0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8nip4UN/QhJluNsbffXayeh/cnsL0UXLj4ncpzKjM8zSUF5UsVuyFDwtMC3TdJTysAYFAEfiPERbLK/HYUidKXkj+fep75AYQckFPM3M8ydl7JXjGMp/qNL98UjmeX9LFfpkTK/M5kl6z6GltwEKUGNynLWGsz8Txjj7kl3KSLP27V9GJfRtBPMg3DuBLzYLD6+9uSgq809ErJeJ7cqhQ0e/DjRlFkYvcbGklTzIBhMkQDUydtXTf902yP0sfvzGt1D6dI15tUKPko0FdEaegF8qUseropa6wI0yINo68NakIKNdE6c13il4oIw7ZD3iPH71o91bB3Mr0Izk1z4/Aa4eo5HyjxiAKigihmhCQ76btwf+ptUGBtgHpLl+Kl7rSlkNFRLR+8h0ITwfR364dxM7QtJS5D1nWXyVCHYaCDTdR1M5UoaldpjfvRMjcHXXhaqnMHm4kFLSxQoYfW0phA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(83380400001)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LU+iqfcPnSBxsUhvRvc0SzrhXBqlfbtM/C9/MAve4y8oDQC/y1kQSJ9LoqveNHEiZsoUB/ut5C+xOgT+usOtX4DPOz+JoqRfp70LlZF7bkK8kZydL4Iyn2eL0vkqfzST5/uqOdKzZ8TB9VgYFDGaZhJZr7ml5F/4kUbJtfKs8xDDQ8ENhsnq+VYnZ+wf5E6dj6EyCZyVxmUMXaa1xtXwj1ADhUWqZV2i7nErKEdSiQTuniPR45N8/KyacM4zbM5L1iQQssmoMCx8V6JAWyddLWKRR8F57PHyi/TZbAijy+8JUSHl/nfPbzvRqOm7b5AoJ+ZbyHVRdl4D4OORrNhSt/dwOeX1WJPHyQ1HovnD37u4LUMsuU67XpKXFq7wC9XGjanv4ktOA+Aw95LmEjmEpJiSzMPKgJT0s/tNYfKFoA5Ptkuze9W29e1OLdVTea93jmgwqlGbC1bfAJSt4aN6yYoWWWExe5YOENovLUkGxTAkO6X9bkn9oAJVzdJee2jltn9UqB6xsMvRSw4oHn5sn+732BNwBTJYbvLRJH5iE16nEqeRXmatE6xE5O29/894/9/Cne7zbU/70qcIg5nWA2J32F+Pn6VYUegRred0kO+517aNd6PK8gFY6FUmdfJqQm/ExgVybX14Ckk9uivGOA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8d80cb-c206-449d-a747-08d86242026f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:32.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2hU1XRDrwD42To9vZCwjQbDJnYXzByZA7HZhoUD59/QTQpCrloN+zFqs62cTKs8ilCMrJ312yNG16RE7feNC3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mediatek switches already account for shifting the frame headers to the
right, replace that with a call to the generic flow dissector procedure.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: John Crispin <john@phrozen.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_mtk.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 2aba17b43e69..7aea20b1d58d 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -105,19 +105,12 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
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
+	.flow_dissect	= dsa_tag_generic_flow_dissect,
 	.overhead	= MTK_HDR_LEN,
 };
 
-- 
2.25.1

