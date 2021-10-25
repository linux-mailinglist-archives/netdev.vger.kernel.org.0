Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC9443A66F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhJYW05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:26:57 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230160AbhJYW0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:26:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWMfgrjR1JJs4jo7K+JoXG6K770rKuynsSTMC/FwYm0UQHdLIkpa5IPmSHNseD4N+eo0CM8v376NVy+N6i8m73P6JuNBj/rUj0DCfWvKh6zu1HdU+oktQ/G9LvNUq8FfQVXH+mx2jp6fWAss9wyOm6TdYsqs/u21fxfmaKSUd/wMWCnOJG5hQd/43i4cJFWNur8dsuKXjYmVBvmsvqS39s13qCAsQd1wUmBJ3LA1xWzr/D08DbUhurZfbOTgKPPhHhRZbBAoDmpLZi+yGq5qDMVvQzwXoZwzbNzCjXrkGoGVsW5i1ldBwSOCOQgAWHpZ0vODiFxo/phrGdZSb9HcqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpDWB4RV32Em87iIbLRqMPppCzCvpcsc8hr16xVRwvY=;
 b=Lx8KnuIr88XZPcUaVYixRJ0vsX5DyXUEOXjXzu+JB9WD3TyrGMFnWGgmEfPWTSBRbA79+XmxCd44+nI/nGGgY/KPKHlIopbkUiWD1ddtO+jbwi8AgqEGeKBnwhPHab65azwCW8nssid6V/9Uh5MiJP7ObM/o0Qv8+7FyKcDG+Wq5E2Rn3JBogFyKOFINSWP/r9R2HNPXrL+d/AwS03bbnmJiXYqoipesCnNpxpJTsfU+RfC6zC/nIRFZtYhSXqgnIyuckREJNFy5U7kyV/FUDlp+w3oYvTL30sS2BfCJ6+K+PP/k7W/cJr7IXZqVIghv4CcV4ObTn8Rj2zGEtkAukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpDWB4RV32Em87iIbLRqMPppCzCvpcsc8hr16xVRwvY=;
 b=S5v6AGjqzl148/93Q3uLxbTcbNV0thKqsk5h8SMJGquxvLyXfIJJ6fk8X0PRYU/j/nmX8ZnWOZKf0/yO/FeMfDvIVDyU6XXhh62pz6KMJbQJxHFTgIRL+1cqbZc54fza+moiYL+gtfjP33NUWRtm/RVvd8/KbKah1RrYa2VY3K4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del from switchdev to the bridge
Date:   Tue, 26 Oct 2021 01:24:00 +0300
Message-Id: <20211025222415.983883-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30cf3937-657d-4da7-727b-08d99806362d
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB230451B705612D5A19720D39E0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sptUh81sW+n3ZAYSI9JyPM01xY7AHC3n6p/S9o/+C9dOazVWSlOlQcE1O1WrKbzQIbNzw9gUiP478wmaCrYBr27WHl+zZW/OV2xkgsTE7fNFGHvUJF2D6/28ePCAwA9RHaj74965Yd4B1MM0SSwgeN/LhXWKc3ud4WdRhu4xCRDMZCDSrtNdacgL8aEd09Eyl7v7FyheA5X8c8FkHSQc2+ZdRxu69xh0cte1xl+iKc3W16ZE3dC9zmrK314AmvQHThfYSNL3WAJ2kYxP5NwvIm+xFOsd686acmnHqzEDNitFMOykb5yQ3rihdfVHp0c4AJILYnXRbN+L2UmXNZvaYLtq19vdIpEk93z+UksGElmj2orJvpp/htoyFPa5os2HXQEOI2PNJrjMvpgcRcrB+bIXJz0cEuY5MiR1SH6kvzOLIWr3h1jbZWcmG0fS8HMGTaNhAC26YZCItItDrxEsRNlV47sRMdTu3oEWjq8nvMAF6LuJgjK+v6W7ymSNaJNo+Qb1Kqdb/rOI2koeSEpzXZpDsUcYc73rrSS6RF2h3aRo5wtzF43HDBtzQt7WGqN7tvVxi3b6ZsQLSkspOzBBX8rf4zcKIcUgmWFcIzwL3w7kxxNtOUqvwJa1JhfJcu4VzvKDFWrrCNKc8FZVvohEMEkyRmUSB20MVZj6IcGk3zEOnq7f0t9/c9MtjAbC+eTHIbLGlv7UQXDnSWiKFl6PQwTYFh7mQVYVUIsYnhoBvtFaH300W9RZ7bjJGZ3FPrnkYrsJdsCV7Vc59EDRvA7iYFDAbN/wuOkLj4Vlo5S8Pyo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(66574015)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(966005)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z1iYMulQF6RHPoxiqgmRlLbgDls6T57Tc7V7vsdixtxQR51KJlmXwNpQiBTr?=
 =?us-ascii?Q?derEERYwbVA0utwDSMVTUVjEfWFYoHxKArs0JIAQJ837gQOmX5CVboYAQPaG?=
 =?us-ascii?Q?Iw4VMaNZt0Hd6/H/ZGirEtxjtf2Lj/75j9UDVBL4Xo6tVnWoLCT0RuwHNEmE?=
 =?us-ascii?Q?Tm8Pvahj5W0GteePaGiMroEe01dPOwWjmOguMHJ2efMAFZ3nIcjJQ/3kY6i9?=
 =?us-ascii?Q?ahJU0lAQTyXPpC0RO/DJLe3mcQX4Fvoyq3rC4tn1w548LXvhKoiAufto2beZ?=
 =?us-ascii?Q?5LpsF1c/PpVpOcm81YSjwMFREqNE5p55zlvzdAkxQfGP8WY7kXH7oY/8zKD3?=
 =?us-ascii?Q?MS2btoYIW1OMvEyUXCxKSFsurNTrlQToCC97IMHtf6VeZg6bU2Mos0hIyLfN?=
 =?us-ascii?Q?73sXXxI0sPnSJN0k9cC42jnkVsv/H8P5Oum/9jAltUpHWMp21+Y8e1aIS42M?=
 =?us-ascii?Q?UFfYW88tVcwiZMu5dXPmy9B+DmSwz4iDVElVC87uLzBgN/XQgOGrW566qDf1?=
 =?us-ascii?Q?qIaiQug+OcOzeBFpPm1APF2JJnDxCAjzJqAC5C5T0xxOF1F8NacIYYyuuNkS?=
 =?us-ascii?Q?KiDsSQc8cLiD5vfwqXZzgLUHpvgF9z4CZ0Q48p1IKYgL2ZqgAw74UiZbmjv4?=
 =?us-ascii?Q?EHMdqxXgwBntLn6/PwjbYcyb/zrC8N82ECTBKte3vkckRV2i59FUYD112uFA?=
 =?us-ascii?Q?D5EYg+h55e/XOBjHsWhovABgp28P3uFAFwabT0+isqZWi0wWZVbrMN4hlf4Q?=
 =?us-ascii?Q?izr/6x5aBo6FKoceYa/lcAjSKyu0S8U8J205D2NLljzibkESQVeGBuzHYU9a?=
 =?us-ascii?Q?5y0x11A2hw9AaP/X9Bm45l5XQZ8OqVXy7aef4CLyJOKfCRm0G3igLiupSf42?=
 =?us-ascii?Q?WzH6VG1vKnAZFajhHSpuiEzr5upSTt5NXzUlGN8V2wTAz8OKSf7cGGfqEMvN?=
 =?us-ascii?Q?XlVV2TZVzfuvhcKepBdY6vAqMji+qrOkthl/dcC1it2DpBKDlYS7sRKj2LAq?=
 =?us-ascii?Q?lRd+HbSkI8cWraVeOUDkINayFio8FD1ALZEUDnpD55MIuMY5t3NQHnghPtyP?=
 =?us-ascii?Q?Hj7qd/bVIgoexr1IOpGf/hKUOASyuSWmZVlB2Za0ZV0odgKGlCyeuVxktnzt?=
 =?us-ascii?Q?5TPcnjY6WueiW6kewmZcHOUN3c03Qwh+gB0Z4BA1Vz97EelJAg7ptiATd57r?=
 =?us-ascii?Q?owLzaOhx7oBSt5MhKDxsEsLeiKXqRtCfVFCAWz6Sfp93R5/jLBJYS74Wmvsy?=
 =?us-ascii?Q?1xvTuObMRkj9GT1EE4jIJguqfLuTgT3bdaQGCXIWSEwZEJrSP1ivrfDwwr/X?=
 =?us-ascii?Q?HK6Eu0Dyb+k2K95l8JtLkhwLwpg1Kfb5qguk0bNnm4RBm0SDoPGB+IFIQYPq?=
 =?us-ascii?Q?3DMFO/+/Fm/SMMxey2GiRbB2oEs+d20cLjUod0pzx9z7OjZneTV5rQ2dy850?=
 =?us-ascii?Q?JGY7Awz7BoQGdbiDaZa0aa5kQfgqG6yyynJ//e6uCTY4dV7kPcCeN8EqO13o?=
 =?us-ascii?Q?Be1hyev+F7apGqTIJykuiwO26J0LYU+BWRQ+a30sIiTNVbHsB2eKdSApetR0?=
 =?us-ascii?Q?PJjv8WGGO42zyXcuR9HZdTLfg7yX8ptrloE2Ou2V0ZPkIoZDXWWUAB9pxdha?=
 =?us-ascii?Q?v+FcuILzI3PdTjBfTnOw3vk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30cf3937-657d-4da7-727b-08d99806362d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:29.7138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QYPyJ8R/u8ru4/ifovMS8m2K+4AlRXGX8Vv17eOGoU748atjoxCTvifZX/WrLFvrCQs/IPojN0Puzd5PobFDMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, this is me bombarding the list with switchdev FDB changes again.

This series attempts to address one design limitation in the interaction
between the bridge and switchdev: error codes returned from the
SWITCHDEV_FDB_ADD_TO_DEVICE and SWITCHDEV_FDB_DEL_TO_DEVICE handlers are
completely ignored.

There are multiple aspects to that. First of all, drivers have a portion
that handles those switchdev events in atomic context, and a portion
that handles them in a private deferred work context. Errors reported
from both calling contexts are ignored by the bridge, and it is
desirable to actually propagate both to user space.

Secondly, it is in fact okay that some switchdev errors are ignored.
The call graph for fdb_notify() is not simple, it looks something like
this (not complete):

IFLA_BRPORT_FLUSH                                                              RTM_NEWNEIGH
   |                                                                               |
   | {br,nbp}_vlan_delete                 br_fdb_change_mac_address                v
   |   |  |                                                  |     fast      __br_fdb_add
   |   |  |  del_nbp, br_dev_delete       br_fdb_changeaddr  |     path         /  |  \
   |   |  |      |                                        |  |    learning     /   |   \
   \   |   -------------------- br_fdb_find_delete_local  |  |       |        /    |    \     switchdev event
    \  |         |                                     |  |  |       |       /     |     \     listener
     -------------------------- br_fdb_delete_by_port  |  |  |       |      /      |      \       |
                                                 |  |  |  |  |       |     /       |       \      |
                                                 |  |  |  |  |       |    /        |        \     |
                                                 |  |  |  |  |    br_fdb_update    |        br_fdb_external_learn_add
           (RTM_DELNEIGH)  br_fdb_delete         |  |  |  |  |       |             |              |
                                     |           |  |  |  |  |       |             |              |    gc_work        netdevice
                                     |           |  |  |  |  |       |      fdb_add_entry         |     timer          event
                                     |           | fdb_delete_local  |             |              |        |          listener
                         __br_fdb_delete         |  |                |             |              /  br_fdb_cleanup      |
                                     |           |  |                |             |             /         |             |     br_stp_change_bridge_id
                                     |           |  |                \             |            /          | br_fdb_changeaddr      |
                                     |           |  |                 \            |           /           |     |                  |
                     fdb_delete_by_addr_and_port |  | fdb_insert       \           |          /       ----/      | br_fdb_change_mac_address
                                              |  |  |  |                \          |         /       /           |  |
                   br_fdb_external_learn_del  |  |  |  | br_fdb_cleanup  \         |        /       /            |  | br_fdb_insert
                                          |   |  |  |  |  |               \        |       /   ----/             |  | |
                                          |   |  |  |  |  |                \       |      /   /                 fdb_insert
                          br_fdb_flush    |   |  |  |  |  |                 \      |     /   /            --------/
                                 \----    |   |  |  |  |  |                  \     |    /   /      ------/
                                      \----------- fdb_delete --------------- fdb_notify ---------/

There's not a lot that the fast path learning can do about switchdev
when that returns an error.

So this patch set mainly wants to deal with the 2 code paths that are
triggered by these regular commands:

bridge fdb add dev swp0 00:01:02:03:04:05 master static # __br_fdb_add
bridge fdb del dev swp0 00:01:02:03:04:05 master static # __br_fdb_delete

In some other, semi-related discussions, Ido Schimmel pointed out that
it would be nice if user space got some feedback from the actual driver,
and made some proposals about how that could be done.
https://patchwork.kernel.org/project/netdevbpf/cover/20210819160723.2186424-1-vladimir.oltean@nxp.com/
One of the proposals was to call fdb_notify() from sleepable context,
but Nikolay disliked the idea of introducing deferred work in the bridge
driver (seems like nobody wants to deal with it).

And since all proposals of dealing with the deferred work inside
switchdev were also shot down for valid reasons, we are basically left
as a baseline with the code that we have today, with the deferred work
being private to the driver, and somehow we must propagate an err and an
extack from there.

So the approach taken here is to reorganize the code a bit and add some
hooks in:
(a) some callers of the fdb_notify() function to initialize a completion
    structure
(b) some drivers that catch SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE and mark
    that completion structure as done
(c) some bridge logic that I believe is fairly safe (I'm open to being
    proven wrong) that temporarily drops the &br->hash_lock in order to
    sleep until the completion is done.

There are some further optimizations that can be made. For example, we
can avoid dropping the hash_lock if there is no switchdev response pending.
And we can move some of that completion logic in br_switchdev.c such
that it is compiled out on a CONFIG_NET_SWITCHDEV=n build. I haven't
done those here, since they aren't exactly trivial. Mainly searching for
high-level feedback first and foremost.

The structure of the patch series is:
- patches 1-6 are me toying around with some code organization while I
  was trying to understand the various call paths better. I like not
  having forward declarations, but if they exist for a reason, I can
  drop these patches.
- patches 7-10 and 12 are some preparation work that can also be ignored.
- patches 11 and 13 are where the meat of the series is.
- patches 14 and 15 are DSA boilerplate so I could test what I'm doing.

Vladimir Oltean (15):
  net: bridge: remove fdb_notify forward declaration
  net: bridge: remove fdb_insert forward declaration
  net: bridge: rename fdb_insert to fdb_add_local
  net: bridge: rename br_fdb_insert to br_fdb_add_local
  net: bridge: move br_fdb_replay inside br_switchdev.c
  net: bridge: create a common function for populating switchdev FDB
    entries
  net: switchdev: keep the MAC address by value in struct
    switchdev_notifier_fdb_info
  net: bridge: take the hash_lock inside fdb_add_entry
  net: bridge: rename fdb_notify to br_fdb_notify
  net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
  net: bridge: make fdb_add_entry() wait for switchdev feedback
  net: rtnetlink: pass extack to .ndo_fdb_del
  net: bridge: wait for errors from switchdev when deleting FDB entries
  net: dsa: propagate feedback to SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
  net: dsa: propagate extack to .port_fdb_{add,del}

 drivers/net/dsa/b53/b53_common.c              |   6 +-
 drivers/net/dsa/b53/b53_priv.h                |   6 +-
 drivers/net/dsa/hirschmann/hellcreek.c        |   6 +-
 drivers/net/dsa/lan9303-core.c                |   7 +-
 drivers/net/dsa/lantiq_gswip.c                |   6 +-
 drivers/net/dsa/microchip/ksz9477.c           |   6 +-
 drivers/net/dsa/mt7530.c                      |   6 +-
 drivers/net/dsa/mv88e6xxx/chip.c              |   6 +-
 drivers/net/dsa/ocelot/felix.c                |   6 +-
 drivers/net/dsa/qca8k.c                       |   6 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |  12 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  14 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   4 +-
 .../marvell/prestera/prestera_switchdev.c     |  18 +-
 .../mellanox/mlx5/core/en/rep/bridge.c        |  10 -
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |   4 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  11 +-
 .../microchip/sparx5/sparx5_mactable.c        |   2 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  12 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |   5 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  13 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  14 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  14 +-
 drivers/net/macvlan.c                         |   3 +-
 drivers/net/vxlan.c                           |   3 +-
 drivers/s390/net/qeth_l2_main.c               |  11 +-
 include/linux/netdevice.h                     |   6 +-
 include/net/dsa.h                             |   6 +-
 include/net/switchdev.h                       |  67 +-
 net/bridge/br_fdb.c                           | 657 ++++++++++--------
 net/bridge/br_if.c                            |   2 +-
 net/bridge/br_private.h                       |  25 +-
 net/bridge/br_switchdev.c                     | 103 ++-
 net/bridge/br_vlan.c                          |   5 +-
 net/core/rtnetlink.c                          |   4 +-
 net/dsa/dsa_priv.h                            |  15 +-
 net/dsa/port.c                                |  13 +-
 net/dsa/slave.c                               |  87 +--
 net/dsa/switch.c                              |  22 +-
 net/switchdev/switchdev.c                     | 156 +----
 43 files changed, 678 insertions(+), 708 deletions(-)

-- 
2.25.1

