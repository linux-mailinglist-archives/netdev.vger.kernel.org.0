Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319C2421B02
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 02:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhJEASK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 20:18:10 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:42500
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230017AbhJEASF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 20:18:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBRUnGFEKmc9VvhuJ+CbMmGDD/Y70qRgxMk3vaTel+mIKbUce4gN9ldbcmElEuxE2mNtlCAj1GIQkiC5ID+u6ehwUXxJRZ7iD36QEHIcrn/SCU6ugCDP4RRzQIYovX6nfg2xBYryp91X0o+VICaeROKHJY+nJ6VwnjZd/nyzr6m6l4FSlqnLmKvf0Sx2Nq23cATEFfRVKbLc2LciOjHEu8uKpVf7kFB1+1+bl89vVflRWb/djww5rVCLg7K+x8YpZUImIyr81E8XhCqHfdCYt7tAIJdSZ4Fxo0p6T3LF5Ol/P7dGO6Nb0ZZeRFkLIpdkdjZegoJOeUILpzX/VfG3vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNuY4FtazQEZhVDHR/3yeErKKsjjh8esOvhLWWJIsao=;
 b=V/+M4MVbFnjY1ZP+LZ2vvy2JJKcQDJ0ABm8qE/a18EYFwv8rNTA0D+BIVdmv73qNa8pq3lZpYIj2s5rfDz63UaQ6D49lDGkbXEsyafP3qWbFun7dHMMk24z8WV8r5q6hhTFipaYyB+3JO9b5pKKsSRlKNTUj6d9B/g0xgu/D7EhC4ayLo3FioKFuCbOuAZcs6hx5sH6N6yqAOm2Wv2d5AIJIjLeESf1z479Xfp6q1634q/yCb6y5RjRcJ3gmto72+H3kIfCRXpn698pGMdYLYnBF+HcVye3dGH4V99MGWbcUJm9q16GTmFKtN3glF7EExoLUXuM2W7kLFH3gDDoGqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNuY4FtazQEZhVDHR/3yeErKKsjjh8esOvhLWWJIsao=;
 b=f+SE4gYc+1rYbAsQQG/xo/tkYpcSY0GZgHJf5HTAUta4AWbmzSIoPMKohcQSSc3Y3bu3rqbZL3K2zWUo00UivAOuac3hd7+0DfQhwXw07KHH2ETHIvFhLVU98xTcKcp5zwUKWPU6r7w0To11U4kLgBOELsHOm05qh8c2JCBCT+A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 00:16:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 00:16:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v2 net 4/4] net: dsa: mv88e6xxx: isolate the ATU databases of standalone and bridged ports
Date:   Tue,  5 Oct 2021 03:14:14 +0300
Message-Id: <20211005001414.1234318-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
References: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0107.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM6P192CA0107.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 00:16:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54e40d66-a9bc-4ffc-b566-08d9879556e0
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-Microsoft-Antispam-PRVS: <VE1PR04MB73437A6EDAB0900B3E2E60F8E0AF9@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 23KhbGddisHa9LvCSiim6hLKhqv+wC/AbZD2+J1VyaLuO9dURtRfeoSXeyS+QC//8FGmQArVU8LTSql/YS3J9PKhzD94l6effc2q1VdRCWdbCB9r0g+ViFRf6pGrGkr0AU+d8r97q3AC55oHxl31400yKec5kZSiQttwGZCzzpbFQA3SSdXjuUnyHqDlUA7YWNCJs+p/1KaqTjsOBSO9inJ4yQO32ZkT0LSwSTN2sjj8QD5pgqmSedLMKUmMP9j10H3W5jHb8qSrvE2bAzrYggppyG/16EirH6Qp+0InUX/f0Esj0RtT3mr2xtnxpmkMpTlWT9VhwtruRNMghX2ka6UYgmZW28FtT2cRMQH2yvmTa4FCFyPH93+tam6o/aAiobmXXCgxahH8c6FC7QAWwy/KbjqcZWZQGxxou2+zuxZFaQ0I62ZW78gWnlXLgXgk2NRc4nhv9pTbZGsA9omcM+aQ3JHITjabcLHNPgWATTNEbD3j1bInhh6yq6Jo7Xl8Jc76XMBj9zUC1satCfJNlcPUW5aDlMblNG3Xq9nw7+4r6I0dMlKQoILDoMT2YO+LYDndLk5a1Q/WhTgn1juwTXWxXFYai0+jIcd+g1g3byJd5FKc3DC3KCunYC8T3FeLEp9/WWqFlJnfSU8Yh6BAWilOS0K/rIB4QeEcquZ+RPeoZN8rNqew9ikq1JOcwqmPntQsBq7e0FYXhoWOxAr6yYtW8utI+bBUtwxZF/1Fz/E3TMzFdnHei7Fbp0IewvoM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8936002)(2906002)(6506007)(110136005)(52116002)(54906003)(5660300002)(316002)(508600001)(8676002)(44832011)(66946007)(186003)(86362001)(30864003)(66476007)(4326008)(956004)(26005)(83380400001)(2616005)(6486002)(1076003)(38350700002)(6512007)(38100700002)(66556008)(130980200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SUrCnuW0YoVGv9RFwoWNJKeRhysBp82dLi4lAhEG2DtrImFAVKVvhF+D+9lz?=
 =?us-ascii?Q?MBORM67qy+mBdJiGvEHjFqgdcy1t1sfoMKVERi6INP5806e9m4bsqbM7h4xA?=
 =?us-ascii?Q?EUfG7oMRNFoBmML7nsXpdpn5MUCaoSNmazZISi3EEwwJ7qeJLae2iefXA23U?=
 =?us-ascii?Q?mQ+2WwndpqmIVetNeBAgU2rA2NcXsudF41y3wb63ARg09WHeA+T4+JntlIvY?=
 =?us-ascii?Q?xpYVPYbtcRmoyIldMZ75d6lsGjydGJaIDBXMsgejold1gQDa7awBbeTgw12+?=
 =?us-ascii?Q?2Ufhl+V7VwSmG7WpcKWG3Zz0b9ZIthWrxXFXaGhy6ItdUBJsTBZ2oH5ZGGPC?=
 =?us-ascii?Q?RTQTgbQAGzOVWHad6WihYL+eIVfElLAeEKimQIRyIKkJvmlES733FZnLqzib?=
 =?us-ascii?Q?B2sM14rH7iBzuMZyGxj3hNipYe0SnD4n3QgbY/OgQdighC95zykVqnl2aHKQ?=
 =?us-ascii?Q?u6+eTz0CZFJ17POG6+D1OX7g8eC82SO+77dTGrblhXAU7mJMAePbI2Ggrg3j?=
 =?us-ascii?Q?EAEslFClO80mvqw24785a5RYILFMHHVZkG3A0NQ+xo8r6D6tiSyetvHCY0AG?=
 =?us-ascii?Q?tkt/ry77TiZMTHovFpf1Uucs98oAzNKvua9Kr+YwP08d0UAXzJD0Yw4dm0xz?=
 =?us-ascii?Q?QdQfEtWO3eljMHuBAQGagP8MiEyN5C/LjtasZorrxch4fc7V7Vq/brVtvU2y?=
 =?us-ascii?Q?4+KTQUCKlO/rxXd0rKmV6Efu2Kl1TLRWyTa2ec8+HAG8E33Hr6HsiJyid4yH?=
 =?us-ascii?Q?K3b7HcMvcrrE49Ux1pIs3B0wGCw95GICq0W6J+z/51/y7p0zpPYVw3SHIrO8?=
 =?us-ascii?Q?blw909vbWwIOiU2WojnCQRs8LqsWLJfI7SzyXS1mKtDJdqgLxO2NhS1ut+lt?=
 =?us-ascii?Q?A4zATyvIJUiI4kGhl1eIv99ulh8Li6iduO1xbGxzgrCnNPWifTPLf7FoZ/sn?=
 =?us-ascii?Q?vUMNtknmNdxPH2KzsaNkyNZe22z9jfn9HHUilGSaXg4IbIinnVvycfk9GGPY?=
 =?us-ascii?Q?Qk7kQ9hpjISTFqxE7o5MUb3ndGur7pXwQrHzn+7OYGeafdPSKD8HZJRJgO8+?=
 =?us-ascii?Q?yJZsvdQ2J807gkuT+0R4Gwqoo9dhJ5Ogz/YYr2m2RgSRdgcKzZa+eljAZ/Gb?=
 =?us-ascii?Q?Y6dzkuxBOYOSId81ugYYwareIdCOOhVLrDFbtiL1N0lpV/+JKp2o1h1ja8MY?=
 =?us-ascii?Q?IELEQdk88M1QAynbtTqTr8YUhssXvQL8xA1EZXcNFWV1I8/0HIcBXaCYgeLh?=
 =?us-ascii?Q?i2X6T57jAx71v4wjrNua5WwZElr0Gzm3igzpuE4m8v1KWgD+UYKlPg8p1+2R?=
 =?us-ascii?Q?ANWdFeq8iw6QRyWlWRDTC23X?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e40d66-a9bc-4ffc-b566-08d9879556e0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 00:16:12.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ClAUDK/v04JYAUDNW9/f3QFGFbNDWSSt3wsfQcPr1nK84d+xiEA/tQEPgp4aGBQT47dWrdMSobrzp/jYNvO1QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
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
  classified) is absent from the VTU, so this kind of packets is
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
    entries, while the standalone port may not, and must not find them
    either. Standalone ports must not use the same FID as ports
    belonging to a bridge. They can use the same FID between each other,
    since the ATU will never have an entry in that FID.

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
issue (a).

The first step is deciding what VID and FID to use for standalone ports,
and what VID and FID for bridged ports. The 0/0 pair for standalone
ports is what they used up till now, let's keep using that. For bridged
ports, there are 2 cases:

- VLAN-unaware ports will end up using the port default FID, because we
  leave their DefaultVID (pvid) at zero (just as in the case of
  standalone ports), a VID which is absent from the VTU.

- VLAN-aware ports will never end up using the port default FID, because
  packets will always be classified to a VID in the VTU or dropped
  otherwise. The FID is the one associated with the VID in the VTU.

Having that said, any value will do for the FID of VLAN-unaware bridge
ports, but we choose 1 because it comes after 0.

So on ingress from user ports that are under a VLAN-unaware bridge,
tag_dsa.c will see a packet with VID 0 and FID 1. So for the xmit to
look up the same ATU database, we need to xmit in FID 1 as well.

Because CPU and DSA ports are shared ports, we need to be smarter about
the way in which we classify a packet to FID 1, we can't just rely on
the port default FID. The only way in which that appears possible is by
enabling the 802.1Q Mode on the shared ports (currently it is disabled),
so as to let the switch derive the VID from the skb, and then the FID
from the VID. We choose the least strict 802.1Q mode, Fallback, which:

- if the ingress frame's VID isn't in the VTU
  -> doesn't drop it
  -> forwards it according to the ingress port's forwarding matrix
  -> classifies it to the DefaultVID (=> port default FID)

-> if the ingress frame's VID is in the VTU
  -> forwards it according to the ingress port's forwarding matrix AND
     the mask of ports that are members of that VID
  -> classifies it to that VID (=> its associated FID in the VTU)

But to get the desired effect of classifying some packets to FID 1 on
xmit, we need to install a VID in the ATU which maps to that FID. We
choose VID 4095, because the bridge cannot install a VID with that value
so nobody will notice. We install VID 4095 to the VTU in
mv88e6xxx_setup_port(), with the mention that mv88e6xxx_vtu_setup()
which was located right below that call was flushing the VTU so those
entries wouldn't be preserved. So we need to relocate the VTU flushing
prior to the port initialization during ->setup(). Also note that this
is why it is safe to assume that VID 4095 will get associated with FID 1:
the user ports haven't been created, so there is no avenue for the user
to create a bridge VLAN which could otherwise race with the creation of
another FID which would otherwise use up the non-reserved FID value of 1.
Currently mv88e6xxx_port_vlan_join() doesn't have the option of
specifying a preferred FID, it always calls mv88e6xxx_atu_new().

mv88e6xxx_port_db_load_purge() is the function to access the ATU for
FDB/MDB entries, and it used to determine the FID to use for
VLAN-unaware FDB entries (VID=0) using mv88e6xxx_port_get_fid().
But the driver only called mv88e6xxx_port_set_fid() once, during probe,
so no surprises, the port FID was always 0. As much as I would have
wanted to not touch that code, the logic is broken when we add a new
FID which is not the port-based default. Sure, FID 1 is the default FID
for bridged ports, but the host-filtered FDB entries which are installed
by DSA on the shared (DSA and CPU) ports should be installed in FID 1,
not in FID 0, but FID 1 is not the port default FID on the shared ports.
So we need to recognize that is more correct to simply hardcode FID 1 in
mv88e6xxx_port_db_load_purge() and revisit when we have FDB isolation in
the DSA API.

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
v1->v2: patch is new

 MAINTAINERS                      |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c | 59 +++++++++++++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/chip.h |  3 ++
 include/linux/dsa/mv88e6xxx.h    | 13 +++++++
 net/dsa/tag_dsa.c                | 12 +++++--
 5 files changed, 73 insertions(+), 15 deletions(-)
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
index d672112afffd..0aa7e4394aab 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -12,6 +12,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/delay.h>
+#include <linux/dsa/mv88e6xxx.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/if_bridge.h>
@@ -1754,11 +1755,15 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
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
@@ -2434,7 +2439,16 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
+
 	err = mv88e6xxx_bridge_map(chip, br);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_port_set_fid(chip, port, MV88E6XXX_FID_BRIDGED);
+	if (err)
+		goto unlock;
+
+unlock:
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -2446,9 +2460,14 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 
 	mv88e6xxx_reg_lock(chip);
+
 	if (mv88e6xxx_bridge_map(chip, br) ||
 	    mv88e6xxx_port_vlan_map(chip, port))
 		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
+
+	if (mv88e6xxx_port_set_fid(chip, port, MV88E6XXX_FID_STANDALONE))
+		dev_err(ds->dev, "failed to restore port default FID\n");
+
 	mv88e6xxx_reg_unlock(chip);
 }
 
@@ -2823,8 +2842,8 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
+	u16 reg, mode, member;
 	int err;
-	u16 reg;
 
 	chip->ports[port].chip = chip;
 	chip->ports[port].port = port;
@@ -2889,8 +2908,24 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	err = mv88e6xxx_port_set_8021q_mode(chip, port,
-				MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED);
+	if (dsa_is_user_port(ds, port)) {
+		mode = MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED;
+		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNTAGGED;
+	} else {
+		mode = MV88E6XXX_PORT_CTL2_8021Q_MODE_FALLBACK;
+		member = MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED;
+	}
+
+	err = mv88e6xxx_port_set_8021q_mode(chip, port, mode);
+	if (err)
+		return err;
+
+	/* Associate MV88E6XXX_VID_BRIDGED with MV88E6XXX_FID_BRIDGED in the
+	 * ATU by virtue of the fact that mv88e6xxx_atu_new() will pick it as
+	 * the first free FID after MV88E6XXX_FID_STANDALONE.
+	 */
+	err = mv88e6xxx_port_vlan_join(chip, port, MV88E6XXX_VID_BRIDGED,
+				       member, false);
 	if (err)
 		return err;
 
@@ -2966,7 +3001,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * database, and allow bidirectional communication between the
 	 * CPU and DSA port(s), and the other ports.
 	 */
-	err = mv88e6xxx_port_set_fid(chip, port, 0);
+	err = mv88e6xxx_port_set_fid(chip, port, MV88E6XXX_FID_STANDALONE);
 	if (err)
 		return err;
 
@@ -3156,6 +3191,10 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 		}
 	}
 
+	err = mv88e6xxx_vtu_setup(chip);
+	if (err)
+		goto unlock;
+
 	/* Setup Switch Port Registers */
 	for (i = 0; i < mv88e6xxx_num_ports(chip); i++) {
 		if (dsa_is_unused_port(ds, i))
@@ -3185,10 +3224,6 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
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

