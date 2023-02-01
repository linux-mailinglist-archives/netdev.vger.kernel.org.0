Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC1768648B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 11:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjBAKlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 05:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbjBAKk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 05:40:57 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2048.outbound.protection.outlook.com [40.107.22.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3571A493;
        Wed,  1 Feb 2023 02:40:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StVX7OCccLWMplgA4DyyFXEQzTfhNWQMBRV69ngKJJA2Ng6b0Mf7L6EHNEy3OJNljHUrZ+mHVyApf/grdOniByGjMEE9Zo2J6ZOylRzExIZKQTt78wgjfGXPTnUhQoBzVyDh6otgtESRXGCcIgBIE8qoxLnI2wuCrfMaq3NPaV6rq/4vkTLoaI5rm4hkkcqwQQD1bG5Pd+7EZjuo7VF16WNSQD7F+LLa7G641pPd09/LgPuw1XiWw4vA9GlmojPvabTizgTg60WNzM7cG0IVABaFycl02RZ13AzMcOqlLaYg5GRp6O+1mReFlCDeF7L2Eygejd5sQiUJQT8pNEuzRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwwUtue5wCR/qrDcBhsSwW5h2f6WGLFH3hwj2kVLT9c=;
 b=OQGdQ4j0WrMuXcyavZA+cwvSE1+L+ISW23l4on7vbuWgv2gknYbpfGoLEQNFuo0nejpI/zO2W77E3c7gIa3BxcChczO3D4zTWHYOT3UAitm/n2ZVNdACo+gdNS8bPghyhwW2ISjvK3OGsMd3hTeET3FDrdJMztY63T1kuJOJdrK7suvt55NkAJz6vSGNxS0ruFL6pXS/a3D03Tyun4RUTSsgYjvEOSVVyKWZ4RBkhK4HZuqTZtvyC4JZJkq15ck7LoY4VyS6wCKWJVuAYMKFhKnmRdZByIaALgJQbg/UT0DSkEHcpP1SOUK/Se7EhDbQ84085U4BEBxV0bo6C28UVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwwUtue5wCR/qrDcBhsSwW5h2f6WGLFH3hwj2kVLT9c=;
 b=lNlap4bT1Vlx8jKZIDckdRxAxzKrPJYAJmBstz7CsPCPqVD2tOJX9Jt/KH9hFaGBrZcybAQSalwOLsQ703Hz2lj+F8U+3Zxwafkj80CaY2OqzFYJcBtJu3KPC28Q5DBsssYx9QgA1V8OmsC8K3OIiRVO3vUDt6RaUn7MmpLaV7g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by AM0PR04MB7170.eurprd04.prod.outlook.com (2603:10a6:208:191::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 1 Feb
 2023 10:39:34 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1%4]) with mapi id 15.20.6064.024; Wed, 1 Feb 2023
 10:39:34 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V2 2/2] net: stmmac: resume phy separately before calling stmmac_hw_setup()
Date:   Wed,  1 Feb 2023 18:38:37 +0800
Message-Id: <20230201103837.3258752-2-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230201103837.3258752-1-xiaoning.wang@nxp.com>
References: <20230201103837.3258752-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::14)
 To HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|AM0PR04MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: b3656736-c9a7-43c2-b6bd-08db04409bd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NbSxE4ILXDYrQEhdR9CAP56Wlo1KkVuFLJuQ2/lUlr6CQdE1cJqnMIbwR+jokMnz7PNn73EADnOfcuLqolmGYsA/wNZuXJ26wybxvsSzKda+Vj0wlPTP4jySQtKkqcICNVuPHsZmi7Kmw76TvqHdrncrJXwg7z2kFMP+dGvYUHTa3PVkVhRGG5slfewMG40DCyeDJ2HtoWLIkg0ITaMDHAI6cPb9np4CpFFDtVK8YL9F+vYzHzZ++i0HeYSGxp/FCzqs9q3LkpgHWHH+a/p7qbOpWHtMbYR5y/ol85fcwIyJ59KyvwsRV4vWMQgdBJCTwZGnfPZBhiP2A4A1/rbh+CtpK3xu+7PNEXUD9Gs6ekyoMWTysqW4Fe8Sw+RR7Ffc6fdauGQsTEP8flxcTfUT9afViVd1T3Zh1IXETsmMx1n0owL6UrNxHsD6y1QqW6oIFgD5OlaEbXcHkAynfzUquWnZpCoH1G6Z1XJbmRjDwdGYS5n9ZkfM4SWdAsIi0Lu7XOuT7YH/xJOSt6FM/YAMO5Q5DQMk962+En+MvktXnWT4xDVAJb/a82qwVlvfh85v80Ixnv2+3J1AIDANYSqZQeCXwJ7twv6eAsuaVUntBGibKtMzYVkhEw4pNmxuyhYfn4GuJZrGXvrxk0gOMT2ZMgedV8oshS4ERfH8wtlDPjk6Pv7O4zngfd2P6y8qrEELW5ekaPaQxe6w35/3oyhEefiSllicXcCTRswMLvuMX4Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199018)(1076003)(6512007)(26005)(6506007)(186003)(478600001)(2616005)(83380400001)(52116002)(6486002)(2906002)(86362001)(316002)(36756003)(8676002)(5660300002)(7416002)(8936002)(921005)(66946007)(38350700002)(38100700002)(66476007)(41300700001)(66556008)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BW9umz8DyjwUYSTTxl3DFZ2Bzmai9cB33eC+J/Z8h3xXMXi/FPnhjZJhIsG/?=
 =?us-ascii?Q?1rqzFoytPLiCBfsMptYfslVYT/4q+/Ot4c+zGQy26h4jYbmPIL1Sym9CLdNh?=
 =?us-ascii?Q?/iNfPU2koiXdrQfO7BkvmDuQQ4qKUOMEwWEUf2Ii4T1WVTmM8jwf8w8HqxcF?=
 =?us-ascii?Q?wL3mxF76+L1SRE58zRZ09Pyg3VuqNDfYKjPkCMPOqNbqxES551mPqtrXvPO5?=
 =?us-ascii?Q?c1Na+V1QKUYKoDTdvazeo0ky5gFIfqBTZU12F2gKuyWr1utcGLak9xQmL+lC?=
 =?us-ascii?Q?5+lXLgmPFsT6JSLPoWFVh3JM+6ZDA6Fnxal4gYGhdiBQZLvRBlz6XcZ3uz4r?=
 =?us-ascii?Q?B43Gky+iMV+YcqtY8253KUmPLApak1fCjhtOWnpwvOdyuAyBSv5ZTxN8DDLg?=
 =?us-ascii?Q?/qEysJL2V3V8MF9iYOnqni/c6kVASKJPFc2j/S1QAubkjEmJqco05yjKcbQS?=
 =?us-ascii?Q?Pu+FWR0nYmyiULYeRH4WST4CDbS8uXVzyiwUbbuxIMgGxnZGX39ribMxckwc?=
 =?us-ascii?Q?SgLHUT0l7NxuWoGbJ4IBs0J7aBos91ir+udkF+y+b4mRPT0THC1wy/ctOKHA?=
 =?us-ascii?Q?nhfxc7uBVGdIHtTStIaDHCKA+NiJzyspk5LWmRszri0/X71Y3rbIF5OZXYhP?=
 =?us-ascii?Q?U129aqgFPXpjTO6hfJu7w3QFG2R+qf5hkn73dBaBbRT8GUHjL9dCCejg5mKB?=
 =?us-ascii?Q?9onD2E3lsEp2IqFuV91A23DA02GdywWfMD6NhuW08WVHvuGzRhQsudp+voY6?=
 =?us-ascii?Q?NZI/OAgSHm46rXKHm17UxfC8is90820+qu5ekAFUJpmz9W5R0APiapafC18I?=
 =?us-ascii?Q?ybrvD8GgrvwNuzksk2Eyt34oZVBoMhfcJ7hCXozreBYWaGP//2EgDHpEQg78?=
 =?us-ascii?Q?HownrZghbbHMH9+XpRGF3BIwT4RN7+LoZ9YLcb+Yr8MZzBO3AySSxybbDqpJ?=
 =?us-ascii?Q?q61EI7LKjSdb0A/rFyfACaFSwF/jMgugYL0UQrmzhQwjdnAgw1mhQJkjw+x+?=
 =?us-ascii?Q?AyhW5ZZl+P/t07pV+7yOCiN8J5WV9mdaxav6GZleA1OQ6G/SXx+vAzpTAsM8?=
 =?us-ascii?Q?RsXxmQeqmHAk7uNWSezVoCCKQUlwB2ENGi1Tn7kH8TalTrR+t4b4VVp45ycF?=
 =?us-ascii?Q?c272+oHn+8dty1YMh/71TQDwvVfq7Hgh62ADB0/p9PW300wZ/M8XaokhrFMo?=
 =?us-ascii?Q?cvpsSiK6Nq6teDRD8vMFd16JhP5Jqkt6ZpqRlB9vAzGuXcRxyydemFINP/aS?=
 =?us-ascii?Q?Gtd6+A018iN/cL5WzgNiEHKrjmsyY8z7WW3W9tMrskPlMzNEHGGvKgguJ1gN?=
 =?us-ascii?Q?oqD/cHO6eJGPrUnay7BROnt08aMDisPTT/zk0oU4pqu+1HzjRcS2DfXA2Srd?=
 =?us-ascii?Q?OlkJ30xu2VS5nauoE7wDL425hJLJRXmnXJ498qIibvCQMuuvSKgmVQL+LDSR?=
 =?us-ascii?Q?W3JuVd34eMPq8m3jWGGCs78OwgowU9ySr4vJtC6gs7irKy+qVN8l1lhvGLAE?=
 =?us-ascii?Q?Pq1JY8vsTDfSGJfidm3T+kWD4spCC/zjdSmYDwmUBknS582LfibpuwoRrmtD?=
 =?us-ascii?Q?5M/YwdI6SzaYc2Emntc5mcJiT7YcxznztPGPG4ZW1wEUbLa7ue1s/t91UOeS?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3656736-c9a7-43c2-b6bd-08db04409bd4
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 10:39:34.4383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i35yVUcjEAlApECkRXt9W0jdZHSRyH4+1GRViyOhsDL0L23Dm3d+W9n9ug9uIm4OaiFSIaBL7KsVfz3IRetHYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7170
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms, mac cannot work after resumed from the suspend with WoL
enabled.

We found the stmmac_hw_setup() when system resumes will called after the
stmmac_mac_link_up(). So the correct values set in stmmac_mac_link_up()
are overwritten by stmmac_core_init() in phylink_resume().

So call the new added function in phylink to resume phy fristly.
Then can call the stmmac_hw_setup() before calling phy_resume().

Fixes: 90702dcd19c0 ("net: stmmac: fix MAC not working when system resume back with WoL active")
Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
V2:
 - add Fixes tag
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1a5b8dab5e9b..38777e408d96 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7538,16 +7538,9 @@ int stmmac_resume(struct device *dev)
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
@@ -7565,6 +7558,11 @@ int stmmac_resume(struct device *dev)
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

