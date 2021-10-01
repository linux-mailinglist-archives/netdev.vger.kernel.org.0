Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6785D41F0FD
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354873AbhJAPRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:17:30 -0400
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:20648
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354824AbhJAPR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 11:17:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCDtwygXP5B6d5LCarUGuL8+PY69WADOuaf8nXqP8wixlvXRR6pFck4jbGm7TJkxj7E5gaJOanfc/q/vbVA8awusU4FqBAHBvlePX+U7ffumGM2zpmvv9atEwVU3diq2i5sqsYtFSOMndQ2j4uDjGIdAVXNecbVFXrQCzV0Bj5PW7EkaAYcEpgWk90DeYqEWu2i4Chzg0qv5XKk6sVUKNNUoGYJyIdqz+XHj5L3gD06r2d2+8zAnon23DC8JnClajyL4ctidybvuDJ05zEGPQEK8uDLfR1sDUTw94SQP2tc/EH+8nU3chQYMjHN6MuJLaSxPUH5H4+Ndl/eSw3b3LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4Ye1EhPCFM36pOwZBMgaTaOdeEKfS/v+PtAyEBIn10=;
 b=bySUmTQ8khQCqWBiPh9wZHYYL7BumX/f1LWK2xDcDp9vzIoHM45x966rp+Bg0xbqAZtD4mcgQJJuQOxSR5pO5Lndei+0We6kVMbP82X8Z3cGITLlDSEbt8dR5j/k99vwqRSL912Ur15w+myND5gGMPZriqOYNYhOK+StFeIbYvh3Btd+jroi185lXfDtbxTu8f1aka+btCYBQGDLAL1XoH4q2OQKXm1YJTmmzqmnkRLmdlo/Uzn8W2oI9GXfgFazQA5AHZu6agBTd2fS/fP+DCOqyRYzwTbz1HID2k39WlCVoNWf+P1uAV2TfQbz5ZpMw7lpy3FO+RayOPs4morfVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4Ye1EhPCFM36pOwZBMgaTaOdeEKfS/v+PtAyEBIn10=;
 b=e2v6sFp/jBVJbvwCaNjWR6tREe3na6wSm9PTbyz2ohhcqK+mQFIHCNROq8q3UdqACASulkCzXxUkMJfhC85CtG7MVekopWzIjJO7bHjZr05hOgDejbnX0ZxPxGmbkIONTxeGTmzA3b+yo3zpYuZNWbk820Vm6rlM7Top1vym/bs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Fri, 1 Oct
 2021 15:15:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 15:15:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [PATCH net-next 0/6] Egress VLAN modification using VCAP ES0 on Ocelot switches
Date:   Fri,  1 Oct 2021 18:15:25 +0300
Message-Id: <20211001151531.2840873-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0001.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM0PR08CA0001.eurprd08.prod.outlook.com (2603:10a6:208:d2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 15:15:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d93cc095-4857-4a24-5aed-08d984ee557a
X-MS-TrafficTypeDiagnostic: VI1PR04MB4224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4224435B130CB5B3AC66F1C4E0AB9@VI1PR04MB4224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJ8ZoiszbmrpFST6/xp1HK02jmc8nihpjZQgmoudqfHYNMmxtIf63j75lkRR2Yuy8Cx7bCZuYcJdaGv6IpmDcwm4dBcFQsX8kROcoum6kozrKm6kc2I8R8/+Z4xYb2HwgaifEeOkvv2Zt3w4WrJQxytQIycQCmMBOOrrJWkMvs7rLUUQv8v/4i14skwxISJbdKiR/AFAqNTbY6k9J5rdf6Wds7fE2TV7nKQygcjd6WoJUBZQeCDB4JiVNUpG6DXkgX+QvZy7nFDXQ5+h+KQRnNv1BihKDVifv2Hou1Sh7Ne88zPMlQlw4941lM+H+XO0XwcWd5bx+8N9Zv0oZfRm5gZjyDCH81okAqQrw5gMMLLv5D50X1YxBb3c4J2v03D9jJMbQxhgqOGjoSg2PcwEm6QvxSFqhdzo3fZv88L7m0TFrayQZnycSGy9B8FxPmjlrqPYSQUIM+oLHeENIibmOO2+AGbyC5DLCiQv74aeBv8zC9cwl7vZub1z0sXltRnjdkHY8zGE9yBQCcMTVmPS9E5KoKtvaIwgZ+s4NRFdVhnaPlTNT1IoNSIQXAH7GusyeUDZsNiOlFEJaksujy7wZO3qaarSvmLWuEipTzg32ETf1GO1UIZlsgGCzcftueCYgPOnlgq+yYYf4lRMErnKG1ZZ8EMsMNF71eZAe+/+71aaRFUak+ghBHzxQh9r0AFO3GM1fS51aAdw8LWHgOTE3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6666004)(1076003)(5660300002)(6512007)(26005)(38350700002)(38100700002)(956004)(110136005)(8676002)(2616005)(36756003)(54906003)(52116002)(6506007)(8936002)(66946007)(508600001)(4326008)(83380400001)(186003)(2906002)(6486002)(66556008)(86362001)(44832011)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fg//NlBs/MgZVVa0x2X0jIsWUnkED/a7B/sCG1JwcdqoiCpDTa97cFOFCuPQ?=
 =?us-ascii?Q?v4CJpHbwapyPTXh567sRWjLuspJL9ZhQPfn+g7xDKJnYlOfAjFN6IxGXfp51?=
 =?us-ascii?Q?7fd0TJBfEGri3h0u9EzK0PyfmO2Ses43PM8txJlY0sT3/2t6L4/kybnwixn+?=
 =?us-ascii?Q?FSlZdfXQx3gJeWqKaokpmgl3PmJsA0MNFyb4iSqCUHzJUsulg9QAgwTMQRJa?=
 =?us-ascii?Q?AgRZH848EnlHHt3425si6cN5kyTjxMH3+3hsVXHLcLLdd56mvFkuHvYW/eNT?=
 =?us-ascii?Q?1MTk50msJW932+bRfcPl0a5ZfpdceKywJCNOtdndBRsy2VZGh95SDNeih1EL?=
 =?us-ascii?Q?gJKTA1Ql02IlyuR6OcIIloxJa+g6qgSDJuxXjKJFKp/g1vHvnOf990ly86Mp?=
 =?us-ascii?Q?1sCl97rPPfWFs3SQHdInvh2ZJUx7K76kSlUMKmaeLTzMlyXN5zbLX4xACQ1u?=
 =?us-ascii?Q?6wC4CV3N3/55IaJ0h8snYHkveUARaGr0nFfO37B/L8L6G0wylViC/DOY5rZU?=
 =?us-ascii?Q?GoXbZIN7TX5N6edL1G/FE4F/UsDl/ORgZFWojN/svhOKTwB+9aTHNmBm4v4R?=
 =?us-ascii?Q?CKCavRn0EzmdEaQufh7mbWZphrrkW/oMNLG99dxDZGImQjWg+yBEq/PcAduJ?=
 =?us-ascii?Q?J69NuMHe6mvR6/ETBMZpohtsYynAt+z6AZwF/zT5EL4ltnor7QRyNNuzVE0W?=
 =?us-ascii?Q?RQGNWjpKrlYMis5MvuKuNij3r2KyM+WMRW+XjYRWC8EU0rQKsH2VC/LgFwoI?=
 =?us-ascii?Q?9eEomwLvgBIDkL+qUPH1BSKmR1S3r3xXROzbqIfXtpu2BNhiwHIyGl9W2OIh?=
 =?us-ascii?Q?NZW4DS2IKE7RRbZS9UNf+/DEucQdreUEVQX1BXodUM78S4tLYv+vxNPswOjr?=
 =?us-ascii?Q?6ZrMkUJLKah9K7tI82i2LeU8CrC3yK2vl3dxgUMBPTeHshzkpfiuaCkNh3kU?=
 =?us-ascii?Q?qDHoO20moTQ/LTMQHPIu3VxNhSEG/eIGZV7BXLQVTBZ8EvoN485n0mPSzdbl?=
 =?us-ascii?Q?Y6SZwsyNifa//cV1YEpI5nX8RC0CbRKtXPX0PeXvYP2vtiim5l9Wm1BV8FtH?=
 =?us-ascii?Q?+U3mItRZM3E18G3oEwdo8fYPQ0f28175sATwDYvyv5uke/GfSJ/1ikJModo4?=
 =?us-ascii?Q?7sqQiO0E++M5nOEin0IlxAAJp2iznabA/yMbKoaufIvTfxmP9ertY/ZrqkZS?=
 =?us-ascii?Q?vcx535s6ThoglYnwL1YYP1r/t6Df7iq0baglfR7oCQVwwxcdzxAHyC3y9b4S?=
 =?us-ascii?Q?SjD4khIlbNQkzzwQTHZYwDvPGk0MXSe0O5jFx68QdFVPsCsGX7UHf2LDPxtl?=
 =?us-ascii?Q?2m/y6t0u+Fdl7s2giP26rE+2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d93cc095-4857-4a24-5aed-08d984ee557a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 15:15:42.2829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1l1w0uUogFLWA+9Af6T5u7Vyn5GwmG6lBrFsvRVWNg9SYVeOaB34FAWJxnpiBYY6hPgdImEMpJCG4QSPenp0EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for modifying a VLAN ID at the egress stage
of Ocelot/Felix switch ports. It is useful for replicating a packet on
multiple ports, and each egress port sends it using a different VLAN ID.

Tested by rewriting the VLAN ID of both
(a) packets injected from the CPU port
(b) packets received from an external station on a front-facing port

Adding a selftest to make sure it doesn't bit-rot, and if it does, that
it can be traced back easily.

Vladimir Oltean (6):
  net: mscc: ocelot: support egress VLAN rewriting via VCAP ES0
  net: mscc: ocelot: write full VLAN TCI in the injection header
  net: dsa: tag_ocelot: set the classified VLAN during xmit
  selftests: net: mscc: ocelot: bring up the ports automatically
  selftests: net: mscc: ocelot: rename the VLAN modification test to
    ingress
  selftests: net: mscc: ocelot: add a test for egress VLAN modification

 drivers/net/ethernet/mscc/ocelot.c            |   2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c     | 125 +++++++++++++++---
 include/linux/dsa/ocelot.h                    |   4 +-
 include/soc/mscc/ocelot_vcap.h                |  10 ++
 net/dsa/tag_ocelot.c                          |  39 ++++++
 .../drivers/net/ocelot/tc_flower_chains.sh    |  50 ++++++-
 6 files changed, 204 insertions(+), 26 deletions(-)

-- 
2.25.1

