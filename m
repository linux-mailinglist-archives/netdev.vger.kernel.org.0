Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275A84DB9A0
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358019AbiCPUnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358059AbiCPUnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:43:22 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2068.outbound.protection.outlook.com [40.107.21.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9ED6E579
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:42:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWq98yvnxtXuIkppksmt+8OURIfT3rcPm+7bRrugMKQ/jNSWcDbDm9F7MPnHnjTukUmwiG0/GYdDGKKz+UI9o5LVYP6bEsblkeF5JMUSezqLO64jsDYQLh+y8Hs8f/vB2c9b20dEs+ModZLLBb2HRfdxjiuIiFNsCy3TpUDR0NHqxGmHTvxMgpT3/p4n2TGgwuiT7lPtRAxxzjOAraZCrJk5sE//Rpeut3FV75ab8XvI8yXCAgEYC//J6y2l8unI438U1cqKrQ8bfmYq38R2FH5JSs2JHXrdUoajVY66xKdihDD6BqJOUL8CuU969Nxws6QSXq5VoO2fvP54QJloXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muVLRVezr1vWUDs2v1tSLPpklF+6OTtL9Dbu9eIl8rk=;
 b=ffA9HLQLFaZSD6bxc08bARrmB2FvR+T7Y0A71cK0vqtmCci0b0QHLTUG43W5RrxPmnYjLcYSglLHQ+Wj4grxOqbJfwJoDmECP4BpZgj3rkVF8JJlmKwRiCmq/5cICWcG9HeST6UyWPR1fPTjomxT8kc+oBxYX9pX/bYj96q/GkbB3lD/AofdaK7mLsGF/JryhyYxv73XJ3/NNKvkwMXCXA55ssxoR8N640Ox0nBQBSMjT5IJbVWyn834C91nUunWSiFZrHJD0C9Tqhj4Sk5K1NeZbvVInn3ZyXneOaIYL722OKZerE8hnYqSvsea49ZwvrRGGLng6MaIjemDT0XRfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muVLRVezr1vWUDs2v1tSLPpklF+6OTtL9Dbu9eIl8rk=;
 b=J2VYhg1opDhzqJygMMu0ZJ45E3thEqPpD1mOBgjfa0dAUm4iQhB20HKFM3vIzI09qjJjxCXwaqTZAp4VLSpDtFyVUjaVpPj7Rb2rN6Ll6rPAZwYz2E/Jg0+cvcJtNX7jptfcwTdcSGPVGDusAQGLHXGAzzoJwQ5wCQoXkApa2RY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB3293.eurprd04.prod.outlook.com (2603:10a6:802:11::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.29; Wed, 16 Mar
 2022 20:42:01 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f%6]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 20:42:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 5/6] net: dsa: pass extack to dsa_switch_ops :: port_mirror_add()
Date:   Wed, 16 Mar 2022 22:41:43 +0200
Message-Id: <20220316204144.2679277-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
References: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0037.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::25) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a4599c2-1fdb-4e4d-5e82-08da078d6a3f
X-MS-TrafficTypeDiagnostic: VI1PR04MB3293:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB3293E685455BBFFF8272C204E0119@VI1PR04MB3293.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CWcI4QPIcQDAHDzbNNeRlqfl/yaEFAGPRvwce3uzGzK4cUwa2y/lxYo9CwYQ4ps2s+DGBfIhp0gNNQZ4dv7DwtFv0ocjvEDgReXvZfieU7NH41jWk3AdXBygh8ZjbytZhxNKYeIiU/qMZpncKIDhsonKwxKv7XZYxxJMF6YAqQI8UfeLurOqIPYxwUh9UrYz5fGakU3R3pr+ItpzIaB7scsH2sw6YMvTjJRvLhFhLIpVtxQVKCFGKMTNkLsL2C3uozYZvjyiS30bE6AXKmWQQDy+ClqWk5bOHOyWAu1QxPVLcGj1Gmzuhcl2t6fHeHCChWvqSQk2NXOAFp0P1qz1AC0ZhlTz6sawFPrQzWOj3C0v/8GpUwYT6H4Xownf9ydDlUxePE2qLdj9Cuv/zXSWE0LTHbdrvu8xYnOr+f0S+bYckgbhhCego97nIv4aScS5UNf+RfLKTo3dKbi9a8foE0QKEuB2fSjPQGHqjDG1zCGD0ZB3nTQXDGHxg6HfEAbs6jVpNnhO6ncNfUexwwn0nPIJfx3X/egpAK+sfeuP9dhsLGQJlS3iA8lYkcx520B1i82Uy2hGALsx/tBNCz3FsaFeree25G+5X5mhs6Pa3XCu5pVvPfbfmNT5hUTZD5AUZaoS9d6xUxE56s1omYxkeio59pPp6Jt6u9EmQtmN9Qp74vxMjnr5PCO9w/bemuOyCN5R6BlSVe6RLxv7QToxxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(38350700002)(86362001)(6916009)(316002)(6486002)(54906003)(5660300002)(36756003)(8936002)(44832011)(8676002)(66946007)(4326008)(66556008)(66476007)(2906002)(83380400001)(2616005)(1076003)(6506007)(508600001)(6512007)(6666004)(52116002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h49RflsSPWz2vpRi8BxRvIDMQtnP7pPPlNNkWCcUhh1c+epAhmVaCsd9d9K5?=
 =?us-ascii?Q?ISLXHaWMd6jiRKI4DnYTfBGQB7H5c+WdS6P/Zup6ZrqFMhPbysY2s/PkyiOs?=
 =?us-ascii?Q?Ugu31Rt2hZNxm5/MSWkqNXXsn9RCpcHIkMFWAD3lAPbGKWu61TtFZRUx3EET?=
 =?us-ascii?Q?c5xeIHnId6ahcLh1bHvyunntEuLUhuE2PpSUxwSnGORNg45NPQoSCcEPkHFt?=
 =?us-ascii?Q?ZWAQ2TLxTY3hJtmLX2sNHPHKXaIOiptfVnjudKh2EPilEvaAfhutAE/nkq6F?=
 =?us-ascii?Q?AqjCWX0drryThagfoOFfLv3gU03uMnBTQHuRNr/fBPII80oZOZTUMHMD7AeM?=
 =?us-ascii?Q?L9hHuBQCPhJN01cT/AkrApdJNl8QbkfNoyrzPnaVIEnctk16+NEdGoVuODEF?=
 =?us-ascii?Q?sh6rugXcatuhd52TdyruA9r82uhYJphsfc941hdg0w/D63O6HXdWp+1JqxLo?=
 =?us-ascii?Q?yijHw4/XOTpBSovPkLUfjrDkV9fgrreL2rbonsxkuFqsbTYqyQrLWVag7mCQ?=
 =?us-ascii?Q?lMXj24Bdewz7Hxj4dONA5MQej1crzLgb2vOf+EIWKdkTiBypNTKzyoJP9YJZ?=
 =?us-ascii?Q?jre0RrJVpia5jkA7mW+mlaJrH/JzpayqFtAykK+lq5qFGcGhYCXa29qSc6R5?=
 =?us-ascii?Q?I/VolkYp2KoYdm4Kb/ywQqJFzjdRuo3kQ8RvInuhuX5c60bAPd+4wg/OnnSe?=
 =?us-ascii?Q?aLTiX5AY7HViMMER2Gi9Qiu6JyGXQCViYQgUBAntt9XECGEX8vYVxrWGtPQ1?=
 =?us-ascii?Q?utEhvko/VBw+VbVEOJ+Z3korfEEvtu2ZIwNnGvLPAJe3jvMu42kv/g/FXYtP?=
 =?us-ascii?Q?YMcv0NrzBVD/RBFUswk3onZg6R/m/egdh+9zqKzuMQ8Gl5pr/cPOsFiQwCHI?=
 =?us-ascii?Q?ymVqq7IsKVUrkmJnqINBDm8fKw5wYEXOQM6J7wLR+VtQkGieOo6TNJrzsnG4?=
 =?us-ascii?Q?wQScA23gNy6GtBiQmS23shSwaTSDvUyLlhv3Sa9BobavqWPJSFL4ahLqggpA?=
 =?us-ascii?Q?5s5ILsmi255DhsE1+00pPw5gUBO9sJddoGJVyVLcTeFPkFnmk7CMmNRSlgNY?=
 =?us-ascii?Q?RtCxXI347SAmt1rA4wpqrPQTEZl6Cw5tt1i8esljrhMA1fq9rCEN6dO4U8Nc?=
 =?us-ascii?Q?fddWagEOwrPn/fYMS8l/kv092ysSxzC3zFMg8j2NWkGS5LyV+zD7+g729WSK?=
 =?us-ascii?Q?1MiOTjunIaJim5xMd4ot6vw4QQyem1QlDidIAf7rVcZ0NDw/rzz0c9HVAjbF?=
 =?us-ascii?Q?//vAptNUlBJEULoUmIcexjRU8vKMTj/J/U0JYTop6Ncx8uYohp/rVnVwpAX0?=
 =?us-ascii?Q?i9vRyzsHx2qCa2pjDnx2dR1wJxxSWXG54XXGukfBmqg/FdgKFrm1B+6DaGWz?=
 =?us-ascii?Q?gdu2uSmbEER/LzRrhOclEWOKQaO6kQbSycaq23+OUqON7utunUljQB3IQAmH?=
 =?us-ascii?Q?u2gA941lRsFSN4xlYLPjoqyaETnFyHzUmOlMlqnfCtEKc/cWaKtY9w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a4599c2-1fdb-4e4d-5e82-08da078d6a3f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 20:41:58.2073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sGjNoMJEd55wLWMMYEbbHYrqasQzFDqsiAL+y2TT2ezNt72Qu9Qv8kOu4lUA6xMKK5JVRm3ziY4yK2Xz4/xFeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3293
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers might have error messages to propagate to user space, most
common being that they support a single mirror port.

Propagate the netlink extack so that they can inform user space in a
verbal way of their limitations.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       | 3 ++-
 drivers/net/dsa/b53/b53_priv.h         | 3 ++-
 drivers/net/dsa/microchip/ksz8795.c    | 2 +-
 drivers/net/dsa/microchip/ksz9477.c    | 2 +-
 drivers/net/dsa/mt7530.c               | 2 +-
 drivers/net/dsa/mv88e6xxx/chip.c       | 3 ++-
 drivers/net/dsa/qca8k.c                | 2 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 include/net/dsa.h                      | 2 +-
 net/dsa/slave.c                        | 3 ++-
 10 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 122e63762979..77501f9c5915 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2110,7 +2110,8 @@ enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL(b53_get_tag_protocol);
 
 int b53_mirror_add(struct dsa_switch *ds, int port,
-		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress)
+		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress,
+		   struct netlink_ext_ack *extack)
 {
 	struct b53_device *dev = ds->priv;
 	u16 reg, loc;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 86e7eb7924e7..3085b6cc7d40 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -373,7 +373,8 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 		const struct switchdev_obj_port_mdb *mdb,
 		struct dsa_db db);
 int b53_mirror_add(struct dsa_switch *ds, int port,
-		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress);
+		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress,
+		   struct netlink_ext_ack *extack);
 enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
 					   enum dsa_tag_protocol mprot);
 void b53_mirror_del(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 5dc9899bc0a6..19050a0216fb 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1213,7 +1213,7 @@ static int ksz8_port_vlan_del(struct dsa_switch *ds, int port,
 
 static int ksz8_port_mirror_add(struct dsa_switch *ds, int port,
 				struct dsa_mall_mirror_tc_entry *mirror,
-				bool ingress)
+				bool ingress, struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index a4699481c746..8222c8a6c5ec 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1018,7 +1018,7 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 
 static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror,
-				   bool ingress)
+				   bool ingress, struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 669f008528ec..19f0035d4410 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1714,7 +1714,7 @@ static int mt753x_mirror_port_set(unsigned int id, u32 val)
 
 static int mt753x_port_mirror_add(struct dsa_switch *ds, int port,
 				  struct dsa_mall_mirror_tc_entry *mirror,
-				  bool ingress)
+				  bool ingress, struct netlink_ext_ack *extack)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int monitor_port;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 84b90fc36c58..d733b07b406c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6036,7 +6036,8 @@ static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
 
 static int mv88e6xxx_port_mirror_add(struct dsa_switch *ds, int port,
 				     struct dsa_mall_mirror_tc_entry *mirror,
-				     bool ingress)
+				     bool ingress,
+				     struct netlink_ext_ack *extack)
 {
 	enum mv88e6xxx_egress_direction direction = ingress ?
 						MV88E6XXX_EGRESS_DIR_INGRESS :
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ee0dbf324268..d3ed0a7f8077 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2473,7 +2473,7 @@ qca8k_port_mdb_del(struct dsa_switch *ds, int port,
 static int
 qca8k_port_mirror_add(struct dsa_switch *ds, int port,
 		      struct dsa_mall_mirror_tc_entry *mirror,
-		      bool ingress)
+		      bool ingress, struct netlink_ext_ack *extack)
 {
 	struct qca8k_priv *priv = ds->priv;
 	int monitor_port, ret;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 3358e979342c..b33841c6507a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2847,7 +2847,7 @@ static int sja1105_mirror_apply(struct sja1105_private *priv, int from, int to,
 
 static int sja1105_mirror_add(struct dsa_switch *ds, int port,
 			      struct dsa_mall_mirror_tc_entry *mirror,
-			      bool ingress)
+			      bool ingress, struct netlink_ext_ack *extack)
 {
 	return sja1105_mirror_apply(ds->priv, port, mirror->to_local_port,
 				    ingress, true);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9bfe984fcdbf..fa9413f625f1 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1022,7 +1022,7 @@ struct dsa_switch_ops {
 				    struct flow_cls_offload *cls, bool ingress);
 	int	(*port_mirror_add)(struct dsa_switch *ds, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror,
-				   bool ingress);
+				   bool ingress, struct netlink_ext_ack *extack);
 	void	(*port_mirror_del)(struct dsa_switch *ds, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror);
 	int	(*port_policer_add)(struct dsa_switch *ds, int port,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f9cecda791d5..7bff7023f877 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1155,6 +1155,7 @@ dsa_slave_add_cls_matchall_mirred(struct net_device *dev,
 				  struct tc_cls_matchall_offload *cls,
 				  bool ingress)
 {
+	struct netlink_ext_ack *extack = cls->common.extack;
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct dsa_slave_priv *p = netdev_priv(dev);
 	struct dsa_mall_mirror_tc_entry *mirror;
@@ -1192,7 +1193,7 @@ dsa_slave_add_cls_matchall_mirred(struct net_device *dev,
 	mirror->to_local_port = to_dp->index;
 	mirror->ingress = ingress;
 
-	err = ds->ops->port_mirror_add(ds, dp->index, mirror, ingress);
+	err = ds->ops->port_mirror_add(ds, dp->index, mirror, ingress, extack);
 	if (err) {
 		kfree(mall_tc_entry);
 		return err;
-- 
2.25.1

