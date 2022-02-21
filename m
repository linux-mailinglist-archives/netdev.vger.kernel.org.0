Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6B84BEC8B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbiBUVYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbiBUVY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:29 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB49FD0D
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D90lunId2qrd+thTDUrGgSKCiG+q8oPJCiXSnGk+yMiNqXuCWnT8lHSduKc+eyMlb6F+PJjnkmw4Ubx+UzAaewQpJuQTGBoMcmAab9M66QlPyi3gPtzqtOC+s0A7t4/5BGZmIUNpPna/oPTJ+briOWD5ElIegfsEcRED646HhuhLQLfjoD2HvKcwMDmBCdzIX3gq1V1cGtz09zuLKAasiLE7gMgRodwF32xd2yLVbVv1D6e0Zm6sUTUTKwH9cnSQP04RpoQ3NMD3npzY/KqhHLFRAg24Z/ge4NF2MTeVXVQXsUTwCo7988MV/yCQaqLPjkYe4u8GkQR3CwpBrPrMTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ImIuwzZ8WgLUklcKeYS79VQJrzud/2409A3BuGf5dk=;
 b=UF2CKoCEOQ/U+iAJBzdsVzaEvopLqiNNmPKdOcfe5QiKFyYPs+56tRSMOgJo8oVexIlslq/lo1OOx2YRtUcNHd9ai1Hh6qnVYa5MkQsRz8695C8t5B5HVaPcSwEfG6dw1bGnF7vQVMP8ON4A0iZhQlFcc2Y/vikghvMUb88GBDdjBRUHWqkO1Xggu31nlqZ0f7CNi4kez8KSsNTQ1qZGI5NBQKoL3GqoAsR1YhyD/phhPsHXcNQ1BR+c1vqe7I1f+mbX1+0LpHfF3nuxh478JIbq8qo77r6/5LlCoOq+7+lhoixSP33VR+YhFGb8CQHCUcL2NrJFhIjmBnMdoiVSrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ImIuwzZ8WgLUklcKeYS79VQJrzud/2409A3BuGf5dk=;
 b=qREkgwSnMl5TTYXCSp+i9ZhLj8CSdcsCU/PE6S/UHHmE5u0GHN/6WbNOuULjvWxzIUPT274QpkWZBVBfK+ptEatcuXUbY8xWV5+sAiAuq4ijECTpwkUo90hDQx2QlBd7UifufSPG1tx5qPLBzJlODuS/pmmvcdIFN0uRdVnOoXg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v4 net-next 00/11] FDB entries on DSA LAG interfaces
Date:   Mon, 21 Feb 2022 23:23:26 +0200
Message-Id: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM5PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:203:51::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12278cb2-729e-4c2d-273d-08d9f5807a49
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB56451C58251EDB5487D198F0E03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMWje8g1Btje00gL69WapAeHob/VSz51u6w8pcok0v2z8+PHq0BtGgv7wdsKySwrF7k1Lg9MLGs1w3jR1Zu1hEZTXLf6fDETWdKsejGahcl9zgCqwlzZA85znhKrQZ4NoI7So5U0oC7uxBaiv/fqKkaIxT8VnCRSHAk83dewCLpm2QNLPPOlBoGbPoHh85ok3oitBGWT4OXPzO0+j+2UiO5GwcYnU4dvBd1goTUBag1BQZYDEd/MMMWZRDxEzsF3BW3O2aiTRXu94qiuQeHJbJSb1RD/BosZZgAF5AzK0oJdhJWadMQa+ykwC6hAqtJ1IofQOD9vzYIQpr5L+p1g42CcTCvoe2c+iC5jQ5JSIIxVydFoW25SqcdQW5qMNWf793IrqQuhmSmEbScumlXBEj/0ixV02Qr5GRpXrNW71x/+j5FVUMli5eYyr6opCRUmXOqr36eJY20Xsr3LGU5LVyYZeo3CLwaV9D6Ism4H0pIzM8h8Gi3a6enshpzncb3qSDy6oTlDFz2Lvr2lQaAzHbdO9YjI84YSXUVIDU1EO4TfpXeleBaLrfwAQYwhhaELlaL3jF5WpzUgdsQmeX7RQXvR9y4I/2Vpm1LcyF/FbYXZzi3RSu7iBcHGFNGGPvgeka2zz6modDLGxGgLcqZXkt1wP08kNo7MYN+gsJXhJ4dnJN7RSqfJ3+aJBlet7BIulBytP7So5uUX232SWsm5TDOT85QZbjRt+udOECc+qVMmPsRrYhMNMoikmTBKiRXv6PFqV6daI3TqoEH/s/yg+H6myV+4FlPucY+NmLW9epQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(966005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(6916009)(66574015)(8936002)(5660300002)(36756003)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1F0R2Jrcnc0T2JWU3FEMDB2VFpXR21Db2dmWENsMEpJKy92YWJQQUpUQ1N3?=
 =?utf-8?B?eTlMUFhJSWNlMHYzMmlYaGxJaVRMTXhVWXlyVzFUd0JxTStPQzhRZzlQV3NJ?=
 =?utf-8?B?VXNLbVA0eGxwWXVZaDFwRkc4NXhwUlU2d0tMaWNvRDl2TThLNHIvSzAzZUFY?=
 =?utf-8?B?RTFKcE5sbHJ3RFVTcnVNRGY4bnFRaUIrQ0JqT1d3VFI4aGdwOFVrNjFPMjcy?=
 =?utf-8?B?Yy9OQ0RCUDdodlpHR3JjeU9TVHBmeVZKSmJRc2FPb3hlQnNLSFhaMStYZG5E?=
 =?utf-8?B?QTFIY2tzTU5KUG9GYUpiWFM2MjV0b1pHdTdxeVJldHdqbnhwc1lQcDFhQTdF?=
 =?utf-8?B?dlRqc3BqU1hsblBzM0ZuL0wxNm1La2oxd1RjN1BjSnNjcHU4emcrOFR6bmx6?=
 =?utf-8?B?TVA4TE5HejlNeGs3WE84UDZxeDNoTmExMlVpSktjeGZkK0dUMDcvWXFlNXkv?=
 =?utf-8?B?R3o1OS9LQ3A4b2NEWE55ZkxnYURpeENYRnJCZ1g5YVJIY29sUnNFdmRLZVE5?=
 =?utf-8?B?THJmUy9mSXJHelVpYXdXeGI4ajEwZTJnKzA3RnJ3dS8rd3NxZ0VGTGprdDVx?=
 =?utf-8?B?ZnVKUDNLVThrT0hadWNrVFFGcDJIUnkrWmFCb1dnU0V0SEFYZkJzdElzSkll?=
 =?utf-8?B?QlJscG1nak9UdmpXSzZBd2IyMFpmOWVKcTM0YnkzUmgwREtweWZ4eTJ2S0FF?=
 =?utf-8?B?djdGTWtzdGlhcWlJTHgyaElxSjBrWUdwaHNnTUVLSG1rUmIvQVRQU2NiT09H?=
 =?utf-8?B?dCt5OE83SnhUcXczYXh0YUxlWTAzejR3aklxZkkrRHNzOTdVZ2lRV2VRUHJZ?=
 =?utf-8?B?Y3djcjlqdFlXczBTb3VFcDBPVjJHS2hFUVNKWXFCTjVRbFd4VnBZN3B5TGg2?=
 =?utf-8?B?WC80RlBEQlQ1NXU3ekhwU2R6bGtPL2xqTE93TklrOVVNV055UG53cm9pMGNP?=
 =?utf-8?B?ZHhmR0pCblE1RlM1NFRWOE9JTElMN0U2enlicGFGMXZzY0ZuV08rRHY5eUkw?=
 =?utf-8?B?NmlkK09qZ3pweXlOUTJ5QzFNeUJaTURTUkxwd3NCamNKcUNKT2dqMlpQekFQ?=
 =?utf-8?B?akFlYmRJbThCTlUwaHRsMG5UN3ZXYWRIQjlXeU53N3lsejVYeEhaK1EyTEln?=
 =?utf-8?B?d0taRmhpSFoxV01Ka0pUZEhEWUhJbVdUdHZzWjNnVW9iMUF4WnoyRktIcXhk?=
 =?utf-8?B?MXhqK0R4bzU4NzFYUlY1aUVnZXJtalE4Zmx0QTZBYXczZ1hUSThzcXI5eHNR?=
 =?utf-8?B?aDRiNk9CZVk3eVJpZkRxWGJFQWgyTm4rWTcxWXduRjRReGZsdm42ZnI2NXhv?=
 =?utf-8?B?aHIyTlY1cTJLQ0RCaXhPS1BnNkJwUmUyNWd6aXBmY1BDR2haWXBqUms3V1lU?=
 =?utf-8?B?R3ZsK2J4Ri8vSFY4VXhoMzF0aWtNUDVEdjZrZDY3aGc2UUxRQThlZy9hNU1M?=
 =?utf-8?B?em1TRnllSWdLNGtyODluY1ozemQ4VFFiUXVNVE4xNUkyWW5jUC9DNnM4OXpw?=
 =?utf-8?B?VDNaYjQ0SVgxa1ZCNmRmVDRpd2Y5ZUZXQ1d2Z1JRWGZXck9wdFNRaEREanVs?=
 =?utf-8?B?c1VnU1ZJd0ZRNFc5L2lJcFdhVTJKbk14R3ExT3ZRR1dFQkVQUmpybzd3eUpw?=
 =?utf-8?B?a3hucGpyTE1BZmozbWVMb1c3aWhOaGZqR2FuRExXM0ZuR3BSSVUzL25ObkNM?=
 =?utf-8?B?dC9JTURndWZTK2s1ZjBTMzcvMFZnNmQ0Q0JGelpJR2h1SEoxaGpGYlRsWVkv?=
 =?utf-8?B?cnNmTWFkc3dBeEYzamFCNTV6RldGVTJuVkpobWhIYTduMFFJaWs3MDZmaGtI?=
 =?utf-8?B?RjhqZHRtWi9hNFVDaFJpQXdCMm9ZTTZjU2FqeWo4WmMxb1hES2F5eGhCb2lS?=
 =?utf-8?B?VnppY0UraEZGQ2V4ZDZUR2hHYzFFQkJDcDFWMTJkRzE5d0ZWTVpNRHA2SmMw?=
 =?utf-8?B?VDBsb0QvSHNha2VBa2hPcVBENEFSVTdzQ1A4RWZiSCt2TkRpWFY5K0ZJYWJl?=
 =?utf-8?B?WDhFeG5iL0gvbnN0ODQwcEVvWW16dVBIMVNKQ3VLM09vRGR6UVNCclJ4dkFT?=
 =?utf-8?B?Z1BuS25KQWViWk1oSHpiaHhBd2N5SkhVWXV2cXA0MVpYREoyV1RJWHY0b29S?=
 =?utf-8?B?N2xzbksyQlZ5dFlqdGFaMTdhOXNPUnU2SzF5OXNRcDk4eEhjWlNsaHZiZDM2?=
 =?utf-8?Q?oO9VK2ApCYako3SyisZML/o=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12278cb2-729e-4c2d-273d-08d9f5807a49
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:00.8525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VLNua8FrHCsrzKtoOoBqmc/DOMbZyPjBx12lVN8v2dV6VOo9hy9X7W/bN2MgYK8EHmHWJOoeh1kIn+/2TLObgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5645
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3->v4:
- avoid NULL pointer dereference in dsa_port_lag_leave() when the LAG is
  not offloaded (thanks to Alvin Šipraga)
- remove the "void *ctx" left over in struct dsa_switchdev_event_work
- make sure the dp->lag assignment is last in dsa_port_lag_create()
v2->v3:
- Move the complexity of iterating over DSA slave interfaces that are
  members of the LAG bridge port from dsa_slave_fdb_event() to
  switchdev_handle_fdb_event_to_device().

This work permits having static and local FDB entries on LAG interfaces
that are offloaded by DSA ports. New API needs to be introduced in
drivers. To maintain consistency with the bridging offload code, I've
taken the liberty to reorganize the data structures added by Tobias in
the DSA core a little bit.

Tested on NXP LS1028A (felix switch). Would appreciate feedback/testing
on other platforms too. Testing procedure was the one described here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210205130240.4072854-1-vladimir.oltean@nxp.com/

with this script:

ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
ip link del br0
ip link add br0 type bridge && ip link set br0 up
ip link set br0 arp off
ip link set bond0 master br0 && ip link set bond0 up
ip link set swp0 master br0 && ip link set swp0 up
ip link set dev bond0 type bridge_slave flood off learning off
bridge fdb add dev bond0 <mac address of other eno0> master static

I'm noticing a problem in 'bridge fdb dump' with the 'self' entries, and
I didn't solve this. On Ocelot, an entry learned on a LAG is reported as
being on the first member port of it (so instead of saying 'self bond0',
it says 'self swp1'). This is better than not seeing the entry at all,
but when DSA queries for the FDBs on a port via ds->ops->port_fdb_dump,
it never queries for FDBs on a LAG. Not clear what we should do there,
we aren't in control of the ->ndo_fdb_dump of the bonding/team drivers.
Alternatively, we could just consider the 'self' entries reported via
ndo_fdb_dump as "better than nothing", and concentrate on the 'master'
entries that are in sync with the bridge when packets are flooded to
software.

Vladimir Oltean (11):
  net: dsa: rename references to "lag" as "lag_dev"
  net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
  net: dsa: qca8k: rename references to "lag" as "lag_dev"
  net: dsa: make LAG IDs one-based
  net: dsa: mv88e6xxx: use dsa_switch_for_each_port in
    mv88e6xxx_lag_sync_masks
  net: dsa: create a dsa_lag structure
  net: switchdev: remove lag_mod_cb from
    switchdev_handle_fdb_event_to_device
  net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
  net: dsa: call SWITCHDEV_FDB_OFFLOADED for the orig_dev
  net: dsa: support FDB events on offloaded LAG interfaces
  net: dsa: felix: support FDB entries on offloaded LAG interfaces

 drivers/net/dsa/mv88e6xxx/chip.c              |  46 ++++---
 drivers/net/dsa/ocelot/felix.c                |  26 +++-
 drivers/net/dsa/qca8k.c                       |  32 ++---
 .../microchip/lan966x/lan966x_switchdev.c     |  12 +-
 drivers/net/ethernet/mscc/ocelot.c            | 128 +++++++++++++++++-
 include/net/dsa.h                             |  66 ++++++---
 include/net/switchdev.h                       |  10 +-
 include/soc/mscc/ocelot.h                     |  12 ++
 net/dsa/dsa2.c                                |  45 +++---
 net/dsa/dsa_priv.h                            |  24 +++-
 net/dsa/port.c                                |  97 ++++++++++---
 net/dsa/slave.c                               |  64 +++++----
 net/dsa/switch.c                              | 109 +++++++++++++++
 net/dsa/tag_dsa.c                             |   4 +-
 net/switchdev/switchdev.c                     |  80 ++++-------
 15 files changed, 560 insertions(+), 195 deletions(-)

-- 
2.25.1

