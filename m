Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B71279B6A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIZRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:52 -0400
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:18948
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbgIZRbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPvhloqNdNq98WRT7DFcJZRwILTuirJxp85xy1+Rw6XI30fM9MfFKPXotOsyBZ8Md2xSAum8QRr1ee9d6PM0+trpOuecIFzQJX1XNAsSBWSAcTYTTUkN/TVZNyssGfClJLYGs2RKSzrR5aSBJXALxmXBALJo8yAOURkWlxGYYP3VCU9Cs02bdZrt9KRL59TiW+e8eej0SHam4RPvK69nAne+UhDf3TFq0apr/y7AG2PQV4HCGGCca376rMOhKDsAHSsUZgEiDuwN/lMomDV10BqmuCo1sP5T+dcBvyxcN1+D7Nd3x2PhQgvH/f7JoeqEHSVehVugl4jfVZKeUy8lMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sodh1IBkkRm5CgfnPXiJ7CvaWBYE9ITR8O0bwsBobU=;
 b=JVNt6+h7YIDzYnkjYHuyYywkM1F88Uh5CzwCny1Sn70/M+4HCP9lQo2OTOdJHfHaQMMmFQffh7WyxmUlr77OARAih5Hxaswgd/r4m5YrDL1uvKPQ75qI/Xr8KHwDvQ9t323a8wq5Evy8ciW7PkAD1ZWO2UqEQ3rlRf9xYI5d1tVWjbt0pNFh9M71VUhEWlNzpZ21rCiM5MseP239A/xlcWJFkbHPL0EEoJidLRQH3D2CsG9nccdQ5GqhkXms2CdetLF/By7FkPQUdXyNrTH+LaJrZ6/UN1r/mHlb7RcneyfY/JnvHV12jcg7RJB8JCiQqTpRYkWJqMnOq4WOyKQm/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sodh1IBkkRm5CgfnPXiJ7CvaWBYE9ITR8O0bwsBobU=;
 b=lhs8hwGs40SnHscOOw3MCAtMNjGJfXgxVGZnbcM/Oss+9KsyaqMmmwxGjIkDqNVWDJVC4EIbTJj0Ys10y5H+v8hb4jQy/O6uhE00G7lWwK3TmqKM8uIE0vPZCufjYVWZZT1IdO4BAI2nRu5V66764S06VA849s78TFGavYghMAw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:30 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 10/16] net: dsa: tag_edsa: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 20:31:02 +0300
Message-Id: <20200926173108.1230014-11-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:29 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d9a5b47a-430f-4554-2181-08d862420134
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB481366FA0B0D223D9F889FF4E0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhDg21FSCiMZhOr69XkqrXARl8Ssdflx8YUOubEPO0JlmIh8qAv7U0FNaV57sOPfWHhgRI4J9S5DwPM/7Ba7BFGEYK0ZzqYoPnU9o5/lM5du3Zq1hr9WWcz2NQioTkuZxk6KXyHUS1qP1g5QATf7bLeYgp/Qd89mDTcOJwj7LsZwcxHPu4nYR8Yu2GUQkcvHfbczBjoDDhC2F59KB8dsvsxMLxGkjRvA3p9MGg8lJXH3Eg4J6bwyjbKwgM1V4irapgUJVqrWFCHOwbX7yhoTJ6JmW6NWHAFhVf7hMHUFVyCisLJTkOvDFbxNUk3yslEvAXH9NC0SAewZjngLyzoIHuQBHcDAaDe+FAFQbg5P/A9aPG3kQQPKIG1xvWFV/RIE1dCvCTmlEbdjLnH3TyRWCu+Nvu3PoIzNlXo8Mcd/MHdCF7KphNBhenrwa1mb9VMq6E1eXwnFwYTwBHWFYUooEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(4744005)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(83380400001)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: s55wUnHlCuonr/UrEpkay20uws433ZwG0TZA1Xnaa6yVuWaC7OP2t0ZvQgpgUxG4KgqyeWHOmGEVSmae1kI8TWNYgLdNPQ8vEFJWYqx0duUn+NKIqvgnlrDERld9Rxl/OveCDRl3xBGWhYYkHkcNhhBstFDnHIvgpN2ueb9OQtXUogMa2KllAosUL4TPA8XfOozRfT2ICKTzoSYGd5QniTO7vXqWUzGtXdas9VJ8QzgdmNHDuqGId3Z5CjzVEQn/SAfMcxtTRD1635fRzQ3WHKAKLoILn0w/fllmKWpminEv8JLUMPqW3tYb9e3Gv68nCUu1WtPeiZjOAm+yJ9nR2vQ+yIJUHb0Rm6bTz7QfTE1ux1k/VTzHxi3L1Ulo2dHvaj0++xLLL8k1e9t/W+wSKX/NL3G/TXpPlB1OzO83jk66tZugMlGhoasLzst/yXXiMiX7mJLDHa4Izq+samgqgjZj2nvcjwxuazwQJvKLgceLJeOaiK8jvI75D8fL41R/TqAYq+/pDeMmzxgtgOeO/0BO1TpreJgzqbFpaOM0L5RrEMZ5inJrzkwYEMSxQY4VukXAEekSrf++MRgvdnuT7bL8WHDn39n+7J6k7ybQXVeJ3kDTzarVRftzsssNV4UBbF5uyLa/wOjTpYkoTC8hlg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a5b47a-430f-4554-2181-08d862420134
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:30.2521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/AGeC7+unPWumDxCUXH5UcuY2e7sa6I2dyzENtkv91DVU7oypQ9kO6BQm0WdKMsTH0Xg423sdNB4nHEoztf9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the .flow_dissect procedure to call the common helper instead
of open-coding the header displacement.

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_edsa.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index 275e7d931b1a..ae883124f679 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -192,19 +192,12 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static void edsa_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				  int *offset)
-{
-	*offset = 8;
-	*proto = ((__be16 *)skb->data)[3];
-}
-
 static const struct dsa_device_ops edsa_netdev_ops = {
 	.name	= "edsa",
 	.proto	= DSA_TAG_PROTO_EDSA,
 	.xmit	= edsa_xmit,
 	.rcv	= edsa_rcv,
-	.flow_dissect   = edsa_tag_flow_dissect,
+	.flow_dissect   = dsa_tag_generic_flow_dissect,
 	.overhead = EDSA_HLEN,
 };
 
-- 
2.25.1

