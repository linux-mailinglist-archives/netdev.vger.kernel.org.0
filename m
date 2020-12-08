Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BFA2D2A51
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgLHMJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:09:11 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:43431
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727650AbgLHMJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:09:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chxovaF+ugMHA6Am7DPyPG/CmgUfFmh7GdLlGnzJqh4e+yGN8WH8HdxxglsEgnDvjBT2CaCTtTDYLK3B/CnPLycOfYewNSE29XWN39GeUZFa1+FaFd7pifathMzAQrhDVj1YXsyzDT3iuotvwJYXn9kfqojLFsQlGOgsrCaAynpyip5zy4l5pbF8DYAdoNMxplhN9F7YD8R1nLc92yKg7wuOrTZ8nVXutaTjM1YaAtt56HjMdvPPo6MDoIgMWBcn+7QfoCkSugvvzXys4g9zyQfMdztJOcCYTRnpfO75GXt0Hf6Tfzw5oFJhKKoWZ63zw/oC3sUr5DkMH8P4lwueNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcid0x2L3u6unvz8I2uit80m4WeIsbcQOsEC5LoE6f4=;
 b=EHQLU6ZGHJcnkWI6MvrjhhCy8Q07CwTtp0Y8XfAbbiSpUPKSOJl1om1jBt/ZWlmocL4kSWpGAtWKzObHWDv11KyjBPvot5jUMsK42pv+ykQv2F3+4gABafF6pQ895Dsc0o8N4MN7DcJ6xCLVdboW5RB3AA2/z25HWaC9eGyXjY29Bnu1H0fAZyF1q7rn9wiLEJoVM/gH2uRa6GLNXsqrgIUspL6Pzd4hUHHe0uCvO8XnBf75UCBsuBF6jDe9XzZbxxekMarZheRihyBImup3e0OOzvxAPnIKbEy2g+e/9o572Fx46IeDRZAGdanBB9N9uylTTUDK2mhQQEuV4U6qjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcid0x2L3u6unvz8I2uit80m4WeIsbcQOsEC5LoE6f4=;
 b=NDAZpIbRjG7bOctNKy0i0F6Vv1z3RkxeWVAw6ADAFxN8ImPM1RT/4n9HjyeBKqQ05YSKBjCeJYXtteBCt+fTE552viVVI+iqi4ICTdJj7YbPqn3lM9clkUTpvXBsz9lYxq58Njs+W/mbomnAqBMT+8YgDF8uWqb2TF56rBK9ybI=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:21 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [RFC PATCH net-next 00/16] LAG offload for Ocelot DSA switches
Date:   Tue,  8 Dec 2020 14:07:46 +0200
Message-Id: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ff1e354-1904-4339-414e-08d89b71f391
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5693717933417C0C92A90761E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /S2z9Dn/PexBCtdmoOJWVZCdbhE33TbZG8jsAqOdyyzVZsWJrE0BSa+WXkNvDkzy0wcWz+xTmZPQmQZFaWZk8kWm1Oxid/wMK735TrZF2K4Jv8CvZogh5v0wFn9/4JyJ5DGGL4qTmVvCcyh4KZYQ2Eb/zLQX9U539qFmsJ0l4Q/3OnsdrH6FoDdPAtU5gPxItc1FIDGOyNS7ALII9gqhbuG0zk98hoCOzCZST2DMYGdFUAsoYmI54wB5jRm6g2duVy3/S05SIY0UrTHLbKieijCue8Oe5YIscgS9tcvXWWRKjOKT3xdg+evegikjsS+uceZzlXteoO/Tt3MkugSdZUJkYHnGPWAYL5zSiUbJGlH7Z4q6hmgq9AdnHrjoFaO4Qfo8geOlb3H8s0Soim50hbxWHBN+ycgQwVAMXcCVDoQY+OpQyy5AvddMPMLfQySQg0ObALiTkr9cqiORQR/+CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(966005)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4OSkUwfhCfr7X+u7IdK55MRlFMSDGsMBGcLbHouUV3dlVvXJ8FAIM4u0Xya4?=
 =?us-ascii?Q?ykcC7u+EJZDJ0+yKsZyEx4fhpvxUTmyeQGFFM62MKOZBktLtY4jtjpUUgfxV?=
 =?us-ascii?Q?TsiP5hUrpnmdfDrcHEUklHy2xbSi5Rbdii7JSCXEZAnbJ3Y5PtBVjyPXU4HA?=
 =?us-ascii?Q?p8otta86inOXXImQExnXoxhYq09CIdM1X5oGMcNU6VAfRcKLaaUPn8PBhvO7?=
 =?us-ascii?Q?Yn8hvvxa08fFfdiPPH9gqWYePX97hsq9DZCgF62ltWAgIvaPy2ETeedcbpdv?=
 =?us-ascii?Q?uJRyIa1S9hvy5Vk4Kvg1VtMR+3qFG15JrfN2T47MidoYKYLYLCZ2N7zZqmWc?=
 =?us-ascii?Q?hgBYrfHrfnZD0x8Xi5MP3W1T18wyzvXZLOyyRKPJ7prk7b+glfnLUfTGMNh4?=
 =?us-ascii?Q?mJZPgJblcI1dZ9foFS3I1cXhnhIo9xvz7rbmfIIi9HQaI28XhipeNoxU1iPG?=
 =?us-ascii?Q?Ho7VJP+yhXADASZ6WZ17XHWT9GTU8rmmX7f+dGYezIa+CnWUCzspovloEkiR?=
 =?us-ascii?Q?BdUvfBw1nFsdn1ZjURe/b5LiOQP0fWN6u3m/szQuKsYoJV9Ghh95b3mlqlf1?=
 =?us-ascii?Q?9EA+azOulUnaIg25Y/MTS7rU0OauyNKELbv591eZhfS8sQ39IjxvNkOhq4tU?=
 =?us-ascii?Q?H24CnrCMQEnV0a3K0FSshklbYGHB4ekk3l7g5q8vjXfe6H/WM1hqScIoVZhG?=
 =?us-ascii?Q?dnl2kXLJYjQ99aAcAjYb0wr49rXKXNaPVbmYq9tPw/+jFnkT/q7o/gI+a6SW?=
 =?us-ascii?Q?6rKfr1yrnUeM1//jrL9ov+5TpuNKryoP1C85o1/iPzywLHdUAqrA7pHZtd+y?=
 =?us-ascii?Q?EsnTj2IKFF5/wiprJzHO3MRKXOLHTow8C8GRkTWum9Yx8dWe+yv1v3Po1G8w?=
 =?us-ascii?Q?75LZ1MDHkDk3xmwmZljcZt7WWyFetKfrjryJPYFrMbIcI9vX1TeSbhMYirRO?=
 =?us-ascii?Q?fSwXjhPzweGtPRfgl6d0t+zoFd7WoPzjIxw6L0hv7nrAjsQaHYf7U1c9jA0d?=
 =?us-ascii?Q?ns0F?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff1e354-1904-4339-414e-08d89b71f391
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:19.5316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UcAzOkJO3cO4lLfP0fouoFmQm2OyhbTld/aaCGHXN1FSGv4uJxw9NOg0hO/FSeoU3OzZUt8K75qQDTlQHEnBhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series comes as a continuation of the discussion started with
Tobias Waldekranz in his patch series to offload bonding/team from DSA:
https://patchwork.kernel.org/project/netdevbpf/patch/20201202091356.24075-3-tobias@waldekranz.com/

On one hand, it shows the rework that needs to be done to ocelot such
that a pure switchdev and a DSA driver could share the same implementation.

On the other hand, it tries to identify what data structures does DSA
really need to keep and pass along to drivers, and which structures are
best left for the drivers to deal privately with them.

Testing has been done in the following topology:

         +----------------------------------+
         | Board 1         br0              |
         |             +---------+          |
         |            /           \         |
         |            |           |         |
         |            |         bond0       |
         |            |        +-----+      |
         |            |       /       \     |
         |  eno0     swp0    swp1    swp2   |
         +---|--------|-------|-------|-----+
             |        |       |       |
             +--------+       |       |
               Cable          |       |
                         Cable|       |Cable
               Cable          |       |
             +--------+       |       |
             |        |       |       |
         +---|--------|-------|-------|-----+
         |  eno0     swp0    swp1    swp2   |
         |            |       \       /     |
         |            |        +-----+      |
         |            |         bond0       |
         |            |           |         |
         |            \           /         |
         |             +---------+          |
         | Board 2         br0              |
         +----------------------------------+

The same script can be run on both Board 1 and Board 2 to set this up:

#!/bin/bash

ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
ip link set swp0 master br0

Then traffic can be tested between eno0 of Board 1 and eno0 of Board 2.

Vladimir Oltean (16):
  net: mscc: ocelot: offload bridge port flags to device
  net: mscc: ocelot: allow offloading of bridge on top of LAG
  net: mscc: ocelot: rename ocelot_netdevice_port_event to
    ocelot_netdevice_changeupper
  net: mscc: ocelot: use a switch-case statement in
    ocelot_netdevice_event
  net: mscc: ocelot: don't refuse bonding interfaces we can't offload
  net: mscc: ocelot: use ipv6 in the aggregation code
  net: mscc: ocelot: set up the bonding mask in a way that avoids a
    net_device
  net: mscc: ocelot: avoid unneeded "lp" variable in LAG join
  net: mscc: ocelot: use "lag" variable name in
    ocelot_bridge_stp_state_set
  net: mscc: ocelot: reapply bridge forwarding mask on bonding
    join/leave
  net: mscc: ocelot: set up logical port IDs centrally
  net: mscc: ocelot: drop the use of the "lags" array
  net: mscc: ocelot: rename aggr_count to num_ports_in_lag
  net: mscc: ocelot: rebalance LAGs on link up/down events
  net: dsa: felix: propagate the LAG offload ops towards the ocelot lib
  net: dsa: ocelot: tell DSA that we can offload link aggregation

 drivers/net/dsa/ocelot/felix.c         |  28 +++
 drivers/net/ethernet/mscc/ocelot.c     | 276 +++++++++++++++----------
 drivers/net/ethernet/mscc/ocelot.h     |   7 +-
 drivers/net/ethernet/mscc/ocelot_net.c | 139 ++++++++-----
 include/soc/mscc/ocelot.h              |  13 +-
 5 files changed, 298 insertions(+), 165 deletions(-)

-- 
2.25.1

