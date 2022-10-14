Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0E85FF094
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 16:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiJNOsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 10:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJNOsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 10:48:01 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2075.outbound.protection.outlook.com [40.107.22.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5384E12276C
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:48:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0nU+LJ5GbnHjFj9GJ87wdEVB4CmPP78MBM38YK3D0rywB+OjprnMr2UIvin2M2WZXUmcm5j475JU6xLkOqG1xr9ThCTZp55e+yxbGDyyBw86UmEyi4zPucG97y4U/DaSkyAwH4IVt/NKgM1AbLn5H+fEX2H6DO6JEJgbK5oC+e+1IW+ZbUln7+f5tlw1l1/vJdRmuUGUyCrBJZrQZSu0wSgpxglCQtUgqGiOWUnniNYAQVj9m7kkF1PLfUBxQhXft/TEjm+pEnTgpKAb/EwnXVlmgvMNWYYPvsH12q1pxC4IfX6G5rpzqdSLcFjvBOfk85MQnwhTIOqiSGlmzBDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zXpqBtyPNuoWVfZalO0ZM7IaWoccbLHn57xW+ra1RTM=;
 b=OsLEEgr42HVayvLvJPLDeIoCavCy0zTZ+kM5ZzOUPMwwV87F5ACPQm0ErS/RKME5CrUgb9suapieewxZMJBQtOO9QghdwAE9ItfeyNaWD2Cn65DLxTbaEi/XwSG0UAKQv55j1kuZA2LPn0Svg+OZjNvVGkwYi+EIqADNbTjiko8Tnm00n9lK5LslNZRFGNqyq4hH22tEZk3dJuDAJhJAt7ic4eIfW3DK9MFq4GeF56EIzWESF2NMJzFSJRXVRBWyrFKXfbgl/CEuHsmNVHYqkmAUc5MYZbwoaf98vpGHf62VuSI0xZNrGX77rvXvA0/iQFTVxcYvWPjwRUaqjJiq5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXpqBtyPNuoWVfZalO0ZM7IaWoccbLHn57xW+ra1RTM=;
 b=ACpHDnDZVaYJdlGuwCT/3HgEw+LdCMqc3LTjL/OV39LRJ/N79HbCZyj7xRnRWSW7OhuRHB6yY9Nt7/ZgPyjT3J+Du8eq106UID08ts9Jz2Ra1UcZCwCO8i8BSqQ8zFyY28u/kxWFtr9uS/KHd6tZ3/uR/vu5JgwBRUfupntWfwY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by GV1PR04MB9133.eurprd04.prod.outlook.com (2603:10a6:150:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 14 Oct
 2022 14:47:57 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c%7]) with mapi id 15.20.5723.029; Fri, 14 Oct 2022
 14:47:57 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH NET v6 1/2] net: phylink: add mac_managed_pm in phylink_config structure
Date:   Fri, 14 Oct 2022 09:47:28 -0500
Message-Id: <20221014144729.1159257-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221014144729.1159257-1-shenwei.wang@nxp.com>
References: <20221014144729.1159257-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0125.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::10) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|GV1PR04MB9133:EE_
X-MS-Office365-Filtering-Correlation-Id: a2d8a2fb-7104-4ed2-dfb6-08daadf31487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ArFnG+xxmzn1U13YpkzLJmUQsRhrZYDZWX5JXurAaZiCwGy1vFwIiNGI1MLBM0oAimfbW/u5vMDEWt6cdYvOn5mHCP5I+IbXdry1tHNYjIxRccWWaAsMosYJ6plXDN0/K9W9Gs9b3+iM3UDZBGf4w9bzcw4lxoJODTSdOENHgDEUYYhAN1w4uX/Xsc1VHF8UNIVpMC2kvHru2lRU1H1ulSrlvI6FVv2l7I9uZbvRRUNfTnMschtG11uWBMnJaarTV78bu28NRUtfs/WeqEmeQWWVqrQPNJt432SUGnjODaCTKV30N3h7zXzS+LmLrLUPe4VfamTeco39D4QWF9b1FbEMbgEI+Ya/9eewQfX/5S30NCtLbRF0ws5gJx0nWfZwlU1+sj+xW7lF1J4/c4w8VRdXt9NsaJzQv0hV1ZNChppFhrjfm+LszQ8Fbktaz8rFLMmOEaPQpLQfE2/htJFCEExkGaCferoTV7VrQxPEqC94u4ekszki7kFSyPOWCNyZ5HQzNmTKYbp7My3wCqrk++AVyrwSe6+djb9KSWOBzDQs1CYC0dGVIRZNkhGnV8m8wWA2Id9yC5j5sJjuwXez7tkPUSmuOMQrdId28za1MHMxAtSffz0q1oeJ2UlRaY1mk8El47wFFBdgRYIP8aqcurYrtGtWVBDCb352cObMOdWTcyYmX5NcKdynT4z9Ow5O7Va9XbSmIGREx64+y0fC6+pgyDurHjuwFVm/a+m5kF3oWhN954aQIFJAeEKBNk3M30BH21kC05YTTEYs+t1TSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199015)(5660300002)(36756003)(8676002)(54906003)(41300700001)(6666004)(6486002)(86362001)(4326008)(44832011)(316002)(66556008)(66476007)(66946007)(8936002)(186003)(26005)(6512007)(38100700002)(7416002)(52116002)(38350700002)(2616005)(55236004)(110136005)(1076003)(6506007)(2906002)(478600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T91B7owAX3Y2QVRPXMC+ZNgpnSRnLOzwa54sjGlz5dx6eGw8Qn8CR9xtYhuR?=
 =?us-ascii?Q?w7X1Iy0J/EHrsogqbdt591QHqrHSZj9Swl83VPwVnuCMndQdZZZoafc+DKNP?=
 =?us-ascii?Q?1hpRie65LSioMCToZAa51KAge2TpHGQFJDeqaORl7zCat0q9MXZYZ06aSl4g?=
 =?us-ascii?Q?axybiIDImCR7BHLVqqNETxzie2kcbEBBpMCFYP78sNKswRBUk+P2kazZokCz?=
 =?us-ascii?Q?D61p8ijholEEmaWTEkEG2T8qQ3SnSxtpqNt32iaNHLjuZ+tYIcC9Pt8ycxO0?=
 =?us-ascii?Q?qdUHl8yAWpXoaxnuXnbXVUmuZBLvfkS587MljZfCpexb16tIWifa/VwXcFYc?=
 =?us-ascii?Q?ERqel6LWmj7xp8NR8ndXXC/pZvqxNhdqHockFVC66hMqPQ5p0ca+FXZh94P4?=
 =?us-ascii?Q?82DhW8I96nG4gkIe+nJwYok5xJkFEfN0IuGUa8QJvgkPkoChfGDe4HNVM3ST?=
 =?us-ascii?Q?wZZ7j29pDQ4lUyJhVXgS11zwPBQvb3sV3IDmck6cb7moOH2HkeQgqI5y1Mx7?=
 =?us-ascii?Q?KQijwelSAOUI1JHMcUhszWL/QY6mD3nN/9U4U5dhXnn8H6HWyHEi7px/fCJr?=
 =?us-ascii?Q?N5RBEKshjuKyeE+Dqd44cCQzSnL8+FGBXQIMcQo6N2PlYL4bRuxh/km9hqaj?=
 =?us-ascii?Q?KDf6y6TEhjcHu+9A1c9QdF84As2xk/UjCQ+ljHLKhvw56is8EJObnUh4U7QQ?=
 =?us-ascii?Q?29Y9T1LEjFlfLSUnB5wgOkGSrO82Mo7XOzgbN8tPcP813heZWPI7xSgA6hFy?=
 =?us-ascii?Q?YGsYiq7yQLkjpYmY5L2c+LeBTXxMOlL/xc8woRDl3E8/6ILncpH9n6j6Y3qc?=
 =?us-ascii?Q?WniitU2x2NJKw2cj6lfsi+gs5EZKIYXYeIvFMh4GJEHGbns8FCR2KR4Yv1Ak?=
 =?us-ascii?Q?avf905FLfClAlq17jHH4Lmvlt9c2fYUj9ZLd+rMBQxef7nR/ZpE++y3sCnvi?=
 =?us-ascii?Q?9+4aojrg24lnnyi6I3fzFveGxQTBJzeK0TcSk6phrjRl/D8vSmuFvhGVF4NI?=
 =?us-ascii?Q?HXZxPSVz3KPV1SrKjUGJfCfbRQSBTuSymlExpiYi1wZz4jL777Jc7UdjVR9W?=
 =?us-ascii?Q?1vTDQN8QorJj64GJw9HdDPmIVPC+uLU3C4uXSpK4PjpI0J50fyllnr5OpumO?=
 =?us-ascii?Q?824M5IRRdfQ5RK8LPVHTOqDUlLEbMVwzMNiWgFhSXJQscheyyX9bVxZ0XD86?=
 =?us-ascii?Q?UOk74sthCKBxInKxmnWO2uVkCacyDOF9cMAOf/+39kG1KynN8xB6fLBjRJsd?=
 =?us-ascii?Q?Fn5jE8sg4H40Wuyr972ct3BbSdaOjFHSHuv1aok4mM2fMhP1vt6dNH2wSsk1?=
 =?us-ascii?Q?+1FFbIfSdvwIm+RkBC/M6EA+BNrZ7ogbDlB/FdVCMDkKRmd5lVp1Y/qVdI7c?=
 =?us-ascii?Q?mCpb/qkqhzX1A6t09vgZ9XexrjxBtsr7eySQKyw3hiDmp/Jpz1v4tCPyexyg?=
 =?us-ascii?Q?+U1vlyx+CRqQOmUI+BRye/Hb1kwRc28IqE8wwYwBeDh8hjwlVvxsnI8ysy/M?=
 =?us-ascii?Q?V67QDku63fAHIdXOlpZBD+pFHvY1sUzgXDB92VUTY79jo8A2AdnEcF7saV5o?=
 =?us-ascii?Q?2qBtzJlczseQ4rPsLb+6rvTiOXc43mrCa2V0XpZx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d8a2fb-7104-4ed2-dfb6-08daadf31487
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 14:47:57.5885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRt/rQgqQ3hWza6ODCZJqPnpymOuQrk1gfKtcSuKPU/S0oOpOHt+IB2DkhDIsKmDcTaD+V7VC0n3wQjDWRFyYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9133
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent commit

'commit 744d23c71af3 ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state")'

requires the MAC driver explicitly tell the phy driver who is
managing the PM, otherwise you will see warning during resume
stage.

Add a boolean property in the phylink_config structure so that
the MAC driver can use it to tell the PHY driver if it wants to
manage the PM.

Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 3 +++
 include/linux/phylink.h   | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 75464df191ef..6547b6cc6cbe 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1661,6 +1661,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	if (phy_interrupt_is_valid(phy))
 		phy_request_interrupt(phy);
 
+	if (pl->config->mac_managed_pm)
+		phy->mac_managed_pm = true;
+
 	return 0;
 }
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 664dd409feb9..3f01ac8017e0 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -122,6 +122,7 @@ enum phylink_op_type {
  *	(See commit 7cceb599d15d ("net: phylink: avoid mac_config calls")
  * @poll_fixed_state: if true, starts link_poll,
  *		      if MAC link is at %MLO_AN_FIXED mode.
+ * @mac_managed_pm: if true, indicate the MAC driver is responsible for PHY PM.
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
@@ -134,6 +135,7 @@ struct phylink_config {
 	enum phylink_op_type type;
 	bool legacy_pre_march2020;
 	bool poll_fixed_state;
+	bool mac_managed_pm;
 	bool ovr_an_inband;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
-- 
2.34.1

