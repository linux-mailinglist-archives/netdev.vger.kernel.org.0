Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563074322B9
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 17:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhJRPYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 11:24:16 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:18150
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231955AbhJRPYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 11:24:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pi4C0QRwIW40JwZVyI47sOHs3Ql5g1LUOEV0FpNFuX0Fct7JljhVo8xRGw2GtX3sbCTP737yruk8o43+A/iyUoNUBp52RXNgu8NKkHnTzA/9HE3K9WtW8HXhLRMVBtZzFh9xtaf/9fMX0STnpiAj5f99fOKaAm0kpKyO9LGYCje6TwEv/UY1UWo8S/RvL4oSQhjr9fUScUV45RXN189lwn6+aJUyREUByNJqNIyUyF5mBTJJ3QK1E4dU2kzbL8OTKgUIM9WB35dVhhZifRpxUrNOHRKhgejbdMnbENT/DYYBHfEsJgtXr/VkpItFbwueQBFFNzOvhMcSdHj9o+Uolw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16cB+wLucdoFx4Nv2qieccTPQK7LElahKL4rJG/8mR8=;
 b=n+7MLkY1HuxlpimiV4PGfE5rEJ7PNmAvxFKGYFQ6IV//SBrKE0D9eS4pd2ORs3Y0kCkG6cO2O9UJr3bUSfHNvEPpv2jvqWjJ+1FxGfaak9UR1W0DDSiL3XUTwRKgNUQvxnWxn8+aJCAmlwKENxjILElDsDtTUyMwh/AdwuJC3EjbYQG9WeWsxUPS1ZJZoey3STM3iDec+j05ZB30FQdtIZ2pDxynCqPd3iXCvWQXsTgnaovxREhjMcJY08WJLbHHy03z8yYE1JFp0wXrhqfjDioTGiaL8N2hE8bYAo58wJrqCYFpNjtAJhAj1EtZytk5wx/77c1XZ8im3OzGWtuldQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16cB+wLucdoFx4Nv2qieccTPQK7LElahKL4rJG/8mR8=;
 b=AuWnEkqbVFKl9Dm6cE6LfH6ZW5rjUezCHVHFRiPpEE2eJhVTJ/tzccA2038mJsgwGbCn0APmqywd6hvWpUWjHCUUeVZpVEtV1bST+2ZhoGCSM/KBoHJHQ20qGxTJQDqpiPn7nzBR0sid1MVjcFhrRs+Q7Rvdq0sPANVBA+Q0H1U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2688.eurprd04.prod.outlook.com (2603:10a6:800:59::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 15:21:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 15:21:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 0/7] Remove the "dsa_to_port in a loop" antipattern
Date:   Mon, 18 Oct 2021 18:21:29 +0300
Message-Id: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 15:21:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f924d35c-d440-45e5-6ef0-08d9924b03c9
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2688:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2688AD50F5411F762548D8E6E0BC9@VI1PR0401MB2688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DY8KIwm/LQIBF0LtREoNiFB1Wi5HZEchQvqxqKJmMJt5GF+OBemNnYZE9ZGU0D2yw0Cn3z3PNO0aRSNdrbUc1GERUCOblNfePFn5imqNSG9nx6s0h8/BGajt6xl9rmQrMsFvkAGZneUGBi5BeGxabFTUgQfzGh3hEHqTNUtJ+5Pbs3+DwW7kwNuUCgdwcjMivxR5J/JFEuwrTqIOYsjnsWtd+7NjBEap3v0QJPbByAkr9Tq9zItA51ZhD7epUA8xMJTfh9koXxQU5MDBtNt/WR7NHXTj9I1QvMsqk97oTH7ZrZQ3jQIo3vJNAYmg9XqMKDVE4pK+rDo1hyFrSYt0vtTAxhByvYJueY9hX9P0LoI5e1Ryvj0dE00H91x2rsmhQ3/FfHeQyrYytpSTd+i9wZoFiGpX12foaaRnxAWh9sjm7hG3OH8gaDfxnWjZ5rfF3muCXif05pDz7+93sZ/W4SlleVXbvcSKlMSizESFaPNe86EUDDa4d1Zk2GA6FzZx6zemdQkJ42Opi3U8vPCKe5gk9uNYPZZaEvcHL8aW6IVmDJjDSOgtG2QnBn6eZRENnmLrnxMlto2Y01s/vJvb5nYLOfnsKDB5WSoMpC13mLY9moCk4EiAPN9X1Ouh18EhlHvOJYlvbDts3ABhwMxtD/Py8ZqYxJbDeYpc6o/Z+suJy0yWV1KZHpVzqtHeKjV58LGqbc/cPciSY8Q9XHNvSP4DWMTFtU5Qt/V6xN0XkTcoJ7s7AnHReBPQnmjI/Xpp6+kn+uQcmh89uNf/T4bqcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(110136005)(956004)(2616005)(316002)(83380400001)(1076003)(54906003)(66476007)(8676002)(66946007)(66556008)(6512007)(508600001)(6506007)(6666004)(36756003)(2906002)(44832011)(966005)(6486002)(86362001)(38100700002)(52116002)(38350700002)(186003)(26005)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tgaxaAwwbCLo18iZsY1byzQCdDRm+EZm2m8dJTp2mZoALyiqkPIhJfl6Ai3j?=
 =?us-ascii?Q?a5hqCgKI4h/2HrmE+zBiAgJd0u9IuqZtejQ4XcB/0xPhvdoMDp6ojyactW8p?=
 =?us-ascii?Q?JWX7kqOfbysegDGl4ahU2bC3IfP30DJR5brYTnZHM2+Cycqb+RWifBeojyWQ?=
 =?us-ascii?Q?SXTl/rvbK27famYJYVLrCydDH/p5DQIXK3VAPtcP9Tgw7IDrzz0/z+XjLCr1?=
 =?us-ascii?Q?PzylYV07wSXNA0T2/i8cn7s7ZACb3tr02JiiktCCCHlKlvMg9EYjfEBdE0Vz?=
 =?us-ascii?Q?RdMjW93+LF9KkIvE9Lj+xU5b3/IogXnPHRVG9tLGgLyCv8nkKSpLsud5Xviq?=
 =?us-ascii?Q?2IvXW+EVdeVZ3+DWghWimqnoIGz8T+vYvLPpJd9A2zOt88WNbhiuP8n7J1a2?=
 =?us-ascii?Q?Dp2/Fxc8gHm3PtqeBSVhgm1m8sOOFxP2VmAZOcymwOXiYR+iNDVx6TSSZqvh?=
 =?us-ascii?Q?hhPEMn7wrejdKlsjsM2r6SC2Mu8NIVfFsl84JCEukrIB/oF/FAylnFZ+kumB?=
 =?us-ascii?Q?FGcwFrC4LuxSqMfn6QllBqMeQpuWFvJiMeYysQKicHGSuE3agv0rr1y+1n5Z?=
 =?us-ascii?Q?H0P4FxU3rRuwjX/1zeKz2LhVa34U0eWTjx4fdg7478YOjbYBLgD765x/Tm+Q?=
 =?us-ascii?Q?Cxec7GR7gTQX9NkjDQhB93Meqeh/2eXGGEsWwes/1kKmg+1BAkooCkSJLVa9?=
 =?us-ascii?Q?F32C4LYvQV3sCc243iPyLf1Rt0iiiiDrUgzCZF5L/H8MLLHnlyBcdiNuoG7w?=
 =?us-ascii?Q?gC90YcULAdyrNIGPN9NYGDU5aQnU9dpBNImo9+hYJjkByw/UghXyzSdDPHSb?=
 =?us-ascii?Q?LjA9beUxIMg8wRUjhB31KzrvkKBKgrTHicLW/u//IhkuqupThBDDmPW2r24l?=
 =?us-ascii?Q?PbnbzL3FPAIEJQ3EYz1cDwUG+ru1I5RWFcuMHbW4RkSJ/KqKFlMGqwpRsx5S?=
 =?us-ascii?Q?aGDj/PobLbZS/zniDcPcZ1m26oofhgKg0m0VZyxP9WT486QmHoL1IZvexide?=
 =?us-ascii?Q?HeMZNwUtIcIAjTecDKJRapCNFNVn+UWL+c2jPXZ4SVWQeSdUHBgqKIggSFj/?=
 =?us-ascii?Q?6c3tsrlKXtvJbsx5c8UvD/0f2dlcbFMuhwtx+sGC06r5iiNQn0CzlcXDU0R/?=
 =?us-ascii?Q?7LhxT/BtmulbrBWiHFCe+2urzSV3G32OQVXsRsF9EW6gRlLyJemNHHNs3sj0?=
 =?us-ascii?Q?fCTJznu2hEhk3d/RT8shv0kvPMT1hoRVdrsxEX0aOqaU4cfwEhUH2lh32J7T?=
 =?us-ascii?Q?k7M/bHbtRr/StgiYtaxhPhdGRNTaP1IVF7sboTMXv85mf7V1yFyJimco6dVP?=
 =?us-ascii?Q?1txHLZ6TzRlc5rQtegE2oLYj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f924d35c-d440-45e5-6ef0-08d9924b03c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 15:21:53.5060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RljQlhQlMMfltVExsBdcc05g3+b0NhjRyUvpiAzXqGzor/RV7tOV2t+MgpNq8C8wEtUBq58kmv8kI/8M6aB9jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1->v2: more patches
v2->v3: less patches

As opposed to previous series, I would now like to first refactor the
DSA core, since that sees fewer patches than drivers, and make the
helpers available. Since the refactoring is fairly noisy, I don't want
to force it on driver maintainers right away, patches can be submitted
independently.

The original cover letter is below:

The DSA core and drivers currently iterate too much through the port
list of a switch. For example, this snippet:

	for (port = 0; port < ds->num_ports; port++) {
		if (!dsa_is_cpu_port(ds, port))
			continue;

		ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
	}

iterates through ds->num_ports once, and then calls dsa_is_cpu_port to
filter out the other types of ports. But that function has a hidden call
to dsa_to_port() in it, which contains:

	list_for_each_entry(dp, &dst->ports, list)
		if (dp->ds == ds && dp->index == p)
			return dp;

where the only thing we wanted to know in the first place was whether
dp->type == DSA_PORT_TYPE_CPU or not.

So it seems that the problem is that we are not iterating with the right
variable. We have an "int port" but in fact need a "struct dsa_port *dp".

This has started being an issue since this patch series:
https://patchwork.ozlabs.org/project/netdev/cover/20191020031941.3805884-1-vivien.didelot@gmail.com/

The currently proposed set of changes iterates like this:

	dsa_switch_for_each_cpu_port(cpu_dp, ds)
		err = ds->ops->change_tag_protocol(ds, cpu_dp->index,
						   tag_ops->proto);

which iterates directly over ds->dst->ports, which is a list of struct
dsa_port *dp. This makes it much easier and more efficient to check
dp->type.

As a nice side effect, with the proposed driver API, driver writers are
now encouraged to use more efficient patterns, and not only due to less
iterations through the port list. For example, something like this:

	for (port = 0; port < ds->num_ports; port++)
		do_something();

probably does not need to do_something() for the ports that are disabled
in the device tree. But adding extra code for that would look like this:

	for (port = 0; port < ds->num_ports; port++) {
		if (!dsa_is_unused_port(ds, port))
			continue;

		do_something();
	}

and therefore, it is understandable that some driver writers may decide
to not bother. This patch series introduces a "dsa_switch_for_each_available_port"
macro which comes at no extra cost in terms of lines of code / number of
braces to the driver writer, but it has the "dsa_is_unused_port" check
embedded within it.

Vladimir Oltean (7):
  net: dsa: introduce helpers for iterating through ports using dp
  net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
  net: dsa: do not open-code dsa_switch_for_each_port
  net: dsa: remove gratuitous use of dsa_is_{user,dsa,cpu}_port
  net: dsa: convert cross-chip notifiers to iterate using dp
  net: dsa: tag_sja1105: do not open-code dsa_switch_for_each_port
  net: dsa: tag_8021q: make dsa_8021q_{rx,tx}_vid take dp as argument

 drivers/net/dsa/sja1105/sja1105_vl.c |   3 +-
 include/linux/dsa/8021q.h            |   5 +-
 include/net/dsa.h                    |  35 +++++-
 net/dsa/dsa.c                        |  22 ++--
 net/dsa/dsa2.c                       |  57 ++++-----
 net/dsa/port.c                       |  21 ++--
 net/dsa/slave.c                      |   2 +-
 net/dsa/switch.c                     | 169 ++++++++++++++-------------
 net/dsa/tag_8021q.c                  | 113 +++++++++---------
 net/dsa/tag_ocelot_8021q.c           |   2 +-
 net/dsa/tag_sja1105.c                |   9 +-
 11 files changed, 224 insertions(+), 214 deletions(-)

-- 
2.25.1

