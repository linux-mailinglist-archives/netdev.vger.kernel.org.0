Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023FD2E0370
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgLVAeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 19:34:03 -0500
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:31106
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725780AbgLVAeC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 19:34:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxMJcUY1KOUgLiKZbk3S+FmTPIXwzZT18AwQeqsD77SDiig1dPctCBn3pvf3S3RRyd1GAyIVgu9cOn5XzwRXFY6doK0c56FbCJImcSBmUioCfprwDio4hY+Nq8jI60ZjB+B2WrNJD410YMhF1XuM+asvLhbks4UdNmRthuaTA+7JfBs8Qzqx2a6qqKoX1nF91aXAWU1qjf99zg3W04R/7GMDhgLb6bkiOrA8DQLgQ80nj1dMKt9d2Ec0sPqawY4VyDnPa1K/7iYxm8CMclLDks/z5EJbUzSeQCaQlblTW3eFfF6BKgVbJzk2+iXacsyzZKFqtVbV2DwFGWka8TjpQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s/JgmR0aKQmfhpxxmMFQ+tWtM5YG951GyBccmwrLO4=;
 b=a3ad2KS2ypyxdyxvN4pnO2R37RVAOHqYxGVmaoW5RKpn0diNlamGgRVQDY2ArX7vAsDtFZIYHOU81JjDdGI15Irn5JPU+DdrNRNZPOhdP2ECxSUlYTFXiKA9mEUbMJ+jau76B8MCNIntmveCv9XXltGx1CvjMK/7IslO20bYyGdeDTWFy0KBvFPWVgxiP01+8egI86znRknfOKyPvqLxmPyc/CZSBWSApZBZ2Oj63Hp4ODwp2WaVlXFz/IRq65MOWngEYmBKFFmweIhsQL5tCV/Iv5SWPdA6FAlftzCS1Q/AOrbHP9IR2QuhG5aBeRtxDtfAOJr9jaDGJjIicvY0Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s/JgmR0aKQmfhpxxmMFQ+tWtM5YG951GyBccmwrLO4=;
 b=sCYOyqv30VXmch3aIiHC8q+Q8VUTj7CNGFPbgl27S9UOcHQ9E3g+hzpnLf6oEE33xD/1RZTlKvJzN/Kx25/oG4S1fStB5G5Rm7GT/WCo9ffpOTtxck7fsXrYcciK0QMPQ/FANP+ZSmUs94N9KnRjhJGOaTD56nxM3P+VkQ7rWL8=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Tue, 22 Dec
 2020 00:33:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 00:33:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 0/2] tag_8021q for Ocelot switches
Date:   Tue, 22 Dec 2020 02:31:10 +0200
Message-Id: <20201222003112.1990768-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM3PR07CA0076.eurprd07.prod.outlook.com
 (2603:10a6:207:4::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM3PR07CA0076.eurprd07.prod.outlook.com (2603:10a6:207:4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.24 via Frontend Transport; Tue, 22 Dec 2020 00:33:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 91ef29da-7384-433e-6711-08d8a6112a15
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3712:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37125E99EDFA78EFD75AE505E0DF0@VI1PR0402MB3712.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7DWJzDf7GbuzzVjkn7AzH4MQl+eS6F50YS0PsfDwriTVwjOmTnKRNL+heEfg6uiJyVkErlARTDvY2CRJ1jLBSYRDvaBt2ACINk9FOSTQtt4XaGV3jduLmQ3e4xp6nW9q13fRtAO5/QQbVqHD61A5YOYrGFjIjrll/bpLBr7Ogt++IZpd3xXSoP9fhumtVDhO83s63YiPuW8TDSHEOAJSqMxCQHJFfykx+/uKJkhDgjp6MALwAhbDkS7rjnTVgALdgaHMzaeN9FAtgsME2DMqDGQuxvdzhsTuAtaQv43+OLphWiWaMooljzrKKWJUcKSh4/sNswN7L/u0VDipqKbmL69ZyaCxAOQ7NJFG743SbDWwRqUx276+VIgVucVSF+Dg7yUOwpKCXRAMkjxFwrEZK1MhTFy4k/HwC6AZIW1GtHw7mcSLLpgxd7wRxz2qTdlfkr/L+pNhzJfdVwUvpm/gJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(69590400010)(5660300002)(36756003)(86362001)(2616005)(4326008)(956004)(44832011)(8936002)(8676002)(66476007)(66946007)(6506007)(478600001)(6512007)(66556008)(186003)(6486002)(54906003)(110136005)(26005)(16526019)(316002)(52116002)(83380400001)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xYiuLIirVD6HixPNo8zMWdAQDPVYyZnK3eQ4We85mGMmuaRQqhyTHj8DSkJL?=
 =?us-ascii?Q?pBxWSOPr5O+uMpz/+gYw55LuWfbIJ7GbYprn9dyh2o5bDi9dmgXTimx4QiC1?=
 =?us-ascii?Q?JB5ypeB+GrccrUe6jHjjqauTCzkNs4z0Ej+izcKbPwL2nUuVbsQy8XlWUVGB?=
 =?us-ascii?Q?8ZkM9Vb1ViG9iA/wGJzBOxt1HWHbog44anO8x7DIpEONFLAbCjAfR1DK9TNk?=
 =?us-ascii?Q?s4b82rgCqFFFvJhvGRMDaj003uacmAaFxiS+Fvbj1ZxpZG7QT45B9w0mSiF5?=
 =?us-ascii?Q?xAsabjhc9o6Ckpdbeg+5kSAP7lbyT4idjflhz7Ux7+bxq149oYZeYytK03nc?=
 =?us-ascii?Q?Oeb8E6MAv1OGLC4Ps1Dt7XgJ/faw4kt2yUVn0kTjOqjJTOw7L7FUAP9uHSnU?=
 =?us-ascii?Q?uaTT7feda/gy0NO6RBbUDYxf3twaZuZLoXcW1V7SGcvBhy3UZ+5aLcH/UjA2?=
 =?us-ascii?Q?O1UjNC/6susqEZWnR6pgkNocYGqkKby00bHmSf0kUy4WmFR4lbWj3uxYhAMS?=
 =?us-ascii?Q?GTa4OmIZYi7WIF/bJlMbGoVSOp/I/asZNBTXfXFqV1VsxV07ffNRUvD2qytp?=
 =?us-ascii?Q?Ls06Zu8x1bmbpYI/sZ+rtSdkzF7moFjK1OKm7+++JirIZADbPtJVAkNx/B0V?=
 =?us-ascii?Q?UYYZB6vMN6DVImWUBdYAxnjRZ/S18xYO3epcnJIUjXJQP9m/d0yU0LH5tFHS?=
 =?us-ascii?Q?5ZkTk9j6e04uRDWkAnyVa4FFvY0zw/fkCHgzdn5o3UE3RwMHiUnA7Sc+5GtD?=
 =?us-ascii?Q?fyqK/KKuhTsD3anu0aJZMD+DtnSO5XlYq+KUiza+vpolZXVYls0iEiVqCTVE?=
 =?us-ascii?Q?u+u+sjaqNUif57qLIbICZVWO4xd/4PGRlQNnwLTTSanhaEERxKFjdKznDXQh?=
 =?us-ascii?Q?5nAlamacj53k4ThLy0aPV8SDWww8GUvUbn+3Ful7Bq4EXFiCzBG95cuUXNWV?=
 =?us-ascii?Q?IJTXb2OxMIqArT+BdRprhctBrLZLNxDGeLgAqdcShSZ+docQ1suCK1YwRiHm?=
 =?us-ascii?Q?IBdH?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 00:33:12.3056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ef29da-7384-433e-6711-08d8a6112a15
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JRoDMOMBx7RV7dilorkoub6zY3tgvSQ6apM1GZMZkxLp3MDNzx61wv8AkgmjnCO7lcTOa5MfAi9cP95pdVeag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Felix switch inside LS1028A has an issue. It has a 2.5G CPU port,
and the external ports, in the majority of use cases, run at 1G. This
means that, when the CPU injects traffic into the switch, it is very
easy to run into congestion. This is not to say that it is impossible to
enter congestion even with all ports running at the same speed, just
that the default configuration is already very prone to that by design.

Normally, the way to deal with that is using Ethernet flow control
(PAUSE frames).

However, this functionality is not working today with the ENETC - Felix
switch pair. The hardware issue is undergoing documentation right now as
an erratum within NXP, but several customers have been requesting a
reasonable workaround for it.

In truth, the LS1028A has 2 internal port pairs. The lack of flow control
is an issue only when NPI mode (Node Processor Interface, aka the mode
where the "CPU port module", which carries DSA-style tagged packets, is
connected to a regular Ethernet port) is used, and NPI mode is supported
by Felix on a single port.

In past BSPs, we have had setups where both internal port pairs were
enabled. We were advertising the following setup:

"data port"     "control port"
  (2.5G)            (1G)

   eno2             eno3
    ^                ^
    |                |
    | regular        | DSA-tagged
    | frames         | frames
    |                |
    v                v
   swp4             swp5

This works but is highly unpractical, due to NXP shifting the task of
designing a functional system (choosing which port to use, depending on
type of traffic required) up to the end user. The swpN interfaces would
have to be bridged with swp4, in order for the eno2 "data port" to have
access to the outside network. And the swpN interfaces would still be
capable of IP networking. So running a DHCP client would give us two IP
interfaces from the same subnet, one assigned to eno2, and the other to
swpN (0, 1, 2, 3).

Also, the dual port design doesn't scale. When attaching another DSA
switch to a Felix port, the end result is that the "data port" cannot
carry any meaningful data to the external world, since it lacks the DSA
tags required to traverse the sja1105 switches below. All that traffic
needs to go through the "control port".

So in newer BSPs there was a desire to simplify that setup, and only
have one internal port pair:

   eno2            eno3
    ^
    |
    | DSA-tagged    x disabled
    | frames
    |
    v
   swp4            swp5

However, this setup only exacerbates the issue of not having flow
control on the NPI port, since that is the only port now. Also, there
are use cases that still require the "data port", such as IEEE 802.1CB
(TSN stream identification doesn't work over an NPI port), source
MAC address learning over NPI, etc.

Again, there is a desire to keep the simplicity of the single internal
port setup, while regaining the benefits of having a dedicated data port
as well. And this series attempts to deliver just that.

So the NPI functionality is disabled conditionally. Its purpose was:
- To ensure individually addressable ports on TX. This can be replaced
  by using some designated VLAN tags which are pushed by the DSA tagger
  code, then removed by the switch (so they are invisible to the outside
  world and to the user).
- To ensure source port identification on RX. Again, this can be
  replaced by using some designated VLAN tags to encapsulate all RX
  traffic (each VLAN uniquely identifies a source port). The DSA tagger
  determines which port it was based on the VLAN number, then removes
  that header.
- To deliver PTP timestamps. This cannot be obtained through VLAN
  headers, so we need to take a step back and see how else we can do
  that. The Microchip Ocelot-1 (VSC7514 MIPS) driver performs manual
  injection/extraction from the CPU port module using register-based
  MMIO, and not over Ethernet. We will need to do the same from DSA.
  This is going to be a huge can of worms due to more than just one
  reason. I left this part out for now.

I determined that a Kconfig option would be a sufficiently good
configuration interface for selecting between the existing NPI-based
tagged and the tag_8021q software-defined tagger. However, this is one
of the things that is up for debate today.

Vladimir Oltean (2):
  net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or
    TX VLAN
  net: dsa: felix: add new VLAN-based tagger

 MAINTAINERS                              |   1 +
 drivers/net/dsa/ocelot/Kconfig           |   4 +-
 drivers/net/dsa/ocelot/Makefile          |   5 +
 drivers/net/dsa/ocelot/felix.c           | 108 +++++++++++++--
 drivers/net/dsa/ocelot/felix.h           |   1 +
 drivers/net/dsa/ocelot/felix_tag_8021q.c | 164 +++++++++++++++++++++++
 drivers/net/dsa/ocelot/felix_tag_8021q.h |  20 +++
 drivers/net/ethernet/mscc/ocelot.c       |  18 ++-
 include/linux/dsa/8021q.h                |  14 ++
 include/soc/mscc/ocelot.h                |   1 +
 net/dsa/Kconfig                          |  34 +++++
 net/dsa/Makefile                         |   3 +-
 net/dsa/tag_8021q.c                      |  15 ++-
 net/dsa/tag_ocelot_8021q.c               |  61 +++++++++
 14 files changed, 424 insertions(+), 25 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_tag_8021q.c
 create mode 100644 drivers/net/dsa/ocelot/felix_tag_8021q.h
 create mode 100644 net/dsa/tag_ocelot_8021q.c

-- 
2.25.1

