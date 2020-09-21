Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAD227360C
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgIUW5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:57:04 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:20979
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726913AbgIUW5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 18:57:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJSBi8GqSkAwIz44pg0oaLzWWyTYI8Gla3C7q5PVC9Z+0dInq/cOS8vXbF2nj1vEeRQL/LgZRzXZLrAeDOGHtX4hlnFsX/Umy5v7seHUTx3HwhDnuaDgqaxEb+SuGl3t0ZHUDaqlAWjEpruGTYudxkKYGKeJLM3AUaEwcT4oTJ3w3mFWyMAbv6fTNJcGJF6x00RHdPGQMdUlhq2knPvR8c9D3JbGnBv6HNjDP/jA9mPP9183ZTiiy7utqk72q01rBSWhLft4S1J95/icks+Cz31RdfBUaHDtQliS7lLufjyaT1dIBO7rul0sHUWHHkhQfAOF0NsH2VdQu4U7REjsIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoBZdArA7I3u9j6TcPGyht/e/9WAMUSsRy7Qq7gDqeQ=;
 b=FnTgz0bVhrvshAK5fsADrwjwJjBeYU2U4AUWWSRjnMGHpspJalg1Tfdh9xI4BEwPytznrGDERMAfsp4SSox8S2U5LkRdF5edadq/AEerbHbulKkbBZdgRoH7U3jw7kC+b7wpUbEGWFS2Ch/G4+YOgBTXq2t0DfpCpntozSqkaX3jfKSMyiZtY7nuRuWYzdhHX+sOgl4YMUmbhXFhqSGGC2+xugLOpAN6uBGx+I+39ahtUukd0PCjBgKfGw4LJPPCTGUz9elnJ5K5qOi7LFbpYKBCmIKFxeSUL4V4ayqjFBW783lNx9U0frB3263kkZewnkT0HQue6S4Nr7abuSxT7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoBZdArA7I3u9j6TcPGyht/e/9WAMUSsRy7Qq7gDqeQ=;
 b=Yv0RGPZzQVN7ob2SnrAa5XqkPFG/RIvTido225ApfmQ2qsX1Lftle24rmfEQ1h18vbbvMul8MDAryQES38dAlNafxs3TZ4YKQ7/arkGLDL5AnKyWBJjc5SUN9kZ3HRxAAk2L3g3JtPaveFrGFzoJPqJuQ+lJ4cuMiO5lZP5a/fs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5343.eurprd04.prod.outlook.com (2603:10a6:803:48::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Mon, 21 Sep
 2020 22:57:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 22:57:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 2/3] net: dsa: seville: fix some key offsets for IP4_TCP_UDP VCAP IS2 entries
Date:   Tue, 22 Sep 2020 01:56:37 +0300
Message-Id: <20200921225638.114962-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921225638.114962-1-vladimir.oltean@nxp.com>
References: <20200921225638.114962-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0047.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::33) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1PR0802CA0047.eurprd08.prod.outlook.com (2603:10a6:800:a9::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Mon, 21 Sep 2020 22:56:59 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dedfcb20-5fc6-4021-ec25-08d85e81a5ee
X-MS-TrafficTypeDiagnostic: VI1PR04MB5343:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB534327492EE2042F571A9DB8E03A0@VI1PR04MB5343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qnNE0fnkiHg7qRDuPxrBM6Ce5XxXvR1oO8e0qBcwf5GAUZn+75KapDK0bjrz6GBKqLyvCqGNXMaHPQJNN7aaGNdNRIWX0hVsIb3xdEiOh3r6REV+sWqIlLhsRuPVHxv8GiHdNod6H3WXUgFRm9R25zHh/kdY5N+UwqfxyrvBQuco+MHKyQAc8u1GGvp0F9qddeFnTPFjPFeSnvYUcEvnDzaXBJOxj3TwQwchPiWan4f1Zcqybc7tI+YZSD0Wa9kKvG2oCUxGWsngWZ4GdRBdhEPVb+u9n+HM+tOUu4KNri+owxq/+TBD1kuPYwlQsA61saatbDaAObu8v/ZJUH4NX3hH3sjGl3sykTF4yMr+MGiSdfGSo2lmYW1ee3mfzqIecyzWPEO4XIVNedGBXbvYcKBKgQ1dRbW8VAfffD2ok50=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(136003)(346002)(366004)(6506007)(316002)(52116002)(6666004)(86362001)(6512007)(6486002)(2906002)(69590400008)(66556008)(8936002)(66946007)(66476007)(83380400001)(1076003)(44832011)(186003)(26005)(5660300002)(4326008)(2616005)(478600001)(36756003)(8676002)(16526019)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PKwP/3SKQiI3AdQZRcEYVgwpp2Dq5+8N13Z7DIAoHda4oLWsO9FcU0HoTqAXnDAThU8T0/z4poZXXydedlW9E92T0SQt/s6ZsNBbMuWh92K5JPars/hyY4B2gtT9OHFkazc3OsScGXhE5vAX+152eTts0sICXkeLhGP/jl6k9nBSZ82FFL2uBrlQgD3/XsjWn/AhaX4Wpa+aGwnNNuFrxZEApl6TiUvbnN6biEbRqQ0eB8ewlPuRYmopkbwmfTgSbQ7CWXGwMBRgQVx7Ti0HdZPvRnj0UZe1tYtqMRNsApktESvd4vrLStlU53ZLUB+83L79W04fS/9fLrnYz5COGt2DxVvowU0XaGZjlofhXFeStvm/4yJ9gzN2erHXUjAzbncFG+sYzv8c/u76hvU5m4GOw/bu9V3nLf8SvT7v+McO7lrK8Q0qSIV2X55Psy0hDa1DmPGWmt13p6LVi5fFIz6c6DEITv0Q9NionVZclGCD/Vp98XN1JhqSEtq5FXNFq7Gn2xt10Q03OcTLC99U3WbG0xLsotM/gpYgPyp6FQgoLNVF1biUDyW2xIY2hUK4Y9VCFYh2J2Jwq+MwtzrOOoyIKT2dRt/wvTxcPFkI8eZ5dSIwSelq+Rk+E+4S1dYeyfJSCFFoJFMOsenJDnoYbw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dedfcb20-5fc6-4021-ec25-08d85e81a5ee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 22:57:00.3224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrKkWU5YvqcnphZ0wUjIoYLdB+F2+Be+vOAYS9no0xasa28yxgoVNudWsK0Z8T1yTiKLYXxsHlzEOODy1uYhtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since these were copied from the Felix VCAP IS2 code, and only the
offsets were adjusted, the order of the bit fields is still wrong.
Fix it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 57baa42b515c..c3f4ed8daa3f 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -649,17 +649,17 @@ static struct vcap_field vsc9953_vcap_is2_keys[] = {
 	[VCAP_IS2_HK_DIP_EQ_SIP]		= {122,   1},
 	/* IP4_TCP_UDP (TYPE=100) */
 	[VCAP_IS2_HK_TCP]			= {123,   1},
-	[VCAP_IS2_HK_L4_SPORT]			= {124,  16},
-	[VCAP_IS2_HK_L4_DPORT]			= {140,  16},
+	[VCAP_IS2_HK_L4_DPORT]			= {124,  16},
+	[VCAP_IS2_HK_L4_SPORT]			= {140,  16},
 	[VCAP_IS2_HK_L4_RNG]			= {156,   8},
 	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= {164,   1},
 	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= {165,   1},
-	[VCAP_IS2_HK_L4_URG]			= {166,   1},
-	[VCAP_IS2_HK_L4_ACK]			= {167,   1},
-	[VCAP_IS2_HK_L4_PSH]			= {168,   1},
-	[VCAP_IS2_HK_L4_RST]			= {169,   1},
-	[VCAP_IS2_HK_L4_SYN]			= {170,   1},
-	[VCAP_IS2_HK_L4_FIN]			= {171,   1},
+	[VCAP_IS2_HK_L4_FIN]			= {166,   1},
+	[VCAP_IS2_HK_L4_SYN]			= {167,   1},
+	[VCAP_IS2_HK_L4_RST]			= {168,   1},
+	[VCAP_IS2_HK_L4_PSH]			= {169,   1},
+	[VCAP_IS2_HK_L4_ACK]			= {170,   1},
+	[VCAP_IS2_HK_L4_URG]			= {171,   1},
 	/* IP4_OTHER (TYPE=101) */
 	[VCAP_IS2_HK_IP4_L3_PROTO]		= {123,   8},
 	[VCAP_IS2_HK_L3_PAYLOAD]		= {131,  56},
-- 
2.25.1

