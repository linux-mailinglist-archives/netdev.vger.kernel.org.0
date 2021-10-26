Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4843B727
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhJZQ3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:29:48 -0400
Received: from mail-vi1eur05on2046.outbound.protection.outlook.com ([40.107.21.46]:18188
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236379AbhJZQ3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:29:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V42Oevhne1GRUtSl5V9rlOXO8gd8lWj8b7JpM438I3Bt2m55wA/QRUhXlUqvK2r3lNB2zR3WYcmsBkSeVY1mB3Lt+gZg58Qqq7ocen3vooSlPpHu81vSdMtmKPn7uY+DKyXdrKUAeaDwJ46sR6ASTSWVvA0mH7sbbBTnTQMkEllSqakSXvHWfmGW4VG9P43jSdzNiJGsY75Saq1Q3uQMpo/0TmBARHXjQW/o2ABZQKmopCF9nuEK0HhAC9dU8hucKNkUTtf1vbM860Bq6jSq6IBNacFXNPXjVdQX7PS8jwBYC01NDrzrdPQr92a6BhQ0Ed9W2NV1mzl6NfnlOTyTzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UyGYLPLBXR9gCfDe6qszFr+X8Tr9t+4qLLaHxna9OY=;
 b=A725kABolxVV7mTOfXzDS2EeM1mAnNgdxB4cWO9r9BLF+mL5IA0qCzJ+XIWJ0ON732ZIX+bKseEyd/YCJN6xiEZaXzCOSUPHSuYHCCCoKwXdU5GVSFwTwHZx3tJp01WGGW20xM7nwhY92zqZAwDWanYKL3jb2BJG3t/3Cj+LvoTMBcnzgcVDAAfMQ5wKDpcbV0z1+mtKRMLp9QKlML1FCljV7NaIdVaXpwz9vYuqPj0hjEeIM69RfJSvaA/GEVXbmNa7w1V58KAfs9EhTxmXy/KmD2uELcrXCB5cVWbcTpr167OQKIO8DmjWu3dljxwSUgnQcke+fG/SrvsAiCQklQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3UyGYLPLBXR9gCfDe6qszFr+X8Tr9t+4qLLaHxna9OY=;
 b=rlSC4iq1sxTP9Z4v8R/UR0eYQq5ADQSLJhWIM9piw4uzRA86UmRnAgzSuSEaQ/N/O/Ivy/UNgCyoJBPzBHDPm3bGopY38kWds8ddz1BWfcQqfvWGFLOs6OtNzEQ3qmVnEJ69vbq/MYBAHaMS2JmAqPgog/kzXio7MPoKOao2OjU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 16:26:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:26:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [RFC PATCH net-next 6/6] net: dsa: eliminate dsa_switch_ops :: port_bridge_tx_fwd_{,un}offload
Date:   Tue, 26 Oct 2021 19:26:25 +0300
Message-Id: <20211026162625.1385035-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
References: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0121.eurprd05.prod.outlook.com
 (2603:10a6:207:2::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR05CA0121.eurprd05.prod.outlook.com (2603:10a6:207:2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 16:26:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78b4465d-88b2-457b-8976-08d9989d6c80
X-MS-TrafficTypeDiagnostic: VI1PR04MB4686:
X-Microsoft-Antispam-PRVS: <VI1PR04MB468690F56738292444C2E02FE0849@VI1PR04MB4686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xl7ZXQzvkt0xJd2FwZNeRyDHKO0jrdqIYYWJcTUh0dzO41m3bJGQmEo5vM7siIJI1hVzsvTsXwrdUYTfFkCQ5DQ3543zxNktjaOIw9+p322Qb3b45xqu37y1WnvTTWTDwKQQjSsl0OW7XF+vuZBIFHu0Hzqc9ZpWp692qVYwheoR8/nvE8gtq/aSWyzS8dHqQKfdY+uLelkU3r796JggSTxwBVlfMDhdhIYmYZn4BlPrFastRrGPZhRSg5iaHr7AlfYCfDLUDF7fcVyIOIAiEhqSjfUTbjXFxvvcQtZQr1zkUk1AdUaz4zSKR6w5H7ahSXNPdqlJz65ko/tWrkbBMbTAPCavm3Ell98b5nxur0Flj8s/osRMT4cil9zh5uRbkccG8BMuf54JsJzphhovM09o37E+LnLl8j+rKz7zy1IYz0cglyercLIj045P8mjo14P0OjoJbAJUT9qj1sh6KL0dh9kUInv0FGUk0wRJ9sKh/LKAnbxyNIFkcCNbVGM5pt7AhZBJk8iXAUin//6hqYs5K0tRl0uurub1sUTkQmb03utnVQwoMzWeaGA5APlHxLM8LtVvq5Uf8Xs0sY8LPN3vbPE2zPtKA/FKhT/VvrDsMRpxI+y7LljX6XSQFpIIcLd05K6gssrOb36+E1vkgeiYKUBvSUaqYtdg5KXN3OaQA7wvwadxyDNvr+RlBb9ndDaYfniqatrJeCNXVrDibQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(6916009)(956004)(8676002)(66556008)(6506007)(1076003)(2616005)(508600001)(186003)(6512007)(30864003)(38100700002)(26005)(5660300002)(6666004)(66946007)(86362001)(44832011)(6486002)(54906003)(52116002)(38350700002)(2906002)(66476007)(83380400001)(316002)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L92Lx3KHEvWyKrjuLPi970Jt0JCUB3kupjkHTSlhPJOeSdQz03TGvyimSWfD?=
 =?us-ascii?Q?EBXlSHSHOAqZLwCYz7jpadOZa62UMe5mtKSOpL2NEdiG1akXn/Onn7wp4IsR?=
 =?us-ascii?Q?ICEjYFSYSTXsBzfh3A0W3DivYQA8swdsbP9m4sddGH3k+6YGouCaXXD4YoXz?=
 =?us-ascii?Q?7w3pFVMrysPrwqHJHFpit2JR5QLVchx1HXHNS5kt+rzVeLh8zaqeDRuR+XAa?=
 =?us-ascii?Q?f/c3vz6oXB+qd2mEOTzDuwTuEhZ4QtfJpmW828GDxL5LTnixnUc4s21kzVHV?=
 =?us-ascii?Q?cvmoPojRR8Tp6iNIb7C+vGSwaNNCeYIx6GAYncloKCFP4tb+QaoNerC0NzNV?=
 =?us-ascii?Q?L5RuhaY16VAVmjZHN+jhathIWWFhsvhSEpbdEOhjZTrXl12EQUhbV44jGTe4?=
 =?us-ascii?Q?uahvKinvFv3In4FtJeg56iRJNwom89jYd+SxNnJ38V62ovicGDUxAxVhwmj+?=
 =?us-ascii?Q?utOfrjEwFinmi6tSu2ntfdsMtoqAwGGtwJYMet++ShIjPGO15i61TmV7MzXW?=
 =?us-ascii?Q?J8Asmg8auxdan6AiDlzsvMoIzQYhTCE/UvFWblSO+q4Lc9ZIpQBvENVXRVVN?=
 =?us-ascii?Q?0z/7Xc36+K/AvaDxxrgU0RiO+aXoJJgjqazItVxZREqAJrRCueOm59fA1Ywk?=
 =?us-ascii?Q?1aoN1lZPhaHPN/1ba5hxencueelV6NEoDCb0xM9yupYxBIc24cnz0nuLm8tW?=
 =?us-ascii?Q?DCrR37ZTOP9Ri7+brD6gBZQxpCdB4ezrLVSuZCYjADxzgnhWFRqdRR5WOtQV?=
 =?us-ascii?Q?I1PxWvx/DnoGYwMDGdkCGP8QXmYEcWBlwZYg0ehYPFsUDmZjEPRnhiMgV3GG?=
 =?us-ascii?Q?7ycAI+WVGrJdbBqe52iQM7IZaXcIqfmFgOifmZkpEkFCsJC5WeZmLfuCSgzO?=
 =?us-ascii?Q?FVBCiDcwCISQpo00rfXKYY05XvqDvOYbgQHUcumeONXEN1EBiUi4+ktF6K5c?=
 =?us-ascii?Q?OVUursLtUvJLWlLhuSbsRLpinwx4VrbNIBt/2PfI2uP6MVNoZm5ryaLvIwd9?=
 =?us-ascii?Q?ZEU/GdoGUu+fWt7SU+yJBcrPN/0gd3BwUo5NvRec6EuLQQ511rezeMgIB+9i?=
 =?us-ascii?Q?Oqv1w5CCUpHnwIukjYl6IZDEtr27Jrss7Qb2VvaTIBtMALQi9/d2an4e03Ey?=
 =?us-ascii?Q?48fOcSyVJcijKtxYo0r2nHAL3tPK4D+mtsBsJw0TLj8s/nTAU3lFg9G9g7As?=
 =?us-ascii?Q?NW20lqhtniFtmXoHQnIKrbxPvqa/XtRo4dSIvF+DSR89w6rxlkbHyxUDFSKy?=
 =?us-ascii?Q?SHUUN96RByljcL97ww6cMrh68R2GKu2Il3uNckBqdwR/1Ly5iDLZWNwuby09?=
 =?us-ascii?Q?Jb+6tkrHCs68a1xttsZuxKcrCuFG+/S8G+qfQVVN3LHZ/ZqvXTYiZTBXiqpf?=
 =?us-ascii?Q?qtrodns8KIEhmq0j3gfhhTTpYIPk/I2vukOz5LsRy6eoPbsyJGrTNtN9CfOn?=
 =?us-ascii?Q?VwMIKhTHiXSwzTaEw8dGYE+ph1+BKq/A1SrmtRyoz69OZtguJLaQrtjGCec/?=
 =?us-ascii?Q?m+h78ia/0KjTd7I7pOG86FJdMEHOBfAPap7Mt9szsp/LVF+irpI1LEcQkD3/?=
 =?us-ascii?Q?g9+KOSIzBoqqp+61OLkjWhQjSvFnRAkBhPDh37IDG+mjtoLmaVr0hOSBgWLS?=
 =?us-ascii?Q?RLHB3vMp8Cy1AKyvTwkxCoI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b4465d-88b2-457b-8976-08d9989d6c80
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:26:54.8505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4oFRH/NaiurfOXJbxfIikbCtJAB3dk7n2pLSlpUFEp9gn7/ZWf0enhdYOTJrGDHTfQAYxkV2c9VpSj4b5xMNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't really need new switch API for these, and with new switches
which intend to add support for this feature, it will become cumbersome
to maintain.

Simply pass a boolean argument to ->port_bridge_join which the driver
must set to true if it implements the TX forwarding offload feature.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       |  3 +-
 drivers/net/dsa/b53/b53_priv.h         |  3 +-
 drivers/net/dsa/dsa_loop.c             |  3 +-
 drivers/net/dsa/hirschmann/hellcreek.c |  3 +-
 drivers/net/dsa/lan9303-core.c         |  3 +-
 drivers/net/dsa/lantiq_gswip.c         |  3 +-
 drivers/net/dsa/microchip/ksz_common.c |  3 +-
 drivers/net/dsa/microchip/ksz_common.h |  2 +-
 drivers/net/dsa/mt7530.c               |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.c       | 71 ++++++++++++--------------
 drivers/net/dsa/ocelot/felix.c         |  2 +-
 drivers/net/dsa/qca8k.c                |  3 +-
 drivers/net/dsa/rtl8366rb.c            |  3 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 22 ++++++--
 drivers/net/dsa/xrs700x/xrs700x.c      |  2 +-
 include/net/dsa.h                      | 10 ++--
 net/dsa/dsa_priv.h                     |  1 +
 net/dsa/port.c                         | 39 ++------------
 net/dsa/switch.c                       |  3 +-
 19 files changed, 81 insertions(+), 100 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 4e41b1a63108..3867f3d4545f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1860,7 +1860,8 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_mdb_del);
 
-int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
+int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
+		bool *tx_fwd_offload)
 {
 	struct b53_device *dev = ds->priv;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index ee17f8b516ca..b41dc8ac2ca8 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -324,7 +324,8 @@ void b53_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void b53_get_ethtool_phy_stats(struct dsa_switch *ds, int port, uint64_t *data);
-int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
+int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
+		bool *tx_fwd_offload);
 void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 70db3a9aa355..33daaf10c488 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -167,7 +167,8 @@ static int dsa_loop_phy_write(struct dsa_switch *ds, int port,
 }
 
 static int dsa_loop_port_bridge_join(struct dsa_switch *ds, int port,
-				     struct dsa_bridge bridge)
+				     struct dsa_bridge bridge,
+				     bool *tx_fwd_offload)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
 		__func__, port, bridge.dev->name);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 17c2d13670a9..53ab5f8ae92e 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -674,7 +674,8 @@ static int hellcreek_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct dsa_bridge bridge)
+				      struct dsa_bridge bridge,
+				      bool *tx_fwd_offload)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 29d909484275..d55784d19fa4 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1103,7 +1103,8 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 }
 
 static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
-				    struct dsa_bridge bridge)
+				    struct dsa_bridge bridge,
+				    bool *tx_fwd_offload)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 6b9b9c712e58..6b5bef7f2a59 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1146,7 +1146,8 @@ static int gswip_vlan_remove(struct gswip_priv *priv,
 }
 
 static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct dsa_bridge bridge)
+				  struct dsa_bridge bridge,
+				  bool *tx_fwd_offload)
 {
 	struct net_device *br = bridge.dev;
 	struct gswip_priv *priv = ds->priv;
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 23784d14a5da..1d13aa56e7d1 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -173,7 +173,8 @@ void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf)
 EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
 
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct dsa_bridge bridge)
+			 struct dsa_bridge bridge,
+			 bool *tx_fwd_offload)
 {
 	struct ksz_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index df953c2bc56e..b444df218c2d 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -159,7 +159,7 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct dsa_bridge bridge);
+			 struct dsa_bridge bridge, bool *tx_fwd_offload);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct dsa_bridge bridge);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 85cc5aca7f96..dcd1a3932cfb 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1186,7 +1186,7 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
-			struct dsa_bridge bridge)
+			struct dsa_bridge bridge, bool *tx_fwd_offload)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 73613a667f6c..0aac71dece29 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2448,8 +2448,27 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
+/* Treat the software bridge as a virtual single-port switch behind the
+ * CPU and map in the PVT. First dst->last_switch elements are taken by
+ * physical switches, so start from beyond that range.
+ */
+static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
+					       unsigned int bridge_num)
+{
+	u8 dev = bridge_num + ds->dst->last_switch;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_pvt_map(chip, dev, 0);
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
 static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
-				      struct dsa_bridge bridge)
+				      struct dsa_bridge bridge,
+				      bool *tx_fwd_offload)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2464,6 +2483,14 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto unlock;
 
+	if (mv88e6xxx_has_pvt(chip)) {
+		err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
+		if (err)
+			goto unlock;
+
+		*tx_fwd_offload = true;
+	}
+
 unlock:
 	mv88e6xxx_reg_unlock(chip);
 
@@ -2478,6 +2505,10 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 
 	mv88e6xxx_reg_lock(chip);
 
+	if (bridge.tx_fwd_offload &&
+	    mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num))
+		dev_err(ds->dev, "failed to remap cross-chip Port VLAN\n");
+
 	if (mv88e6xxx_bridge_map(chip, bridge) ||
 	    mv88e6xxx_port_vlan_map(chip, port))
 		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
@@ -2523,42 +2554,6 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-/* Treat the software bridge as a virtual single-port switch behind the
- * CPU and map in the PVT. First dst->last_switch elements are taken by
- * physical switches, so start from beyond that range.
- */
-static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
-					       unsigned int bridge_num)
-{
-	u8 dev = bridge_num + ds->dst->last_switch;
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_pvt_map(chip, dev, 0);
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
-}
-
-static int mv88e6xxx_bridge_tx_fwd_offload(struct dsa_switch *ds, int port,
-					   struct dsa_bridge bridge)
-{
-	return mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
-}
-
-static void mv88e6xxx_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
-					      struct dsa_bridge bridge)
-{
-	int err;
-
-	err = mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
-	if (err) {
-		dev_err(ds->dev, "failed to remap cross-chip Port VLAN: %pe\n",
-			ERR_PTR(err));
-	}
-}
-
 static int mv88e6xxx_software_reset(struct mv88e6xxx_chip *chip)
 {
 	if (chip->info->ops->reset)
@@ -6278,8 +6273,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
 	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
 	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
-	.port_bridge_tx_fwd_offload = mv88e6xxx_bridge_tx_fwd_offload,
-	.port_bridge_tx_fwd_unoffload = mv88e6xxx_bridge_tx_fwd_unoffload,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 8cf82fa91a6b..001213891b91 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -698,7 +698,7 @@ static int felix_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int felix_bridge_join(struct dsa_switch *ds, int port,
-			     struct dsa_bridge bridge)
+			     struct dsa_bridge bridge, bool *tx_fwd_offload)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 3ae10f22ada9..390dad77f062 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1729,7 +1729,8 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 }
 
 static int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct dsa_bridge bridge)
+				  struct dsa_bridge bridge,
+				  bool *tx_fwd_offload)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask, cpu_port;
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index fac2333a3f5e..ecc19bd5115f 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1186,7 +1186,8 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 
 static int
 rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
-			   struct dsa_bridge bridge)
+			   struct dsa_bridge bridge,
+			   bool *tx_fwd_offload)
 {
 	struct realtek_smi *smi = ds->priv;
 	unsigned int port_bitmap = 0;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 24584fe2e760..cefde41ce8d6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2074,14 +2074,30 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_bridge_join(struct dsa_switch *ds, int port,
-			       struct dsa_bridge bridge)
+			       struct dsa_bridge bridge,
+			       bool *tx_fwd_offload)
 {
-	return sja1105_bridge_member(ds, port, bridge, true);
+	int rc;
+
+	rc = sja1105_bridge_member(ds, port, bridge, true);
+	if (rc)
+		return rc;
+
+	rc = dsa_tag_8021q_bridge_tx_fwd_offload(ds, port, bridge);
+	if (rc) {
+		sja1105_bridge_member(ds, port, bridge, false);
+		return rc;
+	}
+
+	*tx_fwd_offload = true;
+
+	return 0;
 }
 
 static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
 				 struct dsa_bridge bridge)
 {
+	dsa_tag_8021q_bridge_tx_fwd_unoffload(ds, port, bridge);
 	sja1105_bridge_member(ds, port, bridge, false);
 }
 
@@ -3230,8 +3246,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.tag_8021q_vlan_add	= sja1105_dsa_8021q_vlan_add,
 	.tag_8021q_vlan_del	= sja1105_dsa_8021q_vlan_del,
 	.port_prechangeupper	= sja1105_prechangeupper,
-	.port_bridge_tx_fwd_offload = dsa_tag_8021q_bridge_tx_fwd_offload,
-	.port_bridge_tx_fwd_unoffload = dsa_tag_8021q_bridge_tx_fwd_unoffload,
 };
 
 static const struct of_device_id sja1105_dt_ids[];
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index ebb55dfd9c4e..35fa19ddaf19 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -540,7 +540,7 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 }
 
 static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
-			       struct dsa_bridge bridge)
+			       struct dsa_bridge bridge, bool *tx_fwd_offload)
 {
 	return xrs700x_bridge_common(ds, port, bridge, true);
 }
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 5e83c64bc96a..94dc8b5ee9c8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -222,6 +222,7 @@ struct dsa_mall_tc_entry {
 struct dsa_bridge {
 	struct net_device *dev;
 	unsigned int num;
+	bool tx_fwd_offload;
 	refcount_t refcount;
 };
 
@@ -814,15 +815,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*set_ageing_time)(struct dsa_switch *ds, unsigned int msecs);
 	int	(*port_bridge_join)(struct dsa_switch *ds, int port,
-				    struct dsa_bridge bridge);
+				    struct dsa_bridge bridge,
+				    bool *tx_fwd_offload);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
 				     struct dsa_bridge bridge);
-	/* Called right after .port_bridge_join() */
-	int	(*port_bridge_tx_fwd_offload)(struct dsa_switch *ds, int port,
-					      struct dsa_bridge bridge);
-	/* Called right before .port_bridge_leave() */
-	void	(*port_bridge_tx_fwd_unoffload)(struct dsa_switch *ds, int port,
-						struct dsa_bridge bridge);
 	void	(*port_stp_state_set)(struct dsa_switch *ds, int port,
 				      u8 state);
 	void	(*port_fast_age)(struct dsa_switch *ds, int port);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 489712ead08f..5abe6864967a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -56,6 +56,7 @@ struct dsa_notifier_bridge_info {
 	int tree_index;
 	int sw_index;
 	int port;
+	bool tx_fwd_offload;
 };
 
 /* DSA_NOTIFIER_FDB_* */
diff --git a/net/dsa/port.c b/net/dsa/port.c
index b2e66994f72c..b1113788bf9b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -270,37 +270,6 @@ static void dsa_port_switchdev_unsync_attrs(struct dsa_port *dp)
 	 */
 }
 
-static void dsa_port_bridge_tx_fwd_unoffload(struct dsa_port *dp,
-					     struct dsa_bridge bridge)
-{
-	struct dsa_switch *ds = dp->ds;
-
-	/* No bridge TX forwarding offload => do nothing */
-	if (!ds->ops->port_bridge_tx_fwd_unoffload || !bridge.num)
-		return;
-
-	/* Notify the chips only once the offload has been deactivated, so
-	 * that they can update their configuration accordingly.
-	 */
-	ds->ops->port_bridge_tx_fwd_unoffload(ds, dp->index, bridge);
-}
-
-static bool dsa_port_bridge_tx_fwd_offload(struct dsa_port *dp,
-					   struct dsa_bridge bridge)
-{
-	struct dsa_switch *ds = dp->ds;
-	int err;
-
-	/* FDB isolation is required for TX forwarding offload */
-	if (!ds->ops->port_bridge_tx_fwd_offload || !bridge.num)
-		return false;
-
-	/* Notify the driver */
-	err = ds->ops->port_bridge_tx_fwd_offload(ds, dp->index, bridge);
-
-	return err ? false : true;
-}
-
 static int dsa_port_bridge_create(struct dsa_port *dp,
 				  struct net_device *br,
 				  struct netlink_ext_ack *extack)
@@ -361,7 +330,6 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
-	bool tx_fwd_offload;
 	int err;
 
 	/* Here the interface is already bridged. Reflect the current
@@ -378,12 +346,13 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback;
 
-	tx_fwd_offload = dsa_port_bridge_tx_fwd_offload(dp, info.bridge);
+	/* Drivers which support bridge TX forwarding should set this */
+	dp->bridge->tx_fwd_offload = info.tx_fwd_offload;
 
 	err = switchdev_bridge_port_offload(brport_dev, dev, dp,
 					    &dsa_slave_switchdev_notifier,
 					    &dsa_slave_switchdev_blocking_notifier,
-					    tx_fwd_offload, extack);
+					    dp->bridge->tx_fwd_offload, extack);
 	if (err)
 		goto out_rollback_unbridge;
 
@@ -434,8 +403,6 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	 */
 	dsa_port_bridge_destroy(dp, br);
 
-	dsa_port_bridge_tx_fwd_unoffload(dp, info.bridge);
-
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
 		dev_err(dp->ds->dev,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index cd0630dd5417..9c92edd96961 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -95,7 +95,8 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 		if (!ds->ops->port_bridge_join)
 			return -EOPNOTSUPP;
 
-		err = ds->ops->port_bridge_join(ds, info->port, info->bridge);
+		err = ds->ops->port_bridge_join(ds, info->port, info->bridge,
+						&info->tx_fwd_offload);
 		if (err)
 			return err;
 	}
-- 
2.25.1

