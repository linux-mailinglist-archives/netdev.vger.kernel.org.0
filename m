Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155753E1FEE
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 02:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241165AbhHFAVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 20:21:06 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:14702
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240778AbhHFAU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 20:20:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foZr+O8uTllzzM/ui5aFXremQHRG1gpqv8uEcannex7Gw/csXaixlAsI6IBrdgnwjs6R5kjO3vcv4JMFCDQC8208MxjLtydU7AxrsM2fnfEiPUQNriEZveamU04uuZW5kuNmJ9f2x6rPfLe83dvql0nMJOS6kw+OFu4YIDX0jC3NXbxMnoI4ylf/zUvQHdNWXSLgZxJD6m3pSY2IDm+hBuvM6+LCQ3qu8ny+khhUXOkWcCN23/vcpUgTihoFigRNYQDun3LPeeLnHY7EGMFEAtzSN91zIXN0Y+BewGLk35kQSTVGNgUk4/0gIcp2iWFt91LwF9FcXqAhElDJbSERfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIm88YN1llotIZLYXtFMIB61jHjwMeAdJLHGaXoxvak=;
 b=IVHGFEnCbR1crXqY5vWquR/B+kdvf0CZSFZlte6tVQl35WHKJSZiOGWsabyPPYpohLAQ3DmqI9oRL8A+I6GN1PtiqK4kn53Y7vQeeUC1wAnUJNHY1cPY2qXXUJL1zfPSwfo7L4MDc7EMjXfTEQT2lNMtc1XusEvIyqmWAvRCF6b3XxfW9rWA5aJNjU3gogx8zV5yGPq14loU6DWF5HoQYViSA0MK8slmIp5+bWLCanTPR6FrrY+F3N6A2g+Sx6g8Jl8GKuOTQ8WNvxhqvfdO5PRwTPgu9GmapZK4SuiGqvuFHDrzZmUYqJvZ7aEFPSExsdDcm8kSTdFHZeAXtI0PBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIm88YN1llotIZLYXtFMIB61jHjwMeAdJLHGaXoxvak=;
 b=BKJRkzojI4oSPYI9yLX5ZvlQXccUPcPLcaFUzIQqEQtKTY8GTObiBqS/n42v2M3IDvhnvB0aEnKX/QxxKmOPx2MAJleaLXzfsiZ0mOa/lw/hCAKdzjrIeX4WMTHSRRD1RDPg+CtIAXIGx8HKKgsg/5Ra2F8NNNx1SeovivngbKQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Fri, 6 Aug
 2021 00:20:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.017; Fri, 6 Aug 2021
 00:20:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 3/3] net: dsa: don't disable multicast flooding to the CPU even without an IGMP querier
Date:   Fri,  6 Aug 2021 03:20:08 +0300
Message-Id: <20210806002008.2577052-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806002008.2577052-1-vladimir.oltean@nxp.com>
References: <20210806002008.2577052-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0087.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0087.eurprd08.prod.outlook.com (2603:10a6:800:d3::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 00:20:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7caf5a4-fbdf-45b6-6645-08d95870048b
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-Microsoft-Antispam-PRVS: <VE1PR04MB734185CCF439A18C8206C37FE0F39@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eLR4L8DzSQBwgDfSODgtXGsoEFVJqGUlzqYTTUPNM8l3gipbU0+mqBgZ429t7lci2q3XWwL58MFYfQPPK4GCeqpqQZ9i6VjDLoErxy3tEVmQ8NimfjcSPl/3qQTi6e3yTcB7llZIvftNAhM/rK4NaLFVtgE0U56viJCSzwUdnlEUv7hAJ6y/tunB59djeBiMpfBvGEqWAwc39iRZbtAnAISlJnN+y+CEK/8Izwty7uaD/eSrn3cULXUXYsXpz+bZqkC8zOQ9lxtOTlxUN36HdU15fsshdZklqR5dSPxG1vAqzME3NNIpMFk/Hl6+Qfnzd2ZRdHm/DFTCKWgQwEM/kvHbJVx/J0MYgHJ8a5yRB3DJVpPq3eIa6ipVobzaMm7IEuYNIR4/nrtg6MWK40Oa0ZNvJhZpkrSbWltNJ9uIKZo6aYokQwI4P5od5xHtqy12KE49+67VD3/2ZlyzOwHIxVVd4Cwig/M603iC6Kw/4rhUkXz1ucRHOGtS7j4ebAn2Flr9eTvejWLL1MYUZklStBisP/SmubV3pq72kbXoI88aP6ypGEiOk8luzO0zF+/Aw6sAtNmmvEMMNfg4+DN5g0mH68g5TFZziZJgTOZ51mt7+YpZdaM0HSd++FHbdo9uLG3oeIweOuT6TnVKNQd3zqGESPWQJPIhQ2Lsn6AOqOu3g318DxLaIxQV91lAy0Ks3fjXRqaqHNm1wrYu/0MG7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(8676002)(44832011)(478600001)(8936002)(6506007)(5660300002)(110136005)(86362001)(316002)(4326008)(54906003)(26005)(186003)(1076003)(2616005)(6512007)(66946007)(66574015)(956004)(83380400001)(66476007)(6666004)(6486002)(52116002)(7416002)(38100700002)(36756003)(66556008)(2906002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nWPjn3CId1KyN3HC9eKP3Iaw9JDOHA2m8QCWAEu9RgrI/suy9r9ioHb7i0hf?=
 =?us-ascii?Q?6UD3vHN3fM1We3OCR/T40Ey4/C2RApKLD13NClH8cbnMCcov2eyvDPEr1Co8?=
 =?us-ascii?Q?smnRNe073boV+be9Xl5eMJNvEtdykKBh+qSRoeZ93CWOD0kQcFq+anJUZo/H?=
 =?us-ascii?Q?nbJHjrGgbkNKsuGpv/up0rw0xMK/GcRLvvm4X7TAjnfjqCVmNUxbtVaDc/hQ?=
 =?us-ascii?Q?e5K0W3wFcVPVxNIW65w+2kc+1K4J9DoqCs1AgjxS5pHHwF8Mhlxb8clnfub0?=
 =?us-ascii?Q?QM20dO4i06FaRaASBOZPhoOs2wijO+JGZCRIkGmGxzbabwShuuWpJVioWS4A?=
 =?us-ascii?Q?k82hoClo1ddJKMy3yUt8fd7FNRtp7jgUtGsPJH8MPaxWHvTd1CP6aenyU50m?=
 =?us-ascii?Q?4p2o48F35RSiD/bwHZSZT96JIEbtgYmS8Y/NLROPmNRigjGeC+5sk2a9uGKp?=
 =?us-ascii?Q?9e70sfOxcw6/uUhRD3WX8whoVTb1q2XzwBWZZvNMmbJyykdfM589oz4SFk4p?=
 =?us-ascii?Q?mpLSTOUF8CMBKqrahRnIXPZer0O4f1fAgTXaWyZm7FkjioXnhm3qDg0fb3Qh?=
 =?us-ascii?Q?5wd69zFvXIoBzqC8HR0XnWBb/x5jVT0i4g3Ym0rwxnTWn0cMbQ3yfPapnelC?=
 =?us-ascii?Q?BVpkxWz+7Us/AHq4sh6XFSqOW09kgQdZtmIr83lEXqF2KFapM0IeUtpIQbvq?=
 =?us-ascii?Q?/eG0VbO75rePbmxx996e2SIF4kiM0asmYRVArr36RL8AvxD0I7Z7M342MAA1?=
 =?us-ascii?Q?ceDZDIpNwQxntMpCEgpVSfl0hzbtmdxaRr7nWjSZtLnY4E7iED806d5cU2Fz?=
 =?us-ascii?Q?PuMSYhVHwN5gziN9fAav59dVlEtFdICS5xxbbSMcox6ZJNAv+rqIBWSQ2onN?=
 =?us-ascii?Q?NbXtm8sRgRv3ATirZHAsE8Pe8MNDIlxpUVoI553Y++VJVcGw3GPU63qyMP+E?=
 =?us-ascii?Q?1AT0U2Z9F37e2AAgkDC6iRYKDblpTREshNOEaTeVvIpd1zOD42liwVMrYDZM?=
 =?us-ascii?Q?ernpA5IRnWt5THmiWy04iqIYd7PADIGJ+SB3R1eprCqd1zEXk25Bgnxn4jOP?=
 =?us-ascii?Q?dDgFD2QLx0x7jlAVXwjdaPBCuwSgIxRXedSNE1QGH5YJhC65GOCgWj7qNDWG?=
 =?us-ascii?Q?obbIpvl+rzIvmOC2g843fAK3sqg2iGTpo5dJtobQN3urRHZCQt20lzFuyXhP?=
 =?us-ascii?Q?pcthvwqjb2wFTloRWrUSVN/m5EMgZuNkOC1Ze9Q9BopnTymrQ0KpVGS0EJGO?=
 =?us-ascii?Q?ibuXnEmVAVWQ7z5RmCVR9NAqBMNev7MOB00ORlISoDPJainNVe8i/eyF9zIS?=
 =?us-ascii?Q?uNNsVdP4wJ+fJXmDhtXxQ4mS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7caf5a4-fbdf-45b6-6645-08d95870048b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 00:20:38.6651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XaIMXo7OC8BFBDZIHbjOwbR3RXetp9en11E8KxBH/PfCkxD74RlOO9JQeXvZRC0F4DbcUjeHxW94+ErG+x35zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 08cc83cc7fd8 ("net: dsa: add support for BRIDGE_MROUTER
attribute") added an option for users to turn off multicast flooding
towards the CPU if they turn off the IGMP querier on a bridge which
already has enslaved ports (echo 0 > /sys/class/net/br0/bridge/multicast_router).

And commit a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
simply papered over that issue, because it moved the decision to flood
the CPU with multicast (or not) from the DSA core down to individual drivers,
instead of taking a more radical position then.

The truth is that disabling multicast flooding to the CPU is simply
something we are not prepared to do now, if at all. Some reasons:

- ICMP6 neighbor solicitation messages are unregistered multicast
  packets as far as the bridge is concerned. So if we stop flooding
  multicast, the outside world cannot ping the bridge device's IPv6
  link-local address.

- There might be foreign interfaces bridged with our DSA switch ports
  (sending a packet towards the host does not necessarily equal
  termination, but maybe software forwarding). So if there is no one
  interested in that multicast traffic in the local network stack, that
  doesn't mean nobody is.

- PTP over L4 (IPv4, IPv6) is multicast, but is unregistered as far as
  the bridge is concerned. This should reach the CPU port.

- The switch driver might not do FDB partitioning. And since we don't
  even bother to do more fine-grained flood disabling (such as "disable
  flooding _from_port_N_ towards the CPU port" as opposed to "disable
  flooding _from_any_port_ towards the CPU port"), this breaks standalone
  ports, or even multiple bridges where one has an IGMP querier and one
  doesn't.

Reverting the logic makes all of the above work.

Fixes: a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
Fixes: 08cc83cc7fd8 ("net: dsa: add support for BRIDGE_MROUTER attribute")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: delete all occurrences of b53_set_mrouter

 drivers/net/dsa/b53/b53_common.c | 10 ----------
 drivers/net/dsa/b53/b53_priv.h   |  2 --
 drivers/net/dsa/bcm_sf2.c        |  1 -
 drivers/net/dsa/mv88e6xxx/chip.c | 18 ------------------
 include/net/dsa.h                |  2 --
 net/dsa/dsa_priv.h               |  2 --
 net/dsa/port.c                   | 11 -----------
 net/dsa/slave.c                  |  6 ------
 8 files changed, 52 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index b23e3488695b..bd1417a66cbf 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2016,15 +2016,6 @@ int b53_br_flags(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_br_flags);
 
-int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
-		    struct netlink_ext_ack *extack)
-{
-	b53_port_set_mcast_flood(ds->priv, port, mrouter);
-
-	return 0;
-}
-EXPORT_SYMBOL(b53_set_mrouter);
-
 static bool b53_possible_cpu_port(struct dsa_switch *ds, int port)
 {
 	/* Broadcom switches will accept enabling Broadcom tags on the
@@ -2268,7 +2259,6 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_bridge_leave	= b53_br_leave,
 	.port_pre_bridge_flags	= b53_br_flags_pre,
 	.port_bridge_flags	= b53_br_flags,
-	.port_set_mrouter	= b53_set_mrouter,
 	.port_stp_state_set	= b53_br_set_stp_state,
 	.port_fast_age		= b53_br_fast_age,
 	.port_vlan_filtering	= b53_vlan_filtering,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 82700a5714c1..9bf8319342b0 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -328,8 +328,6 @@ int b53_br_flags_pre(struct dsa_switch *ds, int port,
 int b53_br_flags(struct dsa_switch *ds, int port,
 		 struct switchdev_brport_flags flags,
 		 struct netlink_ext_ack *extack);
-int b53_set_mrouter(struct dsa_switch *ds, int port, bool mrouter,
-		    struct netlink_ext_ack *extack);
 int b53_setup_devlink_resources(struct dsa_switch *ds);
 void b53_port_event(struct dsa_switch *ds, int port);
 void b53_phylink_validate(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3b018fcf4412..6ce9ec1283e0 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1199,7 +1199,6 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.port_pre_bridge_flags	= b53_br_flags_pre,
 	.port_bridge_flags	= b53_br_flags,
 	.port_stp_state_set	= b53_br_set_stp_state,
-	.port_set_mrouter	= b53_set_mrouter,
 	.port_fast_age		= b53_br_fast_age,
 	.port_vlan_filtering	= b53_vlan_filtering,
 	.port_vlan_add		= b53_vlan_add,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 272b0535d946..111a6d5985da 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5781,23 +5781,6 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 	return err;
 }
 
-static int mv88e6xxx_port_set_mrouter(struct dsa_switch *ds, int port,
-				      bool mrouter,
-				      struct netlink_ext_ack *extack)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	if (!chip->info->ops->port_set_mcast_flood)
-		return -EOPNOTSUPP;
-
-	mv88e6xxx_reg_lock(chip);
-	err = chip->info->ops->port_set_mcast_flood(chip, port, mrouter);
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
-}
-
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 				      struct net_device *lag,
 				      struct netdev_lag_upper_info *info)
@@ -6099,7 +6082,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_bridge_leave	= mv88e6xxx_port_bridge_leave,
 	.port_pre_bridge_flags	= mv88e6xxx_port_pre_bridge_flags,
 	.port_bridge_flags	= mv88e6xxx_port_bridge_flags,
-	.port_set_mrouter	= mv88e6xxx_port_set_mrouter,
 	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
 	.port_fast_age		= mv88e6xxx_port_fast_age,
 	.port_vlan_filtering	= mv88e6xxx_port_vlan_filtering,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 33f40c1ec379..048d297623c9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -699,8 +699,6 @@ struct dsa_switch_ops {
 	int	(*port_bridge_flags)(struct dsa_switch *ds, int port,
 				     struct switchdev_brport_flags flags,
 				     struct netlink_ext_ack *extack);
-	int	(*port_set_mrouter)(struct dsa_switch *ds, int port, bool mrouter,
-				    struct netlink_ext_ack *extack);
 
 	/*
 	 * VLAN support
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f201c33980bf..cddf7cb0f398 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -234,8 +234,6 @@ int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
 int dsa_port_bridge_flags(const struct dsa_port *dp,
 			  struct switchdev_brport_flags flags,
 			  struct netlink_ext_ack *extack);
-int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
-		     struct netlink_ext_ack *extack);
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan,
 		      struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d9ef2c2fbf88..23e30198a90e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -597,17 +597,6 @@ int dsa_port_bridge_flags(const struct dsa_port *dp,
 	return ds->ops->port_bridge_flags(ds, dp->index, flags, extack);
 }
 
-int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
-		     struct netlink_ext_ack *extack)
-{
-	struct dsa_switch *ds = dp->ds;
-
-	if (!ds->ops->port_set_mrouter)
-		return -EOPNOTSUPP;
-
-	return ds->ops->port_set_mrouter(ds, dp->index, mrouter, extack);
-}
-
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 532085da8d8f..0356ceb89a37 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -314,12 +314,6 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
 		break;
-	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
-		if (!dsa_port_offloads_bridge(dp, attr->orig_dev))
-			return -EOPNOTSUPP;
-
-		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter, extack);
-		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
-- 
2.25.1

