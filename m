Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDA63F52D1
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhHWVYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:24:06 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:59364
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232772AbhHWVYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 17:24:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOdQP6zIZfq813BSQMipos2SZ7teTvdzOnFmR1ki1IWhmPASMGd6zcnMfOBVWzxWNdGepF93hGakxWTMBbz5krDKEOmwovTsfWV/XVPv0FPGP8oLv/zat7hqkiDZl/nSpLOYXJ1YhI8HywBVA4KpzSGxwEFAWyWe44Bw6GW31cgxn9AM3aSKgc7+E+m38ySOCTgtXIDdyey5FX9RMdLBPySLppkNyYpQq2sDoD5/7jgVTOt+FEsWz55RE5XrSNS6Qi0jUNwtUhwqhPR+3X1U1YYfDIN0kXE0NyQpUTb85uwCV7hycqLBS2t3qYh/g+DR+IxPwwTU4izNdhx/s/Sc2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYdt9pmp/u/bDgDP2eX5GO1Jkj9eqi5VP2KlLxBJCsc=;
 b=hRB2nqz/sRwu5pI5RRQZXYA4PHc25AcQNTXzaoaiIckFrVLzVdZWXn6gRrF3RWA0N/cuzOxeQ4uD6l6yriDZu2X84Wo+fiDvCg07IJ5HP3Yd540aEL66TFcSUOSRmasajyo+VDvYGsS+MSUOiJXS54HRjrQU3wgieFmrRo/pCWttTYnQYJ/L7eiQH2Ooc9OkoiOzNtj5YGK8Oan5UImGYblW/N8dvVrKb3Jp+a3kCMoNL+aob6pEFAvNrqdlfGWbcSIgzKJaaawBMVN30iUDhiJyWKW/WD6+FcwN8nPuW7tSdSMOYQhp9puSVY/k36zYWJzFbeRGfCrQnWePzZhHog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYdt9pmp/u/bDgDP2eX5GO1Jkj9eqi5VP2KlLxBJCsc=;
 b=U/9s3xsKwn2WYYMVydiOcI0/BykU8QsC6V+iYklmmI4t3iNA8sgAAwuMmP29bHPksomOB4V1h8//PzF30ksy1rKjBD2y8xlkMdWx23SOKVYLZLDRyNz0iXM+UMfMCAx1L4mgxmz0GsvIlWEHElqQrGKIavafUW95vLQe8zb3I/A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4221.eurprd04.prod.outlook.com (2603:10a6:803:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 21:23:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Mon, 23 Aug 2021
 21:23:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 0/4] Plug holes in DSA's software bridging support
Date:   Tue, 24 Aug 2021 00:22:54 +0300
Message-Id: <20210823212258.3190699-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR05CA0150.eurprd05.prod.outlook.com
 (2603:10a6:207:3::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM3PR05CA0150.eurprd05.prod.outlook.com (2603:10a6:207:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Mon, 23 Aug 2021 21:23:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 439f5d47-3517-4beb-c77a-08d9667c369e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4221:
X-Microsoft-Antispam-PRVS: <VI1PR04MB42214D848A48EBC4C2A76A65E0C49@VI1PR04MB4221.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGpj/y2mnnWO+v47wBqVVx/yRlVbgOmA26cktsGnTysM8uxeKCKtUGpDMUl9yGM4aK24tyrQ53pVO6VySFLzz6lp96e2nKTXE5ZXH9QIdepCiiJACzoxiw964QiwIJ4bwbAB1M2TuOqQNsJEcQWJpKVNGb6JbCVN77ehuUH5NHmmg0McEkqYiYJjpEcBKel2Og5zsPakLljEH5ZdfTwD6jJiepzMN2iip7ugZl3Q8js7Macjqwua5i7tQhGjNuW303Ubkx7Yp7BtymTAyWksBumVWXqqxZ3Ny+0tN+rPrChwyYv/OzqA7qm8BOMunRWfLVYWOVDkPqkOiMj99T6OwxwbC73pg4DMwELj04g6Kc+K3HBjotxV+ybZTXtejzWSV4WnlZ/MlBcp1UqCep5blrNhbT7/mMs5SRjslZBFvXEwPpSnRvmgAe/J1jVA4C5hcSnt3cz3vqPXkCiZdVRAbHXcqq1HrJnm648PerDGjzdjmnhR2JONvIhq8ZWmY4zfhd2d9E6zCwexLIYXprFVcoAl5Frnx0XDUuylDCyxeH4Cdc/pg7vWmqzAoi7xBElZNpQ8tGgmgG1Qk6lj3kVzTo4nE6827HomCt48SRHciBHchzxji/KwZMgifYEW47f2y6/tcw0WMYcrIHiyk8KTz8/SIziafS4Ov3BkabMjjILlr1BQCuFkmFy4ocg0CY09wqTi3zQRt0vURT6aVW+z4+rpUCNX8sbv/NmzV50m5zdU01SP9OBQIcE8+lTNFPob5eZrVZ3ZAZIlAUJkpmCBzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(366004)(396003)(83380400001)(66476007)(66556008)(6506007)(26005)(4326008)(8676002)(66946007)(8936002)(6512007)(186003)(6486002)(86362001)(6666004)(38350700002)(6916009)(38100700002)(52116002)(5660300002)(316002)(966005)(44832011)(36756003)(54906003)(1076003)(2616005)(2906002)(478600001)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDNrQlhNeDFFQXg0dWZEOFg1VTRJVVhCeWV4eG82Y2w4dEJoenZPZ3JDZnZq?=
 =?utf-8?B?dDFDNVFmeURpNHhVM0lMSzQ1azlQQXZvYUowWXdEM285MGUxQ0lBa1dDYmpS?=
 =?utf-8?B?T25zREhaSXRSQXdhUk9aZWx2aFZDQk5tZk5GcDFLK29QQVhKU1REN3dsY0hz?=
 =?utf-8?B?VzRuMDNYSXZrejA5Ry84WE5yWVBiemhYQ0lrZlVLdVVHRXBqT2J6aGgvMy9N?=
 =?utf-8?B?UEc3bXZDZ0x4M2V1VVpyNVJPb0JEK0g2VGdHbzd1U1QzMERUeitYZUdlTGVN?=
 =?utf-8?B?UEVkbWo4QTNmdmVqTmtHamgvam9MV0UzbE1BSFFXTGhneTJZL2lYamY4eXha?=
 =?utf-8?B?YjJIV3BSTWlCV2llVFo0TEJUSDVObWhXK2prYnB3Sy90MzFBUHZwU3NBZWpz?=
 =?utf-8?B?UmpQdXVxNUtBa0R4M3dZQjcwbTVLNnF6Q1RWQzdZdUNnUlJjWlQ2Qlp5Uk9p?=
 =?utf-8?B?cU9YaHlmT3ZTak9OQ0M2YVhrSlpDOFhvYUl0aXJpT2xsVSsvbm51bE9qNlQw?=
 =?utf-8?B?U0ZQdE1RVC95L0s2LzJINVdBV2cwR3cwUnJxNGxHRjRVOHhSZi9QQzJZanJx?=
 =?utf-8?B?K3pFSmgzZXkzRmJxOGdqVkZJc1htT2laZU04TGxzdEFGVWI4MEZ2S0xObDdG?=
 =?utf-8?B?ZTR2NmU0ekVZOG5DL2U4em8vUVI1UEtvSFErdXF0NXpWOXRhcDJuWVMyMUxZ?=
 =?utf-8?B?T040M1hKZnk5Y2FDNjYzaTRRMUZoYkdRcWxOV0JUM1NwUkRDUi9QQ2FkcjlW?=
 =?utf-8?B?TzVXck5NVmd3a212WjluWU1hZTRjQS9Ebml1d2hvZ1BId1QxRHZGZXhaVXZF?=
 =?utf-8?B?QWFwcVhQcG0wdkQ2dXpBM2I1SGVHaWlxS1ZFN2JCYWppdmhxenlRWXcvMm1w?=
 =?utf-8?B?VGd2NU5aNGhhK3I2eGo5YnFwRVhYRHZjLzZ0ZTc4NWxsL2VRVklwZUFiUHpw?=
 =?utf-8?B?YTBNdzdSclhqMDVrendxNENhZ0pBNWxmMHgrZFoxcjBFbkM2VzR2NkwvWStv?=
 =?utf-8?B?elNnMFBPVkV2QXBOSlhyMHdvUWt4RFB1YUtzY1RLTWpycDRFV2lSZWl6UGwv?=
 =?utf-8?B?WXI1TWpGQzNxZ3N6cEhWenlUUk4yMnBsWUI1dWV4alFsc2R3WEQvN3FKMldh?=
 =?utf-8?B?Tk9ic3p5WDBwR2UrbktUWWRqRUErSTk1Ny9hV3BzRUdOQU9hVUNwWlZFOHF1?=
 =?utf-8?B?K3dSV0xUdURMMGVnallESVVaRlRuSkY4OG5DdXNRdHhFamZ4YXhodlBZd3hP?=
 =?utf-8?B?Z00yOHJWQ1BJU1hIU2RoYzYyWE9UekdTeWU5dm1lcXN6NHVqZG9zMkljbWdZ?=
 =?utf-8?B?cXdhV3IrTnhKblNCY2pJaGY5WWRmS2o0TnhBd1krVXFZNnZSaFpzZWR2c0RZ?=
 =?utf-8?B?emd5QmZlRHcvNXFMU0I3KzJGMmhjR08wZVN1WGFnNVptUW8zZTdPbk00K0J4?=
 =?utf-8?B?TEw0Z0RQRDU2bnBNc1NPRnorZkxZWStGYWFCUG5hOUVHSW0yVDM5bUZxY0hK?=
 =?utf-8?B?T0xBYVU2Y2ZDK2J2VjAySzllbXIzdTVQanl4REIvbWVtSmNwaWYzS3U3bmVB?=
 =?utf-8?B?ZC9DUjVlcFhGRWt3SnM5SWhrN0pJRlFnSm03dFhIMWJSVWdFa3R6VHdqcUhP?=
 =?utf-8?B?alZnaFdHZFM1Tm5sd0VuYlY4aXdkRGJzK3FNSXFPT2d6Nko4WGNjdk0vanpD?=
 =?utf-8?B?MzBPN2Z5aWN6NE9kS1k4cWpWajlRRzQ4K0pOc2Noc1RBa2MzbnNIWEdQajRF?=
 =?utf-8?Q?/S2uROX/rwGHy3/rS9ZtqC+wgMZFSTtQ5y8ZsfR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439f5d47-3517-4beb-c77a-08d9667c369e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 21:23:13.0747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHz/2ayvUiniUQaNTCXnnp1bnKfFeouIsc0r0w0rNrWVO3IWL7IYABzZ7+wTho8CuSj1sZz6gU8HdibNAGDnlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:
- Make sure that leaving an unoffloaded bridge works well too
- Remove a set but unused variable
- Tweak a commit message

This series addresses some oddities reported by Alvin while he was
working on the new rtl8365mb driver (a driver which does not implement
bridge offloading for now, and relies on software bridging).

First is that DSA behaves, in the lack of a .port_bridge_join method, as
if the operation succeeds, and does not kick off its internal procedures
for software bridging (the same procedures that were written for indirect
software bridging, meaning bridging with an unoffloaded software LAG).

Second is that even after being patched to treat ports with software
bridging as standalone, we still don't get rid of bridge VLANs, even
though we have code to ignore them, that code manages to get bypassed.
This is in fact a recurring issue which was brought up by Tobias
Waldekranz a while ago, but the solution never made it to the git tree.

After debugging with Florian the last time:
https://patchwork.kernel.org/project/netdevbpf/patch/20210320225928.2481575-3-olteanv@gmail.com/
I became very concerned about sending these patches to stable kernels.
They are relatively large reworks, and they are only tested properly on
net-next.

A few commands on my test vehicle which has ds->vlan_filtering_is_global
set to true:

| Nothing is committed to hardware when we add VLAN 100 on a standalone
| port
$ ip link add link sw0p2 name sw0p2.100 type vlan id 100
| When a neighbor port joins a VLAN-aware bridge, VLAN filtering gets
| enabled globally on the switch. This replays the VLAN 100 from
| sw0p2.100 and also installs VLAN 1 from the bridge on sw0p0.
$ ip link add br0 type bridge vlan_filtering 1 && ip link set sw0p0 master br0
[   97.948087] sja1105 spi2.0: Reset switch and programmed static config. Reason: VLAN filtering
[   97.957989] sja1105 spi2.0: sja1105_bridge_vlan_add: port 2 vlan 100
[   97.964442] sja1105 spi2.0: sja1105_bridge_vlan_add: port 4 vlan 100
[   97.971202] device sw0p0 entered promiscuous mode
[   97.976129] sja1105 spi2.0: sja1105_bridge_vlan_add: port 0 vlan 1
[   97.982640] sja1105 spi2.0: sja1105_bridge_vlan_add: port 4 vlan 1
| We can see that sw0p2, the standalone port, is now filtering because
| of the bridge
$ ethtool -k sw0p2 | grep vlan
rx-vlan-filter: on [fixed]
| When we make the bridge VLAN-unaware, the 8021q upper sw0p2.100 is
| uncomitted from hardware. The VLANs managed by the bridge still remain
| committed to hardware, because they are managed by the bridge.
$ ip link set br0 type bridge vlan_filtering 0
[  134.218869] sja1105 spi2.0: Reset switch and programmed static config. Reason: VLAN filtering
[  134.228913] sja1105 spi2.0: sja1105_bridge_vlan_del: port 2 vlan 100
| And now the standalone port is not filtering anymore.
ethtool -k sw0p2 | grep vlan
rx-vlan-filter: off [fixed]

The same test with .port_bridge_join and .port_bridge_leave commented
out from this driver:

| Not a flinch
$ ip link add link sw0p2 name sw0p2.100 type vlan id 100
$ ip link add br0 type bridge vlan_filtering 1 && ip link set sw0p0 master br0
Warning: dsa_core: Offloading not supported.
$ ethtool -k sw0p2 | grep vlan
rx-vlan-filter: off [fixed]
$ ip link set br0 type bridge vlan_filtering 0
$ ethtool -k sw0p2 | grep vlan
rx-vlan-filter: off [fixed]

Vladimir Oltean (4):
  net: dsa: don't call switchdev_bridge_port_unoffload for unoffloaded
    bridge ports
  net: dsa: properly fall back to software bridging
  net: dsa: don't advertise 'rx-vlan-filter' when not needed
  net: dsa: let drivers state that they need VLAN filtering while
    standalone

 drivers/net/dsa/hirschmann/hellcreek.c |  1 +
 include/net/dsa.h                      |  3 +
 net/dsa/dsa_priv.h                     |  2 +
 net/dsa/port.c                         | 46 ++++++++++++++-
 net/dsa/slave.c                        | 79 +++++++++++++++++++++++++-
 net/dsa/switch.c                       | 27 ++++++---
 6 files changed, 147 insertions(+), 11 deletions(-)

-- 
2.25.1

