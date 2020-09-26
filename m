Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8D9279B66
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgIZRbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:40 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:61761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbgIZRbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ajq2H4YTzwkn0/MA49m6wR5jEvE8/3aQJTwPwcG3tw5JCRXxZFcj7uzbyhDvSUeCZUZrGWSAJkGMncRcmZD+Q5bDg1mwwakpBYoV9m5VzXr+GczczDxRCxSAho/kFlTU/2C6+LMi1fWBCnYh9S3wK/0tmVlQXhpPWWa+uRc8gfZqnla7y75aU8s6+HdBWTLhN8P9eljewc/CIaIKHShNrBlXDSkHlMOLocy+usdBs95pe/lm0Zeq4c0FW+GSZpUACiQsis/Adx/T/Igab62Ak+OCL/Xxel08+/Fy06iFdkV63hKRBH/XAiBBWQQJMtYuuBV9rv2O3A7rwSzOT9vRDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTfpjC3l/eBsKhC7ibSLtiffVldP6M04U13rfR+gDBo=;
 b=QiI0ZeQw3BsUKS+ZetwdohzuE01/zjAItMqzp6uJZKj8SZBzHldFDfk21bDaKMACzcwZ+wEuIlRtIYgU6an3RGMiI2VCYmhanL5SwzlXkE2nX/sRMtxxKsAZpoQmAxT0NIbnF29K5N/9BTdeMCr2PraukcOm13nUA5S2mQFNz5quuY5C0uqRY6xwdKyQSmTkJrp5X/hZD+1wg5cpYvwHXCuVBbp9M1e7QEzFmSqtCr60ar2lrdxSpbBRTxcGnDr+gU1difKbFuvR1FNneNdA5idg3697aQJ8xvKRIom8r3UIYffxGhDDglj6ULAD8sad30oMRF8hAeMXbkL+EcwApQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTfpjC3l/eBsKhC7ibSLtiffVldP6M04U13rfR+gDBo=;
 b=jesKZxg62oR7D6jP11vidUfL6AGp/lRG7snwp+ZCWzCInc2+NNI1fEUfLXBAeLshi8FDNt4HrmI7Vsr3itvAclY+wKv8hE9b/BPg96/oKxZ14g2la1Bg4YA5vL5vX5quLzUuEtLl3eAHBWTz/UaI9FY415ueQ5XLxKha9uk4buc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:29 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 09/16] net: dsa: tag_dsa: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 20:31:01 +0300
Message-Id: <20200926173108.1230014-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:28 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7956dcdd-a9d1-4b1c-d92e-08d8624200a5
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB481323BE9A34B9EF146B6320E0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Wl5RLR5q+jakcjuLt+1DSFKHIZ62cTCb+QHIDgQxxeUBWKrKBvdAF0mudfMd5cMHqXFY+rIL+AW9Iv0bu6yVNgwzc4aP7XMJCt/C6O714rejuRt7cWOE1vfwIu0BrvKrIIPx4KBMZCGcyoRTAwDpgvp4dDZLCWXdANCnyuka8nK6+8mRJDDcVb60HTB8rQPr727HdOzqlgTnFOv/vAxY69iiZVk9vTOn9Hvp0LzSYPwccwB3BKZtdYfPJPwsBW1Kqch/Uw4/qOaCcY4IZOpGiDv3xKMMeNk7Z+4d/xHygG2tNu7fshK1PumXOBYIqPEZxTL8Zw/VO5JynM9B0IpRM5GGvEASi8cAy/gf6iXy4iq1F8HbAWzOfjoe/r/K68HWq2JNsNhhI/DVoFiY6frY3J7+kTzakNNdFgA0sISMSDIEzGvhW7mUX5cTcH+U51AHMC0Xhl60zhrBr60O1ZCIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(4744005)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(83380400001)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qdnIlhulIxuhuMgPihb/mAtJhl2TOf9i3z+jQISOWfUq23TpjCmANXMAhzOvUSFTOVWFWFENZe5E2yg2q16/NwS//CKFARpMrGlzUr0ZKIpKxINZfV+5HIvvO/99gucW/a4JoKpd0Z7vxFV9i9739NyDEOFRUgqbfTVwlvp7pFKh3edFX3MXBrBI5Xreq5VI4VZ+YGrimCX5Ex4t7F9b24yIyXRwsZN0MBPdvWGReZdsh0my0WsLHM+gAW+gJ6LcizUkJzbnkWW8gFJfp6Zq3+GHGQvnPb3wuzH7qGKSakAwwZI+kvjA1clHWAfNupRNPRH+/Dty/MXfVwG8daZph8zTuuoRBXs398Fo8cLIwYNyyWIpjxDmdzqRlp03AGPpS3rsMIsHsKt449rXVCGdbVM36u4rc3dPSZKts0K6IzdiOk71qH2/70BZvB55UXlx0P0D7UUyXI9EHUV3AGPHShmMG+yFbIwHl7Ar9kjblkBo2ik5r5GNkSdgTzERBsMdXFeldwz7o42aY5n5i3DrKRPlxprybgcBeBdVMcBTIlW+7wlGjANyQvhLJKphu1QS3Ipj9rD2mP1bnhziGZrfUl7/fhOgFIaeabbnAgiqPjRM4raZiYq8gDneKHAC0YYlNMxuaq13UcehpjI59glMMA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7956dcdd-a9d1-4b1c-d92e-08d8624200a5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:29.3036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ew+Tn6t0LWZKqgcS5aqdL3mhsmNRxNNM76AC7+YqodozCUTd+/FYN+D219Mt8zQ5mEg6pAs2gAeouCLw2DpN7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the .flow_dissect procedure to call the common helper instead
of open-coding the header displacement.

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_dsa.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index ef15aee58dfc..413086dcddb4 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -142,19 +142,12 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
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
+	.flow_dissect   = dsa_tag_generic_flow_dissect,
 	.overhead = DSA_HLEN,
 };
 
-- 
2.25.1

