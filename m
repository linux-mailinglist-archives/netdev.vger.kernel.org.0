Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB3F425854
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242881AbhJGQtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:49:35 -0400
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:18693
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242840AbhJGQt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:49:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8DrqcNGy4iH6TmJ/EftizZVpS/o/NgOM4Rx2KxrtrhLN2Hre57zumoaqEo60WcG+e+7Vb00u7bpKf68wm1aho3ihILs1KAQUecWInlPItTI+mIFqEsH3XhjWlN+nH96pdaEFThu0Ucp9X0kOunJGhBB6Pxnb/NWOH19mSWvltW6tmDIDVAJtS8DDba8QzltC5/U0fAy5k9cmY97g0w+/rG5sPhId2/l2vbTtMeJr54JuWgBXPFIVtw4ywsJED/6ky1H7mUvaOI420G8wJVH5NBZlDRVW/t58dhdd118yjoxO5iPgP2XZVGY+osQDaPa6wcxNmOYdGXCwMuvuSQ97A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tAuRSNK7z4GkNlMWCK7prygikXlK9vOkaUwkInQvuY=;
 b=V7A6BvrVfDjqfHo9TGI2yeSAOqUZ1G9RWYj/ayjPotk5ok0ncqgqVwXJDPcaGK2hTWfxybBkkaQ+ydQlOKTIUL9+hYTyMHD/IL/M99LI/ecIuzyqzbuhc2+uL6zOnhaJGZifcsBGntH4M2Hui/JQvSF8agj6jrjH/V7VdBamPRaxUkhQfx+5HGuNydj4k9NkohKwtRX48eKuB8fem0omP9wf/Di0MwbOYsCrrg8drwODrj2Xbgheh84glnw/e+RD+MpgHqVux7XeIB5rBQdjpYVb6LqfuaGlSnMHwujRywfrq8mdNoXg3koy9WDDO+xT7mr3autrOuW4B0PCI+3brg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tAuRSNK7z4GkNlMWCK7prygikXlK9vOkaUwkInQvuY=;
 b=R1i6CHK80b51ZfWyvQJUFbZTIdHouYQmfBjFYmfxqukG4483PDIsOkgnawg3UAggwWv+/P18HYFlcOXY1FAfi+n5BqXOL3CsHzrLF8jU+krL7j+Wo+kY7mmO8P7Xpyh/0i711rwYKGAgduKRNhrCDuqvEhZ5fatHQmDOj5yPeFU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Thu, 7 Oct
 2021 16:47:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 16:47:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v3 net 4/4] net: dsa: mv88e6xxx: isolate the ATU databases of standalone and bridged ports
Date:   Thu,  7 Oct 2021 19:47:11 +0300
Message-Id: <20211007164711.2897238-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
References: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0105.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR08CA0105.eurprd08.prod.outlook.com (2603:10a6:800:d3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 7 Oct 2021 16:47:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42443c23-1897-48f4-8b31-08d989b225f4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3549DD79C62A31B8B44D4AD1E0B19@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQmame2Ej6tGW2RINzkZ3Qk0F717WpaAH/GQNwLfaP4+JZI3oGATpl6Gx5VlIhl0PPFhTVGM05UBiRpzHNNLPcXSguLQ9t6i/secYr1b54K6O6aDZglqjdoSsv9qlV9mKxUQTI6fi4dcbuIp9JYK+nbXUNRTbkZCL3rDkFmRYebo2+euT5yno0vDZoNBhLrxTAmt7Sn/yWUZ/EujfzqIutgaVhXws9C+M7r07Z1Me91cdbn37764C1Htwqu8I0uG3XO3o/f2n8luYTyX/9xm/xCvGXB2rqc2xC5hAbafsBLzvRp2CW7s+tKygznhy35oHZCRqwJYm48N1szYeQnMQ/RdvHHUxvBvATGrAdN8RyhFuCtWdkzcm9nx4t926ixwTRn4MhYarLWn+6edWCE+LmrkUz12DlAvS5M6/S7r1jcXogJXVnWzcn6tYZFJ7tSihKTecWSVQ6ueKy2S0bHJ4N04Q1+nG2EYwZxjlzvxL6BNtE0QofDAC08efy8jJFgz5GPq1puHm+JEeEQXx3RTuwwqIrrn7Lq1JabLZypnAYyCnP7B224123/GsNrtc0hrVqXOG9yORa0MUWaeaQza/zO0SZLaIMyBLDo45SPE2WC6Hn6XDnU3dKWL/zdBpMXbZcTm45PcCfKG7CmVPqcWiIy8x2G5YkJHjiWoPNZJKs6ikV9CCkCttphPSqu4B+Oz+s3LCiDbDBcdTy6PQipPkBs8gjsBzmKD3W+FvXW1uSkij5eIcDzD5C+Bvf4rjNVq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(83380400001)(38350700002)(5660300002)(316002)(2906002)(110136005)(66946007)(1076003)(54906003)(6512007)(66556008)(66476007)(38100700002)(2616005)(6486002)(956004)(8676002)(52116002)(30864003)(4326008)(6506007)(508600001)(26005)(44832011)(186003)(8936002)(6666004)(130980200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EtH8BwxUjlYwSg4sRxKAEDIXyvYXVd2e1eK3NQ2VZRLTlx5bDN5jw64BJ51J?=
 =?us-ascii?Q?RTgiOLJn0peZt+vqLwT/qCy49s+Z2Vi8IoghuQQPId8MJ0Q122ZqeZ52XxT/?=
 =?us-ascii?Q?3bTMoGD0sg5VNfEIQ0rhenYrgRLYMTWC4lBsxEbiLcGtaHNukZ2ZF62aRYV7?=
 =?us-ascii?Q?eJzSrOKouZYYR+K6XoNe8N9WPyUBDc4NQc79VtwiMBeMYt2FKuq4tE3R9sKR?=
 =?us-ascii?Q?J/4B3jTaJItYazq2cPxKvrzbGUi3vX8hO8dTTcr4Ry52LZe+cdlfN3A79W4F?=
 =?us-ascii?Q?PzodmaqBMFpMcDMEP4W4NfpKKykM/qSz8JBr2SqqNjPJRvMVwNdpsGbLU3Be?=
 =?us-ascii?Q?NoPreTSFB3LOTYaolQaT5SDxpz2ux9W8MkrUUaU4keEGD/VGnOXpax4jl2zd?=
 =?us-ascii?Q?ENiKDLL7K9IizXjms5zM5IuCzqxdTq4GwR4sEvq9zGHHCZ8xUnNZsq4YYks3?=
 =?us-ascii?Q?FAs/YzuYh+mc7PNR7UjUr1cZjQzEtZbS80OzwMWp1FRtlZXm+R1l0cYPll3H?=
 =?us-ascii?Q?i9L4mYv+ScO5rpjgEDArnLsfYg/8/b64saeRr8HMoa89NDSVLeXZWqGHaojP?=
 =?us-ascii?Q?1WewUkRetZ1qTVPJQXRvzMxNrUFAbknhaC2KEg2CVljXlt6WQGXlEXhO4zXV?=
 =?us-ascii?Q?kMgpQtYVMsYQ949aJ9juEJd94VyAkYYZpqJjnc0kj34p1eSUe0nFq9LwRWvm?=
 =?us-ascii?Q?wYQz4qPtbZCG1Lx88UUl721hYhHmON4mmft6ANvFqpIrza530zHIzdGAABBE?=
 =?us-ascii?Q?88xeHu/NyPHvcOjQJp7CbIAHvH8H3mfR58144DlIxKsfTtrgWhTk6mb8Gyli?=
 =?us-ascii?Q?/tRXRVYkRziy/ept/HMv5/qoYQZks8a/aKsMFBVc7b++femZQA4ZOg4q74z7?=
 =?us-ascii?Q?g3gCF7856sGCdtuALVS8MI3uAEzpW0oEJgD3i0W8Cr/IAqUyue2r7DVUf89o?=
 =?us-ascii?Q?F+XT52tsVNg6e0AUzv3wEqOJWWH3BzFL7rn5WBOSZGPMeOW9Z06oirsu39Ce?=
 =?us-ascii?Q?s98IOZ1Wh+gH4HzioxkgZlVQ3gs1T+12CvP6X5V2IHnP2pFfi+tfHzN766QD?=
 =?us-ascii?Q?XoweG0WquW4GasG19Tir8KnmdNibySmjEdvqWF8XIhIYIvmB48z7aMGjsXQ3?=
 =?us-ascii?Q?IxtmpaJKlwm6lVc3CptLulavb5bTdaHNPTSS0J+FTjjQd0pX6RhDBDJkW7LZ?=
 =?us-ascii?Q?x0XMhJ2YHuP9o0BIDqUcuAAKD8Dz1vq/BAFUTjlgB+mUCGxDJRRQGv7tP8Ai?=
 =?us-ascii?Q?MOJuwfPt6+6087j8yF7psky/pPyrBsNeiYoawBETrDM8PLFFRw0iKmtu4xLk?=
 =?us-ascii?Q?rB6RgCqVxindirEXhytO4q/a?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42443c23-1897-48f4-8b31-08d989b225f4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 16:47:28.5302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HcduKlXL3LcYApNgjnYbJuOK6jhbQbtD+glv4LxhzSYW6+h18ANMHmjJDvGsVHeZ61NTupfky3DhBXPJUoE8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit 6087175b7991 ("net: dsa: mt7530: use independent VLAN
learning on VLAN-unaware bridges"), software forwarding between an
unoffloaded LAG port (a bonding interface with an unsupported policy)
and a mv88e6xxx user port directly under a bridge is broken.

We adopt the same strategy, which is to make the standalone ports not
find any ATU entry learned on a bridge port.

Theory: the mv88e6xxx ATU is looked up by FID and MAC address. There are
as many FIDs as VIDs (4096). The FID is derived from the VID when
possible (the VTU maps a VID to a FID), with a fallback to the port
based default FID value when not (802.1Q Mode is disabled on the port,
or the classified VID isn't present in the VTU).

The mv88e6xxx driver makes the following use of FIDs and VIDs:

- the port's DefaultVID (to which untagged & pvid-tagged packets get
  classified) is 0 and is absent from the VTU, so this kind of packets is
  processed in FID 0, the default FID assigned by mv88e6xxx_setup_port.

- every time a bridge VLAN is created, mv88e6xxx_port_vlan_join() ->
  mv88e6xxx_atu_new() associates a FID with that VID which increases
  linearly starting from 1. Like this:

  bridge vlan add dev lan0 vid 100 # FID 1
  bridge vlan add dev lan1 vid 100 # still FID 1
  bridge vlan add dev lan2 vid 1024 # FID 2

The FID allocation made by the driver is sub-optimal for the following
reasons:

(a) A standalone port has a DefaultPVID of 0 and a default FID of 0 too.
    A VLAN-unaware bridged port has a DefaultPVID of 0 and a default FID
    of 0 too. The difference is that the bridged ports may learn ATU
    entries, while the standalone port has the requirement that it must
    not, and must not find them either. Standalone ports must not use
    the same FID as ports belonging to a bridge. All standalone ports
    can use the same FID, since the ATU will never have an entry in
    that FID.

(b) Multiple VLAN-unaware bridges will all use a DefaultPVID of 0 and a
    default FID of 0 on all their ports. The FDBs will not be isolated
    between these bridges. Every VLAN-unaware bridge must use the same
    FID on all its ports, different from the FID of other bridge ports.

(c) Each bridge VLAN uses a unique FID which is useful for Independent
    VLAN Learning, but the same VLAN ID on multiple VLAN-aware bridges
    will result in the same FID being used by mv88e6xxx_atu_new().
    The correct behavior is for VLAN 1 in br0 to have a different FID
    compared to VLAN 1 in br1.

This patch cannot fix all the above. Traditionally the DSA framework did
not care about this, and the reality is that DSA core involvement is
needed for the aforementioned issues to be solved. The only thing we can
solve here is an issue which does not require API changes, and that is
issue (a), aka use a different FID for standalone ports vs ports under
VLAN-unaware bridges.

The first step is deciding what VID and FID to use for standalone ports,
and what VID and FID for bridged ports. The 0/0 pair for standalone
ports is what they used up till now, let's keep using that. For bridged
ports, there are 2 cases:

- VLAN-aware ports will never end up using the port default FID, because
  packets will always be classified to a VID in the VTU or dropped
  otherwise. The FID is the one associated with the VID in the VTU.

- On VLAN-unaware ports, we _could_ leave their DefaultVID (pvid) at
  zero (just as in the case of standalone ports), and just change the
  port's default FID from 0 to a different number (say 1).

However, Tobias points out that there is one more requirement to cater to:
cross-chip bridging. The Marvell DSA header does not carry the FID in
it, only the VID. So once a packet crosses a DSA link, if it has a VID
of zero it will get classified to the default FID of that cascade port.
Relying on a port default FID for upstream cascade ports results in
contradictions: a default FID of 0 breaks ATU isolation of bridged ports
on the downstream switch, a default FID of 1 breaks standalone ports on
the downstream switch.

So not only must standalone ports have different FIDs compared to
bridged ports, they must also have different DefaultVID values.
IEEE 802.1Q defines two reserved VID values: 0 and 4095. So we simply
choose 4095 as the DefaultVID of ports belonging to VLAN-unaware
bridges, and VID 4095 maps to FID 1.

For the xmit operation to look up the same ATU database, we need to put
VID 4095 in DSA tags sent to ports belonging to VLAN-unaware bridges
too. All shared ports are configured to map this VID to the bridging
FID, because they are members of that VLAN in the VTU. Shared ports
don't need to have 802.1QMode enabled in any way, they always parse the
VID from the DSA header, they don't need to look at the 802.1Q header.

We install VID 4095 to the VTU in mv88e6xxx_setup_port(), with the
mention that mv88e6xxx_vtu_setup() which was located right below that
call was flushing the VTU so those entries wouldn't be preserved.
So we need to relocate the VTU flushing prior to the port initialization
during ->setup(). Also note that this is why it is safe to assume that
VID 4095 will get associated with FID 1: the user ports haven't been
created, so there is no avenue for the user to create a bridge VLAN
which could otherwise race with the creation of another FID which would
otherwise use up the non-reserved FID value of 1.

[ Currently mv88e6xxx_port_vlan_join() doesn't have the option of
  specifying a preferred FID, it always calls mv88e6xxx_atu_new(). ]

mv88e6xxx_port_db_load_purge() is the function to access the ATU for
FDB/MDB entries, and it used to determine the FID to use for
VLAN-unaware FDB entries (VID=0) using mv88e6xxx_port_get_fid().
But the driver only called mv88e6xxx_port_set_fid() once, during probe,
so no surprises, the port FID was always 0, the call to get_fid() was
redundant. As much as I would have wanted to not touch that code, the
logic is broken when we add a new FID which is not the port-based
default. Now the port-based default FID only corresponds to standalone
ports, and FDB/MDB entries belong to the bridging service. So while in
the future, when the DSA API will support FDB isolation, we will have to
figure out the FID based on the bridge number, for now there's a single
bridging FID, so hardcode that.

Lastly, the tagger needs to check, when it is transmitting a VLAN
untagged skb, whether it is sending it towards a bridged or a standalone
port. When we see it is bridged we assume the bridge is VLAN-unaware.
Not because it cannot be VLAN-aware but:

- if we are transmitting from a VLAN-aware bridge we are likely doing so
  using TX forwarding offload. That code path guarantees that skbs have
  a vlan hwaccel tag in them, so we would not enter the "else" branch
  of the "if (skb->protocol == htons(ETH_P_8021Q))" condition.

- if we are transmitting on behalf of a VLAN-aware bridge but with no TX
  forwarding offload (no PVT support, out of space in the PVT, whatever),
  we would indeed be transmitting with VLAN 4095 instead of the bridge
  device's pvid. However we would be injecting a "From CPU" frame, and
  the switch won't learn from that - it only learns from "Forward" frames.
  So it is inconsequential for address learning. And VLAN 4095 is
  absolutely enough for the frame to exit the switch, since we never
  remove that VLAN from any port.

Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- reach MV88E6XXX_FID_BRIDGED via MV88E6XXX_VID_BRIDGED, never via the
  port-based default FID. This way all switches in a DSA tree classify
  the same packet to the same FID, even though the FID isn't transmitted
  in the DSA tag.
- MV88E6XXX_VID_BRIDGED can be installed on shared ports as untagged
  too, no need to special-case it by making it unmodified.
- no need to put shared ports in the Fallback 802.1Q mode, because they
  don't need to look at an 802.1Q header, just parse the DSA tag which
  they always do.

v1->v2: patch is new

 MAINTAINERS                      |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c | 67 +++++++++++++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/chip.h |  3 ++
 include/linux/dsa/mv88e6xxx.h    | 13 +++++++
 net/dsa/tag_dsa.c                | 12 ++++--
 5 files changed, 80 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/dsa/mv88e6xxx.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6fbedd4784a3..632580791d2d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11147,6 +11147,7 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/marvell.txt
 F:	Documentation/networking/devlink/mv88e6xxx.rst
 F:	drivers/net/dsa/mv88e6xxx/
+F:	include/linux/dsa/mv88e6xxx.h
 F:	include/linux/platform_data/mv88e6xxx.h
 
 MARVELL ARMADA 3700 PHY DRIVERS
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d672112afffd..d7b29792732b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -12,6 +12,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/delay.h>
+#include <linux/dsa/mv88e6xxx.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_bridge.h>
@@ -1681,13 +1682,17 @@ static int mv88e6xxx_port_commit_pvid(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_port *dp = dsa_to_port(chip->ds, port);
 	struct mv88e6xxx_port *p = &chip->ports[port];
+	u16 pvid = MV88E6XXX_VID_STANDALONE;
 	bool drop_untagged = false;
-	u16 pvid = 0;
 	int err;
 
-	if (dp->bridge_dev && br_vlan_enabled(dp->bridge_dev)) {
-		pvid = p->bridge_pvid.vid;
-		drop_untagged = !p->bridge_pvid.valid;
+	if (dp->bridge_dev) {
+		if (br_vlan_enabled(dp->bridge_dev)) {
+			pvid = p->bridge_pvid.vid;
+			drop_untagged = !p->bridge_pvid.valid;
+		} else {
+			pvid = MV88E6XXX_VID_BRIDGED;
+		}
 	}
 
 	err = mv88e6xxx_port_set_pvid(chip, port, pvid);
@@ -1754,11 +1759,15 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 	u16 fid;
 	int err;
 
-	/* Null VLAN ID corresponds to the port private database */
+	/* Ports have two private address databases: one for when the port is
+	 * standalone and one for when the port is under a bridge and the
+	 * 802.1Q mode is disabled. When the port is standalone, DSA wants its
+	 * address database to remain 100% empty, so we never load an ATU entry
+	 * into a standalone port's database. Therefore, translate the null
+	 * VLAN ID into the port's database used for VLAN-unaware bridging.
+	 */
 	if (vid == 0) {
-		err = mv88e6xxx_port_get_fid(chip, port, &fid);
-		if (err)
-			return err;
+		fid = MV88E6XXX_FID_BRIDGED;
 	} else {
 		err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 		if (err)
@@ -2434,7 +2443,16 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
+
 	err = mv88e6xxx_bridge_map(chip, br);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_port_commit_pvid(chip, port);
+	if (err)
+		goto unlock;
+
+unlock:
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -2444,11 +2462,20 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 					struct net_device *br)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
 
 	mv88e6xxx_reg_lock(chip);
+
 	if (mv88e6xxx_bridge_map(chip, br) ||
 	    mv88e6xxx_port_vlan_map(chip, port))
 		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
+
+	err = mv88e6xxx_port_commit_pvid(chip, port);
+	if (err)
+		dev_err(ds->dev,
+			"port %d failed to restore standalone pvid: %pe\n",
+			port, ERR_PTR(err));
+
 	mv88e6xxx_reg_unlock(chip);
 }
 
@@ -2894,6 +2921,20 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
+	/* Associate MV88E6XXX_VID_BRIDGED with MV88E6XXX_FID_BRIDGED in the
+	 * ATU by virtue of the fact that mv88e6xxx_atu_new() will pick it as
+	 * the first free FID after MV88E6XXX_FID_STANDALONE. This will be used
+	 * as the private PVID on ports under a VLAN-unaware bridge.
+	 * Shared (DSA and CPU) ports must also be members of it, to translate
+	 * the VID from the DSA tag into MV88E6XXX_FID_BRIDGED, instead of
+	 * relying on their port default FID.
+	 */
+	err = mv88e6xxx_port_vlan_join(chip, port, MV88E6XXX_VID_BRIDGED,
+				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNTAGGED,
+				       false);
+	if (err)
+		return err;
+
 	if (chip->info->ops->port_set_jumbo_size) {
 		err = chip->info->ops->port_set_jumbo_size(chip, port, 10218);
 		if (err)
@@ -2966,7 +3007,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * database, and allow bidirectional communication between the
 	 * CPU and DSA port(s), and the other ports.
 	 */
-	err = mv88e6xxx_port_set_fid(chip, port, 0);
+	err = mv88e6xxx_port_set_fid(chip, port, MV88E6XXX_FID_STANDALONE);
 	if (err)
 		return err;
 
@@ -3156,6 +3197,10 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 		}
 	}
 
+	err = mv88e6xxx_vtu_setup(chip);
+	if (err)
+		goto unlock;
+
 	/* Setup Switch Port Registers */
 	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
 		if (dsa_is_unused_port(ds, i))
@@ -3185,10 +3230,6 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	if (err)
 		goto unlock;
 
-	err = mv88e6xxx_vtu_setup(chip);
-	if (err)
-		goto unlock;
-
 	err = mv88e6xxx_pvt_setup(chip);
 	if (err)
 		goto unlock;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 33d067e8396d..8271b8aa7b71 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -21,6 +21,9 @@
 #define EDSA_HLEN		8
 #define MV88E6XXX_N_FID		4096
 
+#define MV88E6XXX_FID_STANDALONE	0
+#define MV88E6XXX_FID_BRIDGED		1
+
 /* PVT limits for 4-bit port and 5-bit switch */
 #define MV88E6XXX_MAX_PVT_SWITCHES	32
 #define MV88E6XXX_MAX_PVT_PORTS		16
diff --git a/include/linux/dsa/mv88e6xxx.h b/include/linux/dsa/mv88e6xxx.h
new file mode 100644
index 000000000000..8c3d45eca46b
--- /dev/null
+++ b/include/linux/dsa/mv88e6xxx.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright 2021 NXP
+ */
+
+#ifndef _NET_DSA_TAG_MV88E6XXX_H
+#define _NET_DSA_TAG_MV88E6XXX_H
+
+#include <linux/if_vlan.h>
+
+#define MV88E6XXX_VID_STANDALONE	0
+#define MV88E6XXX_VID_BRIDGED		(VLAN_N_VID - 1)
+
+#endif
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 68d5ddc3ef35..b3da4b2ea11c 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -45,6 +45,7 @@
  *   6    6       2        2      4    2       N
  */
 
+#include <linux/dsa/mv88e6xxx.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <linux/slab.h>
@@ -164,16 +165,21 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 			dsa_header[2] &= ~0x10;
 		}
 	} else {
+		struct net_device *br = dp->bridge_dev;
+		u16 vid;
+
+		vid = br ? MV88E6XXX_VID_BRIDGED : MV88E6XXX_VID_STANDALONE;
+
 		skb_push(skb, DSA_HLEN + extra);
 		dsa_alloc_etype_header(skb, DSA_HLEN + extra);
 
-		/* Construct untagged DSA tag. */
+		/* Construct DSA header from untagged frame. */
 		dsa_header = dsa_etype_header_pos_tx(skb) + extra;
 
 		dsa_header[0] = (cmd << 6) | tag_dev;
 		dsa_header[1] = tag_port << 3;
-		dsa_header[2] = 0;
-		dsa_header[3] = 0;
+		dsa_header[2] = vid >> 8;
+		dsa_header[3] = vid & 0xff;
 	}
 
 	return skb;
-- 
2.25.1

