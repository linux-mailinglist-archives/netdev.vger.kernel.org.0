Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0564327DC05
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgI2W2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:54 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:6339
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728684AbgI2W2y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQLkNPZph5swBbFePtFF4/eGeRO7R7cOU9Y7toRtEpcEVY+C5k5/RnXjUz+mSc3m1u4xw9fPxPrmO/cx1yC6Kgr/NrOqTCInonU6HxrLSZuEEu9vIZxoibjFQwfvPV7HCplCcludJKVsX+wBPO/LPtXf54hYXGzBJDsPwYGq2VJiNC833O/74gZQmY4QF2v7eZ8oDlIBISJJ12QhR7ER9uE/l/oPZEHmYKE4pWJhsBWJ5eKBwAUicOT5ZEgfVZn0j3Mp+Wss+ZlHVz6geqfPzoJ8I5X/hSqSAvbOd1reJibgLEdMG3DKcLuOZmOlSqp+UCZZOjaxDvBlffhfyF3PIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHqD4PWFA/GXZT4iHUOh0Rw3HhKvYgXndJLQNzuU+ck=;
 b=HxosgSFwoXHQL+MG4U3XaNP3jzF15icJLmWMIWMwtYrqKmaTIe/fe4fDpvAP9OfZzOh5nr0wL9fxsfSa7YNAzWLRJqzJf8MzxMueRBgSDXb6HtlYbT/4QDXCbnL6R1XwePq3tmHjxlGWzrwkVqaHRTKm4RzeJwD5eUGpjprmW5DL34LEO8B3Qt67Fjd8ry/aMUccz9YnmlJW7npswGrN7K4atN+be0tMKqnPiGIKAHQ9fOhj/54u9ZhdYNT9bbTxxAJ662COj0GzTJquWj4LOfapEEGqPyL+/wwbdWVfTppnpaFGyvwu7SJD+mEPukhackhMsITCWeQmkxS00/k26Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHqD4PWFA/GXZT4iHUOh0Rw3HhKvYgXndJLQNzuU+ck=;
 b=EJr4Iy9qgk4/IeFR0kC30esqqkoVrgNRzOZfP+KlOVl00eq/OOQ+PgcNm1Oi2WCkzkqznqAMPbvDtmALVRH/KsELz5cJdF5yLkSToBnefbRugVKFrOor7XdPfHce439b4TYrzliW5+2dL5ZAOEQ6oEH8s+afEsSioJKk+b9YBss=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:28:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:28:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 10/13] net: mscc: ocelot: rename variable 'count' in vcap_data_offset_get()
Date:   Wed, 30 Sep 2020 01:27:30 +0300
Message-Id: <20200929222733.770926-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929222733.770926-1-vladimir.oltean@nxp.com>
References: <20200929222733.770926-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:28:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fcecf56b-2b44-4651-03d5-08d864c6f303
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797B8147EC4D0D6CB94AAE6E0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hOlTWkPgGdUM0/m0TF3DShCl6o/2rlPeePrI+gqvr8kJKuItfXMSKzpy4xh1A9Q/ipjQyMTltYKC0sYtddXDbu/ipGtgN1Hc/I3wXATBY08Eo4PlndhJzmasJMJZyQzgpycvUYjuM6CAPOOO9s09kHdSJeYdb3bjyBTEEZh8wxB2XuZy71X1MsYP+jPPc1zGksSjB/HvTlYv8WXbXBXPjAR6ClvRRo/eWfAyUIcNz65i/8uu+HR0SlK/cY1OhVwoF+1NUDYEA3BWcWlj/OD5hW+2kULmVixwwgP0og0Uovov87CtAhqdYMxXk9aWXHiiusMzwt3jdPlsbUKqj8n8B8JR1ZgUGljMG0DRvW+YNq5yPuSIP8FdBAHJfOFsMoAaTHrwLLeJRPRpbjZ4bKFaEo6nJZW6jsV4Anu47Un736JvtzNtiB+HssKIypEepM74
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ra6ZO/TFPRo/Js0b9n5+S6FrCmwXS4C7CKDlBLB68I4nPLZF5WveObVmvKWXaSbJE+d5cI1CfF/XYhq/LG2SxVd6MNY2pZUHAtlL1upNS9LReWMekVycAQ/ClppvqxCTteNPuBFVpEmL0EJrXJyfSyFURGOodH+zpn1nJC+IosmTudtpIKaiTLPPAy9x1NHvOmO+fPmSJctlbhoIeuC3AmL934Hlimbu6GXfkb/RZM7/U1qMVWcAi7psYVS9GImrCkYfB4biaj3rTgvI0CPXQytt6L/yYrmt8SmlIqHUirxn8NyB1uCB9zOIYOAwsT6gGfvSWKwmCANtFfbyoXGopnTcuhmkra1ph/0LD49p6TjB1Xler3zdzpHxQgRN0NnOrm4dctYIaPl8HJc92ryxUbqq2pOTIquE/MWMEY56a95HeUYTkB0nYUZxi1pOscV8OtFayuZS0p+cieLLlxLys4moEG2zAupqAvxrW0izETgyubVoVqxgrgptJUwn+Y5S1TccM3h5f0vuxcTSPZP39vDTdVVQn/0iparkQLi2HOdpZRDX89jss1Mh0fkqeY/mOLUQ0xoTzxhs75/RJ6/LMovYGnf1k00QHtj3SSDhtMBwO/uoSpp+SNUGz7nACD+asx6pK1klwf/W+IgQe86unw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcecf56b-2b44-4651-03d5-08d864c6f303
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:28:11.9276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WWGDYuKRwoKS/5c/K1al0u8s1DL7dgeBCgI2bxdA0JE0jAvA1GQ+oXDy1I3+jmh18tBGYFCc8AgYEmObLtLGlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This gets rid of one of the 2 variables named, very generically,
"count".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 3f7d3fbaa1fc..1c732e3687d8 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -174,25 +174,25 @@ static void vcap_cache2action(struct ocelot *ocelot,
 static void vcap_data_offset_get(const struct vcap_props *vcap,
 				 struct vcap_data *data, int ix)
 {
-	int i, col, offset, count, cnt, base;
+	int i, col, offset, num_entries_per_row, cnt, base;
 	u32 width = vcap->tg_width;
 
 	switch (data->tg_sw) {
 	case VCAP_TG_FULL:
-		count = 1;
+		num_entries_per_row = 1;
 		break;
 	case VCAP_TG_HALF:
-		count = 2;
+		num_entries_per_row = 2;
 		break;
 	case VCAP_TG_QUARTER:
-		count = 4;
+		num_entries_per_row = 4;
 		break;
 	default:
 		return;
 	}
 
-	col = (ix % count);
-	cnt = (vcap->sw_count / count);
+	col = (ix % num_entries_per_row);
+	cnt = (vcap->sw_count / num_entries_per_row);
 	base = (vcap->sw_count - col * cnt - cnt);
 	data->tg_value = 0;
 	data->tg_mask = 0;
@@ -203,13 +203,13 @@ static void vcap_data_offset_get(const struct vcap_props *vcap,
 	}
 
 	/* Calculate key/action/counter offsets */
-	col = (count - col - 1);
+	col = (num_entries_per_row - col - 1);
 	data->key_offset = (base * vcap->entry_width) / vcap->sw_count;
 	data->counter_offset = (cnt * col * vcap->counter_width);
 	i = data->type;
 	width = vcap->action_table[i].width;
 	cnt = vcap->action_table[i].count;
-	data->action_offset = (((cnt * col * width) / count) +
+	data->action_offset = (((cnt * col * width) / num_entries_per_row) +
 			      vcap->action_type_width);
 }
 
-- 
2.25.1

