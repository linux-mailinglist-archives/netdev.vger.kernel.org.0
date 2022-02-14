Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0984B5E46
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiBNXcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:32:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiBNXcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:32:14 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC817107A94
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:32:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtKV68tQYu8whyWd1oD2v99zCKbgUabgCrzTWqp5jm4yVgvXEKLssT6ALSLovCq0cI9RBE3HzXOfNm0vqn03lfa/DKv8VgI7mt7hh6fTurGyNo30kqycw62W80OsCSp18z/cec/XGejZyGAGvbrR/tPdpP0nEh6m5BSkEFjJhsmTwjNALLdIlz6YLQ9T6LJPdG2JflBg6qHhRmPcLY4pk9y7eiEVJisaYcdDJLYsr2nIN7I1WWtW0KJjTukWwtYC4zMGsEx8A3W6h3UyS096N04v4OMjRGJgpEOY+2N01CRXPu5CTUltpE68X4Qd71kQUdBOI19N+sP/bmlXjK2GVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2NCOSaBTQ8GmJ5+jvV2NG78eIwps/hyoFLkjYGzeU8=;
 b=UzHIuSfWZwjVjDomUTBqppxz9JZiHmf5PHkk5zhpHyAvMP3hRkU/RSCETLisuEPAukw2ni9E6OV+Yc5alyn7HSFWQ+ccV67hxlK7GJmKFwg45tvrIUQcXwAFk2s49UlOpgmZyFlGENkoDXdK7J77dwkPt7V0UUEjthkgUy5fsFyn5JqxP2dEs7I11EoVa+A9zw2jEIgWP/sEmg+tei1O7nmWNmfuQOslg2LJjzuGwfvAl/vECGYm7d3FnCJFo6rl9wriJ6wdjfGbJc6Bs4oxZUAGEkSK/fDgp80rPqQ2MDxiDZDqqKurQnauNcQ7LAYkrUuWuvlCM9uMvTFVmBQkVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2NCOSaBTQ8GmJ5+jvV2NG78eIwps/hyoFLkjYGzeU8=;
 b=F7oJAvPXUF17lPYK9KEyDSl9cOIU05hGa02i2wLnG9AbunMtVlw0go+CJYCvmysRj6jvrs3ML7YNjyCFbvSdw/YCTB8mi/UNPPjx04u+6IZ7vQkOLSOzQiAR/mKCsl56/s9n4o0k8/UGyic/c5HPUFYjl9GJT7b0IacodzlnRVg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 23:32:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:32:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 0/8] Replay and offload host VLAN entries in DSA
Date:   Tue, 15 Feb 2022 01:31:03 +0200
Message-Id: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0377.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2d520f0-1a57-445a-eb43-08d9f012341c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504D020053898D41FF1C692E0339@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7hQ2I3nGLaIFRd5qHYrnAleUIJy/LVzy3251YGc6hiMzmfwR5OUUkaEoA1gKP3DzQXLpOGpIrvcYZ44sPKgSaeHkuqSfBt68lZtQuoffLa3ZqtDBhJEjtaFKsfvO8y0FuvSNUWRihsY+kB3kzYQBCyQL2k9dxWLm8QUlOO3Lso2OZtnif6aBxXFaMGHZGDyeEW8xya5jba7YXFgYbe8N8pa1psjpMSBlKc2ci5/bDZwpH6tHf7zK98IR+TyhFUlNdg1jGJ7T+wyv207YAgS1fjfDC0K1vbU4KDWW/CEv1OjciCcUM4H5OT01cKpe7S33+vw4OlcpdGlRRffFNkwnbNUAL/Rm+dJAYtLZolkoz3T1LfhRKAcH2kdV86AmjKTvJMgmyOUAQNWSV3xyUsRPQfcufHMhPzsnKu/q6oz13GxTcPmLNGMO+BsKWaiNI44dqNrSyc2fZ8kyA/ds9j71QNtm9V1IjuM8Weswj9wqYJ3mMv97pyw7L5qOhrvIaRYE83c75z7LnMFyXze0IR16Qp6CSfj285azTu9JUf5mFneWILSRyIJkbBOULmEWNxkbV3G4dg/AcTSTS+EmPcEtPgP+dpTYBdYCPTudU8DH21KP6kH9rKVLcMZczxUeAg+DiUfFLBPxVMVtxNnjeAUJFvW1xoRYzjRyNSsbVPT5a+5re2WLglTzzvRzwGkc4g858aa9zNZYcJrenQ7If+jRMyCl7PaVaQ/gJyGywY/wi470gMT9xbuX8d3ZQB//4m6hf2r+ZnS1Kvi0B96of8dm5gLjYD+c+wVqAwsCevN+ryc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(66556008)(6512007)(2616005)(54906003)(508600001)(6506007)(52116002)(966005)(6486002)(8676002)(6916009)(2906002)(4326008)(44832011)(36756003)(83380400001)(316002)(26005)(186003)(1076003)(66476007)(86362001)(38350700002)(38100700002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iQZptRzciy6A2G5N9BA0nkqxt0nOoxb5W1Lue88Fp+EEbvYDV99H3bVm3agH?=
 =?us-ascii?Q?wOAw5KyeN8+9g41ApclKbH/XrjN+GjHq5VZcGVcnC2ztCywx53fJCVIGThlM?=
 =?us-ascii?Q?9NDgZgdInFQhes5PF/zYS3bQ73nvTLjGnx8cHitI+DYqGqRXbTpvtcABjl5l?=
 =?us-ascii?Q?NYaZCl/26BEHNt8tB1356FQ/jOE0mEcOA06tooI07prkMGxaIsVTa6gefimH?=
 =?us-ascii?Q?NMm2O0KYJMrv60gTE8CUzQM/g2PCQKu19fwN+i7is0V7ji17n2wVNEJvNI5V?=
 =?us-ascii?Q?nOaCnVWGUPQMljg568dFC2RZLs04JIea4mKsR7Xo50HiEtDu03+G2z0kt+ZV?=
 =?us-ascii?Q?KJ9mB2Yd6X9Wfu5Lv/mmQ/m8G7fr+ETGLs+eQMIK7hk02nNkK5rR6CLh8jTl?=
 =?us-ascii?Q?+EaH8IWs9xBUUGb3tSB8E4R1mVTJaFYRCIOqKI4Fyl6IIaFvPJj293wdJR3P?=
 =?us-ascii?Q?4K2fvnL+s/r27caZ+zaj+yJZC7ahITHuPU7qTqvA/OZa+ol4fsH6lakdyDj+?=
 =?us-ascii?Q?lclNVY/zLTRBNI+T+TCnD6cNwfU/1D6zXuXATq2m1nKOR6AQ//gK99tT5uCT?=
 =?us-ascii?Q?cvBoC0/k58e9j6geozg+bBtNfBwBadQnGnyzU9fRudQ0shutaz6k9de86k/Y?=
 =?us-ascii?Q?f8tVXMcbV6q5xlxHYuft0YcKW3IlNrvEs60Hn+HXaXLGxv6zoKeeRlG+Mai8?=
 =?us-ascii?Q?NxF9D5EFTtX4Pe/NvZ1+kveh0Z9dpTFf4CZDk0vj7tl4ytwX6CfqLbuuWJjJ?=
 =?us-ascii?Q?iMP4xKGoyKDMHzREOn19GjuwBOKDeRcqo7NgJpsWCEMRURCuuEQ7NqAlqdIb?=
 =?us-ascii?Q?90jHUCFmFh5JXI2FF4Fb9gEVFLngu8OTxj0Gxu8WR5Bq+MMjuSuP6IyHuEja?=
 =?us-ascii?Q?FA3/7nD1FF8ZPE3s86ACsNYSpW62kDwgYWT3jfv7YT5MUWabFXoGNru5OdF3?=
 =?us-ascii?Q?Sl4wlE+IoIlu6hlm1BYBwp7gEVNczIPEwZ4IzTgn34Nf1J44ngt/Xh1087dQ?=
 =?us-ascii?Q?lPaReAFMktZpgPJWzeIf3lO5Q6teqXR1HQjJLsjDHCOo/Bs8JQaL3P2WiAxn?=
 =?us-ascii?Q?VDsWnivFFkTUkclNW6HE276JTEAbqOTmvAAkXWUsjjmroPRzFrYL+3kXiEkG?=
 =?us-ascii?Q?xPArPUWgjgt1WqknC/UMFgQZzH8MH6FABtN5WVF1iryY3NcO/i2ooYNxNUAP?=
 =?us-ascii?Q?Ugx+DpDbv57Rsn2pLxtAbSCddu+71YR205L/yLGOEjLdjQNfo+kmlrQYaaNf?=
 =?us-ascii?Q?NMi5MFWOFG/mrJb6Z68Nzyamn7oBLxEURzgXrXVIjVpvEj35PFqn5cl/kOAt?=
 =?us-ascii?Q?WE8YSrf54NEL5yh9MFA6mEsZ3zItm67Lz2e44jYOXG0JHUxXD1tnPEGcwAx9?=
 =?us-ascii?Q?4C2lAfU7kfjQ+lnNoB1f1j10R9tL7rp525/8MgSkVPs9loAdTIYAFsxRPxU5?=
 =?us-ascii?Q?yrC0cgm+DCP/y+295s03tmSogGifag70QAhEWdItUQwur2t0tn2vWp5jSEYr?=
 =?us-ascii?Q?wGFWTXUBRMyvRnoCskTqFu6bZhignrsiLBevnUmO4mSWuUMlz8uujmSdFQi4?=
 =?us-ascii?Q?cz/EBaZPSUIZIx8Ywexy9P3WYAoVGCY61Y2gqgy1HpfTsG7ep5aTlUXgolwR?=
 =?us-ascii?Q?hx+PT9cNFze9ZjtrBz5vG10=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d520f0-1a57-445a-eb43-08d9f012341c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:32:02.5742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KtmjoqBXMhPz0VCSo8cdyvUrAShaCGnbkniqDu9ppaRETTPUqnnvY+t2BpJHjk2KFgDMgisnr6Y4Ss3q58WVsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1->v2:
- prune switchdev VLAN additions with no actual change differently
- no longer need to revert struct net_bridge_vlan changes on error from
  switchdev
- no longer need to first delete a changed VLAN before readding it
- pass 'bool changed' and 'u16 old_flags' through switchdev_obj_port_vlan
  so that DSA can do some additional post-processing with the
  BRIDGE_VLAN_INFO_BRENTRY flag
- support VLANs on foreign interfaces
- fix the same -EOPNOTSUPP error in mv88e6xxx, this time on removal, due
  to VLAN deletion getting replayed earlier than FDB deletion

The motivation behind these patches is that Rafael reported the
following error with mv88e6xxx when the first switch port joins a
bridge:

mv88e6085 0x0000000008b96000:00: port 0 failed to add a6:ef:77:c8:5f:3d vid 1 to fdb: -95 (-EOPNOTSUPP)

The FDB entry that's added is the MAC address of the bridge, in VID 1
(the default_pvid), being replayed as part of br_add_if() -> ... ->
nbp_switchdev_sync_objs().

-EOPNOTSUPP is the mv88e6xxx driver's way of saying that VID 1 doesn't
exist in the VTU, so it can't program the ATU with a FID, something
which it needs.

It appears to be a race, but it isn't, since we only end up installing
VID 1 in the VTU by coincidence. DSA's approximation of programming
VLANs on the CPU port together with the user ports breaks down with
host FDB entries on mv88e6xxx, since that strictly requires the VTU to
contain the VID. But the user may freely add VLANs pointing just towards
the bridge, and FDB entries in those VLANs, and DSA will not be aware of
them, because it only listens for VLANs on user ports.

To create a solution that scales properly to cross-chip setups and
doesn't leak entries behind, some changes in the bridge driver are
required. I believe that these are for the better overall, but I may be
wrong. Namely, the same refcounting procedure that DSA has in place for
host FDB and MDB entries can be replicated for VLANs, except that it's
garbage in, garbage out: the VLAN addition and removal notifications
from switchdev aren't balanced. So the first 2 patches attempt to deal
with that.

This patch set has been superficially tested on a board with 3 mv88e6xxx
switches in a daisy chain and appears to produce the primary desired
effect - the driver no longer returns -EOPNOTSUPP when the first port
joins a bridge, and is successful in performing local termination under
a VLAN-aware bridge.
As an additional side effect, it silences the annoying "p%d: already a
member of VLAN %d\n" warning messages that the mv88e6xxx driver produces
when coupled with systemd-networkd, and a few VLANs are configured.
Furthermore, it advances Florian's idea from a few years back, which
never got merged:
https://lore.kernel.org/lkml/20180624153339.13572-1-f.fainelli@gmail.com/
v2 has also been tested on the NXP LS1028A felix switch.

Some testing:

root@debian:~# bridge vlan add dev br0 vid 101 pvid self
[  100.709220] mv88e6085 d0032004.mdio-mii:10: mv88e6xxx_port_vlan_add: port 9 vlan 101
[  100.873426] mv88e6085 d0032004.mdio-mii:10: mv88e6xxx_port_vlan_add: port 10 vlan 101
[  100.892314] mv88e6085 d0032004.mdio-mii:11: mv88e6xxx_port_vlan_add: port 9 vlan 101
[  101.053392] mv88e6085 d0032004.mdio-mii:11: mv88e6xxx_port_vlan_add: port 10 vlan 101
[  101.076994] mv88e6085 d0032004.mdio-mii:12: mv88e6xxx_port_vlan_add: port 9 vlan 101
root@debian:~# bridge vlan add dev br0 vid 101 pvid self
root@debian:~# bridge vlan add dev br0 vid 101 pvid self
root@debian:~# bridge vlan
port              vlan-id
eth0              1 PVID Egress Untagged
lan9              1 PVID Egress Untagged
lan10             1 PVID Egress Untagged
lan11             1 PVID Egress Untagged
lan12             1 PVID Egress Untagged
lan13             1 PVID Egress Untagged
lan14             1 PVID Egress Untagged
lan15             1 PVID Egress Untagged
lan16             1 PVID Egress Untagged
lan17             1 PVID Egress Untagged
lan18             1 PVID Egress Untagged
lan19             1 PVID Egress Untagged
lan20             1 PVID Egress Untagged
lan21             1 PVID Egress Untagged
lan22             1 PVID Egress Untagged
lan23             1 PVID Egress Untagged
lan24             1 PVID Egress Untagged
sfp               1 PVID Egress Untagged
lan1              1 PVID Egress Untagged
lan2              1 PVID Egress Untagged
lan3              1 PVID Egress Untagged
lan4              1 PVID Egress Untagged
lan5              1 PVID Egress Untagged
lan6              1 PVID Egress Untagged
lan7              1 PVID Egress Untagged
lan8              1 PVID Egress Untagged
br0               1 Egress Untagged
                  101 PVID
root@debian:~# bridge vlan del dev br0 vid 101 pvid self
[  108.340487] mv88e6085 d0032004.mdio-mii:11: mv88e6xxx_port_vlan_del: port 9 vlan 101
[  108.379167] mv88e6085 d0032004.mdio-mii:11: mv88e6xxx_port_vlan_del: port 10 vlan 101
[  108.402319] mv88e6085 d0032004.mdio-mii:12: mv88e6xxx_port_vlan_del: port 9 vlan 101
[  108.425866] mv88e6085 d0032004.mdio-mii:10: mv88e6xxx_port_vlan_del: port 9 vlan 101
[  108.452280] mv88e6085 d0032004.mdio-mii:10: mv88e6xxx_port_vlan_del: port 10 vlan 101
root@debian:~# bridge vlan del dev br0 vid 101 pvid self
root@debian:~# bridge vlan del dev br0 vid 101 pvid self
root@debian:~# bridge vlan
port              vlan-id
eth0              1 PVID Egress Untagged
lan9              1 PVID Egress Untagged
lan10             1 PVID Egress Untagged
lan11             1 PVID Egress Untagged
lan12             1 PVID Egress Untagged
lan13             1 PVID Egress Untagged
lan14             1 PVID Egress Untagged
lan15             1 PVID Egress Untagged
lan16             1 PVID Egress Untagged
lan17             1 PVID Egress Untagged
lan18             1 PVID Egress Untagged
lan19             1 PVID Egress Untagged
lan20             1 PVID Egress Untagged
lan21             1 PVID Egress Untagged
lan22             1 PVID Egress Untagged
lan23             1 PVID Egress Untagged
lan24             1 PVID Egress Untagged
sfp               1 PVID Egress Untagged
lan1              1 PVID Egress Untagged
lan2              1 PVID Egress Untagged
lan3              1 PVID Egress Untagged
lan4              1 PVID Egress Untagged
lan5              1 PVID Egress Untagged
lan6              1 PVID Egress Untagged
lan7              1 PVID Egress Untagged
lan8              1 PVID Egress Untagged
br0               1 Egress Untagged
root@debian:~# bridge vlan del dev br0 vid 101 pvid self

Vladimir Oltean (8):
  net: bridge: vlan: notify switchdev only when something changed
  net: bridge: switchdev: differentiate new VLANs from changed ones
  net: bridge: make nbp_switchdev_unsync_objs() follow reverse order of
    sync()
  net: bridge: switchdev: replay all VLAN groups
  net: switchdev: rename switchdev_lower_dev_find to
    switchdev_lower_dev_find_rcu
  net: switchdev: introduce switchdev_handle_port_obj_{add,del} for
    foreign interfaces
  net: dsa: add explicit support for host bridge VLANs
  net: dsa: offload bridge port VLANs on foreign interfaces

 include/net/dsa.h         |  10 ++
 include/net/switchdev.h   |  45 +++++++++
 net/bridge/br_private.h   |   6 +-
 net/bridge/br_switchdev.c |  95 ++++++++++---------
 net/bridge/br_vlan.c      |  77 ++++++++++------
 net/dsa/dsa2.c            |   8 ++
 net/dsa/dsa_priv.h        |   7 ++
 net/dsa/port.c            |  42 +++++++++
 net/dsa/slave.c           | 164 ++++++++++++++++++++++++---------
 net/dsa/switch.c          | 187 ++++++++++++++++++++++++++++++++++++--
 net/switchdev/switchdev.c | 152 ++++++++++++++++++++++++++++---
 11 files changed, 656 insertions(+), 137 deletions(-)

-- 
2.25.1

