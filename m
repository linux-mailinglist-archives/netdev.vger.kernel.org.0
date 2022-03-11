Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8654D6ADB
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiCKWsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiCKWsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:48:08 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150048.outbound.protection.outlook.com [40.107.15.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5AD2272C5;
        Fri, 11 Mar 2022 14:22:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUeXV1JE00L2IRMOQ5hsb9qeJZRGAjfps0pCe+RRLKQynlsmQ13KTbFUF0cixyO1+NMWjfjjMlqdohLBtajK0DSc8LliWLhoQ9taxDkKQ142Wl92YXoHR4G/um82QybRiVouzw+ZBx3CzlNNGNlhsXgcuewNQ3hxXpIEKypdpmQzjdEg/TL5xR4dl16hdfQsTidynFyoN7nUT7HGUISz4epCRoY0yAL33oMOIzy1LN4B+7K/xCEK+V8q+w7xmgq2uHGYVDXErSAiybYAhdM27SI4keR3vSMxwrUt68db0K+PzpPIirWtMWcwcpW2v7l58b0aIgwo5ZtIzav5nAUxIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIXzyMulaG0lCkAs7j/vlV6tR7a63T9ByaqL8rpT+tM=;
 b=fQcspjml9erUg3Ls22EqJI3n4bFdVNJgx9M0/MHDGRH+f7cp81tJQxqvHvdXRxKXKQw62UwDACPraTO2i7xfo4JWzraIt7K2cAFaQBEiNNov6PkMs/oT62ELkNWT/mM0kZZ4wraPyTSK+TfDq5uYolvOCU+Chrm6X0KNOiTUKq18gJJxs8ziodCQq9lqAT2ZkesAdmGDLRyKCIiMdA3m/VdKmJ0MYUPALBmt3xiGW0KvgWFR232P8bCqV5/nhHQOJGWv9IyWWsIsJP+00iv1GbimTnGCZkMKvfp5Q3dK7tU2MEPmLPSGuEJXx3RO8ucDRMHGffKeG8aDwpP3DmvCWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIXzyMulaG0lCkAs7j/vlV6tR7a63T9ByaqL8rpT+tM=;
 b=U6Z9wLX//WfXE6irs27YaU5LmWv8iBN8cfLIWRFHGQWJsCa8svELCywiRMewxkrS+Cf0tiwRUOaLi/WoYp2NqidYPLR2gGLzAxryIaHZcY2D1LtzB8oFwiz+DFNwbUt/roGi5g5w3aK9QTXBY3PSYCnTf4d9TyPAp8h5WoS1xNM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB8845.eurprd04.prod.outlook.com (2603:10a6:102:20c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Fri, 11 Mar
 2022 21:23:29 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5061.025; Fri, 11 Mar 2022
 21:23:29 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 0/8] dpaa2-mac: add support for changing the protocol at runtime
Date:   Fri, 11 Mar 2022 23:22:20 +0200
Message-Id: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0057.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::34) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2f23f7a-8c99-4f22-15e0-08da03a562f7
X-MS-TrafficTypeDiagnostic: PAXPR04MB8845:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB8845731E5EA7F1CA9C332ED5E00C9@PAXPR04MB8845.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yrcaeKFs/kOlIXknDNMhZ2xpk5g22tmMAIZlVz4U97H/7SICTzOl3ex++EZHW0kGH0NaPoKKsonfZGveGm4U8Hbwwdk1DujH6WgfQjS8DQDdpAP8cMu+RuGwB3aaeKifzTSvqgCXgrvKVQQyBSbJ0qNL+l7LzAq8tRuSdjC2n4XUjKcDmJeX+O0+YqXbutMjlZnN+cfTNBzqYhvMqwjvW3yWdJ9zlNiZ7VfOr0zg9t5Evctmh79vkHLj2no1v1IVJkZqK5dg318QKP6IolKlzuZOqklZKY+qr5IqrnvihG9RqbD7SE5+SldqbBupwH7Ero9LEpqQOyN8h6wqAquj0emneILAk7b2IGQA6UKKiHD0oGHmb82YW+J1+0QKRy22ILd3Em4yMCncBo5BHway/zi/uXwOsy2mBBoIeXDbSNqAUfNGY9lq7VoATKzbYTN/GanlacsoAwrTcyE8KHHvo14jxbObxT8Zl3ubj2bLLzJDGTL20qvIXGdssRPzSo3uy6M+CisUEbXJ62hcWKEwQEFRkPi1MyNf6QG6WZaUKPYglueW7jhEReu38NQZZ4vrVEFP6XPDZ9lblTd5bqzGN3RZ7w0lJTEOeC/XkanveyulFOfCK4JCwwjlJxUNUlha1Cx7DVqDoSmTTcLYmAHEg6xADUgH5daTpoOW7cqlcRkk4qm40f+1a/ZnV0bLv5Gqccdrhwgt9FFRqRqqhAgNdFBNIe/kBEMNCc09ZAxMuDOlJO00+UfEp7J4YVMtE07Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(4326008)(66556008)(8676002)(66946007)(36756003)(316002)(38350700002)(38100700002)(6666004)(6512007)(83380400001)(8936002)(26005)(186003)(508600001)(5660300002)(1076003)(7416002)(2616005)(6486002)(44832011)(2906002)(52116002)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wRZv9C9ze4SM2gaI6yFv+xjQKmJXFOnEReA3CZfV89eFKrn4qEHB8KTQ3PS9?=
 =?us-ascii?Q?6aNGDQMvYjyzaB2wKN/fB/K9PLzG/9fw8Afh1KZiexGnJEInSsqKo+DUXUhs?=
 =?us-ascii?Q?Uu29Gcr2EygavlMQgWvDwlCUR9U6AF+6kQLf4ODtQPNxeHtYGjk6ASEoUbIJ?=
 =?us-ascii?Q?l3P9quwmL41Oiu6MxDRsZh53yHXkycbaTzdTW31L9WJvCTDLDrytsHpMMBvH?=
 =?us-ascii?Q?ukyHBlFbZfHdUqi7UzVQUUEjGNhvSNBaKnLxhWgo6O+Ys4qaBGpGPuBSmsl6?=
 =?us-ascii?Q?79JdBaWUrbFdNE9qX3fP+LRTov7Yy3k0T2TsbEnT2pgf68vuTnBLIyzN5YJ+?=
 =?us-ascii?Q?HnNPsR+cXhtRglhfY4PKZYMBKVDx/nPIUS2Vg5s7Z27m2tB6NxeGyFvxHKva?=
 =?us-ascii?Q?ldFfRsg2oo60ikYbJnbEHygii9Ije+Zu1t8KjgY0Qf34zeu8PzNM9gP5yAf1?=
 =?us-ascii?Q?u/85g1gJyufkf17f2ZVftDu/zov0iO3jLygXu2EQGvPjKSrX4/3fqKZnA5JU?=
 =?us-ascii?Q?g7WAnjgMfp3c3VTPN695XO2PrGCv96Dvk/0KxUWq5h+NwzsyJm1p76To6cSr?=
 =?us-ascii?Q?Qsi9ptDlp2Ut41OGedRfIg2HaZxsv/qavlPdDf+8nlcsgE+YFv51yNnMG12j?=
 =?us-ascii?Q?ZjHRafkxqNnIESxqHN+XCdZLykIz8Cg/42YC3VZNc5ewhov+gjdGYqTVsJ2x?=
 =?us-ascii?Q?8I477fPnZLLzTJVcdydP8N+wPC68vg1ckhJtlfLuialK6r//QEyjygKgerQ9?=
 =?us-ascii?Q?DmPNLavMXWCdZzNbv8E292LidgTctfJa/qohX5esJ66eX4/N4zLS6+KhVdfm?=
 =?us-ascii?Q?vMxEghKReKy4+umI5BHdavYzu8XiXk38n7LCDpVSXbAj2p41uo03V0yI5VWq?=
 =?us-ascii?Q?83hvJgXOnJCzHAmhJ0+COdSNpUSqJ/bA1mC3DT62IbiV+Y/pbfJUgZjYJBXq?=
 =?us-ascii?Q?t8hSQMdwiYMD0EI+6X+8gGhJrifbkhNRZRS6Qsp5/AJFP+lajSAEclRbPsVF?=
 =?us-ascii?Q?ZAqgNnTdmF418ib4rOJmodl5CxmBvlXOp1UT7K1VqhvoPgSMChdwJqEhu2MT?=
 =?us-ascii?Q?c4YmrE/ZtDiUWCcD0gSYW2gd7kn5xONB1Sf8bkkDyw+12AdA14RM4SGjw/HS?=
 =?us-ascii?Q?jtwCMwhSJEm5t3qkaPtyQJs07AcH2JN+N/3q+HexzMUf65SKDfCuTaUQ/+/m?=
 =?us-ascii?Q?AqRt6TPTj0GLcgu+MiDusyJDnxwQ7t57mSx1kb/EFd+RS1tc+iXpH5Ftegj6?=
 =?us-ascii?Q?3Tlv3GlkdWlTkKNWoZ7hrDlnC+wQtskFWGGb7RD9HweEhrzYBw/w3jxJW9oA?=
 =?us-ascii?Q?wS2Sxg6YVV982dXRd4AGInjOfvQC6coU2qoYOOMBSW8z7pdSqvZH6yv2GEPZ?=
 =?us-ascii?Q?KTDcVfbTPgIm8h4O1g9J3AS1m62xW5qnEsNWJHXX4Fo+2WvBGW+iDjZuIYHP?=
 =?us-ascii?Q?imLJZSdXwlosEEH6H+O/a4jPi3jrz16MbQR92fOjjMn/nXH0gxrP3A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f23f7a-8c99-4f22-15e0-08da03a562f7
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:23:29.3224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UuHHJvdJxEVeOVpJqwAfPicsPdIXlrJBBmXNSVo2KohGhTAD1CNffkPyTr1CwScXh7oRYN4a3YOUgjmogOgUIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8845
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for changing the Ethernet protocol at
runtime on Layerscape SoCs which have the Lynx 28G SerDes block.

The first two patches add a new generic PHY driver for the Lynx 28G and
the bindings file associated. The driver reads the PLL configuration at
probe time (the frequency provided to the lanes) and determines what
protocols can be supported.
Based on this the driver can deny or approve a request from the
dpaa2-mac to setup a new protocol.

The next 2 patches add some MC APIs for inquiring what is the running
version of firmware and setting up a new protocol on the MAC.

Moving along, we extract the code for setting up the supported
interfaces on a MAC on a different function since in the next patches
will update the logic.

In the next patch, the dpaa2-mac is updated so that it retrieves the
SerDes PHY based on the OF node and in case of a major reconfig, call
the PHY driver to set up the new protocol on the associated lane and the
MC firmware to reconfigure the MAC side of things.

Finally, the LX2160A dtsi is annotated with the SerDes PHY nodes for the
1st SerDes block. Beside this, the LX2160A Clearfog dtsi is annotated
with the 'phys' property for the exposed SFP cages.

Changes in v2:
	- 1/8: add MODULE_LICENSE
Changes in v3:
	- 2/8: fix 'make dt_binding_check' errors
	- 7/8: reverse order of dpaa2_mac_start() and phylink_start()
	- 7/8: treat all RGMII variants in dpmac_eth_if_mode
	- 7/8: remove the .mac_prepare callback
	- 7/8: ignore PHY_INTERFACE_MODE_NA in validate
Changes in v4:
	- 1/8: remove the DT nodes parsing
	- 1/8: add an xlate function
	- 2/8: remove the children phy nodes for each lane
	- 7/8: rework the of_phy_get if statement
	- 8/8: remove the DT nodes for each lane and the lane id in the
	  phys phandle
Changes in v5:
	- 2/8: use phy as the name of the DT node in the example

Ioana Ciornei (8):
  phy: add support for the Layerscape SerDes 28G
  dt-bindings: phy: add bindings for Lynx 28G PHY
  dpaa2-mac: add the MC API for retrieving the version
  dpaa2-mac: add the MC API for reconfiguring the protocol
  dpaa2-mac: retrieve API version and detect features
  dpaa2-mac: move setting up supported_interfaces into a function
  dpaa2-mac: configure the SerDes phy on a protocol change
  arch: arm64: dts: lx2160a: describe the SerDes block #1

 .../devicetree/bindings/phy/fsl,lynx-28g.yaml |  40 ++
 MAINTAINERS                                   |   7 +
 .../freescale/fsl-lx2160a-clearfog-itx.dtsi   |   4 +
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi |   6 +
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   5 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 159 ++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   8 +
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   5 +-
 .../net/ethernet/freescale/dpaa2/dpmac-cmd.h  |  12 +
 drivers/net/ethernet/freescale/dpaa2/dpmac.c  |  54 ++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h  |   5 +
 drivers/phy/freescale/Kconfig                 |  10 +
 drivers/phy/freescale/Makefile                |   1 +
 drivers/phy/freescale/phy-fsl-lynx-28g.c      | 624 ++++++++++++++++++
 14 files changed, 919 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-28g.c

-- 
2.33.1

