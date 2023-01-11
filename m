Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95B366602E
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbjAKQRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbjAKQRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:32 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0356C1C921;
        Wed, 11 Jan 2023 08:17:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9LI8IFEIpUFzuOTAGZ/RnJVP6E5NsDYAIAy5fr0F2utMQPSpCi9wgjNLhIbz3UBxDPctMPmlmpCztVSX+tMVWEiyvm4/0XutDTDh+CzxQUWi3M5PXyKYHlHne8mcymbETfVjyx1E+4FnrE845nUhDc6jK0kaFqATM9gFQ61cH3pa2/ehhyq9IUuP0GwoN1os25cQjiMNkizqNyjsJuFrs3DUZWjxGvWeUgXRM4D89zLazLo1mPgmksNUsJyldzrXd+Y0SkUUedEIThtzKF3K8bz9s/yuGgk8Baif2/6ljgJSoqTP6doQUPtAUaVDZzVqxzbfqeqohoofHrv0owyGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOq/BfDDC/v6g5kKEr5MBnUn6KefkNGrzfjf5oYBVv8=;
 b=KG7+TVqxjWAvsFWvIdE2OhotN9jbp0yEbv/bfjZn9/kRJKa6FB8RcMWDNsqmEAvppaekYXhB5vHmzgHkknGSc3Yh1s8x0jWxdYhoSv33c8M+ZA5gCczJIwLZqGDzVoB/CUWGop8h5e2NETYtlOy8oCnsbK6t6Wz4PahTtxInY3+7oUwU9xwK7Ck3VQnMCWgUw94VGJDJiUCGGQhoLCNHmq6TCX7KNbWqSwVYWizxw+a8qRevUpxAuvP4eYF0w3LacsI9ZQgp7nM561z6Ck7F38RRIKVDH3I7jPtTQWyyviE2QVjpQdU3uc0lIw3wx2oI3q+DPzIxMMEg+aBk/15vdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOq/BfDDC/v6g5kKEr5MBnUn6KefkNGrzfjf5oYBVv8=;
 b=aSs8+GnwdQX1rsz5uQ6AWucvISLSAPOUMd7kMXQBzzhHtfMHlJZD8NiOCiepjhEnpOqpYFFdPIVM2wXnW9wuoFrP+hBmRngtAM1KIMgDmwrbuEmilmGIhr2QkM8Rr42hISOWDxABzBUGSce40OXaBuPuWPTuT77G6Q5nficdkcE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7168.eurprd04.prod.outlook.com (2603:10a6:800:129::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 16:17:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:16 +0000
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
Subject: [PATCH v2 net-next 00/12] ethtool support for IEEE 802.3 MAC Merge layer
Date:   Wed, 11 Jan 2023 18:16:54 +0200
Message-Id: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7168:EE_
X-MS-Office365-Filtering-Correlation-Id: f00cb562-bfff-4b4d-33c3-08daf3ef4e47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwwREjBzwS+odJMxmBky+PDp5onnkaPSmcyuiQYhLCsmA3bDt4LFyDnoo+2jGlZKFW+AYIfvmic537d6mOflIQS2FFaHFI/8Hh856T0sry8FhemNJpfUBF+KzCcaCEeyfHe4HH53wJwsaBpc+XaHzDYohxsMMmdHo7FfgBaJTJpmoOb4wjTUyCGNN2F3kMaGw5TwYm2+dx6OLoSIrE3u8LOcGol8Qd9OQ+/daTtKR7fzYYNQznNhKXfuWUvfstrRoD5HuS3Rc/OKukwPZeWu2Jf0zACYhX+zmGv8O8l2aQtjXXhQdpTgYdSWavej9Czk+tUS2+kQZavuQYlt5/sz3/GgxbVzEvXV6geFPFNeXaS3BaMjFGStp2BG5VjjT4MVXgkXk/LddqagrNXLEEEGxxm+dRtb2+Zn9gmh5Gg/qY9yOWd2YZtvyjJoNeN3hCwkW0tTVmGQAPinTzfdbNNnK+AcHz9I1yFuOryTTEcMvoBPa5bqJFoC1eM6FxXwdcHu1lA5NXZPLTOZ4dq/hSP9b37ews4u1mnyhCZq46qX5xtNLm91Kcmb2yZ8IvVMI3Dw4bMmv/JFIHEaJq1eY0ATN86A/+tCnqbs6ST4O1R+6NtfxUDI1O8gL5Q5rvwS68rnqClFoD8jNPrdgaK5YWvOcPJjjfCX2Oke/mEEBUt1IsU5H7jI9v04kiU4Gn3PheSUYje8SmuDpJPMXqz4tspaykdlOWaJwcNYeVf0r+m/8kFVTkX6G/xHFNCGHQd4CAskubC/EdnBFwrQAODVbLb7UPfBgRXvm8M4g8CuwaQx8P8MqdM3m4YwYyRtMr9VK4DJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199015)(478600001)(966005)(6486002)(41300700001)(38100700002)(38350700002)(6512007)(1076003)(86362001)(54906003)(316002)(2616005)(52116002)(26005)(66476007)(66946007)(66556008)(186003)(4326008)(8676002)(6916009)(36756003)(5660300002)(6666004)(6506007)(7416002)(2906002)(44832011)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n1o3JNqXjBEvZ6XWZE28Y5OzuiJtgqXu8AfTbsBEUkZUU42z5qSpAZDgATlD?=
 =?us-ascii?Q?jePDdVcKi4w0KbrGQf5qk7flpMV/DRAgTX/KEUPqGAsp94Fzv78UabC5KZ6s?=
 =?us-ascii?Q?tGcgrjPylPvdcBbtJtqpvEfIxxdcAmt9K3HFx+930AjGovoeTjy5bjgjQbRz?=
 =?us-ascii?Q?haVNQ/KAckyrPSYxurrdwiv+oC+jZnzZMu86gu3xlR+4ywrpNpdl6szy8D4r?=
 =?us-ascii?Q?Cjr1mfBxs/w/TLxgnlbGfl/9MqdWn1P9vrpG5NgjHUXNgNMlaQc5T9c7u2W7?=
 =?us-ascii?Q?IsAFvYC9JmQ7irxIFzcHrG08dyI+ptnQgq+odZm2GufvSIxSkahXGs+71R4P?=
 =?us-ascii?Q?vQSyRcD7p1QHWt3Z7Yxb+0s/OPMZpCJUvnBtFVW4RuZXuQyh+05IA8sRW5H+?=
 =?us-ascii?Q?hVgE4q00Zk0CO42LqD+a8OOcdxNtbtJr8vnGLed9wwj6admCa1nvnS/ss7iv?=
 =?us-ascii?Q?3TnYgH2EeGvNkLPJA8Y9X12PuqFG2nDAHpXlGXwZOZLFXWi8oYM0KYi/+mvS?=
 =?us-ascii?Q?/7ba18FrCtEMZTKu9Dkxo7EHMTjjJ6flhPzkFKuoMGZePQY3a8dufIyq6/UB?=
 =?us-ascii?Q?ZrvVt5iWcpKETYdTTfn2s2rIZDcEsPSVof0kTlwopauSeB3qNcAikXfK1E7A?=
 =?us-ascii?Q?KxvdzNK/YvJYuECQ6XsaJeBnaAaEvI1jENqTJwp8VbSEV8/qMNC3CAaxl5f6?=
 =?us-ascii?Q?Obe4ghpxo7+oWFC2Kj7gKR54XPq9OGlOFsJWmglvAMxQ/NpeJbYYk19NEZul?=
 =?us-ascii?Q?btdfQQW7stbus3QMx1tjC7LGerUpEft5Y+p785rJ5QkwV7lyMuhcAHbZoIkb?=
 =?us-ascii?Q?aC81zniQj6TwQLXg4kkxzsCR8LsISOI9/E3Q7w86XRFp7qngxOHSeQH34Tio?=
 =?us-ascii?Q?uV1o1/x9FlvSYGAbLWx9U3kHT9BuWzj5pDjGLbwMIsuOcproyrudeiJmGBWh?=
 =?us-ascii?Q?bUNmB0AYBNcR/NtYIOkl771KHep4HJC8leYGwsl/Q4xQg6qRPM4yPotEfvwe?=
 =?us-ascii?Q?ppJoCBBvhitl4zTOAP3xaMXvBuYPzeWVg1RaCCNVc68FqozjNBRSe7NJq0gn?=
 =?us-ascii?Q?jLvLc28UO+sY7hK8PSdE33aB1XFvHlG8/umoZDclmir8dn+Lg6zwnWzqXQW7?=
 =?us-ascii?Q?KSSBPVldOro3ovLWWlwr+Ic/J/qeHBNfVkF0qusk1PTHl6HCTqTIr6Fvpc//?=
 =?us-ascii?Q?PCmW5nSd7zWzFxXDhTR7sepg/LxI+oKKG6mJMHaASlm34MDJGk1oBvY0O1w5?=
 =?us-ascii?Q?PRC3XdL6IcSW+eoxSsmhxphPCM1VEkwrgYxZoYWYWEaRfW0gcQkJrGGqqvyJ?=
 =?us-ascii?Q?NDobcvqpwuEKCfvDkhm/QxU6/uEzOI01TD1P06tmuaRZwHn7Jx1XFZyQfStm?=
 =?us-ascii?Q?FovTLz4XGRC3P9m2MozVPPqDMjCbExy+42miUBcsb1Y5NxUfEJisxW+fCWtT?=
 =?us-ascii?Q?1vroeKR/mzsuAJFKC+wIh4QkajNV/jiold54FmN9suIY21BpHLyRSNsKsi2e?=
 =?us-ascii?Q?dNbHV3oTumzeOm4cyjddE5oNx2sxoqC2YydBY5O/X759OhLQcQLlcukvwCAN?=
 =?us-ascii?Q?42Ueh/gIQhhqHtsaP0nFnDwV68g6dthoeJaNauXzRPIBJ4RiNnLA/sIZnAfu?=
 =?us-ascii?Q?sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f00cb562-bfff-4b4d-33c3-08daf3ef4e47
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:16.3775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erSViiAqgDD54YWSGEz97fzW0pkUs8daqN4iWKd3UR9CQqNc6+E3tawIFJZ+jwDqkWIS4x3Q1RkwTaekcCmS8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7168
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a continuation of my work started here:
https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.1952936-1-vladimir.oltean@nxp.com/

I've decided to focus just on the MAC Merge layer for now, which is why
I am able to submit this patch set as non-RFC.

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
  net: ethtool: add helpers for MM addFragSize translation
  net: dsa: add plumbing for changing and getting MAC merge layer state
  net: mscc: ocelot: allow ocelot_stat_layout elements with no name
  net: mscc: ocelot: hide access to ocelot_stats_layout behind a helper
  net: mscc: ocelot: export ethtool MAC Merge stats for Felix VSC9959
  net: mscc: ocelot: add MAC Merge layer support for VSC9959

 Documentation/networking/ethtool-netlink.rst | 123 +++++++
 Documentation/networking/statistics.rst      |   1 +
 drivers/net/dsa/ocelot/felix.c               |  28 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c       |  57 +++-
 drivers/net/ethernet/mscc/Makefile           |   1 +
 drivers/net/ethernet/mscc/ocelot.c           |  18 +-
 drivers/net/ethernet/mscc/ocelot.h           |   2 +
 drivers/net/ethernet/mscc/ocelot_mm.c        | 213 ++++++++++++
 drivers/net/ethernet/mscc/ocelot_stats.c     | 331 +++++++++++++++++--
 include/linux/ethtool.h                      | 245 +++++++++++---
 include/net/dsa.h                            |  11 +
 include/soc/mscc/ocelot.h                    |  58 ++++
 include/soc/mscc/ocelot_dev.h                |  23 ++
 include/uapi/linux/ethtool.h                 |  43 +++
 include/uapi/linux/ethtool_netlink.h         |  50 +++
 net/dsa/slave.c                              |  35 ++
 net/ethtool/Makefile                         |   4 +-
 net/ethtool/common.h                         |   2 +
 net/ethtool/mm.c                             | 273 +++++++++++++++
 net/ethtool/netlink.c                        |  19 ++
 net/ethtool/netlink.h                        |  34 +-
 net/ethtool/pause.c                          |  47 +++
 net/ethtool/stats.c                          | 158 ++++++++-
 23 files changed, 1697 insertions(+), 79 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_mm.c
 create mode 100644 net/ethtool/mm.c

-- 
2.34.1

