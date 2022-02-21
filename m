Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7AC4BEA1E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiBUSEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:04:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiBUSCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:02:41 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB3915A33
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:54:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXH4XSRADjTvaZC/84nMUVNiC5LS3UHognbR2+A06vbHLFk/T8X6/XgDpgl4+9DAEcm9xTBviRVLWhGRYg0OCCMjbfPqASveB7SNtMYld8IseCF4hwdGTf/8Z4d9nNT2sX32UbZ8UcyywKK8LNdb86iWXm3pPzTCpPqfkpfrg3mTK52tAl13Zxhwab24ps3buVtTW9mUfNed7DMXXQthAFg3Mh7bDeVmxa6CUINt+wB52u8+ZNtf9D7Fm19QWom3axUBGrsHadfm0/eDjEyG8mh3p9RSblKIVCrqkTqGFZHFmj54XqB0Q9SesHX9TzZVcUaVShjsnQiRVhFiZQqzsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgsCdI1lkEAjwru2JCQOwukmswwvMldirg2XfrfWYKw=;
 b=XD7177Bz+B+GaW8FaRdxuVX28xGyn3n+1eKIqB87XwcFxLBfDvVmPDFo6yLpmG27kxhOtoXu2Td61eOWe1XFI1SP2GoTrIlQ+Y9+4Ddn4swo9fKLQxzPSzz8Xiodt/w8wVF8n2njxOqg2nlochmyNbbAu/Cuh8HN3NX26YpEU5x9dkVSFdU4dsQUITaERgFTHZFS5qSpH6VBdrUJPGN9rvOIk4Ho+GHLxS7NcvvjCrFa440uF2cs+WUAjRdvHaTDA68JfqWxvPMDDRq12EE4EE4n0Zj4+exInhtQtkOyt8e4CJYbsWJNHSTLyXBt7o6ztJtjPHvEiwf0JqYt8IZabQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgsCdI1lkEAjwru2JCQOwukmswwvMldirg2XfrfWYKw=;
 b=KKpT0kTgWGrZlCGLQZ8MOfiBtJvxH/K/ZRi0VRGSckqyUp0v8BKr3r24RP5Ifqv7rOpGjTaK4d73Smf3pjDNCWvdrGd5aFJQyie06ulRZNNpAdvPLtNalfa7ZijOJrTGEwigC/3V7SiA2hiUUJGajseIA8FiLtLFAw+V35u2oJo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3693.eurprd04.prod.outlook.com (2603:10a6:803:18::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 17:54:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 17:54:07 +0000
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
Subject: [PATCH v3 net-next 00/11] FDB entries on DSA LAG interfaces
Date:   Mon, 21 Feb 2022 19:53:45 +0200
Message-Id: <20220221175356.1688982-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b21d53ea-bda6-409b-217d-08d9f56327cf
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3693:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3693C1C2FB03E240DEB42B89E03A9@VI1PR0402MB3693.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ehW9NhSzt/kNBy0uJ0iAnRwAiWWGFDjyS8E5IH0IxWwJhGnzCpR6ZSWZUhK53xb6kuL4SrBvYiE1XdBUIBprLUrNJ5Y6B8FnAvnuj/tc8QYLKciHGbHYVO7au/8MJXsBwWeZz3VKlHoijZB0WtH0v5g6pYAJFkhwX7SnAgkpVumyskNk2HnB6NLnwMTYe0isghUjHsSO2X7Pv5BArDSlOkx6w8ouZKjSLOG50idAMpqnURxEZ8elh0DUgoFiC/ZIiwmXLKIp2M+sRklwZhC2K6qIgWffcpPl9xhXdVhzvsZj8N2pzpHU9qTYGZvqXwRn+ttLL3/NeyIH+Sf38bTPDNyElsQwr2bhK1PB2HlByX/k9WRw8zndGoLoHIPZNr7fJji6a/Tx25eFGoFR372tsAOn8y3pxNELgTXYZgrd8+upnWQWs2z/xt0b82+9STD6wUz5rspzPetrFpMfAkS+GffQZY6Gvo7CgzwX/YojngMbeDqH3Zlhr8KC1A29itrf402ke9Mn5a3ZoWkPjvjMPUk4GDuBw9OAsxxFDYFafbEHtNUbawg/Me+S4cRoq4YuJbOLTJz3Hg5laDcfrw/xWoha88Kj1VGB/654Yhe+MVuerOq+S4Wp8qKhPQPcnBabIwC5TEvmLU2iLzjiB+qrA2fwkmx3ggQusi7VBSKnWE5FsCiNnwWvDXMqb+UMWSXG6zkycqyDYeiwL6TeLhC41PAggN9eNjEpQn4hK3PEDvyQI3CxSRKlc1v9NTOvUnVtv3i39sy/887JRbRuaPCWGQOaCczVVreZaTPB5QBPa20=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(66556008)(4326008)(8676002)(66476007)(8936002)(26005)(7416002)(54906003)(5660300002)(83380400001)(66946007)(186003)(316002)(44832011)(86362001)(52116002)(966005)(6486002)(6506007)(6666004)(36756003)(2616005)(2906002)(38350700002)(38100700002)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T+K6XvlMSlq5bFn94CLc9nzF2wuQSkCUlzWXzb1RwK0IeDLSTIJgG0qukMzk?=
 =?us-ascii?Q?4RqUcQXGWSGZalwsyZaOoRT/y7Ka38mhjfGQO1kmd/nXTRrKLlFQ8MJ/ppi6?=
 =?us-ascii?Q?k1TAZI2Ly4uezEEA8Ge9CulTPkKo4dUXx4PWCanuLRAzCucofVninJmJGNkR?=
 =?us-ascii?Q?eiC7ME94mhLlnalXKB00ZvLDWifByT7iA951Wof8xe3Rc4pLwWoTrhMYxllT?=
 =?us-ascii?Q?jWcxdaHcCGQn5MW9XxM45+irmgLB+fXlJfN4MqytuPUlpfDUhdLwsHBQLMZD?=
 =?us-ascii?Q?zafd/vcsskOx2dr9gImn0VbK4un/CxOXfHt8j5ULMd6vkMqRzBGTJYaYFC+D?=
 =?us-ascii?Q?PQHOMn9u0Crc0e5xT8YYb+6O37kN1X51611A+YVJseRuXTibZDVlaLooSmMs?=
 =?us-ascii?Q?SyZmOMQEo47fVLoWjw+PDOEI0zV8wDkxle/bwhDbgz7p0VX+FLrep+vU+3q9?=
 =?us-ascii?Q?j+qfNFaVzphrMxhenEai40YzsFEvkoFnN//l2VQRGJ1pbZrccGTjqJQTtVR2?=
 =?us-ascii?Q?JvXqQj+/GioPl3oEsNVWRQwKgta/Q1SHZxj2Y7cn2ER8n6dVnjznRzYYn5uV?=
 =?us-ascii?Q?RF7Mss5PFsBnVpWRm17D/EMPhV2cMoUxginlzagyXPyqGOmDeTKWM9QPKFsO?=
 =?us-ascii?Q?VH9Ka6KxduY1sdXlHRbGnpuVP90MW40q9rQZF/WbwaztDsd81bquogqUax11?=
 =?us-ascii?Q?D0PHMhnoKhgMWVcmmJAA1m8vp/1Z2BRmHLWJLJuPBG/g5yGmMZWvPoJdPuW9?=
 =?us-ascii?Q?ZGy4LeUlA2uCqf1ZlqNb+FZ1/c1uPbr5gne3Zh75vQeud2Vd2yR9yOrauzeG?=
 =?us-ascii?Q?rt2azoHdcwgWmcqe+qCva+gFAxRnTJMHBni5fYeDLSpkyZrglKoFScJDqwcZ?=
 =?us-ascii?Q?/x93g/HKbX6eByZUSkjhyhDAzz2m3FkG9ONvr65HO3RYhHKXkoSaQy5lt8fc?=
 =?us-ascii?Q?9DWSXnOd+DD/oYpRMFxoYu9BY4R9+v0c4ngxr/IfmyCKogqnOwuJdX3h7ZU/?=
 =?us-ascii?Q?PsrPwW4Lv51rjqA+yY3R4xTjNWZr4Iyr54J5gssHPQxamzfmiFnldQujDzQZ?=
 =?us-ascii?Q?k7bzjdBavxY+FdafXlR7EZ1x0AissNMhdj8KViqJbNp6c2Ys08EUXTwuiiRc?=
 =?us-ascii?Q?w0s5BBgFU9+kbYUqpjGdffbH+w7EtohSf/vytoaZjQmDpp1VOSq3kEfRxFWv?=
 =?us-ascii?Q?JazyGYixw8hPdWzBNo1ID7ZBI6pFvdJ0IVp5qivQlZTb5Yk82ZYA7Vzbiqma?=
 =?us-ascii?Q?3Fy55C/ttTflY2ktM+yHEtGzemaR6mTqD2p+VosMBUt7xvmwzGQ9bNICzbHB?=
 =?us-ascii?Q?d8lDwmQ73VCF7HJzndcC0Kb7iacBadQBO5MASOvypmNNbYiyfPE2uq5d7neL?=
 =?us-ascii?Q?laZntrbArWyqYYUk0B5sdsfmP6UG1c037wylMPNYFyySveMlQ5smU6MV2/nw?=
 =?us-ascii?Q?qRqvlTDKX4zUOS+XxZ+V8pYniy77nYwsqo05UduPFtqm4yI4+W/pf7caJU0n?=
 =?us-ascii?Q?d+rWdT8suTlaN9i0LhpTSb+wcDYUPkiV0UDniYeRZMD0vAssTzCycVhzmtX1?=
 =?us-ascii?Q?eX4z7frugqVRYA1kJFCefzQHIO5N71A3CbXyo3y24hkNRFunDALf3WLL8FbF?=
 =?us-ascii?Q?8kZgaDmUz27CG78C2mv7nRI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b21d53ea-bda6-409b-217d-08d9f56327cf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 17:54:07.1838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ZX5MVtnz7sEgcYDDmGuH00aB+ZTqvOiIiZ2cVxRUrH26pZ4IzGX5NElLFaNczgJ+/IwOtMNPGQX0CCa+i7Gaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3693
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2->v3: Move the complexity of iterating over DSA slave interfaces that
are members of the LAG bridge port from dsa_slave_fdb_event() to
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
 net/dsa/dsa_priv.h                            |  25 +++-
 net/dsa/port.c                                |  96 ++++++++++---
 net/dsa/slave.c                               |  64 +++++----
 net/dsa/switch.c                              | 109 +++++++++++++++
 net/dsa/tag_dsa.c                             |   4 +-
 net/switchdev/switchdev.c                     |  80 ++++-------
 15 files changed, 560 insertions(+), 195 deletions(-)

-- 
2.25.1

