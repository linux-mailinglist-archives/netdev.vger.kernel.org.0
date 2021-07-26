Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5FE3D6516
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhGZQTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:19:55 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:42242
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242038AbhGZQQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hm1XqWxYjpGvx1sbKbl6YDC5hO8Wro8ccPMoZKuDakUO1P9jRatbWoqelGRdXrKtnlCLmCht6Fa4eLbFfpC40Hfnx9FxdI8gnPGDTtWYMSlWUHH8YOfO5Xe91xEDT1CkxVAIoILg3XXe0FtBo2+3dHwBw5djHHFcJGwlaHWOGq62fv43Rf74loIEHwbMMs0K0EoHXpCBbUHv8fHcJaztEuo0+IrN9ENlWU7GfOPX37YVPdrKfghPbKRNPQwY8zLDXSqqcA5AEGcDIvS2VQQrMbW7GjDup6UQKQfmJVTxwgQNqz6aSGYufIVvtHTzWfF041sI14SuhxW5sRlDSfpjqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6luHFJoDp3oT1b1WOGU7ERfpGkWlcbXSMyTT640UT24=;
 b=hN77uC7PEd8/aseh+cD96Sr1EN0v2bToDtmf1qcxdjJmdDRiamopzPp8OKn8kKYXp1nJcaYZHX7I60JZBMAn/+J2bSLzvsXgtN27h10h2T29pawjSVJPjzVD+KdvAjJR+9lNl5laywi8gKzYz8mnCKVP3lUytmEMiXG/Y/LXdyKxkpyGcxaqIux10AUIxt4J2GBud8P+eHqjdOwVZpxa62ROWGPYdfs9hQbf/+l67mRwPdhaovyufgZ+v7aIBg7IWs+GwAO+46E8/NM7almHBrkAU8//REj9E8rMzV08TyG79/vLc29BrrEXX0yveMcSUZq87xeWlPbchWo1XnnsZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6luHFJoDp3oT1b1WOGU7ERfpGkWlcbXSMyTT640UT24=;
 b=cjc/Eb19ym7c2irCwJZBgcNfG3ow/kGg+JNnBETOJ8E90Np1TYGo5nfiDFE4kfgx13Iqyn3oM8QlVaWM9YDk10Ydr6slQeJ04K8ll/GM6KFV6wuQDQYWC3+gphFngnYcA3ig58xFt6/W4BsUE8rLbSF7CfvcV9shqrzfJEPepyM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 16:56:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 16:56:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 6/9] net: dsa: sja1105: deny more than one VLAN-aware bridge
Date:   Mon, 26 Jul 2021 19:55:33 +0300
Message-Id: <20210726165536.1338471-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
References: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 16:56:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff9d4531-8cb9-46a4-3e15-08d95056417f
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7328EAB67A252716E9B2661BE0E89@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HcyuOy6BufWe11b0159Z+9yzwXyKakZxcTG5Fr/0CuqQEuh6ATLMqGx4Sm1kDZkBDdfRQ19e7rvZQy13qHlLcJL8IYAl99kTtBVaQTYKKRTPWdbVcvC3zrw4QKoNG/hohV3G8f7B7KTMjW55L6CrJaXQnesD1Aw0K8cEIxn3nWSHPcEA7q/hfgmW89e+7B1+1Ufyz2xmBuVXE+RIOBmeXIx/w8gKYlmRFxxEYb6nqAZRk+ArIqHEmV3oNnTsx8Z6M9GMJ4aWnjSXKeWZuCFfanG4JOy/RBAKfVdqMSwCQ2sWUBPB1m0H7+L2py/rgIVTeAB4ZLAQXcX6fnr92ZG74F8XT4M2vsFQrZBZQtbMZqDTQ6uqGlCqQ6AJR6Kir3f7YxRvcvi/+bU0kXOIDhn+1dB+NO3WB+R6LDIgxm+WY5z3QEJuNsnR0N3G+NiVOjCNMPVt7mkYn4eAodws8X3q2HOZj2iAvfN8/j8JaSpSgx6o5ZBLS55LQR0tiH+ywWb57d52/0/VtCa44yzYWWOl3FK0CqQly7PKEf6han8cW30OuyaPtGCMTNUVz1hjCOHpOY38ixMn1GxE9MDQraGd0IzctLbCPbRZm1P5cizHptm7MGSz/isSN7+Ni1PJXGWiq3uLq5HaTh3N7z0OK9a++pTYdrDEzrVw3KIqlR0oJgHq8tOpakuMhZgAxGrie4amISUPvDu1OOOkyz6KBuTMww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(36756003)(38350700002)(38100700002)(83380400001)(478600001)(44832011)(956004)(6666004)(86362001)(2616005)(2906002)(52116002)(8676002)(8936002)(66556008)(5660300002)(66946007)(54906003)(110136005)(66476007)(316002)(26005)(6512007)(6506007)(186003)(1076003)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SjAkCcIzoQsCaooGyqZgGU0Yycj02FQnmxacjvcCQMdsTUuYTe4HTXVzhfD/?=
 =?us-ascii?Q?zA1FTHLlXBeGaeLqj1ML2DLZROp3KG3Yru9r65LN8D4KR9xFcPNWwU99LSUu?=
 =?us-ascii?Q?0pD7PCNJzlYiI9VOKzuZpqM2eKAaKNrrLlkdwHVAldoGsxbFIpBwqNu8UhXu?=
 =?us-ascii?Q?FO57U83GhFXt6C7ryAwAJ06KbPOeu8GRTzfbIh68dsCD5kVZJcGCl7q03pLg?=
 =?us-ascii?Q?3JC3qrhJnAudaYJ1UaM4yJhO61Ywc0sjzdnty74+Y2kuFRfobyn0zRYca6yP?=
 =?us-ascii?Q?EzkiK4Fe8Y6rkTYmahXYJn8MF/Gvu6AAzslUcLmcbJrT1ntNlYi92VkhhIn7?=
 =?us-ascii?Q?yGEnQY7Ug4H2Z81I2XmKOImHGxA05InoGtWHKBUolXVEKyX53nvMgVy1qtD1?=
 =?us-ascii?Q?suLl+0bPys085D2YTzToGGRwlRkQXjlvVGK4AGtSPgr/zn+X5BTcr3AooESc?=
 =?us-ascii?Q?5CgxSeN7typHk/p2w1d/fpWWsgTLoXmTwnCVrT1JxFBlCIYWJ7FXUywmW8GK?=
 =?us-ascii?Q?8vB05M6GkxjAq93zU/+VqZxnI1MMH0qTcnJz8cC3bqHFo/ggX/s8q6wyqDxO?=
 =?us-ascii?Q?q5dSbEjPrQ/Cdit1tnLw9+pYOp0YsGri4i0mro1y4mmjyN8i5LS0FUxUEyGy?=
 =?us-ascii?Q?WW6dVx5H+gr+qnd5DbTD6lkqxhczYd6GJ4cdG2bv50OX79g0E69Q3oHqbgau?=
 =?us-ascii?Q?KbqLb1usoB6aMe3TRz6I7m5EfIdPg7ifM9yn42yuAIupaD6CtPKaGgF4tUFJ?=
 =?us-ascii?Q?SYwIzqICd4sLW2yCL6XLZjJ4u3pAb0iL4dGRjOTMHI6pzmqQJYDa4n2/zfXx?=
 =?us-ascii?Q?yLUiXGMQizfriicxq6Urt2ZEpln0fDC+d5rGyngzTw8Zaz7S01PTIxzOIQLG?=
 =?us-ascii?Q?YIlGD3rBta48h6N89CxRuTh/DGu2ywQ0uKw3lxnxeqDaItzwO8OfCdy3JuWq?=
 =?us-ascii?Q?BhBghWlsSLmsAhU8Z3gX6/xEKbv/y0R+SKlcPsSWX/tHEiTFMjRtOZfrvSoY?=
 =?us-ascii?Q?CGPMtThzkz3t7uHCZgYjUY70l+701cDby6rsT3Eqh1WRbKmH6OVT0MmpKPeN?=
 =?us-ascii?Q?6O6qd79oKBA9g6gny3GUbSh1if/X8E4OtclNF6hDa45ZCuJt1exdM1VuddIe?=
 =?us-ascii?Q?f47rS65YJTuaIpNBearJpXNNXWtQvtFKs/Rc21xVXlo6ID/Q2zOrBZQY2kK6?=
 =?us-ascii?Q?hFefqWaheOqP8ii6akeTHXDQcpr2kF0MEYQsoINt5U/HLNpt1umH+vRdJUeG?=
 =?us-ascii?Q?zPw5A4T+A5f1D2YYSyGftAe4xF2R+tF4Qu6oZstbnzBhua+WljEj+MTTMZ8G?=
 =?us-ascii?Q?XqlRbRNtC6hmlwgIZR60ewRV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff9d4531-8cb9-46a4-3e15-08d95056417f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 16:56:04.7722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIkGdA1IGusEiqWxjNyaZ3fDnTfN68PXTO3fyEmO32dyZlXI3m7t99mKDodGvEFg8qSEqOa6tPmCfqQbD6cC2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With tag_sja1105.c's only ability being to perform an imprecise RX
procedure and identify whether a packet comes from a VLAN-aware bridge
or not, we have no way to determine whether a packet with VLAN ID 5
comes from, say, br0 or br1. Actually we could, but it would mean that
we need to restrict all VLANs from br0 to be different from all VLANs
from br1, and this includes the default_pvid, which makes a setup with 2
VLAN-aware bridges highly imprectical.

The fact of the matter is that this isn't even that big of a practical
limitation, since even with a single VLAN-aware bridge we can pretty
much enforce forwarding isolation based on the VLAN port membership.

So in the end, tell the user that they need to model their setup using a
single VLAN-aware bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index a380f37fd22d..ef63226fed2b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2257,12 +2257,25 @@ static int sja1105_prechangeupper(struct dsa_switch *ds, int port,
 {
 	struct netlink_ext_ack *extack = info->info.extack;
 	struct net_device *upper = info->upper_dev;
+	struct dsa_switch_tree *dst = ds->dst;
+	struct dsa_port *dp;
 
 	if (is_vlan_dev(upper)) {
 		NL_SET_ERR_MSG_MOD(extack, "8021q uppers are not supported");
 		return -EBUSY;
 	}
 
+	if (netif_is_bridge_master(upper)) {
+		list_for_each_entry(dp, &dst->ports, list) {
+			if (dp->bridge_dev && dp->bridge_dev != upper &&
+			    br_vlan_enabled(dp->bridge_dev)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Only one VLAN-aware bridge is supported");
+				return -EBUSY;
+			}
+		}
+	}
+
 	return 0;
 }
 
-- 
2.25.1

