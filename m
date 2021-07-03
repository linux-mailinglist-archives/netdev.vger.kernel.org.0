Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889673BA893
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 13:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhGCMBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:01:03 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:8275
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230196AbhGCMBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 08:01:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOu5s93/uyfGNnUWzoASdpPCMrQjKfVBWJgM9bmvDPUdG+8WisWp67g2F98zWVRXdzDK8+xefIHaJt1FngoorViKoZu0cjlySQuyCcrxAO9Vuje8y4l2FNeZZbD7qxNsmPZbhZQmVh12fnayxlqUz8iAraz6aVmzS7D4iKo9k+xwF2/w0jWlsreV/KmDn92oOGZhwzt7REuxSArHIkALhdRG8xdt5+eahm9o9cD00evFQ6eY85VWkzzXHfJ+LR86hBDqvaViEoPYIkWULG7BvDyUaFl3XGdi4nKTUmmcumAqhqucXZ9NtTfYEkWE2bj/7x4pmigwhtj+9jJj6OhHyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59voxxYYPSGMxzZfLg+j2gbtEYV66sJBuRkSAM1xX9U=;
 b=Kv9aXi1HA0Rduf+lbCTxRAsarZ69OOkJEoEWOMdILlzPfpj++2rdBw5Jsl5mb1a3JYhbU/K8E1135gNdk7p8qfteqRaIv64DaT4K60s8JkcBiKmKsdMQ8iEl6Sv2SaCmxols3ZNFw2Jo5fLBgIQm1wohXlQ1fCFViko+RYWoz7N0dlSzk5UMMF3ckA3h1PTFcKo+AHmRmXYzZduiGpnvdfO4pj+Uc75RhcJxFmC2fO7UOsceS/VTmGf4Jfh3ecxg3fugqie0Oq9N3aum+HGqnrRadkkjz1LHgLP6dvJHg9kHrFDgERhv2hk6GcahPZDGLEe63yWvo33dgPPM2x32vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59voxxYYPSGMxzZfLg+j2gbtEYV66sJBuRkSAM1xX9U=;
 b=hMok4ZWmDp0/4MwXURELZjeu/urfwuIq3Wsdvi7khY2COpZez/wlx2Otev+5keob52HAR4dp25ZghISMj8yPyt3b94KKFVWWo4+VfJvaCGmouBhIMW6CbGuU49Ajm7SzY4fnjlAoXge8Im9IoAgInn+SUOJB2qHL5QMknUQJ8ao=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 11:58:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4287.031; Sat, 3 Jul 2021
 11:58:26 +0000
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
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [RFC PATCH v2 net-next 00/10] Allow forwarding for the software bridge data path to be offloaded to capable devices
Date:   Sat,  3 Jul 2021 14:56:55 +0300
Message-Id: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.224.68]
X-ClientProxiedBy: PR3P189CA0081.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.224.68) by PR3P189CA0081.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Sat, 3 Jul 2021 11:58:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ac096fb-eb19-4f20-9f43-08d93e19dd46
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25091B9D511F986F23DDA419E01E9@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owqH+y5sbmpS6AHFb/cTRrE5rlEz+APMVHQeC4MGaV9/vW9OoTvO1kcOQAeKjNf6uICOBjppr28HOhL4lkwG2BkLtCU91GCI8AhzwNVn+aSSMwVAEJzPXp98/Pgf5tZdkzXTGyDPXfl/LNvndz/zr163aayEHtPO9fIEn76pEXp0madVsGyc6zPDb6xkSmyg34Nxcxbc6b+ZZjKZC5jXdNaEB/22+V1fCzuW8b9AU4N6FzEkD2mD+5qUdtQv7soxx0D2wL4+qGNbzJwEHoiPjHkrL8JDZPYfx96XI5ISBp+386EFBaYnR6d8HfzY1sQ54NFb238HiVQtLq4NTrnTn5aYYelmzluLJpoVgMhQa+KYJTt1MfoqNWIQpQV0Os+J2NdGp4PYwLssRfEI1sSAaQWN6iixMGVcVNOX4+JdnMwBwxKs5ZaP/LrSCTEoKwRyYgsTzFxJSvCW6ZswFbiJ9KHJOBu1f7OeFK49ZDWIUY7uk7lM36Dv8Q8xbbXF7bbRUpXTnp1YP1qmDsOVhIWVPxuookC2ARMWpc/i1H2UoJ1dCAShr2KvOUzf4Wh8jirFKwbagWphGRzNrrzuSyePYS6W5iEOPJHeG/rtLj7Qsd5fXS6CidfEyg5m+X7KCXiaVktlACWxztYDCPIgaYUOZXNEyk+B5IgYBWNVURMi9Gs1B/boaGJ8btPogfAa4SfwHqSSZWG8wlT1tlkFQqTRR0cc9Rvdi+LCqKySgvypP6coBJxwvVRTQIzsgdYW2vNB58bYbMSmGQXP+cBOiJzObSdSAyOjt5N2Dg4grEapd+H9jESdjRv69tifOPyQHVpt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(6506007)(2906002)(966005)(4326008)(36756003)(2616005)(44832011)(956004)(6666004)(478600001)(7416002)(5660300002)(110136005)(66946007)(26005)(52116002)(1076003)(8676002)(8936002)(316002)(54906003)(66476007)(66556008)(6486002)(38100700002)(16526019)(38350700002)(186003)(66574015)(83380400001)(86362001)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y4xSUeypW7xXewZhyWWZ7Lgq6uf5N0/IutfN40TVcol27NBSyHQk2u6nIRZj?=
 =?us-ascii?Q?LyV09eqDLNtDNBNKrB5BuYf9C3DeDSuGC0B+Y7yx6+JeD0r6bmNgxR/t6ij4?=
 =?us-ascii?Q?5sQpxLoEv/H9PxGjWsywYHJKlFL3qx+0jnG+epDi2VfH1QwOBTDu8ZiJ1Z9R?=
 =?us-ascii?Q?3m94ifEYg3QEkRFyP8GBcm0OrMlx+/EdOYx6uWJ/dj3mCWO8KU8Fduz9c4cy?=
 =?us-ascii?Q?kr5z0nyrJPXzqZLDMsnuwgbMqAg7fCQmJaN+jBMLCQIVs2w95hbrRTN8tDIX?=
 =?us-ascii?Q?+kuzTHPyWNZs0eMagxrN59DcXW3+eN8NCinxzGgYQNatqcSnhb3a9hIhNOOc?=
 =?us-ascii?Q?P7M7e2dejA5pxdvFwKIlzB7mQwSL+zM/G6VR2IKkfTy4f8Y9uS5xV5NO/tGf?=
 =?us-ascii?Q?/UXj1jSuberR3zygdLNP9tP9JfqF2Vq+B2gGBjAHPqdndZwAYZQhQuIkL4eC?=
 =?us-ascii?Q?mMgKTw+3umt9F7jB0tremvZONGTz5rfLmh0GfM8tvfJELVAVTl4yzUE5tul4?=
 =?us-ascii?Q?zsKTN5QwWIiITRYzqxHP2pH0r/zeMklhuShB0EzKHoxxUL5r7w+S0H74j5xY?=
 =?us-ascii?Q?vVxNOgT76OYq8OH4eJ1G05rdGILIxk4A0WbxiEbKjyZbY+aZg9WyRB1pxUa9?=
 =?us-ascii?Q?mBDXGhCn+qstQdktzKO+nrvpUNAB3B2I2ElFquoR6qF4XWyYH0/fO7Njlwiw?=
 =?us-ascii?Q?f8WHp+woz8P1iTM/p80dkYz79viZwzomq+Ghf/UBgHUWxOYdD1soXLWEi845?=
 =?us-ascii?Q?zDv/IPqJ6NteMI0FuOD8W/y/o4CQgxP5XQ/nENZ3l1arI50HkLNTpp00oNke?=
 =?us-ascii?Q?BxKcHefHoqfs6g5sTz8CZoLXAKuJTnjEUtVCopqErJWnDFEFx9vra8Rlq+76?=
 =?us-ascii?Q?S/rq5CFVx650rYvoSlhbxIz6TmqzNWPrkMpBaCrBnKOYUoye2hCSepOTMvWa?=
 =?us-ascii?Q?IR7dU3iYTTHGkTY/HdQ1SLyb0iQccCDP2JUb/7IMK3sL8Gg7kOwnUf6Ug1uE?=
 =?us-ascii?Q?/AXpPbV5LgD+cBVr8NCzJnoOgmplCd08NOkhmCBgWmavMut7Uva86AwbSSo0?=
 =?us-ascii?Q?XJxIHZHIWJVuovbtk3Rkzx3wwnLsAl0P3Tc5mL27sW2xRxdEMbjaa4q+x5MB?=
 =?us-ascii?Q?7unPra7nfnD/yd5AX9R54f35Eari4qGJlOnPCeWU9/WESd7NY4b52Dcoyplh?=
 =?us-ascii?Q?/bChn0+M66EbnAhEnFIYgWe5+5pEePNekghf87etGUrY9SJz82JlK/O0vV+Z?=
 =?us-ascii?Q?//+7JR38JQCPviW7Q0dxEgOw4s6om2tTe9MlzHshdbHGjl+Cj7DF3/FU5IUf?=
 =?us-ascii?Q?Hcg+He83/vb+XaGTDgiBxMmr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac096fb-eb19-4f20-9f43-08d93e19dd46
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 11:58:26.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s31b8jHxFddS6c+otvG6x5MMWcQXSy2a4bZQiF7wpj8LQ68ZGh7C64uP5lo1vem+0FDb/Qy99ogieuDXwwxLdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Tobias Waldekranz (5):
  net: dfwd: constrain existing users to macvlan subordinates
  net: bridge: disambiguate offload_fwd_mark
  net: bridge: switchdev: recycle unused hwdoms
  net: bridge: switchdev: allow the data plane forwarding to be
    offloaded
  net: dsa: tag_dsa: offload the bridge forwarding process

Vladimir Oltean (5):
  net: extract helpers for binding a subordinate device to TX queues
  net: allow ndo_select_queue to go beyond dev->num_real_tx_queues
  net: dsa: track the number of switches in a tree
  net: dsa: add support for bridge forwarding offload
  net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in
    the PVT

 drivers/net/dsa/mv88e6xxx/chip.c              | 106 +++++++++++-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |   3 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   3 +
 include/linux/if_bridge.h                     |   1 +
 include/linux/netdevice.h                     |  13 +-
 include/net/dsa.h                             |  37 ++++
 net/bridge/br_forward.c                       |  18 +-
 net/bridge/br_if.c                            |   4 +-
 net/bridge/br_private.h                       |  49 +++++-
 net/bridge/br_switchdev.c                     | 163 +++++++++++++++---
 net/bridge/br_vlan.c                          |  10 +-
 net/core/dev.c                                |  31 +++-
 net/dsa/dsa2.c                                |   3 +
 net/dsa/dsa_priv.h                            |  28 +++
 net/dsa/port.c                                |  35 ++++
 net/dsa/slave.c                               | 134 +++++++++++++-
 net/dsa/switch.c                              |  58 +++++++
 net/dsa/tag_dsa.c                             |  60 ++++++-
 19 files changed, 700 insertions(+), 59 deletions(-)

-- 
2.25.1

