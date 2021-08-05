Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332393E13F4
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240848AbhHELgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:36:54 -0400
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:9888
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240731AbhHELgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 07:36:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2oAJ+YwQiiZk1IznCtZueGqJzn3Ul7e1aOVgefxIlv5f2B55NgI71tgWecrZUWnCuSd2m60YpPk4VB22lxLoXoE4fy9Zje8uGxTjiLmshw/hdzZj1hS29zysqOg+pvry5tqf08MgYVmuoXeZpsQ5q/ezjsl6exjdqwJ4TS4WfS/UvdJd8bvGyGbIoPv5H+zIh/HBAtbrj7ttO/LWmsjJwrB3A3PZVqP043vcOIdEsorBh2Xhm2/lRVuesX0cvMn1NyQH8tLJ8E/J5u7DGYlpEp3tiVCoB0xc0xiL845kpfN/PLY1FeCSKwBryEshC0PKlPO3W6Hcglz6BDQJYxN6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/quqMOTo9J9b17dlTVNvdkHh7zhZ7H1DKAUbDoI6SA=;
 b=gHhywytSqL4Pro0LaTFAORHThtDZKX9C0D2yIQrkTfzfN1id2h6VSaqkpi0+1gTn+yLjW0GR44t9Sw8CJDy53gqooVoDm/8L6W2IlEh2/M3+sy93w1vVZhn6IPkkor7CeYkAz8New/OUFA2WM5ASom+3XklO9ZGKll09Rxj/X9zR0xB01FLx06F45OpABBlwvqNCuBHzg4VKieqUyIWjobE9BpkiPtw7y1wTG2nL7oaNZui2UTnJ+AtLKk3Vhvr/AtvFfAFd9AiLthLCwHdTr2m8phcyXAzcDz24AhirmS0LlhYlbFS58tCfb3nT8II3qzEW3RC7fpgG6gB5GEhO9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/quqMOTo9J9b17dlTVNvdkHh7zhZ7H1DKAUbDoI6SA=;
 b=W/0/xine9KAb2zmt3/4SDXnC7pkzd44DMmQQhIW6DrjDeOPxJAu0S7VjWQf8of9HcA3pKPFyXiMHh0atNL/rRn7VyEeP/sjhg3dJLbKbeMX405Yg6H1dyMhxPFsBuMX689B5OxZqgDAqdB82fNS+NgOj+R1AokWRWOWFJP0njXs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6272.eurprd04.prod.outlook.com (2603:10a6:803:fe::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Thu, 5 Aug
 2021 11:36:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 11:36:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next] net: dsa: tag_sja1105: optionally build as module when switch driver is module if PTP is enabled
Date:   Thu,  5 Aug 2021 14:36:12 +0300
Message-Id: <20210805113612.2174148-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0006.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM9P250CA0006.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 11:36:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dbcb04b-ec4a-4427-1a86-08d958054876
X-MS-TrafficTypeDiagnostic: VI1PR04MB6272:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6272FDD083AE12FEC04BB3F1E0F29@VI1PR04MB6272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jprodZntvokeOseR2EDk49tEq4yXkqf53p5UGdTN3ILwyccUFa7cJIl/4m0DNCHwVYtrlcryq26RfgzqfPwv+nmv+QL6tQYJyO7214aVLD8Hwd7DFJvpg/9yoqh13zVGyKfL+UUY/B8uOBRMy8ZHnb0BDc0+fgmllZrUyTNklwufDdCjsCCQrzbE3NIiq0SBBFJl3RbaEYIwC3niykH5HTawrBdWFn80aYsZL62hECl2MiR6EppI3brtno5HjwgIwqIBWHK+ybsmoDumeDfY+IrFAIVF2abFcdQNY6WkaSUBJz9iYiMe+z6L0OFobAk/wcq4p9a+Hf49J+wn9QVshfAV0jpdzR2gIPOf0i8KQPkPYnmdv9Eviy5DxQL7aVJjznPXGdiHlAU9kZIPF1t6ADfFwmT8uvOLc87xbnWbJrg38IxI+IZcWkt1MWWL6H4NeMuqCFMF5bdBMfAGPpMJuCvTK0eGLxTn/OLxgIWF62f+pVVkXjKEMePmIMnQLkL0qKnTt+Q6uscGCm3rMpuzfKKv9Oi+M2+BzUGJe3xcPhpgUz/6rwpDRfQE5PrVvadxy1tUfBwpW9yOaFTsShmYujK77M2hKA/GF/TOlsCZcxAHWF6zl/ZLmN5iqaLNTH7ZpFRIoaU4tvEcmbBNGnb9hFEHPO8hcihjuHxpqCU6HvYTuvGWhfxnzoCAAA+xr7Dr81nB3BRSfYiT+eGIGRjLkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(6666004)(186003)(110136005)(52116002)(498600001)(4326008)(8676002)(54906003)(6506007)(44832011)(26005)(66946007)(8936002)(6486002)(956004)(2906002)(66556008)(2616005)(1076003)(5660300002)(6512007)(66476007)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wXmR4cajl4vwb7BMj8wZ+pajStGHFRkNXhyTKK7NPwwX8JftBQESmcA3uc59?=
 =?us-ascii?Q?H580fpBZYqflNmqkD/kRThrc8YrIOquj44+ZzDz66pRWsqIyxelatFhkmXM/?=
 =?us-ascii?Q?PRvU1ZaC1pVEUXBt8ip43GYJmlDuN7AzQM9eH4j0fiaS/UGOTQLYCKRpeSgr?=
 =?us-ascii?Q?St+SiB7XpLev8LtTjEGDVZ0WN+avHuLqerFSWSGRdRRYmq7y3OF2U7H2QxPh?=
 =?us-ascii?Q?suUpKMv/RA6qarTQXQ7Vf3VYiO6zT0sglRyCWg43NhRxfsCb+C1mfiUIelWa?=
 =?us-ascii?Q?tZUO8ToDdUWPXy0IDubi4mmUDXB4fdgX1sDx4Em9p31GkyyGxLAdKt22R1yS?=
 =?us-ascii?Q?Mi0kROHP2SPIxrH37uV9go+NqP6JXgdGofB2Xz0vFytfT8HRzgBYutCZOzb6?=
 =?us-ascii?Q?J9hhNXIEQXmkDitiB1ZljagmxjTnGE2+KWrudQVBBYqERM092mQ4pAzSeCzQ?=
 =?us-ascii?Q?OteT3nRsOloj4jtZvC4yCcwgRH5PzxRKuEdFmVxkdvvIjwyFPowJ//PTTyPB?=
 =?us-ascii?Q?ZYzgsjgoaeeGrcb+yrCyXQKsLaydNwQgNfExBf+9BY4helZVOmUfASrGPTqN?=
 =?us-ascii?Q?mOPekJ+kA+jzzO4AGZaqN97t6WUEwEpqvzy7W3GvxuhK4XOe1l1lqvTjH6N/?=
 =?us-ascii?Q?wSAXN+8x/P+3p7szpGwgsmor824upWQBbM0PIhvZOOLcIzu3qNn6wQ/wXohD?=
 =?us-ascii?Q?u9tRkBNCVYW0NtbvFUnXQD4cWa8jObJrrhs4JXLQOEXtcKKpjUVjMbHdSl1S?=
 =?us-ascii?Q?RqXpumrNGpHdG2D+80nVBEXE30qw/+tYNKD3s4LpZ/DImaHZxYuwdZPUljhO?=
 =?us-ascii?Q?sUuyl3UwQxb/6KHETEaSRI02QAz+qpRB15rfJ46D0IKBcXbQY4Lmwk2rmCqW?=
 =?us-ascii?Q?uhKHQJ4x9u+tK/W2VUlUpveHsKdy/wPO9GOpu+E3IMAKpp2XMFcfgBAroTr/?=
 =?us-ascii?Q?oGto239RjR4GzuoZMi6PmLKC8BeaSBiHB3c36YusdNZtAB7c64X3lSuK2yW9?=
 =?us-ascii?Q?G813Qs7BOB9l33tTa3TWGsst/SAMRGnJzePwdGKQQLplhDXIrKPQr7MiH7Y+?=
 =?us-ascii?Q?7TO9eeD+zTl17klERVdvsa20oJBMK2yiqfU7sFxlcsFyx7VleSqY3ho2hcrU?=
 =?us-ascii?Q?6Nxcq/E6WErT/6m+M/VyTY7t6iIfMzfXCP69lrrWIWPLey5hQ96dTtRho6h8?=
 =?us-ascii?Q?zrkc6bYAVDND6JK09p1jbTb+HsVzfa5WEGlpY/qjihwvGSDimBTB+abx5ETh?=
 =?us-ascii?Q?9Vc+oey3lKfVJfO/yRKmKth9AtwUWdaDawHPeatCWcH4CoXLDq/tjssVvY3H?=
 =?us-ascii?Q?qluPwYN4iZogvjtGDtcHAaFy?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbcb04b-ec4a-4427-1a86-08d958054876
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 11:36:36.5225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejvGIbj5733t1P8VDqvr0+DITsc4JyNYMQVC3nmseqjU65afqVFHBDyhkktKQAJVjY4Pu5Fa4OnmLidlxk8H3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6272
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX timestamps are sent by SJA1110 as Ethernet packets containing
metadata, so they are received by the tagging driver but must be
processed by the switch driver - the one that is stateful since it
keeps the TX timestamp queue.

This means that there is an sja1110_process_meta_tstamp() symbol
exported by the switch driver which is called by the tagging driver.

There is a shim definition for that function when the switch driver is
not compiled, which does nothing, but that shim is not effective when
the tagging protocol driver is built-in and the switch driver is a
module, because built-in code cannot call symbols exported by modules.

So add an optional dependency between the tagger and the switch driver,
if PTP support is enabled in the switch driver. If PTP is not enabled,
sja1110_process_meta_tstamp() will translate into the shim "do nothing
with these meta frames" function.

Fixes: 566b18c8b752 ("net: dsa: sja1105: implement TX timestamping for SJA1110")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index bca1b5d66df2..970906eb5b2c 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -138,6 +138,7 @@ config NET_DSA_TAG_LAN9303
 
 config NET_DSA_TAG_SJA1105
 	tristate "Tag driver for NXP SJA1105 switches"
+	depends on (NET_DSA_SJA1105 && NET_DSA_SJA1105_PTP) || !NET_DSA_SJA1105 || !NET_DSA_SJA1105_PTP
 	select PACKING
 	help
 	  Say Y or M if you want to enable support for tagging frames with the
-- 
2.25.1

