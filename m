Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673163E01C8
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbhHDNR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:17:26 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:63904
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238343AbhHDNRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:17:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBVCN0PQTgLnmcLmpCWr5R5069Pa9eB6XSgfHvRPr6DDHnjw4mNYRcbrS26sJ8kZE996DiFx61yh0eG4IPzkDwV6AKEd0fQeVR/Gqqc3nQclmXIjPGE+UNzUeP8QRCW5jG/M5RI/FXEM4Zu7vMsxl3/cuwDsF0YZjg9rPkVxMVws8/EKWHVfrzlcMiHVkM3Es8LDqoDmUBlIwsbBHIOkPmpjpGPCu5N/M2OAWCMpd1WUCY93Lj/hdPLyJn38wYSTjjCdRD260t7sVtLoPgoNBvTg1SsjkqqkPJ4ym/VjV3PaHpW7TzasL4pNiykLqhuvfLlHjReRJwJLE6mfBJ7e2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwI0jm+ZWgmCnORWmGh1d1TegTIKQ6d1GNKUNNMaqnI=;
 b=d7Br2vaLR46kl/YFsGF1wUnvgKZarjzv25bahjUtNR602kIPmTGSo9Ld0+jKKEUwMccbtoxJF004HOq6TfeSLbeOK3gKTOC7zmGvRXkT0H28euW37+XfgukfiXSB2K9gTnWIRxB8g2H55806iOSMcArj9gCvD2zdLcgzfh/zu5QmxsHyTOMEaauSCBNzUZPh1GbqYJylw96C0eWJrR0HDCcuaXE7evXV2hk0yYhzttaS3Q503Ez2dOOCTbSdqc/1e2UT/PBbnxS0FsZ7iOEGF+tIlINiGC0rJWhfkK+cOMexH+OMTw0gnHT/8NsxcHZeQrRNqpdYcmCJVVYwXffIPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HwI0jm+ZWgmCnORWmGh1d1TegTIKQ6d1GNKUNNMaqnI=;
 b=rWisHJZUqRRz/cy5MjRFyKVT9dLUhXppiXXxLi3VLBwrhVnbuFqWoLk8Iw6f/TSD3xy+uIeM2Rkh7f+6wcLYB9uT0cphjtde8kBb0pqlRNW40syAwjUotM0pjuYAzRSKpA8qraAeU2ejDEIL8RLMrFVFokO8IF4xJcUYVS/m01I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 13:16:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:16:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 5/8] net: dsa: sja1105: manage VLANs on cascade ports
Date:   Wed,  4 Aug 2021 16:16:19 +0300
Message-Id: <20210804131622.1695024-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
References: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0083.eurprd03.prod.outlook.com
 (2603:10a6:208:69::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR03CA0083.eurprd03.prod.outlook.com (2603:10a6:208:69::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:16:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d0dc72c-dbbe-4977-803f-08d9574a1c1a
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB396746FE879C6534E2611643E0F19@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAVdPsiA+oSGSLGgvYeE3BZEQ87ppKaqXx5LK3UEQIhkghAOKrXhMjfJln0WCfi7qEi9nW/IRFHpBccGQYgCev35pkVEjDgq2rhgg6fUUywqsBeXXX7MxVgom/df6CVtxO2MLBDqbLvsOHNphIaBN6WPKHiUbo4+qI9W8KZRaDvPipuhZNQgZD3SUN4uqIp8QfkK/me3kQA14LOslUQGNUIbLwlfBtWsGCUQflOWRwe+yRPNTOMuZCBIgaK7NKu3xPJf9lpEzGcUDrZfib3na4cyQcmUtVVDUE/Q6MGWm8ASTRv36GqMq25k1gpaamwdz4/onga3U9M3uWNWTr5cHRHOuYD/AWQizdCtCnsYA1nWLnJokVzGOiA997QeNkXnD/C4meO8tU0oPUuoXjQiD6CeyO9qxDbm/agXrb/zMRe/a85ga6oWwT4MgBusLxgXH2X/udQSuAXa6xTR7PzX7jZth9LszngSFk5iN6gE39jK+IX+dTYewI7V9GcAI+P8nqqHdFj5GL3Obywb9I+KGDSKb3SRfokIVyEZO6qwjDNW4KUJzo4IwT/5bjrXjvyz5no26ShOYPEvYLhtatp0TYlIJHQ4C+AsYk2t/3t4dt/ZYb+b2a4mYcn/JcUgLedMmTKaz1EnedhiKkBXpTwEyGkhnL3IxmX6S8AtRCSs1It29afgbtSpiT/WvRHhc9MATTbqsWs95rHvtk9tLuTUbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(478600001)(36756003)(1076003)(66476007)(2906002)(6512007)(66946007)(83380400001)(66556008)(54906003)(8936002)(86362001)(5660300002)(8676002)(6666004)(316002)(26005)(6486002)(110136005)(6506007)(38350700002)(52116002)(956004)(2616005)(4326008)(38100700002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nx85FMm8BJNVcUixCOSlrhSZUn/h43h8GxH7sWShgIyK/mwzH8jFIYGEaGBO?=
 =?us-ascii?Q?hrbR6f4XEKpNmua4Or0B9iSWP5Oy7NRpENdnq3ySW4t0XqjuBn78/2XMG1Co?=
 =?us-ascii?Q?mi1SDosShRH2rfc7dZsAMAs9jDdsestJQrIdPH2v3tlkJ0p/g1ivgI9rxqtA?=
 =?us-ascii?Q?t1bvaua4LHYRrsjTkMMkvEm1m9V38MKvsnH8dqBsdw7ykjuQe8vWhqoBX+ml?=
 =?us-ascii?Q?STRbxpVC1L0H/F6TkN8LUTbcevMgGl4hGGT8QSXhICzYiHGSDwkjvzozhQaP?=
 =?us-ascii?Q?Ki2UtUSDQKyOq5B45EqZ13jeETdBR1c/ZdVwea6XK0PD0i4Wwm1jdFrSMcvw?=
 =?us-ascii?Q?kvpacxqxp92tmf5/1D57OMIII2XjHoUq36j48H6m8n3Zhzv8cogAx2CZ3r2Q?=
 =?us-ascii?Q?autbmVwFoV3RS63CCpwgUovnmriKkBKJRUwITq2pilKOPtu9/s4cxpZ2GS3o?=
 =?us-ascii?Q?ae1gnO2b+qfhUTXnE5M3wsrSiZdF0vefzY4bzhQhGMrWFgWkfjbZg2g5J49y?=
 =?us-ascii?Q?wBMjp+VZF6De0aOMTmKSjPm74f58P370Laeq3zjIb90uy8Cp1LqNK1i/cJPG?=
 =?us-ascii?Q?tsu0czDDYGVAbDk52n3m36FfpwZrpwAjbltpGuKsCmp0X/EpVoEx7EiZyh7D?=
 =?us-ascii?Q?GhiT6K2z3SGoFBx4lVr3EWYVziujWVmBBBC3OXMpbKABpPitxDmAOdH55agh?=
 =?us-ascii?Q?kurDppZVgnsCDScPHj0xoP0SIoIg/JDDsotT4O5H0LsHU+ptOyM6e6kHbbvz?=
 =?us-ascii?Q?TSgJ/9XsH5C0N8kR5qAUZF8NKcoPi7KO3u6i4Zo6DsiOLid0VouoiEW2TVO2?=
 =?us-ascii?Q?8nGCgi9teFUPNbBUojqj8GYa532pjvFX/GSP71F2CHeqrYcsoe8FYH/rSaHN?=
 =?us-ascii?Q?6wPz3yGO0RMiBkEsw9hDDoe+V5JwU9qzb2de1T+T6N1yNomRtY2IppwYO5PR?=
 =?us-ascii?Q?DkdzEJ080l7AkfdDXCXpe9A+T+NjdgqyrIXFP74NOGvGEv5Rppn6cC2Rs6gm?=
 =?us-ascii?Q?M6/SmB0zd0gUzOYgzpfHYsvQOp6HqyvUkJr9EU4RnRmlb/2XD80KGMfSspEJ?=
 =?us-ascii?Q?O6jGiyTaW5Wv72ugM1jkIcrobbkG3WRPwqL+9BlSnGs085JsrR8YjOiDkvEw?=
 =?us-ascii?Q?AMAZYF4A6Np3uDLZ1dOJd33ShTfCvDUxaEt1Veaq3+4F/zwhS4gk3CYyh0zA?=
 =?us-ascii?Q?P2Pmv/BdBd+QyObEHcZ2X1/XKgsiSKMi9lfMcRvfhOPT1zcl1LBiOtwVzQri?=
 =?us-ascii?Q?gztUsT+8oHdvvl++YFdBlp9opbk4nfzRgt+4mDZLxU83lTdMMdb7mFzIU4n9?=
 =?us-ascii?Q?rpoa4HOXZ4mg46dAGlaDEVYd?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d0dc72c-dbbe-4977-803f-08d9574a1c1a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:16:46.4448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CCC3VBl4fdfSxwJHJ6T397wVzppWGtiRIWgCM6dliN7BSO3bcvmbbACYJJHSGBPDOms5Vo0xbulWNoVlyE77YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ed040abca4c1 ("net: dsa: sja1105: use 4095 as the private
VLAN for untagged traffic"), this driver uses a reserved value as pvid
for the host port (DSA CPU port). Control packets which are sent as
untagged get classified to this VLAN, and all ports are members of it
(this is to be expected for control packets).

Manage all cascade ports in the same way and allow control packets to
egress everywhere.

Also, all VLANs need to be sent as egress-tagged on all cascade ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 66a54defde18..d1d4d956cae8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -460,7 +460,7 @@ static int sja1105_init_static_vlan(struct sja1105_private *priv)
 		pvid.vlan_bc |= BIT(port);
 		pvid.tag_port &= ~BIT(port);
 
-		if (dsa_is_cpu_port(ds, port)) {
+		if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port)) {
 			priv->tag_8021q_pvid[port] = SJA1105_DEFAULT_VLAN;
 			priv->bridge_pvid[port] = SJA1105_DEFAULT_VLAN;
 		}
@@ -2310,8 +2310,8 @@ static int sja1105_bridge_vlan_add(struct dsa_switch *ds, int port,
 		return -EBUSY;
 	}
 
-	/* Always install bridge VLANs as egress-tagged on the CPU port. */
-	if (dsa_is_cpu_port(ds, port))
+	/* Always install bridge VLANs as egress-tagged on CPU and DSA ports */
+	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 		flags = 0;
 
 	rc = sja1105_vlan_add(priv, port, vlan->vid, flags);
-- 
2.25.1

