Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800403DC158
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 00:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhG3W5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 18:57:37 -0400
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:20255
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232817AbhG3W5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 18:57:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQEFSm9+cMWrUyuBRMPxUjR6ySV50+htF43mmSxk6oAAGnUG3F8bToq1xdZfQgbUjb5BJX3500FAD3qWgGQZ2vg9dLyoczRAqZdr8LpSeQ1mKbjJLJN6Wc737fJvJE9nZIrNIPpVog7D/xrv+9er9RaMqGnk+8/xAlqiMLKojV7dkzzWFHOLBtovJdDGyWnx6Zw3HR7X+rif0mPyHctoVuUx9ai4qPmDkYEra+17EqaQv888LPVbhJpZO7n/2OZ1GBxvpdyadgRzT9h94ftt3hMKVVN4JbHWxA/7FADWkO+wYbmayGCWj0TWTM5HwEXAfCFTBAVg1vOTkhv6HRfKkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygEgWRwQao4h9pKzxFWuo34nKP4ccDTDpi5EthcAWEU=;
 b=B1OgWNNN2iXa3+i61SN1Q9XUZFGqGZwZ6HOQP7OTNf9f8opf9vZuwMc2Tk9QRbOnGxSd9Io2lpcmtVdGSc9GqqPIP3yPHe7akQBC1yowpPfcyOpY3lSYZ7RGritJjCum2aIpZKmaQQeNMj7sIKlO5+h1d+YZ1LYHgZ/Smo3vFdHCXv1NwdqirLL6bzgY5z4C6mgd5xPkiOdmx35Efk3MYFvwMVGXED9xsokYek3MXAYCp/1VtQWkYczO3OFzFsGx7N3JHVlsDsVIy5bI46MHw0tdC+JskrGhXTCh7Gf8DC5pMn7M5nv/J6idiNFX0DH5rI8yFyts8QcsFlA9n6tp8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygEgWRwQao4h9pKzxFWuo34nKP4ccDTDpi5EthcAWEU=;
 b=UeorjJaBR/xu9Z639sHI1uWtD38BPZwW0xLPYzo4c66L+wXWMv98aNLW5gKcTR3d0nmB5+nDA01RS7E9dMVCLjruG7sCe8TC6OYv3/d1RiMAKdSd7vLrZcahA6AWXikAzWShkMDNqei0z27djYhmXqTr/Hr7UsTMCk1Cm90mmjA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Fri, 30 Jul
 2021 22:57:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 22:57:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next] net: dsa: mt7530: drop paranoid checks in .get_tag_protocol()
Date:   Sat, 31 Jul 2021 01:57:14 +0300
Message-Id: <20210730225714.1857050-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0127.eurprd05.prod.outlook.com
 (2603:10a6:207:2::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM3PR05CA0127.eurprd05.prod.outlook.com (2603:10a6:207:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 22:57:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68a8e731-f689-45e3-07af-08d953ad66cb
X-MS-TrafficTypeDiagnostic: VI1PR04MB4912:
X-Microsoft-Antispam-PRVS: <VI1PR04MB49124134868E4A448901CF4CE0EC9@VI1PR04MB4912.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jgJc/ZeNwNmR4jHP9HweWecveuDYNLR1oVOACy3fJrXqDsGxD213u15vnS4qEgko30a80PfCfd40OYan0BPZBnKt5YghH49NvJMY2m+z23/jseAC5Agqf4oduUhR/SGTwOoI5hTXfPegJRZvWAo1EeyUKUmZ3S5+xKUU4Bo6xbC5RzzDW/ACHJomx1YwyiJvP+f6gIG8XA/xn55UTmxjbOZDBiX43C/+nzoDYYudjVn+AHdtZEY8vPMJ4RrLTb4AOj2ucT7+izGdnOIPFfsN6xiXmOOlmuG/sZnWcZe2DclrsF2xFgJxtI9tvQNEG5nVNLUzlbiCtURSxlqLPQavk53h/JGfHrDtIu6KvW82iisNEPfpAI+qAD5HXjiO5YizfyPJOcCYMaJUZAE6OHNmAD9i7kI1Z93aHTuoPAWMxQl4bHiJjXOu2enT0hQ80tB229NJgVLuRb3PP8UhrztQpR+F+6qdSv3ipCuGFDkpMZwcxYRtdqWWU4+mb5e/SlJeb7nSnwu3IcTPEom7aQwCU1/96vzDKHZNOwuB+CgBnR1NwWlzixl4uCoLjUQtlgeVBpVdQW915pHDFbYV8taM2wmSB88PXNowdpmJXOpzsVK7UgNiollM4F0jFhzMvE6oZVxaVrkpgyAUcIwGrC2Hi6AlcWbqoaFucjhw2+Ni28Y80VEaUmDqugI90fib2xT4empZ5qEv718Ow8YJQ0D8ZApsCQqw2N2+690cwMGH+50=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(346002)(366004)(136003)(376002)(5660300002)(83380400001)(2906002)(8936002)(478600001)(86362001)(186003)(38350700002)(8676002)(956004)(110136005)(38100700002)(66476007)(66946007)(66556008)(6486002)(26005)(4326008)(316002)(6512007)(2616005)(44832011)(54906003)(6666004)(6506007)(36756003)(1076003)(52116002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pVqFzWuUtnhUueW4q5lVAKFSL4GgTynYrlvMz+bHa8DyY9fpjUcPqUOrOBHy?=
 =?us-ascii?Q?GQYnvrtMdFWppWxORfdE9G9RyzZ9urs/VJ21wQeYjhc4oEKSkVu7Tvl6ytq+?=
 =?us-ascii?Q?FNTdNA+akUv2hQ48SN1Ue0nqmaDqgpJSVb14gppSxZlHmSSxLvdjxJvTzRa1?=
 =?us-ascii?Q?W6OYGGHkOYh98Naf5UvtQGGQO8HtOhm/rePxc+RcK+PgBhvX3X0vNjQBK/mK?=
 =?us-ascii?Q?RbJfxaUf1q8ysf9iL0HgC7Y7vpSnGZco6GogDJURV8kl4GTwBmRrZyqVyoen?=
 =?us-ascii?Q?cyABRwPrBkCIsAkkhfRHTiZoR8si+gyxjFrPGYonJE4n54rLa4FNgEFjwKsK?=
 =?us-ascii?Q?SVOG7bKrAykyNuGNn8FvsKcyCw9TuPSs8piXnQ1ZHGc+hoXZzKuywTi6VCZh?=
 =?us-ascii?Q?w1rEsVtFeZnnSg5klQEYBDOe15tOrKCD79Ze2zl5RnmxsJ5/yZDH70E7OAjX?=
 =?us-ascii?Q?FaWIthrtc1yyAgwX/PdiuWGAsQJob6pSrAx0PMyI2pe/9QYNTuW5B32ngZOJ?=
 =?us-ascii?Q?8XUMyRACjqBiMrJglaYpeEOtyzOwl5kYLcAf7q6aSS6b08O6CedUhbkFFVO+?=
 =?us-ascii?Q?6xxkPpXUyKYKWMBaQTH3C7tqR9MfdRKh9X1r8Fe3xOtKA1rIFzwI35YWUGeI?=
 =?us-ascii?Q?hHop2OTIIciDFtFFr6hNb07xCSUKDfymDU22f2yhkAf5Ln+mTNdw4AK1tve0?=
 =?us-ascii?Q?ankXoUalPTCoyaL9OcpGtW6Bx5BH9nS0I8QU3Ek2eqlkw8L0/uQAwC3rGDKi?=
 =?us-ascii?Q?MyU272vrIk2eA6ybE1jPg3dCs1QEO+wkYawB58Eb0mnevp1aIdw0mqOHvMoa?=
 =?us-ascii?Q?OT3fBhUaHWxQ1Dl7RT5po6c3RXveexzRNzAB8uN+0+e5QvClwGdp0OAqtAFd?=
 =?us-ascii?Q?M2SD6rmiR63GI7vIEIsHOcmS8t0nnx1+AiSZC65alOVSZMmuQOoTN5qAoHS2?=
 =?us-ascii?Q?SqKQJL+aqoEbXxKJwfanMcn4B7WMKEaJKHAvSsHbQ1It5+Huwhq8qy4iT/DR?=
 =?us-ascii?Q?4J7FLvLqwomBGsu2OVowMyw/s0Ira3e8sgnAqwYiXJ+q3EjLVzT/vXdJtxkV?=
 =?us-ascii?Q?HptiEbp4kSjz8CelVUCh8/9z2vHsLsdca5rdJrWzMLjmX7K8j6shnuiDxJ+2?=
 =?us-ascii?Q?WrgbZhSjrdmui8ZYN88XI47si+vLsyu3MXQYtHq+GGS+jKwibZ61d8LD15W3?=
 =?us-ascii?Q?eLv48ciY1ZXyihBqM0SjGw4+KZ4l4UVawFryXgBnct46r7u7GS1eiGt8eFkt?=
 =?us-ascii?Q?gmBjGlAw/dZupYcrLmtjlg/5E8lQAenytTYIInhVXRc6/I8on4BszHz4kkhb?=
 =?us-ascii?Q?diuOGlBVPg7t/q1slCbe8D5O?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a8e731-f689-45e3-07af-08d953ad66cb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 22:57:27.1023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cu4rMXTPksEzsw+ofgAIX3juU7e/EVpIdUKU6sb+QOHX4gcLikwXnkwoWtZGwYWAPWBDdCY2WxYNwOEnKDphnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is desirable to reduce the surface of DSA_TAG_PROTO_NONE as much as
we can, because we now have options for switches without hardware
support for DSA tagging, and the occurrence in the mt7530 driver is in
fact quite gratuitout and easy to remove. Since ds->ops->get_tag_protocol()
is only called for CPU ports, the checks for a CPU port in
mtk_get_tag_protocol() are redundant and can be removed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mt7530.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 69f21b71614c..b6e0b347947e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1717,15 +1717,7 @@ static enum dsa_tag_protocol
 mtk_get_tag_protocol(struct dsa_switch *ds, int port,
 		     enum dsa_tag_protocol mp)
 {
-	struct mt7530_priv *priv = ds->priv;
-
-	if (port != MT7530_CPU_PORT) {
-		dev_warn(priv->dev,
-			 "port not matched with tagging CPU port\n");
-		return DSA_TAG_PROTO_NONE;
-	} else {
-		return DSA_TAG_PROTO_MTK;
-	}
+	return DSA_TAG_PROTO_MTK;
 }
 
 #ifdef CONFIG_GPIOLIB
-- 
2.25.1

