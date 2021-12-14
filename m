Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642DA473A62
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhLNBpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 20:45:55 -0500
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:7390
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231177AbhLNBpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 20:45:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UiCr6Od4W4I9PS4IvMXpnklujVmtKn3iUOPYX/kPGoz6mPDz0piQCyDU5/9fbTOA6ALl0UXP+rRGAnAEYykoxp8Z+WsvZj3ScI3XWZn82ZSgtPrYvfOB6GiKYpEvUIPu646uv7oePLEI/LZeQE7C6s6ngwrTlT1tFmpeBNAWBEhTomd4tvccbU7us5IM87EQ0GlkESkFrn5llpQsUCwY9CFAmtRnKatoy0Da3u+N/nQa3CaEHawG0Act1zg68Q/VTzPimK7btjRehLjgiNmiaOLaNqveA7E7m/qyEX64fy8ywuIltOeOlH7OoK7T1hclpI5sRusaGE/BJtNRaa1FlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Njg5bzJviSSDKM1uB7f4bvQW7mU3SeNNYPVYUjwob2o=;
 b=AtpJqHrF9wUiBuMrlZjYP4g3/kLAp1WejzOIboF/ni/6qClbUmywfRBaB+24NypcvlA5t4WfYmI599x7eFKsz0f2svxnXX+bNbkeE63S9YMp3AVspyUwBsky/LPdLmNMkjif3F31et2dt8Iqf/t5kfDWVbpPSFWIf7Zuy7aIBTCPpEvyXuKfeo3o6icUUDBbH6gYt5AWdh2a64DwQcnxdB/kb7gOwDziVfsFimQbp1e25mNLN2gWDwFVvOBYDadJ5LQQakNlAgsQcSNQCUZXFezaHq3TPbQLP4IQzNBVXqHjG8lwiEE/ndKVTpJbOv2lqSZwOS9VnWP1+3JwUM1NgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Njg5bzJviSSDKM1uB7f4bvQW7mU3SeNNYPVYUjwob2o=;
 b=X93HRi4oDZwns/c7hNKx9SANVox4HZWBUguEVDhLe+tHSr1EwfEnBh8bI3sm2+sdRKYocHo0d3mLPzebcQrO0P5e4Iy9Of238yBpew13PO5trYudv6WrPvqYtIFEhPUbm/li1EOQ0wTgvx0WLG07SEDEc/Qqq8XOpIBH4ke3n1w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Tue, 14 Dec
 2021 01:45:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 01:45:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next 0/3] DSA tagger-owned storage fixups
Date:   Tue, 14 Dec 2021 03:45:33 +0200
Message-Id: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 01:45:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc3ce592-9012-4efc-68c6-08d9bea37378
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2800662FEFFF64F7C88F586AE0759@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gr4/RGOfg5aqPLOwXDI6b3DwdWbGQAkThzLq8+aQZ6c7Kyw6rFXnKl607sh3ZQoAkj3sqe7/jSr/tL/ymB+BPIeMzr6d4jgtoQKieH8oxZuiuB0bJI/YyiJNrl+sbZ6w7sIjJTloPpusAUh+bGMBf0kUE2rl/XiktmOnOLcz515nXAFcqX6oMmkVlDylw5XKEkBwTxtulzYjvw/sjAiKnH5lQh78p+LxgEW2XC74C8tOBIirIaUZxZRA6ca4qgfUsJHjla4m933Wfm56a1zxn71dNHemqSi/RIyiwRKoflSk6Pxakg1+ASOMykOcCVQg2Vo/NPY0unPCNYZS+q9sZvsRmt5SYwzWfeB+M8/5+zHZG4hAnfjf/eVLvXhZCWsS2k3VU4BH7NvwgyhxeHZk45atEDJnBGJVsWx+fBYA3fJuw8317csDBAqbQTJGw4SRgO5zwgVD/ggxCS6VZm9Jx84FLZBqDL9tWM+1Ran7cnOLIXHXjFFC5uykcKaIfc391qC9PG+RVvnD+yif7H9N8J+qiCQJdSpqAYm74/HBvH9r32WvfqgQ1srY2X0KyqBQME4yoWzT2WHUXMS5Eje5Qb3usTa2VB2ABmJDXI55cc3K+B8WKfXOhhkju92TgK9qAjpPyondXIcJtA4POSXWiu3lFeBt0GzvB0cUZsnMPBk2rn1H7wvs/AvvLkU3gHbwG4PeoQpiqJS1gPDCMHWAeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(52116002)(26005)(36756003)(956004)(2616005)(4326008)(508600001)(44832011)(186003)(6916009)(54906003)(83380400001)(86362001)(1076003)(8936002)(6666004)(2906002)(6512007)(38100700002)(38350700002)(5660300002)(316002)(66946007)(6486002)(66476007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IMvLgqkIUhi4a87lU8oxzCbuCzbb7zpJBUXtoKCX43MQJ/ElvqaWcpfv0DtT?=
 =?us-ascii?Q?JX76stYeHGSW3NNMhf8VqsJH4KyxPSmNUDtdr4DRGkLGGm+mCLyZuko3mUxz?=
 =?us-ascii?Q?v40N0KEuDSL/H3MI5u0G7NloN67wDPb5oueumx6uvso8TTnp7q20cZ7U+uai?=
 =?us-ascii?Q?YFXDsHToS+7x55FfBNI3+aanXIJ5eEsgEXAh5Li7/uZ3KRemgUSActk3Mx57?=
 =?us-ascii?Q?TmyKz+Sp6XSz2B7CAA/i94PE6yb4oQvhbGXlFFnclFotwCWA3gpnhki06Wf2?=
 =?us-ascii?Q?6Kx7PINFPYmZ/JTkCHCQ2DRgDCy1Pn7dy/+saKgnNc5XUMvRAKQWGT7gDXtG?=
 =?us-ascii?Q?E0aKbFL8t6UN9rnwVh80ZYyep5JSZ/TsOO2CPYpvrK6Z9L4J691pilEkNE+o?=
 =?us-ascii?Q?h8UGG1Bih8jI0T4s1U6KxXUOARJY/ugxhdJwP1J31IP9yvtNlABn2GIHtN3i?=
 =?us-ascii?Q?NFEqdoR/+nvO37saIV3BJ+4ngp3yct6JYasmHrVoExzTlguVJPM1w6CXhcHY?=
 =?us-ascii?Q?X3W9hXfHhz2BudVUDFqohR//72aKIc1Lzjz4XLNOwvax8otq4tHGK/J4zNdt?=
 =?us-ascii?Q?AsrR/nkigry197Nf6m56fsmAW6kYqKbEgNp9nmhMaYoMPZfY04/LrpW89Bdk?=
 =?us-ascii?Q?NYhAl4thg+fl/b7JJZCrfC/xNXN3yzi/RgjzY1umeuDhFKJ0yETZdRnQ1G7/?=
 =?us-ascii?Q?/PoE27a4YSSiVqZ95qivf1JgBBZwFQe0pwY7D4XDp3BMfI9OGJr9n5MaCB7Y?=
 =?us-ascii?Q?uyInDw0LTU6Y8PQFhgHkovY/tsB8xwgJRENiMDon4MEMEmvZ4BLE8W3Wj4A6?=
 =?us-ascii?Q?GrlcdQPbXlCRvuHmW6m5TS2v04hNEQUKeXb7ZGe2N3IMcgJQwpoivXbs8ozs?=
 =?us-ascii?Q?BEIfN4jKq+3MoW2PJHZgDCp7ew9WRFuXdER0uur4RpOgg7GmhHD2x6JhBxbi?=
 =?us-ascii?Q?wV1Rt0Wz9KQ9jWX9l/iZGt9CdfCRWldDGaWdXVu+GdqOmIEO0Z9Ykk8AHG2G?=
 =?us-ascii?Q?EG15l2TTumh9CNKOLu5KdUyCnYicZ74jrLeizjbob8rvrPinb8hNb69VnGZt?=
 =?us-ascii?Q?el7/fcClBBKCkodH1+AYOaXn1NHa4SaGCGYOv2ODOS089JpYGft6wb+aZaGF?=
 =?us-ascii?Q?+C1zQ+KwU7iA497xEpKmL41wwOsVOVdtbnXR2T3GoMSZwywVmRc+0U8ZCN3E?=
 =?us-ascii?Q?FaErDgYSnq+JaX8arzrGoF9SzBTd66B2s/dBYHrhTw+sG2aBPyGLS+/6mLFQ?=
 =?us-ascii?Q?hi5De26ouHp2W1fedv1P9leTdm5ROWGwJmyLDqpFKAUDVCpRIReKEuhyJYPl?=
 =?us-ascii?Q?qSdoJm//Qv2qDoJ5ijHH8M0XKKD/w1kCLBfLV1DTBOahIu/UKatXlRvVvYUE?=
 =?us-ascii?Q?HYJjuwma9IYji6tXQ5T3WatZyzkjFuw7sFQSD6kXUXyAOw3rByRy5SXHp85X?=
 =?us-ascii?Q?YnnT9IFGVOzFcc9CgetEJ5LK7gnbnMxNrRxjbIUUSA/iRtfndKLTGCmdSEy+?=
 =?us-ascii?Q?Y/3lULCUehzbnc0pDpa8uDgjf0B87/dpJtiQ6JIPJBhdmDPRYESX+LpTaEwj?=
 =?us-ascii?Q?6bN+++A4q1pT0O5RrMUE1r6xXmGHUgyc+wBIh2GuqusNjAqkXuSkfbzaM/e+?=
 =?us-ascii?Q?vuifX6fMvmyz0jWdHU8T8QA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3ce592-9012-4efc-68c6-08d9bea37378
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 01:45:47.7103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ems6o3VVms4yQmYKnd7UD4JiqHwSPwZVjyUKkjWZ7LSJZrFJ7jWLC0F+E+Lw6BWewucfPwOz9lQ2ZdxEeOnGNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that the DSA tagger-owned storage changes were insufficiently
tested and do not work in all cases. Specifically, the NXP Bluebox 3
(arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts) got broken by
these changes, because
(a) I forgot that DSA_TAG_PROTO_SJA1110 exists and differs from
    DSA_TAG_PROTO_SJA1105
(b) the Bluebox 3 uses a DSA switch tree with 2 switches, and the
    tagger-owned storage patches don't cover that use case well, it
    seems

Therefore, I'm sorry to say that there needs to be an API fixup: tagging
protocol drivers will from now on connect to individual switches from a
tree, rather than to the tree as a whole. This is more robust against
various ordering constraints in the DSA probe and teardown paths, and is
also symmetrical with the connection API exposed to the switch drivers
themselves, which is also per switch.

With these changes, the Bluebox 3 also works fine.

Vladimir Oltean (3):
  net: dsa: tag_sja1105: fix zeroization of ds->priv on tag proto
    disconnect
  net: dsa: sja1105: fix broken connection with the sja1110 tagger
  net: dsa: make tagging protocols connect to individual switches from a
    tree

 drivers/net/dsa/sja1105/sja1105_main.c | 16 +++---
 include/linux/dsa/sja1105.h            |  3 +-
 include/net/dsa.h                      |  5 +-
 net/dsa/dsa2.c                         | 44 +++++++----------
 net/dsa/dsa_priv.h                     |  1 +
 net/dsa/switch.c                       | 52 ++++++++++++++++++--
 net/dsa/tag_ocelot_8021q.c             | 53 ++++++--------------
 net/dsa/tag_sja1105.c                  | 67 +++++++++-----------------
 8 files changed, 119 insertions(+), 122 deletions(-)

-- 
2.25.1

