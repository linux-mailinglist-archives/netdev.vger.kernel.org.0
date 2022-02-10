Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456914B0DD6
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241811AbiBJMwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238007AbiBJMwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:15 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2082.outbound.protection.outlook.com [40.107.20.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A11C2636
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITStqHN3PVc5FfvyRh0uewxdSQ05Zc0rKaQIG/llkhBdjw86PrlZhvmxfzFgWOXEsEPdtLBQB1aQ543O7QscGwGbmNs2zcJ4ZLySL4t22ALcndPPBfkbQtwELomqUIPy6wqyAl2BQTt4v2fZpq3SimTpvy0yM+yAakqwh0Psr9ZePTj+lts8xKRNEsNwhJctNT1N6xUj/37o8mb9U737UM5jtUfLe+Cn17YvOMyTmkR6g10znJRuzfFTW5qJNHKnVkA4D7RWrny/ZrWAyzAA9/t20cRiDbQ5mrn2zmjQzGmna+uHodLM51rN1smWaz4VE6ESIRQWaWATK99k7tgadw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZmraTZOpkGay2u9UnEa31pkqg07Id0/61e9hd1j4T4=;
 b=HvaeNkQyQ3RUxzMazzwDml4FlxcNaLtT3Sw8k/bL3jYXZf4lwbHwMygU+SQoFXUJEZu3AnYM2QFFLR3/JTY+4oIIL352h77HjxeceWsz9YU+s1ha1olPi4EjFioHnLT2nIXnDmshRaRc3ONfY1OX7GtGfklWXPN+mk/A0a0UDC3A6QDZv629DYjpGGW8vu+KHSWaD5uOG3ofAxKhDYJPOOoncNsF1iDud8ZMnL5kYWjpUyNapYKdcgu1JNENRuZix98SnoA4EfB2RF8LUBb6ArhxIRPLA/BsK69Guo/z5JTbOP8jOgzOITYxFHZBNTR+GPC8DvlCfpbY2QdDM7zfYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZmraTZOpkGay2u9UnEa31pkqg07Id0/61e9hd1j4T4=;
 b=XkTvtb+04BOnKgqKABtWrTHk4zJs4OoPHsVRY0ZIDhTgo3szt7G/Ab+You+CFvXS4RmK0c8TKuJUYPUICm/KFe1bBqmXbDUPDP34vQu9z6KvhIYpsWY1+q27qNezZgYC/KLkO/+ZVO9zWw2CRtuAE5gaqQXRdiBwR5Pjxd/QaNQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7336.eurprd04.prod.outlook.com (2603:10a6:10:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 12:52:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 00/12] FDB entries on DSA LAG interfaces
Date:   Thu, 10 Feb 2022 14:51:49 +0200
Message-Id: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1677ced-8ff8-491b-2d0c-08d9ec9428c9
X-MS-TrafficTypeDiagnostic: DBAPR04MB7336:EE_
X-Microsoft-Antispam-PRVS: <DBAPR04MB7336E0227BCB1A6768583350E02F9@DBAPR04MB7336.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSO+gADYY4+sky9bLmFIHzA0AjbM+/RbN8fBxW7GCFMnc13PO5ZLiK+lts395hnxJUCOihOPgAfYRPicfttNSgvfMrbhmgcx9Bf2PmAKRE3NiW0vLlUexeW0ISTIp6ArLq9OaKLsNXIPji0pasYTuJ1R27GA/n5SSxq9o3pLIKvBhjaV3uj+ukYEIfrmKrKUbNWGJIsHVn52gtajWqPzwD6wZLeXfSYgZOiDWqmh2gW9oOD8ZLMaZsp64R2pbQu4x/sPbPCXjod4J0fC5tredGXJURtAc1S+gz7Z/Dfexy04b1dRNHFkrknG0d1/Qw+bqnsubjQ9F3V5kza9m9KXOAJZXx5BKVEXIUy6eVJj1CE7mO4ONXQfvXT8U780NW5kyOGu1zOUBbHCIeQASw3OZGUKBAU6DU7aN+MH7vCtXj943+tD7seiolU2rhDS3k8FyAMCqt1qV9eY9KFyWZJvtKx6/v2bw40Vg3QWF9u4RQ2c214TqHehn+Kk2JIUKYehqlKCEB0XEhyM4xZ0Ff5N1x8ka271HOkbU1AMRM9wGgg+Bl/GLPkDGXumotLLwwL5Ro+ZVqW4+IZ+gKMzLVJ/5mUKyymWEnyOcSV3FbMdIMYUA4yDZPQZKM/q1WmU3ew2hD4CV2ooYFQBZNM69t2RqEHyzWyAIDy5emaA3dqSOjLKjTtErjFiOotMtw0DslUc6+vavDOhkuwl27VNbUuLwOgwlk06xS2+fMpg/tETEIwzyQhofNyqhNBQP2KXf8gaBBv/c+hOqmDuLXjYu3x9tMVj0t2N2fZycCpZDThUJ0ieJwGkXwvsxSZM402xzEa66GQndWMXyXZ0qD8XQrJ97w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(52116002)(186003)(26005)(6666004)(2616005)(83380400001)(6512007)(6506007)(44832011)(2906002)(7416002)(5660300002)(8936002)(4326008)(66476007)(66946007)(508600001)(966005)(36756003)(8676002)(66556008)(6486002)(54906003)(38100700002)(86362001)(38350700002)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XUzCWMq7sgxHQxDpJKzwNwSfZi1DoydwTyu/y+BO+La54MrZVueP6nikBi/d?=
 =?us-ascii?Q?KWPc6peGz4GfOoU2gckzca72ODdLgkBqCZEO4Hy5qBh8zCcCeQrGeBAbTxus?=
 =?us-ascii?Q?MaiTIF2SYrnV+nh2IFo9HYhwWiKrLwYeK2l5xkzRPMs2syIpA8baJeYS+9fp?=
 =?us-ascii?Q?wv79P0E/s/Sw/7bctIlV5G945rEDQjkJS9lSfpH7BoEdglBnzrUxsf5WoFrQ?=
 =?us-ascii?Q?lyzYq/BNm1mjvGhFJr6tzZG/pwPl8TvBylWTxYYi8LKlZgAPxo8Bmi6XJiLc?=
 =?us-ascii?Q?K73p919ZfOOwqCmjpCX4rJVjOP1ueOekIO5i5Hjv5R1vkJIxeiOPi8mTcCiq?=
 =?us-ascii?Q?Z6JdctPoYFeJyVu/6dLWkjwYeUMepT/2TfZ4Guk8ZA0NHMIEI9DY9gGyweBO?=
 =?us-ascii?Q?19LathOHtHNO+rj82R3b33CglYb8cC5PXWB+qjMwcV4B5IIeXqGB505GQ044?=
 =?us-ascii?Q?IItHyZEUyUMXwqYqi+9JwudwR8S+GVFwZR+4ExdqtW5FKue+XoETKb6yZoO5?=
 =?us-ascii?Q?/YHcYHHNokQ86O/02t2rdEXjhNXgLdFEstFSzx4Oz7lqqAZ2Qm6/TSMbBe5j?=
 =?us-ascii?Q?NEBTNy6/wL2bLkTXNkrfHVxyMfqE6U6JvBArpl7f3c35tVf+Mn8nzZD9sl2S?=
 =?us-ascii?Q?DVoE08Cqj397uBzxigTE2mxYA8+xbkeszJL/jV3+K0NUsFm1oBXDn6xmk1eJ?=
 =?us-ascii?Q?2ThyD5SL5iL31fzjJP7SqxHKCU1WjmAWTWrJPcWcdFoho6j91dKAR7GMSPfG?=
 =?us-ascii?Q?BX/zUgrCI9f36SuER9Yoo/LmJ3PccpC13L5v0Gvb3lEaAdluAuuDltXV8egv?=
 =?us-ascii?Q?odv6496vIr8B4fxqPrFZx3+bCGKuq7BkbNrAW1QOWM9nt9Mb3GSINIygevCl?=
 =?us-ascii?Q?ujA1M7JK63U80CTEjypPJsf4EpsbOPwIeuezCUyXlchZpJOtx850OdFwMPI2?=
 =?us-ascii?Q?wZZgf98k1CGeCANOvlnhq0K0k//y97rNjc08F21dnajFgB82yzd9fZViSRDh?=
 =?us-ascii?Q?pA6NDNndeoeIEX98TClU4jbsKL0waa9BzR3stn4dVy6AzxT+Qa+iK7VQ/FNA?=
 =?us-ascii?Q?x8deiiZgg81zJE0bmv85zN4MyImxFImAF3LhMJ1y/kvj4CI0p1zjE50zg870?=
 =?us-ascii?Q?7dY3G/DUWQ7Sbknv+Hs5iSxBSmNiEuMQgPF0WqCO9bEmsD6BRww91XCsTH8L?=
 =?us-ascii?Q?gNfHVyfVCW/rbAoxQmHwlXXPv7llK6GSd0i76qmfMxvDAP6tI0svfz0Kv7Pf?=
 =?us-ascii?Q?Vm3CvFU0h/NcM2ajKvs305hk8kdQfLeUqEJZEayLCSf2twfNl9nkTN3yVczN?=
 =?us-ascii?Q?8uiUjEbbqkKxdYIx/urdJPXe3Hrod1TncBu+HA5e5NlJBW7/EsiHrNtmUsCs?=
 =?us-ascii?Q?MUvSmTmHO/9yeKPciQYeJFTIKB3ZCD3x8ZFqn0XZVIBs57Zj/Xu28O3G6ooy?=
 =?us-ascii?Q?Skzo3P0vnW6q6muq94JKa/JiA83+VXIvqflZoN2do5s95XFJyVxllCa7wsbm?=
 =?us-ascii?Q?r/y7OTa6rDpIhBIbxNyBB7j7Re3alWdabeav9qO+RCz8mXB4Od1sLb8xAsuD?=
 =?us-ascii?Q?H8SncA5HTgfbeLJNzzDYTddYDFBdjSKNze4mXR0gZ9iKuoEaYDnlaLv1FnpS?=
 =?us-ascii?Q?J92iOHp4V5TuTIwfqW5gnNI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1677ced-8ff8-491b-2d0c-08d9ec9428c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:13.6660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYkp/A9PviFtRTAqktlGV/gNi9q49x/UgiUP+LEYZQs8yueNxBOpwTAAEYLCgyQWO+YyDxPL/gpRVjKVCGQXSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7336
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the same content as the RFC v1:
https://patchwork.kernel.org/project/netdevbpf/cover/20220107150056.250437-1-vladimir.oltean@nxp.com/
There wasn't any feedback, so I assume that is good news.
Resending as non-RFC.

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

