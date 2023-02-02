Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2D568771A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjBBIRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBBIRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:17:07 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2060.outbound.protection.outlook.com [40.107.105.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F788241A;
        Thu,  2 Feb 2023 00:17:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRhZ8deG6NJbQkncs78RmWbrZXaB8YhRFh4s67DBM6pwCMWemebXRjQiAEqPwbNTuLytyEGTn/GcNGlIbd/gEMThrYFMSE/YqPsZ5EolOs62ENxW5u+eEwAbfZbWXzMtYZ4SQ4XE+UE/4Sb1ViHnLMTgaSs6fCw1t5V2k7H6DVBk44GdQsaRc/H7H0N4ksifsdg/7jxyvJ0ry52PixXkC9+RADQbWulU0wHrJd91InICkqKqPanyD4UwwVmQ62A3L23GcH+5RF9io3gHNgVHaS7MKcpbJRRaGJa8mAGDjQFi+59TutI3FR06e4XGwyrnPU/5R698J82HoDM7WUlr+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nywlvBN/FbAwNmekc7G9y0+h2Jo2nRoaVJGeOUlwXmA=;
 b=QgRC95tlowVMN4VcrkfE0/8YYmVy8ic90CfOo0LC9eDAZ3hkJgjIDvRMwUV55g9mwhxpuwS8GUXs1pu6Zk65omsME7p4StrO9IGFZEBYDFK/lvBLwvDIm1gzCtRGYvCSI/8GIxbxdJ00DwwS6w/cLOfr4EdzL21nijYAa5XAr008SMfqm9LasQpvdTbFGh0mFc8CA4j32PhrNjfWwo806G+lWjrIXkGZKeqRYyqs+JDEepZIJ8hNSB+aLFatyhtTq52FFRYAXdDtTVF8p/ZcaYor0y1kfeggcw7xC0LM/lsT7RS2+Exh/qYPOaW4kK8YUvQnapFw1cNiWo3oqOvFPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nywlvBN/FbAwNmekc7G9y0+h2Jo2nRoaVJGeOUlwXmA=;
 b=g9hA9QzJadigpPkhpGkxrBaVkyE4fAx2KPModHrzh0iPa1MMGWH1vGoFa5eU7qtzOV22+mTI506pWhiMiR4Wd+TrqC0OyBl4nLOwSaMVje+3TV3HHy6c0cNfILoxObSTO3TtdGxPZUQhmrtBCZNbPd1WAj3HWmgipv4yPYe7So8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by VI1PR04MB6912.eurprd04.prod.outlook.com (2603:10a6:803:134::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Thu, 2 Feb
 2023 08:17:03 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::4980:91ae:a2a8:14e1%4]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 08:17:03 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V3 1/2] net: phylink: add a function to resume phy alone to fix resume issue with WoL enabled
Date:   Thu,  2 Feb 2023 16:15:59 +0800
Message-Id: <20230202081559.3553637-1-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::36)
 To HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|VI1PR04MB6912:EE_
X-MS-Office365-Filtering-Correlation-Id: 44ec787d-5d72-4f25-84bf-08db04f5dd25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4powkt0iuXop4p/BYbxCZfD/EuNtGv8zRSpfYeS1dL7DWF4eHmlcPkGu9oMORcHNjEgQh2DonQ639N/R0at0pCSbxhgR73dFFads9KFNaCw9d+trM95yiGinUdzU6A721llUIBuoDyYw/cOxwITiw6RTpXQ33jng/eOTbXBdWyNdzvwOcTnw5ixscUApI99PYtfEs6rU3pOhFKnl5o90sFsxu/ZYFd5/V5GF6YQmZ6mW7U7wQ0mB+OQDAUF1LAvz9dKANGsR/0HqBPYnobkuudShKuklOnP5oQpxFjSfTgJfJ1gHesS/lg3Nsk/MlcIsh0R5BPTOZAaGvFc7hm2xgbRh84uLNCR0MGQKUnwzuwFeDAKI8XI6b1bhcWNaHrg4wrFyFgb7h4foxB/PNq4/9WVGWez20tLarooGxwOXPip5XDTo/edOVE1cAVCH55iVprYIMCPzW6wBoMDjs3fSXdwg+RyzBJBLh7ucOjIxYrxXIrIFuvaUCHsY7R4YbIylwqjEIx/3PFv3KGeIbapwBjo3So16234TtsoIrSiVFUBwzdoDz3jVnmni0tG4hG2bMXQWb8RS78Se3YpXFjaNltcx19q70IAglL32//+VPV2v3Ov3wVGkxdId1kin96H8vkXVblh7fJL9zHi538s7dBK5ZB7CD0cA9FrlvGrWjufBuJuyRPfl/9cV2SwMmVvvqcPzdhdZO0kWCxfqW+8Yzt2VNz8uQDjbkV9rbQpBMXg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199018)(36756003)(86362001)(921005)(1076003)(38100700002)(38350700002)(66556008)(66946007)(66476007)(41300700001)(4326008)(8676002)(8936002)(316002)(7416002)(26005)(5660300002)(6666004)(83380400001)(2616005)(2906002)(478600001)(6506007)(6486002)(52116002)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K53gLX66Zx7VMCx1QV8v/Y2/wbpSgubE/tHpT8nHBnae1o7j+o4Zx5+JcMz3?=
 =?us-ascii?Q?UgVxrhWWE/Pr5k7M5l9g/Kj/xjBEw2ygaV3hJl77v4SDpdMm4ioXvIVusiRf?=
 =?us-ascii?Q?4bt1GYdjBR3PXrsgpxLOVT2DmcBdXjapjBo6Z1f6dezWNN4JikFtDwrLqp26?=
 =?us-ascii?Q?HYCTTmciGrx2yCiNWdtQM41le69ip1Mpihmbs03CKZuTgUhwi9n4hTzx04Xm?=
 =?us-ascii?Q?5gakOABJFokrltxs4n4R185cS1NTUrFMltFIYhzP3Ch85l3FTF6LEFQ0DE5a?=
 =?us-ascii?Q?McSgn3AQQBSFnFGqspNFEYfuGxgOtp1fNledu0mH+6SNCD0WDEnuWJ5mELx6?=
 =?us-ascii?Q?xW+GeHbaajbZFUsJ7GcN318yC7D+ajEAN6BfnudM6iULphZMf7GbMfrYIW7F?=
 =?us-ascii?Q?BxQgzWor3liwNG8wivjFAP3PcBnOEzRM3hUCm60/AvbV1C7VhIO+y6gQAg4h?=
 =?us-ascii?Q?mF/A20hMmC5L78attlc8BhDVQLi8LQeakw7oFtVRTI3f2wEmpbrooQ//Bok+?=
 =?us-ascii?Q?F1Iz48Q4Op33PwCK9MIPEPvwAoiIlh7ISL/1l02U4SbeEmsGstZb/FrB7jP9?=
 =?us-ascii?Q?ODiob2BDLQM8x6i8kbet5z/8jb8+kACtws4VEfh3L8tI7+ev4T8w8v2ELdpQ?=
 =?us-ascii?Q?+ELJJExGZpkWycvXsnZ0W3BsHdm/ZFDoBWzB8eosv+fi/DbjdtWdYCORNWBl?=
 =?us-ascii?Q?H3ay5bN/NkYR2/3pljDZhgc24xsqyHTNGyjIkLNmecV/5owgn//CdUKuHCE+?=
 =?us-ascii?Q?xMVe6JaCBWNkquoKuPERtBbdPAFoHnVkfDLe4zdsPGL/sKLLvJNsctSyu91r?=
 =?us-ascii?Q?1AcBDRwdpePhu/ceEdsRRpKdUgIEzMzuKjYSe9wWENGm/QfiwjMqtkakGB+D?=
 =?us-ascii?Q?N0RcN/z304SL0pNXky2cpMRI4whif9cVfoSQbr3OtsvNKISHKVTpOswStClO?=
 =?us-ascii?Q?XC2vXc9fT07O8J2bhA7rKWV1TdMWVa6viA34SPj1owd3Hzf1FWA/HgS55Hc3?=
 =?us-ascii?Q?MYdQKDm2kQ9QhATARcxwJjHDrCrwyDgWrwT/td7J6FpjSbYj/tYqcAmCxeAC?=
 =?us-ascii?Q?KKsaRQCJMjtSzBnA2zwNKh6PH/0SL0EiXcPv/ssqQ7xWsT6qSj88iPOCrB0v?=
 =?us-ascii?Q?ETmVvB4FkwPGoQ5BPtPYHChucSYf3l/7GQ4gqYZ1eQY8DBPP+am6UFlGIYmX?=
 =?us-ascii?Q?q7WANroqD9qNGRo7+sQv32v+tm6NT/bjv864UHGzUmoJfE6h/bYYTvNXqS4L?=
 =?us-ascii?Q?SvjnFfzsOTDUL4HWK7oED3FC38bfUtSCOQ3NVmkYxXczUBy/wNZCz58cjJAk?=
 =?us-ascii?Q?nS7ABfqWseM3vhn+CeCSrh1RUkxvHMDxb+sLQ1Huzug6UWgPG1U1Q9ivYk9w?=
 =?us-ascii?Q?kSKMx/VoZMdxS0g9GBYI1POFSHY+CJm/UFdfWLBh+DVqoVEPBD8ewAi84AIk?=
 =?us-ascii?Q?BJMxogCtliqpSuylyb0tR9a5ke4EJJsHUC+HkNKg82ui1IDiNelRAslP/9v6?=
 =?us-ascii?Q?I+LMsSIWrAWNVTR6wXXKIoQVImU+z2XmW8ybggtQNKM8x3b/qrSSCgRD97jm?=
 =?us-ascii?Q?vdL6xRipDZqA3oRxyrr5bvSFlOoyo3OQwlEFGFG+UqtrYlH8yAzG8gXSG6wf?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44ec787d-5d72-4f25-84bf-08db04f5dd25
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 08:17:02.9279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MAO4Ie4UNuXNzcpHBhoWvq89O16atess6pvf4hB644OlP5n6WwvBaCbxhAhW/mklnhARYzY+xA+5nkZpCytvJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6912
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
V3 change:
 - add brace to avoid ambiguous 'else'
   Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/net/phy/phylink.c | 32 ++++++++++++++++++++++++++++++--
 include/linux/phylink.h   |  1 +
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 319790221d7f..c2fe66f0b78f 100644
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
@@ -1943,8 +1946,12 @@ void phylink_start(struct phylink *pl)
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
@@ -2024,6 +2031,27 @@ void phylink_suspend(struct phylink *pl, bool mac_wol)
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

