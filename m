Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A089F69F1C6
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbjBVJd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjBVJdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:33:04 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2088.outbound.protection.outlook.com [40.107.15.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43303929F;
        Wed, 22 Feb 2023 01:31:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igJ00wVpLN8BqUJGRL1kCNLh9aQs5WUHMp5brskLFFJTsEjjOvSJ3jNRuugjHkvGp8CgvIMDcZEeAzzp6LaFVW+lzM40A0R8OVgjlbV0Tqk2sO621zNr+Wl9CxXMb8Ks0BD2IPuVQPbEG4HIp2MaEY+Ymhas9sHUc7etQ4Fq66oYYNtyOskL24vGJCIiTW9aIfgCGoSsHXmLvs5470hqFYn6kRWboKfJQ/mIoj3FwQAJjckZVRHTj+a/s7t3lpRy3NC5wMGeiyXQkl6qhwts6+kejUViam+rgSylcxwRBzAuVfyg6IYHQNtB3cXggFYV4hlRSU0jCT1wArSXIedCYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CyoynQkskN1O4sEggNgAldSJwdQeO6Tp+Ujrk4hI9pA=;
 b=VXgf9mH9W9FsLiKwMBvpG5zHJMUCFT18bcVoVHJ6LKQX6pprizSJQ6exd1pK4vh80odEDBXe68nD7UHDgwCdY/eRdAHObLGoYZlO1MgvyRcJB+3zj7tFS4aJn/F849AUqXhB9ZjjAOgIBPfcDSsyD7Zkn7B0BXiTvNOgMrUSHP2ZJy1oOYnMU1V8Sw+V6F0zlEtf4PsPym9CrnvUYPg8CLA+c0eiGbJaofZ06IgHyhJ+/ToXFn+5VCNVNzrkrDTe07mwLiEYJmtCvGTZ5vYwSnFbzJLpu3wG4ioRYv00s5dTC7SYV3n10UsowsfHF6HoJIayvw7/M5EF4RtHU4sYYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyoynQkskN1O4sEggNgAldSJwdQeO6Tp+Ujrk4hI9pA=;
 b=VslS30s9Ao4JrvfbGZutBtyXYnB9DnesP1xiQIX1Chz8C4pm+Y+re1T2VJnRq0xTGmFVej1NcnwD3hiBYGjQVjTPv1QOkFRstVbah2jKqgKOX0Gt3WilvQqLwFM2xykKDEH8GQpD7ZI63MFZ+P1FqtQR5UYzE/mDJVkGVMMI0Pc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by AS8PR04MB8468.eurprd04.prod.outlook.com (2603:10a6:20b:34b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.18; Wed, 22 Feb
 2023 09:28:48 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1%4]) with mapi id 15.20.6134.018; Wed, 22 Feb 2023
 09:28:47 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net-next V4 2/2] net: stmmac: resume PHY separately before calling stmmac_hw_setup()
Date:   Wed, 22 Feb 2023 17:26:36 +0800
Message-Id: <20230222092636.1984847-2-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230222092636.1984847-1-xiaoning.wang@nxp.com>
References: <20230222092636.1984847-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0001.apcprd06.prod.outlook.com
 (2603:1096:4:186::21) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|AS8PR04MB8468:EE_
X-MS-Office365-Filtering-Correlation-Id: b0d58544-40b2-47d8-7dfe-08db14b7335d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QVk8PgwEhSfq4UT0n2QMA3RJq2qipHuId2OqBYxf2RoJGvvIiOgAfY9K3kmn6hkADYWJaA7KAbqEAykuXJ73eiAelBNwzSJH+g2bP1U3zqlnTemXRVZyBdb9cm2kBHwN17OwLtezZ/BqW6EFDB7pqaG7HSwgV8ul/yinwzlSzVdncRZs2td0SRyBeEB15IzLqAREEAD+8IOYSgi9CYOUcZMhLbFdB+HtklvIS/l/KG+1mF4fvZwVoZjyPEaWCoyDDRwUQ4AAUKvsQijKPPijRY2ZZyXqAyr7acJKp8GFWnwcKYXo51UvV2lByUdjpN1y7R06mZk9s0SJxZmovEd+aBSUFSCqE48k6r06we8uszND42dFc1Z1Cqo8dobia1nd4JBVwvxmlaUWOJv7mDJyMYVRXkI9u4LyG+HoURZNvr22ltxSzqz5QAJLrTR1+RLf7Px5iuT1vfvCZG3JZc1ZbiXt/RAkqmotP272yPzDiULwaskr73fmRJiuWpxXjN9QLX67ANcggHJEIF1gq26a6SbWuAygl2cH96uGfqvaO2Ae2uhtHBgPR2tf57VmkWEvPHJOIio+Dj7FZGb6ikpoUMYCktO1vzEfyYl2uUDICo20HYI0tMnZp25aLyIk95tQ9lFBqkxXRskn/PPOgDE3A9H4svp1Glf2+gBpJba+Egxt9OnWVXASI5myJNjr9LAell7RzVjK3uz5GNYjoWkJ7bGK5SIiJw0RUh79SYewZH8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199018)(86362001)(36756003)(8676002)(6512007)(6506007)(4326008)(186003)(66946007)(1076003)(66556008)(8936002)(26005)(52116002)(41300700001)(2616005)(6486002)(6666004)(316002)(478600001)(38100700002)(2906002)(921005)(38350700002)(83380400001)(5660300002)(7416002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tFc+Wx/10YtwNqPwdyzahO4huoPjifH/fqId0n/3TUQF7gPm9Sit/MrVVnuc?=
 =?us-ascii?Q?PM/uIJByzFUU5wESd3+ZFDlgt8v3p+r9eZdGmb0gU9mqD+TlV1FeekPrKIWp?=
 =?us-ascii?Q?zP2kJ5oRDGSUm1TJRvU7SMzwLMfSlWcUXhfOjbhZvjFfrc4ykzd/37296EXi?=
 =?us-ascii?Q?f64c7xsE28hPUScZh9yu1s0dhsXXgy7PWGFP8Gv4CVUUY8AECvyHKMpXmP5E?=
 =?us-ascii?Q?GlxDEOSMlFVSpTo9nQHD8wESmPTgyz9HzBQjBAW91e2IuUZ0H/WhGc66221l?=
 =?us-ascii?Q?SWS/2Fqu8UumcoPhxZKPJ8NwM08Duea0Es4FlG9pHlKWv6PK/MCR2AS+5lpT?=
 =?us-ascii?Q?slEy1fzQBdXTlKiuny2QVLDbnRgmRi0ZV67OZBmb3pdXCvd7/BC0hZ19mqgn?=
 =?us-ascii?Q?M0SJdzk96kP9q2FUnLbyI0ObBRHLLAh6xtqwYbFr7zUIkhHi5JfO3dBhXKzp?=
 =?us-ascii?Q?gAU/D9axKnsc9pQ6R0f0dnf7dgZAsp9G/5E7nHIYfd9CCSqjzHmEXURHJ40u?=
 =?us-ascii?Q?ghTR2osayhNteXXC3TxWtmatjupbyK8mJZ8xo5D1kBsB2xg4N6pVViEU5iXT?=
 =?us-ascii?Q?i6imYLHRi9BT+B6u37IVYyyMPmTGDwkjGlNXSSlRvruKHb2CCkaXVHZPwMTK?=
 =?us-ascii?Q?sJD6webwEfbmBl7BugRcT3LCein5A3UwxUIqcAj0dLRHgzOtS3Wol52kogSn?=
 =?us-ascii?Q?/ZBIVGAmbjwKs+E8pS0LeoAWTHlgnmUnYjR1QZaStei8nCo1O26uHLhhj8/l?=
 =?us-ascii?Q?Hu7S6LuNCHbNc2tcFJHZIB6FELL7jTFqxlFhpVGHwW1s08WlrYB97UI7DvlQ?=
 =?us-ascii?Q?teAqpk0kiXlUHhDaIHCBXvrRNh9HLhu76fuijeo6lLXBC/qogWOB8rig+h2I?=
 =?us-ascii?Q?Lzf1UZWxN7tTkyAGcAPb5z/+aRavRE8V3cN6s+XdGm9QgoM6DQWoOdAAhxiv?=
 =?us-ascii?Q?rGEGe/f//wmxZc+l2LERI2v+9jyaa3KEN+9go/8ohb5g/J138Kzs86100Wx+?=
 =?us-ascii?Q?YBakRMuUvOVQL/3XwmKj+e3s12R1DzNacXRW+df75uO9ZluSZSydPLih0yax?=
 =?us-ascii?Q?/nveiworvOP0A7JBrAszoaPCa/dAA9v8ZWUob/bEk1h+dUm5C63Rs3xp3YUu?=
 =?us-ascii?Q?M6YgfQFPxl2d6HbNSfIDfQxHYrOzUHGWkptBgtXjDSOejL2WlXJQRw/6dZFv?=
 =?us-ascii?Q?Xiz71Pewd4vH6663G2VRR7G2+Uq2lzvA0df351sL6jImJJlE7/Tut3pDWYx0?=
 =?us-ascii?Q?o2hNzhCv8HrT55b229GpNaAEKgvhEciXdwCa8VIsJlhV02HTen6d4eqDtMQx?=
 =?us-ascii?Q?07f0Dj+vvE6V16or9qRt82OgQIBkbaYYrlh0ocUTxLWEB6NN22qNguC3nQCX?=
 =?us-ascii?Q?rfIlSZVsHUze3ihOQI5SFwubkYFBefnQ9peTHjRK+hEbPIWFWWE3TlsnETrC?=
 =?us-ascii?Q?2z6cqGucqdS1/V1J13NULCc02w0eLfV4F80d6yhREG1nrw3ga9XrWgEFd5dy?=
 =?us-ascii?Q?ZV94jAoa/U0pBwOIhf43uCPIIjThyKfNtKZq/T/MCsi6Ax7GLuNQpqAPOWhS?=
 =?us-ascii?Q?qkpXacBQmFShJqdx8uzx5NuwR8KL6ADqTxgrfzzdNJe4SYIUXRsSSPTki9Ae?=
 =?us-ascii?Q?og=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0d58544-40b2-47d8-7dfe-08db14b7335d
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 09:28:47.8580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMl89UcPZE78ujwogS0UCzig8xWSpqFj8aEachDAtJJZmPWe2CE542WCB+bTkS0KNpQ9Jjeeibd6/3XWXWYvLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8468
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms, MAC cannot work after resumed from the suspend with WoL
enabled.

We found the stmmac_hw_setup() when system resumes will called after the
stmmac_mac_link_up(). So the correct values set in stmmac_mac_link_up()
are overwritten by stmmac_core_init() in phylink_resume().

So call the new added function in phylink to resume PHY firstly.
Then can call the stmmac_hw_setup() before calling phy_resume().

Fixes: 90702dcd19c0 ("net: stmmac: fix MAC not working when system resume back with WoL active")
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
V2:
 - add Fixes tag
V3: no change
V4:
 - Unify MAC and PHY in comments and subject to uppercase.
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e4902a7bb61e..75857b85921a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7541,16 +7541,9 @@ int stmmac_resume(struct device *dev)
 	}
 
 	rtnl_lock();
-	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
-		phylink_resume(priv->phylink);
-	} else {
-		phylink_resume(priv->phylink);
-		if (device_may_wakeup(priv->device))
-			phylink_speed_up(priv->phylink);
-	}
-	rtnl_unlock();
 
-	rtnl_lock();
+	phylink_phy_resume(priv->phylink);
+
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
@@ -7568,6 +7561,11 @@ int stmmac_resume(struct device *dev)
 	stmmac_enable_all_dma_irq(priv);
 
 	mutex_unlock(&priv->lock);
+
+	phylink_resume(priv->phylink);
+	if (device_may_wakeup(priv->device) && !priv->plat->pmt)
+		phylink_speed_up(priv->phylink);
+
 	rtnl_unlock();
 
 	netif_device_attach(ndev);
-- 
2.34.1

