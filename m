Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE21F4D4C88
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244709AbiCJPBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343648AbiCJO6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:58:34 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141DB18887F;
        Thu, 10 Mar 2022 06:52:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OateU03eUBj4aUP/n2G/cfpDBWChd287nNOwCThnp65DXSt5xfn2Bscr0AMx6AN32xCu8MUJeyKPOf7Ltj+WXZyPSSiF+Egp0ZBfyCJMB8+DsWWSVwasxZasLcUXkcTBVQb0sxTiQ6AdVlpolYDhx1WDVXcGxNI+YTw7xXTwuqEGLI6RoeBv7PaPnzIFxgozxAf5t6Y/LQpc8ejbOyd0MS0gm2Hmre8nP/xbkLbIE/EPhHj1b6aPbqR7sOGfKEaCXprYchxK3ErPSrO+8BU/Iy42FInCD1YlarcjtbT6FLW/JdGuoS72W2UY4bRVPuwD/T6DnlQjijZ7NQqnyV74/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfCpDelf82F9eLCIZ2vkHXw0jVacvy/CTibGU2rDiHg=;
 b=EKwCtcv9KB3+2la4rU9cVw02PycUhzffOvszHj4aWBhgNCkRlvSHYKvUFOu2jQFhYkUn9edDhkpssXnAGAjZulPxg9Zkb1sWEqOceVr2FAgCB8FQeqQUyEYRIswoQec5gOH2FJo6jI9VzzYqiuc04Ob9AWtUcnS16ogOpKjI0ZATsZXd+TDAn/xx1qZ58QaKSYbPGpmU6pIoQ9zn5XhJJg/VVTPOk1LDMy0fTpChfOHiveH7miHCa53/bbG5ltk5kvj9GFKTDSXWQ7NgtQB/F/eR/mvYqj4c+x3TEv6J39y50y+mw+RgS5hRLkqzIU+jA9mgrsKWDiYzNAy6nywVdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfCpDelf82F9eLCIZ2vkHXw0jVacvy/CTibGU2rDiHg=;
 b=eTJC4/SLjer15EyIOciJmas7DzKepIxwYhR/Bm0Y5JQpErxZEp8IYY012Exw8L96lk+1XRkJmPAR67RRmwHLeJhXqjHi/7vHkXyJp/+HNAlEqvx8Xn81fYFJqLJBMFusDczEWA0CfBSNCiJyaUy1SMxZ+fa0Auw1IWXXPnROmJI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.29; Thu, 10 Mar
 2022 14:52:22 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 14:52:21 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 0/8] dpaa2-mac: add support for changing the protocol at runtime
Date:   Thu, 10 Mar 2022 16:51:52 +0200
Message-Id: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0288.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 904a99b2-0a32-412e-456d-08da02a594a3
X-MS-TrafficTypeDiagnostic: AM8PR04MB7281:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB728119EC9C71D63BB6B2A01AE00B9@AM8PR04MB7281.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6hXxHSkR/mo0SYXxD0hRaGu2SYfaB5dKgJpMANJDjYMvac+cQ43KATdT6iXgdpBxkHo8Ou8bTsXidii4upsb4oon2fe1/hOxyc6/dkna5GcqlAZNo66HkgI5d/wN8B/A176TGFV+x/rEyAJOXBNmqi08001ABbXi4uYB/8efwRmXCaV+iqjdsMexnfUFG+FO/H9zYu+eFIXE58F+YelKpGAmFie0rSQZ4gZGnXmoPWSUBv3J486sPM5TjzEOCRUmJYSZ1mHXmxetNpfpUWhSVIOeK1yd7snp6TdFDVEsjO7j/9F97eyFGNq4ObOD4nq38yx+ZyXP7eR3s1mAp7U5L6XBQURSY+DCoajEPRVbHP9whRm2B+lNDys++VDvxadBekL/GRgcWFl7zHrc6+DcX5GAzturAoroiqNtxBSJPglkJs1kqlyHpcaJ5slSe3hLGanRRx0WeIYk171LIvkUOheTAL0VHMvnL8Gr2HvEmdu33ykMYnMo/dqG8a/i8h0NiLrmzeFw4m0SMhs2FBaJpAEkvmW1VriyscBdVN9gJCi0i79v1fWOffbnif0ijrpeh0uht7PtMxNLZnF0SvCPQPMl+LsyIn5ihzF60AsmEYIkPnvHsx6/RfrTh5cgmLfHtEGHj6ox1S+ORy9Nr7FWjykQ6lemYf/3gRg1a8vOo6ouj1FoCn+giOPZOpf9UF9dpIGAssIK+KvkVREnZAErAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(316002)(66556008)(6486002)(52116002)(66476007)(8676002)(5660300002)(6506007)(66946007)(4326008)(2616005)(2906002)(8936002)(86362001)(186003)(44832011)(38350700002)(38100700002)(6666004)(508600001)(36756003)(26005)(83380400001)(7416002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0jhRkUBR3LoikFhPlOCCHAwqKRHb0s+mqByt2RD1Y64eMMDxW7JLpzPrLpZT?=
 =?us-ascii?Q?GQcDhNs2sd/rUOcAtJFjvM42FEpZgWerV7ilunvuu2EM4CWjmNlqBtFZ5cVp?=
 =?us-ascii?Q?LlYb7VTR8vs7mo+VwPh5TjTo/qSTCUgN/zcFvciEsPnQkDOoB2dI1FAd8D2B?=
 =?us-ascii?Q?OUGYi7c2KVUoWozIXkiNVWP8bQxn9qRY3XpfE4StUPs6zVm/bZV0VV02dLWV?=
 =?us-ascii?Q?Bmj2Ee0p7FchIill2NxYSmiDoK6+gGTnUi72bnnu0KlBRyp++IkciZ8aJVes?=
 =?us-ascii?Q?Ar91mIXrmKH1vJ2UiSoZu00aLtkd254Cp1I0VX4EUbPxn+ZTBlPV0y9cJwh/?=
 =?us-ascii?Q?CbQzhlxob+DZJceIcH8R4MzFQ8vGG92R92z6h8RT9yVPTTpU7vAduyt5VsiC?=
 =?us-ascii?Q?VX2WtXxbmvtwO8N7uqbJO3l0oxccoCwflUFgaIbTIoBEJGFzDFW7dir2nyp2?=
 =?us-ascii?Q?UGFkv0P9IVtpKOvF578/aLNjdsYW144wZTKvGNZW2IBDoP9Yf/H3ndYQHpUl?=
 =?us-ascii?Q?aEMgL82nar3y0EYubE88abFR5SfK1VYBZrs9VeZBDXtadQ1WwiwISzQY6vvN?=
 =?us-ascii?Q?i1GmQYZ2smIGGx++hb81z52MdYtECG0ftUVYS9RyUrD0aS97nAhuJbJV4irq?=
 =?us-ascii?Q?PZy7elLFACwHOlkI/ad79/BqkX5Z//9dvGxtjYVsZIzdGpWvBTbMR/hesZYy?=
 =?us-ascii?Q?MO5aRIodGGEujjMzVQIxPlrGJSioIFt7mH2GnogvoZqMmiUAXrHL+Q8xe9Cd?=
 =?us-ascii?Q?fGNrfe/ayss4CVBMoGf4/IoHcOnWgBTzS89nAELA2/5oMw9513aXCV5rqVzj?=
 =?us-ascii?Q?A1RuScHKl+J1kEtO4mXbM4nZ9rzVQzIKE6vUcltyKoyRl/aHWeZicPamQ0DQ?=
 =?us-ascii?Q?ZD6ddqfFieBpxaKYUmPKJkbs9DiUd3/oY2sD0R/+TvAAXC58J/WiQHbYsssK?=
 =?us-ascii?Q?irYrvVTmSGAeMiqQOtrTjbS1IoP1KoYRIeV3zOGdk7SgUEz7wU/5gEoM5Nq+?=
 =?us-ascii?Q?j9XkVzC3WwiuUeBvdhJzYsQ6ZCKfdYJ9uHpdXAxjHAYwm+wM3Xl2Dcpv4cKo?=
 =?us-ascii?Q?hIO4vFBPkuXR/voalVr0Zn7jXPp++ncz6ptOJrJ+v+FNOqqXDGrdT8SlQlqm?=
 =?us-ascii?Q?AHS1e3wsHyPlS85z4QHydJVSklwd5Z3tN9rfxUbvLO7CZYAeBnYCkIFsxyWz?=
 =?us-ascii?Q?4KWKBQRlbgo+OA7NDKi6lNtkKnZ6/4td0l2ZafHzoF68ePk24uvj0k+iknW2?=
 =?us-ascii?Q?TCLot5FOJFgXheMRzdX0PHS6zuBmQ8rlEbfihVYdsNKUmROjaK3rg8ueL8rc?=
 =?us-ascii?Q?Sy1h/O/wcy2Mmsxa/Q+ZlBwCnlzoUU6b8KOj+98O3SMciqBogO/6bvXujsJP?=
 =?us-ascii?Q?zvRaLOsZxKI6QvCi28m8xYpsgUm/kkH1BZhgJe6Y6j2U7BERDjHXn6NYQEua?=
 =?us-ascii?Q?rUmrQomEjlaunZw77xWXBIEL05FI2HCZEIZ6SxfSOexLiGkWad2isEeCsdG1?=
 =?us-ascii?Q?PEZiMI2g1q2IY2An97HIKDIWOWihP+BEqV3l4p3fWqyK6hzBcTMK8cSBQr9D?=
 =?us-ascii?Q?TB5FO0CZhO9IrKQug1EkMHmhmXy8XIep+xE9w2c4lJdH+aYXe0hdYbt+zaf1?=
 =?us-ascii?Q?YrP9zH3umuXEcHT4tH68+Ds=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 904a99b2-0a32-412e-456d-08da02a594a3
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 14:52:21.5589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wg4pTKLQBYKeWTWltCSLfCAF9WpexErygEDlY7oVKSNbNL+MZJJ393rwLQrDgGWz21Cp4WEGUc2R44XbFXDLAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
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

Ioana Ciornei (8):
  phy: add support for the Layerscape SerDes 28G
  dt-bindings: phy: add the "fsl,lynx-28g" compatible
  dpaa2-mac: add the MC API for retrieving the version
  dpaa2-mac: add the MC API for reconfiguring the protocol
  dpaa2-mac: retrieve API version and detect features
  dpaa2-mac: move setting up supported_interfaces into a function
  dpaa2-mac: configure the SerDes phy on a protocol change
  arch: arm64: dts: lx2160a: describe the SerDes block #1

 .../devicetree/bindings/phy/fsl,lynx-28g.yaml |  98 +++
 MAINTAINERS                                   |   7 +
 .../freescale/fsl-lx2160a-clearfog-itx.dtsi   |   4 +
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi |  41 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   5 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 161 ++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   8 +
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   5 +-
 .../net/ethernet/freescale/dpaa2/dpmac-cmd.h  |  12 +
 drivers/net/ethernet/freescale/dpaa2/dpmac.c  |  54 ++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h  |   5 +
 drivers/phy/freescale/Kconfig                 |  10 +
 drivers/phy/freescale/Makefile                |   1 +
 drivers/phy/freescale/phy-fsl-lynx-28g.c      | 630 ++++++++++++++++++
 14 files changed, 1020 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-28g.c

-- 
2.33.1

