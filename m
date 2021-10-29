Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C9F44058C
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhJ2Wiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:38:52 -0400
Received: from mail-vi1eur05on2056.outbound.protection.outlook.com ([40.107.21.56]:17921
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231132AbhJ2Wiv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 18:38:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbELzc8WJMZmMlOc03KokeOiIGk1mQViitM1Jzym4cNt6U0s0VxSnspWGZxlyZeO6rOdxppkWrz9Ev1x+PO8v/3MPWapYo2v6ZDdZlT2Tmu7X5TVW6Vh6Fk9rL81e9/eKSfQ0ngjvLynGCUM6chjNPJUy9kj/3rHwY0+5EqkMQijBtnkjlFVrqEzsHdplXnoLY6iToxBIcjd3rMsrMxVpfUkjpUbkgmyhOL8obAnSiF2jY80VGnKElHlFbIOIRdWQHyQap5mXAzSYrpHsKnWMkKztzW+SVXj1OA86fgSvTI3hrwitRmcWtDUfjs7sN8PBmg8IudtvX1AkiDZ3sqEhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEOJHrkRXKrshxTjqtEjWwIzv/NAJnes+fCAbxlRUPE=;
 b=HdQTMYRuX8FlV+5eTqDKgdEz+MKUjpTeWMVCHjQICXgHzFPuWQA0xpptfZsREXxRrkExClhwhpUm0i6VW7uC2tgy7thDgMh9IVn0lGCOWIS1Bs7YMamQAPPWW3bGIijL3G8cP+PmEo7stZ1rFoHIMBM56l5mtcK5Ift1LA6xIewHBSon0UJxL/dymea1xTfAhmguhdh1D39RVfzVB9MUWDqpdu5cIOj4uHEMojOQRG5BuaIKzaDwVLMjG/MWo99uKjcygNVRn7U5Ta8hUnb43dEbMHbS4yzWng6EL4VpvBj+mGLaKkPpMma6S5NydEvEw7cd7+LXPsXgJl5cyNC97Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEOJHrkRXKrshxTjqtEjWwIzv/NAJnes+fCAbxlRUPE=;
 b=nS2cBN6lUoKTDMr//8BEovRycgp/gzKrbuDWfgmpnyeKxmvKLkn4A6KX9JZFlml/Be+oV2/HEEqx/wKqBipKiyHoQQdQ7ylseUckz8ZZblWcGQq4Poag4fRbza2ykGIaP7XPbKvJzDdbnb31TqUmgxJd9Xcfi6NhrEvvPVZMk50=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3711.eurprd04.prod.outlook.com (2603:10a6:803:18::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 22:36:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Fri, 29 Oct 2021
 22:36:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: bridge: switchdev: fix shim definition for br_switchdev_mdb_notify
Date:   Sat, 30 Oct 2021 01:36:06 +0300
Message-Id: <20211029223606.3450523-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0065.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::42) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.175.102) by AM5PR1001CA0065.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 22:36:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d7c612a-2d91-4159-1546-08d99b2c86df
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3711:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3711C0A8F0EB0ED8328A79DEE0879@VI1PR0402MB3711.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gVJcTtcThOUAE1+dd0KOEKe0B/INZHtxtxOXtrAFLdzPtvPlzkKVf3XuS+OwglAgduKmb5axFrO02NXT63utxavdX/ArJL6VpqCs9bnaZqhYeIWqyIptulwXMCU8lW9DXK9duBzoXkanwrOaYeDCIFoucafMsIN0Qphl6PS1Adzp2ORWsWb2XfouAxE2jKmywL3wmCAJb+73PbE4yV7ERbYqBvhc8t8M3bMeTHzbidjBZagGe9phFQhL1NDR9aM15nor8NhYKJ2M4SJtnWlMl491VBnO8TAHZpGV/wnjlIoFm8num7KahGjUmj4mLO2HCKsnPnp2iaKXK2iyjIUKX86R7d6Kik0LvwulgWqbTnkfV0H0Gg17Fuwub0VHtSU5imkicsA/yyHYzSyxEscGFkHk0B6oinkNxT+aV0bP93mE55zB6M0ksR4sDdIiSSsiH1NkqHC824u/GIWuYcoBnIpHr52RKb8wROuB8OjxoBEqE8KVSnxpM0SAWvsvfKUniea0pTkxiuyEgLOVGz1RJ5+YiVYl6lKhFkL8Lxef1dHp49AoyPn5sKvczhBgqgSkpCzfLnNSLl7IooKdW0GSSj4dNqSGr/7iKgBbECbLcXXGqGBqloJggtSB0M8coqa67rmtaKWDq4KBN7nuOL0HNzZtWT47U2TlJHNEEg2YFve1m6TIBQS2eT8Ld+n1k0pbsXmPowts+z3gHOqId3obyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(6666004)(66946007)(86362001)(44832011)(956004)(66476007)(5660300002)(1076003)(2906002)(6512007)(2616005)(6506007)(6916009)(4326008)(508600001)(38350700002)(26005)(186003)(316002)(8676002)(6486002)(8936002)(36756003)(38100700002)(54906003)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xo1VqwEPsHh3763nVSP2GWvagL1lEUX4evnoiVvXa8VsAuSPHQaxCTxrAkEe?=
 =?us-ascii?Q?3XR0TcLFyAwczd3PpdXKX+Esypw07Bb8utL7dKYrOYJ4fN3CZnn6yQC5mJ+0?=
 =?us-ascii?Q?0YSHMZV761j1EkWf2XMlAcz20xyPJ02ytphuaKpsAT3tZMYjAaiAuVT7R7lq?=
 =?us-ascii?Q?P6bm+qiGH5jx8gS2sWEiZtzU4x7l58cTn4NBN0yZ/1fFjzksL54MJnEB2LSs?=
 =?us-ascii?Q?2aZnQUhux760SyVxFLd5gZY0SYUj635usHasWLp7QT8z/3wyS5qQA2a6OWYE?=
 =?us-ascii?Q?+6Ys4hSzwGKVHW5fGukyx++4+D3ZWnFU+OrZmvbUOcuF0LlB0gpOII3R46KK?=
 =?us-ascii?Q?fR2+u6HcwvireZodJRHtaYO/Qqysh85v5jIMLUYNRtw+WrQyZIBi0O6Gfg7Y?=
 =?us-ascii?Q?m8Mq+Y6a7UjUYYAtwnXEmSYXlTMbev7cFR/EFopKQtey2F38uUer9zOWrqKQ?=
 =?us-ascii?Q?CMo2chLsxzH/6kXDUk4pDqCKCDNXiCSGbWKu7hvpnl1jdcicw1jgtRGaj7qo?=
 =?us-ascii?Q?cYp7jTuvDw63LGglWmJANHNr+J5dPW+9e/bgEhqpEUMrBXrt31yPa9Xa1iBC?=
 =?us-ascii?Q?fYgSNgRidXp7UziFAX2ti9yc/QC4IQe57hteVLBkjeBVYj+YgClglWYkGBlH?=
 =?us-ascii?Q?femLnQigWzMxF/gZcNvB9KTCJKEXJ4kTnA4zVhu6cKFa8rqwGpzkMJY+Fl1c?=
 =?us-ascii?Q?zbdlU0URRg2FVPhmq5BtAI2fo+EJTsIMrXbVDnNtoE/OKyORg8CoKeyazhQT?=
 =?us-ascii?Q?ogO01n5OlU1LE98xumlsWzA1gcScGHL3pXo11R7/lULZfUqfWHP6INMFkGBC?=
 =?us-ascii?Q?At1G0ZfNCN2QZhS9TCetcmCGTVxOCL3okqOsGj0XNLikmp+CzNgaPKHghB1N?=
 =?us-ascii?Q?idPKDSlby6x0jLuLrPArM9J3W6UcoOdmgjKWk4omb6V4jEoHA80pLiJ0D7Pb?=
 =?us-ascii?Q?JKI90sPtUr607TQbWT7rbTX8zleE8CQUFzwmtl25HObuhdkpQajydn2+4+Gx?=
 =?us-ascii?Q?xyKzS1cPQJYg5mK9hwbIsJZ0CSUTANy8aTke3Td8HbGvN/4Nt2KxbfFR/aSP?=
 =?us-ascii?Q?Zm/qSf7usXTTcmlDbmjt6p3Sk4hS4FTuCtyPHC24zJJ/OZJgJhGBEPZU/HEt?=
 =?us-ascii?Q?8ucEQty0aFQp+Fp795RikLvs5aXFGQTe+kDAsViHOdQxiphjn1VouamMg1wf?=
 =?us-ascii?Q?0T+lgGbQ3WwYECPHs/0cSyHkAE46IXlW3tmHIBUXFzLCilaRRpGfd6JTVt+c?=
 =?us-ascii?Q?VXQwsVO7J5arFO4GBdVOPjdmvN0T6Zr/DBK3mPLpJd4AOoRFyMvZgVuJRMaf?=
 =?us-ascii?Q?+CxP8cixGelBRmW4dR2Fw+oXVwky8yvA6mFpGkBMkfnW0JmfwCwnEJynPGvV?=
 =?us-ascii?Q?xKM0HgCONboWK5DqBMpUXPDZqCoBFza3jAu/PWLEoamGORyAQ4/clz5mT7iA?=
 =?us-ascii?Q?wD/IRLP0Ju5TaXiM7SZ1HrCete0tr+PM513SHuJ0OhWCvMOmB7tYe4LiRM6a?=
 =?us-ascii?Q?RYPQtedSuXMSKIODWTYASbgxkK/0gyDUh5pyIFQG02a94MT+DDzxh48GtPuX?=
 =?us-ascii?Q?HLR1r5TylNYJZTT4SJGu9MGcySRGxtt9Yvlj83DoTMyUELgCHdzGJi17X/q/?=
 =?us-ascii?Q?5sUkzPlx8rxR51wzPo+5qzI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7c612a-2d91-4159-1546-08d99b2c86df
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 22:36:19.6217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RhWqWwPQ8eJaH/QVvLuBi5Xcx4CNdLRJ+GMiRCN9JTrAb6RdEsM6jHca0wkVbHGV8Akqn659mOG6L5X9s3OcrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3711
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_switchdev_mdb_notify() is conditionally compiled only when
CONFIG_NET_SWITCHDEV=y and CONFIG_BRIDGE_IGMP_SNOOPING=y. It is called
from br_mdb.c, which is conditionally compiled only when
CONFIG_BRIDGE_IGMP_SNOOPING=y.

The shim definition of br_switchdev_mdb_notify() is therefore needed for
the case where CONFIG_NET_SWITCHDEV=n, however we mistakenly put it
there for the case where CONFIG_BRIDGE_IGMP_SNOOPING=n. This results in
build failures when CONFIG_BRIDGE_IGMP_SNOOPING=y and
CONFIG_NET_SWITCHDEV=n.

To fix this, put the shim definition right next to
br_switchdev_fdb_notify(), which is properly guarded by NET_SWITCHDEV=n.
Since this is called only from br_mdb.c, we need not take any extra
safety precautions, when NET_SWITCHDEV=n and BRIDGE_IGMP_SNOOPING=n,
this shim definition will be absent but nobody will be needing it.

Fixes: 9776457c784f ("net: bridge: mdb: move all switchdev logic to br_switchdev.c")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_private.h | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 5552c00ed9c4..3fe0961dbd12 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -956,11 +956,6 @@ int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
 				      struct netlink_ext_ack *extack);
 bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan, bool on);
 
-void br_switchdev_mdb_notify(struct net_device *dev,
-			     struct net_bridge_mdb_entry *mp,
-			     struct net_bridge_port_group *pg,
-			     int type);
-
 int br_rports_fill_info(struct sk_buff *skb,
 			const struct net_bridge_mcast *brmctx);
 int br_multicast_dump_querier_state(struct sk_buff *skb,
@@ -1396,13 +1391,6 @@ static inline bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan,
 	return false;
 }
 
-static inline void br_switchdev_mdb_notify(struct net_device *dev,
-					   struct net_bridge_mdb_entry *mp,
-					   struct net_bridge_port_group *pg,
-					   int type)
-{
-}
-
 static inline bool
 br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 			       const struct net_bridge_mcast *brmctx2)
@@ -1983,6 +1971,10 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       struct netlink_ext_ack *extack);
 void br_switchdev_fdb_notify(struct net_bridge *br,
 			     const struct net_bridge_fdb_entry *fdb, int type);
+void br_switchdev_mdb_notify(struct net_device *dev,
+			     struct net_bridge_mdb_entry *mp,
+			     struct net_bridge_port_group *pg,
+			     int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
@@ -2069,6 +2061,13 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 {
 }
 
+static inline void br_switchdev_mdb_notify(struct net_device *dev,
+					   struct net_bridge_mdb_entry *mp,
+					   struct net_bridge_port_group *pg,
+					   int type)
+{
+}
+
 static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 {
 }
-- 
2.25.1

