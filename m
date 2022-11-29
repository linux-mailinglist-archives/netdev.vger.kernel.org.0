Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BF363C218
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiK2OOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbiK2ONb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:31 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1f::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9911D3FBAE;
        Tue, 29 Nov 2022 06:12:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaBdXw2zVmnYg8OK8h/nmYHuurjZ58eA+V1WHDF02KuGSrozp6fCLuNxZWrJ32ur7uA5eichVOGz4wb8G6nNjj27ujuzCY0yfmotDBBC9/8hJ+eZHqpYoSYH/Xtq39o+xUPOr2VYFCoWLnEYOQJ/eG5ZzDhvyjk2DBiGqUL7eZ90D4AZ248tYQRw63do80TejWhxwcgBRKnnq01Fgd5yIlXSC0WQM2mQ3SIKEG8OYsBuni0S4lXGSk9/ASW+4+IbVOxUVsfhnaq4JIw0WG6bacyQCI/L7wCOnMXFfUIuCPfu3HgTkH8XLYtT12PQ/UvppmMR8qygUV1f3HSBmE9d9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+NjQJ0EKVqLVx7VXfqbReaRqke6H97MkKptkAm4XOY=;
 b=AdjI6jQYXKR9KH5l4r3xKa7N2Ht/1pCVvn/mSZChai22go9dLe5PtN8/GCDVBoVQI84NfigONXiCKEFvVYBlJMOV8cp5oByd66I45ozZnGHjF5ROPXtHO57TavYxUbX0HAHJprIt31ikgrbc35gYyDUt3x+SB6VVgEkM7cEUYzvUhL9Bmg5LdJ8t6WXjaW/AflB/Gbbw88Kd89kXxnFkk9Q2GFfUx0r0nvtQYv1gyMYvc0pGRqqx8t7DBOaxRcj/4X7zsD1+FX1fHxbfzpW+owRDzQvQDyJx6qevjos2qidtEZexU5FY7Vy/eGYe5+tBxDaNiGN9BnKWkAWlEAIpPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+NjQJ0EKVqLVx7VXfqbReaRqke6H97MkKptkAm4XOY=;
 b=VMMq2SeHzcxHai008rlgcsGpgJw16mr1P3RNVR9WEnPWxZyjHraNSilY95WgC/kYjaEAld50lVLM1ykqTJsqx+n+pOHx2NmlilJuiebD/+bGeCJC/owwPHHVSnPb+gL3Q4vVR9fT2eF0irjRHkLHGho5LgDLRS165UwgEnBJF3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/12] net: dpaa2: replace dpaa2_mac_is_type_fixed() with dpaa2_mac_is_type_phy()
Date:   Tue, 29 Nov 2022 16:12:11 +0200
Message-Id: <20221129141221.872653-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 04543228-fe6e-4633-1b57-08dad213c36a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1M1YSCrkhFlxjqjNhF2UuzdTquTota3ic2p99B2p2t8UfXSPPTC3orvo3C6Y9RFRoeOBUMlzgY2SZX15hSLggMiY+KiiEWiQGRGcO+pADCm2PXG/JLAI8ckLLlxh9Zt7hdtoy16xWpCdlfKReErngR3BtL6GGlrHIUN3wJN2di8GYbI/ji7kqmBcTD81FtuL02Wqbv3TXgQp3Zm+5GjEeqdBA2Ojbq9Wx2Cz9cUziSa1gyvZGaS2Fl5sVrSxVYtdtjypTstnI+n/eeWi2ZVXfTsVLVbyprVaxEEpDjwsQn0g8YttougEhWaqjs+F6QsPJgQoj847x11VdThyGwknUSkVT5j37yY4VP6p9x+dlfy1Z/Rebhi5f1+eIyYo3F9l5CjtGknUEG1fi4LZm2bavIf7SEA+HBMTYCyThOiwdmA+hH1RiqMMHIVdVb3QQFztJUTHEquIRdLZWqRmj/5EZY2o/XxwXUeY9hAw59Zwtev0PsX6PXBMS+SlnAH4TrfpAxZJOyi2GDnJD6ryvGhCm4Wi+BlxKs3C9ciKu+hgiOxuBtRd53mthocvds1HloAAlxGf8qQeV+HVDal4iQuwyfMTt4q1MoTmFoaGnwa91CA6UCOWY6B6ci2E6q6/mQf3eZXajFGo+pQ2nu9QB3+nedaB2lJ6ZkVSY+TwPlMaf13Nk4YRGUlayLnzBBVXqXZy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KWPpcKAGllGRr4Bq8/Tpa3rfov+pBsL11oQLTHCzbS2yJKSDkbFF9rvwTp34?=
 =?us-ascii?Q?QYtPN26nh+LGnSBRyNOGxmw/8k08jsBOUK0nsnjIEBsSeXy7YTlBdukIGD7Q?=
 =?us-ascii?Q?4lzoL/Ps5y6ZEa6aCMjQ/T8DF7dzxVTdTtUuujgiNvLjwE4S+9GsfNNaEpaI?=
 =?us-ascii?Q?J7m+R36SIyjoqCf5tx1z54EKRhq+PGKX0rexfoU4x6sOeNRjr0k/5yVOvWOh?=
 =?us-ascii?Q?UbIr40tszDQtbDOfYY0U0EEE5olcuMR3FYAtGeAEO43ww0E+fz/VNJvUZVa/?=
 =?us-ascii?Q?65IVXZRSIgl8+21eEVZ81S9vRVEYpz8nA0pCquYLR+JSJevCEu6HktQTuiJu?=
 =?us-ascii?Q?Y7nEhZyB/NWIe9LLEJg41uC57/M4eU1i+854SI0XLfbdyWQXaAYXPxa4Pn0Y?=
 =?us-ascii?Q?jAoGeQ1EyymL1N2c+0BRpAidP4RIzXBCzKyGbEJ+qPfyTpA0463djeNaHeGr?=
 =?us-ascii?Q?S5/R/6U4dWrGN/MyYB7fdddeNwZlGr7LBk+ctoul4lXrHVbyX9r3/M6b69Zq?=
 =?us-ascii?Q?wvTuP3NcfwvB6KoBA0aOHdLBvf44UCvrtX1+5esJWgeAmdC9lbvFa3twSceJ?=
 =?us-ascii?Q?xVDwfIDLxDG62LPM67jHcQvAqlNt78TpsQyCpfT5Ew8CxJ0Bmx69QrDI9ORf?=
 =?us-ascii?Q?vfnLOmhfD5RInb5BJM8Oh4oGRbkjnckU54cujtyv0eiEXEiNguzPqPD2tVYG?=
 =?us-ascii?Q?wdvA3mUgD19Mm3FmBPgCP959CpO45W4aShT0egSsCmvQNp4bRJYizJEOrRCJ?=
 =?us-ascii?Q?cvRX50VDcYCn0ZgjnnADHCqTvu4q5ZdRlulK1Anmwp2gLoYfJq0ZG5VX2iAw?=
 =?us-ascii?Q?7AIAsbVjRomYJJnph8V2ImUxWoFa1n829Z2/2D+m7bqY7bNPDz8IKmZa1ZOG?=
 =?us-ascii?Q?neSz1xuwMcC8hF3wNX8ZRvjZO1/9a2BdiZQYI0nt0rFaejLfTPXYIw0W3ek3?=
 =?us-ascii?Q?EM7h46VOqRW2MofdL6c7gQyQSvt2Ydg76LGIBYv380q17O0nKBnEHSYaZ7XS?=
 =?us-ascii?Q?LQZGVH7gAUSBY9KHoP7E08sj5qw4bRVhrMjMZ30oJ1FSSaazoIbSvqm3Wc91?=
 =?us-ascii?Q?O/5lqxmDtk0ES67WpFFFj2os3rq/eUDFbmurMu8Xeh4GBtc5XCDmX7BlokeI?=
 =?us-ascii?Q?u/dFpfsYMj4MpACuG0Zs19zYL/Pex/P5+ca2IjjOqqaXjdU3CMC9lvn9AjeI?=
 =?us-ascii?Q?xevLmtHORK3MhSoF1ziH0S5BJOpkPVK6R1zXyf42qlIb4qzkdU2oYwhDry8a?=
 =?us-ascii?Q?MEXnsw+WeL5/4uY7FMr49r6+NITNy5kVXNqOB84SsxHZxva/WuwmPx+QWOeh?=
 =?us-ascii?Q?tUI2thUwkEdOxUQLYiLIAhlznAeGV9QAh2n6ywlmT44ITUwwVHGApKWM4edq?=
 =?us-ascii?Q?cpQaaml09Oglh5hj6NmLKjdbYo8WAqRIuxlEAsWpKqxDN2tzOIILAk8LDY1+?=
 =?us-ascii?Q?6gQEA2aj2U5GKG4RTIdc7L3FMvIjXhBPwSGgFr2mSGePMVWKka8I5LH+b4eP?=
 =?us-ascii?Q?fenr6Y8PBGr/o/kEeSS5SItaQcY8MaAlAO8CWrJ8D4GtmxanmnXitgvfIipe?=
 =?us-ascii?Q?K9cvFeT4DSO+2hP3TIDUz7WM/DgmPoZvYZ2ghxWZRqySz1q+ZcMT5QhO/nTb?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04543228-fe6e-4633-1b57-08dad213c36a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:35.2943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DveAA9Y5CJPyyJ6usU4PBlxEWYyDfu4DGpWee3zW35rl1MNamdz//84ZQp32USQszQgplBkASKflSn9FyIjriw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dpaa2_mac_is_type_fixed() is a header with no implementation and no
callers, which is referenced from the documentation though. It can be
deleted.

On the other hand, it would be useful to reuse the code between
dpaa2_eth_is_type_phy() and dpaa2_switch_port_is_type_phy(). That common
code should be called dpaa2_mac_is_type_phy(), so let's create that.

The removal and the addition are merged into the same patch because,
in fact, is_type_phy() is the logical opposite of is_type_fixed().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/mac-phy-support.rst       |  9 ++++++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h       |  7 +------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h       | 10 ++++++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h    |  7 +------
 4 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst
index 51e6624fb774..1d2f55feca24 100644
--- a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst
+++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst
@@ -181,10 +181,13 @@ when necessary using the below listed API::
  - int dpaa2_mac_connect(struct dpaa2_mac *mac);
  - void dpaa2_mac_disconnect(struct dpaa2_mac *mac);
 
-A phylink integration is necessary only when the partner DPMAC is not of TYPE_FIXED.
-One can check for this condition using the below API::
+A phylink integration is necessary only when the partner DPMAC is not of
+``TYPE_FIXED``. This means it is either of ``TYPE_PHY``, or of
+``TYPE_BACKPLANE`` (the difference being the two that in the ``TYPE_BACKPLANE``
+mode, the MC firmware does not access the PCS registers). One can check for
+this condition using the following helper::
 
- - bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,struct fsl_mc_io *mc_io);
+ - static inline bool dpaa2_mac_is_type_phy(struct dpaa2_mac *mac);
 
 Before connection to a MAC, the caller must allocate and populate the
 dpaa2_mac structure with the associated net_device, a pointer to the MC portal
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 5d0fc432e5b2..04270ae44d84 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -768,12 +768,7 @@ static inline unsigned int dpaa2_eth_rx_head_room(struct dpaa2_eth_priv *priv)
 
 static inline bool dpaa2_eth_is_type_phy(struct dpaa2_eth_priv *priv)
 {
-	if (priv->mac &&
-	    (priv->mac->attr.link_type == DPMAC_LINK_TYPE_PHY ||
-	     priv->mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE))
-		return true;
-
-	return false;
+	return dpaa2_mac_is_type_phy(priv->mac);
 }
 
 static inline bool dpaa2_eth_has_mac(struct dpaa2_eth_priv *priv)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index a58cab188a99..c1ec9efd413a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -30,8 +30,14 @@ struct dpaa2_mac {
 	struct phy *serdes_phy;
 };
 
-bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
-			     struct fsl_mc_io *mc_io);
+static inline bool dpaa2_mac_is_type_phy(struct dpaa2_mac *mac)
+{
+	if (!mac)
+		return false;
+
+	return mac->attr.link_type == DPMAC_LINK_TYPE_PHY ||
+	       mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE;
+}
 
 int dpaa2_mac_open(struct dpaa2_mac *mac);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 0002dca4d417..9898073abe01 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -230,12 +230,7 @@ static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
 static inline bool
 dpaa2_switch_port_is_type_phy(struct ethsw_port_priv *port_priv)
 {
-	if (port_priv->mac &&
-	    (port_priv->mac->attr.link_type == DPMAC_LINK_TYPE_PHY ||
-	     port_priv->mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE))
-		return true;
-
-	return false;
+	return dpaa2_mac_is_type_phy(port_priv->mac);
 }
 
 static inline bool dpaa2_switch_port_has_mac(struct ethsw_port_priv *port_priv)
-- 
2.34.1

