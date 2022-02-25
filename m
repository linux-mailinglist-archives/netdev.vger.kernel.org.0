Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171094C413F
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239010AbiBYJYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239015AbiBYJXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:23:47 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5811A8049
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5TcxrOKtZKezaN+gXpIGcWpnPT1haZfLcoFpYCByqPcwuRniu5Mcv5e4MzeRG3dCSuEql0K7NtGWRwZNoIi8PNsTEPoSf7dtUIirD7hQevXdc8Ajgjt8r7xVV5GEIV4iXAXtQxNyYGzH2PmJY2I+z+vVF3jjxOiIbm6StE/bZUPe0Oq7jhb/+PhgDn0VnaP9L0IYz+dYUbWHlJtEdzdkKA0G/8+QIttvSDT8Xuogt3fUTtWkg2nghIyKYgC8tsbyHvlvGhQLHlIfOYgAScAm51Qembmy/2d430WDRE9phCUsOy4jinWjS9jjQS6lhh//ggNu0M7pQOSqah8nbw53Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGLhZU5WX7XXJYG3NCQAVkZkFr8BbN7RXFsQ5cKgR6I=;
 b=ViXB8e6S+k0WUgQQxZdxMPzvb4YO7o08+q46ZY2K1SQWPHQ8kXKp+7g9MUKkzL4jLiSXmw44xqsj25k53FLXOMPBgcJ9SSSYXLfxyFC3pHlNMJHY8ZmtuYXXgtQPQHkSO22Dp66J2V3RNlCGP+mZ6/ILFRpg27+SzsCYovpuBgNqjxKFNR7Ml2NrDTIXTU8p7fWzIzP49oSI1ba35kV/BnaFjJz+nZOAF7oA0Th4/zjsJjGx7G67uWsGppG+uP2a96DmFvz4ZtuW9FI64PSo6CIN+9N+pAkctOSCCQHl2OSJ7mi5S0KI8k3SCHBF0T9DI3vxWnfUsOVqh85o0IqzEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGLhZU5WX7XXJYG3NCQAVkZkFr8BbN7RXFsQ5cKgR6I=;
 b=lA63yMCfB4dE4RAZhnWdsE0s884luuMvZHix8dw48K7r4IkoA3XH5TPy1ntw8hMgx8qfi3stTkvQwTyXAXVw+hmNSSL64WHi1OWtxhl6vLe0K94S/yNYZZgFWdeVCJPVe03Fpe44dH6gAT3lGO01xMaYMW+tGg7KvTpla0Ij8Uc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7658.eurprd04.prod.outlook.com (2603:10a6:10:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 07/10] net: dsa: request drivers to perform FDB isolation
Date:   Fri, 25 Feb 2022 11:22:22 +0200
Message-Id: <20220225092225.594851-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225092225.594851-1-vladimir.oltean@nxp.com>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0065.eurprd02.prod.outlook.com
 (2603:10a6:802:14::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5459252d-c523-4ff5-9624-08d9f8406f47
X-MS-TrafficTypeDiagnostic: DBBPR04MB7658:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB765872E08CBA95E8E7F4687BE03E9@DBBPR04MB7658.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pLUhY0SiIZrF+yE9oojnkTfCzjEfqwOaxxA5vFzFNapQDXD6t5/NsW9xpsC+eHz1ngOrd7Othdkz0TFLkR71QI5QPbRTStIV+v6AdRUnPirzBIPNAL26o98XDqDcCq/jPhPZ0pDF5t95DenwwlyDHMrWJiHmFwEJYpKQ7tLfGRgPCqreOXiOtwgLWwTX+FD6zxMeJHCaZb4R6nON2MzOvExWYRaJWZUps6ecR3VvqF+j6+jFWbUgO/YrNthA5lFCVGG2xc5Jr58qsFg/j5R1aYO5jLCMotM2YUyWGn4S30rQicL5myBnUH21mrT1b38gqDdM76eiltV8hKZoUqhYWWMHEvAfnYGbz6ClePnigoez09aCcsq2lb9XPEdHDfQCGWvCCCXrahZy/yx7eV8oddBi7i48nTcSJJIoQbY+9+IXJ28BGXGqt/4nn6bOB9aa3EgwrCdX33HwBDyEv4WWNPJuIddPkkyLTnw6M7xB/kWaZcc6cbVrgvE/cffB/akEPmMAw12zz4zjNMoWcSD8HDYeuDrgy+9tABES4nTOTFphqLDCCtylSmkwKWKW+USn6RJ7EOnL25LRuSy7FGaW26ULfwz7bq0OfEk1MYucGp1ABebovIQBxND1AwP16Za+xbw95dg0+n1gJvKeyvoBlKSMpKciHDNF6gwjzuQpc0AzGYyTej39cL+6Qo0DRVZN3nZrDBsKQmpIhS+ZYtNhsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(4326008)(316002)(38100700002)(8676002)(110136005)(6486002)(6666004)(38350700002)(86362001)(8936002)(6506007)(52116002)(36756003)(66946007)(30864003)(7416002)(26005)(186003)(66556008)(66476007)(1076003)(6512007)(44832011)(83380400001)(5660300002)(2906002)(2616005)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YysUIzY9RCmsWmOgChOcJV2ky+nxAWAWr/qv1eZb0j7sgV4ktM+w5CeoYaci?=
 =?us-ascii?Q?AgUmE/jF+BXFR2sZt5iyEjvRRZxVcaqdDMKn/c+JoVxCsOp/p2ACsj+ajZLc?=
 =?us-ascii?Q?scrH8NY+3yKlu0EZw6xERto2HSQspokKp/8I3JtnVLnX24qnty0fVuxmnYuR?=
 =?us-ascii?Q?Azd1VuCeCBK65Qyglypy/JNOg/T7laxdir3gZlaoLeDCpi/wg9hK8Kg916l0?=
 =?us-ascii?Q?O6g/9bI+kcyP67WE+qq4eicf48EzCW0NqUirRa5a+t8vclZIOICvvtTX8vAF?=
 =?us-ascii?Q?4oEN9vD9vHGWjPBTkWzkKtoHSxBnGN7cbebXBhOwj2qeCft2fRN1SXyV3ZS0?=
 =?us-ascii?Q?BX518ShFwR3QbVanYvb07prJ4IqNFQOJh18dWzwcZH/7Pgx9LM2/o+zDKaQ4?=
 =?us-ascii?Q?1X5AB/sEetOX4gQ/Dx5DHh7KzVUPhTo0aqZxa5l9G4jmP0zq+YsnO1zF8o8B?=
 =?us-ascii?Q?MtsStVvdYB8qO6IUOP0JTV5LtL4crQwcqWtJeV5rw7eVux1FHDe8YS3DZW/w?=
 =?us-ascii?Q?zj/fCCM1zZ7HUl5M8KU4AzqbtIiV9Jn0yf9ulaU5OqFIoV7Z4lgNpZ+QjGMT?=
 =?us-ascii?Q?x1QxXKCtyrUATCZEPhqDAcWL/flt/ZCRc9AgzxgmqioHLcblCSkN6UkqkWbl?=
 =?us-ascii?Q?+SSkaeGsjx4FTTd+ZoTvBFzSj0GX8zEdz2S+7s3HX/Mw5VOz2Bor8bEQqChB?=
 =?us-ascii?Q?XuSdgxyuQzoA/eWrpbOFWYtJcyK/Stkpu87zv4Dbub4etw4XD4g/IQrAw+is?=
 =?us-ascii?Q?5eo3qC8ulCSP2WxmtWBb9XmhbMEfPCCip16N+TozQhheGZS8oCcfQW/b+wl9?=
 =?us-ascii?Q?TWmWv3WhX+qvGGSrMK/I5OmcBEPiwKcryTkwmA+PRWfTewfHVgFUMISXbh8v?=
 =?us-ascii?Q?H7oYCKp2CJE3s/qDuJj/aDAwKCoLHxQHoh45ttGhrJbXCHwcVTewYDGwFLgP?=
 =?us-ascii?Q?s98pURndPx104ziJQdBTOXA6FojbPkPTZ9CO5cdiCjRJNpJfsrT6li8sK2Ly?=
 =?us-ascii?Q?ZoBz/8GcOh6gqxNExOZA5howQEDL9FzIIHTMrU54ezvvhMfJhSxiYdYaKGhr?=
 =?us-ascii?Q?Iz9jOJlTYRbntPVJSif/AT9v251my0eDqrTDbALxFiD9rwkgPRiqBee+7WhB?=
 =?us-ascii?Q?ljBJOp+/EHcPAainSPTHD+9c0uvU2gUl8xnak/zXTBKG8cE2sMl5NvfGIamD?=
 =?us-ascii?Q?rmIUDhs9askLlIMVPRwNZgq5tE3V8Gr83ic5ARypY7GFw/Q3MMTTPrHR8HpH?=
 =?us-ascii?Q?2iwxMP98gum3gezInbswtbyyQtQdHJr+HG6y/FdB/zvA070j0Aw6RWA9ogUg?=
 =?us-ascii?Q?kYqLeXrozuLsrddTdB2EVs3WjhzyqrUSEETe1JcQizgCjcACY/NTU1/6BHly?=
 =?us-ascii?Q?rREc6ZbfoA7FGTYUVSSvFHHlK52SGxBW0SbY1C2pQqhITgqgogPjHSYw4wXq?=
 =?us-ascii?Q?CGtCmJ1zhTHvP7SZh8KTxuxR+lhtEFGjJ0/R84yQ07fOIko3DGx0REazd45m?=
 =?us-ascii?Q?Nb8xMprcBlXWAeU9+5M8reQJWcNgEkqObU32sb/5WECadI+N0Qt2VPTUtGt8?=
 =?us-ascii?Q?E6INPg4ye2IeUstuBp/2jS7eWVKEcdfmEMGJ6Yc+5iLRQ97KWvf+w5GLsdV8?=
 =?us-ascii?Q?1K3b3IJ8/IkBj+Lg9grjMDA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5459252d-c523-4ff5-9624-08d9f8406f47
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:08.1005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Tm4/eo/mc10BzdmXkHJYOdhFgeIOxTHk0HK5/t0psl9X5xd/LnEniHSM2RvTAbhSGfiAtJXT7KFJE2ZxHtJpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7658
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Changing the API to pass a reference to a bridge is not superfluous, and
looking at the passed bridge argument is not the same as having the
driver look at dsa_to_port(ds, port)->bridge from the ->port_fdb_add()
method.

DSA installs FDB and MDB entries on shared (CPU and DSA) ports as well,
and those do not have any dp->bridge information to retrieve, because
they are not in any bridge - they are merely the pipes that serve the
user ports that are in one or multiple bridges.

The struct dsa_bridge associated with each FDB/MDB entry is encapsulated
in a larger "struct dsa_db" database. Although only databases associated
to bridges are notified for now, this API will be the starting point for
implementing IFF_UNICAST_FLT in DSA. There, the idea is to install FDB
entries on the CPU port which belong to the corresponding user port's
port database. These are supposed to match only when the port is
standalone.

It is better to introduce the API in its expected final form than to
introduce it for bridges first, then to have to change drivers which may
have made one or more assumptions.

Drivers can use the provided bridge.num, but they can also use a
different numbering scheme that is more convenient.

DSA must perform refcounting on the CPU and DSA ports by also taking
into account the bridge number. So if two bridges request the same local
address, DSA must notify the driver twice, once for each bridge.

In fact, if the driver supports FDB isolation, DSA must perform
refcounting per bridge, but if the driver doesn't, DSA must refcount
host addresses across all bridges, otherwise it would be telling the
driver to delete an FDB entry for a bridge and the driver would delete
it for all bridges. So introduce a bool fdb_isolation in drivers which
would make all bridge databases passed to the cross-chip notifier have
the same number (0). This makes dsa_mac_addr_find() -> dsa_db_equal()
say that all bridge databases are the same database - which is
essentially the legacy behavior.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       | 12 ++--
 drivers/net/dsa/b53/b53_priv.h         | 12 ++--
 drivers/net/dsa/hirschmann/hellcreek.c |  6 +-
 drivers/net/dsa/lan9303-core.c         | 13 ++--
 drivers/net/dsa/lantiq_gswip.c         |  6 +-
 drivers/net/dsa/microchip/ksz9477.c    | 12 ++--
 drivers/net/dsa/microchip/ksz_common.c |  6 +-
 drivers/net/dsa/microchip/ksz_common.h |  6 +-
 drivers/net/dsa/mt7530.c               | 12 ++--
 drivers/net/dsa/mv88e6xxx/chip.c       | 12 ++--
 drivers/net/dsa/ocelot/felix.c         | 18 +++--
 drivers/net/dsa/qca8k.c                | 12 ++--
 drivers/net/dsa/sja1105/sja1105_main.c | 26 +++++--
 include/net/dsa.h                      | 42 +++++++++--
 net/dsa/dsa_priv.h                     |  3 +
 net/dsa/port.c                         | 75 ++++++++++++++++++-
 net/dsa/switch.c                       | 99 +++++++++++++++++---------
 17 files changed, 280 insertions(+), 92 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 83bf30349c26..a8cc6e182c45 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1708,7 +1708,8 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 }
 
 int b53_fdb_add(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid)
+		const unsigned char *addr, u16 vid,
+		struct dsa_db db)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
@@ -1728,7 +1729,8 @@ int b53_fdb_add(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL(b53_fdb_add);
 
 int b53_fdb_del(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid)
+		const unsigned char *addr, u16 vid,
+		struct dsa_db db)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
@@ -1829,7 +1831,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL(b53_fdb_dump);
 
 int b53_mdb_add(struct dsa_switch *ds, int port,
-		const struct switchdev_obj_port_mdb *mdb)
+		const struct switchdev_obj_port_mdb *mdb,
+		struct dsa_db db)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
@@ -1849,7 +1852,8 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL(b53_mdb_add);
 
 int b53_mdb_del(struct dsa_switch *ds, int port,
-		const struct switchdev_obj_port_mdb *mdb)
+		const struct switchdev_obj_port_mdb *mdb,
+		struct dsa_db db)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index a6b339fcb17e..d3091f0ad3e6 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -359,15 +359,19 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 int b53_vlan_del(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan);
 int b53_fdb_add(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid);
+		const unsigned char *addr, u16 vid,
+		struct dsa_db db);
 int b53_fdb_del(struct dsa_switch *ds, int port,
-		const unsigned char *addr, u16 vid);
+		const unsigned char *addr, u16 vid,
+		struct dsa_db db);
 int b53_fdb_dump(struct dsa_switch *ds, int port,
 		 dsa_fdb_dump_cb_t *cb, void *data);
 int b53_mdb_add(struct dsa_switch *ds, int port,
-		const struct switchdev_obj_port_mdb *mdb);
+		const struct switchdev_obj_port_mdb *mdb,
+		struct dsa_db db);
 int b53_mdb_del(struct dsa_switch *ds, int port,
-		const struct switchdev_obj_port_mdb *mdb);
+		const struct switchdev_obj_port_mdb *mdb,
+		struct dsa_db db);
 int b53_mirror_add(struct dsa_switch *ds, int port,
 		   struct dsa_mall_mirror_tc_entry *mirror, bool ingress);
 enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 726f267cb228..cb89be9de43a 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -827,7 +827,8 @@ static int hellcreek_fdb_get(struct hellcreek *hellcreek,
 }
 
 static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
-			     const unsigned char *addr, u16 vid)
+			     const unsigned char *addr, u16 vid,
+			     struct dsa_db db)
 {
 	struct hellcreek_fdb_entry entry = { 0 };
 	struct hellcreek *hellcreek = ds->priv;
@@ -872,7 +873,8 @@ static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_fdb_del(struct dsa_switch *ds, int port,
-			     const unsigned char *addr, u16 vid)
+			     const unsigned char *addr, u16 vid,
+			     struct dsa_db db)
 {
 	struct hellcreek_fdb_entry entry = { 0 };
 	struct hellcreek *hellcreek = ds->priv;
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 3969d89fa4db..a21184e7fcb6 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1188,7 +1188,8 @@ static void lan9303_port_fast_age(struct dsa_switch *ds, int port)
 }
 
 static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
+				const unsigned char *addr, u16 vid,
+				struct dsa_db db)
 {
 	struct lan9303 *chip = ds->priv;
 
@@ -1200,8 +1201,8 @@ static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int lan9303_port_fdb_del(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
-
+				const unsigned char *addr, u16 vid,
+				struct dsa_db db)
 {
 	struct lan9303 *chip = ds->priv;
 
@@ -1245,7 +1246,8 @@ static int lan9303_port_mdb_prepare(struct dsa_switch *ds, int port,
 }
 
 static int lan9303_port_mdb_add(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb)
+				const struct switchdev_obj_port_mdb *mdb,
+				struct dsa_db db)
 {
 	struct lan9303 *chip = ds->priv;
 	int err;
@@ -1260,7 +1262,8 @@ static int lan9303_port_mdb_add(struct dsa_switch *ds, int port,
 }
 
 static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb)
+				const struct switchdev_obj_port_mdb *mdb,
+				struct dsa_db db)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 8a7a8093a156..3dfb532b7784 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1389,13 +1389,15 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 }
 
 static int gswip_port_fdb_add(struct dsa_switch *ds, int port,
-			      const unsigned char *addr, u16 vid)
+			      const unsigned char *addr, u16 vid,
+			      struct dsa_db db)
 {
 	return gswip_port_fdb(ds, port, addr, vid, true);
 }
 
 static int gswip_port_fdb_del(struct dsa_switch *ds, int port,
-			      const unsigned char *addr, u16 vid)
+			      const unsigned char *addr, u16 vid,
+			      struct dsa_db db)
 {
 	return gswip_port_fdb(ds, port, addr, vid, false);
 }
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 18ffc8ded7ee..94ad6d9504f4 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -640,7 +640,8 @@ static int ksz9477_port_vlan_del(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
+				const unsigned char *addr, u16 vid,
+				struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 alu_table[4];
@@ -697,7 +698,8 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_fdb_del(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid)
+				const unsigned char *addr, u16 vid,
+				struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 alu_table[4];
@@ -839,7 +841,8 @@ static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb)
+				const struct switchdev_obj_port_mdb *mdb,
+				struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 static_table[4];
@@ -914,7 +917,8 @@ static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 }
 
 static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb)
+				const struct switchdev_obj_port_mdb *mdb,
+				struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 static_table[4];
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 94e618b8352b..104458ec9cbc 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -276,7 +276,8 @@ int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 EXPORT_SYMBOL_GPL(ksz_port_fdb_dump);
 
 int ksz_port_mdb_add(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb)
+		     const struct switchdev_obj_port_mdb *mdb,
+		     struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 	struct alu_struct alu;
@@ -321,7 +322,8 @@ int ksz_port_mdb_add(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL_GPL(ksz_port_mdb_add);
 
 int ksz_port_mdb_del(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb)
+		     const struct switchdev_obj_port_mdb *mdb,
+		     struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 	struct alu_struct alu;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c6fa487fb006..66933445a447 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -166,9 +166,11 @@ void ksz_port_fast_age(struct dsa_switch *ds, int port);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
 int ksz_port_mdb_add(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb);
+		     const struct switchdev_obj_port_mdb *mdb,
+		     struct dsa_db db);
 int ksz_port_mdb_del(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb);
+		     const struct switchdev_obj_port_mdb *mdb,
+		     struct dsa_db db);
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
 
 /* Common register access functions */
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index f74f25f479ed..abe63ec05066 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1349,7 +1349,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_fdb_add(struct dsa_switch *ds, int port,
-		    const unsigned char *addr, u16 vid)
+		    const unsigned char *addr, u16 vid,
+		    struct dsa_db db)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
@@ -1365,7 +1366,8 @@ mt7530_port_fdb_add(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_fdb_del(struct dsa_switch *ds, int port,
-		    const unsigned char *addr, u16 vid)
+		    const unsigned char *addr, u16 vid,
+		    struct dsa_db db)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
@@ -1416,7 +1418,8 @@ mt7530_port_fdb_dump(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_mdb_add(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_mdb *mdb)
+		    const struct switchdev_obj_port_mdb *mdb,
+		    struct dsa_db db)
 {
 	struct mt7530_priv *priv = ds->priv;
 	const u8 *addr = mdb->addr;
@@ -1442,7 +1445,8 @@ mt7530_port_mdb_add(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_mdb_del(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_mdb *mdb)
+		    const struct switchdev_obj_port_mdb *mdb,
+		    struct dsa_db db)
 {
 	struct mt7530_priv *priv = ds->priv;
 	const u8 *addr = mdb->addr;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1b9a20bf1bd6..d79c65bb227e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2456,7 +2456,8 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
-				  const unsigned char *addr, u16 vid)
+				  const unsigned char *addr, u16 vid,
+				  struct dsa_db db)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2470,7 +2471,8 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
-				  const unsigned char *addr, u16 vid)
+				  const unsigned char *addr, u16 vid,
+				  struct dsa_db db)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -6002,7 +6004,8 @@ static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
-				  const struct switchdev_obj_port_mdb *mdb)
+				  const struct switchdev_obj_port_mdb *mdb,
+				  struct dsa_db db)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -6016,7 +6019,8 @@ static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
-				  const struct switchdev_obj_port_mdb *mdb)
+				  const struct switchdev_obj_port_mdb *mdb,
+				  struct dsa_db db)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 04f5da33b944..d92feee97c63 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -592,7 +592,8 @@ static int felix_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int felix_fdb_add(struct dsa_switch *ds, int port,
-			 const unsigned char *addr, u16 vid)
+			 const unsigned char *addr, u16 vid,
+			 struct dsa_db db)
 {
 	struct ocelot *ocelot = ds->priv;
 
@@ -600,7 +601,8 @@ static int felix_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int felix_fdb_del(struct dsa_switch *ds, int port,
-			 const unsigned char *addr, u16 vid)
+			 const unsigned char *addr, u16 vid,
+			 struct dsa_db db)
 {
 	struct ocelot *ocelot = ds->priv;
 
@@ -608,7 +610,8 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 }
 
 static int felix_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag lag,
-			     const unsigned char *addr, u16 vid)
+			     const unsigned char *addr, u16 vid,
+			     struct dsa_db db)
 {
 	struct ocelot *ocelot = ds->priv;
 
@@ -616,7 +619,8 @@ static int felix_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag lag,
 }
 
 static int felix_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag lag,
-			     const unsigned char *addr, u16 vid)
+			     const unsigned char *addr, u16 vid,
+			     struct dsa_db db)
 {
 	struct ocelot *ocelot = ds->priv;
 
@@ -624,7 +628,8 @@ static int felix_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag lag,
 }
 
 static int felix_mdb_add(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_mdb *mdb)
+			 const struct switchdev_obj_port_mdb *mdb,
+			 struct dsa_db db)
 {
 	struct ocelot *ocelot = ds->priv;
 
@@ -632,7 +637,8 @@ static int felix_mdb_add(struct dsa_switch *ds, int port,
 }
 
 static int felix_mdb_del(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_mdb *mdb)
+			 const struct switchdev_obj_port_mdb *mdb,
+			 struct dsa_db db)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 6844106975a9..7189fd8120d7 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2397,7 +2397,8 @@ qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 
 static int
 qca8k_port_fdb_add(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid)
+		   const unsigned char *addr, u16 vid,
+		   struct dsa_db db)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
@@ -2407,7 +2408,8 @@ qca8k_port_fdb_add(struct dsa_switch *ds, int port,
 
 static int
 qca8k_port_fdb_del(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid)
+		   const unsigned char *addr, u16 vid,
+		   struct dsa_db db)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
@@ -2444,7 +2446,8 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 
 static int
 qca8k_port_mdb_add(struct dsa_switch *ds, int port,
-		   const struct switchdev_obj_port_mdb *mdb)
+		   const struct switchdev_obj_port_mdb *mdb,
+		   struct dsa_db db)
 {
 	struct qca8k_priv *priv = ds->priv;
 	const u8 *addr = mdb->addr;
@@ -2455,7 +2458,8 @@ qca8k_port_mdb_add(struct dsa_switch *ds, int port,
 
 static int
 qca8k_port_mdb_del(struct dsa_switch *ds, int port,
-		   const struct switchdev_obj_port_mdb *mdb)
+		   const struct switchdev_obj_port_mdb *mdb,
+		   struct dsa_db db)
 {
 	struct qca8k_priv *priv = ds->priv;
 	const u8 *addr = mdb->addr;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index dd89b077aae6..91b0e636d194 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1819,7 +1819,8 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_fdb_add(struct dsa_switch *ds, int port,
-			   const unsigned char *addr, u16 vid)
+			   const unsigned char *addr, u16 vid,
+			   struct dsa_db db)
 {
 	struct sja1105_private *priv = ds->priv;
 
@@ -1827,7 +1828,8 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_fdb_del(struct dsa_switch *ds, int port,
-			   const unsigned char *addr, u16 vid)
+			   const unsigned char *addr, u16 vid,
+			   struct dsa_db db)
 {
 	struct sja1105_private *priv = ds->priv;
 
@@ -1885,7 +1887,15 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 
 static void sja1105_fast_age(struct dsa_switch *ds, int port)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct sja1105_private *priv = ds->priv;
+	struct dsa_db db = {
+		.type = DSA_DB_BRIDGE,
+		.bridge = {
+			.dev = dsa_port_bridge_dev_get(dp),
+			.num = dsa_port_bridge_num_get(dp),
+		},
+	};
 	int i;
 
 	for (i = 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
@@ -1913,7 +1923,7 @@ static void sja1105_fast_age(struct dsa_switch *ds, int port)
 
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
-		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid);
+		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, db);
 		if (rc) {
 			dev_err(ds->dev,
 				"Failed to delete FDB entry %pM vid %lld: %pe\n",
@@ -1924,15 +1934,17 @@ static void sja1105_fast_age(struct dsa_switch *ds, int port)
 }
 
 static int sja1105_mdb_add(struct dsa_switch *ds, int port,
-			   const struct switchdev_obj_port_mdb *mdb)
+			   const struct switchdev_obj_port_mdb *mdb,
+			   struct dsa_db db)
 {
-	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid);
+	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, db);
 }
 
 static int sja1105_mdb_del(struct dsa_switch *ds, int port,
-			   const struct switchdev_obj_port_mdb *mdb)
+			   const struct switchdev_obj_port_mdb *mdb,
+			   struct dsa_db db)
 {
-	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid);
+	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid, db);
 }
 
 /* Common function for unicast and broadcast flood configuration.
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 01faba89c987..87c5f18eb381 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -341,11 +341,28 @@ struct dsa_link {
 	struct list_head list;
 };
 
+enum dsa_db_type {
+	DSA_DB_PORT,
+	DSA_DB_LAG,
+	DSA_DB_BRIDGE,
+};
+
+struct dsa_db {
+	enum dsa_db_type type;
+
+	union {
+		const struct dsa_port *dp;
+		struct dsa_lag lag;
+		struct dsa_bridge bridge;
+	};
+};
+
 struct dsa_mac_addr {
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	refcount_t refcount;
 	struct list_head list;
+	struct dsa_db db;
 };
 
 struct dsa_vlan {
@@ -409,6 +426,13 @@ struct dsa_switch {
 	 */
 	u32			mtu_enforcement_ingress:1;
 
+	/* Drivers that isolate the FDBs of multiple bridges must set this
+	 * to true to receive the bridge as an argument in .port_fdb_{add,del}
+	 * and .port_mdb_{add,del}. Otherwise, the bridge.num will always be
+	 * passed as zero.
+	 */
+	u32			fdb_isolation:1;
+
 	/* Listener for switch fabric events */
 	struct notifier_block	nb;
 
@@ -941,23 +965,29 @@ struct dsa_switch_ops {
 	 * Forwarding database
 	 */
 	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid);
+				const unsigned char *addr, u16 vid,
+				struct dsa_db db);
 	int	(*port_fdb_del)(struct dsa_switch *ds, int port,
-				const unsigned char *addr, u16 vid);
+				const unsigned char *addr, u16 vid,
+				struct dsa_db db);
 	int	(*port_fdb_dump)(struct dsa_switch *ds, int port,
 				 dsa_fdb_dump_cb_t *cb, void *data);
 	int	(*lag_fdb_add)(struct dsa_switch *ds, struct dsa_lag lag,
-			       const unsigned char *addr, u16 vid);
+			       const unsigned char *addr, u16 vid,
+			       struct dsa_db db);
 	int	(*lag_fdb_del)(struct dsa_switch *ds, struct dsa_lag lag,
-			       const unsigned char *addr, u16 vid);
+			       const unsigned char *addr, u16 vid,
+			       struct dsa_db db);
 
 	/*
 	 * Multicast database
 	 */
 	int	(*port_mdb_add)(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb);
+				const struct switchdev_obj_port_mdb *mdb,
+				struct dsa_db db);
 	int	(*port_mdb_del)(struct dsa_switch *ds, int port,
-				const struct switchdev_obj_port_mdb *mdb);
+				const struct switchdev_obj_port_mdb *mdb,
+				struct dsa_db db);
 	/*
 	 * RXNFC
 	 */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7a1c98581f53..27575fc3883e 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -67,6 +67,7 @@ struct dsa_notifier_fdb_info {
 	int port;
 	const unsigned char *addr;
 	u16 vid;
+	struct dsa_db db;
 };
 
 /* DSA_NOTIFIER_LAG_FDB_* */
@@ -74,6 +75,7 @@ struct dsa_notifier_lag_fdb_info {
 	struct dsa_lag *lag;
 	const unsigned char *addr;
 	u16 vid;
+	struct dsa_db db;
 };
 
 /* DSA_NOTIFIER_MDB_* */
@@ -81,6 +83,7 @@ struct dsa_notifier_mdb_info {
 	const struct switchdev_obj_port_mdb *mdb;
 	int sw_index;
 	int port;
+	struct dsa_db db;
 };
 
 /* DSA_NOTIFIER_LAG_* */
diff --git a/net/dsa/port.c b/net/dsa/port.c
index adab159c8c21..7af44a28f032 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -798,8 +798,19 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
+		.db = {
+			.type = DSA_DB_BRIDGE,
+			.bridge = *dp->bridge,
+		},
 	};
 
+	/* Refcounting takes bridge.num as a key, and should be global for all
+	 * bridges in the absence of FDB isolation, and per bridge otherwise.
+	 * Force the bridge.num to zero here in the absence of FDB isolation.
+	 */
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_ADD, &info);
 }
 
@@ -811,9 +822,15 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
-
+		.db = {
+			.type = DSA_DB_BRIDGE,
+			.bridge = *dp->bridge,
+		},
 	};
 
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
 }
 
@@ -825,6 +842,10 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
+		.db = {
+			.type = DSA_DB_BRIDGE,
+			.bridge = *dp->bridge,
+		},
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
@@ -839,6 +860,9 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 			return err;
 	}
 
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
 }
 
@@ -850,6 +874,10 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
+		.db = {
+			.type = DSA_DB_BRIDGE,
+			.bridge = *dp->bridge,
+		},
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
@@ -860,6 +888,9 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 			return err;
 	}
 
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
 }
 
@@ -870,8 +901,15 @@ int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		.lag = dp->lag,
 		.addr = addr,
 		.vid = vid,
+		.db = {
+			.type = DSA_DB_BRIDGE,
+			.bridge = *dp->bridge,
+		},
 	};
 
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
 	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_ADD, &info);
 }
 
@@ -882,8 +920,15 @@ int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		.lag = dp->lag,
 		.addr = addr,
 		.vid = vid,
+		.db = {
+			.type = DSA_DB_BRIDGE,
+			.bridge = *dp->bridge,
+		},
 	};
 
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
 	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_DEL, &info);
 }
 
@@ -905,8 +950,15 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.mdb = mdb,
+		.db = {
+			.type = DSA_DB_BRIDGE,
+			.bridge = *dp->bridge,
+		},
 	};
 
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
 	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_ADD, &info);
 }
 
@@ -917,8 +969,15 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.mdb = mdb,
+		.db = {
+			.type = DSA_DB_BRIDGE,
+			.bridge = *dp->bridge,
+		},
 	};
 
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
 	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_DEL, &info);
 }
 
@@ -929,6 +988,10 @@ int dsa_port_host_mdb_add(const struct dsa_port *dp,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.mdb = mdb,
+		.db = {
+			.type = DSA_DB_BRIDGE,
+			.bridge = *dp->bridge,
+		},
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
@@ -937,6 +1000,9 @@ int dsa_port_host_mdb_add(const struct dsa_port *dp,
 	if (err)
 		return err;
 
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
 }
 
@@ -947,6 +1013,10 @@ int dsa_port_host_mdb_del(const struct dsa_port *dp,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.mdb = mdb,
+		.db = {
+			.type = DSA_DB_BRIDGE,
+			.bridge = *dp->bridge,
+		},
 	};
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
@@ -955,6 +1025,9 @@ int dsa_port_host_mdb_del(const struct dsa_port *dp,
 	if (err)
 		return err;
 
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
 }
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index eb38beb10147..1d3c161e3131 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -210,21 +210,41 @@ static bool dsa_port_host_address_match(struct dsa_port *dp,
 	return false;
 }
 
+static bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b)
+{
+	if (a->type != b->type)
+		return false;
+
+	switch (a->type) {
+	case DSA_DB_PORT:
+		return a->dp == b->dp;
+	case DSA_DB_LAG:
+		return a->lag.dev == b->lag.dev;
+	case DSA_DB_BRIDGE:
+		return a->bridge.num == b->bridge.num;
+	default:
+		WARN_ON(1);
+		return false;
+	}
+}
+
 static struct dsa_mac_addr *dsa_mac_addr_find(struct list_head *addr_list,
-					      const unsigned char *addr,
-					      u16 vid)
+					      const unsigned char *addr, u16 vid,
+					      struct dsa_db db)
 {
 	struct dsa_mac_addr *a;
 
 	list_for_each_entry(a, addr_list, list)
-		if (ether_addr_equal(a->addr, addr) && a->vid == vid)
+		if (ether_addr_equal(a->addr, addr) && a->vid == vid &&
+		    dsa_db_equal(&a->db, &db))
 			return a;
 
 	return NULL;
 }
 
 static int dsa_port_do_mdb_add(struct dsa_port *dp,
-			       const struct switchdev_obj_port_mdb *mdb)
+			       const struct switchdev_obj_port_mdb *mdb,
+			       struct dsa_db db)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -233,11 +253,11 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_mdb_add(ds, port, mdb);
+		return ds->ops->port_mdb_add(ds, port, mdb, db);
 
 	mutex_lock(&dp->addr_lists_lock);
 
-	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
+	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid, db);
 	if (a) {
 		refcount_inc(&a->refcount);
 		goto out;
@@ -249,7 +269,7 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
 		goto out;
 	}
 
-	err = ds->ops->port_mdb_add(ds, port, mdb);
+	err = ds->ops->port_mdb_add(ds, port, mdb, db);
 	if (err) {
 		kfree(a);
 		goto out;
@@ -257,6 +277,7 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
 
 	ether_addr_copy(a->addr, mdb->addr);
 	a->vid = mdb->vid;
+	a->db = db;
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &dp->mdbs);
 
@@ -267,7 +288,8 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
 }
 
 static int dsa_port_do_mdb_del(struct dsa_port *dp,
-			       const struct switchdev_obj_port_mdb *mdb)
+			       const struct switchdev_obj_port_mdb *mdb,
+			       struct dsa_db db)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -276,11 +298,11 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_mdb_del(ds, port, mdb);
+		return ds->ops->port_mdb_del(ds, port, mdb, db);
 
 	mutex_lock(&dp->addr_lists_lock);
 
-	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid);
+	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid, db);
 	if (!a) {
 		err = -ENOENT;
 		goto out;
@@ -289,7 +311,7 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 	if (!refcount_dec_and_test(&a->refcount))
 		goto out;
 
-	err = ds->ops->port_mdb_del(ds, port, mdb);
+	err = ds->ops->port_mdb_del(ds, port, mdb, db);
 	if (err) {
 		refcount_set(&a->refcount, 1);
 		goto out;
@@ -305,7 +327,7 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 }
 
 static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-			       u16 vid)
+			       u16 vid, struct dsa_db db)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -314,11 +336,11 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_add(ds, port, addr, vid);
+		return ds->ops->port_fdb_add(ds, port, addr, vid, db);
 
 	mutex_lock(&dp->addr_lists_lock);
 
-	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
+	a = dsa_mac_addr_find(&dp->fdbs, addr, vid, db);
 	if (a) {
 		refcount_inc(&a->refcount);
 		goto out;
@@ -330,7 +352,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		goto out;
 	}
 
-	err = ds->ops->port_fdb_add(ds, port, addr, vid);
+	err = ds->ops->port_fdb_add(ds, port, addr, vid, db);
 	if (err) {
 		kfree(a);
 		goto out;
@@ -338,6 +360,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 
 	ether_addr_copy(a->addr, addr);
 	a->vid = vid;
+	a->db = db;
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &dp->fdbs);
 
@@ -348,7 +371,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 }
 
 static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			       u16 vid)
+			       u16 vid, struct dsa_db db)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
@@ -357,11 +380,11 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_del(ds, port, addr, vid);
+		return ds->ops->port_fdb_del(ds, port, addr, vid, db);
 
 	mutex_lock(&dp->addr_lists_lock);
 
-	a = dsa_mac_addr_find(&dp->fdbs, addr, vid);
+	a = dsa_mac_addr_find(&dp->fdbs, addr, vid, db);
 	if (!a) {
 		err = -ENOENT;
 		goto out;
@@ -370,7 +393,7 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	if (!refcount_dec_and_test(&a->refcount))
 		goto out;
 
-	err = ds->ops->port_fdb_del(ds, port, addr, vid);
+	err = ds->ops->port_fdb_del(ds, port, addr, vid, db);
 	if (err) {
 		refcount_set(&a->refcount, 1);
 		goto out;
@@ -386,14 +409,15 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 }
 
 static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
-				     const unsigned char *addr, u16 vid)
+				     const unsigned char *addr, u16 vid,
+				     struct dsa_db db)
 {
 	struct dsa_mac_addr *a;
 	int err = 0;
 
 	mutex_lock(&lag->fdb_lock);
 
-	a = dsa_mac_addr_find(&lag->fdbs, addr, vid);
+	a = dsa_mac_addr_find(&lag->fdbs, addr, vid, db);
 	if (a) {
 		refcount_inc(&a->refcount);
 		goto out;
@@ -405,7 +429,7 @@ static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
 		goto out;
 	}
 
-	err = ds->ops->lag_fdb_add(ds, *lag, addr, vid);
+	err = ds->ops->lag_fdb_add(ds, *lag, addr, vid, db);
 	if (err) {
 		kfree(a);
 		goto out;
@@ -423,14 +447,15 @@ static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
 }
 
 static int dsa_switch_do_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag *lag,
-				     const unsigned char *addr, u16 vid)
+				     const unsigned char *addr, u16 vid,
+				     struct dsa_db db)
 {
 	struct dsa_mac_addr *a;
 	int err = 0;
 
 	mutex_lock(&lag->fdb_lock);
 
-	a = dsa_mac_addr_find(&lag->fdbs, addr, vid);
+	a = dsa_mac_addr_find(&lag->fdbs, addr, vid, db);
 	if (!a) {
 		err = -ENOENT;
 		goto out;
@@ -439,7 +464,7 @@ static int dsa_switch_do_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag *lag,
 	if (!refcount_dec_and_test(&a->refcount))
 		goto out;
 
-	err = ds->ops->lag_fdb_del(ds, *lag, addr, vid);
+	err = ds->ops->lag_fdb_del(ds, *lag, addr, vid, db);
 	if (err) {
 		refcount_set(&a->refcount, 1);
 		goto out;
@@ -466,7 +491,8 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->sw_index,
 						info->port)) {
-			err = dsa_port_do_fdb_add(dp, info->addr, info->vid);
+			err = dsa_port_do_fdb_add(dp, info->addr, info->vid,
+						  info->db);
 			if (err)
 				break;
 		}
@@ -487,7 +513,8 @@ static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->sw_index,
 						info->port)) {
-			err = dsa_port_do_fdb_del(dp, info->addr, info->vid);
+			err = dsa_port_do_fdb_del(dp, info->addr, info->vid,
+						  info->db);
 			if (err)
 				break;
 		}
@@ -505,7 +532,7 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_fdb_add(dp, info->addr, info->vid);
+	return dsa_port_do_fdb_add(dp, info->addr, info->vid, info->db);
 }
 
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
@@ -517,7 +544,7 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_fdb_del(dp, info->addr, info->vid);
+	return dsa_port_do_fdb_del(dp, info->addr, info->vid, info->db);
 }
 
 static int dsa_switch_lag_fdb_add(struct dsa_switch *ds,
@@ -532,7 +559,8 @@ static int dsa_switch_lag_fdb_add(struct dsa_switch *ds,
 	dsa_switch_for_each_port(dp, ds)
 		if (dsa_port_offloads_lag(dp, info->lag))
 			return dsa_switch_do_lag_fdb_add(ds, info->lag,
-							 info->addr, info->vid);
+							 info->addr, info->vid,
+							 info->db);
 
 	return 0;
 }
@@ -549,7 +577,8 @@ static int dsa_switch_lag_fdb_del(struct dsa_switch *ds,
 	dsa_switch_for_each_port(dp, ds)
 		if (dsa_port_offloads_lag(dp, info->lag))
 			return dsa_switch_do_lag_fdb_del(ds, info->lag,
-							 info->addr, info->vid);
+							 info->addr, info->vid,
+							 info->db);
 
 	return 0;
 }
@@ -604,7 +633,7 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 	if (!ds->ops->port_mdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_mdb_add(dp, info->mdb);
+	return dsa_port_do_mdb_add(dp, info->mdb, info->db);
 }
 
 static int dsa_switch_mdb_del(struct dsa_switch *ds,
@@ -616,7 +645,7 @@ static int dsa_switch_mdb_del(struct dsa_switch *ds,
 	if (!ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_port_do_mdb_del(dp, info->mdb);
+	return dsa_port_do_mdb_del(dp, info->mdb, info->db);
 }
 
 static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
@@ -631,7 +660,7 @@ static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->sw_index,
 						info->port)) {
-			err = dsa_port_do_mdb_add(dp, info->mdb);
+			err = dsa_port_do_mdb_add(dp, info->mdb, info->db);
 			if (err)
 				break;
 		}
@@ -652,7 +681,7 @@ static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->sw_index,
 						info->port)) {
-			err = dsa_port_do_mdb_del(dp, info->mdb);
+			err = dsa_port_do_mdb_del(dp, info->mdb, info->db);
 			if (err)
 				break;
 		}
-- 
2.25.1

