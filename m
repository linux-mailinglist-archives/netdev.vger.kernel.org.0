Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2EF29FAC5
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgJ3BuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:50:00 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:45367
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726152AbgJ3Btl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HxsIj3PbOgonlYg+axhrqU4glWRAPRjFycxbwi62wHoLObY5HTKt4Q6gmBRhEhKcmjprollT8i6/3rMwUHGXUQwfc1MXsCj8a9EJRzMlRFHrbfq0sZdqtvgB0vEBTn6U036GNassSSxmFKp1kLeJtMUuThezewoiUZ2MWieekqpKzj0M/ELTKpPGTbpLzhyg/86XtqrLUPf+FKpxWvt3Upge638kPpZYV2tGvtwSoOsS3EfX5GaC7kMxxySkcf2BG34bL3WmZa+SV+j3SzhDYBGchNmTSR/f5MGWKUvzA58oUoQ4h/AosMLhjHhllZ9xPtoqFw4QfNulnInnQHS5hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5duhinMJ8Qh3fGfgzgxY+vqMJL+QuMAb8iX/f2HmP2c=;
 b=CCIMEPOFaWw/RVaBhNY6HaG8ycqD9h5XQQaqYRioFcv+CQd5A5BF0mAwmxzhR9NTuobhDwXGPsiGTRC4cIW4stIh5a6akVs2uRHOEjxQZAOI44uZwnK2v8lxOJGldl6MJbOHpPSYtT3q8y0cmSqu2F69HOqB2/9UFsZ+V0WlFG1TDHZYC67bsVWoJPBAPeY5wm5+5Ki70EqfVgfY/6Ro4hW+uApj6+uFlyzNLWnZ3niOsV1Q8dJEX4qwIV93Pp1+V4R+QkVi1nmuF9R1CgU43lJJyFl2IxFfKrB4NSmkqyGn9f8FeTvH7fBbF3MtvZqbL5sfByaNMij3jEQ4yuEMEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5duhinMJ8Qh3fGfgzgxY+vqMJL+QuMAb8iX/f2HmP2c=;
 b=CXopOIid4Yxsq3KrPfKGziTeslpn5cf4uagB6NEY2k2qccx1LJwvErUSq7tEM/gPdrMzOMVHLeyMAVdNYWMKr61q1bbV3SD1V5lB4u0YTuI5uDV+BiEnacqIOws5jqcw0kDiOBhntBz58YDzg7PEgzZEP7HyuCFz/oXQ/pvqaVk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:32 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net-next 05/12] net: dsa: tag_ocelot: let DSA core deal with TX reallocation
Date:   Fri, 30 Oct 2020 03:49:03 +0200
Message-Id: <20201030014910.2738809-6-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d0823a0a-cd58-464b-b06c-08d87c760c13
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB250982F5A9A8FE8CD430BEC3E0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+sNjRlWHxrHjWNt+z9etPYk09wxKipybEpVyktGE+si6wMw/XCoLYfIwrvuYeTPJPGLAje5xfiuNnR//cg9r5SLFbgjoZGPA/OMl05sr8EO7FJGy5WZjET4m3KOC+XxObptTaNzbiWzAXwXknpBnSdLC73wvnC6Xpm2GELGLr2nFPYP7ywY5g6Nspwfjd545+dsIVUDjDO/NRlVPYZf6pFvr4aWmyG5FSGPpv5rsGULpuOtfiVte32GFW5ABd6ZOrhPF3MnsRkQ/u/ZJ5MW3Ced0znIJjrAuCHIg8U+L6k8yvd7AilZEFY51MpdWgwEp8sQuxHkkuz/DTDWcleqhXSYhs93ZtPgUCv0VVGoICxpOc8SjVHRrpyKj034G/gW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(4744005)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JM+o9l/e/9myPBIKGIaZtAragNIPPrWMTu9t05y9B7MdxA5YEZ3CIEZU3mCIn9DU1SP4qXxABnUEBc8VvriRiQDISl8M6Gnc/2MhyqY66thcXwmGT0eVriGGDqFG3UXUMxjKdeKqwJt1V6CdI9s389XpLVmqiavEdjXxoqzbTXTX6C9HfvNqlvmBzwygDTizs4/qdTkkON+TubQ8z5CmTHduM7oTUtxj8VC/YJQUdaDkSx0OPzfYMqZ3M3Wel0GtUWzLfpO0qFyxOGm63sZ73PIGlnWR2uWb72voOzPpF0Io6ZvHoU6wYULVivWnr3/jk5Siy/N3ZyjuotOa4Kigy5SUA/Bi5bTObZmDBwmL/40UNTrpAiwhyZOjzijCTLAoWaOgN2I5gL7he4jo/714iJ8vTitcZNgt/UkSmQ3XWz4zlot8/6lVUzdNHuk+TadOEbJRZZ0j3Sic6gYDizNnwcDyw7UynlV0UGk2EULeQayPCX4WlvHWNlU0LqkLt1ZeGl0cJOe8sa9za5tzCmLbiqxXVq5rFUyg9eul/xlimE/VZ8cPPRwb7VQZGjIyNb79kpLuMwucANnEigUJEueKXq+w9g1YxsN7wfR9wcTZKH2UYaanl1wJoqFZ8cG9lRu9yuH/9LWvwZRw2PoAoXeMaA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0823a0a-cd58-464b-b06c-08d87c760c13
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:32.5356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/3THVx4cTfmC5Gro87o+6K1lEcyIC15UN1QhGbGoKV6i3qic9W33f2WnUydSfMAEZin+bv5oubuNSuoZ6BSCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_ocelot.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 3b468aca5c53..16a1afd5b8e1 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -143,13 +143,6 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	struct ocelot_port *ocelot_port;
 	u8 *prefix, *injection;
 	u64 qos_class, rew_op;
-	int err;
-
-	err = skb_cow_head(skb, OCELOT_TOTAL_TAG_LEN);
-	if (unlikely(err < 0)) {
-		netdev_err(netdev, "Cannot make room for tag.\n");
-		return NULL;
-	}
 
 	ocelot_port = ocelot->ports[dp->index];
 
-- 
2.25.1

