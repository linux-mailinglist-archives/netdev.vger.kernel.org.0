Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B6829FAC0
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgJ3Btv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:51 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:45367
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726210AbgJ3Btp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvGXNyoqGSfXDtWxuDFBbiy3Iqsr7Kbr5U9ijuiZMfp1J3MELpAJqgJV0VWFdT52OvjS/mO8QEnkLVCJc0XieDA55ij796DouHea+CnbzsETM3i/Sjv9+gquSc4GeFi03jQJu5U32q59mwYgqCYYMdR9bfuti6pCv+ZBSkyNiBWzdUnUUbo4O0trKKAS0M2uozxkxQctxpSEJCv7jaq3tE+Kr4MqkxZ3PwSxt/N5NnVhae+lyDfUYYJrJif26Evur1wkkihkU2EBPPphprUg7mov0n3F4JjLyygLnElVZA9Z1qrl+tJFANKC0xIvAvCl11YRfM5JSl9SGOP96VuqPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKoYOwO63hyMyVeGFZxsD3lcZCjBvdDcK/lk+WVGp0o=;
 b=lKpXHsoWGZDC/oafNj38s2+ls7nsZdTc2+yPxHciy+ktIcuAeWOWKbl4tcDxSd27ziaU/r3csjTaO6wxcdB/IUhE53PuUKK45O8i+2iDHBw9/u9jErg8ELDbU0tMEZhRr6Qn5Cctkj0znbGb2esE5Fs6rOhH8zExxsZJdsE33F+pB3h7zFEAy5XQrONDq+0dvYDzinR0MtC5/umC7g+scAMyJlOxKDKxf9QRFNZgXFOVzWjqS94az6uM6FG423MrkYxPWSYBAYwnFXxGOOTVzxCfJn8L7SrD372AZdttjvKkpYSsMc714qLg/bSrgGNJT26h0B1MnyoLdYSVjI9mSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKoYOwO63hyMyVeGFZxsD3lcZCjBvdDcK/lk+WVGp0o=;
 b=Nh6thciue3H23PYgmF3Dz3ZdUznh3C8FhBLTuZpFqhQkPEP99Q5lkGMbzPU5rE6NkPJxPuidCp0ACWz3VF+4mo6VDVI+BvnKtMfzUL0jDXOGWpw/MtH0lSq5zpzhsdvTnnApq3AjlX27V5qfzKa3p1rIWqQa6R7YmpUecLMq2uo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:36 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net-next 09/12] net: dsa: tag_brcm: let DSA core deal with TX reallocation
Date:   Fri, 30 Oct 2020 03:49:07 +0200
Message-Id: <20201030014910.2738809-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aade3a8e-872b-4014-189b-08d87c760e8c
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2509F952AB0C91340075E603E0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uaq7OXWm531RJ/YF8NZWSkxx8LHCP431WOJF/AxNk6N+YBh93SBwSe4wzWvcdDl2mIPhrrI4rGQmqpGAXvB4h+FJraahi2S114tXdZo75fUg8mcnXbOzIfbbMewXHhKNUW3hh5RXH0Je1uF3gm5+wvdXlfLYPuR8dHPXFB/XN8hpii+/Oc/ZnmLGS69Q1QKpv6aUHKoAOK6h3PQ3ZV9mM13X0ooP8jCwrOfW3RlN75MttPQb3qfwgdVg4VHRM/NUGZI3nexLSGczU+f9K7LFKjc1dyOqeR4FUVvlzrUyVJfckD96sE85587Q+HECIn7IXcL8sPiDY89YOqr7wPBchaM5PGaOpz4JBDARtdQX5l4M4ola10oU6cUFGJTKnTFc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(4744005)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: X+wNSwV5lge5BXOTvQ0WiBrkP7jYHrZUfMkfyKjVRJHcWi1mukL51uBb2TBk0Ev/exLoMrV3wZV0EK6UIzjZIz75FyzYDfWCV04SscvIjsZZNIRO1DNAXq12le37otsvE1hAL23pLzdSB7MUfVtjl4rQNZOAmvHpvKz4116X7CVDXceCN4DhoGFygRDcTg4as2n7UF9EqQkVXspIr8XOt0hQ1KtQZNhfUPG60LauJgHIledEGNsDWRV92ly6PWUC4pN7MkjTC80qncuRwFMCn/CG7q2fj3bZZei6xxH/ttBgJzvusaAFncXj8E3H4KYsHVeAjfOlxvuvB+CSAhFpE12AtcIiMKyKMyO9Mbj/zMfJMujNanyQVUtdmie8Ormh9KjC77a9WvULdqb7Biph5Er5z5wnYUE4yLWLZnZm9nq7Lx6d7LIKFv3l/BBOrwlUmOxewDpPRH5q0fqOdFzEfqykG+yOCRhyUgyWggVZXuXwjtgnNFsq6h9wUVALYJXErexe2Os9RzGzxKysol5y/cjYcBRbO4QlppsgETRHVEA/FixupR3hm2uLTDCmZbHWALn6wjOxpbNtc2FlltMiUifOJ3NF/JEDxdd8PtZkMfizS4DnUOMd69AvOETiQpjZyobD4oqlIuEum7T/qk7Siw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aade3a8e-872b-4014-189b-08d87c760e8c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:36.6571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WiVvwMBdl89tddyXEx+KlVehjtyFUr4l4rrFUFPPPzRuZcPlKJI6CYNjXbQF0wuLANRlzRPRqValTTw0YelxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_brcm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index ad72dff8d524..e934dace3922 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -66,9 +66,6 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	u16 queue = skb_get_queue_mapping(skb);
 	u8 *brcm_tag;
 
-	if (skb_cow_head(skb, BRCM_TAG_LEN) < 0)
-		return NULL;
-
 	/* The Ethernet switch we are interfaced with needs packets to be at
 	 * least 64 bytes (including FCS) otherwise they will be discarded when
 	 * they enter the switch port logic. When Broadcom tags are enabled, we
-- 
2.25.1

