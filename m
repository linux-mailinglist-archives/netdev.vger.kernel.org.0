Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F473C5EFF
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhGLPY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:24:58 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:27617
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232203AbhGLPY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:24:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFSHWwtnR4lBfEAxMdv2kme+Zilt3YvQWvRK46JiVx6RUvT9UHx2dP8nS/KTE8wR6PwzZfIVBFQ+MPrnkDGcACrJCneJ+8yPloGqzCBJyCKR6t4JdKbHxIRbukCPUFuxhqoqajXz+EURmF5bgizb3Lok4maZ79LnCgGTyF1ZxNFMMqnJRTSfN09EeCzjrIkGZzLxtkR7v7OufDjeD8rI65ZElWBXzsdCX6fF5GRX8pjlcdV4U5uRJR9feDUDnHopRlm6FlQDkYkH1u44ljTdj+K5MHdZn36ZYQ0QycRjRaNHr4FG992PMILMknZT5p+1u3e5fW9ywuLZGlhpe2OWrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0AU/r/fvq4/WXHk0odMl95TUEOkigCnFX93soJ79NcM=;
 b=M/nm4BVGA/FD0r29wV+98N2jJ7l6lq84UStanexZv9i4Z19bi/CtiCxisqHyNZtmOdlTDjklIQ8hfaGnzVIEAiLca8SDivPPt5XE2bk07jfimSE1eFSj8jI0tW7fAExeCkWbJGTx4kztZ2PDc7MrYclfBauWQ+7vn584bmaDYCoSPtpmRPNBQEd/iWX3uWbDblk2/bJDK4HquBYUh2X4abl3fxNtSNEZ2mwfYGg7otxE4cs+y/3zCIM1WU34UM45ZxltItrO20WuwCVWTc3N/TbhwfgfziUQB6ZgSlEp1THUFEFCwZV3c6/ISNcqZ4PhwFYsixpCYMC26c4Drb2+XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0AU/r/fvq4/WXHk0odMl95TUEOkigCnFX93soJ79NcM=;
 b=HYemXxZsHGDNSAfO9BnN9xQ9nhPXbUOoR51QkbwM/MgfHlmdqC/lx974XLi4MYzSmcxVCuUMOLJpn0zGJkxgqzRMPjdUA5I1vkPmcgP3AX56uTyJhS7Dzp4ufRSGo5qrjg4XiXjPem2nhI5XAKRUScHhdp81xS5YE7P1hudmpdQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 15:22:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 00/24] Allow forwarding for the software bridge data path to be offloaded to capable devices
Date:   Mon, 12 Jul 2021 18:21:18 +0300
Message-Id: <20210712152142.800651-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e8223ad-a078-4d33-e57a-08d94548cf00
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35498BD1FAB09AB775C781E5E0159@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kW+fnYzEhXR/d9aYS1A3z2TLb7WT2a4vaXSbREV0sVB0JxcTTbnIdUIvyoAA8g8iD20faBGwxHBPqA/z87uYAm8PVTtbDUmNibdVBgtz9u6pZebz1fx5ZaC4oI37YOfsw6iijL2dOEUin9cvVygg4fLB39kwUs7O8Oy+MXLNrQFCnP5xJ96r8kZNVTAGYltndT6lPzEmdUvEYNdjnPeKbMrDro6AAWROFLgTIEv2JIkB4nzYQ8fTyR2oEzSy6fEn24BHVS7ryU5kkxOvNsrMhcXM0o99mau03FmBCjqTliN3WvHzqJ8a8UrqXiMiMxmTjlEMr1KqBFvHuafYC9SMhS2o6EIWtuDRU0VB5wIh7iHlYVqd8APlMAP8hB9wWlF9ra74ZDOofs5CnHyc5oXkBzGak0lWaKW0yNtSmOgW2pJICv0qaS+35pLba4gIDOzTf5pCqYabOIXoPboAVvTl0S5ETo77EjinV9CuRqKXNHF8etfjEOnLXKgz2FmuXAUbIF/h0mLXPPtbiZqltr6JHRcTJ/cSMkluJuF1CctEOz4IVLuMGFztx5GRc2CJBOrm7mJA69A6tgBYF7jjGO1Wk/AhJqISahQGhhB+AGwHYg6P77kXC/KMOD6kz2FPcL5MvLGQ8/44T8HoRK0aqayGx2/04MQS3Wa/70s2M1SWZn/dG5O8CMXpFAxtbDGSZBOqATvyqHeeHWrz0U34p1sGAsdZK+4FQIoER5h31oIky1reoJ/RCDuZFwc+kSBIC1d1qruq1PoT0bTpdT+NenQagDAPTG8Q4gOK3urj5EPPLk0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(136003)(366004)(6506007)(6666004)(478600001)(26005)(186003)(83380400001)(66476007)(66556008)(2616005)(2906002)(7416002)(6512007)(316002)(956004)(44832011)(54906003)(110136005)(4326008)(8676002)(966005)(66574015)(66946007)(8936002)(30864003)(86362001)(38100700002)(52116002)(1076003)(5660300002)(6486002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IABKKBsJd430YF/oGQ64BzrfHNTH0ejMNRlL8KouDiiszdrvAl86NT2sp7Z+?=
 =?us-ascii?Q?I/au2WecYiF474PXlWhKjRH3MaflOnLLEOHroX0PNk1hKToD7QmSYOcs8+BM?=
 =?us-ascii?Q?IaUh3ROPWNklJ1+5PuXr/b8jVmB2OLqzFI4MSlBnvj9OBdsmYe3XqMlw1zZs?=
 =?us-ascii?Q?dlYKCV2/sMwjufqQlCFmkOWFnQX296bBBjEIi0AjT3qpQvHLq5UpWJwyFWlM?=
 =?us-ascii?Q?Ru9FnihbV+07UZLBets5Gfg6z4V2KHkjAlvNh52nh1nHnybBE+de2GbtM3qC?=
 =?us-ascii?Q?2jRx/06enpNBVs4YoAuFogmJIET7lCV2Iy0kCMqPN9S6FfN7pGvQQ2/Xq+8l?=
 =?us-ascii?Q?vXx2k1H0uvHoy0WnXmP84JAUk3OJXnOSrTjAi1+6wQYE3+XLNcHv0RmpUGs/?=
 =?us-ascii?Q?lop4EELd/0BBBVSqsyqcYE9MySsezrWFKBHggIKb/zOZHJMqRmLGy6fck4AQ?=
 =?us-ascii?Q?9QfAOijEGctDrYc56kOjV/6VbYPCLuk/jiDVKVi3QTLm7QEwiyYA5aD4+D4j?=
 =?us-ascii?Q?m8ctYTeIBDu827ikp4xZSOJE4YdLo6UozQxqkTDVSu1n0rU4sPFZR8Kq5IGt?=
 =?us-ascii?Q?mSKoCiaJFPdMTw0hMJitBRw0h878Jug8AzVjj/e1GPpRmAg5kc+b0xlw6hvE?=
 =?us-ascii?Q?K+50PdgY4CWUDkv9FF4NYAOyXckm1il2Ox76UHB62yUNJ0T4BB4sLdessvLX?=
 =?us-ascii?Q?+aNEM37xc4HXG8oENA+ORxAjMKwYQJ5dRSVDRMB3j3P1L4HZS3jDIYywhk7e?=
 =?us-ascii?Q?QcIGMcAe6IZIn53Oe4A2hVer/nQZS96/QO5DrzJMGtLreUWNGBWRLREbJqLc?=
 =?us-ascii?Q?ZoDwZqvvY/ZaUDo7WCNnUM95kKgZ37ttZf32ezJgG5rwQgOwHQsDsni5A2X/?=
 =?us-ascii?Q?KOJ0CvvAzefATQwzgFM0Y+8E0kws45Mmi0KtCPgk9KMb9eT2IJLZY0qh8Xp5?=
 =?us-ascii?Q?gMWq3OtXS8bWT96wDZrCftxDjK0Chy4XZ9oNd39ggOQ1eAwXdx1c5RlyTZhr?=
 =?us-ascii?Q?9Lt1csgdnkgYEcyNTMQZvLI3xYrf3JmitMEdIUme3Z4M6BOekewZ0iwZ55kE?=
 =?us-ascii?Q?CUFoxljhw9Jp2sa1ByncOa+/hwZaq54Ju+KViKZFcG0eFHNFntOD+9ib+/X+?=
 =?us-ascii?Q?jRPdI0porQZaJrK6Vv/F470UwQs079J2MMEXd+M2fbPwRtqQ/zVUeqAfcdD6?=
 =?us-ascii?Q?Pu31+qm6Yk1l1RLsE2cLvY5LM281qIRSnOAWqau735fhvn6Qgkq3D0rITSv3?=
 =?us-ascii?Q?8MSh/kJ6n8eFUXehKVMOHUT1i0K7oC8wXKjxc0FvT+3N8f81vRVyCSgyDOXk?=
 =?us-ascii?Q?K4OT6oITp2H6FWsTaCDFqtnn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8223ad-a078-4d33-e57a-08d94548cf00
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:06.4708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQrkLkMK3nVuZvIgMCFsMJiyMUa4osbKDWV71l4iS2fG9lNENkPBvb/MOkkyzxyd9EmGmb93Jn3dIvDc6Ire7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Message for v3:

In this submission I have introduced a "native switchdev" driver API to
signal whether the TX forwarding offload is supported or not. This comes
after a third person has said that the macvlan offload framework used
for v2 and v1 was simply too convoluted.

This large patch set is submitted for discussion purposes (it is
provided in its entirety so it can be applied & tested on net-next).
It is only minimally tested, and yet I will not copy all switchdev
driver maintainers until we agree on the viability of this approach.

The major changes compared to v2:
- The introduction of switchdev_bridge_port_offload() and
  switchdev_bridge_port_unoffload() as two major API changes from the
  perspective of a switchdev driver. All drivers were converted to call
  these.
- Augment switchdev_bridge_port_{,un}offload to also handle the
  switchdev object replays on port join/leave.
- Augment switchdev_bridge_port_offload to also signal whether the TX
  forwarding offload is supported.

Message for v2:

For this series I have taken Tobias' work from here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210426170411.1789186-1-tobias@waldekranz.com/
and made the following changes:
- I collected and integrated (hopefully all of) Nikolay's, Ido's and my
  feedback on the bridge driver changes. Otherwise, the structure of the
  bridge changes is pretty much the same as Tobias left it.
- I basically rewrote the DSA infrastructure for the data plane
  forwarding offload, based on the commonalities with another switch
  driver for which I implemented this feature (not submitted here)
- I adapted mv88e6xxx to use the new infrastructure, hopefully it still
  works but I didn't test that

The data plane of the software bridge can be partially offloaded to
switchdev, in the sense that we can trust the accelerator to:
(a) look up its FDB (which is more or less in sync with the software
    bridge FDB) for selecting the destination ports for a packet
(b) replicate the frame in hardware in case it's a multicast/broadcast,
    instead of the software bridge having to clone it and send the
    clones to each net device one at a time. This reduces the bandwidth
    needed between the CPU and the accelerator, as well as the CPU time
    spent.

The data path forwarding offload is managed per "hardware domain" - a
generalization of the "offload_fwd_mark" concept which is being
introduced in this series. Every packet is delivered only once to each
hardware domain.

In addition, Tobias said in the original cover letter:

====================
## Overview

   vlan1   vlan2
       \   /
   .-----------.
   |    br0    |
   '-----------'
   /   /   \   \
swp0 swp1 swp2 eth0
  :   :   :
  (hwdom 1)

Up to this point, switchdevs have been trusted with offloading
forwarding between bridge ports, e.g. forwarding a unicast from swp0
to swp1 or flooding a broadcast from swp2 to swp1 and swp0. This
series extends forward offloading to include some new classes of
traffic:

- Locally originating flows, i.e. packets that ingress on br0 that are
  to be forwarded to one or several of the ports swp{0,1,2}. Notably
  this also includes routed flows, e.g. a packet ingressing swp0 on
  VLAN 1 which is then routed over to VLAN 2 by the CPU and then
  forwarded to swp1 is "locally originating" from br0's point of view.

- Flows originating from "foreign" interfaces, i.e. an interface that
  is not offloaded by a particular switchdev instance. This includes
  ports belonging to other switchdev instances. A typical example
  would be flows from eth0 towards swp{0,1,2}.

The bridge still looks up its FDB/MDB as usual and then notifies the
switchdev driver that a particular skb should be offloaded if it
matches one of the classes above. It does so by using the _accel
version of dev_queue_xmit, supplying its own netdev as the
"subordinate" device. The driver can react to the presence of the
subordinate in its .ndo_select_queue in what ever way it needs to make
sure to forward the skb in much the same way that it would for packets
ingressing on regular ports.

Hardware domains to which a particular skb has been forwarded are
recorded so that duplicates are avoided.

The main performance benefit is thus seen on multicast flows. Imagine
for example that:

- An IP camera is connected to swp0 (VLAN 1)

- The CPU is acting as a multicast router, routing the group from VLAN
  1 to VLAN 2.

- There are subscribers for the group in question behind both swp1 and
  swp2 (VLAN 2).

With this offloading in place, the bridge need only send a single skb
to the driver, which will send it to the hardware marked in such a way
that the switch will perform the multicast replication according to
the MDB configuration. Naturally, the number of saved skb_clones
increase linearly with the number of subscribed ports.

As an extra benefit, on mv88e6xxx, this also allows the switch to
perform source address learning on these flows, which avoids having to
sync dynamic FDB entries over slow configuration interfaces like MDIO
to avoid flows directed towards the CPU being flooded as unknown
unicast by the switch.


## RFC

- In general, what do you think about this idea?

- hwdom. What do you think about this terminology? Personally I feel
  that we had too many things called offload_fwd_mark, and that as the
  use of the bridge internal ID (nbp->offload_fwd_mark) expands, it
  might be useful to have a separate term for it.

- .dfwd_{add,del}_station. Am I stretching this abstraction too far,
  and if so do you have any suggestion/preference on how to signal the
  offloading from the bridge down to the switchdev driver?

- The way that flooding is implemented in br_forward.c (lazily cloning
  skbs) means that you have to mark the forwarding as completed very
  early (right after should_deliver in maybe_deliver) in order to
  avoid duplicates. Is there some way to move this decision point to a
  later stage that I am missing?

- BR_MULTICAST_TO_UNICAST. Right now, I expect that this series is not
  compatible with unicast-to-multicast being used on a port. Then
  again, I think that this would also be broken for regular switchdev
  bridge offloading as this flag is not offloaded to the switchdev
  port, so there is no way for the driver to refuse it. Any ideas on
  how to handle this?


## mv88e6xxx Specifics

Since we are now only receiving a single skb for both unicast and
multicast flows, we can tag the packets with the FORWARD command
instead of FROM_CPU. The swich(es) will then forward the packet in
accordance with its ATU, VTU, STU, and PVT configuration - just like
for packets ingressing on user ports.

Crucially, FROM_CPU is still used for:

- Ports in standalone mode.

- Flows that are trapped to the CPU and software-forwarded by a
  bridge. Note that these flows match neither of the classes discussed
  in the overview.

- Packets that are sent directly to a port netdev without going
  through the bridge, e.g. lldpd sending out PDU via an AF_PACKET
  socket.

We thus have a pretty clean separation where the data plane uses
FORWARDs and the control plane uses TO_/FROM_CPU.

The barrier between different bridges is enforced by port based VLANs
on mv88e6xxx, which in essence is a mapping from a source device/port
pair to an allowed set of egress ports. In order to have a FORWARD
frame (which carries a _source_ device/port) correctly mapped by the
PVT, we must use a unique pair for each bridge.

Fortunately, there is typically lots of unused address space in most
switch trees. When was the last time you saw an mv88e6xxx product
using more than 4 chips? Even if you found one with 16 (!) devices,
you would still have room to allocate 16*16 virtual ports to software
bridges.

Therefore, the mv88e6xxx driver will allocate a virtual device/port
pair to each bridge that it offloads. All members of the same bridge
are then configured to allow packets from this virtual port in their
PVTs.
====================

Tobias Waldekranz (4):
  net: bridge: disambiguate offload_fwd_mark
  net: bridge: switchdev: recycle unused hwdoms
  net: bridge: switchdev: allow the TX data plane forwarding to be
    offloaded
  net: dsa: tag_dsa: offload the bridge forwarding process

Vladimir Oltean (20):
  net: dpaa2-switch: use extack in dpaa2_switch_port_bridge_join
  net: dpaa2-switch: refactor prechangeupper sanity checks
  net: mlxsw: refactor prechangeupper sanity checks
  net: ocelot: fix switchdev objects synced for wrong netdev with LAG
    offload
  net: prestera: if the LAG that we're joining is under a bridge, join
    it
  net: prestera: refactor prechangeupper sanity checks
  net: bridge: switchdev: let drivers inform which bridge ports are
    offloaded
  net: prestera: guard against multiple switchdev obj replays on same
    bridge port
  net: mlxsw: guard against multiple switchdev obj replays on same
    bridge port
  net: bridge: drop context pointer from br_fdb_replay
  net: bridge: use the public notifier chain for br_fdb_replay
  net: bridge: unexport call_switchdev_blocking_notifiers
  net: bridge: propagate ctx to switchdev_port_obj_{add,del}
  net: bridge: propagate ctx to br_switchdev_port_vlan_{add,del}
  net: bridge: replay mdb entries on the public switchdev notifier chain
  net: bridge: replay vlan entries on the public switchdev notifier
  net: bridge: switchdev object replay helpers for everybody
  net: dsa: track the number of switches in a tree
  net: dsa: add support for bridge TX forwarding offload
  net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in
    the PVT

 drivers/net/dsa/mv88e6xxx/chip.c              |  78 ++++-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  61 +++-
 .../ethernet/marvell/prestera/prestera_main.c | 107 +++++--
 .../marvell/prestera/prestera_switchdev.c     |  36 ++-
 .../marvell/prestera/prestera_switchdev.h     |   7 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 275 ++++++++++-------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +
 .../mellanox/mlxsw/spectrum_switchdev.c       |  21 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  41 ++-
 drivers/net/ethernet/mscc/ocelot_net.c        | 116 +++++--
 drivers/net/ethernet/rocker/rocker.h          |   6 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  30 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  37 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  28 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  26 +-
 include/linux/if_bridge.h                     |  55 ++--
 include/net/dsa.h                             |  22 +-
 include/net/switchdev.h                       |  20 +-
 net/bridge/br_fdb.c                           |  46 +--
 net/bridge/br_forward.c                       |   9 +
 net/bridge/br_if.c                            |  11 +-
 net/bridge/br_mdb.c                           |  51 ++--
 net/bridge/br_mrp_switchdev.c                 |  20 +-
 net/bridge/br_private.h                       |  87 +++++-
 net/bridge/br_switchdev.c                     | 284 ++++++++++++++++--
 net/bridge/br_vlan.c                          |  62 ++--
 net/dsa/dsa2.c                                |   4 +
 net/dsa/dsa_priv.h                            |   8 +-
 net/dsa/port.c                                | 172 +++++++----
 net/dsa/slave.c                               |  17 +-
 net/dsa/tag_dsa.c                             |  52 +++-
 net/switchdev/switchdev.c                     |  58 ++--
 32 files changed, 1369 insertions(+), 482 deletions(-)

-- 
2.25.1

