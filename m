Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A023B5B4B20
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiIKBJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiIKBI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:08:56 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75874F3BB;
        Sat, 10 Sep 2022 18:08:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfbNTiX8PzB9KKryKZqmTdVt7tT37Eu0EN8D9nNjmqkg4y/b1NGWmPTVrB86aUjiU6/3uVeq7FedxhbwZmzFzvHDp9F/jezzNiH/z2wXrY7K1PmsyBpbcFLPXDxaYa1nZXFhVaVYzVXi56oZ2T2bIVZsfAIWk5bUav/P7jwR8tS8a2nQmZdn84qrOvdQBhR1FAVCnj658xrDgNAdgcx8Bj473OVX3T+/3nnLRzrMRY1ZPw94OTYlkC9QsBuV1OIgNCHMQP3UlRg61JWzqd4frSygcQ6YT4+27Evakc4+as3EpV/k5bUBfvaDWrwtlV5SG/F+mDM65KB1h0+rMPwURA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C37CZpFSk8ZZGkxmG4z2ikV/SN/A4GMTaNE4dxZ4rFE=;
 b=ZO8yskHZXRL3PwP/QtMDc5DnY3nCC/LsiFR6Pk5ntrqlMzX29CQCaLK2zKSTdk2Lwza1fKY6VYavqyknmstEc0+3lDv26eglKLs3ZEuGZR7e4hafobumNNdKN7lmDOZFDJAOfX5kVluaoIey6JSsDkiN4I0oU0nkR0nqxd7eBFiWTqDnjNxEEJ60HRhmdv7XmT5nQJzSvztW2YDCr0Mk9k/2YUTMHxLRpbK1EpKTbO2txY06w7PTC26sK755485iZz479/9Ly7e2nvZmuWRHuOUYC/uZgVeHl/CLObuheK5bS4p/VgAg+2gOrUhNzQRzkJunXqGhR/KX8XJ4+tgLrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C37CZpFSk8ZZGkxmG4z2ikV/SN/A4GMTaNE4dxZ4rFE=;
 b=e+gbMHE6XOGjV5ropXRecwsBPblbJv4USePtyjMWnarCup9T0uG495WeOMKjo0efCa5EGECaduppNBg5dqjZq2qwTAjUB1U+NXqEruwd/Lkp3KqwbMFaX5kdUkCxHzp5C6mkt3rRONzvjf0wEifd6fcqJD2yuZil5N0xg+LmNXk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7739.eurprd04.prod.outlook.com (2603:10a6:10:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:08:00 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:08:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net-next 07/10] net: dsa: propagate extack to port_lag_join
Date:   Sun, 11 Sep 2022 04:07:03 +0300
Message-Id: <20220911010706.2137967-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DBBPR04MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: dab29846-d59c-4c1f-a939-08da939211e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0QupusroIAQ1KvJv5V9vueDNhwqYnLZQ3rryEWjeO+2LeQaD3Uej4Xsdpq26XZcg/NEKiAu1Sjsdaw3vjPv40l5C00h38VOpz5fAh8gC16BSxPsy+GrkBffJGz5m1lax/1VBwc4XXj22Vr8hlMe20kruHr04VIiAKPsF8HvddC3MkiJ2u1Kn8kTji26uuaioFI5ZnLIzzg68A0gur0Kp0cPARoejxCFAeuxC3wpDzzCkO7hBjP++y3mzWaYEFXF47IiOBmkAJI3VL1h7EcE3SKxErMwBuoI0ImmW+UtLiCVbIGbDwRpRiliaUzI0+0027vKNUWxsbVTs074y1dWTxPILr6EGiUgjUKgzRs2aJdDoDjk0tdjFwMnLe2KVmiq9b+qe4jE39Qza0RL+wtpCP8nACHwvbBd0Z4sP+4dmFpMsKuwM5gluJE1yC+mDiGM2vUTYWp9pcPT5lK7eGFeHtIr6YyzkLUVuhOjB0jAndiZCZLku46ujKcoCsVvRU4QiYfbttbBzJu4xn9NMgkCjzgtHi3/Cq40IbNmBlSSp3gD91QEPMl397+WEPSGK93RtyRFCptH7L4dh9o6abN/a0IdrEFBPAKObjIF5pqwr9W4L5Fp8hULOiwTUt7TPNvHNBwn85uHGa4v0WHPfeW9FVuenOsTU4AYtc1hq0Awj9ava18VZ8ANbp7oT+5uL8VwC6AFcfqPx9nINiUaJ/EBKVhPu8wYOq5QUDS1IES3RGhRJx05WMkL1RRms1CX7sUm9s1N4HJ7b9RE2E6Qtbq0lA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(38350700002)(30864003)(2906002)(44832011)(83380400001)(2616005)(186003)(1076003)(316002)(66476007)(66556008)(4326008)(8936002)(66946007)(8676002)(54906003)(6916009)(36756003)(7416002)(5660300002)(478600001)(41300700001)(52116002)(6486002)(26005)(6512007)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qYdyZy3I0JWeRmMeYvJVx4zRMqkhViFMpQQaDT/KA/qN1OUEUBNAup1XGpDd?=
 =?us-ascii?Q?pZCkYVnYocS7cdtFV91CnsywGOnbOvGehbLx6ZcdJycgr6o0BihBzG7O6BJI?=
 =?us-ascii?Q?rk+IGOMqQbn0UdmrGmNatUk5/dVLv5Y2rxoeT0oIDaVfhbU+gM5XmDEwZm05?=
 =?us-ascii?Q?phe7DV1hXbI58qFQMqTN/4GDpfFmAwgvFnwAw6WN29QKU0WY+84mLNYtEr4h?=
 =?us-ascii?Q?Dc52d7rRDg1lLrsP1Jkrie/3enzk1qx01KdiijUWGANdFm0qOJ/86XggEMEP?=
 =?us-ascii?Q?rvSh1XhRoUNZOm3/FeAlUsH6it+Albq2pGdSaLJ9I+li9y1BoRBhE/Q9u0Sf?=
 =?us-ascii?Q?9n4thHE4/j2tkgaf/pczPU4JdnNWjqdgZaS/B+5awLWTOJxHUO8hjyZ6PWGn?=
 =?us-ascii?Q?E/MXgmNb6UzcnPYmAvlzddhcrT3lWV0ZnwIwNAzxzHxyOv5H2hs000vLTn3d?=
 =?us-ascii?Q?o48wMvZpGME/83dcNryB5r5Are1PBzLcSfJxZ3EXu1CEA3gSeRSuN7UwjBNw?=
 =?us-ascii?Q?YXTqMh64jLfaVEgnr3lQBZ0VWMyA4Dl2ldYOcZd9YRaD+SM1//EOYHCP+VSK?=
 =?us-ascii?Q?wSwQ7vKwuzS9ee0eyo6J+uIj00b/PJ45q3Zwrn2nLgUE4Tk4QdDkKvT8e8xZ?=
 =?us-ascii?Q?1gC9Ymg+aqweZEprANLLZNK7UkLaBcOPPSoMeG7lugph5dSq+ZP2RRsXunQY?=
 =?us-ascii?Q?CyGzaFauH1dUM6ubzxsw7XuxdePFeJ7YYobeiFiRFk7w2mv8cycO3jTX82s/?=
 =?us-ascii?Q?5Bh5Lw0kpNz3LhtV65JFftk9k1DjiCsSTwNJXUqCSMoPQcqM/rzheaXDgPie?=
 =?us-ascii?Q?ay22NdgPcIumkFDKirrZ2pp0k2U2Q1At7UGcf0EF4J+Xb35ZrahSoxr+HR/t?=
 =?us-ascii?Q?SmhokkGlno9SxJRwMjgPLqIIbfjVbLsd8wXwyEP4Ccp0oPzyZ5pn/eu/sLWv?=
 =?us-ascii?Q?n+JfBWGw8zwOPRHNEYxqaO0o+6fKEq4QZtDu/u4F3pD/IDA32pvh+tamoDQz?=
 =?us-ascii?Q?JIIg5vxFZutVLnku6QCIB27vmpS4dgVMHZsI62OV9yxf6ic7ty2rxFnxsXPu?=
 =?us-ascii?Q?ysI4WUEiw67ZP34jkXqLYI+vf9DgfYx3oCMqxLDN/3BwCYxg36gx0TSWPbqt?=
 =?us-ascii?Q?Hd3466TojhsdqBa2vhASqlF5/gg8PuExDY+kcs7i5Qb11UC6bN6d3b0NVq40?=
 =?us-ascii?Q?G7MMX2XHmEWKWs7r1db09Cea/aeqw6J+oMW5kwpbz7BtdwCjP7C2ve6Hj5wc?=
 =?us-ascii?Q?UHSPwAaekQR0luaPr7dat2vjJHpw9EzY15nA1xK0eevWyB8Vm8czHtEVX+Bm?=
 =?us-ascii?Q?k+oVyadj2WDJwmNb4hsYAw5wXThhC/ukdvFeEsEt/J+KdI4y0D/3PQUWDzhy?=
 =?us-ascii?Q?loFmXNp25Z0u4gfbV573AoQ0vZ9piyEB3CukvP758tZKl+0qv/LxHo249C/Z?=
 =?us-ascii?Q?4w9VGxSqTmi69evgvBHbPJcBMF0OYq8+/TDLDePEyjpYweeGNmgkhJWMuVl4?=
 =?us-ascii?Q?EOQHUoX6sWt+DuR9hmvbpu1eRiiXynWqsmeqAtcgvhxGYK6TLpRIQxaheJIz?=
 =?us-ascii?Q?N70WhH6DdeHRaoUwgwm6kKzmerfrKRA0t278ZdOjlXyufEOCkQP7uip0Z22m?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab29846-d59c-4c1f-a939-08da939211e6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:08:00.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBt20KVS9bfbQ0VMuDykADYEgoPfY6yBImYDEM8sY7TNOem7ewXhVma9bH3/h4AIxP73ui9bnesPTMxtmX5ZQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers could refuse to offload a LAG configuration for a variety of
reasons, mainly having to do with its TX type. Additionally, since DSA
masters may now also be LAG interfaces, and this will translate into a
call to port_lag_join on the CPU ports, there may be extra restrictions
there. Propagate the netlink extack to this DSA method in order for
drivers to give a meaningful error message back to the user.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/dsa/mv88e6xxx/chip.c       | 27 ++++++++++++++++++--------
 drivers/net/dsa/ocelot/felix.c         |  5 +++--
 drivers/net/dsa/qca/qca8k-common.c     | 23 ++++++++++++++++------
 drivers/net/dsa/qca/qca8k.h            |  3 ++-
 drivers/net/ethernet/mscc/ocelot.c     |  8 ++++++--
 drivers/net/ethernet/mscc/ocelot_net.c |  7 +++----
 include/net/dsa.h                      |  6 ++++--
 include/soc/mscc/ocelot.h              |  3 ++-
 net/dsa/dsa_priv.h                     |  1 +
 net/dsa/port.c                         |  1 +
 net/dsa/switch.c                       |  4 ++--
 11 files changed, 60 insertions(+), 28 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6f4ea39ab466..5f178faa110f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6593,14 +6593,17 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 				      struct dsa_lag lag,
-				      struct netdev_lag_upper_info *info)
+				      struct netdev_lag_upper_info *info,
+				      struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
 	int members = 0;
 
-	if (!mv88e6xxx_has_lag(chip))
+	if (!mv88e6xxx_has_lag(chip)) {
+		NL_SET_ERR_MSG_MOD(extack, "Chip does not support LAG offload");
 		return false;
+	}
 
 	if (!lag.id)
 		return false;
@@ -6609,14 +6612,20 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 		/* Includes the port joining the LAG */
 		members++;
 
-	if (members > 8)
+	if (members > 8) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot offload more than 8 LAG ports");
 		return false;
+	}
 
 	/* We could potentially relax this to include active
 	 * backup in the future.
 	 */
-	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only offload LAG using hash TX type");
 		return false;
+	}
 
 	/* Ideally we would also validate that the hash type matches
 	 * the hardware. Alas, this is always set to unknown on team
@@ -6769,12 +6778,13 @@ static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
 
 static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 				   struct dsa_lag lag,
-				   struct netdev_lag_upper_info *info)
+				   struct netdev_lag_upper_info *info,
+				   struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err, id;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag, info, extack))
 		return -EOPNOTSUPP;
 
 	/* DSA LAG IDs are one-based */
@@ -6827,12 +6837,13 @@ static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
 
 static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
 					int port, struct dsa_lag lag,
-					struct netdev_lag_upper_info *info)
+					struct netdev_lag_upper_info *info,
+					struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag, info, extack))
 		return -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index c73ef5f7aa64..82dcc21a7172 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -861,11 +861,12 @@ static void felix_bridge_leave(struct dsa_switch *ds, int port,
 
 static int felix_lag_join(struct dsa_switch *ds, int port,
 			  struct dsa_lag lag,
-			  struct netdev_lag_upper_info *info)
+			  struct netdev_lag_upper_info *info,
+			  struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_lag_join(ocelot, port, lag.dev, info);
+	return ocelot_port_lag_join(ocelot, port, lag.dev, info, extack);
 }
 
 static int felix_lag_leave(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index bba95613e218..fb45b598847b 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -1017,7 +1017,8 @@ int qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 
 static bool qca8k_lag_can_offload(struct dsa_switch *ds,
 				  struct dsa_lag lag,
-				  struct netdev_lag_upper_info *info)
+				  struct netdev_lag_upper_info *info,
+				  struct netlink_ext_ack *extack)
 {
 	struct dsa_port *dp;
 	int members = 0;
@@ -1029,15 +1030,24 @@ static bool qca8k_lag_can_offload(struct dsa_switch *ds,
 		/* Includes the port joining the LAG */
 		members++;
 
-	if (members > QCA8K_NUM_PORTS_FOR_LAG)
+	if (members > QCA8K_NUM_PORTS_FOR_LAG) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot offload more than 4 LAG ports");
 		return false;
+	}
 
-	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only offload LAG using hash TX type");
 		return false;
+	}
 
 	if (info->hash_type != NETDEV_LAG_HASH_L2 &&
-	    info->hash_type != NETDEV_LAG_HASH_L23)
+	    info->hash_type != NETDEV_LAG_HASH_L23) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only offload L2 or L2+L3 TX hash");
 		return false;
+	}
 
 	return true;
 }
@@ -1160,11 +1170,12 @@ static int qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 }
 
 int qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
-			struct netdev_lag_upper_info *info)
+			struct netdev_lag_upper_info *info,
+			struct netlink_ext_ack *extack)
 {
 	int ret;
 
-	if (!qca8k_lag_can_offload(ds, lag, info))
+	if (!qca8k_lag_can_offload(ds, lag, info, extack))
 		return -EOPNOTSUPP;
 
 	ret = qca8k_lag_setup_hash(ds, lag, info);
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index e36ecc9777f4..0b7a5cb12321 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -512,7 +512,8 @@ int qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 
 /* Common port LAG function */
 int qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
-			struct netdev_lag_upper_info *info);
+			struct netdev_lag_upper_info *info,
+			struct netlink_ext_ack *extack);
 int qca8k_port_lag_leave(struct dsa_switch *ds, int port,
 			 struct dsa_lag lag);
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 874fb2a5874e..5c18f8986975 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2132,10 +2132,14 @@ static void ocelot_migrate_lag_fdbs(struct ocelot *ocelot,
 
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
-			 struct netdev_lag_upper_info *info)
+			 struct netdev_lag_upper_info *info,
+			 struct netlink_ext_ack *extack)
 {
-	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can only offload LAG using hash TX type");
 		return -EOPNOTSUPP;
+	}
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 2979fb1ba0f7..50858cc10fef 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1412,11 +1412,10 @@ static int ocelot_netdevice_lag_join(struct net_device *dev,
 	int port = priv->port.index;
 	int err;
 
-	err = ocelot_port_lag_join(ocelot, port, bond, info);
-	if (err == -EOPNOTSUPP) {
-		NL_SET_ERR_MSG_MOD(extack, "Offloading not supported");
+	err = ocelot_port_lag_join(ocelot, port, bond, info, extack);
+	if (err == -EOPNOTSUPP)
+		/* Offloading not supported, fall back to software LAG */
 		return 0;
-	}
 
 	bridge_dev = netdev_master_upper_dev_get(bond);
 	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 3f717c3fcba0..1c80e75b3cad 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1094,7 +1094,8 @@ struct dsa_switch_ops {
 					int port);
 	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
 				      int port, struct dsa_lag lag,
-				      struct netdev_lag_upper_info *info);
+				      struct netdev_lag_upper_info *info,
+				      struct netlink_ext_ack *extack);
 	int	(*crosschip_lag_leave)(struct dsa_switch *ds, int sw_index,
 				       int port, struct dsa_lag lag);
 
@@ -1169,7 +1170,8 @@ struct dsa_switch_ops {
 	int	(*port_lag_change)(struct dsa_switch *ds, int port);
 	int	(*port_lag_join)(struct dsa_switch *ds, int port,
 				 struct dsa_lag lag,
-				 struct netdev_lag_upper_info *info);
+				 struct netdev_lag_upper_info *info,
+				 struct netlink_ext_ack *extack);
 	int	(*port_lag_leave)(struct dsa_switch *ds, int port,
 				  struct dsa_lag lag);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 355cfdedc43b..ea19e8ef1f61 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1229,7 +1229,8 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct net_device *bridge);
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond,
-			 struct netdev_lag_upper_info *info);
+			 struct netdev_lag_upper_info *info,
+			 struct netlink_ext_ack *extack);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
 void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d252a04ed725..f0ae54d0435e 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -88,6 +88,7 @@ struct dsa_notifier_lag_info {
 	const struct dsa_port *dp;
 	struct dsa_lag lag;
 	struct netdev_lag_upper_info *info;
+	struct netlink_ext_ack *extack;
 };
 
 /* DSA_NOTIFIER_VLAN_* */
diff --git a/net/dsa/port.c b/net/dsa/port.c
index e557b42de9f2..98f7fa0cdd5c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -635,6 +635,7 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 	struct dsa_notifier_lag_info info = {
 		.dp = dp,
 		.info = uinfo,
+		.extack = extack,
 	};
 	struct net_device *bridge_dev;
 	int err;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4dfd68cf61c5..c2cb15e21324 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -507,12 +507,12 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
 {
 	if (info->dp->ds == ds && ds->ops->port_lag_join)
 		return ds->ops->port_lag_join(ds, info->dp->index, info->lag,
-					      info->info);
+					      info->info, info->extack);
 
 	if (info->dp->ds != ds && ds->ops->crosschip_lag_join)
 		return ds->ops->crosschip_lag_join(ds, info->dp->ds->index,
 						   info->dp->index, info->lag,
-						   info->info);
+						   info->info, info->extack);
 
 	return -EOPNOTSUPP;
 }
-- 
2.34.1

