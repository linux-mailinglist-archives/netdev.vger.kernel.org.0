Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB974D61E1
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348688AbiCKM4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348685AbiCKM4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:56:15 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDFD1BFDED;
        Fri, 11 Mar 2022 04:55:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGP4QzMcozoEfTF6UKZpGW4urn8B0X7sQMHC4P5iQZO2KaFf8JR6fRswEGJ83NvG59MvzTf3VaPAR1GoNriQGuwsPtTx4MzOZnN/RTuHKrWULCyo7OM82BugcmymiObPUGJAe6N6Qt3I+byR3pU+rpiog3F2VJLmMJouoTnIGiU+OKfRJEQUKpcRu9oCqloIa+4Q40UhsUkgQsco0bWZiyJ8JV0RPF0DAsKaTQacxElPmY1CR2abykuaNnl+4BkOKDWZtVOv0hhpxkVLWH3Zlddw2Lu1ezknIMSNeS3E4i4pHUysijYQGGqzA86y/JxmVvxrq0RGN4AdNeqTXsTPAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KV/tIoAPSm3WZ2lcvwOkAGfBv0GtpuOeSAUj4rxhQpM=;
 b=J8/n/1dtLIBiUMgo3as5ZDXTOCODWxRnf5lw49H8cnUnjbM+xV3rlF7IeTNMyXtNr1n6xKEASZ0qPMCTYPGpRhY1QPMGCs3wBXw+F5Gsm7UJyIn2eQsS9NVjDTJLt1T/kNINMV5Myij2JjpBueE26A6ITD+hxRXcH+A2kHXY1OqQd2kHrVsieg+gc+4c0xjZ9V3sYn1rLEBHQSQv+ueaHtVBIJJq+HkJMgt0szdvLThWng3YU/DlfhYmpLZ+c2Sgk4xO/eJ+pc3fRaxN9OWdmIQfWmO1tbeyhOtPuwA/KkLIGey32a5XYBLKOGKt/loDM5HMjzvyA868U9de1b5tLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KV/tIoAPSm3WZ2lcvwOkAGfBv0GtpuOeSAUj4rxhQpM=;
 b=BFriH85Es5f7AzBZt0nx4YzszSzKT4i/8A4SA8t+wTNRU1QhD4K8kEDqelJL28ER0ceapYwmf7GYIbeO38jS2GBasxmZT4DJH166kOIrTjFHCjjEVi+TI4d9llvEwPW7pcuppMr0AcWfjvBs5l8CqSq7FuCFX/kwo+ZsyqW0D6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB8880.eurprd04.prod.outlook.com (2603:10a6:102:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Fri, 11 Mar
 2022 12:55:07 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 12:55:06 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 6/8] dpaa2-mac: move setting up supported_interfaces into a function
Date:   Fri, 11 Mar 2022 14:54:35 +0200
Message-Id: <20220311125437.3854483-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
References: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0402CA0014.eurprd04.prod.outlook.com
 (2603:10a6:203:90::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9828ff7-9da1-4642-d8be-08da035e5e24
X-MS-TrafficTypeDiagnostic: PAXPR04MB8880:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB8880154E3951F0DBC39BAB8AE00C9@PAXPR04MB8880.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OxZWZMSVKZ7Habfv5gKlGiJOSwETekyFN2tkKGvohJw3vW415uwLdeaZXEvnY2QvJzZ0MTpO7/lQk1Walx7mapd726zLJFWS/hiV2Z4H8C69A76HZcVFCdgfcdGJNsUW3ynDZ6zU8m0LIvt66hqo2kuOXCXCR2lEPG7GjGJ/CjBVZrNrL+zayjSFpDK+H5qBPuReerGwYgaLsXH4uoT+8SIPxc102crGJMbvoOXGzIHybKTU/b50cUsEBQMcY8EtBo+WHU/5qHC8IV4DmEfswR1cxqrCZBHum73hNSb9nYrL21h6+W8VO3A+oH5JgkxrHnufZieJP96BtIlYtnz7QBGO/DIi8AWzVD4Mq5nOoX26q3zFCKxyMTB3/CGoZY5+9gckc5OvPNTGkqA4cm2BaWcn7BZpS+yX+cB+/8euFTxQqfMlyN4BgmuxMA5mNYVgZoCBv4VwCiNk4KiqcyVE9SBVh7lYqeiOeRIzLBwyMkxPsKS3cJ06hjmjFznMDsQCVOudRi3NugBAoGw2Ub4KGLbYH4ZNJWlSgutxml+Dr0Bke4xrNU3CPBE6n28MJKq0P9ctB4qfrnV8W5qxXV95uNtuVo4aoPjZCoirVXz6P7cZnfdAJQ5EFYc1h6pSnbDAeXqwJ0KOTsG2YM/QAqqAYm/QrkSEipRfjuG0OsgDID0NqcBxhMMM47SL8eRskCX95a5MZfJdcUSmUp5cTY7uQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(66946007)(2906002)(66476007)(4326008)(8676002)(66556008)(86362001)(6486002)(8936002)(7416002)(38100700002)(5660300002)(26005)(186003)(1076003)(2616005)(83380400001)(38350700002)(6506007)(6666004)(498600001)(6512007)(36756003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2XGhBXoD/lAZ/PO5HiM3E7RTbdY0T/YX9gMd52GLkcUNM6XUn34lGZp5+lqB?=
 =?us-ascii?Q?0hHmKXT5qsbm0JXbkQmBqbkrmS8yrnaIt3hXJcG4taMTcMy49AuhBHqttuPj?=
 =?us-ascii?Q?5CP1WfTCwnaXt+jtNYUuHM1De21P5ubqrpqZKMgSMjY4kCETYpEBTpz4gYvT?=
 =?us-ascii?Q?KAksxbKUm10ELwJGE8rSJvlYPi54PgOhcGCwcae5D4mOVGob/Vqaopt5To9d?=
 =?us-ascii?Q?hFNQkeyx22agIWpBqXisJ1Fc6tMCD6uGMx/JRxcCstAwvaXL9eNLIjfnJk1K?=
 =?us-ascii?Q?I1SlBJwzxWLUQ1XOfoWTeiloyxJCQGSkqUiF7tDx1uBCGhbZIR2Fiyl5aGkk?=
 =?us-ascii?Q?5J6rmBZGbayEpHP+3Dhm22uU3Fzn/onOYF3Bgf2kvDWbOY3NwHEc77TIqExC?=
 =?us-ascii?Q?cUVryfuJgxVbiJYoWX+gCQrSScrqlAPr1eeCKGANxwbN3+yD/mb6cGFsZzXL?=
 =?us-ascii?Q?gEvJCRT8VLIgIK9xdSYrr2APwPtLrILy5fk2yulX75K5Wabgj8qKcNLy7soI?=
 =?us-ascii?Q?dA1037TtF21OPsAXVXqcfGpd2TGoKfBeJx1PK1xA7Zq9XHnQG1k9MEfpazqD?=
 =?us-ascii?Q?G7EgdDKIrEiiMnIiZe71sm73fLVgL5zI+4kWGCpaRiSRweCudEHW2gisly0f?=
 =?us-ascii?Q?1QBPvUFpQ/19NOuahYsbj2S+5XB/9FzwlPoijZAXkGWQ1bQMXowTZictR8F2?=
 =?us-ascii?Q?C/m6Bco12FBXOU/IqDX5V4dM+D7CrAo1KaZhV4jjmjsfUkq6gKVwbHaO6eyH?=
 =?us-ascii?Q?L7/F3Qyf8rvNLg6LKIIQSYv3os+tLLQ67hSnhL/ZeYNRNWBwyz5OeVP2JLHN?=
 =?us-ascii?Q?x7jeVcyXFroSLChY55kT2P6ZgUbcjwbzfmdd/6bJ87TzAYd46ZEyrspvWBFo?=
 =?us-ascii?Q?D+FQHQ/nwswGhv3y3IhL8cqJxfyOV7oaNZjt4NZEBr6Ca/7GHv1d8ZllViPc?=
 =?us-ascii?Q?OdzL7jR+2rK42e2c5bQNtSVYFeBoQErgjIoZsJHmWLrY8B91oHfk4UQb/Wu9?=
 =?us-ascii?Q?J1Z6CJqruvf8DLW4Yq/Bciep8HPz4RNZ1DiOEgA5VuWfAQkrqlu4OZliYUZF?=
 =?us-ascii?Q?hoC4bK5Ltgkbwfr2IOK/PINT0ePvG4zmT8vS9ny549jrMRLI0J6AKvw0T2QU?=
 =?us-ascii?Q?ey/xqDmyCTBpv35Fol+r7zjbnlC2uOIS3dd3J6DxtDBwEyJB7eGh9LF9iobd?=
 =?us-ascii?Q?1oP3oBVbf7wqifv9yoDpsZGXYT2IQ9XhA0ZPc+pobW2MTdiKiQereVFqvJAp?=
 =?us-ascii?Q?axIl/L0k3ubuziOlrT/IZL0JQdncnei4ru8EM//t8VDfGdVxlxtWk9zVL6vq?=
 =?us-ascii?Q?esctAktAEnLL0DdtXWvdSxSWnLvQe1PGoGIp0nTGahVI9uHFDCm4ynI0lNZT?=
 =?us-ascii?Q?zEmqOb7HYysoedcwWfPaKh12n8wGBU7DnfMjtKSRS3f8mrqlcXn7PrrZrXr0?=
 =?us-ascii?Q?u17U6oDn5aa7u4T6NnwbB/u4YstbE3cGOS9zFH9Qax+1SAT6xST/vA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9828ff7-9da1-4642-d8be-08da035e5e24
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:55:06.9034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HCyP54ww0R0emgO2VReqUcvyzf1UWzMI83Gzm9rvxccJkX5ArtMACb6dv/VKho6WcB84OfVDNrGiCh2cnG6Gaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8880
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The logic to setup the supported interfaces will get annotated based on
what the configuration of the SerDes PLLs supports. Move the current
setup into a separate function just to try to keep it clean.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- none
Changes in v4:
	- none

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 43 +++++++++++--------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c4a49bf10156..e6e758eaafea 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -257,6 +257,29 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 	}
 }
 
+static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
+{
+	/* We support the current interface mode, and if we have a PCS
+	 * similar interface modes that do not require the SerDes lane to be
+	 * reconfigured.
+	 */
+	__set_bit(mac->if_mode, mac->phylink_config.supported_interfaces);
+	if (mac->pcs) {
+		switch (mac->if_mode) {
+		case PHY_INTERFACE_MODE_1000BASEX:
+		case PHY_INTERFACE_MODE_SGMII:
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+				  mac->phylink_config.supported_interfaces);
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  mac->phylink_config.supported_interfaces);
+			break;
+
+		default:
+			break;
+		}
+	}
+}
+
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct net_device *net_dev = mac->net_dev;
@@ -305,25 +328,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		MAC_10FD | MAC_100FD | MAC_1000FD | MAC_2500FD | MAC_5000FD |
 		MAC_10000FD;
 
-	/* We support the current interface mode, and if we have a PCS
-	 * similar interface modes that do not require the PLLs to be
-	 * reconfigured.
-	 */
-	__set_bit(mac->if_mode, mac->phylink_config.supported_interfaces);
-	if (mac->pcs) {
-		switch (mac->if_mode) {
-		case PHY_INTERFACE_MODE_1000BASEX:
-		case PHY_INTERFACE_MODE_SGMII:
-			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
-				  mac->phylink_config.supported_interfaces);
-			__set_bit(PHY_INTERFACE_MODE_SGMII,
-				  mac->phylink_config.supported_interfaces);
-			break;
-
-		default:
-			break;
-		}
-	}
+	dpaa2_mac_set_supported_interfaces(mac);
 
 	phylink = phylink_create(&mac->phylink_config,
 				 dpmac_node, mac->if_mode,
-- 
2.33.1

