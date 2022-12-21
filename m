Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053E7652D98
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 09:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiLUICw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 03:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbiLUICm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 03:02:42 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2087.outbound.protection.outlook.com [40.107.21.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EE2164B3;
        Wed, 21 Dec 2022 00:02:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPJpB7vBMkvLeJpNcFOiDUnN6bCJDKNIFJ1tQJAup4XuJxeQxhMzFLP5L/mmV/oYIjM/cp2V3QOHLe8nPrGdE6tvZM485rfQ0DTGASVJI0aVBaKdl0gBoAcUIpK/yLIIuqyELUmhsq+sTtq9XC45E4cq/KjV75FBultRap3bzI/KSha1rVWXXGczx0pPbAgPFNWIpAcaayGx971S/K9M4MdpAV/Emt4FICwOEjbg73RbF3kRHXXLNzgOWIqoU0CP5PH73ZpeZSLNMTzQKaYQPvAfqIhRh1iM8yINSvw++GRJfiBZb0JlRtdHTIKXuZ9oHOw38eS4Lem0fcviRNNjEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yR60+Ui3v8eqpdeEf/eDfnZJ55leMLByQTG7sD8xCc4=;
 b=EHp030D5Auxvj1DP9ZQ4EBaqxowiBvM4c8hbly2meNOdAl/UOujTyAxZgejXwXKra6fxJFRXVX5gWEDki/wANYVAs+OTMXe+Xa1qYrlD/wm9Vzs4FiLXuYOQykSMCy+XLzMs1a3nutSnomNAaD7s85C7tinxR+ggeIPhmVGlACoiHuX9Ys4bDQNTUqrBaPmFt3zNjWBjXrlbGOMXaLgCtk5GGXDxHUGww85LPTZu+rIoKxhHw44jw5/P9R9nbcQacFELIZTxO/Hgt44gf0iaA8apwyEDfWDqbI6P11TZivpgwc5yQO2NiP+lrWHoImjR/o7HC4vXj6W6SiGOl6as1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yR60+Ui3v8eqpdeEf/eDfnZJ55leMLByQTG7sD8xCc4=;
 b=jnyW7AeQF3iwRZk+dYYRJoAp/tB3DTvOOhTcVeArMAbSw16pagm/MCMM5DPybqVa8snn/GwkV/ypWhfmlfH+OfASiS+p4kgOtS/NZvj6waSY6wU1XIPHKhO1jTUgAP+PGLcrBVph8K2wrnprPhhNDGS0lKKGdCJEibtp1wb3pw0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by PAXPR04MB8426.eurprd04.prod.outlook.com (2603:10a6:102:1ca::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 08:02:39 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c%11]) with mapi id 15.20.5924.016; Wed, 21 Dec
 2022 08:02:37 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     linux@armlinux.org.uk, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: phylink: add a function to resume phy alone to fix resume issue with WoL enabled
Date:   Wed, 21 Dec 2022 16:01:43 +0800
Message-Id: <20221221080144.2549125-2-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221221080144.2549125-1-xiaoning.wang@nxp.com>
References: <20221221080144.2549125-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:196::10) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|PAXPR04MB8426:EE_
X-MS-Office365-Filtering-Correlation-Id: a03ec048-9d13-47a2-e959-08dae329b9a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FzTp8Z8gaWD/mKQl7duTK6GJCzaPivDjUZ/MX3iosogk9URIMMNR0DHEu7rCxnQSe0Lt1Y5+ei20PMePVMMbrxc2GEs88BKA672MGt0kHCPrWG08IyNZvSN3gGPJPA3p0vmtbnSvaCdjM7Z1eaPYyCAsQ0KuRWtUSWAlGbXLGBDB5vl2uJt7Q9J5947z9Ofwj3C0+ILezAr/6mlJ4/E1ZjNyC8w6ssh20Tvoa1MFSNgPPPMP/xqbv2LKC26lXXmp6zwXIowGvoiEpk75MOF+vwLbUounem1GdNM+opkGzu72QB3t0plbWK108KVJ80na69m7Q6lzbjyxbLOM1hE9L3JwUcO6H5CkBvJRYLy5EApyFvPULBJ8OVG843Plh+0pxov415mDkz09xRE7ojaOm1qwxcly2cMgYJ2ftzwjKujJGQ6LxnlcEW7AKA7diXW+UhUnE6vxuSrjMuUHV2hGMXzoVNiy6WNuM9myX0qS9bONl2t1yNxR8rD0mQIwbI1ODt9xZuQC8vmGifX5R7G4pD0ft4UFyctw757Bbb/jz1OiVSr8WkYhJW0xeYlM/e63Y4vqDicGnE3FCSMsyNXcjO0lLs48o6BMS03kmcFjHN1wJvnX+wMmoadwtrYnF1zsL3/F5LOhtOIwUywoZTXMV3RSiUExJXb6l02O05uoiwDRlMQ4pQlALPqQohhlZFrxnUUuIdC6lCHykTzCdcz/jQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(478600001)(6486002)(6506007)(186003)(6512007)(2906002)(26005)(36756003)(52116002)(41300700001)(66476007)(66556008)(66946007)(8676002)(4326008)(5660300002)(7416002)(83380400001)(921005)(1076003)(316002)(8936002)(38350700002)(38100700002)(2616005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nnDqotW4dqL8qKDCIeevYUh5g42AUgFw8SD8JmrkazuCJLTtM3MqUS5FdEC5?=
 =?us-ascii?Q?rUK6qMTNNX5HlztaBcXUYxEbAqBxeeX3roiyLOo/qRBFGVMyULibUWXbiCOz?=
 =?us-ascii?Q?NMuU/8RJDOYoR/z7s/ood9mBUZw6GNMq6NqvsITETgKEzYgS5k4wOqExF+pf?=
 =?us-ascii?Q?OQGZK3ggaIcrEJtGs1X3taC2Ll5mzxwCVRDoUVvGrMlOAemuvsLxcSsBT5wj?=
 =?us-ascii?Q?yFAB8Szpvj/uIRV4AgNxg1/NUIXDOkN+4PxGwVjJQVr/Ts0ig2Fac/OMjGzG?=
 =?us-ascii?Q?76pCRPzSGln3EyHPB1pkg3tYP3lfNjHo8NMVVhSlbyOcBQwST4R8gCzMkWpP?=
 =?us-ascii?Q?W6K/xt5peY0yWI3Un1YNHx14K5VH0CmrbFy+WgVugZ1UhDzDChEOIZ8heP4L?=
 =?us-ascii?Q?//TMteg6XbPMtY/kpKy3rz/RRb3SojqPycouUO1p/gKXZ9AYrAcybQcF7n4j?=
 =?us-ascii?Q?EzKsSrhicVZJhvl6DdbDPFX315ozL5+T7z76Od3HLEIFT606b1iAIOhmxrEj?=
 =?us-ascii?Q?ejI7J7iKFLOBOfvWQiKjIJa1v/CSir7HF12lxXjmPKMZskqyfDfP/P8nvfSe?=
 =?us-ascii?Q?5SYFjkTEmIGlzQnQRBq7JG3jXr9AxqK8KV3ZGzPlWvrvGUyxo+afHf/lVHwD?=
 =?us-ascii?Q?rTB8KQu/fGlle7gViCs2Jx73nfBACr2zp7eny2J6CbHkzJFwQkH1BmhB+cTq?=
 =?us-ascii?Q?WhQawZNbmtHgdvBK9G13lwzG2n6WYORdc6/c43aVH6IM79F9nBiKMiQwqeSb?=
 =?us-ascii?Q?cpUPoMWYBIpp6kNbjJa3uEztrfKUtvaTRDA1zQhpO4uxUPRlZDaiLD83MQ4b?=
 =?us-ascii?Q?qxLmJI1GpAtg/9QJ6GDr33XzKEGWGEIj3zcxl8ORFbFNjwhP19rkKeVCAN9G?=
 =?us-ascii?Q?lbwrS43sTs51XevJ1BDHBm6iy+6nt3yD/grNV5p//3fSgQNPeVAO8pW6Loq5?=
 =?us-ascii?Q?vE7s7uyRjBJM+IdaFuLTwhuOCiecvxtwkWbZCzag+393pNSRbXnDDwatuPva?=
 =?us-ascii?Q?f+N4KcwttVgKKAwxXUrF9QC9VggwDRqZG9yevUYpK7wydKN6XTr5wPjCcP/O?=
 =?us-ascii?Q?gqseQcUu6Q+UQafQivPEkRoqo1rcdOQGhPpZz8x1BhCNmPPcTabELLVT+Qzy?=
 =?us-ascii?Q?5XIzvNvVC4sAObfMKzrP2cr68b2ximfCEtkU7wBcg2rAr5M+kXSWgdZB43sz?=
 =?us-ascii?Q?pbWnpR98BBzvaGIvMozynK15SsE7VQHPtCFCe1XIjwiPVzXXeoxbgbARwemx?=
 =?us-ascii?Q?30H67srOzH2jFMqMtHvcdHToUA/0XPUOwncesL6O5ss7uuHeHWh83+asWdsd?=
 =?us-ascii?Q?noaDeIme5hxXdHXu71tVJLzzy+sTnZEojq0sN5MElAGO6hf55GljVJd38QcH?=
 =?us-ascii?Q?aQqvJOpg/KaR4sYCrnVKTAqLBByiK67LTx1vt2vVLqTQS3FXUGRLAW8IIxi0?=
 =?us-ascii?Q?qMkTtKP/rOxPfkGy6iyvFkCYNI/45YC9WG0oDxOaSifEOXkIdSXnopSE4B0s?=
 =?us-ascii?Q?EE7Vknu2BjlYMfvqNbLGbhzvwnJZnjmrzftUfQuTK+JFIpNnlVoYXl4M4vPe?=
 =?us-ascii?Q?hkas4hFwdGtDjX0otgOAjo1Ui5ZM5NN62z7OvCTs?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a03ec048-9d13-47a2-e959-08dae329b9a2
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 08:02:37.6315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFU6aLxemrPp9ObViBn+aOr5Uis5rWBUE2ai7aaMIhN1hPISZgCCwLKr5pwr/G21eBNiA6WNGrkyvR43wzekBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8426
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
 drivers/net/phy/phylink.c | 21 ++++++++++++++++++++-
 include/linux/phylink.h   |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09cc65c0da93..5bab59142579 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1939,7 +1939,7 @@ void phylink_start(struct phylink *pl)
 	}
 	if (poll)
 		mod_timer(&pl->link_poll, jiffies + HZ);
-	if (pl->phydev)
+	if (pl->phydev && pl->phydev->state < PHY_UP)
 		phy_start(pl->phydev);
 	if (pl->sfp_bus)
 		sfp_upstream_start(pl->sfp_bus);
@@ -2020,6 +2020,25 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
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
+	    && pl->phydev)
+		phy_start(pl->phydev);
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

