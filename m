Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8944487969
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347976AbiAGPBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:01:17 -0500
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:26369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347974AbiAGPBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jH/RQ5b0z7mqsq0yo0HW729icJP0eJVs4IGKPpCkmrDg2MMmQlj//5ipYMSkTy4lhVEcbBdPA9K225jqAePTd6Mzsesvdm80mPCNXowvdgPNPMPoI52CQ3lDq8nuyZImUXR87kQ9mZC/DTs/XqB9n71XbvP2YcjZewOM8VVLhEhaBdRYFp34zSw5yuCKgw7I+v+eYW95VGMcBbKmJVTbqrf1UIICEXvS07KFRqalaKQ4l/K+nO7JFDAxlmpXWnEWWPMhLZRKayueVOLiUvvSw37v5FaNhDwJ6N8LjHg8/LNyTonDdb7yrSgG5GisV1ofeWVZuBO0/twvm43+pDoqeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VN05tZb/GsQiyVJ61iCo3aaMGCbxA6WKsqRJsS864K8=;
 b=fQzBzXGV/oJTIuPM7sGqZJ8J9y76YkcZGlyl062O4INdCAjgMI9kcQO16QatFkRP25WQr3YBHFgRwMrAkH6wbOdcDlH3nuVKIu4A2BXHixtjGLPB6C5FV5nHfMmZKf5FLFqg/BSf41d3Hix0hE+ZfsYF0gvNOdOw40gXrCDm2rDAMmx6+pRO9LOf4qUxe/8tA0hOx+X3wJIImUBYNz2yKVqkWd7+WC0cc6ccuCl6s1nWJRmhYnZEE3bEYHL3lEpBKQTXAXafMF0ExmK4gmfBJmYRHFvQbFFUlZzCEZmkHc8ECZMbw1p+tqPqUoacK8vVPZd62hPXdsjNI3Uc28Xs4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VN05tZb/GsQiyVJ61iCo3aaMGCbxA6WKsqRJsS864K8=;
 b=UnMt9dANtqI1QVOivwLPWuzV6IV3FkO6C7TAqJAnMMbpVoLlgqXw6TSyqFBJroDfDwMf0D10/ElDFwEgjRl9tCF3Fe4TYZASnohbzBQ3bPOJLYHIEwu2RluDaAs5adSw1wZeP9sxAeSF2TMYgaLSkXdVi/pymygVmh6r2vsYZDU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 00/12] FDB entries on DSA LAG interfaces
Date:   Fri,  7 Jan 2022 17:00:44 +0200
Message-Id: <20220107150056.250437-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6efa63b9-934e-41b3-34d3-08d9d1ee8869
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34087A018723181D587318F5E04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CN1kJji9HYCd4RRREKhLIkDdxSneM0Jlj562Do4U1wwrjYqmRNcJ3dkgbzXkCbkSViSk1C41uQOXEHimP43QBKs9fKW/W4ms/ZTLSMuaiWBUQA4atcJ8+KIa7pfLFsC9T8lzJMCf0/DDXKcRlLVebPjVAn324T/X0ek+OI+T3q/1lxQ58H1i2zhNNKAOoAwiGyWJcph8fyERrFqvvYUD1w6GletmODMSev8jFGNrEJk7uD/og5hV5vXLkOTrJ39Njbq4+0tXjJ0yDzqP0yL8+qAjFQIyVcXFuN0gvD0KAgiUO86MxctIzbOlup7zd5xSEUXWJmVQL7Ho1TCLJSir7+ZPxBaQCq1p3XhXtX6XtvCU1CW/TcHZCEj3G3ZK678WHiYkKc8/oYK1N3xNF5UnMGI6hL/fbWD8tNxOCZLiZAP9iwAOgs+WFwDyjblH5GprnmSY9rz1NudnROy+I8yZqxddH3GhETdjGALRrslRc4oIPMo2QS0cY82NeXlatHhka9tg/Hxu87ytIqy04E+xvzh6F5Kr5DCyn/ffACpjZZeDfCr0EB6RpvQ2APQQInQnUrcKEtuNsmBmA1TriPaCiyn+clqhDWKdT2Kl/k2L7BMzo1nqSz51qPvHPeGmHo698+ZSCqkh42YbyC1+hz3JEReYxV0S/4G3Uds2wPhb+pFAPzlg4pEI6CMj0r7alG/uQ6iEZ3j24sEZkHo5/rw6SOQaCCmdNR7aCsAzr3sjKix8yxBth8lgRld1UDJ9PTstHE8xaYDilRZfz5tyMXyFvrx+7FyofgWJedwf+H93SjY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(966005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vSOaFFKI8HvxPN8e+0g88vV1rY+7DUxT6sxxDesS+jiIZ5HFs/UWfgdeCifZ?=
 =?us-ascii?Q?tXTAMsrTf2b1KsXodtfrOWJAhTO0Ra+yMQmg+dHFNvauGNZtjz3LsI393Kbl?=
 =?us-ascii?Q?jEnKELqFEFnddX5xZye47hMXJEM+5oj8hoyKhD/N/h/jaU0fPut1Pdim3Zrc?=
 =?us-ascii?Q?1AQJ67Ulb9Io3YCimeXDOIT5T22Wyolx9ErMwGdUR7eCSPySP4dQbMJHEhi7?=
 =?us-ascii?Q?L+0WOj+tKC4pn9y5x5LSc0h9A+aeu/qpSOUWq+bfXb4UBZlReXWVkxDwO6cG?=
 =?us-ascii?Q?LlgeZ+PRQwjPDZRMA1K9Z1rEdfPCktcEAJoBev/puCKfkTSBFwgDPwNwTQZo?=
 =?us-ascii?Q?ocK+eng/Xij392FR8IN1r64BAKD2mMqh5NUJKc4q2lwApeO6oBRudHNhOIX7?=
 =?us-ascii?Q?U1D0NcLR5PuMTRH/BVviDPXGKKlIBab/M4tLwiHjDCkWllIrpyGibY3SpbFc?=
 =?us-ascii?Q?Al2wUxlnQ3MKXenj3jktj+Zrzee7jM+1CIv4Sd+pC/u0UwdYMYbe8oAQ1rSN?=
 =?us-ascii?Q?vCkPy8SruWPqMZUqwvr28MCWz/g8MLe20bQ3f4j+XPobSflQcyBKGbC6YEt0?=
 =?us-ascii?Q?GVfd71tPxmyEXoOuzUmWZvcBedaM9RxBXIDUqhogm6m8/KDWJAZktK68N0wW?=
 =?us-ascii?Q?ldWt+cGvi2x33EufGy7bmYS3Hb9P2tu6esQDKdRN2AiELEAdQZuu95D/KnF/?=
 =?us-ascii?Q?KQ+H3nXCu+PXow6ZarOo51XSYvpoOC2X9LVGjOkoChzId0Sw2H6SkTj5AE40?=
 =?us-ascii?Q?zh5MtgfxgnjCYFRq6N/TNk8OtYBAKAPfa1CY3JuR+1X0zTw9NrcEdYpOzzfZ?=
 =?us-ascii?Q?TSU7ZmuPYEqYbeDLrzGKUrtBQ1UbuPWB+Miu0YVuPqXNwmSAKE5nMOpn7VI4?=
 =?us-ascii?Q?4oIJzaROgmuEPfbj2ct2c6FYd6PC73BHuBfmaV/cxEFrhI981VWyfkjs0ygk?=
 =?us-ascii?Q?yfW7zFVq0eVXffMeWUebhntCWXY2YDUqPBv+zMcYG1mytXc/vreDCrns6z+h?=
 =?us-ascii?Q?TWJIGjp55GRU/bKK+Kp1fn0Cl9rYpOJXNZzzBbltQVVkMJF9Wy94uRSebMOU?=
 =?us-ascii?Q?qcSm/mBd2A1zyo6aYT6OZ+6yd7w8gtMALu7YowLdJQUXS+hyKAFkGd+fRlig?=
 =?us-ascii?Q?qqUkpObcRZf2KYH9qDGQMvLQEP60G50yLQ2rSXoUwnSypg+/rwA4dyGaKgKi?=
 =?us-ascii?Q?lW7iKAj1z/y/EIVIWhLJqJCjOKjfkVZi5MPE6pKvW3kujb86UOosgVSGhKJu?=
 =?us-ascii?Q?VFR9/oCfpI6pmG91Yw6PzJqUbtF1E5eyKMQnmbunGxTv8+mW4SVpjQS4rs5w?=
 =?us-ascii?Q?Gi6ZLi2NUxEap2aIDYjTDfJqV1lba7hFF5GfmUlPa15wuF1ofMEOY5Fi2RW/?=
 =?us-ascii?Q?CV9RhCy852jlbYcBKUOF8huqwCBVmSpnodbYhi8Sqd2sBl4usT6hLoaPWhIB?=
 =?us-ascii?Q?AIKB61b9Dgv5hA5+NGgfyhVjFU63yDO3uKkpL6hswOS2I7YA0C1eVj6WBrNN?=
 =?us-ascii?Q?MqMd2pw8xNsHTxm8hr6H1TNh7HXGFeos4syBdiKXDeqGcgdkk8LRPot7b2W8?=
 =?us-ascii?Q?cG7aZhldldSEfwy34nQx0gJXzoC6lqIfdI/La7Dv9NhqOHdk4WJh7IH57Zir?=
 =?us-ascii?Q?3im0DSqTt7RNW32eCFF/338=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6efa63b9-934e-41b3-34d3-08d9d1ee8869
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:07.2059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GP4SlUjfYHCdGHzUvdS9g8oFXZAh2dkwGh27jrpSgnDt6AiLbZ/LX8coCjxlT6keyS4VQ/bjwIYgN2rkBeIixQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC for 2 reasons:
- it's a bit late in the kernel development cycle to introduce such a
  large change set
- it doesn't apply/work without the following in-flight patches:

[PATCH net] net: mscc: ocelot: fix incorrect balancing with down LAG ports
git b4 20220107135839.237534-1-vladimir.oltean@nxp.com
[PATCH net-next] net: dsa: felix: add port fast age support
git b4 20220107144229.244584-1-vladimir.oltean@nxp.com

This work permits having static and local FDB entries on LAG interfaces
that are offloaded by DSA ports. New API needs to be introduced in
drivers. To maintain consistency with the bridging offload code, I've
taken the liberty to reorganize the data structures added by Tobias in
the DSA core a little bit.

Lightly tested on NXP LS1028A (felix switch). Would appreciate feedback/
testing on other platforms too. Testing procedure was the one described
here:
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

Vladimir Oltean (12):
  net: dsa: rename references to "lag" as "lag_dev"
  net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
  net: dsa: qca8k: rename references to "lag" as "lag_dev"
  net: dsa: make LAG IDs one-based
  net: dsa: mv88e6xxx: use dsa_switch_for_each_port in
    mv88e6xxx_lag_sync_masks
  net: dsa: create a dsa_lag structure
  net: switchdev: export switchdev_lower_dev_find
  net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
  net: dsa: move dsa_foreign_dev_check above
    dsa_slave_switchdev_event_work
  net: dsa: refactor FDB event work for user ports to separate function
  net: dsa: support FDB events on offloaded LAG interfaces
  net: dsa: felix: support FDB entries on offloaded LAG interfaces

 drivers/net/dsa/mv88e6xxx/chip.c   |  46 +++---
 drivers/net/dsa/ocelot/felix.c     |  26 ++-
 drivers/net/dsa/qca8k.c            |  32 ++--
 drivers/net/ethernet/mscc/ocelot.c | 128 ++++++++++++++-
 include/net/dsa.h                  |  66 ++++++--
 include/net/switchdev.h            |   6 +
 include/soc/mscc/ocelot.h          |  12 ++
 net/dsa/dsa2.c                     |  45 ++---
 net/dsa/dsa_priv.h                 |  24 ++-
 net/dsa/port.c                     |  96 +++++++++--
 net/dsa/slave.c                    | 253 +++++++++++++++++++++++------
 net/dsa/switch.c                   | 109 +++++++++++++
 net/dsa/tag_dsa.c                  |   4 +-
 net/switchdev/switchdev.c          |   3 +-
 14 files changed, 691 insertions(+), 159 deletions(-)

-- 
2.25.1

