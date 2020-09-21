Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8833927360E
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgIUW5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:57:11 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:20979
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728692AbgIUW5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 18:57:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfoQD+60fagr7vpUWrXcy2eAaOqh1DCdT4xEahB2lkcjXJuD0xpZYjm5tyJ8yO+4/2hStk2yBSZOAlALBxpz2dc4R5ZZ0xhPRzshnprfhDQdO+Q58YiKzkNt4otvp1bn6JhPaTxI7P6oLxJJq75eRB8N7W5CKrEXEx+O1HwPmezDKvrj0V5dXZhgANzXkrppfg/Z4B9+ehdgg1MzKzj21W/a6+whCma0SUSqePWuspHcb8Gc9g/3AWgI9WMzubnS9FyS4vJww8ohIkGuPX1XdjOz364hXeIzzYQh1cgSrfUnRPo/a7RGq85qqNGIfCEbCqUB1S/V4G70jrrayZAXjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gogENdhR17acp27l5UML+BzCiiBTk22zCOkp4UL8hKY=;
 b=Yr3unvIYhoVk7azxhHNxAW7zLeldBEf7VMpkYfutU7i88ZRT0UHMHltH0KAeAz/rCKwv3c1dBDQSC95DevNDS4IV+i6cwhRfcL+lhhvnJsXKBiJ769WXVGjqyxsPWvtUQy+bDEomDmG3Aco8QklvYjZwsA7Ych/bVOxfSl67tLzjTvgui6RK9we5sfjdSA0Ab4idMEj6f03qmePgR+8eGWRHOACTVw54Zp2zloHco/0KcksiJaoiIWIP5CA+ivq5DMqd1pDPzZ3e497ZW/YVxigGM1G01ikXB5uHTbUCoyyc26hehzdNJnrmcXqehNIxfE3gQZu2aZoIw7J/ZkYlvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gogENdhR17acp27l5UML+BzCiiBTk22zCOkp4UL8hKY=;
 b=HUaoY2wD+0LTtnvbcwX5ryFFzNLDOTFdTtH5UbNstv9cszFh00mJ56zVPbKeXSeYZfwDFMoc0OnX/PnB5pVkexHTHB9zxugUTWV8DM1ILSmp0Ew1NZG1pcHPYgjUpXOmdHfuRzhXxSLsKx3OKJRHxMgjsMDErmOZetbXmHC84fs=
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
Subject: [PATCH net 1/3] net: dsa: felix: fix some key offsets for IP4_TCP_UDP VCAP IS2 entries
Date:   Tue, 22 Sep 2020 01:56:36 +0300
Message-Id: <20200921225638.114962-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 704fa14d-572c-4b53-7a03-08d85e81a584
X-MS-TrafficTypeDiagnostic: VI1PR04MB5343:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB53438E2076F6B5D0610EEAC6E03A0@VI1PR04MB5343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02QVC4yH1rf4ns57Cjm3c3AJK8Lo0X82HnXPvDeLcsjikfPNE4x1Is6bq7cWzBeM+B0jDIC7+5NX8fspnkma+/nBx2hmwaZaN1UKz8oJ5NuY9bVpkQdTwpPCVPJr5Xo416rfAA+95OSt5FxqRok16KldkZcXAMW12cS3sLWnTqr0WtEiTVz0TPfTQP9XVuCl+f1kBLADsHelJSYKnPiPhfHacTUj+XcAa5aegVS/eeg8z4W26vlEm3ff4FY3V3MsopV5EqHkaLK3Ppkm24dlGr6WCxgO/s+sUtdbpe8iiw/jyAhmFTaJxSaLZ3aOvgwOxNOGhle6+dnY5wvQ2/1gbR5jvdkB9QCLRL6y6wachvhuYJbO+8/4TiiShA8/bEbeoqJJ96l3tugRQ7InkEjWO8u31ySywFyvTb7c4qc9HzUYmxWA6a+RigHkQ7uLwiXg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(136003)(346002)(366004)(6506007)(316002)(52116002)(6666004)(86362001)(6512007)(6486002)(2906002)(69590400008)(66556008)(8936002)(66946007)(66476007)(83380400001)(1076003)(44832011)(186003)(26005)(5660300002)(4326008)(2616005)(478600001)(36756003)(8676002)(16526019)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PakAIF4qSTQy4xRjWsTpCR7877pl3ehUvlRvkmrS0D54MjmnoPYCOipXFDP89QZ6VvjGNf3mGAuE4EoNMTtTNuCkBrjB1GFbh+rA00m4ktSnZLcs94gZ9xPM4VB7jcKVVqGj2oFPYufH+G+ax4SKMn0PjoHVONXtsaJ0IrrZrr99yX+ZsXtM1Qz/gvVQbJyykYyN3bgOqRZ9+vfg8r4m9js8C+ctNnJHJrC8zh4Lw4tkWBWhZBWxVv8OTJRFp10tD2qdNu/A6jLHC+GJRo3puWgQqa1pNiBt33WuDc8tsxokvmR2lktsSMlt1p8wRYycOejCj3zBVZCNBehTUG/eCWTsz/YPFDXoN5jGKVAU7vqhh5GwmKvQHaIkgtp3Ly2rNEuSeXlrAfHPTy0fMXvWzh3G499Ny18Uw8mdNUJk1IYxLdukak34Hwz5TP0G4U9VoqQW/yGkeOWnptv7ccIlXuG68+jW6zxz9FVlkCwL4agPX/rrqPQ1wUc8MMlZqY2q5p0b7AeVaKExHL9/h4nVOyChsygNNus8+QEiL/ZVZMQZO8QBfYXWPRbYGWENJfSdjUsnDqN6NB6rkpcYnTdGdUUQHakqnpzJROM9B02ZVGXoe9sbKt3nmSggNu3x4E5Uu6MoigmGcMB9WxG6D4gqfw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 704fa14d-572c-4b53-7a03-08d85e81a584
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 22:56:59.5918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SN2Thsa+oNnANnglDQk059gwJVAoigQhfjMrJIU6CkhK9emfN4JtEeCweeQ2yeB8qhSlZtxtJ9K4FCT65Lp8aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Some of the IS2 IP4_TCP_UDP keys are not correct, like L4_DPORT,
L4_SPORT and other L4 keys. This prevents offloaded tc-flower rules from
matching on src_port and dst_port for TCP and UDP packets.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index e1df0b85cc86..6690c2fff5eb 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -646,17 +646,17 @@ static struct vcap_field vsc9959_vcap_is2_keys[] = {
 	[VCAP_IS2_HK_DIP_EQ_SIP]		= {118,   1},
 	/* IP4_TCP_UDP (TYPE=100) */
 	[VCAP_IS2_HK_TCP]			= {119,   1},
-	[VCAP_IS2_HK_L4_SPORT]			= {120,  16},
-	[VCAP_IS2_HK_L4_DPORT]			= {136,  16},
+	[VCAP_IS2_HK_L4_DPORT]			= {120,  16},
+	[VCAP_IS2_HK_L4_SPORT]			= {136,  16},
 	[VCAP_IS2_HK_L4_RNG]			= {152,   8},
 	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= {160,   1},
 	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= {161,   1},
-	[VCAP_IS2_HK_L4_URG]			= {162,   1},
-	[VCAP_IS2_HK_L4_ACK]			= {163,   1},
-	[VCAP_IS2_HK_L4_PSH]			= {164,   1},
-	[VCAP_IS2_HK_L4_RST]			= {165,   1},
-	[VCAP_IS2_HK_L4_SYN]			= {166,   1},
-	[VCAP_IS2_HK_L4_FIN]			= {167,   1},
+	[VCAP_IS2_HK_L4_FIN]			= {162,   1},
+	[VCAP_IS2_HK_L4_SYN]			= {163,   1},
+	[VCAP_IS2_HK_L4_RST]			= {164,   1},
+	[VCAP_IS2_HK_L4_PSH]			= {165,   1},
+	[VCAP_IS2_HK_L4_ACK]			= {166,   1},
+	[VCAP_IS2_HK_L4_URG]			= {167,   1},
 	[VCAP_IS2_HK_L4_1588_DOM]		= {168,   8},
 	[VCAP_IS2_HK_L4_1588_VER]		= {176,   4},
 	/* IP4_OTHER (TYPE=101) */
-- 
2.25.1

