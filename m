Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8E166D91B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbjAQJBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236206AbjAQJBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:23 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2081.outbound.protection.outlook.com [40.107.247.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A262FCF2;
        Tue, 17 Jan 2023 01:00:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6GvgvRyOxKSTper1dyphzgSCBIUO/8BNyK3v0BbsJDrFV7IQ60qirC9igxOxPPd8Dmi9YZLIGAH2a5t2w7O9NrEs3xXhYXvLq3iUrsYkLZnSL80+adfks2cLtrrdDm1DmBwRh+bexiMg1T5wRoz7pDXJTzhkgmiokLBLqpfJrwEmytn+l49eZxayfYJNcIthq9xxrFzp5zqZR28fbnlpP4rY8qGuPlRH/rtirLGfEbqEiKdgWtiJWPGRgjOApc/YYmWAQ5K1Ei8MeqB7dd49k1xpVEWTTde72qRn79LXmxhLr1yhJRps7Gwcv5fH+6Jn0+0zVILs8XSKJZARWV/1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKXxV/4DbpgmMY2h/yqmQT1furxdDZ19Auz6XrsZRYU=;
 b=GYn2btsXhOKxDkdVikjCuHfyJSgO2tByYjY7/bOFpPyYy2IzdKvsjYu++iZTU4D+pRhaUD/abIhLprquOuwOD/iG+4JCwB6VdU6pYLznWde1DGr6c/wOOjQsnv2B/y157r1AoLdLZdYAvvykRxDuTzne10lN5+Ki9711HtOKvYEBh9RAMPD+0EIyQvQ8DTPMGRPVmTsAxrmOVfsqtuHMMghw5SBFTFf8Druw8Nj9fSr07v/Sr2vusxuUKONPOLjx5c2wie2a4YYX9+4GaM2PlZt4QUW9z2wJZLpZwUHP8nh9OLscvVURJuvE+XhaVlUVapE8H9zIEhSSUCkQGm6HFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKXxV/4DbpgmMY2h/yqmQT1furxdDZ19Auz6XrsZRYU=;
 b=ZghWkiZ9j9Fa0W85Z/Osq0WV2gL5RdXNZ06KntaJEz8utpw9UEh6A4QuM/SOQJS51xWI9Ii133A4F+3J+MCFyItP6nm0HMtDkfwwL55Kk0swxWv45BBLYf0HUoTN73WswhgGnrhLneEyzzx1XgkDxjxlP6U4eQUttc/Ryf2/e48=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9304.eurprd04.prod.outlook.com (2603:10a6:102:2b6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 08:59:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 08:59:59 +0000
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
Subject: [PATCH v3 net-next 00/12] ethtool support for IEEE 802.3 MAC Merge layer
Date:   Tue, 17 Jan 2023 10:59:35 +0200
Message-Id: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9304:EE_
X-MS-Office365-Filtering-Correlation-Id: 75cc97cc-f9ca-4b6a-841a-08daf86935b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5dZotZPDKYXUGSkPripLtY7DWBi0OCuxiyI6tdu6gvmG8u4udJASJ0hyjOoVAk3fomH8dt4dFsi8IeEeZqAKTdH4QWlb4tMOjB/V9HFCP6o4m9Ugm+2bDbwLbb/8Si0vANRC/6z0XbjEiKAoJIYr8TPvcIPRUR7bIH97OvKqsAXxYR7ZGq41Z3GTNRTtbEq8/3W+UAG0x8m2003jcdnYnd+RRpuFGIuLC44KwErkWzecM0Pu5Nvl1WkkAcjtgoeAEppW4MuQab2VCuwkQ/7jBKImBQwkDJ0d+17e0HTHbd1kAFwlkLkGmCY8ZsjIxaLbi9sXHTH/fMYSA5TTr87C2KtjeNQUmW3JYDGer7B1A4+ydGfVTaguosni4o4htVWjK9wtFlgcuqrbehsOXAK24e4Z3mFsPjH59KWQ3F5OgBW55ee0MzXuOTosnd7g2xLSN6md4ghpdNSWfZcS67WuGQCjjl0JUwhVh6UHWscTo2ratu4Bi3oHcQQ0hQpOKBag29I6EfM7XqVnjgsZFB49QtirqF6vyMN7hfLgNXDz9OpNLxFG/SaPTew3IdJ+c8kDOCQRP2fi76OkFBFna95CFTsHHzQJ7nOi3FgQNUnc8OS7GVY8a7Mdqa5J1pfrPc4YH85gHIpkRGmQqF3nrWyV6oG99FZHZNsUbe1cQbXUoOmMER/OdUgLSZM9alFIX6h2vELrCOGM3klBOHnY7JUqVwbtnOsKxkaW5cqt5np96Md/GG6W0Dv3otMPlnBdoBOD/RSBm7ddo8Ew71+kc6DaIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199015)(6486002)(966005)(6512007)(478600001)(186003)(26005)(6666004)(52116002)(6506007)(66556008)(2616005)(66946007)(66476007)(316002)(54906003)(8676002)(6916009)(4326008)(36756003)(83380400001)(41300700001)(8936002)(44832011)(1076003)(2906002)(7416002)(38350700002)(38100700002)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2i4aGDTeOA5oGIeZKp1hfpxbumblet7cItvrFu+0LlplBHn9FqCiIBG+0Nz0?=
 =?us-ascii?Q?wUk14qfKHLy5Bl+INdxqSD+v/N01cC1HZEAvcTbpq1l43Rn37ZP9dYzM7seo?=
 =?us-ascii?Q?lGVfdRKa64qGqVbmHOcW+E+ctQYi6+3CY71FuSlO/AnkUktJowK0ZSIsjEL4?=
 =?us-ascii?Q?ZKiweqUSu0vkA+Re5QvWY4zwP5R6cQbKDEjb9nUAp8fIQuh32NU1MxuiQt2y?=
 =?us-ascii?Q?E8wuvGfqD6Ru5NYgHtkKBNzK6v7WhTo/rCqphWY80FkfEEnLaBVC5vfQJRMT?=
 =?us-ascii?Q?ofmNXB1l0g6QiSW7S1O5fvwqhRrA8vhJEEkHWxI9rXFtgLmlkKVegBPw8PMN?=
 =?us-ascii?Q?hM1pN8QVn/AUkVD3lnqAtTpHaqQ3Xfni1Wi84iSU6qftGbIuzT4eR9u43iHt?=
 =?us-ascii?Q?u0HKHAtlT9TLSrcXUpZUYqfXldZSPDXZPeqMWbmJw+AZvXqeBA5e4Y8erV+I?=
 =?us-ascii?Q?dMouXMdLgOr18lF5PK47vEyVVJ2FBrnu8AzV+4Y+5C4talVxPZ6wjOzmPy3U?=
 =?us-ascii?Q?vhtlBAMKdEfVVsWPyzl9SFAcBGWj5bhdWtsmLrMNAmbNhelbZbfImodzBWu5?=
 =?us-ascii?Q?6dKtl75zk/ADQKvllIs34QHD0vKK+7k0GGZVy09j2KBJb8qUgO1y2xluV98P?=
 =?us-ascii?Q?krbpX40JAP5bhhTf/beC7Ckw9qjg35RUJ9oqqbVEXp3dSb/ilhkR6IZLpCvt?=
 =?us-ascii?Q?jJ7SANJDpzA/OuhufS7JKMFCmi67RWgQdZNBP2v+CvKpk1v9S3bs61HV9Wxu?=
 =?us-ascii?Q?M7J/JCcXVsQRbdoAsK7bSK9gXPyYhmeovtVR6pCNytqRkFYJE8Lzp3CxyePU?=
 =?us-ascii?Q?pPt/QEyfiSIf+wY/RplLC9StEePRxrH+0QGd0FNZm966nAvA7H7kt5YDiKna?=
 =?us-ascii?Q?P39CTqYmmTzcVEbmYRNINLZZmDKBczNujkhIIjpie5THUXN1em3xjMbPEDcM?=
 =?us-ascii?Q?psovng6nt0k5H230VgL/Jlm/qMn1Jq48rdXd37I1lrZtaZ9XNeVi+WhnzQ4y?=
 =?us-ascii?Q?cjC1gFzYh5GMXTaIELmN6VKG66VD1nK7BghCcudmVo+1C4IgN9QB19q7MPos?=
 =?us-ascii?Q?kIKfb8ekk4GfJJkFPLOFqmzNIyCcGjN5fhmZVU8EB8SHW9Mw19eovj9vSK7X?=
 =?us-ascii?Q?cMkcHZzQMqy0uYbDbBrbowlCzMYdP35d6X10i7qMURVQgzYabEV64Ts5nQg4?=
 =?us-ascii?Q?Pvvkz8N5Q8AaiUNfcadIjwN4E0nl+LpkjMiHFEhH5rm5PKh3EKpiWAAJeM9j?=
 =?us-ascii?Q?1Nn4vOni0oGpglQOR5466h3rgxMajqBxetofg0wFI3gb/wFeEGfeyoLBlGWx?=
 =?us-ascii?Q?rl+aP4TsyYH/TteHIyKiglvZLT3pAl7FJRdzZ5TKxkeI9ig3/+xJ5f3/O0Tq?=
 =?us-ascii?Q?G92px6MQPdA/mpX0vM71gLK6ae8p02xImKvfBQmcVYXPUX+JqLXJ3jj+ifH5?=
 =?us-ascii?Q?IaYluyndvl8b6llHuK8KiCU3p+AoQ6WyYvRuDzgTbeFAV8pGsoXjaLnGJLnG?=
 =?us-ascii?Q?v7uUTze9nk3F8YnEeBkjqJ1gtUXR/8tZOpHowEkG/OY57AyilMkRYM5z11xL?=
 =?us-ascii?Q?epvDgBhmM3Dhi/i7Exvi+aaa/JWa8/YL34/KJaqsdSXl0msKc4RF1zKqcA03?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75cc97cc-f9ca-4b6a-841a-08daf86935b5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 08:59:58.4876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FN1eB3ZPC292fqVa3ihYGM1oCRvmvmK8+qwLEQvr9Q9xgaT7J7D1nAZL1CLtByHWCg4Q49uutUSi1GGjBP8YVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9304
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

