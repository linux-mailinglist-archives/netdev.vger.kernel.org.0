Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF22D5FA666
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 22:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiJJUgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 16:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiJJUgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 16:36:22 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130044.outbound.protection.outlook.com [40.107.13.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A3846229
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 13:34:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEVOJctNNNV88P9AId0Y3vVVK/5XbpJiUuTNoyMKLnYIWyA5oNyZLAxdSSFDmecADJEbRaA//X7BPdtD7bDl8Xix/T1tJUDGxM5xkeNGMex8vi5SirqZnH8XhBIOmu5++LeGO6kO0DlLcYyu+Zk9J4D46laytOpAS8rHwjn41U5lQW7ttx1XlDWN4Y911wZuOO4ZMvxtyUKJ6Uoof531upGOowhiSnl/Ru8iuhTGxRL5J+PvI6JgZMwjdw92F6lo1Xo6vfvZqDUCBWpFbpzWuBULsy3bdoa2BAJvWnX6RZ6uKFHUI5k2fhvN8PGm80+vheXiuW/3fUOV2FINIleiYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fjm+o/ndx0eI6PafJEpx6Y1xOxgQGkAM/RSX42hmJL0=;
 b=STUX+FmlEDFSkxQ7kG4tPT4pGN8Ys4b/wDNoV6c4fX8mDvjwPwvarcyx70CpzgxCEZKo5KW7+hdEJnHgAA9h0Bdvrer1ULV2A8h1Zy8TzlQPhUqyBc96uTRqEJHyt+GOiD8WkfDBv/NYJXdEqPChiypknDWk4UbSv5qarZFptDNRxTElVF+bU9z3LuP5KiekuFd+B8B/vpZVjdVFWXae2s/hn9ZEH656Au/l1cHVJ7YrHxI7SRzE9Bn1T4/hJcLXw5W3Zxi5xv6v2ibknsKmfeWI6sBi2aSMHg/XW50j86yaiBZrQV5z/QqFVexvB0lqgEnWPES4G5I2oNlnNFerwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fjm+o/ndx0eI6PafJEpx6Y1xOxgQGkAM/RSX42hmJL0=;
 b=ZtI5HNIm0WIrv9/tUEOWO5XuWrwSfbkqL1eneNiXPpucbhU3Ugx3Z81i6Mg3qkZLEyJdKRaz6ehZm94YhUP8TXhMInXB7wKDOv8paB3FjgIQIzadgtehWuBiz3hnEGSn0pvqJHUC/Wp0Ww2Arr86CsY2BnQiVn992PvCTCqEagM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PA4PR04MB9567.eurprd04.prod.outlook.com (2603:10a6:102:26d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.40; Mon, 10 Oct
 2022 20:33:53 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 20:33:53 +0000
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
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 1/2] net: phylink: add mac_managed_pm in phylink_config structure
Date:   Mon, 10 Oct 2022 15:33:00 -0500
Message-Id: <20221010203301.132622-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221010203301.132622-1-shenwei.wang@nxp.com>
References: <20221010203301.132622-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::30) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PA4PR04MB9567:EE_
X-MS-Office365-Filtering-Correlation-Id: 46179efc-9e57-459c-c3e4-08daaafebeae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +fZ1UpmJtVuN5IsK4E58tbMqHwu2KKRwUujEjIIs65W/1q0OkDLecb3gby7k87jFgSDj7z1sSXOPis5lGEbjLMDzRU4UdaUNWnmwdNKfaV3RwOpQzc0QnYH97UQ6ECCL0bkvck8ijHynRafva7ewWAh1xJP+q4kJQ0mtsxlNFNeJ3+I/NsIaSYeWdfGwGHmNAPXgY8sU2kfmTXH0y2PtmwprIqC0P2IFrKQFFLiTRFr9lKm72xPwXLKzRuRToaYZtzH6VV7YYvx+2mNen6c/GVUDnYpsDRvsXhyhBnuCz3rAmuYV80NBE4iUs+EvD6BB1xU5T2Igg2JRffNVk2OJYzt6FZg/WA8dXUF/BLrTuclSRYZKi+JFJbON3y7C2zL5YqnxVSf4Fjsvx/tV+sX2C+ZF30P69Vo+tJS/VCvo2k5CcWbn1GdhBsLuz9XNdZyzqEVofF2R4d1epywMQrRwmt2T5WOXKg4PpuaIVWoq2qX8OaTahbKNSa0x/BANJTTMJTk/qKXryhzbnk39Hs2Scz6e4ZFFcaRSbiMnnW72MYJ3bmEbsuyBrpyXYD2iO2xHOUcAwRY1xb0Vd2wXruinf6Xhh0nzzzDtS4yZhTpSJWQiFXsxhnwgv2O8iIBjL+dtgApSf/+LngSHVrGxLukGRpOapF82GuDL7btwdootp95Qutb60MOFm8CIIN6ypPDfMis9MlmAS9J8dLKdOID2jPaqUBqNz/bq6Q9/9ywuh/8aDzJ4SiUWd94p7ErBVSKKDAp7xlUfjWXPzyuSW1WQMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(66476007)(83380400001)(4326008)(44832011)(38100700002)(38350700002)(2616005)(1076003)(7416002)(2906002)(5660300002)(86362001)(8936002)(6486002)(55236004)(52116002)(8676002)(316002)(26005)(6512007)(478600001)(6506007)(110136005)(54906003)(186003)(41300700001)(66946007)(6666004)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fhkTN57ZrJLYFnEwVbWn50hfsw/+fJGP//5qmpL6Cb09cn7WybgHnSs04Y0t?=
 =?us-ascii?Q?oPpDWCxM6XRZoM8s+jmSLvEIBqPihifVE6FXVI+T+OkcjsZI7jixtvuzKDgk?=
 =?us-ascii?Q?Lwn+eRKTgOoK6V8+YpfTePsDMYvhKQG6FCecZnV6hDBbRSj7nMQksMyAUDIf?=
 =?us-ascii?Q?txLvxgnqFTpfqWSXv75ha4wPJh6w2KCj5iywIYoxWPTVgBqLT2XJBtmAlikO?=
 =?us-ascii?Q?rBZUk7mmmL0Piloa8M6oUM2h7ldxud1m1pDpnpaphi8jFNVsSF+fzGFWjs/Z?=
 =?us-ascii?Q?6UeDcPUF1+vmwjJs/YYxsDdpWubMYem1lGh6owVBjlRdTwexXzrcmJB9m7Hc?=
 =?us-ascii?Q?Fy/q1Qaex8amLMM35uiynsWyXI70xGqYtCoBLmBhFEnX1n180ypUXgD5j6gs?=
 =?us-ascii?Q?NAXtjItGlODss4zbEn2lh2Hd25YKd0M8nGm/ePNqjjKEMcGwGhdirzMkdFHO?=
 =?us-ascii?Q?im1rdkgdJH3R2/dXkORwdob5xnNFFc/JTSSVxTRxtVKGIVXE/ATZHLOpxi1a?=
 =?us-ascii?Q?DQXfFQ85nPLGsbpAGxhrmh4Tnw0GvaAG38HiF1uj8jH24KPzr/svl/O+BS68?=
 =?us-ascii?Q?utC59Zv6lmBMP/KKIbo9omUE4VOR9U7g2Gw3DULtIxI6wvmh5xSuSjYg5YIv?=
 =?us-ascii?Q?uipuNVygPPUNHIzk4H9qmHWwhRvbqf/uqCcHPVHc1BkKEvdDzuZxvaeYoU7w?=
 =?us-ascii?Q?jD18NgwexEgi6J+cg/rT3MUESADV6tMCiQVOwPrNHViKj4bjw9ROZ82J59c4?=
 =?us-ascii?Q?QB0vcclJIyyt2JHxQIpcoV82P+l9VVpe/8WfrOpkmDSfrvpqRaP0B9gWFrLa?=
 =?us-ascii?Q?mlP/LNjJa4BdSWvxKQcnfuzFD0o5z7oK6Gedi7XIZpxkGAaAWMexupGO2KV3?=
 =?us-ascii?Q?EQHyp1M3XDHsDprfY70i/kaWDgCjclYhtbBYCxySUaq395fiz+B2NZvaQIcp?=
 =?us-ascii?Q?jP759uR2KddJpcjlpsd/pTdh0rEwyRQDkte+yE5gX7NpqKuanImGN5bZPTsk?=
 =?us-ascii?Q?krV/K6kqo0TijZt/Cw1RBXW/6RyLZ0VId1q3L+1pUrz87ZtXJAS5xFNNgzS7?=
 =?us-ascii?Q?kK0iXn2QihiTtX4atwSHtg4XixQTjaigfRzs5Bg3e/VED42gjQnkNLLqytu4?=
 =?us-ascii?Q?0iXMaCyP8PuwhTqY7c/FwnGeD9sFmeT5YHcVSTfN5yjfNEQi4tjZAqYkl6xc?=
 =?us-ascii?Q?3ChUoDumDkGfrdslKsIx5+9T34AvRoo611Hyl829zmSokmqXVTg9mEab2DjT?=
 =?us-ascii?Q?810Zzxeag9czwUULoVNThuW+y03u5BJVb5MXeSeYc8waN6yuSBig6z52epXn?=
 =?us-ascii?Q?zZljODw2oD6fiPUzupyofhCu6VHDgeJ9D98A6zQWKM463tR/1c3CfGBwM9G4?=
 =?us-ascii?Q?fjG00wmaiPREba/u2BUAzBE6DEP3ocjcL/9jvRDa6Gh6UygA1PhejbIuMDbS?=
 =?us-ascii?Q?bleEGtnaA465KmWv1TeC+A54KZSZi3bwy7hjyf/jV9GPACIR1F7gud6k8c38?=
 =?us-ascii?Q?oqctTFD2F6LygpYteiCyGgreAa1Zmajf+MQNBSJK+4j3m79at39geovd/9X/?=
 =?us-ascii?Q?I8AsU1lm7ubSvKhonWupqQNepft+EwH4kl2ufJzS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46179efc-9e57-459c-c3e4-08daaafebeae
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 20:33:53.2336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U9js8N6Z5HIEplBl43ip5GZ3omVJmfYvWTwaCfjJ25UszoAkn+jdA47ILNGaHmjVmu8FxT9g3UJj3kBO2jZJ0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9567
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

'commit 47ac7b2f6a1f ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state")'

requires the MAC driver explicitly tell the phy driver who is
managing the PM, otherwise you will see warning during resume
stage.

Add a boolean property in the phylink_config structure so that
the MAC driver can use it to tell the PHY driver if it wants to
manage the PM.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/phy/phylink.c | 4 ++++
 include/linux/phylink.h   | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e9d62f9598f9..6d64d4b6d606 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -74,6 +74,7 @@ struct phylink {
 
 	bool mac_link_dropped;
 	bool using_mac_select_pcs;
+	bool mac_managed_pm;
 
 	struct sfp_bus *sfp_bus;
 	bool sfp_may_have_phy;
@@ -1439,6 +1440,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	if (phy_interrupt_is_valid(phy))
 		phy_request_interrupt(phy);
 
+	if (pl->config->mac_managed_pm)
+		phy->mac_managed_pm = true;
+
 	return 0;
 }
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..a3adf7fe7eaf 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -88,6 +88,7 @@ enum phylink_op_type {
  *	(See commit 7cceb599d15d ("net: phylink: avoid mac_config calls")
  * @poll_fixed_state: if true, starts link_poll,
  *		      if MAC link is at %MLO_AN_FIXED mode.
+ * @mac_managed_pm: if true, indicate the MAC driver is responsible for PHY PM.
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
@@ -100,6 +101,7 @@ struct phylink_config {
 	enum phylink_op_type type;
 	bool legacy_pre_march2020;
 	bool poll_fixed_state;
+	bool mac_managed_pm;
 	bool ovr_an_inband;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
-- 
2.34.1

