Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874DD27CC53
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbgI2MfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:35:20 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:29398
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729449AbgI2LVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 07:21:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWuTkQ1WKgjqWm0yuP86XdfQBrtT70AlfsHiTlz1td9Sm1ehJbWMmhLeJWsVReUytde/LDQ/l+0sZE04MRXKCwza2j0PD7FudPdXzWIUIrdIuG4d9KfqYaP5/g9pB723W4lNQ12tXjoKqN+mp3iRIO9IvH+llPkTZA/vNos5eNu1ARXE+FZHuMfBY/xBdFKG+qZ0FeW3dzi9CDxXZ0mtwkTubyKk72s8juukJ1RxmFeCh1sCQyq1jY9R38tCrxbsIhoBX/kc+sT1Eon/dsU3+c0xU73u+qkdiDLsIgzfODRbqbmfJfdOdJxkCy7lod6umNt5btACQ9Rd9igtube1FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIdMgnUCQSzm6gTgiAw7XUs+PrnJ4SeARocCa0Dp0mE=;
 b=hPQOOzGHUcrcx21JWZcL31ES4xj6JIBuMsQFy98mouxm9qgJ1YmVRLHO9IN6TVBgiefFLKrdflVmAG8tfRaUBX+wP/0HUpno8tmZel8g/4XZedcyKZOR+7f8PVJKRxLfKelBXPP7DqvIsXYeZ5L86PghcRlybUAe7FYtRTVNp6h7ZOQj8HkAPfNSXOZTEFLhEwIwV48xkcIfivLr79VjrnTrp2p0IzwyR+McvKOb28/J1sZgEUSeRnoTU1C1apV6+9sJp+/1x/9eKAOlMfV2U7ok5Gv/Pl7zjIsqlBLCXBShtLPxWMs8VtqgaquHOWrJz9vv54Y5Re8KORhJUr0qcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIdMgnUCQSzm6gTgiAw7XUs+PrnJ4SeARocCa0Dp0mE=;
 b=FMpTkUQ0zsGGYdvuvQ4nOgmK3rMsPUwbbDyOlPuOzlTonr4dSp+/2Wc08j6e0TAi7U3r0486/OQD1d0HdgcB+bs4M3z/BfmYaTANfJ8gEpliwJyl68LMugjhZ+eZ27LkP+wy38FG3Y7WGLH0nQ8Tt5tHH6ORwJ5Di4lhkQDKlMk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Tue, 29 Sep
 2020 11:20:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 11:20:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 1/2] net: dsa: felix: fix incorrect action offsets for VCAP IS2
Date:   Tue, 29 Sep 2020 14:20:24 +0300
Message-Id: <20200929112025.3759284-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929112025.3759284-1-vladimir.oltean@nxp.com>
References: <20200929112025.3759284-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM4PR0902CA0013.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM4PR0902CA0013.eurprd09.prod.outlook.com (2603:10a6:200:9b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Tue, 29 Sep 2020 11:20:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d56bf298-f3e4-44c4-9f33-08d86469b26d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB46882395E32BCA557C6E2E67E0320@VI1PR04MB4688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TDEZ/NOa1FwDObAzrBGQlpRjOYEdYw4ifQCI4avB4Mq2Gzf4XrJjNqIB0mmraRcMHdwAhHlmtZXiJKEF39qDFiWo4tcuaLBsWAd19lw47zVh5vomPa4X3j5p1ppTw4caMqWabCEk+ke6mYGWx70iA7oh2F0yXUDe2aSjHvAkYWraG2jMk/NBxWVySK8jOrKNlRMBHKb1fIf/8txXq4ynOuETOqG/KeplDRNMNvHjc5YSt+v7TcJmGP7GDi3dd9bSjClXAP/5Phj1/Ul74CBGu7glyahnqAYlFcHVi/ou+tJTVX3DSoyOhn+1R/oiFcuFIfsRkZGTB4STv+M5GouhCxIO5DvgbqSpoiJ42HlmY340mWYiDmrLafJNfb8u+w6OiS7rEfECZTTk5TSHCCYJBkfv/lsJ5eq42Vc0El8l7tUeTeGcpO1GdzBFhZLfhmWF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(2906002)(8936002)(44832011)(5660300002)(66556008)(66476007)(36756003)(6666004)(66946007)(69590400008)(6486002)(83380400001)(6512007)(4326008)(8676002)(316002)(186003)(86362001)(16526019)(26005)(2616005)(6506007)(956004)(1076003)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vcgDapTXzPSgZIMYjN4xJkfBeA0YAl2Vky+TY72r2Q2sexw8I6TKzpjUWQ+1tDn6ESK/3iNtkSI7S/IVBKGu3Y2mnijPgO1IvDbaReePKc7SMzL51EjOERy+k1/RRJ6hQ/5TfdFOAbiJUL/W7cGxw0D3ffMI4HPl7GQajXdwS3uYsCIZdL3DKTzN2WVZo8JXCtwyq8VsZaWX3UYmjhg18VKbtMVrMHdCCZ/ybmYaygHZWY8/aohFtRrmEz0eziVpmyXp3WHVbfLArsw20S4FBk6h//SJwEGCxjk/P1To1/hLOdbD0FJzgViOnfFGJT7dnV6dKt8a5XoxHPUoo9y5fhGCPutH7LojnvdYL+XK+Z6CqNCMkxtEWFsKlxm4AoLPRYQsgDUdF1TSxOXB8W92nguO4+LyGPLueYfdFqjGCDpdRYQItHTco6rQVnJpI/+VlxHGXZ9tr6IKPrJqfJYt7kMqfGjfx/WaJDqqb6gnuNYRM2JKbu9socWFqySTtwQo6jLXqe26icW7cfcJW0LIXUtZ/4XYZcp8porFByBw9V4QkKSfh9KDY5k28vVfcKN5+k6G7fu4g+za1iwoxz5QL+Bs3rpv2M0O3FTmlKVQgvMmeKocFMQvZsAXSJGELB2ZvxOV4HWK4eBkEYE8exhVOg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56bf298-f3e4-44c4-9f33-08d86469b26d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 11:20:40.3176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hHNso1rZfO2SbUAAXbIvvAR/0SvixmDjVJu4rYwRowP1l8cO/k5dN8S1Uz2HkSk+NltOiOkUBiz/HqVIpeECTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port mask width was larger than the actual number of ports, and
therefore, all fields following this one were also shifted by the number
of excess bits. But the driver doesn't use the REW_OP, SMAC_REPLACE_ENA
or ACL_ID bits from the action vector, so the bug was inconsequential.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2e9270c00096..af651ae03572 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -686,12 +686,12 @@ static struct vcap_field vsc9959_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_POLICE_ENA]		= {  9,  1},
 	[VCAP_IS2_ACT_POLICE_IDX]		= { 10,  9},
 	[VCAP_IS2_ACT_POLICE_VCAP_ONLY]		= { 19,  1},
-	[VCAP_IS2_ACT_PORT_MASK]		= { 20, 11},
-	[VCAP_IS2_ACT_REW_OP]			= { 31,  9},
-	[VCAP_IS2_ACT_SMAC_REPLACE_ENA]		= { 40,  1},
-	[VCAP_IS2_ACT_RSV]			= { 41,  2},
-	[VCAP_IS2_ACT_ACL_ID]			= { 43,  6},
-	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32},
+	[VCAP_IS2_ACT_PORT_MASK]		= { 20,  6},
+	[VCAP_IS2_ACT_REW_OP]			= { 26,  9},
+	[VCAP_IS2_ACT_SMAC_REPLACE_ENA]		= { 35,  1},
+	[VCAP_IS2_ACT_RSV]			= { 36,  2},
+	[VCAP_IS2_ACT_ACL_ID]			= { 38,  6},
+	[VCAP_IS2_ACT_HIT_CNT]			= { 44, 32},
 };
 
 static const struct vcap_props vsc9959_vcap_props[] = {
-- 
2.25.1

