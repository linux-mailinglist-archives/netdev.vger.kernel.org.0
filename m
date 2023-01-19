Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA204673860
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjASM2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjASM14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:27:56 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277EB5DC36;
        Thu, 19 Jan 2023 04:27:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzNTbLN7I0v8R8BgKiapIWP5gFOPeUzz9uqUnS/gg0I6xbf/YJQUizGVPxdAXcWNIQt+hstWTFBWLLAgc2Z2MmD89/OUklhOZabZ9h5z2FSOpJo46BgeRtgyYxP5SXC6sfv9B16hF8agl3nhRqBHs6Fa1Klg4XZ6LKVGaCuWEMcsBFf+3ewgsyFBCd9Hh8KxZv16AJEkejPA3/UeLROMUqjocoBgSKg1yv1bH9gPhbw667c4mARhRTrXv107+WmOBe7eVfiE/FhL1DcuE5puuIyp7u7ETL6ZCvPgPlip7iX34mE5aAroFAdPUblA6TjIIdHJWbnW9y5/K5WBEo9uSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4vfXyYWWAzvcQpSHPAImCHirlMdAe1VKjFUABReYA8=;
 b=HlH90VcxN2l+Ah3rGfLmOdaK92NqRHFmfCn8/VlNimUlZN2Z67C91JUrBUUqiJYSBlmbjlBPbPBDFn4TnarsixGJpEyEziaXaoGi/LStdRYoR1dxZbkf7zpAIsmULbT5JoD/wExjs9CocTFj9htMuSYW4+EsQ6l9ERGlC4mgHYm9iP2TpB2cK+Zdavm0dMQTlRpcNQp61JCBUkGDwmpmK+8jVjBNmD9nwq7GrfAi9Ee//HIUowl9J3A7lCUu5cvBh2OLH2UjFT5DuWnM7f0KZLArRqyOjqyp/RHtzUZPUGXd3ttqrJaU3DgjliJbo6iY4f9zmFge5gqEgw7d2GQAsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4vfXyYWWAzvcQpSHPAImCHirlMdAe1VKjFUABReYA8=;
 b=Hf7emIij+pwhsKx/2GaQl83VRs+nfyj6VIq2RLuKuvctpaLa8J++rWQ/C5DCuPBwc0cWSF9ZUFzsLEhZk/7304wy1arJMZZcVWRBDteAHgfz09qg/90DanSCMkH+WIZ8Su9pQeXxEwoJUpg05knyn1sfwpj+w6lqLk7Acdovoa8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9376.eurprd04.prod.outlook.com (2603:10a6:102:2b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:27:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v4 net-next 00/12] ethtool support for IEEE 802.3 MAC Merge layer
Date:   Thu, 19 Jan 2023 14:26:52 +0200
Message-Id: <20230119122705.73054-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9376:EE_
X-MS-Office365-Filtering-Correlation-Id: b05ec950-6aff-4cb2-dd6b-08dafa188cbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e8ZOROawRENVJpS8HGHAOU3VTVM0+neAjzIKJvI4Los7GTxRAw6FMnnrFR2NJ39rRu3uNLeQj0XZiVFbu0sESFAgc7WVMwcVBMD3dLlTIZy9ok9LhDva5ecHSRN9x/T1bciGrORifiiFvMg3OkaYvkPudbcVZkXajqU+nGX9FgrruP26AaQ0tZdfGAKKPSlbNOQRlKLliq8LTwxVdr92/fv+AV20SEVMP6Z6HNQLdO4322e3HbnLSaBmGd10EeZvdTfO1oQ0qvCol0D6ncT5obU8BSbS6yEN7cpbcnwYwi04FblHHMw5HAOycP5F/AvckAxDcmMy62F31D8gZwrG/0MrdAAO7GBnOyonA+R7/voCa/OamzgVJErDsOpyGTHsH1c6SdSPNk5/EeeXvBmE9m1bkz0apT5uERHGyiuIlFX7XeT5znfuI0nSHmStun0+QuoWugAoVBuYaWs7qTENDIS71Qqs3A9SItJFTniSniUExbvyCtX32hSLvNqdyPds47c8O/TC5wRdV9OiA3bGGwTnO7CbvUjyTYDg2QHYzJ7RjvsBB1KYXgZZzrt6Ni+f3FehrBCN/5u697Wx09sKgHqrylpzAtU3G/JuimV6Qhf/AIyNZQpElhqMCxid0aYTsHuao48bMkeRfHk54VXYHtS9BJLiKQtCahqTnuddm3SD3mOTE+fsC6u1NSzly140aAEuGiB5kZN/+Y5um2KDVlofGGY+omGo+GaelhnA9OWO7XrSY2Acmsb1fSQwoM791bPgVE0YRuQmbGS5Y9/w9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(6506007)(66946007)(66476007)(44832011)(66556008)(7416002)(8936002)(5660300002)(2906002)(38350700002)(38100700002)(316002)(6666004)(54906003)(52116002)(86362001)(36756003)(4326008)(6486002)(478600001)(966005)(6916009)(41300700001)(8676002)(26005)(1076003)(6512007)(186003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CHY6gnIx5bOZsdGtJ75589wLBgqBZqDAf4uXCQiRQcgAmoiT2F02tuE3CdLe?=
 =?us-ascii?Q?IRYNPQBYUKkcFcK2nJNwLGxIJzxYna2KxXz6tpeEnDXyuJfu4ZTHKtMczDZl?=
 =?us-ascii?Q?CnPW5wnLhE5ZTPSq922fsbKPLdTHYEIkfcFCLPLLyrP+DMZ7LTz4DDragl3V?=
 =?us-ascii?Q?u8x2VTgJ6a4jjFRW84I0Y3b6cQtpYTgPTYefuvdVVVYZ7kptGQX3u+gqcOQY?=
 =?us-ascii?Q?pqkF4k4j9cNn0sTC68NbPUAMPAS3kyFwfEOH9qZ3Do27+mhHmW7ZmtFe7xwi?=
 =?us-ascii?Q?ji2yFzr+3jLFT2p6LNEhezT2C20D5BWfnzxVzRx1dzVCO120iBZOOgXcv+Se?=
 =?us-ascii?Q?maaGHFGtUXd+2kEWIgfjWvptfI4tYc+XAjBmwr6e7i/sLdl5XkwojxkwQnV3?=
 =?us-ascii?Q?r/fHqtHtEOki4cOIZ4SeeoV+h18atUZAam0JmcktUIIO+n8vGFqrAN+wTWje?=
 =?us-ascii?Q?IpQgCdLyhG8L15I0vw3c9ajDvoFmtuH36CC4RXFdX5I1umjORXuLPnB9SjsA?=
 =?us-ascii?Q?rvurT+XLOWmxu8oyIpiGaGy9HYe2cFhKRZ/hkukI3qFdPXyxc+nkcGyht/lD?=
 =?us-ascii?Q?exH08G/O+hhBmx/f7MJCATo72eSQJrZNjpHJ4i8pSgEAMY0zDnMELFmFW6Oi?=
 =?us-ascii?Q?W4H8r74eJO89SOBA9fVjRKFyoh3CF11hzEnWh0sZVTt0jLaFpMCIn0Vc898B?=
 =?us-ascii?Q?ss6ovP3iZU6jjrvJ68iD2hvJW+VhnpEJK+rh3ZSi47I8jYFSsF5yXXLUCh0T?=
 =?us-ascii?Q?1rSW87TGDFrNeD3z1/V0PRD6nOmSNEG7ToPNOQ2y6oWhCJaDBh80RMo0Afm5?=
 =?us-ascii?Q?HHcokPq7uBoqOGcwOQ4exEoXF0BMdclnjoTrKO9SvfhnkukhPzWlOs21ny/a?=
 =?us-ascii?Q?B+4qyh1lCaJZ3Ktnpq/UXVuTNy51nxt66js3nLzOKVUv9s3bMaJ06DjH5w1o?=
 =?us-ascii?Q?AIYmVsX2StgCfwVutnjzSzLOcPU4kW2a9ukDFkc2r1ulf0hn6J8aRWEKTl9J?=
 =?us-ascii?Q?FmjRu69vYhAJgURbmc738lPB5yk8ZMwhqkuLjkS3j3WS1xKqepBaws0u032N?=
 =?us-ascii?Q?mWsMEJhI2sLWt0a9MH3LTwyXanWViwV96tGLC+eM1ANTO2kLLApwSi7D5Q/q?=
 =?us-ascii?Q?ylmmIdL1vm3GOs4Mq0twYiGTS4JU8z+WnS2NbSD0aALPdK87RTq0xaV5k6zA?=
 =?us-ascii?Q?GTREwkVcRvFWrg0awCTcgztPq/rdDyk5qIFKUSM0XZdoF+gMrwCTTPyo+a8b?=
 =?us-ascii?Q?VsHBLSM0JNg4VeG3+3RSu8OjRJjdSI/ndXJuhZ99GwrCHIXcY9z38GQ1IKZs?=
 =?us-ascii?Q?3r49OUzgWYg1+OTl/ngOYLG9yI9ymkfMEpaHgvqP4E93uPCbnmo8qScrKnnm?=
 =?us-ascii?Q?I/WjJugHUfZCnEraasm0hVgxePQgScaXu7YvnkfqycM+KxJytM+ZisrJW3FD?=
 =?us-ascii?Q?zBtHeFhdZ5fuCQAC1A0lvkLiAb0zKv/1ltypjMNAypi4PyISHjMxD+5qk75M?=
 =?us-ascii?Q?giHBvD1I1fFZHA/JCeu3hLrInZ5tFFUWJQpdU1EmkkA9bxpQIH6LeDdeHS3w?=
 =?us-ascii?Q?pkkKkiuIL2+fxnd54ajDoSDfI7etLt8udDg794FAqJDAqyzBCrhbH5lnqGLS?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b05ec950-6aff-4cb2-dd6b-08dafa188cbf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:37.6702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Itixh3/eVeoPFPcS+dL3Xhfyg/1VGdbUM5ITMhBrZTS1Q+9Q8mQ8u8bpD2VjOtn6i1OExsaVYoNz604Yt/E6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9376
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change log
----------

v3->v4:
- add missing opening bracket in ocelot_port_mm_irq()
- moved cfg.verify_time range checking so that it actually takes place
  for the updated rather than old value
v3 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20230117085947.2176464-1-vladimir.oltean@nxp.com/

v2->v3:
- made get_mm return int instead of void
- deleted ETHTOOL_A_MM_SUPPORTED
- renamed ETHTOOL_A_MM_ADD_FRAG_SIZE to ETHTOOL_A_MM_TX_MIN_FRAG_SIZE
- introduced ETHTOOL_A_MM_RX_MIN_FRAG_SIZE
- cleaned up documentation
- rebased on top of PLCA changes
- renamed ETHTOOL_STATS_SRC_* to ETHTOOL_MAC_STATS_SRC_*
v2 at:
https://patchwork.kernel.org/project/netdevbpf/cover/20230111161706.1465242-1-vladimir.oltean@nxp.com/

v1->v2:
I've decided to focus just on the MAC Merge layer for now, which is why
I am able to submit this patch set as non-RFC.
v1 (RFC) at:
https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.1952936-1-vladimir.oltean@nxp.com/

What is being introduced
------------------------

TL;DR: a MAC Merge layer as defined by IEEE 802.3-2018, clause 99
(interspersing of express traffic). This is controlled through ethtool
netlink (ETHTOOL_MSG_MM_GET, ETHTOOL_MSG_MM_SET). The raw ethtool
commands are posted here:
https://patchwork.kernel.org/project/netdevbpf/cover/20230111153638.1454687-1-vladimir.oltean@nxp.com/

The MAC Merge layer has its own statistics counters
(ethtool --include-statistics --show-mm swp0) as well as two member
MACs, the statistics of which can be queried individually, through a new
ethtool netlink attribute, corresponding to:

$ ethtool -I --show-pause eno2 --src aggregate
$ ethtool -S eno2 --groups eth-mac eth-phy eth-ctrl rmon -- --src pmac

The core properties of the MAC Merge layer are described in great detail
in patches 02/12 and 03/12. They can be viewed in "make htmldocs" format.

Devices for which the API is supported
--------------------------------------

I decided to start with the Ethernet switch on NXP LS1028A (Felix)
because of the smaller patch set. I also have support for the ENETC
controller pending.

I would like to get confirmation that the UAPI being proposed here will
not restrict any use cases known by other hardware vendors.

Why is support for preemptible traffic classes not here?
--------------------------------------------------------

There is legitimate concern whether the 802.1Q portion of the standard
(which traffic classes go to the eMAC and which to the pMAC) should be
modeled in Linux using tc or using another UAPI. I think that is
stalling the entire series, but should be discussed separately instead.
Removing FP adminStatus support makes me confident enough to submit this
patch set without an RFC tag (meaning: I wouldn't mind if it was merged
as is).

What is submitted here is sufficient for an LLDP daemon to do its job.
I've patched openlldp to advertise and configure frame preemption:
https://github.com/vladimiroltean/openlldp/tree/frame-preemption-v3

In case someone wants to try it out, here are some commands I've used.

 # Configure the interfaces to receive and transmit LLDP Data Units
 lldptool -L -i eno0 adminStatus=rxtx
 lldptool -L -i swp0 adminStatus=rxtx
 # Enable the transmission of certain TLVs on switch's interface
 lldptool -T -i eno0 -V addEthCap enableTx=yes
 lldptool -T -i swp0 -V addEthCap enableTx=yes
 # Query LLDP statistics on switch's interface
 lldptool -S -i swp0
 # Query the received neighbor TLVs
 lldptool -i swp0 -t -n -V addEthCap
 Additional Ethernet Capabilities TLV
         Preemption capability supported
         Preemption capability enabled
         Preemption capability active
         Additional fragment size: 60 octets

So using this patch set, lldpad will be able to advertise and configure
frame preemption, but still, no data packet will be sent as preemptible
over the link, because there is no UAPI to control which traffic classes
are sent as preemptible and which as express.

Preemptable or preemptible?
---------------------------

IEEE 802.3 uses "preemptable" throughout. IEEE 802.1Q uses "preemptible"
throughout. Because the definition of "preemptible" falls under 802.1Q's
jurisdiction and 802.3 just references it, I went with the 802.1Q naming
even where supporting an 802.3 feature. Also, checkpatch agrees with this.

Vladimir Oltean (12):
  net: ethtool: netlink: introduce ethnl_update_bool()
  net: ethtool: add support for MAC Merge layer
  docs: ethtool-netlink: document interface for MAC Merge layer
  net: ethtool: netlink: retrieve stats from multiple sources (eMAC,
    pMAC)
  docs: ethtool: document ETHTOOL_A_STATS_SRC and
    ETHTOOL_A_PAUSE_STATS_SRC
  net: ethtool: add helpers for aggregate statistics
  net: ethtool: add helpers for MM fragment size translation
  net: dsa: add plumbing for changing and getting MAC merge layer state
  net: mscc: ocelot: allow ocelot_stat_layout elements with no name
  net: mscc: ocelot: hide access to ocelot_stats_layout behind a helper
  net: mscc: ocelot: export ethtool MAC Merge stats for Felix VSC9959
  net: mscc: ocelot: add MAC Merge layer support for VSC9959

 Documentation/networking/ethtool-netlink.rst | 107 ++++++
 Documentation/networking/statistics.rst      |   1 +
 drivers/net/dsa/ocelot/felix.c               |  28 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c       |  57 +++-
 drivers/net/ethernet/mscc/Makefile           |   1 +
 drivers/net/ethernet/mscc/ocelot.c           |  18 +-
 drivers/net/ethernet/mscc/ocelot.h           |   2 +
 drivers/net/ethernet/mscc/ocelot_mm.c        | 214 ++++++++++++
 drivers/net/ethernet/mscc/ocelot_stats.c     | 331 +++++++++++++++++--
 include/linux/ethtool.h                      | 248 +++++++++++---
 include/net/dsa.h                            |  11 +
 include/soc/mscc/ocelot.h                    |  58 ++++
 include/soc/mscc/ocelot_dev.h                |  23 ++
 include/uapi/linux/ethtool.h                 |  43 +++
 include/uapi/linux/ethtool_netlink.h         |  50 +++
 net/dsa/slave.c                              |  37 +++
 net/ethtool/Makefile                         |   4 +-
 net/ethtool/common.h                         |   2 +
 net/ethtool/mm.c                             | 271 +++++++++++++++
 net/ethtool/netlink.c                        |  19 ++
 net/ethtool/netlink.h                        |  34 +-
 net/ethtool/pause.c                          |  48 +++
 net/ethtool/stats.c                          | 159 ++++++++-
 23 files changed, 1688 insertions(+), 78 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_mm.c
 create mode 100644 net/ethtool/mm.c

-- 
2.34.1

