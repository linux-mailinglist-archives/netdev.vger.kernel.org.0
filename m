Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DA469F1CC
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjBVJet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbjBVJeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:34:31 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe02::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6F639B9D;
        Wed, 22 Feb 2023 01:32:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdaXSbt+xbaIRS9D9gsjqAE7Gpqs7UzaNM9jEO2g0kQ54TXoycQ8G//VjlxsGAe3EPeFd8pCd9KkQi1gruLGvUn8/TFG6EFqiNlc5xYDSapN0HHOXkVjsdxyIE0KQn0g97VLQNQovioMJc0bTAFOz92987C369MlxDwwiT76eSSPY3x7cCPc7gRUgwzcwXOS8DAviIU0cg6ianQEgwOh3IrmfVz2ZMKDHmXwavo+yQHgSzwWnoHFJwqkJKtccwiC4aXEA1hA7slpy1CKqWLgCOhQPe1SovShD4pkvm/U4rVxcHE8BS0WaxZ2w/12LeGsSRjZsqu1lr6W/oYWcJxOGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5BEMGpCgypVwzO05HwJfPKZLn/JDJHAsZ62nxCzaE8=;
 b=jG6OLuU2zfKOsR5uHZoDi9LP1awYw/gUyobPt64IsnmlWuBEdEJ6+WBHE3np7T/2tUPkstypgl8RX/BfzC+Yrh3PztcaKTzS6OHQDoKo/mzW9Z85qWdrQwoKGUMYhLoq8VlzrZHn4URg6jYNku1A0QfBthzy8XOSwHRls53hEx+vK+a9RrBHnIQzbd9pA2aioVY0xvhHDCHwD9AH/0ZBjxNu5Qqm8zWxjGcgGpO6USByhTpbQwCkhED1vR3FvTdftvwtc2wdPeQYKLn9Vt/qvpML8oa+E+YOCeIc33DFhRS1XIPd6hQZTjShCUNIuv1DhE1w9uW9Qx5sAz9ZtByPLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5BEMGpCgypVwzO05HwJfPKZLn/JDJHAsZ62nxCzaE8=;
 b=HgdTFZ7jHk8wSlF5BarY0tVfKWn9rAIg9kZgQ7gzNvoHW0mD4vSUhAL080pqEVKDcOtnQhz4fPPzvyg5nmISqe0Ha3duQ0ouUDAlTX5Im/0JUQ9YuuuDlA9Yzr5CG2ShZIi7PxQegV1zSNhQl9N7V67L0LrEIaenz/hnsIvBIXI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by AS8PR04MB8468.eurprd04.prod.outlook.com (2603:10a6:20b:34b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.18; Wed, 22 Feb
 2023 09:28:42 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1%4]) with mapi id 15.20.6134.018; Wed, 22 Feb 2023
 09:28:42 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net-next V4 1/2] net: phylink: add a function to resume PHY alone to fix resume issue with WoL enabled
Date:   Wed, 22 Feb 2023 17:26:35 +0800
Message-Id: <20230222092636.1984847-1-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0001.apcprd06.prod.outlook.com
 (2603:1096:4:186::21) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|AS8PR04MB8468:EE_
X-MS-Office365-Filtering-Correlation-Id: 580a852a-76f6-4bcf-7821-08db14b7303c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oEe+7Agp4nq6EQHGi/pjzaLgWNU+8HVHZE321hjAo+IbNDHMPd0+lA+vx1kt7Ry2BKG12uJeqwpZ1w5/g4JGGfYsXzZRPo9XDT9O3NCRWNucnylCZ0ZvTgnig1ta7UwCh2V284kkJilby+xo755A6O8O7Dd9dv9RvG+WE5ZfMJgMKI4jjAZjSbylm07kjeOQZR7GjiXhyVIQMML5ls+4rLeyCHaFlidQKIT/kPHdKQfl5NUb4YPeWi34kSee2LpjNSgBMvW5KzRJuoRfR8HY37+TqtPlmQZH9WKP3VXBb2HWL8ZIEwwAg2F0389+PW61N7efKCFkng7ZFcWBkWIXcL8Lei1CVFpEldGkqCW6yRIuA5b7yGKR9KUU7sc2/iqAdMOldmQTfEBxe50XGEpxQ12TtYvsO5cVsxlDWgTqIGoMDZg2lJZFvpgFRP1d7DCHF5PA675Xd+p5CtTY5r4RoQcVX78k1oaActeEIf7/DhsXQmPLJuaghYakNoXpNcZgJDQzl2fyDI8pEfNUDVnR94Q9owP3TcwdfqWB6dZmIDzOU6Zw8OD/1gTBLOzrRxwY8YjTxdnIfVZnQX/OBylrUiRAdW4QP5Gtwztrxpk/yNjKYlxHi4FW/pP3rk2tEVEthb2YWcycWXXHVXAx0L+tnX/3o4KefMiFqEsB9B8mPYgjGMaJn0CFt9MnexfL1qjMIpDiBmNyLDnOYxEQvtn43X3QzJ1pMInD7r7/sbGPtKk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199018)(86362001)(36756003)(8676002)(6512007)(6506007)(4326008)(186003)(66946007)(1076003)(66556008)(8936002)(26005)(52116002)(41300700001)(2616005)(6486002)(6666004)(316002)(478600001)(38100700002)(2906002)(921005)(38350700002)(83380400001)(5660300002)(7416002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jpih2v6KDhT7ZlkF0ddcydYpd/VKJ6FWD4f26T2ByuK97y0ucgvtianWH2Dd?=
 =?us-ascii?Q?+wzJXtGjcT4gTjdXE0YRhOOQg+WfbmWGvpiTdw7XbzI6Y4l6yFn2JtGaJ8/+?=
 =?us-ascii?Q?4br8Ou5iqqdyzGnURp/QKS74hnxnZUHWl4wgYzTk28TmR/oDQMc5euVlJow+?=
 =?us-ascii?Q?ehyn7iXpOdy8BP09JJ8ibvm4A0qBTinO4X6M8V/tK4EBc57NBEb0P5tBtiyM?=
 =?us-ascii?Q?YpaSS/Pcs8/kUJTuMpyDrEJNmmYX2vmES2k6iNRhzpAzj3ZzuZWSnQgN2IKX?=
 =?us-ascii?Q?wLqI15ZtXd8RwHqn12Ex5aZhfNGOsOoEUZoTwdhvzTnhnRotcgNzP9+AGiHc?=
 =?us-ascii?Q?NNiXARaZTK50gBHXl0kL0TMZuVhznqTy4Jm2B7nm+Sq2HN44Q2++PxV8c/j8?=
 =?us-ascii?Q?KhrhcOPsukGrnLqsPPtBkX8W5eBxug13fTHtj/kvKXYroT6TLyo0r2AQuP9B?=
 =?us-ascii?Q?TSt/kYr/sjKydjroITC9wd/fr7zOhtv+xBCMJrzjWy976F1+7Yi3uiiaUI2F?=
 =?us-ascii?Q?baK3Rsay2SBUW6puZKi5UiLZ7q9JoSSxf5rluOM2SXVFgGCp/jNILsF64oO+?=
 =?us-ascii?Q?kjhz3WwWLWw94XUtd6d5WQuB9/+nfu3v9PORlWD11Z86VtpYjuIYGzY3Gq2r?=
 =?us-ascii?Q?bIQvbz33QpS7PXsx/c1e54WOG85xqDJrgslQ6C01jalGNG2YA3xiqZy2OwAd?=
 =?us-ascii?Q?VHtaJhL5/QGE2TuVr5GeUy/wuOY3UVeWOnY9FiOLUlwaFVrwJLCDtdnVeGfx?=
 =?us-ascii?Q?hBGcRQoZuB2E7fuE9fzDaSU225HFq/JgO4Hi9Bi9nTmxFYjdKCXbRDBdpGYL?=
 =?us-ascii?Q?ys8C5FLe6mD+qAM3yJ3Fdt8EzueEsuvPG6eS/nhX9ZpoFQ1kgyI6bsbHYm0N?=
 =?us-ascii?Q?DZf2U8mlWpT+RcHtIR08eHnzURmlMG4+s9gftKDjs3gHcLdc6UxcefIvGJqR?=
 =?us-ascii?Q?tQvt6fq9erFyIiHB5lGNLsMT0B4XG9dfgG5Fp7xurYCjilWN7hnEkBDhw5fe?=
 =?us-ascii?Q?25bKaTMduOc8WFV2LJExEwpp/2///5i1US6ANkjaRTFZ6kPU9WlcI0Z4AD0Y?=
 =?us-ascii?Q?p40CYIxQymzNPzRapl76HjRaMZB8aYDE5DgrHQQz0R5EaAevB8ZZf8MKaaOd?=
 =?us-ascii?Q?gH0EQk01THhkwn2tkwYl2qC7BMLxWe9pb9+s2/Q+UVK984EYE6Kb2sa1u8zk?=
 =?us-ascii?Q?9a5/pRJjlyMi3cb31a5pj2ZW0dYi6LGWGxAk6m0FIvUNn3cNoYLI/0KjnuQ+?=
 =?us-ascii?Q?YtY7Q6anW7lVOkg0MD0lOny89tLrH/qj+QNRFuLpliFnokYOyu+1oF8V5sVG?=
 =?us-ascii?Q?JL5PHl8MalXm4ryFbFGtG3KQTBeV3CBzrhTg2bohiS/UGJB8KSjNOmmtilfS?=
 =?us-ascii?Q?HASIqNWr0wKr5nnJsUG7R6Qc1IQ68zC2CMFyI5fdMsL9/W0Q8W0q9rPSeJRa?=
 =?us-ascii?Q?F251KTudqd+S4QFVOLsSASe9DgO/WA++hXngvaZz+19uY6w+Ymc9h8x7ZAix?=
 =?us-ascii?Q?tvkgVT37ZhKh1G2f02cuZW8NX0x0a2SiHZKdIA+tDjhOk/QgjXjiSWcAzkiY?=
 =?us-ascii?Q?AVMuU4INLODty4MO+KDbqdKaVlCoNckk2joBoplHeswe/DWWoQbFqPEq6Lda?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580a852a-76f6-4bcf-7821-08db14b7303c
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 09:28:42.6553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACjK4Xp5cfPJWFQ1B38asbTlZ9mKOIxw7lWSZT5gaD8+WZch1SwGSEWQalNALGimkYRJ4P++tQoweLGMkLXcqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8468
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Issue we met:
On some platforms, MAC cannot work after resumed from the suspend with WoL
enabled.

The cause of the issue:
1. phylink_resolve() is in a workqueue which will not be executed immediately.
   This is the call sequence:
       phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
   For stmmac driver, mac_link_up() will set the correct speed/duplex...
   values which are from link_state.
2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
   phylink_resume(), because MAC need PHY rx_clk to do the reset.
   stmmac_core_init() is called in function stmmac_hw_setup(), which will
   reset the MAC and set the speed/duplex... to default value.
Conclusion: Because phylink_resolve() cannot determine when it is called, it
            cannot be guaranteed to be called after stmmac_core_init().
	    Once stmmac_core_init() is called after phylink_resolve(),
	    the MAC will be misconfigured and cannot be used.

In order to avoid this problem, add a function called phylink_phy_resume()
to resume PHY separately. This eliminates the need to call phylink_resume()
before stmmac_hw_setup().

Add another judgement before called phy_start() in phylink_start(). This way
phy_start() will not be called multiple times when resumes. At the same time,
it may not affect other drivers that do not use phylink_phy_resume().

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
V2 change:
 - add mac_resume_phy_separately flag to struct phylink to mark if the MAC
   driver uses the phylink_phy_resume() first.
V3 change:
 - add brace to avoid ambiguous 'else'
   Reported-by: kernel test robot <lkp@intel.com>
V4:
Many thanks to Jakub and Russel for their suggestions, here are the changes for V4.
 - Unify MAC and PHY in comments and subject to uppercase.
 - Add subject of the sentence.
 - Move && to the end of the line
 - Add notice in the comment of function phylink_phy_resume()
---
 drivers/net/phy/phylink.c | 35 +++++++++++++++++++++++++++++++++--
 include/linux/phylink.h   |  1 +
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ea8fcce5b2d9..0be57e9463d9 100644
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
@@ -1942,8 +1945,12 @@ void phylink_start(struct phylink *pl)
 	}
 	if (poll)
 		mod_timer(&pl->link_poll, jiffies + HZ);
-	if (pl->phydev)
-		phy_start(pl->phydev);
+	if (pl->phydev) {
+		if (!pl->mac_resume_phy_separately)
+			phy_start(pl->phydev);
+		else
+			pl->mac_resume_phy_separately = false;
+	}
 	if (pl->sfp_bus)
 		sfp_upstream_start(pl->sfp_bus);
 }
@@ -2023,6 +2030,30 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
 }
 EXPORT_SYMBOL_GPL(phylink_suspend);
 
+/**
+ * phylink_phy_resume() - resume PHY alone
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * In the MAC driver using phylink, if the MAC needs the clock of the PHY
+ * when it resumes, it can call this function to resume the PHY separately.
+ * Then proceed to MAC resume operations.
+ * 
+ * Note: This function MUST ONLY be called before calling phylink_start()
+ *       in the MAC resume function.
+ */
+void phylink_phy_resume(struct phylink *pl)
+{
+	ASSERT_RTNL();
+
+	if (!test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state) &&
+	    pl->phydev) {
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

