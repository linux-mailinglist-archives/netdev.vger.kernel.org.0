Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FFF3CE822
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352674AbhGSQh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:37:57 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:32129
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354840AbhGSQf1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:35:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ys+Ptsn+3/DWdr3+8AE2chXxhkVUfM/Evf3Zv7dpPbsLSG9QuOUtOIa5Bsnn00a6VKy+bh0tOocq+7DuprmD9+7rHCKxSYzcfcHWK4OOalvIcAAQbxvsPV7ycp+MGCaZplaEAgOn2y2rfESTMHZZBcJhiDHOVIpDAJ+c9+1boRGMUPSWoOFbHn8nLm2EB81+5FiYujhU5dltJUwoLdj3m1jXc195d6qGsYJYpOVA3Uqgd5WDrCewApgP+gxO7pYkNNbc1tEieyTWN2ZnjyEQabGhaPmn0juaAhtyW5oQfeDhgsyGy9maDyFjaB3iC84XSY10Zm3KO0FII/e/76my+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc3QZtxeUARTDQB2olp3m4rZOv0kTsnglxal6iQ9OEM=;
 b=FrVQvg7lBlCuSM0qaVom9tLQUPDYx6vjBpBYUho2qpEoGpduetNhK7VXmooCiEZFH4sn/aYHT6TWLfyUWvG/ugAfSRMSQo5GMW8+dS3+VoobicjDMC8LVdgCpnho5siaWjJaBUZnftEp4c+P6uCNFnNmiAkQhurhOa1hez/Pfx3aXU61hqZTswUKC0EqRC/qcUEtNh7QNpkiqCs+x9JPahg4Ij47CIXyjikqtIh+8E5LmkXUCPxESXQldnz4ax5xBEcH8GJkOny2IOrQ3lGo3Tf5Qj05Mn7OUFDR5Y4ah7NSXmcBZXi1JfeG8CMbeNh6X8BojaIzUdGBTWRY9Fkaog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc3QZtxeUARTDQB2olp3m4rZOv0kTsnglxal6iQ9OEM=;
 b=rxVM2EQ4CXwJJWhgUJVY9Mk1MuYTy0NIC96rvlGjQOCn5FJpPbpG1rtuojEF1zI1eYzduxR4eHMglm9QvbxYAyIXiZ7wXuGp6+Vq1UH7NdeJK4m/cfiFobcfSaJwfJe8U10VrFP3HWFBoyUfp9Jql4t5uEaGSPFffUbrUgXgIqE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 00/11] Proper cross-chip support for tag_8021q
Date:   Mon, 19 Jul 2021 20:14:41 +0300
Message-Id: <20210719171452.463775-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c644ce6f-ab68-4577-0b9b-08d94ad8e32f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407BA7A430E6C2072773947E0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MOwnfx6048aVEZNqDSF/nTyi0f9Y2q3GYlhF9Q4oLkDFPT/Gv1XTZMQuKCUyDNpshBtMxyIJ55Rq8CV5uX6Wq6cafvMuUJD9QgYH7sgSvDdk6xGGNYyBN7vT9aCKQZv35RCtAr1zW1e9bV9A1cKYEMk5DcrTycsJa2XNf6XMJjGoX28kTfBcZjnX7OJN1oPswei+jBHmUwwENvy4HaDVGAEGDnthd8jqLta5M9jC2aAZAbcJaaH8EwxleFqvwH+HpgxO643/QzWQrCh+mHAPjInSnHS6+jRgZrghju5PD7Obgk3XDiioBuN2IsIoeflDHZqZhhgyamg4wRiTo07fDznb3VVSeJRKygPJ6wj/eBBx9U6gKkHGS4x8P4rYSUsFqSlRiipmin+7y2sfV/jM2QeeSDR8NILYjUuO/k7pmPdguIrYL3Vuq74mhEARO+nKjeB/0ZbOe005dI4QHAu3prZlQoQQ4ta1Q3ZwsibY1cBhVerYXAaHEWGa/e0iDXASqw17dpAZIYDZoF7sBD1xAD5fqIBmmk0LDM/ORaqfPQxCNPbEjRfPfxaWz0RgoDUFWBa886qwZ9eeYo1j/AeApVgoiM8fFC+fp7u6Euw6gffAgq8CHnhi/GkI2K3eQiNFcHtJGy+o8bteqNScD1qsH3xffVyqEs8OSYSg8WaK/4I4mI8t+BuzAGR7va8WtHfotqPGFjI7JERlB6yUWJ9EA72DgucUivTyLZkkdXPa7zdqJNaCNarYe8avBKRsoN4060ObpvQSyts3iSv0xEIXFMVdF00NwGT72YmFP1GXELuYrFUU/UuDu4uCkO6YQbxV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vS7miCmioNciz+wrBtDT8NqD2cRI9ha7DGOV2cBlvM7za0oRBl1gUO2rh/Ep?=
 =?us-ascii?Q?N607kPxA6y6M1iBZE6+BC2Cxy81vJqb9hYfGk8gBqhFhOX9uSQzyF/ss5gf7?=
 =?us-ascii?Q?W80bDLEn6bejRGmksaSJpUr30THnjGOiemiH/GB1IPoyqOzeacLrqD8Jz8E2?=
 =?us-ascii?Q?HQ/YZmcysb6njUAOlw3Kpl1Sp79mvo36Uxi2GZgHi+3I8pDgfEt670yybQch?=
 =?us-ascii?Q?h2RLOQ20tARnRBrBQS1xLc7RjyJERJaTEm2vzq2CqG02wGTLyrWOvtrf8pYc?=
 =?us-ascii?Q?ucLoWMCeUp1vW7XEK5UwPnMopw29lJbUoBFE8uYlf0y07dhM0wCKQ2VIPghQ?=
 =?us-ascii?Q?IuOqwKyM0GhdJeInztDDTmiu7KmzpdkNd+UYIsiHn+VJzTD6EZZDpdMyoubw?=
 =?us-ascii?Q?KCdJfpEldd5YYKpjRtJt2rTZC/QgZJEUiF40/dUzKPP2f9sc6JW/qSwlb67l?=
 =?us-ascii?Q?GnOfU8VIqmeKA96uDyE7gOa5n2q6TXWMZTh21oBg5VPyG49dhya27zNIpzLl?=
 =?us-ascii?Q?FMjAS4ozLea2akIVFRDcuIMJYzj2xe8l4M1M8wetLAYf+e8XvKyxijkR757s?=
 =?us-ascii?Q?n++/kvpdconn3GtYbTxe6EUhqOdMZ5PDDT3vMv0cpDXUwUouTczKo4/smX+H?=
 =?us-ascii?Q?uQqbJAcW3hk7c00GbPnB0i7sdFmC5sx12S3unbAeZEmT4aLAyLpqCsuGr96p?=
 =?us-ascii?Q?o8l3dua4J3SESmguu5lAXQfPbyOTq34c+3EXkSXNSo40T6H/GjtVM4pIun1o?=
 =?us-ascii?Q?qAHAKK2dtkdNsi5/KRxyARAaC1aQfHV6yYR3sXWixy8GhjGkL7OfCVvhxsKG?=
 =?us-ascii?Q?Jc/pcDciJz/j2MsqGVGbKwV+tf4dsJ4nVE3Mhqb7vYafjVqdbujhk1oTj6ZH?=
 =?us-ascii?Q?HTlJ+muzzbFsSGNQHPS2j0+L204gWC872Qdx33mabC1VSosNm6yDHigG0Ecf?=
 =?us-ascii?Q?/8kBMTUkR70rsCdlNVcWZX4biMbjzIyTWu4vnGO3Sjbe6Ixuv82HxMfDf5v3?=
 =?us-ascii?Q?r7rLzXGQD5IAuhCee+bkNiUMBMm59Mjgdl1xzE7/QcBELZJds3pxGay/+WpH?=
 =?us-ascii?Q?5mFZbBsP/T+iGsMnbUkPoVIZcaMk4zu4i4DVtIvNA+0ZdM/V2X7T9gpSyRtn?=
 =?us-ascii?Q?Lo8CPS1G0SRDtnQGFEM2qDJD4QWTcbRn4hISuemT3aTZka1Xe4EJD/9r7EdK?=
 =?us-ascii?Q?MKNqTfNWvQ3Fee+IaYBTbsWc9SN8TNsb702HDAaaN5Y36LN0jy/TNOsUZrtI?=
 =?us-ascii?Q?nyod4DH2jhs2E9O0l7JBC2jIF2t8XZbSq7nK6MiZaD2RqG69kLCuwyhICH8n?=
 =?us-ascii?Q?GMHkWb2MJbGbWVfQYA2vShPC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c644ce6f-ab68-4577-0b9b-08d94ad8e32f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:03.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xwTlSeWbzEv3NADF0b98bMfpZVVewgQCJCJzUE8AG5X2fn2lLlzcfHZ8UrRFqx+2QUy1XJTOufe6YJ2FVL6jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cross-chip bridging support for tag_8021q/sja1105 introduced here:
https://patchwork.ozlabs.org/project/netdev/cover/20200510163743.18032-1-olteanv@gmail.com/

took some shortcuts and is not reusable in other topologies except for
the one it was written for: disjoint DSA trees. A diagram of this
topology can be seen here:
https://patchwork.ozlabs.org/project/netdev/patch/20200510163743.18032-3-olteanv@gmail.com/

However there are sja1105 switches on other boards using other
topologies, most notably:

- Daisy chained:
                                             |
    sw0p0     sw0p1     sw0p2     sw0p3     sw0p4
 [  user ] [  user ] [  user ] [  dsa  ] [  cpu  ]
                                   |
                                   +---------+
                                             |
    sw1p0     sw1p1     sw1p2     sw1p3     sw1p4
 [  user ] [  user ] [  user ] [  dsa  ] [  dsa  ]
                                   |
                                   +---------+
                                             |
    sw2p0     sw2p1     sw2p2     sw2p3     sw2p4
 [  user ] [  user ] [  user ] [  user ] [  dsa  ]

- "H" topology:

         eth0                                                     eth1
          |                                                        |
       CPU port                                                CPU port
          |                        DSA link                        |
 sw0p0  sw0p1  sw0p2  sw0p3  sw0p4 -------- sw1p4  sw1p3  sw1p2  sw1p1  sw1p0
   |             |      |                            |      |             |
 user          user   user                         user   user          user
 port          port   port                         port   port          port

In fact, the current code for tag_8021q cross-chip links works for
neither of these 2 classes of topologies.

The main reasons are:
(a) The sja1105 driver does not treat DSA links. In the "disjoint trees"
    topology, the routing port towards any other switch is also the CPU
    port, and that was already configured so it already worked.
    This series does not deal with enabling DSA links in the sja1105
    driver, that is a fairly trivial task that will be dealt with
    separately.
(b) The tag_8021q code for cross-chip links assumes that any 2 switches
    between cross-chip forwarding needs to be enabled (i.e. which have
    user ports part of the same bridge) are at most 1 hop away from each
    other. This was true for the "disjoint trees" case because
    once a packet reached the CPU port, VLAN-unaware bridging was done
    by the DSA master towards the other switches based on destination
    MAC address, so the tag_8021q header was not interpreted in any way.
    However, in a daisy chain setup with 3 switches, all of them will
    interpret the tag_8021q header, and all tag_8021q VLANs need to be
    installed in all switches.

When looking at the O(n^2) real complexity of the problem, it is clear
that the current code had absolutely no chance of working in the general
case. So this patch series brings a redesign of tag_8021q, in light of
its new requirements. Anything with O(n^2) complexity (where n is the
number of switches in a DSA tree) is an obvious candidate for the DSA
cross-chip notifier support.

One by one, the patches are:
- The sja1105 driver is extremely entangled with tag_8021q, to be exact,
  with that driver's best_effort_vlan_filtering support. We drop this
  operating mode, which means that sja1105 temporarily loses network
  stack termination for VLAN-aware bridges. That operating mode raced
  itself to its own grave anyway due to some hardware limitations in
  combination with PTP reported by NXP customers. I can't say a lot
  more, but network stack termination for VLAN-aware bridges in sja1105
  will be reimplemented soon with a much, much better solution.
- What remains of tag_8021q in sja1105 is support for standalone ports
  mode and for VLAN-unaware bridging. We refactor the API surface of
  tag_8021q to a single pair of dsa_tag_8021q_{register,unregister}
  functions and we clean up everything else related to tag_8021q from
  sja1105 and felix.
- Then we move tag_8021q into the DSA core. I thought about this a lot,
  and there is really no other way to add a DSA_NOTIFIER_TAG_8021Q_VLAN_ADD
  cross-chip notifier if DSA has no way to know if the individual
  switches use tag_8021q or not. So it needs to be part of the core to
  use notifiers.
- Then we modify tag_8021q to update dynamically on bridge_{join,leave}
  events, instead of what we have today which is simply installing the
  VLANs on all ports of a switch and leaving port isolation up to
  somebody else. This change is necessary because port isolation over a
  DSA link cannot be done in any other way except based on VLAN
  membership, as opposed to bridging within the same switch which had 2
  choices (at least on sja1105).
- Finally we add 2 new cross-chip notifiers for adding and deleting a
  tag_8021q VLAN, which is properly refcounted similar to the bridge FDB
  and MDB code, and complete cleanup is done on teardown (note that this
  is unlike regular bridge VLANs, where we currently cannot do
  refcounting because the user can run "bridge vlan add dev swp0 vid 100"
  a gazillion times, and "bridge vlan del dev swp0 vid 100" just once,
  and for some reason expect that the VLAN will be deleted. But I digress).
  With this opportunity we remove a lot of hard-to-digest code and
  replace it with much more idiomatic DSA-style code.

This series was regression-tested on:
- Single-switch boards with SJA1105T
- Disjoint-tree boards with SJA1105S and Felix (using ocelot-8021q)
- H topology boards using SJA1110A

Vladimir Oltean (11):
  net: dsa: sja1105: delete the best_effort_vlan_filtering mode
  net: dsa: tag_8021q: use "err" consistently instead of "rc"
  net: dsa: tag_8021q: use symbolic error names
  net: dsa: tag_8021q: remove struct packet_type declaration
  net: dsa: tag_8021q: create dsa_tag_8021q_{register,unregister}
    helpers
  net: dsa: build tag_8021q.c as part of DSA core
  net: dsa: let the core manage the tag_8021q context
  net: dsa: make tag_8021q operations part of the core
  net: dsa: tag_8021q: absorb dsa_8021q_setup into
    dsa_tag_8021q_{,un}register
  net: dsa: tag_8021q: manage RX VLANs dynamically at bridge join/leave
    time
  net: dsa: tag_8021q: add proper cross-chip notifier support

 drivers/net/dsa/ocelot/felix.c            |  34 +-
 drivers/net/dsa/ocelot/felix.h            |   1 -
 drivers/net/dsa/sja1105/sja1105.h         |  14 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c | 114 +---
 drivers/net/dsa/sja1105/sja1105_main.c    | 668 ++--------------------
 drivers/net/dsa/sja1105/sja1105_vl.c      |  14 +-
 include/linux/dsa/8021q.h                 |  34 +-
 include/linux/dsa/sja1105.h               |   1 -
 include/net/dsa.h                         |  10 +
 net/dsa/Kconfig                           |  12 -
 net/dsa/Makefile                          |   3 +-
 net/dsa/dsa_priv.h                        |  22 +
 net/dsa/port.c                            |  28 +
 net/dsa/switch.c                          |  30 +-
 net/dsa/tag_8021q.c                       | 569 +++++++++---------
 net/dsa/tag_ocelot_8021q.c                |   4 +-
 net/dsa/tag_sja1105.c                     |  28 +-
 17 files changed, 455 insertions(+), 1131 deletions(-)

-- 
2.25.1

