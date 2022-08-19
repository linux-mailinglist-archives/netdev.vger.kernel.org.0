Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2D459A4FB
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350663AbiHSRl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354855AbiHSRki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:40:38 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150053.outbound.protection.outlook.com [40.107.15.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE06F1B790
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 09:59:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9H6lbPB0L9jTPvS7hLODrJstIEftltg2XJfrlA8Kua5sR0Y4ZwFjyumVqJbreSR8c1zNLFJOnKGMjKeGdtR4CqgcDpdFm8HljkU6G7i+o1GHbbAeWVQ+WFCQ+wuYceadl3UEVho1HrX+meULQMvuexJEE/nql2EGaIXpibeS6dm8iuyMLBqhiH2A8ivjHBKUWdAnEUalYwK2A2CSp9E09xQlkoyNvfYGRkYHK+kJ2z/T0tqzmTCap7CDx92OXkgWOMm2OVu8N5bwALcsm+0S7QfBV5p6aQbHId5TfVIlfjPsc/OgbvJr9WLscMzISq9kn9LDLmDJnK7k/HhmZTX0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2PcqQkTlAOwZtKv1GLV1FxWNNe1stztnvSNM0WY9RzI=;
 b=PKOznd8u0qJIS3A/3/mlNB/D6pnAJAkyyEO4G75wL5acaS8cN4l7xv2R1gWSPr0rgmWPFOLA1AIKgIkiSeUq9H5BzNQK4Ab4u/6a30rM+q0pc27wL8lb+4fO1+7kYPg0zGVVrfCjDoIpLdOwyxN9UZS9qgyLPb45v28fp+elGOiI3YXe+DXOGQiaG/SPMTa5XhLJmLavMRNEZUlyiKbE7u85GNOlrJ05kjiZkSlAPZPAzTeGtQ+YlPamigEXDzkUWBjTF4SXU+BM4zKSD1kzIfzCPq//2hRY5N560N3BQ7ZQNg1xr/lzkFxNVHsLqHXm13rGC1kmDOnDJhZHBMob+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PcqQkTlAOwZtKv1GLV1FxWNNe1stztnvSNM0WY9RzI=;
 b=UFv9shjalUhk7rMv6zdRTp0OT60X5Zy431FB/b1RRJsXJZN6W66Vb7F3FpKEhYXhoyNmA/Xo5MhZxj+UUF0W4MEyQD67g2PRx36MqbqVRRT3NlAarnmSrTIh8qHkOrW9b+WOL3twtXpIJ8j90RzmrH+8C2RJrWMPWoAnPcEHeTo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7038.eurprd04.prod.outlook.com (2603:10a6:800:12d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 16:59:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 16:59:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Thread-Topic: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Thread-Index: AQHYsb+mq+RKMZoa5EST9UiAwGJ6ra215G0AgACSNwA=
Date:   Fri, 19 Aug 2022 16:59:41 +0000
Message-ID: <20220819165940.ett7n4vwbw6hvqvi@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <87czcwk5rf.fsf@kurt>
In-Reply-To: <87czcwk5rf.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e621c10-a829-41d2-8174-08da8204358f
x-ms-traffictypediagnostic: VI1PR04MB7038:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: di4SHahkXZqu+vDgaQQbvPU/TflIxclJz23JYDpS5AlBorzKNyMjbJB/S86j53Kjv974I67LlYjc6vJH/MPJD6swShy/atE0TtFLvdaJ332i/oIAukOO9YKdPD/NeLQXMJqc+BJ15WlS5nOWTb0us67L9ekJvgnjzrdktAK68AvJjiWQ54wnQFIoQFp2GcXJ4GGtvK2I6JU1b98iLfao0VOcTXkEnLsGulCeEblb5bRG4Pn0WmIiARdVxvaaewh2mSDk3wrKatVTKOuPrv3q3JBDe8X+JwrjTNN6qv116vNEaZnoIDBotThwb4Us2YORp9b0RBC3TxDr21PxuOhVSTPm7lyNvg6XZVlZ/wTLquWnAadVsVzzcwy4mwNVElLQZKX9W36TwTHkEeAhNVV88p0DEEyqXJfBsFBuQ8c0lyvHeW5lLLzPGPZ9Q8qD1fZZdIYLOQ+lWsynVFvU04Ogo5qEp2Mkhb5jxlJybZKh4WmV52QVMsfNQTaEuMmV4nVL46AdZONAhhxVDquLeUDGVv2VSXhJLfUMfPbH1FV1ayIg2W6OYjO/Bbfqe6p1xfDrM/A4nTlbdtZgB2GuaTHmUGvQrEGUGSzRIufKBWlN4e2e26P+pix05j8+dqYVIyM2IE+gNSMLfEr67/VE042VgP0vavFBPrzGTuW9dJ0JnyVwH2IzYpLhU046kfwIBeNJ8O4esdwzAZjePTryu/5UQmFES5vkByk4H84xZm6g5fwbdF2E16bOS9oNVujQjyC0WejXB1sSW+WEZnN6f0lMd+Ka61vjp+TIdLW6aETvSXI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(6916009)(316002)(1076003)(186003)(54906003)(83380400001)(71200400001)(33716001)(38100700002)(122000001)(6506007)(38070700005)(76116006)(66446008)(66946007)(4326008)(66476007)(64756008)(66556008)(2906002)(966005)(8676002)(9686003)(6486002)(478600001)(26005)(86362001)(41300700001)(6512007)(30864003)(5660300002)(44832011)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RcnQukCwxt3tqqT2yCSIp4yTvZBuxp9wi4VsnA2v298jvtsc/t0VWWKC5ARA?=
 =?us-ascii?Q?WfQpHirZhFJwjBH3CTTP2Y3Y6OnM4/cGMmhYWWG12Ck9osVoAODEPD8UrlXq?=
 =?us-ascii?Q?jA5JAtCN+PR9PnztiOb4S4z+Ru98/Z/Hxu7fCWfYSv2qUzE3KMaVv5YMUt54?=
 =?us-ascii?Q?HJfF4/AYKWoKlC2tkfBdn3fXk5yBoafLOHNCEv1rcSRKw+e+7zApTYS+e+3l?=
 =?us-ascii?Q?wJbBZgB0pT0Z5jxLBmtUKWENcHxUMp8wcfxJM0QdTJlzyJ1qg0czj8d5RRW4?=
 =?us-ascii?Q?FeEr2BeDZOEQ67shtzj0ySewQ+8C70ZpwBI4WYZVq4h8x1yD/4d7cmfZpjLT?=
 =?us-ascii?Q?sUp33DQb09QTYJ3umbIW2ZnaCxU5CJVPCq0mfsMxRbryqqfrkbLoHYnF46Z1?=
 =?us-ascii?Q?tE2Tbs9HqafMX3Fkt+8qugw9lhMzABswupYG/3Xo4CEkKJm72YBwi2+D9l/e?=
 =?us-ascii?Q?njQvOJaNPa4oIitpIko2eeHIKiPrW5ucthm1KfT1aQ5qBYecQdhRjPR0TJOd?=
 =?us-ascii?Q?sOv0y8SVWAGYTZVOGIUhIPQqXRfq4C5kv71n8mtYG389547baAMZWtDbdXV7?=
 =?us-ascii?Q?NAuWbGDdVVYS1p9buY2iRtyYiAs/okmbLDK+pVxDt5tbFGF9hdKm9I3bKQEO?=
 =?us-ascii?Q?yBHekVOsHgrheiNNT8KPArcZXC1nucqNyFsDFw7vohyIE2NSNaLAb35O17/U?=
 =?us-ascii?Q?FFFReRqaojtzfYW35TLFINPW1mrs6N1qKPQu7TWTHAQQlvyJr7T+nqQsRZ6T?=
 =?us-ascii?Q?UeEjipA8xioadtCRhmeLhPMSXXIiL9eCVgJPSm56zlNx8BfFcZ9wfYkXmAGB?=
 =?us-ascii?Q?14DN0JbtTnD/eQaC4JkMk6wmPQdjwucWRznyYVwN2WLjS17KWQUuGtGkEBBY?=
 =?us-ascii?Q?mHqtBgA+dOTM0S+YhDPrfKxM/FQksqCYdy0F0LTMfVYgehi/eREsa7iarQlh?=
 =?us-ascii?Q?syUYBfZIdbnB+CCWW9LDBQr4taD+ZlcJvmzLWKFmur3TOjvz8lxaVliYbLBs?=
 =?us-ascii?Q?88419UrVFDxW1h0CGWWJ/fBApTn1Bdi4j7+lHLJ04HiZgTVSNTFhE4VvoZdJ?=
 =?us-ascii?Q?k4vH/mqcwUqEk58bklCDfbxm+Iyp5ZmkThNOmusv9gYwWYSE2F9IsiVdI4HY?=
 =?us-ascii?Q?06ue9uT8GWEOgc5QQfTe5mcYZhwWuQf4wa48N4zoBlEYMRBAJkHbwEMeXk2m?=
 =?us-ascii?Q?b+gNDwOXhqKJIdoSQVg+piNaqd+GKqNSGh6fdm98CknBgU6i/iJcrzxWe2cv?=
 =?us-ascii?Q?o3fw297NKttzXMzxBECsArdpe9dheyabmu5RTHxHYl4jHUT8XFig4YNqbdib?=
 =?us-ascii?Q?KSb7MdH5o3d31EgR8fhlBTL12uY9VIk7y5AXlTE/vyIKC046tBJOexJnY7w9?=
 =?us-ascii?Q?jXeeOwHkBag7rKWRn2e76xXuyvkdrW2cDMYHNyiOBF+CYxn6pddwG1UCBKTT?=
 =?us-ascii?Q?NuKzP6EV4bgln6A2FlozwZzghwV+rRZnwr48mVrzyxaJ1hPKxD7hhGKroP0h?=
 =?us-ascii?Q?XSqdWlXaHdIRR06J58xYolYdoKexMzPbP/Q6JGIz0GUR74948O2+lFy0GY+T?=
 =?us-ascii?Q?6AhTClcj1bkPD4NnQOgYeafVPeOd5aJRE0qMC/UmbXlIE236iwFSeQxMZMvT?=
 =?us-ascii?Q?OA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AFEEF4CD64E25249A535820C256ABF6B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e621c10-a829-41d2-8174-08da8204358f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 16:59:41.6267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ngQsx2mQtzWUi3pWigd2/FnFq3b73REqj+sdBuq8zGXy6OU0qW/OOVqMITxubO93Fp3YTlJIvMj0I6ZPIRCWEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7038
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On Fri, Aug 19, 2022 at 10:16:20AM +0200, Kurt Kanzenbach wrote:
> On Wed Aug 17 2022, Vladimir Oltean wrote:
> > Vinicius' progress on upstreaming frame preemption support for Intel I2=
26
> > seemed to stall, so I decided to give it a go using my own view as well=
.
> > https://patchwork.kernel.org/project/netdevbpf/cover/20220520011538.109=
8888-1-vinicius.gomes@intel.com/
>=20
> Great to see progress on FPE :-).

Let's hope it lasts ;)

> > - Finally, the hardware I'm working with (here, the test vehicle is the
> >   NXP ENETC from LS1028A, although I have patches for the Felix switch
> >   as well, but those need a bit of a revolution in the driver to go in
> >   first). This hardware is not without its flaws, but at least allows m=
e
> >   to concentrate on the UAPI portions for this series.
> >
> > I also have a kselftest written, but it's for the Felix switch (covers
> > forwarding latency) and so it's not included here.
>=20
> What kind of selftest did you implement? So far I've been doing this:
> Using a cyclic real time application to create high priority frames and
> running iperf3 in parallel to simulate low priority traffic
> constantly. Afterwards, checking the NIC statistics for fragments and so
> on. Also checking the latency of the RT frames with FPE on/off.
>=20
> BTW, if you guys need help with testing of patches, i do have access to
> i225 and stmmacs which both support FPE. Also the Hirschmann switches
> should support it.

Blah, I didn't want to spoil the surprise just yet. I am orchestrating 2
isochron senders at specific times, one of PT traffic and one of ET.

There are actually 2 variants of this: one is for endpoint FP and the
other is for bridge FP. I only had time to convert the bridge FP to
kselftest format; not the endpoint one (for enetc).

In the endpoint case, interference is created on the sender interface.
I compare HW TX timestamps to the expected TX times to calculate how
long it took until PT was preempted. I repeat the test millions of times
until I can plot the latencies having the PT <-> ET base time offset on
the X axis. It looks very cool.

The bridge case is similar, except for the fact that interference is
created on a bridge port going to a common receiver of 2 isochron
senders. What I plot is the path delay, and again, this shows actual
preemption times with a nanosecond resolution.

Here's a small snapshot of the main script. Not shown are the supporting
scripts for this:

#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright 2022 NXP
#
# Selftest for Frame Preemption on a switch. Creates controlled packet
# collisions between a priority configured as preemptable traffic (PT) and =
a
# priority configured as express traffic (ET).
#
#                           +-----------------------------+
#                           |            fp.sh            |
#                           |             br0             |
#                           |     +--------+--------+     |
#                           |     |        |        |     |
#                           |   $swp1    $swp2    $swp3   |
#                           +-----------------------------+
#   +--------------------+        ^        ^        |       +--------------=
--+
#   |                    |        |        |        |       |              =
  |
#   | fp_node_et_send.sh |--------+        |        +------>| fp_node_rcv.s=
h |
#   |        $h1         |                 |                |       $h3    =
  |
#   +--------------------+                 |                +--------------=
--+
#                                          |
#   +--------------------+                 |
#   |                    |                 |
#   | fp_node_pt_send.sh |-----------------+
#   |        $h2         |
#   +--------------------+
#
# Normally, a packet collision plot with no frame preemption looks as follo=
ws.
# The first packet starts being transmitted by the MAC, and the second pack=
et
# sees a latency proportional to how much transmission time of the previous
# packet there is left.
#
#        ^
#   ET   |
# frame  |        ---.
#  path  |       /    --.
# delay  |       |       --.
#        |       /          --.
#        |       |             --.
#        |      /                 --.
#        |      |                    ---.
#        |-----/                         -----------------------
#        |
#     ---+----------------------------------------------------------->
#        |      ET base time offset relative to PT
#
# Depending on the preemption point (where the express packet hits the
# preemptable packet that is undergoing transmission), the express packet w=
ill
# have a higher or lower path delay (latency).
#
# The packet collision can be broken into 3 distinct intervals:
# (a) when the packets start interfering, but not enough of the PT packet h=
as
#     been transmitted yet so as to preempt it (MAC merge fragments must st=
ill
#     obey the minimum Ethernet frame size rule). There are no frame
#     preemptions when packets collide here.
# (b) the preemptable area, where the latency should be equal to the
#     transmission time of a MAC merge fragment rather than a full packet
#     (preemption should happen right away).
# (c) where the packets still interfere, but there are not enough bytes of =
the
#     PT frame left to transmit so as to construct a valid fragment out of =
the
#     remainder. No preemptions are expected in this region.
#
#        ^
#   ET   |      a         b            c
# frame  |   <----><---------------><---->
#  path  |
# delay  |
#        |
#        |       /|
#        |      /  -----------------.
#        |      |                    ---.
#        |-----/                         -----------------------
#        |
#     ---+----------------------------------------------------------->
#        |      ET base time offset relative to PT
#
# The selftest evaluates the preemption performance of a given switch by
# plotting the ET latency as a function of the ET base time offset.

WAIT_TIME=3D1
NUM_NETIFS=3D3
NETIF_CREATE=3Dno
REQUIRE_MZ=3Dno
lib_dir=3D$(dirname $0)/../../../net/forwarding
source $lib_dir/lib.sh
source $lib_dir/tsn_lib.sh
source $(dirname $0)/fp_topology.sh

require_command gnuplot

swp1=3D${NETIFS[p1]}
swp2=3D${NETIFS[p2]}
swp3=3D${NETIFS[p3]}

signal_received=3Dfalse

ethtool_save_fp_admin_status()
{
	admin_status=3D$(ethtool --json --show-fp $1 | \
		jq "(.[].\"parameter-table\"[] | select(.prio =3D=3D $2)).\"admin-status\=
"")
}

ethtool_restore_fp_admin_status()
{
	case $admin_status in
	express)
		ethtool --set-fp $1 admin-status $2:E
		;;
	preemptable)
		ethtool --set-fp $1 admin-status $2:P
		;;
	esac
}

avg_pdelay()
{
	local file=3D$1
	local tmp=3D$(mktemp)

	printf "print((" > $tmp
	isochron report \
		--input-file "${file}" \
		--printf-format "print(\"{} + \".format(%d - %d), end=3D'')\n" \
		--printf-args "RT" | python3 - >> $tmp
	printf "0) / $NUM_FRAMES)" >> $tmp
	cat $tmp | python3 -
	rm -f $tmp
}

validate_coordination()
{
	local et=3D$1; shift
	local pt=3D$1; shift
	local et_start
	local pt_start

	et_start=3D$(($(isochron report --input-file $et \
		--printf-format "%u - %u" --printf-args "SB" --stop 1)))
	pt_start=3D$(($(isochron report --input-file $pt \
		--printf-format "%u - %u" --printf-args "SB" --stop 1)))
	if ! [ $et_start =3D $pt_start ]; then
		printf "ET test %s / PT test %s: ET starts at %s, PT starts at %s\n" \
			"$et" "$pt" \
			"$(isochron report --input-file $et \
				--printf-format "%T" --printf-args "S" --stop 1)" \
			"$(isochron report --input-file $pt \
				--printf-format "%T" --printf-args "S" --stop 1)"
		exit 1
	fi
}

plot()
{
	local pt_frame_size=3D$1; shift
	local num_tests=3D$1; shift
	local fp_label=3D$1; shift
	local pt_svg=3D"plots/pt-${pt_frame_size}-${fp_label}-pt.svg"
	local pt_plot=3D"plots/pt-${pt_frame_size}-${fp_label}-pt.plot"
	local et_svg=3D"plots/pt-${pt_frame_size}-${fp_label}-et.svg"
	local et_plot=3D"plots/pt-${pt_frame_size}-${fp_label}-et.plot"
	local pt_avg_pdelay
	local et_avg_pdelay
	local base_time
	local et
	local pt
	local i

	printf "Plotting charts for collision between PT@%d and ET@%d\n" \
		"${pt_frame_size}" "${ET_FRAME_SIZE}"

	mkdir -p plots
	rm -f $et_plot $pt_plot

	for ((i =3D 0; i < num_tests; i++)); do
		et=3D"reports/pt-${pt_frame_size}-test-${i}-${fp_label}-et.dat"
		pt=3D"reports/pt-${pt_frame_size}-test-${i}-${fp_label}-pt.dat"

		base_time=3D$(isochron report --input-file "${et}" \
				--printf-format "%u" --printf-args "B" \
				--stop 1)

		pt_avg_pdelay=3D$(avg_pdelay $pt)
		et_avg_pdelay=3D$(avg_pdelay $et)

		echo "$base_time $pt_avg_pdelay" >> $pt_plot
		echo "$base_time $et_avg_pdelay" >> $et_plot

		if [ "$signal_received" =3D "true" ]; then
			exit 1
		fi
	done

	gnuplot --persist <<- EOF
		set xlabel "Base time offset (ns)"
		set ylabel "Average PT path delay (ns)"
		set term svg
		set terminal svg enhanced background rgb "white"
		set output "${pt_svg}"
		plot "${pt_plot}" using 1:2 with lines title "PT latency"
	EOF

	gnuplot --persist <<- EOF
		set xlabel "Base time offset (ns)"
		set ylabel "Average ET path delay (ns)"
		set term svg
		set terminal svg enhanced background rgb "white"
		set output "${et_svg}"
		plot "${et_plot}" using 1:2 with lines title "ET latency"
	EOF

	rm -f ${et_plot} ${pt_plot}
}

test_collision()
{
	local test_num=3D$1; shift
	local pt_frame_size=3D$1; shift
	local base_time_offset=3D$1; shift
	local fp_label=3D$1; shift
	local vrf_name=3D$(master_name_get br0)
	local et=3D"reports/pt-${pt_frame_size}-test-${test_num}-${fp_label}-et.da=
t"
	local pt=3D"reports/pt-${pt_frame_size}-test-${test_num}-${fp_label}-pt.da=
t"
	local orchestration=3D$(mktemp)
	local et_extra_args
	local pt_extra_args

	if [ "${H1_REQUIRE_PTP4L}" =3D "no" ]; then
		et_extra_args=3D"${et_extra_args} --omit-sync"
	fi

	if [ "${H2_REQUIRE_PTP4L}" =3D "no" ]; then
		pt_extra_args=3D"${pt_extra_args} --omit-sync"
	fi

	if [ "${H3_REQUIRE_PTP4L}" =3D "no" ]; then
		et_extra_args=3D"${et_extra_args} --omit-remote-sync"
		pt_extra_args=3D"${pt_extra_args} --omit-remote-sync"
	fi

	mkdir -p reports

	printf "Collision between PT packets of size %d and ET packets of size %d =
at %s, test %d (base time offset %d)\n" \
		${pt_frame_size} ${ET_FRAME_SIZE} ${fp_label} ${test_num} ${base_time_off=
set}

	cat <<- EOF > ${orchestration}
	[ET]
	host =3D $H1_IPV4%$vrf_name
	port =3D $H1_PORT
	exec =3D isochron send \\
		--client $H3_IPV4%$vrf_name \\
		--stats-port $H3_ET_PORT \\
		--interface $ET_IF_NAME \\
		--unix-domain-socket $UDS_ADDRESS_H1 \\
		--num-frames $NUM_FRAMES \\
		--priority $ET_PRIO \\
		--vid 0 \\
		--base-time ${base_time_offset} \\
		--cycle-time ${CYCLE_TIME_NS} \\
		--frame-size $ET_FRAME_SIZE \\
		--sync-threshold $SYNC_THRESHOLD_NS \\
		--cpu-mask $((1 << ${ISOCHRON_CPU})) \\
		--sched-fifo \\
		--sched-priority 98 \\
		--etype 0xdead \\
		--txtime \\
		${et_extra_args} \\
		--output-file ${et}

	[PT]
	host =3D $H2_IPV4%$vrf_name
	port =3D $H2_PORT
	exec =3D isochron send \\
		--client $H3_IPV4%$vrf_name \\
		--stats-port $H3_PT_PORT \\
		--interface $PT_IF_NAME \\
		--unix-domain-socket $UDS_ADDRESS_H2 \\
		--num-frames $NUM_FRAMES \\
		--priority $PT_PRIO \\
		--vid 0 \\
		--base-time 0.000000000 \\
		--cycle-time ${CYCLE_TIME_NS} \\
		--frame-size $pt_frame_size \\
		--sync-threshold $SYNC_THRESHOLD_NS \\
		--cpu-mask $((1 << ${ISOCHRON_CPU})) \\
		--sched-fifo \\
		--sched-priority 98 \\
		--etype 0xdeaf \\
		--txtime \\
		${pt_extra_args} \\
		--output-file ${pt}
	EOF

	isochron orchestrate --input-file ${orchestration}

	rm -rf ${orchestration}

	validate_coordination $et $pt
}

test_collision_sweep_base_time()
{
	local pt_frame_size=3D$1; shift
	local base_time_start=3D$1; shift
	local base_time_stop=3D$1; shift
	local base_time_increment=3D$1; shift
	local fp_label=3D$1; shift
	local num_tests
	local i

	num_tests=3D$(((base_time_stop - base_time_start + 1) / base_time_incremen=
t))
	for ((i =3D 0; i < num_tests; i++)); do
		base_time=3D$((base_time_start + i * base_time_increment))

		test_collision "$i" "$pt_frame_size" "$base_time" "$fp_label"

		if [ "$signal_received" =3D "true" ]; then
			exit 1
		fi
	done

	plot $pt_frame_size $num_tests $fp_label
}

test_pt_124()
{
	local start=3D$1; shift
	local stop=3D$1; shift
	local fp_label=3D$1; shift

	test_collision_sweep_base_time 124 $start $stop 40 $fp_label
}

test_pt_300()
{
	local start=3D$1; shift
	local stop=3D$1; shift
	local fp_label=3D$1; shift

	test_collision_sweep_base_time 300 $start $stop 40 $fp_label
}

test_pt_600()
{
	local start=3D$1; shift
	local stop=3D$1; shift
	local fp_label=3D$1; shift

	test_collision_sweep_base_time 600 $start $stop 40 $fp_label
}

test_pt_1000()
{
	local start=3D$1; shift
	local stop=3D$1; shift
	local fp_label=3D$1; shift

	test_collision_sweep_base_time 1000 $start $stop 40 $fp_label
}

test_pt_1500()
{
	local start=3D$1; shift
	local stop=3D$1; shift
	local fp_label=3D$1

	test_collision_sweep_base_time 1500 $start $stop 40 $fp_label
}

test_no_fp_cut_through()
{
	local fp_label=3D"no-fp"

	test_pt_124 0 1800 $fp_label
	test_pt_300 0 3400 $fp_label
	test_pt_600 0 7000 $fp_label
	test_pt_1000 1500 12000 $fp_label
	test_pt_1500 3000 17000 $fp_label
}

test_fp_quick()
{
	ethtool_save_fp_admin_status $swp3 $PT_PRIO
	ethtool --set-mm $swp3 verify-disable off enabled on add-frag-size 0
	ethtool --set-fp $swp3 admin-status $PT_PRIO:P

	test_pt_1500 12000 26000 "quick"

	ethtool_restore_fp_admin_status $swp3 $PT_PRIO
}

test_fp()
{
	local fp_label=3D$1; shift
	local add_frag_size=3D$1; shift

	ethtool_save_fp_admin_status $swp3 $PT_PRIO
	ethtool --set-mm $swp3 verify-disable off enabled on add-frag-size $add_fr=
ag_size
	ethtool --set-fp $swp3 admin-status $PT_PRIO:P

	test_pt_124 200 2000 $fp_label
	test_pt_300 1500 5000 $fp_label
	test_pt_600 4500 10000 $fp_label
	test_pt_1000 8800 17000 $fp_label
	test_pt_1500 12000 26000 $fp_label

	ethtool_restore_fp_admin_status $swp3 $PT_PRIO
}

test_fp_add_frag_size_0()
{
	test_fp "add-frag-size-0" 0
}

test_fp_add_frag_size_1()
{
	test_fp "add-frag-size-1" 1
}

test_fp_add_frag_size_2()
{
	test_fp "add-frag-size-2" 2
}

test_fp_add_frag_size_3()
{
	test_fp "add-frag-size-2" 3
}

setup_prepare()
{
	vrf_prepare

	switch_create
	ptp4l_start "$swp1 $swp2 $swp3" false ${UDS_ADDRESS_SWITCH}
	phc2sys_start ${UDS_ADDRESS_SWITCH}
}

cleanup()
{
	pre_cleanup

	ptp4l_stop "$swp1 $swp2 $swp3"
	phc2sys_stop
	switch_destroy

	vrf_cleanup
}

signal()
{
	signal_received=3Dtrue
}

trap cleanup EXIT
trap signal SIGTERM
trap signal SIGINT

#	test_no_fp_cut_through
#	test_fp_add_frag_size_0
#	test_fp_add_frag_size_1
#	test_fp_add_frag_size_2
#	test_fp_add_frag_size_3
ALL_TESTS=3D"
	test_fp_quick
"

setup_prepare
setup_wait

tests_run

exit $EXIT_STATUS=
