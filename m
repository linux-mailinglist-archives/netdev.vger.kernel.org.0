Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4756B3CFB40
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbhGTNM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:12:28 -0400
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:59681
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238989AbhGTNGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:06:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KW+gs0yih75ipRXuYLnd7qOfr2ZsNcJlRJaN0Zv9Airt7KAD40HE4g/5E9v4TTWcz0aeS/Sax5sUSJ+iANt+u40cEONDvE3WFAo44yLO0pgvloXLR02rknEinA7a8cqHf/sBw6EkEDEx87K1VftJ9fbY2syHngy8b+pqPX1Y4Av1/oR1o64080YRyJJIUC5jWHhfqTZ+FpY7VjGvusvQNbA/r94a7rnb1jyTW2x/nIIjsuUa+EhRA+jCUBmpfLj4wC56K9ahERIMAn6IT/zkuHHj1EmmsIeWedeWbSDXvo3aZX7e2qOd5v0Mhbrc4+CxoWqEVCWFnBT7Sl1k/LQu8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LglH0w1vp4WC3sskwgO3VjbY6Ou7YGQatfYwouiD61E=;
 b=A7rcU9eVW/QCibFJCvOgsJES7znPLsOEDb8JzuQD3zC6FK8ha5yRwkVuPOLwcjr3eEt4TEFLCzWM2kA27qcNQhD8kAlBoQWz0B7bbPsWSezq4nHbxsXHihIpENEjqStGfbuZ/pnhcieOj4zZbohFHAhpOIA6KRGzMu//Xhj6y86ID+eO6fwnjWqAU27qSdEi9X9TqMdwU1vhGksXHhfH8l2t3yTC1yqehXr4w4Ruxai3RsE7/K2eeJknh6pebZzedwhevqx28xnbyOJgZ0c2WFeRSnJK2/LBxirRMX575KyUyftt4Ub4mUyE1sZ+zkutrroLfPwW1OyHRbCxbxjJTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LglH0w1vp4WC3sskwgO3VjbY6Ou7YGQatfYwouiD61E=;
 b=WRyjAeY2Uzqzgmo11Z6lFLoYYKfs2IInIsmk6c0Tul8ogYBON+WNPq3txN/2tVvxRDfJI8i3Wp2E3erX/ke7eZ1sk5EboWfEo/Y/2fQV7mCoHCyJM5ZN8YVtkrBAMxuGrXSbrlpMPlVzlpXphL2OH6eX8V6Yntthf2YMr4iBKfk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 13:47:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 13:47:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v5 net-next 00/10] Let switchdev drivers offload and unoffload bridge ports at their own convenience
Date:   Tue, 20 Jul 2021 16:46:45 +0300
Message-Id: <20210720134655.892334-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR3P191CA0002.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Tue, 20 Jul 2021 13:47:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8239afa4-27bf-4934-0c48-08d94b84dfa7
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB56966FD5DE75974961ED307BE0E29@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: enQquURI/T2gHvbhshT+kCS65ZL2FCjVhs1+wzD6GaeLv+AvdmzKms4uBnTAqvIEgFHa7g62K0jzr7l0EVmRDFnmMBhSr1vbbK1xp0mLxF5n8wKSwGxWeWbUdhlaHVa+gtIT/UVh2j0A7x5kY+RNl8Dre9Q36nA6yvBFPXKnpRbyYpYIBOcC3J4HYDzmEod1jMAEVIEUoZY35yksilriVm0KzF5Lwb5ujC46n0pVOvBIWxAmr4WWyVtOJOQJ4mI9ccucFPK6G04CNRx3udzHg8bdSBI6WS+o0UmCustQ0uRBq4nSW/7eW+QXkTDff4/WtKMjkixICGqNmt7Zhg9QMAQ1MZ6vyP9sCXOnsH7yDsX5ijgfspeqplGXerTS1eZA35glwJZ7AbNXewUSh7UtQi+5v5Ah7P+N1Yo8EIFfV+j0v5z+QThEgOCnQ4pJEXyCcgO8dmPBPV0cZIdUY8QBGYHt8ZZmFOmwD3eXAs91H4nCSSCwhib40jo8qu7X/yoy/pDofhZyu0kwYLRCTl+B1GjhAc7BX7QtpthqQtKIZEBMEZ1qfYBmAeBXsmobmHocHY2BU30l/6u4lSOguhlC/f2F5A6ltpUuquHtKQdWX7vDN947rR20jT/wBwr7EnVa/2TTsvty9b8bCgbmlrVc0tZn1Q6GUi7Caf3Po5OqtzBPrv2FXRzOolTslnMcqIshoXiL+hJ817TuvUTFNOcVnMFMtZZSdg8OOhBWGlAv3YJ8iPTjryULcyACpIM18U3xWiUV5Xeuk3bkR8dET0MNMJFVM8k/b5QK/K8Qt/NJ3es=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(66946007)(6486002)(66556008)(316002)(26005)(54906003)(110136005)(38350700002)(6666004)(38100700002)(8676002)(83380400001)(4326008)(66476007)(8936002)(6512007)(2616005)(186003)(5660300002)(36756003)(966005)(52116002)(956004)(478600001)(7416002)(44832011)(86362001)(1076003)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qp97RQoGOMUJKA4eO2AiPebejRzt0r1Bx7cwCm5Jr7bDsJA2pjc2Zi2qFgWn?=
 =?us-ascii?Q?wynUwa5Fl8lyUXNBmSLUKR+bbfXP7phsZHcDGYmNqn/1vJOxPstcgkqvedDM?=
 =?us-ascii?Q?K3fnJggo/Kstd6yrDSlKntKp/PNsMUxQzS/BhMDzileMvfOeiPQ2cK5PsIdH?=
 =?us-ascii?Q?3zHBZWVKOgvAHOhkOsQL22C1J1QAyjUflcT/B03pQ3LuhbiTS2wzsRyzbv8w?=
 =?us-ascii?Q?wBzL6eGuBKucSB9FQU9GdL8ek/rLcX44D05DYyVPSMnTXkIkk+unylgWjAnX?=
 =?us-ascii?Q?J2wiT7d9xq/XZrNEyUDIrxw5Iw09JJn5lRVHtEJA6LhUvxbGn6yIAjgBY2d7?=
 =?us-ascii?Q?s2rLrnRezhVUflPSOuSS4HgHrRCNiX9bURmvwc1BRqjTnyKDF004M/UYtAlQ?=
 =?us-ascii?Q?8oSvhxjBWbOLTT/OdZffURhbrlfkps7odbFQjwHXnUAZgHZjeGmwN8M/47Na?=
 =?us-ascii?Q?jhtSt9GKaFFbPWLhvJDn6iCJ/qIBHrts1jX5ioc4/i8saXILu5obndziKtBH?=
 =?us-ascii?Q?wGXLZN+xyzccjTcdj72c11ppGTOLMLq91X1cN2SZ0UaEdSzNKhYiKlE81uYM?=
 =?us-ascii?Q?w7yIox9JWQvDTa0cmQ3bdzLHPEtRileSRnwBQeYDFv3v8UyHjIz+S2Akh8AQ?=
 =?us-ascii?Q?kasIyTrMOkDOrRuGiw7d6H9uad0Z4MYJVLL3ikEqwOnBS+9CvY7jY2nBenCt?=
 =?us-ascii?Q?3dCN4Pjyapq+g87Fm7vrVqdhlda2yjWJOv6R1LGeGpgRv5Dm1Iy0b73VE+S2?=
 =?us-ascii?Q?RNW3pBlUZ0Vq22LD82DM1doVzK211j0ec9o+pGK299x0uoxKOT/CdlIbNvD1?=
 =?us-ascii?Q?9zIIIPWqbKiNo1nB20vJAOnIc8jNf/yLowkzNW61OuMOy7QRdjkhzBAlWIGC?=
 =?us-ascii?Q?XJHa3cG9nm6vABp+rdZY2v/bXdp7rBdTKPNHqzeiXHwKC03G0z5mptcyCgpA?=
 =?us-ascii?Q?1BBWiF9oh3+MPjg45VdSjfpRDmOSIM97Uk33Af8lxZRYzXvtSjl9o1MEZ3rU?=
 =?us-ascii?Q?sjy6SOkD6be8OGHjkKQfa372o7E6t7DSsf4hkMmSsVn9T5yGvivvhCSFX8/L?=
 =?us-ascii?Q?N3+aHAkrxczzZGilBrMAeLdNjQYKpdL08ifWgR7zscijkgWcg4YG6FKXCHYN?=
 =?us-ascii?Q?IV3/w7M/3YyzslQ/PJPuQ6oxbNslXqVSHkr1hVlNlJ9tdetowIO8iq0bP1hq?=
 =?us-ascii?Q?ixMz21kvUPRI0netjlzKG7Bs7TmTBKq47HnpiLk4jxO0QOhptkSOovLBfwAP?=
 =?us-ascii?Q?Ng4Td2vnqULInrx/pxCgI6+Iiui7GMstfnlDsZDhaPrC1M85Vwfl7wXatIQm?=
 =?us-ascii?Q?ENZktUtMs7TkqLC00tyL8W7B?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8239afa4-27bf-4934-0c48-08d94b84dfa7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 13:47:11.1587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xThuzYW5PG/uDYtIlRy/BgBVvnazw1PQbyH3vJLBrV2IlgeohKnpOnpVuBgbD9TzQyemehVLRmNVpy29TI8ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces an explicit API through which switchdev drivers
mark a bridge port as offloaded or not:
- switchdev_bridge_port_offload()
- switchdev_bridge_port_unoffload()

Currently, the bridge assumes that a port is offloaded if
dev_get_port_parent_id(dev, &ppid, recurse=true) returns something, but
that is just an assumption that breaks some use cases (like a
non-offloaded LAG interface on top of a switchdev port, bridged with
other switchdev ports).

Along with some consolidation of the bridge logic to assign a "switchdev
offloading mark" to a port (now better called a "hardware domain"), this
series allows the bridge driver side to no longer impose restrictions on
that configuration.

Right now, all switchdev drivers must be modified to use the explicit
API, but more and more logic can then be placed centrally in the bridge
and therefore ease the job of a switchdev driver writer in the future.

For example, the first thing we can hook into the explicit switchdev
offloading API calls are the switchdev object and FDB replay helpers.
So far, these have only been used by DSA in "pull" mode (where the
driver must ask for them). Adding the replay helpers to other drivers
involves a lot of repetition. But by moving the helpers inside the
bridge port offload/unoffload hook points, we can move the entire replay
process to "push" mode (where the bridge provides them automatically).

The explicit switchdev offloading API will see further extensions in the
future.

The patches were split from a larger series for easier review:
https://patchwork.kernel.org/project/netdevbpf/cover/20210718214434.3938850-1-vladimir.oltean@nxp.com/

Tobias Waldekranz (2):
  net: bridge: disambiguate offload_fwd_mark
  net: bridge: switchdev: recycle unused hwdoms

Vladimir Oltean (8):
  net: dpaa2-switch: use extack in dpaa2_switch_port_bridge_join
  net: dpaa2-switch: refactor prechangeupper sanity checks
  mlxsw: spectrum: refactor prechangeupper sanity checks
  mlxsw: spectrum: refactor leaving an 8021q upper that is a bridge port
  net: marvell: prestera: refactor prechangeupper sanity checks
  net: switchdev: guard drivers against multiple obj replays on same
    bridge port
  net: bridge: switchdev: let drivers inform which bridge ports are
    offloaded
  net: bridge: switchdev object replay helpers for everybody

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  69 +++-
 .../ethernet/marvell/prestera/prestera_main.c |  99 +++--
 .../marvell/prestera/prestera_switchdev.c     |  42 ++-
 .../marvell/prestera/prestera_switchdev.h     |   7 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 347 ++++++++++++------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +
 .../mellanox/mlxsw/spectrum_switchdev.c       |  28 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  48 ++-
 drivers/net/ethernet/mscc/ocelot_net.c        | 115 ++++--
 drivers/net/ethernet/rocker/rocker.h          |   9 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  34 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  42 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  34 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  14 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.h |   3 +
 drivers/net/ethernet/ti/cpsw_new.c            |  32 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |   4 +-
 drivers/net/ethernet/ti/cpsw_switchdev.h      |   3 +
 include/linux/if_bridge.h                     |  60 +--
 net/bridge/br_fdb.c                           |   1 -
 net/bridge/br_if.c                            |  11 +-
 net/bridge/br_mdb.c                           |   1 -
 net/bridge/br_private.h                       |  61 ++-
 net/bridge/br_switchdev.c                     | 254 +++++++++++--
 net/bridge/br_vlan.c                          |   1 -
 net/dsa/port.c                                |  83 ++---
 26 files changed, 1059 insertions(+), 347 deletions(-)

-- 
2.25.1

