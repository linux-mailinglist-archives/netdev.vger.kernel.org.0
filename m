Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62CD686484
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 11:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbjBAKk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 05:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjBAKkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 05:40:47 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28E310AB4;
        Wed,  1 Feb 2023 02:40:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8nwaQ6cLvJNzCrM9+G/9jG6ptw6rLVW/gZtahiOd0KykBAih6tgjkmJRMbUDqI0i/wJqp+pflXgLLAtidkj4TuGMSISrA3A/T2D65O4wsIAO2wQhJifuqP/aQMsLLrHSFkdw8jZtUNdMAR4FJ/Mm/kxUqytIMrxLNYRq4nWcoJfDrcMufsmOObgzSf2rRa9fNChAW0hMGsr5j4peTeWzseHaJja7FOFCCCYUMRquSyyMf4pOloKfyYmjfkQOsLflzEs1HbAllFuDakk7gBbmcXcfgl6okVo/UiSB3y8yFzsLBPGyZqSF53lhI53Jk3j0/VAKKEp8TI8rWgt5BPbcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=664vzMskWXzAS5U3l6IEbrlcnIYgZwaDh9zGQRxj1wI=;
 b=G3xW92rIcTqnPHxkKoyHXGgn51HI5ZVfK1F+JdXHIAPf/hlrxM2fGC5B0lEDm6YXibuG8KAAca2Bw/PcehUTZF/grOZ0MlHo5mYa5nQEUvN/tDYTae/tPzX61m2PiyN5TwXvJpy/Naa31sHHy+9hBuj430bTjHL9JFKn5gKRDtFD07GQYUtboGI8dpb4Ob6Xca5phWwqvR8YXHURu8Dlhcaoc/kWq5yu85KOmfkgptLwlf+fcI4vbqBliqhVUn6E7sVe7FOPTN+Z534CdoKmrrCtrWlL3WmVV5DxFBxwBgh/fq7CGBmmGJkEcp5TQxzxcak3ZIB4NA8hEEyaE9hfvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=664vzMskWXzAS5U3l6IEbrlcnIYgZwaDh9zGQRxj1wI=;
 b=SPkIzKb1r8gX0paIT8xZUHl+Pq3ToSUoObtQy1Fkmatm8rt5gKtNEGE9Jx5BX1YrajnXMNfXloQqIQJr78G8MfoKYGkUDST16SoPf692MNdLvbctUIYoO9szGAqKClio21Kmq0C7zTpVLHvosJCJqaaBO7ud0nqRqh2h+jRLI/U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by AS8PR04MB8263.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Wed, 1 Feb
 2023 10:39:29 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1%4]) with mapi id 15.20.6064.024; Wed, 1 Feb 2023
 10:39:28 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V2 1/2] net: phylink: add a function to resume phy alone to fix resume issue with WoL enabled
Date:   Wed,  1 Feb 2023 18:38:36 +0800
Message-Id: <20230201103837.3258752-1-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::14)
 To HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|AS8PR04MB8263:EE_
X-MS-Office365-Filtering-Correlation-Id: 391e719c-1e5f-4108-5308-08db04409873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aBYFxDB/nF4SBUz2qlGp52aw89BHPnQ5M+dRJXdt4CRjNf9KFBLw1SHmuOmFf43owv16OenkRtkwx1gqSk7TtZnbUZ7ZzDZX8pj+ya8kexdu4kIo6t7JNy/WQLsv9Klov2C4Jjunb/m2smvHfNUSC8ETZHfg5Iyp1/3WV/wTE3YhUrUoWKiQSImXNNZQEndCf22e7A8KKPvzATsJcFZw9T9tFuv0DRMwqjrW8EDnIIUYfynYLy9L90tLTffgPr2Ho8C4AdVf1+SbWkWfcMBlDIQJ7H55fGi9qYjT5/pReXoc6NnJm1iM7l3bYo3cr1YJ0PTU0VxhvZtd3eguKbJrfwlMAa4FAYARGdg3seM0PwHgG4bazb7Vr6b1lPoK8jWzT73V0uEXHbLtcsX5YuYIS9Qjm5gbXprWMx3nJ7V3mpr1E/enttSmUF4RPjE6I8gpsOvUpIW9d4kB/u4ijdDCA4cxDzImTDYot8uzdiJu0spNSDJfxN7cqHMrr03qBD5EXU4rn71ip43UFIRBdq2bmjYePa89Crzu/CPvZWkRzGtiT8ev9hE4topYMC9iKltYBZAIqEJtIMZKf6FMA62yJJp0nkId9u0bNj1qQGUhga/ZFt1FSocWx6iRAWTndIBPPosnHfOuHjNzupd7FUhX7PH/WjfDrMoxJYCTdqybXnkFCZuCYsQHbBHpFfpN2gEn7/GQu0Cga7FhEVacGsAF82vxfTx4uM52qd3GCtnlrMg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199018)(66476007)(4326008)(66556008)(8676002)(41300700001)(8936002)(316002)(6666004)(66946007)(5660300002)(83380400001)(7416002)(478600001)(1076003)(26005)(2906002)(36756003)(6486002)(6512007)(186003)(6506007)(2616005)(52116002)(86362001)(921005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fiq929B41VrG5vAmApNqWp9NK9xQ8tzW5CR3rm8aSGcWDBrbdxE9zg32nE01?=
 =?us-ascii?Q?wadaQrdPC9FPuj9SU+Mr9P1X3yagEKGKqx8UraKpxPOJKVjv+WqKtMkMa0Om?=
 =?us-ascii?Q?V7G0ZB1b8PHQk45aHhZ9U01lchzCyg5xtd5omra6u5gtqVQW9FfiOk8wl4vY?=
 =?us-ascii?Q?jvi9u2twdkwJ0aewQnHOTlfJvhA76ZMdCYh6oM6uFNTOED1uKsQ1AviVXtTV?=
 =?us-ascii?Q?IIjicSIZ5SW+CItic7As4T6jdAUgCFHCTy6TjsZe7H93Y6JzYG1nhSvV/mr+?=
 =?us-ascii?Q?gQdhX1kMAn/mUBqDmgO9ipDevetBI9Kh4Ws/6b12H8+cmOvPPwZMS+QSlytA?=
 =?us-ascii?Q?7I6AHe0LTbT/A9fmENiyxl/5rCmxCzYO+/njO6bHNHvxNHiD+eBDt2PBaJn5?=
 =?us-ascii?Q?HRoZ/ueRjhjseCHy2cZTvcHeYzdSdaxeLSO8+BUd9SrYYaWggh8/9KdnxwjZ?=
 =?us-ascii?Q?OpKMb9RWLf8cqeCsqTl+7W+yCmCmc+BA0J6A5vkkDM2UjiL1exhOLUEciEhN?=
 =?us-ascii?Q?Q4NCM1gZ3cHRZnDUXPGWEDE7g0UYu/a/zwUbOYZiPkFrIQWFGQJwz3DeK1xG?=
 =?us-ascii?Q?zQjIIP2TmhxivLq2iHFXvIZAVzYePIuI8IRNETc1F1Kd4kwYNN+K/voDxLeg?=
 =?us-ascii?Q?ASeuTv5UvzH4DJkJ5IV/RD9+KGu8MMAIVpfRaZGndh8SVQZaDEl7AhWRJfYY?=
 =?us-ascii?Q?oBFMdIj2mO2mAd3/qqiEl0lpeI8BUWmnXHfZoZwPf0eoJ4p1wFlk+IlLO4b7?=
 =?us-ascii?Q?g27h+ILIkE8spyJ2XDNdmSLFZhtaARlNYC/Yp/LYAU7W0bSplwd0VBMtg8dE?=
 =?us-ascii?Q?qk/9nIYSXNOG3onQFSL2CfF0GYxvOqk6gNvOlxl1B/mCA8CTFn9k4BKIze/Y?=
 =?us-ascii?Q?OTIu1GM0UM9N7gnR0rSL+w0H+R5ztK1ToU6WaXOpGn36u2AWTxOab+NBZ2SU?=
 =?us-ascii?Q?uzrPDGp21LWNOOQUiA4tB3vuKV7i5VGi7PNpqLw/ksgfGt2WbMXGvaUEoon6?=
 =?us-ascii?Q?8nk8xHkgqe367JEa5NJrexIVvanAkdUfHAhS02z4nkM6K+D4QT56GpQSjDIx?=
 =?us-ascii?Q?u4ifp7rkeWt3/9kDGGsaQyiph4GYMCzYt+ZUsChRcPXTzH1sXmt0aaxejdQe?=
 =?us-ascii?Q?G8iQ1DEYphqVYiBAYpBXnH4D1NCtM8fiZt0a+MiTmCsjV+UhkGz5T03OIYpW?=
 =?us-ascii?Q?aQlv3groI0Vo5PeGrSPrnATIqIwK8KMCDmwukGLAUH0hK3kH9clw2ZBGuujB?=
 =?us-ascii?Q?/Ac77uZnxP9m4ZcP2PcQQkUBOyaj4YFKFfyG0xFZy7SKuHqWXU1bK2Na6Mxr?=
 =?us-ascii?Q?YIlwzlmJ3JiatwLJdmTHS3TCPmrntnIgKh4LpLKPNaClc8OmgLva6OhjeI+Y?=
 =?us-ascii?Q?CAlQy1WZwRIv6uQuaxhEnZFwIysoCvQMBfuhyFzM+S+XSHE752HSuVBnNsBJ?=
 =?us-ascii?Q?Stbp2bqRwpw23+NJQ3CnWMlT79UlzwXxH7J5WB9DkF1+XrzYTXmxSVmuMLov?=
 =?us-ascii?Q?i8FnIHTf5ew7hMpjYX5IvrZcftHO8vz/BmoTqcKKT8qdHHCz+zHeD/kASUON?=
 =?us-ascii?Q?wGEM3w+Myr4biHmQRuXvIKjNZo2uYCjk3d2q+Vi0dtgmgn04cbhdpejCUlFC?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 391e719c-1e5f-4108-5308-08db04409873
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 10:39:28.7825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZSUWVl2wbPue29oJo7vgFPasAt5rlKUR9Gt3AGhF36TPXBO51dG1pTvjL4RfofRkipAUHzPS1pyVtHvL9D7ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8263
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Issue we met:
On some platforms, mac cannot work after resumed from the suspend with WoL
enabled.

The cause of the issue:
1. phylink_resolve() is in a workqueue which will not be executed immediately.
   This is the call sequence:
       phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
   For stmmac driver, mac_link_up() will set the correct speed/duplex...
   values which are from link_state.
2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
   phylink_resume(), because mac need phy rx_clk to do the reset.
   stmmac_core_init() is called in function stmmac_hw_setup(), which will
   reset the mac and set the speed/duplex... to default value.
Conclusion: Because phylink_resolve() cannot determine when it is called, it
            cannot be guaranteed to be called after stmmac_core_init().
	    Once stmmac_core_init() is called after phylink_resolve(),
	    the mac will be misconfigured and cannot be used.

In order to avoid this problem, add a function called phylink_phy_resume()
to resume phy separately. This eliminates the need to call phylink_resume()
before stmmac_hw_setup().

Add another judgement before called phy_start() in phylink_start(). This way
phy_start() will not be called multiple times when resumes. At the same time,
it may not affect other drivers that do not use phylink_phy_resume().

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
V2 change:
 - add mac_resume_phy_separately flag to struct phylink to mark if the mac
   driver uses the phylink_phy_resume() first.
---
 drivers/net/phy/phylink.c | 29 ++++++++++++++++++++++++++++-
 include/linux/phylink.h   |  1 +
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 319790221d7f..687562869c33 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -80,6 +80,8 @@ struct phylink {
 	DECLARE_PHY_INTERFACE_MASK(sfp_interfaces);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
 	u8 sfp_port;
+
+	bool mac_resume_phy_separately;
 };
 
 #define phylink_printk(level, pl, fmt, ...) \
@@ -1509,6 +1511,7 @@ struct phylink *phylink_create(struct phylink_config *config,
 		return ERR_PTR(-EINVAL);
 	}
 
+	pl->mac_resume_phy_separately = false;
 	pl->using_mac_select_pcs = using_mac_select_pcs;
 	pl->phy_state.interface = iface;
 	pl->link_interface = iface;
@@ -1944,7 +1947,10 @@ void phylink_start(struct phylink *pl)
 	if (poll)
 		mod_timer(&pl->link_poll, jiffies + HZ);
 	if (pl->phydev)
-		phy_start(pl->phydev);
+		if (!pl->mac_resume_phy_separately)
+			phy_start(pl->phydev);
+		else
+			pl->mac_resume_phy_separately = false;
 	if (pl->sfp_bus)
 		sfp_upstream_start(pl->sfp_bus);
 }
@@ -2024,6 +2030,27 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
 }
 EXPORT_SYMBOL_GPL(phylink_suspend);
 
+/**
+ * phylink_phy_resume() - resume phy alone
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * In the MAC driver using phylink, if the MAC needs the clock of the phy
+ * when it resumes, can call this function to resume the phy separately.
+ * Then proceed to MAC resume operations.
+ */
+void phylink_phy_resume(struct phylink *pl)
+{
+	ASSERT_RTNL();
+
+	if (!test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)
+	    && pl->phydev) {
+		phy_start(pl->phydev);
+		pl->mac_resume_phy_separately = true;
+	}
+
+}
+EXPORT_SYMBOL_GPL(phylink_phy_resume);
+
 /**
  * phylink_resume() - handle a network device resume event
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index c492c26202b5..6edfab5f754c 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -589,6 +589,7 @@ void phylink_stop(struct phylink *);
 
 void phylink_suspend(struct phylink *pl, bool mac_wol);
 void phylink_resume(struct phylink *pl);
+void phylink_phy_resume(struct phylink *pl);
 
 void phylink_ethtool_get_wol(struct phylink *, struct ethtool_wolinfo *);
 int phylink_ethtool_set_wol(struct phylink *, struct ethtool_wolinfo *);
-- 
2.34.1

