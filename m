Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C7D3B7968
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 22:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbhF2UfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 16:35:16 -0400
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:7175
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235165AbhF2UfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 16:35:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggO+Wxpo5igt4YAUqWX1uHs8BV8pNoMKqUTNoUdTOE+NmxoglFgFB17BDwUphtRDMJYtYWodm0mjf2pNZX11DIXRloYFsvU63/bUwAf/xa75oOd1aLRSCm/Rk7WlYzjxDvP8zCGhMINSHioHahHlLnQpyUjyeQ/nljiuksZnkzxAgmXTGIo24DA2ioY9fPhFU5NqsniLLX+vQkZ4+Bdm6756IguKCpIzzwYbbduT6LZqjiXIAocGr1z7xisdCqkYIcmjunaqzChXSYXfp4/eRLcJIDDDMuk6WRO0D2VTRqj0jLc5qtskdyjMT4v8E0rxxsNdW0NwbFn7BBbXsL4UGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0XrsvTZVgUgBkWQ5NeZlumzy91wv7ENhDu5ny08fGg=;
 b=Mu6FRMqQ0O60bBJY9gmornFbcpJvlH+fC6hvEmXNH7FbUi5CHmwHBghanWbzYNNBzfdNH7FJJBMpyDHEJyf+8LruSCDb8i7Wc4Gtyxck7NbrXZb7nzKivAfJ6hx58tQjCLklZ/pvuwxgroCXwi8IDn3S5ftHmvq1SDQL93Xx/U9MhpQZ25ZoCOzUPPwL1Uc62Zt6NEn1QXcI0HYZq4m6Sc8XldFV6pTfHgw9mej2k1ohesVDYMba5/HUWQg6/abZhL+rvQauSFYH7NFmEsUz2R/7vph4zhB2wWKGbN0udV94kmxf5ri6ee51J5m5+aLxXrFeI/OjJJMP0oWynmP7Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0XrsvTZVgUgBkWQ5NeZlumzy91wv7ENhDu5ny08fGg=;
 b=H7njpCLnhyYJliGU+jVg6FOWMDLLYlbW9G3Ex+orCbu6+ebDJnHgE/bJ5pgigH+FAZemmx49hL6HIpLNC2LYivjKwvsexhYFMvSQNtSu0NrO6ffmIonf/v8WVBkJvlJbO2ggIQYXvu3izy/Iz98f577/eD+gNY3wZLImIPH82PA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2303.eurprd04.prod.outlook.com (2603:10a6:800:28::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Tue, 29 Jun
 2021 20:32:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 20:32:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: return -EOPNOTSUPP when driver does not implement .port_lag_join
Date:   Tue, 29 Jun 2021 23:32:15 +0300
Message-Id: <20210629203215.2639720-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.224.68]
X-ClientProxiedBy: AM3PR05CA0103.eurprd05.prod.outlook.com
 (2603:10a6:207:1::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.224.68) by AM3PR05CA0103.eurprd05.prod.outlook.com (2603:10a6:207:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 20:32:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93011eb4-f50a-4071-3789-08d93b3d0cc4
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2303:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2303A6068AA1E5417BF49160E0029@VI1PR0401MB2303.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vcyxqj/RiUtE1RC9bP1kdYM7ks+Znlje0ogNNJ8Bv8DZlQgw56wuvK+F6j3tF7hvFbpDVxpbGXBso9urib3lK0iovY6ES35S++8VKqPbGA6MRFVWE/S2jRSpWW9wLneGccg1/2Vued4cedbtlQJaeqhzVmmPuXQIhl38xkUXaHsxDc65cSf1Hmo8eCx0us7PKZ/OgR8jI/eGLCyEPvu2eYhe6yQoLBUtny+ma2mr2tGeXrSKvs6NR42lkhbZgm1ofJQstFafEhVqJ3KaX3UQf5A/Ciz+CwSUz1SdPjnoxnqLNb0wZH1gmhYQnCoXZFrOxJ6pPsGQdgKiA3lc3TPEUS3+nsJ8i53jXDQ0XSs08iqjDpDl7vipYoWbLoz2+mCrtYEPd36P0KEL/sBwblqYWPgDv+oVcm1m0oqKXgvahO8lLthRq9uu9yoavmcUCBEJh/Mh/qR280EHGAjB6eeJLHcywUp2nHt6q44Qv/m3K7OVI4g1SCm47I8U5uVKpYG2mgW0dwDcrHAnalzSIIuZoo02rbOGCWg7vq8zoSVoJNrJiMXnd86wdnFANG/JLP6JAO8F8OfKlrOt7fFBituQykscv2qtFvECra1T52W1osRMsHn4vyrIFAZUcNnbijjyJk47Bin+LoWNy3rxrQf4+fb+WU9dBmI784SNm6H+Ps2fQ7jaP59Ybkvy+4Cx7ZTheMf8rQY1XuJkOw+NeHyJ6oQQe6WHc4FpW+eF4lMIqgo6r7tDlpkTB18Vl7xhwAYmO9bi2rJlRSTD+wM/B20MOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6512007)(8676002)(86362001)(5660300002)(83380400001)(316002)(4326008)(8936002)(6506007)(16526019)(1076003)(26005)(478600001)(66946007)(2906002)(186003)(6486002)(6666004)(38100700002)(38350700002)(36756003)(110136005)(2616005)(66556008)(44832011)(54906003)(66476007)(956004)(69590400013)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ESZx7wLbyo2plXy+GjitRS7sY1xh4KGumPkJpmMHddK1IEhAOQL+ODePbSfo?=
 =?us-ascii?Q?5H/Ccb9L8xV146kwlKvJjXZicXMdYNjq9aHEi3/1Y/K/KkUOQhwm7CdFEouu?=
 =?us-ascii?Q?1vOJERkj7iquFyJKj4ex7YniRIXwg+NnglhzAwr/xn1spQaCGQKIVSjtQ/sC?=
 =?us-ascii?Q?Oh95sRGqeiM6jAkI4SbOEgziPEBrrJzaqQ6YT/3Y5zuL78iDyZt7/kuu6z5B?=
 =?us-ascii?Q?Hqgh+QeROGEi2aTgb/X/oObG4toHm8iElasPeqBHwo2Xgorl4FF9UwQRaybX?=
 =?us-ascii?Q?n4IBK3MvRYe8jXffpucIY4wh3FU2Fh62LylQSIeGk2qn9iLDjqB9njggthck?=
 =?us-ascii?Q?nqmczMeaIiw9sl0YL3pF1QGfeZdJyq8oAP8dLN+KVPAnPgzFUKGdvDaRrPEd?=
 =?us-ascii?Q?Oznfun+5ewyXTPTGHlkkBk64i1ypaTdB4qtsGYbVwTgVWrob6yrn2a4P+QL8?=
 =?us-ascii?Q?RYHuUya4LfHQLJ9Ympy1Bb55siANKdRsvTawI+TxVV7qfEkSEeT5qnFg8+Hd?=
 =?us-ascii?Q?wpzdN04CaHFTKXbC41WMsFxD9+xiFb9mfKF/l86RnDksNWQNxggNwYARERyp?=
 =?us-ascii?Q?0O8bnfRs1p2g3CAcl7vewfXMVHzrZaV642VgJgginRMcM42XnvEP7PLiMNGg?=
 =?us-ascii?Q?4ZPpXI9axxLstqruJnfmZQ/hOVIjdjTe3ch8q3L0RRzy1VA1riFJMAC3kNn1?=
 =?us-ascii?Q?k/yaHTbXKsGcIJwt9c6cdbYBSM0Z8UxLHOn/SyyuWeb67Bgt2efjvmQl+hyx?=
 =?us-ascii?Q?CiETvDnMSktA+zUKv3RCykiSR3lgKI4OzdBYSmE0+kRUMVLEcwe6QSu36vyt?=
 =?us-ascii?Q?/H/mh9OK83M/BPN6QZ4EgcJb4s6sdulKTZgy5a1KMF275uZAE2GlN4OIdL8D?=
 =?us-ascii?Q?BGpsRPFdu32s6HaN0zW/9gjK5aVCGKfNtilTw6EzVON+CGaQWgrha67mOjfQ?=
 =?us-ascii?Q?TDtLKP5vZWU9L2xQ8jt6fmlEyhqoE9klWojhLYjo+jeAf9c5xKO8L2bRx345?=
 =?us-ascii?Q?YfL5iWQyA0itG0GJj/y3lIuWdC0RUpJIdGWba7gkVX0ZYEi7RgLJVtNkhTWd?=
 =?us-ascii?Q?102guEwNm0Y913lfJ2a+6/Km9cGqpXM6GlW2btteH6Sbb0nXB3eq5FCMn/Hk?=
 =?us-ascii?Q?wk+L2GGra3Lp5sPB7yWkeL1Qwsc87ufpN5lS/fodzWUF6JmimePqkpVGeq1g?=
 =?us-ascii?Q?M9I7OUwLYKhPr7W+e3yLUz+vLFuYtsACtUvyzBFvHfNzIRmSIAzwpWvYcVOM?=
 =?us-ascii?Q?R9g50iVmcgkQEM9Plcb1g9KgcQUsr5nAT9H4RC1CLZSoRro0F6YWY1CI7p1q?=
 =?us-ascii?Q?7ocx7+eTckC1ePElzmpLjivN?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93011eb4-f50a-4071-3789-08d93b3d0cc4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 20:32:44.5166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZGHBBqIPlzo3T3QfIjCqn3UNd4qBTWowOvFaHZt082SNNTkS5iJ1QlsJeLG/auLHw0NN8wU/f8e9HGp19OwoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2303
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA core has a layered structure, and even though we end up
returning 0 (success) to user space when setting a bonding/team upper
that can't be offloaded, some parts of the framework actually need to
know that we couldn't offload that.

For example, if dsa_switch_lag_join returns 0 as it currently does,
dsa_port_lag_join has no way to tell a successful offload from a
software fallback, and it will call dsa_port_bridge_join afterwards.
Then we'll think we're offloading the bridge master of the LAG, when in
fact we're not even offloading the LAG. In turn, this will make us set
skb->offload_fwd_mark = true, which is incorrect and the bridge doesn't
like it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index af71b8638098..248455145982 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -427,7 +427,7 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
 						   info->port, info->lag,
 						   info->info);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static int dsa_switch_lag_leave(struct dsa_switch *ds,
@@ -440,7 +440,7 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 		return ds->ops->crosschip_lag_leave(ds, info->sw_index,
 						    info->port, info->lag);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static int dsa_switch_mdb_add(struct dsa_switch *ds,
-- 
2.25.1

