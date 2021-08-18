Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28BB3F0327
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbhHRMDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:03:35 -0400
Received: from mail-eopbgr00067.outbound.protection.outlook.com ([40.107.0.67]:52143
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233134AbhHRMDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:03:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5xjn36m5VSCQm/zYAASNHhV60zZskyh7wDrBnhecQWQttI258xxZFJgy7gcfOib9NXnB8IEEn3jdNNegFSvP03fNICFRtCOvv6RtkyROC7F/GETpukYy/L6SY7R73trOb5qyH3Ft+A7CIZtJbt4mpprobfIkcREiCW533MvLYawMwQi4RrACM9M+avtsitbs18kyIGeU1xfwH7h5jld7QyDz7XHZwqWlXrVHwyxxvnLMXZxfp+/SSbpja7UBb3fjuV0OLjpWyh0/NoGqECPg8+kxZrgIxzKrwgqMzhlPDHs4DJm0T6ao3GufCgA5AnX6T6mAkYj+PGQuXAtizY7SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyIL0Fkhmb2YryiSrW2r832R4oNLt7JX6pFzRn4B2a4=;
 b=nZtMK0y6mautqnK1F+MqRSajmcKke80xweCI3nZVekOMXkj08u8GXKdKAEVrwq4x/11MoZX4P21Gedy3v8eEhxB6aepH6bRM7MnZRoS/HfOsvnno19R9wK+hD+/O1UufWbhwi3EQ2jSjOV1QdNth9QhVlVH6TG1WbiE6hlfQMMR4x5sLyvZz0/Dnj57PXLMJuV8GYmY61mqCdcq4iai++aWNQ7EG7mh2cO7Dda5tnGOwJ6xVUFELSV5DtaEn322YXwkr60q6a9zBNUa8gTqRh+vzFzOBastWXJsCV0j6gTvSjVnSOeRf0rs+nXy+a7XxtUkCznN/7XqAKSEHAh5I1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyIL0Fkhmb2YryiSrW2r832R4oNLt7JX6pFzRn4B2a4=;
 b=mTVV9u/9GNgDS8ctGR+2khmEEK4CXzEJkLrQU1yMhxpiFyGJ0mym37ci6Mz91cmZXXJEk/ewXPl5ZPT4nYE0YSOGQnnwnWmIkhs16k7rFi34qf83EtdFS4kU1LcZm9r80JgaDgvMEXFmZWCAk4+0N2DZOC4UNlILdnOglynvQSU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:02:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:02:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 00/20] DSA FDB isolation
Date:   Wed, 18 Aug 2021 15:01:30 +0300
Message-Id: <20210818120150.892647-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:02:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d26dfa9e-fd92-4bbf-52c7-08d9624019b8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB38390DC4C08B7E797D32782BE0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TIyq9HdvihXm3Jh5/clQdLp38HnRkG86fkZtUcyAxOvX1u1NKcuCZvm2W9fU0Pyt6s5VGsFECTeVFnOh9FYwQ3SDxODz/yp7EF+zdzaVPky9o+EnfcWLRHe812+K6TefLV45f9L60YtGMV8wwOUHX/0RYZ1kSy96Zorq5Igy1m5y7c5GopbZ2qwz/tH9kz32gSu1U14+SLnBVO5qelso2G4EF8fSzAvZ3uzcVihq/4ef5SkAPSK++Wix7KkGnAsMofjQKoJpfFLlLq6jszpXGKCSfgcpn6eT60WV8FOoKdja9I2zZVgC8vYvThj/d3f0PhKtSDxc3gG/ch8CIcQEJyAogvpCV08zwgtxr0v2YDKAR9nsfwX6yI2KebQ+F0Z9MV+JooKcp9tpGJTz2a/3EWSfukFtbaDZiz0fpHKjbo9sCf18OUGe5zi9ezYLtMW7VNsiH7uQDucSIeE0RrPMWAMb9yKq3joDOpFvIo5/IfbClaEoXAD7PlKCrW8/+IHEqLi+HEcZk+YyoAswSovYkVxWPdQNNEGwa4nqUrVw5ldb6sw1R4kRM0XPHeurJ79I1mlOGdjqZ0qVBDfELhOQ8Avcd/ERQR9vAYXv6MPGbj/o4GwzB6wx4XKGuELMpTNRi5PGXpqxu1RaEjzRYQ7TzHFNwJov1yHxoq2RV0JTxIqx9jGxeLeD7B65ktzs4vuqcRZnPJNJ3zUpPZbN5NBoZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39840400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PA+XpDC1DR+e10OmqkoX2tJoJHGYs13Hc2gZQYtOXxtTHWudJHTuemzaIqdb?=
 =?us-ascii?Q?VB0m4kEydjPH7fE/B0wlIzB1VnZz/YSPlR3Fb6wQfx+eSNjc14bqlpNmZq/l?=
 =?us-ascii?Q?ia++lc6kSLY4DT0/dXJMFd282S8pIMRZIOA9zw9qAaY1Eo9YUM3MBEsLxDkz?=
 =?us-ascii?Q?gTfzhQEftkU/N/fQtYtFX4CCpyQjqWjaGxoGQi739zepciklFavmXnGVOOGs?=
 =?us-ascii?Q?U6BFTBDyLQ7wTnrFo3k0PHg7PD+QZcAzrbqVLPXdXIs9+wy5DLAzspBWvJpv?=
 =?us-ascii?Q?SgEA/QbhrM5uQQfC1YvLjkD3xg50/F8pSCzwbTVZm5y60PCt3Xpi7XTU7lsa?=
 =?us-ascii?Q?WdGHVG0uj1nmk9vrHw4PxmEVnL4nMia3PCTrX5gOBpAX+J2XTop4BtC8O83J?=
 =?us-ascii?Q?0MktSd87pwptGC0kv0LjleA6KSGU8jf0i8+9INfPjDZVreicsc5jOWwnl1+X?=
 =?us-ascii?Q?RXAbKZort4YDczsRf/3IR4/JF9rLnwVtV34COFyB1KoYBXeNyXxsP4t/jupF?=
 =?us-ascii?Q?EYRpuOZcXCVyk6swZ7YU5E6xzyMIYsLWEqbgbgm2sXMtahKLx5ljPJ3XsS72?=
 =?us-ascii?Q?G4S6jUy5AoA8hA/BpthoZaQf30RZkldazbj9rMgOh5XLt3A41GdeCbJB8f31?=
 =?us-ascii?Q?7q3txv0+k9aBWWoZ7CU/cKqX3mdTxKll58GkiCreKyAW3ZTAAUFOCW1rLEYD?=
 =?us-ascii?Q?VrD996OXPjU9xx58J58+J82duTzmAMG2lICoQBJ4rbODCgKNycWPeTJJ0c1K?=
 =?us-ascii?Q?mqpmLO6qWSGvWp9/PEAI6nMD5MjY0CjsDtUMDQDNbeazJjkyyCvn8sfD6gos?=
 =?us-ascii?Q?vMyKCEae3+MIB7u0x/IdyCRtYisgHclHTFf1eYwDk83wNluBJlHk0tebC+uE?=
 =?us-ascii?Q?krlHc6FoA15ks6Sn+CFEbKm3RyfVCl+lX+B8WnXk3ssRfC0EkXF5ysu6MuhD?=
 =?us-ascii?Q?CTzsYhJMXTd7elKmpSlyPp8w0arRkV0E++o2WtPO82phMUQrWDMqbgm6eNgp?=
 =?us-ascii?Q?BsU0G8XDHAFuloHJ9/jzkr8ojDcKQaB0kWRGFG+WlUUDdsWjVk2kNViwOp5s?=
 =?us-ascii?Q?mkNguM4W5OftXRUwBDAQH6x+EzEmODV2x5KEZSrQDe/1bj2qIM6UUnIcfWVE?=
 =?us-ascii?Q?VqnUTjRA8kRh1x/ksDRJLsgJOAXNdU6AxgtqXsr8cuV28EeuKPfCjHajjNgx?=
 =?us-ascii?Q?q1oDX747reNfQagfpJrY1q2czVK+0X6yVaIWIugqYY7CgJUoqhiCHTTZVfdF?=
 =?us-ascii?Q?mes4rMlEfU9AdzV9ImpiqYxrw9SmRMKySdQgcPssgFyL+FKwXg52g32e2bEX?=
 =?us-ascii?Q?X3WNAEJNmYJLZ8QIYMzL+qcJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d26dfa9e-fd92-4bbf-52c7-08d9624019b8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:02:50.1123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nGsm5UBXFAw4zDUOk/xMQjB75Ai6gRhy4oPTsVySUwczz+pgPPqR3sksqHrUakbdKCfxJULHnhrBUKk8oNcrug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I will submit patches separately because this series is very large, but
I want to first give readers the full picture before agreeing on the
fine details.

There are use cases which need FDB isolation between standalone ports
and bridged ports, as well as isolation between ports of different
bridges. Most of these use cases are a result of the fact that packets
can now be partially forwarded by the software bridge, so one port might
need to send a packet to the CPU but its FDB lookup will see that it can
forward it directly to a bridge port where that packet was autonomously
learned. So the source port will attempt to shortcircuit the CPU and
forward autonomously, which it can't due to the forwarding isolation we
have in place. So we will have packet drops instead of proper operation.

DSA does not have a driver API that encourages FDB isolation, so this
needs to be created. The basis for this is the dp->bridge_num allocation
we have created for bridge TX forwarding offload. We generalize that
concept here.

Drivers are provided that bridge_num in .port_bridge_{join,leave}, and
the bridge_dev in .port_fdb_{add,del} and .port_mdb_{add,del}. Drivers
can call dsa_bridge_num_find(bridge_dev) in the FDB/MDB methods and they
can find the bridge_num that was provided to them in .port_bridge_{join,leave}.

The association between bridge_dev and bridge_num is made at
.port_bridge_join time and broken at .port_bridge_leave time.

The trouble is that .port_bridge_leave races with FDB entries deleted by
the bridge when the port leaves. The issue is that all switchdev drivers
schedule a work item to have sleepable context, and that work item can
be actually scheduled after .port_bridge_leave. So dsa_bridge_num_find()
can potentially not work when called from .port_fdb_del after
.port_bridge_leave has been called, and that is not nice.

So switchdev is also modified to use its embedded SWITCHDEV_F_DEFER
mechanism to make the FDB notifiers emitted from the fastpath be
scheduled in sleepable context. All drivers are converted to handle
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE from their blocking notifier block
handler. This solves the aforementioned problem because the bridge waits
for the switchdev deferred work items to finish before a port leaves,
whereas a work item privately scheduled by the driver will obviously not
be waited upon by the bridge, leading to the possibility of having the
race.

Vladimir Oltean (20):
  net: dsa: track unique bridge numbers across all DSA switch trees
  net: dsa: assign a bridge number even without TX forwarding offload
  net: dsa: propagate the bridge_num to driver .port_bridge_{join,leave}
    methods
  net: switchdev: move SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking
    notifier chain
  net: bridge: switchdev: make br_fdb_replay offer sleepable context to
    consumers
  net: switchdev: drop the atomic notifier block from
    switchdev_bridge_port_{,un}offload
  net: switchdev: don't assume RCU context in
    switchdev_handle_fdb_{add,del}_to_device
  net: dsa: handle SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE synchronously
  net: dsa: tag_8021q: replace the SVL bridging with VLAN-unaware IVL
    bridging
  net: dsa: tag_8021q: add support for imprecise RX based on the VBID
  net: dsa: felix: delete workarounds present due to SVL tag_8021q
    bridging
  net: dsa: tag_8021q: merge RX and TX VLANs
  net: dsa: tag_8021q: rename dsa_8021q_bridge_tx_fwd_offload_vid
  net: dsa: pass extack to .port_bridge_join driver methods
  net: dsa: request drivers to perform FDB isolation
  net: dsa: sja1105: enforce FDB isolation
  net: mscc: ocelot: transmit the "native VLAN" error via extack
  net: mscc: ocelot: transmit the VLAN filtering restrictions via extack
  net: mscc: ocelot: use helpers for port VLAN membership
  net: mscc: ocelot: enforce FDB isolation when VLAN-unaware

 drivers/net/dsa/b53/b53_common.c              |  18 +-
 drivers/net/dsa/b53/b53_priv.h                |  18 +-
 drivers/net/dsa/dsa_loop.c                    |   7 +-
 drivers/net/dsa/hirschmann/hellcreek.c        |  13 +-
 drivers/net/dsa/lan9303-core.c                |  18 +-
 drivers/net/dsa/lantiq_gswip.c                |  11 +-
 drivers/net/dsa/microchip/ksz9477.c           |  12 +-
 drivers/net/dsa/microchip/ksz_common.c        |  11 +-
 drivers/net/dsa/microchip/ksz_common.h        |  11 +-
 drivers/net/dsa/mt7530.c                      |  17 +-
 drivers/net/dsa/mv88e6xxx/chip.c              |  30 +-
 drivers/net/dsa/ocelot/felix.c                | 180 ++++++------
 drivers/net/dsa/qca8k.c                       |  12 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |  98 ++++---
 drivers/net/dsa/sja1105/sja1105_vl.c          |   4 +-
 drivers/net/dsa/xrs700x/xrs700x.c             |   5 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  86 +++---
 .../marvell/prestera/prestera_switchdev.c     | 112 ++++----
 .../mellanox/mlx5/core/en/rep/bridge.c        |  59 +++-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  61 +++-
 .../microchip/sparx5/sparx5_switchdev.c       |  78 ++---
 drivers/net/ethernet/mscc/ocelot.c            | 255 ++++++++++++++---
 drivers/net/ethernet/mscc/ocelot.h            |   3 +
 drivers/net/ethernet/mscc/ocelot_net.c        |  95 +++++--
 drivers/net/ethernet/rocker/rocker_main.c     |  74 ++---
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |   4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   4 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  59 ++--
 drivers/net/ethernet/ti/cpsw_new.c            |   4 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  62 ++--
 drivers/s390/net/qeth_l2_main.c               |   4 +-
 include/linux/dsa/8021q.h                     |  29 +-
 include/net/dsa.h                             |  36 ++-
 include/net/switchdev.h                       |  26 +-
 include/soc/mscc/ocelot.h                     |  30 +-
 net/bridge/br.c                               |   5 +-
 net/bridge/br_fdb.c                           |  40 ++-
 net/bridge/br_private.h                       |   4 -
 net/bridge/br_switchdev.c                     |  18 +-
 net/dsa/dsa.c                                 |  15 -
 net/dsa/dsa2.c                                |  49 ++++
 net/dsa/dsa_priv.h                            |  25 +-
 net/dsa/port.c                                | 126 ++++----
 net/dsa/slave.c                               | 138 +++------
 net/dsa/switch.c                              |  79 ++---
 net/dsa/tag_8021q.c                           | 269 +++++++-----------
 net/dsa/tag_ocelot_8021q.c                    |   4 +-
 net/dsa/tag_sja1105.c                         |  28 +-
 net/switchdev/switchdev.c                     |  61 +++-
 49 files changed, 1428 insertions(+), 979 deletions(-)

-- 
2.25.1

