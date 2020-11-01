Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294032A20F9
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgKATRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:07 -0500
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:31354
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726873AbgKATRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhmAMxDtKCazLSMnRmZGhlddMn7lhxxtUkGnYlMkTPDhSSmawMQdKjoWH2wWxH7G/2pHfOg5IRrYZ5yhwfTAufg2ZnfIB5aJK3UpQatHNuFLpfZ5OzxqYco2lDguueInURmgrlqqUqfRh76MGGcdiWyYBwpWNqlcHumlzCI5UIjar0q4uVLsTvzyapZNfu4XN2jff2l+3jGxLsXRw7/UoiOITxFfltRkw0SmZwOMs8yf+V3QbvrDoePWLQKjCeX0X/oyCJge7aX+hlGtSPC/aTDknEIk/vcMA8b8wglA5dyHu6T3g0N1BbwIlOZmqE+GAtQXv5WRomT0yv+vEaxOVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4TtjDkCNleuJKf1wCx8b2YnhlMCZogSbiK0KoyWD+Q=;
 b=BZed/2iu+JGljAasjOj3D700P6SKgJUzzZ8zGUCLlQMmPhMY4xKVemHBdooG+sKf5q52d04+t8mz1m06Biftn/kk7QMKfVJqbZGkkxTBITavHpggFAjF/FMUS+HstnSLP5lXnw15556gJa3VYJ0aly0vNR8uzRydeN8N8KU7FLhJxr4t1MZMcEo1ezDMqhbWOT9vyjUYkW+2iW17xwPD/T1W0lWKKNbKAaHJPdlpJtvWc2EOsSosOD8lS+7ajE3GHNOtcOCUQ+0sCmpPJzgc6uMs6SanNjPbGe3B0LOB05FZj6o3x9pzS+EmVIn2qeVlZpoAYJOHF3zTeOpYybJUWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4TtjDkCNleuJKf1wCx8b2YnhlMCZogSbiK0KoyWD+Q=;
 b=KQvvatP8RGRQr4PfSpHGvXDySKctyUs0Y6E2x+3uQcC1KCuYLYf4PlN3kWxX//AsQtpJ7ORzbIrRNgfW3HTBjseNtGhNhz/UnoxIiq0ENZwrFxcAU48QMfooxnGG3WAT628ibTTUKSO6PulXEK7WekA2lpYvzquw9AkX4yoAhnM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:55 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        John Crispin <john@phrozen.org>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v3 net-next 04/12] net: dsa: tag_qca: let DSA core deal with TX reallocation
Date:   Sun,  1 Nov 2020 21:16:12 +0200
Message-Id: <20201101191620.589272-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f26335d5-6f92-4453-48c7-08d87e9ab1f3
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2861E1CBC38A862D50A76C50E0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iC0Qse8aBXQd0NgPYYZJubHamA93JZDuwaYSHpdChXGsMEOTBHM9BfvrKNop2c90WY9ImxRRARh5FW0ywEWyb+3MR7VZUp3L1ttYWFxhx3RloMX5/qHrrbIFFfvdjDNxeTLDz22NX1EeQFQxRmk6PcwJASauIGLWa2KibjrxuPub1Qd+/ed0vFW2+wnbzrxCGsw33qTlZ7jANIPBzGSzfGOTIfNAl5a0H02CfVwVjSXMMVm7ud6ZjA65+mltI4au0WeEcsl7ywXY4sDQaeEnQCxu5hp779ervEdyhM6cIeQ/RipKS5Xvo8hM74IN65SADWpNZWmOqzrnMpJILbvXgp5J15p3RZ/ibfSMu3dH7yg3vZmtuQ6sT5A68ZBhchsV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(4744005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: R93HeKygCKwtIQ5JwZj211cGE3VvRSAf9lajyac7PHTk4rxld9XOI7v/mTfBp9gPjsA+iUjbh0kCU+P5xwBWX9AwlgnifW5KLnBfi3ieOGiCLrktUeftH3DBk2nMoq62BxdOxr0+kgaf9oirtm0Nn6/4iqcM2nguLIBwTQp3gT96HJApYTxw5rLkrHyDCiWliVmhq9pQ7n7fF/czsoZCvxRjStdD7zZtT7fcWFerAnsSdfyO3JqpRwoyfR7AfiVxWefb5IdkbeM0lt3rij12EBrnZjT7zyDNyN0Z+a67vgC2nYGzuCUzxyIIgoIqpbDVnKBwQl43lGs0vFNGwouBwg4cxFTkUSHwzB+2HR6peuqrqHeq3jxbybiLgxbT0d74wzjV6vTxUZON7iBn5aOBmJ2pYxzmYVqqxxNnNN2cNdDfENXDxjbTMw00oGEgErIDj6htiLix+R1FftvrPFspN53GfdOSo1rxzbfpY3eh77llocz2HUfSiOxa7G7SwTtKYsU3XjsgfYvp6tgfpgkc1+ZKgiB4a7CfrPfaKjbf4gz+5/LhkkVdY+jAiUjq4iY8u5KuShtWUMA1kfnovvAzbYnJ6Xr5G+Z0+ptPJ895hqIPCyrKgjMPqlAspcHrxZsfSk2fd7Kp7a+kIqiMThlB8w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f26335d5-6f92-4453-48c7-08d87e9ab1f3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:55.1308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXfFNiLe7YBKAq0diNDhQ2yYL5jZyO0JrEB95brq/bV7uFRZja+GDAj2AhaFvnhbN7iJQKWwp2gsixVh+1nXHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: John Crispin <john@phrozen.org>
Cc: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/dsa/tag_qca.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 1b9e8507112b..88181b52f480 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -34,9 +34,6 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	__be16 *phdr;
 	u16 hdr;
 
-	if (skb_cow_head(skb, QCA_HDR_LEN) < 0)
-		return NULL;
-
 	skb_push(skb, QCA_HDR_LEN);
 
 	memmove(skb->data, skb->data + QCA_HDR_LEN, 2 * ETH_ALEN);
-- 
2.25.1

