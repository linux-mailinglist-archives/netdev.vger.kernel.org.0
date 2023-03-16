Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18DED6BD4D0
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjCPQNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCPQNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:13:15 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2043.outbound.protection.outlook.com [40.107.105.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D08E56523;
        Thu, 16 Mar 2023 09:13:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTZY7exmS77Q9SM9W6BLn/MFF7JfoBdqLyhcZnkZpnBEC7JK1nVyYKTZr9ZumQOhK+6HOBAA660MbJoMMJYCDDswDlK8eUpWTamOXNGU71uDQ9JgIEjXHojIcX5KgiAAtrAJ+ZTUykTpEp2jPo/Hbj2XeEsAouA9v+0VRXux2+SJ6vTeYWf2o8BMat1Joa+or3uWFyWflDeKetWgPu6oKBKlbKIaswIPhFVLXY8V1N+1vPzVYvllMhnBHv+1xVzJN6Ej9iuPmO2IGdS0GYBp4hk7+qljTLJylYZWbvnNJPX9sgLlWgoUPzhOfQ/Wn4ZMIXhbyTiS+WNWcTBAymc43g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yjwtZqysEy/1B7sD3wNWF9rs6nGiv95KJ3UVntXGlWQ=;
 b=L37kj8ZUf+UUQVhMYvGyePdFiUJJ3fWXnDUfOE/uoxVsaZAAEzzRU6OobJ+8lCFPXrSxz+FIMJ5nqLqLdKGy8/97eugQE/Ofad6d1xUY44OzYkQQCpqebN34u2ML/4RAWbytp8PRINl/57Eiv1Xl3uFoeeeRA9EU52Uvgfe6yHmQjIgvzhuwJhd0fo1v2UsZ+MDn7lxf0SKvxGEDnyoBe+ssZ/fsHAKGJhHLS83AF8uyT8iA8DCCljYu5OPijGjktSyDGkJ3OEyopv0ZbhsQv8XE5A9JliQLz413dY5+fv1PodSfxVwflWLTOqrU6ERiReAMSlwpHUjcmSO3dtMuvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjwtZqysEy/1B7sD3wNWF9rs6nGiv95KJ3UVntXGlWQ=;
 b=A5HXPb0MHvqhN/KHLpv+nGNK2fofXPuG02FBo5DVoNZTi7+WjSx8cUwKb20yjgP/etwg9hpEQtVTNZ8DkvtYQlJYCgpxsq+pNUmmgXsvRQL5pc3eXQ0AmonZkAeEKGpyqsK+HwxGEy6QesnVcipjrCWrGm9rBHcBIFutByTS5tI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7861.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 16:13:09 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 16:13:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org
Subject: [RFC/RFT PATCH net-next 1/4] net: dsa: microchip: add an enum for regmap widths
Date:   Thu, 16 Mar 2023 18:12:47 +0200
Message-Id: <20230316161250.3286055-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:207:1::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7861:EE_
X-MS-Office365-Filtering-Correlation-Id: ed14e0d1-1c6d-4fac-dc85-08db2639557b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RKsIa59EIVRH6A+tb9qvlSTJGz1c3eBZvryI/AYO95fgl/K+ALTKZn1TL6d1hbTCX6TixbxBn0btyL7VGXcT5efACjHZ4diXEbwxBVPNvwsj3FxkteIOqYC/j5fqH6H6dC/Q7t3YsBCbrXqgx3wDg1TD+tOm7ACXt6491KRSnm9OwZZcBk5ktDNPtw0uWOUn1VQ5nOj6toRGQQ4egeDlJFGUuRorzGPePw/GQBcAz1q7yriHr364DUXqMPvfokokNHhIp3pr+6fRHXcEZUm1n/a14ifLIWIOFjJtJ4KRYKrVAJnTuQP/ucYcKHXrTFB6uh59W3m2Kwnq18hu74UOC5S0dQMdAOBVSTGxazq/g3md6h+Ns1ekpimEZXJsZPa1fDBpGNFJZlckEUM34PZM0/wuJBZ5d6V7c2c9+IkPZGR763yxkZgKeMs18r5DpLcP7zTdZgYtsm6ieCB9Ztq/dUIJggoUX2Sct0fh9N+JMSLFf+XtikT3YeYGhcyIJiO7j1AOryBks7BrlmK7dbl0VFg1G+JX5p8r0Aoe9pDcP3fmAG4VA4a6A002l2N4BHa0akllttUHpIxD8x2PfSORY3jbKf9+B3p5AXgKx7k+4EDK3QDY8c5MKh+g5RAeOdJta/mS0qWJFnp/iOQd407DGrkQMmq/53913Ag20wysUn6hvL1nediKHiICpHkcwHnhDJ5Q7MFHCca9DIKbXmt+sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199018)(36756003)(86362001)(38350700002)(38100700002)(2906002)(5660300002)(41300700001)(8936002)(30864003)(44832011)(7416002)(4326008)(6512007)(66476007)(1076003)(6506007)(26005)(186003)(2616005)(6666004)(83380400001)(316002)(54906003)(6916009)(8676002)(66946007)(6486002)(52116002)(478600001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ODG5TrUw8R4xQpaPBMT/DMry3JUhWXsBc7wjKJzXzTldLqGMpwJt1EYMUz/T?=
 =?us-ascii?Q?lhyrR5SBKsmYl6QfPKsSI/Yoj6PmKVvSGMlpgFYItTqTn3umyV01m06wXAkC?=
 =?us-ascii?Q?YEJzjL2SFBFZmBHdC2EYOcbnxD3D5yeIsjtjATjjXMs7uo5eBv7U6pL6rDNS?=
 =?us-ascii?Q?Lx7WRC1qO+sc7bxTc1jxJ7BpjIu3O4mav1ntwU0hJyU//ZfPXdtE+Je9jlAP?=
 =?us-ascii?Q?jvHOxdwr+NleNG6OARJ8GdIEFYppmI+hlfDNJqq8EXPLPDTEbFh7P4pS7J6+?=
 =?us-ascii?Q?Q+w4zQs8ao560o+WxfteaTDC3XP7X8/G4BF5mIwetX/T1wIFir1kRyKhcjki?=
 =?us-ascii?Q?pjWHiQrPMFluK2uq1WFtbtggTacNePAXE+mWZwIvDJBrvo70OrLF0DIa8VO4?=
 =?us-ascii?Q?imkfaRBKZmcXYI4XxYvS8ZCZEwXH4VUVx1L/Gs1IYIVH8vJGXQt3afoZNQT/?=
 =?us-ascii?Q?a7P4Lg81AaCWb0qCWogwQI3TO+A6nJ6MkI2RukVbos98xI0yWft3M5RpZCm9?=
 =?us-ascii?Q?fPxjdChFvQvKsBOmM/4nnJ2Y3JTC2cZCfmmSTDTuMm1uPvJuAzLdJoxRfDfj?=
 =?us-ascii?Q?kJfRiUHwY0n3Yd4UIACwIA6FGTSgtfwoMkyokLqFPT2V4ZMFIsPaVxrqRz1V?=
 =?us-ascii?Q?xgGPedzpqBg5NjBptQmPY5HkIF02T8HdtJINZCzWUGuYtGetRX5U3pL1O31Q?=
 =?us-ascii?Q?Qu1I92z0d8ljF8+p76iXlvnpJSYR/E6b6AFnkp/+wmE5bQ3Ds8Nuppszd4VE?=
 =?us-ascii?Q?tuzv6G+sT3kQD2N7a8Q/fs0T/JqNIG+BPo1HdChvhxUYy4QzoCFyDbo8Z0QL?=
 =?us-ascii?Q?2Q7NMqzTF9CReUd11YuNx3K3a8NrTRsXLc2Ii02aRXNznuMlNCNWEFnXNnr9?=
 =?us-ascii?Q?4x+BNeZu6450aLhfroYCgxCWqteMI8UByv/1n00t0lQHy/a4oKQAGo8NH3px?=
 =?us-ascii?Q?0kP+I87D6BKGiah74VxefGNgAYRT/udZe4JVCgU0xOQRCFzxZ2SYNYpejHxV?=
 =?us-ascii?Q?Rukn3JZ+G/Xg2iqNVrYcdTRbPk5gxQSAtLFA/fKqSH2Mz7uxruzT8Y/pUqqo?=
 =?us-ascii?Q?MpDLWwDmJ8V/E7adDv8hj0Xj0Sb5lA91IVVU4eqUmixKfiKuZ7YiBk33mcgX?=
 =?us-ascii?Q?uGOdccaGMiHA9uzmqoPvpG4c8YiMCbFtbjgB4rsLZJakH3VZ69h3n7z7xmZt?=
 =?us-ascii?Q?5YqB5DJr54dC2rRTBQjtA5wGCqVjgMCgMj6mtuTEDYtBnU6WZJg3udbrZu8N?=
 =?us-ascii?Q?7hD0L4PluvUl7p2Sm/Qry8KvldhVbeveRZTrw7G8I6B6Gl6XkUb7BlH2Wi0K?=
 =?us-ascii?Q?DiQoM++E6w8A0LKWQYOk6cp4ezMNIcBGQt0hb37/4EzeHzICjShFRY0u8qdI?=
 =?us-ascii?Q?dziqmSwSe6Rcv2Pk3Aa5OaxcjoIwp24nu2BqRC528dSGG2OXuvl+OjmUAk4q?=
 =?us-ascii?Q?eNl0ZzrGfG5JLWjF8ms0VpsqFMK4DV2/O1fqE6SLwwkqglYZs17S8KBKuMm/?=
 =?us-ascii?Q?N8SD+vvTa3YW21W0L+2Ps7xdza0I/1+0HSwUdNB+AnEw+E1tdMYMBnnDYCKp?=
 =?us-ascii?Q?ddPDG9JPdoYwoiiaBupYvf+3gD7RnE25vaFZoIdwcTCbPfLou7G9n0chYhje?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed14e0d1-1c6d-4fac-dc85-08db2639557b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 16:13:09.6291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: //Jg79TA6mN4Q3R0LPzeSk2xe05HchwGq8GPQtuWgOZPBy9fw5AspOWkfh9enrSJSfr8wYYsML1lrEuLY9TYpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not immediately obvious that this driver allocates, via the
KSZ_REGMAP_TABLE() macro, 3 regmaps for register access: dev->regmap[0]
for 8-bit access, dev->regmap[1] for 16-bit and dev->regmap[2] for
32-bit access.

In future changes that add support for reg_fields, each field will have
to specify through which of the 3 regmaps it's going to go. Add an enum
now, to denote one of the 3 register access widths, and make the code go
through some wrapper functions for easier review and further
modification.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/microchip/ksz8795.c      |  8 ++--
 drivers/net/dsa/microchip/ksz8863_smi.c  |  2 +-
 drivers/net/dsa/microchip/ksz9477.c      | 24 +++++------
 drivers/net/dsa/microchip/ksz9477_i2c.c  |  2 +-
 drivers/net/dsa/microchip/ksz_common.c   |  6 +--
 drivers/net/dsa/microchip/ksz_common.h   | 53 +++++++++++++++++-------
 drivers/net/dsa/microchip/ksz_spi.c      |  2 +-
 drivers/net/dsa/microchip/lan937x_main.c |  8 ++--
 8 files changed, 63 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 003b0ac2854c..7f9ab6d13952 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -28,13 +28,13 @@
 
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
-	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
+	regmap_update_bits(ksz_regmap_8(dev), addr, bits, set ? bits : 0);
 }
 
 static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 			 bool set)
 {
-	regmap_update_bits(dev->regmap[0], PORT_CTRL_ADDR(port, offset),
+	regmap_update_bits(ksz_regmap_8(dev), PORT_CTRL_ADDR(port, offset),
 			   bits, set ? bits : 0);
 }
 
@@ -1375,14 +1375,14 @@ int ksz8_setup(struct dsa_switch *ds)
 	ksz_cfg(dev, S_LINK_AGING_CTRL, SW_LINK_AUTO_AGING, true);
 
 	/* Enable aggressive back off algorithm in half duplex mode. */
-	regmap_update_bits(dev->regmap[0], REG_SW_CTRL_1,
+	regmap_update_bits(ksz_regmap_8(dev), REG_SW_CTRL_1,
 			   SW_AGGR_BACKOFF, SW_AGGR_BACKOFF);
 
 	/*
 	 * Make sure unicast VLAN boundary is set as default and
 	 * enable no excessive collision drop.
 	 */
-	regmap_update_bits(dev->regmap[0], REG_SW_CTRL_2,
+	regmap_update_bits(ksz_regmap_8(dev), REG_SW_CTRL_2,
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP,
 			   UNICAST_VLAN_BOUNDARY | NO_EXC_COLLISION_DROP);
 
diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
index 2f4623f3bd85..5871f27451cb 100644
--- a/drivers/net/dsa/microchip/ksz8863_smi.c
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -145,7 +145,7 @@ static int ksz8863_smi_probe(struct mdio_device *mdiodev)
 	if (!dev)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(ksz8863_regmap_config); i++) {
+	for (i = 0; i < __KSZ_NUM_REGMAPS; i++) {
 		rc = ksz8863_regmap_config[i];
 		rc.lock_arg = &dev->regmap_mutex;
 		dev->regmap[i] = devm_regmap_init(&mdiodev->dev,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index bf13d47c26cf..3019f54049fc 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -21,25 +21,25 @@
 
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
-	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
+	regmap_update_bits(ksz_regmap_8(dev), addr, bits, set ? bits : 0);
 }
 
 static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 			 bool set)
 {
-	regmap_update_bits(dev->regmap[0], PORT_CTRL_ADDR(port, offset),
+	regmap_update_bits(ksz_regmap_8(dev), PORT_CTRL_ADDR(port, offset),
 			   bits, set ? bits : 0);
 }
 
 static void ksz9477_cfg32(struct ksz_device *dev, u32 addr, u32 bits, bool set)
 {
-	regmap_update_bits(dev->regmap[2], addr, bits, set ? bits : 0);
+	regmap_update_bits(ksz_regmap_32(dev), addr, bits, set ? bits : 0);
 }
 
 static void ksz9477_port_cfg32(struct ksz_device *dev, int port, int offset,
 			       u32 bits, bool set)
 {
-	regmap_update_bits(dev->regmap[2], PORT_CTRL_ADDR(port, offset),
+	regmap_update_bits(ksz_regmap_32(dev), PORT_CTRL_ADDR(port, offset),
 			   bits, set ? bits : 0);
 }
 
@@ -52,7 +52,7 @@ int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu)
 
 	frame_size = mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
 
-	return regmap_update_bits(dev->regmap[1], REG_SW_MTU__2,
+	return regmap_update_bits(ksz_regmap_16(dev), REG_SW_MTU__2,
 				  REG_SW_MTU_MASK, frame_size);
 }
 
@@ -60,7 +60,7 @@ static int ksz9477_wait_vlan_ctrl_ready(struct ksz_device *dev)
 {
 	unsigned int val;
 
-	return regmap_read_poll_timeout(dev->regmap[0], REG_SW_VLAN_CTRL,
+	return regmap_read_poll_timeout(ksz_regmap_8(dev), REG_SW_VLAN_CTRL,
 					val, !(val & VLAN_START), 10, 1000);
 }
 
@@ -147,7 +147,7 @@ static int ksz9477_wait_alu_ready(struct ksz_device *dev)
 {
 	unsigned int val;
 
-	return regmap_read_poll_timeout(dev->regmap[2], REG_SW_ALU_CTRL__4,
+	return regmap_read_poll_timeout(ksz_regmap_32(dev), REG_SW_ALU_CTRL__4,
 					val, !(val & ALU_START), 10, 1000);
 }
 
@@ -155,7 +155,7 @@ static int ksz9477_wait_alu_sta_ready(struct ksz_device *dev)
 {
 	unsigned int val;
 
-	return regmap_read_poll_timeout(dev->regmap[2],
+	return regmap_read_poll_timeout(ksz_regmap_32(dev),
 					REG_SW_ALU_STAT_CTRL__4,
 					val, !(val & ALU_STAT_START),
 					10, 1000);
@@ -170,7 +170,7 @@ int ksz9477_reset_switch(struct ksz_device *dev)
 	ksz_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
 
 	/* turn off SPI DO Edge select */
-	regmap_update_bits(dev->regmap[0], REG_SW_GLOBAL_SERIAL_CTRL_0,
+	regmap_update_bits(ksz_regmap_8(dev), REG_SW_GLOBAL_SERIAL_CTRL_0,
 			   SPI_AUTO_EDGE_DETECTION, 0);
 
 	/* default configuration */
@@ -213,7 +213,7 @@ void ksz9477_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 	data |= (addr << MIB_COUNTER_INDEX_S);
 	ksz_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, data);
 
-	ret = regmap_read_poll_timeout(dev->regmap[2],
+	ret = regmap_read_poll_timeout(ksz_regmap_32(dev),
 			PORT_CTRL_ADDR(port, REG_PORT_MIB_CTRL_STAT__4),
 			val, !(val & MIB_COUNTER_READ), 10, 1000);
 	/* failed to read MIB. get out of loop */
@@ -346,7 +346,7 @@ void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	const u16 *regs = dev->info->regs;
 	u8 data;
 
-	regmap_update_bits(dev->regmap[0], REG_SW_LUE_CTRL_2,
+	regmap_update_bits(ksz_regmap_8(dev), REG_SW_LUE_CTRL_2,
 			   SW_FLUSH_OPTION_M << SW_FLUSH_OPTION_S,
 			   SW_FLUSH_OPTION_DYN_MAC << SW_FLUSH_OPTION_S);
 
@@ -1165,7 +1165,7 @@ int ksz9477_setup(struct dsa_switch *ds)
 	ksz_cfg(dev, REG_SW_MAC_CTRL_1, SW_JUMBO_PACKET, true);
 
 	/* Now we can configure default MTU value */
-	ret = regmap_update_bits(dev->regmap[1], REG_SW_MTU__2, REG_SW_MTU_MASK,
+	ret = regmap_update_bits(ksz_regmap_16(dev), REG_SW_MTU__2, REG_SW_MTU_MASK,
 				 VLAN_ETH_FRAME_LEN + ETH_FCS_LEN);
 	if (ret)
 		return ret;
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 97a317263a2f..497be833f707 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -24,7 +24,7 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c)
 	if (!dev)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(ksz9477_regmap_config); i++) {
+	for (i = 0; i < __KSZ_NUM_REGMAPS; i++) {
 		rc = ksz9477_regmap_config[i];
 		rc.lock_arg = &dev->regmap_mutex;
 		dev->regmap[i] = devm_regmap_init_i2c(i2c, &rc);
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 50fd548c72d8..8617aeaa0248 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2093,7 +2093,7 @@ static int ksz_setup(struct dsa_switch *ds)
 	}
 
 	/* set broadcast storm protection 10% rate */
-	regmap_update_bits(dev->regmap[1], regs[S_BROADCAST_CTRL],
+	regmap_update_bits(ksz_regmap_16(dev), regs[S_BROADCAST_CTRL],
 			   BROADCAST_STORM_RATE,
 			   (BROADCAST_STORM_VALUE *
 			   BROADCAST_STORM_PROT_RATE) / 100);
@@ -2104,7 +2104,7 @@ static int ksz_setup(struct dsa_switch *ds)
 
 	ds->num_tx_queues = dev->info->num_tx_queues;
 
-	regmap_update_bits(dev->regmap[0], regs[S_MULTICAST_CTRL],
+	regmap_update_bits(ksz_regmap_8(dev), regs[S_MULTICAST_CTRL],
 			   MULTICAST_STORM_DISABLE, MULTICAST_STORM_DISABLE);
 
 	ksz_init_mib_timer(dev);
@@ -2154,7 +2154,7 @@ static int ksz_setup(struct dsa_switch *ds)
 	}
 
 	/* start switch */
-	regmap_update_bits(dev->regmap[0], regs[S_START_CTRL],
+	regmap_update_bits(ksz_regmap_8(dev), regs[S_START_CTRL],
 			   SW_START, SW_START);
 
 	return 0;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8abecaf6089e..ef1643c357a4 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -22,6 +22,13 @@
 struct ksz_device;
 struct ksz_port;
 
+enum ksz_regmap_width {
+	KSZ_REGMAP_8,
+	KSZ_REGMAP_16,
+	KSZ_REGMAP_32,
+	__KSZ_NUM_REGMAPS,
+};
+
 struct vlan_table {
 	u32 table[3];
 };
@@ -137,7 +144,7 @@ struct ksz_device {
 	const struct ksz_dev_ops *dev_ops;
 
 	struct device *dev;
-	struct regmap *regmap[3];
+	struct regmap *regmap[__KSZ_NUM_REGMAPS];
 
 	void *priv;
 	int irq;
@@ -377,11 +384,25 @@ phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit);
 extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
+static inline struct regmap *ksz_regmap_8(struct ksz_device *dev)
+{
+	return dev->regmap[KSZ_REGMAP_8];
+}
+
+static inline struct regmap *ksz_regmap_16(struct ksz_device *dev)
+{
+	return dev->regmap[KSZ_REGMAP_16];
+}
+
+static inline struct regmap *ksz_regmap_32(struct ksz_device *dev)
+{
+	return dev->regmap[KSZ_REGMAP_32];
+}
 
 static inline int ksz_read8(struct ksz_device *dev, u32 reg, u8 *val)
 {
 	unsigned int value;
-	int ret = regmap_read(dev->regmap[0], reg, &value);
+	int ret = regmap_read(ksz_regmap_8(dev), reg, &value);
 
 	if (ret)
 		dev_err(dev->dev, "can't read 8bit reg: 0x%x %pe\n", reg,
@@ -394,7 +415,7 @@ static inline int ksz_read8(struct ksz_device *dev, u32 reg, u8 *val)
 static inline int ksz_read16(struct ksz_device *dev, u32 reg, u16 *val)
 {
 	unsigned int value;
-	int ret = regmap_read(dev->regmap[1], reg, &value);
+	int ret = regmap_read(ksz_regmap_16(dev), reg, &value);
 
 	if (ret)
 		dev_err(dev->dev, "can't read 16bit reg: 0x%x %pe\n", reg,
@@ -407,7 +428,7 @@ static inline int ksz_read16(struct ksz_device *dev, u32 reg, u16 *val)
 static inline int ksz_read32(struct ksz_device *dev, u32 reg, u32 *val)
 {
 	unsigned int value;
-	int ret = regmap_read(dev->regmap[2], reg, &value);
+	int ret = regmap_read(ksz_regmap_32(dev), reg, &value);
 
 	if (ret)
 		dev_err(dev->dev, "can't read 32bit reg: 0x%x %pe\n", reg,
@@ -422,7 +443,7 @@ static inline int ksz_read64(struct ksz_device *dev, u32 reg, u64 *val)
 	u32 value[2];
 	int ret;
 
-	ret = regmap_bulk_read(dev->regmap[2], reg, value, 2);
+	ret = regmap_bulk_read(ksz_regmap_32(dev), reg, value, 2);
 	if (ret)
 		dev_err(dev->dev, "can't read 64bit reg: 0x%x %pe\n", reg,
 			ERR_PTR(ret));
@@ -436,7 +457,7 @@ static inline int ksz_write8(struct ksz_device *dev, u32 reg, u8 value)
 {
 	int ret;
 
-	ret = regmap_write(dev->regmap[0], reg, value);
+	ret = regmap_write(ksz_regmap_8(dev), reg, value);
 	if (ret)
 		dev_err(dev->dev, "can't write 8bit reg: 0x%x %pe\n", reg,
 			ERR_PTR(ret));
@@ -448,7 +469,7 @@ static inline int ksz_write16(struct ksz_device *dev, u32 reg, u16 value)
 {
 	int ret;
 
-	ret = regmap_write(dev->regmap[1], reg, value);
+	ret = regmap_write(ksz_regmap_16(dev), reg, value);
 	if (ret)
 		dev_err(dev->dev, "can't write 16bit reg: 0x%x %pe\n", reg,
 			ERR_PTR(ret));
@@ -460,7 +481,7 @@ static inline int ksz_write32(struct ksz_device *dev, u32 reg, u32 value)
 {
 	int ret;
 
-	ret = regmap_write(dev->regmap[2], reg, value);
+	ret = regmap_write(ksz_regmap_32(dev), reg, value);
 	if (ret)
 		dev_err(dev->dev, "can't write 32bit reg: 0x%x %pe\n", reg,
 			ERR_PTR(ret));
@@ -473,7 +494,7 @@ static inline int ksz_rmw16(struct ksz_device *dev, u32 reg, u16 mask,
 {
 	int ret;
 
-	ret = regmap_update_bits(dev->regmap[1], reg, mask, value);
+	ret = regmap_update_bits(ksz_regmap_16(dev), reg, mask, value);
 	if (ret)
 		dev_err(dev->dev, "can't rmw 16bit reg 0x%x: %pe\n", reg,
 			ERR_PTR(ret));
@@ -486,7 +507,7 @@ static inline int ksz_rmw32(struct ksz_device *dev, u32 reg, u32 mask,
 {
 	int ret;
 
-	ret = regmap_update_bits(dev->regmap[2], reg, mask, value);
+	ret = regmap_update_bits(ksz_regmap_32(dev), reg, mask, value);
 	if (ret)
 		dev_err(dev->dev, "can't rmw 32bit reg 0x%x: %pe\n", reg,
 			ERR_PTR(ret));
@@ -503,12 +524,12 @@ static inline int ksz_write64(struct ksz_device *dev, u32 reg, u64 value)
 	val[0] = swab32(value & 0xffffffffULL);
 	val[1] = swab32(value >> 32ULL);
 
-	return regmap_bulk_write(dev->regmap[2], reg, val, 2);
+	return regmap_bulk_write(ksz_regmap_32(dev), reg, val, 2);
 }
 
 static inline int ksz_rmw8(struct ksz_device *dev, int offset, u8 mask, u8 val)
 {
-	return regmap_update_bits(dev->regmap[0], offset, mask, val);
+	return regmap_update_bits(ksz_regmap_8(dev), offset, mask, val);
 }
 
 static inline int ksz_pread8(struct ksz_device *dev, int port, int offset,
@@ -552,7 +573,7 @@ static inline int ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 static inline void ksz_prmw8(struct ksz_device *dev, int port, int offset,
 			     u8 mask, u8 val)
 {
-	regmap_update_bits(dev->regmap[0],
+	regmap_update_bits(ksz_regmap_8(dev),
 			   dev->dev_ops->get_port_addr(port, offset),
 			   mask, val);
 }
@@ -709,9 +730,9 @@ static inline int is_lan937x(struct ksz_device *dev)
 
 #define KSZ_REGMAP_TABLE(ksz, swp, regbits, regpad, regalign)		\
 	static const struct regmap_config ksz##_regmap_config[] = {	\
-		KSZ_REGMAP_ENTRY(8, swp, (regbits), (regpad), (regalign)), \
-		KSZ_REGMAP_ENTRY(16, swp, (regbits), (regpad), (regalign)), \
-		KSZ_REGMAP_ENTRY(32, swp, (regbits), (regpad), (regalign)), \
+		[KSZ_REGMAP_8] = KSZ_REGMAP_ENTRY(8, swp, (regbits), (regpad), (regalign)), \
+		[KSZ_REGMAP_16] = KSZ_REGMAP_ENTRY(16, swp, (regbits), (regpad), (regalign)), \
+		[KSZ_REGMAP_32] = KSZ_REGMAP_ENTRY(32, swp, (regbits), (regpad), (regalign)), \
 	}
 
 #endif
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 96c52e8fb51b..279338451621 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -63,7 +63,7 @@ static int ksz_spi_probe(struct spi_device *spi)
 	else
 		regmap_config = ksz9477_regmap_config;
 
-	for (i = 0; i < ARRAY_SIZE(ksz8795_regmap_config); i++) {
+	for (i = 0; i < __KSZ_NUM_REGMAPS; i++) {
 		rc = regmap_config[i];
 		rc.lock_arg = &dev->regmap_mutex;
 		rc.wr_table = chip->wr_table;
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 399a3905e6ca..b479a628b1ae 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -20,13 +20,13 @@
 
 static int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
-	return regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
+	return regmap_update_bits(ksz_regmap_8(dev), addr, bits, set ? bits : 0);
 }
 
 static int lan937x_port_cfg(struct ksz_device *dev, int port, int offset,
 			    u8 bits, bool set)
 {
-	return regmap_update_bits(dev->regmap[0], PORT_CTRL_ADDR(port, offset),
+	return regmap_update_bits(ksz_regmap_8(dev), PORT_CTRL_ADDR(port, offset),
 				  bits, set ? bits : 0);
 }
 
@@ -86,7 +86,7 @@ static int lan937x_internal_phy_write(struct ksz_device *dev, int addr, int reg,
 	if (ret < 0)
 		return ret;
 
-	ret = regmap_read_poll_timeout(dev->regmap[1], REG_VPHY_IND_CTRL__2,
+	ret = regmap_read_poll_timeout(ksz_regmap_16(dev), REG_VPHY_IND_CTRL__2,
 				       value, !(value & VPHY_IND_BUSY), 10,
 				       1000);
 	if (ret < 0) {
@@ -116,7 +116,7 @@ static int lan937x_internal_phy_read(struct ksz_device *dev, int addr, int reg,
 	if (ret < 0)
 		return ret;
 
-	ret = regmap_read_poll_timeout(dev->regmap[1], REG_VPHY_IND_CTRL__2,
+	ret = regmap_read_poll_timeout(ksz_regmap_16(dev), REG_VPHY_IND_CTRL__2,
 				       value, !(value & VPHY_IND_BUSY), 10,
 				       1000);
 	if (ret < 0) {
-- 
2.34.1

