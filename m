Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0BC3F0336
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhHRMFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:05:03 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:55044
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236429AbhHRMEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPh0i477QIW1AczL8N+o6Aj3FaJbyGQKATU7/zCWQ2ODZXokE1ArqHHojCc4PJSFpk19ScyaPzwpGtIj4/H02DCUU7NbKgegGDjgkGsoK6J9rs5ULFIZSKNwwMcwWu0UzNz2Pf+Sq6yZCyaBufZRgKKkK80UOMVEzoxOl6CXBs5iYyJypgpH6jvCtLJLhxD7SyV13NSqTgFGmiqIJR08OpxKsxHjEIY/r/vIFZ8J4mvt2YvZUilbF3ZyVShX3DY0Tk8NE5zVveZDyPNfXj9Bx73hJXNCjPaU6Pv4P29SdieRWGhQ/VXI1w7E5mzM56I4Z8zR5aOF9tT7AZDfJ1Rptg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GNw2doj2mneTs9MCg88u3o7d0vmR9sCmO2rWru6r70=;
 b=AhAfx3RuFNHYHXpewtWH6EfKYKxZvJzx8vGHNYVTAy3w2dH/JzD6omcq/5ZFdVQIDOxh9IMupwAg2osKj3wZeBkoNarE9/vSFfst1NVlhNqLIqtxOmngurPn90Uky08kfOlMBqok0XAS5RuMEESz8biAJQHxOtvlQVeRaDsMTJIIyFaVn1y9vPzSY2KK/XShMTnU4QebKXTyqA1bybSY9+E4EWu4dyFTWQFTCzIpPArNLpv8LDGoxSgu4qU+oU9mhNhA1/Jrw1LJTTAoy4EDZJro/YbahmVBOQ4SB2JQCUaG2bXY5En37ofPZAlpsesz9Og4/y080Lk7gOMEpydOHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2GNw2doj2mneTs9MCg88u3o7d0vmR9sCmO2rWru6r70=;
 b=JwzLT1jM1r4rRVl8DgKLmb1CBG461k6k79jk1x3oByOB3T1ht5kH+8CZ8dJExQeOYqRSjjJ9EnbdBaOPu6CywMtsd0D6mqmQ+2NPrALGlRO0ypMfX1Vcg3QSzeZGm/79lHjGndPszp6XvSWHr4JeQZyNDaEwvbi1KZHuK9XQPd0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:03:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:11 +0000
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
Subject: [RFC PATCH net-next 15/20] net: dsa: request drivers to perform FDB isolation
Date:   Wed, 18 Aug 2021 15:01:45 +0300
Message-Id: <20210818120150.892647-16-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10539c05-65ec-449b-b1ab-08d962402670
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839EA6172A41C3CB8F11D10E0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MmzDKevEAgKoM+8hf0xDETO5/fm82CrvB8/ilyTrRTfezYgo2NzJFx8FWgfnCqNxMO7kp1tQgbGVFGAwNjxXIAQi38+qvJ1tkWH+1f9P/ZRGeDSArGRJ1HiUe8ogtMjvNPHFU8Zic3Y0Uurfie0oMrBIJYfTQnwYDvcgCaqCpTHJxnJXSzXXGoFC0hxqU1la5A+d1gKkFnLVOYg8mHmHhVy7ueFMiVZj36Rgfi6SsQ5av9N9UUVoCAUgQhzVGcLhXd238KVMGdEuIfN6mF+J1ElCtb8X2Xbc0IEBYoZv6gv5lFwkSqdr3rl9yMfKx0qF9P784ih+bI4T3C/KBgl6xgGnqaKEtVYS5gzxNqoUtrTgpXkOlsJmPxiX/3gr1lhe81H2MSEJbeDtAgWg66qzUfa2RPeUzvMEyCQVFvpPmR7TQa2t5doE6lAFP92537cBBO2zTrxmxpY+S1iyhi8vS7a8vS5STAyPVdetjgFlLk/0wzKfVis7eZx6uE3M2S90JCr14PaB4EvT7D6HTFJhipHn6GtU45/SNb65Thfmb9mj7JYbp8BhgHfEJRML7SEms0X8BfcecXLL6RwkXdK/Fj1jUv72bQn0Hfi1E+oP1jmCiu5MSbdPUBwmNkpKeyXY6QJRPX4kcJsana/vRp7awPgYZT9AOdrQjM3LG7gjkDIkuMe38iNV2Cx0fpd2OoExSWsKAzip4HEdS8ueUlpzgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(30864003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kEcoKjF6pVLuD/oq1iIiCNJBvGoIPu+1rAwxJlDWCXZsSx2xHyqTJk0xE36v?=
 =?us-ascii?Q?BlAEYeXMh7D4SYSVentiehVz+UPmUAQuwpm5QNq9EDBwz4xFn9pDT95G818O?=
 =?us-ascii?Q?5bly3CFTNmrqsOTgK9hZMsp9N7Ubr8XgBEgJtZpCM9Rp4i/9PQGzOiKRpinx?=
 =?us-ascii?Q?PKvgp4YVeXC7UGroKoWyJgWiBzzUSPg379H7ckiiyAROkG+wXH1A+QPF+Sav?=
 =?us-ascii?Q?CFxL2u71rxgcv6MF9vunOZxvlaVYqKi/8bvlCjKxWOeW3ff7kylwUXfNJFDO?=
 =?us-ascii?Q?moslu58gccatJFHRbWJ/PsGCVuSeARHLG6v9Lc8bnj1rT6LMAZRvTC0sus7p?=
 =?us-ascii?Q?mKm7ku7KFv5B1Jn4pPVbX3BZmxhjccfOAZnDy7HKKHucWraSRjJnA2waqE3D?=
 =?us-ascii?Q?udtHrqQosfjamU5ecamHmZ1OOSb40u7yE1xdAcMovcXlFBnLsg/MDnLJYF2N?=
 =?us-ascii?Q?XjOsc03vbLi8mK+Hag5/pZqancUs/1a1ryeBNRLDyTNZBAd0TXQcp7sRS8xu?=
 =?us-ascii?Q?g1r37K8l+wLZVl/nRtg5cBTzJyFtkc6NahCPpl+idA/3Awadq0sDsDGM8ELE?=
 =?us-ascii?Q?I9YPaM6TALTFNNBo7FMR52P7ndyYFzugfFyJweBU0bCWBGs6f9nLh2nOzz+m?=
 =?us-ascii?Q?VTIrhDOHUlQ3mHVyrPTI383JijBgFCHe6CuDLPQPnLL7/FIQXjnZM5ANVim1?=
 =?us-ascii?Q?BilRepaf7GYcw0PmRrX/2TkoFGztnW/gIUa6/vAQlED5o/lfAJhLWmuS+NRe?=
 =?us-ascii?Q?oYlpE++TKO9xRisREB88XzMtZWaASj9a6YQIogY/H+pMrrjd8HVsmHvR1MTu?=
 =?us-ascii?Q?iTc+ANi3TlNYzOyRGaMFoGBafiQUATh3KlG9EI8gZsBGAYMVxVtvVhi3RGWU?=
 =?us-ascii?Q?Di7TaUB5CvwcNfDnb/d8/iFyUhB2ozg2ZckbkZdkWvkXOFSs0ggHo8QdOvV7?=
 =?us-ascii?Q?o6zx0aPdV6ssRSLx1gwUM0XqcZ7qfwoSRYc7EeSoxwPe2xfgjycOALSJPpTl?=
 =?us-ascii?Q?mQ/DlK0in5rhYgPl5n8tdyAUryLeb1B9LVgeoEPlOY0EiErXPV8U654oHMwk?=
 =?us-ascii?Q?uSoZuCCIgCSM/Qn1SoU7wSPFVaiP42OtestnTfWa3q2bokw5puwN26dOX1e5?=
 =?us-ascii?Q?lt/J+ku5TmoA89yRGOXybw3XxUhXFAwVKf63AoSYS9ijDGUY/7tTuVz5/C0y?=
 =?us-ascii?Q?ryLuRUJtw4iXnoA8M5EW+dEgu+kI9vr6Wlo99uwrNpdX6vMS3JnQtMqOQspr?=
 =?us-ascii?Q?0c6DO1/JHTobdPuAFT4Qzyh6HzbTOx9UAc2HLbpocr9Ls/go/dT9pOtjPGwg?=
 =?us-ascii?Q?JhU22WQMhLJjY7nznLvglCbX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10539c05-65ec-449b-b1ab-08d962402670
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:11.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQBg6YYnbtTyDInaFHmD1LikxcYtUOp8prwxXXcFizkaIPGeW4cZYU7JrZGGX8kKRqZPPjrClvj4zU7rT/vfqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For DSA, to encourage drivers to perform FDB isolation simply means to
track which bridge does each FDB and MDB entry belong to. It then
becomes the driver responsibility to use something that makes the FDB
entry from one bridge not match the FDB lookup of ports from other
bridges.

The top-level functions where the bridge is determined are:
- dsa_port_fdb_{add,del}
- dsa_port_host_fdb_{add,del}
- dsa_port_mdb_{add,del}
- dsa_port_host_mdb_{add,del}

aka the pre-crosschip-notifier functions.

One might obviously ask: why do you pass the bridge_dev all the way to
drivers, can't they just look at dsa_to_port(ds, port)->bridge_dev?!

Well, no.

While that might work for user ports, it does not work for CPU and DSA
ports. Those service multiple bridges, of course.

When dsa_port_host_fdb_add(dp) is called, the driver is notified on
dp->cpu_dp. So it loses the information about the original dp, so it
cannot access dp->bridge_dev.

But notice that at least we don't explicitly pass the bridge_num to it.
Drivers can call dsa_bridge_num_find(bridge_dev), sure, but it is
optional and if they have a better tracking scheme, they should be free
to use it.

DSA must perform refcounting on the CPU and DSA ports by also taking
into account the bridge number. So if two bridges request the same local
address, DSA must notify the driver twice, once for each bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       | 12 +++--
 drivers/net/dsa/b53/b53_priv.h         | 12 +++--
 drivers/net/dsa/hirschmann/hellcreek.c |  6 ++-
 drivers/net/dsa/lan9303-core.c         | 13 ++++--
 drivers/net/dsa/lantiq_gswip.c         |  6 ++-
 drivers/net/dsa/microchip/ksz9477.c    | 12 +++--
 drivers/net/dsa/microchip/ksz_common.c |  6 ++-
 drivers/net/dsa/microchip/ksz_common.h |  6 ++-
 drivers/net/dsa/mt7530.c               | 12 +++--
 drivers/net/dsa/mv88e6xxx/chip.c       | 12 +++--
 drivers/net/dsa/ocelot/felix.c         | 12 +++--
 drivers/net/dsa/qca8k.c                |  6 ++-
 drivers/net/dsa/sja1105/sja1105_main.c | 19 +++++---
 include/net/dsa.h                      | 13 ++++--
 net/dsa/dsa_priv.h                     |  2 +
 net/dsa/port.c                         |  9 +++-
 net/dsa/switch.c                       | 63 +++++++++++++++-----------
 17 files changed, 143 insertions(+), 78 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 55bfcec2b204..bec55bf0efeb 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1712,7 +1712,8 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 }
 
 int b53_fdb_add(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid)
+		const unsigned char *addr, u16 vid,
+		const struct net_device *br)
 {
 	struct b53_device *priv = ds->priv;
 
@@ -1727,7 +1728,8 @@ int b53_fdb_add(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL(b53_fdb_add);
 
 int b53_fdb_del(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid)
+		const unsigned char *addr, u16 vid,
+		const struct net_device *br)
 {
 	struct b53_device *priv = ds->priv;
 
@@ -1819,7 +1821,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL(b53_fdb_dump);
 
 int b53_mdb_add(struct dsa_switch *ds, int port,
-		const struct switchdev_obj_port_mdb *mdb)
+		const struct switchdev_obj_port_mdb *mdb,
+		const struct net_device *br)
 {
 	struct b53_device *priv = ds->priv;
 
@@ -1834,7 +1837,8 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL(b53_mdb_add);
 
 int b53_mdb_del(struct dsa_switch *ds, int port,
-		const struct switchdev_obj_port_mdb *mdb)
+		const struct switchdev_obj_port_mdb *mdb,
+		const struct net_device *br)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 4e9b05008524..6124d0f0d62b 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -358,15 +358,19 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 int b53_vlan_del(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan);
 int b53_fdb_add(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid);
+		const unsigned char *addr, u16 vid,
+		const struct net_device *br);
 int b53_fdb_del(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid);
+		const unsigned char *addr, u16 vid,
+		const struct net_device *br);
 int b53_fdb_dump(struct dsa_switch *ds, int port,
 		 dsa_fdb_dump_cb_t *cb, void *data);
 int b53_mdb_add(struct dsa_switch *ds, int port,
-		const struct switchdev_obj_port_mdb *mdb);
+		const struct switchdev_obj_port_mdb *mdb,
+		const struct net_device *br);
 int b53_mdb_del(struct dsa_switch *ds, int port,
-		const struct switchdev_obj_port_mdb *mdb);
+		const struct switchdev_obj_port_mdb *mdb,
+		const struct net_device *br);
 int b53_mirror_add(struct dsa_switch *ds, int port,
 		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress);
 enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index fdae74313eb7..f4de182a091b 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -826,7 +826,8 @@ static int hellcreek_fdb_get(struct hellcreek *hellcreek,
 }
 
 static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
-			     const unsigned char *addr, u16 vid)
+			     const unsigned char *addr, u16 vid,
+			     const struct net_device *br)
 {
 	struct hellcreek_fdb_entry entry = { 0 };
 	struct hellcreek *hellcreek = ds->priv;
@@ -871,7 +872,8 @@ static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_fdb_del(struct dsa_switch *ds, int port,
-			     const unsigned char *addr, u16 vid)
+			     const unsigned char *addr, u16 vid,
+			     const struct net_device *br)
 {
 	struct hellcreek_fdb_entry entry = { 0 };
 	struct hellcreek *hellcreek = ds->priv;
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index d1148ab2f66e..311d8f5e3c87 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1181,7 +1181,8 @@ static void lan9303_port_fast_age(struct dsa_switch *ds, int port)
 }
 
 static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
+				const unsigned char *addr, u16 vid,
+				const struct net_device *br)
 {
 	struct lan9303 *chip = ds->priv;
 
@@ -1193,8 +1194,8 @@ static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int lan9303_port_fdb_del(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
-
+				const unsigned char *addr, u16 vid,
+				const struct net_device *br)
 {
 	struct lan9303 *chip = ds->priv;
 
@@ -1238,7 +1239,8 @@ static int lan9303_port_mdb_prepare(struct dsa_switch *ds, int port,
 }
 
 static int lan9303_port_mdb_add(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb)
+				const struct switchdev_obj_port_mdb *mdb,
+				const struct net_device *br)
 {
 	struct lan9303 *chip = ds->priv;
 	int err;
@@ -1253,7 +1255,8 @@ static int lan9303_port_mdb_add(struct dsa_switch *ds, int port,
 }
 
 static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb)
+				const struct switchdev_obj_port_mdb *mdb,
+				const struct net_device *br)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 64a22652cc75..7dd9d9752a17 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1364,13 +1364,15 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 }
 
 static int gswip_port_fdb_add(struct dsa_switch *ds, int port,
-			      const unsigned char *addr, u16 vid)
+			      const unsigned char *addr, u16 vid,
+			      const struct net_device *br)
 {
 	return gswip_port_fdb(ds, port, addr, vid, true);
 }
 
 static int gswip_port_fdb_del(struct dsa_switch *ds, int port,
-			      const unsigned char *addr, u16 vid)
+			      const unsigned char *addr, u16 vid,
+			      const struct net_device *br)
 {
 	return gswip_port_fdb(ds, port, addr, vid, false);
 }
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 854e25f43fa7..1cc6ab1dfef8 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -583,7 +583,8 @@ static int ksz9477_port_vlan_del(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
+				const unsigned char *addr, u16 vid,
+				const struct net_device *br)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 alu_table[4];
@@ -640,7 +641,8 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
+				const unsigned char *addr, u16 vid,
+				const struct net_device *br)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 alu_table[4];
@@ -782,7 +784,8 @@ static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb)
+				const struct switchdev_obj_port_mdb *mdb,
+				const struct net_device *br)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 static_table[4];
@@ -857,7 +860,8 @@ static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb)
+				const struct switchdev_obj_port_mdb *mdb,
+				const struct net_device *br)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 static_table[4];
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 202fd93caae3..96b4cd6f7daa 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -246,7 +246,8 @@ int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 EXPORT_SYMBOL_GPL(ksz_port_fdb_dump);
 
 int ksz_port_mdb_add(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb)
+		     const struct switchdev_obj_port_mdb *mdb,
+		     const struct net_device *br)
 {
 	struct ksz_device *dev = ds->priv;
 	struct alu_struct alu;
@@ -291,7 +292,8 @@ int ksz_port_mdb_add(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL_GPL(ksz_port_mdb_add);
 
 int ksz_port_mdb_del(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb)
+		     const struct switchdev_obj_port_mdb *mdb,
+		     const struct net_device *br)
 {
 	struct ksz_device *dev = ds->priv;
 	struct alu_struct alu;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 59c42cc1000b..31653e1ae15f 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -167,9 +167,11 @@ void ksz_port_fast_age(struct dsa_switch *ds, int port);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
 int ksz_port_mdb_add(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb);
+		     const struct switchdev_obj_port_mdb *mdb,
+		     const struct net_device *br);
 int ksz_port_mdb_del(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb);
+		     const struct switchdev_obj_port_mdb *mdb,
+		     const struct net_device *br);
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
 
 /* Common register access functions */
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3f3b4d3a36e4..08a5e5ef75e6 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1348,7 +1348,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_fdb_add(struct dsa_switch *ds, int port,
-		    const unsigned char *addr, u16 vid)
+		    const unsigned char *addr, u16 vid,
+		    const struct net_device *br)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
@@ -1364,7 +1365,8 @@ mt7530_port_fdb_add(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_fdb_del(struct dsa_switch *ds, int port,
-		    const unsigned char *addr, u16 vid)
+		    const unsigned char *addr, u16 vid,
+		    const struct net_device *br)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
@@ -1415,7 +1417,8 @@ mt7530_port_fdb_dump(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_mdb_add(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_mdb *mdb)
+		    const struct switchdev_obj_port_mdb *mdb,
+		    const struct net_device *br)
 {
 	struct mt7530_priv *priv = ds->priv;
 	const u8 *addr = mdb->addr;
@@ -1441,7 +1444,8 @@ mt7530_port_mdb_add(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_mdb_del(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_mdb *mdb)
+		    const struct switchdev_obj_port_mdb *mdb,
+		    const struct net_device *br)
 {
 	struct mt7530_priv *priv = ds->priv;
 	const u8 *addr = mdb->addr;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 92c2833a25a4..1b46641052a6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2241,7 +2241,8 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
-				  const unsigned char *addr, u16 vid)
+				  const unsigned char *addr, u16 vid,
+				  const struct net_device *br)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2255,7 +2256,8 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
-				  const unsigned char *addr, u16 vid)
+				  const unsigned char *addr, u16 vid,
+				  const struct net_device *br)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -5682,7 +5684,8 @@ static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
-				  const struct switchdev_obj_port_mdb *mdb)
+				  const struct switchdev_obj_port_mdb *mdb,
+				  const struct net_device *br)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -5696,7 +5699,8 @@ static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
-				  const struct switchdev_obj_port_mdb *mdb)
+				  const struct switchdev_obj_port_mdb *mdb,
+				  const struct net_device *br)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index cccbd33d5ac5..e764d8646d0b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -628,7 +628,8 @@ static int felix_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int felix_fdb_add(struct dsa_switch *ds, int port,
-			 const unsigned char *addr, u16 vid)
+			 const unsigned char *addr, u16 vid,
+			 const struct net_device *br)
 {
 	struct ocelot *ocelot = ds->priv;
 
@@ -636,7 +637,8 @@ static int felix_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int felix_fdb_del(struct dsa_switch *ds, int port,
-			 const unsigned char *addr, u16 vid)
+			 const unsigned char *addr, u16 vid,
+			 const struct net_device *br)
 {
 	struct ocelot *ocelot = ds->priv;
 
@@ -644,7 +646,8 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 }
 
 static int felix_mdb_add(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_mdb *mdb)
+			 const struct switchdev_obj_port_mdb *mdb,
+			 const struct net_device *br)
 {
 	struct ocelot *ocelot = ds->priv;
 
@@ -652,7 +655,8 @@ static int felix_mdb_add(struct dsa_switch *ds, int port,
 }
 
 static int felix_mdb_del(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_mdb *mdb)
+			 const struct switchdev_obj_port_mdb *mdb,
+			 const struct net_device *br)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 4254fbd84432..b4893b179289 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1619,7 +1619,8 @@ qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 
 static int
 qca8k_port_fdb_add(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid)
+		   const unsigned char *addr, u16 vid,
+		   const struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
@@ -1629,7 +1630,8 @@ qca8k_port_fdb_add(struct dsa_switch *ds, int port,
 
 static int
 qca8k_port_fdb_del(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid)
+		   const unsigned char *addr, u16 vid,
+		   const struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8580ca2e88df..667e698b5ae8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1731,7 +1731,8 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_fdb_add(struct dsa_switch *ds, int port,
-			   const unsigned char *addr, u16 vid)
+			   const unsigned char *addr, u16 vid,
+			   const struct net_device *br)
 {
 	struct sja1105_private *priv = ds->priv;
 
@@ -1739,7 +1740,8 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_fdb_del(struct dsa_switch *ds, int port,
-			   const unsigned char *addr, u16 vid)
+			   const unsigned char *addr, u16 vid,
+			   const struct net_device *br)
 {
 	struct sja1105_private *priv = ds->priv;
 
@@ -1796,6 +1798,7 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 
 static void sja1105_fast_age(struct dsa_switch *ds, int port)
 {
+	const struct net_device *br = dsa_to_port(ds, port)->bridge_dev;
 	struct sja1105_private *priv = ds->priv;
 	int i;
 
@@ -1824,7 +1827,7 @@ static void sja1105_fast_age(struct dsa_switch *ds, int port)
 
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
-		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid);
+		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, br);
 		if (rc) {
 			dev_err(ds->dev,
 				"Failed to delete FDB entry %pM vid %lld: %pe\n",
@@ -1835,15 +1838,17 @@ static void sja1105_fast_age(struct dsa_switch *ds, int port)
 }
 
 static int sja1105_mdb_add(struct dsa_switch *ds, int port,
-			   const struct switchdev_obj_port_mdb *mdb)
+			   const struct switchdev_obj_port_mdb *mdb,
+			   const struct net_device *br)
 {
-	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid);
+	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, br);
 }
 
 static int sja1105_mdb_del(struct dsa_switch *ds, int port,
-			   const struct switchdev_obj_port_mdb *mdb)
+			   const struct switchdev_obj_port_mdb *mdb,
+			   const struct net_device *br)
 {
-	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid);
+	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid, br);
 }
 
 /* Common function for unicast and broadcast flood configuration.
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 5ecba358889a..103b738bd773 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -305,6 +305,7 @@ struct dsa_link {
 struct dsa_mac_addr {
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
+	const struct net_device *br;
 	refcount_t refcount;
 	struct list_head list;
 };
@@ -731,9 +732,11 @@ struct dsa_switch_ops {
 	 * Forwarding database
 	 */
 	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid);
+				const unsigned char *addr, u16 vid,
+				const struct net_device *br);
 	int	(*port_fdb_del)(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid);
+				const unsigned char *addr, u16 vid,
+				const struct net_device *br);
 	int	(*port_fdb_dump)(struct dsa_switch *ds, int port,
 				 dsa_fdb_dump_cb_t *cb, void *data);
 
@@ -741,9 +744,11 @@ struct dsa_switch_ops {
 	 * Multicast database
 	 */
 	int	(*port_mdb_add)(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb);
+				const struct switchdev_obj_port_mdb *mdb,
+				const struct net_device *br);
 	int	(*port_mdb_del)(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb);
+				const struct switchdev_obj_port_mdb *mdb,
+				const struct net_device *br);
 	/*
 	 * RXNFC
 	 */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 3a9d81ca3e64..ffdec05e1530 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -66,6 +66,7 @@ struct dsa_notifier_fdb_info {
 	int port;
 	const unsigned char *addr;
 	u16 vid;
+	const struct net_device *br;
 };
 
 /* DSA_NOTIFIER_MDB_* */
@@ -73,6 +74,7 @@ struct dsa_notifier_mdb_info {
 	const struct switchdev_obj_port_mdb *mdb;
 	int sw_index;
 	int port;
+	const struct net_device *br;
 };
 
 /* DSA_NOTIFIER_LAG_* */
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 07c57287ac3e..0c904525a95b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -739,6 +739,7 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
+		.br = dp->bridge_dev,
 	};
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_ADD, &info);
@@ -752,7 +753,7 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
-
+		.br = dp->bridge_dev,
 	};
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
@@ -766,6 +767,7 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
+		.br = dp->bridge_dev,
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
@@ -785,6 +787,7 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
+		.br = dp->bridge_dev,
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
@@ -814,6 +817,7 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.mdb = mdb,
+		.br = dp->bridge_dev,
 	};
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_ADD, &info);
@@ -826,6 +830,7 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.mdb = mdb,
+		.br = dp->bridge_dev,
 	};
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_DEL, &info);
@@ -838,6 +843,7 @@ int dsa_port_host_mdb_add(const struct dsa_port *dp,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.mdb = mdb,
+		.br = dp->bridge_dev,
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
@@ -856,6 +862,7 @@ int dsa_port_host_mdb_del(const struct dsa_port *dp,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.mdb = mdb,
+		.br = dp->bridge_dev,
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index b1c38eee2cac..d0fda69104f9 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -188,20 +188,22 @@ static bool dsa_switch_host_address_match(struct dsa_switch *ds, int port,
 }
 
 static struct dsa_mac_addr *dsa_mac_addr_find(struct list_head *addr_list,
-					      const unsigned char *addr,
-					      u16 vid)
+					      const unsigned char *addr, u16 vid,
+					      const struct net_device *br)
 {
 	struct dsa_mac_addr *a;
 
 	list_for_each_entry(a, addr_list, list)
-		if (ether_addr_equal(a->addr, addr) && a->vid == vid)
+		if (ether_addr_equal(a->addr, addr) && a->vid == vid &&
+		    a->br == br)
 			return a;
 
 	return NULL;
 }
 
 static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb)
+				 const struct switchdev_obj_port_mdb *mdb,
+				 const struct net_device *br)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct dsa_mac_addr *a;
@@ -209,9 +211,9 @@ static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_mdb_add(ds, port, mdb);
+		return ds->ops->port_mdb_add(ds, port, mdb, br);
 
-	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
+	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid, br);
 	if (a) {
 		refcount_inc(&a->refcount);
 		return 0;
@@ -221,7 +223,7 @@ static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
 	if (!a)
 		return -ENOMEM;
 
-	err = ds->ops->port_mdb_add(ds, port, mdb);
+	err = ds->ops->port_mdb_add(ds, port, mdb, br);
 	if (err) {
 		kfree(a);
 		return err;
@@ -229,6 +231,7 @@ static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
 
 	ether_addr_copy(a->addr, mdb->addr);
 	a->vid = mdb->vid;
+	a->br = br;
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &dp->mdbs);
 
@@ -236,7 +239,8 @@ static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
 }
 
 static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb)
+				 const struct switchdev_obj_port_mdb *mdb,
+				 const struct net_device *br)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct dsa_mac_addr *a;
@@ -244,16 +248,16 @@ static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_mdb_del(ds, port, mdb);
+		return ds->ops->port_mdb_del(ds, port, mdb, br);
 
-	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
+	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid, br);
 	if (!a)
 		return -ENOENT;
 
 	if (!refcount_dec_and_test(&a->refcount))
 		return 0;
 
-	err = ds->ops->port_mdb_del(ds, port, mdb);
+	err = ds->ops->port_mdb_del(ds, port, mdb, br);
 	if (err) {
 		refcount_inc(&a->refcount);
 		return err;
@@ -266,7 +270,8 @@ static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
 }
 
 static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
-				 const unsigned char *addr, u16 vid)
+				 const unsigned char *addr, u16 vid,
+				 const struct net_device *br)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct dsa_mac_addr *a;
@@ -274,9 +279,9 @@ static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_add(ds, port, addr, vid);
+		return ds->ops->port_fdb_add(ds, port, addr, vid, br);
 
-	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
+	a = dsa_mac_addr_find(&dp->fdbs, addr, vid, br);
 	if (a) {
 		refcount_inc(&a->refcount);
 		return 0;
@@ -286,7 +291,7 @@ static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
 	if (!a)
 		return -ENOMEM;
 
-	err = ds->ops->port_fdb_add(ds, port, addr, vid);
+	err = ds->ops->port_fdb_add(ds, port, addr, vid, br);
 	if (err) {
 		kfree(a);
 		return err;
@@ -294,6 +299,7 @@ static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
 
 	ether_addr_copy(a->addr, addr);
 	a->vid = vid;
+	a->br = br;
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &dp->fdbs);
 
@@ -301,7 +307,8 @@ static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
-				 const unsigned char *addr, u16 vid)
+				 const unsigned char *addr, u16 vid,
+				 const struct net_device *br)
 {
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct dsa_mac_addr *a;
@@ -309,16 +316,16 @@ static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_del(ds, port, addr, vid);
+		return ds->ops->port_fdb_del(ds, port, addr, vid, br);
 
-	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
+	a = dsa_mac_addr_find(&dp->fdbs, addr, vid, br);
 	if (!a)
 		return -ENOENT;
 
 	if (!refcount_dec_and_test(&a->refcount))
 		return 0;
 
-	err = ds->ops->port_fdb_del(ds, port, addr, vid);
+	err = ds->ops->port_fdb_del(ds, port, addr, vid, br);
 	if (err) {
 		refcount_inc(&a->refcount);
 		return err;
@@ -343,7 +350,7 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 		if (dsa_switch_host_address_match(ds, port, info->sw_index,
 						  info->port)) {
 			err = dsa_switch_do_fdb_add(ds, port, info->addr,
-						    info->vid);
+						    info->vid, info->br);
 			if (err)
 				break;
 		}
@@ -365,7 +372,7 @@ static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 		if (dsa_switch_host_address_match(ds, port, info->sw_index,
 						  info->port)) {
 			err = dsa_switch_do_fdb_del(ds, port, info->addr,
-						    info->vid);
+						    info->vid, info->br);
 			if (err)
 				break;
 		}
@@ -382,7 +389,7 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_fdb_add(ds, port, info->addr, info->vid);
+	return dsa_switch_do_fdb_add(ds, port, info->addr, info->vid, info->br);
 }
 
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
@@ -393,7 +400,7 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_fdb_del(ds, port, info->addr, info->vid);
+	return dsa_switch_do_fdb_del(ds, port, info->addr, info->vid, info->br);
 }
 
 static int dsa_switch_hsr_join(struct dsa_switch *ds,
@@ -463,7 +470,7 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_mdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_mdb_add(ds, port, info->mdb);
+	return dsa_switch_do_mdb_add(ds, port, info->mdb, info->br);
 }
 
 static int dsa_switch_mdb_del(struct dsa_switch *ds,
@@ -474,7 +481,7 @@ static int dsa_switch_mdb_del(struct dsa_switch *ds,
 	if (!ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_mdb_del(ds, port, info->mdb);
+	return dsa_switch_do_mdb_del(ds, port, info->mdb, info->br);
 }
 
 static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
@@ -489,7 +496,8 @@ static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_switch_host_address_match(ds, port, info->sw_index,
 						  info->port)) {
-			err = dsa_switch_do_mdb_add(ds, port, info->mdb);
+			err = dsa_switch_do_mdb_add(ds, port, info->mdb,
+						    info->br);
 			if (err)
 				break;
 		}
@@ -510,7 +518,8 @@ static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_switch_host_address_match(ds, port, info->sw_index,
 						  info->port)) {
-			err = dsa_switch_do_mdb_del(ds, port, info->mdb);
+			err = dsa_switch_do_mdb_del(ds, port, info->mdb,
+						    info->br);
 			if (err)
 				break;
 		}
-- 
2.25.1

