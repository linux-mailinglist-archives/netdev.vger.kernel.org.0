Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403735F79D9
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 16:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJGOli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 10:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJGOlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 10:41:37 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60063.outbound.protection.outlook.com [40.107.6.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186C3FC1F1
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 07:41:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAG4LlWHuMIz8m5LZr2q3prcLdSDRbGDyf8/A5+O+EZtWYTQZ22050mm5i/gyLNfVTgDwuLeddP+pEVRALLc4Ig19r+vspj51+A6UdAQ3yueiujHB+FjmxRzQucQGUt4OfsEeeav7dfKVYv8UeO3tCxDuVFhX6YaD1niIenZrFiVjAcurmWaU8/uipB/cqq7+UanyObpjxncHBabz3J9cSFvAL/G3XeAf7Clbyxz0nK0B0LhU+lrWYauF9xixY15K+RY1obVDUKRuU8hstIvboRttUKlYiQYxE4FQqVIK+dvuHM/QswsDpKdoVQ1nFFsPS+kzGS4O6teo0kdz2nRag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L23oD6qzfHYHlp6AaNYOEaLwxuwGEGxU1gYNYV0aYyc=;
 b=kqloRCT9bRyAU0saupX/pt5GH/wbTVZIKVNr9+nuRTlEiqhGp7s+uN/6n2w0tfRqqorYw2pZjhhRgA+L6ziB7KKFogx73RMIV4pflrhPLx2rzSKCLHYwLnZJljVROKCh8NW4o3UJWWppCb6Zwztp1SFNkUSTsIxV29ZOmTUcJFnbe7iaemR1bwEporGSoJ9n6xFZXwtOqJLZeT4dY6ByeoTWqdvqTrY2HlDHTUA7rmv3vh9s9P74R04/6Yqlhstea2mlAp/s+UOuC6qE61EFXwj+6hU0U14hM/MAXCZLbWkcl7jdDTAty22uMqPJhrtrEJqcYbkQEpmj6necRl/Ddg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L23oD6qzfHYHlp6AaNYOEaLwxuwGEGxU1gYNYV0aYyc=;
 b=pn+YmD2OZJcMuPqjrCJH6Uhuilo3S4KUEn02Bm/prNyaVcYemjf/PqEqO6kcf8/udBmjrmdIWAPfcZ/nPARrvLNIMpYHB54eWfPoYlNPG6fDFQAOrIPa2TEJVJzCOW/Y1PtSfrSfb2dSW/zG6DImIzId0aIlObec411EvWhItjk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB8226.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Fri, 7 Oct
 2022 14:41:33 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5676.036; Fri, 7 Oct 2022
 14:41:33 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v2 1/1] net: phylink: add phylink_set_mac_pm() helper
Date:   Fri,  7 Oct 2022 09:41:11 -0500
Message-Id: <20221007144111.786748-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0071.namprd07.prod.outlook.com
 (2603:10b6:a03:60::48) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM9PR04MB8226:EE_
X-MS-Office365-Filtering-Correlation-Id: 15b6daae-e627-4f18-d109-08daa872070c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Pzy3fZPCCs3r+4fKRzbShYjJ4A237+pSG2W1+nrhObgFynZ2aPv2eexisUdj1yvY2sNw7CLKq86j4Fj0Hbh9CgrXuVJEhH38sF32tG8hvAJrlcTN6r1v0y0Q0a829ZCosMP5j1IGcRMZ5p5cG++vkiNzlyMQx/SPWLv+cJu2dGuF9gLg3ee3DsgPORMYTH7XMdUPTOH2xdCdpS3RhJ2iO4QmZM8L5sg9bw0KZvDMaFDrCdIyg6Ic4EvaZbTX9FlPv8/F4l9SInP9MtJoZMJqhKUsv7M/f6CrM5OGwDfbs+ebNHw86I/HM3/lzTTrZaBiqqub3r4sEdq4NEqY+Ge+ktfr4jan+Rz1z73B+JbZH4THWMM1sEQkvmPLILZGQ5YE7kVfh1QSGQ4LoErvJ9FXLgaVe9eJFOpxTyOhk1+5+vLmmUdG8WtKfaGKcl23oudV68nqkICAiPKQl0RqdcecQlWmMCHqqBT0FVM1to0aagxVfmy6XcmatKtRsb9LDcrxhHMqaRZeWZ4XxEjQzRBlR7GsMA65LIDuK7Q5kp0qa4i5Y7pZH0sxYx1o0OgI/avQiR8lXDoyknA9FFnda6vPrvEdocq+7kYB2wH/MZGkQysP9ClOIwFjInMCdnWVx7Mzo/q14Wm6z559a+7R/+ia1bxJuKX9TiS2YpMHTi9LKGxcc5nHbrZ2s+jNiTQcgxOGAMxwvQSPYR4UsYadUNxICeE97csfqt5K0y9V2c1AXrsS6pnxYF1Qulqn1CetSvZxIDnYyLKpHuIQRUdcUUpTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199015)(83380400001)(8676002)(1076003)(38350700002)(44832011)(38100700002)(5660300002)(2616005)(2906002)(6512007)(8936002)(86362001)(41300700001)(6486002)(6666004)(316002)(55236004)(66556008)(52116002)(110136005)(6506007)(4326008)(66476007)(66946007)(26005)(478600001)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mcVa4USfyq7LC2Ocp71kj1NFe0CfRdSCNARPtDqWsZpfpRMfRIND9Ex6Oyu0?=
 =?us-ascii?Q?rrm/6phUgz/FC7HQt1qMhBsjojOdLdM2eUxN+TBDjn9e+YWMU7xCYx07/6+W?=
 =?us-ascii?Q?UzSCLX8mHc6tSs3udKAAfHH/NHVzh1ySk6ccmrM+LZ5rqPOUkfePd/3buZ4O?=
 =?us-ascii?Q?n3iUKNls2QPDJxyltAP0x2IupbjzR0zasZC181cmD+SPzwKi3N9RZr5kAwQk?=
 =?us-ascii?Q?1QBo9f/mdEqnz7fHjr+AY12XsTRv+IofiHQNFWdbWEjEzTKdkzuQUsn62HCR?=
 =?us-ascii?Q?9bMruSvueOeDG3ztdi8SU1thNeKpJFgUiuIa3E0CPNpCppi7ruP3chGnYXuV?=
 =?us-ascii?Q?Smqi0281gB9MmsM1Bc+cB2z+J9xGOS6van0J8v1VgbqiNTIPZqJ8KJYwclmp?=
 =?us-ascii?Q?4/HWVxsi6414EPOV5YgavrpaY633ckFBahVIxbtMgcy/uRrGScLL3incNDet?=
 =?us-ascii?Q?XBP7WXrRUIHVjzuKorqAIxcZQgSuP89gjlViuK+rVySkRPBqratIkuUZbX1e?=
 =?us-ascii?Q?ChnLmBcAKZenaUCh0jsSh3pRXuYh/lWQhbUdzByyAfVVREQgFvRSs1ituP/f?=
 =?us-ascii?Q?2ZSpKpQJvsvEjd7x5dTneyDFRaobckgQ7+9MLNpxSkclYFH6aT5nd5bDcPUs?=
 =?us-ascii?Q?6QE3yU18PsOHfOGVCN5qTWIKamGEm0O0hcTlzjcfVfy1dziS/itll4g+Zp65?=
 =?us-ascii?Q?J/G/xGGX7a4IatzBQEKrIBN5JlcjBLLd9qFBpHACtaQ+b3017RDs7ShOiBuq?=
 =?us-ascii?Q?JKbJQLoq3NH8QDbWxfGeZHpbdp5el1vlkfTTu3vOglpPl3MPcEkgelWhmWrj?=
 =?us-ascii?Q?QkdE/F1Fx2ojB5gGMoz3B2biA7c6E6Y7LOXfrwIj9GrfiY2iY+GhbUzAB84k?=
 =?us-ascii?Q?sk+RmHA2hkLltaxzhkl3ymdNVLdqEN+n8BFJCIcBqZuAGq0zjFxIrWBGoOBb?=
 =?us-ascii?Q?a39y+d+u74XWdpo/xSFCiXMU5iRy69Uz52sZcUplciZguc9spRC6jh9anTWR?=
 =?us-ascii?Q?kWN/aEwVLdjqPdLUflPS9wyLtydeaIeuVTy1q2yAp8gPaq5DZEp0w1pKKzEB?=
 =?us-ascii?Q?txfZxXOm6FB83m1jdJsrmQmmYzF3QOmt03Rjc0fHB/Iz4j11O+pSmWiOV1lG?=
 =?us-ascii?Q?dH7+KCXd3ViTgoEjfGw82NkUzFVZuJQaKopsaab79/Z+SmJt5SPgypMan/s2?=
 =?us-ascii?Q?qDVy9Fx8isg6z21H6c8iKt39PQRUgznjb/MzSkgpuFLuR6ZfhpLzKQ2nmRYi?=
 =?us-ascii?Q?VRHS6TLYqNfySl9In61s/H8w6k4SwtLGkHm6IcoMlCfnt66B4Jo98eZ6tJTj?=
 =?us-ascii?Q?xQ8wqriDbGkOkSh3myDUdA9w0Vzs5I+cLavHrerGaz5GXUcwkcPkxed4qnz2?=
 =?us-ascii?Q?Ap5TtKW+ND8IuUd5sTdiQbIiMXKT4nWyny5xcCp+q0lgHxYN/bXnbGzTWYj0?=
 =?us-ascii?Q?j1rA39wq28vrAAtTuA7kCQsGYNyHW8Zm7ILsIu/8ISaYZ8JQ66KhRUNPyc1B?=
 =?us-ascii?Q?nt6wEFi9zR6V76DEs/Yess/Oz62diKw1QlIHkWlLgsKwZlsiqqCDH/CvAbFY?=
 =?us-ascii?Q?ZQ9SYgYZI9mjxj6w2d5jeRQegoTRC25GPXOQOwaw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b6daae-e627-4f18-d109-08daa872070c
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 14:41:33.4013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TphevZcJ3/rVpL4BZjsBe2SNaEg+oQ3VJseAQBMSyTrU+AKXLGvAF12SjDVV4yyxEzdp7Wl4Pv9Ka0vUpM1N1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8226
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

Add a helper to let the MAC driver has a way to tell the PHY
driver it will manage the PM.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 Changes in v2:
  - add the API description
  - remove the unneccesary ASSERT_RTNL();

 drivers/net/phy/phylink.c | 17 +++++++++++++++++
 include/linux/phylink.h   |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e9d62f9598f9..525cf07d5da6 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1722,6 +1722,23 @@ void phylink_stop(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_stop);

+/**
+ * phylink_set_mac_pm() - set phydev->mac_managed_pm to true
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Set the phydev->mac_managed_pm, which is under the phylink instance
+ * specified by @pl, to true. This is to indicate that the MAC driver is
+ * responsible for PHY PM.
+ *
+ * The function can be called in the net_device_ops ndo_open() method.
+ */
+void phylink_set_mac_pm(struct phylink *pl)
+{
+	if (pl->phydev)
+		pl->phydev->mac_managed_pm = true;
+}
+EXPORT_SYMBOL_GPL(phylink_set_mac_pm);
+
 /**
  * phylink_suspend() - handle a network device suspend event
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..cfcc680462b9 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -540,6 +540,7 @@ void phylink_mac_change(struct phylink *, bool up);

 void phylink_start(struct phylink *);
 void phylink_stop(struct phylink *);
+void phylink_set_mac_pm(struct phylink *pl);

 void phylink_suspend(struct phylink *pl, bool mac_wol);
 void phylink_resume(struct phylink *pl);
--
2.34.1

