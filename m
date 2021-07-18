Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54E63CCB09
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 23:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhGRVtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 17:49:12 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:24552
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232582AbhGRVtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 17:49:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2sYMdI/4uqM+nzDe074t6c/KiX0CNbvRs/xAbYOMaWwEIte/Ea0u1Uv6T6wOct1sXOEUy+htA7IojzSQNJHFMH8IKw+RjCvq/oJn1KUuonBlzgA0PGL87pdFDHNXVW+/AGXqesfeX/7KkqAsEwJdSYs6DCRi2KpF6ZaDLXxowZtboaoErhXu8oP/wa0JVH9PbiPMOu/DNcapNCa21ZM/zGcsLWqBmnra0Lj1vIlzXdfn7newopg099RfySPKZ88yc9UeGXGAbN+Q5NNb9TAEdFk2jq8tkMNA9/V69FJeq/AGsOFLBOD5hj13qMINVHskFuixAgJQ7WXPP/6RzYxWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXgAZKpvFD7MrvWAjGcK4E55sPm7zle8836ggooTT2w=;
 b=LyGwoWTiu5i0Kkq+Yy+haoA+Bq2mf9SJuEkiZMOvgOU6NIgMJJh+dKatycGzz7GmZOaBll9XA4QNz51/MMQSYdYcsvNrZRQpU3kgWwO0c/XzYrRpkip3Htu3/si3/vBvUiGVLgCfKCfQ+LldsxrEb20vx4r2j5Mp3JAX0HI58vWkggD2OJ0dgnkgldT/qZBW2I+vJrQ5r90vC3wSgejXZZaKwu7ZJ8oibpIlibKCvdIGiafdfvLymPO+iNLXf++L8yD8zqfZONXaxNrJu4eKJuFlnhRpUl98tOmnhnIaRy9knMok+EyWSnAxUKPunxcRiFX9gR2cVjf1hkyTU1TPdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXgAZKpvFD7MrvWAjGcK4E55sPm7zle8836ggooTT2w=;
 b=ZIj79gD5BP8NSydaeHygbMG67UIVOjJRr5lz4z6yKA5TgGh1WnVTegkw3YuDA3YiHlydTyvTWb02s00WCwwRUg2zP+9v1A2ldBf0U8rhVhsK+FbSytRyhaV7/DkkWnbr85CPNJ5LvKmoPH/iKjzTL/ZVaseclZHmN9sP+Hz0gR8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Sun, 18 Jul
 2021 21:46:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Sun, 18 Jul 2021
 21:46:10 +0000
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH v4 net-next 00/15] Allow forwarding for the software bridge data path to be offloaded to capable devices
Date:   Mon, 19 Jul 2021 00:44:19 +0300
Message-Id: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0014.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by VI1PR0602CA0014.eurprd06.prod.outlook.com (2603:10a6:800:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Sun, 18 Jul 2021 21:46:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae256d2b-92f0-499e-7b4c-08d94a357462
X-MS-TrafficTypeDiagnostic: VE1PR04MB7325:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73250C9B2D8B744124B6F627E0E09@VE1PR04MB7325.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kWiWMhwlEkNNq2gnidctzEQ3lun5rA6C5KHUc/wF84HsZqYg8u764h0DPTHzHht0Y5V9hiu80INKaytiJBxW/iMDKR0VGHNKkgOpRrFNEga+FiPh6oj9qwa63CSL/3B+QU0nr0r2yXFyf3ZmgxI3RSbFrHnJZE8ZphKSvcM8Vvw9WFeKKeTxanayZ6ftnZfvH25uozf29oLdf1JZJuWmwqPxVLBYuFDmO87QKq9OOtFg9nZdxgvywUw2nJUZNlfBaraNzSJIvgaZ5IyZFJDixDj6b6s4A5gNkTnykwSFJL3Et9+Al436oco0oldrTZSKWVIdOhWnMQO+HopG8nzMyXRRbZm5etX+EMBsYcnVglL8hgZZndy/Oh1b9btSIyTewkIiCbvsHhRnnSdz7HO3fuwLREG7aujVVS+Aj2BGG9vWpyH96Ofm76kLMJJ4ngrWn1j1Gy+WFopeBpr7w1omewgau9ezEyttQKkbL6jSlbGxRhbhKUL7i/5mEjY7ftcQ56IoexeyTcEDM11Cuk3vIKEnGiO++2429Dgr7wjKS12XjjdfWaDiCcEvoRjFDnkXZeVIRwYcjLS7tU9ZlyFu7OdyrT0OES9sYkqwhXPxvWt3jrdXVMh2NyoxYMocC/Z3nCKbxb8+2+lbm32h+Sfz42z6FJM7DkGlLr8c3VZQbMplWlGdObmdmQig6aIQ/OP/xG3CMW1otlXrNS61MjS9z1h4VIp0F+2//mllHfs7p8YvWRYKPc64RvB5ISpKhTIq2Mr0+KOtUhu/NpMkT3QVBO7k8NX4vpuxhtty2/tYqGHdDe3eoCLD2mUX668COx1i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39850400004)(346002)(6666004)(110136005)(8936002)(6506007)(8676002)(86362001)(54906003)(186003)(26005)(66946007)(66556008)(66574015)(83380400001)(66476007)(52116002)(2906002)(1076003)(316002)(7416002)(5660300002)(966005)(478600001)(36756003)(6512007)(30864003)(6486002)(44832011)(4326008)(956004)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G9slo+Y7Uqwd5UxFkIUTwWBnVmH6Lc3SJeUjUSlE0IHIIeQJkQRNYQu8k69L?=
 =?us-ascii?Q?O/tfJtGCrgdY+7iwEspiYhQ827Nyl6U4SLB8b1JkgEw2fyM0MI4w7+xhlHH4?=
 =?us-ascii?Q?iB6Ilp1lStCrgJGPNqtWmH4SZ4FYZndyXYHLmr4bpXURVSsNdRH6ekpTAXSE?=
 =?us-ascii?Q?0Ar79CWaQ/qdQLroUILc1wK27/ydbsObuaUkWrLrmZ647CGhhPhKswep+KuS?=
 =?us-ascii?Q?kdm+dT66Q3UwHKPFLYJlcHWqgcYuAm7Ug6dhWqwNZkL/9m3jo9oZHeEG4jGH?=
 =?us-ascii?Q?rthzeuDRdRU3w+OPOWAz6HUkMS0EtpI4ktdE6Pu56uQzI+P6UnJ+FKWyMDGh?=
 =?us-ascii?Q?pJJYOsD4S02yqtsbUiddXUrChu5hrQDo+WX1VzwzqgIsVZWegYT+VCtceCqR?=
 =?us-ascii?Q?zwGWxUXWJvX5CAnfnZWtRiSL1yj6uwGdDrEWhe2gL+bJc2v5XaBljfTW7zNZ?=
 =?us-ascii?Q?irQyiX7g2b4Ztx34rtg3aGTvdMY22bQSgQGPeWLS6NmJplFENrnVi4Asz8AK?=
 =?us-ascii?Q?WSotoHsGgfv0rkOTGdDQPJQRZytVdbTHayE1obdxGUpQ6OogcbNVZ/BoHqqy?=
 =?us-ascii?Q?PJSLz4kblpmjHHxaL1PtfNw580GZwjY0Xu2rW/wcTtmE0d3iytrU4juvM4LC?=
 =?us-ascii?Q?6FZHvb7klUqEkCkdPLtHKrZ2Nt3TYl+DsyN7NsqGc2XVtZsbvfdPdO0nbrdr?=
 =?us-ascii?Q?Emda2eu+GL/di2EFVlkL8xiJwGsHk6BCVFZr9zZghuPnlQmW6QzUl9vcTsH4?=
 =?us-ascii?Q?cMSPI2BdYHqaMr03/kn5gpOp3QY9TCcRtJl/mBh7O1hnaTRDly2dDXBm0Zhx?=
 =?us-ascii?Q?pRnEmRk8frkZmJacpghz/S/qUP6LJQyxCCjSeGSG7z1mQjMAB+vjIhPd1Ub5?=
 =?us-ascii?Q?MPMV3nYYbGAuzwDXAEX1GlO/3VUVQ7FXdbIsNrlTdpH8+Urrhsnqzg64Riso?=
 =?us-ascii?Q?Q/5wT1314IPUUSHZgzN44fPtkQUhhJp4Ko/HxVb3TaiG1DuJ5H8XDls335Ud?=
 =?us-ascii?Q?4xsrMo1Lj8e8FN+6TJoD+uP/sxuVwwVBSxjflxpQoK+/M/uMQxIt1OEjejA0?=
 =?us-ascii?Q?K3bCXg5dathLSo3AARN8GPBAlb11g8aIlDWCyCc+A7vE6hMXQfV6zfozjVPX?=
 =?us-ascii?Q?Tu0tBQljyAnUcY124Q3QUY7E8bENBjfJHI6iHEnvSyT0LcTMJJuLRXpHVd+o?=
 =?us-ascii?Q?2GEzerI4iTlagHQ1unpLoS92ixjAPPUpg1mtPvV0BsFAw5BiuwxxUTt2XXP4?=
 =?us-ascii?Q?eKPiCH7Lg2P57JI0scwNF3Oq/FzGvRfWKMq7QvOxlfwt2DoqdH1eXnVOtUKY?=
 =?us-ascii?Q?Vw3jnhVLdbK5cJPzvQpJgaaz?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae256d2b-92f0-499e-7b4c-08d94a357462
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2021 21:46:09.8797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lcxdP8Qm6Q1uHjUORC7CukQ0tRvn/H96HZncfAVGEiuuUJe1Zc47LPLwrEITXsL3qC4ST225g5hDmNmU6VGISQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I would like these patches to simmer for a few days and get some
feedback / confirmation that there are no regressions from switchdev
driver maintainers.

===========================================================

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

===========================================================

Message for v4:

The biggest change compared to the previous series is not present in the
patches, but is rather a lack of them. Previously we were replaying
switchdev objects on the public notifier chain, but that was a mistake
in my reasoning and it was reverted for v4. Therefore, we are now
passing the notifier blocks as arguments to switchdev_bridge_port_offload()
for all drivers. This alone gets rid of 7 patches compared to v3.

Other changes are:
- Take more care for the case where mlxsw leaves a VLAN or LAG upper
  that is a bridge port, make sure that switchdev_bridge_port_unoffload()
  gets called for that case
- A couple of DSA bug fixes
- Add change logs for all patches
- Copy all switchdev driver maintainers on the changes relevant to them

===========================================================

Message for v3:
https://patchwork.kernel.org/project/netdevbpf/cover/20210712152142.800651-1-vladimir.oltean@nxp.com/

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

===========================================================

Message for v2:
https://patchwork.kernel.org/project/netdevbpf/cover/20210703115705.1034112-1-vladimir.oltean@nxp.com/

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

In addition, Tobias said in the original cover letter:

===========================================================

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

Cc: Vadym Kochan <vkochan@marvell.com>
Cc: Taras Chornyi <tchornyi@marvell.com>
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>

Tobias Waldekranz (4):
  net: bridge: disambiguate offload_fwd_mark
  net: bridge: switchdev: recycle unused hwdoms
  net: bridge: switchdev: allow the TX data plane forwarding to be
    offloaded
  net: dsa: tag_dsa: offload the bridge forwarding process

Vladimir Oltean (11):
  net: dpaa2-switch: use extack in dpaa2_switch_port_bridge_join
  net: dpaa2-switch: refactor prechangeupper sanity checks
  mlxsw: spectrum: refactor prechangeupper sanity checks
  mlxsw: spectrum: refactor leaving an 8021q upper that is a bridge port
  net: marvell: prestera: refactor prechangeupper sanity checks
  net: switchdev: guard against multiple switchdev obj replays on same
    bridge port
  net: bridge: switchdev: let drivers inform which bridge ports are
    offloaded
  net: bridge: switchdev object replay helpers for everybody
  net: dsa: track the number of switches in a tree
  net: dsa: add support for bridge TX forwarding offload
  net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in
    the PVT

 drivers/net/dsa/mv88e6xxx/chip.c              |  78 +++-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  69 +++-
 .../ethernet/marvell/prestera/prestera_main.c |  99 +++--
 .../marvell/prestera/prestera_switchdev.c     |  42 ++-
 .../marvell/prestera/prestera_switchdev.h     |   7 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 347 ++++++++++++------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +
 .../mellanox/mlxsw/spectrum_switchdev.c       |  28 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  48 ++-
 drivers/net/ethernet/mscc/ocelot_net.c        | 115 ++++--
 drivers/net/ethernet/rocker/rocker.h          |   9 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  34 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  42 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  34 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  14 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.h |   3 +
 drivers/net/ethernet/ti/cpsw_new.c            |  32 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |   4 +-
 drivers/net/ethernet/ti/cpsw_switchdev.h      |   3 +
 include/linux/if_bridge.h                     |  63 ++--
 include/net/dsa.h                             |  21 ++
 net/bridge/br_fdb.c                           |   1 -
 net/bridge/br_forward.c                       |   9 +
 net/bridge/br_if.c                            |  11 +-
 net/bridge/br_mdb.c                           |   1 -
 net/bridge/br_private.h                       |  84 ++++-
 net/bridge/br_switchdev.c                     | 287 +++++++++++++--
 net/bridge/br_vlan.c                          |  11 +-
 net/dsa/dsa2.c                                |   4 +
 net/dsa/dsa_priv.h                            |   6 +
 net/dsa/port.c                                | 192 +++++++---
 net/dsa/tag_dsa.c                             |  52 ++-
 32 files changed, 1406 insertions(+), 348 deletions(-)

-- 
2.25.1

