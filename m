Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8768D3F500A
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 20:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbhHWSDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 14:03:45 -0400
Received: from mail-eopbgr150081.outbound.protection.outlook.com ([40.107.15.81]:51841
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229627AbhHWSDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 14:03:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AP/EYRmf2TNp7hBk+n//KjuvZCU5e0MZzcUoq3BxNbsTIRtVpt6zC2cmtqNp1PJMKDzjv4E7yWOzJhuMBd4dqIRAHdsdcINaWh+Y7tN0HI0DUFYD7x5vXfHfWQ4JX7ebR/X8u/wy+/8veKA0ZolTPFIYjjcZHhQgL3gZEZ6TrLEUl/0KwAsbxiYlGlbKreiWdL956JjLdoi4jAHlVs7UMHRsHf7SQ64LwQku8lfleq40Sfw3ddMCdQ9iz3USMomFNFV5bVzq8Tq2hNwnODxFabENYzpssyjtb0bElJGr/0sTpMr51FmUhtd8GMaT/dm46U/de181IElbOYmEUAymjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZUaL8NswEwywS9x1m/xW6oY41vV6jq3b6R3Stif7Ek=;
 b=QUKKWCwuqa03G4pA5iv+OjqfO1Mn5JfCpv3HcnrwzDZP+Vil08k6QQNMOczzLz/2aqgjUDVLctrdj+beDa3M5rcT0N05sorI1Npuhws/WLXwT2jAVaBB9QUH/XoJnEo30o8VNmwyXOrrsSE6XrNWNFuZ7zv3aJL2P0AWqytwXpqIo2SFzgi6Oy7YEPasValCwCOnUEyvvfHur1t1weC3ECNbVysHw3saP4KucDFuO2LnmbuV9mHV3bBKM3VimwMX3mH+8AoRs4tyq4VLus6Wnxd5epVJ1SBkCi68i0gnxH9CzsSN2jduszL7/FXK0jo6Iv4cTUHhGnZP18Pix8+KAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZUaL8NswEwywS9x1m/xW6oY41vV6jq3b6R3Stif7Ek=;
 b=JsXu3yMysb0JZpc8cs6lv6U+VfvUlXAg8hOAemhJDmI9y/DuxmI/ypNpUXhsY7w/J/2Qi1s/AWHVlQoaChw0AtCcAsunr4/S3ZDeyMbgpVzJCYlX+xgLD+sC/MohoV+Mrhokrq483jEOnjXKHhWtSetbPM95eSnL6EjUWUYiTQ0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3070.eurprd04.prod.outlook.com (2603:10a6:802:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Mon, 23 Aug
 2021 18:02:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 18:02:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 0/3] Plug holes in DSA's software bridging support
Date:   Mon, 23 Aug 2021 21:02:39 +0300
Message-Id: <20210823180242.2842161-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P193CA0007.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM9P193CA0007.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 18:02:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0455aeef-0856-4839-4f23-08d966603cb3
X-MS-TrafficTypeDiagnostic: VI1PR04MB3070:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3070AE1508B24B603B07D801E0C49@VI1PR04MB3070.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rHpQFvb3nsjkhfRp5qZN7tUhTuugjMfT0FYMySACFC1KjcRT8SHSt3/XgiuDXs2vceanqJ1tpJPlgyDGWpl4oEcIfu+nYSgJ4a6LUx3j9cbWaw+WvrYw3SOytkbEo0iozKjK8XUUN0OwQCePhbTFKBXtT0+b892RP1OmtIvdFPsNT1eLNQeeqtCEUpwp74zoquwJ4CLrJR7gOMJxtkEVZvb44qhkTqTYCeuhNbOvjoPeXAdHaQ7UgcZOV6I3CFxWZU3Xk21kUIp/jRG629Q2uhpXnaMopK8xgpGOr3C2/XYbaL68LfscQZToFB/er6H2mnpFxjUY9oxvP7hmAR5gUkRcfxRS04DGRY28USH+fAody3g30+CoOJIqARoT0/WQy4CLfdKcMCO7HVnxNQNYASQVBhv/W1mi9Bm0j72f7r2IUAd6UQrUkZpN7yN2vtTcpQUTRD8lpOdao80uq15wt82N0RJFUeoL+H5WyoMnXN9j/sgZ+Bfcw4aUVVBnZX2UoSijKsH2UKghwOTiKCGIHSfH3PtGgoL6bdzqKcNnHSgy8rr0Sj45WW9SeosB6M3NELQw97OM09FA3zLYzUMX6b3Y9+ex7Zq+YeNaHzNg7X710BG8nUD4/c+1DXEa0ZgUe2p44kfMn60kUEYtLTEVA20sAFnETF8YS6eZt+MDEaMWz3Fg26MMLrUFX8uhFjPFYR6w1JVbOmOZ7RMJTA3e5Ib2z/2+U882ukmX0JlxiqwzFeqC6qLyEUUgML0bhqW8s0fIJ/OObtgy7JsxoFIS/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39850400004)(366004)(396003)(6486002)(966005)(1076003)(36756003)(44832011)(478600001)(2906002)(83380400001)(8936002)(6506007)(38100700002)(86362001)(38350700002)(4326008)(66476007)(66556008)(66946007)(186003)(6916009)(6512007)(5660300002)(6666004)(52116002)(26005)(54906003)(956004)(316002)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qi83amZaN2lHWVgzT1ZEK2xvQzcyWlp4WEI0dk9GMmhnRVpBVnI0MlF4NHk0?=
 =?utf-8?B?b1BmeFY0bVRJUWRsODNNZW9meDdoYXFDOGNteDNMV3BmMi9NcTNsZFg0UXlh?=
 =?utf-8?B?S2Jvc2pxa0F4ZVhPOW9XYnZrV2VyOUJoT29LMjBudGthaUQyZ1BHSEJtN3Bi?=
 =?utf-8?B?bVQ4QzhaU1dmL2tWeC9qTnVvNk1GTlU2R0pyVHg5K2pRYlhIbnR2aHJIUmV4?=
 =?utf-8?B?VHhLZkxKdG9Sd01aWkc0cjR1a1R5VTlGOGhvdTkvWUxzODROMzk0dGVWajBj?=
 =?utf-8?B?NXM2cFZYeTY4cnR4S1BzZnBOR1RRZXdRa3VhNzJ1NjBiQmh0MEZFdEdEc3dx?=
 =?utf-8?B?dWxYT2I3VnZuSWxRR3IvM05IalJEb1FIdWcxQ3Y4emQ3b000aWpzY2Qxelhq?=
 =?utf-8?B?SnNaQmMwOC9RWEtLRHlNbXo0TW9HSlpFd05INldFOGJZV3BWT3V2b1l5T3Bq?=
 =?utf-8?B?TXJPQ1VIQzdKMEhuVktoZ3FMVkZuOTZXTUdxZHY5dHlQc2lHWWFCR3RBaUpr?=
 =?utf-8?B?V1RjK2hpQnBsYUMwR1pzZ3ZpZWVFNUwxK0FNUjNUWnJ4UzZ6OWRCTXFDdnh2?=
 =?utf-8?B?M29qWmx6dkV3MlJvWXZ3ZW1Ic2dOMzVReG1EZWxZbjBEckRZMXNQOHo3VVhj?=
 =?utf-8?B?ZG1MRFhQWFFRazhwNlNjcko3ZVZmRVpobTBnaGVwVHcycEFaMHh2cXNvTk9y?=
 =?utf-8?B?b05iK1EwRksvdHRlTzIvbTNjTSt4NUJmNmVMZU5aWFhuLzljZUpiQjRHSFF3?=
 =?utf-8?B?cFE2NmRIWExPL3cwYUZId0JBMUdSTlBhcnJ0M2VlalVFWUMycmtaOUZHTlVD?=
 =?utf-8?B?RTVqM2RwMHdQQWlNQ29vWHpVUFJVRjdTbW1nVXdhaGEvZlF6YVBKc2Z4VDUz?=
 =?utf-8?B?eWZVZlh0NlhrU0RnRjNLZVRiQ0kyUHcyOW51VUFSMzk3VVV4Z3IwUzdFR1Jl?=
 =?utf-8?B?OVpsY1BWeGpKVE5TcDcrVWZRcHNTTlN0eEpVeDNIRlZzUlJxd0FtN1BjTkhI?=
 =?utf-8?B?RllIdlJkMXlTTWRvUXYvekZTbDM4VGcvaFdUN1ZHVUx4eDFGMnNGOVNsclVI?=
 =?utf-8?B?eUZidVRLQnllQVI4ZHpob2Q0TUNTTjIxQ253dEhzaEFScmVpbFJDSWJtZ2ZD?=
 =?utf-8?B?WHhsOUthODcxQVlPRW14VW50TGp2OEpFQUZQMDRpM0d5bldFU3ZRVjJEcDZ2?=
 =?utf-8?B?UW8yYVVGNnJMT0kxK3d1QXFoYmN1dCs4amRENUtwZUlCTlJqcU9nZFNuTEt1?=
 =?utf-8?B?K3pIYXZsRHg3MTY4TGcyK0lpMkthTFM0V1AveTBvUFI5Mm45d1lnNTY0bEtQ?=
 =?utf-8?B?TmNHVG9CcGNvWE43cWRNbkUvNTVYQUdRUVlWL1JzUTArMFRTVHV6QjQ1SGgx?=
 =?utf-8?B?dWxQSm9aeEVJSjJBY0I5NFRsTExVM0EwdDZFV2pvUE9TemwwSkkwd2VmMmd6?=
 =?utf-8?B?K2czTk5USkRHRjhnU0twcHZzWC84SzdINEtGVlhOZmdXM3hZWkZUTDR4dXR4?=
 =?utf-8?B?U2ZxQkFDOEJWeU5qSC9UTmVoT3VBV2hoNjJ5UEtQVHRiTGpwR3lkQWpLc1Ur?=
 =?utf-8?B?SUM5WTQxWGxsZjY3K1NjRzd0cXBqYnZJYVFRVXUzR2JDWjN1cFdNY0pxV1J2?=
 =?utf-8?B?VEp0M05JVVAwelVHS21rZ2RScTU5N3ZZQ3Q1ZWdMOFBEWFpaV2tmUnZvd201?=
 =?utf-8?B?TkdWWWhlRzh2N0JBbXRZeVliSE9aSWhlNVBOcDdpNy9sVFljeGRUTGlkcUlv?=
 =?utf-8?Q?E5EFAEel9V9YQjWOFOAwyflW1UkJpuanKaEYpMp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0455aeef-0856-4839-4f23-08d966603cb3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 18:02:58.1527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBQeEHHJ05Rnk+sTaKd5k/QjmDQecnDBZ0El9DwpKtVb8CIZMkY7vxLgUcDiH66Ptmxnlcrecxb288W9CDn6RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
# When a neighbor port joins a VLAN-aware bridge, VLAN filtering gets
# enabled globally on the switch. This replays the VLAN 100 from
# sw0p2.100 and also installs VLAN 1 from the bridge on sw0p0.
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
# And now the standalone port is not filtering anymore.
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

Vladimir Oltean (3):
  net: dsa: properly fall back to software bridging
  net: dsa: don't advertise 'rx-vlan-filter' when not needed
  net: dsa: let drivers state that they need VLAN filtering while
    standalone

 drivers/net/dsa/hirschmann/hellcreek.c |  1 +
 include/net/dsa.h                      |  3 +
 net/dsa/dsa_priv.h                     |  2 +
 net/dsa/port.c                         | 42 +++++++++++++-
 net/dsa/slave.c                        | 79 +++++++++++++++++++++++++-
 net/dsa/switch.c                       | 27 ++++++---
 6 files changed, 143 insertions(+), 11 deletions(-)

-- 
2.25.1

