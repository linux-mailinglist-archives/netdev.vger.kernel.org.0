Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F5B4378E6
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhJVOUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:20:08 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:37344
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232825AbhJVOUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 10:20:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHELiKVZThVfgokVjEvnwo0L+Yrflw+q4IRZ2ZsNJEbcojgnI4XqRnjgN1226k/IUypMwUS3lD1A2sSys09ldEe59qLJr02g8H5G0o/SAuoFkyDLf/OpRATqCgO2d5ODtPxU5NG1SpggFEVp6vD6srAW6o6HTG+LYz0GUWE3cOeCbjzuf7IfBA8uhqB5ikXjhav9xgO6UnRZt1wA5B4lxNe+OohC6h4aGHcOWDmEuk94Flfscybtm38q2Nkf7UNtYg3V0shn2hPzYgIyrL/52adpkgdXSR78ZvBXhgDWN1FPSK3lpbYkft3F1c3/Ln8HCrWT0DB7qSfalrotXGlp7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daexkmKrS3BX0SDYNibpa2yu4covnDNLCv5FYKJbB4k=;
 b=NcENSnFM+mmR2sT5MsEF4hhIFeWwL+aSqI9kdZDw9Qb7Lczi5eH8TRLO2Wv/WLjnwDCjBNJmQpNwGicbiV4HvwRE75f6y99K9KGUtJs2czaGBAYdO0gD2hVTLnERVhcgZ7CUAgX7JVgGl4fT+e9M7LzjMYnXoOcQOcb4Vmy7kohU+CPiNyrmTzCl7aVMOr2JvsmRSefK3pTGe0Oqp9A8w5hjO32q+CuqnBTEj7WsLtvirLe3H1r8TvL0TywwlVa4Q4km0gwf0oZgpogvVbeV1kbCYuLlFqL5S0y2P4XD+FeFdkEPe/EIyavC3z+hp20D1j0glC3lARqM+oNkEG6UzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daexkmKrS3BX0SDYNibpa2yu4covnDNLCv5FYKJbB4k=;
 b=sJbJ6mxLNFbxNJDNdxmI/mKs/F0QdZLTGwxAQldjkU92x4aB+6PKfOZfJP4zMYBw7V+HDAWm4RK5QnVtH97o8P6N80tz545UMEOg4uekzRzFRNr147nRcRmKXHyVBSGfVOJOWDEltr1IJc5sfTpfPRSTEgbM/rjSJZXRZ/jxU5M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 14:17:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 14:17:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 0/9] Drop rtnl_lock from DSA .port_fdb_{add,del}
Date:   Fri, 22 Oct 2021 17:16:07 +0300
Message-Id: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 14:17:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3650bb80-9886-44fa-758b-08d99566b8c9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3406338EC3D1D3D4B5F8A0ECE0809@VI1PR0402MB3406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 10eQwsyW/TAyRmAAU4l+bIFbRsmRbH9yhlIoOGFmnXjwfQZMdfD7nPKQQk5W05Kzmnn1OFiH6Zohd/Rk/OjwDhn4C0NK57sj9Ck0VL8XtT7l9Xtm5D3rm8Pjsnm/vcTrL1xWlYu/nw6HXEoFD7d7OVxg5k6ydIsHX394QX2jSlY8imLejgPXtb501fHJpOiTPPwgl8c/edhrbCZ2QorZO4ltknf0LVI+rSJQ3a5mE0lwRhdUtc1bxsONPOvNOQx+ISgxBu8yRTrwINpCGT/iNFm3OPTyNcs6hfoRdhY6Ix2OwO3iLOScw/QbdwFIGX2CnmoyxiblbhH+VROTP0O64lc+hDs1kSl0PdBjZPRUgqdR7HUXPV8MMPqF6oaE0iwR7vi/PGYiMvd6otr3dFv91wXRTkXOp2NV8wV0XMbxAjD9T6XJMCI34TQUqUY8tlQB55VK/lt8KrezQDRrmpB+dYMArzgpdoX2oH9QKs08mcOxh3KThZN0hdB3D8JIyAFNQPUodJjmvQcqzYovp72LxSsciwABncnjTWYsGrQOHnicqFLbtkRdrDjnufhOvAIzj8XTw6GwgYOqZDcPtCzNr4vIJ11EIGpf7ouGXke6qVlIOmuq4qWIRTtrYwdVAuXP/HSama/+EoUurdAePqkAiToBW/8glLm0+kOmq4A/b0g+X3RZr3D8mFz1J6jZTMEAAsKloWctpKsbNedu+deedlPtiuHdxNu5/BcFlEHb2t4KIuaIo/WHTFoAWVNA/2W4BSKF7Kd0z+WtDmNBKtaTUInXYfaQMxorF7oV60kLQkex4OUZYvTTUDJKOr8KvOYG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(7416002)(8936002)(44832011)(38350700002)(6916009)(956004)(83380400001)(54906003)(66556008)(508600001)(66476007)(66946007)(6512007)(86362001)(4326008)(6486002)(52116002)(5660300002)(2616005)(316002)(6506007)(1076003)(8676002)(36756003)(2906002)(186003)(38100700002)(26005)(6666004)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nq64BVfebcg3l3G+DsvfBkLwQQIrXtHdvKxs88MN02SFZqU2PPpNx2WiGqRn?=
 =?us-ascii?Q?wlEYYE2TchWb+F6H0ILULEgNE44Uu9PxKReerjsljyDy9EAtNuQ2Vau8omZ3?=
 =?us-ascii?Q?1KQ/8o3h2XYztLQmlZEN39bNGvzFhT/fitzzhdyyM1yD/l+XeTDVz9oY73ND?=
 =?us-ascii?Q?B6YKvHm8B4HJi7+jOMVr+AP/DWZpxrk0uf6Ir7grZgMzHLxtGH6ZxmJQzxhz?=
 =?us-ascii?Q?W10GxRaPyZcYr8KmNDsPk7bdHD7zEVYEwvvPtIR7vdRfb6wwmo1kpN7RGWYY?=
 =?us-ascii?Q?tIH8ivqoeadKYwwpiWNnG/e8DeogHMXRiev4CsqRW+1r4LbN33p/j77yPlYm?=
 =?us-ascii?Q?1TV3E+2gFkgjE9aD/ess89ImXwMp7De6QsUz/yQA2V4d21LvEGKmJX+uXNWx?=
 =?us-ascii?Q?HO0fBn3AA0eNa8C1ykfr7fKQHcU+/gRvubhE68N1RW9sGTkmDKFJCa0RF9MP?=
 =?us-ascii?Q?pgHnN3TNoz/0aqKz/oL84WROE5dVvHaEuMVRlGKuHAd+zpb/0oSFBtaNbdpZ?=
 =?us-ascii?Q?kzFnEtU+x1lviwyZCsu23qw1nXP3dlEX2t1uojsusA/yEoi0g+ZRgeyNNVJe?=
 =?us-ascii?Q?WMvnbTNTcJ7QUN4fTTc7+BspObSs48EvMFeRSfq8tTiuwQr7u8+p1Q8VGLwc?=
 =?us-ascii?Q?M+F3crxpWkbzEuISByTbbVw1AaiERZT49z/7VRL+jQlUGJ2hOR1O+Vg823bi?=
 =?us-ascii?Q?0IPrqSI6Q9AKDRaRPsQQfhMXK7WHDR/tWBDAkMP26nrNL6GkvJLyn6dc7rO1?=
 =?us-ascii?Q?PpYUQWbDgKEsa5W6x9krMKyhv/qKu4DKcNk+YhLSjkmmG6n01ImeU9C2copW?=
 =?us-ascii?Q?C87W4gRJIGvsgL8d+kN79z5ft0EGUefARUqsGycHRNon6274CVPTesdJaBer?=
 =?us-ascii?Q?k+UE3vS9K4p8adIut0I44KCK3LS40xAlxx2Une0dgl09s3kgs7tl1KUqWZwI?=
 =?us-ascii?Q?0o3FDckZn0bhaVEL5mfkpyf6YIF90JppXvUGLlte1/n3/Gxs0eDQG5+7JtsO?=
 =?us-ascii?Q?JvNgfTKTVm+xVr4195yGmk/RIQ/IzkIp22IAqjg2H7JXtebhiWMM4mcq1Kev?=
 =?us-ascii?Q?gv0ExkRuOItgFZ/cimqGzNg6ASCWVdMMAc6uXK30F8SUJ7fjbeAv9wnLhtHN?=
 =?us-ascii?Q?KYAF3MdLjeFwBjfBP+NcKCEZejlxqX1rlS/IS82b+0V9mqCA2LqwJjBuhKEu?=
 =?us-ascii?Q?4OpmA9Rp2CsMkcBRafUWoIT6D3czOTpA7gspmG/dwzrPNrpd7bbs5xIWpyx7?=
 =?us-ascii?Q?F1anu1LT3naoUSiElRmRw9aRu4wfyPQIxTUNDDo6ij69O+bfhJEiUYLU6UUh?=
 =?us-ascii?Q?3wRsX4JDghufwGAcygiBMq8lwtCeJZWyT8+ySvOqjWgfJaMGRClzWW5DaCpQ?=
 =?us-ascii?Q?30OYly8gzhkiyo0jP2lD2BH6BPHn5X6HTMGGgr19D7s8HUgFYS0lo/RA+akA?=
 =?us-ascii?Q?jxPh59Bsb7guighDRcRM5lcCXUQVd4Sp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3650bb80-9886-44fa-758b-08d99566b8c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 14:17:47.0828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As mentioned in the RFC posted 2 months ago:
https://patchwork.kernel.org/project/netdevbpf/cover/20210824114049.3814660-1-vladimir.oltean@nxp.com/

DSA is transitioning to a driver API where the rtnl_lock is not held
when calling ds->ops->port_fdb_add() and ds->ops->port_fdb_del().
Drivers cannot take that lock privately from those callbacks either.

This change is required so that DSA can wait for switchdev FDB work
items to finish before leaving the bridge. That change will be made in a
future patch series.

A small selftest is provided with the patch set in the hope that
concurrency issues uncovered by this series, but not spotted by me by
code inspection, will be caught.

A status of the existing drivers:

- mv88e6xxx_port_fdb_add() and mv88e6xxx_port_fdb_del() take
  mv88e6xxx_reg_lock() so they should be safe.

- qca8k_fdb_add() and qca8k_fdb_del() take mutex_lock(&priv->reg_mutex)
  so they should be safe.

- hellcreek_fdb_add() and hellcreek_fdb_add() take mutex_lock(&hellcreek->reg_lock)
  so they should be safe.

- ksz9477_port_fdb_add() and ksz9477_port_fdb_del() take mutex_lock(&dev->alu_mutex)
  so they should be safe.

- b53_fdb_add() and b53_fdb_del() did not have locking, so I've added a
  scheme based on my own judgement there (not tested).

- felix_fdb_add() and felix_fdb_del() did not have locking, I've added
  and tested a locking scheme there.

- mt7530_port_fdb_add() and mt7530_port_fdb_del() take
  mutex_lock(&priv->reg_mutex), so they should be safe.

- gswip_port_fdb() did not have locking, so I've added a non-expert
  locking scheme based on my own judgement (not tested).

- lan9303_alr_add_port() and lan9303_alr_del_port() take
  mutex_lock(&chip->alr_mutex) so they should be safe.

- sja1105_fdb_add() and sja1105_fdb_del() did not have locking, I've
  added and tested a locking scheme.

Vladimir Oltean (9):
  net: dsa: sja1105: wait for dynamic config command completion on
    writes too
  net: dsa: sja1105: serialize access to the dynamic config interface
  net: mscc: ocelot: serialize access to the MAC table
  net: dsa: b53: serialize access to the ARL table
  net: dsa: lantiq_gswip: serialize access to the PCE table
  net: dsa: introduce locking for the address lists on CPU and DSA ports
  net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
  selftests: lib: forwarding: allow tests to not require mz and jq
  selftests: net: dsa: add a stress test for unlocked FDB operations

 MAINTAINERS                                   |  1 +
 drivers/net/dsa/b53/b53_common.c              | 41 +++++++--
 drivers/net/dsa/b53/b53_priv.h                |  1 +
 drivers/net/dsa/lantiq_gswip.c                | 27 +++++-
 drivers/net/dsa/sja1105/sja1105.h             |  2 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 91 ++++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_main.c        |  1 +
 drivers/net/ethernet/mscc/ocelot.c            | 53 ++++++++---
 include/net/dsa.h                             |  1 +
 include/soc/mscc/ocelot.h                     |  3 +
 net/dsa/dsa2.c                                |  1 +
 net/dsa/slave.c                               |  2 -
 net/dsa/switch.c                              | 76 +++++++++++-----
 .../drivers/net/dsa/test_bridge_fdb_stress.sh | 48 ++++++++++
 tools/testing/selftests/net/forwarding/lib.sh | 10 +-
 15 files changed, 284 insertions(+), 74 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh

-- 
2.25.1

