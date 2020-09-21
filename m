Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3218273611
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgIUW5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:57:14 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:20979
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728708AbgIUW5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 18:57:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abnpyZ67rM08Qdj5IWZpZT8562BYspSD3UPTMLuEA/0p3CM/wYq9Nrn8D/PHdodbgZshYbYQ65gPUTP2h8r24LhIo7dJ08IY9cRRMKEUQQsNKMacY4xFtbFYpwy0N18kTGFO0rip7Yq3Np+vgCTAyegEZ8u7eUzfc0A2Fxd1k7eXEQktJ3d/dEUJaL8rKZ9JY0cqk6/8PPgUIaUF9Trgd7VSSkpKnH155Wl2BO7+Dkwl9oznt0DH4H8uqvfZLXB6CiF7KQqgJC5Urt1kia4UAHXObSDgIVh54U+XGF7iOMHbZG4BwTKZlBBUNl7gnmxXw2b3qNYQ6MG6e5vcRMPCjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoOax/UqpjKzDgeSyGwIL/7PZ78IKHWd50YCZbCLLbo=;
 b=OBLbmiYMbhn/Q9Amq6u8NqgfSAZOX+2pMxBAuvtWJqVtwmtzLyhwwMD8GdakCRePtBwmx6dgohNLJ5W76Rc4oWZus3dm8D44hrEIsHFuyBhWTKat2wVaKMb0NLQTk8RcfkblcjUOGSfj6CbxBgAfHAM8tPSAkVP/iBAexhyqZLIBEe1RC0D/0lSHrMTa+tBGNfQ4Ha6RxGCNU0zC0rhJ3St0J/ojlShyN3GSupr6lbSZKGRno8cB91dEYxNmWJgmN6RRB2XhvUbeB91MHTV2aWmf3QO5TRgAJAEU1xY5HxYTtuP/42bTTg6xPci8J3NpVKaIxYlcQISrxxyrnAgWUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoOax/UqpjKzDgeSyGwIL/7PZ78IKHWd50YCZbCLLbo=;
 b=iMX6dIO86HyyxH+yZF5zWSb5+z/gai4ynmmaBe/qxHdSa2jtAnLbDYjE/akusWaME/jAh1xnfi44mJleOlHWSLkr7raParu6PX5YylMuNI0LdM7ifOn+UK5JBvEnEc26MjwPtDVzlTZnOyVQDcMLbwK37856tR1nRRrGxpIX23k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5343.eurprd04.prod.outlook.com (2603:10a6:803:48::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Mon, 21 Sep
 2020 22:57:01 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 22:57:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 3/3] net: mscc: ocelot: fix some key offsets for IP4_TCP_UDP VCAP IS2 entries
Date:   Tue, 22 Sep 2020 01:56:38 +0300
Message-Id: <20200921225638.114962-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by VI1PR0802CA0047.eurprd08.prod.outlook.com (2603:10a6:800:a9::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Mon, 21 Sep 2020 22:57:00 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d853255-27bc-4ddf-e88f-08d85e81a661
X-MS-TrafficTypeDiagnostic: VI1PR04MB5343:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB534367148CFB6180BA38FD18E03A0@VI1PR04MB5343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tX7kVMwSvYRbFUzEe7DlLYyfuvydPfh1XQSi/Jb3z+dcCrGsSzqzp2r0qMySoGodt0756PYKkEkoB0o3vZZS8/GN5dUGvcCjQDlU8WVmWHPlokWajA1fEgnHlgkfoUN3yIQ0cYUOxgWmw4ccMRcLJvJ3fr/XfDDuIU1uIqRTk7fTOGalqxZNewaQ2Hwjq4YmgqwtoCFZXueNWohYdiFoItrijZ0K+g8sJSueOVAIdwO+1MnfceuDmYnLdchrGkKyKIpER6pdbBjwhcA+8Q7djERr+3DvL1J7DBB+jI09vcmFvSdbqkBDWNruCTDrSPz+ezJL+g5gKQJBMaaYkUnxIPMjWfl9idUa/8X6DMLC5xslVyLa6KqSccsB5lEZstqxoCxLbY4cl5TuKtHYXw5EEcNMucbqYeIZzkjFP9zTpt+h8nRYOCQJIonR0xQlr+G3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(136003)(346002)(366004)(6506007)(316002)(52116002)(6666004)(86362001)(6512007)(6486002)(2906002)(69590400008)(66556008)(8936002)(66946007)(66476007)(83380400001)(1076003)(44832011)(186003)(26005)(5660300002)(4326008)(2616005)(478600001)(36756003)(8676002)(16526019)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mQHCsLYVPjq2kt52zj45y6kSanPmGPexU/n5gZP8ODqVRzqMZ3pHwIHCQfsJFq5mWSnGFpBVJPXlDplaBUoyRuCW9qQ5Zb8lmRfsmUlvot7CWgQ3qH8mT5Se4t5ImTySpTyCv8DoZ4wUmbmnPb+AxdJ1qEQstV8Mqf0BYch+3zqEOMkN3ng3d9BfVGqoQ+KpSVRJka15aQGKHz1ML4rQnS+hHQHKdgOouaAas4SqU3jFfY6m5M4y1rbk4H9A5hdO1pzN+7V+hTZ6EvJyIDSh1LzFN/EMhXn5cogSv84xMlulDKShIusoAMlJV67TlDXAZERSIkaAMy9ySRNWN3HSZr4t5ivJFGXB3zYWksrLHEtLK/6va1UxpfBeYiJiy5i7SwIZ9+TSfmwCDggq/QuQ4QIYBAqODN3JgrtX5Hf6KYcRmG2vWNg7uofpfTCu9cB9rEY5cTim/vrQc47mPC5KfJbkedqXWuxNjKFqspAv2JUeNOiYN+4/dxGO/f/wAR0pU8xb1HrKDzP8vnW5/T71GvQF27RYNrxzSt6Xn9jfKn1g0XhOzraIlYnRIWEGdDH4W1wYMpPGsTeSv3fAo1eZZKRz3IDEOfMe4EIvVi3HnX3gQgd7JSxc16ehYv9LeA/doyCpftCQtxm9YCb8CjbjJQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d853255-27bc-4ddf-e88f-08d85e81a661
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 22:57:01.0240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmZ/IYZ9agwOy2kiYYlPtV4P314WJ5nHn9fEo1v0gJXHs/AJypHuUjVyhQxv0ABtxeiPzWNgy/DlTaiKEDkh0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IS2 IP4_TCP_UDP key offsets do not correspond to the VSC7514
datasheet. Whether they work or not is unknown to me. On VSC9959 and
VSC9953, with the same mistake and same discrepancy from the
documentation, tc-flower src_port and dst_port rules did not work, so I
am assuming the same is true here.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 40558578eb75..eac241ee30ba 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -807,17 +807,17 @@ static const struct vcap_field vsc7514_vcap_is2_keys[] = {
 	[VCAP_IS2_HK_DIP_EQ_SIP]		= {123,   1},
 	/* IP4_TCP_UDP (TYPE=100) */
 	[VCAP_IS2_HK_TCP]			= {124,   1},
-	[VCAP_IS2_HK_L4_SPORT]			= {125,  16},
-	[VCAP_IS2_HK_L4_DPORT]			= {141,  16},
+	[VCAP_IS2_HK_L4_DPORT]			= {125,  16},
+	[VCAP_IS2_HK_L4_SPORT]			= {141,  16},
 	[VCAP_IS2_HK_L4_RNG]			= {157,   8},
 	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= {165,   1},
 	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= {166,   1},
-	[VCAP_IS2_HK_L4_URG]			= {167,   1},
-	[VCAP_IS2_HK_L4_ACK]			= {168,   1},
-	[VCAP_IS2_HK_L4_PSH]			= {169,   1},
-	[VCAP_IS2_HK_L4_RST]			= {170,   1},
-	[VCAP_IS2_HK_L4_SYN]			= {171,   1},
-	[VCAP_IS2_HK_L4_FIN]			= {172,   1},
+	[VCAP_IS2_HK_L4_FIN]			= {167,   1},
+	[VCAP_IS2_HK_L4_SYN]			= {168,   1},
+	[VCAP_IS2_HK_L4_RST]			= {169,   1},
+	[VCAP_IS2_HK_L4_PSH]			= {170,   1},
+	[VCAP_IS2_HK_L4_ACK]			= {171,   1},
+	[VCAP_IS2_HK_L4_URG]			= {172,   1},
 	[VCAP_IS2_HK_L4_1588_DOM]		= {173,   8},
 	[VCAP_IS2_HK_L4_1588_VER]		= {181,   4},
 	/* IP4_OTHER (TYPE=101) */
-- 
2.25.1

