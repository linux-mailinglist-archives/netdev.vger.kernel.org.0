Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50516604609
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiJSMzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiJSMz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:55:28 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on0613.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::613])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB6AFE91F;
        Wed, 19 Oct 2022 05:38:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPxHIoryL3FTlEpoi+3HqRhmEVJ2CiYIH3mCEgVei2qgoaZy9KQGxhKWB7XF7M19ZKBfmKYPXXELbNWuIhl2lSszGvZkQoUR9yzjreWConZtcgREIC5KHyI3mBnYyBLYVxdXBOEbEb5dT/0uDvZgATilUbL7cL0iSkYL5ojuzBXjBRo9IJvCSOw5fZhqcqqx7EEcM7BIPJlwIkwq+dQp+eOJ7tMx8il8CRTDsSWZsn7piEuU89+MdukQIgX0ZJ03541+66XEub9oCix3g5cZ0gHVtFoTlM4T8K2KWFBvEhn11G2yleS8PQc+q5NF2/glj97iwwsFNfFr/FfY4Ugp5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lM0ygeiEGam8Rt1aKmv4rqJtqfGRJlCd4+fCBAvcrC0=;
 b=LhxOS19bRW8ntwl3yINFTjobhlBoIAvuC8CvGMCEBYrG0ZNXayO1lWPEnspJkZfcvnRONqHdzzhK9IiGFCv+8tO7eKSQiEFVCKZ90HAYlBeH6LNg0N9v0eHQHGPkOYGYRXK7aTKgkvshmqffRB0C7DJ4zZ/SNSWjJdEjO9IHipDRoODUivccwIeI2NNu3AxwcnXlOmEbOdqUemPjMjJVz4IpMlUPGdQdEfbS+X0mpWN2KGCGXahXh0DWY6qisq8BgO37MyU2OfkhfkMzSOxqRDFRYk1Kxe8fvKFyACN5J5o7NrsDWTLul3Ufb9s0OJKYLIjd4nbtW9e0MDD/TlVE5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lM0ygeiEGam8Rt1aKmv4rqJtqfGRJlCd4+fCBAvcrC0=;
 b=aVWoGOsNV+1mLaijF8SW6GINsXs01ZUWEkcU4K67PpvsHbL0Scdye+W4urBGIxVMdgNWk/PnJ4dZ1CcCXI+NWyib6D3OHXV2Ke7s5qMoZDzZchEqgSG9HIEHh7alvspfyFoLITBPubq2y7ADW3Z5AFzdJcnRE1Ya3c7VMOtHKPk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by AM0PR04MB6819.eurprd04.prod.outlook.com (2603:10a6:208:17f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Wed, 19 Oct
 2022 12:36:58 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::d8b1:a777:e29:7a5a]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::d8b1:a777:e29:7a5a%10]) with mapi id 15.20.5723.034; Wed, 19 Oct 2022
 12:36:58 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH] net: stmmac: linkup phy after enabled mac when system resume
Date:   Wed, 19 Oct 2022 20:36:43 +0800
Message-Id: <20221019123643.1937889-1-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0041.apcprd02.prod.outlook.com
 (2603:1096:4:196::20) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|AM0PR04MB6819:EE_
X-MS-Office365-Filtering-Correlation-Id: 49527828-924d-4810-d575-08dab1ce9d34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9szagNAqYm1JYs5/tjNwbOwQB6BRNhfiKvIGkO0alAtsXoxUfUqFX5v6Ach8p+V2QrR0CvRy5Gi8VkLnwqm9H7SVmMdd9yanMPcW7dUlNpHMFQpQn282bCGbSKNQyHC2F9+dkufSa0xd608pWE27HBDwfuf15uQ5bykq0pwjmNHlZotcFw6SDNMO86jauo24p+s743ChfBKqgxjxj+AeyUrJyDQ1/PACE6TXHRd9s35y2UIe0Y3XNySLqTUHboxqGuJw9sgG5oqyoOJQiQdrOgjdck2gQTWGcMzY0yFGYiaHi0zPZkepU7shBDjO2vz4QGh/cup0XTkFQOTD0hyzofQoKfcjeZ70oW5S5yMOMcw9WRo/TB/LRF79lY1cKfQ4U1an9XQY7sCnggZH5S+wbWec4iXVU3FgTvNrnLKghOmDNa6w/vTp5FWd1+MyVyLpVp5W5gcnKq0zyG/QCA1fE0CbRJKnT8LLaijmZzA2qqzCgI93QrSMPWLfEJVPq5s6I+PQ0m4NUjxSvgZm3wthviiGt2GDY19JcSSrK1pnkwCp3+1kfK3248Rr2knZ3CZWoljxqDJA0zsuSoPRt3UGjdb/wUh4V+c4DV3rNpwAEixoGo/RjeY9oeHgkKTRDOtwN2f6kmay98qZQqtGoGRFRAenTFtzrYH6Hy3zH7KPpWzbUvnSxOnDbHjFtOmsupu9AFnVAC0oggp5UWxQtgZm+r1dvBvQgmz6280XW6ZuG/4EgTo/8Edaums3TunhW40h4N/SE9HMqrOuxIADJIW+5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199015)(36756003)(7416002)(86362001)(2906002)(38350700002)(5660300002)(38100700002)(2616005)(6486002)(186003)(1076003)(83380400001)(316002)(66946007)(52116002)(66556008)(6512007)(66476007)(6506007)(478600001)(8676002)(26005)(4326008)(41300700001)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ghS86wO7Wn9N13jEjSSLhefuCCMS7Q64HFD4hEkTbw18HCy9Dvz9RTsiSqAY?=
 =?us-ascii?Q?KSBFfH43FxX5H+cIDA2bFGgcUJrRcSuy+S7X0I+GrwjkWqMX2fz7n20IGS7r?=
 =?us-ascii?Q?vkJatsCKE7C8Mj4lc28e60+LfhFQdg5Un8rkupbzEp3InxIHGvEj1XqPOi6/?=
 =?us-ascii?Q?sKpqQfWZl4Mm9RnddTbbAWI6KbyLsuXdaIPIbvjvTJzkii2vi8vaMf/p2uGN?=
 =?us-ascii?Q?nel/ON3x6t1Ec8O2MKUD51wSsvw469cxZQuH+5sbakpLdVgP2niYREw42aOT?=
 =?us-ascii?Q?JxgRoYvzr/1b8HBYWIkKqah9bm0qSpjaciMso5Yp5LD5xmo6tQfjl1ahoHgb?=
 =?us-ascii?Q?G1HxYDmhjpZMhjkLqQtfobezU4m2dW6WMM6Rf4nJsRjFJwlTJg05E9rsB2F0?=
 =?us-ascii?Q?Icr8RNHH6sGPrf2DILYeVTHOSvpXPbpQ2DcDaHWjCHGJnRtAa7sCthP4HSQu?=
 =?us-ascii?Q?hpXWxTew5MKMuKqewf7PsjZeSD7g3vY5zYEhtYvurQduJ33Ce2FRxzPOslpZ?=
 =?us-ascii?Q?MxRmKoOQMoWS2GQk40BFjDL3H2XJ8BlkTOuv/g+gMiN0IgUyq/GiM2UiiVkW?=
 =?us-ascii?Q?E6Id4SrX+sEE8E9IiB0ReeN8gqu8AqnDyDcd1q4eoLhOaeZ9jkeS/SJWWg4j?=
 =?us-ascii?Q?14uIJsqEtvv/WtAZJ4IvMraIhc97k5cgM7mwIrgtjgw4Tg1kFIwIz9GRqlz8?=
 =?us-ascii?Q?PmjF8BgNuDFyKfUK07y08tt2O80imVaLD/tGMj/bgBHwjU5J82xJqyO0c8fl?=
 =?us-ascii?Q?HPy8K58vMVLAzESPbegcEyTbooKse7tngbk9z7KZH55WJW5kpUzLr30FsP7B?=
 =?us-ascii?Q?gkDrCSc28UINbj4FsSpPXjeae+Ec3pdW2EH5QoLFhB8qm+1N7iVPbwelTaPS?=
 =?us-ascii?Q?YLD/Az0K0c+FicmZu+twh0AUr+tEHhkj/q7qjTAfP/u0OjhC3A8+UtkfawJJ?=
 =?us-ascii?Q?ehHob4fvhdmQsDKjxju0IWovjZ1l4mn0y88IaZqYH4r6iv30MVvCj7yUD7YB?=
 =?us-ascii?Q?h/0mJDqA6aMkguCkG2N4QBAsrLmff8UsJ/GDRqR7ty7WfNX8QqlAxKHGMAxo?=
 =?us-ascii?Q?FUu4G/op9/MMjuDe2wxkQoHXWGyKKg61UBhkYv9WAKTFLmYzxwZSknRxsoS4?=
 =?us-ascii?Q?3S0nlM6lc5jkHeixGLR5tImlYBtv6h1k0xdPAj8ViqtX7/PFHEJOcJDRTDie?=
 =?us-ascii?Q?ElvWfWytKsMAXfvAzOM6zqPVDOTQoU5m577xwU5zfos75wuu3yMoXesQcQR/?=
 =?us-ascii?Q?QeQoeH0IOmBERn4CLSkHWlBG1hvSB2V5/oW6GiUWYy2dSxVwHKeSnoLnd4vU?=
 =?us-ascii?Q?U8uvYutr76t9Wi9vsgYp96Fjh5uBHVrhzXlZcO+5VcSXB1GwSTwqhG5/X77i?=
 =?us-ascii?Q?etI/8Nlvl073hSQ3kXk3uJTFxkIl9RLtur+AqXTO2vw2n3+TL+Ow68YApx61?=
 =?us-ascii?Q?FqpDvgc8I1EoMK0bo6cHNZu/OE2QwSQ3/i/cUka6mS72dVoBSqsoVDsDs9TW?=
 =?us-ascii?Q?aLIuzdS4F5sBK6gDqgkjAyiKL7+IinYk7DbyxsFDBD4ackoaNFyE9lf7YfYZ?=
 =?us-ascii?Q?Ck9iX3HbwdHdPGxZdCBeaaVU+mitBSyreZrolpEHndg0iXN9nt2nfZ7BoZrJ?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49527828-924d-4810-d575-08dab1ce9d34
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 12:36:58.7711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8L632FfXNSLvaydnFtvsL5+xnlBACVNBdPeJHg1ShQDIf15m6ef/S17S0eBmPeBcYiyrUZMH0J19UQl4258iEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6819
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is an issue: after enabled the WoL function, EQoS cannot send and
receive data after resumed because of the wrong setting of
MAC_CONFIGURATION register.

When enable the WoL function, stmmac_resume will call stmmac_hw_setup
and phylink_resume.
 - When do stmmac_hw_setup, it will reset the stmmac, and re-config the
   register GMAC_CONFIG with a fixed default value GMAC_CORE_INIT.
 - When do phylink_resume in stmmac_resume, it will call stmmac_mac_link_up in
   a workqueue. stmmac_mac_link_up will set the correct speed/duplex states
   provided by phy to the CONFIG register.

So when resume the stmmac, the workqueue of phylink_resume must be run after
the stmmac_hw_setup to ensure that the configuration of the CONFIG register
is correct.
In order to ensure this, put the place of phylink_resume consistent with
stmmac_open.
Make sure that stmmac_mac_link_up is called after stmmac_hw_setup even the
workqueue of phylink_resume is run immediately.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 65c96773c6d2..79c9ea451a81 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7515,16 +7515,6 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
-	rtnl_lock();
-	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
-		phylink_resume(priv->phylink);
-	} else {
-		phylink_resume(priv->phylink);
-		if (device_may_wakeup(priv->device))
-			phylink_speed_up(priv->phylink);
-	}
-	rtnl_unlock();
-
 	rtnl_lock();
 	mutex_lock(&priv->lock);
 
@@ -7539,6 +7529,16 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_restore_hw_vlan_rx_fltr(priv, ndev, priv->hw);
 
+	mutex_unlock(&priv->lock);
+	if (device_may_wakeup(priv->device) && priv->plat->pmt) {
+		phylink_resume(priv->phylink);
+	} else {
+		phylink_resume(priv->phylink);
+		if (device_may_wakeup(priv->device))
+			phylink_speed_up(priv->phylink);
+	}
+	mutex_lock(&priv->lock);
+
 	stmmac_enable_all_queues(priv);
 	stmmac_enable_all_dma_irq(priv);
 
-- 
2.34.1

